//
//  ViewController.m
//  Examle
//
//  Created by honzon on 16/1/17.
//  Copyright © 2016年 honzon. All rights reserved.
//

#define k_SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define k_SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height

#import "ViewController.h"
#import "SubsectionCircularView.h"
@interface ViewController ()
@property (nonatomic ,strong)SubsectionCircularView *circularView;
@property (nonatomic ,strong)NSTimer *timer;
@property (nonatomic ,assign)BOOL isShaper;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    SubsectionCircularView *circularView =  [SubsectionCircularView createShaperCircularViewWithFrame:CGRectMake(k_SCREEN_WIDTH/2 - 100, k_SCREEN_HEIGHT/2 - 100, 100, 100) superView:self.view instanceCount:0 maxInstanceCount:8 instanctLayer:nil];
   
    self.circularView = circularView;
    [self addCircularViewTimer];
    
    UIButton *repeatbBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    repeatbBnt.frame = CGRectMake(k_SCREEN_WIDTH/2 - 100, k_SCREEN_HEIGHT/2 + 150, 100, 50);
    [repeatbBnt setTitle:@"repeat" forState:UIControlStateNormal];
    [repeatbBnt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [repeatbBnt addTarget:self action:@selector(repeat) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:repeatbBnt];
    
    
    UIButton *stopBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    stopBnt.frame = CGRectMake(k_SCREEN_WIDTH/2 , k_SCREEN_HEIGHT/2 + 150, 100, 50);
    [stopBnt setTitle:@"stop" forState:UIControlStateNormal];
    [stopBnt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [stopBnt addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopBnt];
    
}

- (void)stop{
    [self.timer invalidate];
    self.timer = nil;
}


- (void)repeat{
    self.circularView.progress = 0.0;
    [self stop];
    [self addCircularViewTimer];
}

- (void)changeCircularView {
    self.circularView.progress += 0.1;
    if (self.circularView.progress == 1.0) {
        [self stop];
    }
}


- (void)addCircularViewTimer {
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(changeCircularView) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    [self.timer fire];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
