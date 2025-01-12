import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(height: 100,),
          ListTile(
            onTap: () {
              launch('https://www.muhuratam.com/');
            },
            leading: const Icon(Icons.web),
            title: const Text('Website'),
          ),
          ListTile(
            onTap: () {
              launch('https://www.muhuratam.com/privacy-and-policy/');
            },
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy and Policy'),
          ),
          const SizedBox(height: 50,),
          const Divider(),
          const Text('Version 1.2.0',style: TextStyle(fontSize: 12),)
        ],
      ),
    );
  }
}
