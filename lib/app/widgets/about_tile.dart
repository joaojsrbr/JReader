import 'package:flutter/material.dart';

class AboutTile extends StatelessWidget {
  final String title;
  final String value;

  const AboutTile({
    required this.title,
    required this.value,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 2.5,
        ),
      ),
      subtitle: Text(value, style: const TextStyle(fontSize: 14)),
    );
  }
}

class AboutTileGenders extends StatelessWidget {
  final List<String> genders;

  const AboutTileGenders({
    required this.genders,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          'Gêneros',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 2.5,
          ),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      subtitle: SizedBox(
        height: 32,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          scrollDirection: Axis.horizontal,
          itemCount: genders.length,
          itemBuilder: (ctx, index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Chip(
                backgroundColor: Colors.blue[600],
                label: Text(genders[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}
