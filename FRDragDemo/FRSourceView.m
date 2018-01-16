//
//  FRSourceView.m
//  FRDragDemo
//
//  Created by Fan's iMac  on 2018/1/16.
//  Copyright © 2018年 Fan's iMac . All rights reserved.
//

#import "FRSourceView.h"

@interface FRSourceView()<NSDraggingSource,NSPasteboardItemDataProvider> {

}
@end

@implementation FRSourceView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)mouseDown:(NSEvent *)event {
    NSPasteboardItem *pasteboardItem = [[NSPasteboardItem alloc] init];
    [pasteboardItem setDataProvider:self forTypes:@[NSPasteboardTypeTIFF]];

    NSDraggingItem *draggingItem = [[NSDraggingItem alloc] initWithPasteboardWriter:pasteboardItem];
    [draggingItem setDraggingFrame:self.bounds contents:[self snapshot]];
    [self beginDraggingSessionWithItems:@[draggingItem] event:event source:self];
}

- (NSImage *)snapshot {
    NSData *pdfdata = [self dataWithPDFInsideRect:self.bounds];
    NSImage *image = [[NSImage alloc] initWithData:pdfdata];
    return image;
}

#pragma mark - NSDraggingSource Methods

- (NSDragOperation)draggingSession:(NSDraggingSession *)session sourceOperationMaskForDraggingContext:(NSDraggingContext)context {
    return NSDragOperationGeneric;
}


- (void)pasteboard:(NSPasteboard *)sender item:(nonnull NSPasteboardItem *)item provideDataForType:(nonnull NSPasteboardType)type {
    NSImage *image = [NSImage imageNamed:@"demopic.png"];
    NSData *tiffdata = image.TIFFRepresentation;
    [sender setData:tiffdata forType:type];
    if (type == NSPasteboardTypeTIFF) {
        [sender setData:tiffdata forType:NSPasteboardTypeTIFF];
    }
}


@end
