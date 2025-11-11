import 'package:flutter/material.dart';

class OnboardingWidget extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingWidget({super.key, required this.onComplete});

  @override
  State<OnboardingWidget> createState() => _OnboardingWidgetState();
}

class _OnboardingWidgetState extends State<OnboardingWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Onboarding> _widgets = [
    Onboarding(
      icon: Icons.rocket_launch,
      title: 'Découvrez SpaceX',
      description: 'Explorez tous les lancements de fusées SpaceX en temps réel',
    ),
    Onboarding(
      icon: Icons.favorite,
      title: 'Ajoutez vos favoris',
      description: 'Sauvegardez vos lancements préférés et retrouvez-les facilement',
    ),
    Onboarding(
      icon: Icons.view_module,
      title: 'Personnalisez l\'affichage',
      description: 'Choisissez entre la vue grille ou liste selon vos préférences',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _widgets.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildPage(_widgets[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    TextButton(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: const Text('Précédent'),
                    )
                  else
                    const SizedBox(width: 80),
                  Row(
                    children: List.generate(
                      _widgets.length,
                          (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage < _widgets.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        widget.onComplete();
                      }
                    },
                    child: Text(_currentPage < _widgets.length - 1 ? 'Suivant' : 'Commencer'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(Onboarding page) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            page.icon,
            size: 120,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 40),
          Text(
            page.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            page.description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class Onboarding {
  final IconData icon;
  final String title;
  final String description;

  Onboarding({
    required this.icon,
    required this.title,
    required this.description,
  });
}
