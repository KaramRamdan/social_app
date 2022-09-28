import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_0/layout/Social_app/cubit/cubit.dart';
import 'package:flutter_0/layout/Social_app/cubit/status.dart';
import 'package:flutter_0/models/social_app/social_login_model.dart';
import 'package:flutter_0/modules/Social_app/social_chat_details/social_chat_details_screen.dart';
import 'package:flutter_0/shared/components/components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SocialChatsScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context,state){},
      builder: (context,state){
        return  ConditionalBuilder(
          condition: SocialCubit.get(context).allUsers!.length >0,
          fallback: ( context)=>
              Center(child: CircularProgressIndicator()),
          builder: ( context)=>ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder:(context,index)=>buildChatItem(SocialCubit.get(context).allUsers![index],context),
            separatorBuilder:(context,index)=>myDivider(),
            itemCount:SocialCubit.get(context).allUsers!.length,
          ),
        );
      },
    );
  }
  Widget buildChatItem(SocialUserModel? model,context)=> InkWell(
    onTap: (){
      navigateTo(context,SocialChatDetailsScreen(
        userModel: model,
      ) );
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(children: [
        CircleAvatar(
          radius: 25.0,
          backgroundImage: NetworkImage('${model!.image}'),
        ),
        SizedBox(
          width: 15,
        ),
        Text(
          '${model.name}',
          style: TextStyle(
            height: 1.4,
          ),
        ),
      ]),
    ),
  );
}
