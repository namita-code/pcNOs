import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Todo/todo_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  Widget? _todoPage;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const _HomeDashboard(),
      _todoPage ??= TodoPage(),
      const _ProfilePage(),
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink, Colors.pinkAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Branded header like AuthPage
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
                child: Row(
                  children: [
                    const Icon(Icons.favorite, color: Colors.white, size: 28),
                    const SizedBox(width: 10),
                    Text(
                      'pcNOs',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                        letterSpacing: .2,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.notifications_none, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: IndexedStack(
                  index: _index,
                  children: pages,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        height: 64,
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        backgroundColor: Colors.pink.withValues(alpha: .1),
        elevation: 6,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.checklist_outlined),
            selectedIcon: Icon(Icons.checklist),
            label: 'Todo',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _HomeDashboard extends StatelessWidget {
  const _HomeDashboard();

  static const double radius = 20;
  static const Color accent = Colors.pinkAccent;

  BoxDecoration get _cardDecoration => BoxDecoration(
    color: Colors.white.withValues(alpha: .95),
    borderRadius: BorderRadius.circular(radius),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.4),
        blurRadius: 25,
        spreadRadius: 3,
        offset: const Offset(0, 10),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero CTA card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: _cardDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back 👋',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: accent,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Track symptoms, learn, and stay consistent with your plan.',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 8,
                      shadowColor: accent.withValues(alpha: .5),
                    ),
                    onPressed: () => Navigator.pushNamed(context, '/symptoms'),
                    icon: const Icon(Icons.play_circle_fill),
                    label: Text('Continue assessment',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 50),

          // Quick actions grid
          GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 1.1,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _HomeTile(
                title: 'Daily log',
                subtitle: 'Meals • Mood • Sleep',
                icon: Icons.checklist_rtl,
                onTap: () => Navigator.pushNamed(context, '/dailyLog'),
              ),
              _HomeTile(
                title: 'Progress',
                subtitle: 'Trends & streaks',
                icon: Icons.show_chart,
                onTap: () => Navigator.pushNamed(context, '/progress'),
              ),
              _HomeTile(
                title: 'PCOS guide',
                subtitle: 'Diet • Exercise',
                icon: Icons.menu_book_rounded,
                onTap: () => Navigator.pushNamed(context, '/learn'),
              ),
              _HomeTile(
                title: 'Reminders',
                subtitle: 'Hydration • Pills',
                icon: Icons.alarm_rounded,
                onTap: () => Navigator.pushNamed(context, '/reminders'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Tip card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .95),
              borderRadius: BorderRadius.circular(radius),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb, color: accent),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Tip: Consistent sleep (7–9h) supports insulin sensitivity and symptom management.',
                    style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[900]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _HomeTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accent = Colors.pinkAccent;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .95),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: accent.withValues(alpha: .15),
                child: Icon(icon, color: accent),
              ),
              const Spacer(),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: accent,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 12.5,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LearnPage extends StatelessWidget {
  const _LearnPage();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Learn resources coming soon',
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
      ),
    );
  }
}

class _ProfilePage extends StatelessWidget {
  const _ProfilePage();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Profile',
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
