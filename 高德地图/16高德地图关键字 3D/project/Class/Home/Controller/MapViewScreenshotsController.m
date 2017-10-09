//
//  MapViewScreenshotsController.m
//  project
//
//  Created by zhouyu on 2017/8/4.
//  Copyright © 2017年 zhouyu. All rights reserved.
//

#import "MapViewScreenshotsController.h"

@interface MapViewScreenshotsController ()<MAMapViewDelegate>
@property (nonatomic, strong) MAMapView *mapView;
@end

@implementation MapViewScreenshotsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    
    __block UIImage *screenshotImage = nil;
    __block NSInteger resState = 0;
    CGRect inRect = CGRectMake(100, 100, 100, 100);
    [self.mapView takeSnapshotInRect:inRect withCompletionBlock:^(UIImage *resultImage, NSInteger state) {
        screenshotImage = resultImage;
        resState = state; // state表示地图此时是否完整，0-不完整，1-完整
    }];
    
    
    [self initToolBar];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.toolbar.barStyle      = UIBarStyleBlack;
    self.navigationController.toolbar.translucent   = YES;
    [self.navigationController setToolbarHidden:NO animated:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setToolbarHidden:YES animated:animated];
}

- (void)mapTypeAction:(UISegmentedControl *)segmentedControl{
    self.mapView.mapType = segmentedControl.selectedSegmentIndex;
}

#pragma mark - Initialization
- (void)initToolBar{
    UIBarButtonItem *flexbleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UISegmentedControl *mapTypeSegmentedControl = [[UISegmentedControl alloc] initWithItems: [NSArray arrayWithObjects:@"标准(Standard)",@"卫星(Satellite)",nil]];
    mapTypeSegmentedControl.selectedSegmentIndex  = self.mapView.mapType;
    [mapTypeSegmentedControl addTarget:self action:@selector(mapTypeAction:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *mayTypeItem = [[UIBarButtonItem alloc] initWithCustomView:mapTypeSegmentedControl];
    self.toolbarItems = [NSArray arrayWithObjects:flexbleItem, mayTypeItem, flexbleItem, nil];
}

@end
