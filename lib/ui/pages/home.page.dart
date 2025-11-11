import 'package:flutter/material.dart';
import 'package:spaceloi/data/models/launch.model.dart';
import 'package:spaceloi/data/services/AppService.dart';
import 'package:spaceloi/ui/api/launch.service.dart';
import 'package:spaceloi/ui/widgets/launch_card_grid.widget.dart';
import 'package:spaceloi/ui/widgets/launch_card_list.widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Launch> launches = [];
  List<String> favorites = [];
  bool isLoading = true;
  bool isGridView = true;
  bool showOnlyFavorites = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await LaunchService.getLaunches();
      final favs = await AppService.getFavorites();
      setState(() {
        launches = data;
        favorites = favs;
        isLoading = false;
      });
    } catch (e) {
      print('Erreur lors du chargement: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _reloadFavorites() async {
    final favs = await AppService.getFavorites();
    if (mounted) {
      setState(() {
        favorites = favs;
      });
    }
  }

  List<Launch> get filteredLaunches {
    if (showOnlyFavorites) {
      return launches.where((launch) => favorites.contains(launch.id)).toList();
    }
    return launches;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spaceloi'),
        actions: [
          IconButton(
            icon: Icon(
              showOnlyFavorites ? Icons.favorite : Icons.favorite_border,
              color: showOnlyFavorites ? Colors.red : null,
            ),
            onPressed: () {
              setState(() {
                showOnlyFavorites = !showOnlyFavorites;
              });
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : isGridView
          ? GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: filteredLaunches.length,
        itemBuilder: (context, index) {
          return LaunchCardGrid(
            launch: filteredLaunches[index],
            onReturn: _reloadFavorites,);
        },
      )
          : ListView.builder(
        itemCount: filteredLaunches.length,
        itemBuilder: (context, index) {
          return LaunchCardList(
            launch: filteredLaunches[index],
            onReturn: _reloadFavorites,);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isGridView = !isGridView;
          });
        },
        child: Icon(isGridView ? Icons.list : Icons.grid_view),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
