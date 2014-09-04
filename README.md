## Examples for accessing Google APIs with Dart

These examples demonstrate the access to Google APIs in dart.


#### Example: cloudstorage_upload_download_service_account

This example demonstrates the usage of the 
[Google Cloud Storage](https://developers.google.com/storage/) API. It shows
how to upload files to Cloud Storage and how to download them again.

In order to run this sample you need to replace "<please fill in>" in 
`bin/main.dart` with the service account credentials obtained form the Google
Developers Console.

More information about how to obtain these can be found on the [googleapis_auth]
(https://github.com/dart-lang/googleapis_auth/blob/master/README.md) repository.


Usage of the example:
```
$ dart bin/main.dart upload /usr/bin/git gs://<bucket>/usr-bin-git
$ dart bin/main.dart download gs://<bucket>/usr-bin-git usr-bin-git
$ diff /usr/bin/git usr-bin-git && echo "Files are identical"
Files are identical
```
Where '<bucket>' needs to be replaced with a Google Cloud Storage bucket of the
Cloud Project. The Developers Console can be used to create one via a web
interface.



#### Example: drive_search_console

This example demonstrates the usage of the 
[Google Drive](https://developers.google.com/drive/) API. It shows
how to search for files in drive from a console application.

In order to run this sample you need to replace "<please fill in>" in 
`bin/main.dart` with the Client ID information obtained form the
Google Developers Console.

More information about how to obtain a Client ID can be found on the
[googleapis_auth]
(https://github.com/dart-lang/googleapis_auth/blob/master/README.md) repository.


Usage of the example:
```
$ dart bin/main.dart 
Usage: dart main.dart <all|docs|pdf|slides|spreadsheets|text>
$ dart bin/main.dart all
Please go to the following URL and grant access:
  => https://accounts.google.com/o/oauth2/auth....
Here are the first 20 documents:

 - foo (https://docs.google.com/document/d/...)
 - bar (https://docs.google.com/document/d/...)
 - ...
```

You must navigate to the URL displayed after the prompt
`Please go to the following URL and grant access:` and give the application
access to it's data.

When you grant access using the browser the running program will pick that up
and continue.

#### Example: drive_search_web

This example demonstrates the usage of the 
[Google Drive](https://developers.google.com/drive/) API. It shows
how to search for files in drive from a client-side only web application.

In order to run this sample you need to replace "<please fill in>" in 
`web/index.dart` with the Client ID information obtained form the
Google Developers Console.

More information about how to obtain a Client ID can be found on the
[googleapis_auth]
(https://github.com/dart-lang/googleapis_auth/blob/master/README.md) repository.
In order to run the below example it is necessary to set the
"JavaScript Origins" settings to "http://localhost:8080" for the Client ID.

Usage of the example:
```
$ pub serve
Loading source assets... 
Serving drive_search_web web on http://localhost:8080
Build completed successfully
```
Navigate with a browser to http://localhost:8080 and authorize the application.
Afterwards you can list Google Drive files (as in the console application
above).


#### Example: drive_upload_download_console

This example demonstrates the usage of the 
[Google Drive](https://developers.google.com/drive/) API. It shows
how to upload files to Google Drive and how to download them again.

In order to run this sample you need to replace "<please fill in>" in 
`bin/main.dart` with the Client ID information obtained form the
Google Developers Console.

More information about how to obtain a Client ID can be found on the
[googleapis_auth]
(https://github.com/dart-lang/googleapis_auth/blob/master/README.md) repository.


Usage of the example:
```
$ dart bin/main.dart 
Usage:
  - dart main.dart upload <local-file> <drive-file-title>
  - dart main.dart download <drive-file-id> <local-file>
$ dart bin/main.dart upload /usr/bin/git usr-bin-git
Please go to the following URL and grant access:
  => https://accounts.google.com/o/oauth2/auth?...

Uploaded /usr/bin/git. Id: 0B_H2HNyMUSo3TEhSeHFCVktrRXc
$ dart bin/main.dart download 0B_H2HNyMUSo3TEhSeHFCVktrRXc usr-bin-git
Please go to the following URL and grant access:
  => https://accounts.google.com/o/oauth2/auth?...

$ diff /usr/bin/git usr-bin-git && echo "Files are identical"
Files are identical
```

You must navigate to the URL displayed after the prompt
`Please go to the following URL and grant access:` and give the application
access to it's data.

When you grant access using the browser the running program will pick that up
and continue.