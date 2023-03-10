import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MostPopular extends StatelessWidget {
  const MostPopular({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StaggeredGrid.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: <Widget>[
            _tile(Colors.green),
            _tile(Colors.lightBlue),
            _tile(Colors.amber),
            _tile(Colors.brown),
            _tile(Colors.deepOrange),
            _tile(Colors.indigo),
            _tile(Colors.red),
            _tile(Colors.pink),
            _tile(Colors.purple),
            _tile(Colors.blue),
            _tile(Colors.green),
            _tile(Colors.lightBlue),
            _tile(Colors.amber),
            _tile(Colors.brown),
            _tile(Colors.deepOrange),
            _tile(Colors.indigo),
            _tile(Colors.red),
            _tile(Colors.pink),
            _tile(Colors.purple),
            _tile(Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _tile(Color color) {
    return Stack(
      children: [
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: Image.asset('assets/girl.jpg').image,
              fit: BoxFit.cover,
            ),
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const Positioned(
          top: 0,
          left: 0,
          child: SizedBox(
            width: 50,
            height: 50,
            child: Icon(
              Icons.verified,
              color: Colors.blue,
            ),
          ),
        ),
        //Ranking number
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            width: 70,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: const Center(
              child: Text(
                '# 100',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: Container(
            width: 200,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: const [
                  Text(
                    'Ayush Kumar Pandit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'MME 2020-2024',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
