//
//  ViewController.m
//  WaveViewTest
//
//  Created by admin on 16/10/9.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "ViewController.h"
#import "UIWaveView.h"
#import "WaterProgressView.h"

@interface ViewController ()

@property(nonatomic,retain)UIButton* btnLeft;
@property(nonatomic,retain)UIButton* btnRight;
@property(nonatomic,retain)WaterProgressView *waterView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.waterView = [[WaterProgressView alloc] initWithFrame:CGRectMake(50, 50, 260, 180)];
    [self.view addSubview:self.waterView];
    self.waterView.center = CGPointMake(self.view.center.x,self.waterView.center.y);
    
    self.waterView.progress = 1;
//    waveView.singleWave = YES;
    [self.waterView startWave];
    
    CGFloat screenWidth = self.view.frame.size.width;
    CGFloat screenHeight = self.view.frame.size.height;
    CGFloat btnMargin = 10;
    CGFloat btnWidth = 50;
    CGFloat btnHeight = 30;
    
    self.btnLeft.frame = CGRectMake(btnMargin, (screenHeight - btnHeight) / 2, btnWidth ,btnHeight);
//    CGPoint btnLeftCenter = self.btnLeft.center;
//    btnLeftCenter.y = self.view.center.y;
//    self.btnLeft.center = btnLeftCenter;
    
    self.btnRight.frame = CGRectMake(screenWidth - btnWidth - btnMargin, (screenHeight - btnHeight) / 2, btnWidth, btnHeight);
}

-(UIButton *)btnLeft{
    if (!_btnLeft) {
        _btnLeft = [self createButton:@"升"];
        [_btnLeft addTarget:self action:@selector(btnLeftClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_btnLeft];
    }
    return _btnLeft;
}

-(UIButton *)btnRight{
    if (!_btnRight) {
        _btnRight = [self createButton:@"降"];
        [_btnRight addTarget:self action:@selector(btnRightClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_btnRight];
    }
    return _btnRight;
}

-(void)btnLeftClick{
    self.waterView.progress = 1;
}

-(void)btnRightClick{
    self.waterView.progress = 0;
}

-(UIButton*)createButton:(NSString*)title{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.backgroundColor = [UIColor grayColor];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return btn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
