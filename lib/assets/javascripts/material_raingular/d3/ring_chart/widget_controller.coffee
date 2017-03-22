class MaterialRaingular.d3.Directives.MrD3RingWidget extends AngularDirectiveModel
  @inject(
    '$scope'
  )
  #   Use "this" for the controller object (sharred between directives)
  # and use $scope for the view of RingWidget

  # All the ring-charts contained by widget
  initialize: ->
    @$scope.rings = []

  # Used by RingDirective linker to add rings to widget controller
  addRing: (ring) -> @$scope.rings.push ring
  refresh:        -> @$scope.rings = []
