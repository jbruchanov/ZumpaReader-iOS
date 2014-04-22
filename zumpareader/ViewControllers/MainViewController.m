//
//  MainViewController.m
//  ZumpaReader
//
//  Created by Joe Scurab on 7/7/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "MainViewController.h"
#import "ZumpaAsyncWrapper.h"
#import "ZumpaItem.h"
#import "DetailViewController.h"
#import "PostViewController.h"
#import "SettingsViewController.h"
#import "Settings.h"
#import "I18N.h"
#import "ZRMainViewCell.h"

#define DISPLAY_WIDTH self.view.frame.size.width
#define LOAD_LIMIT_OFFSET 5
#define REQUEST_ITEMS_SIZE 35
#define CONTENT_OFFSET @"contentOffset"
#define REUSE_KEY @"ZRMainViewCell"

@interface MainViewController () <SettingsViewControllerDelegate, PostViewControllerDelegate, ZumpaWSClientDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) ZumpaAsyncWrapper *zumpa;
@property (strong, nonatomic) NSMutableArray* zumpaItems;
@property (strong, nonatomic) NSMutableDictionary* zumpaItemHeights;
@property (strong, nonatomic) ZumpaMainPageResult* currentResult;
@property (nonatomic) BOOL isLoading;
@property (strong, nonatomic) UIColor *colorEven;
@property (strong, nonatomic) UIColor *colorOdd;
@property (strong, nonatomic) ZRMainViewCell *measureCell;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *reloadButton;
@property (strong, nonatomic) NSUserDefaults *settings;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *filterButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *postButton;
@property (nonatomic) BOOL mustResetContentOffset;
@property (nonatomic, strong) NSString *userName;

-(void)setSpinnerVisible:(BOOL) visible;
-(void)didReceiveResponse:(ZumpaMainPageResult*) result appendData:(BOOL) append;
-(void)willReload;
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

    self.zumpaItemHeights = [[NSMutableDictionary alloc]init];
    self.settings = [[NSUserDefaults alloc]init];
    self.userName = [self.settings stringForKey:USERNAME];

    NSBundle *bundle = [NSBundle mainBundle];
    NSDictionary *info = [bundle infoDictionary];
    NSString *prodName = [info objectForKey:@"CFBundleDisplayName"];
    self.title = prodName;
    
    self.colorEven = [UIColor whiteColor];
    self.colorOdd = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    
    [self setSpinnerVisible:YES];
    self.zumpaItems = [[NSMutableArray alloc]init];
    ZumpaWSClient *client = [[ZumpaWSClient alloc]init];
    client.delegate = self;
    self.zumpa = [[ZumpaAsyncWrapper alloc]initWithWebService:client];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsMake(0,0,0,0);

    [self willReload];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    int y = (int)self.tableView.contentOffset.y;
    if(!self.mustResetContentOffset &&  y < -100){
        [self willReload];
        self.mustResetContentOffset = YES;
    }
    
    if(self.mustResetContentOffset){
        self.mustResetContentOffset = !(y >= 0);//let overscroll return before next request
    }
}

-(void)hasErrorDuringSending:(NSError *)error{
    [[[UIAlertView alloc]initWithTitle:NSLoc(@"Error") message:[error localizedDescription] delegate:nil cancelButtonTitle:NSLoc(@"OK") otherButtonTitles: nil]show];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.postButton setEnabled:[self.settings boolForKey:IS_LOGGED_IN]];
    [self.filterButton setEnabled:[self.settings boolForKey:IS_LOGGED_IN]];
    [self.tableView addObserver:self forKeyPath:CONTENT_OFFSET options:(NSKeyValueObservingOptionNew) context:NULL];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tableView removeObserver:self forKeyPath:CONTENT_OFFSET];
}

- (IBAction)reloadDidClick:(id)sender {
    [self willReload];
}

-(void)didReceiveResponse:(ZumpaMainPageResult*) result appendData:(BOOL)append{
    [self setSpinnerVisible:NO];
    self.isLoading = NO;
    self.currentResult = result;
    if(!append){
        [self.zumpaItems removeAllObjects];
        NSArray *paths = [self.tableView indexPathsForVisibleRows];
        NSIndexPath *ip = [paths lastObject];
        if(ip && ip.item > REQUEST_ITEMS_SIZE){ //scroll only if we reloaded data and user is below first page
            [self.tableView scrollsToTop];
        }
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
    ZRMainViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REUSE_KEY];
    if(!cell){
        cell = [tableView dequeueReusableCellWithIdentifier:REUSE_KEY];
    }

    int index = indexPath.item;
    if(index == [self.zumpaItems count] - LOAD_LIMIT_OFFSET){
        [self willLoadNextPage];
    }
    ZumpaItem *zi = [self.zumpaItems objectAtIndex:index];
    [cell setItem:zi];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    ZumpaItem *item = self.zumpaItems[indexPath.row];
    NSNumber *height = [self.zumpaItemHeights objectForKey:@(item.ID)];
    if(height){
        return [height intValue];
    }

    if(!self.measureCell){
        UINib *nib = [UINib nibWithNibName:@"ZRMainViewCell" bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:REUSE_KEY];
        self.measureCell = [tableView dequeueReusableCellWithIdentifier:REUSE_KEY];
    }

    self.measureCell.item = item;
    [self.measureCell layoutIfNeeded];
    int h = [self.measureCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;//safety 1 from webinar
    [self.zumpaItemHeights setObject:@(h) forKey:@(item.ID)];
    return h;
}

-(void)willReload{
    if(!self.isLoading){
        self.isLoading = YES;
        [self setSpinnerVisible:YES];
        __weak MainViewController *zelf = self;
        [self.zumpa getItemsWithCallback:^(ZumpaMainPageResult *result) {
            if(zelf){
                [zelf didReceiveResponse:result appendData:NO];
            }
        }];
    }
}

-(void)willLoadNextPage{
    if(!self.isLoading && self.currentResult){
        NSString *nextPage = self.currentResult.nextPage;
        if(nextPage){
            [self setSpinnerVisible:YES];
            __weak MainViewController *zelf = self;
            [self.zumpa getItemsWithUrl:nextPage andCallback:^(ZumpaMainPageResult *result) {
                if(zelf){
                    [zelf didReceiveResponse:result appendData:YES];
                }
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
        dc.settings = self.settings;
    }else if([@"Post" isEqualToString:segue.identifier]){
        PostViewController *pc = (PostViewController*)segue.destinationViewController;
        pc.zumpa = self.zumpa;
        pc.delegate = self;
        pc.settings = self.settings;
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
    [self setPostButton:nil];
    [super viewDidUnload];
}

-(void)settingsWillClose:(id)source{
    self.userName = [self.settings stringForKey:USERNAME];
}

- (IBAction)filterDidClick:(id)sender {
    [[[UIActionSheet alloc]initWithTitle:NSLoc(@"Filter") delegate:self cancelButtonTitle:NSLoc(@"Cancel") destructiveButtonTitle:nil otherButtonTitles:NSLoc(@"NoFilter"),NSLoc(@"ByOwnThreads"),NSLoc(@"ByFavThreads"), nil] showFromBarButtonItem:sender animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex >= 0 && buttonIndex <= 2){
        [self.settings setInteger:buttonIndex forKey:FILTER];
        [self.settings synchronize];
        [self willReload];
    }
}

-(void)userDidSendMessage{
    [self willReload];
}
@end
