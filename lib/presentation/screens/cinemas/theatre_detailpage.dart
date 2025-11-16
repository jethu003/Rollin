import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rollin_user/presentation/resourses/app_colours.dart';
import 'package:rollin_user/presentation/screens/cinemas/live_screen_layout.dart';


class TheatreDetailsPage extends StatefulWidget {
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

  @override
  State<TheatreDetailsPage> createState() => _TheatreDetailsPageState();
}

class _TheatreDetailsPageState extends State<TheatreDetailsPage> {
  DateTime _selectedDate = DateTime.now();
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _shows = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchShows();
  }

  Future<void> _fetchShows() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('shows')
          .where('theatreId', isEqualTo: widget.theatreId)
          .get();

      if (mounted) {
        setState(() {
          _shows = snap.docs;
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching shows: $e');
      if (mounted) setState(() => _loading = false);
    }
  }

  List<DateTime> get _nextDays =>
      List.generate(3, (i) => DateTime.now().add(Duration(days: i)));

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final showsForDate =
        _shows.where((doc) => doc['date'] == dateStr).toList();

    final Map<String, List<QueryDocumentSnapshot<Map<String, dynamic>>>> grouped =
        {};
    for (var doc in showsForDate) {
      final title = doc['movieTitle'];
      grouped.putIfAbsent(title, () => []);
      grouped[title]!.add(doc);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator(color: Colors.red))
            : CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  //  App Bar
                  SliverAppBar(
                    expandedHeight: 220,
                    pinned: true,
                    backgroundColor: Colors.black,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(widget.theatreName),
                      background: CachedNetworkImage(
                        imageUrl: widget.image.isNotEmpty
                            ? widget.image
                            : 'https://via.placeholder.com/400x200.png?text=No+Image',
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(color: Colors.red),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.black26,
                          child: const Icon(Icons.broken_image,
                              color: Colors.white, size: 50),
                        ),
                      ),
                    ),
                  ),

                  //  Date Tabs
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
                              DateUtils.isSameDay(date, _selectedDate);
                          final label = DateFormat('dd').format(date);
                          final month = DateFormat('MMM').format(date);
                          final day = DateFormat('E').format(date);
                          final suffix =
                              i == 0 ? 'Today' : i == 1 ? 'Tomorrow' : day;

                          return GestureDetector(
                            onTap: () => setState(() => _selectedDate = date),
                            child: Container(
                              width: width * 0.28,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.yellow[100]
                                    : Colors.white,
                                border: Border(
                                  bottom: BorderSide(
                                    color: isSelected
                                        ? AppColours.primaryColor
                                        : Colors.grey.shade300,
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      month,
                                      style: TextStyle(
                                        fontSize: width * 0.035,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      label,
                                      style: TextStyle(
                                        fontSize: width * 0.05,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      suffix,
                                      style: TextStyle(
                                        fontSize: width * 0.033,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // 🎬 Movies and shows
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final movieTitle = grouped.keys.elementAt(index);
                        final showDocs = grouped[movieTitle]!;
                        final moviePoster = showDocs.first['posterUrl'] ?? '';
                        final duration = '2h 30m';
                        final genre = 'Comedy, Horror, Thriller';

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 🎞 Movie info
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: CachedNetworkImage(
                                      imageUrl: moviePoster.isNotEmpty
                                          ? moviePoster
                                          : 'https://via.placeholder.com/100x150.png?text=No+Poster',
                                      width: 80,
                                      height: 110,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        width: 80,
                                        height: 110,
                                        color: Colors.grey.shade200,
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        width: 80,
                                        height: 110,
                                        color: Colors.grey.shade300,
                                        child: const Icon(Icons.broken_image),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          movieTitle,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'UA 16+ • $genre\n$duration',
                                          style: const TextStyle(
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

                              // 🕒 Show times (clickable)
                              Wrap(
                                spacing: 10,
                                runSpacing: 8,
                                children: showDocs.map((doc) {
                                  final showTime = doc['time'];
                                  final showId = doc.id;

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SeatLayoutPage(
                                            theatreId: widget.theatreId,
                                            showId: showId,
                                            movieTitle: movieTitle,
                                            showTime: showTime,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: Colors.grey.shade400),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            "HINDI",
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            showTime,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
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
              ),
      ),
    );
  }
}
