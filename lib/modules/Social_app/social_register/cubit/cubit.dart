import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_0/models/social_app/social_login_model.dart';
import 'package:flutter_0/modules/Social_app/social_register/cubit/status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SocialRegisterCubit extends Cubit<SocialRegisterStates> {
  SocialRegisterCubit() : super(SocialRegisterInitialState());
  static SocialRegisterCubit get(context) => BlocProvider.of(context);

  void userRegister({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) {
    emit(SocialRegisterLoadingState());
   FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value)async {
      print(value.user?.email);
      print(value.user?.uid);
      userCreate(
        phone: phone,
        email: email,
        uId: value.user?.uid,
        name: name,
      );
      // emit(SocialRegisterSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialRegisterErrorState(error));
    });
  }

  void userCreate({
    required String? email,
    required String? name,
    required String? phone,
    required String? uId,
  }) {
    SocialUserModel? model = SocialUserModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      bio: 'write your bio . . .',
      image:
          'https://img.freepik.com/free-photo/waist-up-portrait-handsome-serious-unshaven-male-keeps-hands-together-dressed-dark-blue-shirt-has-talk-with-interlocutor-stands-against-white-wall-self-confident-man-freelancer_273609-16320.jpg?w=740&t=st=1660154696~exp=1660155296~hmac=618871f6238f09e356b4ae9119d3eb4a2a75fb0303f654ef814a1fd283086a21',
      cover:
      ' https://img.freepik.com/free-vector/blue-futuristic-networking-technology_53876-97395.jpg?w=740&t=st=1660859146~exp=1660859746~hmac=9248c9215bad57f45a3fa67a15f5f43470a6fd32e488a380251b6b0c13eb3f86'   ,
      isEmailVerified: false,
    );
   FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value)async {
      emit(SocialCreateUserSuccessState());
    }).catchError((error) {
      emit(SocialCreateUserErrorState(error.toString()));
      print(error.toString());
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;
  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(SocialChangePasswordIconState());
  }
}
