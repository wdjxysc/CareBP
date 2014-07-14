//
//  MainViewController.m
//  CareBP
//
//  Created by 夏 伟 on 14-6-28.
//  Copyright (c) 2014年 夏 伟. All rights reserved.
//

#import "MainViewController.h"
#import "ServerConnect.h"
#import "LinkAViewController.h"
#import "LinkBViewController.h"
#import "QuestionViewController.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UILabel *sysLabel;
@property (weak, nonatomic) IBOutlet UITextField *sysTextField;
@property (weak, nonatomic) IBOutlet UILabel *sysUnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *diaLabel;
@property (weak, nonatomic) IBOutlet UITextField *diaTextField;
@property (weak, nonatomic) IBOutlet UILabel *diaUnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *pulseLabel;
@property (weak, nonatomic) IBOutlet UITextField *pulseTextField;
@property (weak, nonatomic) IBOutlet UILabel *pulseUnitLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel2;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView2;
@property (weak, nonatomic) IBOutlet UIButton *linkBtn1;
@property (weak, nonatomic) IBOutlet UIButton *linkBtn2;

@end

@implementation MainViewController
@synthesize inputDataBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgView)];
        [self.view addGestureRecognizer:tap];
    }
    return self;
}
-(void)tapBgView
{
    // 发送resignFirstResponder.
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initMyView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //从服务器获取app列表
        int i = random()%4 + 1;
        NSDictionary *dic = [ServerConnect terminalGetContent:1 number:i];
        if(dic)
        {
            _datadic = dic;
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (dic) {
                [self loadContentImageView:_datadic];
            }
            else
            {
                NSLog(@"ServerConnect terminalGetContent failed");
            }
        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initMyView
{
    //设置状态栏字体颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //本页标题图片
    UIImageView *topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    [topImageView setImage:[UIImage imageNamed:@"navibar_bg"]];
    [self.view addSubview:topImageView];
    
    //本页标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, 70, 24)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    titleLabel.text = @"呵护血压";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:titleLabel];
    
    //日期
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 25, 70, 20)];
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
    [fomatter setDateFormat:@"yyyy/M/d"];
    dateLabel.text = [fomatter stringFromDate:[NSDate date]];
    dateLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:dateLabel];
    
    //星期
    UILabel *weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 37, 70, 20)];
    weekLabel.textColor = [UIColor whiteColor];
    weekLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
    NSDateComponents *comps;
    NSCalendar*calendar = [NSCalendar currentCalendar];
    comps =[calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit)
                       fromDate:[NSDate date]];
    int i= (int)[comps weekday];
    switch (i) {
        case 1:
            weekLabel.text = @"星期日";
            break;
        case 2:
            weekLabel.text = @"星期一";
            break;
        case 3:
            weekLabel.text = @"星期二";
            break;
        case 4:
            weekLabel.text = @"星期三";
            break;
        case 5:
            weekLabel.text = @"星期四";
            break;
        case 6:
            weekLabel.text = @"星期五";
            break;
        case 7:
            weekLabel.text = @"星期六";
            break;
        default:
            break;
    }
    weekLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:weekLabel];
    
    //右心
    UIButton *heartBtn = [[UIButton alloc]initWithFrame:CGRectMake(290, 32, 21, 17)];
    [heartBtn setBackgroundImage:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
    [heartBtn addTarget:self action:@selector(careBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:heartBtn];
    
//    //添加按钮
//    _inputDataBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 90, 120, 120)];
//    [_inputDataBtn setBackgroundImage:[UIImage imageNamed:@"btn_input_normal"] forState:UIControlStateNormal];
//    [self.view addSubview:_inputDataBtn];
//    
//    //预防块
//    UIImageView *yufangImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 230, 314, 109)];
//    [yufangImageView setImage:[UIImage imageNamed:@"image_bg1"]];
//    [self.view addSubview:yufangImageView];
//    
//    
//    //预防块
//    UIImageView *siliaoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 349, 314, 188)];
//    [siliaoImageView setImage:[UIImage imageNamed:@"image_bg2"]];
//    [self.view addSubview:siliaoImageView];
    
}

-(IBAction)inputDataBtnPressed:(id)sender
{
    _sysLabel.hidden = NO;
    _sysTextField.hidden = NO;
    _sysUnitLabel.hidden = NO;
    _diaLabel.hidden = NO;
    _diaTextField.hidden = NO;
    _diaUnitLabel.hidden = NO;
    _pulseLabel.hidden = NO;
    _pulseTextField.hidden = NO;
    _pulseUnitLabel.hidden = NO;
    UIButton *btn = (UIButton *)sender;
    btn.hidden = YES;
}

-(void)loadContentImageView : (NSDictionary *)dic
{
    NSLog(@"%@",dic);
    if([[dic valueForKey:@"RESULT_CODE"] integerValue] == 0)
    {
        _titleLabel1.text = [[[dic valueForKey:@"RESULT_INFO"] valueForKey:@"RESULT_YF"] valueForKey:@"conetentTitle"];
        _contentLabel1.text = [[[dic valueForKey:@"RESULT_INFO"] valueForKey:@"RESULT_YF"] valueForKey:@"contentSummary"];
        
        _titleLabel2.text = [[[dic valueForKey:@"RESULT_INFO"] valueForKey:@"RESULT_FA"] valueForKey:@"typeName"];
        _contentLabel2.text = [[[dic valueForKey:@"RESULT_INFO"] valueForKey:@"RESULT_FA"] valueForKey:@"conetentTitle"];
        _contentTextView2.text = [[[dic valueForKey:@"RESULT_INFO"] valueForKey:@"RESULT_FA"] valueForKey:@"contentSummary"];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *dataimage_fa = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[[dic valueForKey:@"RESULT_INFO"] valueForKey:@"RESULT_FA"] valueForKey:@"thumbnailUrl"]]];//适用于加载在网页上的图片
        //        NSData *data = [ServerConnect doSyncRequest:[rowData valueForKey:@"imageName"]];//用于下载图片
        UIImage *image_fa = [UIImage imageWithData:dataimage_fa];
        NSData *dataimage_yf = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[[dic valueForKey:@"RESULT_INFO"] valueForKey:@"RESULT_YF"] valueForKey:@"thumbnailUrl"]]];//适用于加载在网页上的图片
        //        NSData *data = [ServerConnect doSyncRequest:[rowData valueForKey:@"imageName"]];//用于下载图片
        UIImage *image_yf = [UIImage imageWithData:dataimage_yf];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (image_fa)
            _imageView1.image = image_fa;
            if (image_yf)
            _imageView2.image = image_yf;
        });
    });
}

-(IBAction)submitBtnPressed:(id)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //从服务器获取app列表
        int i = random()%4 + 1;
        NSDictionary *dic = [ServerConnect terminalGetContent:1 number:i];
        if(dic)
        {
            _datadic = dic;
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (dic) {
                [self loadContentImageView:_datadic];
            }
            else
            {
                NSLog(@"ServerConnect terminalGetContent failed");
            }
        });
    });
}

-(IBAction)linkBtn1Pressed:(id)sender
{
    LinkAViewController *linkAViewController = [[LinkAViewController alloc]initWithNibName:@"LinkAViewController" bundle:nil];
    [self.navigationController pushViewController:linkAViewController animated:YES];
}
-(IBAction)linkBtn2Pressed:(id)sender
{
    LinkBViewController *linkBViewController = [[LinkBViewController alloc]initWithNibName:@"LinkBViewController" bundle:nil];
    [self.navigationController pushViewController:linkBViewController animated:YES];
}
-(IBAction)careBtnPressed:(id)sender
{
    QuestionViewController *questionViewController = [[QuestionViewController alloc]initWithNibName:@"QuestionViewController" bundle:nil];
    [self.navigationController pushViewController:questionViewController animated:YES];
}
@end
