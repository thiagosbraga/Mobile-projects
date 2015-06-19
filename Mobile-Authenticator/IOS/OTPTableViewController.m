//
//  OTPTableViewController.m
//  OTP-Test
//
//  Created by PRODUBAN on 6/18/15.
//  Copyright (c) 2015 Produban. All rights reserved.
//

#import "OTPTableViewController.h"
#import "OTPTableViewCell.h"
#import "QrCodeViewController.h"
#import "OTPGen.h"


@interface OTPTableViewController ()

@end

@implementation OTPTableViewController

UIBarButtonItem *refreshButton;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _controller = [[OTPController alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title =@"OTP TOKEN";
    [self setupNavigationController];
    [self getLista];
//    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getLista) userInfo:nil repeats:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupNavigationController{
    
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(lerCodigo)];
    NSMutableArray *buttons = [[NSMutableArray alloc]init];
    [buttons addObject:refreshButton];
    [buttons addObject:self.editButtonItem];
	//self.navigationItem.rightBarButtonItem = refreshButton;
    self.navigationItem.rightBarButtonItems =buttons;
}

-(void)getLista{

    _list = [_controller getAllOTOP];
    [self.tableView reloadData];

}

- (void)lerCodigo{
    
    QrCodeViewController *vc = [[QrCodeViewController alloc]initWithDelegate:self];
    UINavigationController * nvc = [[UINavigationController alloc]initWithRootViewController:vc];
    nvc.navigationBar.tintColor = [UIColor whiteColor];
    [nvc.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [self presentViewController:nvc animated:YES completion:nil];
    
}

-(void)responseQrcodeData:(NSString *)data{
    
    NSLog(@"%@",data);
    [_controller saveOTP:data];
    [self getLista];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
    
    if (editing) {
        refreshButton.enabled = NO;
    }else{
        refreshButton.enabled = YES;
    }
    //[[self tableView] reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_list count];
    //return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentifier=@"CELL";
    OTPTableViewCell *cell = (OTPTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellidentifier];
    
    if(cell ==nil){
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OTPTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    NSManagedObject * otp = [_list objectAtIndex:indexPath.row];

    cell.lblClientID.text = [[otp valueForKey:@"clientID"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    cell.lblIssuer.text = [otp valueForKey:@"issuer"];
    OTPGen *generator = [[OTPGen alloc]initWithSecret:otp andOTPTableViewCELL:cell];
    
    
    return cell;
}

// The editing style for a row is the kind of button displayed to the left of the cell when in editing mode.
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    // No editing style if not editing or the index path is nil.
    
    if (self.editing == NO || !indexPath) return UITableViewCellEditingStyleNone;
    // Determine the editing style based on whether the cell is a placeholder for adding content or already
    // existing content. Existing content can be deleted.
    if (self.editing && indexPath.row == ([_list count])) {
        return UITableViewCellEditingStyleInsert;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}


// Update the data model according to edit actions delete or insert.
- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSManagedObject *otp = [_list objectAtIndex:indexPath.row];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.controller deleteOTP:otp];
        [self getLista];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
    
    
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath{
    //Manipulate your data array.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
@end
