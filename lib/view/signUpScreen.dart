import 'package:flutter/material.dart';
import 'package:farah/services/api_service.dart';
import 'package:farah/view/ProviderProfileSetupScreen.dart';
import 'package:farah/view/homeScreen.dart';
import 'loginScreen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  static const Color cream = Color(0xFFF3EDE2);
  static const Color navy = Color(0xFF1B2A4A);
  static const Color gold = Color(0xFFD4AF37);
  static const Color softBorder = Color(0xFFE6E0D5);

  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  final TextEditingController serviceNameController = TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController licensedOperatorController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isCreatingAccount = false;

  String? _accountType;
  String? _serviceType;
  String? _location;

  final List<String> _serviceTypes = [
    'قاعات الأفراح',
    'صالونات التجميل',
    'التزيين والديكور',
    'تأجير السيارات',
    'قاعات الفنادق',
  ];

  final List<String> _locations = [
    'رام الله',
    'نابلس',
    'القدس',
    'بيت لحم',
    'الخليل',
  ];

  static const Map<String, String> _serviceCodes = {
    'قاعات الأفراح': 'wedding_hall',
    'صالونات التجميل': 'beauty_salon',
    'التزيين والديكور': 'decor',
    'تأجير السيارات': 'car_rental',
    'قاعات الفنادق': 'hotel_hall',
  };

  static const Map<String, String> _locationCodes = {
    'رام الله': 'ramallah',
    'نابلس': 'nablus',
    'القدس': 'jerusalem',
    'بيت لحم': 'bethlehem',
    'الخليل': 'hebron',
  };

  @override
  void dispose() {
    _scrollController.dispose();
    serviceNameController.dispose();
    ownerNameController.dispose();
    phoneController.dispose();
    licensedOperatorController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  bool get isProviderSelected => _accountType == 'provider';
  bool get isUserSelected => _accountType == 'user';

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
              Icons.arrow_back_ios_new_rounded,
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: navy.withOpacity(0.08),
                      blurRadius: 28,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  radius: const Radius.circular(10),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 36,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 68,
                              height: 68,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: cream,
                                border: Border.all(color: gold, width: 1.5),
                              ),
                              child: const Text(
                                'FZ',
                                style: TextStyle(
                                  color: navy,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'LibertinusMath',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Center(
                            child: Text(
                              'إنشاء حساب',
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
                              'انضم إلى فرح زون وابدأ رحلتك معنا',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: navy.withOpacity(0.58),
                                fontSize: 13,
                                height: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          _sectionTitle('اختر نوع حسابك'),
                          const SizedBox(height: 6),
                          Text(
                            'اختر الطريقة التي ستستخدم بها فرح زون',
                            style: TextStyle(
                              color: navy.withOpacity(0.55),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _accountTypeCard(
                                  type: 'user',
                                  icon: Icons.person_rounded,
                                  title: 'مستخدم',
                                  subtitle: 'أبحث عن خدمات ومزودين لمناسبتي',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _accountTypeCard(
                                  type: 'provider',
                                  icon: Icons.storefront_rounded,
                                  title: 'مزود خدمة',
                                  subtitle: 'أقدم خدماتي وأعرضها للعملاء',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          if (_accountType != null)
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 350),
                              reverseDuration:
                                  const Duration(milliseconds: 220),
                              switchInCurve: Curves.easeOutCubic,
                              switchOutCurve: Curves.easeInCubic,
                              transitionBuilder: (child, animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0, 0.04),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  ),
                                );
                              },
                              child: _accountFields(),
                            ),
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

  Widget _accountFields() {
    if (isProviderSelected) return _providerFields();
    return _userFields();
  }

  Widget _providerFields() {
    return Column(
      key: const ValueKey('providerFields'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('معلومات الخدمة'),
        const SizedBox(height: 18),
        _fieldLabel('نوع الخدمة'),
        const SizedBox(height: 8),
        _serviceSelector(),
        const SizedBox(height: 18),
        _fieldLabel('اسم الخدمة'),
        const SizedBox(height: 8),
        TextFormField(
          controller: serviceNameController,
          style: const TextStyle(color: navy, fontSize: 13),
          decoration: _inputDecoration(
            hint: 'ادخل اسم الخدمة',
            icon: Icons.business_rounded,
          ),
          validator: (value) {
            if (isProviderSelected &&
                (value == null || value.trim().isEmpty)) {
              return 'يرجى إدخال اسم الخدمة';
            }
            return null;
          },
        ),
        const SizedBox(height: 18),
        _fieldLabel('الموقع'),
        const SizedBox(height: 8),
        _locationSelector(),
        const SizedBox(height: 28),
        _sectionDivider(),
        const SizedBox(height: 26),
        _sectionTitle('معلومات مزود الخدمة'),
        const SizedBox(height: 18),
        _fieldLabel('اسم مزود الخدمة'),
        const SizedBox(height: 8),
        TextFormField(
          controller: ownerNameController,
          style: const TextStyle(color: navy, fontSize: 13),
          decoration: _inputDecoration(
            hint: 'أدخل الاسم',
            icon: Icons.person_rounded,
          ),
          validator: (value) {
            if (isProviderSelected &&
                (value == null || value.trim().isEmpty)) {
              return 'يرجى إدخال اسم مزود الخدمة';
            }
            return null;
          },
        ),
        const SizedBox(height: 18),
        _fieldLabel('رقم الهاتف'),
        const SizedBox(height: 8),
        TextFormField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          style: const TextStyle(color: navy, fontSize: 13),
          decoration: _inputDecoration(
            hint: 'أدخل رقم الهاتف',
            icon: Icons.phone_rounded,
          ),
          validator: (value) {
            if (isProviderSelected &&
                (value == null || value.trim().isEmpty)) {
              return 'يرجى إدخال رقم الهاتف';
            }
            if (isProviderSelected &&
                value != null &&
                value.trim().length < 9) {
              return 'يرجى إدخال رقم هاتف صحيح';
            }
            return null;
          },
        ),
        const SizedBox(height: 18),
        _fieldLabel('رقم الهوية / رقم المشتغّل المرخص'),
        const SizedBox(height: 8),
        TextFormField(
          controller: licensedOperatorController,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: navy, fontSize: 13),
          decoration: _inputDecoration(
            hint: 'أدخل رقم الهوية أو رقم المشتغّل المرخص',
            icon: Icons.badge_rounded,
          ),
          validator: (value) {
            if (isProviderSelected &&
                (value == null || value.trim().isEmpty)) {
              return 'يرجى إدخال رقم الهوية أو رقم المشتغّل المرخص';
            }
            return null;
          },
        ),
        const SizedBox(height: 28),
        _loginInformationFields(),
      ],
    );
  }

  Widget _userFields() {
    return Column(
      key: const ValueKey('userFields'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('معلوماتك الشخصية'),
        const SizedBox(height: 18),
        _fieldLabel('الاسم الكامل'),
        const SizedBox(height: 8),
        TextFormField(
          controller: ownerNameController,
          style: const TextStyle(color: navy, fontSize: 13),
          decoration: _inputDecoration(
            hint: 'أدخل اسمك الكامل',
            icon: Icons.person_rounded,
          ),
          validator: (value) {
            if (isUserSelected && (value == null || value.trim().isEmpty)) {
              return 'يرجى إدخال الاسم الكامل';
            }
            return null;
          },
        ),
        const SizedBox(height: 18),
        _loginInformationFields(),
      ],
    );
  }

  Widget _loginInformationFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('البريد الإلكتروني'),
        const SizedBox(height: 8),
        TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(color: navy, fontSize: 13),
          decoration: _inputDecoration(
            hint: 'أدخل بريدك الإلكتروني',
            icon: Icons.email_rounded,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'يرجى إدخال البريد الإلكتروني';
            }
            final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
            if (!emailRegex.hasMatch(value.trim())) {
              return 'يرجى إدخال بريد إلكتروني صحيح';
            }
            return null;
          },
        ),
        const SizedBox(height: 18),
        _fieldLabel('كلمة المرور'),
        const SizedBox(height: 8),
        TextFormField(
          controller: passwordController,
          obscureText: _obscurePassword,
          style: const TextStyle(color: navy, fontSize: 13),
          decoration: _inputDecoration(
            hint: 'أنشئ كلمة مرور',
            icon: Icons.lock_rounded,
          ).copyWith(
            suffixIcon: IconButton(
              onPressed: () {
                setState(() => _obscurePassword = !_obscurePassword);
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
              return 'يرجى إنشاء كلمة مرور';
            }
            if (value.length < 6) {
              return 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';
            }
            return null;
          },
        ),
        const SizedBox(height: 18),
        _fieldLabel('تأكيد كلمة المرور'),
        const SizedBox(height: 8),
        TextFormField(
          controller: confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          style: const TextStyle(color: navy, fontSize: 13),
          decoration: _inputDecoration(
            hint: 'أعد إدخال كلمة المرور',
            icon: Icons.lock_reset_rounded,
          ).copyWith(
            suffixIcon: IconButton(
              onPressed: () {
                setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword,
                );
              },
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: navy.withOpacity(0.55),
                size: 20,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'يرجى تأكيد كلمة المرور';
            }
            if (value != passwordController.text) {
              return 'كلمتا المرور غير متطابقتين';
            }
            return null;
          },
        ),
        const SizedBox(height: 30),
        _createAccountButton(),
        const SizedBox(height: 24),
        Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              Text(
                'لديك حساب بالفعل؟ ',
                style: TextStyle(
                  color: navy.withOpacity(0.6),
                  fontSize: 13,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text(
                  'تسجيل الدخول',
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
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _createAccountButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _isCreatingAccount ? null : _createAccount,
        style: ElevatedButton.styleFrom(
          backgroundColor: navy,
          foregroundColor: Colors.white,
          disabledBackgroundColor: navy.withOpacity(0.55),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: _isCreatingAccount
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: gold,
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'إنشاء الحساب',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_back_rounded, size: 18, color: gold),
                ],
              ),
      ),
    );
  }

  Future<void> _createAccount() async {
    if (_isCreatingAccount) return;

    if (_accountType == null) {
      _showMessage('يرجى اختيار نوع الحساب أولاً');
      return;
    }

    if (isProviderSelected && _serviceType == null) {
      _showMessage('يرجى اختيار نوع الخدمة');
      return;
    }

    if (isProviderSelected && _location == null) {
      _showMessage('يرجى اختيار موقع الخدمة');
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() => _isCreatingAccount = true);

    try {
      await ApiService.register({
        'role': isProviderSelected ? 'Provider' : 'User',
        'fullName': ownerNameController.text.trim(),
        'email': emailController.text.trim(),
        'password': passwordController.text,
        if (isProviderSelected) ...{
          'serviceName': serviceNameController.text.trim(),
          'serviceType': _serviceCodes[_serviceType],
          'location': _locationCodes[_location],
          'phone': phoneController.text.trim(),
          'licenseNumber': licensedOperatorController.text.trim(),
        },
      });

      if (!mounted) return;
      _showMessage('تم إنشاء الحساب بنجاح!');

      if (isProviderSelected) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProviderProfileSetupScreen(
              providerName: ownerNameController.text.trim(),
              providerPhone: phoneController.text.trim(),
              providerEmail: emailController.text.trim(),
              licensedOperatorNumber: licensedOperatorController.text.trim(),
              serviceType: _serviceType!,
              initialLocation: _location!,
              initialServiceName: serviceNameController.text.trim(),
            ),
          ),
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      }
    } on ApiException catch (e) {
      if (mounted) _showMessage(e.message);
    } catch (_) {
      if (mounted) {
        _showMessage('تعذر الاتصال بالسيرفر. تأكدي من تشغيل الباك إند.');
      }
    } finally {
      if (mounted) setState(() => _isCreatingAccount = false);
    }
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

  Widget _sectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 21,
          decoration: BoxDecoration(
            color: gold,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const SizedBox(width: 9),
        Text(
          title,
          style: const TextStyle(
            color: navy,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _fieldLabel(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: navy,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _accountTypeCard({
    required String type,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final bool selected = _accountType == type;

    return GestureDetector(
      onTap: () {
        if (_accountType == type) return;

        setState(() {
          _accountType = type;

          if (type == 'user') {
            serviceNameController.clear();
            phoneController.clear();
            licensedOperatorController.clear();
            _serviceType = null;
            _location = null;
          } else {
            ownerNameController.clear();
          }

          _formKey.currentState?.reset();
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOut,
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 178),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFFBF2) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? gold : softBorder,
            width: selected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: navy.withOpacity(selected ? 0.08 : 0.025),
              blurRadius: selected ? 16 : 8,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 260),
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: selected ? navy : cream,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    color: selected ? gold : navy,
                    size: 25,
                  ),
                ),
                if (selected)
                  Positioned(
                    top: -5,
                    right: -5,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: gold,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: navy,
                        size: 13,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: navy,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: navy.withOpacity(0.52),
                fontSize: 10.5,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _selectorField({
    required IconData icon,
    required String? value,
    required String placeholder,
    required VoidCallback onTap,
  }) {
    final bool selected = value != null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color:
              selected ? const Color(0xFFFFFBF2) : cream.withOpacity(0.55),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? gold : navy.withOpacity(0.10),
            width: selected ? 1.3 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: selected ? gold.withOpacity(0.15) : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: navy, size: 19),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                value ?? placeholder,
                style: TextStyle(
                  color: selected ? navy : navy.withOpacity(0.38),
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: navy.withOpacity(0.55),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _serviceSelector() {
    return _selectorField(
      icon: Icons.auto_awesome_rounded,
      value: _serviceType,
      placeholder: 'اختر نوع الخدمة',
      onTap: _showServiceTypeSelector,
    );
  }

  Widget _locationSelector() {
    return _selectorField(
      icon: Icons.location_on_rounded,
      value: _location,
      placeholder: 'اختر موقع الخدمة',
      onTap: _showLocationSelector,
    );
  }

  void _showServiceTypeSelector() {
    _showOptionsSheet(
      title: 'اختر نوع الخدمة',
      subtitle: 'حدد الخدمة التي يقدمها نشاطك',
      options: _serviceTypes,
      selectedValue: _serviceType,
      iconFor: _serviceIcon,
      onSelected: (value) => setState(() => _serviceType = value),
    );
  }

  void _showLocationSelector() {
    _showOptionsSheet(
      title: 'اختر موقع الخدمة',
      subtitle: 'حدد المدينة التي تتواجد فيها خدمتك',
      options: _locations,
      selectedValue: _location,
      iconFor: (_) => Icons.location_on_rounded,
      onSelected: (value) => setState(() => _location = value),
    );
  }

  void _showOptionsSheet({
    required String title,
    required String subtitle,
    required List<String> options,
    required String? selectedValue,
    required IconData Function(String) iconFor,
    required ValueChanged<String> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            decoration: const BoxDecoration(
              color: cream,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _bottomSheetHandle(),
                    const SizedBox(height: 18),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: navy,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          color: navy.withOpacity(0.55),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    ...options.map((option) {
                      final bool selected = selectedValue == option;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 9),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            onSelected(option);
                            Navigator.pop(sheetContext);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: selected ? navy : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: selected
                                    ? gold
                                    : navy.withOpacity(0.07),
                                width: selected ? 1.2 : 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: navy.withOpacity(0.025),
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? Colors.white.withOpacity(0.10)
                                        : cream,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    iconFor(option),
                                    color: selected ? gold : navy,
                                    size: 21,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    option,
                                    style: TextStyle(
                                      color: selected ? Colors.white : navy,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                if (selected)
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    color: gold,
                                    size: 21,
                                  )
                                else
                                  Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    color: navy.withOpacity(0.25),
                                    size: 13,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _serviceIcon(String service) {
    switch (service) {
      case 'قاعات الأفراح':
        return Icons.celebration_rounded;
      case 'صالونات التجميل':
        return Icons.face_retouching_natural_rounded;
      case 'التزيين والديكور':
        return Icons.auto_awesome_rounded;
      case 'تأجير السيارات':
        return Icons.directions_car_rounded;
      case 'قاعات الفنادق':
        return Icons.hotel_rounded;
      default:
        return Icons.design_services_rounded;
    }
  }

  Widget _bottomSheetHandle() {
    return Center(
      child: Container(
        width: 45,
        height: 4,
        decoration: BoxDecoration(
          color: navy.withOpacity(0.18),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _sectionDivider() {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: softBorder)),
        const SizedBox(width: 10),
        Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: gold,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: Container(height: 1, color: softBorder)),
      ],
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
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: navy.withOpacity(0.10)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: navy.withOpacity(0.10)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: gold, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }
}