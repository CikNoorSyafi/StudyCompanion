import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  static const primary = Color(0xFF800000);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFB),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          "Admin Console",
          style: TextStyle(color: Colors.black),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications, color: primary),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👋 Welcome
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Welcome back,\nAdministrator",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),

            // 📊 STATS CARDS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: const [
                  StatCard("Students", "1,240", Icons.school),
                  StatCard("Teachers", "45", Icons.history_edu),
                  StatCard("Reports", "12", Icons.flag),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ⚡ QUICK ACTIONS
            sectionTitle("Quick Actions"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: const [
                  ActionCard("Students", Icons.school),
                  ActionCard("Teachers", Icons.history_edu),
                  ActionCard("Parents", Icons.family_restroom),
                  ActionCard("Analytics", Icons.bar_chart),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 📜 RECENT ACTIVITY
            sectionTitle("Recent Activity"),
            const ActivityTile("Mohd Rizwan", "Uploaded Mathematics Syllabus"),
            const ActivityTile("Siti Nurhaliza", "Requested password reset"),
            const ActivityTile("System", "New student registration"),

            const SizedBox(height: 80),
          ],
        ),
      ),

      // 🔻 BOTTOM NAV
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Users"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Messages"),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }

  static Widget sectionTitle(String text) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );
}

// 🔹 STATS CARD
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const StatCard(this.title, this.value, this.icon, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AdminDashboard.primary),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(title, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

// 🔹 ACTION CARD
class ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const ActionCard(this.title, this.icon, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AdminDashboard.primary),
          const Spacer(),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// 🔹 ACTIVITY TILE
class ActivityTile extends StatelessWidget {
  final String name;
  final String action;

  const ActivityTile(this.name, this.action, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(backgroundColor: Colors.grey),
      title: Text(name),
      subtitle: Text(action),
      trailing: const Text("2m ago"),
    );
  }
}
