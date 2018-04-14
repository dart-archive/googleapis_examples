#### Example: drive_search_web

This example demonstrates the usage of the 
[Google Drive](https://developers.google.com/drive/) API. It shows
how to search for files in drive from a client-side only web application.

In order to run this sample you need to replace "<please fill in>" in 
`web/index.dart` with the Client ID information obtained form the
Google Developers Console.

More information about how to obtain a Client ID can be found on the
[googleapis_auth](https://github.com/dart-lang/googleapis_auth/blob/master/README.md) repository.
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

