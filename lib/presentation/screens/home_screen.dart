import 'package:catinder/data/repositories/cat_repository_impl.dart';
import 'package:flutter/material.dart';
import '../../data/services/cat_api_service.dart';
import '../widgets/action_buttons.dart';
import '../widgets/cat_card.dart';
import 'package:catinder/domain/entities/cat.dart';

import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final CatRepositoryImpl _catRepository;
  Cat? _currentCat;
  int _likeCounter = 0;
  bool _isLoading = false;
  late AnimationController _heartAnimationController;
  late Animation<double> _heartAnimation;

  @override
  void initState() {
    super.initState();
    _catRepository = CatRepositoryImpl(apiService: CatApiService());
    _loadNewCat();

    _heartAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _heartAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_heartAnimationController);
  }

  @override
  void dispose() {
    _heartAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadNewCat() async {
    setState(() {
      _isLoading = true;
    });
    final cat = await _catRepository.getRandomCat();
    setState(() {
      _currentCat = cat;
      _isLoading = false;
    });
  }

  void _handleLike() {
    setState(() {
      _likeCounter++;
    });
    _heartAnimationController.forward().then((_) {
      _heartAnimationController.reset();
    });
    _loadNewCat();
  }

  void _handleDislike() {
    _loadNewCat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
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
            const SizedBox(width: 8),
            Icon(
              Icons.pets,
              color: Colors.blueAccent,
              size: 28,
            ),
          ],
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          Center(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.only(right: 16.0),
              child: Row(
                children: [
                  ScaleTransition(
                    scale: _heartAnimation,
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$_likeCounter',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: _isLoading || _currentCat == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  child: CatCard(
                    cat: _currentCat!,
                    onLike: _handleLike,
                    onDislike: _handleDislike,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(cat: _currentCat!),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  left: 32,
                  right: 32,
                  bottom: 32,
                  child: ActionButtons(
                      onLike: _handleLike, onDislike: _handleDislike),
                ),
              ],
            ),
    );
  }
}
