import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:rollin_user/data/repositories/home_pagerepoimp.dart';
import 'package:rollin_user/domain/entities/home_page_entity.dart';
import 'package:rollin_user/domain/usecases/home_page_usecase.dart';
import 'package:rollin_user/presentation/bloc/seat_layout/home_page_bloc.dart';
import 'package:rollin_user/presentation/bloc/seat_layout/home_page_event.dart';
import 'package:rollin_user/presentation/bloc/seat_layout/home_page_state.dart';
import 'package:rollin_user/presentation/resourses/app_colours.dart';
import 'package:rollin_user/presentation/screens/home_page/book_from_movies.dart';
import 'package:rollin_user/presentation/screens/home_page/home_page_appbar.dart';
import 'package:rollin_user/presentation/screens/home_page/trailor_page.dart';
import 'package:rollin_user/presentation/widgets/custom_shimmer.dart';

class TheatreShowMoviesPage extends StatelessWidget {
  const TheatreShowMoviesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TheatreMoviesBloc(
        GetNowPlayingMovies(
          MovieRepositoryImpl(FirebaseFirestore.instance),
        ),
      )..add(LoadTheatreMovies()),
      child: const _TheatreShowMoviesView(),
    );
  }
}

class _TheatreShowMoviesView extends StatelessWidget {
  const _TheatreShowMoviesView();

  Map<String, dynamic> _movieToMap(MovieEntity movie) {
    return {
      'id': movie.id,
      'title': movie.title,
      'posterUrl': movie.posterUrl,
      'backdropUrl': movie.backdropUrl,
      'language': movie.language,
      'releaseDate': movie.releaseDate,
      'genres': movie.genres,
      'overview': movie.overview,
      'cast': movie.cast,
      'crew': movie.crew,
      'trailer': movie.trailorUrl,
    };
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: AppColours.shineBlack,
      appBar: HomeAppBar(),
      body: BlocBuilder<TheatreMoviesBloc, TheatreMoviesState>(
        builder: (context, state) {
          final loading = state is TheatreMoviesLoading;
          final movies =
              state is TheatreMoviesLoaded ? state.movies : <MovieEntity>[];

          /// ===============================
          /// LOADING
          /// ===============================
          if (loading) {
            return Padding(
              padding: EdgeInsets.all(width * 0.03),
              child: Wrap(
                spacing: width * 0.04,
                runSpacing: height * 0.02,
                children: List.generate(
                  6,
                  (_) => SizedBox(
                    width: (width - (width * 0.04) - (width * 0.06)) / 2,
                    height: height * 0.30,
                    child: CustomShimmer(
                      child: Container(color: Colors.grey.shade800),
                    ),
                  ),
                ),
              ),
            );
          }

          /// ===============================
          /// EMPTY
          /// ===============================
          if (movies.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.movie_creation_outlined,
                    size: 70,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12),
                  Text(
                        "Sorry no movies available!",
                        style: TextStyle(
                          color: Color.fromARGB(255, 200, 194, 194),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                ],
              ),
            );
          }

          /// ===============================
          /// MOVIES + FOOTER TEXT
          /// ===============================
          return Padding(
            padding: EdgeInsets.all(width * 0.03),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // 👈 keeps left
                children: [
                  Wrap(
                    spacing: width * 0.04,
                    runSpacing: height * 0.02,
                    children: movies.map((movie) {
                      final itemWidth =
                          (width - (width * 0.04) - (width * 0.06)) / 2;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MovieDetailsOverlayPage(
                                movie: _movieToMap(movie),
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: itemWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(width * 0.02),
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      width: itemWidth,
                                      height: height * 0.30,
                                      child: Image.network(
                                        movie.posterUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),

                                    /// ▶️ Trailer
                                    Positioned(
                                      bottom: 8,
                                      right: 8,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  FullScreenTrailerPage(
                                                trailerUrl:
                                                    movie.trailorUrl,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding:
                                              const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.black
                                                .withOpacity(0.6),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.play_arrow_rounded,
                                            color: Colors.white,
                                            size: 26,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                movie.title,
                                style: const TextStyle(
                                  color: AppColours.shineWhite,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                movie.language,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                movie.genres.join(' • '),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),

               
                  const SizedBox(height: 30),
                  const Center(
                  child: Text(
                        "That's all we've got!",
                        style: TextStyle(
                          color: Color.fromARGB(255, 200, 194, 194),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
