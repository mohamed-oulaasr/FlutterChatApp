// ignore_for_file: avoid_print, curly_braces_in_flow_control_structures

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_app/layout/cubit/states.dart';
import 'package:flutter_social_app/models/message_model.dart';
import 'package:flutter_social_app/models/post_model.dart';
import 'package:flutter_social_app/models/user_model.dart';
import 'package:flutter_social_app/modules/chats/chats_screen.dart';
import 'package:flutter_social_app/modules/feeds/feeds_screen.dart';
import 'package:flutter_social_app/modules/new_post/new_post_screen.dart';
import 'package:flutter_social_app/modules/settings/settings_screen.dart';
import 'package:flutter_social_app/modules/users/users_screen.dart';
import 'package:flutter_social_app/shared/components/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class HomeCubit extends Cubit<HomeStates>
{
  HomeCubit() : super(HomeInitialState());

  static HomeCubit? get(context) => BlocProvider.of(context);

  UserModel? userModel;

  void getUserData()
  {
    emit(HomeGetUserLoadingState());

    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .get()
        .then((value)
        {
          //print('Home - user data : ${value.data()}');
          //print('Home - user id : $uId');

          userModel = UserModel.fromJson(value.data()!);
          emit(HomeGetUserSuccessState());
        })
        .catchError((error)
        {
          print(error.toString());
          emit(HomeGetUserErrorState(error.toString()));
        }
        );
  }

  int currentIndex = 0;

  List<Widget> screens =
  [
    FeedsScreen(),
    ChatsScreen(),
    NewPostScreen(),
    UsersScreen(),
    SettingsScreen(),
  ];

  List<String> titles =
  [
    'Home',
    'Chats',
    'Post',
    'Users',
    'Settings',
  ];

  void changeBottomNav(int index)
  {

    if(index == 1)
    {
      getUsers();
    }

    if(index == 2)
    {
      emit(HomeNewPostState());
    }
    else
    {
      currentIndex = index;
      emit(HomeChangeBottomNavState());
    }
  }

  File? profileImage;
  File? coverImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async
  {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if(pickedFile != null)
    {
      profileImage = File(pickedFile.path);
      print(pickedFile.path);
      emit(HomeProfileImagePickedSuccessState());
    }
    else
    {
      print('No image selected.');
      emit(HomeProfileImagePickedErrorState());
    }
  }

  Future<void> getCoverImage() async
  {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if(pickedFile != null)
    {
      coverImage = File(pickedFile.path);
      emit(HomeCoverImagePickedSuccessState());
    }
    else
    {
      print('No image selected.');
      emit(HomeCoverImagePickedErrorState());
    }
  }

  //String profileImageUrl = '';

  void uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
  })
  {
    emit(HomeUserUpdateLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value)
        {
          value.ref
              .getDownloadURL()
              .then((value)
              {
                //emit(HomeUploadProfileImageSuccessState());
                print('this is profile image $value');
                //profileImageUrl = value;
                updateUser(
                  name: name,
                  phone: phone,
                  bio: bio,
                  image: value,
                );
              })
              .catchError((error)
              {
                emit(HomeUploadProfileImageErrorState());
              });
        })
        .catchError((error)
        {
          emit(HomeUploadProfileImageErrorState());
        });
  }

  //String coverImageUrl = '';

  void uploadCoverImage({
    required String name,
    required String phone,
    required String bio,
  })
  {
    emit(HomeUserUpdateLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value)
        {
          value.ref
              .getDownloadURL()
              .then((value)
              {
                //emit(HomeUploadCoverImageSuccessState());
                print('this is cover image $value');
                //coverImageUrl = value;
                updateUser(
                  name: name,
                  phone: phone,
                  bio: bio,
                  cover: value,
                );
              })
              .catchError((error)
              {
                emit(HomeUploadCoverImageErrorState());
              });
        })
        .catchError((error)
        {
          emit(HomeUploadCoverImageErrorState());
        });
  }

  // void updateUserImages({
  //   required String name,
  //   required String phone,
  //   required String bio,
  // })
  // {
  //   emit(HomeUserUpdateLoadingState());
  //
  //   if(coverImage != null)
  //   {
  //     uploadCoverImage();
  //   }
  //   else if(profileImage != null)
  //   {
  //     uploadProfileImage();
  //   }
  //   else if(coverImage != null && profileImage != null)
  //   {}
  //   else
  //   {
  //     updateUserData(
  //       name: name,
  //       phone: phone,
  //       bio: bio,
  //     );
  //   }
  // }

  void updateUser({
    required String name,
    required String phone,
    required String bio,
    String? image,
    String? cover,
  })
  {
    UserModel userModelUpdate = UserModel(
      name:  name,
      phone: phone,
      bio:   bio,
      uId:   userModel!.uId,
      email: userModel!.email,
      image: image ?? userModel!.image,
      cover: cover ?? userModel!.cover,
      isEmailVerified: false,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(userModelUpdate.toMap())
        .then((value)
        {
          getUserData();
        })
        .catchError((error)
        {
          emit(HomeUserUpdateErrorState());
        });
  }

  File? postImage;

  Future<void> getPostImage() async
  {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if(pickedFile != null)
    {
      postImage = File(pickedFile.path);
      emit(HomePostImagePickedSuccessState());
    }
    else
    {
      print('No image selected.');
      emit(HomePostImagePickedErrorState());
    }
  }

  void removePostImage()
  {
    postImage = null;
    emit(HomeRemovePostImageState());
  }

  void uploadPostImage({
    required String dateTime,
    required String text,
  })
  {
    emit(HomeCreatePostLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value)
    {
      value.ref
          .getDownloadURL()
          .then((value)
          {
            //emit(HomeCreatePostSuccessState());
            print('this is post image $value');
            //postImage = value;
            createPost(
              dateTime: dateTime,
              text: text,
              postImage: value,
            );

          })
          .catchError((error)
          {
            emit(HomeCreatePostErrorState());
          });
          })
          .catchError((error)
          {
            emit(HomeCreatePostErrorState());
          });
  }

  void createPost({
    required String dateTime,
    required String text,
    String? postImage,
  })
  {
    emit(HomeCreatePostLoadingState());

    PostModel postModel = PostModel(
      uId: userModel!.uId,
      name: userModel!.name,
      image: userModel!.image,
      dateTime: dateTime,
      text: text,
      postImage: postImage ?? '',
    );

    FirebaseFirestore.instance
        .collection('posts')
        .add(postModel.toMap())
        .then((value)
        {
          emit(HomeCreatePostSuccessState());
        })
        .catchError((error)
        {
          emit(HomeCreatePostErrorState());
        });
  }

  List<PostModel> posts = [];
  List<String> postsId = [];
  List<int> likes = [];

  void getPosts()
  {
    FirebaseFirestore.instance
        .collection('posts')
        .get()
        .then((value)
        {
          value.docs.forEach((element)
          {
            element.reference
            .collection('likes')
            .get()
            .then((value)
            {
              likes.add(value.docs.length);
              postsId.add(element.id);
              posts.add(PostModel.fromJson(element.data()));
            })
            .catchError((error) {});
          });

          emit(HomeGetPostsSuccessState());
        })
        .catchError((error)
        {
          emit(HomeGetPostsErrorState(error.toString()));
        });
  }

  void likePost(String postId)
  {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uId)
        .set(
        {
          'like' : true,
        })
        .then((value)
        {
          emit(HomeLikePostSuccessState());
        })
        .catchError((error)
        {
          emit(HomeLikePostErrorState(error.toString()));

        });
  }

  List<UserModel> users = [];

  void getUsers()
  {
    if(users.isEmpty)
    {
      FirebaseFirestore.instance
          .collection('users')
          .get()
          .then((value)
      {
        value.docs.forEach((element)
        {

          if(element.data()['uId'] != userModel!.uId!)
            users.add(UserModel.fromJson(element.data()));

        });

        emit(HomeGetAllUsersSuccessState());
      })
          .catchError((error)
      {
        emit(HomeGetAllUsersErrorState(error.toString()));
      });
    }
  }

  void sendMessage({
    required String receiverId,
    required String dateTime,
    required String text,
  })
  {
    MessageModel messageModel = MessageModel(
      senderId: userModel!.uId!,
      receiverId: receiverId,
      dateTime: dateTime,
      text: text,
    );

    // set my chats

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId!)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value)
        {
          emit(HomeSendMessageSuccessState());
        })
        .catchError((error)
        {
          emit(HomeSendMessageErrorState());
        });

    // set receiver chats

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uId!)
        .collection('messages')
        .add(messageModel.toMap())
        .then((value)
    {
      emit(HomeSendMessageSuccessState());
    })
        .catchError((error)
    {
      emit(HomeSendMessageErrorState());
    });
  }

  List<MessageModel> messages = [];

  void getMessages({
    required String receiverId,
  })
  {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId!)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event)
        {
          messages = [];

          event.docs.forEach((element)
          {
            messages.add(MessageModel.fromJson(element.data()));
          });

          emit(HomeGetMessagesSuccessState());
        });
  }


}