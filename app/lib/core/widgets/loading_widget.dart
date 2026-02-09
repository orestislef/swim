import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

// Helper for shimmer placeholder boxes
class _Box extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const _Box({required this.width, required this.height, this.radius = 8});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

Widget _shimmerWrap(BuildContext context, {required Widget child}) {
  return Shimmer.fromColors(
    baseColor: Theme.of(context).colorScheme.surfaceContainerHighest,
    highlightColor: Theme.of(context).colorScheme.surface,
    child: child,
  );
}

/// Generic list – kept for backwards compatibility
class ShimmerList extends StatelessWidget {
  final int itemCount;
  const ShimmerList({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return _shimmerWrap(
      context,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: itemCount,
        padding: const EdgeInsets.all(16),
        itemBuilder: (_, _) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}

/// Dashboard: 2 rows of stat cards + booking list tiles
class ShimmerDashboard extends StatelessWidget {
  const ShimmerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return _shimmerWrap(
      context,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          // Welcome text
          const _Box(width: 180, height: 24, radius: 6),
          const SizedBox(height: 8),
          const _Box(width: 120, height: 14, radius: 4),
          const SizedBox(height: 20),
          // Stat cards row 1
          Row(
            children: const [
              Expanded(child: _ShimmerStatCard()),
              SizedBox(width: 12),
              Expanded(child: _ShimmerStatCard()),
            ],
          ),
          const SizedBox(height: 12),
          // Stat cards row 2
          Row(
            children: const [
              Expanded(child: _ShimmerStatCard()),
              SizedBox(width: 12),
              Expanded(child: _ShimmerStatCard()),
            ],
          ),
          const SizedBox(height: 24),
          // Section title
          const _Box(width: 140, height: 18, radius: 4),
          const SizedBox(height: 12),
          // Booking list tiles
          for (int i = 0; i < 3; i++) ...[
            const _ShimmerBookingTile(),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _ShimmerStatCard extends StatelessWidget {
  const _ShimmerStatCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _Box(width: 28, height: 28, radius: 6),
            SizedBox(height: 8),
            _Box(width: 60, height: 12, radius: 4),
            SizedBox(height: 6),
            _Box(width: 90, height: 16, radius: 4),
          ],
        ),
      ),
    );
  }
}

class _ShimmerBookingTile extends StatelessWidget {
  const _ShimmerBookingTile();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(backgroundColor: Colors.transparent, child: _Box(width: 40, height: 40, radius: 20)),
        title: const _Box(width: 120, height: 14, radius: 4),
        subtitle: const _Box(width: 100, height: 12, radius: 4),
        trailing: const _Box(width: 50, height: 24, radius: 12),
      ),
    );
  }
}

/// Bookings: card with icon + title/subtitle row + status badge
class ShimmerBookingList extends StatelessWidget {
  final int itemCount;
  const ShimmerBookingList({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return _shimmerWrap(
      context,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: itemCount,
        padding: const EdgeInsets.all(16),
        itemBuilder: (_, _) => Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: const [
                    _Box(width: 24, height: 24, radius: 6),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Box(width: 140, height: 14, radius: 4),
                          SizedBox(height: 6),
                          _Box(width: 110, height: 12, radius: 4),
                        ],
                      ),
                    ),
                    _Box(width: 60, height: 24, radius: 12),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    _Box(width: 80, height: 12, radius: 4),
                    _Box(width: 70, height: 14, radius: 4),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Subscriptions: card with icon + title + badge + info rows
class ShimmerSubscriptionList extends StatelessWidget {
  final int itemCount;
  const ShimmerSubscriptionList({super.key, this.itemCount = 3});

  @override
  Widget build(BuildContext context) {
    return _shimmerWrap(
      context,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: itemCount,
        padding: const EdgeInsets.all(16),
        itemBuilder: (_, _) => Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    _Box(width: 24, height: 24, radius: 6),
                    SizedBox(width: 12),
                    Expanded(child: _Box(width: 140, height: 14, radius: 4)),
                    _Box(width: 60, height: 24, radius: 12),
                  ],
                ),
                const SizedBox(height: 12),
                for (int i = 0; i < 3; i++) ...[
                  Row(
                    children: const [
                      _Box(width: 16, height: 16, radius: 4),
                      SizedBox(width: 8),
                      _Box(width: 80, height: 12, radius: 4),
                      SizedBox(width: 8),
                      _Box(width: 100, height: 12, radius: 4),
                    ],
                  ),
                  const SizedBox(height: 6),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Attendances: table-like shimmer
class ShimmerTable extends StatelessWidget {
  final int rowCount;
  const ShimmerTable({super.key, this.rowCount = 8});

  @override
  Widget build(BuildContext context) {
    return _shimmerWrap(
      context,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Header row
                  Row(
                    children: const [
                      Expanded(child: _Box(width: 60, height: 14, radius: 4)),
                      SizedBox(width: 24),
                      Expanded(child: _Box(width: 60, height: 14, radius: 4)),
                    ],
                  ),
                  const Divider(height: 24),
                  // Data rows
                  for (int i = 0; i < rowCount; i++) ...[
                    Row(
                      children: [
                        const _Box(width: 14, height: 14, radius: 3),
                        const SizedBox(width: 8),
                        const Expanded(child: _Box(width: 80, height: 12, radius: 4)),
                        const SizedBox(width: 24),
                        const _Box(width: 14, height: 14, radius: 3),
                        const SizedBox(width: 8),
                        const Expanded(child: _Box(width: 60, height: 12, radius: 4)),
                      ],
                    ),
                    if (i < rowCount - 1) const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Waitlist/Cancellations: colored banner-like containers with left border
class ShimmerBannerList extends StatelessWidget {
  final int itemCount;
  final Color color;
  const ShimmerBannerList({super.key, this.itemCount = 4, this.color = Colors.grey});

  @override
  Widget build(BuildContext context) {
    return _shimmerWrap(
      context,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: itemCount,
        padding: const EdgeInsets.all(16),
        itemBuilder: (_, _) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withAlpha(30),
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(color: color.withAlpha(60), width: 4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _Box(width: double.infinity, height: 14, radius: 4),
              SizedBox(height: 8),
              _Box(width: 200, height: 12, radius: 4),
            ],
          ),
        ),
      ),
    );
  }
}

/// Barcode: centered icon + text + card with barcode placeholder
class ShimmerBarcode extends StatelessWidget {
  const ShimmerBarcode({super.key});

  @override
  Widget build(BuildContext context) {
    return _shimmerWrap(
      context,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Column(
              children: [
                const _Box(width: 48, height: 48, radius: 12),
                const SizedBox(height: 16),
                const _Box(width: 160, height: 18, radius: 4),
                const SizedBox(height: 8),
                const _Box(width: 220, height: 14, radius: 4),
                const SizedBox(height: 32),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: const [
                        _Box(width: 280, height: 100, radius: 4),
                        SizedBox(height: 16),
                        _Box(width: 180, height: 24, radius: 4),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Profile: avatar + name + badge + field cards
class ShimmerProfile extends StatelessWidget {
  const ShimmerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return _shimmerWrap(
      context,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          // Avatar
          const Center(child: _Box(width: 96, height: 96, radius: 48)),
          const SizedBox(height: 12),
          const Center(child: _Box(width: 140, height: 20, radius: 4)),
          const SizedBox(height: 8),
          const Center(child: _Box(width: 100, height: 24, radius: 12)),
          const SizedBox(height: 32),
          // Profile field cards
          for (int i = 0; i < 3; i++) ...[
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const _Box(width: 24, height: 24, radius: 6),
                title: const _Box(width: 80, height: 12, radius: 4),
                subtitle: const _Box(width: 120, height: 16, radius: 4),
              ),
            ),
          ],
          const SizedBox(height: 24),
          const _Box(width: double.infinity, height: 40, radius: 20),
        ],
      ),
    );
  }
}

/// Book class: step headers with chips/calendar placeholders
class ShimmerBookClass extends StatelessWidget {
  const ShimmerBookClass({super.key});

  @override
  Widget build(BuildContext context) {
    return _shimmerWrap(
      context,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Box(width: 200, height: 14, radius: 4),
            const SizedBox(height: 20),
            // Step 1 header
            Row(
              children: const [
                _Box(width: 28, height: 28, radius: 14),
                SizedBox(width: 10),
                _Box(width: 140, height: 16, radius: 4),
              ],
            ),
            const SizedBox(height: 12),
            // Choice chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                _Box(width: 90, height: 32, radius: 16),
                _Box(width: 110, height: 32, radius: 16),
                _Box(width: 80, height: 32, radius: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
