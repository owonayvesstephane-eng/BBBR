import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const BatixApp());
}

// ============================================================================
// PALETTE DE COULEURS & STYLE BATIX (Conforme aux maquettes)
// ============================================================================
class BatixColors {
  static const Color bgDark = Color(0xFF08121E);
  static const Color bgCard = Color(0xFF102132);
  static const Color border = Color(0xFF1E3A56);
  static const Color green = Color(0xFF00A859);
  static const Color greenLight = Color(0xFF10B981);
  static const Color orange = Color(0xFFFF8C00);
  static const Color orangeLight = Color(0xFFFFB300);

  static const LinearGradient orangeGradient = LinearGradient(
    colors: [Color(0xFFFF7A00), Color(0xFFFFAE00)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient greenGradient = LinearGradient(
    colors: [Color(0xFF008F4C), Color(0xFF10B981)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient darkBackgroundGradient = LinearGradient(
    colors: [Color(0xFF0A1929), Color(0xFF06101A), Color(0xFF0A221E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

// ============================================================================
// BASE DE DONNÉES EN MÉMOIRE (Partagée entre Client et Transporteur)
// ============================================================================
class OrderModel {
  final String id;
  final String productName;
  final String supplierName;
  final int unitPrice;
  final int deliveryFee;
  final int quantity;
  final String destination;
  final String secretCode;
  String status;
  String? photo1Matricule;
  String? photo2Cargaison;
  String? photo3Sol;
  bool isSigned;

  OrderModel({
    required this.id,
    required this.productName,
    required this.supplierName,
    required this.unitPrice,
    required this.deliveryFee,
    required this.quantity,
    required this.destination,
    required this.secretCode,
    this.status = 'En cours',
    this.photo1Matricule,
    this.photo2Cargaison,
    this.photo3Sol,
    this.isSigned = false,
  });

  int get totalMaterials => unitPrice * quantity;
  int get grandTotal => totalMaterials + deliveryFee;
}

class AppDatabase {
  static final List<OrderModel> orders = [
    OrderModel(
      id: 'CMD-2026-00124',
      productName: 'Ciment 50kg (CPJ 42.5)',
      supplierName: 'Fournisseur B (Dépôt Central)',
      unitPrice: 4900,
      deliveryFee: 15000,
      quantity: 50,
      destination: 'Chantier Odza (Derrière Tradex)',
      secretCode: '8419',
    ),
  ];

  static final List<Map<String, dynamic>> products = [
    {
      'name': 'Ciment 50kg',
      'subtitle': 'Haute qualité • CPJ 42.5 / Robuste',
      'category': 'Ciment',
      'unit': 'sac',
      'icon': Icons.foundation,
      'suppliers': [
        {'name': 'Fournisseur A', 'price': 5000, 'delivery': 15000, 'delay': '24h', 'rating': 4.7, 'stock': 600},
        {'name': 'Fournisseur B', 'price': 4900, 'delivery': 15000, 'delay': '24h', 'rating': 4.8, 'stock': 450},
        {'name': 'Fournisseur C', 'price': 5100, 'delivery': 10000, 'delay': 'Express 6h', 'rating': 4.9, 'stock': 1200},
        {'name': 'Fournisseur D', 'price': 4850, 'delivery': 20000, 'delay': '48h', 'rating': 4.4, 'stock': 300},
      ],
    },
    {
      'name': 'Fer à béton 12mm',
      'subtitle': 'Acier haute résistance • FeE500',
      'category': 'Fer à béton',
      'unit': 'barre',
      'icon': Icons.linear_scale,
      'suppliers': [
        {'name': 'Fournisseur A', 'price': 6800, 'delivery': 15000, 'delay': '24h', 'rating': 4.7, 'stock': 500},
        {'name': 'Fournisseur B', 'price': 6650, 'delivery': 18000, 'delay': '24h', 'rating': 4.6, 'stock': 800},
        {'name': 'Fournisseur C', 'price': 6900, 'delivery': 12000, 'delay': 'Express 12h', 'rating': 4.8, 'stock': 350},
      ],
    },
    {
      'name': 'Gravier 5/15 ou 15/25',
      'subtitle': 'Granulats de carrière concassés',
      'category': 'Gravier',
      'unit': 'm³',
      'icon': Icons.landscape,
      'suppliers': [
        {'name': 'Fournisseur A', 'price': 4200, 'delivery': 25000, 'delay': '24h', 'rating': 4.8, 'stock': 200},
        {'name': 'Fournisseur B', 'price': 4000, 'delivery': 28000, 'delay': '48h', 'rating': 4.5, 'stock': 150},
        {'name': 'Fournisseur E', 'price': 4150, 'delivery': 22000, 'delay': '24h', 'rating': 4.7, 'stock': 400},
      ],
    },
    {
      'name': 'Bois de coffrage',
      'subtitle': 'Planche épaisseur 25mm • Traitée',
      'category': 'Bois',
      'unit': 'm²',
      'icon': Icons.forest,
      'suppliers': [
        {'name': 'Fournisseur A', 'price': 12000, 'delivery': 15000, 'delay': '24h', 'rating': 4.6, 'stock': 120},
        {'name': 'Fournisseur B', 'price': 11500, 'delivery': 15000, 'delay': '24h', 'rating': 4.8, 'stock': 300},
      ],
    },
    {
      'name': 'Parpaings 15cm / 20cm',
      'subtitle': 'Agglos vibrés haute densité',
      'category': 'Brique',
      'unit': 'pièce',
      'icon': Icons.grid_view_rounded,
      'suppliers': [
        {'name': 'Fournisseur A', 'price': 350, 'delivery': 20000, 'delay': '24h', 'rating': 4.7, 'stock': 5000},
        {'name': 'Fournisseur B', 'price': 325, 'delivery': 22000, 'delay': '48h', 'rating': 4.5, 'stock': 8000},
      ],
    },
  ];
}

class BatixApp extends StatelessWidget {
  const BatixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BATIX',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: BatixColors.bgDark,
        primaryColor: BatixColors.green,
        fontFamily: 'Roboto',
      ),
      home: const OnboardingScreen(),
    );
  }
}

// ============================================================================
// WIDGET LOGO BATIX RÉUTILISABLE
// ============================================================================
class BatixLogoHeader extends StatelessWidget {
  final double size;
  final bool showTagline;
  final bool darkText;

  const BatixLogoHeader({
    super.key,
    this.size = 70,
    this.showTagline = true,
    this.darkText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [BatixColors.green, Color(0xFF053824)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: BatixColors.orange, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: BatixColors.green.withOpacity(0.35),
                blurRadius: 14,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/logo.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Icon(
                Icons.local_shipping_rounded,
                size: size * 0.55,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: size * 0.42,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
            children: [
              TextSpan(
                text: 'BATI',
                style: TextStyle(color: darkText ? const Color(0xFF0A2239) : Colors.white),
              ),
              const TextSpan(
                text: 'X',
                style: TextStyle(color: BatixColors.orange),
              ),
            ],
          ),
        ),
        if (showTagline) ...[
          const SizedBox(height: 4),
          Text(
            "L'approvisionnement intelligent\nde vos chantiers.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: darkText ? Colors.black87 : Colors.white70,
              height: 1.3,
            ),
          ),
        ],
      ],
    );
  }
}

// ============================================================================
// ÉCRAN 1 : PAGE D'ACCUEIL / BIENVENUE
// ============================================================================
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: BatixColors.darkBackgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const BatixLogoHeader(size: 95, showTagline: true),
                const Spacer(),
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      colors: [
                        BatixColors.orange.withOpacity(0.25),
                        BatixColors.green.withOpacity(0.25),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(color: BatixColors.border, width: 1.5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.local_shipping_rounded, size: 90, color: BatixColors.orangeLight),
                      SizedBox(height: 12),
                      Text(
                        'Votre partenaire logistique BTP de confiance',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    _FeatureBadge(icon: Icons.widgets_rounded, label: 'Matériaux\nBTP'),
                    _FeatureBadge(icon: Icons.bolt_rounded, label: 'Livraison\nrapide'),
                    _FeatureBadge(icon: Icons.verified_user_rounded, label: 'Partenaires\nfiables'),
                  ],
                ),
                const SizedBox(height: 28),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const WelcomeAuthScreen()),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: BatixColors.orangeGradient,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: BatixColors.orange.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Commencer',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_forward_rounded, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _FeatureBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: BatixColors.green.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(color: BatixColors.green),
          ),
          child: Icon(icon, color: BatixColors.greenLight, size: 24),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, color: Colors.white70),
        ),
      ],
    );
  }
}

// ============================================================================
// ÉCRAN 2 : INSCRIPTION, CONNEXION OU DÉMO
// ============================================================================
class WelcomeAuthScreen extends StatelessWidget {
  const WelcomeAuthScreen({super.key});

  void _goToProfileChoice(BuildContext context, String mode) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProfileSelectionScreen(authMode: mode)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: BatixColors.darkBackgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(height: 10),
                const BatixLogoHeader(size: 85, showTagline: false),
                const SizedBox(height: 24),
                const Text(
                  'Bienvenue sur BATIX',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Connectez-vous ou créez votre compte\npour accéder à tous les services.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 40),
                _AuthOptionButton(
                  icon: Icons.person_add_alt_1_rounded,
                  label: "S'inscrire",
                  gradient: BatixColors.orangeGradient,
                  textColor: Colors.white,
                  onTap: () => _goToProfileChoice(context, 'inscription'),
                ),
                const SizedBox(height: 16),
                _AuthOptionButton(
                  icon: Icons.login_rounded,
                  label: 'Se connecter',
                  bgColor: BatixColors.bgCard,
                  borderColor: BatixColors.greenLight,
                  textColor: Colors.white,
                  onTap: () => _goToProfileChoice(context, 'connexion'),
                ),
                const SizedBox(height: 16),
                _AuthOptionButton(
                  icon: Icons.play_circle_outline_rounded,
                  label: 'Mode démo',
                  bgColor: Colors.white,
                  textColor: BatixColors.bgDark,
                  onTap: () => _goToProfileChoice(context, 'demo'),
                ),
                const Spacer(),
                const Text(
                  'Ensemble pour des chantiers\nplus performants !',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.white60,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthOptionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final LinearGradient? gradient;
  final Color? bgColor;
  final Color? borderColor;
  final Color textColor;
  final VoidCallback onTap;

  const _AuthOptionButton({
    required this.icon,
    required this.label,
    this.gradient,
    this.bgColor,
    this.borderColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          gradient: gradient,
          color: bgColor,
          borderRadius: BorderRadius.circular(30),
          border: borderColor != null ? Border.all(color: borderColor!, width: 1.5) : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: textColor, size: 26),
            const Expanded(child: SizedBox()),
            Text(
              label,
              style: TextStyle(color: textColor, fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const Expanded(child: SizedBox()),
            Icon(Icons.chevron_right_rounded, color: textColor),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// ÉCRAN 3 : CHOIX DU PROFIL (4 Profils)
// ============================================================================
class ProfileSelectionScreen extends StatelessWidget {
  final String authMode;
  const ProfileSelectionScreen({super.key, required this.authMode});

  void _selectRole(BuildContext context, String roleTitle, String roleKey) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(roleTitle: roleTitle, roleKey: roleKey, authMode: authMode),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: BatixColors.darkBackgroundGradient),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text(
                      'BATIX • Choix du profil',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: BatixColors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: BatixColors.orange),
                    ),
                    child: const Text(
                      'Étape 1 / 2',
                      style: TextStyle(color: BatixColors.orangeLight, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'En tant que quoi souhaitez-vous continuer ?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 6),
              const Text(
                'Sélectionnez votre profil pour configurer vos accès sécurisés :',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 20),
              _ProfileRoleCard(
                number: '1. Client (Acheteur BTP)',
                description:
                    'Accéder au catalogue, comparer les Fournisseurs A, B, C, D proches de votre chantier et être livré en express.',
                icon: Icons.shopping_cart_checkout_rounded,
                accentColor: BatixColors.greenLight,
                onTap: () => _selectRole(context, 'Espace Client BTP', 'client'),
              ),
              _ProfileRoleCard(
                number: '2. Fournisseur',
                description:
                    'Publier vos matériaux avec photo, qualité et tarifs (ou importer votre fichier Excel) et recevoir les commandes.',
                icon: Icons.factory_rounded,
                accentColor: BatixColors.orange,
                onTap: () => _selectRole(context, 'Espace Fournisseur', 'fournisseur'),
              ),
              _ProfileRoleCard(
                number: '3. Transporteur / Livreur',
                description:
                    'Partager votre GPS en direct au client, filmer avec la caméra directe les 3 preuves et faire signer avec le code secret.',
                icon: Icons.local_shipping_rounded,
                accentColor: Colors.lightBlueAccent,
                onTap: () => _selectRole(context, 'Espace Livraison', 'transporteur'),
              ),
              _ProfileRoleCard(
                number: '4. Agent de BATIX',
                description:
                    'Superviser les inscriptions légales, auditer les preuves de livraison et contrôler les reçus et paiements.',
                icon: Icons.shield_rounded,
                accentColor: Colors.purpleAccent,
                onTap: () => _selectRole(context, 'Console Agent BATIX', 'agent'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileRoleCard extends StatelessWidget {
  final String number;
  final String description;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;

  const _ProfileRoleCard({
    required this.number,
    required this.description,
    required this.icon,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: BatixColors.bgCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: accentColor.withOpacity(0.5), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: accentColor, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    number,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, color: accentColor, size: 18),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: const TextStyle(color: Colors.white70, fontSize: 13.5, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// ÉCRAN 4 : CONNEXION / INSCRIPTION
// ============================================================================
class LoginScreen extends StatefulWidget {
  final String roleTitle;
  final String roleKey;
  final String authMode;

  const LoginScreen({
    super.key,
    required this.roleTitle,
    required this.roleKey,
    required this.authMode,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailCtrl = TextEditingController(text: 'client@batix.com');
  final TextEditingController _passCtrl = TextEditingController(text: '••••••••');
  bool _rememberMe = true;

  void _submit() {
    if (widget.roleKey == 'client') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ClientMainScreen()),
      );
    } else if (widget.roleKey == 'transporteur') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TransporterDashboardScreen()),
      );
    } else if (widget.roleKey == 'fournisseur') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SupplierPreviewScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AgentPreviewScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isSignup = widget.authMode == 'inscription';
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: BatixColors.darkBackgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const BatixLogoHeader(size: 75, showTagline: true),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: BatixColors.bgCard.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: BatixColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isSignup ? "S'inscrire • ${widget.roleTitle}" : widget.roleTitle,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Accédez à votre espace en toute sécurité',
                        style: TextStyle(color: Colors.white60, fontSize: 13),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _emailCtrl,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email_outlined, color: Colors.white70),
                          hintText: 'Adresse e-mail ou téléphone',
                          filled: true,
                          fillColor: BatixColors.bgDark,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: BatixColors.border),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _passCtrl,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline, color: Colors.white70),
                          suffixIcon: const Icon(Icons.visibility_outlined, color: Colors.white54),
                          hintText: 'Mot de passe',
                          filled: true,
                          fillColor: BatixColors.bgDark,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: BatixColors.border),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            activeColor: BatixColors.orange,
                            onChanged: (v) => setState(() => _rememberMe = v ?? true),
                          ),
                          const Text('Se souvenir de moi', style: TextStyle(fontSize: 13)),
                          const Spacer(),
                          const Text(
                            'Mot de passe oublié ?',
                            style: TextStyle(color: BatixColors.orangeLight, fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: _submit,
                        child: Container(
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: BatixColors.orangeGradient,
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: Center(
                            child: Text(
                              isSignup ? "Valider l'inscription  →" : '→   Se connecter',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          side: const BorderSide(color: BatixColors.green),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                        ),
                        onPressed: _submit,
                        icon: const Icon(Icons.g_mobiledata_rounded, size: 30, color: Colors.white),
                        label: const Text(
                          'Se connecter avec Google',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// ESPACE CLIENT : ACCUEIL + CATALOGUE ALIBABA (Fournisseurs A, B, C...)
// ============================================================================
class ClientMainScreen extends StatefulWidget {
  const ClientMainScreen({super.key});

  @override
  State<ClientMainScreen> createState() => _ClientMainScreenState();
}

class _ClientMainScreenState extends State<ClientMainScreen> {
  int _selectedIndex = 1;
  String _searchQuery = '';
  String _selectedCategory = 'Tous';

  final List<String> _categories = ['Tous', 'Ciment', 'Fer à béton', 'Gravier', 'Bois', 'Brique'];

  @override
  Widget build(BuildContext context) {
    final filteredProducts = AppDatabase.products.where((p) {
      final matchesCategory = _selectedCategory == 'Tous' || p['category'] == _selectedCategory;
      final matchesSearch = p['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p['category'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: BatixColors.bgDark),
        title: const BatixLogoHeader(size: 34, showTagline: false, darkText: true),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Changer de profil (Tester Livreur)',
            icon: const Icon(Icons.swap_horiz_rounded, color: BatixColors.green),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ProfileSelectionScreen(authMode: 'connexion')),
              );
            },
          ),
        ],
      ),
      drawer: _buildClientDrawer(context),
      body: _selectedIndex == 0
          ? _buildClientHomeDashboard()
          : _selectedIndex == 1
              ? _buildAlibabaCatalog(filteredProducts)
              : _buildClientOrdersList(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: BatixColors.green,
        unselectedItemColor: Colors.blueGrey,
        currentIndex: _selectedIndex,
        onTap: (idx) => setState(() => _selectedIndex = idx),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.manage_search_rounded), label: 'Catalogue'),
          BottomNavigationBarItem(icon: Icon(Icons.local_shipping_outlined), label: 'Livraisons'),
        ],
      ),
    );
  }

  Widget _buildClientDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: BatixColors.bgDark,
      child: SafeArea(
        child: Column(
          children: [
            const ListTile(
              leading: CircleAvatar(
                backgroundColor: BatixColors.green,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text('Utilisateur BATIX', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('client@batix.com • Client BTP', style: TextStyle(color: BatixColors.greenLight, fontSize: 12)),
            ),
            const Divider(color: BatixColors.border),
            ListTile(
              leading: const Icon(Icons.home_rounded, color: BatixColors.greenLight),
              title: const Text('Accueil'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _selectedIndex = 0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.grid_view_rounded, color: Colors.white70),
              title: const Text('Catalogue & Fournisseurs'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _selectedIndex = 1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_shipping_rounded, color: Colors.white70),
              title: const Text('Suivi des livraisons'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _selectedIndex = 2);
              },
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
              title: const Text('Changer de profil / Déconnexion', style: TextStyle(color: Colors.redAccent)),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const WelcomeAuthScreen()),
                  (route) => false,
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildClientHomeDashboard() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0A2E23), BatixColors.green],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Des matériaux\nau bon endroit,\nau bon moment !',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: BatixColors.orange,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () => setState(() => _selectedIndex = 1),
                child: const Text('Comparer les fournisseurs →'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.35,
          children: [
            _HomeQuickCard(
              icon: Icons.shopping_cart_rounded,
              color: BatixColors.green,
              title: 'Commander\nun produit',
              onTap: () => setState(() => _selectedIndex = 1),
            ),
            _HomeQuickCard(
              icon: Icons.location_on_rounded,
              color: BatixColors.orange,
              title: 'Suivre une\nlivraison',
              onTap: () => setState(() => _selectedIndex = 2),
            ),
            _HomeQuickCard(
              icon: Icons.construction_rounded,
              color: Colors.blue,
              title: 'Mes chantiers\nen cours',
              onTap: () => setState(() => _selectedIndex = 2),
            ),
            _HomeQuickCard(
              icon: Icons.receipt_long_rounded,
              color: Colors.purple,
              title: 'Mes commandes\n& Codes secrets',
              onTap: () => setState(() => _selectedIndex = 2),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAlibabaCatalog(List<Map<String, dynamic>> products) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          child: Column(
            children: [
              TextField(
                style: const TextStyle(color: Colors.black87),
                onChanged: (v) => setState(() => _searchQuery = v),
                decoration: InputDecoration(
                  hintText: 'Rechercher un produit (ex: Ciment, Fer, Gravier...)',
                  hintStyle: const TextStyle(color: Colors.black45, fontSize: 14),
                  prefixIcon: const Icon(Icons.search_rounded, color: BatixColors.green),
                  suffixIcon: const Icon(Icons.tune_rounded, color: Colors.black54),
                  filled: true,
                  fillColor: const Color(0xFFF0F4F8),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 36,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final selected = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(cat),
                        selected: selected,
                        selectedColor: BatixColors.green,
                        backgroundColor: const Color(0xFFE8EEF3),
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                        onSelected: (_) => setState(() => _selectedCategory = cat),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final List suppliers = product['suppliers'] as List;
              final int minPrice = suppliers.map((s) => s['price'] as int).reduce(min);
              final int maxPrice = suppliers.map((s) => s['price'] as int).reduce(max);

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: BatixColors.orange.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(product['icon'] as IconData, color: BatixColors.orange, size: 36),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['name'],
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0A2239),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                product['subtitle'],
                                style: const TextStyle(fontSize: 12.5, color: Colors.black54),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'De $minPrice à $maxPrice FCFA / ${product['unit']}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: BatixColors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${suppliers.length} fournisseurs (A, B, C...)',
                          style: const TextStyle(fontSize: 12.5, color: Colors.black54, fontWeight: FontWeight.w600),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: BatixColors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          onPressed: () => _openSupplierComparisonSheet(context, product),
                          icon: const Icon(Icons.compare_arrows_rounded, size: 18),
                          label: const Text('Choisir fournisseur'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _openSupplierComparisonSheet(BuildContext context, Map<String, dynamic> product) {
    final List suppliers = product['suppliers'] as List;
    int selectedSupplierIdx = suppliers.length > 1 ? 1 : 0;
    int quantity = 50;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: BatixColors.bgDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final chosen = suppliers[selectedSupplierIdx];
            final int unitPrice = chosen['price'] as int;
            final int delivery = chosen['delivery'] as int;
            final int totalPrice = (unitPrice * quantity) + delivery;

            return Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${product['name']} • Fournisseurs',
                        style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white70),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const Text(
                    'Comparez les tarifs des fournisseurs vérifiés et choisissez votre quantité :',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 14),
                  ...List.generate(suppliers.length, (i) {
                    final s = suppliers[i];
                    final isSelected = i == selectedSupplierIdx;
                    return GestureDetector(
                      onTap: () => setModalState(() => selectedSupplierIdx = i),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isSelected ? BatixColors.green.withOpacity(0.18) : BatixColors.bgCard,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected ? BatixColors.greenLight : BatixColors.border,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                              color: isSelected ? BatixColors.greenLight : Colors.white54,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        s['name'],
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                      ),
                                      const SizedBox(width: 6),
                                      const Icon(Icons.verified, color: BatixColors.greenLight, size: 16),
                                      const SizedBox(width: 6),
                                      Text('⭐ ${s['rating']}', style: const TextStyle(fontSize: 12, color: Colors.amber)),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Délai : ${s['delay']} • Transport : ${s['delivery']} FCFA • Stock : ${s['stock']}',
                                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${s['price']} FCFA\n/${product['unit']}',
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                                color: BatixColors.orangeLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: BatixColors.bgCard,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: BatixColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Quantité (${product['unit']}s) :',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline, color: BatixColors.orange),
                              onPressed: () {
                                if (quantity > 10) setModalState(() => quantity -= 10);
                              },
                            ),
                            Text(
                              '$quantity',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline, color: BatixColors.greenLight),
                              onPressed: () => setModalState(() => quantity += 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total livré sur chantier :', style: TextStyle(color: Colors.white70)),
                      Text(
                        '$totalPrice FCFA',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: BatixColors.greenLight),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  GestureDetector(
                    onTap: () {
                      final String generatedPin = (1000 + Random().nextInt(9000)).toString();
                      final newOrder = OrderModel(
                        id: 'CMD-2026-00${AppDatabase.orders.length + 125}',
                        productName: '${product['name']} (${product['subtitle']})',
                        supplierName: chosen['name'],
                        unitPrice: unitPrice,
                        deliveryFee: delivery,
                        quantity: quantity,
                        destination: 'Chantier Yaoundé - Riviera / Odza',
                        secretCode: generatedPin,
                      );
                      AppDatabase.orders.insert(0, newOrder);
                      Navigator.pop(ctx);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrderConfirmedScreen(order: newOrder),
                        ),
                      ).then((_) => setState(() => _selectedIndex = 2));
                    },
                    child: Container(
                      width: double.infinity,
                      height: 54,
                      decoration: BoxDecoration(
                        gradient: BatixColors.orangeGradient,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: const Center(
                        child: Text(
                          'Passer la commande & Obtenir le Code Secret',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildClientOrdersList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: AppDatabase.orders.length,
      itemBuilder: (context, index) {
        final o = AppDatabase.orders[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: BatixColors.bgDark,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(o.id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: o.status == 'Livrée' ? BatixColors.green : BatixColors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(o.status, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text('${o.quantity} x ${o.productName}', style: const TextStyle(color: Colors.white, fontSize: 15)),
              Text('Fournisseur choisi : ${o.supplierName} (${o.unitPrice} FCFA/u)',
                  style: const TextStyle(color: Colors.white70, fontSize: 13)),
              Text('Total payé (protégé) : ${o.grandTotal} FCFA',
                  style: const TextStyle(color: BatixColors.greenLight, fontWeight: FontWeight.bold)),
              const Divider(color: BatixColors.border, height: 24),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: BatixColors.bgCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: BatixColors.orange),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Code secret à 4 chiffres\n(À donner au livreur à l\'arrivée) :',
                        style: TextStyle(fontSize: 12.5, color: Colors.white70),
                      ),
                    ),
                    Text(
                      o.secretCode.split('').join(' '),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: BatixColors.orangeLight,
                        letterSpacing: 4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HomeQuickCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final VoidCallback onTap;

  const _HomeQuickCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF0A2239),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// ÉCRAN COMMANDE CONFIRMÉE + CODE SECRET À 4 CHIFFRES
// ============================================================================
class OrderConfirmedScreen extends StatelessWidget {
  final OrderModel order;
  const OrderConfirmedScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: BatixColors.darkBackgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: BatixColors.green.withOpacity(0.2),
                    border: Border.all(color: BatixColors.greenLight, width: 3),
                  ),
                  child: const Icon(Icons.check_rounded, size: 64, color: BatixColors.greenLight),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Commande confirmée !',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Votre commande a bien été enregistrée.',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: BatixColors.bgCard,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: BatixColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('N° ${order.id}', style: const TextStyle(color: Colors.white70)),
                      const SizedBox(height: 6),
                      Text(
                        '${order.quantity} x ${order.productName}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text('Fournisseur : ${order.supplierName}', style: const TextStyle(color: Colors.white70)),
                      const Divider(color: BatixColors.border, height: 24),
                      Text(
                        'Total : ${order.grandTotal} FCFA',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: BatixColors.bgDark,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: BatixColors.orange),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'GARDEZ PRÉCIEUSEMENT VOTRE CODE SECRET DE LIVRAISON :',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 11.5, color: BatixColors.orangeLight, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              order.secretCode.split('').join('   '),
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: BatixColors.orangeGradient,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: const Center(
                      child: Text(
                        '→   Voir mes commandes & Suivi GPS',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const BatixLogoHeader(size: 50, showTagline: true),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// ESPACE TRANSPORTEUR / LIVREUR
// ============================================================================
class TransporterDashboardScreen extends StatefulWidget {
  const TransporterDashboardScreen({super.key});

  @override
  State<TransporterDashboardScreen> createState() => _TransporterDashboardScreenState();
}

class _TransporterDashboardScreenState extends State<TransporterDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: BatixColors.darkBackgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const BatixLogoHeader(size: 38, showTagline: false),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: BatixColors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: BatixColors.greenLight),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.circle, size: 10, color: BatixColors.greenLight),
                          SizedBox(width: 6),
                          Text('GPS En ligne', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout_rounded, color: Colors.white70),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const ProfileSelectionScreen(authMode: 'connexion')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const Text(
                      'Bonjour, livreur 👋',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "Voici vos livraisons assignées aujourd'hui",
                      style: TextStyle(color: Colors.white70, fontSize: 13.5),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: BatixColors.bgCard,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: BatixColors.border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${AppDatabase.orders.length}',
                                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                                const Text('Livraisons du jour', style: TextStyle(fontSize: 12, color: Colors.white70)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: BatixColors.bgCard,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: BatixColors.border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('18.5 km', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                                Text('Distance GPS estimée', style: TextStyle(fontSize: 12, color: Colors.white70)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Missions de livraison à effectuer :',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ...AppDatabase.orders.map((order) {
                      final isDone = order.status == 'Livrée';
                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: BatixColors.bgCard,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isDone ? BatixColors.green : BatixColors.orange,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(order.id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isDone ? BatixColors.green : BatixColors.orange,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(order.status, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('${order.quantity} x ${order.productName}',
                                style: const TextStyle(fontWeight: FontWeight.w600)),
                            Text('Enlèvement : ${order.supplierName}', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                            Row(
                              children: [
                                const Icon(Icons.location_on, color: BatixColors.orangeLight, size: 16),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    'Destination GPS : ${order.destination}',
                                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            if (!isDone)
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: BatixColors.green,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => TransporterDeliveryProofScreen(order: order),
                                      ),
                                    ).then((_) => setState(() {}));
                                  },
                                  icon: const Icon(Icons.navigation_rounded),
                                  label: const Text('Suivre itinéraire GPS & Livrer →'),
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// PREUVE DE LIVRAISON : 3 PHOTOS CAMÉRA DIRECTE + SIGNATURE + CODE 4 CHIFFRES
// ============================================================================
class TransporterDeliveryProofScreen extends StatefulWidget {
  final OrderModel order;
  const TransporterDeliveryProofScreen({super.key, required this.order});

  @override
  State<TransporterDeliveryProofScreen> createState() => _TransporterDeliveryProofScreenState();
}

class _TransporterDeliveryProofScreenState extends State<TransporterDeliveryProofScreen> {
  final ImagePicker _picker = ImagePicker();
  final List<Offset?> _signaturePoints = [];
  final TextEditingController _pinController = TextEditingController();

  Future<void> _captureDirectCameraPhoto(int step) async {
    if (step == 2 && widget.order.photo1Matricule == null) {
      _showMsg('Veuillez d\'abord filmer la Photo 1 (Camion avec matricule).');
      return;
    }
    if (step == 3 && widget.order.photo2Cargaison == null) {
      _showMsg('Veuillez d\'abord filmer la Photo 2 (Camion portant le ciment).');
      return;
    }

    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 80,
      );

      setState(() {
        final String pathOrSimulated = photo?.path ?? 'CAPTURED_CAMERA_STEP_$step';
        if (step == 1) widget.order.photo1Matricule = pathOrSimulated;
        if (step == 2) widget.order.photo2Cargaison = pathOrSimulated;
        if (step == 3) widget.order.photo3Sol = pathOrSimulated;
      });
    } catch (e) {
      setState(() {
        if (step == 1) widget.order.photo1Matricule = 'CAMERA_DIRECT_MATRICULE_OK';
        if (step == 2) widget.order.photo2Cargaison = 'CAMERA_DIRECT_CARGAISON_OK';
        if (step == 3) widget.order.photo3Sol = 'CAMERA_DIRECT_SOL_OK';
      });
      _showMsg('Photo $step capturée avec filigrane BATIX & GPS (< 150m).');
    }
  }

  void _validateDelivery() {
    if (widget.order.photo1Matricule == null ||
        widget.order.photo2Cargaison == null ||
        widget.order.photo3Sol == null) {
      _showMsg('Erreur : Les 3 photos prises en direct avec la caméra sont obligatoires !');
      return;
    }
    if (_signaturePoints.isEmpty) {
      _showMsg('Erreur : Le client doit signer sur l\'écran.');
      return;
    }
    if (_pinController.text.trim() != widget.order.secretCode) {
      _showMsg(
        'Code secret invalide ! Demandez au client le code à 4 chiffres (${widget.order.secretCode}).',
      );
      return;
    }

    setState(() {
      widget.order.isSigned = true;
      widget.order.status = 'Livrée';
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: BatixColors.bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.verified_rounded, color: BatixColors.greenLight, size: 30),
            SizedBox(width: 10),
            Expanded(child: Text('Livraison Validée !')),
          ],
        ),
        content: const Text(
          'Les 3 photos horodatées, la signature du client et le code secret à 4 chiffres ont été envoyés à la base de données BATIX.\n\nLe paiement du fournisseur et du transporteur est débloqué.',
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: BatixColors.green),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Terminer la mission'),
          ),
        ],
      ),
    );
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: BatixColors.orange),
    );
  }

  @override
  Widget build(BuildContext context) {
    final o = widget.order;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BatixColors.bgDark,
        title: Text('Livraison ${o.id}'),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: BatixColors.darkBackgroundGradient),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: BatixColors.bgCard,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: BatixColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.gps_fixed_rounded, color: BatixColors.greenLight),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Itinéraire GPS actif : ${o.destination}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Distance du chantier : 35 mètres (< 150m autorisé) • Caméra déverrouillée',
                    style: TextStyle(fontSize: 12, color: BatixColors.greenLight),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Étape 1 : Prendre les 3 photos obligatoires (Caméra directe uniquement, import interdit)',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            _CameraStepTile(
              stepNumber: 1,
              title: 'Photo 1 : Camion avec matricule visible',
              subtitle: 'À l\'entrée du chantier (plaque d\'immatriculation lisible)',
              filePath: o.photo1Matricule,
              isLocked: false,
              onCapture: () => _captureDirectCameraPhoto(1),
            ),
            _CameraStepTile(
              stepNumber: 2,
              title: 'Photo 2 : Camion portant le ciment',
              subtitle: 'Cargaison visible dans le camion avant déchargement',
              filePath: o.photo2Cargaison,
              isLocked: o.photo1Matricule == null,
              onCapture: () => _captureDirectCameraPhoto(2),
            ),
            _CameraStepTile(
              stepNumber: 3,
              title: 'Photo 3 : Le ciment déchargé au sol',
              subtitle: 'Produit posé au sol sur le chantier, camion vide',
              filePath: o.photo3Sol,
              isLocked: o.photo2Cargaison == null,
              onCapture: () => _captureDirectCameraPhoto(3),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Étape 2 : Faites signer le client',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => setState(() => _signaturePoints.clear()),
                  child: const Text('Effacer', style: TextStyle(color: BatixColors.orangeLight)),
                ),
              ],
            ),
            Container(
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: BatixColors.greenLight, width: 2),
              ),
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _signaturePoints.add(details.localPosition);
                  });
                },
                onPanEnd: (_) => _signaturePoints.add(null),
                child: CustomPaint(
                  painter: _SignaturePainter(_signaturePoints),
                  size: Size.infinite,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: BatixColors.bgCard,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: BatixColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Code de validation (4 chiffres)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Le client doit saisir son code secret (Code commande : ${o.secretCode})',
                    style: const TextStyle(fontSize: 12.5, color: Colors.white70),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _pinController,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 16,
                      color: BatixColors.orangeLight,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: '8 4 1 9',
                      hintStyle: const TextStyle(color: Colors.white24, letterSpacing: 12),
                      filled: true,
                      fillColor: BatixColors.bgDark,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: BatixColors.orange),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: _validateDelivery,
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: BatixColors.greenGradient,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: BatixColors.green.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.check_circle_rounded, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      'Valider la livraison  →',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _CameraStepTile extends StatelessWidget {
  final int stepNumber;
  final String title;
  final String subtitle;
  final String? filePath;
  final bool isLocked;
  final VoidCallback onCapture;

  const _CameraStepTile({
    required this.stepNumber,
    required this.title,
    required this.subtitle,
    required this.filePath,
    required this.isLocked,
    required this.onCapture,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDone = filePath != null;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDone ? BatixColors.green.withOpacity(0.15) : BatixColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDone
              ? BatixColors.greenLight
              : isLocked
                  ? Colors.white12
                  : BatixColors.orange,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: isDone
                ? BatixColors.green
                : isLocked
                    ? Colors.white12
                    : BatixColors.orange,
            child: Icon(
              isDone
                  ? Icons.check_rounded
                  : isLocked
                      ? Icons.lock_outline_rounded
                      : Icons.camera_alt_rounded,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.white70)),
                if (isDone)
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      '✓ Capturée en direct • Filigrane BATIX + GPS OK',
                      style: TextStyle(fontSize: 11.5, color: BatixColors.greenLight, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: isLocked ? Colors.grey.shade800 : BatixColors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: isLocked ? null : onCapture,
            icon: const Icon(Icons.camera_alt, size: 16),
            label: Text(isDone ? 'Refaire' : 'Filmer'),
          ),
        ],
      ),
    );
  }
}

class _SignaturePainter extends CustomPainter {
  final List<Offset?> points;
  _SignaturePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFF0A2239)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.2;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SupplierPreviewScreen extends StatelessWidget {
  const SupplierPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: BatixColors.bgDark, title: const Text('Espace Fournisseur BATIX')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.factory_rounded, size: 70, color: BatixColors.orange),
              SizedBox(height: 16),
              Text(
                'Espace Fournisseur prêt pour la phase 2',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Gestion des stocks par entrepôt, import Excel/CSV et confirmation des commandes en 15 minutes.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AgentPreviewScreen extends StatelessWidget {
  const AgentPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: BatixColors.bgDark, title: const Text('Console Agent de BATIX')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.shield_rounded, size: 70, color: Colors.purpleAccent),
              SizedBox(height: 16),
              Text(
                'Console Agent de Contrôle BATIX',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Vérification des dossiers AES-256, audit des 3 photos de livraison et contrôle des paiements.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
