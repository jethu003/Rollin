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
import 'package:rollin_user/presentation/screens/home_page/book_from_movies.dart';

class CinemaListPage extends StatefulWidget {
  const CinemaListPage({super.key});

  @override
  State<CinemaListPage> createState() => _CinemaListPageState();
}

class _CinemaListPageState extends State<CinemaListPage> {
  String searchQuery = '';
  String selectedCity = '';

  final List<String> availableCities = [
    'All',
    'Mumbai',
    'Delhi',
    'Bangalore',
    'Chennai',
    'Kochi',
  ];

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
                _buildSearchSection(),

                const TabBar(
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.amber,
                  indicatorWeight: 2.5,
                  tabs: [
                    Tab(text: 'Movies'),
                    Tab(text: 'Cinemas'),
                  ],
                ),

                const Divider(height: 1),

                Expanded(
                  child: TabBarView(
                    children: [
                      _buildMoviesTab(),
                      _buildCinemasTab(),
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

  
  Widget _buildSearchSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search for a movie or cinema',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) =>
                setState(() => searchQuery = value.toLowerCase()),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: selectedCity.isEmpty ? 'All' : selectedCity,
            items: availableCities
                .map(
                  (city) => DropdownMenuItem(
                    value: city,
                    child: Text(city),
                  ),
                )
                .toList(),
            onChanged: (value) =>
                setState(() => selectedCity = value == 'All' ? '' : value ?? ''),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

 
  Widget _buildMoviesTab() {
    return BlocBuilder<ShowBloc, ShowState>(
      builder: (context, state) {
        if (state is ShowLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ShowLoaded) {
          final filteredShows = state.shows.where((s) {
            final movieTitle = s['movie'].title.toLowerCase();
            final city = s['theatre'].city?.toLowerCase() ?? '';
            return movieTitle.contains(searchQuery) &&
                (selectedCity.isEmpty ||
                    city.contains(selectedCity.toLowerCase()));
          }).toList();

          final uniqueMovies = {
            for (var s in filteredShows) s['movie'].id: s['movie']
          }.values.toList();

          if (uniqueMovies.isEmpty) {
            return const Center(child: Text('No movies found.'));
          }

          return ListView.builder(
            itemCount: uniqueMovies.length,
            itemBuilder: (context, index) {
              final movie = uniqueMovies[index];

              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    movie.posterUrl,
                    width: 70,
                    height: 100,
                    fit: BoxFit.cover,

                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        width: 70,
                        height: 100,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.movie),
                      );
                    },

                    errorBuilder: (_, __, ___) => Container(
                      width: 70,
                      height: 100,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.broken_image),
                    ),
                  ),
                ),
                title: Text(movie.title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                  '${movie.language} • ${movie.genres.join(', ')}',
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          MovieDetailsOverlayPage(movie: movie.toJson()),
                    ),
                  );
                },
              );
            },
          );
        }

        if (state is ShowError) {
          return Center(child: Text(state.message));
        }

        return const SizedBox();
      },
    );
  }

 
  Widget _buildCinemasTab() {
    return BlocBuilder<ShowBloc, ShowState>(
      builder: (context, state) {
        if (state is ShowLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ShowLoaded) {
          final uniqueTheatres = {
            for (var s in state.shows) s['theatre'].id: s['theatre']
          }.values.toList();

          final filtered = uniqueTheatres.where((t) {
            final city = t.city?.toLowerCase() ?? '';
            return t.name!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                (selectedCity.isEmpty ||
                    city.contains(selectedCity.toLowerCase()));
          }).toList();

          if (filtered.isEmpty) {
            return const Center(child: Text('No cinemas found.'));
          }

          return ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final theatre = filtered[index];

              return ListTile(
                leading: const Icon(Icons.theaters, color: Colors.amber),
                title: Text(theatre.name ?? 'Unknown'),
                subtitle: Text(theatre.city ?? ''),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TheatreDetailsPage(
                        theatreId: theatre.id,
                        theatreName: theatre.name,
                        location: theatre.city,
                        image: theatre.images.isNotEmpty
                            ? theatre.images.first
                            : 'https://via.placeholder.com/400x200.png',
                      ),
                    ),
                  );
                },
              );
            },
          );
        }

        if (state is ShowError) {
          return Center(child: Text(state.message));
        }

        return const SizedBox();
      },
    );
  }
}
