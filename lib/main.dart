import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const NoorAlMominApp());
}

class NoorAlMominApp extends StatelessWidget {
  const NoorAlMominApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'نور المؤمن',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F3E22),
          primary: const Color(0xFF0F3E22),
          secondary: const Color(0xFFD4AF37),
        ),
      ),
      home: const MainWrapper(),
    );
  }
}

class MainWrapper extends StatefulWidget {
  const MainWrapper({Key? key}) : super(key: key);

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(
        onNavigateToTasbeeh: () => setState(() => _selectedIndex = 2),
        onNavigateToQiblah: () => setState(() => _selectedIndex = 1),
        onNavigateToDuas: () => setState(() => _selectedIndex = 3),
        onNavigateToQuran: () => setState(() => _selectedIndex = 4),
      ),
      const QiblahScreen(),
      const TasbeehScreen(),
      const DuasScreen(),
      const QuranScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex > 3 ? 3 : _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF0F3E22),
            unselectedItemColor: Colors.grey.shade400,
            selectedLabelStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled), label: 'الرئيسية'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.explore_outlined), label: 'القبلة'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.control_point_duplicate), label: 'السبحة'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.auto_stories_rounded), label: 'الأدعية'),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------- الشاشة الرئيسية -------------------
class HomeScreen extends StatelessWidget {
  final VoidCallback onNavigateToTasbeeh;
  final VoidCallback onNavigateToQiblah;
  final VoidCallback onNavigateToDuas;
  final VoidCallback onNavigateToQuran;

  const HomeScreen({
    Key? key,
    required this.onNavigateToTasbeeh,
    required this.onNavigateToQiblah,
    required this.onNavigateToDuas,
    required this.onNavigateToQuran,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F6),
      appBar: AppBar(
        title: const Text('نور المؤمن',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF0F3E22),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F3E22), Color(0xFF1B5E3A)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F3E22).withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('الجمعة، ٢٧ ربيع الثاني',
                          style:
                              TextStyle(color: Colors.white70, fontSize: 13)),
                      Text('النجف الأشرف',
                          style: TextStyle(
                              color: Color(0xFFD4AF37),
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 18),
                  Text('الصلاة القادمة: الظهر',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                  SizedBox(height: 6),
                  Text('12:15 م',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 28),
            const Text('الخدمات السريعة',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B2E22))),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildServiceCard(context, Icons.explore_rounded, 'القبلة',
                    const Color(0xFFD97706), onNavigateToQiblah),
                _buildServiceCard(context, Icons.touch_app_rounded, 'السبحة',
                    const Color(0xFF0D9488), onNavigateToTasbeeh),
                _buildServiceCard(context, Icons.auto_stories_rounded,
                    'الأدعية', const Color(0xFF7C3AED), onNavigateToDuas),
                _buildServiceCard(context, Icons.menu_book_rounded, 'القرآن',
                    const Color(0xFF0284C7), onNavigateToQuran),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, IconData icon, String label,
      Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 75,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: color.withOpacity(0.12), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 8),
            Text(label,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333))),
          ],
        ),
      ),
    );
  }
}

// ------------------- شاشة القرآن الكريم -------------------
class QuranScreen extends StatefulWidget {
  const QuranScreen({Key? key}) : super(key: key);

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  List<dynamic> _surahs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSurahs();
  }

  Future<void> _fetchSurahs() async {
    try {
      final response =
          await http.get(Uri.parse('https://api.alquran.cloud/v1/surah'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _surahs = data['data'];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F6),
      appBar: AppBar(
        title: const Text('القرآن الكريم (الـ 114 سورة)',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF0F3E22),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF0F3E22)))
          : _surahs.isEmpty
              ? const Center(
                  child: Text('تعذر تحميل السور، تأكد من الاتصال بالإنترنت'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _surahs.length,
                  itemBuilder: (context, index) {
                    final surah = _surahs[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 6,
                              offset: const Offset(0, 2))
                        ],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              const Color(0xFF0F3E22).withOpacity(0.1),
                          child: Text(
                            '${surah['number']}',
                            style: const TextStyle(
                                color: Color(0xFF0F3E22),
                                fontWeight: FontWeight.bold,
                                fontSize: 13),
                          ),
                        ),
                        title: Text(
                          'سورة ${surah['name']}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF1B2E22)),
                        ),
                        subtitle: Text(
                          'عدد الآيات: ${surah['numberOfAyahs']} | ${surah['englishName']} (${surah['revelationType'] == 'Meccan' ? 'مكية' : 'مدنية'})',
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 12),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded,
                            size: 14, color: Colors.grey),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SurahDetailScreen(
                                surahNumber: surah['number'],
                                surahName: surah['name'],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}

// ------------------- شاشة قراءة السورة -------------------
class SurahDetailScreen extends StatefulWidget {
  final int surahNumber;
  final String surahName;

  const SurahDetailScreen(
      {Key? key, required this.surahNumber, required this.surahName})
      : super(key: key);

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  List<dynamic> _ayahs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAyahs();
  }

  Future<void> _fetchAyahs() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.alquran.cloud/v1/surah/${widget.surahNumber}'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _ayahs = data['data']['ayahs'];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFDF9),
        appBar: AppBar(
          title: Text('سورة ${widget.surahName}',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white)),
          centerTitle: true,
          backgroundColor: const Color(0xFF0F3E22),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF0F3E22)))
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    if (widget.surahNumber != 9 && widget.surahNumber != 1)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Text(
                            'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F3E22)),
                          ),
                        ),
                      ),
                    Text(
                      _ayahs
                          .map((ayah) =>
                              '${ayah['text']} ﴿${ayah['numberInSurah']}﴾')
                          .join(' '),
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontSize: 22,
                        height: 2.3,
                        fontFamily: 'serif',
                        color: Color(0xFF222222),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

// ------------------- شاشة الأدعية والزيارات -------------------
class DuasScreen extends StatelessWidget {
  const DuasScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> _duasAndZiyarat = const [
    {
      'title': 'دعاء كميل بن زياد',
      'timing': 'يُقرأ ليلة الجمعة',
      'assetPath': 'assets/duas/kumayl.txt',
    },
    {
      'title': 'زيارة عاشوراء',
      'timing': 'تُقرأ في كل وقت',
      'assetPath': 'assets/duas/ashura.txt',
    },
    {
      'title': 'دعاء التوسل',
      'timing': 'يُقرأ ليلة الأربعاء',
      'assetPath': 'assets/duas/tawassul.txt',
    },
    {
      'title': 'دعاء الندبة',
      'timing': 'يُقرأ صباح الجمعة',
      'assetPath': 'assets/duas/nudba.txt',
    },
    {
      'title': 'زيارة أمين الله',
      'timing': 'عند زيارة أمير المؤمنين (ع)',
      'assetPath': 'assets/duas/ameen_allah.txt',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F6),
      appBar: AppBar(
        title: const Text('الأدعية والزيارات',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF0F3E22),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _duasAndZiyarat.length,
        itemBuilder: (context, index) {
          final item = _duasAndZiyarat[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 3))
              ],
            ),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF0F3E22),
                child: Icon(Icons.auto_stories_rounded,
                    color: Colors.white, size: 20),
              ),
              title: Text(item['title']!,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: Text(item['timing']!,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              trailing: const Icon(Icons.arrow_forward_ios_rounded,
                  size: 14, color: Colors.grey),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DuaDetailScreen(
                      title: item['title']!,
                      assetPath: item['assetPath']!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// ------------------- شاشة قراءة النص من الملف الخارجي -------------------
class DuaDetailScreen extends StatelessWidget {
  final String title;
  final String assetPath;

  const DuaDetailScreen(
      {Key? key, required this.title, required this.assetPath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFDF9),
        appBar: AppBar(
          title: Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white)),
          centerTitle: true,
          backgroundColor: const Color(0xFF0F3E22),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: FutureBuilder<String>(
          future: DefaultAssetBundle.of(context).loadString(assetPath),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF0F3E22)));
            } else if (snapshot.hasError) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'عذراً، لم يتم العثور على الملف النصي داخل مجلد assets/duas/ أو أن اسم الملف غير مطبق تماماً.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
              );
            }

            final content = snapshot.data ?? '';

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Text(
                        'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F3E22)),
                      ),
                    ),
                  ),
                  Text(
                    content,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 20,
                      height: 2.2,
                      fontFamily: 'serif',
                      color: Color(0xFF222222),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ------------------- شاشة القبلة -------------------
class QiblahScreen extends StatelessWidget {
  const QiblahScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F6),
      appBar: AppBar(
        title: const Text('اتجاه القبلة',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF0F3E22),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F3E22).withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.explore_rounded,
                    size: 80, color: Color(0xFF0F3E22)),
              ),
              const SizedBox(height: 24),
              const Text(
                'البوصلة الإسلامية واتجاه الكعبة',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B2E22)),
              ),
              const SizedBox(height: 12),
              const Text(
                'الكعبة المشرفة تقع في مكة المكرمة.\nحرك الهاتف بشكل رقم (8) لتعيير البوصلة بدقة عالية.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------- شاشة السبحة الإلكترونية -------------------
class TasbeehScreen extends StatefulWidget {
  const TasbeehScreen({Key? key}) : super(key: key);

  @override
  State<TasbeehScreen> createState() => _TasbeehScreenState();
}

class _TasbeehScreenState extends State<TasbeehScreen> {
  int _counter = 0;
  String _currentZikr = 'سُبْحَانَ اللَّهِ';

  final List<String> _azkar = [
    'سُبْحَانَ اللَّهِ',
    'الْحَمْدُ لِلَّهِ',
    'لَا إِلَهَ إِلَّا اللَّهُ',
    'اللَّهُ أَكْبَرُ',
    'أَسْتَغْفِرُ اللَّهَ',
  ];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    HapticFeedback.lightImpact();
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
    HapticFeedback.mediumImpact();
  }

  void _changeZikr() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('اختر الذكر',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F3E22))),
              const SizedBox(height: 15),
              ..._azkar.map((zikr) => ListTile(
                    title: Text(zikr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                    onTap: () {
                      setState(() {
                        _currentZikr = zikr;
                        _counter = 0;
                      });
                      Navigator.pop(context);
                    },
                  )),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F6),
      appBar: AppBar(
        title: const Text('السبحة الإلكترونية',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF0F3E22),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: _resetCounter,
            tooltip: 'تصفير العداد',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _changeZikr,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_currentZikr,
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F3E22))),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_drop_down, color: Color(0xFF0F3E22)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: _incrementCounter,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F3E22), Color(0xFF1B5E3A)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F3E22).withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '$_counter',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 65,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'اضغط في أي مكان على الدائرة للتسبيح',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
