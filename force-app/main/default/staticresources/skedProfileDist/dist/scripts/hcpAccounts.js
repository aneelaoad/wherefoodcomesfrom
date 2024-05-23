(function(angular) {

    var app = angular.module('app', [])

    app.controller('HcpAccountsCtrl', ['$scope', function($scope) {
        $scope.data = {
            accounts: []
        }

        $scope.state = {
            details: [
                { label: 'HCP ID', value: 'TBC__c' },
                { label: 'HCP Account', value: 'TBC__c' },
                { label: 'Status', value: 'TBC__c' },
                { label: 'Comments', value: 'TBC__c' },
                { label: 'Do Not Contact Patient', value: 'TBC__c' },
                { label: 'Speciality', value: 'TBC__c' }
            ],
            contact: [
                { label: 'Phone', value: 'TBC__c' },
                { label: 'Fax', value: 'TBC__c' },
                { label: 'Office Contact', value: 'TBC__c' },
                { label: 'Phone Extension', value: 'TBC__c' }
            ],
            addresses: [
                { primary: 'TBC__c' }
            ],
            territories: [
                { territory: 'TBC__c' }
            ],
            relationships: [
                { patientAccount: 'TBC__c' }
            ]
        }

        for (var i = 0; i < 20; i++) {
            $scope.data.accounts.push({
                id: i,
                name: "Jason First",
                product: "CINQAIR"
            })
        }

    }])

})(angular);
