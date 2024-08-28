import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../service/provider.dart';
import 'article.dart';
import '../utils/utils.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NewsProvider>(context);
    final favoriteArticles = provider.favoriteArticles;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Articles'),
      ),
      body: favoriteArticles.isEmpty
          ? const Center(child: Text('No favorites added'))
          : ListView.builder(
              itemCount: favoriteArticles.length,
              itemBuilder: (context, index) {
                final article = favoriteArticles[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArticleDetailScreen(
                          article: article,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Leading widget (image)
                        Container(
                          width: 100, // Fixed width for the image
                          height: 100, // You can set a height if needed
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            image: DecorationImage(
                              image: NetworkImage(article.urlToImage ?? ''),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: article.urlToImage == null
                              ? const Icon(
                                  Icons.broken_image,
                                  size: 50,
                                )
                              : null,
                        ),
                        const SizedBox(
                            width: 8), // Space between image and text content
                        // Title and subtitle
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Text(
                                article.title ?? 'No title',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Subtitle
                              Row(
                                children: [
                                  const Icon(Icons.edit_calendar_rounded,
                                      size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    article.publishedAt != null
                                        ? formatDate(article.publishedAt!)
                                        : 'No publish date',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
