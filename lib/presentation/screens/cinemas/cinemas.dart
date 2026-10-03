import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rollin_user/data/datasources/cinemas_datasource.dart';
import 'package:rollin_user/data/repositories/cinemas_repoimpl.dart';
import 'package:rollin_user/domain/usecases/cinemas_usecase.dart';
import 'package:rollin_user/presentation/bloc/cinemas/cinemas_bloc.dart';
import 'package:rollin_user/presentation/bloc/cinemas/cinemas_event.dart';
import 'package:rollin_user/presentation/bloc/cinemas/cinemas_state.dart';
import 'package:rollin_user/presentation/resourses/app_colours.dart';
import 'package:rollin_user/presentation/widgets/custom_shimmer.dart';
import 'package:rollin_user/presentation/screens/cinemas/theatre_search.dart';
import 'package:rollin_user/presentation/screens/cinemas/theatre_detailpage.dart';

class CinemasPage extends StatelessWidget {
  const CinemasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CinemaBloc(
        GetCinemas(
          CinemaRepositoryImpl(
            CinemaRemoteDataSourceImpl(FirebaseFirestore.instance),
          ),
        ),
      )..add(LoadCinemas()),
      child: const _CinemasView(),
    );
  }
}

class _CinemasView extends StatelessWidget {
  const _CinemasView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.shineBlack,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColours.shineBlack,
        elevation: 0,
        title: const Text(
          "Cinemas",
          style: TextStyle(color: AppColours.shineWhite),
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
              padding: EdgeInsets.fromLTRB(8, 6.9, 15, 2),
              child: Icon(Icons.search_rounded, color: AppColours.shineWhite),
            ),
          ),
        ],
      ),
      body: BlocBuilder<CinemaBloc, CinemaState>(
        builder: (context, state) {
          if (state is CinemaLoading) {
            return _buildShimmer();
          }

          if (state is CinemaLoaded) {
            if (state.cinemas.isEmpty) {
              return const Center(
                child: Text(
                  "No cinemas found",
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }
            return _buildCinemaList(context, state.cinemas);
          }

          if (state is CinemaError) {
            return Center(
              child: Text(
                'hello',
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  //  SHIMMER LOADING UI
  Widget _buildShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: CustomShimmer(
            duration: const Duration(seconds: 2),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFBEEDB),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  //  CINEMA LIST WITH IMAGE PLACEHOLDER
  Widget _buildCinemaList(BuildContext context, List cinemas) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: cinemas.length,
      itemBuilder: (context, index) {
        final cinema = cinemas[index];
        final image = cinema.image.isNotEmpty
            ? cinema.image
            : "https://via.placeholder.com/400x200";

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TheatreDetailsPage(
                  theatreId: cinema.id,
                  theatreName: cinema.name,
                  image: image,
                  location: cinema.location,
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.network(
                    image,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,

                    //  PLACEHOLDER WHILE LOADING
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return CustomShimmer(
                        duration: const Duration(seconds: 2),
                        child: Container(
                          height: 180,
                          color: Colors.grey.shade300,
                        ),
                      );
                    },

                    //  FALLBACK IF IMAGE FAILS
                    errorBuilder: (_, __, ___) => Container(
                      height: 180,
                      color: Colors.grey.shade300,
                      child: const Icon(
                        Icons.broken_image,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFBEEDB),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          cinema.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


