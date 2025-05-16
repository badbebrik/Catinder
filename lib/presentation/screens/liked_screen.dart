import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../domain/entities/liked_cat.dart';
import '../cubits/liked_cats_cubit.dart';
import 'detail_screen.dart';

class LikedScreen extends StatelessWidget {
  const LikedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LikedCatsCubit>();

    return Scaffold(
      body: BlocBuilder<LikedCatsCubit, LikedCatsState>(
        builder: (context, state) {
          if (state is LikedCatsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is LikedCatsError) {
            return Center(child: Text(state.message));
          }

          final loaded = state as LikedCatsLoaded;
          final breedsMap = <String, String>{};
          for (final like in loaded.allCats) {
            final b = like.cat.breed;
            if (b != null) breedsMap[b.id] = b.name;
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.white,
                elevation: 0,
                centerTitle: true,
                expandedHeight: 90,
                flexibleSpace: SafeArea(
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
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
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButton<String?>(
                        value: loaded.selectedBreed,
                        isExpanded: true,
                        hint: const Text('Filter by breed'),
                        items: [
                          const DropdownMenuItem(
                              value: null, child: Text('All')),
                          ...breedsMap.entries.map(
                                (e) => DropdownMenuItem(
                              value: e.key,
                              child: Text(e.value),
                            ),
                          ),
                        ],
                        onChanged: cubit.setBreedFilter,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Total: ${loaded.cats.length}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),

              loaded.cats.isEmpty
                  ? SliverFillRemaining(
                child: Center(
                  child: Text(
                    'No cats yet',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
              )
                  : SliverList.builder(
                itemCount: loaded.cats.length,
                itemBuilder: (_, i) =>
                    _LikedCard(liked: loaded.cats[i]),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LikedCard extends StatelessWidget {
  final LikedCat liked;
  const _LikedCard({required this.liked});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LikedCatsCubit>();
    final breedName = liked.cat.breed?.name ?? 'Cat';
    final likedAtString = liked.likedAt.toLocal().toString().substring(0, 16);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailScreen(cat: liked.cat)),
        ),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            height: 160,
            child: Row(
              children: [
                CachedNetworkImage(
                  imageUrl: liked.cat.imageUrl,
                  width: 160,
                  height: 160,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (_, __, ___) => const Icon(Icons.error),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              breedName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Liked $likedAtString',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: IconButton(
                            onPressed: () => cubit.delete(liked.cat.id),
                            icon: const Icon(Icons.delete_outline),
                            color: Colors.red,
                            iconSize: 24,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 24,
                              minHeight: 24,
                            ),
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
    );
  }
}
