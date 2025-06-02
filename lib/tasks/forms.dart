import 'package:flutter/material.dart';
import 'package:todo/components/notifications.dart';
import 'package:todo/core/styles.dart';
import 'package:todo/tasks/services.dart';

class TaskCreationForm extends StatefulWidget {
  const TaskCreationForm({super.key, required this.onSuccess});
  final VoidCallback onSuccess;

  @override
  State<TaskCreationForm> createState() => _TaskCreationFormState();
}

class _TaskCreationFormState extends State<TaskCreationForm> {
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
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 16,
              children: [
                Text('New Task', style: CustomTextStyles.h2),
                SizedBox(height: 4),
                TextFormField(
                  controller: _detailController,
                  keyboardType: TextInputType.text,
                  style: CustomTextStyles.b2,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Detail',
                    errorText: _formErrors?['title']?.join(', '),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: colorScheme.primary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: colorScheme.inversePrimary),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
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
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: colorScheme.inversePrimary),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:
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
                                backgroundColor: colorScheme.tertiary,
                                foregroundColor: colorScheme.onTertiary,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
