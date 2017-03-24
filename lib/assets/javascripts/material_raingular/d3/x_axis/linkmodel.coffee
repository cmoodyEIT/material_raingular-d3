class XAxisModel extends AngularLinkModel
  @inject('$parse')
  initialize: ->
    @parent = @$controller.compact()[0]
    @options = @parent.options
    @parent._xAxis = @axis = d3.select(@$element[0])
    @axis.attr('transform',"translate(0,#{@parent.height()})")
    @label  = @$parse @$attrs.mrD3Label
    @domain = @$parse @$attrs.mrD3Domain
    @$scope.$watchCollection @domain, @adjustAxis.bind(@)
    @$scope.$watch @label,  @adjustAxis.bind(@)
    @appendLabel()
    @adjustAxis(true)
  adjustAxis: (newVal,oldVal) ->
    return if newVal == oldVal
    @parent.xAxis.domain(@domain(@$scope)) if @domain(@$scope)
    @axis.call(d3.axisBottom(@parent.xAxis))
    @labelEl.text(@label(@$scope)) if @label(@$scope)
    @parent.adjustBars()
  appendLabel: ->
    @labelEl = @parent.holder.append('text')
    .attr('x', @parent.width()/2)
    .attr('y', @parent.height() + (@options.margins.bottom + 30) / 2)
    .style("text-anchor","middle")
  @register(MaterialRaingular.d3.Directives.MrD3XAxis)
