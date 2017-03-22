# //= require material_raingular/d3/ring_chart/directive

### TODO: Massive refactor required after change to coffeescropt.
          The watch function is really more of a hack than an actual
          fix to the fact that we aren't responsive to data changes
###
###
************************************************************************
  Custom D3 ring chart

  Most everything here is going to be happening outside the AngularJS
context so scope.$apply() will be necessary for forcing angular to go
into it's digest loop when changes are made to the scope.

  dataset: Constructed from a data service passed-in by directive caller.
Result is
************************************************************************
###



class RingChartModel extends AngularLinkModel
  # Default attributes to use in template if attribute not set.
  # Currently this only affects the internal relative positioning.
  defaults:
    width: 200
    height: 200

  initialize: ->
    @d3 = window.d3
    @$mrD3RingWidgetController = @$controller
    @$scope.title ||= "Some title from data-set."
    @_addRings()
    @$scope.$watchCollection @_dataset, (newVal,oldVal) =>
      @_addRings() if newVal != oldVal
  #TODO: Replace with data factory that generates JSON objects.
  _dataset: => @$scope.$eval(@$scope.ringData)
  _addRings: ->
    # Add ring to ring list on RingWidgetController
    @$mrD3RingWidgetController.refresh()
    @$mrD3RingWidgetController.addRing(@$scope)

    @w = @defaults.width
    @h = @defaults.height

    # Get sum and calc percent.
    @toPercent = 1/@_dataset().reduce(@_getSum)*100
    @outerRadius = Math.min(@w,@h)/2
    @innerRadius = Math.min(@w,@h)/3

    @cornerRadius = @outerRadius*0.05
    arc = @d3.arc()
      .innerRadius(@innerRadius)
      .outerRadius(@outerRadius)
      .cornerRadius(@cornerRadius)
      .padAngle(0.03)

    @arcDataset = @d3.pie()(@_dataset()) # Convert array of number into arc object data

    # Normalize arc dataset
    @_rotateArcs(@arcDataset, 0)
    # Make first data element centered on rhs of ring graph
    @rotateAngle = @_calcCenterRotation(@arcDataset[0])
    # Go through and rotate all arcs.
    @_rotateArcs(@arcDataset, @rotateAngle)
    # Easy colors accessible via a 10-step ordinal scale
    @color = @d3.scaleOrdinal(@d3.schemeCategory10)

    # Select SVG element from template
    @svg = @d3.select(@$element[0])
      .select("div")
      .select("svg")

    #Set up groups
    @svg.selectAll("g").remove()
    @arcs = @svg.append("g")
      .attr("class", "rings")
      .selectAll("g.arc")
      .data(@arcDataset)
      .enter()
      .append("g")
      .attr("class", "arc")
      .classed("selected", (d, i) -> i==0)
      .attr("transform", "translate(" + @outerRadius + "," + @outerRadius + ")")
      .on("dblclick", @_doubleClickArc)
      .on("mouseover", @_percentOnHover)
      .on("mouseout", @_setInitialCenterText)

    @arcs.append("title")
      .text (d,i) ->
        d.value + " Hours " + (if i == 0 then "Billable" else "Non-billable")

    @_setInitialCenterText()

    #Draw arc paths
    @arcs.append("path")
        .attr "fill", (d, i) => @color(i)
        .attr("d", arc)



  _calcCenterRotation: (datum) ->
    # Make selected data element centered on rhs of ring graph
    elementAngle = datum["endAngle"] - datum["startAngle"]
    elementCenterAngle = datum["startAngle"] + elementAngle/2
    rotateAngle = 2*Math.PI - elementCenterAngle + Math.PI/2
    return rotateAngle
  ### rotateArcs: Takes a positive angle in radians and and d3ArcDataset and
  mutates the data. ###
  _rotateArcs: (d3ArcData, radRotation) ->
    radRotation = Math.abs(radRotation)
    for data in d3ArcData
      dTheta = data["endAngle"] - data["startAngle"]
      data["startAngle"] = (data["startAngle"] + radRotation)%(Math.PI*2)
      data["endAngle"]   =  data["startAngle"] + dTheta

  _doubleClickArc: (datum) =>
    rings = @d3.select(@$element[0])
      .select("g.rings")
    @svg.selectAll("g.arc")
      .classed("selected", false)
    @d3.select(this)
      .classed("selected", true)
    rings.transition().duration(1000)
      .attrTween("transform", tween)

    tween = =>
      rotateAngle = @_calcCenterRotation(datum)*180/Math.PI
      interpolateFrom = this.getAttribute("transform") || "rotate(0, 100, 100)";
      return @d3.interpolateString(interpolateFrom, "rotate(" + rotateAngle +  ", 100, 100)")

  # Add initial center percent text
  _setInitialCenterText: =>
    @svg.select("text.center")
      .remove()
    data = @svg.select("g.arc.selected").datum();
    @svg.append("text")
      .attr("class", "center")
      .attr("x", @outerRadius)
      .attr("y", @outerRadius)
      .attr("dy", "0.3em")
      .text((Math.round(data.value*@toPercent) || 0) + "%")

  # percent
  _percentOnHover: (d) =>
    @svg.select("text.center")
      .remove()
    @svg.append("text")
      .attr("class", "center")
      .attr("x", @outerRadius)
      .attr("y", @outerRadius)
      .attr("dy", "0.3em")
      .text(Math.round(d.value * @toPercent) + "%")


  _getSum: (total, num) ->
    return total + num

  @register(MaterialRaingular.d3.Directives.MrD3Ring)
