import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/platforms/common/posts/model/post.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/model/date_filter.dart';

class PostRepository {
  final postCollection = FirebaseFirestore.instance.collection("posts");

  void addPost(PostModel postModel) {
    this.postCollection.add(postModel.toJson());
  }

  void deletePost(String postId) {
    this.postCollection.doc(postId).delete();
  }

  Future<QuerySnapshot> getPosts(String userId) {
    return this.postCollection.where("postedBy", isEqualTo: userId).get();
  }

  Future<List<dynamic>> getAllPosts(
      String search, int dateFilter, String userId) async {
    QuerySnapshot query;
    if (search == "") {
      query = await this
          .postCollection
          .orderBy("createdAt", descending: true)
          .get();
    } else {
      query = await this
          .postCollection
          .where("skills", arrayContains: search)
          .orderBy("createdAt", descending: true)
          .get();
    }
    if (dateFilter == 0)
      return query.docs.isEmpty ? [] : query.docs;
    else {
      if (dateFilter == 1) {
        List<DocumentSnapshot> filteredPosts = [];
        if (query.docs.isNotEmpty) {
          List<String> postIds = query.docs.map((e) => e.id).toList();
          for (String s in postIds) {
            QuerySnapshot postSnapshot = await this
                .postCollection
                .doc(s)
                .collection("applicants")
                .where("id", isEqualTo: userId)
                .get();
            if (postSnapshot.docs.isNotEmpty) {
              DocumentSnapshot postSnapshot =
                  await this.postCollection.doc(s).get();
              filteredPosts.add(postSnapshot);
            }
          }
        }
        return filteredPosts;
      } else {
        List<DocumentSnapshot> filteredPosts = [];
        if (query.docs.isNotEmpty) {
          List<String> postIds = query.docs.map((e) => e.id).toList();
          for (String s in postIds) {
            QuerySnapshot postSnapshot = await this
                .postCollection
                .doc(s)
                .collection("applicants")
                .where("id", isEqualTo: userId)
                .get();
            if (postSnapshot.docs.isNotEmpty) {
              DocumentSnapshot postSnapshot =
                  await this.postCollection.doc(s).get();
              filteredPosts.add(postSnapshot);
            }
          }

          List<String> appliedPostIds = filteredPosts.map((e) => e.id).toList();
          List<String> notAppliedPostIds = postIds
              .where((element) => !appliedPostIds.contains(element))
              .toList();
          filteredPosts=[];
          for (String s in notAppliedPostIds) {
            DocumentSnapshot postSnapshot =
                await this.postCollection.doc(s).get();
            if (postSnapshot.exists) {
              filteredPosts.add(postSnapshot);
            }
          }
        }
        return filteredPosts;
      }
    }
  }

  Future<void> closePost(PostModel postModel) async {
    this.postCollection.doc(postModel.id).set(postModel.toJson());
  }

  void applyPost(String postId, String applicantId) async {
    this
        .postCollection
        .doc(postId)
        .collection("applicants")
        .doc(applicantId)
        .set({
      "id": applicantId,
      "isAccepted": false,
      "createdAt": DateTime.now().toIso8601String()
    });
  }

  Future<bool> checkIfUserHasAppliedForPost(
      String postId, String applicantId) async {
    QuerySnapshot snapshot =
        await this.postCollection.doc(postId).collection("applicants").get();
    if (snapshot.docs.isEmpty) return false;
    return List.from(snapshot.docs.where((e) => e.id == applicantId)).isEmpty
        ? false
        : true;
  }

  Future<List<String>> getApplicantsForAPost(String postId) async {
    List<String> users = [];
    QuerySnapshot snapshot =
        await this.postCollection.doc(postId).collection("applicants").get();
    for (DocumentSnapshot documentSnapshot in snapshot.docs) {
      users.add(documentSnapshot.id);
    }
    return users;
  }
}
