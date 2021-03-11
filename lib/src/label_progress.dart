import 'package:flutter/material.dart';

typedef IndexedSelectedWidgetBuilder = Widget Function(BuildContext context, int index, bool selected);

typedef NodeSelectedWidgetBuilder = Widget Function(BuildContext context, int index, bool selected);

/// Author:       hbolin
/// Date:         2021/03/10 10:46 PM
/// Description:  显示标签的进度条
class LabelProgress extends StatelessWidget {
  /// 选中的开始
  final int selectedStart;

  /// 选中结束
  final int selectedEnd;

  /// 未选中节点的背景色
  final Color unSelectedNodeColor;

  /// 选中节点的背景色
  final Color selectedNodeColor;

  /// 未选中线的颜色
  final Color unSelectedLineColor;

  /// 选中线的颜色
  final Color selectedLineColor;

  /// 线的粗细
  final double lineThickness;

  /// 节点和线之间的间隔
  final double nodeLineSpace;

  /// 节点和底部标签的间隔
  final double nodeLabelSpacing;

  /// 一共有几项
  final int count;

  /// 底部组件的实现代理
  final LabelProgressChildDelegate delegate;

  /// 方向:水平或者竖直
  final Axis direction;

  /// 是否可以滚动
  final bool isScrollable;

  /// 2个标签之间的间隔，仅在isScrollable为true的时候有效
  final double labelsSparing;

  /// 自定义底部组件
  LabelProgress({
    Key key,
    this.selectedStart = 0,
    @required this.selectedEnd,
    this.unSelectedLineColor,
    this.selectedLineColor,
    this.unSelectedNodeColor,
    this.selectedNodeColor,
    this.lineThickness = 2,
    this.nodeLineSpace = 4,
    this.nodeLabelSpacing = 6,
    this.direction = Axis.horizontal,
    this.isScrollable = false,
    this.labelsSparing = 20,
    @required this.count,
    @required IndexedSelectedWidgetBuilder builder,
    @required NodeSelectedWidgetBuilder nodeBuilder,
  })  : delegate = LabelProgressChildBuilderDelegate(builder, nodeBuilder),
        assert(selectedEnd != null),
        assert(count != null && count >= 0),
        assert(builder != null),
        super(key: key);

  /// 显示单行本文
  LabelProgress.text({
    Key key,
    this.selectedStart = 0,
    @required this.selectedEnd,
    this.unSelectedLineColor,
    this.selectedLineColor,
    this.unSelectedNodeColor,
    this.selectedNodeColor,
    this.lineThickness = 2,
    this.nodeLineSpace = 4,
    this.nodeLabelSpacing = 6,
    this.direction = Axis.horizontal,
    this.isScrollable = false,
    this.labelsSparing = 20,
    @required List<String> labels,
    TextStyle selectedTextStyle,
    TextStyle unSelectedTextStyle,
    bool needNodeIndex = true, // 是否需要1，2，3...的顺序
    TextStyle nodeTextStyle,
  })  : count = labels.length,
        delegate = LabelProgressChildBuilderDelegate((BuildContext context, int index, bool selected) {
          var element = labels[index];
          return Text(
            '$element',
            style: selected
                ? (selectedTextStyle ??
                    Theme.of(context).textTheme.caption.copyWith(
                          color: Theme.of(context).primaryColor,
                        ))
                : (unSelectedTextStyle ?? Theme.of(context).textTheme.caption),
          );
        }, (BuildContext context, int index, bool selected) {
          Color nodeColor = unSelectedNodeColor ?? Theme.of(context).dividerColor;
          if (selected) {
            nodeColor = selectedNodeColor ?? Theme.of(context).primaryColor;
          }
          return Material(
            shape: CircleBorder(
              side: BorderSide.none,
            ),
            color: nodeColor,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: needNodeIndex
                  ? Text(
                      '$index',
                      style: nodeTextStyle ??
                          Theme.of(context).textTheme.overline.copyWith(
                                color: Colors.white,
                                height: 1,
                              ),
                    )
                  : SizedBox.shrink(),
            ),
          );
        }),
        assert(selectedEnd != null),
        assert(labels != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // 节点
    List<Widget> nodeChildren = [];
    for (int i = 0; i < count; i++) {
      Widget node;
      switch (direction) {
        case Axis.vertical:
          node = _buildProgressItemVertical(context, i);
          if (!isScrollable) {
            node = Expanded(child: node);
          }
          break;
        case Axis.horizontal:
        default:
          node = _buildProgressItemHorizontal(context, i);
          if (!isScrollable) {
            node = Expanded(child: node);
          }
          break;
      }
      nodeChildren.add(node);
    }

    // 底部
    List<Widget> children = [];
    for (int i = 0; i < count; i++) {
      bool selected = selectedStart <= i && i <= selectedEnd;
      Widget child = Center(child: delegate.build(context, i, selected));
      if (!isScrollable) {
        child = Expanded(child: child);
      }
      children.add(child);
    }

    switch (direction) {
      case Axis.vertical:
        return _buildVertical(context, nodeChildren, children);
      case Axis.horizontal:
      default:
        return _buildHorizontal(context, nodeChildren, children);
    }
  }

  Widget _buildHorizontal(BuildContext context, List<Widget> nodeChildren, List<Widget> children) {
    assert(nodeChildren.length == children.length);

    if (isScrollable) {
      List<Widget> temp = [];
      for (int i = 0; i < nodeChildren.length; i++) {
        temp.add(IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              nodeChildren[i],
              SizedBox(height: nodeLabelSpacing),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: labelsSparing),
                child: children[i],
              ),
            ],
          ),
        ));
      }
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: temp,
        ),
      );
    } else {
      return Column(
        children: [
          Row(
            children: nodeChildren,
          ),
          SizedBox(height: nodeLabelSpacing),
          Row(
            children: children,
          ),
        ],
      );
    }
  }

  Widget _buildVertical(BuildContext context, List<Widget> nodeChildren, List<Widget> children) {
    if (isScrollable) {
      List<Widget> temp = [];
      for (int i = 0; i < nodeChildren.length; i++) {
        temp.add(IntrinsicHeight(
          child: Row(
            children: [
              Container(
                constraints: BoxConstraints(
                  minWidth: 36,
                ),
                alignment: Alignment.center,
                child: nodeChildren[i],
              ),
              SizedBox(width: nodeLabelSpacing),
              Padding(
                padding: EdgeInsets.symmetric(vertical: labelsSparing),
                child: children[i],
              ),
            ],
          ),
        ));
      }
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: temp,
        ),
      );
    } else {
      return Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: nodeChildren,
          ),
          SizedBox(width: nodeLabelSpacing),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ],
      );
    }
  }

  // 水平的节点
  Widget _buildProgressItemHorizontal(BuildContext context, int index) {
    // 线 默认都是未选中状态
    Color startLineColor = unSelectedLineColor ?? Theme.of(context).dividerColor;
    Color endLineColor = unSelectedLineColor ?? Theme.of(context).dividerColor;
    if (selectedStart < index && index <= selectedEnd) {
      startLineColor = selectedLineColor ?? Theme.of(context).primaryColor;
    }
    if (selectedStart <= index && index < selectedEnd) {
      endLineColor = selectedLineColor ?? Theme.of(context).primaryColor;
    }
    if (index == 0) {
      startLineColor = Colors.transparent;
    } else if (index == (count - 1)) {
      endLineColor = Colors.transparent;
    }
    // 节点 默认都是未选中状态
    bool nodeSelected = selectedStart <= index && index <= selectedEnd;
    return Row(
      children: [
        Expanded(
          child: Container(
            height: lineThickness,
            color: startLineColor,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: nodeLineSpace),
          child: _buildNodeWidget(context, index, nodeSelected),
        ),
        Expanded(
          child: Container(
            height: lineThickness,
            color: endLineColor,
          ),
        ),
      ],
    );
  }

  // 竖直的节点
  Widget _buildProgressItemVertical(BuildContext context, int index) {
    // 线 默认都是未选中状态
    Color startLineColor = unSelectedLineColor ?? Theme.of(context).dividerColor;
    Color endLineColor = unSelectedLineColor ?? Theme.of(context).dividerColor;
    if (selectedStart < index && index <= selectedEnd) {
      startLineColor = selectedLineColor ?? Theme.of(context).primaryColor;
    }
    if (selectedStart <= index && index < selectedEnd) {
      endLineColor = selectedLineColor ?? Theme.of(context).primaryColor;
    }
    if (index == 0) {
      startLineColor = Colors.transparent;
    } else if (index == (count - 1)) {
      endLineColor = Colors.transparent;
    }
    // 节点 默认都是未选中状态
    bool nodeSelected = selectedStart <= index && index <= selectedEnd;
    return Column(
      children: [
        Expanded(
          child: Container(
            color: startLineColor,
            width: lineThickness,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: nodeLineSpace),
          child: _buildNodeWidget(context, index, nodeSelected),
        ),
        Expanded(
          child: Container(
            color: endLineColor,
            width: lineThickness,
          ),
        ),
      ],
    );
  }

  // 创建节点样式
  Widget _buildNodeWidget(BuildContext context, int index, bool selected) {
    return delegate.nodeBuild(context, index, selected);
  }
}

abstract class LabelProgressChildDelegate {
  const LabelProgressChildDelegate();

  Widget build(BuildContext context, int index, bool selected);

  Widget nodeBuild(BuildContext context, int index, bool selected);
}

class LabelProgressChildBuilderDelegate extends LabelProgressChildDelegate {
  final IndexedSelectedWidgetBuilder builder;
  final NodeSelectedWidgetBuilder nodeBuilder;

  LabelProgressChildBuilderDelegate(this.builder, this.nodeBuilder);

  @override
  Widget build(BuildContext context, int index, bool selected) {
    return builder(context, index, selected);
  }

  @override
  Widget nodeBuild(BuildContext context, int index, bool selected) {
    return nodeBuilder(context, index, selected);
  }
}
