import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pantalla_bloc_api/bloc/api_event.dart';
import 'bloc/api_bloc.dart';
import 'screens/screen_api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD con BLoC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (_) => ApiBloc()..add(FetchActionsEvent()),
        child: const ScreenApi(),
      ),
    );
  }
}
