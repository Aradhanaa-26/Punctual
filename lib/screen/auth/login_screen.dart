import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../widgets/app_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController =
      TextEditingController();

  final _passwordController =
      TextEditingController();

  final AuthService _authService = AuthService();

  UserRole _selectedRole = UserRole.student;

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 460,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    _buildLogo(),

                    const SizedBox(height: 42),

                    Text(
                      'Welcome to Punctual',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium,
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Track attendance clearly. Stay on track.',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium,
                    ),

                    const SizedBox(height: 32),

                    _buildRoleSelector(),

                    const SizedBox(height: 24),

                    Text(
                      'Username',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium,
                    ),

                    const SizedBox(height: 8),

                    TextFormField(
                      controller:
                          _usernameController,
                      decoration:
                          const InputDecoration(
                        hintText:
                            'Enter your username',
                        prefixIcon: Icon(
                          Icons.person_outline_rounded,
                        ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty) {
                          return 'Enter your username';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 18),

                    Text(
                      'Password',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium,
                    ),

                    const SizedBox(height: 8),

                    TextFormField(
                      controller:
                          _passwordController,
                      obscureText:
                          _obscurePassword,
                      decoration:
                          InputDecoration(
                        hintText:
                            'Enter your password',
                        prefixIcon: const Icon(
                          Icons.lock_outline_rounded,
                        ),
                        suffixIcon:
                            IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword =
                                  !_obscurePassword;
                            });
                          },
                          icon: Icon(
                            _obscurePassword
                                ? Icons
                                    .visibility_outlined
                                : Icons
                                    .visibility_off_outlined,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty) {
                          return 'Enter your password';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 28),

                    AppButton(
                      label: _isLoading
                          ? 'Signing in...'
                          : 'Sign In',
                      icon: Icons.login_rounded,
                      onPressed: _isLoading
                          ? null
                          : _login,
                    ),

                    const SizedBox(height: 18),

                    Center(
                      child: Text(
                        'Punctual Attendance Tracker',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall,
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

  Widget _buildLogo() {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: PunctualColors.deepAccent,
            borderRadius:
                BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.access_time_rounded,
            color: PunctualColors.softHighlight,
            size: 28,
          ),
        ),
        const SizedBox(width: 14),
        Text(
          'Punctual',
          style: Theme.of(context)
              .textTheme
              .headlineMedium,
        ),
      ],
    );
  }

  Widget _buildRoleSelector() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: PunctualColors.card,
        borderRadius:
            BorderRadius.circular(15),
        border: Border.all(
          color: PunctualColors.border,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _RoleButton(
              label: 'Student',
              icon:
                  Icons.school_outlined,
              selected:
                  _selectedRole ==
                      UserRole.student,
              onTap: () {
                setState(() {
                  _selectedRole =
                      UserRole.student;
                });
              },
            ),
          ),
          Expanded(
            child: _RoleButton(
              label: 'Admin',
              icon:
                  Icons.admin_panel_settings_outlined,
              selected:
                  _selectedRole ==
                      UserRole.admin,
              onTap: () {
                setState(() {
                  _selectedRole =
                      UserRole.admin;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  void _login() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final user = _authService.login(
      username:
          _usernameController.text.trim(),
      password:
          _passwordController.text,
      role: _selectedRole,
    );

    setState(() {
      _isLoading = false;
    });

    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter valid login details.',
          ),
        ),
      );
      return;
    }

    if (!mounted) {
      return;
    }

    if (user.role == UserRole.admin) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.adminDashboard,
        (route) => false,
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.studentDashboard,
        (route) => false,
      );
    }
  }
}

class _RoleButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _RoleButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(11),
      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color: selected
              ? PunctualColors.deepAccent
              : Colors.transparent,
          borderRadius:
              BorderRadius.circular(11),
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 19,
              color: selected
                  ? PunctualColors.softHighlight
                  : PunctualColors.mutedText,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: selected
                    ? PunctualColors.primaryText
                    : PunctualColors.secondaryText,
                fontWeight: selected
                    ? FontWeight.w600
                    : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}