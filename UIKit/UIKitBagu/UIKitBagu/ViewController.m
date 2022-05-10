//
//  ViewController.m
//  UIKitBagu
//
//  Created by Ryder Fang on 2021/10/13.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSDictionary *messageAttr = @{
        NSFontAttributeName:[UIFont systemFontOfSize:14],
        NSForegroundColorAttributeName:[UIColor redColor]
    };
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"您的机器实在太烂了，建议您TMD快换一台新机器：京东官方旗帜店！" attributes:messageAttr];
    [str addAttribute:NSLinkAttributeName value:@"https://www.jd.com/" range:[str.string rangeOfString:@"京东官方旗帜店"]];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"内存告警" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alert setValue:str forKey:@"attributedMessage"];
    [alert addAction:[UIAlertAction actionWithTitle:@"好的🙁" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"这就去😰" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
