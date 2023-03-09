import 'package:flutter/material.dart';
import 'package:juconfession/Screens/most.popular.dart';
import 'package:juconfession/Screens/popular.girls.dart';

import 'popular.boys.dart';

class TrendingPage extends StatelessWidget {
  const TrendingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Trending'),
          centerTitle: true,
        ),
        body: Column(
          children: const [
            TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.trending_up),
                  text: 'Most Followers',
                ),
                Tab(
                  icon: Icon(Icons.girl),
                  text: 'Famous Girls',
                ),
                Tab(
                  icon: Icon(Icons.boy_rounded),
                  text: 'Famous Boys',
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  MostPopular(),
                  PopularGirls(),
                  PopularBoys(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
