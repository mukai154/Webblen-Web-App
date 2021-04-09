import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webblen_web_app/app/app.locator.dart';
import 'package:webblen_web_app/models/webblen_live_stream.dart';
import 'package:webblen_web_app/services/firestore/common/firestore_storage_service.dart';
import 'package:webblen_web_app/services/firestore/data/post_data_service.dart';
import 'package:webblen_web_app/utils/custom_string_methods.dart';

class LiveStreamDataService {
  final CollectionReference streamsRef = FirebaseFirestore.instance.collection("webblen_live_streams");
  PostDataService? _postDataService = locator<PostDataService>();

  DialogService? _dialogService = locator<DialogService>();
  FirestoreStorageService? _firestoreStorageService = locator<FirestoreStorageService>();

  int dateTimeInMilliseconds2hrsAgog = DateTime.now().millisecondsSinceEpoch - 7200000;

  Future<bool?> checkIfStreamExists(String id) async {
    bool exists = false;
    try {
      DocumentSnapshot snapshot = await streamsRef.doc(id).get();
      if (snapshot.exists) {
        exists = true;
      }
    } catch (e) {
      _dialogService!.showDialog(
        title: "Error",
        description: e.toString(),
      );
      return null;
    }
    return exists;
  }

  Future<bool?> checkIfStreamSaved({required String uid, required String eventID}) async {
    bool saved = false;
    try {
      DocumentSnapshot snapshot = await streamsRef.doc(eventID).get();
      if (snapshot.exists) {
        List savedBy = snapshot.data()!['savedBy'] == null ? [] : snapshot.data()!['savedBy'].toList(growable: true);
        if (!savedBy.contains(uid)) {
          saved = false;
        } else {
          saved = true;
        }
      }
    } catch (e) {
      return null;
    }
    return saved;
  }

  Future saveUnsaveStream({required String? uid, required String? streamID, required bool savedStream}) async {
    List? savedBy = [];
    DocumentSnapshot snapshot = await streamsRef.doc(streamID).get().catchError((e) {
      _dialogService!.showDialog(
        title: "Stream Error",
        description: e.message,
      );
      return false;
    });
    if (snapshot.exists) {
      savedBy = snapshot.data()!['savedBy'] == null ? [] : snapshot.data()!['savedBy'].toList(growable: true);
      if (savedStream) {
        if (!savedBy!.contains(uid)) {
          savedBy.add(uid);
        }
      } else {
        if (savedBy!.contains(uid)) {
          savedBy.remove(uid);
        }
      }
      await streamsRef.doc(streamID).update({'savedBy': savedBy});
    }
    return savedBy.contains(uid);
  }

  Future reportStream({required String? streamID, required String? reporterID}) async {
    DocumentSnapshot snapshot = await streamsRef.doc(streamID).get().catchError((e) {
      _dialogService!.showDialog(
        title: "Stream Error",
        description: e.message,
      );
      return null;
    });
    if (snapshot.exists) {
      List reportedBy = snapshot.data()!['reportedBy'] == null ? [] : snapshot.data()!['reportedBy'].toList(growable: true);
      if (reportedBy.contains(reporterID)) {
        _dialogService!.showDialog(
          title: "Report Error",
          description: "You've already reported this stream. This stream is currently pending review.",
        );
      } else {
        reportedBy.add(reporterID);
        streamsRef.doc(streamID).update({"reportedBy": reportedBy});
        return _dialogService!.showDialog(
          title: "Stream Reported",
          description: "This stream is now pending review.",
        );
      }
    }
  }

  Future createStream({required WebblenLiveStream stream}) async {
    await streamsRef.doc(stream.id).set(stream.toMap()).catchError((e) {
      return e.message;
    });
  }

  Future updateStream({required WebblenLiveStream stream}) async {
    await streamsRef.doc(stream.id).update(stream.toMap()).catchError((e) {
      return e.message;
    });
  }

  Future deleteStream({required WebblenLiveStream stream}) async {
    await streamsRef.doc(stream.id).delete();
    if (stream.imageURL != null) {
      await _firestoreStorageService!.deleteImage(storageBucket: 'images', folderName: 'streams', fileName: stream.id!);
    }
    await _postDataService!.deleteEventOrStreamPost(eventOrStreamID: stream.id, postType: 'stream');
  }

  Future getStreamByID(String? id) async {
    WebblenLiveStream? stream;
    DocumentSnapshot snapshot = await streamsRef.doc(id).get().catchError((e) {
      print(e.message);
      _dialogService!.showDialog(
        title: "Stream Error",
        description: e.message,
      );
      return null;
    });
    if (snapshot.exists) {
      stream = WebblenLiveStream.fromMap(snapshot.data()!);
    } else if (!snapshot.exists) {
      _dialogService!.showDialog(
        title: "his Stream No Longer Exists",
        description: "This stream has been removed",
      );
      return null;
    }
    return stream;
  }

  FutureOr getStreamForEditingByID(String? id) async {
    WebblenLiveStream? stream;
    DocumentSnapshot snapshot = await streamsRef.doc(id).get().catchError((e) {
      print(e.message);
      _dialogService!.showDialog(
        title: "Stream Error",
        description: e.message,
      );
      return null;
    });
    if (snapshot.exists) {
      stream = WebblenLiveStream.fromMap(snapshot.data()!);
    } else if (!snapshot.exists) {
      return null;
    }
    return stream;
  }

  Future<String?> generateStreamToken(String streamID) async {
    String? token;
    DocumentSnapshot snapshot = await streamsRef.doc(streamID).get().catchError((e) {
      _dialogService!.showDialog(
        title: "There was an issue starting this stream",
        description: "Please try again",
      );
      return null;
    });
    if (snapshot.exists) {
      if (snapshot.data()!['token'] != null) {
        token = snapshot.data()!['token'];
      } else {
        token = getRandomString(30);
        await streamsRef.doc(streamID).update({'token': token});
      }
    }
    return token;
  }

  ///READ & QUERIES
  Future<List<DocumentSnapshot>> loadStreams({
    required String areaCode,
    required int resultsLimit,
    required String? tagFilter,
    required String? sortBy,
  }) async {
    Query query;
    List<DocumentSnapshot> docs = [];
    if (areaCode.isEmpty) {
      query = streamsRef
          .where('startDateTimeInMilliseconds', isGreaterThan: dateTimeInMilliseconds2hrsAgog)
          .orderBy('startDateTimeInMilliseconds', descending: false)
          .limit(resultsLimit);
    } else {
      query = streamsRef
          .where('nearbyZipcodes', arrayContains: areaCode)
          .where('startDateTimeInMilliseconds', isGreaterThan: dateTimeInMilliseconds2hrsAgog)
          .orderBy('startDateTimeInMilliseconds', descending: false)
          .limit(resultsLimit);
    }
    QuerySnapshot snapshot = await query.get().catchError((e) {
      if (!e.message.contains("insufficient permissions")) {
        print(e.message);
        _dialogService!.showDialog(
          title: "Stream Error",
          description: e.message,
        );
      }
      return [];
    });
    if (snapshot.docs.isNotEmpty) {
      docs = snapshot.docs;
      if (tagFilter!.isNotEmpty) {
        docs.removeWhere((doc) => !doc.data()!['tags'].contains(tagFilter));
      }
      if (sortBy == "Latest") {
        docs.sort((docA, docB) => docB.data()!['startDateTimeInMilliseconds'].compareTo(docA.data()!['startDateTimeInMilliseconds']));
      } else {
        docs.sort((docA, docB) => docB.data()!['savedBy'].length.compareTo(docA.data()!['savedBy'].length));
      }
    }
    return docs;
  }

  Future<List<DocumentSnapshot>> loadAdditionalStreams(
      {required DocumentSnapshot lastDocSnap, required String areaCode, required int resultsLimit, required String? tagFilter, required String? sortBy}) async {
    Query query;
    List<DocumentSnapshot> docs = [];
    if (areaCode.isEmpty) {
      query = streamsRef
          .where('startDateTimeInMilliseconds', isGreaterThan: dateTimeInMilliseconds2hrsAgog)
          .orderBy('startDateTimeInMilliseconds', descending: false)
          .startAfterDocument(lastDocSnap)
          .limit(resultsLimit);
    } else {
      query = streamsRef
          .where('nearbyZipcodes', arrayContains: areaCode)
          .where('startDateTimeInMilliseconds', isGreaterThan: dateTimeInMilliseconds2hrsAgog)
          .orderBy('startDateTimeInMilliseconds', descending: false)
          .startAfterDocument(lastDocSnap)
          .limit(resultsLimit);
    }
    QuerySnapshot snapshot = await query.get().catchError((e) {
      if (!e.message.contains("insufficient permissions")) {
        print(e.message);
        _dialogService!.showDialog(
          title: "Stream Error",
          description: e.message,
        );
      }
      return [];
    });
    if (snapshot.docs.isNotEmpty) {
      docs = snapshot.docs;
      if (tagFilter!.isNotEmpty) {
        docs.removeWhere((doc) => !doc.data()!['tags'].contains(tagFilter));
      }
      if (sortBy == "Latest") {
        docs.sort((docA, docB) => docB.data()!['startDateTimeInMilliseconds'].compareTo(docA.data()!['startDateTimeInMilliseconds']));
      } else {
        docs.sort((docA, docB) => docB.data()!['savedBy'].length.compareTo(docA.data()!['savedBy'].length));
      }
    }
    return docs;
  }

  Future<List<DocumentSnapshot>> loadStreamsByUserID({required String? id, required int resultsLimit}) async {
    List<DocumentSnapshot> docs = [];
    Query query = streamsRef.where('hostID', isEqualTo: id).orderBy('startDateTimeInMilliseconds', descending: false).limit(resultsLimit);
    QuerySnapshot snapshot = await query.get().catchError((e) {
      if (!e.message.contains("insufficient permissions")) {
        print(e.message);
        _dialogService!.showDialog(
          title: "Stream Error",
          description: e.message,
        );
      }
      return [];
    });
    if (snapshot.docs.isNotEmpty) {
      docs = snapshot.docs;
    }
    return docs;
  }

  Future<List<DocumentSnapshot>> loadAdditionalStreamsByUserID({
    required String? id,
    required DocumentSnapshot lastDocSnap,
    required int resultsLimit,
  }) async {
    List<DocumentSnapshot> docs = [];
    Query query =
        streamsRef.where('hostID', isEqualTo: id).orderBy('startDateTimeInMilliseconds', descending: false).startAfterDocument(lastDocSnap).limit(resultsLimit);
    QuerySnapshot snapshot = await query.get().catchError((e) {
      if (!e.message.contains("insufficient permissions")) {
        print(e.message);
        _dialogService!.showDialog(
          title: "Stream Error",
          description: e.message,
        );
      }
      return [];
    });
    if (snapshot.docs.isNotEmpty) {
      docs = snapshot.docs;
    }
    return docs;
  }
}