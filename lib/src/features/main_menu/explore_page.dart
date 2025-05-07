import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:read_nest/src/res/app_textstyle.dart';

import '../../data/app_data.dart';
import '../../res/app_colors.dart';
import '../../res/app_icons.dart';

class ExplorePage extends StatefulWidget{
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  int _selectedCategoryIndex = 0;
  final TextEditingController _searchTextController = TextEditingController();


  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
      child: Column(
        spacing: 20,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text("Explore", style: AppTextStyles.headingTextStyle,),
          ),

          TextField(
            controller: _searchTextController,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(99),
                borderSide: BorderSide(color: AppColors.textFieldFillColor)
              ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(99),
                    borderSide: BorderSide(color: AppColors.textFieldFillColor)
                ),
              fillColor: AppColors.textFieldFillColor,
              filled: true,
              prefixIcon: Icon(Icons.search_rounded, color: Colors.grey,),
              hintText: "Search...",
              hintStyle: AppTextStyles.regularTextStyle.copyWith(color: Colors.grey),
              suffixIcon: Icon(Icons.filter_list_rounded),
            ),
            onTapOutside: (val)=> FocusManager.instance.primaryFocus?.unfocus(),
          ),
          SizedBox(
            height: 45,
            width: double.infinity,
            child: ListView.builder(
                itemCount: AppDate.genres.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, index){
                  bool isSelected = _selectedCategoryIndex == index;
                  return InkWell(
                    onTap: ()=> setState(() =>  _selectedCategoryIndex = index),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15,),
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(99),
                          border: Border.all(color: isSelected ? Colors.transparent : AppColors.textFieldFillColor),
                          color: isSelected ? AppColors.primaryColor.withOpacity(0.2) : Colors.white
                      ),
                      alignment: Alignment.center,
                      child: Text(AppDate.genres[index], textAlign: TextAlign.center, style: AppTextStyles.regularTextStyle.copyWith(color: isSelected ? AppColors.primaryColor : Colors.black, fontWeight: FontWeight.w600),),
                    ),
                  );
                }),
          ),

          SizedBox(
            height: size.height*0.35,
            child: ListView.builder(
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, index){
                  return Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  color: AppColors.textFieldFillColor
                              ),
                              margin: EdgeInsets.only(right: 15),
                              child:  ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(imageUrl: AppIcons.dummyBookImageUrl2)),
                            ),
                            Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(99)
                                  ),
                                  child: Text("50% off", style: AppTextStyles.regularTextStyle.copyWith(color: Colors.white),),
                                )),
                            Positioned(
                                right: 20,
                                top: 0,
                                child: IconButton(
                                  onPressed: (){}, icon: Icon(Icons.favorite, color: Colors.red,),
                                  style: IconButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      backgroundColor: Colors.white
                                  ),
                                ))
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(right: 15), child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("The trials of appollo",overflow: TextOverflow.ellipsis, style: AppTextStyles.titleTextStyle,),
                          Text("Greek mythology", style: AppTextStyles.regularTextStyle.copyWith(color: Colors.grey),)
                        ],
                      ),)
                    ],
                  );
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Recommendation", style: AppTextStyles.titleTextStyle,),
              TextButton(onPressed: (){}, child: Text("See All", style: AppTextStyles.regularTextStyle.copyWith(fontWeight: FontWeight.w700),))
            ],
          ),

          Column(
            children: List.generate(5, (index){
              return Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Row(
                  spacing: 10,
                  children: [
                    SizedBox(
                      height: 75,
                      width: 75,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(imageUrl: AppIcons.dummyBookImageUrl,fit: BoxFit.cover,),
                      ),
                    ),
                    Expanded(child: Column(
                      children: [
                        Text("Fantasy", style: AppTextStyles.regularTextStyle,),
                        Text("The trials of appollo", style: AppTextStyles.titleTextStyle,),
                        Row(
                          children: List.generate(4, (index){
                            return Icon(Icons.star, color: Colors.yellow,);
                          }),
                        )
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                    )
                  ],
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}