angular.module('loomioApp').factory 'MembershipModel', (BaseModel) ->
  class MembershipModel extends BaseModel
    @singular: 'membership'
    @plural: 'memberships'
    @indexes: ['userId', 'groupId']

    group: ->
      @recordStore.groups.find(@groupId)

    user: ->
      @recordStore.users.find(@userId)
