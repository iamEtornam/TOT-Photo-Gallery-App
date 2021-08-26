import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

Future<XFile?> getImage({required ImageSource imageSource}) async {
  return await ImagePicker().pickImage(source: imageSource);
}

Future<File?> getCroppedFile({required String file}) async {
  return await ImageCropper.cropImage(
      sourcePath: file,
      compressFormat: ImageCompressFormat.png,
      compressQuality: 70,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        title: 'Crop Image',
      ));
}

class CustomBottomSheetWidget extends StatelessWidget {
  final List<Options> options;
  final double height;
  final String title;

  const CustomBottomSheetWidget(
      {Key? key,
      required this.options,
      this.height = 170.0,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoActionSheet(
            message: Text(
              '$title',
            ),
            actions: options
                .map((e) => CupertinoButton(
                    child: Text(
                      e.label!,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Colors.blue),
                    ),
                    onPressed: () {
                      e.onTap!();
                    }))
                .toList(),
            cancelButton: CupertinoButton(
                child: Text('Cancel',
                    style: Theme.of(context)
                        .textTheme
                        .button!
                        .copyWith(color: Colors.red)),
                onPressed: () => Navigator.of(context).pop()))
        : Container(
            height: height,
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Column(
                  children: options
                      .map((e) => Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  e.onTap!();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(e.label!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(color: Colors.blue)),
                                ),
                              ),
                              Divider()
                            ],
                          ))
                      .toList(),
                ),
                InkWell(
                  onTap: () async {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Cancel',
                      style: Theme.of(context)
                          .textTheme
                          .button!
                          .copyWith(color: Colors.red),
                    ),
                  ),
                )
              ],
            ),
          );
  }
}

class Options {
  String? label;
  Function? onTap;

  Options({required String label, Function? onTap}) {
    this.label = label;
    this.onTap = onTap;
  }
}
