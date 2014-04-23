//
//  DetailViewController.m
//  ZumpaReader
//
//  Created by Joe Scurab on 7/8/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "DetailViewController.h"
#import "ZumpaSubItem.h"
#import "PostViewController.h"
#import "UISurvey.h"
#import "I18N.h"
#import "DialogHelper.h"
#import "Settings.h"
#import "ZRSubViewCell.h"

#define CONTENT_OFFSET @"contentOffset"

@interface DetailViewController () <PostViewControllerDelegate, UISurveyDelegate>


-(void)setSpinnerVisible:(BOOL) visible;
-(void)dataDidLoad:(NSArray*) items;
-(void)clientDidFinishLoading;
-(void)dataWillLoad;

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableDictionary *itemViews;
@property (nonatomic, strong) NSMutableDictionary *itemHeights;

@property (nonatomic) BOOL isLoading;
@property (strong, nonatomic) UIColor *colorEven;
@property (strong, nonatomic) UIColor *colorOdd;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) BOOL mustResetContentOffset;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *favorite;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *reloadButton;

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initHeader];
    self.title = self.item.subject;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.colorEven = [UIColor whiteColor];
    self.colorOdd = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    self.items = [[NSMutableArray alloc]init];
    self.itemHeights = [[NSMutableDictionary alloc]init];
    self.itemViews = [[NSMutableDictionary alloc]init];
    [self dataWillLoad];
    [self initFavoriteButton];
    self.addButton.enabled = [self.settings boolForKey:IS_LOGGED_IN];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) initFavoriteButton{
    [self.favorite setTitle:self.item.favoriteThread ? NSLoc(@"SetNoFavorite") :NSLoc(@"SetFavorite")];
    self.favorite.enabled = [self.settings boolForKey:IS_LOGGED_IN];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView addObserver:self forKeyPath:CONTENT_OFFSET options:(NSKeyValueObservingOptionNew) context:NULL];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.tableView removeObserver:self forKeyPath:CONTENT_OFFSET];
    [super viewWillDisappear:animated];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if(self.tableView.contentSize.height < self.tableView.frame.size.height){
        return;
    }
    int y = self.tableView.contentSize.height - (int)self.tableView.contentOffset.y - self.tableView.frame.size.height;
    if(!self.mustResetContentOffset &&  y < -100){
        [self dataWillLoad];
        self.mustResetContentOffset = YES;
    }
    
    if(self.mustResetContentOffset){
        self.mustResetContentOffset = !(y >= 0);//let overscroll return before next request
    }
}

-(void) initHeader{
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        
    self.reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(dataWillLoad:)];
    
    self.navigationItem.rightBarButtonItem = self.reloadButton;
}

-(void)dataWillLoad{
    if(self.isLoading == NO){
        self.isLoading = YES;
        [self setSpinnerVisible:YES];
        __weak DetailViewController *zelf = self;
        [self.zumpa getSubItemsWithUrl:self.item.itemsUrl andCallback:^(NSArray *array)  {
            if(zelf){
                [zelf dataDidLoad:array];
            }
        }];
    }
}

-(void)dataDidLoad:(NSArray *)items{
    [self.items removeAllObjects];
    [self.items addObjectsFromArray:items];
    [self.tableView reloadData];
    [self clientDidFinishLoading];
}

-(void)clientDidFinishLoading{
    [self setSpinnerVisible:NO];
    self.isLoading = NO;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.itemViews objectForKey:@(indexPath.row)];
    return cell;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    ZumpaSubItem *item = self.items[indexPath.row];
    NSNumber *height = [self.itemHeights objectForKey:@(indexPath.row)];
    if (height) {
        return [height intValue];
    }

    ZRSubViewCell *zsvc = [ZRSubViewCell create];
    [zsvc setBackgroundColor: (indexPath.row % 2 == 0) ? self.colorEven : self.colorOdd];
    [self.itemViews setObject:zsvc forKey:@(indexPath.row)];

    zsvc.item = item;
    int h = [zsvc.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;//safety 1 from webinar
    [self.itemHeights setObject:@(h) forKey:@(indexPath.row)];
    return h;
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
- (IBAction)dataWillLoad:(id)sender {
    [self dataWillLoad];
}

- (IBAction)addDidClick:(id)sender {
    [self performSegueWithIdentifier:@"Post" sender:sender];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setFavorite:nil];
    [super viewDidUnload];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([@"Post" isEqualToString:segue.identifier]){
        PostViewController *pvc = (PostViewController*) segue.destinationViewController;
        pvc.item = self.item;
        pvc.zumpa = self.zumpa;
        pvc.delegate = self;
        pvc.settings = self.settings;
        
        if([sender isKindOfClass:[NSString class]]){
            pvc.prefilledMessage = sender;
        }
    }
}

-(void) userDidSendMessage{
    [self dataWillLoad];
}

-(void)didVote:(int)surveyButtonIndex{
    if(![self.settings boolForKey:IS_LOGGED_IN]){
        [[[UIAlertView alloc] initWithTitle:NSLoc(@"Error") message:NSLoc(@"NotLoggedIn") delegate:nil cancelButtonTitle:NSLoc(@"OK") otherButtonTitles:nil] show];
        return;
    }
    __weak ZumpaSubItem *zsi = [self.items objectAtIndex:0];
    if(zsi.survey){
        __weak UIActivityIndicatorView *pbar = [DialogHelper showProgressDialog:self.view];
        __weak DetailViewController *zelf = self;
        [self.zumpa voteSurvey:zsi.survey.ID forItem:surveyButtonIndex withCallback:^(Survey *newSurvey) {
            if(zelf){
                [pbar removeFromSuperview];
                //TODO:Survey handling
//                zsi.survey = newSurvey;
//                if(zelf.survey){
//                    [zelf.survey setSurvey: newSurvey];
//                }else{
//                    [zelf.tableView reloadData];
//                }
                [zelf.tableView reloadData];
            }
        }];
    }else{
        [[[UIAlertView alloc]initWithTitle:NSLoc(@"Error") message:NSLoc(@"WTF_SurveyNotFound") delegate:nil cancelButtonTitle:NSLoc(@"OK") otherButtonTitles: nil]show];
    }
}
- (IBAction)favoriteDidCllick:(id)sender {
    if(self.isLoading == NO){
        if(![self.settings boolForKey:IS_LOGGED_IN]){
            [[[UIAlertView alloc] initWithTitle:NSLoc(@"Error") message:NSLoc(@"NotLoggedIn") delegate:nil cancelButtonTitle:NSLoc(@"OK") otherButtonTitles:nil] show];
            return;
        }
        [self setSpinnerVisible:YES];
        __weak DetailViewController *zelf = self;
        ZumpaItem *zi = self.item;
        [self.zumpa switchFavoriteThread:zi.ID withCallback:^(BOOL result) {
            if(zelf){
                if(result){
                    zi.favoriteThread = !zi.favoriteThread;
                    [zelf initFavoriteButton];
                }
                [zelf setSpinnerVisible:NO];
            }
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}


@end
