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
#define AnimationSpeedRaito 1.4f
#define AnimationButtonSpeed 0.5f

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *animationView;

@property (weak, nonatomic) IBOutlet UIView *hourTensView;
@property (weak, nonatomic) IBOutlet UIView *hourUnitsView;
@property (weak, nonatomic) IBOutlet UIView *minTensView;
@property (weak, nonatomic) IBOutlet UIView *minUnitsView;

@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIImageView *imgInBtn2;
@property (weak, nonatomic) IBOutlet UIImageView *imgInBtn1;
@property (assign, nonatomic) BOOL isToolImage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupAnimationViews) name:keyNotificationAnimation object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:keyNotificationAnimation object:nil userInfo:nil];
    
    self.btn1.layer.cornerRadius = self.btn1.bounds.size.width / 2;
    self.btn1.layer.masksToBounds = true;
    self.btn2.layer.cornerRadius = self.btn1.bounds.size.width / 2;
    self.btn2.layer.masksToBounds = true;
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
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitSecond | NSCalendarUnitMinute) fromDate:date];
    NSInteger min = [components minute];
    NSInteger second = [components second];
    
    NSString *minTens = [NSString stringWithFormat:@"%ld", min / 10];
    NSString *minUnits = [NSString stringWithFormat:@"%ld", min % 10];
    NSString *secTens = [NSString stringWithFormat:@"%ld", second / 10];
    NSString *secUnits = [NSString stringWithFormat:@"%ld", second % 10];
    
    LOTAnimationView *aniHourTens = [LOTAnimationView animationNamed:minTens];
    CGRect rect1 = self.hourTensView.frame;
    aniHourTens.frame = rect1;
    aniHourTens.animationSpeed = AnimationSpeedRaito;
    [self.hourTensView addSubview:aniHourTens];
    
    LOTAnimationView *aniHourUnits = [LOTAnimationView animationNamed:minUnits];
    CGRect rect2 = self.hourUnitsView.frame;
    rect2.origin = CGPointZero;
    aniHourUnits.frame = rect2;
    aniHourUnits.animationSpeed = AnimationSpeedRaito;
    [self.hourUnitsView addSubview:aniHourUnits];
    
    LOTAnimationView *aniMinTens = [LOTAnimationView animationNamed:secTens];
    CGRect rect3 = self.minTensView.frame;
    rect3.origin = CGPointZero;
    aniMinTens.frame = rect3;
    aniMinTens.animationSpeed = AnimationSpeedRaito;
    [self.minTensView addSubview:aniMinTens];

    LOTAnimationView *aniMinUnits = [LOTAnimationView animationNamed:secUnits];
    CGRect rect4 = self.minUnitsView.frame;
    rect4.origin = CGPointZero;
    aniMinUnits.frame = rect4;
    aniMinUnits.animationSpeed = AnimationSpeedRaito;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionButtonAnimation:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSUInteger tag = button.tag;
    
    if (tag == 2 && self.isToolImage == NO) {
        [self ShowAlert:@"Press setting button"];
        return;

    } else if (tag == 1 && self.isToolImage == YES) {
        [self ShowAlert:@"Press tool button"];
        return;
    }
    
    float btn1Width = self.btn1.frame.size.width;
    float btn2Width = self.btn2.frame.size.width;
    
    float btn1X = self.btn1.frame.origin.x;
    float btn2X = self.btn2.frame.origin.x + btn2Width - btn1Width;
    
    CGRect rect1 = self.btn1.frame;
    CGRect rect2 = self.btn2.frame;
    rect1.size.width = btn2Width;
    rect2.size.width = btn1Width;
    rect1.origin.x = btn1X;
    rect2.origin.x = btn2X;
    
    float widthImg2 = self.imgInBtn2.frame.size.width;
    float xImg2 = btn2X + btn1Width/2 - widthImg2/2;
    CGRect rectImg2 = self.imgInBtn2.frame;
    rectImg2.origin.x = xImg2;
    
    float widthImg1 = self.imgInBtn1.frame.size.width;
    float xImg1 = btn1X + btn2Width/2 - widthImg1/2;
    CGRect rectImg1 = self.imgInBtn1.frame;
    rectImg1.origin.x = xImg1;
    
    self.isToolImage = !self.isToolImage;
    
    NSMutableArray *flyAnimFrames1 = [NSMutableArray array];
    NSMutableArray *flyAnimFrames2 = [NSMutableArray array];
    for(int i = 0; i <= 28; i++) {
        UIImage *img1 = [UIImage imageNamed:[NSString stringWithFormat:@"__cframe%02d", i]];
        [flyAnimFrames1 addObject:img1];
        UIImage *img2 = [UIImage imageNamed:[NSString stringWithFormat:@"__frame%02d", i]];
        [flyAnimFrames2 addObject:img2];
    }
    
    if (self.isToolImage == NO) {
        flyAnimFrames1 = [[[flyAnimFrames1 reverseObjectEnumerator] allObjects] mutableCopy];
        flyAnimFrames2 = [[[flyAnimFrames2 reverseObjectEnumerator] allObjects] mutableCopy];
    }
    
    self.imgInBtn1.animationImages = flyAnimFrames1;
    self.imgInBtn1.animationDuration = AnimationButtonSpeed;
    self.imgInBtn1.animationRepeatCount = 1;
    [self.imgInBtn1 startAnimating];
    
    self.imgInBtn2.animationImages = flyAnimFrames2;
    self.imgInBtn2.animationDuration = AnimationButtonSpeed;
    self.imgInBtn2.animationRepeatCount = 1;
    [self.imgInBtn2 startAnimating];
    
    // now animate the view...
    [UIView animateWithDuration:AnimationButtonSpeed
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.btn1.transform = CGAffineTransformIdentity;
                         self.btn1.frame = rect1;
                         
                         self.btn2.transform = CGAffineTransformIdentity;
                         self.btn2.frame = rect2;
                         
                         self.imgInBtn1.frame = rectImg1;
                         self.imgInBtn2.frame = rectImg2;
                     }
                     completion:^(BOOL finished) {
                         [self.imgInBtn1 setImage:[flyAnimFrames1 lastObject]];
                         [self.imgInBtn2 setImage:[flyAnimFrames2 lastObject]];
                     }];
}

- (void)ShowAlert:(NSString *)Message {
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:nil
                                                                  message:@""
                                                           preferredStyle:UIAlertControllerStyleAlert];
    UIView *firstSubview = alert.view.subviews.firstObject;
    UIView *alertContentView = firstSubview.subviews.firstObject;
    for (UIView *subSubView in alertContentView.subviews) {
        subSubView.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:0.9f];
    }
    NSMutableAttributedString *AS = [[NSMutableAttributedString alloc] initWithString:Message];
    [AS addAttribute: NSForegroundColorAttributeName value: [UIColor blackColor] range: NSMakeRange(0,AS.length)];
    [alert setValue:AS forKey:@"attributedTitle"];
    [self presentViewController:alert animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:^{
        }];
    });
}


@end
