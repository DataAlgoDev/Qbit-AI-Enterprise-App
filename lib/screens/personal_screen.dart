import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../services/rag_service.dart';

class PersonalScreen extends StatefulWidget {
  const PersonalScreen({super.key});

  @override
  State<PersonalScreen> createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {
  final List<String> _selectedInterests = [];
  List<Map<String, dynamic>> _aiRecommendations = [];
  bool _isLoadingRecommendations = false;
  final List<String> _availableInterests = [
    'AI Engineering',
    'Machine Learning',
    'Mobile Development',
    'Web Development',
    'Cloud Computing',
    'Data Science',
    'Cybersecurity',
    'DevOps',
    'UI/UX Design',
    'Project Management',
    'Leadership',
    'Public Speaking',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Section'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(MdiIcons.cog),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            _buildProfileSection(),
            const SizedBox(height: 24),
            
            // Interests Section
            _buildSectionHeader('Your Interests', MdiIcons.heart),
            const SizedBox(height: 12),
            _buildInterestsSection(),
            const SizedBox(height: 24),
            
            // Goals Section
            // _buildSectionHeader('Career Goals', MdiIcons.target),
            // const SizedBox(height: 12),
            // _buildGoalsSection(),
            // const SizedBox(height: 24),
            
            // Recommendations Section
            _buildSectionHeader('AI Recommendations', MdiIcons.lightbulbOn),
            const SizedBox(height: 12),
            _buildRecommendationsSection(),
            const SizedBox(height: 24),
            
            // Health Metrics Section
            _buildSectionHeader('Health & Wellness', MdiIcons.heartPulse),
            const SizedBox(height: 12),
            _buildHealthSection(),
            const SizedBox(height: 24),
            
            // Active Tickets Section
            _buildSectionHeader('Active Tickets', MdiIcons.ticketConfirmation),
            const SizedBox(height: 12),
            _buildActiveTicketsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: const Color(0xFF1565C0),
              child: Icon(
                MdiIcons.account,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ajay Narayanan',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Software Developer',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Engineering Team',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
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

  Widget _buildInterestsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select your interests to get personalized recommendations:',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableInterests.map((interest) {
                final isSelected = _selectedInterests.contains(interest);
                return FilterChip(
                  label: Text(interest),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedInterests.add(interest);
                      } else {
                        _selectedInterests.remove(interest);
                      }
                    });
                    // Trigger AI recommendations update
                    _fetchAIRecommendations();
                  },
                  selectedColor: const Color(0xFF1565C0).withValues(alpha: 0.2),
                  checkmarkColor: const Color(0xFF1565C0),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _fetchAIRecommendations() async {
    if (_selectedInterests.isEmpty) {
      if (mounted) {
        setState(() {
          _aiRecommendations = [];
          _isLoadingRecommendations = false;
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        _isLoadingRecommendations = true;
      });
    }

    try {
      final interestsText = _selectedInterests.join(', ');
      final prompt = """Based on these professional interests: $interestsText, recommend exactly 3 relevant courses, certifications, or training programs. For each recommendation, provide in this format:

1. Course Title Here
Brief description of what it covers and why it's relevant
Platform: Provider name | Duration: estimated time | Level: Beginner/Intermediate/Advanced

2. Course Title Here
Brief description of what it covers and why it's relevant  
Platform: Provider name | Duration: estimated time | Level: Beginner/Intermediate/Advanced

3. Course Title Here
Brief description of what it covers and why it's relevant
Platform: Provider name | Duration: estimated time | Level: Beginner/Intermediate/Advanced

Use this exact format. No extra introductory text.""";
      
      final response = await RagService.sendMessage(prompt);
      
      // Parse the AI response into structured recommendations
      final recommendations = _parseAIRecommendations(response['response'] ?? '');
      
      // Only call setState if the widget is still mounted
      if (mounted) {
        setState(() {
          _aiRecommendations = recommendations;
          _isLoadingRecommendations = false;
        });
      }
    } catch (e) {
      // Only call setState if the widget is still mounted
      if (mounted) {
        setState(() {
          _isLoadingRecommendations = false;
          _aiRecommendations = [];
        });
      }
      print('Error fetching AI recommendations: $e');
    }
  }

  List<Map<String, dynamic>> _parseAIRecommendations(String aiResponse) {
    final recommendations = <Map<String, dynamic>>[];
    
    // Clean up the response by removing markdown and extra formatting
    String cleanResponse = aiResponse
        .replaceAll(RegExp(r'\*\*'), '') // Remove bold markdown
        .replaceAll(RegExp(r'^\s*Here are.*?\n', multiLine: true), '') // Remove intro lines
        .replaceAll(RegExp(r'^\s*Based on.*?\n', multiLine: true), '') // Remove intro lines
        .replaceAll('[', '').replaceAll(']', '') // Remove brackets
        .trim();
    
    // Split by numbered items (1., 2., 3., etc.)
    final numberedSections = cleanResponse.split(RegExp(r'\n(?=\d+\.\s)'));
    
    for (final section in numberedSections) {
      if (section.trim().isEmpty) continue;
      
      final lines = section.split('\n').map((line) => line.trim()).where((line) => line.isNotEmpty).toList();
      if (lines.isEmpty) continue;
      
      String title = '';
      String description = '';
      String details = '';
      
      for (int i = 0; i < lines.length; i++) {
        final line = lines[i];
        
        // First line after number is usually the title
        if (i == 0) {
          title = line.replaceAll(RegExp(r'^\d+\.\s*'), '').trim();
        }
        // Lines starting with "Platform:" are details
        else if (line.toLowerCase().startsWith('platform:')) {
          details = line.replaceAll(RegExp(r'^platform:\s*', caseSensitive: false), '').trim();
        }
        // Other lines are description
        else if (description.isEmpty && line.length > 10) {
          description = line.trim();
        }
        // Additional description or details
        else if (line.length > 5) {
          if (line.toLowerCase().contains('duration') || line.toLowerCase().contains('level') || 
              line.toLowerCase().contains('platform') || line.toLowerCase().contains('provider')) {
            details += (details.isEmpty ? '' : ' • ') + line.trim();
          } else if (description.length < 100) {
            description += (description.isEmpty ? '' : ' ') + line.trim();
          }
        }
      }
      
      // Validate and clean up extracted data
      if (title.isNotEmpty && title.length > 3) {
        // Clean and format title
        if (title.endsWith(':')) title = title.substring(0, title.length - 1);
        title = title.trim();
        
        // Set default description if empty
        if (description.isEmpty) {
          description = 'Recommended course based on your interests in ${_selectedInterests.join(', ').toLowerCase()}';
        }
        
        // Set default details if empty  
        if (details.isEmpty) {
          details = 'Online course • Self-paced learning';
        }
        
        // Truncate if too long
        if (title.length > 60) title = title.substring(0, 57) + '...';
        if (description.length > 120) description = description.substring(0, 117) + '...';
        if (details.length > 80) details = details.substring(0, 77) + '...';
        
        recommendations.add({
          'title': title,
          'description': description,
          'details': details,
          'icon': _getIconForRecommendation(title + ' ' + description),
          'color': _getColorForRecommendation(title + ' ' + description),
        });
      }
    }
    
    // Fallback: If structured parsing failed, try simple sentence splitting
    if (recommendations.isEmpty && cleanResponse.isNotEmpty) {
      // Remove any remaining numbers and split by lines
      final lines = cleanResponse
          .replaceAll(RegExp(r'^\d+\.\s*', multiLine: true), '')
          .split('\n')
          .where((line) => line.trim().length > 15)
          .take(4)
          .toList();
      
      for (int i = 0; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.isNotEmpty) {
          String title = 'Learning Path ${i + 1}';
          String description = line;
          
          // Try to extract a meaningful title from the content
          final words = line.split(' ');
          if (words.length >= 2) {
            // Take first few words as title if they seem like a course name
            final potentialTitle = words.take(4).join(' ');
            if (potentialTitle.length < 50 && !potentialTitle.contains('|')) {
              title = potentialTitle;
              description = line.length > potentialTitle.length + 10 
                  ? line.substring(potentialTitle.length).trim() 
                  : 'Comprehensive learning path for your interests';
            }
          }
          
          recommendations.add({
            'title': title,
            'description': description.length > 100 ? description.substring(0, 97) + '...' : description,
            'details': 'AI-recommended learning path',
            'icon': MdiIcons.bookOpenPageVariant,
            'color': [Colors.blue, Colors.green, Colors.orange, Colors.purple][i % 4],
          });
        }
      }
    }
    
    return recommendations.take(3).toList(); // Limit to 3 as per prompt
  }

  IconData _getIconForRecommendation(String title) {
    final titleLower = title.toLowerCase();
    if (titleLower.contains('course') || titleLower.contains('learning')) return MdiIcons.schoolOutline;
    if (titleLower.contains('webinar') || titleLower.contains('workshop')) return MdiIcons.presentation;
    if (titleLower.contains('certification') || titleLower.contains('cert')) return MdiIcons.certificateOutline;
    if (titleLower.contains('conference') || titleLower.contains('meetup')) return MdiIcons.accountGroup;
    return MdiIcons.bookOpenPageVariant;
  }

  Color _getColorForRecommendation(String title) {
    final titleLower = title.toLowerCase();
    if (titleLower.contains('ai') || titleLower.contains('machine learning')) return Colors.purple;
    if (titleLower.contains('mobile') || titleLower.contains('flutter') || titleLower.contains('app')) return Colors.blue;
    if (titleLower.contains('web') || titleLower.contains('frontend') || titleLower.contains('backend')) return Colors.green;
    if (titleLower.contains('cloud') || titleLower.contains('aws') || titleLower.contains('azure')) return Colors.orange;
    if (titleLower.contains('data') || titleLower.contains('analytics')) return Colors.teal;
    if (titleLower.contains('security') || titleLower.contains('cyber')) return Colors.red;
    return Colors.indigo;
  }

  Widget _buildRecommendationsSection() {
    if (_selectedInterests.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              MdiIcons.lightbulbOutline,
              size: 64,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Select your interests above',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'I\'ll recommend relevant courses and webinars using AI',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (_isLoadingRecommendations) {
      return Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'AI is finding recommendations for you...',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    if (_aiRecommendations.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              MdiIcons.alertCircleOutline,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No recommendations found',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try selecting different interests or check your connection',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      children: _aiRecommendations.map((recommendation) => _buildRecommendationCard(
        recommendation['title'],
        recommendation['description'],
        recommendation['details'],
        recommendation['icon'],
        recommendation['color'],
      )).toList(),
    );
  }

  Widget _buildRecommendationCard(String title, String description, String details, IconData icon, Color color) {
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
              child: Icon(icon, color: color, size: 24),
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
                  const SizedBox(height: 4),
                  Text(
                    details,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            Icon(MdiIcons.chevronRight, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Annual Health Checkup Reminder',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your annual health checkup is due next month. Book your appointment to maintain optimal health.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Navigate to health booking
                    },
                    icon: Icon(MdiIcons.calendarPlus),
                    label: const Text('Book Appointment'),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    // TODO: View health tips
                  },
                  icon: Icon(MdiIcons.lightbulbOn),
                  label: const Text('Health Tips'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveTicketsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ticket Header
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(
                    MdiIcons.laptop,
                    color: Colors.orange,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'IT-2024-1247',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.orange.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'In Progress',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Outlook Email Sync Issues',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1565C0).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Medium',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1565C0),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Ticket Details
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Email sync problems with Outlook mobile app, not receiving new emails automatically. IT team is investigating server configuration.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Ticket Info Grid
            Row(
              children: [
                Expanded(
                  child: _buildTicketInfoItem(
                    MdiIcons.calendar,
                    'Submitted',
                    'Sept 15, 2024',
                  ),
                ),
                Expanded(
                  child: _buildTicketInfoItem(
                    MdiIcons.clockOutline,
                    'Expected Fix',
                    'Sept 18, 2024',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTicketInfoItem(
                    MdiIcons.accountTie,
                    'Assigned To',
                    'Hemant D',
                  ),
                ),
                Expanded(
                  child: _buildTicketInfoItem(
                    MdiIcons.update,
                    'Last Update',
                    'Sept 16',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Latest Update
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[100]!),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    MdiIcons.informationOutline,
                    color: const Color(0xFF1565C0),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Latest Update:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1565C0),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Applied initial server patch, monitoring results.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: View ticket details
                    },
                    icon: Icon(MdiIcons.eye, size: 16),
                    label: const Text('View Details'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Add comment or contact IT
                    },
                    icon: Icon(MdiIcons.message, size: 16),
                    label: const Text('Add Comment'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketInfoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            const SizedBox(width: 18), // Align with icon
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

}

// class Goal {
//   final String title;
//   final String description;
//   final double progress;
//   final String category;
//   final DateTime dueDate;
//
//   Goal({
//     required this.title,
//     required this.description,
//     required this.progress,
//     required this.category,
//     required this.dueDate,
//   });
// }
