//
//  ViewController.m
//  钥匙串
//
//  Created by czbk on 16/7/14.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

#import "ViewController.h"
#import "SSKeychain.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *passText;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /**
     *  参数1:要保存到钥匙串中的密码
     *  参数2:要保存哪个应用的密码
     *  参数3:要保存哪个账户的密码
     */
    [SSKeychain setPassword:@"zhang" forService:[NSBundle mainBundle].bundleIdentifier account:@"zhangsan"];
    
    /**
     *  参数1:保存哪个应用的密码
     *  参数2:保存哪个账户的密码
     */
    NSString *pass = [SSKeychain passwordForService:[NSBundle mainBundle].bundleIdentifier account:@"zhangsan"];
    
    NSLog(@"从钥匙串中获取的密码是:%@",pass);
}


- (IBAction)clickButton:(UIButton *)sender {
    //得到文本框中的数据
    NSString *name = self.nameText.text;
    NSString *pass = self.passText.text;
    
    
    //服务器地址
    NSURL *url = [NSURL URLWithString:@"http://localhost/login.php"];
    
    //请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //请求方式
    request.HTTPMethod = @"POST";
    
    //请求体
    NSString *bady = [NSString stringWithFormat:@"username=%@&password=%@",name,pass];
    request.HTTPBody = [bady dataUsingEncoding:NSUTF8StringEncoding];
    
    //发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if(nil == connectionError){
            id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            
            NSLog(@"%@",result);
            
        }
    }];
}

@end
