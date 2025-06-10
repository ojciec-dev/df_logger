/// Copyright (c) 2025 Wojciech Plesiak

// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import '../core/core.dart';

const String defaultBufferName = 'dlog';

/// Number of logs to write to the file in a single batch.
const int _batchSize = 1000;

/// Writes logs to a file.
class DLogWritter {
  /// Buffers for logs that are not yet written to the file.
  static final Map<String, List<String>> _fileBuffers = {};
  static final Map<String, List<LogLine>> _screenBuffers = {};
  static final Map<String, Function(LogLine logLine)?> _bufferListeners = {};

  static final screenBufferStreamController = StreamController<LogLine>.broadcast();

  /// Configuration for the logger.
  final DLogConfig config;

  /// Files to which logs will be written.
  static final Map<String, File?> _logFiles = {};

  /// Completer for the ongoing write operation.
  static Completer<void>? _writingCompleter;

  const DLogWritter(this.config);

  List<LogLine> get defaultScreenBuffer => _screenBuffers[config.bufferName ?? defaultBufferName] ?? [];

  static List<LogLine> getScreenBuffer([String bufferName = defaultBufferName]) => _screenBuffers[bufferName] ?? [];

  void write(LogLine log) {
    _maybeWriteToFile(log.formattedMessage);
    _maybeWriteToScreenBuffer(log);

    // Call the listener if it is set
    _bufferListeners[config.bufferName ?? defaultBufferName]?.call(log);
    screenBufferStreamController.add(log);
  }

  void _maybeWriteToScreenBuffer(LogLine log) {
    if (!config.writeToScreenBuffer) {
      return;
    }

    final bufferName = config.bufferName ?? defaultBufferName;
    final screenBuffer = _screenBuffers.putIfAbsent(bufferName, () => <LogLine>[]);
    screenBuffer.add(log);

    // Remove oldest elements if buffer exceeds limit
    if (screenBuffer.length > config.screenBufferSize) {
      final minExcesiveElements = screenBuffer.length - config.screenBufferSize;
      final someExtra = config.screenBufferSize * config.screenBufferTrimFactor; // remove some % more elements
      screenBuffer.removeRange(0, minExcesiveElements + someExtra.toInt());
    }
  }

  void _maybeWriteToFile(String message) {
    if (!config.writeToFile) {
      return;
    }

    final bufferName = config.bufferName ?? defaultBufferName;
    final fileBuffer = _fileBuffers.putIfAbsent(bufferName, () => []);

    final logFile = _logFiles[bufferName];
    fileBuffer.add(message);

    if (fileBuffer.length >= config.fileBatchSize) {
      _writeBatchToFile(fileBuffer, logFile, config.fileBatchSize);
    }
  }

  // Write logs to the file in batches
  static Future<void> _writeBatchToFile(List<String> buffer, File? logFile, int batchSize) async {
    if (logFile == null) {
      print('Log file not set but config.writeToFile is true. Did you call `configureFileLogging`?');
      return;
    }

    if (_writingCompleter != null) {
      await _writingCompleter!.future;
      return;
    }

    _writingCompleter = Completer<void>();

    try {
      final linesToWrite = buffer.take(batchSize).toList();
      buffer.removeRange(0, linesToWrite.length);

      await logFile.writeAsString(
        '${linesToWrite.join('\n')}\n',
        mode: FileMode.append,
      );
    } catch (e) {
      print('Logger: Failed to write logs to file: $e');
    } finally {
      _writingCompleter!.complete();
      _writingCompleter = null;
    }
  }

  // Flush remaining logs to the file
  static Future<void> flush([int batchSize = _batchSize]) async {
    print('DLogWritter; flushing logs...');
    for (final bufferName in _fileBuffers.keys) {
      final fileBuffer = _fileBuffers[bufferName]!;
      final logFile = _logFiles[bufferName];
      while (fileBuffer.isNotEmpty && logFile != null) {
        await _writeBatchToFile(fileBuffer, logFile, batchSize);
      }
    }
  }

  static void setListener(void Function(LogLine)? listener, [String bufferName = defaultBufferName]) {
    _bufferListeners[bufferName] = listener;
  }

  /// Configure the logger to write logs to a file.
  /// Provide the directory path where the log file will be saved. If not provided, the external directory path will be used.
  /// Provide the application name to create a directory for the logs. If not provided, 'df_logger' will be used.
  /// Provide the file name for the log file. If not provided, 'dlog_$timestampInMs.log' will be used.
  static Future<void> configureFileLogging({String? directoryPath, String? appName, String? fileName, String? bufferName}) async {
    // get file path and create directory if not exists
    final filePath = await getLogFilePath(directoryPath: directoryPath, appName: appName, fileName: fileName);
    final buffer = bufferName ?? defaultBufferName;

    if (filePath == null) {
      print('File path is null. Logging to file fo buffer $buffer is disabled.');
      return;
    }

    _logFiles[buffer] = File(filePath);

    print('DLogWritter configured to write logs to file: $filePath');
  }

  static disableFileLogging([String bufferName = defaultBufferName]) {
    print('disableFileLogging for buffer: $bufferName');
    _logFiles.remove(bufferName);
  }

  static Future<String?> getLogFilePath({String? directoryPath, String? appName, String? fileName}) async {
    final directory = directoryPath ?? await getExternalDirectoryPath();
    if (directory == null) {
      print('File path not provided and failed to get external directory path. Logging to file is disabled.');
      return null;
    }

    final applicatioName = appName ?? 'df_logger';
    final fileDirectory = Directory('$directory/$applicatioName');

    if (!await fileDirectory.exists()) {
      await fileDirectory.create(recursive: true);
    }

    final int timestampInMs = DateTime.now().millisecondsSinceEpoch;
    final logFileName = fileName ?? 'dlog_$timestampInMs.log';
    final path = '${fileDirectory.path}/$logFileName';

    return path;
  }

  static void clear({
    bool clearFileBuffers = true,
    bool clearScreenBuffers = true,
  }) {
    if (clearFileBuffers) {
      for (final buffer in _fileBuffers.values) {
        buffer.clear();
      }
    }
    if (clearScreenBuffers) {
      for (final buffer in _screenBuffers.values) {
        buffer.clear();
      }
    }
  }

  static Future<String?> getExternalDirectoryPath() async {
    if (Platform.isAndroid) {
      // For Android: Access the external storage directory
      final directory = Directory('/sdcard/Documents');
      return directory.existsSync() ? directory.path : null;
    } else if (Platform.isIOS) {
      // For iOS: Use the Documents directory as an equivalent
      // final directory = Directory('${Directory.current.path}/Documents');
      // return directory.path;
      // TODO: remove it or find a way to get the external directory path on iOS
      return null;
    } else {
      // For unsupported platforms
      print('External directory is not supported on this platform.');
      return null;
    }
  }
}
