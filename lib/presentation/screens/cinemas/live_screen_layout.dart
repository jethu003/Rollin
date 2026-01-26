import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'checkoutpage.dart';



class SeatLayoutPage extends StatefulWidget {
  final String theatreId;
  final String showId;
  final String movieTitle;
  final String showTime;

  const SeatLayoutPage({
    super.key,
    required this.theatreId,
    required this.showId,
    required this.movieTitle,
    required this.showTime,
  });

  @override
  State<SeatLayoutPage> createState() => _SeatLayoutPageState();
}

class _SeatLayoutPageState extends State<SeatLayoutPage> {
  late final SeatLayoutController controller;

  @override
  void initState() {
    super.initState();
    controller = SeatLayoutController(
      firestore: FirebaseFirestore.instance,
      showId: widget.showId,
    );

    controller.startListening(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String rowLabel(int index) {
    String result = '';
    while (index >= 0) {
      result = String.fromCharCode(65 + index % 26) + result;
      index = (index ~/ 26) - 1;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final layoutData = controller.layoutData;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  iconSize: 22,
                  onPressed: () {
                   Navigator.pop(context);
                  },
                ),
        backgroundColor: Colors.white,
        title: Text(
          "${widget.movieTitle} • ${widget.showTime}",
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
         SizedBox(height: 20,),
    Container(
      height: 6, 
      margin: const EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(4),
      ),
    ),

    const SizedBox(height: 8),

    // SCREEN text
    const Text(
      'SCREEN',
      style: TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      ),
    ),

          Expanded(
            child: layoutData == null
                ? const Center(child: CircularProgressIndicator())
                : InteractiveViewer(
                    constrained: false,
                    boundaryMargin: const EdgeInsets.all(200),
                    minScale: 0.6,
                    maxScale: 2.5,
                    child: Column(
                      children:
                          controller.tiers.asMap().entries.map((tierEntry) {
                        final tierIndex = tierEntry.key;
                        final tier = tierEntry.value;
                        final tierLayout = Map<String, dynamic>.from(
                          layoutData['tier_$tierIndex'] ?? {},
                        );

                        final rows =
                            tier['rows'] ?? tierLayout.length;
                        final colPartitions =
                            List<int>.from(tier['colPartitions'] ?? []);

                        return Padding(
                          padding:
                              const EdgeInsets.symmetric(vertical: 12),
                          child: Column(
                            children: [
                              Text(
                                "${tier['tierName']} – ₹${tier['price']}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),

                              ...List.generate(rows, (r) {
                                final label = rowLabel(r);
                                final seats = List<String>.from(
                                    tierLayout['row_$r'] ?? []);

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 25,
                                        child: Text(label),
                                      ),
                                      const SizedBox(width: 8),
                                      ...seats
                                          .asMap()
                                          .entries
                                          .expand((e) {
                                        final col = e.key;
                                        final seatId =
                                            "tier_$tierIndex-$label${col + 1}";

                                        final widgets = <Widget>[];

                                        if (colPartitions.contains(col)) {
                                          widgets.add(
                                              const SizedBox(width: 20));
                                        }

                                        widgets.add(
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                controller.toggleSeat(
                                                  seatId,
                                                  () =>
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          "Maximum 5 seats allowed"),
                                                    ),
                                                  ),
                                                );
                                              });
                                            },
                                            child: Container(
                                              width: 28,
                                              height: 28,
                                              margin: const EdgeInsets
                                                  .symmetric(horizontal: 3),
                                              decoration: BoxDecoration(
                                                color: controller
                                                    .seatColor(seatId),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                border: Border.all(
                                                    color:
                                                        Colors.black26),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "${col + 1}",
                                                  style: const TextStyle(
                                                      fontSize: 9),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                        return widgets;
                                      }),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
          ),

          const _Legend(),

          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: controller.selectedSeats.isEmpty
                  ? null
                  : () async {
                      await controller.lockSelectedSeats();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CheckoutPage(
                            showId: widget.showId,
                            theatreId: widget.theatreId,
                            movieTitle: widget.movieTitle,
                            showTime: widget.showTime,
                            tiers: controller.tiers,
                          ),
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(
                "Continue (${controller.selectedSeats.length} seats)",
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          _LegendItem(color: Colors.white, label: "Available"),
          _LegendItem(color: Colors.amber, label: "Selected"),
          _LegendItem(color: Colors.blueGrey, label: "Occupied"),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Colors.black),
          ),
        ),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}


class SeatLayoutController {
  final FirebaseFirestore firestore;
  final String showId;

  Map<String, dynamic>? layoutData;
  List<Map<String, dynamic>> tiers = [];
  Set<String> permanentSeats = {};
  Map<String, int> tempLocks = {};
  Set<String> selectedSeats = {};

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _sub;

  static const int lockDuration = 5 * 60 * 1000;

  SeatLayoutController({
    required this.firestore,
    required this.showId,
  });

  void startListening(VoidCallback onUpdate) {
    final ref = firestore.collection('shows').doc(showId);

    _sub = ref.snapshots().listen((doc) async {
      final data = doc.data();
      if (data == null) return;

      final now = DateTime.now().millisecondsSinceEpoch;

      final rawLocks = Map<String, dynamic>.from(data['tempLocks'] ?? {});
      final Map<String, int> locks = {};
      rawLocks.forEach((k, v) {
        if (v is int) {
          locks[k] = v;
        } else if (v is String) locks[k] = int.tryParse(v) ?? 0;
        else if (v is num) locks[k] = v.toInt();
      });

      final expired = locks.keys.where((k) => locks[k]! < now).toList();
      if (expired.isNotEmpty) {
        final updates = <String, dynamic>{};
        for (var k in expired) {
          updates['tempLocks.$k'] = FieldValue.delete();
        }
        try {
          await ref.update(updates);
          expired.forEach(locks.remove);
        } catch (_) {}
      }

      final booked =
          Map<String, dynamic>.from(data['bookedSeats'] ?? {}).keys.toSet();

      layoutData = Map<String, dynamic>.from(data['layout'] ?? {});
      tiers = List<Map<String, dynamic>>.from(data['tiers'] ?? []);
      permanentSeats = booked;
      tempLocks = locks;

      selectedSeats.removeWhere(
        (s) => permanentSeats.contains(s) || tempLocks.containsKey(s),
      );

      onUpdate();
    });
  }

  void dispose() {
    _sub?.cancel();
  }

  void toggleSeat(String seatId, VoidCallback onLimitReached) {
    if (permanentSeats.contains(seatId) || tempLocks.containsKey(seatId)) return;

    if (selectedSeats.contains(seatId)) {
      selectedSeats.remove(seatId);
    } else {
      if (selectedSeats.length >= 5) {
        onLimitReached();
        return;
      }
      selectedSeats.add(seatId);
    }
  }

  Future<void> lockSelectedSeats() async {
    if (selectedSeats.isEmpty) return;

    final ref = firestore.collection('shows').doc(showId);
    final expiry = DateTime.now().millisecondsSinceEpoch + lockDuration;

    final updates = <String, dynamic>{};
    for (var seat in selectedSeats) {
      updates['tempLocks.$seat'] = expiry;
    }

    await ref.update(updates);
  }

  Color seatColor(String seatId) {
    if (permanentSeats.contains(seatId) ||
        tempLocks.containsKey(seatId)) {
      return Colors.blueGrey;
    }
    if (selectedSeats.contains(seatId)) return Colors.amber;
    return Colors.white;
  }
}



















// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'checkoutpage.dart';

// class SeatLayoutPage extends StatefulWidget {
//   final String theatreId;
//   final String showId;
//   final String movieTitle;
//   final String showTime;

//   const SeatLayoutPage({
//     super.key,
//     required this.theatreId,
//     required this.showId,
//     required this.movieTitle,
//     required this.showTime,
//   });

//   @override
//   State<SeatLayoutPage> createState() => _SeatLayoutPageState();
// }

// class _SeatLayoutPageState extends State<SeatLayoutPage> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Map<String, dynamic>? layoutData;
//   List<Map<String, dynamic>> tiers = [];
//   Set<String> permanentSeats = {};
//   Map<String, int> tempLocks = {};
//   Set<String> selectedSeats = {};
//   StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _sub;

//   static const int lockDuration = 5 * 60 * 1000; // 5 minutes

//   @override
//   void initState() {
//     super.initState();
//     _listenForUpdates();
//   }

//   @override
//   void dispose() {
//     _sub?.cancel();
//     super.dispose();
//   }

//   void _listenForUpdates() {
//     final docRef = _firestore.collection('shows').doc(widget.showId);

//     _sub = docRef.snapshots().listen((docSnapshot) async {
//       final data = docSnapshot.data();
//       if (data == null) return;

//       final now = DateTime.now().millisecondsSinceEpoch;

//       final rawLocks = Map<String, dynamic>.from(data['tempLocks'] ?? {});
//       final Map<String, int> locks = {};
//       rawLocks.forEach((k, v) {
//         if (v is int) locks[k] = v;
//         else if (v is String) locks[k] = int.tryParse(v) ?? 0;
//         else if (v is num) locks[k] = v.toInt();
//       });

//       // Remove expired locks
//       final expiredKeys = locks.keys.where((k) => locks[k]! < now).toList();
//       if (expiredKeys.isNotEmpty) {
//         final updates = <String, dynamic>{};
//         for (var k in expiredKeys) updates['tempLocks.$k'] = FieldValue.delete();
//         try {
//           await docSnapshot.reference.update(updates);
//           expiredKeys.forEach(locks.remove);
//         } catch (_) {}
//       }

//       final bookedMap = Map<String, dynamic>.from(data['bookedSeats'] ?? {});
//       final Set<String> bookedSet = bookedMap.keys.toSet();

//       setState(() {
//         layoutData = Map<String, dynamic>.from(data['layout'] ?? {});
//         tiers = List<Map<String, dynamic>>.from(data['tiers'] ?? []);
//         permanentSeats = bookedSet;
//         tempLocks = locks;
//         selectedSeats.removeWhere(
//             (s) => permanentSeats.contains(s) || tempLocks.containsKey(s));
//       });
//     });
//   }

//   String getRowLetter(int index) {
//     String result = '';
//     while (index >= 0) {
//       result = String.fromCharCode(65 + (index % 26)) + result;
//       index = (index ~/ 26) - 1;
//     }
//     return result;
//   }

//   Color getSeatColor(String seatId) {
//     if (permanentSeats.contains(seatId) || tempLocks.containsKey(seatId)) {
//       return Colors.blueGrey;
//     }
//     if (selectedSeats.contains(seatId)) return Colors.amber;
//     return Colors.white;
//   }

//   void _onSeatTap(String seatId) {
//     if (permanentSeats.contains(seatId) || tempLocks.containsKey(seatId)) return;

//     setState(() {
//       if (selectedSeats.contains(seatId)) {
//         selectedSeats.remove(seatId);
//       } else {
//         if (selectedSeats.length >= 5) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Maximum 5 seats can be selected.")),
//           );
//           return;
//         }
//         selectedSeats.add(seatId);
//       }
//     });
//   }

//   Future<void> _lockSeatsTemporarily() async {
//     if (selectedSeats.isEmpty) return;

//     final ref = _firestore.collection('shows').doc(widget.showId);
//     final now = DateTime.now().millisecondsSinceEpoch;
//     final expiry = now + lockDuration;

//     final updates = <String, dynamic>{};
//     for (var seat in selectedSeats) {
//       updates['tempLocks.$seat'] = expiry;
//     }

//     await ref.update(updates);
//   }

//   Widget _buildSeatLayout() {
//     if (layoutData == null) {
//       return const Center(child: CircularProgressIndicator(color: Colors.amber));
//     }

//     return InteractiveViewer(
//       constrained: false,
//       boundaryMargin: const EdgeInsets.all(200),
//       minScale: 0.6,
//       maxScale: 2.5,
//       child: Column(
//         children: [
//           ...tiers.asMap().entries.map((tierEntry) {
//             final tierIndex = tierEntry.key;
//             final tier = tierEntry.value;

//             final tierLayout =
//                 Map<String, dynamic>.from(layoutData!['tier_$tierIndex'] ?? {});
//             final rowCount = tier['rows'] ?? tierLayout.length;
//             final colPartitions = List<int>.from(tier['colPartitions'] ?? []);

//             return Padding(
//               padding: const EdgeInsets.symmetric(vertical: 12),
//               child: Column(
//                 children: [
//                   Text("${tier['tierName']} – ₹${tier['price']}",
//                       style: const TextStyle(
//                           fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
//                   const SizedBox(height: 8),
//                   ...List.generate(rowCount, (rIndex) {
//                     final rowLabel = getRowLetter(rIndex);
//                     final seats = List<String>.from(tierLayout['row_$rIndex'] ?? []);

//                     return Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 3),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                               width: 25,
//                               child: Text(rowLabel,
//                                   style: const TextStyle(
//                                       fontSize: 12, color: Colors.black))),
//                           const SizedBox(width: 8),
//                           ...seats.asMap().entries.expand((entry) {
//                             final col = entry.key;
//                             final seatId = "tier_$tierIndex-$rowLabel${col + 1}";
//                             final color = getSeatColor(seatId);

//                             final widgets = <Widget>[];

//                             // Insert spacing for column partitions
//                             if (colPartitions.contains(col)) {
//                               widgets.add(const SizedBox(width: 20));
//                             }

//                             widgets.add(
//                               GestureDetector(
//                                 onTap: () => _onSeatTap(seatId),
//                                 child: Container(
//                                   width: 28,
//                                   height: 28,
//                                   margin: const EdgeInsets.symmetric(horizontal: 3),
//                                   decoration: BoxDecoration(
//                                       color: color,
//                                       borderRadius: BorderRadius.circular(6),
//                                       border: Border.all(color: Colors.black26, width: 1)),
//                                   child: Center(
//                                     child: Text("${col + 1}",
//                                         style: const TextStyle(
//                                             color: Colors.black, fontSize: 9)),
//                                   ),
//                                 ),
//                               ),
//                             );

//                             return widgets;
//                           }).toList(),
//                         ],
//                       ),
//                     );
//                   }),
//                 ],
//               ),
//             );
//           }).toList(),
//           const SizedBox(height: 60),
//         ],
//       ),
//     );
//   }

//   Widget _buildLegend() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: const Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           _LegendItem(color: Colors.white, label: "Available"),
//           _LegendItem(color: Colors.amber, label: "Selected"),
//           _LegendItem(color: Colors.blueGrey, label: "Occupied"),
//         ],
//       ),
//     );
//   }

//   Widget _buildBookButton() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       child: ElevatedButton(
//         onPressed: selectedSeats.isEmpty
//             ? null
//             : () async {
//                 await _lockSeatsTemporarily();
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => CheckoutPage(
//                       showId: widget.showId,
//                       theatreId: widget.theatreId,
//                       movieTitle: widget.movieTitle,
//                       showTime: widget.showTime,
//                       tiers: tiers,
//                     ),
//                   ),
//                 );
//               },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: selectedSeats.isEmpty ? Colors.grey : Colors.amber,
//           minimumSize: const Size(double.infinity, 50),
//         ),
//         child: Text(
//           selectedSeats.isEmpty
//               ? "Select seats to continue"
//               : "Continue (${selectedSeats.length} seats)",
//           style: const TextStyle(fontSize: 16, color: Colors.black),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text(
//           "${widget.movieTitle} • ${widget.showTime}",
//           style: const TextStyle(color: Colors.black, fontSize: 18),
//         ),
//       ),
//       body: Column(
//         children: [
//           Container(
//             height: 50,
//             width: double.infinity,
//             color: Colors.black,
//             child: const Center(
//               child: Text('SCREEN',
//                   style: TextStyle(color: Colors.white, fontSize: 16)),
//             ),
//           ),
//           Expanded(child: _buildSeatLayout()),
//           _buildLegend(),
//           _buildBookButton(),
//         ],
//       ),
//     );
//   }
// }

// class _LegendItem extends StatelessWidget {
//   final Color color;
//   final String label;
//   const _LegendItem({required this.color, required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           width: 18,
//           height: 18,
//           decoration: BoxDecoration(color: color, border: Border.all(color: Colors.black)),
//         ),
//         const SizedBox(width: 6),
//         Text(label, style: const TextStyle(fontSize: 14)),
//       ],
//     );
//   }
// }





