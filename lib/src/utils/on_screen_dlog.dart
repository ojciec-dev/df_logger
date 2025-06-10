/// Copyright (c) 2025 Wojciech Plesiak

import 'package:df_logger/df_logger.dart';
import 'package:flutter/material.dart';

/// Widget displaying list of latest logs on the screen. On-screen logs are cleared by long press. Double tap callback can be provided.
class OnScreenDLog extends StatelessWidget {
  /// Maximum number of lines to display.
  final int maxLines;

  /// Scroll controller for the list and scroll automatically to the bottom. If not provided logs will not scroll automatically.
  final ScrollController? scrollController;

  /// Text style for the logs.
  final TextStyle? textStyle;

  /// Double tap callback.
  final Function()? onDoubleTap;

  const OnScreenDLog({
    this.maxLines = 1000,
    this.textStyle = const TextStyle(),
    this.scrollController,
    this.onDoubleTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final list = DLogWritter.getScreenBuffer().reversed.take(maxLines).toList().reversed.toList();

    return StreamBuilder(
        stream: DLogWritter.screenBufferStreamController.stream,
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (data == null && list.isEmpty) {
            return const SizedBox();
          }
          if (data != null) {
            list.add(data);
          }
          if (list.length > maxLines) {
            list.removeAt(0);
          }

          Future.delayed(const Duration(milliseconds: 100), () {
            scrollController?.animateTo(
              scrollController!.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          });
          return GestureDetector(
            onDoubleTap: onDoubleTap,
            onLongPress: () {
              list.clear();
              DLogWritter.screenBufferStreamController.sink.add(LogLine(Level.trace, '- cleared -\n\n'));
            },
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              controller: scrollController,
              itemCount: list.length,
              itemBuilder: (context, index) {
                final line = list[index];
                return Text(
                  line.copyWith(logFormat: LogFormat.noDateTime()).formattedMessage,
                  style: textStyle?.copyWith(
                    color: Color(DLogDefaults.colorFor(line.level).value),
                  ),
                );
              },
            ),
          );
        });
  }
}
