
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:rollin_user/data/repositories/theatre_detail.dart';
import 'package:rollin_user/presentation/bloc/theatre_details/theatre_details_bloc.dart';
import 'package:rollin_user/presentation/bloc/theatre_details/theatre_details_event.dart';
import 'package:rollin_user/presentation/bloc/theatre_details/theatre_details_state.dart';

import 'package:rollin_user/presentation/resourses/app_colours.dart';
import 'package:rollin_user/presentation/widgets/custom_shimmer.dart';
import 'live_screen_layout.dart';

class TheatreDetailsPage extends StatelessWidget {
  final String theatreId;
  final String theatreName;
  final String location;
  final String image;

  const TheatreDetailsPage({
    super.key,
    required this.theatreId,
    required this.theatreName,
    required this.location,
    required this.image,
  });

  List<DateTime> get _nextDays =>
      List.generate(3, (i) => DateTime.now().add(Duration(days: i)));

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;

    return BlocProvider(
      create: (_) => TheatreDetailsBloc(
        TheatreRepository(FirebaseFirestore.instance),
        MovieRepository(FirebaseFirestore.instance),
      )..add(LoadShows(theatreId)),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocBuilder<TheatreDetailsBloc, TheatreDetailsState>(
            builder: (context, state) {
              if (state is TheatreLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.red),
                );
              }

              if (state is TheatreLoaded) {
                return _buildUI(context, state, width);
              }

              return const Center(
                child: Text('Error loading shows'),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildUI(
      BuildContext context, TheatreLoaded state, double width) {
    final dateStr =
        DateFormat('yyyy-MM-dd').format(state.selectedDate);

    final showsForDate = state.shows
        .where((doc) => doc['date'] == dateStr)
        .toList();

    final Map<String,
        List<QueryDocumentSnapshot<Map<String, dynamic>>>> grouped = {};

    for (var doc in showsForDate) {
      final title = doc['movieTitle'];
      grouped.putIfAbsent(title, () => []);
      grouped[title]!.add(doc);
    }

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        /// APP BAR
        SliverAppBar(
          expandedHeight: 220,
          pinned: true,
          backgroundColor: Colors.black,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                CustomShimmer(
                  child: CachedNetworkImage(
                    imageUrl: image.isNotEmpty
                        ? image
                        : 'https://via.placeholder.com/400x200.png',
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        Container(color: Colors.grey.shade300),
                    errorWidget: (_, __, ___) =>
                        Container(color: Colors.grey.shade300),
                  ),
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                  child: Container(
                    color: Colors.black.withOpacity(0.35),
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 20,
                  child: Text(
                    theatreName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        /// DATE SELECTOR
        SliverToBoxAdapter(
          child: Container(
            color: AppColours.shineBlack,
            height: width * 0.20,
            padding: EdgeInsets.only(top: width * 0.02),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _nextDays.length,
              itemBuilder: (context, i) {
                final date = _nextDays[i];
                final isSelected =
                    DateUtils.isSameDay(date, state.selectedDate);

                return GestureDetector(
                  onTap: () => context
                      .read<TheatreDetailsBloc>()
                      .add(ChangeDate(date)),
                  child: Container(
                    width: width * 0.28,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? Colors.yellow[100] : Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: isSelected
                              ? AppColours.primaryColor
                              : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(DateFormat('MMM').format(date)),
                        Text(
                          DateFormat('dd').format(date),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          i == 0
                              ? 'Today'
                              : i == 1
                                  ? 'Tomorrow'
                                  : DateFormat('E').format(date),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        /// EMPTY STATE
        if (grouped.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.movie_filter_outlined,
                    size: width * 0.18,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No movies available',
                    style: TextStyle(
                      fontSize: width * 0.045,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Please select another date',
                    style: TextStyle(
                      fontSize: width * 0.035,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          /// MOVIE LIST
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final movieTitle = grouped.keys.elementAt(index);
                final showDocs = grouped[movieTitle]!;

                final movieId = showDocs.first.data()['movieId'];
                final movie = state.movies[movieId];

                final poster =
                    movie?['posterUrl'] ??
                    showDocs.first.data()['posterUrl'] ??
                    '';

                final genres =
                    (movie?['genres'] as List?)?.join(', ') ?? '—';

                final duration =
                    movie?['runtime'] != null
                        ? '${movie!['runtime']} min'
                        : '—';

                final certificate =
                    movie?['certificate'] ?? 'UA';

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: CachedNetworkImage(
                              imageUrl: poster.isNotEmpty
                                  ? poster
                                  : 'https://via.placeholder.com/100x150.png',
                              width: 80,
                              height: 110,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movieTitle,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$certificate • $genres',
                                  style: TextStyle(
                                    fontSize: width * 0.035,
                                    color: Colors.black54,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 8,
                        children: showDocs.map((doc) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SeatLayoutPage(
                                    theatreId: theatreId,
                                    showId: doc.id,
                                    movieTitle: movieTitle,
                                    showTime: doc['time'],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(8),
                                border: Border.all(
                                    color: Colors.grey.shade400),
                              ),
                              child: Text(
                                doc['time'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      Divider(color: Colors.grey.shade300),
                    ],
                  ),
                );
              },
              childCount: grouped.length,
            ),
          ),
      ],
    );
  }
}


// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:rollin_user/data/repositories/theatre_detail.dart';
// import 'package:rollin_user/presentation/bloc/theatre_details/theatre_details_bloc.dart';
// import 'package:rollin_user/presentation/bloc/theatre_details/theatre_details_event.dart';
// import 'package:rollin_user/presentation/bloc/theatre_details/theatre_details_state.dart';

// import 'package:rollin_user/presentation/resourses/app_colours.dart';
// import 'package:rollin_user/presentation/widgets/custom_shimmer.dart';
// import 'live_screen_layout.dart';

// class TheatreDetailsPage extends StatelessWidget {
//   final String theatreId;
//   final String theatreName;
//   final String location;
//   final String image;

//   const TheatreDetailsPage({
//     super.key,
//     required this.theatreId,
//     required this.theatreName,
//     required this.location,
//     required this.image,
//   });

//   List<DateTime> get _nextDays =>
//       List.generate(3, (i) => DateTime.now().add(Duration(days: i)));

//   @override
//   Widget build(BuildContext context) {
//     final media = MediaQuery.of(context);
//     final width = media.size.width;

//     return BlocProvider(
//       create: (_) => TheatreDetailsBloc(
//         TheatreRepository(FirebaseFirestore.instance),
//       )..add(LoadShows(theatreId)),
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: SafeArea(
//           child: BlocBuilder<TheatreDetailsBloc, TheatreDetailsState>(
//             builder: (context, state) {
//               if (state is TheatreLoading) {
//                 return const Center(
//                   child: CircularProgressIndicator(color: Colors.red),
//                 );
//               }

//               if (state is TheatreLoaded) {
//                 return _buildUI(context, state, width);
//               }

//               return const Center(
//                 child: Text('Error loading shows'),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildUI(
//       BuildContext context, TheatreLoaded state, double width) {
//     final dateStr =
//         DateFormat('yyyy-MM-dd').format(state.selectedDate);

//     final showsForDate = state.shows
//         .where((doc) => doc['date'] == dateStr)
//         .toList();

//     final Map<String,
//         List<QueryDocumentSnapshot<Map<String, dynamic>>>> grouped = {};

//     for (var doc in showsForDate) {
//       final title = doc['movieTitle'];
//       grouped.putIfAbsent(title, () => []);
//       grouped[title]!.add(doc);
//     }

//     return CustomScrollView(
//       physics: const BouncingScrollPhysics(),
//       slivers: [
//         ///  APP BAR
//         SliverAppBar(
//           expandedHeight: 220,
//           pinned: true,
//           backgroundColor: Colors.black,
//           flexibleSpace: FlexibleSpaceBar(
//             background: Stack(
//               fit: StackFit.expand,
//               children: [
//                 CustomShimmer(
//                   child: CachedNetworkImage(
//                     imageUrl: image.isNotEmpty
//                         ? image
//                         : 'https://via.placeholder.com/400x200.png',
//                     fit: BoxFit.cover,
//                     placeholder: (_, __) =>
//                         Container(color: Colors.grey.shade300),
//                     errorWidget: (_, __, ___) =>
//                         Container(color: Colors.grey.shade300),
//                   ),
//                 ),
//                 BackdropFilter(
//                   filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
//                   child: Container(
//                     color: Colors.black.withOpacity(0.35),
//                   ),
//                 ),
//                 Positioned(
//                   left: 16,
//                   bottom: 20,
//                   child: Text(
//                     theatreName,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 22,
//                       fontWeight: FontWeight.w600,
//                       shadows: [
//                         Shadow(
//                           color: Colors.black54,
//                           blurRadius: 6,
//                           offset: Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),

//         /// DATE SELECTOR
//         SliverToBoxAdapter(
//           child: Container(
//             color: AppColours.shineBlack,
//             height: width * 0.20,
//             padding: EdgeInsets.only(top: width * 0.02),
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: _nextDays.length,
//               itemBuilder: (context, i) {
//                 final date = _nextDays[i];
//                 final isSelected =
//                     DateUtils.isSameDay(date, state.selectedDate);

//                 return GestureDetector(
//                   onTap: () => context
//                       .read<TheatreDetailsBloc>()
//                       .add(ChangeDate(date)),
//                   child: Container(
//                     width: width * 0.28,
//                     margin: const EdgeInsets.symmetric(horizontal: 6),
//                     decoration: BoxDecoration(
//                       color:
//                           isSelected ? Colors.yellow[100] : Colors.white,
//                       border: Border(
//                         bottom: BorderSide(
//                           color: isSelected
//                               ? AppColours.primaryColor
//                               : Colors.grey.shade300,
//                           width: isSelected ? 2 : 1,
//                         ),
//                       ),
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(DateFormat('MMM').format(date)),
//                         Text(
//                           DateFormat('dd').format(date),
//                           style: const TextStyle(
//                               fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           i == 0
//                               ? 'Today'
//                               : i == 1
//                                   ? 'Tomorrow'
//                                   : DateFormat('E').format(date),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),

//         /// 🚫 EMPTY STATE
//         if (grouped.isEmpty)
//           SliverFillRemaining(
//             hasScrollBody: false,
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.movie_filter_outlined,
//                     size: width * 0.18,
//                     color: Colors.grey.shade400,
//                   ),
//                   const SizedBox(height: 12),
//                   Text(
//                     'No movies available',
//                     style: TextStyle(
//                       fontSize: width * 0.045,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     'Please select another date',
//                     style: TextStyle(
//                       fontSize: width * 0.035,
//                       color: Colors.grey.shade500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           )

//         /// 🎥 MOVIE LIST
//         else
//           SliverList(
//             delegate: SliverChildBuilderDelegate(
//               (context, index) {
//                 final movieTitle = grouped.keys.elementAt(index);
//                 final showDocs = grouped[movieTitle]!;
//                 final poster = showDocs.first['posterUrl'] ?? '';

//                 // ✅ OLD SAFE STATIC VALUES (NO FIRESTORE ACCESS)
//                 const genre = 'Comedy, Horror, Thriller';
//                 const duration = '2h 30m';
//                 const certificate = 'UA 16+';

//                 return Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 16, vertical: 10),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(6),
//                             child: CachedNetworkImage(
//                               imageUrl: poster.isNotEmpty
//                                   ? poster
//                                   : 'https://via.placeholder.com/100x150.png',
//                               width: 80,
//                               height: 110,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment:
//                                   CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   movieTitle,
//                                   style: const TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   '$certificate • $genre\n$duration',
//                                   style: TextStyle(
//                                     fontSize: width * 0.035,
//                                     color: Colors.black54,
//                                     height: 1.3,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 12),
//                       Wrap(
//                         spacing: 10,
//                         runSpacing: 8,
//                         children: showDocs.map((doc) {
//                           return GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) => SeatLayoutPage(
//                                     theatreId: theatreId,
//                                     showId: doc.id,
//                                     movieTitle: movieTitle,
//                                     showTime: doc['time'],
//                                   ),
//                                 ),
//                               );
//                             },
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 8, horizontal: 12),
//                               decoration: BoxDecoration(
//                                 borderRadius:
//                                     BorderRadius.circular(8),
//                                 border: Border.all(
//                                     color: Colors.grey.shade400),
//                               ),
//                               child: Text(
//                                 doc['time'],
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.w600),
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                       const SizedBox(height: 16),
//                       Divider(color: Colors.grey.shade300),
//                     ],
//                   ),
//                 );
//               },
//               childCount: grouped.length,
//             ),
//           ),
//       ],
//     );
//   }
// }



// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:rollin_user/data/repositories/theatre_detail.dart';
// import 'package:rollin_user/presentation/bloc/theatre_details/theatre_details_bloc.dart';
// import 'package:rollin_user/presentation/bloc/theatre_details/theatre_details_event.dart';
// import 'package:rollin_user/presentation/bloc/theatre_details/theatre_details_state.dart';

// import 'package:rollin_user/presentation/resourses/app_colours.dart';
// import 'package:rollin_user/presentation/widgets/custom_shimmer.dart';
// import 'live_screen_layout.dart';

// class TheatreDetailsPage extends StatelessWidget {
//   final String theatreId;
//   final String theatreName;
//   final String location;
//   final String image;

//   const TheatreDetailsPage({
//     super.key,
//     required this.theatreId,
//     required this.theatreName,
//     required this.location,
//     required this.image,
//   });

//   List<DateTime> get _nextDays =>
//       List.generate(3, (i) => DateTime.now().add(Duration(days: i)));

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => TheatreDetailsBloc(
//         TheatreRepository(FirebaseFirestore.instance),
//       )..add(LoadShows(theatreId)),
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: SafeArea(
//           child: BlocBuilder<TheatreDetailsBloc, TheatreDetailsState>(
//             builder: (context, state) {
//               if (state is TheatreLoading) {
//                 return const Center(
//                   child: CircularProgressIndicator(color: Colors.red),
//                 );
//               }

//               if (state is TheatreLoaded) {
//                 return _buildUI(context, state);
//               }

//               return const Center(child: Text('Error loading shows'));
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildUI(BuildContext context, TheatreLoaded state) {
//     final width = MediaQuery.of(context).size.width;
//     final dateStr =
//         DateFormat('yyyy-MM-dd').format(state.selectedDate);

//     final showsForDate = state.shows
//         .where((doc) => doc['date'] == dateStr)
//         .toList();

//     final Map<String,
//         List<QueryDocumentSnapshot<Map<String, dynamic>>>> grouped = {};

//     for (var doc in showsForDate) {
//       final title = doc['movieTitle'];
//       grouped.putIfAbsent(title, () => []);
//       grouped[title]!.add(doc);
//     }

//     return CustomScrollView(
//       physics: const BouncingScrollPhysics(),
//       slivers: [
       
//     SliverAppBar(
//   expandedHeight: 220,
//   pinned: true,
//   backgroundColor: Colors.black,
//   flexibleSpace: FlexibleSpaceBar(
//     background: Stack(
//       fit: StackFit.expand,
//       children: [
        
//         CustomShimmer(
//           child: CachedNetworkImage(
//             imageUrl: image.isNotEmpty
//                 ? image
//                 : 'https://via.placeholder.com/400x200.png',
//             fit: BoxFit.cover,
//             placeholder: (context, url) => Container(
//               color: Colors.grey.shade300,
//             ),
//             errorWidget: (_, __, ___) => Container(
//               color: Colors.grey.shade300,
//             ),
//           ),
//         ),

        
//         BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
//           child: Container(
//             color: Colors.black.withOpacity(0.35),
//           ),
//         ),

        
//         Positioned(
//           left: 16,
//           bottom: 20,
//           child: Text(
//             theatreName,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 22,
//               fontWeight: FontWeight.w600,
//               letterSpacing: 0.4,
//               shadows: [
//                 Shadow(
//                   color: Colors.black54,
//                   blurRadius: 6,
//                   offset: Offset(0, 2),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     ),
//   ),
// ),


        
//         SliverToBoxAdapter(
//           child: Container(
//             color: AppColours.shineBlack,
//             height: width * 0.20,
//             padding: EdgeInsets.only(top: width * 0.02),
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: _nextDays.length,
//               itemBuilder: (context, i) {
//                 final date = _nextDays[i];
//                 final isSelected =
//                     DateUtils.isSameDay(date, state.selectedDate);

//                 return GestureDetector(
//                   onTap: () => context
//                       .read<TheatreDetailsBloc>()
//                       .add(ChangeDate(date)),
//                   child: Container(
//                     width: width * 0.28,
//                     margin: const EdgeInsets.symmetric(horizontal: 6),
//                     decoration: BoxDecoration(
//                       color: isSelected
//                           ? Colors.yellow[100]
//                           : Colors.white,
//                       border: Border(
//                         bottom: BorderSide(
//                           color: isSelected
//                               ? AppColours.primaryColor
//                               : Colors.grey.shade300,
//                           width: isSelected ? 2 : 1,
//                         ),
//                       ),
//                     ),
//                     child: FittedBox(
//                       fit: BoxFit.scaleDown,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(DateFormat('MMM').format(date)),
//                           Text(
//                             DateFormat('dd').format(date),
//                             style: const TextStyle(
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           Text(i == 0
//                               ? 'Today'
//                               : i == 1
//                                   ? 'Tomorrow'
//                                   : DateFormat('E').format(date)),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),

        
//         SliverList(
//           delegate: SliverChildBuilderDelegate(
//             (context, index) {
//               final movieTitle = grouped.keys.elementAt(index);
//               final showDocs = grouped[movieTitle]!;
//               final poster = showDocs.first['posterUrl'] ?? '';
//               final duration = '2h 30m';
//               final genre = 'Comedy, Horror, Thriller';

//               return Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(6),
//                           child: CachedNetworkImage(
//                             imageUrl: poster.isNotEmpty
//                                 ? poster
//                                 : 'https://via.placeholder.com/100x150.png',
//                             width: 80,
//                             height: 110,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 movieTitle,
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 'UA 16+ • $genre\n$duration',
//                                 style: const TextStyle(
//                                   color: Colors.black54,
//                                   height: 1.3,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 12),
//                     Wrap(
//                       spacing: 10,
//                       runSpacing: 8,
//                       children: showDocs.map((doc) {
//                         return GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => SeatLayoutPage(
//                                   theatreId: theatreId,
//                                   showId: doc.id,
//                                   movieTitle: movieTitle,
//                                   showTime: doc['time'],
//                                 ),
//                               ),
//                             );
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 8, horizontal: 12),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8),
//                               border: Border.all(
//                                   color: Colors.grey.shade400),
//                             ),
//                             child: Column(
//                               children: [
//                                 const Text(
//                                   'HINDI',
//                                   style: TextStyle(
//                                       fontSize: 12,
//                                       color: Colors.black54),
//                                 ),
//                                 Text(
//                                   doc['time'],
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                     const SizedBox(height: 16),
//                     Divider(color: Colors.grey.shade300),
//                   ],
//                 ),
//               );
//             },
//             childCount: grouped.length,
//           ),
//         ),
//       ],
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:rollin_user/presentation/resourses/app_colours.dart';
// import 'package:rollin_user/presentation/screens/cinemas/live_screen_layout.dart';


// class TheatreDetailsPage extends StatefulWidget {
//   final String theatreId;
//   final String theatreName;
//   final String location;
//   final String image;

//   const TheatreDetailsPage({
//     super.key,
//     required this.theatreId,
//     required this.theatreName,
//     required this.location,
//     required this.image,
//   });

//   @override
//   State<TheatreDetailsPage> createState() => _TheatreDetailsPageState();
// }

// class _TheatreDetailsPageState extends State<TheatreDetailsPage> {
//   DateTime _selectedDate = DateTime.now();
//   List<QueryDocumentSnapshot<Map<String, dynamic>>> _shows = [];
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchShows();
//   }
  
//   Future<void> _fetchShows() async {
//     try {
//       final snap = await FirebaseFirestore.instance
//           .collection('shows')
//           .where('theatreId', isEqualTo: widget.theatreId)
//           .get();

//       if (mounted) {
//         setState(() {
//           _shows = snap.docs;
//           _loading = false;
//         });
//       }
//     } catch (e) {
//       debugPrint('Error fetching shows: $e');
//       if (mounted) setState(() => _loading = false);
//     }
//   }

//   List<DateTime> get _nextDays =>
//       List.generate(3, (i) => DateTime.now().add(Duration(days: i)));

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;

//     final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
//     final showsForDate =
//         _shows.where((doc) => doc['date'] == dateStr).toList();

//     final Map<String, List<QueryDocumentSnapshot<Map<String, dynamic>>>> grouped =
//         {};
//     for (var doc in showsForDate) {
//       final title = doc['movieTitle'];
//       grouped.putIfAbsent(title, () => []);
//       grouped[title]!.add(doc);
//     }

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: _loading
//             ? const Center(child: CircularProgressIndicator(color: Colors.red))
//             : CustomScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 slivers: [
//                   //  App Bar
//                   SliverAppBar(
//                     expandedHeight: 220,
//                     pinned: true,
//                     backgroundColor: Colors.black,
//                     flexibleSpace: FlexibleSpaceBar(
//                       title: Text(widget.theatreName),
//                       background: CachedNetworkImage(
//                         imageUrl: widget.image.isNotEmpty
//                             ? widget.image
//                             : 'https://via.placeholder.com/400x200.png?text=No+Image',
//                         fit: BoxFit.cover,
//                         placeholder: (context, url) => const Center(
//                           child: CircularProgressIndicator(color: Colors.red),
//                         ),
//                         errorWidget: (context, url, error) => Container(
//                           color: Colors.black26,
//                           child: const Icon(Icons.broken_image,
//                               color: Colors.white, size: 50),
//                         ),
//                       ),
//                     ),
//                   ),

//                   //  Date Tabs
//                   SliverToBoxAdapter(
//                     child: Container(
//                       color: AppColours.shineBlack,
//                       height: width * 0.20,
//                       padding: EdgeInsets.only(top: width * 0.02),
//                       child: ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         itemCount: _nextDays.length,
//                         itemBuilder: (context, i) {
//                           final date = _nextDays[i];
//                           final isSelected =
//                               DateUtils.isSameDay(date, _selectedDate);
//                           final label = DateFormat('dd').format(date);
//                           final month = DateFormat('MMM').format(date);
//                           final day = DateFormat('E').format(date);
//                           final suffix =
//                               i == 0 ? 'Today' : i == 1 ? 'Tomorrow' : day;

//                           return GestureDetector(
//                             onTap: () => setState(() => _selectedDate = date),
//                             child: Container(
//                               width: width * 0.28,
//                               margin:
//                                   const EdgeInsets.symmetric(horizontal: 6),
//                               decoration: BoxDecoration(
//                                 color: isSelected
//                                     ? Colors.yellow[100]
//                                     : Colors.white,
//                                 border: Border(
//                                   bottom: BorderSide(
//                                     color: isSelected
//                                         ? AppColours.primaryColor
//                                         : Colors.grey.shade300,
//                                     width: isSelected ? 2 : 1,
//                                   ),
//                                 ),
//                               ),
//                               child: FittedBox(
//                                 fit: BoxFit.scaleDown,
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Text(
//                                       month,
//                                       style: TextStyle(
//                                         fontSize: width * 0.035,
//                                         color: Colors.black54,
//                                       ),
//                                     ),
//                                     Text(
//                                       label,
//                                       style: TextStyle(
//                                         fontSize: width * 0.05,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                     Text(
//                                       suffix,
//                                       style: TextStyle(
//                                         fontSize: width * 0.033,
//                                         color: Colors.grey.shade700,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),

//                   // 🎬 Movies and shows
//                   SliverList(
//                     delegate: SliverChildBuilderDelegate(
//                       (context, index) {
//                         final movieTitle = grouped.keys.elementAt(index);
//                         final showDocs = grouped[movieTitle]!;
//                         final moviePoster = showDocs.first['posterUrl'] ?? '';
//                         final duration = '2h 30m';
//                         final genre = 'Comedy, Horror, Thriller';

//                         return Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 16.0, vertical: 10),
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               // 🎞 Movie info
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   ClipRRect(
//                                     borderRadius: BorderRadius.circular(6),
//                                     child: CachedNetworkImage(
//                                       imageUrl: moviePoster.isNotEmpty
//                                           ? moviePoster
//                                           : 'https://via.placeholder.com/100x150.png?text=No+Poster',
//                                       width: 80,
//                                       height: 110,
//                                       fit: BoxFit.cover,
//                                       placeholder: (context, url) => Container(
//                                         width: 80,
//                                         height: 110,
//                                         color: Colors.grey.shade200,
//                                         child: const Center(
//                                           child: CircularProgressIndicator(
//                                             strokeWidth: 2,
//                                           ),
//                                         ),
//                                       ),
//                                       errorWidget: (context, url, error) =>
//                                           Container(
//                                         width: 80,
//                                         height: 110,
//                                         color: Colors.grey.shade300,
//                                         child: const Icon(Icons.broken_image),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 10),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         Text(
//                                           movieTitle,
//                                           style: const TextStyle(
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.black,
//                                           ),
//                                         ),
//                                         const SizedBox(height: 4),
//                                         Text(
//                                           'UA 16+ • $genre\n$duration',
//                                           style: const TextStyle(
//                                             color: Colors.black54,
//                                             height: 1.3,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),

//                               const SizedBox(height: 12),

                              
//                               Wrap(
//                                 spacing: 10,
//                                 runSpacing: 8,
//                                 children: showDocs.map((doc) {
//                                   final showTime = doc['time'];
//                                   final showId = doc.id;

//                                   return GestureDetector(
//                                     onTap: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) => SeatLayoutPage(
//                                             theatreId: widget.theatreId,
//                                             showId: showId,
//                                             movieTitle: movieTitle,
//                                             showTime: showTime,
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                     child: Container(
//                                       padding: const EdgeInsets.symmetric(
//                                           vertical: 8, horizontal: 12),
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(8),
//                                         border: Border.all(
//                                             color: Colors.grey.shade400),
//                                       ),
//                                       child: Column(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           const Text(
//                                             "HINDI",
//                                             style: TextStyle(
//                                               color: Colors.black54,
//                                               fontSize: 12,
//                                             ),
//                                           ),
//                                           Text(
//                                             showTime,
//                                             style: const TextStyle(
//                                               fontWeight: FontWeight.w600,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   );
//                                 }).toList(),
//                               ),

//                               const SizedBox(height: 16),
//                               Divider(color: Colors.grey.shade300),
//                             ],
//                           ),
//                         );
//                       },
//                       childCount: grouped.length,
//                     ),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }
// }