import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_c19/model/articles_response.dart';
import 'package:news_c19/ui/utils/build_context_extensions.dart';
import 'package:news_c19/ui/widgets/article_bottom_sheet_view.dart';
import 'package:timeago/timeago.dart';

class ArticleWidget extends StatelessWidget {
  final ArticleDM articleDM;

  const ArticleWidget({super.key, required this.articleDM});

  @override
  Widget build(BuildContext context) {
    var date = DateTime.parse(articleDM.publishedAt ?? "");
    var theme = context.theme;
    return InkWell(
      onTap: () => ArticleBottomSheetView.show(context, articleDM),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(8),
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
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) {
                print("failed to load: $error");
                return const Icon(Icons.error);
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
                  format(date),
                  style: theme.textTheme.displayMedium,
                ),
            ])
          ],
        ),
      ),
    );
  }
}
