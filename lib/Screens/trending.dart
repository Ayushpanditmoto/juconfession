import 'package:flutter/material.dart';

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
                  FeatureNot(),
                  FeatureNot(),
                  FeatureNot(),
                  // MostPopular(),
                  // PopularGirls(),
                  // PopularBoys(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureNot extends StatelessWidget {
  const FeatureNot({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          //once we reach 100 User This feature will be available
          // Text(
          //   'Feature Not Available',
          //   style: TextStyle(
          //     fontSize: 17,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Once we reach 100 Users',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'This feature will be Automatically available',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
