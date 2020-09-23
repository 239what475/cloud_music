

import 'package:extended_image/extended_image.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_music/base_framework/utils/image_helper.dart';

/*
* 图片格式是否是webp要等于后端和IOS确定在做更改，目前是webp的
*
* extend_image 更多使用方法：https://github.com/fluttercandies/extended_image/blob/master/README-ZH.md
*
* 图片格式： webp : -w400  -w600 -w1000
* */



class ShowImageUtil{
  ///根据后台协商不同尾缀来加载不同尺寸的图片，可以换成你自己的
  static const String TEST = "";
  static const String W400 = "-w400";
  static const String W600 = "-w600";
  static const String W1000 = "-w1000";

  static const String img50 = '?param=150y150';
  static const String img200 = '?param=200y200';
  static const String imgBanner = '?param=400y200';

  /*
  * show image with default & error widget
  *
  * */
  static Widget showImageWithDefaultError(String url,double width,
      double height,{
    String imageType = TEST,
        double borderRadius = 0,
    Widget defaultImg,
        Widget errorImg,
        BoxFit boxFit : BoxFit.cover}){
    //print("image url ________$url$W400");
    //debugPrint("banner circle radius  : $borderRadius");
    return ClipRRect(
      borderRadius:BorderRadius.all(Radius.circular(borderRadius)) ,
      child: ExtendedImage.network(
        "$url$imageType",
        width: width,
        height: height,
        fit: boxFit,
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        cache: true,
        //不同状态加载不同图片
//      loadStateChanged: (ExtendedImageState state){
//        switch(state.extendedImageLoadState){
//          case LoadState.loading:
//            return Container();
//          case LoadState.completed:
//
//            return ExtendedRawImage(
//                image: state.extendedImageInfo?.image,
//              width: width,
//              height: height,fit: boxFit,);
//          case LoadState.failed:
//          // TODO: Handle this case.
//            return Container();
//          default :
//            return Container();
//        }
//      },
      ),
    );
  }




//  static Widget showImageSmallWithDefaultError(String url,double width,
//      double height,{
//        Widget defaultImg,
//        Widget errorImg,
//        BoxFit boxFit : BoxFit.fill}){
//    return CachedNetworkImage(
//      imageUrl: "$url.small.webp",
//      placeholder: (_,__){
//        return defaultImg??ImageHelper.placeHolderGoodsDefaultImg(width:
//        width,height:
//        height);
//      },
//      errorWidget: (_,__,___){
//        return errorImg??ImageHelper.goodsErrorStatusImg(width: width,height:
//        height);
//      },
//      width: width,height: height,fit: BoxFit.fill,);
//  }

  /// out of stock widget
//  static Widget showOutOfStock(String label,double labelSize,double width,double height){
//    return Container(
//      alignment: Alignment.center,
//      width: width,
//      height: height,
//      color: Color.fromRGBO(229, 229, 229, 0.3),
//      child: Text(
//        "$label",style: TextStyle(color: Colors.white,fontSize: labelSize),
//      ),
//    );
//  }



}