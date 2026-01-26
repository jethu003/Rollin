import 'package:flutter/material.dart';
import 'package:rollin_user/domain/entities/coming_soon.dart';
import 'package:rollin_user/presentation/widgets/custom_shimmer.dart';

class MovieDetailsPage extends StatelessWidget {
  final MovieEntity movie;
  const MovieDetailsPage({super.key, required this.movie});

  static const Color shineBlack = Color.fromARGB(255, 255, 250, 240);
  static const Color shineWhite = Color.fromARGB(255, 0, 0, 0);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: shineBlack,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///  BACKDROP WITH SHIMMER
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  movie.backdropUrl,
                  width: double.infinity,
                  height: height * 0.25,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return CustomShimmer(
                      child: Container(
                        height: height * 0.25,
                        color: Colors.grey.shade300,
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => Container(
                    height: height * 0.25,
                    color: Colors.grey.shade300,
                    child: const Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),

              SizedBox(height: height * 0.02),

              ///  TITLE
              Text(
                movie.title,
                style: TextStyle(
                  color: shineWhite,
                  fontSize: width * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: height * 0.005),

              ///  LANGUAGE + DATE
              Row(
                children: [
                  Text(
                    movie.language.toUpperCase(),
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: width * 0.035),
                  ),
                  SizedBox(width: width * 0.04),
                  Text(
                    movie.releaseDate,
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: width * 0.035),
                  ),
                ],
              ),

              SizedBox(height: height * 0.01),

              ///  GENRES
              Text(
                movie.genres.join(" • "),
                style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: width * 0.035),
              ),

              Divider(
                color: Colors.grey[400],
                thickness: 1,
                height: height * 0.03,
              ),

              ///  PLOT
              Text(
                "Plot:",
                style: TextStyle(
                    color: shineWhite,
                    fontSize: width * 0.045,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: height * 0.005),
              Text(
                movie.overview,
                style: TextStyle(
                    color: shineWhite,
                    fontSize: width * 0.035),
              ),

              SizedBox(height: height * 0.03),

              ///  CAST
              Text(
                "Cast:",
                style: TextStyle(
                    color: shineWhite,
                    fontSize: width * 0.045,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: height * 0.01),

              SizedBox(
                height: height * 0.18,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: movie.cast.length,
                  itemBuilder: (context, index) {
                    final cast = movie.cast[index];
                    return Container(
                      width: width * 0.2,
                      margin: EdgeInsets.only(right: width * 0.03),
                      child: Column(
                        children: [
                          ///  CAST IMAGE SHIMMER
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              cast.profileUrl,
                              width: width * 0.18,
                              height: width * 0.18,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, progress) {
                                if (progress == null) return child;
                                return CustomShimmer(
                                  child: Container(
                                    width: width * 0.18,
                                    height: width * 0.18,
                                    color: Colors.grey.shade300,
                                  ),
                                );
                              },
                              errorBuilder: (_, __, ___) => Container(
                                width: width * 0.18,
                                height: width * 0.18,
                                color: Colors.grey.shade300,
                                child: const Icon(Icons.person),
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.005),
                          Text(
                            cast.name,
                            style: TextStyle(
                                color: shineWhite,
                                fontSize: width * 0.03),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            cast.character,
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: width * 0.025),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: height * 0.03),

              ///  CREW
              Text(
                "Crew:",
                style: TextStyle(
                    color: shineWhite,
                    fontSize: width * 0.045,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: height * 0.01),

              SizedBox(
                height: height * 0.18,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: movie.crew.length,
                  itemBuilder: (context, index) {
                    final crew = movie.crew[index];
                    return Container(
                      width: width * 0.2,
                      margin: EdgeInsets.only(right: width * 0.03),
                      child: Column(
                        children: [
                          /// 👥 CREW AVATAR SHIMMER
                          CustomShimmer(
                            child: Container(
                              width: width * 0.18,
                              height: width * 0.18,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.005),
                          Text(
                            crew.name,
                            style: TextStyle(
                                color: shineWhite,
                                fontSize: width * 0.03),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            crew.job,
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: width * 0.025),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: height * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}
