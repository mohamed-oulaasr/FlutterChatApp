// ignore_for_file: avoid_print, unnecessary_string_interpolations, curly_braces_in_flow_control_structures

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_app/shared/cubit/states.dart';
import 'package:flutter_social_app/shared/network/local/cache_helper.dart';

class AppCubit extends Cubit<AppStates> {

  AppCubit() : super(AppInitialState());

  static AppCubit? get(context) => BlocProvider.of(context);

  bool isDark = false;

  // Change App Mode
  void changeAppMode({bool? fromShared})
  {
    if(fromShared != null)
    {
      isDark = fromShared;

      emit(AppChangeModeState());
    }
    else
    {
      isDark = !isDark;

      CacheHelper.saveData(
        key: 'isDark',
        value: isDark,
      ).then((value)
      {
        emit(AppChangeModeState());
      });
    }
  }

}