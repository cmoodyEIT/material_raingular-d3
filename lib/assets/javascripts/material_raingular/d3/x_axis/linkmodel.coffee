class XAxisModel extends AngularLinkModel
  @inject('$interpolate')
  initialize: ->
    for key in ['label','min','max']
      @[key] = angular.element @$element[0].getElementsByTagName(key)
    @parent = @$controller.compact()[0]
    @options = @parent.options
    @appendLabel()
    @appendAxis()
  appendLabel: ->
    @parent.svg.append('text')
    .attr('x', @parent.width()/2 + @options.margins.left)
    .attr('y', @parent.$element[0].offsetHeight - (@options.margins.bottom - 30) / 2)
    .style("text-anchor","middle")
    .text(@label.html())
  appendAxis: ->
    x = d3.scaleLinear().range([0,@parent.width()])
    x.domain([@min.html(),@max.html()])
    @parent.svg.append('g')
    .attr('transform',"translate(#{@parent.options.margins.left},#{@parent.height() + @parent.options.margins.top})")
    .call(d3.axisBottom(x))
  @register(MaterialRaingular.d3.Directives.MrD3XAxis)
