class MaterialRaingular.d3.Directives.MrD3BarChartModel extends AngularDirectiveModel
  @inject('$timeout','$element','$attrs')
  initialize: ->
    @options = @$scope.$eval(@$attrs.d3Options || '{}')
    @options.margins = Object.merge({top: 20,right: 20, left: 70, bottom: 50},@options.margins || {})
    @svg = d3.select(@$element[0])
    @holder = @svg.select('g')
    @holder.attr('transform',"translate(#{@options.margins.left},#{@options.margins.right})")
    @xAxis = d3.scaleBand().rangeRound([0,@width()]).padding(0.1)
    @yAxis = d3.scaleLinear().range([0,@height()])
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
      height = (rect.attr('raw-size') / @maxValue()) * @width()
      rect.attr('y',@height() - height)
      rect.attr('height',height)
    @xAxis.domain(@xDomain)
    for rect in @bars().nodes()
      d3.select(rect).attr('width',@xAxis.bandwidth())
      d3.select(rect).attr('x',@xAxis(@xDomain[@indexOf(rect)]))
    @_xAxis?.call(d3.axisBottom(@xAxis))
  height:   -> @$element[0].clientHeight - @options.margins.top  - @options.margins.bottom
  width:    -> @$element[0].clientWidth  - @options.margins.left - @options.margins.right
  maxValue: ->
    val   = @yAxis?.domain().max()
    val ||= (@bars().nodes().map (rect) -> d3.select(rect).attr('raw-size')).max()
    val
