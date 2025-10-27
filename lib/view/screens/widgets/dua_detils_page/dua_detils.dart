
import 'package:flutter/material.dart';
import '../../../../model/dua_model/dua_model.dart';
import '../step_card/step_card.dart';


class DuaDetailPage extends StatelessWidget {
  final DuaModel dua;

  const DuaDetailPage({super.key, required this.dua});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(dua.title)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header image
            if (dua.imagePath.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                child: Image.asset(
                  dua.imagePath,
                  width: double.infinity,
                  height: 240,
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(height: 14),

            // Title + intro
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Text(
                    dua.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  if (dua.intro != null)
                    Text(
                      dua.intro!,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.justify,
                    ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Steps list
            if (dua.steps.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: dua.steps.map((s) {
                    return StepCard(
                      index: s.order,
                      title: s.title,
                      subtitle: s.subtitle,
                      note: s.extraNote,
                    );
                  }).toList(),
                ),
              )
            else
            // Fallback: single description card
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  dua.intro ?? 'No details available.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
