import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shtiwy/core/services/supabase_service.dart';

class PackagesList extends StatelessWidget {
  const PackagesList({super.key});

  Future<List<Map<String, dynamic>>> _fetchPackages() async {
    final db = SupabaseService.database;
    final res =
        await db.from('packages').select().order('created_at', ascending: false)
            as List<dynamic>;
    return res.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  Future<Map<String, dynamic>?> _fetchNextDeparture(String packageId) async {
    final db = SupabaseService.database;
    final rows =
        await db
                .from('package_departures')
                .select()
                .eq('package_id', packageId)
                .order('departure_date', ascending: true)
                .limit(1)
            as List<dynamic>;
    if (rows.isEmpty) return null;
    return Map<String, dynamic>.from(rows.first as Map);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchPackages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final packages = snapshot.data ?? [];
        if (packages.isEmpty)
          return const Center(child: Text('No packages available'));

        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: packages.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final pkg = packages[index];
            final pkgId = pkg['id'] as String? ?? '';
            final duration = pkg['duration_days']?.toString() ?? '';
            final tier = pkg['tier'] ?? '';

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            pkg['name'] ?? 'Unnamed',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          (tier as String).toUpperCase(),
                          style: const TextStyle(color: Colors.blueAccent),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      pkg['description'] ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.schedule, size: 16),
                        const SizedBox(width: 6),
                        Text('$duration days'),
                        const SizedBox(width: 12),
                        const Icon(Icons.location_on_outlined, size: 16),
                        const SizedBox(width: 6),
                        FutureBuilder<Map<String, dynamic>?>(
                          future: _fetchNextDeparture(pkgId),
                          builder: (context, dsnap) {
                            if (dsnap.connectionState ==
                                ConnectionState.waiting) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            }
                            final d = dsnap.data;
                            if (d == null)
                              return const Text('No upcoming departures');
                            final date = d['departure_date'];
                            final price = d['price'];
                            final currency = d['currency'] ?? 'USD';
                            final dateStr = date != null
                                ? DateFormat.yMMMd().format(
                                    DateTime.parse(date as String),
                                  )
                                : 'TBA';
                            return Text(
                              '$dateStr · ${price.toString()} $currency',
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
