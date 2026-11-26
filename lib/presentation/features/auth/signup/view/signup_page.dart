import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/app_colors.dart';
import '../../../../../core/app_strings.dart';
import '../../auth_validators.dart';
import '../../login/widget/login_header.dart';
import '../../otp_verification/view/otp_verification_page.dart';
import '../../viewmodel/auth_provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? AppStrings.fieldRequired : null;

  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) return;
    final email = _emailController.text.trim();
    final provider = context.read<AuthProvider>();
    final success = await provider.signUp(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: email,
      password: _passwordController.text,
    );
    if (!mounted) return;
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Could not create account.'),
        ),
      );
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => OtpVerificationPage(
          email: email,
          password: _passwordController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 24),
                const LoginHeader(isRegistering: true),
                const SizedBox(height: 24),
                _field(
                  _firstNameController,
                  'First name',
                  validator: _required,
                  next: true,
                ),
                const SizedBox(height: 12),
                _field(
                  _lastNameController,
                  'Last name',
                  validator: _required,
                  next: true,
                ),
                const SizedBox(height: 12),
                _field(
                  _emailController,
                  AppStrings.emailAddress,
                  validator: AuthValidators.email,
                  keyboardType: TextInputType.emailAddress,
                  next: true,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  validator: AuthValidators.password,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: AppStrings.password,
                    suffixIcon: IconButton(
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.iconInactive,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: isLoading ? null : _createAccount,
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Create Account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String hint, {
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    bool next = false,
    TextInputAction? textInputAction,
    void Function(String)? onSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction:
          textInputAction ??
          (next ? TextInputAction.next : TextInputAction.done),
      onFieldSubmitted: onSubmitted,
      decoration: InputDecoration(hintText: hint),
    );
  }
}
