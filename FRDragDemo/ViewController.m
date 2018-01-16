//
//  ViewController.m
//  FRDragDemo
//
//  Created by Fan's iMac  on 2018/1/15.
//  Copyright © 2018年 Fan's iMac . All rights reserved.
//

#import "ViewController.h"
#import "FRDestView.h"
#import "FRSourceView.h"

@interface ViewController () {
    FRDestView *destView;
    FRSourceView *sourceView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    sourceView = [[FRSourceView alloc] initWithFrame:NSMakeRect(50, 50, 100, 100)];
    sourceView.image = [NSImage imageNamed:@"demopic.png"];
    [self.view addSubview:sourceView];
    //
    destView = [[FRDestView alloc] initWithFrame:NSMakeRect(200, 50, 100, 100)];
    [self.view addSubview:destView];

}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
