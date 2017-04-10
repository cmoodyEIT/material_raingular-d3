class MaterialRaingular.d3.Directives.PieChartModel extends AngularDirectiveModel
  @inject('$timeout','$element','$attrs')
  initialize: ->
    @svg        = d3.select(@$element[0])
    @chartLayer = @svg.select('g.chartLayer')
    @setSize()
    @arc        = d3.arc().outerRadius(@chartHeight / 2).innerRadius(0)
    @slices = []
    @values = []
  setSize: () ->
    @options = @$scope.$eval(@$attrs.mrD3Options) || {}
    @width   = @options.width  || 960
    @height  = @options.height || 500
    @color   = @options.color  || '6b486b'
    @margin  = @options.margin || {top: 40,left: 0,bottom: 40,right: 0}
    @chartWidth  = @width - (@margin.left + @margin.right)
    @chartHeight = @height - (@margin.top + @margin.bottom)
    @svg.attr('width', @width).attr 'height', @height
    @chartLayer.attr('width', @chartWidth).attr('height', @chartHeight).attr 'transform', "translate(#{[@margin.left,@margin.top]})"

  addSlice: (slice) ->
    @slices.push(slice) unless @slices.includes(slice)
    return @slices.index(slice)
  removeSlice: (slice) ->
    index = @slices.indexOf(slice)
    return unless index >= 0
    @slices.splice(index,1)
    @values.splice(index,1)
    @drawChart()
  changeData: (slice,value) ->
    @slices.push(slice) unless @slices.includes(slice)
    index = @slices.indexOf(slice)
    @values[index] = value
    @arcs = d3.pie().sort(null).value((d) -> d)(@values)
    @$timeout.cancel(@drawTimeout)
    @drawTimeout = @$timeout(@drawChart.bind(@),10)
    return index
  drawChart: () ->
    for slice,i in @slices
      continue unless @arcs[i]
      slice.path
      .attr('d', @arc(@arcs[i]))
      slice.afterDraw?()
