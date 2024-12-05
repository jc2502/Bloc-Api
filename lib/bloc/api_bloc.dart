import 'package:flutter_bloc/flutter_bloc.dart';
import 'api_event.dart';
import 'api_state.dart';
import '../repository/api_repository.dart';

class ApiBloc extends Bloc<ApiEvent, ApiState> {
  final ApiRepository _repository = ApiRepository();

  ApiBloc() : super(ApiInitialState()) {
    on<FetchActionsEvent>((event, emit) async {
      emit(ApiLoadingState());
      try {
        final actions = await _repository.fetchActions();
        emit(ApiLoadedState(actions: actions));
      } catch (e) {
        emit(ApiErrorState(message: e.toString()));
      }
    });

    on<DeleteActionEvent>((event, emit) async {
      emit(ApiLoadingState());
      try {
        await _repository.deleteAction(event.id);
        final actions = await _repository.fetchActions();
        emit(ApiLoadedState(actions: actions));
      } catch (e) {
        emit(ApiErrorState(message: e.toString()));
      }
    });

    on<CreateActionEvent>((event, emit) async {
      emit(ApiLoadingState());
      try {
        await _repository.createAction(event.newAction);
        final actions = await _repository.fetchActions();
        emit(ApiLoadedState(actions: actions));
      } catch (e) {
        emit(ApiErrorState(message: e.toString()));
      }
    });

    on<EditActionEvent>((event, emit) async {
      emit(ApiLoadingState());
      try {
        await _repository.editAction(event.id, event.updatedAction);
        final actions = await _repository.fetchActions();
        emit(ApiLoadedState(actions: actions));
      } catch (e) {
        emit(ApiErrorState(message: e.toString()));
      }
    });
  }
}
