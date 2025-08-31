import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:read_nest/src/data/app_data.dart';
import 'package:read_nest/src/res/app_avatars.dart';
import 'package:read_nest/src/res/app_colors.dart';
import 'package:read_nest/src/res/app_constants.dart';
import 'package:read_nest/src/res/app_icons.dart';
import 'package:read_nest/src/res/app_textstyle.dart';

class UpdatedHomePage extends StatefulWidget{
  const UpdatedHomePage({super.key});

  @override
  State<UpdatedHomePage> createState() => _UpdatedHomePageState();
}

class _UpdatedHomePageState extends State<UpdatedHomePage> {
  int _selectedCategoryIndex = 0;
  final TextEditingController _searchTextEditingController = TextEditingController();

  @override
  void dispose() {
    _searchTextEditingController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Column(
        spacing: 20,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 10,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(AppAvatars.avatar1),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hi, Sheraz", style: AppTextStyles.titleTextStyle,),
                      Text("Good Morning", style: AppTextStyles.regularTextStyle,)
                    ],
                  )
                ],
              ),
              IconButton(onPressed: (){}, icon: SvgPicture.asset(AppIcons.icNotification))
            ],
          ),
          SizedBox(
            height: 45,
            child: TextField(
              controller: _searchTextEditingController,
              decoration: InputDecoration(
                fillColor: AppColors.textFieldFillColor,
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
          SizedBox(
            height: 35,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
                itemCount: AppData.genres.length,
                itemBuilder: (ctx, index){
                bool isSelected = _selectedCategoryIndex == index;
                return Padding(
                  padding: const EdgeInsets.only(right: 10.0,),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected ? Colors.black : AppColors.textFieldFillColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(99)
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap
                    ),
                    onPressed: ()=> setState(()=> _selectedCategoryIndex = index), child: Text(AppData.genres[index], textAlign: TextAlign.center, style: AppTextStyles.smallTextStyle.copyWith(color: isSelected ? Colors.white : Colors.black),),),
                );
                  /*return Container(
                    decoration: BoxDecoration(

                      borderRadius: BorderRadius.circular(99)
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    margin: EdgeInsets.only(right: 10),
                    child: Text(AppData.genres[index], textAlign: TextAlign.center, style: AppTextStyles.smallTextStyle,),
                  );*/
            }),
          ),
          Expanded(child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 20, mainAxisSpacing: 20, childAspectRatio: 2/3), itemBuilder: (_, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Stack(
                    children: [
                      CachedNetworkImage(imageUrl: 'https://www.classificationoffice.govt.nz/media/images/killers_of_the_flower_moon.width-1200.jpg', fit: BoxFit.cover, width: double.infinity,),
                      Positioned(
                          right: 10,
                          top: 10,
                          child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                        color: AppColors.textFieldFillColor,
                          shape: BoxShape.circle
                      ),
                        child: Icon(Icons.favorite_border, color: Colors.black45, size: 18,),)),
                      Positioned(
                          left: 10,
                          bottom: 10,
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: AppColors.textFieldFillColor,
                                borderRadius: BorderRadius.circular(99)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Row(
                                spacing: 4,
                                children: [
                                  Icon(Icons.access_time_outlined, size: 18,),
                                  Text('15 min', style: AppTextStyles.smallTextStyle.copyWith(fontSize: 12, fontWeight: FontWeight.w600),)
                                ],
                              ),
                            ))),
                    ],
                  )),
                  Text("Killers of the FLOWER MOON", style: AppTextStyles.smallTextStyle.copyWith(fontWeight: FontWeight.w600),),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text('David Grann', style: AppTextStyles.smallTextStyle.copyWith(fontSize: 12),),
                  )
                ],
              ),
            );
          }))
        ],
      ),
    );
  }
}