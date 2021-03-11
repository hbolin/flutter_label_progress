import 'package:flutter/material.dart';
import 'package:flutter_label_progress/src/label_progress.dart';

/// 测试页面
class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('测试LabelProgress'),
      ),
      body: Column(
        children: [
          // 水平的标签指示器
          LabelProgress.text(
            selectedStart: 1,
            selectedEnd: 2,
            unSelectedLineColor: Colors.black,
            selectedLineColor: Colors.red,
            unSelectedNodeColor: Colors.black,
            selectedNodeColor: Colors.green,
            lineThickness: 5,
            nodeLineSpace: 20,
            nodeTextStyle: TextStyle(color: Colors.yellow),
            unSelectedTextStyle: TextStyle(color: Colors.black),
            selectedTextStyle: TextStyle(color: Colors.red),
            nodeLabelSpacing: 30,
            labels: [
              '企业信息',
              '法人信息',
              '法人人脸识别',
            ],
          ),
          // 水平的标签指示器:可以滚动
          LabelProgress.text(
            selectedStart: 1,
            selectedEnd: 2,
            // unSelectedLineColor: Colors.black,
            // selectedLineColor: Colors.red,
            // unSelectedNodeColor: Colors.black,
            // selectedNodeColor: Colors.green,
            // lineThickness: 5,
            // nodeLineSpace: 20,
            // nodeTextStyle: TextStyle(color: Colors.yellow),
            // unSelectedTextStyle: TextStyle(color: Colors.black),
            // selectedTextStyle: TextStyle(color: Colors.red),
            // nodeLabelSpacing: 30,
            isScrollable: true,
            // labelsSparing: 30,
            labels: [
              '企业信息',
              '法人信息',
              '法人人脸识别',
              '企业信息',
              '法人信息',
              '法人人脸识别',
              '企业信息',
              '法人信息',
              '法人人脸识别',
              '企业信息',
              '法人信息',
              '法人人脸识别',
            ],
          ),
          // 自定义指示器和标签
          LabelProgress(
            selectedStart: 1,
            selectedEnd: 2,
            count: 4,
            builder: (BuildContext context, int index, bool selected) {
              return Column(
                children: [
                  Text('标题$index'),
                  Text('小标题$index'),
                ],
              );
            },
            nodeBuilder: (BuildContext context, int index, bool selected) {
              return selected
                  ? Icon(
                Icons.check,
                color: Colors.blue,
              )
                  : Icon(Icons.error, color: Colors.grey);
            },
          ),
          // 竖直的标签指示器
          Expanded(
            child: LabelProgress.text(
              selectedStart: 1,
              selectedEnd: 2,
              direction: Axis.vertical,
              isScrollable: true,
              labels: [
                '企业信息',
                '法人信息',
                '法人人脸识别',
                '企业信息',
                '法人信息',
                '法人人脸识别',
                '企业信息',
                '法人信息',
                '法人人脸识别',
                '企业信息',
                '法人信息',
                '法人人脸识别',
              ],
            ),
          ),
          // 自定义指示器和标签
          Expanded(
            child: LabelProgress(
              selectedStart: 1,
              selectedEnd: 2,
              count: 20,
              direction: Axis.vertical,
              isScrollable: true,
              builder: (BuildContext context, int index, bool selected) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('标题$index'),
                    Text('小标题$index'),
                  ],
                );
              },
              nodeBuilder: (BuildContext context, int index, bool selected) {
                return selected
                    ? Icon(
                  Icons.check,
                  color: Colors.blue,
                )
                    : Icon(Icons.error, color: Colors.grey);
              },
            ),
          ),
        ],
      ),
    );
  }
}