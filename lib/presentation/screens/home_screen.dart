import 'package:catinder/presentation/cubits/cat_feed_cubit.dart';
import 'package:catinder/presentation/cubits/connectivity_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/action_buttons.dart';
import '../widgets/cat_card.dart';
import 'detail_screen.dart';
import 'liked_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _heartCtrl;
  late final Animation<double> _heartAnim;
  int _prevLikes = 0;

  @override
  void initState() {
    super.initState();

    _heartCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _heartAnim = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween:
            Tween(begin: 1.2, end: 1.0).chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_heartCtrl);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConnectivityCubit>().stream.listen((status) {
        if (status == ConnectivityStatus.offline) {
          _showSnackBar(message: 'Нет соединения с интернетом');
        } else {
          _showSnackBar(message: 'Соединение восстановлено');
          context.read<CatFeedCubit>().loadNext();
        }
      });
    });
  }

  @override
  void dispose() {
    _heartCtrl.dispose();
    super.dispose();
  }

  void _showSnackBar({required String message}) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final catFeedCubit = context.read<CatFeedCubit>();
    final connectivityStatus = context.watch<ConnectivityCubit>().state;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Cat',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              'inder',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.pets, color: Colors.blueAccent, size: 28),
          ],
        ),
        actions: [
          BlocBuilder<CatFeedCubit, CatFeedState>(
            builder: (_, state) {
              return ScaleTransition(
                scale: _heartAnim,
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.favorite, color: Colors.red, size: 24),
                      const SizedBox(width: 6),
                      Text(
                        '${state.likes}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (connectivityStatus == ConnectivityStatus.offline)
            _buildOfflineView(catFeedCubit)
          else
            BlocConsumer<CatFeedCubit, CatFeedState>(
              listener: (context, state) {
                if (state.likes > _prevLikes) {
                  _heartCtrl.forward().then((_) => _heartCtrl.reset());
                }
                _prevLikes = state.likes;

                if (state is CatFeedError) {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Ошибка'),
                      content: Text(state.message),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is CatFeedLoading || state is CatFeedInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CatFeedTransition) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      CatCard(
                        cat: state.previous,
                        onLike: () {},
                        onDislike: () {},
                        onTap: () {},
                      ),
                      Container(color: Colors.white70),
                      const Center(child: CircularProgressIndicator()),
                    ],
                  );
                } else if (state is CatFeedLoaded) {
                  final cat = state.cat;
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned(
                        top: 12,
                        right: 12,
                        child: FloatingActionButton.small(
                          heroTag: 'likesScreenBtnOnline',
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LikedScreen()),
                          ),
                          backgroundColor: Colors.blueAccent,
                          child:
                              const Icon(Icons.favorite, color: Colors.white),
                        ),
                      ),
                      CatCard(
                        cat: cat,
                        onLike: () => catFeedCubit.likeCurrent(),
                        onDislike: () => catFeedCubit.dislikeCurrent(),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => DetailScreen(cat: cat)),
                        ),
                      ),
                      Positioned(
                        bottom: 32,
                        left: 32,
                        right: 32,
                        child: ActionButtons(
                          onLike: () => catFeedCubit.likeCurrent(),
                          onDislike: () => catFeedCubit.dislikeCurrent(),
                        ),
                      ),
                    ],
                  );
                } else if (state is CatFeedError) {
                  return Center(
                    child: ElevatedButton(
                      onPressed: () => catFeedCubit.loadNext(),
                      child: const Text('Повторить'),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          Positioned(
            top: 12,
            right: 12,
            child: FloatingActionButton.small(
              heroTag: 'likesScreenBtnOffline',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LikedScreen(),
                ),
              ),
              backgroundColor: Colors.blueAccent,
              child: const Icon(Icons.favorite, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfflineView(CatFeedCubit catFeedCubit) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/offline.png',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 24),
            const Text(
              'Потеряно соединение с интернетом',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Пожалуйста, проверьте ваше интернет-соединение и нажмите «Retry».',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                catFeedCubit.loadNext();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
