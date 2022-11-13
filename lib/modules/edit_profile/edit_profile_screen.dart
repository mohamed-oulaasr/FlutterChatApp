// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, sort_child_properties_last, sized_box_for_whitespace, must_be_immutable, avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_app/layout/cubit/cubit.dart';
import 'package:flutter_social_app/layout/cubit/states.dart';
import 'package:flutter_social_app/shared/components/components.dart';
import 'package:flutter_social_app/shared/styles/icon_broken.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatelessWidget
{
  var nameController  = TextEditingController();
  var phoneController = TextEditingController();
  var bioController   = TextEditingController();

  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state)
      {
        var user         = HomeCubit.get(context)!.userModel!;
        var profileImage = HomeCubit.get(context)!.profileImage;
        var coverImage   = HomeCubit.get(context)!.coverImage;

        nameController.text  = user.name!;
        phoneController.text = user.phone!;
        bioController.text   = user.bio!;

        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Edit Profile',
            actions:
            [
              defaultTextButton(
                text: 'Update',
                function: ()
                {
                  HomeCubit.get(context)!.updateUser(
                      name: nameController.text,
                      phone: phoneController.text,
                      bio: bioController.text,
                  );
                },
              ),
              SizedBox(
                width: 15.0,
              ),
            ],
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children:
                [
                  if(state is HomeUserUpdateLoadingState)
                    LinearProgressIndicator(),
                  if(state is HomeUserUpdateLoadingState)
                    SizedBox(
                      height: 10.0,
                    ),
                  Container(
                    height: 190.0,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                height: 140.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(4.0),
                                  ),
                                  image: DecorationImage(
                                    image: coverImage == null
                                    ?
                                    NetworkImage(
                                      '${user.cover}',
                                    )
                                    :
                                    FileImage(coverImage) as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: CircleAvatar(
                                  radius: 20.0,
                                  child: Icon(
                                    IconBroken.Camera,
                                    size: 16.0,
                                  ),
                                ),
                                onPressed: () 
                                {
                                  HomeCubit.get(context)!.getCoverImage();
                                },
                              ),
                            ],
                          ),
                          alignment: AlignmentDirectional.topCenter,
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 54.0,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                radius: 50.0,
                                backgroundImage: profileImage == null ?
                                NetworkImage(
                                  '${user.image}',
                                )
                                :
                                FileImage(
                                    profileImage,
                                ) as ImageProvider,
                              ),
                            ),
                            IconButton(
                              icon: CircleAvatar(
                                radius: 20.0,
                                child: Icon(
                                  IconBroken.Camera,
                                  size: 16.0,
                                ),
                              ),
                              onPressed: ()
                              {
                                HomeCubit.get(context)!.getProfileImage();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  if(HomeCubit.get(context)!.profileImage != null || HomeCubit.get(context)!.coverImage != null)
                    Row(
                    children:
                    [
                      if(HomeCubit.get(context)!.profileImage != null)
                        Expanded(
                        child: Column(
                          children: [
                            defaultButton(
                              text: 'upload profile',
                              function: ()
                              {
                                HomeCubit.get(context)!.uploadProfileImage(
                                  name: nameController.text,
                                  phone: phoneController.text,
                                  bio: bioController.text,
                                );
                              },
                            ),
                            if(state is HomeUserUpdateLoadingState)
                              SizedBox(
                              height: 5.0,
                            ),
                            if(state is HomeUserUpdateLoadingState)
                              LinearProgressIndicator(),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      if(HomeCubit.get(context)!.coverImage != null)
                        Expanded(
                        child: Column(
                          children: [
                            defaultButton(
                              text: 'upload cover',
                              function: ()
                              {
                                HomeCubit.get(context)!.uploadCoverImage(
                                    name: nameController.text,
                                    phone: phoneController.text,
                                    bio: bioController.text,
                                );
                              },
                            ),
                            if(state is HomeUserUpdateLoadingState)
                              SizedBox(
                              height: 5.0,
                            ),
                            if(state is HomeUserUpdateLoadingState)
                              LinearProgressIndicator(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if(HomeCubit.get(context)!.profileImage != null || HomeCubit.get(context)!.coverImage != null)
                    SizedBox(
                    height: 20.0,
                  ),
                  defaultFormField(
                    controller: nameController,
                    type: TextInputType.name,
                    validate: (String? value)
                    {
                      if(value!.isEmpty)
                      {
                        return 'name must not be empty';
                      }

                      return null;
                    },
                    label: 'Name',
                    prefix: IconBroken.User,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  defaultFormField(
                    controller: phoneController,
                    type: TextInputType.phone,
                    validate: (String? value)
                    {
                      if(value!.isEmpty)
                      {
                        return 'phone number must not be empty';
                      }

                      return null;
                    },
                    label: 'Phone',
                    prefix: IconBroken.Call,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  defaultFormField(
                    controller: bioController,
                    type: TextInputType.text,
                    validate: (String? value)
                    {
                      if(value!.isEmpty)
                      {
                        return 'bio must not be empty';
                      }

                      return null;
                    },
                    label: 'Bio',
                    prefix: IconBroken.Info_Circle,
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
