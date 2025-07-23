import 'package:flutter/material.dart';
import 'package:frontend/constants/app_dimension.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/widgets/album_provider.dart';
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
  void _setSortParam(String param){
    setState(() {
      _sortParameter = param;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: AppDimensions.toolBarHeight(context),
      color: purle1,
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          ToolBarButton(functionality: _ChangeOrder(setParam: _setSortParam, isAscending: _isAscending)),
          ToolBarButton(
            functionality: _ToggleAscOrDesc(
              sortParam: _sortParameter,
              onToggle: _toggleSortOrder,
              isAscending: _isAscending,
            ),
          ),
          ToolBarButton(functionality: _SearchInAlbums())
        ],
      ),
    );
  }
}

class _ToggleAscOrDesc extends StatelessWidget {
  final bool isAscending;
  final VoidCallback onToggle;
  final String sortParam;

  const _ToggleAscOrDesc({required this.onToggle, required this.isAscending, required this.sortParam });

  @override
  Widget build(BuildContext context) {
    final albumProvider = Provider.of<AlbumProvider>(context);
    return GestureDetector(
      onTap: () {onToggle();albumProvider.sortAlbumsBy(sortParam, isAscending);},
      child: Icon(isAscending ? Icons.arrow_downward : Icons.arrow_upward),
    );
  }
}

class _ChangeOrder extends StatelessWidget {
  final bool isAscending;
  final List<String> _menuItems = [
    'Title',
    'Length',
    'Release Date',
    "Number of tracks",
  ];
  final Function setParam;
  _ChangeOrder({required this.isAscending, required this.setParam});

  @override
  Widget build(BuildContext context) {
    final albumProvider = Provider.of<AlbumProvider>(context, listen: false);
    return PopupMenuButton<String>(
      itemBuilder: (context) => _menuItems
          .map((item) => PopupMenuItem(value: item, child: Text(item)))
          .toList(),
      onSelected: (value) {
        setParam(value);
        albumProvider.sortAlbumsBy(value, isAscending);
      },
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [Text("Sort"), Icon(Icons.arrow_drop_down)],
        ),
      ),
    );
  }
}

class ToolBarButton extends StatelessWidget {
  const ToolBarButton({super.key, required functionality})
    : _functionality = functionality;
  final Widget _functionality;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.all(Radius.elliptical(12, 10)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SizedBox(width: 200, child: _functionality),
    );
  }
}

class _SearchInAlbums extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final albumProvider = Provider.of<AlbumProvider>(context);
    return SearchBar(
      onSubmitted: (value){
        albumProvider.searchInAlbums(value);
      },
    );
  }
}