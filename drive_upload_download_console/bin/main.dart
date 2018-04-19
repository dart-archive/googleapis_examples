// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' show Client;
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


// Upload a file to Google Drive.
Future uploadFile(drive.DriveApi api,
                  String file,
                  String name) {
  // We create a `Media` object with a `Stream` of bytes and the length of the
  // file. This media object is passed to the API call via `uploadMedia`.
  // We pass a partially filled-in `drive.File` object with the title we want
  // to give our newly created file.
  var localFile = new File(file);
  var media = new drive.Media(localFile.openRead(), localFile.lengthSync());
  var driveFile = new drive.File()..title = name;
  return api.files.insert(driveFile, uploadMedia: media).then((drive.File f) {
    print('Uploaded $file. Id: ${f.id}');
  });
}

// Download a file from Google Drive.
Future downloadFile(drive.DriveApi api,
                    Client client,
                    String objectId,
                    String filename) {
  return api.files.get(objectId).then((drive.File file) {
    // The Drive API allows one to download files via `File.downloadUrl`.
    return client.readBytes(file.downloadUrl).then((bytes) {
      var stream = new File(filename).openWrite()..add(bytes);
      return stream.close();
    });
  });
}

main(List<String> args) {
  if (args.length != 3 || !['upload', 'download'].contains(args.first)) {
    print('Usage:');
    print('  - dart main.dart upload <local-file> <drive-file-title>');
    print('  - dart main.dart download <drive-file-id> <local-file>');
    return;
  }

  // Obtain an authenticated HTTP client which can be used for accessing Google
  // APIs. We use `Identifier` to identifiy this client applicaiton and request
  // access for all scopes in `Scopes`.
  // The user will be asked to go to a URL and grant access. See `userPrompt`.
  auth.clientViaUserConsent(identifier, scopes, userPrompt).then((client) {
    var api = new drive.DriveApi(client);

    switch (args.first) {
      case 'upload':
        return uploadFile(api, args[1], args[2])
            .whenComplete(() => client.close());
      case 'download':
        return downloadFile(api, client, args[1], args[2])
            .whenComplete(() => client.close());
    }
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
