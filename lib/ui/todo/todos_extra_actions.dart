import 'package:flutter/material.dart';
import 'package:todo/services/firestore_database.dart';
import 'package:provider/provider.dart';

enum TodosActions { toggleAllComplete, clearCompleted }

class TodosExtraActions extends StatelessWidget {
  const TodosExtraActions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirestoreDatabase firestoreDatabase = Provider.of(context);

    return PopupMenuButton<TodosActions>(
      icon: const Icon(Icons.more_horiz),
      onSelected: (TodosActions result) {
        switch (result) {
          case TodosActions.toggleAllComplete:
            firestoreDatabase.setAllTodoComplete();
            break;
          case TodosActions.clearCompleted:
            firestoreDatabase.deleteAllTodoWithComplete();
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<TodosActions>>[
        PopupMenuItem<TodosActions>(
          value: TodosActions.toggleAllComplete,
          child: Text("todosPopUpToggleAllComplete"),
        ),
        PopupMenuItem<TodosActions>(
          value: TodosActions.clearCompleted,
          child: Text("todosPopUpToggleClearCompleted"),
        ),
      ],
    );
  }
}