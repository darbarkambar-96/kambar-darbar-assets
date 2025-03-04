import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:io' show Platform;

import 'PhotoItem.dart';

class PhotoGalleryScreen extends StatefulWidget {
  const PhotoGalleryScreen({super.key});

  @override
  _PhotoGalleryScreenState createState() => _PhotoGalleryScreenState();
}

class _PhotoGalleryScreenState extends State<PhotoGalleryScreen> {
  final List<PhotoItem> _items = [];
  late Future<List<Photos>> futureMedicalCategories;

  List<Photos> categories = [];
  int loaded = 2;

  Future<List<Photos>> fetchAlbum() async {
    final response = await http.get(Uri.parse(
        'https://www.classic24digital.com/kambardarbar/photogalleryapi.php'));

    if (response.statusCode == 200) {
      debugPrint('Photo gallery API');
      var data = json.decode(response.body.toString());

      for (Map i in data) {
        Photos p = Photos.fromJson(i);
        debugPrint(p.Imgsrc);
        _items.add(PhotoItem(p.Imgsrc, ""));
      }
      setState(() {
        loaded = 1;
      });
      return categories;
    } else {
      return categories;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loaded != 1) {
      fetchAlbum();
    }
    return Scaffold(
      appBar: (Platform.isAndroid)
          ? AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Text(
                'Photo Gallery',
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodySmall,
                  fontSize: 20,
                  color: Colors.indigoAccent,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                ),
              ),
            )
          : AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Text(
                'Photo Gallery',
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodySmall,
                  fontSize: 20,
                  color: Colors.indigoAccent,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<void>(
              future: Future.delayed(const Duration(seconds: 2)),
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: LoadingAnimationWidget.stretchedDots(
                      color: Colors.indigoAccent,
                      size: 50,
                    ),
                  );
                } else {
                  return GalleryImage(
                    imageUrls: _items
                        .map((item) =>
                            'https://www.classic24digital.com/kambardarbar/images/${item.image}')
                        .toList(),
                    numOfShowImages: _items.length,
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    closeWhenSwipeDown: true,
                    closeWhenSwipeUp: true,
                    crossAxisCount: 2,
                    loadingWidget: Center(
                      child: LoadingAnimationWidget.stretchedDots(
                        color: Colors.indigoAccent,
                        size: 50,
                      ),
                    ),
                    titleGallery: 'Photos - Kambar Darbar',
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Photos {
  final int Id;
  final String Imgsrc;

  const Photos({
    required this.Id,
    required this.Imgsrc,
  });

  factory Photos.fromJson(dynamic json) {
    return Photos(
      Id: int.parse(json['Id'].toString()),
      Imgsrc: json['PhotoSrc'],
    );
  }
}
