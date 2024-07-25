import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AnimeCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String episode;
  final double rating;
  final VoidCallback onTap; // Tambahkan callback onTap

  const AnimeCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.episode,
    required this.rating,
    required this.onTap, // Tambahkan parameter onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Tambahkan onTap di sini
      child: Container(
        width: 130,
        height: MediaQuery.of(context).size.height * 0.33,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8.0),
          color: const Color.fromARGB(255, 25, 25, 25),
        ),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.17,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: 100,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            SizedBox(
              width: 100,
              child: Text(
                episode != 'null' ? 'Episode $episode' : 'Ongoing',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Center(
              child: RatingBarIndicator(
                unratedColor: Colors.white,
                rating: rating / 20, // Karena rating dalam skala 100
                itemBuilder: (context, index) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 20.0,
                direction: Axis.horizontal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
