import 'package:flutter_test/flutter_test.dart';
import 'package:df_logger/src/logger/dlog.dart';

void main() {
  group(
    'Tests for generating prefix',
    () {
      test(
        'Both tag or group are null',
        () async {
          // do
          String prefix = DLog.generatePrefix(null, null);
          // test
          expect(prefix, '');
        },
      );

      test(
        'Only tag not null',
        () async {
          // do
          String prefix = DLog.generatePrefix('tag', null);
          // test
          expect(prefix, 'tag');
        },
      );

      test(
        'Only group not null',
        () async {
          // do
          String prefix = DLog.generatePrefix(null, 'group');
          // test
          expect(prefix, '<group>');
        },
      );

      test(
        'Both tag and group not null',
        () async {
          // do
          String prefix = DLog.generatePrefix('tag', 'group');
          // test
          expect(prefix, 'tag<group>');
        },
      );
    },
  );

  group(
    'Tests for apply method',
    () {
      test(
        'Changing enabled and minLoggingLevel properties',
        () async {
          // when
          final log = DLog('tag');
          expect(log.enabled, true);
          expect(log.minLoggingLevel, Level.verbose);
          // do
          log.apply(
            minLoggingLevel: Level.warning,
            enabled: false,
          );
          // test
          expect(log.enabled, false);
          expect(log.minLoggingLevel, Level.warning);
        },
      );

      test(
        'Changing enabled and minLoggingLevel properties',
        () async {
          // when
          final log = DLog('tag');
          // do
          bool customLoggerTriggered = false;
          log.apply(
            logger: (msg) => customLoggerTriggered = true,
          );
          // test
          log.debug('test message');
          expect(customLoggerTriggered, true);
        },
      );
    },
  );

  group(
    'Tests for logger itself',
    () {
      test(
        'Attempting to print below min logging level',
        () async {
          // do
          bool customLoggerTriggered = false;
          final log = DLog(
            'tag',
            minLogLevel: Level.debug,
            logger: (msg) {
              customLoggerTriggered = true;
            },
          );
          // test
          log.verbose('below min logging level');
          expect(customLoggerTriggered, false);
        },
      );

      test(
        'Attempting to print at min logging level',
        () async {
          // do
          bool customLoggerTriggered = false;
          final log = DLog(
            'tag',
            logger: (msg) {
              customLoggerTriggered = true;
            },
          );
          // test
          log.debug('at min logging level');
          expect(customLoggerTriggered, true);
        },
      );
    },
  );
}
