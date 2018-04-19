#### Example: drive_upload_download_console

This example demonstrates the usage of the 
[Google Drive](https://developers.google.com/drive/) API. It shows
how to upload files to Google Drive and how to download them again.

In order to run this sample you need to replace "<please fill in>" in 
`bin/main.dart` with the Client ID information obtained form the
Google Developers Console.

More information about how to obtain a Client ID can be found on the
[googleapis_auth](https://github.com/dart-lang/googleapis_auth/blob/master/README.md) repository.


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
