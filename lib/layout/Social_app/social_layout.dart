import 'package:flutter/material.dart';
import 'package:flutter_0/layout/Social_app/cubit/cubit.dart';
import 'package:flutter_0/layout/Social_app/cubit/status.dart';
import 'package:flutter_0/modules/Social_app/social_new_post/social_new_post_screen.dart';
import 'package:flutter_0/shared/components/components.dart';
import 'package:flutter_0/shared/styles/icon_broken.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SocialLayout extends StatelessWidget {
  const SocialLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getUserData();
        return BlocConsumer<SocialCubit,SocialStates>(
          listener: (context,state){
            if(state is SocialNewPostState){
              navigateTo(context, SocialNewPostScreen());
            }
          },
          builder: (context,state){
            var cubit =SocialCubit.get(context);
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  cubit.titles[cubit.currentIndex],
                ),
                actions: [
                  IconButton(
                      onPressed: (){},
                      icon: Icon(
                        IconBroken.Notification,
                      ),
                  ),
                  IconButton(
                      onPressed: (){},
                      icon: Icon(
                        IconBroken.Search,
                      ),
                  ),
                ],
              ),
              body: cubit.screens[cubit.currentIndex] ,
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: cubit.currentIndex,
                onTap: (index){
                cubit.changeBottomNav(index);
                },
                items: [
                  BottomNavigationBarItem(
                      icon:Icon(
                        IconBroken.Home,
                      ),
                    label: 'Home'
                  ),
                  BottomNavigationBarItem(
                      icon:Icon(
                        IconBroken.Chat,
                      ),
                      label: 'Chats'
                  ),
                  BottomNavigationBarItem(
                      icon:Icon(
                        IconBroken.Paper_Upload,
                      ),
                      label: 'Post'
                  ),
                  BottomNavigationBarItem(
                      icon:Icon(
                        IconBroken.User,
                      ),
                    label: 'Users'
                  ),
                  BottomNavigationBarItem(
                      icon:Icon(
                        IconBroken.Profile,
                      ),
                    label: 'Profile'
                  ),
                ],

              ),

//دى بتاعت الفارتيكشن بس عشان الفاير بيز بيتاخر لاغينها
              // ConditionalBuilder(
              //   condition: SocialCubit.get(context).model !=null,
              //   builder: (context) {
              //    var model =FirebaseAuth.instance.currentUser!.emailVerified;
              //     return Column(
              //       children: [
              //         if(!model)
              //         Container(
              //           color: Colors.amber.withOpacity(.6) ,
              //           child: Padding(
              //             padding: const EdgeInsets.symmetric(horizontal:20,),
              //             child: Row(
              //               children: [
              //                 Icon(Icons.info_outline),
              //                 SizedBox(width: 15,),
              //                 Expanded(
              //                   child: Text(
              //                     'Please Verify Your Email ',
              //                   ),
              //                 ),
              //                 SizedBox(width: 15,),
              //                 defaultTextButton(
              //                     text: 'Send',
              //                     function: () {
              //                       FirebaseAuth.instance.currentUser
              //                           ?.sendEmailVerification()
              //                           .then((value) {
              //                             showToast(text: 'Check Your Mail',
              //                                 state: ToastStates.SUCCESS,
              //                             );
              //                       }).catchError((error){
              //
              //                       });
              //                     }
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ),
              //       ],
              //     );
              //   },
              //   fallback: (context) =>
              //       Center(child: CircularProgressIndicator()),
              // ),
            );
          },
        );
      }
    );
  }
}
