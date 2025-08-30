import 'package:flutter/material.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=> Navigator.of(context).pop(),
      child: Align(
        alignment: Alignment.topLeft,
        child: CircleAvatar(
          backgroundColor: Colors.grey[200],
          child: Center(child: IconButton(onPressed: (){
            Navigator.of(context).pop();
          }, icon: Icon(Icons.arrow_back)),),
        ),
      ),
    );
  }
}