import 'package:flutter/material.dart';

class MovieGrid extends StatelessWidget {
  const MovieGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0), 
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0, 
          mainAxisSpacing: 8.0,
          childAspectRatio: 0.55, 
        ),
        itemCount: 10, 
        itemBuilder: (context, index) {
          return const MoviePoster(
            imagePath: 'assets/aavesham.jpg',
            movieName: 'Aavesham',
            rating: 4.5, 
          );
        },
      ),
    );
  }
}

class MoviePoster extends StatelessWidget {
  final String imagePath;
  final String movieName;
  final double rating;

  const MoviePoster({
    super.key,
    required this.imagePath,
    required this.movieName,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      
      children: [
        Container(
          height: 260, 
          width: 195, 
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0), 
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), 
                blurRadius: 4,
                offset: const Offset(2, 2),
              ),
            ],
            image: DecorationImage(
              image: AssetImage(imagePath), 
              fit: BoxFit.fill, 
            ),
          ),
        ),
        const SizedBox(height: 4.0), 
    
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 14.0),
            const SizedBox(width: 4.0), 
            Text(
              rating.toStringAsFixed(1),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4.0), 
   
        Text(
          movieName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis, 
          maxLines: 1, 
        ),
                const Text(
          'Genere : drama ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis, 
          maxLines: 1, 
        ),
      ],
    );
  }
}
