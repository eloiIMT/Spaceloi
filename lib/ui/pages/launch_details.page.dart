import 'package:flutter/material.dart';
import 'package:spaceloi/data/models/launch.model.dart';
import 'package:spaceloi/data/models/rocket.model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spaceloi/data/services/AppService.dart';
import 'package:spaceloi/ui/api/launch.service.dart';
import 'package:spaceloi/ui/widgets/rocket_card.widget.dart';
import 'package:spaceloi/utils/Date_formatter.dart';

class LaunchDetailsPage extends StatefulWidget {
  const LaunchDetailsPage({super.key, required this.launch});

  final Launch launch;

  @override
  State<LaunchDetailsPage> createState() => _LaunchDetailsPageState();
}

class _LaunchDetailsPageState extends State<LaunchDetailsPage> {
  Rocket? rocket;
  bool isLoadingRocket = true;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadRocket();
    _checkFavorite();
  }

  Future<void> _loadRocket() async {
    try {
      final data = await LaunchService.getRocketById(widget.launch.rocketId);
      setState(() {
        rocket = data;
        isLoadingRocket = false;
      });
    } catch (e) {
      print('Erreur lors du chargement de la fusée: $e');
      setState(() {
        isLoadingRocket = false;
      });
    }
  }

  Future<void> _checkFavorite() async {
    final result = await AppService.isFavorite(widget.launch.id);
    setState(() {
      isFavorite = result;
    });
  }

  Future<void> _toggleFavorite() async {
    if (isFavorite) {
      await AppService.removeFavorite(widget.launch.id);
    } else {
      await AppService.addFavorite(widget.launch.id);
    }
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            leading: Container(
              margin: const EdgeInsets.all(8.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: _toggleFavorite,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.launch.imagesUrl.isEmpty
                        ? widget.launch.patchUrl
                        : widget.launch.imagesUrl.first,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Icon(Icons.rocket_launch, size: 300, color: Colors.black)
                  )
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.launch.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  _buildInfoSection(),
                  const SizedBox(height: 16.0),
                  if (widget.launch.details != null) ...[
                    _buildDetailsSection(),
                    const SizedBox(height: 16.0),
                  ],
                  _buildRocketSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informations',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12.0),
            _buildInfoRow(Icons.rocket_launch, 'Identifiant du lancement', '${widget.launch.id}'),
            const Divider(),
            _buildInfoRow(Icons.calendar_today, 'Date', DateFormatter.formatDateTime(widget.launch.date)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20.0, color: Colors.blue),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Détails',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12.0),
            Text(
              widget.launch.details!,
              style: const TextStyle(
                fontSize: 15.0,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRocketSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Fusée',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12.0),
        isLoadingRocket
            ? const Center(child: CircularProgressIndicator())
            : rocket != null
            ? RocketCard(rocket: rocket!)
            : const Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Impossible de charger les informations de la fusée'),
          ),
        ),
      ],
    );
  }
}
