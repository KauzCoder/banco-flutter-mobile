import 'package:flutter/material.dart';

class ModuleTile extends StatelessWidget {
  const ModuleTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.routeName,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.of(context).pushNamed(routeName),
      ),
    );
  }
}
