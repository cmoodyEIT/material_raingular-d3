class PieChartModel extends AngularLinkModel
  @inject('$timeout')
  initialize: ->
    @svg = d3.select(@$element[0]).append('svg')
    @chartLayer = @svg.append('g').classed('chartLayer', true)
    data = Object.map(@$scope.$eval(@$attrs.d3Data))(@cast.bind(@))
    @setSize(data)
    @drawChart(data)
    @$scope.$watchCollection @$attrs.d3Data, @redrawChart.bind(@)
  cast: (key,val) -> {name: key.titleize(), value: val}
  redrawChart: (obj) ->
    data = Object.map(@$scope.$eval(@$attrs.d3Data))(@cast.bind(@))
    @drawChart(data)

  setSize: (data) ->
    @options = @$scope.$eval(@$attrs.d3Options) || {}
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
    arc  = d3.arc().outerRadius(@chartHeight / 2).innerRadius(@chartHeight / 4).padAngle(0.03).cornerRadius(8) #/ <- I hate atom right now
    pieG = @chartLayer.selectAll('g').data([ data ]).enter().append('g').attr('transform', "translate(#{[@chartWidth / 2,@chartHeight / 2]})")
    block = pieG.selectAll('.arc').data(arcs)
    newBlock = block.enter().append('g').classed('arc', true)
    newBlock.append('path').attr('d', arc).attr('id', (d, i) -> 'arc-' + i)
    .attr('stroke', 'gray').attr 'fill', (d, i) -> d3.interpolateCool Math.random()
    newBlock.append('text').attr('dx', 55).attr('dy', -5).append('textPath').attr('xlink:href', (d, i) ->'#arc-' + i)
    .text (d) -> d.data.name
    return

  @register(MaterialRaingular.d3.Directives.MrD3PieChart)
