import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../service/provider.dart';
import '../utils/utils.dart';
import 'article.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<NewsProvider>(context, listen: false);
      provider.fetchTeslaNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final provider = Provider.of<NewsProvider>(context);

        return provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : provider.error != null
                ? Center(child: Text(provider.error!))
                : provider.newsResponse?.articles?.isNotEmpty == true
                    ? ListView.builder(
                        // Filter the articles to exclude those in the favorites list
                        itemCount: provider.newsResponse!.articles!
                            .where((article) =>
                                !provider.isFavorite(article)) // Filter logic
                            .length,
                        itemBuilder: (context, index) {
                          // Get the filtered article list
                          final filteredArticles = provider
                              .newsResponse!.articles!
                              .where((article) => !provider.isFavorite(article))
                              .toList();

                          final article = filteredArticles[index];

                          if (article.title == '[Removed]') {
                            return const SizedBox.shrink();
                          }

                          return Dismissible(
                            key: Key(article.title ?? 'article_$index'),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red.shade100,
                              alignment: Alignment.centerRight,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                                  Text(
                                    'Add to favorite',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.endToStart) {
                                provider.addToFavorites(article);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Added to favorites'),
                                  ),
                                );
                                return false; // Prevent dismissal
                              }
                              return true; // Allow other dismiss directions
                            },
                            onDismissed: (direction) {
                              // This won't be reached as we're preventing dismissal
                            },
                            child: GestureDetector(
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
                                      height:
                                          100, // You can set a height if needed
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              article.urlToImage ?? ''),
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
                                        width:
                                            8), // Space between image and text content
                                    // Title and subtitle
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                              const Icon(
                                                  Icons.edit_calendar_rounded,
                                                  size: 16),
                                              const SizedBox(width: 4),
                                              Text(
                                                article.publishedAt != null
                                                    ? formatDate(
                                                        article.publishedAt!)
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
                            ),
                          );
                        },
                      )
                    : const Center(child: Text('No news available'));
      },
    );
  }
}
