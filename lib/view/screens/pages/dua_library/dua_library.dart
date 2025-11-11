//
// import 'package:flutter/material.dart';
// import '../../../../model/dua_data/dua_data.dart';
// import '../../../../model/dua_model/dua_model.dart';
// import '../../../../resources/buttom_navigation_bar/buttom_navigation.dart';
// import '../../widgets/dua_card/dua_card.dart';
// import '../../widgets/dua_detils_page/dua_detils.dart';
// import '../../../../resources/colors/colors.dart';
//
// class DuaLibrary extends StatefulWidget {
//   const DuaLibrary({super.key});
//
//   @override
//   State<DuaLibrary> createState() => _DuaLibraryState();
// }
//
// class _DuaLibraryState extends State<DuaLibrary>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//   }
//
//   Widget _buildDuaList(Future<List<DuaModel>> future) {
//     return FutureBuilder<List<DuaModel>>(
//       future: future,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }
//
//         final duas = snapshot.data ?? [];
//
//         if (duas.isEmpty) {
//           return const Center(child: Text('No Duas Available'));
//         }
//
//         return ListView.builder(
//           itemCount: duas.length,
//           itemBuilder: (context, index) {
//             final dua = duas[index];
//             return DuaCard(
//               imagePath: dua.imagePath,
//               title: dua.title,
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => DuaDetailPage(dua: dua),
//                   ),
//                 );
//               },
//             );
//           },
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//
//     final Color indicatorColor = AppColor.gold;
//     final Color selectedLabelColor = isDark ? AppColor.gold : AppColor.deepCharcoal;
//     final Color unselectedLabelColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;
//
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Dua Library'),
//           centerTitle: true,
//           backgroundColor: isDark ? AppColor.deepCharcoal : AppColor.gold,
//           foregroundColor: isDark ? AppColor.gold : AppColor.whiteColor,
//           bottom: TabBar(
//             controller: _tabController,
//             indicatorColor: indicatorColor,
//             labelColor: selectedLabelColor,
//             unselectedLabelColor: unselectedLabelColor,
//             indicatorWeight: 3,
//             tabs: const [
//               Tab(text: 'Hajj'),
//               Tab(text: 'Umrah'),
//               Tab(text: 'Masnoon Duas'),
//             ],
//           ),
//         ),
//         bottomNavigationBar: const BottomNavigation(index: 1),
//         body: TabBarView(
//           controller: _tabController,
//           children: [
//             _buildDuaList(DuaData.fetchHajjDuas()),
//             _buildDuaList(DuaData.fetchUmrahDuas()),
//             _buildDuaList(DuaData.fetchMasnoonDuas()),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
import 'package:flutter/material.dart';
import '../../../../model/dua_data/dua_data.dart';
import '../../../../model/dua_model/dua_model.dart';
import '../../../../resources/buttom_navigation_bar/buttom_navigation.dart';
import '../../widgets/dua_card/dua_card.dart';
import '../../widgets/dua_detils_page/dua_detils.dart';
import '../../../../resources/colors/colors.dart';

class DuaLibrary extends StatefulWidget {
  const DuaLibrary({super.key});

  @override
  State<DuaLibrary> createState() => _DuaLibraryState();
}

class _DuaLibraryState extends State<DuaLibrary>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  Widget _buildDuaList(Future<List<DuaModel>> future) {
    return FutureBuilder<List<DuaModel>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColor.gold),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: AppColor.error),
            ),
          );
        }

        final duas = snapshot.data ?? [];

        if (duas.isEmpty) {
          return const Center(
            child: Text(
              'No Duas Available',
              style: TextStyle(fontSize: 16, color: AppColor.deepCharcoal),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemCount: duas.length,
          itemBuilder: (context, index) {
            final dua = duas[index];
            return DuaCard(
              imagePath: dua.imagePath,
              title: dua.title,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DuaDetailPage(dua: dua),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColor.deepCharcoal : AppColor.softBeige,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? AppColor.deepCharcoal : AppColor.greyBorder,
        title: const Text(
          'Dua Library',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        foregroundColor: isDark ? AppColor.gold : AppColor.whiteColor,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(55),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? AppColor.surfaceDark : AppColor.whiteColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColor.deepCharcoal.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: isDark ? AppColor.gold : AppColor.deepCharcoal,
              unselectedLabelColor: Colors.grey[500],
              indicator: BoxDecoration(
                color: AppColor.gold.withOpacity(0.85),
                borderRadius: BorderRadius.circular(10),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              tabs: const [
                Tab(text: 'Hajj'),
                Tab(text: 'Umrah'),
                Tab(text: 'Masnoon Duas'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDuaList(DuaData.fetchHajjDuas()),
          _buildDuaList(DuaData.fetchUmrahDuas()),
          _buildDuaList(DuaData.fetchMasnoonDuas()),
        ],
      ),
      bottomNavigationBar: const BottomNavigation(index: 1),
    );
  }
}
