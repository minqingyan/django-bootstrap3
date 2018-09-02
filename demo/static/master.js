var app = angular.module('webdir_bsrc', ['ui.router', 'oc.lazyLoad']);
app.config(['$stateProvider', '$urlRouterProvider',
  function($stateProvider, $urlRouterProvider) {
    $urlRouterProvider.otherwise('/pages/intro');

    $stateProvider.state('index', {
      url: '/pages/:name',
      abstract: true,
      templateUrl: function($stateParams) {
        return 'modules/' + $stateParams.name + '/' + $stateParams.name + '.html?ver=' + (new Date()).getTime();
      },
      controllerProvider: function(loader) {
        return loader;
      },
      resolve: {
        loader: ['$ocLazyLoad', '$stateParams', function($ocLazyLoad, $stateParams) {
          var url = 'modules/' + $stateParams.name + '/' + $stateParams.name + '.js?ver=' + (new Date()).getTime();

          return $ocLazyLoad.load(url).then(function() {
            return $stateParams.name;
          });
        }]
      }
    }).state('index.id', {
      url: '?id'
    });

  }
]);
