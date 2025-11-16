import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:rollin_user/data/datasources/firestore_datasource.dart';
import 'package:rollin_user/data/repositories/show_repo_impl.dart';
import 'package:rollin_user/domain/usecases/show_usecase.dart';
import 'package:rollin_user/presentation/bloc/shows_theatres/showsbloc_bloc.dart';
import 'package:rollin_user/presentation/bloc/shows_theatres/showsbloc_event.dart';
import 'package:rollin_user/presentation/bloc/shows_theatres/showsbloc_state.dart';
import 'package:rollin_user/presentation/screens/cinemas/theatre_detailpage.dart';

class CinemaListPage extends StatefulWidget {
  const CinemaListPage({super.key});

  @override
  State<CinemaListPage> createState() => _CinemaListPageState();
}

class _CinemaListPageState extends State<CinemaListPage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;
    final dataSource = FirestoreDataSource(firestore);
    final repository = ShowRepositoryImpl(dataSource);
    final usecase = GetShowsWithDetails(repository);

    return BlocProvider(
      create: (_) => ShowBloc(usecase)..add(FetchShows()),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //  Search Bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for a movie or cinema',
                      hintStyle:
                          const TextStyle(color: Colors.grey, fontSize: 15),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.toLowerCase();
                      });
                    },
                  ),
                ),

                //  Tab Bar
                const TabBar(
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.amber,
                  indicatorWeight: 2.5,
                  labelStyle:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  tabs: [
                    Tab(text: 'Movies'),
                    Tab(text: 'Cinemas'),
                  ],
                ),
                const Divider(height: 1),

                // Tab Views
                Expanded(
                  child: TabBarView(
                    children: [
                      // 🎞 MOVIES TAB
                      BlocBuilder<ShowBloc, ShowState>(
                        builder: (context, state) {
                          if (state is ShowLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state is ShowLoaded) {
                            final uniqueMovies = {
                              for (var s in state.shows)
                                s['movie'].id: s['movie']
                            }.values.toList();

                            final filteredMovies = uniqueMovies
                                .where((m) => m.title
                                    .toString()
                                    .toLowerCase()
                                    .contains(searchQuery))
                                .toList();

                            if (filteredMovies.isEmpty) {
                              return const Center(
                                  child: Text('No movies found.'));
                            }

                            return ListView.builder(
                              padding: const EdgeInsets.only(top: 10),
                              itemCount: filteredMovies.length,
                              itemBuilder: (context, index) {
                                final movie = filteredMovies[index];

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          movie.posterUrl ?? '',
                                          width: 70,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Container(
                                            width: 70,
                                            height: 100,
                                            color: Colors.grey[300],
                                            child: const Icon(Icons.image,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              movie.title ?? 'Untitled Movie',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                            const SizedBox(height: 4),

                                            Text(
                                              (movie.language ?? 'Unknown'),
                                              style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 13,
                                              ),
                                            ),
                                            const SizedBox(height: 4),

                                            Text(
                                              (movie.genres != null &&
                                                      movie.genres.isNotEmpty)
                                                  ? movie.genres.join(', ')
                                                  : 'No genres available',
                                              style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          } else if (state is ShowError) {
                            return Center(
                                child: Text('Error: ${state.message}'));
                          }
                          return const SizedBox();
                        },
                      ),

                      // 🎭 CINEMAS TAB
                      BlocBuilder<ShowBloc, ShowState>(
                        builder: (context, state) {
                          if (state is ShowLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state is ShowLoaded) {
                            final uniqueTheatres = {
                              for (var s in state.shows)
                                s['theatre'].id: s['theatre']
                            }.values.toList();

                            final filteredTheatres = uniqueTheatres
                                .where((t) => t.name
                                    .toString()
                                    .toLowerCase()
                                    .contains(searchQuery))
                                .toList();

                            if (filteredTheatres.isEmpty) {
                              return const Center(
                                  child: Text('No cinemas found.'));
                            }

                            return ListView.builder(
                              padding: const EdgeInsets.only(top: 10),
                              itemCount: filteredTheatres.length,
                              itemBuilder: (context, index) {
                                final theatre = filteredTheatres[index];

                                return ListTile(
                                  leading: const Icon(Icons.theaters_outlined,
                                      color: Colors.amber),
                                  title: Text(
                                    theatre.name ?? 'Unknown Theatre',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  subtitle: Text(
                                    theatre.city ?? '',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  trailing: const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 16,
                                      color: Colors.grey),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => TheatreDetailsPage(
                                          theatreId: theatre.id ?? '',
                                          
                                          image: theatre.image ?? '',
                                          location:
                                              theatre.city ?? 'Unknown City', theatreName: theatre.name,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          } else if (state is ShowError) {
                            return Center(
                                child: Text('Error: ${state.message}'));
                          }
                          return const SizedBox();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
