import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodoItem extends ConsumerWidget {
  const TodoItem({super.key, required this.index, required this.item});
  final int index;
  final Map item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 5,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          child: Text('${index + 1}'),
        ),
        title: Text(
          item["title"],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        subtitle: Text('Description: ${item["description"]}'),
      ),
    );
  }
}
