// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';

// class CloudFiles extends StatefulWidget {
//   const CloudFiles({Key? key}) : super(key: key);

//   @override
//   State<CloudFiles> createState() => _CloudFilesState();
// }

// class _CloudFilesState extends State<CloudFiles> {
//   String pageTitle = "Cloud Files";
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   User? user;
//   String? userID;

//   @override
//   initState() {
//     super.initState();
//     initUser();
//   }

//   initUser() async {
//     user = _firebaseAuth.currentUser!;
//     userID = user!.uid;
//     setState(() {});
//   }

//   Future<List<Map<String, dynamic>>> _loadFiles() async {
//     List<Map<String, dynamic>> files = [];
//     final ListResult result = await _storage.ref().list();
//     final List<Reference> allFiles = result.items;

//     await Future.forEach<Reference>(allFiles, (file) async {
//       final String fileUrl = await file.getDownloadURL();
//       final FullMetadata fileMeta = await file.getMetadata();
//       files.add({
//         "url": fileUrl,
//         "path": file.fullPath,
//       });
//     });

//     return files;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(pageTitle),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: FutureBuilder(
//               future: _loadFiles(),
//               builder: (BuildContext context,
//                   AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.done) {
//                   return ListView.builder(
//                     itemCount: snapshot.data?.length ?? 0,
//                     itemBuilder: (context, index) {
//                       final Map<String, dynamic> newFile =
//                           snapshot.data![index];
//                     },
//                   );
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
