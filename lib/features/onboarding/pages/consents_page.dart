import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class ConsentsPage extends HookConsumerWidget {
  final Map<String, String> consents;
  final void Function(Map<String, bool>) onContinue;

  const ConsentsPage({
    super.key,
    required this.consents,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consentStates = useState<Map<String, bool>>(
      {for (var id in consents.keys) id: false},
    );

    bool allChecked = consentStates.value.values.every((v) => v);

    return Scaffold(
      appBar: AppBar(title: const Text('Consents')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: consents.entries.map((entry) {
                  final id = entry.key;
                  final htmlDescription = entry.value;
                  return CheckboxListTile(
                    value: consentStates.value[id] ?? false,
                    onChanged: (checked) {
                      consentStates.value = {
                        ...consentStates.value,
                        id: checked ?? false,
                      };
                    },
                    title: Html(
                      data: htmlDescription,
                      onLinkTap: (url, _, __) async {
                        if (url != null) {
                          final uri = Uri.parse(url);
                          await launchUrl(uri);
                        }
                      },
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed:
                  allChecked ? () => onContinue(consentStates.value) : null,
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
