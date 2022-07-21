//
//  MainViewController.m
//  UIKitBagu
//
//  Created by Ryder Fang on 2021/10/13.
//

#import "MainViewController.h"

@interface MainViewController ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void)setupViews {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)next:(UIButton *)button {
    
}

@end
