import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:read_nest/src/features/summary_detail_page/summary_insights_widget.dart';
import 'package:read_nest/src/features/summary_detail_page/summary_overview_widget.dart';
import 'package:read_nest/src/features/summary_detail_page/summary_related_books.dart';
import 'package:read_nest/src/models/book_model.dart';
import 'package:read_nest/src/res/app_colors.dart';
import 'package:read_nest/src/res/app_textstyle.dart';

class SummaryDetailPage extends StatelessWidget{
  const SummaryDetailPage({super.key, required Book book}) : _book = book;
  final Book _book;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          elevation: 0,
          actions: [
            IconButton(onPressed: (){}, icon: Icon(Icons.share)),
            IconButton(onPressed: (){}, icon: Icon(Icons.favorite_border_rounded)),
          ],
        ),
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverOverlapAbsorber(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        spacing: 20,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: size.height*0.35,
                            child: Center(
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: CachedNetworkImage(imageUrl: _book.image, fit: BoxFit.cover,)),
                            ),
                          ),
                          Column(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_book.bookName, style: AppTextStyles.regularTextStyle.copyWith(fontWeight: FontWeight.w600),),
                              Text(_book.author, style: AppTextStyles.smallTextStyle),
                              Row(
                                spacing: 10,
                                children: [
                                  Container(
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                          color: AppColors.textFieldFillColor,
                                          borderRadius: BorderRadius.circular(99)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          spacing: 4,
                                          children: [
                                            Icon(Icons.access_time_outlined, size: 18,),
                                            Text('15 min', style: AppTextStyles.smallTextStyle.copyWith(fontSize: 12, fontWeight: FontWeight.w600),)
                                          ],
                                        ),
                                      )),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        spacing: 10,
                                        children: List.generate(_book.categories.length, (index){
                                          return Container(
                                              padding: EdgeInsets.all(3),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(99),
                                                  border: Border.all(color: Colors.grey)
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                                child: Text(_book.categories[index], style: AppTextStyles.smallTextStyle.copyWith(fontSize: 12, fontWeight: FontWeight.w600),)
                                              ));
                                        })
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                spacing: 10,
                                children: [
                                  Expanded(child: _buildReadingListeningBtn(isReading: true, title: 'Start reading',)),
                                  Expanded(child: _buildReadingListeningBtn(isReading: false, title: 'Start listening')),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _TabBarDelegate(
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(99),
                          color: AppColors.textFieldFillColor,
                        ),
                        child: TabBar(
                          tabs: [
                            Tab(text: 'Overview'),
                            Tab(text: 'Insights'),
                            Tab(text: 'Related'),
                          ],
                          dividerHeight: 0,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorPadding: EdgeInsets.all(5),
                          indicator: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(99)
                          ),
                          labelColor: AppColors.primaryColor,
                          labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600,),
                          unselectedLabelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500,),
                          indicatorColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                Builder(
                  builder: (context) {
                    return CustomScrollView(
                      // key: PageStorageKey('overview'),
                      slivers: [
                        SliverOverlapInjector(
                          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: SummaryOverviewWidget(book: _book,),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Builder(
                  builder: (context) {
                    return CustomScrollView(
                      // key: PageStorageKey('overview'),
                      slivers: [
                        SliverOverlapInjector(
                          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: SummaryInsightsWidget(book: _book,),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Builder(
                  builder: (context) {
                    return CustomScrollView(
                      key: PageStorageKey<String>('related'),
                      slivers: [
                        SliverOverlapInjector(
                          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                        ),
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: SummaryRelatedBooks(),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton _buildReadingListeningBtn({required bool isReading, required String title}) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: isReading ? Colors.black : Colors.white
        ),
        onPressed: () {}, child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 5,
      children: [
        Icon(isReading ? Icons.play_arrow_rounded : Icons.headset_rounded, color: isReading ? Colors.white : Colors.black,),
        Text(title,
          style: AppTextStyles.smallTextStyle.copyWith(color: isReading ? Colors.white : Colors.black),)
      ],
    ));
  }

}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  _TabBarDelegate(this._tabBarContainer);

  final Widget _tabBarContainer;

  @override
  double get minExtent => 50;

  @override
  double get maxExtent => 50;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      alignment: Alignment.centerLeft,
      child: _tabBarContainer,
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}