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
          Text('水平的标签指示器'),
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
            nodeLabelSpacing: 10,
            labels: [
              '标签1',
              '标签2',
              '标签3',
            ],
          ),
          Padding(padding: const EdgeInsets.only(top: 20)),
          // 水平的标签指示器:可以滚动
          Text('水平的标签指示器:可以滚动'),
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
              '标签1',
              '标签2',
              '标签3',
              '标签4',
              '标签5',
              '标签6',
              '标签7',
              '标签8',
              '标签9',
              '标签10',
            ],
          ),
          Padding(padding: const EdgeInsets.only(top: 20)),
          // 自定义节点和标签
          Text('自定义节点和标签'),
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
                      Icons.check_circle,
                      color: Colors.blue,
                    )
                  : Icon(Icons.error, color: Colors.grey);
            },
          ),
          Padding(padding: const EdgeInsets.only(top: 20)),
          // 竖直的标签指示器
          Text('竖直的标签指示器'),
          Expanded(
            child: LabelProgress.text(
              selectedStart: 1,
              selectedEnd: 2,
              direction: Axis.vertical,
              isScrollable: true,
              labels: [
                '标签1',
                '标签2',
                '标签3',
                '标签4',
                '标签5',
                '标签6',
                '标签7',
              ],
            ),
          ),
          Padding(padding: const EdgeInsets.only(top: 20)),
          // 自定义节点和标签
          Text('自定义节点和标签：竖直方向'),
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
                        Icons.check_circle,
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
