import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/liked_cats_cubit.dart';
import '../widgets/liked_card.dart';

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
                    LikedCard(liked: loaded.cats[i]),
              ),
            ],
          );
        },
      ),
    );
  }
}

