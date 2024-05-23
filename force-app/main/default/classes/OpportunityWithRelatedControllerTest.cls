@isTest
public class OpportunityWithRelatedControllerTest {
	@isTest
	public static void testOWRC(){
		Account a = new Account(Name='test');
		insert a;
		Opportunity o = new Opportunity(CloseDate=date.today()+1, Name='test', stagename='new', accountId = a.id);
		insert o;
		 ApexPages.StandardController sc = new ApexPages.StandardController(o);
        
         opportunitywithrelatedcontroller oc = new opportunitywithrelatedcontroller(sc);

         PageReference pageRef = Page.OpportunityWithRelatedView;
         Test.setCurrentPageReference(pageRef);
         oc.newFeed();
         oc.getThisOpportunity();
         oc.setEdit();
         oc.cancel();
         oc.save();
         oc.newField();
         oc.newMaterial();
         oc.newStorage();
         oc.newSeeds();
         oc.newLivestock();
         oc.newProduct();
         oc.expandAll();
         oc.collapseAll();
         oc.toggleFields();
         oc.toggleMaterials();
         oc.toggleStorage();
         oc.toggleSeeds();
         oc.toggleLivestock();
         oc.toggleProducts();
         oc.modToDelete = 'Product';
         oc.removeModule();
         
	}
}