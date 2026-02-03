import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/constants/widget_text.dart';
import 'package:frontend/dimensions/app_dimension.dart';
import 'package:frontend/dimensions/search_bar_dimensions.dart';
import 'package:frontend/dimensions/tool_bar_dimension.dart';
import 'package:frontend/providers/search_provider.dart';
import 'package:frontend/providers/display_provider.dart';
import 'package:frontend/utils/text_display_widgets.dart';
import 'package:frontend/widgets/auth.dart';
import 'package:provider/provider.dart';

class SearchEntryOnline extends StatelessWidget {
  const SearchEntryOnline({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ToolBarDimensions.toolBarHeight(context),
      width: InfoPanelDimensions.infoPanelWidth(context),
      alignment: Alignment.center,
      child: Row(children: [_ChangeSearchCategory(), _SearchOnlineBar()]),
    );
  }
}

class _SearchOnlineBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    return Expanded(
      child: SizedBox(
        height: SearchBarDimensions.widgetHeight(context),
        child: TextField(
          style: currentTheme.textTheme.bodySmall,
          decoration: InputDecoration(
            filled: true,
            fillColor: deepAccent,
            suffixIcon: MouseRegion(
              cursor: SystemMouseCursors.grabbing,
              child: IconButton(
                onPressed: () {
                  searchProvider.resetOffSet();
                  search(context);
                },
                icon: Icon(Icons.public),
              ),
            ),
            hintStyle: currentTheme.textTheme.bodySmall?.copyWith(
              color: currentTheme.hintColor,
            ),
            hintText: searchOnlineHint,
            border: OutlineInputBorder(
              borderRadius: SearchBarDimensions.widgetBorderRadius,
            ),
          ),
          onSubmitted: (value) {
            searchProvider.setQuerry(value);
            searchProvider.resetOffSet();
            search(context);
          },
          onChanged: (value) {
            searchProvider.setQuerry(value);
          },
        ),
      ),
    );
  }
}

class _ChangeSearchCategory extends StatefulWidget {
  @override
  State<_ChangeSearchCategory> createState() => _ChangeSearchCategoryState();
}

class _ChangeSearchCategoryState extends State<_ChangeSearchCategory> {
  final List<String> categories = ['release', 'artist'];

  String selectedCategory = 'release';
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      width: SearchBarDimensions.changeCategoryButtonWidth(context),
      margin: EdgeInsets.only(right: AppDimensions.smallSpacing),
      decoration: BoxDecoration(
        border: Border.all(),
        color: deepAccent,
        borderRadius: SearchBarDimensions.widgetBorderRadius,
      ),
      alignment: Alignment.center,

      height: SearchBarDimensions.widgetHeight(context),
      child: PopupMenuButton<String>(
        style: TextButton.styleFrom(side: BorderSide(width: 1)),
        color: deepAccent,
        borderRadius: SearchBarDimensions.popUpMenuBorderRadius,
        initialValue: selectedCategory,
        position: PopupMenuPosition.under,
        offset: Offset(30, 20),
        itemBuilder: (context) => categories
            .map(
              (category) => PopupMenuItem(
                onTap: () {
                  setState(() {
                    selectedCategory = category;
                  });
                  Provider.of<SearchProvider>(
                    context,
                    listen: false,
                  ).searchCategory = category;
                },
                value: category,
                child: DisplayText(
                  text: category,
                  textStyle: textTheme.bodyMedium,
                ),
              ),
            )
            .toList(),
        child: DisplayText(
          text: selectedCategory,
          textStyle: textTheme.bodyMedium,
        ),
      ),
    );
  }
}

Future<void> search(BuildContext context) async {
  final displayProvider = Provider.of<DisplayProvider>(context, listen: false);
  final searchProvider = Provider.of<SearchProvider>(context, listen: false);
  await Future.delayed(Duration(milliseconds: 500));

  showSnackBar(searching, context);
  final results = await searchProvider.search();

  if (results.isEmpty) {
    showSnackBar(noSearchResult, context);
  }
  displayProvider.displayEntities = results;
  searchProvider.isSearching = true;
  displayProvider.changeSelectedEntity(null);
}
