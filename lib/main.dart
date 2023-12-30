import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todos_list/themes/theme_provider.dart';
import 'package:todos_list/themes/themes.dart';
import 'package:todos_list/utils/todo_system.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Todos todos = Todos();
  final TextEditingController searchController = TextEditingController();
  List<Todo> filteredTodos = [];

  @override
  void initState() {
    super.initState();
    _loadTodos();
    searchController.addListener(updateFilteredTodos);
  }

  Future<void> _loadTodos() async {
    await todos.loadTodosFromPrefs(); // Load todos from SharedPreferences
    setState(() {
      filteredTodos = todos.getTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Todos List",
      theme: Provider.of<ThemeProvider>(context).themeData,
      darkTheme: darkMode, // Add darkTheme for dark mode
      themeMode: Provider.of<ThemeProvider>(context).currentThemeMode,
      debugShowCheckedModeBanner: false,
      // color: Theme.of(context).colorScheme.secondary,
      home: Scaffold(
        appBar: appBarWidget(),
        drawer: appDrawer(context),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: _buildSearchTextField(),
            ),
            Expanded(
              child: Column(
                children: [
                  bodyTodosList(filteredTodos),
                  bottomInputBar(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget appDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.book,
                  size: 64,
                ),
                SizedBox(height: 8),
                Text(
                  "Todos List",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "@Kabir Jaipal",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget bottomInputBar(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Type Todo Here...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                prefixIcon: const Icon(Icons.assignment),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                if (controller.text.isNotEmpty) {
                  todos.addTask(controller.text);
                  updateFilteredTodos();
                  controller.clear();
                }
              });
            },
            child: Icon(
              Icons.add,
              size: 40,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget bodyTodosList(List<Todo> todosList) {
    return Expanded(
      child: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: InkWell(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    // Check Icon
                    IconButton(
                      icon: Icon(
                        todosList[index].isCompleted
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: Colors.deepPurpleAccent,
                      ),
                      onPressed: () {
                        setState(() {
                          final todo = todosList[index];
                          // todo.isCompleted = !todo.isCompleted;
                          todo.isCompleted
                              ? todos.incompleteTask(index)
                              : todos.completeTask(index);
                          updateFilteredTodos();
                        });
                      },
                    ),
                    // Todo Text
                    Expanded(
                      child: Text(
                        todosList[index].title,
                        style: TextStyle(
                          fontSize: 18,
                          decoration: todosList[index].isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ),
                    // Delete Icon
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        setState(() {
                          todos.removeTask(index);
                          updateFilteredTodos();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: 10),
        itemCount: todosList.length,
      ),
    );
  }

  AppBar appBarWidget() {
    final theme = Provider.of<ThemeProvider>(context).themeData;
    return AppBar(
      elevation: 0,
      title: const Text(
        "Todos",
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      leading: Builder(
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.only(left: 12),
            child: IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(
                Icons.menu,
                size: 40, // Adjust the size as needed
              ),
            ),
          );
        },
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: IconButton(
            onPressed: () {
              // Pass the context
              setState(() {
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme();
              });
            },
            icon: Icon(
              theme == darkMode ? Icons.sunny : Icons.nightlight,
              size: 35,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchTextField() {
    return TextField(
      controller: searchController,
      onChanged: (text) {
        updateFilteredTodos();
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              BorderSide(color: Theme.of(context).scaffoldBackgroundColor),
        ),
        hintText: "Search Todos Here...",
        hintStyle: const TextStyle(
          fontSize: 18,
        ),
        prefixIcon: const Icon(
          Icons.search,
          size: 28,
        ),
      ),
    );
  }

  void updateFilteredTodos() {
    final searchQuery = searchController.text.toLowerCase();
    setState(() {
      filteredTodos = todos.getTasks().where((todo) {
        return todo.title.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    });
  }
}
