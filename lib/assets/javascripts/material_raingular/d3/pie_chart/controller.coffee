class MaterialRaingular.d3.Directives.PieChartModel extends AngularDirectiveModel
  @inject('$timeout','$element','$attrs')
  initialize: ->
    @svg = d3.select(@$element[0]).append('svg')
    @chartLayer = @svg.append('g').classed('chartLayer', true)
    data = Object.map(@$scope.$eval(@$attrs.d3Data))(@cast.bind(@))
    @setSize(data)
    @drawChart(data)
    @$scope.$watchCollection @$attrs.d3Data, @redrawChart.bind(@)
    @$attrs.$observe 'd3Data', @redrawChart.bind(@)
  cast: (key,val) -> {name: key.titleize(), value: val}
  redrawChart: (obj) ->
    data = Object.map(@$scope.$eval(@$attrs.d3Data))(@cast.bind(@))
    @drawChart(data)

  setSize: (data) ->
    @options = @$scope.$eval(@$attrs.mrD3Options) || {}
    @width   = @options.width  || 960
    @height  = @options.height || 500
    @color   = @options.color  || '6b486b'
    @margin  = @options.margin || {top: 40,left: 0,bottom: 40,right: 0}
    @chartWidth  = @width - (@margin.left + @margin.right)
    @chartHeight = @height - (@margin.top + @margin.bottom)
    @svg.attr('width', @width).attr 'height', @height
    @chartLayer.attr('width', @chartWidth).attr('height', @chartHeight).attr 'transform', "translate(#{[@margin.left,@margin.top]})"

  drawChart: (data) ->
    @chartLayer.selectAll('g').remove()
    arcs = d3.pie().sort(null).value((d) -> d.value)(data)
    arc  = d3.arc().outerRadius(@chartHeight / 2).innerRadius(0)
    pieG = @chartLayer.selectAll('g').data([ data ]).enter().append('g').attr('transform', "translate(#{[@chartWidth / 2,@chartHeight / 2]})")
    block = pieG.selectAll('.arc').data(arcs)
    @newBlock = block.enter().append('g').classed('arc', true)
    @newBlock.append('path')
      .attr('d', arc)
      .attr('id', (d, i) -> 'arc-' + i)
      .attr 'fill', (d, i) -> d3.interpolateCool Math.random()
      .on('mouseover', @_mouseOver)
      .on('mouseout',  @_mouseOut)
      .on('mousemove', @_mouseMove)
      .on('click',     @_click.bind(@))
    @newBlock.append('text')
      .style('text-anchor', 'middle')
      .style('pointer-events', 'none')
      .style('fill', '#fff')
      .attr('dy', '.35em')
      .attr 'transform', (d) ->
        centroid = arc.centroid(d)
        x = centroid[0]
        y = centroid[1]
        'translate(' + x + ',' + y + ')'
      .text (d) -> d.data.value
  _mouseOver: (d, i) ->
    d3.select('#tip-'+ i + (d.data.value.toFixed()))
      .classed('hidden', false)
      .style('left', d3.event.pageX + 'px')
      .style('top', ((d3.event.pageY - 80 ) / 2) + 'px')
  _mouseMove: (d, i) ->
    d3.select('#tip-'+ i + (d.data.value.toFixed()))
      .style('left', d3.event.pageX + 'px')
      .style('top', ((d3.event.pageY - 80 ) / 2) + 'px')
  _mouseOut: (d, i) ->
    d3.select('#tip-'+ i + (d.data.value.toFixed())).classed('hidden', true)
  _click: (arc,index) ->
      t = d3.transition().duration(300).ease(d3.easeLinear)
      paths = @newBlock.selectAll('path')
      paths.selectAll('animateTransform').remove()
      path = d3.select paths.nodes()[index]
      reduce = !path.attr('transform') || (path.attr('transform').strip() == "translate(0,0)scale(1,1)")
      paths.transition(t).attr('transform',"translate(0,0) scale(1,1)")
      return unless reduce
      theta = (arc.endAngle + arc.startAngle)/2
      x = 10 * Math.cos (Math.PI / 2) - theta
      y = -10 * Math.sin (Math.PI / 2) - theta
      path.transition(t).attr('transform',"translate(#{x},#{y}) scale(1.25,1.25)")
