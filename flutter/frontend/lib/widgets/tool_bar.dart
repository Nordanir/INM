import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/dimensions/content_list_dimensions.dart';
import 'package:frontend/dimensions/tool_bar_dimension.dart';
import 'package:frontend/providers/selection_provider.dart';
import 'package:frontend/providers/superbase_config.dart';
import 'package:frontend/providers/album_provider.dart';
import 'package:frontend/providers/search_provider.dart';
import 'package:provider/provider.dart';

class ToolBar extends StatefulWidget {
  const ToolBar({super.key});

  @override
  State<ToolBar> createState() => _ToolBarState();
}

class _ToolBarState extends State<ToolBar> {
  bool _isAscending = true;
  String _sortParameter = 'Title';

  void _toggleSortOrder() {
    setState(() => _isAscending = !_isAscending);
  }

  void _setSortParam(String param) {
    setState(() {
      _sortParameter = param;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ToolBarDimensions.toolBarWidth(context),
      height: ToolBarDimensions.toolBarHeight(context),
      margin: EdgeInsets.only(top: 20, bottom: 10),
      decoration: BoxDecoration(
        color: lightBlueHighlight,
        borderRadius: ToolBarDimensions.toolBarBorderRadius(),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          _ToggleAscOrDesc(
            sortParam: _sortParameter,
            onToggle: _toggleSortOrder,
            isAscending: _isAscending,
          ),

          _ChangeOrder(setParam: _setSortParam, isAscending: _isAscending),

          Spacer(),
          _SearchInAlbums(),
          _Profile(),
          HomeButton(),
        ],
      ),
    );
  }
}

class _ToggleAscOrDesc extends StatelessWidget {
  final bool isAscending;
  final VoidCallback onToggle;
  final String sortParam;

  const _ToggleAscOrDesc({
    required this.onToggle,
    required this.isAscending,
    required this.sortParam,
  });

  @override
  Widget build(BuildContext context) {
    final albumProvider = Provider.of<AlbumProvider>(context);
    return GestureDetector(
      onTap: () {
        onToggle();
        albumProvider.sortAlbumsBy(sortParam, isAscending);
      },
      child: Container(
        margin: EdgeInsets.only(left: 16),
        width: ToolBarDimensions.toolBarHeight(context) * .5,
        height: ToolBarDimensions.toolBarHeight(context) * .5,
        decoration: BoxDecoration(
          color: deepBlueHighLight,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            bottomLeft: Radius.circular(8),
          ),
        ),
        child: Icon(isAscending ? Icons.arrow_downward : Icons.arrow_upward),
      ),
    );
  }
}

class _ChangeOrder extends StatefulWidget {
  final bool isAscending;
  final Function setParam;
  const _ChangeOrder({required this.isAscending, required this.setParam});

  @override
  State<_ChangeOrder> createState() => _ChangeOrderState();
}

class _ChangeOrderState extends State<_ChangeOrder> {
  void setDisplayText(String text) {
    setState(() {
      displayText = text;
    });
  }

  final List<String> _menuItems = [
    'Title',
    'Length',
    'Release Date',
    "Number of tracks",
  ];
  String displayText = "Sort";
  @override
  Widget build(BuildContext context) {
    final albumProvider = Provider.of<AlbumProvider>(context, listen: false);
    return Container(
      height: ToolBarDimensions.toolBarHeight(context) * .5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        border: Border(right: BorderSide(color: Color(0xff5B82B5))),
        color: Color(0xff7092BE),
      ),

      child: PopupMenuButton<String>(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll<Color>(secondaryBlue),
        ),
        color: lightBlueHighlight,
        itemBuilder: (context) => _menuItems
            .map((item) => PopupMenuItem(value: item, child: Text(item)))
            .toList(),
        onSelected: (value) {
          widget.setParam(value);
          albumProvider.sortAlbumsBy(value, widget.isAscending);
          setDisplayText(value);
        },
        position: PopupMenuPosition.under,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(style: TextStyle(fontSize: 12), displayText),
              Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchInAlbums extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final albumProvider = Provider.of<AlbumProvider>(context);
    return Container(
      height: ToolBarDimensions.toolBarHeight(context) * .6,
      margin: EdgeInsets.only(right: 40),
      width: ContentListDimensions.albumListPanelWidth(context) * .4,
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white30,
          suffixIcon: Icon(Icons.search),
          hintText: "Search your library...",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16),
              bottom: Radius.circular(16),
            ),
            borderSide: BorderSide.none,
          ),
        ),
        onSubmitted: (value) {
          albumProvider.searchInAlbums(value);
        },
      ),
    );
  }
}

class _Profile extends StatefulWidget {
  @override
  State<_Profile> createState() => _ProfileState();
}

class _ProfileState extends State<_Profile> {
  Color textColor = Colors.black;
  @override
  Widget build(BuildContext context) {
    final supabase = Provider.of<SupabaseConfig>(context);
    final profile = Provider.of<SupabaseConfig>(
      context,
      listen: true,
    ).currentProfile;
    return Container(
      decoration: BoxDecoration(),
      width: ContentListDimensions.albumListPanelWidth(context) * .2,
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            textColor = Colors.white;
          });
        },
        onExit: (_) {
          setState(() {
            textColor = Colors.black;
          });
        },
        child: GestureDetector(
          onTap: () {
            supabase.logout();
          },
          child: Text(
            profile.userName,
            style: TextStyle(
              color: textColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class HomeButton extends StatelessWidget {
  const HomeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final supabaseConfig = Provider.of<SupabaseConfig>(context, listen: false);
    final albumProvider = Provider.of<AlbumProvider>(context, listen: true);
    final searchProvider = Provider.of<SearchProvider>(context, listen: true);
    final selectionProvider = Provider.of<SelectionProvider>(context);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        minimumSize: ToolBarDimensions.navBarButtonMinSize,
        maximumSize: ToolBarDimensions.navBarButtonMaxSize,
        backgroundColor: lightGreen,
        alignment: Alignment.center,
      ),
      onPressed: () async {
        albumProvider.displayingAlbums = await supabaseConfig.retrieveAlbums();
        searchProvider.isSearching = false;
        selectionProvider.changeSelectedAlbum(null);
      },
      child: Icon(size: ToolBarDimensions.navBarButtonIconSize(), Icons.home),
    );
  }
}
