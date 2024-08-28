import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../service/model/news_response.dart';
import '../service/provider.dart';
import '../utils/utils.dart';

class ArticleDetailScreen extends StatefulWidget {
  final Article article;

  const ArticleDetailScreen({super.key, required this.article});
  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // ignore: use_build_context_synchronously
      final provider = Provider.of<NewsProvider>(context, listen: false);
      provider.fetchTeslaNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Back'),
        centerTitle: false,
      ),
      body: Builder(
        builder: (context) {
          final provider = Provider.of<NewsProvider>(context);
          final isFavorite = provider.isFavorite(widget.article);

          return provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : provider.error != null
                  ? Center(child: Text(provider.error!))
                  : provider.newsResponse?.articles?.isNotEmpty == true
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  if (widget.article.urlToImage != null &&
                                      widget.article.urlToImage!.isNotEmpty)
                                    Image.network(
                                      widget.article.urlToImage!,
                                      width: double.infinity,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.4,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(Icons.broken_image,
                                            size: 200);
                                      },
                                    )
                                  else
                                    // Placeholder if no valid image URL is provided
                                    Container(
                                      width: double.infinity,
                                      height: 200,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.broken_image,
                                          size: 100),
                                    ),
                                  // Show the heart icon if the article is a favorite
                                  if (isFavorite)
                                    const Positioned(
                                      top: 16,
                                      right: 16,
                                      child: Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                        size: 30,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  const Icon(Icons.edit_calendar_rounded),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    widget.article.publishedAt != null
                                        ? formatDate(
                                            widget.article.publishedAt!)
                                        : 'No publish date',
                                  ),
                                ],
                              ),
                              Text(
                                widget.article.title ?? 'No title',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.article.description ?? 'No description',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      : const Center(child: Text('No news available'));
        },
      ),
    );
  }
}
