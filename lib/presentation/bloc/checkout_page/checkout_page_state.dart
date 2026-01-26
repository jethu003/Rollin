import 'package:equatable/equatable.dart';

class CheckoutState extends Equatable {
  final bool isLoading;
  final List<String> lockedSeats;
  final String? posterUrl;
  final String? theatreName;
  final String? showDate;
  final String? error;

  const CheckoutState({
    this.isLoading = false,
    this.lockedSeats = const [],
    this.posterUrl,
    this.theatreName,
    this.showDate,
    this.error,
  });

  CheckoutState copyWith({
    bool? isLoading,
    List<String>? lockedSeats,
    String? posterUrl,
    String? theatreName,
    String? showDate,
    String? error,
  }) {
    return CheckoutState(
      isLoading: isLoading ?? this.isLoading,
      lockedSeats: lockedSeats ?? this.lockedSeats,
      posterUrl: posterUrl ?? this.posterUrl,
      theatreName: theatreName ?? this.theatreName,
      showDate: showDate ?? this.showDate,
      error: error,
    );
  }

  @override
  List<Object?> get props =>
      [isLoading, lockedSeats, posterUrl, theatreName, showDate, error];
}
