import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:catinder/domain/entities/cat.dart';

class DetailScreen extends StatelessWidget {
  final Cat cat;

  const DetailScreen({super.key, required this.cat});

  Widget _buildRatingBar(int? value, String label,
      {Color color = Colors.blue}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: List.generate(5, (index) {
            return Icon(
              Icons.star,
              size: 20,
              color: (value ?? 0) > index ? color : Colors.grey[300],
            );
          }),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, String value,
      {IconData? icon, Color? iconColor}) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (icon != null)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (iconColor ?? Colors.blue).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? Colors.blue,
                ),
              ),
            if (icon != null) const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final breed = cat.breed;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                breed?.name ?? 'Nice Cat',
                style: const TextStyle(
                  color: Colors.white,
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
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: cat.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black54,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (breed != null)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  if (breed.description != null &&
                      breed.description!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        breed.description!,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  if (breed.origin != null)
                    _buildInfoCard('Origin', breed.origin!,
                        icon: Icons.public, iconColor: Colors.green),
                  if (breed.weight != null)
                    _buildInfoCard('Weight', '${breed.weight} kg',
                        icon: Icons.monitor_weight, iconColor: Colors.orange),
                  if (breed.lifeSpan != null)
                    _buildInfoCard('Life span', '${breed.lifeSpan!} years',
                        icon: Icons.timer, iconColor: Colors.purple),
                  if (breed.temperament != null)
                    _buildInfoCard('Temperament', breed.temperament!,
                        icon: Icons.psychology, iconColor: Colors.blue),
                  if (breed.altNames != null && breed.altNames!.isNotEmpty)
                    _buildInfoCard('Other names', breed.altNames!,
                        icon: Icons.label, iconColor: Colors.teal),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Traits',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              children: [
                                if (breed.adaptability != null)
                                  _buildRatingBar(
                                      breed.adaptability, 'Adaptability',
                                      color: Colors.green),
                                if (breed.affectionLevel != null)
                                  _buildRatingBar(
                                      breed.affectionLevel, 'Affection level',
                                      color: Colors.red),
                                if (breed.childFriendly != null)
                                  _buildRatingBar(
                                      breed.childFriendly, 'Child friendly',
                                      color: Colors.orange),
                                if (breed.dogFriendly != null)
                                  _buildRatingBar(
                                      breed.dogFriendly, 'Dog friendly',
                                      color: Colors.brown),
                                if (breed.energyLevel != null)
                                  _buildRatingBar(
                                      breed.energyLevel, 'Energy level',
                                      color: Colors.blue),
                                if (breed.grooming != null)
                                  _buildRatingBar(breed.grooming, 'Grooming',
                                      color: Colors.purple),
                                if (breed.healthIssues != null)
                                  _buildRatingBar(
                                      breed.healthIssues, 'Health issues',
                                      color: Colors.red),
                                if (breed.intelligence != null)
                                  _buildRatingBar(
                                      breed.intelligence, 'Intelligence',
                                      color: Colors.indigo),
                                if (breed.sheddingLevel != null)
                                  _buildRatingBar(
                                      breed.sheddingLevel, 'Shedding level',
                                      color: Colors.brown),
                                if (breed.socialNeeds != null)
                                  _buildRatingBar(
                                      breed.socialNeeds, 'Social needs',
                                      color: Colors.teal),
                                if (breed.strangerFriendly != null)
                                  _buildRatingBar(breed.strangerFriendly,
                                      'Stranger friendly',
                                      color: Colors.deepOrange),
                                if (breed.vocalisation != null)
                                  _buildRatingBar(
                                      breed.vocalisation, 'Vocalisation',
                                      color: Colors.pink),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
