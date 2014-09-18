// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:googleapis_auth/auth_browser.dart' as auth;
import 'package:googleapis/customsearch/v1.dart' as search;

// This is the pub custom search ID - available at:
// https://github.com/dart-lang/pub-dartlang/blob/master/app/handlers/search.py
final customSearchId = '009011925481577436976:h931xn2j7o0';

// This is the API Key obtained from the Google Developers Console.
final apiKey = '<please-fill-in>';

class Package {
  final String title;
  final String url;
  final String snippet;

  Package(this.title, this.url, this.snippet);
}

// Use the Custom Search API to search for pub packages.
Future<List<Package>> searchPackages(search.CustomsearchApi api, String query) {
  return api.cse.list(query, cx: customSearchId).then((search.Search search) {
    var packages = [];
    if (search.items != null) {
      for (var result in search.items) {
        packages.add(
            new Package(result.htmlTitle, result.link, result.htmlSnippet));
      }
    }
    return packages;
  });
}

main() {
  InputElement searchText = querySelector('#search_text');
  ButtonElement searchButton = querySelector('#search_button');
  DivElement results = querySelector('#results');

  var client = auth.clientViaApiKey(apiKey);
  var api = new search.CustomsearchApi(client);

  searchText.onInput.listen((_) {
    searchButton.disabled = searchText.value == '';
  });

  searchButton.onClick.listen((_) {
    searchPackages(api, searchText.value).then((List<Package> packages) {
      results.children.clear();

      if (packages.isEmpty){
        display('<h5>No results found.</h5>', results);
      } else {
        for (var package in packages) {
          display('<h3><a href="${package.url}">${package.title}</a></h3>',
                  results);
          display(package.snippet, results);
        }
      }
    });
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
