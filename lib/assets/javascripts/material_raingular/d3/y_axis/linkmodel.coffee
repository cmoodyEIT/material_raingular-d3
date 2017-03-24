class YAxisModel extends AngularLinkModel
  @inject('$parse')
  initialize: ->
    @parent = @$controller.compact()[0]
    @options = @parent.options
    @parent._yAxis = @axis = d3.select(@$element[0])
    @label  = @$parse @$attrs.mrD3Label
    @domain = @$parse @$attrs.mrD3Domain
    @$scope.$watchCollection @domain, @adjustAxis.bind(@)
    @$scope.$watch @label,  @adjustAxis.bind(@)
    @appendLabel()
    @adjustAxis(true)
  adjustAxis: (newVal,oldVal) ->
    return if newVal == oldVal
    @parent.yAxis.domain(@domain(@$scope)) if @domain(@$scope)
    @axis.call(d3.axisLeft(@parent.yAxis))
    @labelEl.text(@label(@$scope)) if @label(@$scope)
    @parent.adjustBars()
  appendLabel: ->
    @labelEl = @parent.holder.append('text')
    .attr("transform", "rotate(-90)")
    .attr("y", - (@options.margins.left + 30)/2)
    .attr("x",0 - (@parent.height() / 2))
    .attr("dy", "1em")
    .style("text-anchor", "middle")
  @register(MaterialRaingular.d3.Directives.MrD3YAxis)
