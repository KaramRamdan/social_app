import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_0/layout/Social_app/cubit/status.dart';
import 'package:flutter_0/models/social_app/social_login_model.dart';
import 'package:flutter_0/models/social_app/social_message_model.dart';
import 'package:flutter_0/modules/Social_app/social_chats/social_chats_screen.dart';
import 'package:flutter_0/modules/Social_app/social_feeds/social_feeds_screen.dart';
import 'package:flutter_0/modules/Social_app/social_new_post/social_new_post_screen.dart';
import 'package:flutter_0/modules/Social_app/social_profile/social_profile_screen.dart';
import 'package:flutter_0/modules/Social_app/social_users/social_users_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/social_app/social_comment_model.dart';
import '../../../models/social_app/social_post_model.dart';
import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  SocialUserModel? userModel;

  void getUserData() {
    emit(SocialGetUserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      userModel = SocialUserModel.fromJson(value.data()!);
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetUserErrorState(error.toString()));
    });
  }

  int currentIndex = 0;
  List<Widget> screens = [
    SocialFeedsScreen(),
    SocialChatsScreen(),
    SocialNewPostScreen(),
    SocialUsersScreen(),
    SocialProfileScreen(),
  ];

  List<String> titles = [
    'Home',
    'Chats',
    'Post',
    'Users',
    'Profile',
  ];
  void changeBottomNav(int index) {
    if (index == 1) getAllUsers();
    if (index == 2) {
      emit(SocialNewPostState());
    } else {
      currentIndex = index;
      emit(SocialChangeBottomNavState());
    }
  }

  File? profileImage;
  final picker = ImagePicker();
  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(SocialProfileImagePickedSuccessState());
    } else {
      showToast(state: ToastStates.ERROR, text: 'No picked photo');
      emit(SocialProfileImagePickedErrorState());
      print('No image selected ');
    }
  }

  File? coverImage;
  Future<void> getCoverImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialCoverImagePickedSuccessState());
    } else {
      emit(SocialCoverImagePickedErrorState());
      showToast(state: ToastStates.ERROR, text: 'No picked photo');
      print('No image selected ');
    }
  }

  void uploadProfileImage({
    required String? name,
    required String? phone,
    required String? bio,
  }) {
    emit(SocialUploadProfileImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((imageUrl) {
        // emit(SocialUploadProfileImageSuccessState());
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          profileImage: imageUrl,
        );
        showToast(
            text: 'Successful Upload Profile Image',
            state: ToastStates.SUCCESS);
      }).catchError((error) {
        emit(SocialUploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadProfileImageErrorState());
    });
  }

  void uploadCoverImage({
    required String? name,
    required String? phone,
    required String? bio,
  }) {
    emit(SocialUploadCoverImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((imageUrl) {
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          coverImage: imageUrl,
        );
        // emit(SocialUploadCoverImageSuccessState());
        showToast(
            text: 'Successful Upload Cover Image', state: ToastStates.SUCCESS);
      }).catchError((error) {
        emit(SocialUploadCoverImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadCoverImageErrorState());
    });
  }

  void updateUser({
    required String? name,
    required String? phone,
    required String? bio,
    String? profileImage,
    String? coverImage,
  }) {
    emit(SocialUserUpdateLoadingState());
    SocialUserModel? model = SocialUserModel(
      name: name,
      phone: phone,
      bio: bio,
      email: userModel!.email,
      uId: userModel!.uId,
      image: profileImage ?? userModel!.image,
      cover: coverImage ?? userModel!.cover,
      isEmailVerified: false,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
      showToast(
          text: 'Successful Upload Your New Information',
          state: ToastStates.SUCCESS);
    }).catchError((error) {
      print(error.toString());
      emit(SocialUserUpdateErrorState());
    });
  }

  File? postImage;
  Future<void> getPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialPostImagePickedSuccessState());
    } else {
      emit(SocialPostImagePickedErrorState());
      showToast(state: ToastStates.ERROR, text: 'No picked photo');
      print('No image selected ');
    }
  }

  void removePostImage() {
    postImage = null;
    emit(SocialRemovePostImageState());
  }

  void uploadPostImage({
    required String? dateTime,
    required String? text,
  }) {
    emit(SocialCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((imageUrl) {
        createPost(
          dateTime: dateTime,
          text: text,
          postImage: imageUrl,
        );
      }).catchError((error) {
        emit(SocialCreatePostErrorState());
      });
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

  void createPost({
    required String? dateTime,
    required String? text,
    String? postImage,
  }) {
    emit(SocialCreatePostLoadingState());
    SocialPostModel? model = SocialPostModel(
      name: userModel!.name,
      uId: userModel!.uId,
      image: userModel!.image,
      dateTime: dateTime,
      text: text,
      postImage: postImage ?? '',
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
      emit(SocialCreatePostSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialCreatePostErrorState());
    });
  }

  List<SocialPostModel>? posts = [];
  List<String>? postsId = [];
  List<int>? likes = [];
  Map<String, int> likesNumber = {};
  Map<String, int> commentsNumber = {};
  void getPosts() {
    FirebaseFirestore.instance.collection('posts').orderBy('dateTime')
        .get()
    .asStream().listen((value) {  value.docs.forEach((element) {
      element.reference.collection('likes').get().then((likeValue) {
        likes!.add(likeValue.docs.length);
        postsId!.add(element.id);
        posts!.add(SocialPostModel.fromJson(element.data()));
      }).catchError((error) {
        emit(SocialGetPostErrorState(error.toString()));
        print(error.toString());
      });
    });
    emit(SocialGetPostSuccessState());});

  }

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uId)
        .set({
      'like': true,
    }).then((value) {
      emit(SocialLikePostSuccessState());
    }).catchError((error) {
      emit(SocialLikePostErrorState(error.toString()));
      print(error.toString());
    });
  }

  List<SocialUserModel>? allUsers = [];
  void getAllUsers() {
    if (allUsers!.length == 0) {
      FirebaseFirestore.instance.collection('posts').get().then((value) {
        value.docs.forEach((element) {
          if (element.data()['uId'] != userModel!.uId) {
            allUsers!.add(SocialUserModel.fromJson(element.data()));
          }
        });
        emit(SocialGetAllUsersSuccessState());
      }).catchError((error) {
        emit(SocialGetAllUsersErrorState(error.toString()));
        print(error.toString());
      });
    }
  }

  void sendMessage({
    required String? receiverId,
    required String? dateTime,
    required String? text,
  }) {
    SocialMessageModel messageModel = SocialMessageModel(
      text: text,
      senderId: userModel!.uId,
      receiverId: receiverId,
      dateTime: dateTime,
    );
    messages=[];
    //set my chat
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });
//set receiver chat
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });
  }

  List<SocialMessageModel> messages = [];
  void getMessages({
    required String? receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(SocialMessageModel.fromJson(element.data()));
      });
      emit(SocialGetMessageSuccessState());
    });
  }
  SocialCommentModel? commentModel;

  void writeComment({
    required String postId,
    required String dateTime,
    required String text,
  }) {
    commentModel = SocialCommentModel(
      name: userModel!.name,
      uId: userModel!.uId,
      image: userModel!.image,
      dateTime: dateTime,
      text: text,
    );

    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add(commentModel!.toMap())
        .then((value) {
      emit(WriteCommentSuccessState());
    }).catchError((error) {
      emit(WriteCommentErrorState());
    });
  }

  List<SocialCommentModel> comments = [];

  // List<int> commentsNumber = [];

  void getComments({
    required String postId,
  }) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      comments = [];
      event.docs.forEach((element) {
        comments.add(SocialCommentModel.fromJson(element.data()));
      });
      emit(GetCommentsSuccessState());
    });
  }
}
