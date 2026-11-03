import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() => runApp(const VoxRoyaleApp());

const ink = Color(0xFF100D1C);
const panel = Color(0xFF1C172B);
const purple = Color(0xFFAB6BFF);
const pink = Color(0xFFE354C5);
const gold = Color(0xFFF2C879);

class VoxRoyaleApp extends StatelessWidget {
  const VoxRoyaleApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'VOX ROYALE',
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: ink,
          colorScheme: const ColorScheme.dark(primary: purple, secondary: gold, surface: panel),
          useMaterial3: true,
        ),
        home: const Directionality(textDirection: TextDirection.rtl, child: AppShell()),
      );
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int selected = 0;
  final pages = const [DiscoverPage(), InboxPage(), CreatePage(), RankingPage(), ProfilePage()];
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: ink,
          title: Row(children: [
            Container(width: 34, height: 34, padding: const EdgeInsets.all(5), decoration: BoxDecoration(borderRadius: BorderRadius.circular(11), gradient: const LinearGradient(colors: [pink, purple])), child: SvgPicture.asset('assets/brand/vox_mark.svg')),
            const SizedBox(width: 10),
            const Text('VOX ROYALE', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
          ]),
          actions: [
            IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const SearchPage())), icon: const Icon(Icons.search_rounded)),
            IconButton(onPressed: () => _toast(context, 'الإشعارات تحتاج إلى ربط خدمة الإشعارات.'), icon: const Icon(Icons.notifications_none_rounded)),
            const SizedBox(width: 5),
          ],
        ),
        body: SafeArea(child: IndexedStack(index: selected, children: pages)),
        bottomNavigationBar: NavigationBar(
          selectedIndex: selected,
          onDestinationSelected: (index) => setState(() => selected = index),
          backgroundColor: const Color(0xFF171322),
          indicatorColor: purple.withValues(alpha: .22),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: 'اكتشف'),
            NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: 'الرسائل'),
            NavigationDestination(icon: Icon(Icons.add_circle_outline), selectedIcon: Icon(Icons.add_circle), label: 'إنشاء'),
            NavigationDestination(icon: Icon(Icons.emoji_events_outlined), selectedIcon: Icon(Icons.emoji_events), label: 'الترتيب'),
            NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'حسابي'),
          ],
        ),
      );
}

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});
  static const rooms = <RoomInfo>[
    RoomInfo('مجلس السهرة', 'جلسة تعارف وحديث خفيف', 28, 'اجتماعي', [Color(0xFF56316E), Color(0xFF211A39)]),
    RoomInfo('مساحة المبدعين', 'أفكار وفنون وحديث ملهم', 16, 'إبداع', [Color(0xFF713A66), Color(0xFF281A38)]),
    RoomInfo('حديث المساء', 'انضم إلى نقاش الليلة', 9, 'جديد', [Color(0xFF674A30), Color(0xFF241C31)]),
    RoomInfo('عالم الألعاب', 'تحديات وأصدقاء جدد', 42, 'ألعاب', [Color(0xFF374078), Color(0xFF211A39)]),
  ];
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.fromLTRB(16, 10, 16, 24), children: [
        Container(height: 190, clipBehavior: Clip.antiAlias, decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), border: Border.all(color: purple.withValues(alpha: .4))), child: Stack(fit: StackFit.expand, children: [
          SvgPicture.asset('assets/rooms/royal_stage.svg', fit: BoxFit.cover),
          DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.centerRight, end: Alignment.centerLeft, colors: [ink.withValues(alpha: .12), ink.withValues(alpha: .82)]))),
          Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [const Text('مساحتك.. صوتك.. عالمك', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900)), const SizedBox(height: 5), const Text('اكتشف المجالس الصوتية'), const SizedBox(height: 12), FilledButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => const RoomPage(room: rooms.first))), icon: const Icon(Icons.graphic_eq), label: const Text('استكشف الغرف'), style: FilledButton.styleFrom(backgroundColor: pink))])),
        ])),
        const SizedBox(height: 20),
        const SectionTitle(title: 'التصنيفات'),
        const SizedBox(height: 10),
        SizedBox(height: 42, child: ListView(scrollDirection: Axis.horizontal, children: ['الكل', 'اجتماعي', 'موسيقى', 'ألعاب', 'تعلم', 'بلدان'].map((label) => Padding(padding: const EdgeInsetsDirectional.only(end: 8), child: ActionChip(label: Text(label), onPressed: () => _toast(context, 'تصنيف $label — يلزم ربط قائمة الغرف الحية.'))).toList())),
        const SizedBox(height: 18),
        const SectionTitle(title: 'غرف مقترحة', action: 'عرض الكل'),
        const SizedBox(height: 8),
        for (final room in rooms) RoomCard(room: room),
        const SizedBox(height: 12),
        const SectionTitle(title: 'الأصول المرئية'),
        const SizedBox(height: 9),
        Row(children: const [AssetPreview(path: 'assets/gifts/royal_gift.svg', label: 'هدية ملكية'), SizedBox(width: 10), AssetPreview(path: 'assets/badges/vip_badge.svg', label: 'شارة VIP')]),
        const SizedBox(height: 8),
        Text('رسومات SVG أصلية أولية. النماذج الفعلية بصيغ GLB/BLEND غير مرفقة حتى الآن.', style: TextStyle(color: Colors.white.withValues(alpha: .52), fontSize: 12)),
      ]);
}

class RoomInfo {
  const RoomInfo(this.name, this.description, this.listeners, this.category, this.colors);
  final String name, description, category;
  final int listeners;
  final List<Color> colors;
}

class RoomCard extends StatelessWidget {
  const RoomCard({super.key, required this.room});
  final RoomInfo room;
  @override
  Widget build(BuildContext context) => Container(margin: const EdgeInsets.only(bottom: 10), decoration: BoxDecoration(gradient: LinearGradient(colors: room.colors), borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white.withValues(alpha: .08))), child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: Container(width: 46, height: 46, decoration: BoxDecoration(color: purple.withValues(alpha: .22), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.graphic_eq_rounded, color: gold)),
        title: Text(room.name, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text('${room.description} · ${room.category}', style: TextStyle(color: Colors.white.withValues(alpha: .63))),
        trailing: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.headphones_rounded, size: 17, color: gold), Text('${room.listeners}')]),
        onTap: () => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => RoomPage(room: room))),
      ));
}

class RoomPage extends StatefulWidget {
  const RoomPage({super.key, required this.room});
  final RoomInfo room;
  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  bool micOn = false;
  bool joined = false;
  final Set<int> occupied = {0};
  final messages = <String>['مرحبًا بكم في المجلس!'];
  final input = TextEditingController();
  @override
  void dispose() { input.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(widget.room.name), actions: [IconButton(onPressed: () => _toast(context, 'نسخ رابط الغرفة يتطلب خدمة مشاركة.'), icon: const Icon(Icons.share_outlined))]),
        body: Column(children: [
          Expanded(child: ListView(padding: const EdgeInsets.all(16), children: [
            Container(height: 130, decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), gradient: LinearGradient(colors: widget.room.colors)), child: Stack(children: [Positioned.fill(child: ClipRRect(borderRadius: BorderRadius.circular(20), child: SvgPicture.asset('assets/rooms/royal_stage.svg', fit: BoxFit.cover))), Center(child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.graphic_eq, size: 32, color: gold), Text(widget.room.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19)), Text('${widget.room.listeners} مستمعًا · ${widget.room.category}')]))])),
            const SizedBox(height: 16),
            const Text('مقاعد المتحدثين', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: 8, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 10, crossAxisSpacing: 8), itemBuilder: (context, index) {
              final isOccupied = occupied.contains(index);
              return InkWell(borderRadius: BorderRadius.circular(16), onTap: () => setState(() { if (isOccupied && index == 0) { _toast(context, 'مقعد المضيف.'); } else if (isOccupied) { occupied.remove(index); } else { occupied.add(index); joined = true; } }), child: Column(children: [Container(width: 54, height: 54, decoration: BoxDecoration(shape: BoxShape.circle, color: isOccupied ? purple.withValues(alpha: .36) : panel, border: Border.all(color: isOccupied ? gold : Colors.white12)), child: Icon(isOccupied ? Icons.person : Icons.mic_none, color: isOccupied ? gold : Colors.white70)), const SizedBox(height: 4), Text(isOccupied ? (index == 0 ? 'المضيف' : 'أنت') : '${index + 1}', style: const TextStyle(fontSize: 12))]));
            }),
            const SizedBox(height: 16),
            const Text('محادثة الغرفة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            for (final message in messages) ListTile(dense: true, leading: const CircleAvatar(radius: 15, backgroundColor: purple, child: Icon(Icons.person, size: 16)), title: Text(message)),
          ])),
          SafeArea(top: false, child: Padding(padding: const EdgeInsets.fromLTRB(12, 8, 12, 10), child: Row(children: [
            IconButton.filledTonal(onPressed: () => _showGifts(context), icon: const Icon(Icons.card_giftcard, color: pink)),
            IconButton.filledTonal(onPressed: () => setState(() => micOn = !micOn), icon: Icon(micOn ? Icons.mic : Icons.mic_off, color: micOn ? gold : null)),
            Expanded(child: TextField(controller: input, decoration: const InputDecoration(hintText: 'اكتب رسالة...', border: OutlineInputBorder(), isDense: true), onSubmitted: (_) => _send())),
            IconButton(onPressed: _send, icon: const Icon(Icons.send_rounded, color: purple)),
            const SizedBox(width: 4),
            FilledButton(onPressed: () { setState(() { joined = !joined; if (!joined) { occupied.removeWhere((i) => i != 0); micOn = false; } }); _toast(context, joined ? 'تم الانضمام محليًا — الصوت المباشر غير مربوط.' : 'غادرت العرض المحلي.'); }, child: Text(joined ? 'مغادرة' : 'انضم')),
          ]))),
        ]),
      );
  void _send() { final text = input.text.trim(); if (text.isEmpty) return; setState(() { messages.add(text); input.clear(); }); }
  void _showGifts(BuildContext context) => showModalBottomSheet<void>(context: context, backgroundColor: panel, builder: (context) => SafeArea(child: Padding(padding: const EdgeInsets.all(20), child: Column(mainAxisSize: MainAxisSize.min, children: [const Text('هدايا الغرفة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)), const SizedBox(height: 16), Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [for (final item in [('وردة', Icons.local_florist), ('هدية', Icons.card_giftcard), ('نجمة', Icons.star)]) Column(children: [IconButton(onPressed: () { Navigator.pop(context); _toast(context, 'واجهة عرض فقط؛ إرسال الهدايا والخصم المالي غير مفعّلين.'); }, icon: Icon(item.$2, color: gold, size: 32)), Text(item.$1)])])]))));
}

class InboxPage extends StatelessWidget { const InboxPage({super.key}); @override Widget build(BuildContext context) => const EmptyState(icon: Icons.forum_outlined, title: 'الرسائل', detail: 'اربط Supabase Realtime لإتاحة المحادثات الفعلية.'); }
class CreatePage extends StatelessWidget { const CreatePage({super.key}); @override Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.add_circle_outline, size: 58, color: purple), const SizedBox(height: 12), const Text('إنشاء غرفة', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), const SizedBox(height: 10), const Text('إنشاء الغرف يحتاج إلى حساب مسجل وخدمة خلفية.'), const SizedBox(height: 16), FilledButton.icon(onPressed: () => _toast(context, 'سيُفعّل الإنشاء بعد ربط Supabase Auth وعمليات الخادم.'), icon: const Icon(Icons.add), label: const Text('إعداد غرفة'))]))); }
class RankingPage extends StatelessWidget { const RankingPage({super.key}); @override Widget build(BuildContext context) => const EmptyState(icon: Icons.emoji_events_outlined, title: 'الترتيب', detail: 'ستظهر لوحات المتصدرين بعد تنفيذ المستويات والبيانات الخلفية.'); }
class ProfilePage extends StatelessWidget { const ProfilePage({super.key}); @override Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(18), children: [Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF30204B), Color(0xFF171322)]), borderRadius: BorderRadius.circular(22)), child: const Row(children: [CircleAvatar(radius: 30, backgroundColor: purple, child: Icon(Icons.person, size: 34)), SizedBox(width: 14), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('ملفي الشخصي', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), Text('سجّل الدخول لعرض بياناتك')])])), const SizedBox(height: 16), for (final entry in [('المحفظة', Icons.account_balance_wallet), ('VIP', Icons.workspace_premium), ('العائلة', Icons.groups), ('المهام', Icons.task_alt), ('الإعدادات', Icons.settings)]) Card(color: panel, child: ListTile(leading: Icon(entry.$2, color: gold), title: Text(entry.$1), trailing: const Icon(Icons.chevron_left), onTap: () => _toast(context, '${entry.$1}: يلزم تنفيذ وربط الخدمة.')))]); }
class SearchPage extends StatelessWidget { const SearchPage({super.key}); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('البحث')), body: Padding(padding: const EdgeInsets.all(18), child: TextField(autofocus: true, decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'ابحث عن غرفة أو تصنيف', border: OutlineInputBorder()), onSubmitted: (_) => _toast(context, 'البحث يحتاج إلى فهرس غرف في الخلفية.')))); }
class EmptyState extends StatelessWidget { const EmptyState({super.key, required this.icon, required this.title, required this.detail}); final IconData icon; final String title, detail; @override Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.all(28), child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 58, color: purple), const SizedBox(height: 12), Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), const SizedBox(height: 8), Text(detail, textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withValues(alpha: .62)))]))); }
class SectionTitle extends StatelessWidget { const SectionTitle({super.key, required this.title, this.action}); final String title; final String? action; @override Widget build(BuildContext context) => Row(children: [Expanded(child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800))), if (action != null) TextButton(onPressed: () => _toast(context, 'يتطلب اتصال قاعدة البيانات.'), child: Text(action!))]); }
class AssetPreview extends StatelessWidget { const AssetPreview({super.key, required this.path, required this.label}); final String path, label; @override Widget build(BuildContext context) => Expanded(child: Container(height: 90, decoration: BoxDecoration(color: panel, borderRadius: BorderRadius.circular(16)), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [SizedBox(width: 48, height: 48, child: SvgPicture.asset(path)), const SizedBox(width: 8), Text(label, style: const TextStyle(fontWeight: FontWeight.bold))]))); }
void _toast(BuildContext context, String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text), behavior: SnackBarBehavior.floating));
