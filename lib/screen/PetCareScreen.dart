import 'package:flutter/material.dart';

import 'ai_chat_screen.dart';
import 'pet_health_screen.dart';
import 'grooming_screen.dart';
import 'vaccination_screen.dart';
import 'food_screen.dart';
import 'awareness_screen.dart';

class PetCareScreen extends StatefulWidget {
  const PetCareScreen({super.key});

  @override
  State<PetCareScreen> createState() => _PetCareScreenState();
}

class _PetCareScreenState extends State<PetCareScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _go(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pet Care"),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TopHeroCard(primary: primary),
                const SizedBox(height: 18),

                Text(
                  "Services",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),

                GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1.05,
                  ),
                  children: [
                    _ServiceCard(
                      icon: Icons.health_and_safety,
                      title: "Health Issues",
                      subtitle: "Symptoms & actions",
                      onTap: () => _go(context, const PetHealthScreen()),
                    ),
                    _ServiceCard(
                      icon: Icons.cut,
                      title: "Grooming",
                      subtitle: "Hygiene & care",
                      onTap: () => _go(context, const GroomingScreen()),
                    ),
                    _ServiceCard(
                      icon: Icons.vaccines,
                      title: "Vaccination",
                      subtitle: "Schedule & tips",
                      onTap: () => _go(context, const VaccinationScreen()),
                    ),
                    _ServiceCard(
                      icon: Icons.restaurant,
                      title: "Food Guide",
                      subtitle: "Safe vs unsafe",
                      onTap: () => _go(context, const FoodScreen()),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                _AwarenessCard(
                  onLearnMore: () => _go(context, const AwarenessScreen()),
                  onAskAI: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AIChatScreen(
                          initialPrompt:
                          "Give animal welfare and responsible pet care advice. "
                              "Also include street animal care tips and what not to do.",
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ========================= TOP HERO CARD ========================= */

class _TopHeroCard extends StatelessWidget {
  final Color primary;
  const _TopHeroCard({required this.primary});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            primary.withOpacity(.18),
            theme.cardColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pet Care Hub 🐾",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Trusted guidance on health, grooming, vaccines, food, and welfare awareness — designed for pets and street animals.",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade700,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.verified, size: 18, color: primary),
                    const SizedBox(width: 6),
                    Text(
                      "NGO-style care tips",
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              color: primary.withOpacity(.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.pets, color: primary, size: 28),
          ),
        ],
      ),
    );
  }
}

/* ========================= SERVICE CARD ========================= */

class _ServiceCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _hover = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    final scale = _pressed
        ? 0.98
        : _hover
        ? 1.03
        : 1.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() {
        _hover = false;
        _pressed = false;
      }),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 170),
          curve: Curves.easeOut,
          scale: scale,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: _hover
                      ? primary.withOpacity(.20)
                      : Colors.black.withOpacity(.07),
                  blurRadius: _hover ? 18 : 12,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 46,
                      width: 46,
                      decoration: BoxDecoration(
                        color: primary.withOpacity(.14),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(widget.icon, color: primary, size: 26),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/* ========================= AWARENESS CARD ========================= */

class _AwarenessCard extends StatelessWidget {
  final VoidCallback onLearnMore;
  final VoidCallback onAskAI;

  const _AwarenessCard({
    required this.onLearnMore,
    required this.onAskAI,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: primary.withOpacity(.18)),
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.volunteer_activism, color: primary),
                const SizedBox(width: 8),
                Text(
                  "Awareness & Welfare",
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Learn responsible pet ownership, street animal care, TNVR awareness, and preventive practices.",
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade700,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onLearnMore,
                  child: const Text("Learn More"),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.smart_toy, size: 18),
                  label: const Text("Ask AI"),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: onAskAI,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
