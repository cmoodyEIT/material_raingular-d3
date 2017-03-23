class XAxisModel extends AngularLinkModel
  @inject('$interpolate','$parse')
  initialize: ->
    for key in ['label','domain']
      @[key] = angular.element @$element[0].getElementsByTagName(key)
    @parent = @$controller.compact()[0]
    @options = @parent.options
    @appendLabel()
    domainStringFn = @$interpolate(@domain.html())
    @$scope.$watch domainStringFn, @adjustAxis.bind(@)
    @axis = @parent.appendXAxis(@$scope.$eval(domainStringFn(@$scope)))
  adjustAxis: (newVal,oldVal) ->
    return if newVal == oldVal
    @parent.adjustXAxis(@axis,@$scope.$eval(newVal))
  appendLabel: ->
    @label = @parent.svg.append('text')
    .attr('x', @parent.width()/2 + @options.margins.left)
    .attr('y', @parent.$element[0].offsetHeight - (@options.margins.bottom - 30) / 2)
    .style("text-anchor","middle")
    .text(@label.html())
  @register(MaterialRaingular.d3.Directives.MrD3XAxis)
