//
//  PostViewController.m
//  ZumpaReader
//
//  Created by Joe Scurab on 7/9/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "PostViewController.h"
#import "DialogHelper.h"

#define DISPLAY_WIDTH self.view.frame.size.width

@interface PostViewController ()
@property (weak, nonatomic) IBOutlet UITextView *message;
@property (weak, nonatomic) IBOutlet UITextField *subject;
@property (strong, nonatomic) UIActivityIndicatorView *pBar;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;


@end

@implementation PostViewController

CGRect originalScrollViewRect;

@synthesize zumpa = _zumpa, delegate = _delegate, item = _item;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initKeyboardListeners];
    if(self.item){
        self.subject.text = self.item.subject;
        [self.subject setEnabled:NO];
    }
    
    originalScrollViewRect = self.scrollView.frame;
    self.scrollView.contentSize = originalScrollViewRect.size;
    
//    self.message.layer.borderWidth = 1;
//    self.message.layer.borderColor = [[UIColor grayColor] CGColor];
    
	// Do any additional setup after loading the view.
}

-(void) initKeyboardListeners{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

-(void) onKeyboardShow:(NSNotification *) notification{
    CGRect r = originalScrollViewRect;
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    self.scrollView.frame = CGRectMake(r.origin.x, r.origin.y, r.size.width, r.size.height - kbSize.height);
}

-(void) onKeyboardHide:(NSNotification *)notification{
    self.scrollView.frame = originalScrollViewRect;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancelDidClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)doneDidClick:(id)sender {
    [self.subject resignFirstResponder];
    [self.message resignFirstResponder];
}
- (IBAction)sendDidClick:(id)sender {
    [self doneDidClick:nil];
    NSString *subj = [self.subject.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *msg = [self.message.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([subj length] > 0 && [msg length] > 0){
        [self showProgressBar:YES];
        if(self.item){
            [self.zumpa replyToThread:self.item.ID withSubject:subj andMessage:msg withCallback:^(BOOL result) {
                [self zumpaDidPost:result];
            }];
        }else{
            [self.zumpa postThread:subj andMessage:msg withCallback:^(BOOL result) {
                [self zumpaDidPost:result];
            }];
        }
    }else{
        [[[UIAlertView alloc]initWithTitle:@"Nope :P" message:@"Subject or message is incomplete!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
}

-(void) zumpaDidPost:(BOOL) result{
    [self showProgressBar:NO];
    if(result){
        [self.delegate userDidSendMessage];
        [self cancelDidClick:nil];
    }else{
        [[[UIAlertView alloc]initWithTitle:@"Error :(" message:@"Some problem with sending!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
}

-(void)showProgressBar:(BOOL) visible{
    if(visible){
        self.pBar = [DialogHelper showProgressDialog:self.view];
    }else{
        [self.pBar removeFromSuperview];
        [self.pBar stopAnimating];
        self.pBar = nil;
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setMessageLabel:nil];
    [super viewDidUnload];
}
@end
