import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey        = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final authService     = AuthService();
  bool    isLoading = false;
  bool    emailSent = false;
  String? _errorMsg;

  @override
  void dispose() { emailController.dispose(); super.dispose(); }

  // ✅ Uses YOUR exact method: authService.resetPassword(email)
  Future<void> resetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() { isLoading = true; _errorMsg = null; });
    try {
      await authService.resetPassword(emailController.text.trim());
      if (!mounted) return;
      setState(() => emailSent = true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _errorMsg = 'Could not find an account with this email.');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F8),
      body: SafeArea(
        child: Column(
          children: [
            // Pink header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                  colors: [Color(0xFFE45D9E), Color(0xFFFF85B3)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text('Reset Password',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 5),
                  const Text("We'll send a reset link to your email",
                      style: TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),
            Expanded(child: emailSent ? _buildSuccessState() : _buildFormState()),
          ],
        ),
      ),
    );
  }

  Widget _buildFormState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 36, 24, 24),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Lock icon
            Container(
              width: 90, height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFFFBEAF0), shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE45D9E).withOpacity(0.3), width: 2),
              ),
              child: const Icon(Icons.lock_reset_rounded, size: 48, color: Color(0xFFE45D9E)),
            ),
            const SizedBox(height: 24),
            const Text('Forgot your password?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2C2C2A))),
            const SizedBox(height: 10),
            const Text(
              'Enter the email address linked to your account\nand we\'ll send a reset link.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 32),

            // Email field
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              onChanged: (_) { if (_errorMsg != null) setState(() => _errorMsg = null); },
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Please enter your email';
                if (!v.contains('@') || !v.contains('.')) return 'Enter a valid email address';
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Email address',
                hintText: 'student@utm.my',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFFE45D9E), size: 20),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFEDE0E7))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFEDE0E7))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE45D9E), width: 1.5)),
                errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Colors.red)),
                focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Colors.red, width: 1.5)),
              ),
            ),

            // Error box
            if (_errorMsg != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50, borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red.shade400, size: 18),
                    const SizedBox(width: 8),
                    Expanded(child: Text(_errorMsg!,
                        style: TextStyle(color: Colors.red.shade600, fontSize: 13))),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 28),

            // Send Reset Link button
            SizedBox(
              width: double.infinity, height: 54,
              child: ElevatedButton(
                onPressed: isLoading ? null : resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE45D9E),
                  disabledBackgroundColor: const Color(0xFFE45D9E).withOpacity(0.6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                ),
                child: isLoading
                    ? const SizedBox(width: 24, height: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                    : const Text('Send Reset Link',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Text('Back to Login',
                  style: TextStyle(color: Color(0xFFE45D9E), fontWeight: FontWeight.w600, fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
      child: Column(
        children: [
          // Green check
          Container(
            width: 100, height: 100,
            decoration: BoxDecoration(
              color: Colors.green.shade50, shape: BoxShape.circle,
              border: Border.all(color: Colors.green.shade300, width: 2),
            ),
            child: Icon(Icons.mark_email_read_rounded, size: 54, color: Colors.green.shade500),
          ),
          const SizedBox(height: 28),
          const Text('Check your email!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2C2C2A))),
          const SizedBox(height: 12),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(color: Colors.grey, fontSize: 14, height: 1.6),
              children: [
                const TextSpan(text: 'We sent a reset link to\n'),
                TextSpan(
                  text: emailController.text.trim(),
                  style: const TextStyle(color: Color(0xFFE45D9E), fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Check your inbox and spam folder,\nthen follow the link to reset your password.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity, height: 54,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
              label: const Text('Back to Login',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE45D9E),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 2,
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => setState(() { emailSent = false; _errorMsg = null; }),
            child: const Text("Didn't receive it? Try again",
                style: TextStyle(color: Color(0xFFE45D9E), fontWeight: FontWeight.w600, fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
