

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:rollin_user/data/repositories/booking_repository.dart';
import 'package:rollin_user/data/repositories/payement_repository.dart';
import 'package:rollin_user/domain/usecases/upload_userbookings_usecase.dart';
import 'package:rollin_user/domain/usecases/payement_usecase.dart';

import 'package:rollin_user/presentation/bloc/bookings/bookings_bloc.dart';
import 'package:rollin_user/presentation/bloc/bookings/bookings_event.dart';
import 'package:rollin_user/presentation/bloc/bookings/bookings_state.dart';

import 'package:rollin_user/presentation/bloc/checkout_page/checkout_page_bloc.dart';
import 'package:rollin_user/presentation/bloc/checkout_page/checkout_page_event.dart';
import 'package:rollin_user/presentation/bloc/checkout_page/checkout_page_state.dart';

import 'package:rollin_user/presentation/bloc/payement_gateway/payement_gateway_bloc.dart';
import 'package:rollin_user/presentation/bloc/payement_gateway/payement_gateway_event.dart';
import 'package:rollin_user/presentation/bloc/payement_gateway/payement_gateway_state.dart';

import 'package:rollin_user/presentation/screens/bottom_navigator/bottom_navigator.dart';
import 'package:rollin_user/presentation/widgets/flushbar.dart';


class CheckoutPage extends StatefulWidget {
  final String showId;
  final String theatreId;
  final String movieTitle;
  final String showTime;
  final List<Map<String, dynamic>> tiers;

  const CheckoutPage({
    super.key,
    required this.showId,
    required this.theatreId,
    required this.movieTitle,
    required this.showTime,
    required this.tiers,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late BookingBloc bookingBloc;
  bool bookingCompleted = false;

  @override
  void initState() {
    super.initState();
    bookingBloc = BookingBloc(
      UploadBookingUseCase(
        BookingRepositoryImpl(FirebaseFirestore.instance),
      ),
    );
  }

  @override
  void dispose() {
    bookingBloc.close();
    super.dispose();
  }

  Map<String, dynamic> _tierInfo(String seatId) {
    final tierIndex =
        int.tryParse(seatId.split('-')[0].replaceAll('tier_', '')) ?? 0;
    return widget.tiers[tierIndex];
  }

  String _tierName(String seatId) =>
      (_tierInfo(seatId)['tierName']).toString().toUpperCase();

  double _seatPrice(String seatId) =>
      (_tierInfo(seatId)['price'] as num).toDouble();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CheckoutBloc(
            firestore: FirebaseFirestore.instance,
            showId: widget.showId,
            theatreId: widget.theatreId,
          )..add(LoadCheckout()),
        ),
        BlocProvider(
          create: (_) => PaymentBloc(
            CreatePaymentIntentUseCase(PaymentRepository()),
          ),
        ),
        BlocProvider.value(value: bookingBloc),
      ],
      child: WillPopScope(
        onWillPop: () async {
          if (!bookingCompleted) {
            context.read<CheckoutBloc>().add(UnlockSeats());
          }
          return true;
        },
        child: BlocBuilder<CheckoutBloc, CheckoutState>(
          builder: (context, state) {
            final total = state.lockedSeats.fold<double>(
              0,
              (p, s) => p + _seatPrice(s),
            );
            final gst = total * 0.18;
            final grandTotal = total + gst;

            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    if (!bookingCompleted) {
                      context.read<CheckoutBloc>().add(UnlockSeats());
                    }
                    Navigator.pop(context);
                  },
                ),
                title: const Text("Checkout"),
              ),
              body: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : BlocConsumer<PaymentBloc, PaymentState>(
                      listener: (context, paymentState) {
                        if (paymentState is PaymentSuccess) {
                          bookingBloc.add(
                            UploadBookingEvent(
                              showId: widget.showId,
                              theatreId: widget.theatreId,
                              movieTitle: widget.movieTitle,
                              showTime: widget.showTime,
                              lockedSeats: state.lockedSeats,
                              tiers:
                                  state.lockedSeats.map(_tierName).toList(),
                              totalPrice: grandTotal,
                              theatreName: state.theatreName,
                              posterUrl: state.posterUrl,
                              showDate: state.showDate,
                            ),
                          );

                          context
                              .read<CheckoutBloc>()
                              .add(BookSeats());
                        }
                      },
                      builder: (context, paymentState) {
                        return BlocListener<BookingBloc, BookingState>(
                          listener: (context, bookingState) {
                            if (bookingState is BookingSuccess) {
                              bookingCompleted = true;

                              showFlushBar(
                                context,
                                "Booking Success → ${bookingState.bookingId}",
                                backgroundColor: Colors.green,
                              );

                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BottomNavigator(),
                                ),
                                (_) => false,
                              );
                            }
                          },
                          child: _oldCheckoutUI(
                            context,
                            state,
                            total,
                            gst,
                            grandTotal,
                            paymentState,
                          ),
                        );
                      },
                    ),
            );
          },
        ),
      ),
    );
  }

  
  Widget _oldCheckoutUI(
    BuildContext context,
    CheckoutState state,
    double total,
    double gst,
    double grandTotal,
    PaymentState paymentState,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (state.posterUrl != null)
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    state.posterUrl!,
                    width: 95,
                    height: 130,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.movieTitle,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${state.showDate ?? ''} • ${widget.showTime}",
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      const SizedBox(height: 6),
                      if (state.theatreName != null)
                        Text(state.theatreName!),
                    ],
                  ),
                ),
              ],
            ),

          const SizedBox(height: 20),

          if (state.lockedSeats.isNotEmpty)
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.grey.shade100,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Your Seats",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      children: state.lockedSeats.map((seat) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _tierName(seat),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Text(seat.split('-')[1]),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 20),

          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _summaryRow("Subtotal", total),
                  _summaryRow("GST (18%)", gst),
                  const Divider(),
                  _summaryRow("Total", grandTotal, bold: true),
                ],
              ),
            ),
          ),

          const Spacer(),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: paymentState is PaymentLoading
                ? null
                : () {
                    context
                        .read<PaymentBloc>()
                        .add(MakePayment(grandTotal));
                  },
            child: paymentState is PaymentLoading
                ? const CircularProgressIndicator(color: Colors.black)
                : const Text("Pay & Book"),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, double value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            "₹${value.toStringAsFixed(2)}",
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}


