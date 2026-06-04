import 'package:flutter/material.dart';
import 'dart:ui';

// IMPORT LAMA
import '../services/session_manager.dart';
import 'login_screen.dart';
import 'home_screen.dart';
import 'explore_screen.dart';
import 'diamond_store_screen.dart';
import 'feedback_screen.dart';

// IMPORT AI
import 'ai_chat_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  // LIST PAGE
  final List<Widget> _pages = [
    const HomeScreen(),
    const ExploreScreen(),
    const DiamondStoreScreen(),
    const AIChatScreen(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),

      appBar: AppBar(
        title: const Text(
          "EsportsPulse",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Color(0xFF102A43),
            letterSpacing: 1.5,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_active_outlined,
              color: Color(0xFF62B1F6),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Belum ada notifikasi turnamen baru.",
                  ),
                  backgroundColor: Color(0xFF102A43),
                ),
              );
            },
          ),
        ],
      ),

      body: _pages[_selectedIndex],

      // BOTTOM NAVIGATION
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            )
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF102A43),
          unselectedItemColor: Colors.blueGrey[300],
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_max_rounded),
              label: 'Home',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              label: 'Explore',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.diamond),
              label: 'Store',
            ),

            // MENU AI
            BottomNavigationBarItem(
              icon: Icon(Icons.smart_toy_rounded),
              label: 'AI',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}

// ===========================
// PROFILE PAGE
// ===========================

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "Loading...";
  String nim = "Loading...";
  String username = "Loading...";

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    String? getName = await SessionManager.getName();

    String? getNim = await SessionManager.getNim();

    String? getUsername = await SessionManager.getUsername();

    setState(() {
      name = getName ?? "User";

      nim = getNim ?? "-";

      username = getUsername ?? "-";
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Color(0xFF62B1F6),
                  Color(0xFF102A43),
                ],
              ),
            ),
            child: const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 56,
                backgroundImage: AssetImage(
                  'assets/images/profile.jpg',
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Color(0xFF102A43),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "@$username",
            style: const TextStyle(
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(
                30,
              ),
            ),
            child: Text(
              "NIM : $nim",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF102A43),
              ),
            ),
          ),
          const SizedBox(height: 25),
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.person,
              ),
              title: const Text(
                "Nama Lengkap",
              ),
              subtitle: Text(name),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.badge,
              ),
              title: const Text(
                "NIM",
              ),
              subtitle: Text(nim),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.alternate_email,
              ),
              title: const Text(
                "Username",
              ),
              subtitle: Text(username),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.feedback,
              ),
              title: const Text(
                "Komentar & Masukan",
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FeedbackScreen(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: () async {
              await SessionManager.logout();

              if (!context.mounted) {
                return;
              }

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
            label: const Text("LOGOUT"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              minimumSize: const Size(
                double.infinity,
                55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
