import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/app.dart';
import 'package:instagram_clone/core/constants/supabase_constants.dart';
import 'package:instagram_clone/core/di/injection_container.dart' as di;
import 'package:instagram_clone/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConstants.supabaseUrl,
    anonKey: SupabaseConstants.supabaseAnonKey,
  );

  // Initialize Dependency Injection
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide the AuthBloc at the root of the application
    return BlocProvider<AuthBloc>(
      create: (_) =>
          di.sl<AuthBloc>()..add(AuthCheckRequested()), // Initial check
      child: AppView(), // Your main App view widget
    );
  }
}
