class XAxisModel extends AngularLinkModel
  @inject('$parse')
  initialize: ->
    @parent = @$controller.compact()[0]
    @options = @parent.options
    @parent._xAxis = @
    @axis   = d3.select(@$element[0])
    @label  = @$parse @$attrs.mrD3Label
    @domain = @$parse @$attrs.mrD3Domain
    @$scope.$watchCollection @domain, @adjustAxis.bind(@)
    @$scope.$watch @label,  @adjustAxis.bind(@)
    @appendLabel()
    @adjustAxis(true)
  adjustAxis: (newVal,oldVal) ->
    return if newVal == oldVal
    @axis.attr('transform',"translate(0,#{@parent.height()})")
    @parent.xAxis.domain(@domain(@$scope)) if @domain(@$scope)
    @axis.call(d3.axisBottom(@parent.xAxis))
    @parent.adjustBars()
    @adjustLabel()
  appendLabel: ->
    @labelEl = @parent.holder.append('text')
    .style("text-anchor","middle")
    @adjustLabel()
  adjustLabel: ->
    @labelEl.attr('x', @parent.width()/2)
    .attr('y', @parent.height() + (@options.margins.bottom + 30) / 2)
    .text(@label(@$scope)) if @label(@$scope)
  @register(MaterialRaingular.d3.Directives.MrD3XAxis)
