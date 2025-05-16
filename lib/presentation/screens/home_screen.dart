import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/cat_feed_cubit.dart';
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
        vsync: this, duration: const Duration(milliseconds: 300));
    _heartAnim = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 1.2)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 50),
      TweenSequenceItem(
          tween: Tween(begin: 1.2, end: 1.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 50),
    ]).animate(_heartCtrl);
  }

  @override
  void dispose() {
    _heartCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CatFeedCubit>();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Cat',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            Text('inder',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent)),
            SizedBox(width: 8),
            Icon(Icons.pets, color: Colors.blueAccent, size: 28),
          ],
        ),
        actions: [
          BlocBuilder<CatFeedCubit, CatFeedState>(
            builder: (_, state) => ScaleTransition(
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
                    Text('${state.likes}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<CatFeedCubit, CatFeedState>(
        listener: (context, state) {
          if (state.likes > _prevLikes) {
            _heartCtrl.forward().then((_) => _heartCtrl.reset());
          }
          _prevLikes = state.likes;
          if (state is CatFeedError) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Ошибка сети'),
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
          }

          if (state is CatFeedLoaded) {
            final cat = state.cat;
            return Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  top: 12,
                  right: 12,
                  child: FloatingActionButton.small(
                    heroTag: 'likesScreenBtn',
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LikedScreen()),
                    ),
                    backgroundColor: Colors.blueAccent,
                    child: const Icon(Icons.favorite, color: Colors.white),
                  ),
                ),
                CatCard(
                  cat: cat,
                  onLike: () => cubit.likeCurrent(),
                  onDislike: () => cubit.dislikeCurrent(),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DetailScreen(cat: cat)),
                  ),
                ),
                Positioned(
                  bottom: 32,
                  left: 32,
                  right: 32,
                  child: ActionButtons(
                    onLike: () => cubit.likeCurrent(),
                    onDislike: () => cubit.dislikeCurrent(),
                  ),
                ),
              ],
            );
          }

          if (state is CatFeedError) {
            return Center(
              child: ElevatedButton(
                onPressed: () => cubit.loadNext(),
                child: const Text('Повторить'),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
