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
  double _priority = 4.0;
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
        priority: _priority.toInt(),
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
      padding: const EdgeInsets.all(15.0),
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
              spacing: 24,
              children: [
                Text('New Task', style: CustomTextStyles.h2),
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
                Slider.adaptive(
                  value: _priority,
                  label: 'Priority',
                  max: 5,
                  min: 1,
                  divisions: 4,
                  onChanged: (double value) {
                    setState(() {
                      _priority = value;
                    });
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
                            OutlinedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: colorScheme.primary,
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
