//
//  ViewController.m
//  KVC_KVO_Demo
//
//  Created by runlin on 17/1/18.
//  Copyright © 2017年 gavin. All rights reserved.
//

#import "ViewController.h"
#import "Book.h"
#import "Person.h"

#define CONTEXT_OBSERVER @"CONTEXT_OBSERVER"

@interface ViewController ()
@property (nonatomic ,strong)Person *p;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self kvoDemo];

    [self kvcDemo];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  当利用KVO监听到某个对象的属性值发生了改变，就会自动调用这个
 *
 *  @param keyPath 哪个属性被改了
 *  @param object  哪个对象的属性被改了
 *  @param change  改成咋样
 *  @param context 当初addObserver时的context参数值
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"%@ %@ %@ %@", object, keyPath, change, context);
}


//释放KVO监听
-(void)dealloc{
    [self.p removeObserver:self forKeyPath:CONTEXT_OBSERVER];
}


- (IBAction)personButtonAction:(id)sender {
    self.p.name = @"zhangsan";
}



#pragma KVO

- (void)kvoDemo{
    self.p = [Person new];
    //为对象p添加一个观察者（监听器）
    [self.p addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:CONTEXT_OBSERVER];
    
}





#pragma KVC

- (void)kvcDemo{
    //访问私有变量
    Book *book = [Book new];
    [book setValue:@"private" forKey:@"_pName"];
    NSLog(@"private name : %@",[book valueForKey:@"_pName"]);
    
    
    //使用KVC直接访问 NSArray 或者 NSSet 的属性值
    Book *book1 = [Book new];
    Book *book2 = [Book new];
    Book *book3 = [Book new];
    
    book1.name = @"shuxue";
    book1.price = 20;
    book2.name = @"yuwen";
    book2.price = 10;
    book3.name = @"waiyu";
    book3.price = 50;
    
    NSArray *books= @[book1, book2, book3];
    NSArray *names = [books valueForKeyPath:@"name"];
    
    NSLog(@"%@",names);
    
    NSLog(@"%@", [books valueForKeyPath:@"@avg.price"]);//使用kvc直接打印出来书的平均价格
    
    //定义一个字典
    NSDictionary *dict = @{
                           @"name"  : @"java",
                           @"price" : @"99",
                           };
    
    Book *bookDic = [[Book alloc] init];//创建模型
    //字典转模型
    [bookDic setValuesForKeysWithDictionary:dict];
    
    NSLog(@"book name: << %@ >>  and  price:<< %zd >>",bookDic.name,bookDic.price);
}



@end
