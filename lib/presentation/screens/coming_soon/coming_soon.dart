import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rollin_user/data/repositories/coming_soon_repositoryimpl.dart';
import 'package:rollin_user/domain/usecases/coming_soon_usecase.dart';
import 'package:rollin_user/presentation/bloc/coming_soon/coming_soon_movies_bloc.dart';
import 'package:rollin_user/presentation/bloc/coming_soon/coming_soon_movies_event.dart';
import 'package:rollin_user/presentation/bloc/coming_soon/coming_soon_movies_state.dart';
import 'package:rollin_user/presentation/resourses/app_colours.dart';
import 'package:rollin_user/presentation/screens/coming_soon/movie_detailspage.dart';
import 'package:rollin_user/presentation/widgets/custom_shimmer.dart';

class ComingSoonMovies extends StatelessWidget {
  const ComingSoonMovies({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = MovieRepositoryImpl(FirebaseFirestore.instance);
    final getComingSoonMovies = GetComingSoonMovies(repo);

    return BlocProvider(
      create: (_) =>
          MovieBloc(getComingSoonMovies)..add(FetchComingSoonMovies()),
      child: Builder(
        builder: (context) {
          final size = MediaQuery.of(context).size;
          final width = size.width;
          final height = size.height;

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text('Coming Soon'),
              backgroundColor: AppColours.shineBlack,
            ),
            backgroundColor: AppColours.shineBlack,
            body: BlocBuilder<MovieBloc, MovieState>(
              builder: (context, state) {
                ///  SHIMMER LOADING STATE
                if (state is MovieLoading) {
                  return Padding(
                    padding: EdgeInsets.all(width * 0.03),
                    child: Wrap(
                      spacing: width * 0.04,
                      runSpacing: height * 0.02,
                      children: List.generate(6, (_) {
                        final itemWidth =
                            (width - (width * 0.04) - (width * 0.06)) / 2;

                        return SizedBox(
                          width: itemWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomShimmer(
                                child: Container(
                                  height: height * 0.30,
                                  width: itemWidth,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade800,
                                    borderRadius:
                                        BorderRadius.circular(width * 0.02),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              CustomShimmer(
                                child: Container(
                                  height: 12,
                                  width: itemWidth * 0.7,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                              const SizedBox(height: 6),
                              CustomShimmer(
                                child: Container(
                                  height: 10,
                                  width: itemWidth * 0.5,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  );
                }

                ///  SUCCESS STATE
                if (state is MovieSuccess) {
                  final movies = state.movies;

                  if (movies.isEmpty) {
                    return const Center(
                      child: Text(
                        "No movies available",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return Padding(
                    padding: EdgeInsets.all(width * 0.03),
                    child: SingleChildScrollView(
                      child: Wrap(
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
                                  builder: (_) =>
                                      MovieDetailsPage(movie: movie),
                                ),
                              );
                            },
                            child: SizedBox(
                              width: itemWidth,
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  ///  POSTER WITH SHIMMER
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(width * 0.02),
                                    child: Image.network(
                                      movie.posterUrl,
                                      width: itemWidth,
                                      height: height * 0.30,
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, progress) {
                                        if (progress == null) return child;
                                        return CustomShimmer(
                                          child: Container(
                                            width: itemWidth,
                                            height: height * 0.30,
                                            color: Colors.grey.shade800,
                                          ),
                                        );
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          width: itemWidth,
                                          height: height * 0.30,
                                          color: Colors.grey.shade800,
                                          child: const Icon(
                                            Icons.broken_image,
                                            color: Colors.grey,
                                            size: 40,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 6),

                                  /// 🎞 TITLE
                                  Text(
                                    movie.title,
                                    style: const TextStyle(
                                      color: AppColours.shineWhite,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                  ///  LANGUAGE
                                  Text(
                                    movie.language,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),

                                  ///  GENRES
                                  Text(
                                    movie.genres.join(" • "),
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
                    ),
                  );
                }

                ///  ERROR STATE
                if (state is MovieFailure) {
                  return Center(
                    child: Text(
                      "Error: ${state.message}",
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }
}
