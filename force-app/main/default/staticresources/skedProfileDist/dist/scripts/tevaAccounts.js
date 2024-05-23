//////////////////////////////
// aljsInit
(function(window, $) {
  if (window.ASSET_PATH) {
    var assetsLocation = window.location.origin + window.ASSET_PATH.slice(0, -1)
    console.log('aljsInit: ', assetsLocation)
    $.aljsInit({
      assetsLocation: assetsLocation,
      scoped: true
    })
  }
})(window, $);

(function(angular) {

    var app = angular.module('app', [])

    app.controller('TevaAccountsCtrl', ['$scope', function($scope) {
        $scope.data = {
            patients: [],
            appoinments: []
        }

        for (var i = 0; i < 10; i++) {
            $scope.data.patients.push({
                id: i,
                date_initiated: "1/10/16",
                product: "Zecuity",
                patient_name: "Jake Philips",
                intake_status: "Open",
                job_queued: "No"
            })
        }

        for (var i = 0; i < 10; i++) {
            $scope.data.appoinments.push({
                id: i,
                date_queued: "1/10/16",
                product: "Zecuity",
                patient_name: "Jake Philips",
                job_type: "Patient Referral"
            })
        }

    }])

})(angular);
