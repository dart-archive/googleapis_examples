// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:googleapis_auth/auth_browser.dart' as auth;
import 'package:googleapis/drive/v2.dart' as drive;


// Obtain the client ID email from the Google Developers Console by creating
// new OAuth credentials of application type "Web application".
//
// This example uses the implicit oauth2 flow. You need to configure the
// "JAVASCRIPT ORIGINS" setting to point to the URIs where your webapp will
// be accessed.
final identifier = new auth.ClientId(
     "<please fill in>.apps.googleusercontent.com",
     null);

// This is the list of scopes this application will use.
// You need to enable the Drive API in the Google Developers Console.
final scopes = [drive.DriveApi.DriveScope];


// Obtain an authenticated HTTP client which can be used for accessing Google
// APIs.
Future authorizedClient(ButtonElement loginButton, auth.ClientId id, scopes) {
  // Initializes the oauth2 browser flow, completes as soon as authentication
  // calls can be made.
  return auth.createImplicitBrowserFlow(id, scopes)
      .then((auth.BrowserOAuth2Flow flow) {
    // Try getting credentials without user consent.
    // This will succeed if the user already gave consent for this application.
    return flow.clientViaUserConsent(immediate: true).catchError((_) {
      // Ask the user for consent.
      //
      // Asking for consent will create a popup window where the user has to
      // authenticate with Google and authorize this application to access data
      // on it's behalf.
      //
      // Since most browsers block popup windows by default, we can only do this
      // inside an event handler (if a user action triggered a popup it will
      // usually not be blocked).
      // We use the loginButton for this.
      loginButton.text = 'Authorize';
      return loginButton.onClick.first.then((_) {
        return flow.clientViaUserConsent(immediate: false);
      });
    }, test: (error) => error is auth.UserConsentException);
  });
}

// Search for documents using the Google Drive API. The query format is
// documented here:
//   => https://developers.google.com/drive/web/search-parameters
Future<List<drive.File>> searchTextDocuments(drive.DriveApi api,
                                             int max,
                                             String query) {
  var docs = [];
  Future next(String token) {
    // The API call returns only a subset of the results. It is possible
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

main() {
  // Once we have an authroized client we will disable the `loginButton` and
  // Enable the `selection` and `listButton`. The user can then list drive
  // documents. After the user clicked `listButton` we fetch the first 20
  // documents matching the query and display them in a list.
  ButtonElement loginButton = querySelector('#login_button');
  DivElement fileList = querySelector('#file_list');
  SelectElement selection = querySelector('#document_type');
  ButtonElement listButton = querySelector('#list_button');

  authorizedClient(loginButton, identifier, scopes).then((client) {
    loginButton.disabled = true;
    selection.disabled = false;
    listButton.disabled = false;
    loginButton.text = 'You are authorized';

    var api = new drive.DriveApi(client);

    listButton.onClick.listen((_) {
      var query = queryMapping[selection.selectedOptions.first.value];
      searchTextDocuments(api, 20, query).then((List<drive.File> files) {
        fileList.nodes.clear();
        display('Here are the first ${files.length} documents:', fileList);
        display('<br/>', fileList);
        for (var file in files) {
          display('<a href="${file.alternateLink}">${file.title}</a> '
                  '(${file.mimeType})', fileList);
        }
      }).catchError((error) {
        display('An error occured: $error', fileList);
      });
    });
  }).catchError((error) {
    loginButton.disabled = true;
    if (error is auth.UserConsentException) {
      loginButton.text = 'You did not grant access :(';
      return new Future.error(error);
    } else {
      loginButton.text = 'An unknown error occured ($error)';
      return new Future.error(error);
    }
  });
}

// Adds a new <div>$msg</div> as a child node of `parent`.
void display(msg, parent) {
  var div = new DivElement();
  div.setInnerHtml('$msg', treeSanitizer: NullTreeSanitizer.Instance);
  parent.children.add(div);
}

class NullTreeSanitizer implements NodeTreeSanitizer {
  static final Instance = new NullTreeSanitizer();
  void sanitizeTree(node) {}
}
