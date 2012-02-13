###
#   @file       ControllerDeleteArea.coffee
#
#   @author     Colin Sullivan <colinsul [at] gmail.com>
#
#               Copyright (c) 2011 Colin Sullivan
#               Licensed under the GPLv3 license.
###

###
#   @class  Instrument is deleted when dragged to this area.
#   Appears when user has started dragging an instrument controller.
###
class tulpasynth.views.ControllerDeleteArea extends Backbone.View

    initialize: () ->

        @height = 128

        @all = tulpasynth.canvas.set()


        @topArrowBottomSegment = tulpasynth.canvas.path('M86.251,12.458  c-7.16,0.518-9.449-4.669-17.203,5.206c-7.686,9.787-11.104,19.771-11.104,19.771l-27.88,4.165c0,0,2.259-12.104,6.689-17.589  c5.105-8.565,14.338-16.836,25.642-20.362S93.283,11.95,86.251,12.458z').attr({'stroke':'#3D7311','id':'path2333','sodipodi:nodetypes':'czccczz','fill':'326.60197167503-#9EED40-#52AF34','stroke-width':'2'})
        @all.push @topArrowBottomSegment

        @leftArrowBottomSegment = tulpasynth.canvas.path('M13.353,98.339  c4.028,5.942,0.681,10.518,13.11,12.295c12.319,1.763,22.673-0.269,22.673-0.269l17.547,22.062c0,0-11.61,4.095-18.576,3.001  c-9.971-0.139-21.75-4-30.456-12.025C8.944,115.377,9.396,92.502,13.353,98.339z').attr({'stroke':'#3D7311','id':'path2381','sodipodi:nodetypes':'czccczz','fill':'319.68354622685-#9EED40-#52AF34','stroke-width':'2'})
        @all.push @leftArrowBottomSegment

        @rightArrowBottomSegment = tulpasynth.canvas.path('M123.419,118.052  c3.133-6.459,8.768-5.848,4.094-17.501c-4.633-11.549-11.569-19.501-11.569-19.501l10.333-26.228c0,0,9.352,8.008,11.887,14.587  c4.865,8.704,7.412,20.837,4.814,32.389C140.379,113.351,120.343,124.397,123.419,118.052z').attr({'stroke':'#3D7311','id':'path2365','sodipodi:nodetypes':'czccczz','fill':'323.49834912631-#9EED40-#52AF34','stroke-width':'2'})
        @all.push @rightArrowBottomSegment

        @topArrowTopSegment = tulpasynth.canvas.path('M54.559,6.855  c19.186,2.465,33.934,20.7,36.872,28.312c-5.521,3.278-11.367,5.343-11.367,5.343l34.283,16.018l14.691-33.629l-10.255,3.146  c-9.29-14.738-23.021-21.009-32.906-24.066C75.991-1.081,58.181,3.738,54.559,6.855z').attr({'stroke':'#3D7311','id':'path2335','sodipodi:nodetypes':'cccccczc','fill':'296.71587232061-#52AF34-#9EED40','stroke-width':'2'})
        @all.push @topArrowTopSegment

        @rightArrowTopSegment = tulpasynth.canvas.path('M144.118,93.408  c-11.729,15.384-34.895,19.038-42.955,17.776c-0.078-6.42,1.057-12.516,1.057-12.516L71.207,120.35l21.776,29.538l2.404-10.455  c17.408-0.676,29.705-9.431,37.296-16.464C140.274,115.937,145.007,98.103,144.118,93.408z').attr({'stroke':'#3D7311','id':'path2367','sodipodi:nodetypes':'cccccczc','fill':'320.10024963869-#52AF34-#9EED40','stroke-width':'2'})
        @all.push @rightArrowTopSegment

        @leftArrowTopSegment = tulpasynth.canvas.path('M24.346,128.586  c-7.458-17.849,0.959-39.737,6.083-46.088c5.599,3.143,10.311,7.173,10.311,7.173l-3.271-37.698L1,56.063l7.852,7.309  c-8.119,15.414-6.685,30.44-4.39,40.531S19.835,127.008,24.346,128.586z').attr({'stroke':'#3D7311','id':'path2383','sodipodi:nodetypes':'cccccczc','fill':'110.47182068677-#52AF34-#9EED40','stroke-width':'2'})
        @all.push @leftArrowTopSegment
        
        @position = 
            x: 1850
            y: 50

        @all.transform 'T'+@position.x+','+@position.y+'S0.5 0.5 0 0'
        bbox = @all.getBBox()

        @shownBBox = @all.getBBox()
        console.log '@shownBBox'
        console.log @shownBBox
        

        # When elements are dragged over icon
        # @dragArea = tulpasynth.canvas.rect @shownBBox.x, @shownBBox.y, @shownBBox.width, @shownBBox.height
        # @dragArea.attr
        #     fill: 'black'
        # @dragArea.toFront()
        # @all.push @dragArea
        # @dragArea.onDragOver () =>
        #     @_handle_drag_over()

        # State we're currently in
        @state = null

        # Initially hidden
        @hide()

        # setTimeout () =>
        #     @hide()

        #     setTimeout () =>
        #         @show()

        #         setTimeout () =>
        #             @_handle_drag_over()
        #             return
        #         , 2000

        #         return
        #     , 2000

        #     return

        # , 2000

    ###
    #   Called from instrument controller when it stops being dragged
    ###
    hide: () ->
        if not @state or @state == 'shown'
            attrs =
                transform: '...s0.00001 0.00001 '+@shownBBox.width+' '+@shownBBox.height
            @all.animate attrs, 50, '<'
            @state = 'hidden'
        else if @state == 'over'
            @handle_drag_over_out () =>
                @hide()
    
    ###
    #   Called from instrument controller when it begins being dragged
    ###
    show: () ->
        if @state == 'hidden'
            attrs = 
                transform: '...s100000 100000 '+@shownBBox.width+' '+@shownBBox.height
            @all.animate attrs, 100, '>'
            @state = 'shown'
    
    ###
    #   Called from instrument controller when it is dragged over region.
    ###
    handle_drag_over: () ->
        if @state == 'shown'
            attrs =
                transform: '...s1.25 1.25 '+@shownBBox.width+' '+@shownBBox.height
            @all.animate attrs, 200, 'bounce'
            @state = 'over'
    
    ###
    #   Called from instrument controller when it is dragged out of region
    ###
    handle_drag_over_out: (cb) ->
        cb = cb || () ->
            return

        if @state == 'over'
            attrs =
                transform: '...s0.8 0.8 '+@shownBBox.width+' '+@shownBBox.height
            @all.animate attrs, 200, 'bounce', cb
            @state = 'shown'
            

            

