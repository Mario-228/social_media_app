import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/social_register_cubit/register_states.dart';
import 'package:social_app/social_models/user_model.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(BuildContext context) => BlocProvider.of(context);

  bool isShawn = true;
  IconData passwordIcon = Icons.visibility_off;

  void changeVisibility() {
    isShawn = !isShawn;
    if (isShawn) {
      passwordIcon = Icons.visibility;
    } else {
      passwordIcon = Icons.visibility_off;
    }
    emit(RegisterChangeVisibility());
  }

  void userRegister(String name, String email, String password, String phone) {
    emit(RegisterUserLoadingState());

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      createUser(name, email, phone, value.user!.uid);
      // emit(RegisterUserSuccessfulState());
    }).catchError((error) {
      emit(RegisterUserFailedState(error.toString()));
    });
  }

  void createUser(String name, String email, String phone, String uId) {
    // emit(CreateUserLoadingState());
    UserModel model = UserModel(
        email: email,
        name: name,
        phone: phone,
        uId: uId,
        image:
            "https://img.freepik.com/free-vector/user-circles-set_78370-4704.jpg?t=st=1718975652~exp=1718979252~hmac=227dc6a3530055d62f25ec9061dcbe7605e6225743ef281b92a478eed7d5511e&w=740",
        cover:
            "https://img.freepik.com/free-vector/user-circles-set_78370-4704.jpg?t=st=1718975652~exp=1718979252~hmac=227dc6a3530055d62f25ec9061dcbe7605e6225743ef281b92a478eed7d5511e&w=740",
        bio:"Write Your Bio...",
        isEmailVerified: false);
    FirebaseFirestore.instance
        .collection("users")
        .doc(uId)
        .set(model.toJson())
        .then((value) {
      emit(CreateUserSuccessfulState(uId));
    }).catchError((error) {
      emit(CreateUserFailedState(error.toString()));
    });
  }
}
