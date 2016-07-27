//
//  ViewController.m
//  DoubiDemo
//
//  Created by gaolili on 16/7/19.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "ViewController.h"
#import "PriceAlertView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *groupURL = [fileManager containerURLForSecurityApplicationGroupIdentifier:@"group.DoubiDemo"];
    groupURL = [groupURL URLByAppendingPathComponent:@"upload"];
    NSArray * array  =[fileManager contentsOfDirectoryAtPath:groupURL.relativePath error:NULL];
    NSLog(@"array =======  %@",array);
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"逗比" forState:UIControlStateNormal];
    btn.frame = CGRectMake(100, 100, 40, 30);
    [btn addTarget:self action:@selector(showAlert) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    
    
}


- (void)showAlert{
    [[ PriceAlertView shareInstance] showAlertWithData:@[@"11111",@"222",@"333"] block:^(id obj) {
        NSLog(@"点击的是=   %@",obj);
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
