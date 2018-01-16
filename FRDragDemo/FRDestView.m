//
//  FRDestView.m
//  FRDragDemo
//
//  Created by Fan's iMac  on 2018/1/16.
//  Copyright © 2018年 Fan's iMac . All rights reserved.
//

#import "FRDestView.h"

@interface FRDestView ()<NSDraggingDestination> {
    NSImage *desImage;

}

@property (nonatomic,assign) BOOL isReceivingDrag;

@end



@implementation FRDestView

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    NSArray *pasteboardTypes = @[NSURLPboardType,NSTIFFPboardType];
    [self registerForDraggedTypes:pasteboardTypes];
}

- (void)setIsReceivingDrag:(BOOL)isReceivingDrag {
    _isReceivingDrag = isReceivingDrag;
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:dirtyRect];
    [[NSColor whiteColor]  setFill];
    [path fill];
    if (self.isReceivingDrag) {
        [[NSColor selectedControlColor] set];
        path.lineWidth = 2;
        [path stroke];
    }
    if (desImage) {
        [desImage drawInRect:dirtyRect];
    }
}

- (BOOL)shouldAllowDrag:(id<NSDraggingInfo>)draggingInfo {
    BOOL canAccept = NO;
    NSDictionary *filteringOptions = @{NSPasteboardURLReadingContentsConformToTypesKey:[NSImage imageTypes]};
    NSPasteboard *pasteBoard = draggingInfo.draggingPasteboard;
    if ([pasteBoard canReadObjectForClasses:@[[NSURL class]] options:filteringOptions]) {
        canAccept = YES;
    }
    //
    if ([pasteBoard.types containsObject:NSTIFFPboardType]) {
        canAccept = YES;
    }
    return canAccept;
}

#pragma mark - NSDraggingDestination Methods

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
    BOOL allow = [self shouldAllowDrag:sender];
    self.isReceivingDrag = allow;
    return self.isReceivingDrag ? NSDragOperationCopy : NSDragOperationNone;
}

- (void)draggingExited:(id<NSDraggingInfo>)sender {
    self.isReceivingDrag = NO;
}

- (BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender {
    BOOL allow = [self shouldAllowDrag:sender];
    return allow;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
    NSDictionary *filteringOptions = @{NSPasteboardURLReadingContentsConformToTypesKey:[NSImage imageTypes]};
    self.isReceivingDrag = NO;
    NSPasteboard *pasteBoard = [sender draggingPasteboard];
    NSPoint point = [self convertPoint:sender.draggingLocation fromView:nil];
    NSArray *urls = [pasteBoard readObjectsForClasses:@[[NSURL class]] options:filteringOptions];
    if (urls.count > 0) {
        NSURL *url = [urls objectAtIndex:0];
        desImage = [[NSImage alloc] initWithContentsOfURL:url];
        [self setNeedsDisplay:YES];
        return YES;
    }
    NSImage *image = [[NSImage alloc] initWithPasteboard:pasteBoard];
    if (image) {
        desImage = image;
        [self setNeedsDisplay:YES];
        return YES;
    }
    return NO;
}

- (void)draggingEnded:(id<NSDraggingInfo>)sender {

}


@end
