// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:carousel_slider/carousel_slider.dart';
//
// class TourPage extends StatefulWidget {
//   const TourPage({super.key});
//
//   @override
//   _TourPageState createState() => _TourPageState();
// }
//
// class _TourPageState extends State<TourPage> {
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   Future<String> _savetour() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setInt('firstlaunch', 1);
//     Navigator.pushNamed(context, '/');
//     return 'saved';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final double height = MediaQuery.of(context).size.height;
//     ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
//     List<String> list = [
//       "assets/img/sc1.jpg",
//       "assets/img/sc2.jpg",
//       "assets/img/sc3.jpg",
//       "assets/img/sc4.jpg",
//       "assets/img/sc5.jpg"
//     ];
//     return Scaffold(
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 0.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: <Widget>[
//             Container(
//               margin: const EdgeInsets.only(top: 00.0),
//               child: ElevatedButton(
//                 onPressed: () {
//                   _savetour();
//                 },
//                 style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 30, vertical: 20),
//                     textStyle: const TextStyle(
//                         fontSize: 15, fontWeight: FontWeight.bold)),
//                 child: const Text('Skip the tour'),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
//               child: CarouselSlider(
//                 options: CarouselOptions(
//                     height: height, autoPlay: true, viewportFraction: 1),
//                 items: list
//                     .map((item) => Center(
//                         child:
//                             Image.asset(item.toString(), fit: BoxFit.contain)))
//                     .toList(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';

class TourPage extends StatefulWidget {
  const TourPage({super.key});

  @override
  _TourPageState createState() => _TourPageState();
}

class _TourPageState extends State<TourPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<String> _saveTour() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('firstlaunch', 1);
    Navigator.pushNamed(context, '/');
    return 'saved';
  }

  @override
  Widget build(BuildContext context) {
    // Get the total screen height
    final double totalHeight = MediaQuery.of(context).size.height;

    // Get the padding caused by the safe area
    final EdgeInsets padding = MediaQuery.of(context).padding;

    // Calculate the height excluding the safe area
    final double heightExcludingSafeArea = totalHeight - padding.top - padding.bottom;

    // final double height = MediaQuery.of(context).size.height;
    // final double width = MediaQuery.of(context).size.width;

    List<String> list = [
      "assets/img/sc1.jpg",
      "assets/img/sc2.jpg",
      "assets/img/sc31.jpg",
      "assets/img/sc41.jpg",
      "assets/img/sc5.jpg"
    ];

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      // vertical: 5,
                      // horizontal: 20,
                    ),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: heightExcludingSafeArea,
                        autoPlay: true,
                        viewportFraction: 1,
                      ),
                      items: list.map((item) {
                        return SizedBox(
                          // width: width,
                          // height: heightExcludingSafeArea,
                          child: Image.asset(
                            item,
                            fit: BoxFit.fitHeight,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              // top: 10,
              right: 10,
              bottom: 10,
              child: ElevatedButton(
                onPressed: _saveTour,
                style: ElevatedButton.styleFrom(
                  elevation: 4,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                child: const Text('Skip the tour'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
