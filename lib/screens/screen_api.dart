import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/api_bloc.dart';
import '../bloc/api_event.dart';
import '../bloc/api_state.dart';

class ScreenApi extends StatelessWidget {
  const ScreenApi({Key? key}) : super(key: key);

  void _showForm(BuildContext parentContext, {Map<String, dynamic>? action}) {
    final _nameController = TextEditingController(text: action?['name']);
    final _avatarController = TextEditingController(text: action?['avatar']);
    final _typeController = TextEditingController(text: action?['type']);
    final _abilityController = TextEditingController(text: action?['ability']);
    final _statusController = TextEditingController(
      text: action != null ? (action['status'] ? 'true' : 'false') : 'false',
    );
    final _deletedAtController = TextEditingController(
      text: action?['deleted_at']?.toString() ?? '',
    );

    final isEditing = action != null;

    showDialog(
      context: parentContext,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Edit Action' : 'Add Action'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _avatarController,
                  decoration: const InputDecoration(labelText: 'Avatar URL'),
                ),
                TextField(
                  controller: _typeController,
                  decoration: const InputDecoration(labelText: 'Type'),
                ),
                TextField(
                  controller: _abilityController,
                  decoration: const InputDecoration(labelText: 'Ability'),
                ),
                TextField(
                  controller: _statusController,
                  decoration: const InputDecoration(labelText: 'Status (true/false)'),
                ),
                TextField(
                  controller: _deletedAtController,
                  decoration: const InputDecoration(labelText: 'Deleted At (timestamp)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newAction = {
                  "name": _nameController.text,
                  "avatar": _avatarController.text,
                  "type": _typeController.text,
                  "ability": _abilityController.text,
                  "status": _statusController.text.toLowerCase() == 'true',
                  "deleted_at": int.tryParse(_deletedAtController.text) ?? 0,
                };

                if (isEditing) {
                  parentContext
                      .read<ApiBloc>()
                      .add(EditActionEvent(action!['id'], newAction));
                } else {
                  parentContext.read<ApiBloc>().add(CreateActionEvent(newAction));
                }

                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD con BLoC'),
      ),
      body: BlocBuilder<ApiBloc, ApiState>(
        builder: (context, state) {
          if (state is ApiLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ApiLoadedState) {
            final actions = state.actions;
            return ListView.builder(
              itemCount: actions.length,
              itemBuilder: (context, index) {
                final action = actions[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(action['avatar']),
                  ),
                  title: Text(action['name']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Type: ${action['type']}'),
                      Text('Ability: ${action['ability']}'),
                      Text('Status: ${action['status'] ? "Active" : "Inactive"}'),
                      Text('Deleted At: ${action['deleted_at']}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showForm(context, action: action),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          context.read<ApiBloc>().add(DeleteActionEvent(action['id']));
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is ApiErrorState) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text('No data available.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showForm(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
