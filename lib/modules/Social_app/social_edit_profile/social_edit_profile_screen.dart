import 'package:flutter/material.dart';
import 'package:flutter_0/layout/Social_app/cubit/cubit.dart';
import 'package:flutter_0/layout/Social_app/cubit/status.dart';
import 'package:flutter_0/modules/Social_app/social_login/social_login_screen.dart';
import 'package:flutter_0/shared/components/components.dart';
import 'package:flutter_0/shared/network/local/cache_helper.dart';
import 'package:flutter_0/shared/styles/icon_broken.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SocialEditProfileScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = SocialCubit.get(context).userModel!;
        nameController.text = userModel.name != null ? userModel.name! : '';
        bioController.text = userModel.bio != null ? userModel.bio! : '';
        phoneController.text = userModel.phone != null ? userModel.phone! : '';

        return Scaffold(
          appBar: myAppBar(
            title: 'Edit Profile',
            context: context,
            actions: [
              defaultTextButton(
                function: () {
                  if (SocialCubit.get(context).profileImage != null) {
                    SocialCubit.get(context).uploadProfileImage(
                        name: nameController.text,
                        phone: phoneController.text,
                        bio: bioController.text);
                  } else if (SocialCubit.get(context).coverImage != null) {
                    SocialCubit.get(context).uploadCoverImage(
                        name: nameController.text,
                        phone: phoneController.text,
                        bio: bioController.text);
                  } else if (SocialCubit.get(context).profileImage != null &&
                      SocialCubit.get(context).coverImage != null) {
                    SocialCubit.get(context).uploadProfileImage(
                        name: nameController.text,
                        phone: phoneController.text,
                        bio: bioController.text);
                    SocialCubit.get(context).uploadCoverImage(
                        name: nameController.text,
                        phone: phoneController.text,
                        bio: bioController.text);
                  } else {
                    SocialCubit.get(context).updateUser(
                        name: nameController.text,
                        phone: phoneController.text,
                        bio: bioController.text);
                  }
                },
                text: 'Update',
              ),
              SizedBox(
                width: 15,
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (state is SocialUserUpdateLoadingState)
                    LinearProgressIndicator(),
                  if (state is SocialUserUpdateLoadingState)
                    SizedBox(
                      height: 20,
                    ),
                  Container(
                    height: 200,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                height: 140.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    topRight: Radius.circular(4),
                                  ),
                                  image: DecorationImage(
                                    image:
                                        SocialCubit.get(context).coverImage ==
                                                null
                                            ? NetworkImage('${userModel.cover}')
                                            : FileImage(SocialCubit.get(context)
                                                .coverImage!) as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  SocialCubit.get(context).getCoverImage();
                                },
                                icon: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.grey.withOpacity(.6),
                                  child: Icon(
                                    IconBroken.Camera,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 64,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                radius: 60.0,
                                backgroundImage:
                                    SocialCubit.get(context).profileImage ==
                                            null
                                        ? NetworkImage('${userModel.image}')
                                        : FileImage(SocialCubit.get(context)
                                            .profileImage!) as ImageProvider,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                SocialCubit.get(context).getProfileImage();
                              },
                              icon: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.grey.withOpacity(.6),
                                child: Icon(
                                  IconBroken.Camera,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // زراير بتظهر عند تغيير الصور بس انا نقلت الفانكشن فوق عند الابديت
                  // if (SocialCubit.get(context).profileImage != null ||
                  //     SocialCubit.get(context).coverImage != null)
                  //   SizedBox(
                  //     height: 20,
                  //   ),
                  // if (SocialCubit.get(context).profileImage != null ||
                  //     SocialCubit.get(context).coverImage != null)
                  //   Row(
                  //     children: [
                  //       if (SocialCubit.get(context).profileImage != null)
                  //         Expanded(
                  //           child: Column(
                  //             children:[ defaultButton(
                  //               function: () {
                  //                 SocialCubit.get(context).uploadProfileImage(
                  //                     name: nameController.text,
                  //                     phone: phoneController.text,
                  //                     bio: bioController.text);
                  //               },
                  //               text: 'Upload Profile',
                  //               fontSize: 13,
                  //               horizontal: 22,
                  //             ),if(state is SocialUploadProfileImageLoadingState)
                  //               SizedBox(
                  //               height: 5,),
                  //   if(state is SocialUploadProfileImageLoadingState)
                  //               LinearProgressIndicator(),
                  //             ],
                  //           ),
                  //         ),
                  //       if (SocialCubit.get(context).coverImage != null)
                  //         Expanded(
                  //           child: Column(
                  //             children:[ defaultButton(
                  //               function: () {
                  //                 SocialCubit.get(context).uploadCoverImage(
                  //                     name: nameController.text,
                  //                     phone: phoneController.text,
                  //                     bio: bioController.text);
                  //               },
                  //               text: 'Upload Cover',
                  //               fontSize: 13,
                  //               horizontal: 22,
                  //             ),if(state is SocialUploadCoverImageLoadingState)
                  //             SizedBox(
                  //               height: 5,),
                  //               if(state is SocialUploadCoverImageLoadingState)
                  //               LinearProgressIndicator(),
                  //             ],
                  //           ),
                  //         ),
                  //     ],
                  //   ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: defaultFormField(
                      controller: nameController,
                      type: TextInputType.name,
                      onValidate: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Write Your Name';
                        }
                        return null;
                      },
                      label: 'Name',
                      prefix: IconBroken.User,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: defaultFormField(
                      controller: bioController,
                      type: TextInputType.text,
                      onValidate: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Write Your Bio ';
                        }
                        return null;
                      },
                      label: 'Bio',
                      prefix: IconBroken.Info_Circle,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: defaultFormField(
                      controller: phoneController,
                      type: TextInputType.phone,
                      onValidate: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Write Your Phone Number ';
                        }
                        return null;
                      },
                      label: 'Phone Number',
                      prefix: IconBroken.Call,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  defaultButton(
                    function: () {
                      CacheHelper.removeData(key:'uId',
                      ).then((value){
                        if(value){
                          navigateAndFinish(context,SocialLoginScreen());
                        }
                      });
                    },
                    text: 'logout',
                    background: Colors.red.shade300,
                    icon: IconBroken.Logout,
                      sizedBoxWidth: 15,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
