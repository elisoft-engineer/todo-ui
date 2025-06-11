import 'package:flutter/material.dart';
import 'package:todo/components/notifications.dart';
import 'package:todo/core/notifiers.dart';
import 'package:todo/core/styles.dart';
import 'package:todo/tasks/models.dart';
import 'package:todo/tasks/services.dart';

class TaskCreationForm extends StatefulWidget {
  const TaskCreationForm({super.key});

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
        Navigator.of(context).pop();
        CustomNotifications.showSuccess(context, 'Task created successfully!');
        tasksFutureNotifier.value = TaskService.fetchTasks(status: "todo");
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
              children: [
                Text('New Task', style: CustomTextStyles.h2),
                SizedBox(height: 24),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: TextFormField(
                    controller: _detailController,
                    keyboardType: TextInputType.text,
                    style: CustomTextStyles.b2,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Detail',
                      errorText: _formErrors?['detail']?.join(', '),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: colorScheme.primary,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: colorScheme.inversePrimary,
                        ),
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
                ),
                SizedBox(height: 24),
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
                SizedBox(height: 24),
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

class TaskEditForm extends StatefulWidget {
  const TaskEditForm({super.key, required this.task});
  final Task task;

  @override
  State<TaskEditForm> createState() => _TaskEditFormState();
}

class _TaskEditFormState extends State<TaskEditForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _detailController = TextEditingController();
  late double _priority;
  Map<String, dynamic>? _formErrors;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _detailController = TextEditingController(text: widget.task.detail);
    _priority = widget.task.priority.toDouble();
  }

  @override
  void dispose() {
    _detailController.dispose();
    super.dispose();
  }

  Future<void> updateTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _formErrors = null;
    });

    try {
      final _ = await TaskService.updateTask(
        id: widget.task.id,
        detail: _detailController.text.trim(),
        priority: _priority.toInt(),
      );

      if (mounted) {
        Navigator.of(context).pop();
        CustomNotifications.showSuccess(
          context,
          'Task has been updated successfully!',
        );
        tasksFutureNotifier.value = TaskService.fetchTasks(
          status: widget.task.status,
        );
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
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> deleteTask() async {
    setState(() {
      _isLoading = true;
      _formErrors = null;
    });

    try {
      final _ = await TaskService.deleteTask(id: widget.task.id);

      if (mounted) {
        Navigator.of(context).pop();
        CustomNotifications.showSuccess(context, 'Task has been deleted');
        tasksFutureNotifier.value = TaskService.fetchTasks(
          status: widget.task.status,
        );
      }
    } catch (e) {
      if (mounted) {
        CustomNotifications.showError(context, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> patchTask() async {
    setState(() {
      _isLoading = true;
      _formErrors = null;
    });

    try {
      final _ = await TaskService.patchTask(id: widget.task.id);

      if (mounted) {
        Navigator.of(context).pop();
        CustomNotifications.showSuccess(context, 'Task has been held');
        tasksFutureNotifier.value = TaskService.fetchTasks(
          status: widget.task.status,
        );
      }
    } catch (e) {
      if (mounted) {
        CustomNotifications.showError(context, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> holdTask() async {
    setState(() {
      _isLoading = true;
      _formErrors = null;
    });

    try {
      final _ = await TaskService.holdTask(id: widget.task.id);

      if (mounted) {
        Navigator.of(context).pop();
        CustomNotifications.showSuccess(
          context,
          'Task has been pushed forward',
        );
        tasksFutureNotifier.value = TaskService.fetchTasks(
          status: widget.task.status,
        );
      }
    } catch (e) {
      if (mounted) {
        CustomNotifications.showError(context, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Edit task', style: CustomTextStyles.h2),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.close),
          ),
        ],
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: TextFormField(
                controller: _detailController,
                keyboardType: TextInputType.text,
                style: CustomTextStyles.b2,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Detail',
                  errorText: _formErrors?['detail']?.join(', '),
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
            ),
            SizedBox(height: 20),
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
          ],
        ),
      ),
      actions: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment:
                _isLoading
                    ? MainAxisAlignment.spaceAround
                    : MainAxisAlignment.spaceBetween,
            children:
                _isLoading
                    ? [
                      const SizedBox(
                        width: 35,
                        height: 35,
                        child: CircularProgressIndicator(),
                      ),
                    ]
                    : [
                      IconButton(
                        onPressed: updateTask,
                        icon: Icon(Icons.edit, color: colorScheme.primary),
                        style: IconButton.styleFrom(
                          backgroundColor: colorScheme.inversePrimary,
                        ),
                      ),
                      IconButton(
                        onPressed: deleteTask,
                        icon: Icon(Icons.delete, color: colorScheme.error),
                        style: IconButton.styleFrom(
                          backgroundColor: Color.fromARGB(87, 235, 71, 42),
                        ),
                      ),
                      IconButton(
                        onPressed: holdTask,
                        icon: Icon(
                          Icons.pause_circle_filled_outlined,
                          color: const Color.fromARGB(255, 82, 117, 126),
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: Color.fromARGB(90, 94, 122, 129),
                        ),
                      ),
                      IconButton(
                        onPressed: patchTask,
                        icon: Icon(
                          Icons.keyboard_double_arrow_right_outlined,
                          color:
                              colorScheme.brightness == Brightness.light
                                  ? Color.fromARGB(255, 9, 102, 6)
                                  : Color.fromARGB(255, 130, 209, 127),
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: Color.fromARGB(74, 58, 226, 17),
                        ),
                      ),
                    ],
          ),
        ),
      ],
    );
  }
}
