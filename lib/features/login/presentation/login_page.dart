import 'package:employee_app/core/color/theme.dart';
import 'package:flutter/material.dart';
import 'package:employee_app/features/login/provider/login_provider.dart';

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
      final success = await auth.login(
        _identityController.text.trim(),
        _passwordController.text,
      );

      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(auth.errorMessage ?? "Error"),
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
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 20,
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
              child: IconButton(
                splashRadius: 20,
                icon: Icon(
                  auth.isDarkMode
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                ),
                onPressed: () =>
                    auth.toggleTheme(!auth.isDarkMode),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: auth.isDarkMode
                ? const [
                    Color(0xff121212),
                    Color(0xff1D1D1D),
                  ]
                : const [
                    Color(0xffF8FAF8),
                    Colors.white,
                  ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 24,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 450,
                ),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.stretch,
                        children: [

                          const SizedBox(height: 8),

                          Center(
                            child: Container(
                              height: 110,
                              width: 110,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.brandGreen
                                    .withOpacity(.12),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.brandGreen
                                        .withOpacity(.15),
                                    blurRadius: 20,
                                    offset:
                                        const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0), 
                                child: Image.asset(
                                  'assets/logo/Ethiopian_Airlines_idbCkgr4HW_1.png', 
                                  fit: BoxFit.contain, 
                                  errorBuilder: (context, error, stackTrace) {
                                    debugPrint('Logo asset load error: $error');
                                    return const Center(
                                      child: Icon(
                                        Icons.airplanemode_active,
                                        color: AppTheme.brandGreen,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          Text(
                            "Employee Portal",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            "Welcome back! Sign in to continue.",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.grey,
                                ),
                          ),

                          const SizedBox(height: 30),

                          Container(
                            padding:
                                const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: AppTheme.brandGreen
                                  .withOpacity(.08),
                              borderRadius:
                                  BorderRadius.circular(18),
                              border: Border.all(
                                color: AppTheme.brandGreen
                                    .withOpacity(.15),
                              ),
                            ),
                            child: const Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [

                                Row(
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: AppTheme.brandGreen,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "Demo Account",
                                      style: TextStyle(
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 12),

                                Text("Username : demo"),
                                Text("Password : demo123"),

                                SizedBox(height: 8),

                                Text(
                                  "Running in offline demo mode until the backend is available.",
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 18),

                          OutlinedButton.icon(
                            onPressed:
                                _fillDemoCredentials,
                            icon: const Icon(
                              Icons.auto_fix_high_rounded,
                            ),
                            label: const Text(
                              "Use Demo Credentials",
                            ),
                          ),

                          const SizedBox(height: 28),

                          TextFormField(
                            controller:
                                _identityController,
                            decoration:
                                const InputDecoration(
                              labelText:
                                  "Username or Email",
                              prefixIcon: Icon(
                                Icons.person_outline,
                              ),
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty) {
                                return "Field required.";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),
                                                    TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: "Password",
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword =
                                        !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty) {
                                return "Field required.";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 32),

                          auth.isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: AppTheme.brandGreen,
                                  ),
                                )
                              : SizedBox(
                                  height: 56,
                                  child: ElevatedButton.icon(
                                    onPressed: () =>
                                        _handleLogin(auth),
                                    icon: const Icon(
                                      Icons.login_rounded,
                                    ),
                                    label: const Text(
                                      "Sign In",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),

                          const SizedBox(height: 24),

                          Center(
                            child: Text(
                              "Employee Website Access System",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.grey,
                                  ),
                            ),
                          ),

                          const SizedBox(height: 8),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}