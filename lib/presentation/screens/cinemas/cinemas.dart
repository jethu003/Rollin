import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rollin_user/presentation/resourses/app_colours.dart';
import 'package:rollin_user/presentation/screens/cinemas/theatre_search.dart';
import 'package:rollin_user/presentation/widgets/custom_shimmer.dart';
import 'theatre_detailpage.dart';

class CinemasPage extends StatefulWidget {
  const CinemasPage({super.key});

  @override
  State<CinemasPage> createState() => _CinemasPageState();
}

class _CinemasPageState extends State<CinemasPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = true;
  List<Map<String, dynamic>> _theatres = [];

  @override
  void initState() {
    super.initState();
    _loadTheatres();
  }

  Future<void> _loadTheatres() async {
    try {
      final showsSnap = await _firestore.collection('shows').get();
      final theatreIds = showsSnap.docs
          .map((doc) => doc['theatreId'])
          .whereType<String>()
          .toSet()
          .toList();

      List<Map<String, dynamic>> loaded = [];
      for (var id in theatreIds) {
        final doc = await _firestore.collection('userprofile').doc(id).get();
        if (doc.exists) {
          final data = doc.data()!;
          loaded.add({
            'id': id,
            'name': data['name'] ?? 'Unknown',
            'location': data['city'] ?? '',
            'image': (data['images'] as List?)?.first ?? '',
          });
        }
      }

      setState(() {
        _theatres = loaded;
        _isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() => _isLoading = false);
    }
  }

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
              padding: EdgeInsets.fromLTRB(8, 6.9, 0, 0),
              child: Icon(Icons.search, color: AppColours.shineWhite),
            ),
          ),
        ],
      ),

      // 🔹 Direct shimmer in the body (no extra function)
      body: _isLoading
          ? ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 6,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: CustomShimmer(
                    duration: const Duration(seconds: 3),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 180,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16)),
                            ),
                          ),
                          Container(
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFBEEDB),
                              borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(16)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _theatres.length,
              itemBuilder: (context, index) {
                final theatre = _theatres[index];
                final image = theatre['image'].isNotEmpty
                    ? theatre['image']
                    : "https://via.placeholder.com/400x200";

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TheatreDetailsPage(
                          theatreId: theatre['id'],
                          theatreName: theatre['name'],
                          image: image,
                          location: theatre['location'],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16)),
                          child: Image.network(
                            image,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFBEEDB),
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(16)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  theatre['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const Icon(Icons.keyboard_arrow_down)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:rollin_user/presentation/screens/cinemas/theatre_detailpage.dart';



// class CinemasPage extends StatefulWidget {
//   const CinemasPage({super.key});

//   @override
//   State<CinemasPage> createState() => _CinemasPageState();
// }

// class _CinemasPageState extends State<CinemasPage> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   bool _loading = true;

//   // theatreId -> movieId -> shows list
//   Map<String, Map<String, List<Map<String, dynamic>>>> _grouped = {};
//   Map<String, Map<String, dynamic>> _theatreCache = {};
//   Map<int, Map<String, dynamic>> _movieCache = {};

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   Future<void> _loadData() async {
//     setState(() => _loading = true);

//     try {
//       final showsSnap = await _firestore.collection('shows').get();

//       _grouped.clear();
//       _theatreCache.clear();
//       _movieCache.clear();

//       final shows = showsSnap.docs.map((d) {
//         final data = Map<String, dynamic>.from(d.data());
//         data['showId'] = d.id;
//         return data;
//       }).toList();

//       for (var show in shows) {
//         String theatreId = (show['theatreId'] ?? '').toString().trim();
//         if (theatreId.isEmpty) continue;

//         final movieIdRaw = show['movieId'];
//         int movieId = movieIdRaw is int
//             ? movieIdRaw
//             : int.tryParse(movieIdRaw.toString()) ?? 0;

//         if (!_theatreCache.containsKey(theatreId)) {
//           final doc = await _firestore.collection('userprofile').doc(theatreId).get();
//           _theatreCache[theatreId] = doc.exists
//               ? doc.data()!
//               : {'name': 'Unknown Theatre', 'city': ''};
//         }

//         if (movieId != 0 && !_movieCache.containsKey(movieId)) {
//           final movieDoc = await _firestore.collection('now_playing')
//               .doc(movieId.toString())
//               .get();

//           _movieCache[movieId] = movieDoc.exists
//               ? movieDoc.data()!
//               : {
//                   'title': show['movieTitle'] ?? 'Unknown Movie',
//                   'posterUrl': show['posterUrl'] ?? ''
//                 };
//         }

//         _grouped.putIfAbsent(theatreId, () => {});
//         final movieKey = movieId.toString();
//         _grouped[theatreId]!.putIfAbsent(movieKey, () => []);
//         _grouped[theatreId]![movieKey]!.add(show);
//       }
//     } catch (e) {
//       print("🔥 ERROR loading cinemas: $e");
//     }

//     if (mounted) setState(() => _loading = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_loading) {
//       return Scaffold(
//         appBar: AppBar(title: const Text("Cinemas")),
//         body: const Center(child: CircularProgressIndicator()),
//       );
//     }

//     final theatreIds = _grouped.keys.toList();

//     return Scaffold(
//       appBar: AppBar(title: const Text("Cinemas")),
//       body: RefreshIndicator(
//         onRefresh: _loadData,
//         child: ListView.builder(
//           padding: const EdgeInsets.all(16),
//           itemCount: theatreIds.length,
//           itemBuilder: (context, i) {
//             final theatreId = theatreIds[i];
//             final theatre = _theatreCache[theatreId] ?? {};

//             final theatreName = theatre['name'] ?? 'Theatre';
//             final theatreImage =
//                 (theatre['images'] is List && theatre['images'].isNotEmpty)
//                     ? theatre['images'][0]
//                     : '';

//             return Card(
//               margin: const EdgeInsets.only(bottom: 16),
//               child: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                           width: 70,
//                           height: 70,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(8),
//                             color: Colors.grey[300],
//                           ),
//                           clipBehavior: Clip.hardEdge,
//                           child: theatreImage.isNotEmpty
//                               ? Image.network(
//                                   theatreImage,
//                                   fit: BoxFit.cover,
//                                   errorBuilder: (_, __, ___) =>
//                                       Container(color: Colors.grey),
//                                 )
//                               : const Icon(Icons.movie),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: Text(
//                             theatreName,
//                             style: const TextStyle(
//                                 fontSize: 18, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => TheatreDetailsPage(
//                                   theatreId: theatreId,
//                                   theatreName: theatreName,
//                                   location: theatre['city'] ?? '',
//                                   image: theatreImage,
//                                 ),
//                               ),
//                             );
//                           },
//                           child: const Text("Open"),
//                         )
//                       ],
//                     ),

//                     const SizedBox(height: 14),

//                     ..._grouped[theatreId]!.keys.map((movieKey) {
//                       final movieId = int.tryParse(movieKey) ?? 0;
//                       final movie = _movieCache[movieId] ?? {};
//                       final movieTitle =
//                           movie['title'] ?? movie['name'] ?? 'Movie';
//                       final poster = movie['posterUrl'] ?? movie['poster'] ?? "";

//                       final shows = _grouped[theatreId]![movieKey]!;

//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Container(
//                                 width: 50,
//                                 height: 70,
//                                 clipBehavior: Clip.hardEdge,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(6),
//                                   color: Colors.grey[300],
//                                 ),
//                                 child: poster.isNotEmpty
//                                     ? Image.network(
//                                         poster,
//                                         fit: BoxFit.cover,
//                                         errorBuilder: (_, __, ___) =>
//                                             Container(color: Colors.grey),
//                                       )
//                                     : const Icon(Icons.image),
//                               ),
//                               const SizedBox(width: 10),
//                               Expanded(
//                                 child: Text(
//                                   movieTitle,
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 8),

//                           Wrap(
//                             spacing: 8,
//                             runSpacing: 6,
//                             children: shows.map((s) {
//                               final time = s['time'] ?? '';
//                               return ActionChip(
//                                 label: Text(time.toString()),
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (_) => TheatreDetailsPage(
//                                         theatreId: theatreId,
//                                         theatreName: theatreName,
//                                         location: theatre['city'] ?? '',
//                                         image: theatreImage,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               );
//                             }).toList(),
//                           ),

//                           const SizedBox(height: 20),
//                         ],
//                       );
//                     }),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

