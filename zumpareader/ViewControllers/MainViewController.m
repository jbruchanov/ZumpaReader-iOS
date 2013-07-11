//
//  MainViewController.m
//  ZumpaReader
//
//  Created by Joe Scurab on 7/7/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "MainViewController.h"
#import "ZumpaAsyncWrapper.h"
#import "ZumpaMainPageResult.h"
#import "ZumpaItem.h"
#import "ZumpaMainViewCell.h"
#import "DetailViewController.h"
#import "PostViewController.h"
#import "SettingsViewController.h"

#define DISPLAY_WIDTH self.view.frame.size.width
#define LOAD_LIMIT_OFFSET 5

@interface MainViewController () <SettingsViewControllerDelegate>

@property (strong, nonatomic) ZumpaAsyncWrapper *zumpa;
@property (strong, nonatomic) NSMutableArray* zumpaItems;
@property (strong, nonatomic) ZumpaMainPageResult* currentResult;
@property (nonatomic) BOOL isLoading;
@property (strong, nonatomic) UIColor *colorEven;
@property (strong, nonatomic) UIColor *colorOdd;
@property (strong, nonatomic) ZumpaMainViewCell *measureCell;
@property (strong, nonatomic) UIFont *measureFont;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *reloadButton;

-(void)setSpinnerVisible:(BOOL) visible;
-(void)didReceiveResponse:(ZumpaMainPageResult*) result appendData:(BOOL) append;
-(void)willLoadNextPage;

@end


@implementation MainViewController

@synthesize zumpa = _zumpa;
@synthesize zumpaItems = _zumpaItems;
@synthesize currentResult = _currentResult;
@synthesize isLoading = _isLoading;
@synthesize colorEven = _colorEven, colorOdd = _colorOdd, measureCell = _measureCell;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.measureFont = [UIFont boldSystemFontOfSize:17];
    self.title = @"Žumpička";
    self.measureCell = [[ZumpaMainViewCell alloc]init];
    self.colorEven = [UIColor whiteColor];
    self.colorOdd = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    
    [self setSpinnerVisible:YES];
    self.zumpaItems = [[NSMutableArray alloc]init];
    self.zumpa = [[ZumpaAsyncWrapper alloc]initWithWebService:[[ZumpaWSClient alloc]init]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.isLoading = YES;
    [self.zumpa getItemsWithCallback:^(ZumpaMainPageResult *result) {
        [self didReceiveResponse:result appendData:NO];
    }];
    
        
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (IBAction)reloadDidClick:(id)sender {
    if(!self.isLoading){
        [self setSpinnerVisible:YES];
        self.isLoading = YES;
        [self.zumpa getItemsWithCallback:^(ZumpaMainPageResult *result) {
            [self didReceiveResponse:result appendData:NO];
        }];
    }
}

-(void)didReceiveResponse:(ZumpaMainPageResult*) result appendData:(BOOL)append{
   [self setSpinnerVisible:NO];
    self.isLoading = NO;
    self.currentResult = result;
    if(!append){
        [self.zumpaItems removeAllObjects];
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    }
    [self.zumpaItems addObjectsFromArray:result.items];
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
    return (self.zumpaItems) ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.zumpaItems) ? [self.zumpaItems count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ZumpaMainViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
       cell = [[ZumpaMainViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    int index = indexPath.item;
    
    if(index == [self.zumpaItems count] - LOAD_LIMIT_OFFSET){
        [self willLoadNextPage];
    }
    
    ZumpaItem *zi = [self.zumpaItems objectAtIndex:index];
    [cell setItem:zi];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZumpaItem *zi = [self.zumpaItems objectAtIndex:indexPath.item];
    self.measureCell.item = zi;
    return self.measureCell.frame.size.height;
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

-(void)willLoadNextPage{
    if(!self.isLoading && self.currentResult){
        NSString *nextPage = self.currentResult.nextPage;
        if(nextPage){
            [self setSpinnerVisible:YES];
            [self.zumpa getItemsWithUrl:nextPage andCallback:^(ZumpaMainPageResult *result) {
                [self didReceiveResponse:result appendData:YES];
            }];
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setBackgroundColor: (indexPath.row % 2 == 0) ? self.colorEven : self.colorOdd];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */

    [self performSegueWithIdentifier:@"OpenDetail" sender:[self.zumpaItems objectAtIndex:indexPath.item]];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([@"OpenDetail" isEqualToString:segue.identifier]){
        DetailViewController *dc = (DetailViewController*)segue.destinationViewController;
        dc.zumpa = self.zumpa;
        dc.item = sender;
    }else if([@"Post" isEqualToString:segue.identifier]){
        PostViewController *pc = (PostViewController*)segue.destinationViewController;
        pc.zumpa = self.zumpa;
    }else if([@"Settings" isEqualToString:segue.identifier]){
        SettingsViewController *scv = (SettingsViewController*)segue.destinationViewController;
        scv.zumpa = self.zumpa;
        scv.delegate = self;
    }

}


-(void)setSpinnerVisible:(BOOL) visible{
    
    if(visible){
        UIActivityIndicatorView *activityIndicator =
        [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        UIBarButtonItem * barButton =
        [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
        [activityIndicator startAnimating];
        self.navigationItem.rightBarButtonItem = barButton;
    }else{
        self.navigationItem.rightBarButtonItem = self.reloadButton;
    }
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [self setReloadButton:nil];
    [super viewDidUnload];
}

-(void)settingsWillClose:(id)source{
    
}
@end
