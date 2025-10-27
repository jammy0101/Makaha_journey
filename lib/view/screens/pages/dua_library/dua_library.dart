//
// import 'package:flutter/material.dart';
// import '../../../../model/dua_data/dua_data.dart';
// import '../../../../model/dua_model/dua_model.dart';
// import '../../../../resources/buttom_navigation_bar/buttom_navigation.dart';
// import '../../widgets/dua_card/dua_card.dart';
// import '../../widgets/dua_detils_page/dua_detils.dart';
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
//             // return DuaCard(
//             //   imagePath: dua.imagePath,
//             //   title: dua.title,
//             //   onTap: () {
//             //     Navigator.push(
//             //       context,
//             //       MaterialPageRoute(
//             //         builder: (_) => DuaDetailPage(
//             //           title: dua.title,
//             //           imagePath: dua.imagePath,
//             //           description: dua.description, // ✅ added
//             //         ),
//             //       ),
//             //     );
//             //   },
//             // );
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
//
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
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Dua Library'),
//           centerTitle: true,
//           bottom: TabBar(
//             controller: _tabController,
//             indicatorColor: isDark ? Colors.white : Colors.black,
//             labelColor: isDark ? Colors.white : Colors.black,
//             unselectedLabelColor:
//             isDark ? Colors.grey[500] : Colors.grey[400],
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
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final duas = snapshot.data ?? [];

        if (duas.isEmpty) {
          return const Center(child: Text('No Duas Available'));
        }

        return ListView.builder(
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

    final Color indicatorColor = AppColor.gold;
    final Color selectedLabelColor = isDark ? AppColor.gold : AppColor.deepCharcoal;
    final Color unselectedLabelColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dua Library'),
          centerTitle: true,
          backgroundColor: isDark ? AppColor.deepCharcoal : AppColor.gold,
          foregroundColor: isDark ? AppColor.gold : AppColor.whiteColor,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: indicatorColor,
            labelColor: selectedLabelColor,
            unselectedLabelColor: unselectedLabelColor,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: 'Hajj'),
              Tab(text: 'Umrah'),
              Tab(text: 'Masnoon Duas'),
            ],
          ),
        ),
        bottomNavigationBar: const BottomNavigation(index: 1),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildDuaList(DuaData.fetchHajjDuas()),
            _buildDuaList(DuaData.fetchUmrahDuas()),
            _buildDuaList(DuaData.fetchMasnoonDuas()),
          ],
        ),
      ),
    );
  }
}
