import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:read_nest/src/res/app_icons.dart';
import 'package:read_nest/src/res/app_textstyle.dart';
import '../../res/app_colors.dart';

class SearchPage extends StatefulWidget{
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchTextEditingController = TextEditingController();
  final List<String>  _trendingSearches = [
    'Productivity', 'Motivation', 'Leadership', 'Business',  'Money', 'Psychology'
  ];
  String _selectedTrending = '';
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Column(

        spacing: 20,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Discover", style: AppTextStyles.regularTextStyle,),
              Icon(Icons.filter_alt_rounded)
            ],
          ),
          SizedBox(
            height: 45,
            child: TextField(
              controller: _searchTextEditingController,
              decoration: InputDecoration(
                  fillColor: AppColors.textFieldFillColor.withValues(alpha: 0.5),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(99),
                      borderSide: BorderSide(color: Colors.transparent)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(99),
                      borderSide: BorderSide(color: Colors.transparent)
                  ),
                  hintText: 'Search books',
                  hintStyle: AppTextStyles.smallTextStyle,
                  prefixIcon: Icon(Icons.search_rounded)
              ),
            ),
          ),
          _buildTrendingSearches(),
          _buildAuthorsSpotLight(),
          _buildReadingGoals(),
          _buildMostSearchedThisWeek()
        ],
      ),
    );
  }

  _buildTrendingSearches() {
    return Column(
      spacing: 10,
      children: [
        Row(
          spacing: 5,
          children: [
            Icon(Icons.trending_up, color: Colors.black, size: 20,),
            Text("Trending searches", style: AppTextStyles.smallTextStyle,),
          ],
        ),
        Wrap(
          children: _trendingSearches.map((trending){
            bool isSelected = _selectedTrending == trending;
            return Padding(
              padding: const EdgeInsets.only(right: 10.0, bottom: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected ? Colors.black : AppColors.textFieldFillColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(99)
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap
                ),
                onPressed: ()=> setState(()=> _selectedTrending = trending), child: Text(trending, textAlign: TextAlign.center, style: AppTextStyles.smallTextStyle.copyWith(color: isSelected ? Colors.white : Colors.black),),),
            );
          }).toList(),
        )
      ],
    );
  }

  _buildAuthorsSpotLight() {
    return Column(
      spacing: 10,
      children: [
        Row(
          spacing: 5,
          children: [
            Icon(Icons.stars_rounded, color: Colors.black, size: 20,),
            Text("Authors Spotlight", style: AppTextStyles.smallTextStyle,),
          ],
        ),
        SizedBox(
          height: 150,
          child: ListView.builder(

              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (ctx, index){
                return Container(
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Icon(Icons.attach_money_rounded, color: Colors.amber,),
                      Text("Wealth Building", style: AppTextStyles.smallTextStyle.copyWith(fontWeight: FontWeight.w600),),
                      Text('4 books', style: AppTextStyles.smallTextStyle.copyWith(fontSize: 12),),
                      Wrap(
                        spacing: 5,
                        children: List.generate(4, (index){
                          return ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: CachedNetworkImage(imageUrl: AppIcons.dummyBookImageUrl2, height: 25,));
                        }),
                      )
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }

  _buildReadingGoals() {
    return SizedBox(
      height: 450,
      child: Column(
        spacing: 10,
        children: [
          Row(
            spacing: 5,
            children: [
              Icon(Icons.ac_unit_rounded, color: Colors.black, size: 20,),
              Text("Reading Goals", style: AppTextStyles.smallTextStyle,),
            ],
          ),
          Expanded(
            child: GridView.builder(
                itemCount: 4,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 15), itemBuilder: (_, index){
              return Container(
                margin: EdgeInsets.only(right: 10, bottom: 10),
                decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10)
                ),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Icon(Icons.attach_money_rounded, color: Colors.amber,),
                    Text("Wealth Building", style: AppTextStyles.smallTextStyle.copyWith(fontWeight: FontWeight.w600),),
                    Text('4 books', style: AppTextStyles.smallTextStyle.copyWith(fontSize: 12),),
                    Wrap(
                      spacing: 5,
                      children: List.generate(4, (index){
                        return ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: CachedNetworkImage(imageUrl: AppIcons.dummyBookImageUrl2, height: 25,));
                      }),
                    )
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  _buildMostSearchedThisWeek() {
    return Column(
      spacing: 10,
      children: [
        Row(
          spacing: 5,
          children: [
            Icon(Icons.trending_up, color: Colors.black, size: 20,),
            Text("Most Searched This Week", style: AppTextStyles.smallTextStyle,),
          ],
        ),
        Column(
          children: List.generate(3, (index){
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.black,
                radius: 10,
                child: Center(child: Text('${index+1}', style: AppTextStyles.smallTextStyle.copyWith(color: Colors.white, fontSize: 12),),),
              ),
              title: Text('Productivity', style: AppTextStyles.regularTextStyle,),
              subtitle: Text('2.1k searches', style: TextStyle(fontSize: 12, color: Colors.grey),),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  spacing: 2,
                  children: List.generate(2, (index){
                  return ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: CachedNetworkImage(imageUrl: AppIcons.dummyBookImageUrl2, height: 25,));
                }),),
              ),
            );
          }),
        )
      ],
    );
  }
}