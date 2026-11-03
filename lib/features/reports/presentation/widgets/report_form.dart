import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:b_risk/core/theme/risk_colors.dart';
import 'package:b_risk/features/auth/presentation/providers/auth_providers.dart';
import 'package:b_risk/features/map/presentation/providers/map_providers.dart';
import 'package:b_risk/features/reports/presentation/providers/report_providers.dart';

/// Bottom-sheet form for a new flood or heat report.
class ReportForm extends ConsumerStatefulWidget {
  const ReportForm({super.key});

  static const maxDetails = 1000;

  @override
  ConsumerState<ReportForm> createState() => _ReportFormState();
}

class _ReportFormState extends ConsumerState<ReportForm> {
  final _formKey = GlobalKey<FormState>();
  final _details = TextEditingController();
  String _type = 'flood';
  String? _barangay;
  bool _busy = false;

  @override
  void dispose() {
    _details.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final user = ref.read(currentUserProvider).value;
    if (user == null) return;
    setState(() => _busy = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(reportRepositoryProvider).submit(
            reporter: user,
            type: _type,
            barangayName: _barangay!,
            details: _details.text.trim(),
          );
      if (mounted) Navigator.pop(context);
      messenger.showSnackBar(const SnackBar(content: Text('Report sent to the MDRRMO.')));
    } catch (_) {
      messenger.showSnackBar(const SnackBar(content: Text("Couldn't send the report. Try again.")));
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final barangays = ref.watch(barangaysProvider).value ?? const [];

    return Padding(
      // Lift the form above the keyboard
      padding: EdgeInsets.fromLTRB(24, 0, 24, 24 + MediaQuery.viewInsetsOf(context).bottom),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('New report', style: theme.textTheme.headlineSmall),
              const SizedBox(height: 20),
              SegmentedButton<String>(
                segments: [
                  for (final (type, label) in const [('flood', 'Flood'), ('heat', 'Extreme heat')])
                    ButtonSegment(
                      value: type,
                      label: Text(label),
                      icon: Icon(RiskColors.iconForHazard(type)),
                    ),
                ],
                selected: {_type},
                onSelectionChanged: (s) => setState(() => _type = s.first),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _barangay,
                decoration: const InputDecoration(labelText: 'Barangay', border: OutlineInputBorder()),
                items: [
                  for (final b in barangays) DropdownMenuItem(value: b.name, child: Text(b.name)),
                ],
                onChanged: (v) => setState(() => _barangay = v),
                validator: (v) => v == null ? 'Pick the barangay' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _details,
                decoration: const InputDecoration(
                  labelText: 'What is happening?',
                  hintText: 'e.g. Knee-deep water on the road near the chapel',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                minLines: 4,
                maxLines: 8,
                maxLength: ReportForm.maxDetails,
                textCapitalization: TextCapitalization.sentences,
                validator: (v) => (v ?? '').trim().isEmpty ? 'Describe what you see' : null,
              ),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: _busy ? null : _submit,
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
                icon: const Icon(Icons.send_rounded),
                label: const Text('Send report'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
