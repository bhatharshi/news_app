import 'dart:convert'; // Add this import for JSON decoding
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:news_app/utils/constant.dart';
import 'model/news_response.dart';
import 'package:http/http.dart' as http;

class NewsProvider with ChangeNotifier {
  NewsResponse? _newsResponse;
  bool _isLoading = false;
  String? _error;

  NewsResponse? get newsResponse => _newsResponse;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchTeslaNews() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final now = DateTime.now();
    final fromDate = now
        .subtract(const Duration(days: 7))
        .toIso8601String()
        .split('T')
        .first;
    final url = Uri.parse(
        '${base_url}everything?q=tesla&from=$fromDate&sortBy=publishedAt&apiKey=$API_KEY');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Parse the JSON response and update the model
        final jsonResponse = jsonDecode(response.body);
        _newsResponse = NewsResponse.fromJson(jsonResponse);

        log('Response status: ${response.statusCode}');
        log('Received ${_newsResponse?.articles?.length} articles.');
      } else {
        // Handle server errors (e.g., 404, 500)
        _error = 'Error ${response.statusCode}: ${response.reasonPhrase}';
        log("$_error");
      }
    } catch (e) {
      _error = "An unexpected error occurred: $e";
      log("Unexpected error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  final List<Article> _favoriteArticles = [];
  List<Article> get favoriteArticles => _favoriteArticles;

  void addToFavorites(Article article) {
    if (!_favoriteArticles.contains(article)) {
      _favoriteArticles.add(article);
      log("Article added: ${article.title}");
      log("Current favorite articles: ${_favoriteArticles.map((a) => a.title).toList()}");
      notifyListeners();
    } else {
      log("Article is already in favorites");
    }
  }

  void removeFromFavorites(Article article) {
    _favoriteArticles.remove(article);
    notifyListeners();
  }

  bool isFavorite(Article article) {
    return _favoriteArticles.contains(article);
  }
}
