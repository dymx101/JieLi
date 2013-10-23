//
//  BookShelfTableViewController.m
//  JieliPublishingA
//
//  Created by 花 晨 on 13-3-12.
//  Copyright (c) 2013年 中卡. All rights reserved.
//

#import "BookShelfTableViewController.h"

@interface BookShelfTableViewController ()

@property (nonatomic,strong)    NSArray *myBooks;

@end

@implementation BookShelfTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)loadBooks:(NSArray *)books{
    self.myBooks = books;
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
static float height =-1;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (height ==-1) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"BookCell" owner:self options:nil];
        BookCell *cell = (BookCell *)[nibs objectAtIndex:0];
        height = cell.frame.size.height;
    }
    return height;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.myBooks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"BookCell" owner:self options:nil];
    BookCell *cell = (BookCell *)[nibs objectAtIndex:0];
    [cell loadBook:[self.myBooks objectAtIndex:indexPath.row]];
    
    return cell;
    
    
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    BookInfo *info = [self.myBooks objectAtIndex:indexPath.row];
    
    HCTadBarController *tabBarController = [[HCTadBarController alloc] init];
    tabBarController.bookInfo = info;
    
//    NSLog(@"\n%@\n%@",info.epub_all,info.epub_unall);
    NSLog(@"%@",info);
    ContentViewController *vc1 = [[ContentViewController alloc] initWithNibName:@"ContentViewController" bundle:nil];
    vc1.tabBarController = tabBarController;
    ShareViewController *vc2 = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil];
    CommentViewController *vc3 = [[CommentViewController alloc] initWithNibName:@"CommentViewController" bundle:nil];
    BuyViewController *vc4 = [[BuyViewController alloc] initWithNibName:@"BuyViewController" bundle:nil];
    
    tabBarController.viewControllers = [NSArray arrayWithObjects:vc1, vc2, vc3, vc4, nil];
    tabBarController.hidesBottomBarWhenPushed = YES;
    [self.delegate pushOut:tabBarController];
}

@end
