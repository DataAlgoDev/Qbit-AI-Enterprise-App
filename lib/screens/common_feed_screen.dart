import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:intl/intl.dart';
import '../services/rag_service.dart';

class CommonFeedScreen extends StatefulWidget {
  const CommonFeedScreen({super.key});
  
  @override
  State<CommonFeedScreen> createState() => _CommonFeedScreenState();
}

class _CommonFeedScreenState extends State<CommonFeedScreen> {
  List<Map<String, dynamic>> _newsletters = [];
  bool _isLoadingNewsletters = true;

  @override
  void initState() {
    super.initState();
    _loadNewsletters();
  }

  Future<void> _loadNewsletters() async {
    try {
      final newsletters = await RagService.generateNewsletters(count: 2);
      if (mounted) {
        setState(() {
          _newsletters = newsletters;
          _isLoadingNewsletters = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingNewsletters = false;
        });
      }
    }
  }

  Future<void> _refreshContent() async {
    setState(() {
      _isLoadingNewsletters = true;
    });
    await _loadNewsletters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Common Feed', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshContent,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Calendar Events Section
            _buildSectionHeader('Calendar Events', MdiIcons.calendar),
            const SizedBox(height: 8),
            _buildCalendarEventCard(
              'Team Meeting',
              'Weekly sync with development team',
              DateTime.now().add(const Duration(hours: 2)),
              Colors.blue,
            ),
            _buildCalendarEventCard(
              'Company All-Hands',
              'Quarterly company update and announcements',
              DateTime.now().add(const Duration(days: 1)),
              Colors.green,
            ),
            const SizedBox(height: 24),
            
            // AI Newsletter Section
            _buildSectionHeader('AI Tech Newsletter', MdiIcons.newspaper),
            const SizedBox(height: 8),
            // Dynamic newsletters
            if (_isLoadingNewsletters)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: CircularProgressIndicator(),
                ),
              )
            else
              ..._newsletters.map((newsletter) => _buildNewsletterCard(
                    newsletter['title'] ?? 'Tech Update',
                    newsletter['description'] ?? 'Latest technology updates.',
                    newsletter['category'] ?? 'Technology',
                    _getCategoryColor(newsletter['category'] ?? 'Technology'),
                  )),
            const SizedBox(height: 24),
            
            // Announcements Section
            _buildSectionHeader('Announcements', MdiIcons.bullhorn),
            const SizedBox(height: 8),
            _buildAnnouncementCard(
              'New Health Insurance Benefits',
              'We are excited to announce enhanced health insurance coverage for all employees. The new plan includes dental and vision coverage.',
              DateTime.now().subtract(const Duration(hours: 3)),
              Colors.orange,
            ),
            _buildAnnouncementCard(
              'Office Renovation Update',
              'The office renovation on the 3rd floor will begin next Monday. Please use alternative routes during construction.',
              DateTime.now().subtract(const Duration(days: 1)),
              Colors.purple,
            ),
            const SizedBox(height: 24),
            
            // Celebrations Section
            _buildSectionHeader('Celebrations', MdiIcons.partyPopper),
            const SizedBox(height: 8),
            _buildCelebrationCard(
              'Birthday Today! 🎉',
              'Wish Sarah Johnson from Marketing a happy birthday!',
              Colors.pink,
            ),
            _buildCelebrationCard(
              'Work Anniversary',
              'Congratulations to Mike Chen on completing 3 years with the company!',
              Colors.amber,
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'ai & software engineering':
        return Colors.teal;
      case 'electronics & dft':
        return Colors.deepOrange;
      default:
        return Colors.blue; // Fallback color
    }
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF1565C0), size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1565C0),
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarEventCard(String title, String description, DateTime dateTime, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 60,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(MdiIcons.clockOutline, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('MMM dd, yyyy - HH:mm').format(dateTime),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnnouncementCard(String title, String content, DateTime dateTime, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'ANNOUNCEMENT',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  DateFormat('MMM dd, HH:mm').format(dateTime),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsletterCard(String title, String description, String category, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    category.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(MdiIcons.openInNew, size: 16, color: Colors.grey[600]),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCelebrationCard(String title, String description, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                MdiIcons.partyPopper,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
