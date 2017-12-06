//
//  ViewController.m
//  ZCJTimeDemo
//
//  Created by ZCJ on 2017/5/2.
//  Copyright © 2017年 ZCJ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    dispatch_source_t timer;
}

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic) BOOL isStart;
@property (nonatomic) BOOL isPause;
@property (nonatomic) BOOL isCreat;
@property (nonatomic,assign) int timeCount;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _timeCount = 0;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)runKeepTimeAction:(id)sender {
    
    if (!_isStart) {
        [self startToCountTime];
        _isPause = NO;
        [sender setTitle:@"暂停" forState:UIControlStateNormal];
    }else
    {
        dispatch_suspend(timer);
        _isPause = YES;
        [sender setTitle:@"继续" forState:UIControlStateNormal];
    }
    
    _isStart = !_isStart;
}

- (IBAction)stopTimeAction:(id)sender {
    
    if (_isCreat){
        if (_isPause == YES) {
            dispatch_resume(timer);
        }
        dispatch_source_cancel(timer);
        [self.startButton setTitle:@"开始" forState:UIControlStateNormal];
        _timeLabel.text = @"00:00:00";
        _isStart = NO;
        _timeCount = 0;
        _isCreat = NO;
    }
}


- (void)startToCountTime
{
    if ([self.startButton.titleLabel.text isEqualToString:@"开始"]) {
        dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, globalQueue);
        _isCreat = YES;
    }
    
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        int hours = _timeCount / 3600;
        int minutes = (_timeCount - (3600*hours)) / 60;
        int seconds = _timeCount%60;
        NSString *strTime = [NSString stringWithFormat:@"%.2d:%.2d:%.2d",hours,minutes,seconds];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _timeLabel.text = strTime;
            
        });
        _timeCount ++;
    });
    
    dispatch_resume(timer);
    
}

@end
