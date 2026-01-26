

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rollin_user/data/datasources/booking_datasource.dart';
import 'package:rollin_user/data/models/booking_model.dart';
import 'package:rollin_user/data/repositories/movie_bookings_repository.dart';
import 'package:rollin_user/domain/usecases/movie_booking_usecase.dart';
import 'package:rollin_user/presentation/bloc/movie_bookings/movie_bookings_bloc.dart';
import 'package:rollin_user/presentation/bloc/movie_bookings/movie_bookings_event.dart';
import 'package:rollin_user/presentation/bloc/movie_bookings/movie_bookings_state.dart';
import 'package:rollin_user/presentation/screens/profile/booking_details_page.dart';

class BookingHistoryPage extends StatelessWidget {
  final String userId;

  const BookingHistoryPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    
    final firestore = FirebaseFirestore.instance;
    final dataSource = BookingDataSource(firestore);
    final repository = BookingRepositoryImpl(dataSource);
    final usecase = GetUserBookings(repository);

    return BlocProvider(
      create: (_) => BookingBloc(usecase)..add(FetchUserBookings(userId)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'My Bookings',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        body: BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            if (state is BookingLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BookingLoaded) {
              final bookings = state.bookings;
              if (bookings.isEmpty) {
                return _buildEmptyState(context);
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  return _buildBookingCard(booking, context);
                },
              );
            } else if (state is BookingError) {
              return Center(
                child: Text(
                  'Error: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

Widget _buildBookingCard(BookingModel booking, BuildContext context) {
  bool isPaid = booking.totalPrice > 0;
  String statusText = isPaid ? "FINISHED" : "FAILED";
  Color statusColor = isPaid ? Colors.green : Colors.red;

  String formattedSeats = booking.seats
      .map((seat) => seat.split("-").last) // "tier_1-B6" → "B6"
      .join(", ");

  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookingDetailsPage(booking: booking),
        ),
      );
    },
    borderRadius: BorderRadius.circular(10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            "Ordered on: ${booking.date} at ${booking.time}",
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        Card(
          elevation: 1.5,
          margin: const EdgeInsets.only(bottom: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Poster
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    booking.posterUrl,
                    width: 65,
                    height: 95,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(width: 10),

                /// Right side details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.movieTitle,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "${booking.date} | ${booking.time}",
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        booking.theatreName,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "${booking.seats.length} ticket(s): ${booking.tiers.first} - $formattedSeats",
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Text(
                            booking.screenName.trim().toUpperCase(),
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                     
                      Text(
                        "Booking ID: ${booking.bookingId}",
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 8),

                      /// Status Bar
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          statusText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}



  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.movie_filter_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 20),
            const Text(
              'No Bookings Available',
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Your movie bookings will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Navigate to booking page
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFBC02D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 12),
                elevation: 0,
              ),
              child: const Text(
                'Book Movie',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
