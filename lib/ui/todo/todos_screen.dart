import 'package:flutter/material.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/models/user_model.dart';
import 'package:todo/providers/auth_provider.dart';
import 'package:todo/routes/routes.dart';
import 'package:todo/services/firestore_database.dart';
import 'package:todo/ui/todo/empty_content.dart';
import 'package:todo/ui/todo/todos_extra_actions.dart';
import 'package:provider/provider.dart';

class TodosScreen extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TodosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final firestoreDatabase =
        Provider.of<FirestoreDatabase>(context, listen: false);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: StreamBuilder(
          stream: authProvider.user,
          builder: (context, snapshot) {
            final UserModel? user = snapshot.data as UserModel?;
            return Text(
             "${user?.email}",
            );
          },
        ),
        actions: <Widget>[
          StreamBuilder(
              stream: firestoreDatabase.todosStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<TodoModel> todos = snapshot.data as List<TodoModel>;
                  return Visibility(
                    visible: todos.isNotEmpty ? true : false,
                    child: const TodosExtraActions(),
                  );
                } else {
                  return const SizedBox(
                    width: 0,
                    height: 0,
                  );
                }
              }),
          IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.setting);
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(
            Routes.create_edit_todo,
          );
        },
      ),
      body: WillPopScope(
          onWillPop: () async => false, child: _buildBodySection(context)),
    );
  }

  Widget _buildBodySection(BuildContext context) {
    final firestoreDatabase =
        Provider.of<FirestoreDatabase>(context, listen: false);

    return StreamBuilder(
        stream: firestoreDatabase.todosStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<TodoModel> todos = snapshot.data as List<TodoModel>;
            if (todos.isNotEmpty) {
              return ListView.separated(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    background: Container(
                      child: Center(
                          child: Text(
                        "todosDismissibleMsgTxt",
                        style: TextStyle(color: Theme.of(context).canvasColor),
                      )),
                    ),
                    key: Key(todos[index].id),
                    onDismissed: (direction) {
                      firestoreDatabase.deleteTodo(todos[index]);

                      _scaffoldKey.currentState!.showSnackBar(SnackBar(
                        backgroundColor:
                            Theme.of(context).appBarTheme.backgroundColor,
                        content: Text(
                          "todosSnackBarContent" + todos[index].task,
                          style:
                              TextStyle(color: Theme.of(context).canvasColor),
                        ),
                        duration: const Duration(seconds: 3),
                        action: SnackBarAction(
                          label: "todosSnackBarActionLbl",
                          textColor: Theme.of(context).canvasColor,
                          onPressed: () {
                            firestoreDatabase.setTodo(todos[index]);
                          },
                        ),
                      ));
                    },
                    child: ListTile(
                      leading: Checkbox(
                          value: todos[index].complete,
                          onChanged: (value) {
                            TodoModel todo = TodoModel(
                                id: todos[index].id,
                                task: todos[index].task,
                                extraNote: todos[index].extraNote,
                                complete: value!);
                            firestoreDatabase.setTodo(todo);
                          }),
                      title: Text(todos[index].task),
                      onTap: () {
                        Navigator.of(context).pushNamed(Routes.create_edit_todo,
                            arguments: todos[index]);
                      },
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(height: 0.5);
                },
              );
            } else {
              return const EmptyContentWidget(
                title: "DefaultTxt",
                message: "DefaultMsgTxt",
                key: Key('EmptyContentWidget'),
              );
            }
          } else if (snapshot.hasError) {
            return const EmptyContentWidget(
              title: "No data..",
              message: "No data available",
              key: Key('EmptyContentWidget'),
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
