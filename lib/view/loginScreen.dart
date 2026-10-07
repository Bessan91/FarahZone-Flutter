import 'package:flutter/material.dart';
import 'package:farah/services/api_service.dart';
import 'signUpScreen.dart';
import 'homeScreen.dart';
import 'package:farah/view/supplierDashboardScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const Color cream = Color(0xFFF3EDE2);
  static const Color navy = Color(0xFF1B2A4A);
  static const Color gold = Color(0xFFD4AF37);

  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: cream,
        appBar: AppBar(
          backgroundColor: cream,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: navy,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'FARAH ZONE',
            style: TextStyle(
              color: navy,
              fontSize: 18,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
              fontFamily: 'LibertinusMath',
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 35,
                  vertical: 40,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: navy.withOpacity(0.08),
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 65,
                          height: 65,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: gold, width: 1.5),
                          ),
                          child: const Text(
                            'FZ',
                            style: TextStyle(
                              color: navy,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      const Center(
                        child: Text(
                          'مرحباً بعودتك',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'LibertinusMath',
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            color: navy,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          'سجّل الدخول للمتابعة في فرح زون',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: navy.withOpacity(0.6),
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 35),
                      const Text(
                        'البريد الإلكتروني',
                        style: TextStyle(
                          color: navy,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(color: navy),
                        decoration: _inputDecoration(
                          hint: 'أدخل بريدك الإلكتروني',
                          icon: Icons.email_outlined,
                        ),
                        validator: (value) {
                          final email = value?.trim() ?? '';
                          if (email.isEmpty) {
                            return 'يرجى إدخال البريد الإلكتروني';
                          }
                          if (!email.contains('@') || !email.contains('.')) {
                            return 'يرجى إدخال بريد إلكتروني صحيح';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 22),
                      const Text(
                        'كلمة المرور',
                        style: TextStyle(
                          color: navy,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: passwordController,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        style: const TextStyle(color: navy),
                        decoration: _inputDecoration(
                          hint: 'أدخل كلمة المرور',
                          icon: Icons.lock_outline,
                        ).copyWith(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(
                                () => _obscurePassword = !_obscurePassword,
                              );
                            },
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: navy.withOpacity(0.55),
                              size: 20,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال كلمة المرور';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          if (!_isLoading) _login();
                        },
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: _isLoading ? null : _forgotPassword,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'نسيت كلمة المرور؟',
                            style: TextStyle(
                              color: navy,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: navy,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: navy.withOpacity(0.55),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: gold,
                                  ),
                                )
                              : const Text(
                                  'تسجيل الدخول',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(color: navy.withOpacity(0.12)),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'أو',
                              style: TextStyle(
                                color: navy.withOpacity(0.45),
                                fontSize: 11,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(color: navy.withOpacity(0.12)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            Text(
                              'ليس لديك حساب؟ ',
                              style: TextStyle(
                                color: navy.withOpacity(0.6),
                                fontSize: 13,
                              ),
                            ),
                            GestureDetector(
                              onTap: _isLoading
                                  ? null
                                  : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const SignupScreen(),
                                        ),
                                      );
                                    },
                              child: const Text(
                                'إنشاء حساب',
                                style: TextStyle(
                                  color: navy,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
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
          ),
        ),
      ),
    );
  }

  // =========================================================
  // LOGIN (متصلة بالباك إند عبر ApiService)
  // =========================================================

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    try {
      final data = await ApiService.login(
        emailController.text.trim(),
        passwordController.text,
      );

      if (!mounted) return;

      debugPrint('LOGIN RESPONSE: $data');

      // نوع الحساب: ممكن يرجع نص (Provider) أو رقم (1) حسب الباك إند
      final roleValue =
          '${data['role'] ?? data['Role'] ?? data['accountType'] ?? ''}'
              .trim()
              .toLowerCase();
      final roleSaysProvider = roleValue == 'provider' || roleValue == '1';

      Map<String, dynamic>? profile;

      if (roleSaysProvider) {
        // أكيد مزود → لازم نجيب بياناته (وأي خطأ بيظهر للمستخدم)
        profile = await ApiService.getMyProviderProfile();
      } else {
        // احتياط: نسأل الباك إذا عند هالحساب بروفايل مزود
        // (المستخدم العادي بيرجع له 403 ونعتبره مستخدم عادي)
        try {
          profile = await ApiService.getMyProviderProfile();
        } on ApiException {
          profile = null;
        }
      }

      if (!mounted) return;

      if (profile != null) {
        final p = profile;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SupplierDashboardScreen(
              providerName: p['providerName'] ?? '',
              providerPhone: p['providerPhone'] ?? '',
              providerEmail: p['providerEmail'] ?? '',
              businessName: p['businessName'] ?? '',
              serviceType: p['serviceType'] ?? '',
              location: p['location'] ?? '',
              address: p['address'] ?? '',
              description: p['description'] ?? '',
              halls: List<Map<String, dynamic>>.from(p['halls'] ?? []),
              licensedOperatorNumber: p['licensedOperatorNumber'] ?? '',
            ),
          ),
        );
      } else {
        // مستخدم عادي → الصفحة الرئيسية
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } on ApiException catch (e) {
      if (mounted) _showMessage(e.message);
    } catch (_) {
      if (mounted) {
        _showMessage('تعذر الاتصال بالسيرفر. تأكدي من تشغيل مشروع الـ API');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _forgotPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      _showMessage('أدخل بريدك الإلكتروني أولاً');
      return;
    }

    _showMessage('ميزة إعادة تعيين كلمة المرور ستتوفر لاحقاً');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message, textAlign: TextAlign.right),
          behavior: SnackBarBehavior.floating,
          backgroundColor: navy,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: navy.withOpacity(0.35), fontSize: 13),
      prefixIcon: Icon(icon, color: navy.withOpacity(0.55), size: 20),
      filled: true,
      fillColor: cream.withOpacity(0.55),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: navy.withOpacity(0.10)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: navy.withOpacity(0.10)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: gold, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.4),
      ),
    );
  }
}