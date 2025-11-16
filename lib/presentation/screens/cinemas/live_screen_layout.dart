import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? layoutData;
  List<Map<String, dynamic>> tiers = [];
  Set<String> occupiedSeats = {}; // Already booked
  Set<String> selectedSeats = {}; // User-selected (max 5)
  int globalRowCounter = 0;

  @override
  void initState() {
    super.initState();
    _listenForUpdates();
  }

  void _listenForUpdates() {
    _firestore.collection('shows').doc(widget.showId).snapshots().listen((doc) {
      final data = doc.data();
      if (data != null) {
        setState(() {
          layoutData = Map<String, dynamic>.from(data['layout'] ?? {});
          tiers = List<Map<String, dynamic>>.from(data['tiers'] ?? []);
          occupiedSeats = _safeSet(data['bookedSeats']);
        });
      }
    });
  }

  Set<String> _safeSet(dynamic field) {
    if (field == null) return {};
    if (field is List) return Set<String>.from(field);
    if (field is Map) return Set<String>.from(field.keys);
    return {};
  }

  // Convert index to A, B, C...
  String getRowLetter(int index) {
    String result = '';
    while (index >= 0) {
      result = String.fromCharCode(65 + (index % 26)) + result;
      index = (index ~/ 26) - 1;
    }
    return result;
  }

  // Seat color
  Color getSeatColor(String seatId) {
    if (occupiedSeats.contains(seatId)) return Colors.black;
    if (selectedSeats.contains(seatId)) return Colors.amber;
    return Colors.white;
  }

  // On tap select seat
  void _onSeatTap(String seatId) {
    if (occupiedSeats.contains(seatId)) return;

    setState(() {
      if (selectedSeats.contains(seatId)) {
        selectedSeats.remove(seatId);
      } else {
        if (selectedSeats.length >= 5) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Maximum 5 seats can be selected.")),
          );
          return;
        }
        selectedSeats.add(seatId);
      }
    });
  }

  // Book selected seats temporarily (10 min)
  void _blockSelectedSeats() async {
    if (selectedSeats.isEmpty) return;

    await _firestore.collection('shows').doc(widget.showId).update({
      'bookedSeats': FieldValue.arrayUnion(selectedSeats.toList()),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Seats blocked for 10 minutes")),
    );

    final selected = selectedSeats.toSet();
    setState(() {
      occupiedSeats.addAll(selected);
      selectedSeats.clear();
    });

    Timer(const Duration(minutes: 10), () async {
      await _firestore.collection('shows').doc(widget.showId).update({
        'bookedSeats': FieldValue.arrayRemove(selected.toList()),
      });
    });
  }

  // Build seat layout
  Widget _buildSeatLayout() {
    if (layoutData == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.amber),
      );
    }

    globalRowCounter = 0;

    return InteractiveViewer(
      constrained: false,
      boundaryMargin: const EdgeInsets.all(200),
      minScale: 0.6,
      maxScale: 2.5,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          children: [
            ...tiers.asMap().entries.map((entry) {
              final tierIndex = entry.key;
              final tier = entry.value;
              final tierName = tier['tierName'] ?? 'Tier';
              final price = tier['price'] ?? 0;
              final cols = (tier['cols'] ?? 0);
              final colPartitions = List<int>.from(tier['colPartitions'] ?? []);
              final rowPartitions = List<int>.from(tier['rowPartitions'] ?? []);
              final tierLayout = Map<String, dynamic>.from(
                layoutData!['tier_$tierIndex'] ?? {},
              );

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  children: [
                    Text(
                      "$tierName – ₹$price",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...tierLayout.entries.map((rowEntry) {
                      final rowLabel = getRowLetter(globalRowCounter++);
                      final seats = List<String>.from(rowEntry.value);

                      if (rowPartitions.contains(globalRowCounter)) {
                        return const SizedBox(height: 20);
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 25,
                              child: Text(
                                rowLabel,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ...List.generate(seats.length, (col) {
                              final seatId =
                                  "tier_$tierIndex-$rowLabel${col + 1}";
                              final color = getSeatColor(seatId);
                              final widgets = <Widget>[];

                              if (colPartitions.contains(col)) {
                                widgets.add(const SizedBox(width: 30));
                              }

                              widgets.add(
                                GestureDetector(
                                  onTap: () => _onSeatTap(seatId),
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    margin: const EdgeInsets.symmetric(horizontal: 3),
                                    decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: Colors.black26,
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "${col + 1}",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 9,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                              return Row(children: widgets);
                            }),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              );
            }),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildScreenIndicator() {
    return Container(
      height: 50,
      width: double.infinity,
      color: Colors.black,
      child: const Center(
        child: Text(
          'SCREEN',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _LegendItem(color: Colors.white, label: "Available"),
          _LegendItem(color: Colors.amber, label: "Selected"),
          _LegendItem(color: Color.fromARGB(255, 7, 149, 76), label: "Occupied"),
        ],
      ),
    );
  }

  Widget _buildBookButton() {
    final selectedInfo = selectedSeats.map((id) {
      final tierIndex = int.tryParse(id.split('-')[0].split('_')[1]) ?? 0;
      final tierName = tiers[tierIndex]['tierName'] ?? 'Tier';
      final price = tiers[tierIndex]['price'] ?? 0;
      return "$tierName - $id - ₹$price";
    }).join('\n');

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: selectedSeats.isEmpty ? null : _blockSelectedSeats,
        style: ElevatedButton.styleFrom(
          backgroundColor: selectedSeats.isEmpty ? Colors.grey : Colors.amber,
          minimumSize: const Size(double.infinity, 50),
        ),
        child: Text(
          selectedSeats.isEmpty
              ? "Select seats to continue"
              : "Continue (${selectedSeats.length} seats)",
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "${widget.movieTitle} • ${widget.showTime}",
          style: const TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          _buildScreenIndicator(),
          Expanded(child: _buildSeatLayout()),
          _buildLegend(),
          _buildBookButton(),
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
        Text(label, style: const TextStyle(color: Colors.black, fontSize: 14)),
      ],
    );
  }
}
