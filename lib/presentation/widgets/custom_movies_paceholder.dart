import 'package:flutter/material.dart';

class CinemaPlaceholderList extends StatelessWidget {
  final int itemCount;
  final Color baseColor;

  const CinemaPlaceholderList({
    super.key,
    this.itemCount = 6,
    this.baseColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        return ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          title: Container(
            height: 14,
            width: double.infinity,
            color: baseColor.withOpacity(0.8),
          ),
          subtitle: Container(
            margin: const EdgeInsets.only(top: 6),
            height: 12,
            width: MediaQuery.of(context).size.width * 0.5,
            color: baseColor.withOpacity(0.8),
          ),
          trailing: Icon(Icons.arrow_forward_ios_rounded,
              size: 16, color: baseColor.withOpacity(0.8)),
        );
      },
    );
  }
}
