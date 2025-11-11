import 'package:flutter/material.dart';
import 'package:spaceloi/data/models/launch.model.dart';
import 'package:spaceloi/data/models/rocket.model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spaceloi/ui/data/api/launch.service.dart';
import 'package:spaceloi/ui/widgets/rocket_card.widget.dart';

class LaunchDetailsPage extends StatefulWidget {
  const LaunchDetailsPage({super.key, required this.launch});

  final Launch launch;

  @override
  State<LaunchDetailsPage> createState() => _LaunchDetailsPageState();
}

class _LaunchDetailsPageState extends State<LaunchDetailsPage> {
  Rocket? rocket;
  bool isLoadingRocket = true;

  @override
  void initState() {
    super.initState();
    _loadRocket();
  }

  Future<void> _loadRocket() async {
    try {
      final data = await LaunchService.getRocketById(widget.launch.id);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.launch.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 8.0,
                      color: Colors.black54,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.launch.imagesUrl.isEmpty
                        ? widget.launch.patchUrl
                        : widget.launch.imagesUrl.first,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Image.asset(
                      'lib/data/image/defaultPatch.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusCard(),
                  const SizedBox(height: 16.0),
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

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: widget.launch.success == true
            ? Colors.green.shade50
            : widget.launch.success == false
            ? Colors.red.shade50
            : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: widget.launch.success == true
              ? Colors.green
              : widget.launch.success == false
              ? Colors.red
              : Colors.orange,
          width: 2.0,
        ),
      ),
      child: Row(
        children: [
          Icon(
            widget.launch.success == true
                ? Icons.check_circle
                : widget.launch.success == false
                ? Icons.cancel
                : Icons.schedule,
            color: widget.launch.success == true
                ? Colors.green
                : widget.launch.success == false
                ? Colors.red
                : Colors.orange,
            size: 32.0,
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.launch.success == true
                      ? 'Lancement réussi'
                      : widget.launch.success == false
                      ? 'Lancement échoué'
                      : 'Lancement à venir',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: widget.launch.success == true
                        ? Colors.green.shade900
                        : widget.launch.success == false
                        ? Colors.red.shade900
                        : Colors.orange.shade900,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  widget.launch.date.toLocal().toString().split('.').first,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
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
            _buildInfoRow(Icons.rocket_launch, 'Numéro de vol', '#0'),
            const Divider(),
            _buildInfoRow(Icons.calendar_today, 'Date UTC', widget.launch.date.toUtc().toString().split('.').first),
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
      crossAxisAlignment: CrossAxisAlignment.start,
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
