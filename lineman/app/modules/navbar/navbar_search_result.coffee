angular.module('loomioApp').directive 'navbarSearchResult', ->
  scope: {result: '='}
  restrict: 'E'
  templateUrl: 'generated/modules/navbar/navbar_search_result.html'
  replace: true
  link: (scope, element, attrs) ->
