
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/login_service.dart'; 
import '../screens/dashboard/main.dart';
import '../utils/session_manager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  static const Color sageGreen = Color(0xFF9CAF88);
  static const Color mintCream = Color(0xFFF0F4EC);
  static const Color forestMist = Color(0xFF6B7D5C);
  static const Color eucalyptus = Color(0xFFA8B5A0);
  static const Color pineShadow = Color(0xFF4A5D3A);
  static const Color mossStone = Color(0xFF7A8471);

  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final result = await LoginService.login(email, password);

    if (result['success'] == true) {
      final ustadz = result['data']; // Tipe: Ustadz

      // Simpan sesi ke SharedPreferences
      await SessionManager.saveUstadzSession(
        idUser: ustadz.idUser,
        nama: ustadz.namaUstadz,
        photo: ustadz.photo,
        accessToken: ustadz.accessToken,
        expiresIn: ustadz.expiresIn,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }

    if (mounted) setState(() => _isLoading = false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [mintCream, Color(0xFFE8F0E3), Color(0xFFDEE8D7)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _slideAnimation.value),
                child: Opacity(
                  opacity: _fadeAnimation.value,
                  child: _buildLoginContent(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoginContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          _buildFuturisticHeader(),
          const SizedBox(height: 30),
          _buildLoginForm(),
        ],
      ),
    );
  }

  Widget _buildFuturisticHeader() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                colors: [sageGreen, eucalyptus, forestMist],
                stops: [0.0, 0.7, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: sageGreen.withOpacity(0.4),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                  spreadRadius: 5,
                ),
                BoxShadow(
                  color: eucalyptus.withOpacity(0.2),
                  blurRadius: 50,
                  offset: const Offset(0, 20),
                  spreadRadius: 10,
                ),
              ],
            ),
            child: const Icon(Icons.eco_outlined, size: 50, color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _buildLoginForm() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: mossStone.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: sageGreen.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 15),
            spreadRadius: 5,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            blurRadius: 20,
            offset: const Offset(-5, -5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('USTADZ PPATQ-RF',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 25,
                fontWeight: FontWeight.w700,
                color: pineShadow,
              )),
          const SizedBox(height: 8),
          Text('Silakan masuk ke akun Anda',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: forestMist,
              )),
          const SizedBox(height: 40),
          _buildTextField(_emailController, 'Email', Icons.person_outline_rounded),
          const SizedBox(height: 24),
          _buildTextField(_passwordController, 'Password', Icons.lock_outline_rounded, isPassword: true),
          const SizedBox(height: 32),
          _buildFuturisticButton(),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? _obscurePassword : false,
      style: GoogleFonts.poppins(fontSize: 16, color: pineShadow),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: forestMist),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: forestMist),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              )
            : null,
        filled: true,
        fillColor: mintCream.withOpacity(0.8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }

  Widget _buildFuturisticButton() {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: sageGreen,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Masuk',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      )),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded, color: Colors.white),
                ],
              ),
      ),
    );
  }
}
