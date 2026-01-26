import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rollin_user/presentation/bloc/movie_details/movie_detail_bloc.dart';
import 'package:rollin_user/presentation/bloc/movie_details/movie_detail_event.dart';
import 'package:rollin_user/presentation/bloc/movie_details/movie_detail_state.dart';
import 'package:rollin_user/presentation/resourses/app_colours.dart';
import 'package:rollin_user/presentation/screens/cinemas/theatre_detailpage.dart';
import 'package:rollin_user/presentation/widgets/custom_button.dart';
import 'package:rollin_user/presentation/widgets/custom_shimmer.dart';

class MovieDetailsOverlayPage extends StatelessWidget {
  final Map<String, dynamic> movie;

  const MovieDetailsOverlayPage({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return BlocProvider(
      create: (_) => MovieDetailsBloc(FirebaseFirestore.instance),
      child: Scaffold(
        backgroundColor: AppColours.shineBlack,
        body: Stack(
          children: [
            /// CONTENT
            SingleChildScrollView(
              padding: EdgeInsets.all(width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height * 0.02),

                  /// BACKDROP
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      movie['backdropUrl'] ?? movie['posterUrl'] ?? '',
                      width: double.infinity,
                      height: height * 0.27,
                      fit: BoxFit.cover,
                    ),
                  ),

                  SizedBox(height: height * 0.02),

                  /// TITLE
                  Text(
                    movie['title'] ?? '',
                    style: TextStyle(
                      color: AppColours.shineWhite,
                      fontSize: width * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: height * 0.005),

                  /// LANGUAGE & RELEASE DATE
                  Row(
                    children: [
                      Text(
                        (movie['language'] ?? '').toUpperCase(),
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      SizedBox(width: width * 0.04),
                      Text(
                        movie['releaseDate'] ?? '',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),

                  SizedBox(height: height * 0.01),

                  /// GENRES
                  Text(
                    (movie['genres'] as List<dynamic>?)?.join(" • ") ?? '',
                    style: TextStyle(color: Colors.grey[700]),
                  ),

                  Divider(color: Colors.grey[400]),

                  /// PLOT
                  Text(
                    "Plot:",
                    style: TextStyle(
                      color: AppColours.shineWhite,
                      fontSize: width * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    movie['overview'] ?? '',
                    style: TextStyle(color: AppColours.shineWhite),
                  ),

                  SizedBox(height: height * 0.02),

                  /// CAST
                  if ((movie['cast'] as List<dynamic>?)?.isNotEmpty ?? false)
                    _PeopleSection(
                      title: "Cast:",
                      people: movie['cast'],
                      isCast: true,
                      width: width,
                      height: height,
                    ),

                  /// CREW
                  if ((movie['crew'] as List<dynamic>?)?.isNotEmpty ?? false)
                    _PeopleSection(
                      title: "Crew:",
                      people: movie['crew'],
                      isCast: false,
                      width: width,
                      height: height,
                    ),

                  SizedBox(height: height * 0.15),
                ],
              ),
            ),

            /// BOOK BUTTON WITH SHIMMER
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: BlocConsumer<MovieDetailsBloc, MovieDetailsState>(
                listener: (context, state) {
                  if (state is MovieDetailsLoaded &&
                      state.theatres.isNotEmpty) {
                    final t = state.theatres.first;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TheatreDetailsPage(
                          theatreId: t['theatreId'],
                          theatreName: t['theatreName'],
                          location: t['location'],
                          image: t['image'],
                        ),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  final button = CustomButton(
                    buttonText: "Book Tickets",
                    buttonColor: AppColours.primaryColor,
                    textColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    onPressed: () {
                      context
                          .read<MovieDetailsBloc>()
                          .add(LoadTheatresForMovie(movie['id']));
                    },
                  );

                  
                  if (state is MovieDetailsLoading) {
                    return CustomShimmer(child: button);
                  }

                  return button;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// PEOPLE SECTION (CAST / CREW)
class _PeopleSection extends StatelessWidget {
  final String title;
  final List<dynamic> people;
  final bool isCast;
  final double width;
  final double height;

  const _PeopleSection({
    required this.title,
    required this.people,
    required this.isCast,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColours.shineWhite,
            fontSize: width * 0.045,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: height * 0.01),
        SizedBox(
          height: height * 0.16,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: people.length,
            itemBuilder: (_, index) {
              final person = people[index];
              return _PersonCard(
                image: isCast ? person['profileUrl'] : null,
                name: person['name'],
                subtitle: isCast ? person['character'] : person['job'],
                width: width,
              );
            },
          ),
        ),
      ],
    );
  }
}

/// PERSON CARD
class _PersonCard extends StatelessWidget {
  final String? image;
  final String name;
  final String subtitle;
  final double width;

  const _PersonCard({
    this.image,
    required this.name,
    required this.subtitle,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width * 0.2,
      margin: EdgeInsets.only(right: width * 0.03),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: image != null
                ? Image.network(
                    image!,
                    width: width * 0.18,
                    height: width * 0.18,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: width * 0.18,
                    height: width * 0.18,
                    color: Colors.grey[400],
                    child: const Icon(Icons.person),
                  ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: TextStyle(color: AppColours.shineWhite),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          Text(
            subtitle,
            style: TextStyle(color: Colors.grey[700]),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
