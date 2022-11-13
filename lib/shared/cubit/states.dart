abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppChangeModeState extends AppStates {}

class GetUserSuccessState extends AppStates {}

class GetUserErrorState extends AppStates
{
  final String error;

  GetUserErrorState(this.error);
}