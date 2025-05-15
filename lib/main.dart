import 'package:catinder/presentation/cubits/cat_feed_cubit.dart';
import 'package:catinder/presentation/cubits/liked_cats_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'infrastructure/di.dart';
import 'presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await initDi();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => sl<CatFeedCubit>()..loadNext()),
      BlocProvider(create: (_) => sl<LikedCatsCubit>()),
    ],
    child: const CatotinderApp(),
  ));
}

class CatotinderApp extends StatelessWidget {
  const CatotinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catinder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
