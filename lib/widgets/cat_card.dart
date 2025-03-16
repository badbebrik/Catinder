import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:developer' as developer;
import 'package:catinder/models/cat.dart';

class CatCard extends StatefulWidget {
  final Cat cat;
  final VoidCallback onLike;
  final VoidCallback onDislike;
  final VoidCallback onTap;

  const CatCard({
    super.key,
    required this.cat,
    required this.onLike,
    required this.onDislike,
    required this.onTap,
  });

  @override
  State<CatCard> createState() => _CatCardState();
}

class _CatCardState extends State<CatCard> with SingleTickerProviderStateMixin {
  Offset _dragOffset = Offset.zero;
  double _rotation = 0;
  double _opacity = 1.0;
  bool _isDragging = false;

  static const double _swipeThreshold = 0.25;
  static const double _maxRotation = 0.4;

  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onDragStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
      _opacity = 1.0;
    });
  }

  void _onDragUpdate(DragUpdateDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;

    setState(() {
      _dragOffset += details.delta;
      _rotation = (_dragOffset.dx / screenWidth * _maxRotation)
          .clamp(-_maxRotation, _maxRotation);

      if (_dragOffset.dx.abs() > screenWidth * _swipeThreshold) {
        _opacity = 1.0 -
            ((_dragOffset.dx.abs() - screenWidth * _swipeThreshold) /
                    (screenWidth * (1 - _swipeThreshold)))
                .clamp(0.0, 0.6);
      } else {
        _opacity = 1.0;
      }
    });
  }

  void _onDragEnd(DragEndDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dragPercentage = _dragOffset.dx / screenWidth;

    if (dragPercentage.abs() > _swipeThreshold) {
      final endSlide = Offset(
        dragPercentage > 0 ? screenWidth : -screenWidth,
        0,
      );

      _slideAnimation = Tween<Offset>(
        begin: _dragOffset,
        end: endSlide,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ));

      _rotationAnimation = Tween<double>(
        begin: _rotation,
        end: _rotation * 2,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ));

      _opacityAnimation = Tween<double>(
        begin: _opacity,
        end: 0.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ));

      _animationController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (dragPercentage > 0) {
            widget.onLike();
          } else {
            widget.onDislike();
          }
        }
      });

      _animationController.forward().then((_) {
        _resetCard();
      });
    } else {
      _slideAnimation = Tween<Offset>(
        begin: _dragOffset,
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ));

      _rotationAnimation = Tween<double>(
        begin: _rotation,
        end: 0.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ));

      _opacityAnimation = Tween<double>(
        begin: _opacity,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ));

      _animationController.forward().then((_) {
        _resetCard();
      });
    }
  }

  void _resetCard() {
    setState(() {
      _isDragging = false;
      _dragOffset = Offset.zero;
      _rotation = 0;
      _opacity = 1.0;
    });
    _animationController.reset();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final cardWidth = screenSize.width * 0.9;
    final cardHeight = screenSize.height * 0.5;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final offset = _isDragging
            ? _dragOffset
            : (_animationController.isAnimating
                ? _slideAnimation.value
                : _dragOffset);
        final rotation = _isDragging
            ? _rotation
            : (_animationController.isAnimating
                ? _rotationAnimation.value
                : _rotation);
        final opacity = _isDragging
            ? _opacity
            : (_animationController.isAnimating
                ? _opacityAnimation.value
                : _opacity);

        return Center(
          child: GestureDetector(
            onTap: widget.onTap,
            onHorizontalDragStart: _onDragStart,
            onHorizontalDragUpdate: _onDragUpdate,
            onHorizontalDragEnd: _onDragEnd,
            child: Transform(
              transform: Matrix4.identity()
                ..translate(offset.dx, offset.dy)
                ..rotateZ(rotation),
              child: Opacity(
                opacity: opacity,
                child: Container(
                  width: cardWidth,
                  height: cardHeight,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: widget.cat.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) {
                            developer.log('Image loading error: $error');
                            return Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(Icons.error,
                                    size: 50, color: Colors.red),
                              ),
                            );
                          },
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.8),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (widget.cat.breed != null)
                                  Text(
                                    widget.cat.breed!.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(1, 1),
                                          blurRadius: 3,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
