abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

// get user

class HomeGetUserLoadingState extends HomeStates {}

class HomeGetUserSuccessState extends HomeStates {}

class HomeGetUserErrorState extends HomeStates
{
  final String error;

  HomeGetUserErrorState(this.error);
}

// get all users

class HomeGetAllUsersLoadingState extends HomeStates {}

class HomeGetAllUsersSuccessState extends HomeStates {}

class HomeGetAllUsersErrorState extends HomeStates
{
  final String error;

  HomeGetAllUsersErrorState(this.error);
}

class HomeChangeBottomNavState extends HomeStates {}

class HomeNewPostState extends HomeStates {}

class HomeProfileImagePickedSuccessState extends HomeStates {}

class HomeProfileImagePickedErrorState extends HomeStates {}

class HomeUploadProfileImageSuccessState extends HomeStates {}

class HomeUploadProfileImageErrorState extends HomeStates {}

class HomeCoverImagePickedSuccessState extends HomeStates {}

class HomeCoverImagePickedErrorState extends HomeStates {}

class HomeUploadCoverImageSuccessState extends HomeStates {}

class HomeUploadCoverImageErrorState extends HomeStates {}

class HomeUserUpdateLoadingState extends HomeStates {}

class HomeUserUpdateErrorState extends HomeStates {}

// create post

class HomeCreatePostLoadingState extends HomeStates {}

class HomeCreatePostSuccessState extends HomeStates {}

class HomeCreatePostErrorState extends HomeStates {}

class HomePostImagePickedSuccessState extends HomeStates {}

class HomePostImagePickedErrorState extends HomeStates {}

class HomeRemovePostImageState extends HomeStates {}

// get posts

class HomeGetPostsLoadingState extends HomeStates {}

class HomeGetPostsSuccessState extends HomeStates {}

class HomeGetPostsErrorState extends HomeStates
{
  final String error;

  HomeGetPostsErrorState(this.error);
}

// like post

class HomeLikePostSuccessState extends HomeStates {}

class HomeLikePostErrorState extends HomeStates
{
  final String error;

  HomeLikePostErrorState(this.error);
}

// chat

class HomeSendMessageSuccessState extends HomeStates {}

class HomeSendMessageErrorState extends HomeStates {}

class HomeGetMessagesSuccessState extends HomeStates {}




