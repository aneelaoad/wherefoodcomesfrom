(function(angular) {

    var app = angular.module('app', [])

    app.controller('InfusionCenterAccountsCtrl', ['$scope', function($scope) {
        $scope.data = {
            facilities: [],
            facilityDetails: [
                { label: "Facility ID", value: "TBC__c" },
                { label: "Account Record Type", value: "TBC__c" },
                { label: "Account", value: "TBC__c" },
                { label: "Parent Account", value: "TBC__c" },
                { label: "Doing Business As", value: "TBC__c" },
                { label: "Type of Facility", value: "TBC__c" },
                { label: "Type of Facility (Other)", value: "TBC__c" },
                { label: "MD Office Specialties", value: "TBC__c" },
                { label: "MD Office Specialties (Other)", value: "TBC__c" },
                { label: "Website Address", value: "TBC__c" },
                { label: "Language Spoken", value: "TBC__c" },
                { label: "Insurance Accepted", value: "TBC__c" },
                { label: "Hospital Affiliation", value: "TBC__c" },
                { label: "Amenities", value: "TBC__c" },
                { label: "Is Accepted", value: "TBC__c" },
                { label: "Is Legally Authorized", value: "TBC__c" },
                { label: "Approved", value: "TBC__c" }
            ],
            physicianDetails: [
                { label: "Physician on Site", value: "TBC__c" },
                { label: "Physician Name", value: "TBC__c" },
                { label: "Physician Affiliation", value: "TBC__c" }
            ],
            facilityStaff: [
                { label: "US Licensed MDs on Staff", value: "TBC__c" },
                { label: "Nurse Practitioners on Staff", value: "TBC__c" },
                { label: "Registered Nurses on Staff", value: "TBC__c" }
            ],
            facilityContactDetails: [
                { label: "Name of Primary Contact", value: "TBC__c" },
                { label: "Primary Contact Phone", value: "TBC__c" },
                { label: "Phone Extension", value: "TBC__c" },
                { label: "Primary Contact Fax", value: "TBC__c" }
            ],
            facilitySiteHours: [
                { label: "Monday", value: "TBC__c" },
                { label: "Tuesday", value: "TBC__c" },
                { label: "Wednesday", value: "TBC__c" },
                { label: "Thursday", value: "TBC__c" },
                { label: "Friday", value: "TBC__c" },
                { label: "Saturday", value: "TBC__c" },
                { label: "Sunday", value: "TBC__c" }
            ],
            facilityPracticeAddress: "Street Address 1 + Street Address 2 + City + State + Zip Code + Country"
        }

        console.log('data', $scope.data.facilityDetails)

        for (var i = 0; i < 5; i++) {
            $scope.data.facilities.push({
                id: i,
                name: "Facility Name " + i
            })
        }

    }])

})(angular);
