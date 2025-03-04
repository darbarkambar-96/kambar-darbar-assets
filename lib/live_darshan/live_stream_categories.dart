// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:darbar_app_of_kambar_darbar/ScreenArguments.dart';
// import 'dart:io' show Platform;
//
// class LiveStreamCategories extends StatefulWidget {
//   const LiveStreamCategories({super.key});
//
//   @override
//   _LiveStreamCategoriesState createState() => _LiveStreamCategoriesState();
// }
//
// class _LiveStreamCategoriesState extends State<LiveStreamCategories> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text(
//           'Live Darshan From Darbar',
//           style: GoogleFonts.poppins(
//             textStyle: Theme.of(context).textTheme.bodySmall,
//             fontSize: 20,
//             color: Colors.indigoAccent,
//             fontWeight: FontWeight.w600,
//             fontStyle: FontStyle.normal,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             Row(
//               children: <Widget>[
//                 Expanded(
//                   child: InkWell(
//                     onTap: () {
//                       if (Platform.isAndroid) {
//                         SystemChrome.setPreferredOrientations([
//                           DeviceOrientation.landscapeRight,
//                           DeviceOrientation.landscapeLeft,
//                         ]);
//                         Navigator.pushNamed(context, '/livevideo',
//                             arguments: ScreenArguments(
//                                 1,
//                                 "rtsp://admin:Globotech@12345@182.48.203.143:1026",
//                                 1));
//                       } else {
//                         Navigator.pushNamed(context, '/livevideo',
//                             arguments: ScreenArguments(
//                                 1,
//                                 "https://rtsp.me/embed/kGKeFAER/",
//                                 1));
//
//                         // GoogleFonts.poppins(
//                         //   textStyle:
//                         //   Theme.of(context).textTheme.bodyMedium,
//                         //   fontSize: 18,
//                         //   color: Colors.blueAccent,
//                         //   fontWeight: FontWeight.w600,
//                         //   fontStyle: FontStyle.normal,
//                         // ),
//
//                         //
//                         // Fluttertoast.showToast(
//                         //     msg: "Stay tuned. We are launching soon.",
//                         //     toastLength: Toast.LENGTH_LONG,
//                         //     gravity: ToastGravity.SNACKBAR,
//                         //     timeInSecForIosWeb: 2,
//                         //     backgroundColor: Colors.white,
//                         //     textColor: Colors.blueAccent,
//                         //     fontSize: 18.0);
//                       }
//                     },
//                     child: Card(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: <Widget>[
//                           ClipRRect(
//                             borderRadius: const BorderRadius.only(
//                               topLeft: Radius.circular(8.0),
//                               topRight: Radius.circular(8.0),
//                             ),
//                             child: Image.asset(
//                               'assets/img/cam1.jpg',
//                               width: double.infinity,
//                               // Make the image take the full width
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           Container(
//                             decoration: const BoxDecoration(
//                                 border: Border(top: BorderSide(width: 1))),
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 10, vertical: 5),
//                             alignment: Alignment.center,
//                             child: Text(
//                               "Sainjans Room",
//                               style: GoogleFonts.poppins(
//                                 textStyle:
//                                     Theme.of(context).textTheme.bodyMedium,
//                                 fontSize: 18,
//                                 color: Colors.blueAccent,
//                                 fontWeight: FontWeight.w600,
//                                 fontStyle: FontStyle.normal,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: InkWell(
//                     onTap: () {
//
//                       if (Platform.isAndroid) {
//                         SystemChrome.setPreferredOrientations([
//                           DeviceOrientation.landscapeRight,
//                           DeviceOrientation.landscapeLeft,
//                         ]);
//                         Navigator.pushNamed(context, '/livevideo',
//                             arguments: ScreenArguments(
//                                 1,
//                                 "rtsp://admin:Globotech@12345@182.48.203.143:1024",
//                                 2));
//                       } else {
//                         Navigator.pushNamed(context, '/livevideo',
//                             arguments: ScreenArguments(
//                                 1,
//                                 "https://rtsp.me/embed/dFTdiiR7/",
//                                 2));
//                         // Fluttertoast.showToast(
//                         //     msg: "Stay tuned. We are launching soon.",
//                         //     toastLength: Toast.LENGTH_LONG,
//                         //     gravity: ToastGravity.SNACKBAR,
//                         //     timeInSecForIosWeb: 1,
//                         //     backgroundColor: Colors.white,
//                         //     textColor: Colors.blueAccent,
//                         //     fontSize: 18.0);
//                       }
//                     },
//                     child: Card(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: <Widget>[
//                           ClipRRect(
//                             borderRadius: const BorderRadius.only(
//                               topLeft: Radius.circular(8.0),
//                               topRight: Radius.circular(8.0),
//                             ),
//                             child: Image.asset(
//                               'assets/img/cam2.jpg',
//                               width: double.infinity,
//                               // Make the image take the full width
//                               fit: BoxFit
//                                   .cover, // Ensure the image covers the entire space
//                             ),
//                           ),
//                           Container(
//                             decoration: const BoxDecoration(
//                                 border: Border(top: BorderSide(width: 1))),
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 10, vertical: 5),
//                             alignment: Alignment.center,
//                             child: Text(
//                               "Gurus Room",
//                               style: GoogleFonts.poppins(
//                                 textStyle:
//                                     Theme.of(context).textTheme.bodyMedium,
//                                 fontSize: 18,
//                                 color: Colors.blueAccent,
//                                 fontWeight: FontWeight.w600,
//                                 fontStyle: FontStyle.normal,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Row(
//               children: <Widget>[
//                 Expanded(
//                   child: InkWell(
//                     onTap: () {
//
//                       if (Platform.isAndroid) {
//                         SystemChrome.setPreferredOrientations([
//                           DeviceOrientation.landscapeRight,
//                           DeviceOrientation.landscapeLeft,
//                         ]);
//                         Navigator.pushNamed(context, '/livevideo',
//                             arguments: ScreenArguments(
//                                 1,
//                                 "rtsp://admin:Globotech@12345@182.48.203.143:1025",
//                                 3));
//                       } else {
//                         Navigator.pushNamed(context, '/livevideo',
//                             arguments: ScreenArguments(
//                                 1,
//                                 "https://rtsp.me/embed/tfNGQ5TA/",
//                                 3));
//                       }
//                     },
//                     child: Card(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: <Widget>[
//                           ClipRRect(
//                             borderRadius: const BorderRadius.only(
//                               topLeft: Radius.circular(8.0),
//                               topRight: Radius.circular(8.0),
//                             ),
//                             child: Image.asset(
//                               'assets/img/cam3.jpg',
//                               width: double.infinity,
//                               // Make the image take the full width
//                               fit: BoxFit
//                                   .cover, // Ensure the image covers the entire space
//                             ),
//                           ),
//                           Container(
//                             decoration: const BoxDecoration(
//                                 border: Border(top: BorderSide(width: 1))),
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 10, vertical: 5),
//                             alignment: Alignment.center,
//                             child: Text(
//                               "Samadhi Room",
//                               style: GoogleFonts.poppins(
//                                 textStyle:
//                                     Theme.of(context).textTheme.bodyMedium,
//                                 fontSize: 18,
//                                 color: Colors.blueAccent,
//                                 fontWeight: FontWeight.w600,
//                                 fontStyle: FontStyle.normal,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: InkWell(
//                     onTap: () {
//
//                       if (Platform.isAndroid) {
//                         SystemChrome.setPreferredOrientations([
//                           DeviceOrientation.landscapeRight,
//                           DeviceOrientation.landscapeLeft,
//                         ]);
//                         Navigator.pushNamed(context, '/livevideo',
//                             arguments: ScreenArguments(
//                                 1,
//                                 "rtsp://admin:Globotech@12345@182.48.203.143:554",
//                                 4));
//                       } else {
//                         Navigator.pushNamed(context, '/livevideo',
//                             arguments: ScreenArguments(
//                                 1,
//                                 "https://rtsp.me/embed/bA4rkyb6/",
//                                 4));
//                         // Fluttertoast.showToast(
//                         //     msg: "Stay tuned. We are launching soon.",
//                         //     toastLength: Toast.LENGTH_LONG,
//                         //     gravity: ToastGravity.SNACKBAR,
//                         //     timeInSecForIosWeb: 1,
//                         //     backgroundColor: Colors.white,
//                         //     textColor: Colors.blueAccent,
//                         //     fontSize: 18.0);
//                       }
//                     },
//                     child: Card(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: <Widget>[
//                           ClipRRect(
//                             borderRadius: const BorderRadius.only(
//                               topLeft: Radius.circular(8.0),
//                               topRight: Radius.circular(8.0),
//                             ),
//                             child: Image.asset(
//                               'assets/img/cam4.jpg',
//                               width: double.infinity,
//                               // Make the image take the full width
//                               fit: BoxFit
//                                   .cover, // Ensure the image covers the entire space
//                             ),
//                           ),
//                           Container(
//                             decoration: const BoxDecoration(
//                                 border: Border(top: BorderSide(width: 1))),
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 10, vertical: 5),
//                             alignment: Alignment.center,
//                             child: Text(
//                               "Samadhi Closeup",
//                               style: GoogleFonts.poppins(
//                                 textStyle:
//                                     Theme.of(context).textTheme.bodyMedium,
//                                 fontSize: 18,
//                                 color: Colors.blueAccent,
//                                 fontWeight: FontWeight.w600,
//                                 fontStyle: FontStyle.normal,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     // child: Card(
//                     //   child: Container(
//                     //     // padding: EdgeInsets.all(5),
//                     //     alignment: Alignment.center,
//                     //     child: Column(
//                     //       mainAxisSize: MainAxisSize.max,
//                     //       children: <Widget>[
//                     //         Image.asset('assets/img/cam4.jpg'),
//                     //         Padding(
//                     //           padding: EdgeInsets.symmetric(
//                     //               horizontal: 0, vertical: 5),
//                     //           //apply padding horizontal or vertical only
//                     //           child: Text(
//                     //             "Samadhi Closeup",
//                     //             style: GoogleFonts.poppins(
//                     //               textStyle:
//                     //                   Theme.of(context).textTheme.bodySmall,
//                     //               fontSize: 18,
//                     //               color: Colors.blueAccent,
//                     //               fontWeight: FontWeight.w600,
//                     //               fontStyle: FontStyle.normal,
//                     //             ),
//                     //           ),
//                     //         ),
//                     //       ],
//                     //     ),
//                     //   ),
//                     // ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//




import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:darbar_app_of_kambar_darbar/ScreenArguments.dart';
import 'dart:io' show Platform;
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http; // For making HTTP requests

class LiveStreamCategories extends StatefulWidget {
  const LiveStreamCategories({super.key});

  @override
  _LiveStreamCategoriesState createState() => _LiveStreamCategoriesState();
}

class _LiveStreamCategoriesState extends State<LiveStreamCategories> {
  List<dynamic> _cameraLinks = []; // To store API response data
  bool _isLoading = true; // To manage loading state
  bool _isError = false; // To handle API errors

  @override
  void initState() {
    super.initState();
    _fetchCameraLinks(); // Fetch API data when the screen loads
  }

  final Map<String, String> _imageMapping = {
    "Samadhi Room": 'assets/img/cam3.jpg',
    "Samadhi Closeup": 'assets/img/cam4.jpg',
    "Guru Room": 'assets/img/cam2.jpg',
    "Sainjans Room": 'assets/img/cam1.jpg',
  };
  final Map<String, String> androidLinks = {
    "Samadhi Room": 'rtsp://admin:Globotech@12345@182.48.203.143:1025',
    "Samadhi Closeup": 'rtsp://admin:Globotech@12345@182.48.203.143:554',
    "Guru Room": 'rtsp://admin:Globotech@12345@182.48.203.143:1024',
    "Saijans Room": 'rtsp://admin:Globotech@12345@182.48.203.143:1026',
  };

  Future<void> _fetchCameraLinks() async {
    const String apiUrl = 'https://kambardarbar.org/cameralinks.php';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success' && data['links'] != null) {
          setState(() {
            _cameraLinks = data['links']; // Store the list of cameras
            _isLoading = false; // Stop loading
          });
        } else {
          setState(() {
            _isError = true; // Mark as error if API response is unexpected
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isError = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isError = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Live Darshan From Darbar',
          style: GoogleFonts.poppins(
            textStyle: Theme.of(context).textTheme.bodySmall,
            fontSize: 20,
            color: Colors.indigoAccent,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
          child:
          CircularProgressIndicator()) // Show loader while fetching data
          : _isError
          ? const Center(child: Text('Failed to load camera links'))
          : _buildCameraList(), // Build camera cards dynamically
    );
  }

  Widget _buildCameraList() {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of cards in each row
        crossAxisSpacing: 2.0, // Space between columns
        mainAxisSpacing: 2.0, // Space between rows
        childAspectRatio: 4.6 / 4, // Adjust aspect ratio of the cards
      ),
      itemCount: _cameraLinks.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // Prevents GridView from scrolling
      itemBuilder: (context, index) {
        final camera = _cameraLinks[index];
        final title = camera['Title'];
        final imageUrl = _imageMapping[title] ?? '';
        final androidLink = androidLinks[title] ?? '';

        return Card(
          child: InkWell(
            onTap: () {
              if (Platform.isIOS) {
                Navigator.pushNamed(
                  context,
                  '/livevideo',
                  arguments: ScreenArguments(1, camera['RTSPLink'], 1),
                );
              } else if (Platform.isAndroid) {
                Navigator.pushNamed(
                  context,
                  '/livevideo',
                  arguments: ScreenArguments(1, androidLink, 1),
                );
              }
            },
            child:

            // child: Card(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: <Widget>[
//                           ClipRRect(
//                             borderRadius: const BorderRadius.only(
//                               topLeft: Radius.circular(8.0),
//                               topRight: Radius.circular(8.0),
//                             ),
//                             child: Image.asset(
//                               'assets/img/cam4.jpg',
//                               width: double.infinity,
//                               // Make the image take the full width
//                               fit: BoxFit
//                                   .cover, // Ensure the image covers the entire space
//                             ),
//                           ),
//                           Container(
//                             decoration: const BoxDecoration(
//                                 border: Border(top: BorderSide(width: 1))),
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 10, vertical: 5),
//                             alignment: Alignment.center,
//                             child: Text(
//                               "Samadhi Closeup",
//                               style: GoogleFonts.poppins(
//                                 textStyle:
//                                     Theme.of(context).textTheme.bodyMedium,
//                                 fontSize: 18,
//                                 color: Colors.blueAccent,
//                                 fontWeight: FontWeight.w600,
//                                 fontStyle: FontStyle.normal,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                  ),
                  child: Image.asset(
                    imageUrl,
                    width: double.infinity,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                      border: Border(top: BorderSide(width: 1))),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  alignment: Alignment.center,
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.bodyMedium,
                      fontSize: 16,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

