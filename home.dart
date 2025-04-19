import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  int? _lastConversationId;

  void _onItemTapped(int index) async {
    if (index == 1) {
      final conversationId = await Navigator.pushNamed(context, '/chat');
      if (conversationId is int) {
        setState(() {
          _lastConversationId = conversationId;
        });
      }
    } else if (index == 2) {
      if (_lastConversationId != null) {
        Navigator.pushNamed(
          context,
          '/insights',
          arguments: _lastConversationId,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No conversation found. Start chatting first."),
          ),
        );
      }
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : null,
        title: const Text("Consultation", style: TextStyle(color: Colors.white)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(40),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
              child: const CircleAvatar(
                backgroundImage: AssetImage('assets/profile.jpg'),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Type here to start a conversation with the AI agent...',
                hintStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[850],
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle("Insights session", trailing: "Review past"),
            _buildInsightTile("Personalized advice"),
            _buildInsightTile("Heart health assessment"),
            const SizedBox(height: 20),
            _buildSectionTitle("Prescribed medications", trailing: "View all"),
            _buildIconGrid([
              _gridItem(Icons.local_pharmacy, "Anti-anxiety"),
              _gridItem(Icons.spa, "Relaxation"),
              _gridItem(Icons.medication, "Mood stabilizers"),
            ]),
            const SizedBox(height: 20),
            _buildSectionTitle("AI agent locator", trailing: "View all"),
            _buildIconGrid([
              _gridItem(Icons.place, "Therapy"),
              _gridItem(Icons.health_and_safety, "Oral health tips"),
              _gridItem(Icons.science, "Genetic"),
              _gridItem(Icons.medical_services, "Counselor"),
              _gridItem(Icons.psychology, "Anxiety"),
              _gridItem(Icons.favorite, "Heart rate"),
            ]),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Insights')
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, {String? trailing}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        if (trailing != null)
          Text(trailing, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildInsightTile(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white)),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text("View", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildIconGrid(List<Widget> children) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: children,
    );
  }

  Widget _gridItem(IconData icon, String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
