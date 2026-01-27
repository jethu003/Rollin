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


// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:rollin_user/presentation/resourses/app_colours.dart';
// import 'package:rollin_user/presentation/screens/cinemas/theatre_search.dart';
// import 'package:rollin_user/presentation/widgets/custom_shimmer.dart';
// import 'theatre_detailpage.dart';

// class CinemasPage extends StatefulWidget {
//   const CinemasPage({super.key});

//   @override
//   State<CinemasPage> createState() => _CinemasPageState();
// }

// class _CinemasPageState extends State<CinemasPage> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   bool _isLoading = true;
//   List<Map<String, dynamic>> _theatres = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadTheatres();
//   }

// Future<void> _loadTheatres() async {
//   try {
//     // 1️⃣ Fetch ONLY active shows
//     final showsSnap = await _firestore
//         .collection('shows')
//         .where('status', isEqualTo: 'active')
//         .get();

//     // 2️⃣ Extract valid theatreIds safely
//     final theatreIds = showsSnap.docs
//         .map((doc) => doc.data()['theatreId'])
//         .where((id) => id != null && id is String && id.isNotEmpty)
//         .cast<String>()
//         .toSet(); // removes duplicates

//     List<Map<String, dynamic>> loaded = [];

//     // 3️⃣ Fetch theatre profiles safely
//     for (final id in theatreIds) {
//       final doc = await _firestore.collection('userprofile').doc(id).get();

//       if (!doc.exists) continue;

//       final data = doc.data();
//       if (data == null) continue;

//       loaded.add({
//         'id': id,
//         'name': data['name'] ?? 'Unknown Theatre',
//         'location': data['city'] ?? '',
//         'image': (data['images'] is List && data['images'].isNotEmpty)
//             ? data['images'][0]
//             : '',
//       });
//     }

//     // 4️⃣ Update UI
//     setState(() {
//       _theatres = loaded;
//       _isLoading = false;
//     });
//   } catch (e, stack) {
//     debugPrint('❌ Failed to load theatres: $e');
//     debugPrintStack(stackTrace: stack);

//     setState(() {
//       _isLoading = false;
//     });
//   }
// }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColours.shineBlack,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: AppColours.shineBlack,
//         elevation: 0,
//         title: const Text(
//           "Cinemas",
//           style: TextStyle(color: AppColours.insideGrey),
//         ),
//         actions: [
//           GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const CinemaListPage()),
//               );
//             },
//             child: const Padding(
//               padding: EdgeInsets.fromLTRB(8, 6.9, 0, 0),
//               child: Icon(Icons.search, color: AppColours.shineWhite),
//             ),
//           ),
//         ],
//       ),

//       //  Direct shimmer in the body (no extra function)
//       body: _isLoading
//           ? ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: 6,
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: const EdgeInsets.only(bottom: 16),
//                   child: CustomShimmer(
//                     duration: const Duration(seconds: 3),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(16),
//                         color: Colors.white,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black12,
//                             blurRadius: 8,
//                             offset: const Offset(0, 4),
//                           )
//                         ],
//                       ),
//                       child: Column(
//                         children: [
//                           Container(
//                             height: 180,
//                             decoration: BoxDecoration(
//                               color: Colors.grey.shade300,
//                               borderRadius: const BorderRadius.vertical(
//                                   top: Radius.circular(16)),
//                             ),
//                           ),
//                           Container(
//                             height: 50,
//                             decoration: const BoxDecoration(
//                               color: Color(0xFFFBEEDB),
//                               borderRadius: BorderRadius.vertical(
//                                   bottom: Radius.circular(16)),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             )
//           : ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: _theatres.length,
//               itemBuilder: (context, index) {
//                 final theatre = _theatres[index];
//                 final image = theatre['image'].isNotEmpty
//                     ? theatre['image']
//                     : "https://via.placeholder.com/400x200";

//                 return GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => TheatreDetailsPage(
//                           theatreId: theatre['id'],
//                           theatreName: theatre['name'],
//                           image: image,
//                           location: theatre['location'],
//                         ),
//                       ),
//                     );
//                   },
//                   child: Container(
//                     margin: const EdgeInsets.only(bottom: 16),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(16),
//                       color: Colors.white,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black12,
//                           blurRadius: 8,
//                           offset: const Offset(0, 4),
//                         )
//                       ],
//                     ),
//                     child: Column(
//                       children: [
//                         ClipRRect(
//                           borderRadius: const BorderRadius.vertical(
//                               top: Radius.circular(16)),
//                           child: Image.network(
//                             image,
//                             height: 180,
//                             width: double.infinity,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         Container(
//                           padding: const EdgeInsets.all(12),
//                           decoration: const BoxDecoration(
//                             color: Color(0xFFFBEEDB),
//                             borderRadius: BorderRadius.vertical(
//                                 bottom: Radius.circular(16)),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   theatre['name'],
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                               ),
//                               const Icon(Icons.keyboard_arrow_down)
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }