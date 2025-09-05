import 'package:flutter/material.dart';
import 'package:read_nest/src/res/app_textstyle.dart';

class SearchPage extends StatefulWidget{
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Discover", style: AppTextStyles.regularTextStyle,),
              Icon(Icons.filter_alt_rounded)
            ],
          ),

        ],
      ),
    );
  }
}