import 'package:algolia/algolia.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart';
import 'package:webblen_web_app/models/search_result.dart';
import 'package:webblen_web_app/models/webblen_event.dart';
import 'package:webblen_web_app/models/webblen_user.dart';

class AlgoliaSearchService {
  final DocumentReference algoliaDocRef = fb.firestore().collection("app_release_info").doc("algolia");
  final CollectionReference userDocRef = fb.firestore().collection("users");

  Future<Algolia> initializeAlgolia() async {
    Algolia algolia;
    String appID;
    String apiKey;
    DocumentSnapshot snapshot = await algoliaDocRef.get();
    appID = snapshot.data()['appID'];
    apiKey = snapshot.data()['apiKey'];
    algolia = Algolia.init(applicationId: appID, apiKey: apiKey);
    return algolia;
  }

  Future<List<SearchResult>> searchUsers({@required String searchTerm, @required resultsLimit}) async {
    Algolia algolia = await initializeAlgolia();
    List<SearchResult> results = [];
    if (searchTerm != null && searchTerm.isNotEmpty) {
      AlgoliaQuery query = algolia.instance.index('webblen_users').setHitsPerPage(resultsLimit).search(searchTerm);
      AlgoliaQuerySnapshot eventsSnapshot = await query.getObjects();
      eventsSnapshot.hits.forEach((snapshot) {
        if (snapshot.data != null) {
          SearchResult result = SearchResult(
            id: snapshot.data['id'],
            type: 'user',
            name: snapshot.data['username'],
            additionalData: snapshot.data['profilePicURL'],
          );
          results.add(result);
        }
      });
    }
    return results;
  }

  Future<List<WebblenUser>> queryUsers({@required String searchTerm, @required resultsLimit}) async {
    Algolia algolia = await initializeAlgolia();
    List<WebblenUser> results = [];
    if (searchTerm != null && searchTerm.isNotEmpty) {
      AlgoliaQuery query = algolia.instance.index('webblen_users').setHitsPerPage(resultsLimit).search(searchTerm);
      AlgoliaQuerySnapshot eventsSnapshot = await query.getObjects();
      eventsSnapshot.hits.forEach((snapshot) {
        if (snapshot.data != null) {
          WebblenUser result = WebblenUser.fromMap(snapshot.data);
          results.add(result);
        }
      });
    }
    return results;
  }

  Future<List<WebblenUser>> queryAdditionalUsers({@required String searchTerm, @required int resultsLimit, @required int pageNum}) async {
    Algolia algolia = await initializeAlgolia();
    List<WebblenUser> results = [];
    if (searchTerm != null && searchTerm.isNotEmpty) {
      AlgoliaQuery query = algolia.instance.index('webblen_users').setHitsPerPage(resultsLimit).setPage(pageNum).search(searchTerm);
      AlgoliaQuerySnapshot eventsSnapshot = await query.getObjects();
      eventsSnapshot.hits.forEach((snapshot) {
        if (snapshot.data != null) {
          WebblenUser result = WebblenUser.fromMap(snapshot.data);
          results.add(result);
        }
      });
    }
    return results;
  }

  Future<List<SearchResult>> searchEvents({@required String searchTerm, @required resultsLimit}) async {
    Algolia algolia = await initializeAlgolia();
    List<SearchResult> results = [];
    if (searchTerm != null && searchTerm.isNotEmpty) {
      AlgoliaQuery query = algolia.instance.index('webblen_events').setHitsPerPage(resultsLimit).search(searchTerm);
      AlgoliaQuerySnapshot eventsSnapshot = await query.getObjects();
      eventsSnapshot.hits.forEach((snapshot) {
        if (snapshot.data != null) {
          SearchResult result = SearchResult(
            id: snapshot.data['id'],
            type: 'event',
            name: snapshot.data['title'],
            additionalData: null,
          );
          results.add(result);
        }
      });
    }
    return results;
  }

  Future<List<WebblenEvent>> queryEvents({@required String searchTerm, @required resultsLimit}) async {
    Algolia algolia = await initializeAlgolia();
    List<WebblenEvent> results = [];
    if (searchTerm != null && searchTerm.isNotEmpty) {
      AlgoliaQuery query = algolia.instance.index('webblen_events').setHitsPerPage(resultsLimit).search(searchTerm);
      AlgoliaQuerySnapshot eventsSnapshot = await query.getObjects();
      eventsSnapshot.hits.forEach((snapshot) {
        if (snapshot.data != null) {
          WebblenEvent result = WebblenEvent.fromMap(snapshot.data);
          results.add(result);
        }
      });
    }
    return results;
  }

  Future<List<WebblenEvent>> queryAdditionalEvents({@required String searchTerm, @required int resultsLimit, @required int pageNum}) async {
    Algolia algolia = await initializeAlgolia();
    List<WebblenEvent> results = [];
    if (searchTerm != null && searchTerm.isNotEmpty) {
      AlgoliaQuery query = algolia.instance.index('webblen_events').setHitsPerPage(resultsLimit).setPage(pageNum).search(searchTerm);
      AlgoliaQuerySnapshot eventsSnapshot = await query.getObjects();
      eventsSnapshot.hits.forEach((snapshot) {
        if (snapshot.data != null) {
          WebblenEvent result = WebblenEvent.fromMap(snapshot.data);
          results.add(result);
        }
      });
    }
    return results;
  }

  Future<List<SearchResult>> searchStreams({@required String searchTerm, @required resultsLimit}) async {
    Algolia algolia = await initializeAlgolia();
    List<SearchResult> results = [];
    if (searchTerm != null && searchTerm.isNotEmpty) {
      AlgoliaQuery query = algolia.instance.index('webblen_streams').setHitsPerPage(resultsLimit).search(searchTerm);
      AlgoliaQuerySnapshot eventsSnapshot = await query.getObjects();
      eventsSnapshot.hits.forEach((snapshot) {
        if (snapshot.data != null) {
          SearchResult result = SearchResult(
            id: snapshot.data['id'],
            type: 'stream',
            name: snapshot.data['name'],
            additionalData: null,
          );
          results.add(result);
        }
      });
    }
    return results;
  }

  // Future<List<WebblenStream>> queryStreams({@required String searchTerm, @required resultsLimit}) async {
  //   Algolia algolia = await initializeAlgolia();
  //   List<WebblenStream> results = [];
  //   if (searchTerm != null && searchTerm.isNotEmpty) {
  //     AlgoliaQuery query = algolia.instance.index('webblen_streams').setHitsPerPage(resultsLimit).search(searchTerm);
  //     AlgoliaQuerySnapshot eventsSnapshot = await query.getObjects();
  //     eventsSnapshot.hits.forEach((snapshot) {
  //       if (snapshot.data != null) {
  //         WebblenStream result = WebblenStream.fromMap(snapshot.data);
  //         results.add(result);
  //       }
  //     });
  //   }
  //   return results;
  // }
  //
  // Future<List<WebblenStream>> queryAdditionalStreams({@required String searchTerm, @required int resultsLimit, @required int pageNum}) async {
  //   Algolia algolia = await initializeAlgolia();
  //   List<WebblenStream> results = [];
  //   if (searchTerm != null && searchTerm.isNotEmpty) {
  //     AlgoliaQuery query = algolia.instance.index('webblen_streams').setHitsPerPage(resultsLimit).setPage(pageNum).search(searchTerm);
  //     AlgoliaQuerySnapshot eventsSnapshot = await query.getObjects();
  //     eventsSnapshot.hits.forEach((snapshot) {
  //       if (snapshot.data != null) {
  //         WebblenStream result = WebblenStream.fromMap(snapshot.data);
  //         results.add(result);
  //       }
  //     });
  //   }
  //   return results;
  // }

  Future<List<String>> queryTags(String searchTerm) async {
    Algolia algolia = await initializeAlgolia();
    List<String> results = [];
    if (searchTerm != null && searchTerm.isNotEmpty) {
      AlgoliaQuery query = algolia.instance.index('tags').search(searchTerm);
      AlgoliaQuerySnapshot snapshot = await query.getObjects();
      snapshot.hits.forEach((snapshot) {
        // print(searchTerm);
        // print(snapshot.data);
        if (snapshot.data != null) {
          String res = snapshot.data['tag'];
          results.add(res);
        }
      });
    }
    return results;
  }

  Future<Map<dynamic, dynamic>> getTagsAndCategories() async {
    Map<dynamic, dynamic> allTags = {};
    Algolia algolia = await initializeAlgolia();
    AlgoliaQuerySnapshot q = await algolia.instance.index('tags').getObjects();
    q.hits.forEach((snapshot) {
      Map<String, dynamic> data = snapshot.data;
      if (allTags[data['category']] == null) {
        allTags[data['category']] = [data['tag']];
      } else {
        allTags[data['category']].add(data['tag']);
      }
    });
    allTags.forEach((key, value) {
      List tags = value.toList(growable: true);
      tags.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
      allTags[key] = tags;
    });
    return allTags;
  }

  Future<List> getRecentSearchTerms({@required String uid}) async {
    List recentSearchTerms = [];
    DocumentSnapshot snapshot = await userDocRef.doc(uid).get();
    if (snapshot.exists) {
      if (snapshot.data()['recentSearchTerms'] != null) {
        recentSearchTerms = snapshot.data()['recentSearchTerms'].toList(growable: true);
      }
    }
    return recentSearchTerms;
  }

  storeSearchTerm({@required String uid, @required String searchTerm}) async {
    List recentSearchTerms = [];
    DocumentSnapshot snapshot = await userDocRef.doc(uid).get();
    if (snapshot.exists) {
      if (snapshot.data()['recentSearchTerms'] != null) {
        recentSearchTerms = snapshot.data()['recentSearchTerms'].toList(growable: true);
        recentSearchTerms.insert(0, searchTerm);
        if (recentSearchTerms.length > 5) {
          recentSearchTerms.removeLast();
        }
      } else {
        recentSearchTerms.add(searchTerm);
      }
      userDocRef.doc(uid).update(data: {'recentSearchTerms': recentSearchTerms});
    }
  }
}
