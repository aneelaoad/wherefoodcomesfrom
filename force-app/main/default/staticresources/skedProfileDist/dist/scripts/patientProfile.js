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

//////////////////////////////
// Module patientProfile
(function(window, angular, _) {

  var mod = angular.module('patientProfile', [])

  mod.controller('PatientProfileCtrl', ['$scope', '$timeout', function($scope, $timeout) {

    $scope.patient = {}

    $scope.state = {
      view: 'home',
      fnsCase: null,
      intakeCase: null,
      intakeCaseTask: null,
      hcpRelationship: null,
      programAffiliation: null,
      productAffiliation: null,
      insuranceDemographic: null,
      showModalAddComment: false
    }

    $scope.addComment = {
      form: null,
      comment: ''
    }

    $scope.hideModalAddComment = function() {
      $timeout(function() {
        $scope.state.showModalAddComment = false
      })
    }

    $scope.showModalAddComment = function() {
      $timeout(function() {
        $scope.addComment.form.$setPristine()
        $scope.addComment.comment = ''
        $scope.state.showModalAddComment = true
      })
    }

    $scope.doAddComment = function(form) {
      form.$setSubmitted(true)
      if (form.$valid) {
        window.API.addComment($scope.addComment.comment, $scope.state.fnsCase.id, function (response) {
          console.log('response', response)
          $timeout(function () {
            if (response.success === true) {
              $scope.state.fnsCase.CNECommunications.unshift(_.clone(response.data))
            } else {
              alert(response.message)
            }
            $scope.hideModalAddComment()
          })
        })
      }
    }

    $scope.openCaseDetail = function (item) {
      console.log('openCaseDetail TBC', item)
      // Check with Devon about this: what we need to show?
    }

    $scope.openHCPAccountPage = function (item) {
      var id = item.HCPAccountId || item.id || item.prescribingHCPId;
      window.location = window.HCPAccountPageUrl + '?id=' + id
      // might need to popup an iframe
    }

    $scope.viewAccount = function (type,id) {
      if(!id || id=='') return; 
      if(type=='HCP') window.location = window.HCPAccountPageUrl + '?id=' + id
      else if(type=='Facility')  window.location = window.InfusionCenterPageUrl + '?id=' + id
      // might need to popup an iframe
    }

    $scope.openInfusionCenterPage = function (item) {
      window.location = window.InfusionCenterPageUrl + '?id=' + item.id
      // might need to popup an iframe
    }

    $scope.openCaseDetail = function (accId, item) {
      window.location = window.PatientProfileUrl + '?id=' + accId + '&caseNumber=' + item.caseNumber
      // might need to popup an iframe
    }

    window.API.getPatientData(function(response) {
      $timeout(function() {
        $scope.patient = response
      })
      $timeout(function() {
        
      }, 200)
    })

  }])
})(window, angular, _);

//////////////////////////////
// Module app
(function(window, angular) {

  var app = angular.module('app', ['patientProfile', 'ui.sldsModal'])

  var getTemplateUrl = function(name) {
    var templateUrl = window.DIST_PATH + 'dist/templates/patient-profile/' + name
    // console.log('templateUrl', templateUrl)
    return templateUrl
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
})(window, angular);
