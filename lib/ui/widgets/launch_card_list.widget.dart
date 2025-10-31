import 'package:flutter/widgets.dart';

class LaunchCardList extends StatelessWidget {
  final List<Widget> cards;

  const LaunchCardList({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: cards,
      ),
    );
  }
}