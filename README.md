Rollin

Rollin is a movie ticket booking platform built with Flutter and Firebase. This repo Rollin is the user app.

Rollin is made of three separate apps sharing one Firebase backend:

App	Platform	Purpose
User (this repo)	Mobile	Browse movies, book seats, pay, view history
Theatre Admin	Mobile	Manage theatres, screens, seat layouts, revenue
Super Admin	Web	Platform-level management
. Features
. Firebase Auth
. Movies and trailers via TMDB API
. Search for movies and theatres
. Theatres and show timings
. Real-time seat availability (Cloud Firestore)
. Stripe payments (test mode)
. Booking history and profile management
. Tech Stack

Flutter · BLoC · Clean Architecture · Firebase (Auth, Firestore, Storage) · Stripe · TMDB 

. Architecture
lib/
├── data/           # Data sources, models, repository implementations
├── domain/         # Entities, repository contracts, use cases
└── presentation/   # Pages, widgets, BLoCs
