import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_clone/core/usecase/usecase.dart';
import 'package:instagram_clone/features/auth/domain/entities/user.dart';
import 'package:instagram_clone/features/auth/domain/usecases/get_current_user.dart';
import 'package:instagram_clone/features/auth/domain/usecases/login_user.dart';
import 'package:instagram_clone/features/auth/domain/usecases/signup_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'dart:async';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final SignupUser signupUser;
  final GetCurrentUser getCurrentUser;
  final supabase.SupabaseClient supabaseClient; // Needed for auth state changes
  StreamSubscription<supabase.AuthState>? _authStateSubscription;

  AuthBloc({
    required this.loginUser,
    required this.signupUser,
    required this.getCurrentUser,
    required this.supabaseClient,
  }) : super(AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthSignupRequested>(_onSignupRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<_AuthUserChanged>(_onAuthUserChanged); // Internal event for stream updates

    // Listen to Supabase auth state changes
    _authStateSubscription = supabaseClient.auth.onAuthStateChange.listen((data) {
       // Map Supabase AuthState to our User entity or null
       final supabase.User? supabaseUser = data.session?.user;
       User? appUser;
       if (supabaseUser != null) {
         // TODO: Ideally, fetch full profile details here if needed
         // For now, create a basic User object
         appUser = User(id: supabaseUser.id, email: supabaseUser.email!); 
       }
       add(_AuthUserChanged(appUser)); // Trigger internal event
    });

    // Initial check
    add(AuthCheckRequested());
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }

  Future<void> _onLoginRequested(AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await loginUser(LoginParams(email: event.email, password: event.password));
    result.fold(
      (failure) => emit(AuthFailure(failure.toString())), // Use failure.message or specific mapping
      (user) => emit(Authenticated(user)), // State might be handled by stream listener
    );
  }

  Future<void> _onSignupRequested(AuthSignupRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signupUser(SignupParams(email: event.email, password: event.password, username: event.username));
    result.fold(
      (failure) => emit(AuthFailure(failure.toString())), // Use failure.message or specific mapping
      (user) => emit(Authenticated(user)), // State might be handled by stream listener
    );
  }

  Future<void> _onLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await supabaseClient.auth.signOut();
      // State change will be handled by the stream listener -> _onAuthUserChanged
      // emit(Unauthenticated()); // Or emit directly if preferred
    } catch (e) {
      emit(AuthFailure('Logout failed: ${e.toString()}'));
    }
  }

  Future<void> _onAuthCheckRequested(AuthCheckRequested event, Emitter<AuthState> emit) async {
     // This might be redundant if the stream listener handles the initial state correctly
     // Kept for explicit initial check if needed
    emit(AuthLoading());
    final result = await getCurrentUser(NoParams());
    result.fold(
      (failure) => emit(Unauthenticated()), // Assume unauthenticated if error fetching
      (user) {
        if (user != null) {
          emit(Authenticated(user));
        } else {
          emit(Unauthenticated());
        }
      },
    );
  }

  void _onAuthUserChanged(_AuthUserChanged event, Emitter<AuthState> emit) {
    if (event.user != null) {
      emit(Authenticated(event.user!));
    } else {
      emit(Unauthenticated());
    }
  }
}

