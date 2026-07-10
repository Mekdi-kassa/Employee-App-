import 'package:employee_app/core/color/theme.dart';
import 'package:employee_app/features/login/provider/login_provider.dart';
import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _identityController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _fillDemoCredentials() {
    _identityController.text = 'demo';
    _passwordController.text = 'demo123';
  }

  @override
  void dispose() {
    _identityController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin(AuthProvider auth) async {
    if (_formKey.currentState!.validate()) {
      final success = await auth.login(_identityController.text.trim(), _passwordController.text);
      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(auth.errorMessage ?? 'Error'), 
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthScope.of(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(auth.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
            onPressed: () => auth.toggleTheme(!auth.isDarkMode),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: AppTheme.brandGreen.withOpacity(0.15), shape: BoxShape.circle),
                    child: const Icon(Icons.connecting_airports_rounded, size: 64, color: AppTheme.brandGreen),
                  ),
                ),
                const SizedBox(height: 24),
                Text('Employee Portal', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Card(
                  color: AppTheme.brandGreen.withOpacity(0.08),
                  elevation: 0,
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Demo access', style: TextStyle(fontWeight: FontWeight.w700)),
                        SizedBox(height: 8),
                        Text('Username: demo'),
                        Text('Password: demo123'),
                        SizedBox(height: 6),
                        Text('This app is running in offline demo mode until the API is ready.'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _fillDemoCredentials,
                  icon: const Icon(Icons.auto_fix_high_rounded),
                  label: const Text('Use demo credentials'),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _identityController,
                  decoration: const InputDecoration(labelText: 'Username or Email', prefixIcon: Icon(Icons.person_outline_rounded)),
                  validator: (value) => value == null || value.trim().isEmpty ? 'Field required.' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Field required.' : null,
                ),
                const SizedBox(height: 32),
                auth.isLoading
                    ? const Center(child: CircularProgressIndicator(color: AppTheme.brandGreen))
                    : ElevatedButton(
                        onPressed: () => _handleLogin(auth),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.brandGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}