// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController addressController = TextEditingController();
  TextEditingController cvcController = TextEditingController();
  TextEditingController nbFamMemController = TextEditingController();
  File? _image;

  Future<void> _selectImage(ImageSource source) async {
    PermissionStatus cameraPermission = await Permission.camera.status;
    PermissionStatus photoLibraryPermission = await Permission.photos.status;

    if (!cameraPermission.isGranted) {
      cameraPermission = await Permission.camera.request();
    }

    if (!photoLibraryPermission.isGranted) {
      photoLibraryPermission = await Permission.photos.request();
    }

    if (cameraPermission.isGranted && photoLibraryPermission.isGranted) {
      final pickedImage = await ImagePicker().pickImage(source: source);

      if (pickedImage != null) {
        setState(() {
          _image = File(pickedImage.path);
        });
      }
    } else {
      // Handle the case where permissions are not granted
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Permission Denied'),
            content: Text('Please grant camera and photo library permissions.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void updateProfile() async {
    String address = addressController.text.trim();
    int cvc = int.tryParse(cvcController.text) ?? 0;
    int nbFamMem = int.tryParse(nbFamMemController.text) ?? 0;

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Update the user's profile in your Prisma backend
        final response = await http.put(
          Uri.parse('http://localhost:3000/auth/profile/${user.uid}'),
          body: jsonEncode({
            'address': address,
            'CVC': cvc,
            'NbFamMem': nbFamMem,
            // Add any additional fields you want to update
          }),
          headers: {"Content-Type": "application/json"},
        );

        if (response.statusCode == 200) {
          // Request to Prisma backend successful
          final responseData = response.body;
          // Process the response data as needed
          print(responseData);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Success'),
                content: Text('Profile updated successfully!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          // Error handling for Prisma backend request
          print(
              'Prisma backend request failed with status: ${response.statusCode}');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Failed to update profile. Please try again.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (error) {
      // Exception handling
      print('An error occurred: $error');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            // Profile Picture in Header
            Padding(
              padding: EdgeInsets.all(16.0),
              child: CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('images/unnamed.jpg'),
              ),
            ),
            // Tabs
            TabBar(
              tabs: [
                Tab(text: 'Liked Events'),
                Tab(text: 'Liked News'),
                Tab(text: 'Profile Editing'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Liked Events component
                  // Render the events that the user liked
                  Center(
                    child: Text('Liked Events'),
                  ),
                  // Liked News component
                  // Render the news that the user liked
                  Center(
                    child: Text('Liked News'),
                  ),
                  // Profile Editing component
                  // Render the form for editing user profile
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Address Input
                          TextField(
                            controller: addressController,
                            decoration: InputDecoration(
                              labelText: 'Address',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 8.0),

                          // CVC Input
                          TextField(
                            controller: cvcController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'CVC',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 8.0),

                          // Number of Family Members Input
                          TextField(
                            controller: nbFamMemController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Number of Family Members',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16.0),

                          // Update Profile Button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: updateProfile,
                                child: Text('Update Profile'),
                              ),
                            ],
                          ),

                          // Add Image Selection Section
                          SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () => _selectImage(ImageSource.gallery),
                                child: Text('Select from Gallery'),
                              ),
                              SizedBox(width: 8.0),
                              ElevatedButton(
                                onPressed: () => _selectImage(ImageSource.camera),
                                child: Text('Take a Photo'),
                              ),
                            ],
                          ),

                          // Display Selected Image
                          if (_image != null) ...[
                            SizedBox(height: 16.0),
                            Image.file(_image!),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Navigation buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      // Navigate to stats component
                    },
                    child: Text('Stats'),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      // Navigate to payment component
                    },
                    child: Text('Payment'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}










//version l masta 
// // ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';

// class ProfileScreen extends StatefulWidget {
//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   TextEditingController addressController = TextEditingController();
//   TextEditingController cvcController = TextEditingController();
//   TextEditingController nbFamMemController = TextEditingController();
//   File? _image;

//   Future<void> _selectImage(ImageSource source) async {
//     PermissionStatus cameraPermission = await Permission.camera.status;
//     PermissionStatus photoLibraryPermission =
//         await Permission.photos.status;

//     if (!cameraPermission.isGranted) {
//       cameraPermission = await Permission.camera.request();
//     }

//     if (!photoLibraryPermission.isGranted) {
//       photoLibraryPermission = await Permission.photos.request();
//     }

//     if (cameraPermission.isGranted && photoLibraryPermission.isGranted) {
//       final pickedImage = await ImagePicker().pickImage(source: source);

//       if (pickedImage != null) {
//         setState(() {
//           _image = File(pickedImage.path);
//         });
//       }
//     } else {
//       // Handle the case where permissions are not granted
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Permission Denied'),
//             content: Text('Please grant camera and photo library permissions.'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }

//   void updateProfile() async {
//     String address = addressController.text.trim();
//     int cvc = int.tryParse(cvcController.text) ?? 0;
//     int nbFamMem = int.tryParse(nbFamMemController.text) ?? 0;

//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         // Update the user's profile in your Prisma backend
//         final response = await http.put(
//           Uri.parse('http://localhost:3000/auth/profile/${user.uid}'),
//           body: jsonEncode({
//             'address': address,
//             'CVC': cvc,
//             'NbFamMem': nbFamMem,
//             // Add any additional fields you want to update
//           }),
//           headers: {"Content-Type": "application/json"},
//         );

//         if (response.statusCode == 200) {
//           // Request to Prisma backend successful
//           final responseData = response.body;
//           // Process the response data as needed
//           print(responseData);
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: Text('Success'),
//                 content: Text('Profile updated successfully!'),
//                 actions: [
//                   TextButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: Text('OK'),
//                   ),
//                 ],
//               );
//             },
//           );
//         } else {
//           // Error handling for Prisma backend request
//           print(
//               'Prisma backend request failed with status: ${response.statusCode}');
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: Text('Error'),
//                 content: Text('Failed to update profile. Please try again.'),
//                 actions: [
//                   TextButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: Text('OK'),
//                   ),
//                 ],
//               );
//             },
//           );
//         }
//       }
//     } catch (error) {
//       // Exception handling
//       print('An error occurred: $error');
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Error'),
//             content: Text('An error occurred. Please try again.'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Address Input
//               TextField(
//                 controller: addressController,
//                 decoration: InputDecoration(
//                   labelText: 'Address',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 8.0),

//               // CVC Input
//               TextField(
//                 controller: cvcController,
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(
//                   labelText: 'CVC',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 8.0),

//               // Number of Family Members Input
//               TextField(
//                 controller: nbFamMemController,
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(
//                   labelText: 'Number of Family Members',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 16.0),

//               // Update Profile Button
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   ElevatedButton(
//                     onPressed: updateProfile,
//                     child: Text('Update Profile'),
//                   ),
//                 ],
//               ),

//               // Add Image Selection Section
//               SizedBox(height: 16.0),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () => _selectImage(ImageSource.gallery),
//                     child: Text('Select from Gallery'),
//                   ),
//                   SizedBox(width: 8.0),
//                   ElevatedButton(
//                     onPressed: () => _selectImage(ImageSource.camera),
//                     child: Text('Take a Photo'),
//                   ),
//                 ],
//               ),

//               // Display Selected Image
//               if (_image != null) ...[
//                 SizedBox(height: 16.0),
//                 Image.file(_image!),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }










// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:image_picker/image_picker.dart';

// class ProfileScreen extends StatefulWidget {
//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   TextEditingController addressController = TextEditingController();
//   TextEditingController cvcController = TextEditingController();
//   TextEditingController nbFamMemController = TextEditingController();
//   File? _image;

//   Future<void> _selectImage(ImageSource source) async {
//     final pickedImage = await ImagePicker().pickImage(source: source);

//     if (pickedImage != null) {
//       setState(() {
//         _image = File(pickedImage.path);
//       });
//     }
//   }

//   void updateProfile() async {
//     String address = addressController.text.trim();
//     int cvc = int.tryParse(cvcController.text) ?? 0;
//     int nbFamMem = int.tryParse(nbFamMemController.text) ?? 0;

//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         // Update the user's profile in your Prisma backend
//         final response = await http.put(
//           Uri.parse('http://localhost:3000/auth/profile/${user.uid}'),
//           body: jsonEncode({
//             'address': address,
//             'CVC': cvc,
//             'NbFamMem': nbFamMem,
//             // Add any additional fields you want to update
//           }),
//           headers: {"Content-Type": "application/json"},
//         );

//         if (response.statusCode == 200) {
//           // Request to Prisma backend successful
//           final responseData = response.body;
//           // Process the response data as needed
//           print(responseData);
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: Text('Success'),
//                 content: Text('Profile updated successfully!'),
//                 actions: [
//                   TextButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: Text('OK'),
//                   ),
//                 ],
//               );
//             },
//           );
//         } else {
//           // Error handling for Prisma backend request
//           print(
//               'Prisma backend request failed with status: ${response.statusCode}');
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: Text('Error'),
//                 content: Text('Failed to update profile. Please try again.'),
//                 actions: [
//                   TextButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: Text('OK'),
//                   ),
//                 ],
//               );
//             },
//           );
//         }
//       }
//     } catch (error) {
//       // Exception handling
//       print('An error occurred: $error');
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Error'),
//             content: Text('An error occurred. Please try again.'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Address Input
//               TextField(
//                 controller: addressController,
//                 decoration: InputDecoration(
//                   labelText: 'Address',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 8.0),

//               // CVC Input
//               TextField(
//                 controller: cvcController,
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(
//                   labelText: 'CVC',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 8.0),

//               // Number of Family Members Input
//               TextField(
//                 controller: nbFamMemController,
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(
//                   labelText: 'Number of Family Members',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 16.0),

//               // Update Profile Button
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   ElevatedButton(
//                     onPressed: updateProfile,
//                     child: Text('Update Profile'),
//                   ),
//                 ],
//               ),

//               // Add Image Selection Section
//               SizedBox(height: 16.0),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () => _selectImage(ImageSource.gallery),
//                     child: Text('Select from Gallery'),
//                   ),
//                   SizedBox(width: 8.0),
//                   ElevatedButton(
//                     onPressed: () => _selectImage(ImageSource.camera),
//                     child: Text('Take a Photo'),
//                   ),
//                 ],
//               ),

//               // Display Selected Image
//               if (_image != null) ...[
//                 SizedBox(height: 16.0),
//                 Image.file(_image!),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
