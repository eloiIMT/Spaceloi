import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spaceloi/data/models/launch.model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spaceloi/ui/pages/launch_details.page.dart';
class LaunchCardGrid extends StatefulWidget {
  const LaunchCardGrid({super.key, required this.launch});

  final Launch launch;

  @override
  State<LaunchCardGrid> createState() => _LaunchCardGridState();
}

class _LaunchCardGridState extends State<LaunchCardGrid> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LaunchDetailsPage(launch: widget.launch),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 6.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: widget.launch.imagesUrl.isEmpty
                      ? BoxShape.circle
                      : BoxShape.rectangle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 8.0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: CachedNetworkImage(
                    imageUrl: widget.launch.imagesUrl.isEmpty
                        ? widget.launch.patchUrl
                        : widget.launch.imagesUrl.first,
                    height: 100,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    errorWidget: (context, url, error) => Image.asset('lib/data/image/defaultPatch.png', height: 100),
                    memCacheWidth: 200,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                widget.launch.name,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16.0,
                    color: Color(0xFF616161),
                  ),
                  Text(
                    ' ${widget.launch.date.toLocal().toString().split(' ').first}',
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Color(0xFF616161),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }
}