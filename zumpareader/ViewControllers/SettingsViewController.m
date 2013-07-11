//
//  SettingsViewController.m
//  zumpareader
//
//  Created by Joe Scurab on 7/11/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "SettingsViewController.h"
#import "Settings.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) NSUserDefaults *settings;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UILabel *loginStatus;

-(void) initButtons;
-(void) loadSettings;

@end

@implementation SettingsViewController

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
    self.settings = [[NSUserDefaults alloc]init];
    [self initButtons];
    [self loadSettings];
}

- (void)viewDidUnload {
    [self setLoginButton:nil];
    [self setUserName:nil];
    [self setPassword:nil];
    [self setLoginStatus:nil];
    [self setLoginButton:nil];
    [super viewDidUnload];
}

-(void)viewWillDisappear:(BOOL)animated{
    if(self.delegate){
        [self.delegate settingsWillClose:self];
    }
    [super viewWillDisappear:animated];
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
    if([self.settings boolForKey:IS_LOGGED_IN] == NO){
        NSString *uid = self.userName.text;
        NSString *pwd = self.password.text;
        
        if([uid length] == 0 || [pwd length] == 0){
            [[[UIAlertView alloc]initWithTitle:@"Nope :P" message:@"Missing username or password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            return;
        }
        [self.zumpa logIn:uid andPassword:pwd withCallback:^(BOOL result) {
            [self loginStatusChanged:result save:YES];
            if(!result){
                [[[UIAlertView alloc]initWithTitle:@":(" message:@"Unable to login" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }

        }];
    }else{
        [self.zumpa logOutWithCallback:^(BOOL result) {
            [self loginStatusChanged:!result save:YES];
        }];
    }
}

-(void) loadSettings{
    self.userName.text = [self.settings stringForKey:USERNAME];
    self.password.text = [self.settings stringForKey:PASSWORD];
    BOOL isLoggedIn = [self.settings boolForKey:IS_LOGGED_IN];
    self.loginStatus.text = isLoggedIn ? @"YES" : @"NO";
    [self loginStatusChanged:isLoggedIn save:NO];
}

-(void) loginStatusChanged:(BOOL) isLoggedIn save:(BOOL) saveIt{
    if(saveIt){
        [self.settings setBool:isLoggedIn forKey:IS_LOGGED_IN];
        [self.settings synchronize];
    }
    self.loginStatus.text = isLoggedIn ? @"YES" : @"NO";
    [self.loginButton setTitle:isLoggedIn ? @"Logout" : @"Login" forState:UIControlStateNormal];
}
@end
