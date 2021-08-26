import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';
import 'package:image_picker/image_picker.dart' as ImagePicker;
import 'package:photo_gallery_app/post.dart';
import 'package:device_preview/device_preview.dart';
import 'package:photo_gallery_app/utilities.dart';
import 'data_source.dart';

void main() {
  runApp(DevicePreview(
    enabled: false,
    builder: (context) => MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context), // Add the locale here
      builder: DevicePreview.appBuilder,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(elevation: 0),
        primaryColor: Colors.white,
        accentColor: Colors.blue,
        textTheme: Typography.material2018(platform: defaultTargetPlatform)
            .white
            .copyWith(
              bodyText1: TextStyle(color: Colors.black, fontSize: 16),
              bodyText2: TextStyle(color: Colors.black, fontSize: 14),
              caption: TextStyle(color: Colors.black, fontSize: 12),
              headline1: TextStyle(color: Colors.black, fontSize: 96),
              headline2: TextStyle(color: Colors.black, fontSize: 60),
              headline3: TextStyle(color: Colors.black, fontSize: 48),
              headline4: TextStyle(color: Colors.black, fontSize: 34),
              headline5: TextStyle(color: Colors.black, fontSize: 24),
              headline6: TextStyle(color: Colors.black, fontSize: 22),
              subtitle1: TextStyle(color: Colors.black, fontSize: 16),
              subtitle2: TextStyle(color: Colors.black, fontSize: 14),
              overline: TextStyle(color: Colors.black, fontSize: 10),
              button: TextStyle(color: Colors.black, fontSize: 16),
            ),
      ),
      darkTheme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: AppBarTheme(
              elevation: 0,
              backgroundColor: Colors.black,
              iconTheme: IconThemeData(color: Colors.white)),
          primaryColor: Colors.white,
          accentColor: Colors.blue,
          textTheme: Typography.material2018(platform: defaultTargetPlatform)
              .white
              .copyWith(
                bodyText1: TextStyle(color: Colors.white, fontSize: 16),
                bodyText2: TextStyle(color: Colors.white, fontSize: 14),
                caption: TextStyle(color: Colors.white, fontSize: 12),
                headline1: TextStyle(color: Colors.white, fontSize: 96),
                headline2: TextStyle(color: Colors.white, fontSize: 60),
                headline3: TextStyle(color: Colors.white, fontSize: 48),
                headline4: TextStyle(color: Colors.white, fontSize: 34),
                headline5: TextStyle(color: Colors.white, fontSize: 24),
                headline6: TextStyle(color: Colors.white, fontSize: 22),
                subtitle1: TextStyle(color: Colors.white, fontSize: 16),
                subtitle2: TextStyle(color: Colors.white, fontSize: 14),
                overline: TextStyle(color: Colors.white, fontSize: 10),
                button: TextStyle(color: Colors.white, fontSize: 16),
              ),
          cardColor: Color.fromRGBO(31, 31, 31, 1)),
      themeMode: ThemeMode.system,
      home: HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final List<String> _images = [
    'https://images.unsplash.com/photo-1593642532842-98d0fd5ebc1a?ixid=MXwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=2250&q=80',
    'https://images.unsplash.com/photo-1612594305265-86300a9a5b5b?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
    'https://images.unsplash.com/photo-1612626256634-991e6e977fc1?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1712&q=80',
    'https://images.unsplash.com/photo-1593642702749-b7d2a804fbcf?ixid=MXwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1400&q=80'
  ];
  late List<Options> options;
  late File imageFile;

// capture image with camera
  getProfileFromCamera() async {
    await getImage(imageSource: ImagePicker.ImageSource.camera)
        .then((file) async {
      File? croppedFile = await getCroppedFile(file: file!.path);

      if (croppedFile != null) {
        setState(() {
          imageFile = croppedFile;
        });
      }
    });
  }

// select image from gallery
  getProfileFromGallery() async {
    await getImage(imageSource: ImagePicker.ImageSource.gallery)
        .then((file) async {
      File? croppedFile = await getCroppedFile(file: file!.path);

      if (croppedFile != null) {
        setState(() {
          imageFile = croppedFile;
        });
      }
    });
  }

  @override
  void initState() {
    options = [
      Options(
          label: 'Select from Camera',
          onTap: () {
            Navigator.pop(context);
            getProfileFromCamera();
          }),
      Options(
          label: 'Select from Gallery',
          onTap: () {
            Navigator.pop(context);
            getProfileFromGallery();
          }),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Gallery',
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.blue),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Platform.isIOS
                    ? showCupertinoModalPopup<void>(
                        context: context,
                        builder: (context) {
                          return CustomBottomSheetWidget(
                            title: 'select an Image',
                            options: options,
                          );
                        })
                    : showModalBottomSheet<void>(
                        context: context,
                        builder: (context) {
                          return CustomBottomSheetWidget(
                            title: 'select an Image',
                            height: 205,
                            options: options,
                          );
                        });
              },
              icon: Icon(
                CupertinoIcons.camera,
                color: Colors.blue,
              ))
        ],
        bottom: PreferredSize(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Today',
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          preferredSize: Size.fromHeight(50),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            Post post = Post.fromJson(posts[index]);

            return InkWell(
              onTap: () {
                showBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(15)),
                            image: DecorationImage(
                                image: NetworkImage(post.post),
                                fit: BoxFit.cover)),
                      );
                    });
              },
              child: PhotoCardWidget(
                images: _images,
                post: post,
              ),
            );
          },
          itemCount: posts.length,
        ),
      ),
    );
  }
}

//custom widget class
class PhotoCardWidget extends StatelessWidget {
  const PhotoCardWidget(
      {Key? key, required List<String> images, required Post post})
      : _images = images,
        _post = post,
        super(key: key);

  final List<String> _images;
  final Post _post;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      elevation: 0,
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(_post.profilePic),
            ),
            title: Text(
              _post.name,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontWeight: FontWeight.w600, fontSize: 17),
            ),
            subtitle: Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 14,
                  color: Colors.blue,
                ),
                Text(
                  _post.location,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: Colors.grey, fontSize: 14),
                )
              ],
            ),
          ),
          Image.network(
            _post.post,
            height: 218,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Material(
                    color: Colors.grey.withOpacity(.1),
                    borderRadius: BorderRadius.circular(35),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            '${_post.likes}',
                            style: Theme.of(context).textTheme.caption,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  FlutterImageStack(
                    imageList: _images,
                    showTotalCount: false,
                    totalCount: 4,
                    itemRadius: 35, // Radius of each images
                    itemCount:
                        4, // Maximum number of images to be shown in stack
                    itemBorderWidth: 2, // Border width around the images
                  ),
                ],
              ),
              Material(
                color: Colors.grey.withOpacity(.1),
                borderRadius: BorderRadius.circular(35),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.chat_bubble_fill,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        '${_post.comments}',
                        style: Theme.of(context).textTheme.caption,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
