import 'package:flutter/material.dart';
import 'package:read_nest/src/res/app_textstyle.dart';

import '../../res/app_colors.dart';

class SearchPage extends StatefulWidget{
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchTextEditingController = TextEditingController();
  List<String>  _trendingSearches = [
    'Productivity', 'Motivation', 'Leadership', 'Business',  'Money', 'Psychology'
  ];
  String _selectedTrending = '';
  @override
  Widget build(BuildContext context) {
    return Padding(
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
}