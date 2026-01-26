import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rollin_user/presentation/screens/cinemas/theatre_search.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 16,

      title: user == null
          ? const SizedBox()
          : StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('rollin_user_profile')
                  .doc(user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Text(
                    "Loading...",
                    style: TextStyle(color: Colors.black),
                  );
                }

                final data = snapshot.data!.data() as Map<String, dynamic>;
                final name = data['name'] ?? 'User';
                final location = data['location'] ?? 'Select location';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hey, $name ",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Text(
                        //   location,
                        //   style: const TextStyle(
                        //     color: Colors.redAccent,
                        //     fontSize: 13,
                        //     fontWeight: FontWeight.w500,
                        //   ),
                        // ),
                        // const SizedBox(width: 4),
                        // const Icon(
                        //   Icons.keyboard_arrow_down,
                        //   color: Colors.redAccent,
                        //   size: 16,
                        // ),
                      ],
                    ),
                  ],
                );
              },
            ),

      actions: [
        Padding(
          
          padding:  EdgeInsets.fromLTRB(0, 1, 0, 2),
          child: IconButton(
            
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CinemaListPage(),
                ),
              );
            },
          ),
        ),
        // IconButton(
        //   icon: const Icon(Icons.notifications_none, color: Colors.black),
        //   onPressed: () {},
        // ),
        const SizedBox(width: 8),
      ],
    );
  }
}
