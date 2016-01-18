//
//  SubsectionCircularView.m
//
//  Created by honzon on 16/1/17.
//  Copyright © 2016年 honzon. All rights reserved.
//

#import "SubsectionCircularView.h"

@interface SubsectionCircularView ()
@property (nonatomic, assign, readwrite)NSUInteger maxInstanceCount;
@property (nonatomic, strong, readwrite)UILabel *textLabel;
@property (nonatomic, strong)CAReplicatorLayer *backgroundReplicator;
@property (nonatomic, assign)CGFloat instanceWidth;
@property (nonatomic, assign)CGFloat instanceHeight;

@property (nonatomic, strong)CAShapeLayer *shaper;

@end

@implementation SubsectionCircularView
-(void)setInstanceCount:(NSUInteger)instanceCount {
    self.replicator.instanceCount = instanceCount;
    _progress =(float)instanceCount/self.maxInstanceCount;
    NSString *text = [NSString stringWithFormat:@"%lu %@",100 *instanceCount/self.maxInstanceCount,@"%"];
    self.textLabel.text =text;
}

- (void)setProgress:(float)progress{
    if (!(_progress == progress)) {
        _progress = progress;
        if (self.shaper) {
            self.shaper.strokeEnd = progress;
            NSString *text = [NSString stringWithFormat:@"%.f %@",100*progress,@"%"];
            self.textLabel.text =text;
        }else {
             self.instanceCount = progress *self.maxInstanceCount;
        }
    }
}

-(NSUInteger)instanceCount {
    return self.replicator.instanceCount;
}

- (instancetype)initWithFrame:(CGRect)frame instanceCount:(NSUInteger)instanceCount maxInstanceCount:(NSUInteger)maxInstanceCount
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createInnerCircleView];
        if (maxInstanceCount <= 0) {//给定默认最大值
            maxInstanceCount = 40;
        }
        self.maxInstanceCount = maxInstanceCount;
        self.instanceWidth = 5.0;//小条默认宽度
        self.instanceHeight = 10.0;//小条默认高度
        
    }
    return self;
}

//添加内层试图
- (void)createInnerCircleView {
    UIView *innerCircleView = [[UIView alloc] init];
    innerCircleView.frame = CGRectMake(10,10,self.frame.size.width - 20, self.frame.size.width - 20);
    innerCircleView.layer.cornerRadius = innerCircleView.bounds.size.width/2;
    innerCircleView.layer.masksToBounds = YES;
    innerCircleView.backgroundColor = [UIColor redColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:innerCircleView.bounds];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    self.textLabel = label;
    [innerCircleView addSubview:label];
    
    [self addSubview:innerCircleView];
}

/**** two CAReplicatorLayer****/

+ (SubsectionCircularView *)createSubsectionCircularViewWithFrame:(CGRect)frame superView:(UIView *)superView  instanceCount:(NSUInteger)instanceCount maxInstanceCount:(NSUInteger)maxInstanceCount{
    SubsectionCircularView *circularView = [[SubsectionCircularView alloc] initWithFrame:frame instanceCount:instanceCount maxInstanceCount:maxInstanceCount];
    
    circularView.backgroundReplicator = [circularView createReplicatorColor:[UIColor grayColor] instanceCount:circularView.maxInstanceCount];
    circularView.replicator =  [circularView createReplicatorColor:[UIColor greenColor]instanceCount:instanceCount];
     circularView.instanceCount = instanceCount;
    
    [circularView.layer addSublayer:circularView.backgroundReplicator];
    [circularView.layer addSublayer:circularView.replicator];
    [superView addSubview:circularView];
    
    return circularView;
}

/****CAReplicatorLayer + CAShaper****/

+ (SubsectionCircularView *)createShaperCircularViewWithFrame:(CGRect)frame superView:(UIView *)superView instanceCount:(NSUInteger)instanceCount maxInstanceCount:(NSUInteger)maxInstanceCount{
    SubsectionCircularView *circularView = [[SubsectionCircularView alloc] initWithFrame:frame instanceCount:instanceCount maxInstanceCount:maxInstanceCount];
    [circularView drawSubsectionCircularView];
    
    [superView addSubview:circularView];
    return circularView;
}

- (void)drawSubsectionCircularView {
    CAShapeLayer *shaper = [CAShapeLayer layer];
    shaper.lineWidth = self.instanceHeight*2;
    
    shaper.fillColor = [UIColor grayColor].CGColor;
    shaper.strokeColor = [UIColor greenColor].CGColor;
    shaper.strokeStart = 0.0;
    shaper.strokeEnd = 0.0;
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    shaper.path = path.CGPath;
    
    CAReplicatorLayer * backgroundReplicator = [self createReplicatorColor:[UIColor grayColor] instanceCount:self.maxInstanceCount];
    [shaper setMask:backgroundReplicator];
    self.shaper = shaper;
    [self.layer addSublayer:shaper];
}


//CAReplicatorLayer
- (CAReplicatorLayer *)createReplicatorColor:(UIColor *)color instanceCount:(NSUInteger)instanceCount{
    CAReplicatorLayer * replicator = [CAReplicatorLayer layer];
    replicator.frame = CGRectMake(self.center.x/2+2*self.instanceHeight, 0, 0, self.frame.size.width);
    replicator.instanceColor = color.CGColor;
    replicator.instanceCount = instanceCount;
    
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DMakeRotation( M_PI*2 /self.maxInstanceCount , 0, 0, 1);
    replicator.instanceTransform = transform;
    
    CALayer * layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, self.instanceWidth, self.instanceHeight);
    layer.backgroundColor = color.CGColor;
    
    //解决据此话问题
    layer.edgeAntialiasingMask = kCALayerBottomEdge|kCALayerLeftEdge | kCALayerRightEdge | kCALayerTopEdge;
    layer.allowsEdgeAntialiasing = YES;
    
    [replicator addSublayer:layer];
    
    replicator.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);//改变初始位置
    
    return replicator;
}


@end
