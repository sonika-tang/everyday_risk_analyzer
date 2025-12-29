import 'package:everyday_risk_analyzer/data/mock_risks.dart';
import 'package:everyday_risk_analyzer/models/risk.dart';
import 'package:everyday_risk_analyzer/ui/screens/splash_screen.dart';
import 'package:everyday_risk_analyzer/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onThemeChange;

  const ProfileScreen({super.key, required this.onThemeChange});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<UserProfile> futureProfile;

  @override
  void initState() {
    super.initState();
    futureProfile = StorageService.loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfile>(
      future: futureProfile,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

        UserProfile profile = snapshot.data!;

        return ListView(
          children: [
            SizedBox(height: 30),
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor,
                      border: Border.all(color: AppTheme.accentColor, width: 2),
                    ),
                    child: Icon(Icons.person, size: 50, color: AppTheme.accentColor),
                  ),
                  SizedBox(height: 16),
                  Text(profile.name, style: Theme.of(context).textTheme.headlineMedium),
                  Text(profile.email, style: Theme.of(context).textTheme.bodySmall),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).brightness == Brightness.dark
                          ? Color(0xFF1a2332)
                          : Color(0xFFe3f2fd),
                    ),
                    child: Text('Edit Profile'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            _buildSettingItem(Icons.person, 'Account Settings', () {}),
            _buildSettingItem(Icons.security, 'Privacy & Security', () {}),
            _buildSettingItem(Icons.notifications, 'Notifications', () {}),
            ListTile(
              leading: Icon(Icons.palette, color: Colors.grey),
              title: Text('Appearance'),
              trailing: Switch(
                value: profile.isDarkMode,
                onChanged: (value) async {
                  profile.isDarkMode = value;
                  await StorageService.saveProfile(profile);
                  widget.onThemeChange();
                },
                activeThumbColor: AppTheme.accentColor,
              ),
            ),
            _buildSettingItem(Icons.language, 'Language', () {}, trailing: Text('English', style: TextStyle(color: Colors.grey))),
            _buildSettingItem(Icons.help, 'Help & Support', () {}),
            _buildSettingItem(Icons.info, 'About', () {}),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SplashScreen(onThemeChange: widget.onThemeChange))),
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFef4444)),
                child: Text('Sign out'),
              ),
            ),
            SizedBox(height: 30),
          ],
        );
      },
    );
  }

  Widget _buildSettingItem(IconData icon, String title, VoidCallback onTap, {Widget? trailing}) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title),
      trailing: trailing ?? Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}