# Drag and drop 

拖拽的时候数据的转移是通过实现了 `NSDraggingInfo` 协议的对象封装的剪切板做到的。


## 想要让你的视图成为拖拽的 destinatioin.

1. 初始化的时候告诉系统，你想让那些类型的文件或者数据拖拽到自己管理的视图区域内。

    ```
    - (void)setup {
        NSArray *pasteboardTypes = @[NSURLPboardType,NSTIFFPboardType];
        [self registerForDraggedTypes:pasteboardTypes];
    }
    ```

2. 需要让视图遵守 NSDraggingDestination 协议

    ```
    //拖拽进入矩形区域时候执行。
    - (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
    //拖拽出矩形区域时候执行。
    - (void)draggingExited:(id<NSDraggingInfo>)sender
    //拖拽进入视图区域，松手的时候判断自己究竟支不支持对应格式.
    - (BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender
    //执行拖拽操作.
    - (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
    ```
    如果不拖出自己的视图区域正常拖入释放的话，调用顺序是
        1. draggingEntered  //拖入
        2. prepareForDragOperation //松手进行判断，拖入准备。
        3. performDragOperation  //执行拖入过程。

    所有拖拽的数据都存放在支持 NSDraggingInfo 协议的对象内部的 pasteBoard 内。即
    
    ```
    //通过 sender.draggingPasteboard 获取数据，
    NSPasteboard *pasteBoard = sender.draggingPasteboard;
    ```
    这部分是系统封装的，开发者不需要操心，用就好了。

3. 一般需要自己实现一个方法判断自己究竟支不支持指定格式。

## 想要让你的视图成为支持拖拽的 source.

1. 想支持拖拽的话需要实现两个协议 `NSDraggingSource` 和 `NSPasteboardItemDataProvider`。
    `NSDraggingSource` 这个协议主要是告诉外部，我在什么样子的场景下支持什么样的拖拽操作。
    
    ```
    - (NSDragOperation)draggingSession:(NSDraggingSession *)session sourceOperationMaskForDraggingContext:(NSDraggingContext)context {
        switch (context) {
            case NSDraggingContextWithinApplication: 
                //程序内拖拽的操作.
                //The operation can be defined by the destination.
                return NSDragOperationGeneric;
                break;
            case NSDraggingContextOutsideApplication:
                //程序之间拖拽的场景.
                return NSDragOperationCopy;
            default:
                break;
        }
    }   
    ```

2. 开始拖拽在鼠标点击的方法里，这里是 `mouseDown` 也有可能在别的地方比如 `mouseTracked`，对 `pasteBoard` 的封装就是在这里进行的。同时 `draggingSession` 就是在这里开始的。

    ```
    - (void)mouseDown:(NSEvent *)event {
        NSPasteboardItem *pasteboardItem = [[NSPasteboardItem alloc] init];
        [pasteboardItem setDataProvider:self forTypes:@[NSPasteboardTypeTIFF]];
    
        NSDraggingItem *draggingItem = [[NSDraggingItem alloc] initWithPasteboardWriter:pasteboardItem];
        [draggingItem setDraggingFrame:self.bounds contents:[self snapshot]];
        [self beginDraggingSessionWithItems:@[draggingItem] event:event source:self];
    }
    ```
3. `NSPasteboardItemDataProvider` 的协议方法 

    ```
    //type 和 item 就是上面初始化 NSPasteboardItem 时候指定的。
    - (void)pasteboard:(NSPasteboard *)sender item:(nonnull NSPasteboardItem *)item provideDataForType:(nonnull NSPasteboardType)type
    ```
    是提供数据源的地方，当在 `destination` 松手要数据源的时候这个方法才会执行。

以上是最简单的拖拽 demo 说明


**Q: 什么是 UTI 类型?**

A: [Uniform Type Identifiers](https://developer.apple.com/library/content/documentation/FileManagement/Conceptual/understanding_utis/understand_utis_intro/understand_utis_intro.html) 

## 参考地址

[详解苹果提供的UTI](https://www.jianshu.com/p/d6fe1e7af9b6)

