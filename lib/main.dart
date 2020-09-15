import 'dart:async';

import 'package:cloud_music/page/splash_page.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_music/base_framework/config/app_config.dart';
import 'package:cloud_music/base_framework/config/global_provider_manager.dart';
import 'package:cloud_music/base_framework/view_model/app_model/locale_model.dart';

import 'package:cloud_music/page/exception/exception_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:reflectable/reflectable.dart';

import 'base_framework/config/router_manager.dart';
import 'generated/l10n.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  ///横竖屏
//  SystemChrome.setPreferredOrientations([
//    DeviceOrientation.portraitUp,
//    DeviceOrientation.portraitDown
//  ]);

  await AppConfig.init();



  runZoned((){
    ErrorWidget.builder = (FlutterErrorDetails details){
      Zone.current.handleUncaughtError(details.exception, details.stack);
      ///出现异常时会进入下方页面（flutter原有的红屏），
      return ExceptionPageState(details.exception.toString(),details.stack.toString()).generateWidget();
    };
  },onError: (Object object,StackTrace trace){
    ///你可以将下面日志上传到服务器，用于release后的错误处理
    debugPrint(object);
    debugPrint(trace.toString());
  });
  runApp(MyApp());
  //状态栏置透明
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ///设计图尺寸
    setDesignWHD(750, 1334,density: 1.0);

    return OKToast(
      child: MultiProvider(
          providers: providers,
        child: Consumer<LocaleModel>(
          builder: (ctx,localModel,child){
            return RefreshConfiguration(
              hideFooterWhenNotFull: true,//列表数据不满一页,不触发加载更多
              child: MaterialApp(
                navigatorKey: navigatorKey,
//                theme: ThemeData(
//                  //项目配置字体，其他主题颜色配置的可以百度
////                  fontFamily: Theme.of(context).platform == TargetPlatform.android? (localModel.localeIndex == 1 ?  "HanSans":"DIN") : "IOSGILROY",
//                ),
                debugShowCheckedModeBanner: false,
                locale: localModel.locale,
                //国际化工厂代理
                localizationsDelegates: [
                  // Intl 插件（需要安装）
                  S.delegate,
                  RefreshLocalizations.delegate, //下拉刷新
                  //系统控件 国际化
                  GlobalCupertinoLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate//文本方向等
                ],
                supportedLocales: S.delegate.supportedLocales,
                navigatorObservers: [
                  routeObserver
                ],
              home: SplashPage().generateWidget(),
              ///改版啦，这里用不到，你可以删除
//                onGenerateRoute: Router.generateRoute,
//                onUnknownRoute: (settings){
//                  return PageRouteBuilder(pageBuilder: (ctx,_,__){
//                    return UnKnowPage();
//                  });
//                },
//                initialRoute: RouteName.demo_page,
              ),
            );
          }),),
    );
  }
}



/*
* 在此处添加(修改)你要执行的方法，之后在terminal运行下方代码
* flutter packages pub run build_runner build
*
* 为了避免顺序错误导致的参数异常，这里不使用positionalArguments
*
*
* 注意： 此类内的方法请全部使用-命名参数- 即 ： {String a} 这样
* 避免顺序不一致导致的执行错误
*
* 参数/返回支持类型 (null,bool,num,String,double)
* 或者包含以上类型的 list,map
*
* 注意： 请勿使用任何dart:ui内的东西（即flutter的代码）
* */

@myReflect
class WorkList{

  test({String n,String m}){
    print('  test method   $n');
  }


}


const myReflect = MyReflectable();

class MyReflectable extends Reflectable{
  const MyReflectable():super(invokingCapability);
}




