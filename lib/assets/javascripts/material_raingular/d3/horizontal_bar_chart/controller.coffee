class MaterialRaingular.d3.Directives.MrD3HorizontalBarChartModel extends AngularDirectiveModel
  @inject('$timeout','$element','$attrs')
  initialize: ->
    @options = @$scope.$eval(@$attrs.mrD3Options || '{}')
    @options.margins = Object.merge({top: 20,right: 20, left: 70, bottom: 50},@options.margins || {})
    @options.minSize ?= 100
    @svg = d3.select(@$element[0])
    @holder = @svg.select('g')
    @holder.attr('transform',"translate(#{@options.margins.left},#{@options.margins.right})")
    @$scope.$watch @height.bind(@), @setAxis.bind(@)
    @$scope.$watch @width.bind(@),  @setAxis.bind(@)
    @setAxis()
  setAxis: ->
    @yAxis = d3.scaleBand().rangeRound([0,@height()]).padding(0.1)
    @xAxis = d3.scaleLinear().range([0,@width()])
    if @_xAxis || @_yAxis
      @_xAxis?.adjustAxis(true)
      @_yAxis?.adjustAxis(true)
    else
      @adjustBars()
  indexOf: (bar) ->
    @bars().nodes().indexOf(bar)
  bars: ->
    nodes = @holder.selectAll('svg > g > rect').nodes()
    d3.selectAll(nodes.concat(@holder.selectAll('g.stacked').nodes()))
  adjustBars: ->
    @yDomain = []
    for bar in @bars().nodes()
      rect = d3.select(bar)
      @yDomain[@indexOf(bar)] = rect.attr('label')
      width = (rect.attr('raw-size') / @maxValue()) * @width()
      rect.attr('width',width || 0)
    @yAxis.domain(angular.copy(@yDomain).reverse())
    for rect in @bars().nodes()
      d3.select(rect).attr('height',@yAxis.bandwidth())
      d3.select(rect).attr('y',@yAxis(@yDomain[@indexOf(rect)]))
    @_yAxis?.axis.call(d3.axisLeft(@yAxis))
  height:   -> [@$element[0].parentElement.clientHeight, @options.minSize].max() - @options.margins.top  - @options.margins.bottom
  width:    -> [@$element[0].parentElement.clientWidth,  @options.minSize].max()  - @options.margins.left - @options.margins.right
  maxValue: ->
    val   = @xAxis?.domain().max()
    val ||= (@bars().nodes().map (rect) -> d3.select(rect).attr('raw-size')).max()
    val
