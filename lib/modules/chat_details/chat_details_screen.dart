// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, prefer_const_constructors, curly_braces_in_flow_control_structures, avoid_print

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_app/layout/cubit/cubit.dart';
import 'package:flutter_social_app/layout/cubit/states.dart';
import 'package:flutter_social_app/models/message_model.dart';
import 'package:flutter_social_app/models/user_model.dart';
import 'package:flutter_social_app/shared/components/constants.dart';
import 'package:flutter_social_app/shared/styles/icon_broken.dart';

class ChatDetailsScreen extends StatelessWidget
{
  UserModel? user;

  ChatDetailsScreen({
    this.user,
  });

  var messageController = TextEditingController();

  @override
  Widget build(BuildContext context)
  {
    return Builder(
      builder: (BuildContext context) 
      {
        HomeCubit.get(context)!.getMessages(
            receiverId: user!.uId!,
        );
        
        return BlocConsumer<HomeCubit, HomeStates>(
          listener: (context, state) {},
          builder: (context, state)
          {
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage(
                        '${user!.image}',
                      ),
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      '${user!.name}',
                    ),
                  ],
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ConditionalBuilder(
                        condition: HomeCubit.get(context)!.messages.isNotEmpty,
                        builder: (context) => Column(
                          children:
                          [
                            Expanded(
                              child: ListView.separated(
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index)
                                {
                                  var message = HomeCubit.get(context)!.messages[index];

                                  if(HomeCubit.get(context)!.userModel!.uId! == message.senderId!)
                                    return buildMyMessage(message);

                                  return buildMessage(message);
                                },
                                separatorBuilder: (context, index) => SizedBox(
                                  height: 15.0,
                                ),
                                itemCount: HomeCubit.get(context)!.messages.length,
                              ),
                            ),
                          ],
                        ),
                        fallback: (context) => Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(15.0,),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Row(
                        children:
                        [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15.0,
                              ),
                              child: TextFormField(
                                controller: messageController,
                                validator: (String? value)
                                {
                                  if(value!.isEmpty)
                                  {
                                    return 'please enter your message';
                                  }

                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'type your message here ...',
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 50.0,
                            color: defaultColor,
                            child: MaterialButton(
                              onPressed: ()
                              {
                                print('this is your message ${messageController.text}');

                                HomeCubit.get(context)!.sendMessage(
                                  receiverId: user!.uId!,
                                  dateTime: DateTime.now().toString(),
                                  text: messageController.text,
                                );

                                messageController.clear();
                              },
                              minWidth: 1.0,
                              child: Icon(
                                IconBroken.Send,
                                size: 16.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildMessage(MessageModel messageModel) => Align(
    alignment: AlignmentDirectional.centerStart,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[300]!,
        borderRadius: BorderRadiusDirectional.only(
          bottomEnd: Radius.circular(10.0),
          topStart: Radius.circular(10.0),
          topEnd: Radius.circular(10.0),
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 10.0,
      ),
      child: Text(
        '${messageModel.text}',
      ),
    ),
  );

  Widget buildMyMessage(MessageModel messageModel) => Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Container(
      decoration: BoxDecoration(
        color: defaultColor.withOpacity(.2,),
        borderRadius: BorderRadiusDirectional.only(
          bottomStart: Radius.circular(10.0),
          topStart: Radius.circular(10.0),
          topEnd: Radius.circular(10.0),
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 10.0,
      ),
      child: Text(
        '${messageModel.text}',
      ),
    ),
  );
}
