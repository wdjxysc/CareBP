//
//  MainViewController.h
//  CareBP
//
//  Created by 夏 伟 on 14-6-28.
//  Copyright (c) 2014年 夏 伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController
{
    IBOutlet UIButton *inputDataBtn;
}

@property(retain,nonatomic)UIButton *inputDataBtn;

@property(retain,nonatomic)NSDictionary *datadic;

-(IBAction)inputDataBtnPressed:(id)sender;

@end
