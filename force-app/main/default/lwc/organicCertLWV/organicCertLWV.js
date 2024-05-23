import { api, LightningElement, track, wire } from 'lwc';
import getCert from '@salesforce/apex/OrganicCertController.getCert'
import updateCertUnSelected from '@salesforce/apex/OrganicCertController.updateCertUnSelected'
import updateCertSelected from '@salesforce/apex/OrganicCertController.updateCertSelected'
import getDocumentId from '@salesforce/apex/OrganicCertController.getDocumentId'

import ID from '@salesforce/schema/Account_Products__c.Id'
import PRODUCT from '@salesforce/schema/Account_Products__c.Product__c'
import ID_MARK from '@salesforce/schema/Account_Products__c.ID_Mark__c'
import STANDARD from '@salesforce/schema/Account_Products__c.Standard__c'
import PRODUCT_STATUS from '@salesforce/schema/Account_Products__c.Product_Status__c'
import CUSTOMER_TYPE from '@salesforce/schema/Account_Products__c.Customer_Type__c'
import { ingestDataConnector } from 'lightning/analyticsWaveApi';
import EmailPreferencesStayInTouchReminder from '@salesforce/schema/User.EmailPreferencesStayInTouchReminder';

const COLS = [
    {
        label: 'Id',
        fieldName: ID.fieldApiName
    },
    {
        label: 'Product',
        fieldName: PRODUCT.fieldApiName
    },
    {
        label: 'Id Mark',
        fieldName: ID_MARK.fieldApiName
    },
    {
        label: 'Standard',
        fieldName: STANDARD.fieldApiName
    },
    {
        label: 'Product Status',
        fieldName: PRODUCT_STATUS.fieldApiName
    },
    {
        label: 'Customer Type',
        fieldName: CUSTOMER_TYPE.fieldApiName
    }
];

export default class OrganicCertLWV extends LightningElement {
    
    @api recordId;
    documentId = '';
    isLoading = false;
    totalPages
    rowOffset = 0;
    recordsPerPage = 100; // change this to change number of records displayed per page
    pageSize
    pageNumber= 1
    data = [];   
    dataToDisplay = [];   
    columns = COLS;
    selectedRecord = new Set();
    @track selectedRowsId = ['a3I63000000GKWBEA4'];

    get url () {
        return '/apex/SDOC__SDCreate1?id='+this.recordId+'&Object=Certificate__c&doclist='+this.documentId;
    }

    connectedCallback() {
        
        getDocumentId({currentRecordId:this.recordId}).then(res =>{
            this.documentId = res
        })
        console.log('DOCUMENT ID : ',this.documentId);
        getCert({ currentRecordId: this.recordId }).then(result=>{
            console.log('date',result);
            this.data = result;
            this.totalRecords = result.length; // update total records count   
            //this.recordsPerPage = result.length              
            this.pageSize =this.recordsPerPage; //set pageSize with default value as first option
            
            this.paginationHelper();
        });
        
        
    }

    

    getSelected(){        
        //this.selectedRecord = this.template.querySelector('lightning-datatable').getSelectedRows();
        this.template.querySelector('lightning-datatable').getSelectedRows().forEach(x=>{
            this.selectedRecord.add(x.Id);
        })
        console.log('clicked on check',this.selectedRecord);        
        this.getSelectedRows()
    }

    previousPage() {
        this.pageNumber = this.pageNumber - 1;
        this.decreaseRowOffset()
        this.paginationHelper();
        
        
        //this.getSelectedRows()
    }
    nextPage() {
        this.pageNumber = this.pageNumber + 1;
        this.increaseRowOffset()
        this.paginationHelper();

        //this.getSelectedRows()
        
    }

    handleProceed(){
       console.log('The list to update',this.selectedRecord);
       this.isLoading = true;
        updateCertUnSelected({certToUpdate:Array.from(this.selectedRecord)})
        .then(res=>{
            //Update unselected to false
            if(res == 'true'){
                console.log('Updated Unselected'+res,this.selectedRecord);
                updateCertSelected({certToUpdate:Array.from(this.selectedRecord)})
                .then(res=>{
                    //update selected to true
                    if(res == 'true'){
                        //loading false

                        this.isLoading = false;
                        console.log('Updated selected',res);
                        window.open(this.url);
                    }else{
                        console.log('somethign went wrong',res);
                    }
                })
                
            }else{
                console.log('somethign went wrong',res);
            }
        })
    }

    get bDisableFirst() {
        return this.pageNumber == 1;
    }
    get bDisableLast() {
        return this.pageNumber == this.totalPages;
    }

    increaseRowOffset() {
        this.rowOffset += this.recordsPerPage;
    }

    decreaseRowOffset() {
        this.rowOffset -= this.recordsPerPage;
    }

    paginationHelper() {
        this.dataToDisplay = [];
        // calculate total pages
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
        // set page number 
        if (this.pageNumber <= 1) {
            this.pageNumber = 1;
        } else if (this.pageNumber >= this.totalPages) {
            this.pageNumber = this.totalPages;
        }
        // set records to display on current page 
        for (let i = (this.pageNumber - 1) * this.pageSize; i < this.pageNumber * this.pageSize; i++) {
            if (i === this.totalRecords) {
                break;
            }
            this.dataToDisplay.push(this.data[i]);
        }
    }
    
    getSelectedRows(){
        this.selectedRecord.forEach(element => {
            console.log('id hopefully', element)
            if(this.selectedRowsId.includes(element)){
                console.log('Id already present');
            }else{
                this.selectedRowsId.push(element)
                
            }
            
        });
        console.log('selectedRowsid',this.selectedRowsId);

    }

    onRowAction(){
        console.log('onRowAction')
    }
}