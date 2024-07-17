import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_state.dart';

class SocialLoginCubit extends Cubit<SocialLoginStates> {
  SocialLoginCubit() : super(SocialInitialState());

  static SocialLoginCubit get(context) => BlocProvider.of(context);

  bool isShown = true;
  IconData passwordIcon = Icons.visibility_off;
  void changeVisibility() {
    isShown = !isShown;
    if (isShown) {
      passwordIcon = Icons.visibility_off;
    } else {
      passwordIcon = Icons.visibility;
    }
    emit(SocialChangePasswordState());
  }

  void login(String email, String password) {
    emit(LoginLoadingState());

    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      emit(LoginSuccessfulState(value.user!.uid));
    }).catchError((error, stackTrace){
      emit(LoginFailedState(error.toString()));
    });
  }
}
