(function(window, angular, moment, $, _) {

    var app = angular.module('app', ['ngSanitize'])

    var getTemplateUrl = function(name) {
        return window.DIST_PATH + 'dist/templates/' + name
    }

    var getIconUrl = function(name, group) {
        if (!group) group = 'utility'
        return window.ASSET_PATH + 'assets/icons/' + group + '-sprite/svg/' + name
    }

    var getIconSrc = function(name, group) {
        if (!group) group = 'utility'
        return window.ASSET_PATH + 'assets/icons/' + group + '/' + name
    }

    app.run(['$rootScope', function($rootScope) {
        $rootScope.getTemplateUrl = getTemplateUrl
        $rootScope.getIconUrl = getIconUrl
        $rootScope.getIconSrc = getIconSrc
    }])

    app.controller('MainController', ['$scope', function($scope) {
        $scope.state = {
            view: 0
        }
    }])

    app.controller('PatientListCtrl', ['$scope', function($scope) {
        $scope.data = {
            patients: [],
            appoinments: []
        }

        $scope.state = {
          activeAppointment: null
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

        $scope.viewPatientProfile = function(patient) {
            var url = 'index.html?id=' + patient.id
            window.open(url)
        }

        $scope.scheduleAndSave = function(appointment) {
            if ($scope.state.activeAppointment !== null && $scope.state.activeAppointment.id === appointment.id) {
              $scope.state.activeAppointment = null
            } else {
              $scope.state.activeAppointment = appointment
            }
        }
    }])

})(window, angular, moment, $, _);
