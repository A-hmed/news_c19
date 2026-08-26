import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_c19/model/articles_response.dart';
import 'package:news_c19/ui/utils/build_context_extensions.dart';
import 'package:timeago/timeago.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleWidget extends StatelessWidget {
  final ArticleDM articleDM;

  const ArticleWidget({super.key, required this.articleDM});

  @override
  Widget build(BuildContext context) {
    var date = DateTime.parse(articleDM.publishedAt ?? "");
    var theme = context.theme;
    return InkWell(
      onTap: () {
        buildShowModalBottomSheet(context, articleDM);
      },
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.secondaryColor),
        ),
        child: Column(
          children: [
            // Image.network(articleDM.urlToImage ??
            //     "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUsGS3PpKkgaBSZflZbwFkH62EfDp6L-CyCaD1rrhDBQ&s=10"),
            CachedNetworkImage(
              imageUrl: articleDM.urlToImage ?? "",
              height: context.height * .25,
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) {
                print("failed to load: $error");
                return Icon(Icons.error);
              },
            ),
            Text(articleDM.title ?? ""),
            Row(children: [
              if (articleDM.author != null)
                Expanded(
                    child: Text("By: ${articleDM.author}",
                        style: theme.textTheme.displayMedium)),
              if (articleDM.publishedAt != null)
                Text(
                  "${format(date)}",
                  style: theme.textTheme.displayMedium,
                ),
            ])
          ],
        ),
      ),
    );
  }

  void buildShowModalBottomSheet(BuildContext context, ArticleDM articleDM) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            height: context.height * .45,
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: context.theme.secondaryColor,
                borderRadius: BorderRadius.all(Radius.circular(16))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: articleDM.urlToImage ?? "",
                    height: context.height * .25,
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) {
                      print("failed to load: $error");
                      return Icon(Icons.error);
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Text(
                    articleDM.description ?? "",
                    style: context.theme.textTheme.displayLarge,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: context.theme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      side: BorderSide(color: context.theme.primaryColor),
                    ),
                    onPressed: () {
                      if (articleDM.url != null && articleDM.url!.isNotEmpty) {
                        _launchURL(articleDM.url!);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("No URL available for this article"),
                          ),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text("View Full Article",
                          style: context.theme.textTheme.titleSmall),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
