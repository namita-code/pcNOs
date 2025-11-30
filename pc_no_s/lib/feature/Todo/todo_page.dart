import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../core/storage/shared_prefs.dart';
import '../todo/todo_repository.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  String? todoContent;
  bool loading = true;
  bool error = false;

  @override
  void initState() {
    super.initState();
    loadTodo();
  }

  Future<void> loadTodo() async {
    try {
      // 1. check cached todo first
      final cached = SharedPrefs.getTodo();
      if (cached != null && cached.isNotEmpty) {
        setState(() {
          todoContent = cached;
          loading = false;
        });
        return;
      }

      // 2. load symptoms data from prefs
      final data = SharedPrefs.getSymptomsData();
      if (data == null) {
        setState(() {
          loading = false;
          error = true;
        });
        return;
      }

      // 3. fetch fresh todo
      final repo = TodoRepository();
      final fresh = await repo.getTodoPlan(data);

      setState(() {
        todoContent = fresh;
        loading = false;
      });

      await SharedPrefs.saveTodo(fresh);

    } catch (e) {
      setState(() {
        loading = false;
        error = true;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your PCOS Action Plan"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              await SharedPrefs.clearTodo(); // Clear cache
              setState(() => loading = true);
              await loadTodo();              // Reload fresh
            },
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error || todoContent == null) {
      return const Center(
        child: Text("Unable to load your action plan. Please try again."),
      );
    }

    return Markdown(
      data: todoContent!,
      styleSheet: MarkdownStyleSheet(
        h1: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.purple),
        h2: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
        p: const TextStyle(fontSize: 16, height: 1.5),
        listBullet: const TextStyle(color: Colors.purple),
      ),
    );
  }
}
