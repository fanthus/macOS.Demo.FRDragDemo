//
//  ViewController.m
//  FRDragDemo
//
//  Created by Fan's iMac  on 2018/1/15.
//  Copyright © 2018年 Fan's iMac . All rights reserved.
//

#import "ViewController.h"
#import "FRDestView.h"

@interface ViewController () {
    FRDestView *destView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    destView = [[FRDestView alloc] initWithFrame:NSMakeRect(200, 50, 100, 100)];
    [self.view addSubview:destView];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
