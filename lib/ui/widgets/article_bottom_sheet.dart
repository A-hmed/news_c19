import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_c19/model/articles_response.dart';
import 'package:news_c19/ui/utils/app_routes.dart';
import 'package:news_c19/ui/utils/build_context_extensions.dart';

class ArticleBottomSheet extends StatelessWidget {
  final ArticleDM articleDM;

  const ArticleBottomSheet({super.key, required this.articleDM});

  @override
  Widget build(BuildContext context) {
    var theme = context.theme;
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.secondaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: articleDM.urlToImage ?? "",
              height: context.height * .25,
              fit: BoxFit.cover,
              placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(color: theme.primaryColor)),
              errorWidget: (context, url, error) =>
                  Icon(Icons.error, color: theme.primaryColor),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            articleDM.content ?? articleDM.description ?? "",
            style: theme.textTheme.displayLarge,
          ),
          SizedBox(
            height: 16,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, AppRoutes.articleDetails(articleDM));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              padding: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              "View Full Article",
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
