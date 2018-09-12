//
//  ViewController.m
//  Lottie
//
//  Created by Phineas.Huang on 2018/9/11.
//  Copyright © 2018 Phineas. All rights reserved.
//

#import "ViewController.h"

#import <Lottie/Lottie.h>

#define keyNotificationAnimation @"play_animation"
#define AnimationSpeed 1.2f

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *animationView;

@property (weak, nonatomic) IBOutlet UIView *hourTensView;
@property (weak, nonatomic) IBOutlet UIView *hourUnitsView;
@property (weak, nonatomic) IBOutlet UIView *minTensView;
@property (weak, nonatomic) IBOutlet UIView *minUnitsView;

@property (weak, nonatomic) IBOutlet UIView *btnSwitch;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupAnimationViews) name:keyNotificationAnimation object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:keyNotificationAnimation object:nil userInfo:nil];
    
    [self setupSwitch];
}

- (void)switchToggled:(LOTAnimatedSwitch *)animatedSwitch {
    NSLog(@"The switch is %@", (animatedSwitch.on ? @"ON" : @"OFF"));
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:keyNotificationAnimation];
}

- (void)setupAnimationViews {
    [self addAnimationView];
}

- (void)addAnimationView {
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    
    NSString *hourTens = [NSString stringWithFormat:@"%ld", hour / 10];
    NSString *hourUnits = [NSString stringWithFormat:@"%ld", hour % 10];
    NSString *minTens = [NSString stringWithFormat:@"%ld", minute / 10];
    NSString *minUnits = [NSString stringWithFormat:@"%ld", minute % 10];
    
    LOTAnimationView *aniHourTens = [LOTAnimationView animationNamed:hourTens];
    CGRect rect1 = self.hourTensView.frame;
    aniHourTens.frame = rect1;
    aniHourTens.animationSpeed = AnimationSpeed;
    [self.hourTensView addSubview:aniHourTens];
    
    LOTAnimationView *aniHourUnits = [LOTAnimationView animationNamed:hourUnits];
    CGRect rect2 = self.hourUnitsView.frame;
    rect2.origin = CGPointZero;
    aniHourUnits.frame = rect2;
    aniHourUnits.animationSpeed = AnimationSpeed;
    [self.hourUnitsView addSubview:aniHourUnits];
    
    LOTAnimationView *aniMinTens = [LOTAnimationView animationNamed:minTens];
    CGRect rect3 = self.minTensView.frame;
    rect3.origin = CGPointZero;
    aniMinTens.frame = rect3;
    aniMinTens.animationSpeed = AnimationSpeed;
    [self.minTensView addSubview:aniMinTens];

    LOTAnimationView *aniMinUnits = [LOTAnimationView animationNamed:minUnits];
    CGRect rect4 = self.minUnitsView.frame;
    rect4.origin = CGPointZero;
    aniMinUnits.frame = rect4;
    aniMinUnits.animationSpeed = AnimationSpeed;
    [self.minUnitsView addSubview:aniMinUnits];

    [aniHourTens play];
    [aniHourUnits play];
    [aniMinTens play];
    [aniMinUnits playWithCompletion:^(BOOL animationFinished) {
        [aniHourTens removeFromSuperview];
        [aniHourUnits removeFromSuperview];
        [aniMinTens removeFromSuperview];
        [aniMinUnits removeFromSuperview];

        [[NSNotificationCenter defaultCenter] postNotificationName:keyNotificationAnimation object:nil userInfo:nil];
    }];
}

- (void)setupSwitch {
    LOTAnimatedSwitch *toggle1 = [LOTAnimatedSwitch switchNamed:@"Switch"];
    [toggle1 setProgressRangeForOnState:0.5 toProgress:1];
    [toggle1 setProgressRangeForOffState:0 toProgress:0.5];
    [toggle1 addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
    CGRect rect = self.btnSwitch.frame;
    rect.origin = CGPointZero;
    toggle1.frame = rect;
    [self.btnSwitch addSubview:toggle1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
