(function(angular) {

    var app = angular.module('app', [])

    app.controller('CNECasesCtrl', ['$scope', function($scope) {
        $scope.data = {
            cneCases: []
        }

        for (var i = 0; i < 10; i++) {
            $scope.data.cneCases.push({
                id: i,
                date_initiated: "1/10/16",
                FNS_case_number: "00022838",
                account_name: "Amanda Thomas",
                case_status: "Pending CNE Manager Assignment"
            })
        }

    }])

})(angular);
