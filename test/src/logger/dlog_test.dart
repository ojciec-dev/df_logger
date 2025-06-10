/// Copyright (c) 2022 Wojciech Plesiak

import 'package:df_logger/df_logger.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'Tests for generating prefix',
    () {
      test(
        'Both tag or group are null',
        () async {
          // do
          String prefix = LogLine.generatePrefix(null, null);
          // test
          expect(prefix, '');
        },
      );

      test(
        'Only tag not null',
        () async {
          // do
          String prefix = LogLine.generatePrefix('tag', null);
          // test
          expect(prefix, 'tag');
        },
      );

      test(
        'Only group not null',
        () async {
          // do
          String prefix = LogLine.generatePrefix(null, 'group');
          // test
          expect(prefix, '<group>');
        },
      );

      test(
        'Both tag and group not null',
        () async {
          // do
          String prefix = LogLine.generatePrefix('tag', 'group');
          // test
          expect(prefix, 'tag<group>');
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
            config: DLogConfig.defaultConfig.copyWith(
              minLoggingLevel: Level.debug,
              logger: (_, __) {
                customLoggerTriggered = true;
              },
            ),
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
            config: DLogConfig.defaultConfig.copyWith(
              logger: (_, __) {
                customLoggerTriggered = true;
              },
            ),
          );
          // test
          log.debug('at min logging level');
          expect(customLoggerTriggered, true);
        },
      );
    },
  );
}
