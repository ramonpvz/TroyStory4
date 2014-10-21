#import "MasterViewController.h"
@interface MasterViewController() <UITableViewDataSource>
@property NSArray *trojans;

@end

@implementation MasterViewController

- (IBAction)onTrojanConquest:(UITextField *)sender
{

    NSManagedObject *trojan = [NSEntityDescription insertNewObjectForEntityForName:@"Trojan" inManagedObjectContext:self.managedObjectContext]; //Creating a new entity
    [trojan setValue:sender.text forKey:@"name"]; //Populating entity
    
    [trojan setValue:@(arc4random_uniform(10)+ 1) forKey:@"prowess"];
    [self.managedObjectContext save:nil]; //Saving...
    [self loadData];
    sender.text = @"";
    [sender resignFirstResponder];

}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *trojan = [self.trojans objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [trojan valueForKey:@"name"];
    cell.detailTextLabel.text = [[trojan valueForKey:@"prowess"] stringValue];
    return cell;
}

-(void) viewDidLoad
{
    [self loadData];
}

- (void) loadData {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Trojan"];
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"prowess" ascending:NO];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"prowess >= %d", 5];
    request.predicate = predicate;
    
    request.sortDescriptors = [NSArray arrayWithObjects:sortDescriptor1, sortDescriptor2, nil];
    self.trojans = [self.managedObjectContext executeFetchRequest:request error:nil];
    [self.tableView reloadData];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.trojans.count;
}

@end