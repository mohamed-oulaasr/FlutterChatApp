// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unnecessary_null_in_if_null_operators, prefer_const_constructors_in_immutables, avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_app/layout/cubit/cubit.dart';
import 'package:flutter_social_app/layout/home_layout.dart';
import 'package:flutter_social_app/modules/login/login_screen.dart';
import 'package:flutter_social_app/shared/bloc_observer.dart';
import 'package:flutter_social_app/shared/components/components.dart';
import 'package:flutter_social_app/shared/components/constants.dart';
import 'package:flutter_social_app/shared/cubit/cubit.dart';
import 'package:flutter_social_app/shared/cubit/states.dart';
import 'package:flutter_social_app/shared/network/local/cache_helper.dart';
import 'package:flutter_social_app/shared/styles/themes.dart';


Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async
{
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  //await Firebase.initializeApp();
  //print("Handling a background message: ${message.messageId}");

  print('on background message');
  print(message.data.toString());

  showToast(text: 'on background message', state: ToastStates.SUCCESS,);
}

void main() async
{

  //https://img.freepik.com/photos-premium/cosmos-dans-champ-coucher-du-soleil_29084-2310.jpg

  // بيتأكد ان كل حاجه هنا في الميثود خلصت و بعدين يتفح الابلكيشن
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    //options: DefaultFirebaseOptions.currentPlatform,
  );

  var token = await FirebaseMessaging.instance.getToken();
  print('Token : $token');

  // foreground fcm
  FirebaseMessaging.onMessage.listen((event)
  {
    print('on message');
    print(event.data.toString());

    showToast(text: 'on message', state: ToastStates.SUCCESS,);
  });

  // when click on notification to open app
  FirebaseMessaging.onMessageOpenedApp.listen((event)
  {
    print('on message opened app');
    print(event.data.toString());

    showToast(text: 'on message opened app', state: ToastStates.SUCCESS,);
  });

  // background fcm
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Bloc Observer
  Bloc.observer = MyBlocObserver();

  // Cache Helper
  await CacheHelper.init();

  bool isDark = CacheHelper.getData(key: 'isDark') ?? false;   // for Null Safety

  Widget widget;

  uId = CacheHelper.getData(key: 'uId') ?? null;

  if(uId != null)
  {
    widget = HomeLayout();
  }
  else
  {
    widget = LoginScreen();
  }

  runApp(MyApp(
    isDark: isDark,
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget
{
  final bool isDark;
  final Widget startWidget;

  MyApp({
    required this.isDark,
    required this.startWidget,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context)
  {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => AppCubit()..changeAppMode(fromShared: isDark),
        ),
        BlocProvider(
            create: (context) => HomeCubit()..getUserData()..getPosts(),
        ),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, states) {},
        builder: (context, states)
        {
          return MaterialApp(
            title: 'SocialApp',
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: AppCubit.get(context)!.isDark ? ThemeMode.dark : ThemeMode.light,
            home: startWidget,
            //home: HomeLayout(),

          );
        },
      ),
    );
  }
}

