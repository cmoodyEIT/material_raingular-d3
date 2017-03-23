class YAxisModel extends AngularLinkModel
  @inject('$interpolate')
  initialize: ->
    @label = angular.element @$element[0].getElementsByTagName('label')
    @parent = @$controller.compact()[0]
    @options = @parent.options
    @appendLabel()
    @appendAxis()
  appendLabel: ->
    @parent.svg.append('text')
    .attr("transform", "rotate(-90)")
    .attr("y", (@options.margins.left - 30)/2)
    .attr("x",0 - (@parent.$element[0].offsetHeight / 2) + @options.margins.bottom - @options.margins.top)
    .attr("dy", "1em")
    .style("text-anchor", "middle")
    .text(@label.html())
  appendAxis: ->
    @parent.yAxis.call(d3.axisLeft(@parent.band))
  @register(MaterialRaingular.d3.Directives.MrD3YAxis)
