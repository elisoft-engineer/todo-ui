import 'package:flutter/material.dart';
import 'package:todo/components/notifications.dart';
import 'package:todo/core/styles.dart';
import 'package:todo/tasks/services.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key, required this.onSuccess});
  final Function() onSuccess;

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _detailController = TextEditingController();
  final _priorityController = TextEditingController();
  Map<String, dynamic>? _formErrors;
  bool _isSubmitting = false;

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _formErrors = null;
    });

    try {
      final _ = await TaskService.createTask(
        detail: _detailController.text.trim(),
        priority: int.parse(_priorityController.text),
      );

      if (mounted) {
        widget.onSuccess();
        Navigator.of(context).pop();
        CustomNotifications.showSuccess(context, 'Task created successfully!');
      }
    } catch (e) {
      if (e is Map<String, dynamic>) {
        setState(() {
          _formErrors = e;
        });
      } else {
        if (mounted) {
          CustomNotifications.showError(context, e.toString());
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return AlertDialog(
      title: const Text('New Task'),
      titleTextStyle: CustomTextStyles.b1.copyWith(color: colorScheme.primary),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              TextFormField(
                controller: _detailController,
                keyboardType: TextInputType.text,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Detail',
                  errorText: _formErrors?['title']?.join(', '),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: colorScheme.inversePrimary),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Detail is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priorityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Priority',
                  errorText: _formErrors?['priority']?.join(', '),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: colorScheme.inversePrimary),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Priority is required';
                  }
                  try {
                    int parsedValue = int.parse(value);
                    if (parsedValue < 1 || parsedValue > 5) {
                      return 'Value must range from 1 to 5';
                    }
                    return null;
                  } catch (_) {
                    return 'Value must be an integer';
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions:
          _isSubmitting
              ? [
                const SizedBox(
                  width: 35,
                  height: 35,
                  child: CircularProgressIndicator(),
                ),
              ]
              : [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.secondary,
                    foregroundColor: colorScheme.onSecondary,
                  ),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                  child: const Text('Submit'),
                ),
              ],
      actionsAlignment: MainAxisAlignment.spaceBetween,
    );
  }
}
