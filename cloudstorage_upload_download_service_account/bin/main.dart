// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/storage/v1.dart' as storage;

// Obtain the service account credentials from the Google Developers Console by
// creating new OAuth credentials of application type "Service account".
// This will give you a JSON file with the following fields.
final accountCredentials = new auth.ServiceAccountCredentials.fromJson(r'''
{
  "private_key_id": "<please fill in>",
  "private_key": "<please fill in>",
  "client_email": "<please fill in>@developer.gserviceaccount.com",
  "client_id": "<please fill in>.apps.googleusercontent.com",
  "type": "service_account"
}
''');

// This is the list of scopes this application will use.
// You need to enable the Google Cloud Storage API in the Google Developers
// Console.
final scopes = [storage.StorageApi.DevstorageFullControlScope];


// Upload a file to Google Cloud Storage.
Future uploadFile(storage.StorageApi api,
                  String file,
                  String bucket,
                  String object) {
  // We create a `Media` object with a `Stream` of bytes and the length of the
  // file. This media object is passed to the API call via `uploadMedia`.
  var localFile = new File(file);
  var media = new storage.Media(localFile.openRead(), localFile.lengthSync());
  return api.objects.insert(null, bucket, name: object, uploadMedia: media);
}

// Download a file from Google Cloud Storage.
Future downloadFile(storage.StorageApi api,
                    String bucket,
                    String object,
                    String file) {
  // The default for `downloadOptions` is metadata. This would only give us the
  // metadata of the Object in Cloud Storage. We specify the `FullMedia` option
  // which will return a `Media` object.
  var options = storage.DownloadOptions.FullMedia;
  return api.objects.get(
      bucket, object, downloadOptions: options).then((storage.Media media) {
    var fileStream = new File(file).openWrite();
    return media.stream.pipe(fileStream);
  });
}

main(List<String> args) {
  if (args.length != 3 || !['upload', 'download'].contains(args.first)) {
    print('Usage:');
    print('  - dart main.dart upload <local-file> gs://<bucket>/<path>');
    print('  - dart main.dart download gs://<bucket>/<path> <local-file>');
    return;
  }

  // Obtain an authenticated HTTP client which can be used for accessing Google
  // APIs. We use `AccountCredentials` to identifiy this client applicaiton and
  // to request access for all scopes in `Scopes`.
  auth.clientViaServiceAccount(accountCredentials, scopes).then((client) {
    var api = new storage.StorageApi(client);

    var regexp = new RegExp(r'^gs://([^/]+)/(.+)$');
    switch (args.first) {
      case 'upload':
        var match = regexp.matchAsPrefix(args[2]);
        if (match != null) {
          return uploadFile(api, args[1], match[1], match[2])
              .whenComplete(() => client.close());
        }
        print('Invalid cloud storage URI: ${args[2]}');
        break;
      case 'download':
        var match = regexp.matchAsPrefix(args[1]);
        if (match != null) {
          return downloadFile(api, match[1], match[2], args[2])
              .whenComplete(() => client.close());
        }
        print('Invalid cloud storage URI: ${args[1]}');
        break;
    }
  }).catchError((error) {
    print("An unknown error occured: $error");
  });
}
