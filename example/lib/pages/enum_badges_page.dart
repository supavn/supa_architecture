import 'package:flutter/material.dart';
import 'package:supa_architecture/models/models.dart';
import 'package:supa_architecture/theme/supa_extended_color_theme.dart';
import 'package:supa_architecture/widgets/widgets.dart';

class EnumBadgesPage extends StatelessWidget {
  const EnumBadgesPage({super.key});

  static const List<String> _tokenKeys = <String>[
    'default',
    'warning',
    'information',
    'success',
    'error',
    'blue',
    'cyan',
    'geekblue',
    'gold',
    'green',
    'lime',
    'magenta',
    'orange',
    'purple',
    'red',
    'volcano',
  ];

  @override
  Widget build(BuildContext context) {
    final extended = Theme.of(context).extension<SupaExtendedColorScheme>();

    return Scaffold(
      appBar: AppBar(
        leading: const GoBackButton(),
        title: const Text('Enum Badges Demo'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _tokenKeys.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index == 0) {
            // Hex example row
            final enumModelHex = EnumModel()
              ..name.rawValue = 'Hex (#RRGGBB)'
              ..color.rawValue = '#0000FF' // blue text
              ..backgroundColor.rawValue = '#E0FFE0'; // light green bg

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hex examples',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                const Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    // Direct TextStatusBadge with hex keys
                    TextStatusBadge(
                      status: 'Hex tokens',
                      textColorKey: '#0000FF',
                      backgroundColorKey: '#E0FFE0',
                      borderColorKey: '#00AA00',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'EnumStatusBadge hex',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    EnumStatusBadge(status: enumModelHex),
                  ],
                ),
              ],
            );
          }

          final key = _tokenKeys[index - 1];
          final enumModel = EnumModel()
            ..name.rawValue = key
            ..color.rawValue = key; // legacy path still supported

          final token = extended?.getTokenGroup(key);

          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: token?.background ?? Colors.transparent,
              border: Border.all(color: token?.border ?? Colors.transparent),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  key,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: token?.text ?? Colors.black,
                      ),
                ),
                EnumStatusBadge(status: enumModel),
              ],
            ),
          );
        },
      ),
    );
  }
}
