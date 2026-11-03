import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() => runApp(const VoxRoyaleApp());

const _ink = Color(0xFF100D1C);
const _panel = Color(0xFF1C172B);
const _purple = Color(0xFFAB6BFF);
const _pink = Color(0xFFE354C5);
const _gold = Color(0xFFF2C879);

class VoxRoyaleApp extends StatelessWidget {
  const VoxRoyaleApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'VOX ROYALE',
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: _ink,
          colorScheme: const ColorScheme.dark(
            primary: _purple,
            secondary: _gold,
            surface: _panel,
          ),
          fontFamily: 'sans-serif',
          useMaterial3: true,
        ),
        home: const Directionality(
          textDirection: TextDirection.rtl,
          child: VoxShell(),
        ),
      );
}

class VoxShell extends StatefulWidget {
  const VoxShell({super.key});

  @override
  State<VoxShell> createState() => _VoxShellState();
}

class _VoxShellState extends State<VoxShell> {
  int _tab = 0;

  static const _titles = ['اكتشف', 'الرسائل', 'إنشاء غرفة', 'الترتيب', 'حسابي'];

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const DiscoverPage(),
      const EmptyPage(icon: Icons.forum_rounded, title: 'الرسائل', caption: 'ستظهر محادثاتك هنا بعد ربط خدمة الرسائل.'),
      const EmptyPage(icon: Icons.add_circle_outline_rounded, title: 'غرفة جديدة', caption: 'إنشاء الغرف يحتاج إلى تسجيل الدخول وربط Supabase.'),
      const EmptyPage(icon: Icons.emoji_events_rounded, title: 'المتصدرون', caption: 'سيظهر الترتيب بعد إعداد بيانات المستويات.'),
      const EmptyPage(icon: Icons.person_rounded, title: 'حسابي', caption: 'سجّل الدخول لإدارة ملفك الشخصي.'),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _ink,
        title: Row(children: [
          Container(
            width: 35,
            height: 35,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(colors: [_pink, _purple]),
            ),
            child: SvgPicture.asset('assets/brand/vox_mark.svg'),
          ),
          const SizedBox(width: 10),
          const Text('VOX ROYALE', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.1, fontSize: 17)),
        ]),
        actions: [
          IconButton(onPressed: () => _notice(context, 'البحث سيتصل بفهرس الغرف عند تفعيل الخلفية.'), icon: const Icon(Icons.search_rounded)),
          IconButton(onPressed: () => _notice(context, 'الإشعارات غير مفعّلة بعد.'), icon: const Icon(Icons.notifications_none_rounded)),
          const SizedBox(width: 6),
        ],
      ),
      body: SafeArea(child: IndexedStack(index: _tab, children: pages)),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (value) => setState(() => _tab = value),
        backgroundColor: const Color(0xFF171322),
        indicatorColor: _purple.withValues(alpha: .22),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: 'اكتشف'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: 'الرسائل'),
          NavigationDestination(icon: Icon(Icons.add_circle_outline), selectedIcon: Icon(Icons.add_circle), label: 'إنشاء'),
          NavigationDestination(icon: Icon(Icons.emoji_events_outlined), selectedIcon: Icon(Icons.emoji_events), label: 'ترتيب'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'حسابي'),
        ],
      ),
    );
  }
}

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
        children: [
          Container(
            height: 188,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: _purple.withValues(alpha: .45)),
            ),
            child: Stack(fit: StackFit.expand, children: [
              SvgPicture.asset('assets/rooms/royal_stage.svg', fit: BoxFit.cover),
              DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.centerRight, end: Alignment.centerLeft, colors: [_ink.withValues(alpha: .12), _ink.withValues(alpha: .75)]))),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [
                  const Text('مساحتك.. صوتك.. عالمك', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 5),
                  Text('اكتشف المجالس الصوتية الآن', style: TextStyle(color: Colors.white.withValues(alpha: .78))),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () => _notice(context, 'الانضمام الصوتي يتطلب تهيئة مزود RTC.'),
                    icon: const Icon(Icons.graphic_eq_rounded, size: 18),
                    label: const Text('استكشف الغرف'),
                    style: FilledButton.styleFrom(backgroundColor: _pink, foregroundColor: Colors.white),
                  ),
                ]),
              ),
            ]),
          ),
          const SizedBox(height: 25),
          Row(children: [const Expanded(child: Text('غرف مختارة', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19))), TextButton(onPressed: () => _notice(context, 'سيظهر المزيد عند ربط قاعدة البيانات.'), child: const Text('عرض الكل'))]),
          const SizedBox(height: 8),
          const RoomCard(title: 'مجلس السهرة', subtitle: 'جلسة تعارف وموسيقى هادئة', listeners: 28, tag: 'اجتماعي', colors: [Color(0xFF4D286E), Color(0xFF211A39)]),
          const RoomCard(title: 'مساحة المبدعين', subtitle: 'أفكار، فنون وحديث ملهم', listeners: 16, tag: 'إبداع', colors: [Color(0xFF713A66), Color(0xFF281A38)]),
          const RoomCard(title: 'حديث المساء', subtitle: 'انضم إلى نقاش الليلة', listeners: 9, tag: 'جديد', colors: [Color(0xFF674A30), Color(0xFF241C31)]),
          const SizedBox(height: 20),
          const Text('أصول مرئية أصلية', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19)),
          const SizedBox(height: 10),
          Row(children: [
            _AssetTile(asset: 'assets/gifts/royal_gift.svg', label: 'هدية'),
            const SizedBox(width: 10),
            _AssetTile(asset: 'assets/badges/vip_badge.svg', label: 'شارة VIP'),
          ]),
          const SizedBox(height: 8),
          Text('رسومات SVG أولية بأسلوب حجمي؛ نماذج 3D الفعلية لم تُنتج بعد.', style: TextStyle(color: Colors.white.withValues(alpha: .52), fontSize: 12)),
        ],
      );
}

class RoomCard extends StatelessWidget {
  const RoomCard({super.key, required this.title, required this.subtitle, required this.listeners, required this.tag, required this.colors});
  final String title;
  final String subtitle;
  final int listeners;
  final String tag;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(gradient: LinearGradient(colors: colors), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withValues(alpha: .08))),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(width: 48, height: 48, decoration: BoxDecoration(color: _purple.withValues(alpha: .22), borderRadius: BorderRadius.circular(15)), child: const Icon(Icons.graphic_eq_rounded, color: _gold)),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          subtitle: Padding(padding: const EdgeInsets.only(top: 5), child: Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: .64)))),
          trailing: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.headphones_rounded, size: 17, color: _gold), const SizedBox(height: 3), Text('$listeners')]),
          onTap: () => _notice(context, 'هذه بطاقة تصميمية؛ بيانات الغرف الحية لم تُربط بعد.'),
        ),
      );
}

class _AssetTile extends StatelessWidget {
  const _AssetTile({required this.asset, required this.label});
  final String asset;
  final String label;
  @override
  Widget build(BuildContext context) => Expanded(child: Container(height: 100, decoration: BoxDecoration(color: _panel, borderRadius: BorderRadius.circular(18)), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [SizedBox(width: 56, height: 56, child: SvgPicture.asset(asset)), const SizedBox(width: 8), Text(label, style: const TextStyle(fontWeight: FontWeight.w700))])));
}

class EmptyPage extends StatelessWidget {
  const EmptyPage({super.key, required this.icon, required this.title, required this.caption});
  final IconData icon;
  final String title;
  final String caption;
  @override
  Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.all(28), child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 58, color: _purple), const SizedBox(height: 14), Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), const SizedBox(height: 8), Text(caption, textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withValues(alpha: .6)))])));
}

void _notice(BuildContext context, String message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), behavior: SnackBarBehavior.floating));
