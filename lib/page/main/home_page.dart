/*
* Author : LiJiqqi
* Date : 2020/9/15
*/

import 'package:cloud_music/base_framework/widget_state/page_state.dart';
import 'package:cloud_music/page/main/discovery/discovery_page.dart';
import 'package:cloud_music/page/main/discovery/widget/custom_tab_bar.dart';
import 'package:cloud_music/page/main/drawer/drawer_page.dart';
import 'package:cloud_music/page/main/mine/mine_page.dart';
import 'package:cloud_music/page/main/video/video_page.dart';
import 'package:cloud_music/page/main/village/village_page.dart';
import 'package:cloud_music/page/main/widget/music_controll_widget.dart';
import 'package:cloud_music/page/search/search_page.dart';
import 'package:cloud_music/service_api/bedrock_repository_proxy.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'discovery/vm/tabbar_vm.dart';

class HomePage extends PageState{

  TabBarViewModel tabController;

  PageController pageController;

  int pageIndex = 1;

  static double horPadding ;
  static double bottomPadding;

  @override
  void initState() {
    horPadding = getWidthPx(30);
    bottomPadding = getWidthPx(120);
    pageController = PageController(initialPage: 1);
    super.initState();
    pageController.addListener(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return switchStatusBar2Dark(
        child:Container(
          width: getWidthPx(750),height: getHeightPx(1334),
          color: Colors.white,
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              buildAppBar(),
              Expanded(child: Stack(
                children: <Widget>[
                  buildBody(),
                  Positioned(
                    bottom: 0,
                    child: MusicControlWidget().generateWidget(),
                  ),
                ],
              )),
            ],
          ),
        ) );
  }

  Widget buildBody(){
    return PageView(
      controller: pageController,
      onPageChanged: (index){
        tabController.switchPage(index);
        pageIndex = index;
      },
      children: <Widget>[
        wrapWithNotify(MinePage().generateWidget()),
        wrapWithNotify(DiscoveryPage().generateWidget()),
        wrapWithNotify(VillagePage().generateWidget()),
        wrapWithNotify(VideoPage().generateWidget())

      ],
    );
  }

  Widget buildAppBar() {
    return Container(
      //color: Colors.blue,
      width: getWidthPx(750),height: getWidthPx(180),
      padding: EdgeInsets.only(left: horPadding,right: horPadding,
        bottom: getWidthPx(30)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          mineWidget(),
          getSizeBox(width: getWidthPx(40)),
          Expanded(
            child: buildTab(),
          ),
          getSizeBox(width: getWidthPx(40)),
          searchWidget(),
        ],
      ),
    );
  }

  Widget mineWidget() {
    return GestureDetector(
      onTap: (){
        //todo
        push(DrawerPage());
      },
      child: Container(
        width: getWidthPx(80),height: getWidthPx(80),
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: 0,
              child: Icon(Icons.reorder,color: Colors.black,size: getWidthPx(60),),
            ),
            Positioned(
              right: 0,
              top: getWidthPx(20),
              child: msgTip(),
            ),
          ],
        ),
      ),
    );
  }

  Widget msgTip() {
    return Container(
      width: getWidthPx(45),height: getWidthPx(25),
      decoration: BoxDecoration(
        color: Colors.red,borderRadius: BorderRadius.circular(getHeightPx(10))
      ),
      alignment: Alignment.bottomCenter,
      child: Text('45',style: TextStyle(color: Colors.white,fontSize: getSp(18)),),
    );
  }

  Widget searchWidget() {
    return GestureDetector(
      onTap: (){
        push(SearchPage());
      },
      child: Container(
        color: Colors.white,
        width: getWidthPx(60),height: getWidthPx(60),
        child: Icon(Icons.search,color: Colors.black,size: getWidthPx(60),),
      ),
    );
  }

  buildTab() {
    return Container(
      height: getWidthPx(80),
      //color: Colors.greenAccent,
      child: CustomTabBar((controller){
        tabController = controller;
      },(index){
        //tab click
        pageController.jumpToPage(index);
      }).generateWidget(),
    );
  }

  Widget wrapWithRaw(Widget child){
    return RawGestureDetector(
      child: child,
      gestures: <Type,GestureRecognizerFactory>{
        HorizontalDragGestureRecognizer
            : GestureRecognizerFactoryWithHandlers<HorizontalDragGestureRecognizer>(
            ()=>HorizontalDragGestureRecognizer(),
            (HorizontalDragGestureRecognizer instance){
              instance
                ..onDown = _handleDragDown
                ..onStart = _handleDragStart
                ..onUpdate = _handleDragUpdate
                ..onEnd = _handleDragEnd
                ..onCancel = _handleDragCancel;

            }
        )
      },
    );
  }

  void _handleDragDown(DragDownDetails details) {
    log('down');

  }

  void _handleDragStart(DragStartDetails details) {
    log('start');

  }

  void _handleDragUpdate(DragUpdateDetails details) {
    log('update');

  }

  void _handleDragEnd(DragEndDetails details) {
    log('end');

  }

  void _handleDragCancel() {
    log('cancel');

  }

  Widget wrapWithNotify(Widget child){
    return NotificationListener<ScrollNotification>(
      child: child,
      onNotification: handleNotification,
    );
  }


  double after,before;

  double lastPixels;
  Drag drag;
  DragStartDetails dragStartDetails;

  bool canBubble = true;

  bool handleNotification(ScrollNotification notification){
    final ScrollMetrics metrics = notification.metrics;
    final ScrollPosition pos = pageController.position;
//    log('above ${metrics.extentBefore}');
//    log('below ${metrics.extentAfter}');
//    log('inside ${metrics.extentInside}');
    //log('${metrics.pixels}');
    if(notification is ScrollEndNotification){
      log('end');
      canBubble = notification.metrics.atEdge;
      drag = null;
      dragPosition = null;
    }
    if(metrics.axis == Axis.horizontal){
      if(notification is ScrollStartNotification){
        log('start');
        if(notification.dragDetails == null) return true;

        dragStartDetails = notification.dragDetails;
//      if(metrics.atEdge){
//        log('start');
//        drag = pageController.position.drag(notification.dragDetails, () { });
//        drag = null;
//      }
      }
      ///滑动到边缘，例如最小边缘时，继续向右滑动，此时不会触发update
      ///只会触发 start和 end
//      if(notification is ScrollUpdateNotification){
////        log('after  : ${metrics.extentAfter}');
////        log('before : ${metrics.extentBefore}');
//        canBubble = false;
//      }
      ///超边界继续滑动，抬起后会回调一次
      if(notification is UserScrollNotification){
        log('user  : ${notification.direction}');
        if(metrics.pixels == metrics.minScrollExtent && notification.direction == ScrollDirection.forward){
          if(drag == null ){
            drag = pageController.position.drag(dragStartDetails, () {
              drag = null;
            });
          }

        }else if(metrics.pixels == metrics.maxScrollExtent && notification.direction == ScrollDirection.reverse){
          if(drag == null ){
            drag = pageController.position.drag(dragStartDetails, () {
              drag = null;
            });
          }
        }

      }
      //log('$canBubble');
//      if(canBubble){
//        if(metrics.atEdge){
//          log('edge');
//          if(dragStartDetails == null ) return true;
//          drag = pageController.position.drag(dragStartDetails, () {
//            log('cancel');
//            drag = null;
//          });
//        }
//        log(this.runtimeType.toString());
//
//      }
//      if(lastPixels != null){
//        if(metrics.atEdge ){
//          if(drag == null) return true;
//          //log('min ${metrics.minScrollExtent} --- max ${metrics.maxScrollExtent}');
//          final double dis = metrics.pixels - lastPixels;
//          //log('juuuuu   ${((pageIndex+1)*pos.viewportDimension)+dis}');
//          if(dis <0){
//
//            //to right
//            log('to right');
//          }else if(dis > 0){
//            //to left
//            log('to left');
//
//          }
////          if(notification is ScrollUpdateNotification){
////            //log('dis  ${notification.scrollDelta}');
////            if(notification.dragDetails == null) return true;
////            final details = notification.dragDetails;
////            drag.update(details);
////          }
//          //debugPrint('jump to  $dis');
//
//          //pageController.jumpTo(((pageIndex+1)*pos.viewportDimension)+dis);
//          lastPixels = metrics.pixels;
//        }else{
//          lastPixels = metrics.pixels;
//        }
//
//      }else{
//        lastPixels = metrics.pixels;
//      }
    }
//    log('${metrics.pixels}');
//    log('${metrics.axisDirection}');
//    log('${metrics.atEdge}');

    return true;

  }

  void log(String info){
    debugPrint('notification----$info');
  }

}





















