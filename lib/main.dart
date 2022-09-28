import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_0/layout/Social_app/cubit/cubit.dart';
import 'package:flutter_0/layout/Social_app/cubit/status.dart';
import 'package:flutter_0/layout/Social_app/social_layout.dart';
import 'package:flutter_0/shared/block_observer.dart';
import 'package:flutter_0/shared/components/components.dart';
import 'package:flutter_0/shared/components/constants.dart';
import 'package:flutter_0/shared/network/local/cache_helper.dart';
import 'package:flutter_0/shared/network/remote/Dio_Helper.dart';
import 'package:flutter_0/shared/styles/Themes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'modules/Social_app/social_login/social_login_screen.dart';
Future<void>firebaseMassagingBackgroundHandler(RemoteMessage message)async{
  print(message.data.toString());
  showToast(text: 'on Background Message', state: ToastStates.SUCCESS);
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var token= await FirebaseMessaging.instance.getToken()??'';
  print('=======================================${token}');

  FirebaseMessaging.onMessage.listen((event) {
    print(event.data.toString());
    showToast(text: 'on  Message', state: ToastStates.SUCCESS);

  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print(event.data.toString());
    showToast(text: 'on  Message Opened App', state: ToastStates.SUCCESS);
  });
  FirebaseMessaging.onBackgroundMessage(firebaseMassagingBackgroundHandler);

  await CacheHelper.init();
  DioHelper.init();

  uId = CacheHelper.getData(key: 'uId');
  Widget widget;
  if (uId != null) {
    widget = SocialLayout();
  } else {
    widget = SocialLoginScreen();
  }

  BlocOverrides.runZoned(
    () {
      runApp(MyApp(
        startWidget: widget,
      ));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  final Widget? startWidget;

  MyApp({
    this.startWidget,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialCubit()
        ..getUserData()
         ..getPosts()
         ,
      child: BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
              title: 'Social App',
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: ThemeMode.light,
              home: startWidget);
        },
      ),
    );
  }
}
