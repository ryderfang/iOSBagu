//
//  MainViewController.m
//  UIKitBagu
//
//  Created by Ryder Fang on 2021/10/13.
//

#import "MainViewController.h"
#import "DemoViewController.h"

@interface MainViewController ()

@property (nonatomic, strong) UIButton *nextButton;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.nextButton];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)testAlert {
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

- (void)next:(UIButton *)button {
    DemoViewController *vc = [[DemoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 500, 300, 50)];
        [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_nextButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}

@end
