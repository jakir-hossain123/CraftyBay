import 'package:crafty_bay/core/app_colors.dart';
import 'package:crafty_bay/core/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/app_assets.dart';
import '../../complete_profile/view/complete_profile_page.dart';
import '../../auth_redirect.dart';
import '../../viewmodel/auth_provider.dart';
import '../widget/otp_imput_field.dart';
import '../widget/otp_resend_timer.dart';

class OtpVerificationPage extends StatefulWidget {
  final String email;
  final String password;

  const OtpVerificationPage({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  String _code = '';

  Future<void> _onNext() async {
    if (_code.length < 4) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(AppStrings.otpIncomplete)));
      return;
    }
    final provider = context.read<AuthProvider>();
    final success = await provider.verifyOtp(
      email: widget.email,
      otp: _code,
      password: widget.password,
    );
    if (!mounted) return;
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'OTP verification failed.'),
        ),
      );
      return;
    }
    AuthRedirect.reset();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const CompleteProfilePage()),
    );
  }

  Future<void> _onResend() async {
    final provider = context.read<AuthProvider>();
    final success = await provider.resendOtp(widget.email);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'A new verification code was sent.'
              : provider.errorMessage ?? 'Could not resend verification code.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 80),
              SvgPicture.asset(AppAssets.logo, width: 100),
              const SizedBox(height: 24),
              const Text(
                AppStrings.enterOtpCode,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                AppStrings.otpSentMessage,
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 4),
              Text(
                widget.email,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              OtpInputField(onChanged: (v) => _code = v),
              const SizedBox(height: 24),
              Consumer<AuthProvider>(
                builder: (context, provider, _) => ElevatedButton(
                  onPressed: provider.isLoading ? null : _onNext,
                  child: provider.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(AppStrings.next),
                ),
              ),
              const SizedBox(height: 24),
              OtpResendTimer(
                onResend: context.watch<AuthProvider>().isLoading
                    ? null
                    : _onResend,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
