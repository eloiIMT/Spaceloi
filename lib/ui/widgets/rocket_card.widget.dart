import 'package:flutter/material.dart';
import 'package:spaceloi/data/models/rocket.model.dart';

class RocketCard extends StatelessWidget {
  const RocketCard({super.key, required this.rocket});

  final Rocket rocket;

  @override
  Widget build(BuildContext context) {
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
            Text(
              rocket.name,
              style: const TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212121),
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              '${rocket.company} • ${rocket.country}',
              style: const TextStyle(
                fontSize: 14.0,
                color: Color(0xFF757575),
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              rocket.description,
              style: const TextStyle(
                fontSize: 15.0,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  _buildSpecRow(Icons.straighten, 'Hauteur', '${rocket.height.toStringAsFixed(2)} m'),
                  const SizedBox(height: 8.0),
                  _buildSpecRow(Icons.track_changes, 'Diamètre', '${rocket.diameter.toStringAsFixed(2)} m'),
                  const SizedBox(height: 8.0),
                  _buildSpecRow(Icons.attach_money, 'Coût par lancement', '\$${rocket.costPerLaunch.toStringAsFixed(2)}'),
                  const SizedBox(height: 8.0),
                  _buildSpecRow(Icons.check_circle_outline, 'Taux de réussite', '${rocket.successRatePct.toStringAsFixed(1)}%'),
                  const SizedBox(height: 8.0),
                  _buildSpecRow(Icons.rocket_launch, 'Premier vol', rocket.firstFlight.toString()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20.0, color: Colors.blue),
        const SizedBox(width: 12.0),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14.0,
              color: Color(0xFF757575),
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212121),
          ),
        ),
      ],
    );
  }
}
