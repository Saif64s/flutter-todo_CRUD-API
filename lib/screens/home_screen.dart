// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_api/services/api_calls.dart';
import 'package:todo_api/widgets/laoding.dart';
import 'package:todo_api/widgets/todo_item.dart';

import '../providers/theme_provider.dart';
import 'add_todo_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List items = [];
  bool isLoading = true;
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    getAllTask();
  }

  Future<void> navigateToAddPage() async {
    final route =
        MaterialPageRoute(builder: ((context) => const AddTodoPage()));
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    getAllTask();
  }

  Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
        builder: ((context) => AddTodoPage(
              todo: item,
            )));
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    getAllTask();
  }

  Future<void> getAllTask() async {
    final response = await ApiCalls.getTask();
    if (response != null) {
      setState(() {
        items = response;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteTask(String id) async {
    bool isSuccess = await ApiCalls.deleteTaskbyId(id);
    if (isSuccess) {
      final deletedItem =
          items.where((element) => element["_id"] != id).toList();
      setState(() {
        items = deletedItem;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        actions: [
          Consumer(builder: (context, ref, child) {
            final theme = ref.watch(themeModeProvider);
            return IconButton(
                onPressed: () {
                  ref.read(themeModeProvider.notifier).state =
                      theme == ThemeMode.light
                          ? ThemeMode.dark
                          : ThemeMode.light;
                },
                icon: Icon(theme == ThemeMode.dark
                    ? Icons.light_mode
                    : Icons.dark_mode));
          })
        ],
        title: Text(
          'T A S K S',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: Visibility(
        visible: isLoading,
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return const LoadingOnRefresh(
              isLoading: true,
            );
          },
        ),
        replacement: RefreshIndicator(
          onRefresh: getAllTask,
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              Map item = items[index];
              final id = item["_id"];
              return Dismissible(
                background: Container(
                  child: const Align(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.delete_forever)),
                  color: Colors.red,
                ),
                direction: DismissDirection.endToStart,
                key: ValueKey(item),
                onDismissed: (direction) {
                  deleteTask(id);
                },
                child: InkWell(
                  onTap: () => navigateToEditPage(item),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TodoItem(
                      index: index,
                      item: item,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddPage,
        child: const Icon(
          Icons.add_circle,
        ),
      ),
    );
  }
}
