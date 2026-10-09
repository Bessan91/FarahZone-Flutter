import 'package:flutter/material.dart';
import 'package:farah/services/api_service.dart';
import 'package:farah/view/ProviderProfileSetupScreen.dart';
import 'package:farah/view/mainScreen.dart';

class SupplierDashboardScreen extends StatefulWidget {
  final String providerName;
  final String providerPhone;
  final String providerEmail;
  final String businessName;
  final String serviceType;
  final String location;
  final String address;
  final String description;
  final String licensedOperatorNumber;
  final List<Map<String, dynamic>> halls;

  const SupplierDashboardScreen({
    super.key,
    required this.providerName,
    required this.providerPhone,
    required this.providerEmail,
    required this.businessName,
    required this.serviceType,
    required this.location,
    required this.address,
    required this.description,
    required this.licensedOperatorNumber,
    required this.halls,
  });

  @override
  State<SupplierDashboardScreen> createState() =>
      _SupplierDashboardScreenState();
}

class _SupplierDashboardScreenState extends State<SupplierDashboardScreen> {
  static const Color cream = Color(0xFFF3EDE2);
  static const Color navy = Color(0xFF1B2A4A);
  static const Color gold = Color(0xFFD4AF37);
  static const Color textDark = Color(0xFF202020);
  static const Color textGrey = Color(0xFF777777);
  static const Color softBorder = Color(0xFFE6E0D5);
  static const Color green = Color(0xFF3E8E68);
  static const Color red = Color(0xFFB84C4C);

  int _selectedIndex = 0;

  DateTime _calendarMonth = DateTime.now();
  DateTime? _selectedDate;

  late String _providerName;
  late String _providerPhone;
  late String _providerEmail;
  late String _businessName;
  late String _serviceType;
  late String _location;
  late String _address;
  late String _description;
  late String _licensedOperatorNumber;
  late List<Map<String, dynamic>> _halls;

  final List<Map<String, dynamic>> _bookings = [
    {
      'customer': 'سارة أحمد',
      'phone': '0599 000 111',
      'service': 'قاعة مزايا 2',
      'date': DateTime(2026, 9, 28),
      'status': 'مؤكد',
      'price': '4000',
    },
    {
      'customer': 'محمد خالد',
      'phone': '0598 000 222',
      'service': 'حفل خطوبة',
      'date': DateTime(2026, 10, 3),
      'status': 'قيد الانتظار',
      'price': '2500',
    },
    {
      'customer': 'ليان علي',
      'phone': '0597 000 333',
      'service': 'قاعة مزايا 1',
      'date': DateTime(2026, 10, 10),
      'status': 'مؤكد',
      'price': '5000',
    },
    {
      'customer': 'نور محمد',
      'phone': '0596 000 444',
      'service': 'قاعة الزفاف',
      'date': DateTime(2026, 10, 10),
      'status': 'مؤكد',
      'price': '3500',
    },
  ];

  final List<Map<String, dynamic>> _customers = [
    {
      'name': 'سارة أحمد',
      'phone': '0599 000 111',
      'bookings': 3,
    },
    {
      'name': 'محمد خالد',
      'phone': '0598 000 222',
      'bookings': 2,
    },
    {
      'name': 'ليان علي',
      'phone': '0597 000 333',
      'bookings': 1,
    },
  ];

  @override
  void initState() {
    super.initState();

    _providerName = widget.providerName;
    _providerPhone = widget.providerPhone;
    _providerEmail = widget.providerEmail;
    _businessName = widget.businessName;
    _serviceType = widget.serviceType;
    _location = widget.location;
    _address = widget.address;
    _description = widget.description;
    _licensedOperatorNumber = widget.licensedOperatorNumber;
    _halls = _deepCopyHalls(widget.halls);

    _calendarMonth = DateTime.now();
    _selectedDate = DateTime.now();
  }

  // ============================================================
  // DATA
  // ============================================================

  List<Map<String, dynamic>> _deepCopyHalls(
    List<Map<String, dynamic>> source,
  ) {
    return source.map((hall) {
      return {
        ...hall,
        'pricing': (hall['pricing'] as List? ?? []).map((item) {
          if (item is Map) {
            return Map<String, dynamic>.from(item);
          }
          return <String, dynamic>{};
        }).toList(),
        'includedItems': List<String>.from(
          hall['includedItems'] as List? ?? [],
        ),
        'hospitality': (hall['hospitality'] as List? ?? []).map((item) {
          if (item is Map) {
            return Map<String, dynamic>.from(item);
          }
          return <String, dynamic>{};
        }).toList(),
        'services': List<String>.from(
          hall['services'] as List? ?? [],
        ),
        'occasions': (hall['occasions'] as List? ?? []).map((item) {
          if (item is Map) {
            return Map<String, dynamic>.from(item);
          }
          return {
            'name': item.toString(),
            'price': '',
          };
        }).toList(),
      };
    }).toList();
  }

  // ============================================================
  // PROFILE EDIT
  // ============================================================

 Future<void> _editProfile() async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ProviderProfileSetupScreen(
        providerName: _providerName,
        providerPhone: _providerPhone,
        providerEmail: _providerEmail,
        serviceType: _serviceType,
        initialLocation: _location,
        initialServiceName: _businessName,
        licensedOperatorNumber: _licensedOperatorNumber,
        initialAddress: _address,
        initialDescription: _description,
        initialHalls: _halls,
        isEditing: true,
      ),
    ),
  );

  // إذا خرج المستخدم بزر الرجوع بدون حفظ، لن تتغير البيانات
  if (result == null || !mounted) return;

  // إذا حُفظت التعديلات، يتم تحديث الواجهة بالبيانات الجديدة المرجعة
  if (result is Map<String, dynamic>) {
    setState(() {
      _providerName = result['providerName']?.toString() ?? _providerName;
      _providerPhone = result['providerPhone']?.toString() ?? _providerPhone;
      _providerEmail = result['providerEmail']?.toString() ?? _providerEmail;
      _businessName = result['businessName']?.toString() ?? _businessName;
      _serviceType = result['serviceType']?.toString() ?? _serviceType;
      _location = result['location']?.toString() ?? _location;
      _address = result['address']?.toString() ?? _address;
      _description = result['description']?.toString() ?? _description;
      _licensedOperatorNumber = result['licensedOperatorNumber']?.toString() ?? _licensedOperatorNumber;

      if (result['halls'] is List) {
        _halls = _deepCopyHalls(
          List<Map<String, dynamic>>.from(
            (result['halls'] as List).map((hall) => Map<String, dynamic>.from(hall)),
          ),
        );
      }
    });
  }
}
  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: cream,
        appBar: _buildAppBar(),
        drawer: _buildDrawer(),
        body: SafeArea(
          child: _buildCurrentPage(),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  // ============================================================
  // APP BAR
  // ============================================================

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: cream,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      automaticallyImplyLeading: false,
      titleSpacing: 18,
      title: Row(
        children: [
          Builder(
            builder: (context) {
              return GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: navy,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.menu_rounded,
                    color: Colors.white,
                    size: 21,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 11),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _pageTitle(),
                style: const TextStyle(
                  color: navy,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'LibertinusMath',
                ),
              ),
              Text(
                'فرح زون',
                style: TextStyle(
                  color: textGrey.withOpacity(.8),
                  fontSize: 10,
                  fontFamily: 'LibertinusMath',
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(left: 14),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = 4;
              });
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: softBorder,
                ),
              ),
              child: const Icon(
                Icons.person_outline_rounded,
                color: navy,
                size: 21,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _pageTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'لوحة التحكم';
      case 1:
        return 'خدماتك';
      case 2:
        return 'الحجوزات';
      case 3:
        return 'العملاء';
      case 4:
        return 'حسابي';
      default:
        return 'لوحة التحكم';
    }
  }

  Widget _buildCurrentPage() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomePage();
      case 1:
        return _buildServicesPage();
      case 2:
        return _buildBookingsPage();
      case 3:
        return _buildCustomersPage();
      case 4:
        return _buildProfilePage();
      default:
        return _buildHomePage();
    }
  }

  // ============================================================
  // HOME
  // ============================================================

  Widget _buildHomePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildWelcomeHeader(),
          const SizedBox(height: 18),
          _buildStatistics(),
          const SizedBox(height: 22),
          _buildDashboardCalendar(),
          const SizedBox(height: 22),
          _buildSectionTitle(
            'آخر الحجوزات',
            'عرض الكل',
            () {
              setState(() {
                _selectedIndex = 2;
              });
            },
          ),
          const SizedBox(height: 10),
          ..._bookings.take(3).map((booking) => _buildBookingCard(booking)),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text(
                      'مرحباً',
                      style: TextStyle(
                        color: navy,
                        fontSize: 12,
                        fontFamily: 'LibertinusMath',
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      '✦',
                      style: TextStyle(
                        color: gold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _providerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                    fontFamily: 'LibertinusMath',
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        _businessName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: gold,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'LibertinusMath',
                        ),
                      ),
                    ),
                    const SizedBox(width: 9),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: textGrey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 9),
                    const Icon(
                      Icons.location_on_outlined,
                      color: textGrey,
                      size: 13,
                    ),
                    const SizedBox(width: 3),
                    Flexible(
                      child: Text(
                        _location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: textGrey,
                          fontSize: 10,
                          fontFamily: 'LibertinusMath',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics() {
    return Row(
      children: [
        Expanded(
          child: _compactStat(
            icon: Icons.event_available_rounded,
            title: 'الحجوزات',
            value: '${_bookings.length}',
            color: navy,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: _compactStat(
            icon: Icons.people_alt_outlined,
            title: 'العملاء',
            value: '${_customers.length}',
            color: gold,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: _compactStat(
            icon: Icons.home_work_outlined,
            title: 'الخدمات',
            value: '${_halls.length}',
            color: green,
          ),
        ),
      ],
    );
  }

  Widget _compactStat({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: softBorder),
      ),
      child: Column(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withOpacity(.09),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 7),
          Text(
            value,
            style: const TextStyle(
              color: navy,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            title,
            style: const TextStyle(
              color: textGrey,
              fontSize: 9,
              fontFamily: 'LibertinusMath',
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CALENDAR
  // ============================================================

  Widget _buildDashboardCalendar() {
    final monthName = _arabicMonth(_calendarMonth.month);

    return Container(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: softBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.035),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 39,
                height: 39,
                decoration: BoxDecoration(
                  color: navy.withOpacity(.07),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: navy,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الحجوزات',
                      style: TextStyle(
                        color: navy,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'LibertinusMath',
                      ),
                    ),
                    Text(
                      'اضغط على أي تاريخ لإدارة الحجوزات',
                      style: TextStyle(
                        color: textGrey,
                        fontSize: 9,
                        fontFamily: 'LibertinusMath',
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: _goToToday,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: gold.withOpacity(.12),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Text(
                    'اليوم',
                    style: TextStyle(
                      color: navy,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'LibertinusMath',
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _calendarArrow(
                icon: Icons.chevron_right_rounded,
                onTap: _previousMonth,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    '$monthName ${_calendarMonth.year}',
                    style: const TextStyle(
                      color: navy,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'LibertinusMath',
                    ),
                  ),
                ),
              ),
              _calendarArrow(
                icon: Icons.chevron_left_rounded,
                onTap: _nextMonth,
              ),
            ],
          ),
          const SizedBox(height: 13),
          _buildWeekDays(),
          const SizedBox(height: 7),
          _buildCalendarGrid(),
          const SizedBox(height: 11),
          _buildCalendarLegend(),
          if (_selectedDate != null) ...[
            const SizedBox(height: 13),
            _buildSelectedDateBookings(),
          ],
        ],
      ),
    );
  }

  Widget _calendarArrow({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: cream,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: navy, size: 19),
      ),
    );
  }

  Widget _buildWeekDays() {
    const days = ['أحد', 'اثنين', 'ثلاثاء', 'أربعاء', 'خميس', 'جمعة', 'سبت'];

    return Row(
      children: days.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: const TextStyle(
                color: textGrey,
                fontSize: 9,
                fontWeight: FontWeight.w600,
                fontFamily: 'LibertinusMath',
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDay = DateTime(_calendarMonth.year, _calendarMonth.month, 1);
    final daysInMonth =
        DateTime(_calendarMonth.year, _calendarMonth.month + 1, 0).day;
    final startOffset = firstDay.weekday % 7;
    final totalCells = ((startOffset + daysInMonth) / 7).ceil() * 7;

    return Column(
      children: List.generate(totalCells ~/ 7, (weekIndex) {
        return Row(
          children: List.generate(7, (dayIndex) {
            final cellIndex = weekIndex * 7 + dayIndex;
            final dayNumber = cellIndex - startOffset + 1;

            if (dayNumber < 1 || dayNumber > daysInMonth) {
              return const Expanded(child: SizedBox(height: 38));
            }

            final date = DateTime(
              _calendarMonth.year,
              _calendarMonth.month,
              dayNumber,
            );

            return Expanded(child: _buildCalendarDay(date));
          }),
        );
      }),
    );
  }

  Widget _buildCalendarDay(DateTime date) {
    final selected = _isSameDay(date, _selectedDate);
    final today = _isSameDay(date, DateTime.now());
    final bookings = _bookingsForDate(date);
    final hasBooking = bookings.isNotEmpty;
    final hasPending =
        bookings.any((booking) => booking['status'] == 'قيد الانتظار');

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDate = date;
        });
      },
      child: SizedBox(
        height: 38,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: selected
                    ? navy
                    : today
                        ? gold.withOpacity(.15)
                        : Colors.transparent,
                shape: BoxShape.circle,
                border: today && !selected
                    ? Border.all(color: gold, width: 1.2)
                    : null,
              ),
              child: Center(
                child: Text(
                  '${date.day}',
                  style: TextStyle(
                    color: selected
                        ? Colors.white
                        : today
                            ? navy
                            : textDark,
                    fontSize: 11,
                    fontWeight:
                        selected || today ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
            ),
            if (hasBooking)
              Positioned(
                bottom: 0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: hasPending ? gold : green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    if (bookings.length > 1) ...[
                      const SizedBox(width: 2),
                      Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          color: navy,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendDot(green, 'حجز مؤكد'),
        const SizedBox(width: 16),
        _legendDot(gold, 'قيد الانتظار'),
      ],
    );
  }

  Widget _legendDot(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            color: textGrey,
            fontSize: 9,
            fontFamily: 'LibertinusMath',
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedDateBookings() {
    final bookings = _bookingsForDate(_selectedDate!);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cream.withOpacity(.65),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: softBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.event_note_rounded, color: navy, size: 17),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  _formatArabicDate(_selectedDate!),
                  style: const TextStyle(
                    color: navy,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'LibertinusMath',
                  ),
                ),
              ),
              Text(
                bookings.isEmpty ? '0 حجوزات' : '${bookings.length} حجوزات',
                style: const TextStyle(
                  color: textGrey,
                  fontSize: 9,
                  fontFamily: 'LibertinusMath',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 42,
            child: ElevatedButton.icon(
              onPressed: () {
                _showAddBookingSheet(_selectedDate!);
              },
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text(
                'إضافة حجز لهذا اليوم',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'LibertinusMath',
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: navy,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          if (bookings.isEmpty) ...[
            const SizedBox(height: 10),
            const Text(
              'لا توجد حجوزات في هذا اليوم',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textGrey,
                fontSize: 10,
                fontFamily: 'LibertinusMath',
              ),
            ),
          ] else ...[
            const SizedBox(height: 10),
            ...bookings.map((booking) => _miniBookingRow(booking)),
          ],
        ],
      ),
    );
  }

  Widget _miniBookingRow(Map<String, dynamic> booking) {
    final confirmed = booking['status'] == 'مؤكد';

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: (confirmed ? green : gold).withOpacity(.11),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              confirmed ? Icons.check_rounded : Icons.schedule_rounded,
              color: confirmed ? green : gold,
              size: 15,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking['customer']?.toString() ?? '',
                  style: const TextStyle(
                    color: textDark,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'LibertinusMath',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  booking['service']?.toString() ?? '',
                  style: const TextStyle(
                    color: textGrey,
                    fontSize: 8,
                    fontFamily: 'LibertinusMath',
                  ),
                ),
              ],
            ),
          ),
          Text(
            _formatPrice(booking['price']),
            style: const TextStyle(
              color: navy,
              fontSize: 9,
              fontWeight: FontWeight.bold,
              fontFamily: 'LibertinusMath',
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _bookingsForDate(DateTime date) {
    return _bookings.where((booking) {
      final bookingDate = booking['date'];
      if (bookingDate is! DateTime) return false;
      return _isSameDay(bookingDate, date);
    }).toList();
  }

  bool _isSameDay(DateTime? first, DateTime? second) {
    if (first == null || second == null) return false;
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  void _previousMonth() {
    setState(() {
      _calendarMonth = DateTime(_calendarMonth.year, _calendarMonth.month - 1);
      _selectedDate = DateTime(_calendarMonth.year, _calendarMonth.month, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _calendarMonth = DateTime(_calendarMonth.year, _calendarMonth.month + 1);
      _selectedDate = DateTime(_calendarMonth.year, _calendarMonth.month, 1);
    });
  }

  void _goToToday() {
    final now = DateTime.now();
    setState(() {
      _calendarMonth = DateTime(now.year, now.month);
      _selectedDate = now;
    });
  }

  // ============================================================
  // ADD BOOKING
  // ============================================================

  void _showAddBookingSheet(DateTime date) {
    final customerController = TextEditingController();
    final phoneController = TextEditingController();
    final serviceController = TextEditingController();
    final priceController = TextEditingController();
    String selectedStatus = 'مؤكد';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: cream,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 42,
                          height: 4,
                          decoration: BoxDecoration(
                            color: softBorder,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              color: navy,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.event_available_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'إضافة حجز جديد',
                                  style: TextStyle(
                                    color: textDark,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    fontFamily: 'LibertinusMath',
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  _formatArabicDate(date),
                                  style: const TextStyle(
                                    color: textGrey,
                                    fontSize: 10,
                                    fontFamily: 'LibertinusMath',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      _bookingInput(
                        controller: customerController,
                        label: 'اسم العميل',
                        hint: 'ادخل اسم العميل',
                        icon: Icons.person_outline_rounded,
                      ),
                      const SizedBox(height: 11),
                      _bookingInput(
                        controller: phoneController,
                        label: 'رقم الهاتف',
                        hint: 'أدخل رقم هاتف العميل',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 11),
                      _bookingInput(
                        controller: serviceController,
                        label: 'القاعة / الخدمة',
                        hint: 'ادخل اسم الخدمة',
                        icon: Icons.apartment_rounded,
                      ),
                      const SizedBox(height: 11),
                      _bookingInput(
                        controller: priceController,
                        label: 'السعر',
                        hint: 'ادخل سعر الحجز',
                        icon: Icons.payments_outlined,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'حالة الحجز',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: textDark,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'LibertinusMath',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _statusOption(
                            'مؤكد',
                            selectedStatus,
                            (value) =>
                                setSheetState(() => selectedStatus = value),
                          ),
                          const SizedBox(width: 8),
                          _statusOption(
                            'قيد الانتظار',
                            selectedStatus,
                            (value) =>
                                setSheetState(() => selectedStatus = value),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            final customer = customerController.text.trim();
                            final phone = phoneController.text.trim();
                            final service = serviceController.text.trim();
                            final price = priceController.text.trim();

                            if (customer.isEmpty || service.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'يرجى إدخال اسم العميل والخدمة',
                                    textAlign: TextAlign.right,
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              return;
                            }

                            final newBooking = {
                              'customer': customer,
                              'phone': phone,
                              'service': service,
                              'date':
                                  DateTime(date.year, date.month, date.day),
                              'status': selectedStatus,
                              'price': price.isEmpty ? '0' : price,
                            };

                            setState(() {
                              _bookings.insert(0, newBooking);
                              _selectedDate =
                                  DateTime(date.year, date.month, date.day);
                              _calendarMonth = DateTime(date.year, date.month);
                              _addOrUpdateCustomer(customer, phone);
                            });

                            Navigator.pop(sheetContext);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'تمت إضافة الحجز بنجاح',
                                  textAlign: TextAlign.right,
                                ),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: navy,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: navy,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'حفظ الحجز',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'LibertinusMath',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _addOrUpdateCustomer(String name, String phone) {
    final existingIndex = _customers.indexWhere(
      (customer) => customer['name']?.toString().trim() == name.trim(),
    );

    if (existingIndex != -1) {
      _customers[existingIndex]['bookings'] =
          (_customers[existingIndex]['bookings'] as int? ?? 0) + 1;
      if (phone.isNotEmpty) {
        _customers[existingIndex]['phone'] = phone;
      }
    } else {
      _customers.insert(0, {
        'name': name,
        'phone': phone,
        'bookings': 1,
      });
    }
  }

  Widget _bookingInput({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          textAlign: TextAlign.right,
          style: const TextStyle(
            color: textDark,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            fontFamily: 'LibertinusMath',
          ),
        ),
        const SizedBox(height: 7),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          textAlign: TextAlign.right,
          style: const TextStyle(
            color: textDark,
            fontSize: 12,
            fontFamily: 'LibertinusMath',
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Colors.black38,
              fontSize: 11,
              fontFamily: 'LibertinusMath',
            ),
            prefixIcon: Icon(icon, color: navy, size: 19),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: softBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: softBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: navy, width: 1.2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _statusOption(
    String value,
    String selectedValue,
    ValueChanged<String> onChanged,
  ) {
    final selected = value == selectedValue;

    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          decoration: BoxDecoration(
            color: selected ? navy : Colors.white,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: selected ? navy : softBorder),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                selected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                color: selected ? gold : textGrey,
                size: 17,
              ),
              const SizedBox(width: 6),
              Text(
                value,
                style: TextStyle(
                  color: selected ? Colors.white : textDark,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'LibertinusMath',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SERVICES
  // ============================================================

  Widget _buildServicesPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildPageIntro(
            icon: Icons.auto_awesome_outlined,
            title: 'خدماتك',
            subtitle: 'الخدمات والأسعار التي تقدمها للعملاء',
          ),
          const SizedBox(height: 16),
          if (_halls.isEmpty)
            _buildEmptyState(
              icon: Icons.home_work_outlined,
              title: 'لا توجد خدمات بعد',
              subtitle: 'أضف خدماتك من خلال تعديل الملف الشخصي.',
            )
          else
            ..._halls.map(_buildHallCard),
        ],
      ),
    );
  }

  Widget _buildHallCard(Map<String, dynamic> hall) {
    final pricing = (hall['pricing'] as List? ?? [])
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();

    final includedItems = List<String>.from(
      hall['includedItems'] as List? ?? [],
    );

    final hospitality = (hall['hospitality'] as List? ?? [])
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();

    final services = List<String>.from(
      hall['services'] as List? ?? [],
    );

    final occasionsRaw = hall['occasions'] as List? ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: softBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.035),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: navy.withOpacity(.07),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(Icons.home_work_outlined, color: navy),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hall['name']?.toString() ?? 'الخدمة',
                      style: const TextStyle(
                        color: navy,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'LibertinusMath',
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'خدمة مضافة',
                      style: TextStyle(
                        color: textGrey,
                        fontSize: 9,
                        fontFamily: 'LibertinusMath',
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                decoration: BoxDecoration(
                  color: green.withOpacity(.09),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, color: green, size: 13),
                    SizedBox(width: 4),
                    Text(
                      'نشطة',
                      style: TextStyle(
                        color: green,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'LibertinusMath',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (pricing.isNotEmpty) ...[
            const SizedBox(height: 17),
            _hallSectionTitle(
              'الأسعار حسب عدد الأشخاص',
              Icons.groups_outlined,
            ),
            const SizedBox(height: 8),
            ...pricing.map(
              (item) => _priceRow(
                item['peopleRange']?.toString() ?? '',
                _formatPrice(item['price']),
              ),
            ),
          ],
          if (includedItems.isNotEmpty) ...[
            const SizedBox(height: 15),
            _hallSectionTitle('يشمل السعر', Icons.check_circle_outline),
            const SizedBox(height: 8),
            _buildChips(includedItems),
          ],
          if (hospitality.isNotEmpty) ...[
            const SizedBox(height: 15),
            _hallSectionTitle('الضيافة', Icons.local_cafe_outlined),
            const SizedBox(height: 8),
            ...hospitality.map(_hospitalityRow),
          ],
          if (services.isNotEmpty) ...[
            const SizedBox(height: 15),
            _hallSectionTitle('الخدمات', Icons.auto_awesome_outlined),
            const SizedBox(height: 8),
            _buildChips(services),
          ],
          if (occasionsRaw.isNotEmpty) ...[
            const SizedBox(height: 15),
            _hallSectionTitle('المناسبات', Icons.celebration_outlined),
            const SizedBox(height: 8),
            _buildOccasionChips(occasionsRaw),
          ],
        ],
      ),
    );
  }

  Widget _priceRow(String range, String price) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
      decoration: BoxDecoration(
        color: cream,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              range,
              style: const TextStyle(
                color: textDark,
                fontSize: 10,
                fontFamily: 'LibertinusMath',
              ),
            ),
          ),
          Text(
            price,
            style: const TextStyle(
              color: navy,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              fontFamily: 'LibertinusMath',
            ),
          ),
        ],
      ),
    );
  }

  Widget _hospitalityRow(Map<String, dynamic> item) {
    final name = item['name']?.toString() ?? '';
    final pricing = (item['pricing'] as List? ?? [])
        .whereType<Map>()
        .map((price) => Map<String, dynamic>.from(price))
        .toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 7),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: cream.withOpacity(.55),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: navy,
              fontWeight: FontWeight.bold,
              fontSize: 11,
              fontFamily: 'LibertinusMath',
            ),
          ),
          if (pricing.isNotEmpty) ...[
            const SizedBox(height: 6),
            ...pricing.map(
              (price) => Row(
                children: [
                  Expanded(
                    child: Text(
                      price['peopleRange']?.toString() ?? '',
                      style: const TextStyle(
                        color: textGrey,
                        fontSize: 9,
                        fontFamily: 'LibertinusMath',
                      ),
                    ),
                  ),
                  Text(
                    _formatPrice(price['price']),
                    style: const TextStyle(
                      color: navy,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChips(List<String> values) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: values.map((value) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
          decoration: BoxDecoration(
            color: navy.withOpacity(.06),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Text(
            value,
            style: const TextStyle(
              color: navy,
              fontSize: 9,
              fontWeight: FontWeight.w600,
              fontFamily: 'LibertinusMath',
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOccasionChips(List occasions) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: occasions.map((occasion) {
        String name;
        String price = '';

        if (occasion is Map) {
          name = occasion['name']?.toString() ?? '';
          price = occasion['price']?.toString() ?? '';
        } else {
          name = occasion.toString();
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
          decoration: BoxDecoration(
            color: gold.withOpacity(.10),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.celebration_outlined,
                color: gold,
                size: 12,
              ),
              const SizedBox(width: 5),
              Text(
                name,
                style: const TextStyle(
                  color: navy,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'LibertinusMath',
                ),
              ),
              if (price.isNotEmpty) ...[
                const SizedBox(width: 5),
                Text(
                  _formatPrice(price),
                  style: const TextStyle(color: textGrey, fontSize: 8),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  // ============================================================
  // BOOKINGS PAGE
  // ============================================================

  Widget _buildBookingsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildBookingsSummary(),
          const SizedBox(height: 15),
          _buildDashboardCalendar(),
          const SizedBox(height: 20),
          _buildSectionTitle(
            'جميع الحجوزات',
            '${_bookings.length} حجوزات',
            () {},
          ),
          const SizedBox(height: 8),
          ..._bookings.map(_buildBookingCard),
        ],
      ),
    );
  }

  Widget _buildBookingsSummary() {
    final confirmed =
        _bookings.where((item) => item['status'] == 'مؤكد').length;
    final pending =
        _bookings.where((item) => item['status'] == 'قيد الانتظار').length;

    return Row(
      children: [
        Expanded(
          child: _bookingSummaryCard(
            'إجمالي الحجوزات',
            '${_bookings.length}',
            Icons.event_available_rounded,
            navy,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: _bookingSummaryCard(
            'مؤكدة',
            '$confirmed',
            Icons.check_circle_outline_rounded,
            green,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: _bookingSummaryCard(
            'انتظار',
            '$pending',
            Icons.schedule_rounded,
            gold,
          ),
        ),
      ],
    );
  }

  Widget _bookingSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: softBorder),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 19),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              color: navy,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: textGrey,
              fontSize: 8,
              fontFamily: 'LibertinusMath',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    final confirmed = booking['status'] == 'مؤكد';
    final date = booking['date'];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: softBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: navy.withOpacity(.07),
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              color: navy,
              size: 21,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking['customer']?.toString() ?? '',
                  style: const TextStyle(
                    color: textDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    fontFamily: 'LibertinusMath',
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  booking['service']?.toString() ?? '',
                  style: const TextStyle(
                    color: textGrey,
                    fontSize: 9,
                    fontFamily: 'LibertinusMath',
                  ),
                ),
                const SizedBox(height: 3),
                if (date is DateTime)
                  Text(
                    _formatArabicDate(date),
                    style: const TextStyle(
                      color: textGrey,
                      fontSize: 9,
                      fontFamily: 'LibertinusMath',
                    ),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: (confirmed ? green : gold).withOpacity(.10),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  booking['status']?.toString() ?? '',
                  style: TextStyle(
                    color: confirmed ? green : navy,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'LibertinusMath',
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _formatPrice(booking['price']),
                style: const TextStyle(
                  color: navy,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'LibertinusMath',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CUSTOMERS
  // ============================================================

  Widget _buildCustomersPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildPageIntro(
            icon: Icons.people_outline_rounded,
            title: 'العملاء',
            subtitle: 'إدارة العملاء وحجوزاتهم',
          ),
          const SizedBox(height: 16),
          ..._customers.map(
            (customer) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(17),
                border: Border.all(color: softBorder),
              ),
              child: Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: gold.withOpacity(.12),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Icon(
                      Icons.person_outline_rounded,
                      color: navy,
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customer['name']?.toString() ?? '',
                          style: const TextStyle(
                            color: textDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            fontFamily: 'LibertinusMath',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          customer['phone']?.toString() ?? '',
                          style: const TextStyle(
                            color: textGrey,
                            fontSize: 9,
                            fontFamily: 'LibertinusMath',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: navy.withOpacity(.06),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Text(
                      '${customer['bookings']} حجوزات',
                      style: const TextStyle(
                        color: navy,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'LibertinusMath',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PROFILE
  // ============================================================

  Widget _buildProfilePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 15),
          _profileSection(
            title: 'معلومات الحساب',
            icon: Icons.person_outline_rounded,
            children: [
              _profileInfo(
                'اسم مقدم الخدمة',
                _providerName,
                Icons.badge_outlined,
              ),
              _profileInfo(
                'رقم الهاتف',
                _providerPhone,
                Icons.phone_outlined,
              ),
              _profileInfo(
                'البريد الإلكتروني',
                _providerEmail,
                Icons.email_outlined,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _profileSection(
            title: 'معلومات النشاط',
            icon: Icons.business_outlined,
            children: [
              _profileInfo(
                'اسم النشاط',
                _businessName,
                Icons.storefront_outlined,
              ),
              _profileInfo(
                'نوع الخدمة',
                _serviceType,
                Icons.category_outlined,
              ),
              _profileInfo(
                'الموقع',
                _location,
                Icons.location_on_outlined,
              ),
              _profileInfo(
                'العنوان',
                _address,
                Icons.home_outlined,
              ),
              _profileInfo(
                'رقم الترخيص',
                _licensedOperatorNumber,
                Icons.verified_outlined,
              ),
              _profileInfo(
                'الوصف',
                _description.isEmpty ? 'لا يوجد وصف' : _description,
                Icons.description_outlined,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _profileSection(
            title: 'الخدمات المضافة',
            icon: Icons.home_work_outlined,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'عدد الخدمات',
                      style: TextStyle(
                        color: textGrey,
                        fontSize: 11,
                        fontFamily: 'LibertinusMath',
                      ),
                    ),
                  ),
                  Text(
                    '${_halls.length}',
                    style: const TextStyle(
                      color: navy,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'LibertinusMath',
                    ),
                  ),
                ],
              ),
              if (_halls.isNotEmpty) ...[
                const SizedBox(height: 11),
                ..._halls.map(
                  (hall) => Padding(
                    padding: const EdgeInsets.only(bottom: 7),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: green,
                          size: 16,
                        ),
                        const SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            hall['name']?.toString() ?? 'خدمة',
                            style: const TextStyle(
                              color: textDark,
                              fontSize: 11,
                              fontFamily: 'LibertinusMath',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF22365E),
            Color(0xFF1B2A4A),
          ],
        ),
        borderRadius: BorderRadius.circular(23),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: gold,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'FZ',
                style: TextStyle(
                  color: navy,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(height: 11),
          Text(
            _businessName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'LibertinusMath',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _serviceType,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontFamily: 'LibertinusMath',
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _editProfile,
              icon: const Icon(
                Icons.edit_outlined,
                color: gold,
                size: 17,
              ),
              label: const Text(
                'تعديل الملف الشخصي',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  fontFamily: 'LibertinusMath',
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: gold.withOpacity(.65),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: softBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: navy.withOpacity(.07),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, color: navy, size: 17),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: navy,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'LibertinusMath',
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          ...children,
        ],
      ),
    );
  }

  Widget _profileInfo(
    String label,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: cream,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: navy, size: 17),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: textGrey,
                    fontSize: 9,
                    fontFamily: 'LibertinusMath',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: textDark,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'LibertinusMath',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // COMMON
  // ============================================================

  Widget _buildPageIntro({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: softBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: gold.withOpacity(.13),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: navy, size: 21),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'LibertinusMath',
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: textGrey,
                    fontSize: 9,
                    fontFamily: 'LibertinusMath',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
    String title,
    String action,
    VoidCallback onTap,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: navy,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'LibertinusMath',
            ),
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            action,
            style: const TextStyle(
              color: gold,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              fontFamily: 'LibertinusMath',
            ),
          ),
        ),
      ],
    );
  }

  Widget _hallSectionTitle(
    String title,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, color: gold, size: 17),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            color: navy,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            fontFamily: 'LibertinusMath',
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: softBorder),
      ),
      child: Column(
        children: [
          Icon(icon, color: navy.withOpacity(.4), size: 42),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: navy,
              fontWeight: FontWeight.bold,
              fontSize: 15,
              fontFamily: 'LibertinusMath',
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: textGrey,
              fontSize: 10,
              fontFamily: 'LibertinusMath',
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DRAWER
  // ============================================================

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: cream,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 22),
              decoration: const BoxDecoration(
                color: navy,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      color: gold,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'FZ',
                        style: TextStyle(
                          color: navy,
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _businessName,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'LibertinusMath',
                    ),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    'لوحة مقدم الخدمة',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontFamily: 'LibertinusMath',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 9),
            _drawerItem(
              icon: Icons.dashboard_outlined,
              title: 'الرئيسية',
              index: 0,
            ),
            _drawerItem(
              icon: Icons.home_work_outlined,
              title: 'الخدمات',
              index: 1,
            ),
            _drawerItem(
              icon: Icons.event_available_outlined,
              title: 'الحجوزات',
              index: 2,
            ),
            _drawerItem(
              icon: Icons.people_outline,
              title: 'العملاء',
              index: 3,
            ),
            _drawerItem(
              icon: Icons.person_outline,
              title: 'حسابي',
              index: 4,
            ),
            const Spacer(),
            const Divider(
              color: softBorder,
              indent: 18,
              endIndent: 18,
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined, color: navy),
              title: const Text(
                'الإعدادات',
                style: TextStyle(
                  color: textDark,
                  fontFamily: 'LibertinusMath',
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline, color: navy),
              title: const Text(
                'المساعدة',
                style: TextStyle(
                  color: textDark,
                  fontFamily: 'LibertinusMath',
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: red),
              title: const Text(
                'تسجيل الخروج',
                style: TextStyle(
                  color: red,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'LibertinusMath',
                ),
              ),
              onTap: _showLogoutDialog,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String title,
    required int index,
  }) {
    final selected = _selectedIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: selected ? navy.withOpacity(.09) : Colors.transparent,
        borderRadius: BorderRadius.circular(13),
      ),
      child: ListTile(
        leading: Icon(icon, color: selected ? navy : textGrey),
        title: Text(
          title,
          style: TextStyle(
            color: selected ? navy : textDark,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            fontFamily: 'LibertinusMath',
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  Widget _buildBottomNavigationBar() {
    return NavigationBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 10,
      height: 68,
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      indicatorColor: gold.withOpacity(.17),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.dashboard_outlined),
          selectedIcon: Icon(Icons.dashboard),
          label: 'الرئيسية',
        ),
        NavigationDestination(
          icon: Icon(Icons.home_work_outlined),
          selectedIcon: Icon(Icons.home_work),
          label: 'الخدمات',
        ),
        NavigationDestination(
          icon: Icon(Icons.event_available_outlined),
          selectedIcon: Icon(Icons.event_available),
          label: 'الحجوزات',
        ),
        NavigationDestination(
          icon: Icon(Icons.people_outline),
          selectedIcon: Icon(Icons.people),
          label: 'العملاء',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'حسابي',
        ),
      ],
    );
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  void _showLogoutDialog() {
    Navigator.pop(context); // يسكّر القائمة الجانبية (Drawer)

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'تسجيل الخروج',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: navy,
              fontWeight: FontWeight.bold,
              fontFamily: 'LibertinusMath',
            ),
          ),
          content: const Text(
            'هل أنت متأكد أنك تريد تسجيل الخروج؟',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: textGrey,
              fontFamily: 'LibertinusMath',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'إلغاء',
                style: TextStyle(
                  color: textGrey,
                  fontFamily: 'LibertinusMath',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext); // يسكّر الـ dialog أولاً
                _logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: red,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'تسجيل الخروج',
                style: TextStyle(fontFamily: 'LibertinusMath'),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    // نمسك الـ Navigator قبل أي await، حتى ما نعتمد على context بعد الانتظار
    final navigator = Navigator.of(context, rootNavigator: true);

    debugPrint('LOGOUT: start');

    try {
      // نمسح التوكن، ولو تأخر التخزين أكثر من ثانيتين نكمل بدونه
      await ApiService.logout().timeout(const Duration(seconds: 2));
      debugPrint('LOGOUT: token cleared');
    } catch (e) {
      debugPrint('LOGOUT: clear token failed -> $e');
    }

    // نرجع للشاشة العامة ونمسح كل الشاشات السابقة
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainScreen()),
      (route) => false,
    );

    debugPrint('LOGOUT: navigated to MainScreen');
  }

  // ============================================================
  // DATE HELPERS
  // ============================================================

  String _arabicMonth(int month) {
    const months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return months[month - 1];
  }

  String _formatArabicDate(DateTime date) {
    const days = [
      'الإثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت',
      'الأحد',
    ];
    return '${days[date.weekday - 1]}، ${date.day} ${_arabicMonth(date.month)}';
  }

  String _formatPrice(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) {
      return '—';
    }

    final number = double.tryParse(
      value.toString().replaceAll(',', ''),
    );

    if (number == null) {
      return '${value.toString()} ₪';
    }

    if (number == number.roundToDouble()) {
      return '${number.toInt()} ₪';
    }

    return '${number.toStringAsFixed(2)} ₪';
  }
}