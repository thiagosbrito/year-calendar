(($)->
  
  CUR_YEAR      = moment().year()
  CUR_MONTH     = moment().month()
  LIST_MONTHS   = moment.months()
  CUR_QUARTER   = moment().quarter()
  CUR_HALF      = if CUR_QUARTER <= 2 then 1 else 2

  brtCalendar = {
    initialize: (options, $container)->
      @settings = {}
      _(@settings).extend $.fn.brtCalendar.defaults,options
      @viewMode         = @settings.period
      @minYear          = CUR_YEAR - @settings.gapYears
      @maxYear          = CUR_YEAR + @settings.gapYears
      @selectedYear     = CUR_YEAR
      @selectedMonth    = CUR_MONTH
      @selectedQuarter  = CUR_QUARTER
      @selectedHalf     = CUR_HALF
      @container        = $container
      @events           = @settings.data

      @render()

    render: ()->
      @cacheDom()
      @buildTemplate()
      @buildDates()
      @createSelect()
      @createDatatables()
      @createFullCalendar()
      @listeners()

    cacheDom: ()->
      @DOMElements = 
        $templateHeader             :   $ templates['header']
        $templateCalendarYearly     :   $ templates['calendar-yearly']
        $templateCalendarHalfYearly :   $ templates['calendar-half-yearly']
        $templateCalendarQuarterly  :   $ templates['calendar-quarterly']
        $templateCalendarMonthly    :   $ templates['calendar-monthly']
        $templateListYearly         :   $ templates['list-yearly']
        $templateListHalfYearly     :   $ templates['list-half-yearly']
        $templateListQuarterly      :   $ templates['list-quarterly']
        $templateListMonthly        :   $ templates['list-monthly']
        $fullCalendarContent        :   null

    buildTemplate: ()->
      $(@container).append @DOMElements.$templateHeader

      
      # remove active class for all buttons
      @DOMElements.$templateHeader.find('.btn-yr-calendar').removeClass 'active'
      @DOMElements.$templateHeader.find('.t-view').removeClass 'active'

      # set active the setting comming from plugin instatiate 
      @DOMElements.$templateHeader.find("[data-period=#{@settings.period}]").addClass('active')
      @DOMElements.$templateHeader.find("[data-type=#{@settings.view}]").addClass('active')

      # verify the settings values to render the proper view      
      if @settings.view is 'calendar'
        switch @settings.period
          when 'yearly'
            @DOMElements.$templateHeader.find('.yr-calendar-spot').append @DOMElements.$templateCalendarYearly
            @buildDates()
          when 'monthly'
            @DOMElements.$templateHeader.find('.yr-calendar-spot').append @DOMElements.$templateCalendarMonthly
          when 'half-yearly'
            @DOMElements.$templateHeader.find('.yr-calendar-spot').append @DOMElements.$templateCalendarHalfYearly
            @buildDates()

          when 'quarterly'
            @DOMElements.$templateHeader.find('.yr-calendar-spot').append @DOMElements.$templateCalendarQuarterly
            @buildDates()
      
      if @settings.view is 'list'
        switch @settings.period
          when 'yearly'
            @DOMElements.$templateHeader.find('.yr-calendar-spot').append @DOMElements.$templateListYearly
            @createDatatables @settings.period
          when 'monthly'
            @DOMElements.$templateHeader.find('.yr-calendar-spot').append @DOMElements.$templateListMonthly
            @createDatatables @settings.period
          when 'half-yearly'
            @DOMElements.$templateHeader.find('.yr-calendar-spot').append @DOMElements.$templateListHalfYearly
            @createDatatables @settings.period
          when 'quarterly'
            @DOMElements.$templateHeader.find('.yr-calendar-spot').append @DOMElements.$templateListQuarterly
            @createDatatables @settings.period

      @DOMElements.$fullCalendarContent = $('.month-calendar')
      @DOMElements.$selectYear = $('#year-select')
    buildDates: ()->
      switch @viewMode

        when'quarterly'
          quarter = CUR_QUARTER
          months = LIST_MONTHS.slice (quarter - 1)*3,quarter*3
          @buildDatesTemplate months

        when 'half-yearly'
          quarter = CUR_QUARTER
          half = if quarter <= 2 then 1 else 2
          months = LIST_MONTHS.slice (half - 1)*6,half*6
          @buildDatesTemplate months

        when 'yearly'
          months = LIST_MONTHS
          @buildDatesTemplate months

    buildDatesTemplate: (list)->
      $(".header-#{@viewMode}").empty()
      for month in list
        $(".header-#{@viewMode}").append "<div class='dyn month-item-header-list #{@viewMode}'>#{month}</div>"
      return

    createSelect: ()->
      optionsSelect = []
      listYears = _.range(CUR_YEAR - @settings.gapYears,CUR_YEAR + @settings.gapYears + 1)
      $.each listYears, (i, item)->
        selected = "selected" if item is CUR_YEAR
        option  = "<option value=#{item} #{selected}>#{item}</option>"
        optionsSelect.push option
      $('#year-select').append(optionsSelect.join(""))


    # Ext plugins
    createDatatables: (period)->
      options = {
        sort: false
        data: @settings.data
        retrieve: true
        bFilter: false
        bSearch: false
        bPaginate: false
        columns: [
          { title: 'Nome',                  data: 'title'}
          { title: 'Início',                data: 'start'}
          { title: 'Término',               data: 'end'}
          { title: 'Projeto Institucional', data: 'institucional'}
          { title: 'Multilinguagem' ,       data: 'linguagens'}
          { title: 'Atividades',            data: 'atividades'}
          { title: 'Status',                data: 'status'}
        ]
      }
      $("#list-#{period}").DataTable(options)

    # adjustPopover: ()->

    createPopover: (calEvent, event)->
      $("#evento#{calEvent.id}").popover('show')
      $('.fc-row').css('z-index',-1)
      $popoverEl = $('.popover')
      $eventEl   = $ event.target
      left = event.pageX - ($popoverEl.width() / 2)
      if left >= 940
        left = 920
      else if left <= 220
        left = 240

      topEventEl = $eventEl.offset().top
      top = topEventEl - $popoverEl.height()

      if top < 200
        $("#evento#{calEvent.id}").siblings('.popover').removeClass('right')
        $("#evento#{calEvent.id}").siblings('.popover').addClass('bottom')
        $popoverEl.offset
          left : left
          top  : top + 140
      else
        $("#evento#{calEvent.id}").siblings('.popover').removeClass('right')
        $("#evento#{calEvent.id}").siblings('.popover').addClass('top')
        $popoverEl.offset
          left : left
          top  : top

      popoverOpts = 
        container: '.fc-view-container'
        html: true
        title: calEvent.title

      $("#evento#{calEvent.id}").popover(popoverOpts)

    removePopover: (ev)->
      $("#evento#{ev.id}").popover('destroy')
      $('.fc-row').css('z-index',1)

    changeYear: ()->
      year = @DOMElements.$selectYear.val()
      month = moment().month(@selectedMonth).format('MM')
      day= 1
      goToDate = moment("#{day}/#{month}/#{year}","DD/MM/YYYY")
      @DOMElements.$fullCalendarContent.fullCalendar 'gotoDate',goToDate
      @selectedYear = year
      switch @viewMode
        when 'yearly'
          @getDataForYear()
        when 'half-yearly'
          @getDataForHalf()
        when 'quarterly'
          @getDataForQuarter()

    createFullCalendar: (rerender)->
      if !rerender
        @DOMElements.$fullCalendarContent.html ''
        @DOMElements.$fullCalendarContent.fullCalendar({
          header: false,
          events: @events
          eventMouseover: (calEvent, event, view)=>
            @createPopover calEvent,event
          eventMouseout: (ev,el,co)=>
            @removePopover(ev)
          eventRender: (ev, el)->
            el.attr "data-toogle","popover"
            el.attr "data-content","#{ev.descricao}"
            el.attr "data-original-title","#{ev.title}"
            el.attr "id","evento#{ev.id}"
        })
      else
        @DOMElements.$fullCalendarContent.fullCalendar('rerenderEvents')
    
    getDataForHalf    : ->
      holder = $('#yr-calendar-schedules-canvas')
      holder.html ''
      monthColumns  = $('#yr-calendar-months-grid').children()
      
      
      for item, key in @events
        
        infoInit  = moment(item.start).format('DD/MM/YYYY').split "/"
        infoEnd   = moment(item.end).format('DD/MM/YYYY').split "/" 

        # 
        dayInit   = infoInit[0]
        monthInit = moment().month(parseInt(infoInit[1])-1).format('MMMM')
        yearInit  = infoInit[2]
        # 
        dayEnd   = infoEnd[0]
        monthEnd = moment().month(parseInt(infoEnd[1])-1).format('MMMM')
        yearEnd  = infoEnd[2]
        # 
        dayWidth      = $('.half-grid').children().width() / moment().month(monthInit).daysInMonth()
        monthWidth    = $('.half-grid').children().width()
        

        if $('.month-item-header-list:contains(' + monthInit + ')').length > 0 and parseInt(yearInit) is @selectedYear
          initPosition = $('.month-item-header-list:contains(' + monthInit + ')').position().left + parseInt(dayInit) * dayWidth - 1
        else
          initPosition = 0
        if $('.month-item-header-list:contains(' + monthEnd + ')').length > 0 and parseInt(yearEnd) is @selectedYear
          endPosition = $('.month-item-header-list:contains(' + monthEnd + ')').position().left + parseInt(dayEnd) * dayWidth - 1
        else
          endPosition = 940
        
        size = endPosition - initPosition

        holder.append "
          <div class='item'
            id='calendar-item-#{key}'
            data-toggle='popover'
            data-content='Data de inicio: #{moment(item.start).format('DD/MM/YYYY')} <br> Data de Encerramento: #{moment(item.end).format('DD/MM/YYYY')}'
            data-original-title='#{item.title}'
            style='background-color: #{item.color}; width: #{size}px; left: #{initPosition}px'>
              &nbsp;
          </div>
          "
    
    getDataForQuarter : ->
      holder = $('#yr-calendar-schedules-canvas')
      holder.html ''
      monthColumns  = $('#yr-calendar-months-grid').children()
      
      
      for item, key in @events
        


        infoInit  = moment(item.start).format('DD/MM/YYYY').split "/"
        infoEnd   = moment(item.end).format('DD/MM/YYYY').split "/" 

        # 
        dayInit   = infoInit[0]
        monthInit = moment().month(parseInt(infoInit[1])-1).format('MMMM')
        yearInit  = infoInit[2]
        # 
        dayEnd   = infoEnd[0]
        monthEnd = moment().month(parseInt(infoEnd[1])-1).format('MMMM')
        yearEnd  = infoEnd[2]
        # 
        dayWidth      = $('.quarter-grid').children().width() / moment().month(monthInit).daysInMonth()
        monthWidth    = $('.quarter-grid').children().width()
        

        if $('.month-item-header-list:contains(' + monthInit + ')').length > 0 and parseInt(yearInit) is @selectedYear
          initPosition = $('.month-item-header-list:contains(' + monthInit + ')').position().left + parseInt(dayInit) * dayWidth - 1
        else
          initPosition = 0
        if $('.month-item-header-list:contains(' + monthEnd + ')').length > 0 and parseInt(yearEnd) is @selectedYear
          endPosition = $('.month-item-header-list:contains(' + monthEnd + ')').position().left + parseInt(dayEnd) * dayWidth - 1
        else
          endPosition = 940
        
        size = endPosition - initPosition
        
        holder.append "
          <div class='item'
            id='calendar-item-#{key}'
            data-toggle='popover'
            data-content='Data de inicio: #{moment(item.start).format('DD/MM/YYYY')} <br> Data de Encerramento: #{moment(item.end).format('DD/MM/YYYY')}'
            data-original-title='#{item.title}'
            style='background-color: #{item.color}; width: #{size}px; left: #{initPosition}px'>
              &nbsp;
          </div>
          "
    formatDates: (item)->
      if item
        inicio  = moment(item.start).format('YYYY-MM-DD')
        fim     = moment(item.end).format('YYYY-MM-DD')
        return [inicio,fim]
    getDataForYear    : ->
      holder = $('#yr-calendar-schedules-canvas')
      holder.html ''
      
      monthColumns  = $('#yr-calendar-months-grid').children()
      
      firstMonth        = moment().month($('#yr-calendar-months-list').children().first().text()).format('MM')
      lastMonth         = moment().month($('#yr-calendar-months-list').children().last().text()).format('MM')
      lastDayLastMonth  = moment().month(lastMonth).daysInMonth()

      curInitDate = "#{@selectedYear}-#{firstMonth}-01"
      curEndDate  = "#{@selectedYear}-#{lastMonth}-#{lastDayLastMonth}"
      
      for item, key in @events
        
        dates = @formatDates item

        infoInit      = moment(item.start).format('DD/MM/YYYY').split "/"
        infoEnd       = moment(item.end).format('DD/MM/YYYY').split "/" 

        # 
        dayInit       = infoInit[0]
        monthInit     = infoInit[1]
        yearInit      = infoInit[2]
        # 
        dayEnd        = infoEnd[0]
        monthEnd      = infoEnd[1]
        yearEnd       = infoEnd[2]
        # 
        dayWidth      = $('.yearly-grid').children().width() / moment().month(monthInit).daysInMonth()
        monthWidth    = $('.yearly-grid').children().width()
        color         = item.color
        

        if parseInt(yearInit) is @selectedYear
          initPosition = $(monthColumns[parseInt(monthInit)-1]).position().left + (parseInt(dayInit) * dayWidth) - 1 
        else
          initPosition = 0
        if parseInt(yearEnd) is @selectedYear
          endPosition = $(monthColumns[parseInt(monthEnd)-1]).position().left + (parseInt(dayEnd) * dayWidth) - 1
        else
          endPosition = 940        
      
        size = endPosition - initPosition

        init = moment(item.start).format('YYYY-MM-DD')

        holder.append "<div class='item'
            id='calendar-item-#{key}'
            data-toggle='popover'
            data-content='Data de inicio: #{moment(item.start).format('DD/MM/YYYY')} <br> Data de Encerramento: #{moment(item.end).format('DD/MM/YYYY')}'
            data-original-title='#{item.title}'
            style='background-color: #{item.color}; width: #{size}px; left: #{initPosition}px'>
            &nbsp;
          </div>"

    verifyYear: (direction)->
      validYear = yes
      numYear = @selectedYear
      switch @viewMode

        when 'monthly'
          if $('.month-item-header-list').html() is 'janeiro' and numYear <= @minYear and direction is 'prev'
            $('.prev').get(0).disabled = true
            return validYear = no

          if $('.month-item-header-list').html() is 'dezembro' and numYear >= @maxYear and direction is 'next'
            $('.next').get(0).disabled = true
            return validYear = no

        when 'quarterly'

          if $('.header-quarterly').children().first().html() is 'janeiro' and numYear <= @minYear and direction is 'prev'
            $('.prev').get(0).disabled = true
            return validYear = no

          if $('.header-quarterly').children().first().html() is 'outubro' and numYear >= @maxYear and direction is 'next'
            $('.next').get(0).disabled = true
            return validYear = no

        when 'half-yearly'
          if $('.header-half-yearly').children().first().html() is 'janeiro' and numYear <= @minYear and direction is 'prev'
            $('.prev').get(0).disabled = true
            return validYear = no

          if $('.header-half-yearly').children().first().html() is 'julho' and numYear >= @maxYear and direction is 'next'
            $('.next').get(0).disabled = true
            return validYear = no

        when 'yearly'
          if numYear <= @minYear and direction is 'prev'
            $('.prev').get(0).disabled = true
            return validYear = no

          if numYear >= @maxYear and direction is 'next'
            $('.next').get(0).disabled = true
            return validYear = no

      return validYear

    adjustSelect: (month, direction)->
      min         = 0
      max         = 11
      $yearSelect = $('#year-select')

      switch @viewMode

        when 'monthly'
          if month < min
            $yearSelect.val(--@selectedYear)
          if month > max
            $yearSelect.val(++@selectedYear)

        when 'quarterly'
          if direction is 'prev' and @selectedQuarter is 1
            $yearSelect.val(--@selectedYear)
          if direction is 'next' and @selectedQuarter is 4
            $yearSelect.val(++@selectedYear)

        when 'half-yearly'
          if direction is 'prev' and @selectedHalf is 2
            $yearSelect.val(--@selectedYear)
          if direction is 'next' and @selectedHalf is 1
            $yearSelect.val(++@selectedYear)

        when 'yearly'
          if direction is 'prev'
            $yearSelect.val(--@selectedYear)
          else
            $yearSelect.val(++@selectedYear)
    navigateBetweenDates: (direction)->
      
      switch @viewMode

        when 'monthly'

          if @verifyYear direction

            if direction is 'prev'
              prevMonth = --@selectedMonth
              @adjustSelect prevMonth, direction
              if prevMonth is -1
                prevMonth = 11
                @selectedMonth = prevMonth
              stringMonth = LIST_MONTHS[prevMonth]
              $('.month-item-header-list').html(stringMonth)
              $('.next').prop('disabled',no)
              @DOMElements.$fullCalendarContent.fullCalendar('prev')

            if direction is 'next'
              
              nextMonth = ++@selectedMonth
              @adjustSelect nextMonth, direction
              if nextMonth is 12
                nextMonth = 0
                @selectedMonth = nextMonth
              stringMonth = LIST_MONTHS[nextMonth]
              $('.month-item-header-list').html stringMonth 
              $('.prev').prop('disabled',no)
              @DOMElements.$fullCalendarContent.fullCalendar('next')

        when 'quarterly'

          if @verifyYear direction

            if direction is 'prev'

              $('.next').prop('disabled',no)
              @adjustSelect null, direction
              @selectedQuarter = 5 if @selectedQuarter is 1
              pos = --@selectedQuarter
              months = LIST_MONTHS.slice (pos - 1)*3,pos*3
              @buildDatesTemplate months
              @getDataForQuarter()
              

            if direction is 'next'

              $('.prev').prop('disabled',no)
              @adjustSelect null, direction
              @selectedQuarter = 0 if @selectedQuarter is 4
              pos = ++@selectedQuarter
              months = LIST_MONTHS.slice (pos - 1)*3,pos*3
              @buildDatesTemplate months
              @getDataForQuarter()

        when 'half-yearly'
          if @verifyYear direction
            if direction is 'prev'
              $('.next').prop('disabled',no)
              @selectedHalf = 3 if @selectedHalf is 1
              --@selectedHalf
              months = LIST_MONTHS.slice (@selectedHalf - 1)*6,@selectedHalf*6
              @buildDatesTemplate months
              @adjustSelect null,direction
              @getDataForHalf()

            if direction is 'next'

              $('.prev').prop('disabled',no)
              @selectedHalf = 0 if @selectedHalf is 2
              ++@selectedHalf
              months = LIST_MONTHS.slice (@selectedHalf - 1)*6,@selectedHalf*6
              @buildDatesTemplate months
              
              @adjustSelect null, direction
              @getDataForHalf()

        when 'yearly'
          if @verifyYear direction
            if direction is 'prev'
              $('.next').prop('disabled',no)
              @getDataForYear()
            else
              $('.prev').prop('disabled',no)
              @getDataForYear()
            @adjustSelect null,direction
    renderView: (d)->
      
      
      $('.next').prop('disabled',no)
      $('.prev').prop('disabled',no)
      
      $control = d.data().control

      switch $control

        when 'view'

          @DOMElements.$templateHeader.find('.t-view').removeClass 'active'
          period  = @DOMElements.$templateHeader.find('.btn-yr-calendar.active').data().period
          @viewMode = period
          
          d.addClass 'active'

          if d.data().control is 'view' and d.data('type') is 'calendar'

            if period is 'yearly'
              @DOMElements.$templateHeader.find('.yr-calendar-spot').empty().append @DOMElements.$templateCalendarYearly
              @buildDates()
              @getDataForYear()
              return

            if period is 'half-yearly'
              @DOMElements.$templateHeader.find('.yr-calendar-spot').empty().append @DOMElements.$templateCalendarHalfYearly
              @buildDates()
              @getDataForHalf()
              return

            if period is 'quarterly'
              @DOMElements.$templateHeader.find('.yr-calendar-spot').empty().append @DOMElements.$templateCalendarQuarterly
              @buildDates()
              @getDataForQuarter()
              return

            if period is 'monthly'
              @DOMElements.$templateHeader.find('.yr-calendar-spot').empty().append @DOMElements.$templateCalendarMonthly
              @createFullCalendar(true)
              return

            return
            
          if d.data().control is 'view' and d.data('type') is 'list'
            if period is 'yearly'
              @DOMElements.$templateHeader.find('.yr-calendar-spot').empty().append @DOMElements.$templateListYearly
              @createDatatables period
              return
            if period is 'half-yearly'
              @DOMElements.$templateHeader.find('.yr-calendar-spot').empty().append @DOMElements.$templateListHalfYearly
              @createDatatables period
              return
            if period is 'quarterly'
              @DOMElements.$templateHeader.find('.yr-calendar-spot').empty().append @DOMElements.$templateListQuarterly
              @createDatatables period
              return
            if period is 'monthly'
              @DOMElements.$templateHeader.find('.yr-calendar-spot').empty().append @DOMElements.$templateListMonthly
              @createDatatables period
              return
            return

        when 'period'

          @DOMElements.$templateHeader.find('.btn-yr-calendar').removeClass 'active'
          d.addClass 'active'

          view = @DOMElements.$templateHeader.find('#yr-calendar-period-buttons .active').data().type
          @viewMode = d.data().period
          if view is 'calendar'
            if d.data().period is 'yearly'
              @DOMElements.$templateHeader.find('.yr-calendar-spot').empty().append @DOMElements.$templateCalendarYearly
              @buildDates()
              @getDataForYear()
            if d.data().period is 'half-yearly'
              @DOMElements.$templateHeader.find('.yr-calendar-spot').empty().append @DOMElements.$templateCalendarHalfYearly
              @buildDates()
              @getDataForHalf()
            if d.data().period is 'quarterly'
              @DOMElements.$templateHeader.find('.yr-calendar-spot').empty().append @DOMElements.$templateCalendarQuarterly
              @buildDates()
              @getDataForQuarter()
            if d.data().period is 'monthly'
              @DOMElements.$templateHeader.find('.yr-calendar-spot').empty().append @DOMElements.$templateCalendarMonthly
              @createFullCalendar(true)
          if view is 'list'
            if d.data().period is 'yearly'
              @DOMElements.$templateHeader.find('.yr-calendar-spot').empty().append @DOMElements.$templateListYearly
              @createDatatables d.data().period
            if d.data().period is 'half-yearly'
              @DOMElements.$templateHeader.find('.yr-calendar-spot').empty().append @DOMElements.$templateListHalfYearly
              @createDatatables d.data().period
            if d.data().period is 'quarterly'
              @DOMElements.$templateHeader.find('.yr-calendar-spot').empty().append @DOMElements.$templateListQuarterly
              @createDatatables d.data().period
            if d.data().period is 'monthly'
              @DOMElements.$templateHeader.find('.yr-calendar-spot').empty().append @DOMElements.$templateListMonthly
              @createDatatables d.data().period

    listeners: () ->
      self = @
      @DOMElements.$templateHeader.find('button').click ()->
        d = $(@)
        if !d.data().direction
          self.renderView d
          event.stopPropagation()
        return
      @DOMElements.$templateHeader.find('.nav-dates').click ()->
        b = $(@)
        self.navigateBetweenDates b.data().direction
        event.stopPropagation();
        return
      @DOMElements.$selectYear.change ()->
        self.changeYear()
        event.stopPropagation();
      return

  }

  $.fn.brtCalendar = (options) ->
    brtCalendar.initialize options,this

  $.fn.brtCalendar.defaults = {
    data: null
    view: 'calendar'
    period: 'yearly'
    gapYears: 20
  }



)(jQuery)