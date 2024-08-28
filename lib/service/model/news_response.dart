import 'package:json_annotation/json_annotation.dart';

part 'news_response.g.dart';

@JsonSerializable()
class NewsResponse {
  final String? status; // Nullable
  final int? totalResults; // Nullable
  final List<Article>? articles; // Nullable

  NewsResponse({
    this.status, // Nullable
    this.totalResults, // Nullable
    this.articles, // Nullable
  });

  factory NewsResponse.fromJson(Map<String, dynamic> json) =>
      _$NewsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$NewsResponseToJson(this);
}

@JsonSerializable()
class Article {
  final Source? source; // Nullable
  final String? author; // Nullable
  final String? title; // Nullable
  final String? description; // Nullable
  final String? url; // Nullable
  final String? urlToImage; // Nullable
  final String? publishedAt; // Nullable
  final String? content; // Nullable

  Article({
    this.source, // Nullable
    this.author, // Nullable
    this.title, // Nullable
    this.description, // Nullable
    this.url, // Nullable
    this.urlToImage, // Nullable
    this.publishedAt, // Nullable
    this.content, // Nullable
  });

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);
  Map<String, dynamic> toJson() => _$ArticleToJson(this);
}

@JsonSerializable()
class Source {
  final String? id; // Nullable
  final String? name; // Nullable

  Source({this.id, this.name}); // Nullable

  factory Source.fromJson(Map<String, dynamic> json) => _$SourceFromJson(json);
  Map<String, dynamic> toJson() => _$SourceToJson(this);
}
