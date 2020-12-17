import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:refactory_test/main/feature/auth/logins-screen.dart';
import 'package:refactory_test/main/feature/auth/register-screen.dart';
import 'package:refactory_test/main/feature/course/bloc/course/course_bloc.dart';
import 'package:refactory_test/main/feature/course/bloc/detail_course/detail_course_bloc.dart';
import 'package:refactory_test/main/feature/course/bloc/review/review_bloc.dart';
import 'package:refactory_test/main/feature/home/bloc/home_bloc.dart';
import 'package:refactory_test/main/feature/home/bloc/partner/partner_bloc.dart';
import 'package:refactory_test/main/feature/home/bloc/see_on/see_on_bloc.dart';
import 'package:refactory_test/main/main-screen.dart';

import 'main/feature/course/bloc/list_course/list_course_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PartnerBloc>(
          create: (BuildContext context) => PartnerBloc(),
        ),
        BlocProvider<HomeBloc>(
          create: (BuildContext context) => HomeBloc(),
        ),
        BlocProvider<SeeOnBloc>(
          create: (BuildContext context) => SeeOnBloc(),
        ),
        BlocProvider<CourseBloc>(
          create: (BuildContext context) => CourseBloc(),
        ),
        BlocProvider<ReviewBloc>(
          create: (BuildContext context) => ReviewBloc(),
        ),
        BlocProvider<ListCourseBloc>(
          create: (BuildContext context) => ListCourseBloc(),
        ),
        BlocProvider<DetailCourseBloc>(
          create: (BuildContext context) => DetailCourseBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Refactory Test',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginScreen(),
      ),
    );
  }
}