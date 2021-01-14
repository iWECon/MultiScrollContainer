# MultiScrollContainer

嵌套滑动 ScrollView Container.

嵌入的 ScrollView (UITableView/UICollectionView/UIScrollView) 只需继承 MultiScrollStateful 协议，并提供协议中的两个属性的默认值即可

除此之外，不需要做任何事情～


如果是 SegmentedController 作为潜入的视图，无需手动处理 ShadowControlable 的逻辑


使用查看 Demo，有空再补文档


#### ContentSize 计算方式
``` swift
// headerView?.height ?? 0
// segmenter.y = header.height
//
// pager.view.y = segmenter.frame.maxY
// pager.view.height = view.frame.height - segmenter.height - (statusBarHeight/navigationBarHeight or other top spacing) ?? 0
//
// scrollView.frame = view.bounds
// scrollView.contentSize.height = view.frame.height + (headerView?.height ?? 0) - (statusBarHeight/navigationBarHeight or other top spacing) ?? 0
```
