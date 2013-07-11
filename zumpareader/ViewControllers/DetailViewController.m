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

#define DISPLAY_WIDTH self.view.frame.size.width
@interface DetailViewController () <PostViewControllerDelegate>


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

@end

@implementation DetailViewController


@synthesize zumpa = _zumpa;
@synthesize item = _item;
@synthesize items = _items;
@synthesize heights = _heights;
@synthesize measureCell = _measureCell;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initHeader];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.measureFont = [UIFont fontWithName:@"Verdana" size:14];
    
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"ZumpaSubViewCell" owner:nil options:nil];
    self.measureCell = [nibObjects lastObject];
    
    self.colorEven = [UIColor whiteColor];
    self.colorOdd = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZumpaSubViewCell" bundle:nil] forCellReuseIdentifier:@"DetailCell"];
    self.items = [[NSMutableArray alloc]init];
    self.heights = [[NSMutableArray alloc]init];
    [self dataWillLoad];
    
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) initHeader{
    UIBarButtonItem *reload = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(dataWillLoad:)];
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addDidClick:)];
    
     self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:reload,add,nil];
}

-(void)dataWillLoad{
    if(self.isLoading == NO){
        [self setSpinnerVisible:YES];
        self.isLoading = YES;
        [self.zumpa getSubItemsWithUrl:self.item.itemsUrl andCallback:^(NSArray *array)  {
            [self dataDidLoad:array];
        }];
    }
}

-(void)dataDidLoad:(NSArray *)items{
    [self clientDidFinishLoading];
    [self.items removeAllObjects];
    [self.items addObjectsFromArray:items];
    [self.tableView reloadData];
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
    static NSString *CellIdentifier = @"DetailCell";
    ZumpaSubViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    ZumpaSubItem *zsi = [self.items objectAtIndex:indexPath.item];
    
    [cell setItem:zsi];
    [self.heights insertObject:[NSNumber numberWithInt:cell.height] atIndex:indexPath.item];
    return cell;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setBackgroundColor: (indexPath.row % 2 == 0) ? self.colorEven : self.colorOdd];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZumpaSubItem *zsi = [self.items objectAtIndex:indexPath.item];
    CGSize size = CGSizeMake(DISPLAY_WIDTH - 10, 100000);
    CGSize measuredSize = [zsi.body sizeWithFont:self.measureFont constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
    return measuredSize.height + 40;
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
    }
}

-(void) userDidSendMessage{
    [self dataWillLoad];
}

@end
