import 'package:crafty_bay/core/app_colors.dart';
import 'package:crafty_bay/core/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../reviews/viewmodel/review_provider.dart';

class CreateReviewPage extends StatefulWidget {
  const CreateReviewPage({super.key});

  @override
  State<CreateReviewPage> createState() => _CreateReviewPageState();
}

class _CreateReviewPageState extends State<CreateReviewPage> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _reviewController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) return AppStrings.fieldRequired;
    return null;
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<ReviewProvider>().addReview(
          _firstNameController.text.trim(),
          _lastNameController.text.trim(),
          _reviewController.text.trim(),
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          AppStrings.createReview,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _firstNameController,
                  textInputAction: TextInputAction.next,
                  validator: _validateRequired,
                  decoration: const InputDecoration(
                    hintText: AppStrings.firstName,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _lastNameController,
                  textInputAction: TextInputAction.next,
                  validator: _validateRequired,
                  decoration: const InputDecoration(
                    hintText: AppStrings.lastName,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _reviewController,
                  maxLines: 7,
                  textInputAction: TextInputAction.newline,
                  validator: _validateRequired,
                  decoration: const InputDecoration(
                    hintText: AppStrings.writeReview,
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _onSubmit,
                  child: const Text(AppStrings.submit),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
