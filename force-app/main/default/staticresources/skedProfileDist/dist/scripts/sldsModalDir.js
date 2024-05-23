(function(window, angular, jQuery) {
    angular.module('ui.sldsModal', [])
        .directive('sldsModal', ['$log', function($log) {
            return {
                restrict: 'A',
                scope: {
                    'sldsModal': '=',
                    'onHide': '='
                },
                link: function(scope, el, attrs) {

                    var $firstInput = el.find('[data-focus-first]').first()
                    var $lastInput = el.find('[data-focus-last]').last()

                    el.on('dismissed.aljs.modal', function() {
                        if (scope.onHide) scope.onHide()
                    })

                    el.on('shown.aljs.modal', function() {
                        /*set focus on first input*/
                        $firstInput.focus()
                    })

                    /*redirect last tab to first input*/
                    $lastInput.on('keydown', function(e) {
                        if ((e.which === 9 && !e.shiftKey)) {
                            e.preventDefault()
                            $firstInput.focus()
                        }
                    })

                    /*redirect first shift+tab to last input*/
                    $firstInput.on('keydown', function(e) {
                        if ((e.which === 9 && e.shiftKey)) {
                            e.preventDefault()
                            $lastInput.focus()
                        }
                    })

                    scope.$watch('sldsModal', function(is_show) {
                        if (!!is_show) {
                            el.modal('show')
                        } else {
                            el.modal('dismiss')
                        }
                    })

                }
            }
        }])
})(window, angular, jQuery);
