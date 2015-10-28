(($) ->

  $.fn.brtCalendar = (options) ->
    rendering = false
    settings = $.extend({
      data: null
      view: null
      period: null
      gapYears: null
    }, options)

    if settings.period is null
      settings.period = 'yearly'
    if settings.view is null
      settings.view = 'calendar'
    if settings.gapYears is null
      settings.gapYears = 20

    minMonth = 0
    maxMonth = 11

    viewMode = settings.period

    year = moment().year()
    minYear = year - settings.gapYears
    maxYear = year + settings.gapYears

    listMonths = moment.months()

    # templates definitions
    $templateHeader               = null
    # templates for calendar
    $templateCalendarYearly       = null   
    $templateCalendarMonthly      = null
    $templateCalendarQuarterly    = null
    $templateCalendarHalfYearly   = null
    # templates for lists
    $templateListYearly           = null   
    $templateListMonthly          = null
    $templateListQuarterly        = null
    $templateListHalfYearly       = null

    # set cache for dom templates
    cacheDom = ()=>
      $templateHeader               = $(templates['header'])
      # templates for calendar
      $templateCalendarYearly       = $(templates['calendar-yearly'])
      $templateCalendarHalfYearly   = $(templates['calendar-half-yearly'])
      $templateCalendarQuarterly    = $(templates['calendar-quarterly'])
      $templateCalendarMonthly      = $(templates['calendar-monthly'])
      # templates for lists
      $templateListYearly           = $(templates['list-yearly'])
      $templateListHalfYearly       = $(templates['list-half-yearly'])
      $templateListQuarterly        = $(templates['list-quarterly'])
      $templateListMonthly          = $(templates['list-monthly'])

    # render templates at html file
    buildTemplate = ()=>

      # by default the calendar its always open in a calendar view instead of list view
      $(this).append $templateHeader

      showLoading()
      # remove active class for all buttons
      $templateHeader.find('.btn-yr-calendar').removeClass 'active'
      $templateHeader.find('.t-view').removeClass 'active'

      # set active the setting comming from plugin instatiate 
      $templateHeader.find('[data-period='+settings.period+']').addClass('active')
      $templateHeader.find('[data-type='+settings.view+']').addClass('active')

      # verify the settings values to render the proper views
      if settings.view is 'calendar'
        if settings.period is 'yearly'
          $templateHeader.find('.yr-calendar-spot').append $templateCalendarYearly
          buildDates()
          hideLoading()
        if settings.period is 'monthly'
          $templateHeader.find('.yr-calendar-spot').append $templateCalendarMonthly
          hideLoading()
        if settings.period is 'half-yearly'
          $templateHeader.find('.yr-calendar-spot').append $templateCalendarHalfYearly
          buildDates()
          hideLoading()
        if settings.period is 'quarterly'
          $templateHeader.find('.yr-calendar-spot').append $templateCalendarQuarterly
          buildDates()
          hideLoading()
      if settings.view is 'list'
        if settings.period is 'yearly'
          $templateHeader.find('.yr-calendar-spot').append $templateListYearly
          instantiateDatatables settings.period
          hideLoading()
        if settings.period is 'monthly'
          $templateHeader.find('.yr-calendar-spot').append $templateListMonthly
          instantiateDatatables settings.period
          hideLoading()
        if settings.period is 'half-yearly'
          $templateHeader.find('.yr-calendar-spot').append $templateListHalfYearly
          instantiateDatatables settings.period
          hideLoading()
        if settings.period is 'quarterly'
          $templateHeader.find('.yr-calendar-spot').append $templateListQuarterly
          instantiateDatatables settings.period
          hideLoading()

    organizeEventsOnCalendarView = (data,period)=>

    buildDates = ()=>
      if viewMode is 'quarterly'
        quarter = moment().quarter()
        months = listMonths.slice (quarter - 1)*3,quarter*3
        buildDatesTemplate(months)
        return

      if viewMode is 'half-yearly'
        quarter = moment().quarter()
        half = if quarter <= 2 then 1 else 2
        months = listMonths.slice (half - 1)*6,half*6
        buildDatesTemplate(months)
        return

      if viewMode is 'yearly'
        months = listMonths
        buildDatesTemplate months

    buildDatesTemplate = (list)=>
      $(".header-#{viewMode}").empty()
      for month in list
        $(".header-#{viewMode}").append "<div class='dyn month-item-header-list #{viewMode}'>#{month}</div>"
      return
        
    createSelect = ()=>
      curYear   = moment().year()
      prevYear  = curYear - settings.gapYears
      nextYear  = curYear + settings.gapYears + 1

      listPrevYears = _.range(prevYear,curYear)
      listNextYears = _.range(curYear+1,nextYear)
      $.each listPrevYears, (i, item)->
        $('#year-select').append($('<option>', {value: item, text: item}))
      $('#year-select').append($('<option>', {value: curYear, text: curYear, selected: true}))
      $.each listNextYears, (i, item)->
        $('#year-select').append($('<option>', {value: item, text: item}))

    # IF YOU WANT TO CHANGE DATATABLES CONFIGS , YOU MUST TO ADJUST IT BELOW
    instantiateDatatables = (period)=>
      options = {
        sort: false
        data: settings.data
        retrieve: true
        bFilter: false
        bSearch: false
        bPaginate: false
        columns: [
          { title: 'Nome',                  data: 'nome'}
          { title: 'Início',                data: 'start'}
          { title: 'Término',               data: 'end'}
          { title: 'Projeto Institucional', data: 'institucional'}
          { title: 'Multilinguagem' ,       data: 'linguagens'}
          { title: 'Atividades',            data: 'atividades'}
          { title: 'Status',                data: 'status'}
        ]
      }

      $('#list-'+period).DataTable(options)


    getMousePos = (tip)->


    instantiateFullcalendar = ()=>
      $('.month-calendar').fullCalendar({
        header: false,
        events: settings.data
        eventMouseover: (calEvent, event, view)->

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
          return
        eventMouseout: (ev,el,co)->
          $("#evento#{ev.id}").popover('destroy')
          $('.fc-row').css('z-index',1)
          return
        eventRender: (ev, el)->
          el.attr "data-toogle","popover"
          # el.attr "data-container","#yr-calendar-months-grid"
          el.attr "data-content","#{ev.descricao}"
          el.attr "data-original-title","#{ev.title}"
          el.attr "id","evento#{ev.id}"
          return
      })
      return

    insertEventsIntoCalendar = ()=>
      console.log 'c_UU_p'
    verifyYear = (direction)->

      validYear = yes

      numYear = parseInt $('#year-select > option:selected').html()

      if viewMode is 'monthly'

        if $('.month-item-header-list').html() is 'janeiro' and numYear <= minYear and direction is 'prev'
          $('.prev').get(0).disabled = true
          return validYear = no

        if $('.month-item-header-list').html() is 'dezembro' and numYear >= maxYear and direction is 'next'
          $('.next').get(0).disabled = true
          return validYear = no

      if viewMode is 'quarterly'

        if $('.header-quarterly').children().first().html() is 'janeiro' and numYear <= minYear and direction is 'prev'
          $('.prev').get(0).disabled = true
          return validYear = no

        if $('.header-quarterly').children().first().html() is 'outubro' and numYear >= maxYear and direction is 'next'
          $('.next').get(0).disabled = true
          return validYear = no

      if viewMode is 'half-yearly'
        if $('.header-half-yearly').children().first().html() is 'janeiro' and numYear <= minYear and direction is 'prev'
          $('.prev').get(0).disabled = true
          return validYear = no

        if $('.header-half-yearly').children().first().html() is 'julho' and numYear >= maxYear and direction is 'next'
          $('.next').get(0).disabled = true
          return validYear = no

      if viewMode is 'yearly'
        if numYear <= minYear and direction is 'prev'
          $('.prev').get(0).disabled = true
          return validYear = no

        if numYear >= maxYear and direction is 'next'
          $('.next').get(0).disabled = true
          return validYear = no

      return validYear

    adjustSelect = (month, direction)=>
      min       = 0
      max       = 11
      index     = $('#year-select')[0].selectedIndex
      totOpts   = $('#year-select option').length
      firstOpt  = $('#year-select option').first().html()
      lastOpt   = $('#year-select option').last().html()

      if viewMode is 'monthly'
      
        if month > max
          index = index + 1
          $('#year-select')[0].selectedIndex = index

        if month < min
          index = index - 1
          $('#year-select')[0].selectedIndex = index

      if viewMode is 'quarterly'
        # console.log month
        if direction is 'prev' and month is 6
          $('#year-select')[0].selectedIndex = $('#year-select')[0].selectedIndex - 1
        if direction is 'next' and month is 3
          $('#year-select')[0].selectedIndex = $('#year-select')[0].selectedIndex + 1

      if viewMode is 'half-yearly'
        if direction is 'prev' and month is 12
          $('#year-select')[0].selectedIndex = $('#year-select')[0].selectedIndex - 1
        if direction is 'next' and month is 0
          $('#year-select')[0].selectedIndex = $('#year-select')[0].selectedIndex + 1

      if viewMode is 'yearly'
        if direction is 'prev'
          $('#year-select')[0].selectedIndex = $('#year-select')[0].selectedIndex - 1
        else
          $('#year-select')[0].selectedIndex = $('#year-select')[0].selectedIndex + 1
      return

    navigateBetweenDates = (direction)=>
      # for month view
      if viewMode is 'monthly'

        if verifyYear(direction)

          if direction is 'prev'

            month = $('.month-item-header-list').html()
            intMonth = parseInt moment().locale('pt-br').month(month).format('MM') - 1
            prevMonth = intMonth - 1
            stringMonth = moment().locale('pt-br').month(prevMonth).format('MMMM')
            $('.month-item-header-list').html(stringMonth)
            adjustSelect prevMonth, direction
            $('.next').get(0).disabled = false
            $('.month-calendar').fullCalendar('prev')

          if direction is 'next'
            
            month = $('.month-item-header-list').html()
            intMonth = parseInt(moment().locale('pt-br').month(month).format('MM')) - 1
            nextMonth = intMonth + 1
            stringMonth = moment().locale('pt-br').month(nextMonth).format('MMMM')
            $('.month-item-header-list').html(stringMonth)
            adjustSelect nextMonth, direction
            $('.prev').get(0).disabled = false
            $('.month-calendar').fullCalendar('next')

      if viewMode is 'quarterly'

        if verifyYear direction

          if direction is 'prev'
            $('.next').get(0).disabled = false
            firstMonthOfQuarter = moment().month($('.header-quarterly').children().first().html()).quarter()
            pos = firstMonthOfQuarter - 1
            if pos < 1
              pos = 4
            months = listMonths.slice (pos - 1)*3,pos*3
            buildDatesTemplate(months)
            month = $('.header-quarterly').children().first().html()
            intMonth = parseInt moment().locale('pt-br').month(month).format('MM') - 1
            prevMonth = intMonth - 3
            adjustSelect prevMonth, direction

          if direction is 'next'
            $('.prev').get(0).disabled = false
            firstMonthOfQuarter = moment().month($('.header-quarterly').children().first().html()).quarter()
            pos = firstMonthOfQuarter + 1
            if pos > 4
              pos = 1
            months = listMonths.slice (pos - 1)*3,pos*3
            buildDatesTemplate(months)
            month = $('.header-quarterly').children().first().html()
            intMonth = parseInt(moment().locale('pt-br').month(month).format('MM')) - 1
            nextMonth = intMonth + 3
            adjustSelect nextMonth,direction
      if viewMode is 'half-yearly'
        if verifyYear direction
          if direction is 'prev'

            $('.next').get(0).disabled = false
            firstMonthOfQuarter = moment().month($('.header-half-yearly').children().first().html()).quarter()
            half = if firstMonthOfQuarter <= 2 then 2 else 1
            months = listMonths.slice (half - 1)*6,half*6
            buildDatesTemplate(months)
            month = $('.header-half-yearly').children().first().html()
            intMonth = parseInt(moment().locale('pt-br').month(month).format('MM')) - 1
            nextMonth = intMonth + 6
            adjustSelect nextMonth,direction

          if direction is 'next'

            $('.prev').get(0).disabled = false
            firstMonthOfQuarter = moment().month($('.header-half-yearly').children().first().html()).quarter()
            half = if firstMonthOfQuarter <= 2 then 2 else 1
            months = listMonths.slice (half - 1)*6,half*6
            buildDatesTemplate(months)
            month = $('.header-half-yearly').children().first().html()
            intMonth = parseInt moment().locale('pt-br').month(month).format('MM') - 1
            prevMonth = intMonth
            adjustSelect prevMonth, direction

      if viewMode is 'yearly'
        if verifyYear direction
          if direction is 'prev'
            $('.next').get(0).disabled = false
          else
            $('.prev').get(0).disabled = false
          adjustSelect null,direction

    # changes the view and re-render the proper template for each view
    renderView = (d)=>
      showLoading()
      $select = $('#year-select')[0]
      $('.next').get(0).disabled = false
      $('.prev').get(0).disabled = false
      $select.selectedIndex = $('#year-select').find(":selected").index()

      if d.data().control is 'view'

        $templateHeader.find('.t-view').removeClass 'active'
        period  = $templateHeader.find('.btn-yr-calendar.active').data('period')
        viewMode = period
        $(this.prevObject[0].activeElement).addClass 'active'

        if d.data().control is 'view' and d.data('type') is 'calendar'
          if period is 'yearly'
            $templateHeader.find('.yr-calendar-spot').empty().append $templateCalendarYearly
            buildDates()
            hideLoading()
            return
          if period is 'half-yearly'
            $templateHeader.find('.yr-calendar-spot').empty().append $templateCalendarHalfYearly
            buildDates()
            hideLoading()
            return
          if period is 'quarterly'
            $templateHeader.find('.yr-calendar-spot').empty().append $templateCalendarQuarterly
            buildDates()
            hideLoading()
            return
          if period is 'monthly'
            $templateHeader.find('.yr-calendar-spot').empty().append $templateCalendarMonthly
            instantiateFullcalendar()
            hideLoading()
            return
          return
          
        if d.data().control is 'view' and d.data('type') is 'list'
          if period is 'yearly'
            $templateHeader.find('.yr-calendar-spot').empty().append $templateListYearly
            instantiateDatatables period
            hideLoading()
            return
          if period is 'half-yearly'
            $templateHeader.find('.yr-calendar-spot').empty().append $templateListHalfYearly
            instantiateDatatables period
            hideLoading()
            return
          if period is 'quarterly'
            $templateHeader.find('.yr-calendar-spot').empty().append $templateListQuarterly
            instantiateDatatables period
            hideLoading()
            return
          if period is 'monthly'
            $templateHeader.find('.yr-calendar-spot').empty().append $templateListMonthly
            instantiateDatatables period
            hideLoading()
            return
          return

      if d.data().control is 'period'

        $templateHeader.find('.btn-yr-calendar').removeClass 'active'
        $(this.prevObject[0].activeElement).addClass 'active'

        view = $templateHeader.find('#yr-calendar-period-buttons .active').data().type
        viewMode = d.data().period
        if view is 'calendar'
          if d.data().period is 'yearly'
            $templateHeader.find('.yr-calendar-spot').empty().append $templateCalendarYearly
            buildDates()
            hideLoading()
          if d.data().period is 'half-yearly'
            $templateHeader.find('.yr-calendar-spot').empty().append $templateCalendarHalfYearly
            buildDates()
            hideLoading()
          if d.data().period is 'quarterly'
            $templateHeader.find('.yr-calendar-spot').empty().append $templateCalendarQuarterly
            buildDates()
            hideLoading()
          if d.data().period is 'monthly'
            $templateHeader.find('.yr-calendar-spot').empty().append $templateCalendarMonthly
            instantiateFullcalendar()
            hideLoading()
        if view is 'list'
          if d.data().period is 'yearly'
            $templateHeader.find('.yr-calendar-spot').empty().append $templateListYearly
            instantiateDatatables d.data().period
            hideLoading()
          if d.data().period is 'half-yearly'
            $templateHeader.find('.yr-calendar-spot').empty().append $templateListHalfYearly
            instantiateDatatables d.data().period
            hideLoading()
          if d.data().period is 'quarterly'
            $templateHeader.find('.yr-calendar-spot').empty().append $templateListQuarterly
            instantiateDatatables d.data().period
            hideLoading()
          if d.data().period is 'monthly'
            $templateHeader.find('.yr-calendar-spot').empty().append $templateListMonthly
            instantiateDatatables d.data().period
            hideLoading()

    showLoading = ()->
      $('.loading').show()
      $('#yr-calendar-spot').addClass('blured')
    hideLoading = ()->
      $('.loading').hide()
      $('#yr-calendar-spot').removeClass('blured')
    # binds button click
    listeners = () =>
      $templateHeader.find('button').click ()->
        d = $(@)
        if !d.data().direction
          renderView d
        return
      $templateHeader.find('.nav-dates').click ()->
        b = $(@)
        navigateBetweenDates b.data().direction
        return

      return


    getData = (data)->
      # console.log data

    # init the plugin
    init = ->
      cacheDom()
      buildTemplate()
      buildDates()
      instantiateDatatables()
      getData(settings.data)
      instantiateFullcalendar()
      listeners()
      createSelect()

    init()

    this
) jQuery