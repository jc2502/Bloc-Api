import 'package:equatable/equatable.dart';

abstract class ApiEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchActionsEvent extends ApiEvent {}

class DeleteActionEvent extends ApiEvent {
  final String id;

  DeleteActionEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateActionEvent extends ApiEvent {
  final Map<String, dynamic> newAction;

  CreateActionEvent(this.newAction);

  @override
  List<Object?> get props => [newAction];
}

class EditActionEvent extends ApiEvent {
  final String id;
  final Map<String, dynamic> updatedAction;

  EditActionEvent(this.id, this.updatedAction);

  @override
  List<Object?> get props => [id, updatedAction];
}
