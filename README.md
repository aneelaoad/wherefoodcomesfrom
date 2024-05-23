<style type="text/css">#myCustomTable {
    border: none;
    sd: repeatheader;
    border-collapse: collapse;
    page-break-inside: avoid;
    page-break-before: auto;
  }

  .td1 {
    font-size: 15px;
    padding: 5px;
    border-bottom: 2px solid #ddd;

  }

  .td2 {
    font-size: 15px;
    padding: 5px;
    border-bottom: 2px solid #ddd;
    text-align: center;
  }

  #myCustomTable tr {
    page-break-inside: avoid;
  }

  #myCustomTable td {
    padding: 3px;
  }
</style>
<div style="text-align:center;"> </div>

<table align="center" border="0" cellpadding="0" cellspacing="0" style="width: 760px; font-family: arial, helvetica, sans-serif; margin-bottom: 30px;">
	<colgroup>
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
	</colgroup>
	<tbody align="center">
		<tr>
			<td colspan="8" height=" 10" style="text-align: center; padding-top: 20px; width: 754px;" valign="bottom"><span style="font-size: 34px;"></span> <span style="font-size: 34px;"></span></td>
		</tr>
		<tr>
			<td colspan="8" height="35" style="width: 754px;" valign="bottom"> </td>
		</tr>
		<tr>
			<td colspan="2" height="20" style="text-align: right; width: 319px;"><span style="font-size:14.5px;"><strong>Certified Operation Name:</strong></span></td>
			<td colspan="6" height="20" style="padding-left: 20px; width: 490px;" valign="top" width="20"><span style="font-size:14.5px;float:left;">{{!Certificate__c.Opportunity_Name__r.Account.name}}</span></td>
		</tr>
		<tr>
			<td colspan="2" height="20" style="text-align: right; padding-top: 15px; width: 319px;"><span style="font-size:14.5px;"><strong>Operation NOP ID:</strong></span></td>
			<td colspan="6" height="20" style="padding-left: 20px; padding-top: 15px; width: 490px;" valign="top"><span style="font-size:14.5px;float:left;">{{!Certificate__c.Opportunity_Name__r.Account.operation_id__c}}</span></td>
		</tr>
		<!--<tr>
<td colspan="8" height="30" valign="top"> </td>
</tr>-->
		<tr>
			<td colspan="2" height="20" style="padding-top: 10px; text-align: right; width: 319px;" valign="top"><span style="font-size:14.5px;"><strong>Operation Contact:</strong></span></td>
			<td colspan="6" height="170" style="padding-left: 20px; padding-top: 20px; width: 490px;" valign="top"><!--{{!
<lineitemsSOQL><class>none</class>
<listname>Operation Contact</listname>
<soql>SELECT Id, Name, Email   FROM Contact    WHERE AccountId  ='{!Certificate__c.accountid__c}' AND isSelected__c = true</soql>
<column prefix="<span style='font-size:14.5px;'> " postfix=": ">Name</column>
<column postfix=", ">Email</column>

</lineitemsSOQL>
}}--><!--{{!
<lineitemsSOQL><class>none</class>
<listname>Operation Contact</listname>
<soql>SELECT Id, Name, Email   FROM Contact    WHERE AccountId  ='{!Certificate__c.accountid__c}' AND isSelected__c = true</soql>
<column prefix="<span style='font-size:14.5px;'>" postfix="</span>" >Blank__c</column>
</lineitemsSOQL>
}}-->
			<div><span style="font-size:14.5px;"><br />
			<strong>&nbsp; </strong></span></div>
			</td>
		</tr>
		<tr>
			<td colspan="2" height="20" style="padding-top: 10px; text-align: right; width: 319px;" valign="top"><span style="font-size:14.5px;"><strong>Certification Scopes: &nbsp; </strong></span></td>
			<td colspan="6" height="auto" style="padding-left: 20px; padding-top: 10px; width: 490px;" valign="top">{{!Certificate__c.Opportunity_Name__r.Account.getaccprodcustomertype__c}}</td>
		</tr>
		<tr>
			<td colspan="2" height="20" style="padding-top: 10px; text-align: right; width: 319px;" valign="top"><span style="font-size:14.5px;"><strong>Physical Site Address:</strong></span></td>
			<td colspan="6" height="170" style="padding-left: 20px; padding-top: 20px; width: 490px;" valign="top"><!--{{!
<lineitemsSOQL><class>none</class>
<listname>Site Addresses</listname>
<soql>Select Address__c,City__c,State__c ,Zip__c,Country__c From Site_Address__c Where Account__c ='{!Certificate__c.accountid__c}' AND is_Selected__c = true AND isSame__c = False</soql>
<column prefix="<span style='font-size:14.5px;'> " postfix=": ">Name</column>
<column postfix=", ">Address__c</column>
<column postfix=", ">City__c</column>
<column postfix=", ">State__c</column>
<column postfix=", ">Zip__c</column>
<column postfix="<br /></span>">Country__c</column>
</lineitemsSOQL>
}}--><!--{{!
<lineitemsSOQL><class>none</class>
<listname>Site Addresses</listname>
<soql>Select Address__c,City__c,State__c ,Zip__c,Country__c,Blank__c From Site_Address__c Where Account__c ='{!Certificate__c.accountid__c}' AND is_Selected__c = true AND isSame__c = true</soql>
<column prefix="<span style='font-size:14.5px;'>" postfix="</span>" >Blank__c</column>
</lineitemsSOQL>
}}-->
			<div><span style="font-size:14.5px;"><br />
			<strong>&nbsp; </strong></span></div>
			</td>
		</tr>
		<tr>
			<td colspan="8" height="40" style="padding-left: 45px; padding-right: 25px; line-height: 90%; width: 684px;" valign="middle"><span style="font-size: 14px; font-family:arial,helvetica,sans-serif;">Certified to the USDA organic regulations, 7 CFR Part 205. Once certified a production or handling operation's organic certification continues in effect until surrendered, suspended, or revoked.</span></td>
		</tr>
		<tr>
			<td colspan="8" height="20" style="padding-left: 20px; padding-top: 30px; line-height: 1; text-align: right; width: 734px;" valign="top"><span style="font-size: 14px;color: rgb(0,0,0); font-family:arial,helvetica,sans-serif;">You may verify the certification of this operation at the Organic Integrity Database<br />
			<span style="font-size: 14px;color: rgb(0,0,0); padding-right:75px; font-family:arial,helvetica,sans-serif;">found at&nbsp;<span style="color:#009900;"><span style="font-size: 14px; font-family: arial, helvetica, sans-serif;"><span style="font-size: 14px; padding-right: 75px; font-family: arial, helvetica, sans-serif;"><a href="https://organic.ams.usda.gov/integrity" target="_blank">https://organic.ams.usda.gov/integrity</a>.</span></span></span></span></span></td>
		</tr>
		<tr>
			<td colspan="8" style="padding-left: 20px; padding-top: 25px; line-height: 1; text-align: right; width: 734px;" valign="top"><span contenteditable="false" tabindex="-1"><img alt="" data-widget="image" src="https://wfcf--pcopy.sandbox.file.force.com/servlet/servlet.ImageServer?id=01563000001q8eO&amp;oid=00D63000000IXpv&amp;lastMod=1660653189000" style="float:left" width="140px" /></span><span style="font-size: 14.5px;color: rgb(105, 105, 105); font-family:arial,helvetica,sans-serif;"><span style="color:rgb(0,0,0);">Certifying Agent:&nbsp;Where Food Comes From Organic</span><br />
			<span style="color:rgb(0,0,0);">Address:&nbsp;202 Sixth Street, Suite 400 Castle Rock CO 80104</span><br />
			<span style="color:rgb(0,0,0);">P: 760-731-0155</span><br />
			<span style="color:rgb(0,0,0);">W: <span style="font-size: 14.5px;color: rgb(105, 105, 105); font-family:arial,helvetica,sans-serif;"><span style="color:rgb(0,0,0);">www.wfcforganic.com</span></span></span></span></td>
		</tr>
		<tr>
			<td colspan="8" height="20" style="padding-left: 10px; padding-top: 30px; line-height: 1; text-align: left; width: 744px;" valign="top"><span style="font-size: 14px;color: rgb(0,0,0); font-family:arial,helvetica,sans-serif;"> <span style="font-size: 14px;color: rgb(0,0,0);padding-right:150px;font-family:arial,helvetica,sans-serif;">Addendum Issue Date: <span style="color:rgb(0,0,0); ">{{!Certificate__c.today__c MM/dd/yyyy}} &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </span></span>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span><span style="font-size: 14px;color: rgb(0,0,0); font-family:arial,helvetica,sans-serif;"><span style="font-size: 14px;color: rgb(0,0,0);padding-right:10px;font-family:arial,helvetica,sans-serif;">24008JA</span></span></td>
		</tr>
	</tbody>
</table>

<div style="page-break-after: always"><span style="display: none;">&nbsp;</span></div>
<!--================================================================================================ page 2--><!--RENDER={{!Certificate__c.Selected_Customer_Type__c}} CONTAINS 'crops'-->

<table align="center" border="0" cellpadding="0" cellspacing="0" style="width:736px; font-family:arial,helvetica,sans-serif;">
	<colgroup>
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
	</colgroup>
	<tbody>
		<tr>
			<td colspan="3" height="10" style="padding-left:2px; padding-bottom:5px;"><span style="font-size:14.5px;"><strong>Certified Operation:</strong></span></td>
			<td colspan="5" height="10" style="padding-left:10px;padding-right:50px;" valign="top"><span style="font-size:14.5px;float:left;">{{!Certificate__c.Opportunity_Name__r.Account.name}}</span></td>
		</tr>
		<tr>
			<td colspan="8" height="10" valign="bottom"> </td>
		</tr>
		<tr>
			<td colspan="8" height=" 10" style="text-align: left;padding-top:5px;" valign="bottom"><span style="font-size: 18px;"><strong>PRODUCTS CERTIFIED FOR CROP SCOPE</strong></span></td>
		</tr>
	</tbody>
</table>
<!--RENDER1={{!Certificate__c.Selected_Product_Status__c}} CONTAINS 'crops 100% organic' -->

<table align="center" gill="" id="myCustomTable" sans="" style="width:736px;height:100%; font-family:arial,helvetica,sans-serif; ">
	<thead>
		<tr style="page-break-inside: avoid!important; page-break-before: auto!important;">
			<td height="23" style="text-align: left;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>PRODUCTS</strong></span></td>
			<td height="25" style="text-align: Center;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>ID MARK</strong></span></td>
			<td height="25" style="text-align: Center;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>STANDARD</strong></span></td>
			<td height="25" style="text-align: Center;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>EFFECTIVE DATE</strong></span></td>
		</tr>
		<tr>
			<td colspan="8" height=" 10" style="text-align: left;padding-top:7px;" valign="bottom"><span style="font-size: 14.5px;"><strong>100% Organic:</strong></span></td>
		</tr>
	</thead>
	<tbody><!--{{!
<lineitemsSOQL><class>none</class>
<listname>Accounts Products</listname>
<soql>Select Product__c,ID_Mark__c,Standard__c ,Effective_Date__c From account_products__c Where Account__c ='{!Certificate__c.accountid__c}' and Product_Status__c='100% Organic' and customer_Type__c like '%Crop%' and is_selected__c =True ORDER BY    Product__c ASC</soql>
<column prefix="<tr><td class='td1' width='250px'>" postfix="</td>">Product__c</column>
<column prefix="<td     class='td2' width='100px'>" postfix="</td>">ID_Mark__c</column>
<column prefix="<td     class='td2' width='230px'>" postfix="</td>">Standard__c</column>
<column prefix="<td     class='td2'>" postfix="</td></tr>" format-date="M/d/yyyy">Effective_Date__c</column>
</lineitemsSOQL>
<br/>
}}-->
	</tbody>
</table>
<!--ENDRENDER1--><!--RENDER1={{!Certificate__c.Selected_Product_Status__c}} CONTAINS 'crops organic'-->

<table align="center" gill="" id="myCustomTable" sans="" style="width:736px;height:100%; font-family:arial,helvetica,sans-serif; ">
	<thead>
		<tr style="page-break-inside: avoid!important; page-break-before: auto!important;">
			<td height="23" style="text-align: left;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>PRODUCTS</strong></span></td>
			<td height="25" style="text-align: Center;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>ID MARK</strong></span></td>
			<td height="25" style="text-align: Center;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>STANDARD</strong></span></td>
			<td height="25" style="text-align: Center;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>EFFECTIVE DATE</strong></span></td>
		</tr>
		<tr>
			<td colspan="8" height=" 10" style="text-align: left;padding-top:7px;" valign="bottom"><span style="font-size: 14.5px;"><strong>Organic:</strong></span></td>
		</tr>
	</thead>
	<tbody><!--{{!
<lineitemsSOQL><class>none</class>
<listname>Accounts Products</listname>
<soql>Select Product__c,ID_Mark__c,Standard__c ,Effective_Date__c From account_products__c Where Account__c ='{!Certificate__c.accountid__c}' and Product_Status__c='Organic' and customer_Type__c='Crop' and is_selected__c =True ORDER BY Product__c   ASC</soql>
<column prefix="<tr><td class='td1' width='250px'>" postfix="</td>">Product__c</column>
<column prefix="<td     class='td2' width='100px'>" postfix="</td>">ID_Mark__c</column>
<column prefix="<td     class='td2' width='230px'>" postfix="</td>">Standard__c</column>
<column prefix="<td     class='td2'>" postfix="</td></tr>" format-date="M/d/yyyy">Effective_Date__c</column>
</lineitemsSOQL>
<br/>
}}-->
	</tbody>
</table>
<!--ENDRENDER1--><!--RENDER1={{!Certificate__c.Selected_Product_Status__c}} CONTAINS 'crops made with organic'--><!--<table align="center" gill="" id="myCustomTable" sans="" style="width:736px;height:100%; font-family:arial,helvetica,sans-serif; ">
<thead>
<tr style="page-break-inside: avoid!important; page-break-before: auto!important;">
<td height="23" style="text-align: left;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>PRODUCTS</strong></span></td>
<td height="25" style="text-align: Center;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>ID MARK</strong></span></td>
<td height="25" style="text-align: Center;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>STANDARD</strong></span></td>
<td height="25" style="text-align: Center;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>EFFECTIVE DATE</strong></span></td>
</tr>
<tr>
<td colspan="8" height=" 10" style="text-align: left;padding-top:7px;" valign="bottom"><span style="font-size: 14.5px;"><strong>Made with Organic:</strong></span></td>
</tr>
</thead>
<tbody>
</tbody>
</table>--><!--ENDRENDER1--><!--{{!
<lineitemsSOQL><class>none</class>
<listname>Accounts Products</listname>
<soql>Select Standard__c,US_Canada__c From account_products__c Where Account__c ='{!Certificate__c.accountid__c}' and customer_Type__c='Crop' and is_selected__c =True and Standard__c includes ('US-CANADA*') LIMIT 1</soql>
<column prefix="<tr><td colspan='8'  style=' text-align:center; padding-left:100px; padding-top:50px;'><span style='font-size:15px; font-family:arial,helvetica,sans-serif;'>*Certified in accordance with the terms of the " postfix=" Organic Equivalency Arrangement</span></td></tr>">US_Canada__c</column>
</lineitemsSOQL>
}}-->
<style type="text/css">table.print-friendly tr td,
  table.print-friendly tr th {
    page-break-inside: avoid;
  }
</style>
<table align="center" border="0" cellpadding="0" cellspacing="0" class="print-friendly" id="mySignatureTable" style="width:736px;font-family:arial,helvetica,sans-serif;">
	<colgroup>
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
	</colgroup>
	<tbody>
		<tr>
			<td colspan="8" height="20" valign="top"> </td>
		</tr>
	</tbody>
</table>

<div style="text-align: right;"> </div>
<!--ENDRENDER--><!--================================================================================================page 3--><!--RENDER={{!Certificate__c.selected_customer_type__c}} CONTAINS 'Handler' -->

<div style="page-break-after: always"><span style="display: none;">&nbsp;</span></div>

<table align="center" border="0" cellpadding="0" cellspacing="0" style="width:736px;font-family:arial,helvetica,sans-serif;">
	<colgroup>
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
	</colgroup>
	<tbody>
		<tr>
			<td colspan="3" height="10" style="padding-left:2px;"><span style="font-size:14.5px;"><strong>Certified Operation:</strong></span></td>
			<td colspan="5" height="10" style="padding-left:10px;padding-right:50px;" valign="top"><span style="font-size:14.5px;float:left;">{{!Certificate__c.Opportunity_Name__r.Account.name}}</span></td>
		</tr>
		<tr>
			<td colspan="8" height="10" valign="bottom"> </td>
		</tr>
		<tr>
			<td colspan="8" height=" 10" style="text-align: left;padding-top:20px;" valign="top"><span style="font-size: 18px;"><strong>PRODUCTS CERTIFIED FOR HANDLER SCOPE</strong></span></td>
		</tr>
	</tbody>
</table>
<!--RENDER1={{!Certificate__c.Selected_Product_Status__c}} CONTAINS 'handler 100% organic'-->

<table align="center" gill="" id="myCustomTable" sans="" style="width:736px; font-family:arial,helvetica,sans-serif; " valign="top">
	<thead>
		<tr style="page-break-inside: avoid!important; page-break-before: auto!important;">
			<td height="23" style="text-align: left;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>PRODUCTS</strong></span></td>
			<td height="25" style="text-align: Center;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>ID MARK</strong></span></td>
			<td height="25" style="text-align: Center;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>STANDARD</strong></span></td>
			<td height="25" style="text-align: Center;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>EFFECTIVE DATE</strong></span></td>
		</tr>
		<tr>
			<td colspan="8" style="text-align: left;padding:2px !important; padding-top:7px;"><span style="font-size: 14.5px;"><strong>100% Organic:</strong></span></td>
		</tr>
	</thead>
	<tbody><!--{{!
<lineitemsSOQL><class>none</class>
<listname>Accounts Products</listname>
<soql>Select Product__c,ID_Mark__c,Standard__c ,Effective_Date__c From account_products__c Where Account__c ='{!Certificate__c.accountid__c}' and Product_Status__c='100% Organic'  and Customer_type__c = 'Handler' and is_selected__c =True ORDER BY Product__c ASC</soql>
<column prefix="<tr><td class='td1' width='250px'>" postfix="</td>">Product__c</column>
<column prefix="<td     class='td2' width='100px'>" postfix="</td>">ID_Mark__c</column>
<column prefix="<td     class='td2' width='230px'>" postfix="</td>">Standard__c</column>
<column prefix="<td     class='td2'>" postfix="</td></tr>" format-date="M/d/yyyy">Effective_Date__c</column>
</lineitemsSOQL>
<br/>
}}-->
	</tbody>
</table>
<!--ENDRENDER1--><!--RENDER2={{!Certificate__c.Selected_Product_Status__c}} CONTAINS 'handler organic'-->

<table align="center" gill="" id="myCustomTable" sans="" style="width:736px; font-family:arial,helvetica,sans-serif; " valign="top">
	<thead>
		<tr style="page-break-inside: avoid!important; page-break-before: auto!important;">
			<td height="23" style="text-align: left;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>PRODUCTS</strong></span></td>
			<td height="25" style="text-align: Center;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>ID MARK</strong></span></td>
			<td height="25" style="text-align: Center;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>STANDARD</strong></span></td>
			<td height="25" style="text-align: Center;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>EFFECTIVE DATE</strong></span></td>
		</tr>
		<tr>
			<td colspan="8" height=" 10" style="text-align: left;padding-top:7px;" valign="bottom"><span style="font-size: 14.5px;"><strong>Organic:</strong></span></td>
		</tr>
	</thead>
	<tbody><!--{{!
<lineitemsSOQL><class>none</class>
<listname>Accounts Products</listname>
<soql>Select Product__c,ID_Mark__c,Standard__c ,Effective_Date__c From account_products__c Where Account__c ='{!Certificate__c.accountid__c}' and Product_Status__c='Organic' and Customer_type__c = 'Handler' and is_selected__c =True ORDER BY Product__c ASC</soql>
<column prefix="<tr><td class='td1' width='250px'>" postfix="</td>">Product__c</column>
<column prefix="<td     class='td2' width='100px'>" postfix="</td>">ID_Mark__c</column>
<column prefix="<td     class='td2' width='230px'>" postfix="</td>">Standard__c</column>
<column prefix="<td     class='td2'>" postfix="</td></tr>" format-date="M/d/yyyy">Effective_Date__c</column>
</lineitemsSOQL>
<br/>
}}-->
	</tbody>
</table>
<!--ENDRENDER2--><!--RENDER3={{!Certificate__c.Selected_Product_Status__c}} CONTAINS 'handler made with organic'-->

<table align="center" gill="" id="myCustomTable" sans="" style="width:736px; font-family:arial,helvetica,sans-serif; ">
	<thead>
		<tr style="page-break-inside: avoid!important; page-break-before: auto!important;">
			<td height="23" style="text-align: left;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>PRODUCTS</strong></span></td>
			<td height="25" style="text-align: Center;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>ID MARK</strong></span></td>
			<td height="25" style="text-align: Center;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>STANDARD</strong></span></td>
			<td height="25" style="text-align: Center;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>EFFECTIVE DATE</strong></span></td>
		</tr>
		<tr>
			<td colspan="8" height=" 10" style="text-align: left;padding-top:7px;" valign="bottom"><span style="font-size: 14.5px;"><strong>Made with Organic:</strong></span></td>
		</tr>
	</thead>
	<tbody><!--{{!
<lineitemsSOQL><class>none</class>
<listname>Accounts Products</listname>
<soql>Select Product__c,ID_Mark__c,Standard__c ,Effective_Date__c From account_products__c Where Account__c ='{!Certificate__c.accountid__c}' and Product_Status__c='Made with Organic'  and Customer_type__c = 'Handler' and is_selected__c =True ORDER BY Product__c ASC</soql>
<column prefix="<tr><td class='td1' width='250px'>" postfix="</td>">Product__c</column>
<column prefix="<td     class='td2' width='100px'>" postfix="</td>">ID_Mark__c</column>
<column prefix="<td     class='td2' width='230px'>" postfix="</td>">Standard__c</column>
<column prefix="<td     class='td2'>" postfix="</td></tr>" format-date="M/d/yyyy">Effective_Date__c</column>
</lineitemsSOQL>
}}-->
	</tbody>
</table>
<!--ENDRENDER3--><!--{{!
<lineitemsSOQL><class>none</class>
<listname>Accounts Products</listname>
<soql>Select Standard__c,US_Canada__c From account_products__c Where Account__c ='{!Certificate__c.accountid__c}' and customer_Type__c='Handler' and is_selected__c =True and Standard__c includes ('US-CANADA*') LIMIT 1</soql>
<column prefix="<tr><td colspan='8'  style=' text-align:center; padding-left:100px; padding-top:50px;'><span style='font-size:15px; font-family:arial,helvetica,sans-serif;'>*Certified in accordance with the terms of the " postfix=" Organic Equivalency Arrangement</span></td></tr>">US_Canada__c</column>
</lineitemsSOQL>
}}-->
<style type="text/css">table.print-friendly tr td,
  table.print-friendly tr th {
    page-break-inside: auto;
  }
</style>
<table align="center" border="0" cellpadding="0" cellspacing="0" class="print-friendly" id="mySignatureTable" style="width:736px;font-family:arial,helvetica,sans-serif;">
	<colgroup>
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
	</colgroup>
	<tbody>
		<tr>
			<td colspan="8" height="20" valign="top"> </td>
		</tr>
	</tbody>
</table>
<!--ENDRENDER--><!-- ================================================================================================ page 4--><!--RENDER={{!Certificate__c.selected_customer_type__c}} CONTAINS 'livestock'-->

<div style="page-break-after: always"><span style="display: none;">&nbsp;</span></div>

<table align="center" border="0" cellpadding="0" cellspacing="0" style="width:736px; font-family:arial,helvetica,sans-serif;">
	<colgroup>
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
	</colgroup>
	<tbody>
		<tr>
			<td colspan="3" height="10" style="padding-left:2px;"><span style="font-size:14.5px;"><strong>Certified Operation:</strong></span></td>
			<td colspan="5" height="10" style="padding-left:10px;padding-right:50px;" valign="top"><span style="font-size:14.5px;float:left;">{{!Certificate__c.Opportunity_Name__r.Account.name}}</span></td>
		</tr>
		<tr>
			<td colspan="8" height="10" valign="bottom"> </td>
		</tr>
		<tr>
			<td colspan="8" height=" 10" style="text-align: left;padding-top:20px;" valign="bottom"><span style="font-size: 18px;"><strong>PRODUCTS CERTIFIED FOR LIVESTOCK SCOPE</strong></span></td>
		</tr>
	</tbody>
</table>
<!--RENDER1={{!Certificate__c.Selected_Product_Status__c}} CONTAINS 'livestock 100% organic'-->

<table align="center" gill="" id="myCustomTable" sans="" style="width:736px;height:100%; font-family:arial,helvetica,sans-serif; ">
	<thead>
		<tr style="page-break-inside: avoid!important; page-break-before: auto!important;">
			<td height="23" style="text-align: left;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>SPECIES</strong></span></td>
			<td height="25" style="text-align: Center;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>ID MARK</strong></span></td>
			<td height="25" style="text-align: Center;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>STANDARD</strong></span></td>
			<td height="25" style="text-align: Center;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>EFFECTIVE DATE</strong></span></td>
		</tr>
		<tr>
			<td colspan="8" height=" 10" style="text-align: left;padding-top:7px;" valign="bottom"><span style="font-size: 14.5px;"><strong>100% Organic:</strong></span></td>
		</tr>
	</thead>
	<tbody><!--{{!
<lineitemsSOQL><class>none</class>
<listname>Accounts Products</listname>
<soql>Select Product__c,ID_Mark__c,Standard__c ,Effective_Date__c From account_products__c Where Account__c ='{!Certificate__c.accountid__c}' and Product_Status__c='100% Organic'  and Customer_type__c = 'Livestock' and is_selected__c =True ORDER BY Product__c ASC</soql>
<column prefix="<tr><td class='td1' width='250px'>" postfix="</td>">Product__c</column>
<column prefix="<td     class='td2' width='100px'>" postfix="</td>">ID_Mark__c</column>            <column prefix="<td     class='td2' width='230px'>" postfix="</td>">Standard__c</column>
<column prefix="<td     class='td2'>" postfix="</td></tr>" format-date="M/d/yyyy">Effective_Date__c</column>
</lineitemsSOQL>
<br/>
}}-->
	</tbody>
</table>
<!--ENDRENDER1--><!--RENDER2={{!Certificate__c.Selected_Product_Status__c}} CONTAINS 'livestock organic'-->

<table align="center" gill="" id="myCustomTable" sans="" style="width:736px;height:100%; font-family:arial,helvetica,sans-serif; ">
	<thead>
		<tr style="page-break-inside: avoid!important; page-break-before: auto!important;">
			<td height="23" style="text-align: left;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><span style="font-size:15px;"><strong>SPECIES</strong></span></span></td>
			<td height="25" style="text-align: Center;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>ID MARK</strong></span></td>
			<td height="25" style="text-align: Center;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>STANDARD</strong></span></td>
			<td height="25" style="text-align: Center;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>EFFECTIVE DATE</strong></span></td>
		</tr>
		<tr>
			<td colspan="8" height=" 10" style="text-align: left;padding-top:7px;" valign="bottom"><span style="font-size: 14.5px;"><strong>Organic:</strong></span></td>
		</tr>
	</thead>
	<tbody><!--{{!
<lineitemsSOQL><class>none</class>
<listname>Accounts Products</listname>
<soql>Select Product__c,ID_Mark__c,Standard__c ,Effective_Date__c From account_products__c Where Account__c ='{!Certificate__c.accountid__c}' and Product_Status__c='Organic' and Customer_type__c = 'Livestock' and is_selected__c =True ORDER BY Product__c ASC</soql>
<column prefix="<tr><td class='td1' width='250px'>" postfix="</td>">Product__c</column>
<column prefix="<td     class='td2' width='100px'>" postfix="</td>">ID_Mark__c</column>
<column prefix="<td     class='td2' width='230px'>" postfix="</td>">Standard__c</column>
<column prefix="<td     class='td2'>" postfix="</td></tr>" format-date="M/d/yyyy">Effective_Date__c</column>
</lineitemsSOQL>
<br/>
}}-->
	</tbody>
</table>
<!--ENDRENDER2--><!--RENDER3={{!Certificate__c.Selected_Product_Status__c}} CONTAINS 'livestock made with organic'-->

<table align="center" gill="" id="myCustomTable" sans="" style="width:736px;height:100%; font-family:arial,helvetica,sans-serif; ">
	<thead>
		<tr style="page-break-inside: avoid!important; page-break-before: auto!important;">
			<td height="23" style="text-align: left;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><span style="font-size:15px;"><strong>SPECIES</strong></span></span></td>
			<td height="25" style="text-align: Center;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>ID MARK</strong></span></td>
			<td height="25" style="text-align: Center;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>STANDARD</strong></span></td>
			<td height="25" style="text-align: Center;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>EFFECTIVE DATE</strong></span></td>
		</tr>
		<tr>
			<td colspan="8" height=" 10" style="text-align: left;padding-top:7px;" valign="bottom"><span style="font-size: 14.5px;"><strong>Made with Organic:</strong></span></td>
		</tr>
	</thead>
	<tbody><!--{{!
<lineitemsSOQL><class>none</class>
<listname>Accounts Products</listname>
<soql>Select Product__c,ID_Mark__c,Standard__c ,Effective_Date__c From account_products__c Where Account__c ='{!Certificate__c.accountid__c}' and Product_Status__c='Made with Organic'  and Customer_type__c like '%Livestock%'  and is_selected__c =True ORDER BY Product__c ASC</soql>
<column prefix="<tr><td class='td1' width='250px'>" postfix="</td>">Product__c</column>
<column prefix="<td     class='td2' width='100px'>" postfix="</td>">ID_Mark__c</column><column prefix="<td     class='td2' width='230px'>" postfix="</td>">Standard__c</column>            <column prefix="<td     class='td2'>" postfix="</td></tr>" format-date="M/d/yyyy">Effective_Date__c</column>
</lineitemsSOQL>
}}-->
	</tbody>
</table>
<!--ENDRENDER3--><!--{{!
<lineitemsSOQL><class>none</class>
<listname>Accounts Products</listname>
<soql>Select Standard__c,US_Canada__c From account_products__c Where Account__c ='{!Certificate__c.accountid__c}' and customer_Type__c='livestock' and is_selected__c =True and Standard__c includes ('US-CANADA*') LIMIT 1</soql>
<column prefix="<tr><td colspan='8'  style=' text-align:center; padding-left:100px; padding-top:50px;'><span style='font-size:15px; font-family:arial,helvetica,sans-serif;'>*Certified in accordance with the terms of the " postfix=" Organic Equivalency Arrangement</span></td></tr>">US_Canada__c</column>
</lineitemsSOQL>
}}-->
<style type="text/css">table.print-friendly tr td,
  table.print-friendly tr th {
    page-break-inside: auto;
  }
</style>
<table align="center" border="0" cellpadding="0" cellspacing="0" class="print-friendly" id="mySignatureTable" style="width:736px;font-family:arial,helvetica,sans-serif;">
	<colgroup>
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
	</colgroup>
	<tbody>
		<tr>
			<td colspan="8" height="20" valign="top"> </td>
		</tr>
	</tbody>
</table>
<!--ENDRENDER--><!--===================================================================================================page 5--><!--RENDER={{!Certificate__c.selected_customer_type__c}} CONTAINS 'wild crop' -->

<div style="page-break-after: always"><span style="display: none;">&nbsp;</span></div>

<table align="center" border="0" cellpadding="0" cellspacing="0" style="width:736px;font-family:arial,helvetica,sans-serif;">
	<colgroup>
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
	</colgroup>
	<tbody>
		<tr>
			<td colspan="3" height="10" style="padding-left:2px;"><span style="font-size:14.5px;"><strong>Certified Operation:</strong></span></td>
			<td colspan="5" height="10" style="padding-left:10px;padding-right:50px;" valign="top"><span style="font-size:14.5px;float:left;">{{!Certificate__c.Opportunity_Name__r.Account.name}}</span></td>
		</tr>
		<tr>
			<td colspan="8" height="10" valign="bottom"> </td>
		</tr>
		<tr>
			<td colspan="8" height=" 10" style="text-align: left;padding-top:20px;" valign="top"><span style="font-size: 18px;"><strong>PRODUCTS CERTIFIED FOR WILD CROP SCOPE</strong></span></td>
		</tr>
	</tbody>
</table>
<!--RENDER1={{!Certificate__c.Selected_Product_Status__c}} CONTAINS 'Wild Crop 100% organic'-->

<table align="center" gill="" id="myCustomTable" sans="" style="width:736px; font-family:arial,helvetica,sans-serif; " valign="top">
	<thead>
		<tr style="page-break-inside: avoid!important; page-break-before: auto!important;">
			<td height="23" style="text-align: left;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>PRODUCTS</strong></span></td>
			<td height="25" style="text-align: Center;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>ID MARK</strong></span></td>
			<td height="25" style="text-align: Center;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>STANDARD</strong></span></td>
			<td height="25" style="text-align: Center;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>EFFECTIVE DATE</strong></span></td>
		</tr>
		<tr>
			<td colspan="8" style="text-align: left;padding:2px !important; padding-top:7px;"><span style="font-size: 14.5px;"><strong>100% Organic:</strong></span></td>
		</tr>
	</thead>
	<tbody><!--{{!
<lineitemsSOQL><class>none</class>
<listname>Accounts Products</listname>
<soql>Select Product__c,ID_Mark__c,Standard__c ,Effective_Date__c From account_products__c Where Account__c ='{!Certificate__c.accountid__c}' and Product_Status__c='100% Organic' and customer_Type__c = 'Wild Crop' and is_selected__c =True ORDER BY    Product__c ASC</soql>
<column prefix="<tr><td class='td1' width='250px'>" postfix="</td>">Product__c</column>
<column prefix="<td     class='td2' width='100px'>" postfix="</td>">ID_Mark__c</column>
<column prefix="<td     class='td2' width='230px'>" postfix="</td>">Standard__c</column>
<column prefix="<td     class='td2'>" postfix="</td></tr>" format-date="M/d/yyyy">Effective_Date__c</column>
</lineitemsSOQL>
<br/>
}}-->
	</tbody>
</table>
<!--ENDRENDER1--><!--RENDER2={{!Certificate__c.Selected_Product_Status__c}} CONTAINS 'wild crop organic'-->

<table align="center" gill="" id="myCustomTable" sans="" style="width:736px; font-family:arial,helvetica,sans-serif; " valign="top">
	<thead>
		<tr style="page-break-inside: avoid!important; page-break-before: auto!important;">
			<td height="23" style="text-align: left;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>PRODUCTS</strong></span></td>
			<td height="25" style="text-align: Center;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>ID MARK</strong></span></td>
			<td height="25" style="text-align: Center;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>STANDARD</strong></span></td>
			<td height="25" style="text-align: Center;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>EFFECTIVE DATE</strong></span></td>
		</tr>
		<tr>
			<td colspan="8" height=" 10" style="text-align: left;padding-top:7px;" valign="bottom"><span style="font-size: 14.5px;"><strong>Organic:</strong></span></td>
		</tr>
	</thead>
	<tbody><!--{{!
<lineitemsSOQL><class>none</class>
<listname>Accounts Products</listname>
<soql>Select Product__c,ID_Mark__c,Standard__c ,Effective_Date__c From account_products__c Where Account__c ='{!Certificate__c.accountid__c}' and Product_Status__c='Organic' and customer_Type__c='Wild Crop' and is_selected__c =True ORDER BY Product__c   ASC</soql>
<column prefix="<tr><td class='td1' width='250px'>" postfix="</td>">Product__c</column>
<column prefix="<td     class='td2' width='100px'>" postfix="</td>">ID_Mark__c</column>
<column prefix="<td     class='td2' width='230px'>" postfix="</td>">Standard__c</column>
<column prefix="<td     class='td2'>" postfix="</td></tr>" format-date="M/d/yyyy">Effective_Date__c</column>
</lineitemsSOQL>
<br/>
}}-->
	</tbody>
</table>
<!--ENDRENDER2--><!--RENDER3={{!Certificate__c.Selected_Product_Status__c}} CONTAINS 'wild crop made with organic'-->

<table align="center" gill="" id="myCustomTable" sans="" style="width:736px; font-family:arial,helvetica,sans-serif; ">
	<thead>
		<tr style="page-break-inside: avoid!important; page-break-before: auto!important;">
			<td height="23" style="text-align: left;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>PRODUCTS</strong></span></td>
			<td height="25" style="text-align: Center;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>ID MARK</strong></span></td>
			<td height="25" style="text-align: Center;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>STANDARD</strong></span></td>
			<td height="25" style="text-align: Center;border-bottom: 1px solid black;padding-top:3px;padding-bottom:3px;"><span style="font-size:15px;"><strong>EFFECTIVE DATE</strong></span></td>
		</tr>
		<tr>
			<td colspan="8" height=" 10" style="text-align: left;padding-top:7px;" valign="bottom"><span style="font-size: 14.5px;"><strong>Made with Organic:</strong></span></td>
		</tr>
	</thead>
	<tbody><!--{{!
<lineitemsSOQL><class>none</class>
<listname>Accounts Products</listname>
<soql>Select Product__c,ID_Mark__c,Standard__c ,Effective_Date__c From account_products__c Where Account__c ='{!Certificate__c.accountid__c}' and Product_Status__c='Made with Organic'  and customer_Type__c='Wild Crop' and is_selected__c =True ORDER BY Product__c ASC</soql>
<column prefix="<tr>    <td class='td1' width='250px'>" postfix="</td>">Product__c</column>
<column prefix="<td     class='td2' width='100px'>" postfix="</td>">ID_Mark__c</column>
<column prefix="<td     class='td2' width='230px'>" postfix="</td>">Standard__c</column>
<column prefix="<td     class='td2'>" postfix="</td></tr>" format-date="M/d/yyyy">Effective_Date__c</column>
</lineitemsSOQL>
}}-->
	</tbody>
</table>
<!--ENDRENDER3--><!--{{!
<lineitemsSOQL><class>none</class>
<listname>Accounts Products</listname>
<soql>Select Standard__c,US_Canada__c From account_products__c Where Account__c ='{!Certificate__c.accountid__c}' and customer_Type__c='wild crop' and is_selected__c =True and Standard__c includes ('US-CANADA*') LIMIT 1</soql>
<column prefix="<tr><td colspan='8'  style=' text-align:center; padding-left:100px; padding-top:50px;'><span style='font-size:15px; font-family:arial,helvetica,sans-serif;'>*Certified in accordance with the terms of the " postfix=" Organic Equivalency Arrangement</span></td></tr>">US_Canada__c</column>
</lineitemsSOQL>
}}-->
<style type="text/css">table.print-friendly tr td,
  table.print-friendly tr th {
    page-break-inside: auto;
  }
</style>
<table align="center" border="0" cellpadding="0" cellspacing="0" class="print-friendly" id="mySignatureTable" style="width:736px;font-family:arial,helvetica,sans-serif;">
	<colgroup>
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
		<col width="92" />
	</colgroup>
	<tbody>
		<tr>
			<td colspan="8" height="20" valign="top"> </td>
		</tr>
	</tbody>
</table>
<br />
<!--ENDRENDER-->