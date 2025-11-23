
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
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

  // ------------------------------------------------------------------
  // BUILD DUA LIST
  // ------------------------------------------------------------------
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
              style: TextStyle(
                fontSize: 16,
                color: AppColor.deepCharcoal,
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
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

  // ------------------------------------------------------------------
  // MAIN UI
  // ------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
      isDark ? AppColor.darkBackground : AppColor.whiteCream,

      // --------------------------------------------------------------
      // CUSTOM PREMIUM APPBAR
      // --------------------------------------------------------------
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Dua Library'.tr,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [AppColor.surfaceDark, AppColor.darkBackground]
                  : [AppColor.gold.withOpacity(0.85), AppColor.gold],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),

      // --------------------------------------------------------------
      // TABBAR WITH PREMIUM CARD STYLE
      // --------------------------------------------------------------
      bottomNavigationBar: const BottomNavigation(index: 1),

      body: Column(
        children: [
          // -------------------------- TABBAR CARD --------------------------
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColor.surfaceDark : Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: isDark ? AppColor.gold : Colors.white,
              unselectedLabelColor: Colors.grey[600],
              indicator: BoxDecoration(
                color: AppColor.gold,
                borderRadius: BorderRadius.circular(12),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              tabs: [
                Tab(text: 'Hajj'.tr),
                Tab(text: 'Umrah'.tr),
                Tab(text: 'Masnoon Duas'.tr),
              ],
            ),
          ),

          // -------------------------- TAB CONTENT --------------------------
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDuaList(DuaData.fetchHajjDuas()),
                _buildDuaList(DuaData.fetchUmrahDuas()),
                _buildDuaList(DuaData.fetchMasnoonDuas()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
