#### Example: cloudstorage_upload_download_service_account

This example demonstrates the usage of the 
[Google Cloud Storage](https://developers.google.com/storage/) API. It shows
how to upload files to Cloud Storage and how to download them again.

In order to run this sample you need to replace "<please fill in>" in 
`bin/main.dart` with the service account credentials obtained form the Google
Developers Console.

More information about how to obtain these can be found on the 
[googleapis_auth](https://github.com/dart-lang/googleapis_auth/blob/master/README.md) repository.


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
