import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_0/layout/Social_app/cubit/status.dart';
import 'package:flutter_0/models/social_app/social_post_model.dart';
import 'package:flutter_0/shared/components/components.dart';
import 'package:flutter_0/shared/styles/colors.dart';
import 'package:flutter_0/shared/styles/icon_broken.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../layout/Social_app/cubit/cubit.dart';
import '../social_comment/social_comment_screen.dart';

class SocialFeedsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return BlocConsumer<SocialCubit,SocialStates>(
          listener:(context,state){} ,
          builder:(context,state){
            return ConditionalBuilder(
              condition: SocialCubit.get(context).posts!.isNotEmpty&& SocialCubit.get(context).userModel!=null,
              builder: ( context)=> SingleChildScrollView(
                physics:BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Card(
                      elevation: 6.0,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      margin: EdgeInsets.all(8.0),
                      child: Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          Image(
                            image: NetworkImage(
                                'https://img.freepik.com/free-photo/horizontal-shot-smiling-curly-haired-woman-indicates-free-space-demonstrates-place-your-advertisement-attracts-attention-sale-wears-green-turtleneck-isolated-vibrant-pink-wall_273609-42770.jpg?w=740&t=st=1660085891~exp=1660086491~hmac=1373c9eaeba49feeae415afdc2b2942fc5e2fb5144f69d2e69d1c41ab31be126'),
                            fit: BoxFit.cover,
                            height: 200.0,
                            width: double.infinity,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'communicate with friends',
                              style: Theme.of(context).textTheme.subtitle1?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder:(context,index)=>buildPostItem(SocialCubit.get(context).posts![index],context,index),
                      separatorBuilder: (context,index)=>SizedBox(height:8,),
                      itemCount:SocialCubit.get(context).posts!.length,
                    ),
                    SizedBox(height: 10,)
                  ],
                ),
              ),
              fallback: (context)=>Center(child: CircularProgressIndicator()),
            );
          },
        );

  }


  Widget buildPostItem(SocialPostModel? model,context,index)=> Card(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    elevation: 5.0,
    margin: EdgeInsets.symmetric(
      horizontal: 8.0,
    ),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage(
                    '${model!.image}'),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                              '${model.name}',
                          style: TextStyle(
                            height: 1.4,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.check_circle,
                          color: defaultColor,
                          size: 15,
                        ),
                      ],
                    ),
                    Text(
                      '${model.dateTime}',
                      style:
                      Theme.of(context).textTheme.caption?.copyWith(
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 15,
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.more_horiz,
                  size: 20,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 8,
            ),
            child: Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey[300],
            ),
          ),
          Text(
            '${model.text}',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          // Padding(
          //   padding: const EdgeInsets.only(
          //     top: 5,
          //   ),
          //   child: Container(
          //     width: double.infinity,
          //     child: Wrap(
          //       children: [
          //         Padding(
          //           padding: const EdgeInsetsDirectional.only(
          //             end: 5,
          //           ),
          //           child: Container(
          //             height: 25,
          //             child: MaterialButton(
          //               minWidth: 1,
          //               padding: EdgeInsets.zero,
          //               onPressed: () {},
          //               child: Text(
          //                 '#software',
          //                 style: Theme.of(context)
          //                     .textTheme
          //                     .caption
          //                     ?.copyWith(
          //                   color: defaultColor,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          if(model.postImage !='')
          Padding(
            padding:  const EdgeInsetsDirectional.only(
              top: 15
            ),
            child: Container(
              height: 140.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                image: DecorationImage(
                  image: NetworkImage(
                      '${model.postImage }'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 5
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5 ),
                      child: Row(
                        children: [
                          Icon(
                            IconBroken.Heart,
                            size: 16,
                            color: Colors.red,
                          ),
                          SizedBox(width: 5,),
                          Text(
                            '${SocialCubit.get(context).likes![index]}',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ),
                    onTap:(){},
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisAlignment:MainAxisAlignment.end,
                        children: [
                          Icon(
                            IconBroken.Chat,
                            size: 16,
                            color: Colors.amberAccent,
                          ),
                          SizedBox(width: 5,),
                          Text(
                            ' Comments',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ),
                    onTap:(){},
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey[300],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18.0,
                        backgroundImage: NetworkImage(
                          '${SocialCubit.get(context).userModel!.image}'
                        ),
                      ),
                      SizedBox(width: 15,),
                      Text(
                        'write a comment . . . . ',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                  onTap: (){
                    navigateTo(context, CommentsScreen(postId: SocialCubit.get(context).postsId![index],));
                  },
                ),
              ),
              SizedBox(width: 20,),
              InkWell(
                child: Row(
                  children: [
                    Icon(
                      IconBroken.Heart,
                      size: 16,
                      color: Colors.red,
                    ),
                    SizedBox(width: 5,),
                    Text(
                      'Like',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
                onTap:(){
                  SocialCubit.get(context).likePost( SocialCubit.get(context).postsId![index]);
                },
              ),

            ],
          ),
        ],
      ),
    ),
  );
}
