//
//  mobViewController.m
//  MobilityScorer
//
//  Created by Cryptoy on 27/06/2014.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "mobViewController.h"

@interface mobViewController () <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *managementIdTextField;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *selectButtons;
@property (strong,nonatomic) NSMutableDictionary *dict;

@end

@implementation mobViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.dict = [[NSMutableDictionary alloc ] init];
    
}

- (IBAction)zeroButtonAction:(id)sender {
    if (![self.managementIdTextField.text  isEqual: @""]) {
        [self.dict setValue:[NSNumber numberWithInt:0] forKey:[self.managementIdTextField text]];
    }
    
    self.managementIdTextField.text = nil;
    [self.managementIdTextField becomeFirstResponder];
    
    NSLog(@"%@", self.dict);
}
- (IBAction)oneButtonAction:(id)sender {
    if (![self.managementIdTextField.text  isEqual: @""]) {
        
        [self.dict setValue:[NSNumber numberWithInt:1] forKey:[self.managementIdTextField text]];
    }
    
    self.managementIdTextField.text = nil;
    [self.managementIdTextField becomeFirstResponder];
    
    NSLog(@"%@", self.dict);
}
- (IBAction)twoButtonAction:(id)sender {
    if (![self.managementIdTextField.text  isEqual: @""]) {
        
        [self.dict setValue:[NSNumber numberWithInt:2] forKey:[self.managementIdTextField text]];
    }
    
    self.managementIdTextField.text = nil;
    [self.managementIdTextField becomeFirstResponder];
    
    NSLog(@"%@", self.dict);
}
- (IBAction)threeButtonAction:(id)sender {
    if (![self.managementIdTextField.text  isEqual: @""]) {
        
        [self.dict setValue:[NSNumber numberWithInt:3] forKey:[self.managementIdTextField text]];
    }
    
    self.managementIdTextField.text = nil;
    [self.managementIdTextField becomeFirstResponder];
    
    NSLog(@"%@", self.dict);
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.managementIdTextField resignFirstResponder];
}

-(NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"Documents Directory: %@", documentsDirectory);
    return [documentsDirectory stringByAppendingPathComponent:@"myfile.csv"];
}

- (IBAction)saveAsFileAction:(id)sender {
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self dataFilePath]]) {
        [[NSFileManager defaultManager] removeItemAtPath:[self dataFilePath] error:nil];
        NSLog(@"Route remove");
    }
    NSLog(@"Then create");
    [[NSFileManager defaultManager] createFileAtPath: [self dataFilePath] contents:nil attributes:nil];
    
    
    NSMutableString *writeString = [NSMutableString stringWithCapacity:0]; //don't worry about the capacity, it will expand as necessary
    
    NSDate *currentDate = [[NSDate alloc] init];
    //NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *localDateString = [dateFormatter stringFromDate:currentDate];
    
    NSLog(@"Date: %@",localDateString);
    
    [writeString appendString: @"Event, LineNo, Date, Score,\n"];
    for (id key in self.dict) {
        [writeString appendString:[NSString stringWithFormat:@"%@, %@, %@, %@\n", @"z Score" , key, [self.dict valueForKey:key], localDateString]]; //the \n will put a newline in
    }


//Moved this stuff out of the loop so that you write the complete string once and only once.
NSLog(@"writeString :%@",writeString);

NSFileHandle *handle;
handle = [NSFileHandle fileHandleForWritingAtPath: [self dataFilePath] ];
//say to handle where's the file fo write
[handle truncateFileAtOffset:[handle seekToEndOfFile]];
//position handle cursor to the end of file
[handle writeData:[writeString dataUsingEncoding:NSUTF8StringEncoding]];
    
[handle closeFile];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/////

- (void)showEmail:(NSString*)file {
    
    NSString *emailTitle = @"Testing";
    NSString *messageBody = @"Testing with CSV";
    NSArray *toRecipents = [NSArray arrayWithObject:@"danhamilt1@blueyonder.co.uk"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Determine the file name and extension
    NSArray *filepart = [file componentsSeparatedByString:@"."];
    NSString *filename = [filepart objectAtIndex:0];
    NSString *extension = [filepart objectAtIndex:1];
    
    NSLog(@"Filename: %@",filename);
    NSLog(@"Extension: %@", extension);
    
    // Get the resource path and read the file using NSData
    //NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:extension];
    NSString *filePath = [self dataFilePath];
    
    NSLog(@"Filepath: %@", filePath);
    NSLog(@"Full Path: %@\n", [filePath stringByAppendingString:filename]);
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    
    // Determine the MIME type
    NSString *mimeType;
    if ([extension isEqualToString:@"jpg"]) {
        mimeType = @"image/jpeg";
    } else if ([extension isEqualToString:@"png"]) {
        mimeType = @"image/png";
    } else if ([extension isEqualToString:@"doc"]) {
        mimeType = @"application/msword";
    } else if ([extension isEqualToString:@"ppt"]) {
        mimeType = @"application/vnd.ms-powerpoint";
    } else if ([extension isEqualToString:@"html"]) {
        mimeType = @"text/html";
    } else if ([extension isEqualToString:@"pdf"]) {
        mimeType = @"application/pdf";
    } else if ([extension isEqualToString:@"csv"]){
        mimeType = @"text/csv";
    }
    
    // Add attachment
    [mc addAttachmentData:fileData mimeType:mimeType fileName:filename];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (IBAction)sendEmail:(id)sender {
    
    [self showEmail:@"myfile.csv"];
    
}

/////

@end
