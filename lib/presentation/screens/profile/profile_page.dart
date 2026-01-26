import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rollin_user/presentation/authentication/login.dart';
import 'package:rollin_user/presentation/resourses/app_colours.dart';
import 'package:rollin_user/presentation/screens/profile/about_us.dart';
import 'package:rollin_user/presentation/screens/profile/booking_history.dart';
import 'package:rollin_user/presentation/screens/profile/privacy_policy.dart';
import 'package:rollin_user/presentation/screens/profile/edit_profile.dart';
import 'package:rollin_user/presentation/widgets/flushbar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

 
  Future<void> _performLogout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => UserLoginScreen()),
        (route) => false,
      );

      showFlushBar(context, "Logged out successfully!");
    } catch (e) {
      showFlushBar(context, "Error logging out");
    }
  }

 
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColours.shineBlack,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          title: const Text(
            "Log Out",
            style: TextStyle(
              color: AppColours.shineWhite,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            "Are you sure you want to log out?",
            style: TextStyle(color: AppColours.shineWhite),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(color: AppColours.shineWhite),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColours.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                _performLogout(context);
              },
              child: const Text(
                "Log Out",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
       
        title: const Text(
          'Account',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
  IconButton(
  icon: Transform.translate(
    offset: const Offset(-5, -3), // ← left , ↑ up
    child: const ImageIcon(
      AssetImage('assets/profile.png'),
      color: Colors.black,
      size: 26,
    ),
  ),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );
  },
),

        ],
      ),
      body: ListView(
        children: [
          // _buildProfileHeader(screenWidth),

          _buildMenuItem(
            icon: Icons.confirmation_number_outlined,
            title: 'My Bookings',
            onTap: () {
              if (user != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookingHistoryPage(userId: user.uid),
                  ),
                );
              }
            },
          ),

          const Divider(height: 30),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _settingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PrivacyPolicyPage()),
                    );
                  },
                ),
                _settingsTile(
                  icon: Icons.info_outline,
                  title: 'About Us',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AboutUsPage()),
                    );
                  },
                ),
                _settingsTile(
                  icon: Icons.logout,
                  title: 'Log Out',
                  isDestructive: true,
                  onTap: () => _showLogoutDialog(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  
  Widget _buildProfileHeader(double screenWidth) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.person, size: 30, color: Color(0xFFFBC02D)),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Jithu j mathew ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
          const SizedBox(height: 15),
          LinearProgressIndicator(
            value: 0.9,
            backgroundColor: Colors.grey.shade300,
            valueColor:
                const AlwaysStoppedAnimation<Color>(Color(0xFFFBC02D)),
            minHeight: 6,
          ),
        ],
      ),
    );
  }

  //  MAIN MENU ITEM
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        child: Row(
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 15),
            Expanded(
              child: Text(title, style: const TextStyle(fontSize: 16)),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}

//  SETTINGS TILE
Widget _settingsTile({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
  bool isDestructive = false,
}) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Icon(
            icon,
            size: 22,
            color: isDestructive ? Colors.red : Colors.black87,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: isDestructive ? Colors.red : Colors.black87,
              ),
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: Colors.grey,
          ),
        ],
      ),
    ),
  );
}
