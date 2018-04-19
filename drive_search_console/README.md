#### Example: drive_search_console

This example demonstrates the usage of the 
[Google Drive](https://developers.google.com/drive/) API. It shows
how to search for files in drive from a console application.

In order to run this sample you need to replace "<please fill in>" in 
`bin/main.dart` with the Client ID information obtained form the
Google Developers Console.

More information about how to obtain a Client ID can be found on the
[googleapis_auth](https://github.com/dart-lang/googleapis_auth/blob/master/README.md) repository.


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
