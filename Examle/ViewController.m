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
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    SubsectionCircularView *circularView =  [SubsectionCircularView createSubsectionCircularViewWithFrame:CGRectMake(k_SCREEN_WIDTH/2 - 100, k_SCREEN_HEIGHT/2 - 100, 200, 200) superView:self.view instanceCount:1 maxInstanceCount:180];
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
    self.circularView.instanceCount = 1;
    [self.timer invalidate];
    self.timer = nil;
}


- (void)repeat{
    [self stop];
    [self addCircularViewTimer];
}

- (void)changeCircularView {
//    self.circularView.progress = self.circularView.progress + 0.05;
    self.circularView.instanceCount ++;
    if (self.circularView.instanceCount == self.circularView.maxInstanceCount) {
        [self stop];
    }
}


- (void)addCircularViewTimer {
    self.timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(changeCircularView) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    [self.timer fire];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
