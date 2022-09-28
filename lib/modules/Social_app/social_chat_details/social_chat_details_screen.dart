import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_0/layout/Social_app/cubit/cubit.dart';
import 'package:flutter_0/layout/Social_app/cubit/status.dart';
import 'package:flutter_0/models/social_app/social_login_model.dart';
import 'package:flutter_0/models/social_app/social_message_model.dart';
import 'package:flutter_0/shared/styles/colors.dart';
import 'package:flutter_0/shared/styles/icon_broken.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SocialChatDetailsScreen extends StatelessWidget {
  SocialUserModel? userModel;
  SocialChatDetailsScreen({
    this.userModel,
  });
  var messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getMessages(
          receiverId: userModel!.uId,
        );
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage(userModel!.image!),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      userModel!.name!,
                    ),
                  ],
                ),
              ),
              body: ConditionalBuilder(
                condition:SocialCubit.get(context).messages.length>0,
                fallback: (context) =>
                   Center(child: CircularProgressIndicator()),
                builder: (context) =>Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ListView.separated(
                                      physics: BouncingScrollPhysics(),
                                      itemBuilder:(context,index){
                                        var message=SocialCubit.get(context).messages[index];
                                        if(SocialCubit.get(context).userModel!.uId==message.senderId) {
                                          return buildMyMessage(message);
                                        }
                                        return buildMessage(message);
                                      },
                                      separatorBuilder: (context,index)=>const SizedBox(height: 15,),
                                      itemCount: SocialCubit.get(context).messages.length,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                        width: .8,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller: messageController,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: '   write message here . . . '),
                                          ),
                                        ),
                                        Container(
                                          height: 50,
                                          color: defaultColor,
                                          child: MaterialButton(
                                            padding: EdgeInsets.zero,
                                            minWidth: 1.0,
                                            onPressed: () {
                                              SocialCubit.get(context).sendMessage(
                                                receiverId: userModel!.uId,
                                                dateTime: DateTime.now().toString(),
                                                text: messageController.text,
                                              );
                                            },
                                            child: Icon(
                                              IconBroken.Send,
                                              size: 25,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
              ),

            );
          },
        );
      },
    );
  }

  Widget buildMessage(SocialMessageModel? messageModel) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadiusDirectional.only(
                bottomEnd: Radius.circular(15),
                topEnd: Radius.circular(15),
                topStart: Radius.circular(15),
              )),
          padding: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 10,
          ),
          child: Text(
              messageModel!.text!
          ),
        ),
      );
  Widget buildMyMessage(SocialMessageModel? messageModel) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          decoration: BoxDecoration(
              color: defaultColor.withOpacity(.2),
              borderRadius: BorderRadiusDirectional.only(
                bottomStart: Radius.circular(15),
                topEnd: Radius.circular(15),
                topStart: Radius.circular(15),
              )),
          padding: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 10,
          ),
          child: Text(
            messageModel!.text!
          ),
        ),
      );
}
