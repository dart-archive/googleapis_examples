// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/drive/v2.dart' as drive;

// Obtain the client email / secret from the Google Developers Console by
// creating new OAuth credentials of application type
// "Installed application / Other".
final identifier = new auth.ClientId(
    "<please fill in>.apps.googleusercontent.com",
    "<please fill in>");

// This is the list of scopes this application will use.
// You need to enable the Drive API in the Google Developers Console.
final scopes = [drive.DriveApi.DriveScope];


// Search for documents using the Google Drive API. The query format is
// documented here:
//   => https://developers.google.com/drive/web/search-parameters
Future<List<drive.File>> searchTextDocuments(drive.DriveApi api,
                                             int max,
                                             String query) {
  var docs = [];
  Future next(String token) {
    // The API call will only return a subset of the results. It is possible
    // to query through the whole result set via "paging".
    return api.files.list(q: query, pageToken: token, maxResults: max)
        .then((results) {
      docs.addAll(results.items);
      // If we would like to have more documents, we iterate.
      if (docs.length < max && results.nextPageToken != null) {
        return next(results.nextPageToken);
      }
      return docs;
    });
  }
  return next(null);
}

// Maps document types to Drive Query strings.
final Map queryMapping =  const {
    'pdf' : "mimeType = 'application/pdf'",
    'text' : "mimeType = 'text/plain'",
    'docs' : "mimeType = 'application/vnd.google-apps.document'",
    'spreadsheets' : "mimeType = 'application/vnd.google-apps.spreadsheet'",
    'slides' : "mimeType = 'application/vnd.google-apps.presentation'",
    'all' : null,
};

main(List<String> args) {
  if (args.length != 1 || !queryMapping.keys.contains(args.first)) {
    print('Usage: dart main.dart '
          '<${(queryMapping.keys.toList()..sort()).join('|')}>');
    return;
  }

  // Obtain an authenticated HTTP client which can be used for accessing Google
  // APIs. We use `identifier` to identifiy this client applicaiton and request
  // access for all scopes in `scopes`.
  // The user will be asked to go to a URL and grant access. See `userPrompt`.
  auth.clientViaUserConsent(identifier, scopes, userPrompt).then((client) {
    var api = new drive.DriveApi(client);
    var query = queryMapping[args.first];
    searchTextDocuments(api, 20, query).then((List<drive.File> files) {
      print('Here are the first ${files.length} documents:');
      print('');
      for (var file in files) {
        print(' - ${file.title} (${file.alternateLink})');
      }
    }).catchError((error) {
      print('An error occured: $error');
    }).whenComplete(() {
      client.close();
    });
  }).catchError((error) {
    if (error is auth.UserConsentException) {
      print("You did not grant access :(");
    } else {
      print("An unknown error occured: $error");
    }
  });
}

void userPrompt(String url) {
  print("Please go to the following URL and grant access:");
  print("  => $url");
  print("");
}
