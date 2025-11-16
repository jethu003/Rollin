import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rollin_user/presentation/resourses/app_colours.dart';
import 'package:rollin_user/presentation/screens/cinemas/theatre_search.dart';
import 'package:rollin_user/presentation/widgets/custom_shimmer.dart';

class TheatreShowMoviesPage extends StatefulWidget {
  const TheatreShowMoviesPage({super.key});

  @override
  State<TheatreShowMoviesPage> createState() => _TheatreShowMoviesPageState();
}

class _TheatreShowMoviesPageState extends State<TheatreShowMoviesPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> movies = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    try {
      final showSnapshot = await firestore.collectionGroup('shows').get();

      final Set<int> movieIds = {};
      for (var doc in showSnapshot.docs) {
        final data = doc.data();
        if (data.containsKey('movieId') && data['movieId'] != null) {
          movieIds.add(data['movieId']);
        }
      }

      if (movieIds.isEmpty) {
        setState(() => loading = false);
        return;
      }

      final movieSnapshot = await firestore
          .collection('now_playing')
          .where('id', whereIn: movieIds.toList())
          .get();

      movies = movieSnapshot.docs.map((doc) => doc.data()).toList();

      setState(() => loading = false);
    } catch (e) {
      debugPrint('Error fetching movies: $e');
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColours.shineBlack,
        elevation: 0,
        title: const Text(
          "Now Playing",
          style: TextStyle(color: AppColours.insideGrey),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CinemaListPage()),
              );
            },
            child: const Padding(
              padding: EdgeInsets.fromLTRB(8, 6.5, 0, 0),
              child: Icon(Icons.search, color: AppColours.shineWhite),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),
      backgroundColor: AppColours.shineBlack,
      body: Padding(
        padding: EdgeInsets.all(width * 0.03),
        child: SingleChildScrollView(
          child: Wrap(
            spacing: width * 0.04,
            runSpacing: height * 0.02,
            children: (loading
                    ? List.generate(6, (_) => <String, dynamic>{}) 
                    : movies)
                .map((movie) {
              double itemWidth =
                  (width - (width * 0.04) - (width * 0.06)) / 2;

              return SizedBox(
                width: itemWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomShimmer(
                      child: Container(
                        width: itemWidth,
                        height: height * 0.30,
                        decoration: BoxDecoration(
                          color: loading
                              ? Colors.grey.shade800
                              : null,
                          image: !loading
                              ? DecorationImage(
                                  image: NetworkImage(movie['posterUrl'] ?? ''),
                                  fit: BoxFit.cover,
                                )
                              : null,
                          borderRadius:
                              BorderRadius.circular(width * 0.02),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    CustomShimmer(
                      child: Text(
                        movie['title'] ?? 'Loading...',
                        style: const TextStyle(
                          color: AppColours.shineWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    CustomShimmer(
                      child: Text(
                        movie['language'] ?? '',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    CustomShimmer(
                      child: Text(
                        (movie['genres'] as List<dynamic>?)
                                ?.join(" • ") ??
                            '',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
