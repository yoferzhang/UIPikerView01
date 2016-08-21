//
//  ViewController.m
//  UIPikerView01
//
//  Created by yoferzhang on 16/8/20.
//  Copyright © 2016年 yoferzhang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property(nonatomic, strong) NSArray *foods;

@property(nonatomic, weak) UIPickerView *pickerView;
@property(nonatomic, weak) UILabel *fruitLabel;
@property(nonatomic, weak) UILabel *mainLabel;
@property(nonatomic, weak) UILabel *drinkLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 绘制一个 pickerView
    [self drawPickerView];
    
    [self drawLabel];
    [self setNavigationBar];
}

#pragma mark - Access 方法

- (NSArray *)foods {
    if (!_foods) {
        // _foods 数组中装着3个数组
        _foods = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"foods" ofType:@"plist"]];
    }
    
    return _foods;
}

#pragma mark - 绘制 pickerView

- (void)drawPickerView
{
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height / 2.0)];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    
    [self.view addSubview:pickerView];
    self.pickerView = pickerView;
}

- (void)drawLabel {
    UILabel *fruitLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 10.0, self.pickerView.bounds.size.height, self.view.bounds.size.width - self.view.bounds.size.width / 10.0, 30)];
    [self.view addSubview:fruitLabel];
    self.fruitLabel = fruitLabel;
    
    UILabel *mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 10.0, self.pickerView.bounds.size.height + 30, self.view.bounds.size.width - self.view.bounds.size.width / 10.0, 30)];
    [self.view addSubview:mainLabel];
    self.mainLabel = mainLabel;
    
    UILabel *drinkLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 10.0, self.pickerView.bounds.size.height + 60, self.view.bounds.size.width - self.view.bounds.size.width / 10.0, 30)];
    [self.view addSubview:drinkLabel];
    self.drinkLabel = drinkLabel;
    
    for (int component = 0; component < self.foods.count; component++) {
        [self pickerView:self.pickerView didSelectRow:0 inComponent:component];
    }
}

#pragma mark - 设置导航栏

- (void)setNavigationBar
{
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"随机" style:UIBarButtonItemStylePlain target:self action:@selector(randomSelection)];
    [self.navigationItem setLeftBarButtonItem:leftBarButton];
    self.navigationItem.title = @"点菜系统";
}

/*
 * 随机选中某一种食物
 */
- (void)randomSelection
{
    for (int component = 0; component < self.foods.count; component++) {
        int randomRow = arc4random() % [self.foods[component] count];
        // 上面这行计算不能用 self.foods[component].count，因为self.foods[component]返回的是个 id ，不能用点语法
        NSInteger oldRow = [self.pickerView selectedRowInComponent:component];
        // 保证每次随机都和上一次不同
        while (randomRow == oldRow) {
            randomRow = arc4random() % [self.foods[component] count];
        }
        [self.pickerView selectRow:randomRow inComponent:component animated:YES];
        [self pickerView:self.pickerView didSelectRow:randomRow inComponent:component];
    }
}


#pragma mark - 数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return self.foods.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.foods[component] count];
}

#pragma mark - UIPickerView 代理方法

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {

    return self.foods[component][row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
            self.fruitLabel.text = self.foods[component][row];
            break;
        case 1:
            self.mainLabel.text = self.foods[component][row];
            break;
        case 2:
            self.drinkLabel.text = self.foods[component][row];
            break;
            
        default:
            break;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
