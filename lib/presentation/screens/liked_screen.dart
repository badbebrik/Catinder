import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/liked_cat.dart';
import '../cubits/liked_cats_cubit.dart';
import 'detail_screen.dart';

class LikedScreen extends StatelessWidget {
  const LikedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LikedCatsCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text('Liked cats')),
      body: Column(
        children: [
          BlocBuilder<LikedCatsCubit, LikedCatsState>(
            builder: (_, state) {
              if (state is! LikedCatsLoaded) return const SizedBox.shrink();

              final breedsMap = <String, String>{};
              for (final like in state.allCats) {
                final b = like.cat.breed;
                if (b != null) breedsMap[b.id] = b.name;
              }

              final items = [
                const DropdownMenuItem<String?>(
                    value: null, child: Text('All')),
                ...breedsMap.entries.map((e) => DropdownMenuItem<String?>(
                  value: e.key,
                  child: Text(e.value),
                )),
              ];

              return Padding(
                padding: const EdgeInsets.all(8),
                child: DropdownButton<String?>(
                  isExpanded: true,
                  value: state.selectedBreed,
                  items: items,
                  onChanged: cubit.setBreedFilter,
                ),
              );
            },
          ),

          Expanded(
            child: BlocBuilder<LikedCatsCubit, LikedCatsState>(
              builder: (_, state) {
                if (state is LikedCatsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is LikedCatsError) {
                  return Center(child: Text(state.message));
                }
                if (state is LikedCatsLoaded) {
                  if (state.cats.isEmpty) {
                    return const Center(child: Text('No cats yet'));
                  }
                  return ListView.builder(
                    itemCount: state.cats.length,
                    itemBuilder: (_, i) =>
                        _LikedTile(liked: state.cats[i]),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LikedTile extends StatelessWidget {
  final LikedCat liked;
  const _LikedTile({required this.liked});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LikedCatsCubit>();

    return Dismissible(
      key: ValueKey(liked.cat.id),
      onDismissed: (_) => cubit.delete(liked.cat.id),
      background: Container(color: Colors.red),
      child: ListTile(
        leading: Image.network(liked.cat.imageUrl,
            width: 60, height: 60, fit: BoxFit.cover),
        title: Text(liked.cat.breed?.name ?? 'Cat'),
        subtitle: Text(
            'Liked ${liked.likedAt.toLocal().toString().substring(0, 16)}'),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => DetailScreen(cat: liked.cat)),
        ),
      ),
    );
  }
}
