//
//  ViewController.m
//  CollectionViewDemo1
//
//  Created by user on 16/3/8.
//  Copyright © 2016年 user. All rights reserved.
//

#import "ViewController.h"

#define CELL_ID   @"CollectionViewCellId"
#define HEADER_ID @"CollectionViewHeadId"
#define FOOTER_ID @"CollectionViewFootId"

#define RANDOM_COLOR [UIColor colorWithRed:arc4random()%256/255.f green:arc4random()%256/255.f blue:arc4random()%256/255.f alpha:1.f]

@interface ViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic)UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //默认使用flowlayout
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    //指定cell的大小
    //全局指定，如果需要精确到cell，使用代理方法
    //默认值 CGSizeMake(50, 50)
//    flowLayout.itemSize = CGSizeMake(80, 80);

    //全局设定
    //设定cell间的最小间隔
    //这个值受布局方向 和iteSize的影响
    //每个方向的最小值 (screen_width-n*itemsize.width)/n+1
//    flowLayout.minimumInteritemSpacing = 0;
//    flowLayout.minimumLineSpacing = 0;

    //指定每个区的上下左右留白
//    flowLayout.sectionInset = UIEdgeInsetsMake(50, 50, 50, 50);

    //设置header/footer的高度
    //对于垂直滚动时，宽不起作用，高度起作用
    //水平滚动相反
//    flowLayout.headerReferenceSize = CGSizeMake(0, 50);
//    flowLayout.footerReferenceSize = CGSizeMake(0, 50);

    //设置滚动方向
    //default is UICollectionViewScrollDirectionVertical
//    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    // Set these properties to YES to get headers that pin to the top of the screen and footers that pin to the bottom while scrolling (similar to UITableView).
    flowLayout.sectionHeadersPinToVisibleBounds = YES;
    flowLayout.sectionFootersPinToVisibleBounds = YES;

    
    
    //创建一个UICollectionView指定使用的布局方式
    //布局方式决定了collectionView内部cell的位置信息
    
//    最简单的UICollectionView就是一个GridView，可以以多列的方式将数据进行展示。标准的UICollectionView包含三个部分，它们都是UIView的子类：
//    
//    Cells 用于展示内容的主体，对于不同的cell可以指定不同尺寸和不同的内容，这个稍后再说
//    Supplementary Views 追加视图 如果你对UITableView比较熟悉的话，可以理解为每个Section的Header或者Footer，用来标记每个section的view
//    Decoration Views 装饰视图 这是每个section的背景，比如iBooks中的书架就是这个


    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    //注册自己定制的cell
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CELL_ID];
    
    //注册补充视图作为header
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEADER_ID];
    
    //注册补充视图作为footer
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FOOTER_ID];

    
    [self.view addSubview:self.collectionView];
    
    //reloadData 数据源发生变化时重新加载
    //[self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

//指定有多少个seciton，跟tableView很类似
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 10;
}

//指定一个section中有多少个cell，这里的cell也成为Item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 50;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_ID forIndexPath:indexPath];
    cell.backgroundColor = RANDOM_COLOR;
    NSLog(@"%@",NSStringFromCGRect(cell.frame));
    return cell;
}

//指定可复用的f，可以作为section的header和footer
-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        //如果是头
        UICollectionReusableView *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HEADER_ID forIndexPath:indexPath];
        headerView.backgroundColor = RANDOM_COLOR;
        return headerView;
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        //如果是脚
        UICollectionReusableView *footerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:FOOTER_ID forIndexPath:indexPath];
        footerView.backgroundColor = RANDOM_COLOR;
        return footerView;
    }
    return nil;
}


#pragma mark - UICollectionViewDelegate

//是否允许选中
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//点击选中一个cell的事件，这里可以做业务逻辑比如页面跳转
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"(section,row) = (%ld,%ld)",indexPath.section,indexPath.row);
}


#pragma mark - UICollectionViewDelegateFlowLayout

//根据indexPath 指定itemSize大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 80);
}

//根据indexPath 指定section的padding
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

//指定最小item间上下间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 30;
}

//指定最小item间左右间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 30;
}


//指定头的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0, 50);
}

//指定footer的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(0, 80);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
