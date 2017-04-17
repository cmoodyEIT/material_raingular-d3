class MaterialRaingular.d3.Directives.MrD3BarChartModel extends AngularDirectiveModel
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
    @xAxis = d3.scaleBand().rangeRound([0,@width()]).padding(0.1)
    @yAxis = d3.scaleLinear().range([0,@height()])
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
    @xDomain = []
    for bar in @bars().nodes()
      rect = d3.select(bar)
      @xDomain[@indexOf(bar)] = rect.attr('label')
      height = (rect.attr('raw-size') / @maxValue()) * @height()
      rect.attr('y',@height() - height)
      rect.attr('height',height)
    @xAxis.domain(@xDomain)
    for rect in @bars().nodes()
      d3.select(rect).attr('width',@xAxis.bandwidth())
      d3.select(rect).attr('x',@xAxis(@xDomain[@indexOf(rect)]))
    @_xAxis?.axis.call(d3.axisBottom(@xAxis))
  height:   -> [@$element[0].parentElement.clientHeight, @options.minSize].max() - @options.margins.top  - @options.margins.bottom
  width:    -> [@$element[0].parentElement.clientWidth,  @options.minSize].max()  - @options.margins.left - @options.margins.right
  maxValue: ->
    val   = @yAxis?.domain().max()
    val ||= (@bars().nodes().map (rect) -> d3.select(rect).attr('raw-size')).max()
    val
