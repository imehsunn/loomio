angular.module('loomioApp').directive 'navbarSearchComment', ->
  scope: {result: '='}
  restrict: 'E'
  templateUrl: 'generated/modules/navbar/navbar_search_items/navbar_search_comment.html'
  replace: true
  link: (scope, element, attrs) ->
