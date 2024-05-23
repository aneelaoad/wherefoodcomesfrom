@isTest
public class OpportunityBuilderControllerTest {
	@isTest
	public static void testOppBuilder(){
		Account a = new Account(Name='test');
		insert a;
		Opportunity o = new Opportunity(CloseDate=date.today()+1, Name='test', stagename='new', accountId = a.id);
		insert o;
		 ApexPages.StandardController sc = new ApexPages.StandardController(o);
        
         opportunitybuildercontroller ob = new opportunitybuildercontroller(sc);
         ob.getredirect();
         ob.getrecordtypeid();
         ob.getthisopp();
         ob.thisOpp.modules[0].isSelected = true;         
         ob.thisOpp.modules[1].isSelected = true;
         ob.gotomoduleoptions();
         ob.thisOpp.objects[0].isSelected = true;         
         ob.thisOpp.objects[1].isSelected = true;
         ob.thisOpp.objects[2].isSelected = true;
         ob.thisOpp.objects[3].isSelected = true;
         ob.thisOpp.objects[4].isSelected = true;
         ob.thisOpp.objects[5].isSelected = true;
         ob.thisOpp.objects[6].isSelected = true;
         ob.gotoinputfields();
         ob.save();

	}
}