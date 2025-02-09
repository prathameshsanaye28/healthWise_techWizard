
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/posts.dart';
import 'storage_methods.dart';

// class FireStoreMethods {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<String> uploadPost(String description, String uid,
//       String username, String profImage, String postTitle, bool isAnonymous) async {
//     String res = "Some error occurred";
//     try {
//       String postId = const Uuid().v1(); // creates unique id based on time
//       Post post = Post(
//         description: description,
//         uid: uid,
//         username: username,
//         likes: [],
//         postId: postId,
//         datePublished: DateTime.now(),
//         postTitle: postTitle,
//         profImage: profImage,
//         isAnonymous: isAnonymous
//       );
//       _firestore.collection('posts').doc(postId).set(post.toJson());
//       res = "success";
//     } catch (err) {
//       res = err.toString();
//     }
//     return res;
//   }

//   Future<String> likePost(String postId, String uid, List likes) async {
//     String res = "Some error occurred";
//     try {
//       if (likes.contains(uid)) {
//         _firestore.collection('posts').doc(postId).update({
//           'likes': FieldValue.arrayRemove([uid])
//         });
//       } else {
//         _firestore.collection('posts').doc(postId).update({
//           'likes': FieldValue.arrayUnion([uid])
//         });
//       }
//       res = 'success';
//     } catch (err) {
//       res = err.toString();
//     }
//     return res;
//   }

//   Future<String> postComment(String postId, String text, String uid,
//       String name, String profilePic) async {
//     String res = "Some error occurred";
//     try {
//       if (text.isNotEmpty) {
//         String commentId = const Uuid().v1();
//         _firestore
//             .collection('posts')
//             .doc(postId)
//             .collection('comments')
//             .doc(commentId)
//             .set({
//           'profilePic': profilePic,
//           'name': name,
//           'uid': uid,
//           'text': text,
//           'commentId': commentId,
//           'datePublished': DateTime.now(),
//         });
//         res = 'success';
//       } else {
//         res = "Please enter text";
//       }
//     } catch (err) {
//       res = err.toString();
//     }
//     return res;
//   }

//   Future<String> deletePost(String postId) async {
//     String res = "Some error occurred";
//     try {
//       await _firestore.collection('posts').doc(postId).delete();
//       res = 'success';
//     } catch (err) {
//       res = err.toString();
//     }
//     return res;
//   }

//   Future<void> followUser(String uid, String followId) async {
//     try {
//       DocumentSnapshot snap =
//           await _firestore.collection('patients').doc(uid).get();
//       List following = (snap.data()! as dynamic)['following'];
//       if (following.contains(followId)) {
//         await _firestore.collection('patients').doc(followId).update({
//           'followers': FieldValue.arrayRemove([uid])
//         });
//         await _firestore.collection('patients').doc(uid).update({
//           'following': FieldValue.arrayRemove([followId])
//         });
//       } else {
//         await _firestore.collection('patients').doc(followId).update({
//           'followers': FieldValue.arrayUnion([uid])
//         });
//         await _firestore.collection('patients').doc(uid).update({
//           'following': FieldValue.arrayUnion([followId])
//         });
//       }
//     } catch (e) {
//       if (kDebugMode) print(e.toString());
//     }
//   }
// }


class FireStoreMethods{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload post
  // Future<String> uploadPost(
  //   String description,
  //   Uint8List file,
  //   String uid,
  //   String username,
  //   String profImage,
  // ) async{
  //   String res ="Some error occurred";
  //   try{
  //     String photoUrl = await StorageMethods().uploadImageToStorage('posts', file, true);
  //     String postId = const Uuid().v1();
  //     Posts post = Posts(
  //       description: description,
  //       uid: uid,
  //       username: username,
  //       postId: postId,
  //       datePublished: DateTime.now(),
  //       postUrl: photoUrl,
  //       profImage: profImage,
  //       likes:[]
  //     );
  //     _firestore.collection('posts').doc(postId).set(post.toJson());
  //     res = "Success";
  //   }catch(err){
  //     res = err.toString();
  //   }
  //   return res;
  // }

  Future<String> uploadPost(
    String description,
    bool isAnonymous,
    String uid,
    String username,
    String profImage, {
    Uint8List? file, // Made optional
  }) async {
    String res = "Some error occurred";
    try {
      String postId = const Uuid().v1();
      String? photoUrl;
      
      // Only upload image if file is provided
      if (file != null) {
        photoUrl = await StorageMethods().uploadImageToStorage('posts', file, true);
      }

      Posts post = Posts(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl, // Can be null
        profImage: profImage,
        likes: [],
        isAnonymous: isAnonymous
      );
      
      await _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

}


