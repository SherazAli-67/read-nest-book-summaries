import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:read_nest/src/res/app_colors.dart';
import 'package:read_nest/src/res/app_textstyle.dart';

class SummaryDetailPage extends StatelessWidget{
  const SummaryDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.share)),
          IconButton(onPressed: (){}, icon: Icon(Icons.favorite_border_rounded)),
        ],
      ),
      body: SafeArea(child: Padding(
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
                    child: CachedNetworkImage(imageUrl: 'https://delivery.happylife.ai/21_Be%20Fearless_Jean%20Case.jpg', fit: BoxFit.cover,)),
              ),
            ),
            Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Think and Grow Rich", style: AppTextStyles.regularTextStyle.copyWith(fontWeight: FontWeight.w600),),
                Text("Napolean Hill", style: AppTextStyles.smallTextStyle),
                Row(
                  spacing: 20,
                  children: [
                   Row(
                     spacing: 5,
                     children: [
                       Icon(Icons.star_rounded, color: Colors.amber,),
                       Text("4.8", style: AppTextStyles.smallTextStyle,)
                     ],
                   ),
                    Row(
                      spacing: 5,
                      children: [
                        Icon(Icons.trending_up, color: Colors.green,),
                        Text("Trending", style: AppTextStyles.smallTextStyle,)
                      ],
                    )
                  ],
                ),
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
                    Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(99),
                          border: Border.all(color: Colors.grey)
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
                        ))
                  ],
                )


              ],
            )
          ],
        ),
      )),
    );
  }

}