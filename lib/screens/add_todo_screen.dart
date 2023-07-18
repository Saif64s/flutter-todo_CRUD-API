// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_api/consts/style_consts.dart';
import 'package:todo_api/services/api_calls.dart';

import '../consts/uri.dart';

class AddTodoPage extends ConsumerStatefulWidget {
  const AddTodoPage({super.key, this.todo});
  final Map? todo;

  @override
  ConsumerState<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends ConsumerState<AddTodoPage> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo["title"];
      final description = todo["description"];
      titleController.text = title;
      descController.text = description;
    }
  }

  Future<void> onUpdateTask() async {
    final todo = widget.todo;
    if (todo == null) {
      return;
    }

    final _id = todo["_id"];
    bool isSuccess = await ApiCalls.updateTask(_id, body);
    // Show if success or failed
    if (isSuccess) {
      titleController.text = '';
      descController.text = '';
      if (context.mounted) {
        showFeedback(context, 'Task updated', Colors.green);
        if (context.mounted) {
          Navigator.pop(context);
        }
      } else {
        showFeedback(context, 'Failed to update task', Colors.red);
      }
    }
  }

  Map get body {
    final title = titleController.text;
    final description = descController.text;
    return {"title": title, "description": description, "is_completed": false};
  }

  Future<void> onSubmitTask() async {
    bool isSuccess = await ApiCalls.createTask(body);

    // Show if success or failed
    if (isSuccess) {
      titleController.text = '';
      descController.text = '';
      if (context.mounted) {
        showFeedback(context, 'Task Added', Colors.green);
        if (context.mounted) {
          Navigator.pop(context);
        }
      } else {
        showFeedback(context, 'Failed to add task', Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'E D I T   T A S K' : 'A D D   T A S K',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: inputDecoration(
                "Task Name", const Icon(Icons.auto_awesome_mosaic_sharp)),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: descController,
            decoration: inputDecoration(
                "Task Description", const Icon(Icons.design_services_rounded)),
            minLines: 5,
            maxLines: 20,
            keyboardType: TextInputType.multiline,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: ElevatedButton(
              onPressed: isEdit ? onUpdateTask : onSubmitTask,
              style: ElevatedButton.styleFrom(
                enableFeedback: true,
                backgroundColor:
                    Theme.of(context).buttonTheme.colorScheme?.onPrimary,
                textStyle: Theme.of(context).textTheme.headlineSmall,
              ),
              child: Text(isEdit ? 'Update Task' : 'Add to Tasks'),
            ),
          ),
        ],
      ),
    );
  }
}
