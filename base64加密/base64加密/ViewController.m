//
//  ViewController.m
//  base64加密
//
//  Created by czbk on 16/7/13.
//  Copyright © 2016年 王帅龙. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *passText;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //
    [self readUseInfo];
}


- (IBAction)clickButton:(UIButton *)sender {
    //得到文本框中的数据
    NSString *name = self.nameText.text;
    NSString *pass = self.passText.text;
    
    //对密码进行加密
    pass = [self base64Ecode:pass];
    NSLog(@"%@",pass);
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
            
            
            [self saveUseInfo];
        }
    }];
}

//base64加密
-(NSString*)base64Ecode:(NSString*)originalStr{
    //把密码转换成二进制
    NSData *data = [originalStr dataUsingEncoding:NSUTF8StringEncoding];
    
    //把二进制进行base64加密
    NSString *ecodeStr = [data base64EncodedStringWithOptions:0];
    
    return ecodeStr;
}

//base64解密
-(NSString*)base64Decode:(NSString*)ecodeStr{
    //判断是否有密码
    if(ecodeStr == nil){
        return nil;
    }
    
    //把base64加密后的密码,转换成二进制数据
    NSData *data = [[NSData alloc]initWithBase64EncodedString:ecodeStr options:0];
    
    //把二进制数据转换成字符串
    NSString *decodeStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    return decodeStr;
}

//保存数据
-(void)saveUseInfo{
    //偏好设置
    NSUserDefaults *defa = [NSUserDefaults standardUserDefaults];
    
    //保存用户名
    [defa setObject:self.nameText.text forKey:@"name"];
    
    //加密密码
    NSString *str = [self base64Ecode:self.passText.text];
    [defa setObject:str forKey:@"pass"];
}

//读取数据
-(void)readUseInfo{
    //
    NSUserDefaults *defa = [NSUserDefaults standardUserDefaults];
    
    //读取用户
    self.nameText.text = [defa objectForKey:@"name"];
    
    //
    NSString *str = [self base64Decode:[defa objectForKey:@"pass"]];
    self.passText.text = str;
}
@end
