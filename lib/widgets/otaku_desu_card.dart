import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class OtakuDesuCard extends StatelessWidget {
  final String title;
  final String thumb;
  final String episode;
  final String updatedOn;
  final String updatedDay;
  final String endpoint;
  final VoidCallback onTap; // Tambahkan callback onTap

  const OtakuDesuCard({
    super.key,
    required this.title,
    required this.thumb,
    required this.episode,
    required this.updatedOn,
    required this.updatedDay,
    required this.endpoint,
    required this.onTap, // Tambahkan parameter onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Tambahkan onTap di sini
      child: Container(
        width: 130,
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height *
              0.34, // Mengatur tinggi minimum
        ),
        padding: EdgeInsets.only(bottom: 10),
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
                  image: NetworkImage(thumb),
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
                child: Text(
              updatedOn,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            )),
          ],
        ),
      ),
    );
  }
}
