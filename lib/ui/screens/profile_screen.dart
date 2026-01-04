import 'package:everyday_risk_analyzer/models/user.dart';
import 'package:everyday_risk_analyzer/ui/screens/splash_screen.dart';
import 'package:everyday_risk_analyzer/ui/widgets/default_appbar.dart';
import 'package:everyday_risk_analyzer/ui/widgets/setting_item.dart';
import 'package:flutter/material.dart';
import 'package:everyday_risk_analyzer/ui/theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  final UserProfile profile;
  final VoidCallback onThemeChange;
  final VoidCallback onProfileUpdated;

  const ProfileScreen({
    super.key,
    required this.profile,
    required this.onThemeChange,
    required this.onProfileUpdated,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserProfile _currentProfile;

  @override
  void initState() {
    super.initState();
    _currentProfile = widget.profile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(),
      body: ListView(
        children: [
          // Profile Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF1a2332)
                  : const Color(0xFFe3f2fd),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Avatar
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                    border: Border.all(color: AppTheme.accentColor, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accentColor.withValues(alpha: .3),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: AppTheme.accentColor,
                  ),
                ),
                const SizedBox(height: 16),
      
                // Name
                Text(
                  _currentProfile.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
      
                // Email
                Text(
                  _currentProfile.email,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 8),
      
                // Member Since
                Text(
                  'Member since ${_currentProfile.createdAt.day}/${_currentProfile.createdAt.month}/${_currentProfile.createdAt.year}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 20),
      
                // Edit Profile Button
                ElevatedButton.icon(
                  onPressed: () => () {
                    _showSnackBar("Edit profile comming soon!");
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Profile'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentColor,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
      
          // Settings Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'SETTINGS',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.grey[600],
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 12),
      
          // Privacy & Security
          SettingItem(
            icon: Icons.security,
            title: 'Privacy & Security',
            subtitle: 'Control your privacy',
            onTap: () {
              _showSnackBar('Privacy settings coming soon!');
            },
          ),
      
          // Appearance / Theme
          SettingItem(
            icon: Icons.color_lens,
            title: 'Appearance',
            subtitle: 'Toggle light/dark mode',
            onTap: () {
              widget.onThemeChange();
              _showSnackBar('Theme changed!');
            },
          ),
      
          // Language
          SettingItem(
            icon: Icons.language,
            title: 'Language',
            subtitle: 'English',
            onTap: () {
              _showSnackBar('Language settings coming soon!');
            },
          ),
      
          // Help & Support
          SettingItem(
            icon: Icons.help,
            title: 'Help & Support',
            subtitle: 'Get assistance',
            onTap: () {
              _showSnackBar('Help section coming soon!');
            },
          ),
      
          // About
          SettingItem(
            icon: Icons.info,
            title: 'About',
            subtitle: 'App information',
            onTap: () {
              _showSnackBar('About page coming soon!');
            },
          ),
      
          // Sign Out
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SplashScreen(onThemeChange: widget.onThemeChange),
                  ),
                  (route) => false, // remove all previous routes
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Sign out'),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
