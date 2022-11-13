// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_app/layout/cubit/cubit.dart';
import 'package:flutter_social_app/layout/cubit/states.dart';
import 'package:flutter_social_app/models/user_model.dart';
import 'package:flutter_social_app/modules/chat_details/chat_details_screen.dart';
import 'package:flutter_social_app/shared/components/components.dart';


class ChatsScreen extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state)
      {
        return ConditionalBuilder(
          condition: HomeCubit.get(context)!.users.isNotEmpty,
          builder: (context) => ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) => buildChatItem(HomeCubit.get(context)!.users[index], context),
            separatorBuilder: (context, index) => myDivider(),
            itemCount: HomeCubit.get(context)!.users.length,
          ),
          fallback: (context) => Center(child: CircularProgressIndicator(),),
        );
      },
    );
  }

  Widget buildChatItem(UserModel userModel, context) => InkWell(
    onTap: ()
    {
      navigateTo(
        context,
        ChatDetailsScreen(
          user: userModel,
        ),
      );
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25.0,
            backgroundImage: NetworkImage(
              '${userModel.image}',
            ),
          ),
          SizedBox(
            width: 15.0,
          ),
          Text(
            '${userModel.name}',
            style: TextStyle(
              height: 1.4,
            ),
          ),
        ],
      ),
    ),
  );
}
