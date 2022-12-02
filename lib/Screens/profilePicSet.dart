import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as au;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as i;
import '../util/color.dart';
import 'AllowLocation.dart';

class ProfilePicSet extends StatefulWidget {
  final userData;
  const ProfilePicSet({Key? key, this.userData}) : super(key: key);

  @override
  State<ProfilePicSet> createState() => _ProfilePicSetState();
}

class _ProfilePicSetState extends State<ProfilePicSet> {
  final au.FirebaseAuth? auth = au.FirebaseAuth.instance;
  String? imgUrl = '';
  bool isImageUploaded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: const <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 50, top: 120),
                    child: Text(
                      "Add your Image",
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                ],
              ),
              Flexible(
                child: Container(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  alignment: Alignment.center,
                  child: Container(
                      width: 250,
                      height: 250,
                      margin: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: primaryColor),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: !isImageUploaded
                          ? IconButton(
                              color: primaryColor,
                              iconSize: 60,
                              icon: const Icon(Icons.add_a_photo),
                              onPressed: () async {
                                await source(context, true);
                              },
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.network(
                                imgUrl!,
                                width: 250,
                                height: 250,
                                fit: BoxFit.fill,
                              ))),
                ),
              ),
              isImageUploaded
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: InkWell(
                          child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(25),
                                  gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        primaryColor.withOpacity(.5),
                                        primaryColor.withOpacity(.8),
                                        primaryColor,
                                        primaryColor
                                      ])),
                              height: MediaQuery.of(context).size.height * .065,
                              width: MediaQuery.of(context).size.width * .75,
                              child: Center(
                                  child: Text(
                                "CHANGE IMAGE",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: textColor,
                                    fontWeight: FontWeight.bold),
                              ))),
                          onTap: () async {
                            await source(context, true);
                          },
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              imgUrl!.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: InkWell(
                          child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(25),
                                  gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        primaryColor.withOpacity(.5),
                                        primaryColor.withOpacity(.8),
                                        primaryColor,
                                        primaryColor
                                      ])),
                              height: MediaQuery.of(context).size.height * .065,
                              width: MediaQuery.of(context).size.width * .75,
                              child: Center(
                                  child: Text(
                                'Continue',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: textColor,
                                    fontWeight: FontWeight.bold),
                              ))),
                          onTap: () async {
                            print(widget.userData);
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) =>
                                      AllowLocation(widget.userData),
                                  // Gender(widget.userData)
                                ));
                          },
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: InkWell(
                          child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              height: MediaQuery.of(context).size.height * .065,
                              width: MediaQuery.of(context).size.width * .75,
                              child: Center(
                                  child: Text(
                                'Continue',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: secondryColor,
                                    fontWeight: FontWeight.bold),
                              ))),
                          onTap: () {},
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  Future source(BuildContext context, bool isProfilePicture) async {
    print("Source CAlled");
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
              title: const Text('Add Picture'),
              content: const Text('Select Source'),
              insetAnimationCurve: Curves.decelerate,
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(
                          Icons.photo_camera,
                          size: 28,
                        ),
                        Text(
                          'camera',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              decoration: TextDecoration.none),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          builder: (context) {
                            getImage(
                                ImageSource.camera, context, isProfilePicture);
                            return const Center(
                                child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ));
                          });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(
                          Icons.photo_library,
                          size: 28,
                        ),
                        Text(
                          'Gallery',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              decoration: TextDecoration.none),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            getImage(
                                ImageSource.gallery, context, isProfilePicture);
                            return const Center(
                                child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ));
                          });
                    },
                  ),
                ),
              ]);
        });
  }

  Future getImage(ImageSource imageSource, context, isProfilePicture) async {
    try {
      var image = await ImagePicker.platform.pickImage(source: imageSource);
      if (image != null) {
        File? croppedFile = (await ImageCropper().cropImage(
            sourcePath: image.path,
            cropStyle: CropStyle.circle,
            aspectRatioPresets: [CropAspectRatioPreset.square],
            uiSettings: [AndroidUiSettings(
              toolbarTitle: 'Crop',
                toolbarColor: primaryColor,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.square,
                lockAspectRatio: true
            ),
            IOSUiSettings(
               minimumAspectRatio: 1.0,
            )],
           )) as File?;
        if (croppedFile != null) {
          await uploadFile(await compressimage(croppedFile), isProfilePicture);
        }
      }
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
    }
  }

  Future uploadFile(File image, isProfilePicture) async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('users/${auth!.currentUser!.uid}/${image.hashCode}.jpg');
    UploadTask uploadTask = storageReference.putFile(image);
    //if (uploadTask.isInProgress == true) {}
    //if (await uploadTask.onComplete != null) {
    await uploadTask.whenComplete(() {
      storageReference.getDownloadURL().then((fileURL) async {
        setState(() {
          print('jbjjjjjjjjjjjjjjjjjjjj');
          imgUrl = fileURL;
          isImageUploaded = true;
        });
        Map<String, dynamic> updateObject = {
          "Pictures": FieldValue.arrayUnion([
            fileURL,
          ])
        };

        // try {
        //   if (isProfilePicture) {
        //     //currentUser.imageUrl.removeAt(0);
        //     .imageUrl!.insert(0, fileURL);
        //     print("object");
        //     await FirebaseFirestore.instance
        //         .collection("Users")
        //         .doc(currentUser.id)
        //         .set(
        //       {"Pictures": currentUser.imageUrl},
        //     );
        //   } else {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(auth!.currentUser!.uid)
            .set(updateObject, SetOptions(merge: true));
        // widget.currentUser.imageUrl!.add(fileURL);
        //}
        //   if (mounted) setState(() {});
        // } catch (err) {
        //   print("Error: $err");
        // }
      });
      // .then((value) {
      //   print('-----${storageReference.getDownloadURL().toString()}');
      //   uploadTask.whenComplete(() {
      //     storageReference.getDownloadURL().then((valuee) {
      //       imgUrl = valuee;
      //     });
      //   });
      // });
    });
  }

  Future compressimage(File image) async {
    final tempdir = await getTemporaryDirectory();
    final path = tempdir.path;
    i.Image? imagefile = i.decodeImage(image.readAsBytesSync());
    final compressedImagefile = File('$path.jpg')
      ..writeAsBytesSync(i.encodeJpg(imagefile!, quality: 80));
    // setState(() {

    return compressedImagefile;
    // });
  }
}
