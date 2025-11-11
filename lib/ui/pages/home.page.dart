import 'package:flutter/material.dart';
import 'package:spaceloi/data/models/launch.model.dart';
import 'package:spaceloi/ui/data/api/launch.service.dart';
import 'package:spaceloi/ui/widgets/launch_card_grid.widget.dart';
import 'package:spaceloi/ui/widgets/launch_card_list.widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Launch> launches = [];
  bool isLoading = true;
  bool isGridView = true;

  @override
  void initState() {
    super.initState();
    _loadLaunches();
  }

  Future<void> _loadLaunches() async {
    try {
      final data = await LaunchService.getLaunches();
      setState(() {
        launches = data;
        isLoading = false;
      });
    } catch (e) {
      print('Erreur lors du chargement: $e');
      setState(() {
        isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Spaceloi'),
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
        itemCount: launches.length,
        itemBuilder: (context, index) {
          return LaunchCardGrid(launch: launches[index]);
        },
      )
          : ListView.builder(
        itemCount: launches.length,
        itemBuilder: (context, index) {
          return LaunchCardList(launch: launches[index]);
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
