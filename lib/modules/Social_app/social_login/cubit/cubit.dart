

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_0/modules/Social_app/social_login/cubit/status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SocialLoginCubit extends Cubit<SocialLoginStates> {
  SocialLoginCubit() : super(SocialLoginInitialState());
  static SocialLoginCubit get(context) => BlocProvider.of(context);


  void userLogin( {
  required String email,
  required String password,
})
  {
    emit(SocialLoginLoadingState());
   FirebaseAuth.instance
        .signInWithEmailAndPassword(
        email: email,
        password: password,
    ).then((value)async{
      print(value.user?.email);
      print(value.user?.uid);
      emit(SocialLoginSuccessState(value.user?.uid));
    }).catchError((error){
      print(error.toString());
      emit(SocialLoginErrorState(error));
    });
  }

  IconData suffix=Icons.visibility_outlined;
  bool isPassword=true;
  void changePasswordVisibility(){
    isPassword=!isPassword;
    suffix=isPassword? Icons.visibility_outlined:Icons.visibility_off_outlined;
 emit(SocialChangePasswordVisibilityState());
  }
}
