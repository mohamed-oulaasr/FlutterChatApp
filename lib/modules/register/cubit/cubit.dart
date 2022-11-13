// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_app/models/user_model.dart';
import 'package:flutter_social_app/modules/register/cubit/states.dart';


class RegisterCubit extends Cubit<RegisterStates>
{
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit? get(context) => BlocProvider.of(context);

  void userRegister({
    required String name,
    required String email,
    required String phone,
    required String password,
  })
  {
    emit(RegisterLoadingState());

    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
    )
    .then((value)
    {
      //print('Register your email : ${value.user!.email} - your uid : ${value.user!.uid}');

      createUser(
        uId: value.user!.uid.toString(),
        name: name,
        email: email,
        phone: phone,
      );

      //emit(RegisterSuccessState());
    })
    .catchError((error)
    {
      emit(RegisterErrorState(error.toString()));
    });
  }

  void createUser({
    required String uId,
    required String name,
    required String email,
    required String phone,
  })
  {
    UserModel userModel = UserModel(
      uId: uId,
      name: name,
      email: email,
      phone: phone,
      bio: 'write you bio ...',
      image: 'https://img.freepik.com/psd-gratuit/portrait-avatar-dessin-anime-3d-jeune-homme-affaires_627936-22.jpg',
      cover: 'https://img.freepik.com/psd-gratuit/portrait-avatar-dessin-anime-3d-jeune-homme-affaires_627936-22.jpg',
      isEmailVerified: false,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(userModel.toMap())
        .then((value)
        {
          emit(CreateUserSuccessState(uId));
        })
        .catchError((error)
        {
          print(error.toString());
          emit(CreateUserErrorState(error.toString()));
        });
  }

  IconData suffix = Icons.visibility_off_outlined;
  bool isPassword = true;

  void registerChangePasswordVisibility()
  {
    isPassword = !isPassword;

    suffix = isPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined;

    //emit(RegisterChangePasswordVisibilityState());
  }

}