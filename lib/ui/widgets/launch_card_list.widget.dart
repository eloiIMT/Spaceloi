import 'package:flutter/material.dart';
import 'package:spaceloi/data/models/launch.model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spaceloi/ui/pages/launch_details.page.dart';

class LaunchCardList extends StatefulWidget {
  const LaunchCardList({super.key, required this.launch});

  final Launch launch;

  @override
  State<LaunchCardList> createState() => _LaunchCardListState();
}

class _LaunchCardListState extends State<LaunchCardList> {
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
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 10.0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4.0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: CachedNetworkImage(
                      imageUrl: widget.launch.imagesUrl.isEmpty
                          ? widget.launch.patchUrl
                          : widget.launch.imagesUrl.first,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        'lib/data/image/defaultPatch.png',
                        fit: BoxFit.cover,
                      ),
                      memCacheWidth: 160,
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.launch.name,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF212121),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 14.0,
                            color: Color(0xFF757575),
                          ),
                          const SizedBox(width: 6.0),
                          Text(
                            widget.launch.date.toLocal().toString().split(' ').first,
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Color(0xFF757575),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFFBDBDBD),
                ),
              ],
            ),
          ),
        )
    );
  }
}
