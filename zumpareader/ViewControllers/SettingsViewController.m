//
//  SettingsViewController.m
//  zumpareader
//
//  Created by Joe Scurab on 7/11/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "SettingsViewController.h"
#import "Settings.h"
#import "DialogHelper.h"
#import "I18N.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) NSUserDefaults *settings;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UILabel *loginStatus;
@property (weak, nonatomic) UIActivityIndicatorView *progressBar;
@property (weak, nonatomic) IBOutlet UITextField *responseNick;
@property (weak, nonatomic) IBOutlet UISwitch *lastPostAuthor;
@property (weak, nonatomic) IBOutlet UILabel *lastPostAuthorLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

-(void) initButtons;
-(void) loadSettings;
@end

@implementation SettingsViewController

CGRect originalScrollViewRect;

@synthesize delegate = _delegate;

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

    [self.userName setPlaceholder:NSLoc(@"Username")];
    [self.password setPlaceholder:NSLoc(@"Password")];
    [self.responseNick setPlaceholder:NSLoc(@"ResponseNick")];
    [self.lastPostAuthorLabel setText:NSLoc(@"LastPostAuthor")];
    self.settings = [NSUserDefaults standardUserDefaults];
    [self initButtons];
    [self loadSettings];
    
    //add nice background for edittexts and left margin
    UIImage *normal = [[UIImage imageNamed:@"home_button_background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    NSArray *textboxes = [NSArray arrayWithObjects:self.userName, self.password, self.responseNick, nil];
    for(UITextField *tf  in textboxes){
        tf.borderStyle = UITextBorderStyleNone;
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
        tf.leftView = paddingView;
        tf.leftViewMode = UITextFieldViewModeAlways;
        [tf setBackground:normal];
    }
    
    originalScrollViewRect = self.scrollView.frame;
    self.scrollView.contentSize = originalScrollViewRect.size;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    
    CGRect frame = bounds;
    frame.origin.y = 3;
    frame.origin.x = 5;
    bounds = frame;
    return CGRectInset( bounds , 0 , 0 );
}

- (void)viewDidUnload {
    [self setLoginButton:nil];
    [self setUserName:nil];
    [self setPassword:nil];
    [self setLoginStatus:nil];
    [self setLoginButton:nil];
    [self setLastPostAuthorLabel:nil];
    [super viewDidUnload];
}

-(void) saveSettings{
    //stuff around login is on diff place
    [self.settings setObject:self.responseNick.text forKey:NICK_RESPONSE];
    [self.settings setBool:[self.lastPostAuthor isOn] forKey:LAST_ANSWER_AUTHOR];
    [self.settings synchronize];
}

-(void)initButtons{
    UIImage *buttonImage = [[UIImage imageNamed:@"home_button_background"]
                            stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [self.loginButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    
    buttonImage = [[UIImage imageNamed:@"home_button_background_hit"]
                   stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [self.loginButton setBackgroundImage:buttonImage forState:UIControlStateHighlighted];
    
}

- (IBAction)loginDidClick:(id)sender {
    [self.progressBar removeFromSuperview];
    __weak SettingsViewController *zelf = self;
    zelf.loginButton.enabled = NO;
    __block NSString *userName = self.userName.text;

    if([self.settings boolForKey:IS_LOGGED_IN] == NO){
        NSString *pwd = self.password.text;
        
        if([userName length] == 0 || [pwd length] == 0){
            [[[UIAlertView alloc]initWithTitle:@"Nope :P" message:@"Missing username or password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            return;
        }
        self.progressBar = [DialogHelper showProgressDialog:self.view];

        [self.zumpa logIn:userName andPassword:pwd withCallback:^(LoginResult *result) {
            if (zelf) {
                [zelf loginStatusChanged:result.Result save:YES];
                zelf.loginButton.enabled = YES;
                [[[UIAlertView alloc] initWithTitle:(!result ? @":(" : @":)") message:result.ZumpaResult delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];

                NSString *token = [zelf.settings valueForKey:PUSH_TOKEN];
                if (token && [token length] > 0) {
                    [zelf.zumpa register:YES pushToken:token forUser:userName withUID:result.UID withCallback:^(BOOL pushReggged) {
                        if (!pushReggged) {
                            [[[UIAlertView alloc] initWithTitle:@":(" message:@"Unable to send push token" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                        }
                    }];
                }
            }
        }];
    }else{
        self.progressBar = [DialogHelper showProgressDialog:self.view];
        self.loginButton.enabled = NO;
        [self.zumpa logOutWithCallback:^(BOOL result) {
            if(zelf){
                zelf.loginButton.enabled = YES;
                [zelf loginStatusChanged:!result save:YES];
                [zelf.zumpa register:NO pushToken:@"" forUser:userName withUID:@"" withCallback:nil];
            }
        }];
    }
}

-(void) loadSettings{
    self.userName.text = [self.settings stringForKey:USERNAME];
    self.password.text = [self.settings stringForKey:PASSWORD];
    BOOL isLoggedIn = [self.settings boolForKey:IS_LOGGED_IN];
    self.loginStatus.text = isLoggedIn ? @"YES" : @"NO";
    [self loginStatusChanged:isLoggedIn save:NO];
    self.responseNick.text = [self.settings stringForKey:NICK_RESPONSE];
    [self.lastPostAuthor setOn:[self.settings boolForKey:LAST_ANSWER_AUTHOR]];
}

-(void) loginStatusChanged:(BOOL) isLoggedIn save:(BOOL) saveIt{
    self.loginButton.enabled = YES;
    [self.progressBar removeFromSuperview];
    self.progressBar = nil;
    if(saveIt){
        [self.settings setBool:isLoggedIn forKey:IS_LOGGED_IN];
    }
    self.loginStatus.text = isLoggedIn ? @"YES" : @"NO";
    [self.loginButton setTitle:isLoggedIn ? @"Logout" : @"Login" forState:UIControlStateNormal];
}
- (IBAction)didSaveClick:(id)sender {
    [self saveSettings];
    if(self.delegate){
        [self.delegate settingsWillClose:self];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
