//
//  DetailViewController.m
//  ZumpaReader
//
//  Created by Joe Scurab on 7/8/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "DetailViewController.h"
#import "ZumpaSubItem.h"
#import "ZumpaSubViewCell.h"
#import "PostViewController.h"
#import "Survey.h"
#import "UISurvey.h"
#import "I18N.h"
#import "DialogHelper.h"

#define MESSAGE_WIDTH self.view.frame.size.width - 16
#define CONTENT_OFFSET @"contentOffset"

#define CELL_IDENTITY @"DetailCell"

@interface DetailViewController () <PostViewControllerDelegate, UISurveyDelegate>


-(void)setSpinnerVisible:(BOOL) visible;
-(void)dataDidLoad:(NSArray*) items;
-(void)clientDidFinishLoading;
-(void)dataWillLoad;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *plusButton;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic) BOOL isLoading;
@property (strong, nonatomic) UIColor *colorEven;
@property (strong, nonatomic) UIColor *colorOdd;
@property (strong, nonatomic) NSMutableArray *heights;
@property (strong, nonatomic) ZumpaSubViewCell *measureCell;
@property (strong, nonatomic) UIFont *measureFont;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UISurvey *survey;
@property (nonatomic) BOOL mustResetContentOffset;

@end

@implementation DetailViewController


@synthesize zumpa = _zumpa;
@synthesize item = _item;
@synthesize items = _items;
@synthesize heights = _heights;
@synthesize settings = _settings;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initHeader];
    [self initMeasurementStuff];
    self.title = self.item.subject;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.colorEven = [UIColor whiteColor];
    self.colorOdd = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZumpaSubViewCell" bundle:nil] forCellReuseIdentifier:@"DetailCell"];
    self.items = [[NSMutableArray alloc]init];
    self.heights = [[NSMutableArray alloc]init];
    [self dataWillLoad];
    
    [self.tableView addObserver:self forKeyPath:CONTENT_OFFSET options:(NSKeyValueObservingOptionNew) context:NULL];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

-(void) initMeasurementStuff{
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"ZumpaSubViewCell" owner:nil options:nil];
    ZumpaSubViewCell *cell = [nibObjects lastObject];
    self.measureFont = [cell fontForMeasurement];
}

-(void) initHeader{
    UIBarButtonItem *reload = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(dataWillLoad:)];
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addDidClick:)];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:reload,add,nil];
}

-(void)dataWillLoad{
    if(self.isLoading == NO){
        self.isLoading = YES;
        [self setSpinnerVisible:YES];
        self.survey = nil;
        [self.zumpa getSubItemsWithUrl:self.item.itemsUrl andCallback:^(NSArray *array)  {
            [self dataDidLoad:array];
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
    ZumpaSubViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTITY forIndexPath:indexPath];
    cell.surveyDelegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ZumpaSubItem *zsi = [self.items objectAtIndex:indexPath.item];
    
    [cell setItem:zsi withSurvey:!self.survey];
    [self.heights insertObject:[NSNumber numberWithInt:cell.height] atIndex:indexPath.item];
    return cell;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    ZumpaSubViewCell *zsvc = ((ZumpaSubViewCell*)cell);
    if(indexPath.item == 0){
        if(self.survey){
            zsvc.survey = self.survey;
            [zsvc addSubview: zsvc.survey];
        }else{
            self.survey = zsvc.survey;
        }
    }
    [cell setBackgroundColor: (indexPath.row % 2 == 0) ? self.colorEven : self.colorOdd];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZumpaSubItem *zsi = [self.items objectAtIndex:indexPath.item];
    CGSize size = CGSizeMake(MESSAGE_WIDTH, 100000);
    CGSize measuredSize = [zsi.body sizeWithFont:self.measureFont constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
    int height = measuredSize.height + 40;
    if(zsi.survey){
        height += [UISurvey estimateHeight:zsi.survey forWidth:self.view.frame.size.width];
    }
    return height;
}

-(void)setSpinnerVisible:(BOOL) visible{
    
    if(visible){
        self.plusButton = self.navigationItem.rightBarButtonItem;
        UIActivityIndicatorView *activityIndicator =
        [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        UIBarButtonItem * barButton =
        [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
        [activityIndicator startAnimating];
        
        self.navigationItem.rightBarButtonItem = barButton;
    }else{
        self.navigationItem.rightBarButtonItem = self.plusButton;
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
    [super viewDidUnload];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([@"Post" isEqualToString:segue.identifier]){
        PostViewController *pvc = (PostViewController*) segue.destinationViewController;
        pvc.item = self.item;
        pvc.zumpa = self.zumpa;
        pvc.delegate = self;
        pvc.settings = self.settings;
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.item == 0){
        ZumpaSubViewCell *zsvc = (ZumpaSubViewCell*)cell;
        if(zsvc.survey){
            self.survey = (self.isLoading) ? nil : zsvc.survey;
            [zsvc.survey removeFromSuperview];
            zsvc.survey = nil;
        }
    }
}

-(void) userDidSendMessage{
    [self dataWillLoad];
}

-(void)didVote:(int)surveyButtonIndex{
    ZumpaSubItem *zsi = [self.items objectAtIndex:0];
    if(zsi.survey){        
        UIActivityIndicatorView *pbar = [DialogHelper showProgressDialog:self.view];
        [self.zumpa voteSurvey:zsi.survey.ID forItem:surveyButtonIndex withCallback:^(Survey *newSurvey) {
            [pbar removeFromSuperview];
            zsi.survey = newSurvey;
            if(self.survey){
                [self.survey setSurvey: newSurvey];
            }else{
                [self.tableView reloadData];
            }
        }];
    }else{
        [[[UIAlertView alloc]initWithTitle:NSLoc(@"Error") message:NSLoc(@"WTF_SurveyNotFound") delegate:nil cancelButtonTitle:NSLoc(@"OK") otherButtonTitles: nil]show];
    }
}

@end
