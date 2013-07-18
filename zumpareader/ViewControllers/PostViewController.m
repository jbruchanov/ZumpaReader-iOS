//
//  PostViewController.m
//  ZumpaReader
//
//  Created by Joe Scurab on 7/9/13.
//  Copyright (c) 2013 Jiri Bruchanov. All rights reserved.
//

#import "PostViewController.h"
#import "DialogHelper.h"
#import <AssetsLibrary/ALAsset.h>
#import "I18N.h"
#import "ImageEditorViewController.h"
#import "Settings.h"

#define DISPLAY_WIDTH self.view.frame.size.width
#define JPEG_QUALITY 0.8
#define MAX_IMAGE_SIZE 1000.0

@interface PostViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate, UIActionSheetDelegate, ImageEditorViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *message;
@property (weak, nonatomic) IBOutlet UITextField *subject;
@property (strong, nonatomic) UIActivityIndicatorView *pBar;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;

@property (nonatomic) UIImagePickerController *imagePickerController;

@property (strong, nonatomic) UIImage *selectedImage;


@end

@implementation PostViewController

CGRect originalScrollViewRect;

@synthesize zumpa = _zumpa, delegate = _delegate, item = _item, selectedImage = _selectedImage, settings = _settings;

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
    
    self.scrollView.delegate = self;
    [self initKeyboardListeners];
    
    
    originalScrollViewRect = self.scrollView.frame;
    self.scrollView.contentSize = originalScrollViewRect.size;
    
    NSString *subj = [self.settings stringForKey:SUBJECT];
    NSString *msg = [self.settings stringForKey:MESSAGE];
    
    if(self.item){
        self.subject.text = self.item.subject;
    }else if(subj){
        self.subject.text = subj;
    }
    
    if(msg){
        self.message.text = subj;
    }
    
    //    self.message.layer.borderWidth = 1;
    //    self.message.layer.borderColor = [[UIColor grayColor] CGColor];
    
	// Do any additional setup after loading the view.
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"%f decelerate:%@", scrollView.bounds.origin.y, decelerate ? @"Y" : @"N");
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
    self.subject.text = @"";
    self.message.text = @"";
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
        [[[UIAlertView alloc]initWithTitle:NSLoc(@"Nope") message:NSLoc(@"SubjectOrMessageEmpty") delegate:nil cancelButtonTitle:NSLoc(@"OK") otherButtonTitles: nil] show];
    }
}

-(void) zumpaDidPost:(BOOL) result{
    [self showProgressBar:NO];
    if(result){
        self.subject.text = @"";
        self.message.text = @"";
        [self.delegate userDidSendMessage];
        [self cancelDidClick:nil];
    }else{
        [[[UIAlertView alloc]initWithTitle:NSLoc(@"Error") message:NSLoc(@"SendingProblem") delegate:nil cancelButtonTitle:NSLoc(@"OK")  otherButtonTitles: nil] show];
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
    NSString *subj = self.subject.text;
    NSString *msg = self.message.text;
    if(subj){
        [self.settings setObject:subj forKey:SUBJECT];
    }
    if(msg){
        [self.settings setObject:msg forKey:MESSAGE];
    }
    [self.settings synchronize];

    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setMessageLabel:nil];
    [self setCameraButton:nil];
    [super viewDidUnload];
}
- (IBAction)cameraDidClick:(id)sender {
    [self showActionSheet];
}

-(void)showActionSheet{
    self.selectedImage = nil;
    if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront] ||
       [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]){
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:NSLoc(@"Source") delegate:self cancelButtonTitle:NSLoc(@"Cancel") destructiveButtonTitle:nil otherButtonTitles:NSLoc(@"Camera"), NSLoc(@"Gallery"), nil];
        [sheet showInView:self.view];
    }else{
        [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
    }else if (buttonIndex == 1){
        [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    self.imagePickerController = imagePickerController;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self doneDidClick:nil];//hide keyboard
    
    [picker dismissViewControllerAnimated:NO completion:nil]; //must be NO
    self.selectedImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    [self performSegueWithIdentifier:@"PhotoEdit" sender:self];
}

- (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([@"PhotoEdit" isEqualToString:segue.identifier]){
        ImageEditorViewController *ievc = segue.destinationViewController;
        ievc.image = self.selectedImage;
        ievc.delegate = self;
    }
}

-(void) didFinishEditing:(NSData *)result{
    if(result){
        UIActivityIndicatorView *pbar = [DialogHelper showProgressDialog:self.view];
        [self.zumpa sendImageToQ3:result withCallback:^(NSString *url) {
            [pbar removeFromSuperview];
            self.message.text = [self.message.text stringByAppendingFormat:@"\n%@",url];
        }];
    }
}

@end
