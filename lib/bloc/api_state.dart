import 'package:equatable/equatable.dart';

abstract class ApiState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ApiInitialState extends ApiState {}

class ApiLoadingState extends ApiState {}

class ApiLoadedState extends ApiState {
  final List<dynamic> actions;

  ApiLoadedState({required this.actions});

  @override
  List<Object?> get props => [actions];
}

class ApiErrorState extends ApiState {
  final String message;

  ApiErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
