import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Column headLine ({required Color color, required String text,required IconData iconData, Function? onTap}){
  return Column(
    children: [
      InkWell(
        onTap: (){
          if(onTap != null){
            onTap();
          }
        },
        child: Container(
          height: 50,
          width: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(7),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                spreadRadius: 1,
                blurRadius: 4
              )
            ]
          ),
           child: Icon(iconData,color: Colors.white,)
        ),
      ),
      SizedBox(height: 5),
      Text(text,style: const TextStyle(fontSize: 12),)
    ],
  );
}
Column featured ({required Color color, required String text,required Alignment alignment, required Size size}){
  return Column(
    children: [
      Container(
        height: 100,
        width: size.width * 0.46,
        padding: EdgeInsets.all(10),
        alignment: alignment,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(7)
        ),
        child: Text(text),
      ),
    ],
  );
}

Column mostPopular({required String text, required Size size, required String image,required Function onTap}) {
  return  Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      InkWell(
        onTap: (){
          onTap();
        },
        child: Container(
          height: 110,
          width: size.width * 0.46,
          margin: const EdgeInsets.only(bottom: 5),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 1,
                    blurRadius: 3
                )
              ]
          ),
          child: ClipRRect(borderRadius:BorderRadius.circular(10),child: Image.asset(image,fit: BoxFit.cover,)),
        ),
      ),

      Text(text,style: const TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.w500),)
    ],
  );
}