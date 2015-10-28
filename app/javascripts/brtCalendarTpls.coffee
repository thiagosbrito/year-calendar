window.templates = {
	'header':'<div class="header-holder">
		<div id="yr-calendar-header" class="well clearfix no-radius affix-top">
			<div class="span5">
				<button class="btn nav-dates prev" data-direction="prev"><i class="icon-chevron-left"></i></button>
				<select class="fix-select span3" id="year-select"></select>
				<button class="btn nav-dates next" data-direction="next"><i class="icon-chevron-right"></i></button>
			</div>
			<div class="span7">
				<div class="btn-group pull-right" id="yr-calendar-period-buttons">
		      <button class="btn active calendar-view t-view" data-control="view" data-type="calendar">
		        <i class="icon-calendar"></i>
		      </button>
		      <button class="btn list-view t-view" data-control="view" data-type="list">
		        <i class="icon-th-list"></i>
		      </button>
		    </div>
				<div class="btn-group pull-right">
					<button class="btn btn-yr-calendar" 				data-period="monthly" 		data-control="period">Mensal</button>
					<button class="btn btn-yr-calendar" 				data-period="quarterly" 	data-control="period">Trimestre</button>
					<button class="btn btn-yr-calendar" 				data-period="half-yearly" data-control="period">Semestre</button>
					<button class="btn btn-yr-calendar active" 	data-period="yearly" 			data-control="period">Ano</button>
				</div>
			</div>
		</div>
		<div class="yr-calendar-spot">
			<div class="loading">
				<div class="spinner">
					<div class="sk-circle">
					  <div class="sk-circle1 sk-child"></div>
					  <div class="sk-circle2 sk-child"></div>
					  <div class="sk-circle3 sk-child"></div>
					  <div class="sk-circle4 sk-child"></div>
					  <div class="sk-circle5 sk-child"></div>
					  <div class="sk-circle6 sk-child"></div>
					  <div class="sk-circle7 sk-child"></div>
					  <div class="sk-circle8 sk-child"></div>
					  <div class="sk-circle9 sk-child"></div>
					  <div class="sk-circle10 sk-child"></div>
					  <div class="sk-circle11 sk-child"></div>
					  <div class="sk-circle12 sk-child"></div>
					</div>
				</div>
			</div>
		</div>
	</div>',

	# Calendar templates
	# YEARLY CALENDAR
	'calendar-yearly' 		: '
		<div class="calendar-spot">
			<div id="yr-calendar-months-list" class="header-yearly">
			</div>
			<div id="yr-calendar-months-grid">
				<div class="month-item-grid yearly"></div>
				<div class="month-item-grid yearly"></div>
				<div class="month-item-grid yearly"></div>
				<div class="month-item-grid yearly"></div>
				<div class="month-item-grid yearly"></div>
				<div class="month-item-grid yearly"></div>
				<div class="month-item-grid yearly"></div>
				<div class="month-item-grid yearly"></div>
				<div class="month-item-grid yearly"></div>
				<div class="month-item-grid yearly"></div>
				<div class="month-item-grid yearly"></div>
				<div class="month-item-grid yearly"></div>
			</div>
			<div id="yr-calendar-schedules-canvas"></div>
		</div>
	',
	# HALF YEAR CALENDAR
	'calendar-half-yearly': '
		<div class="calendar-spot">
			<div id="yr-calendar-months-list" class="header-half-yearly">
			</div>
			<div id="yr-calendar-months-grid">
				<div class="month-item-grid half-yearly"></div>
				<div class="month-item-grid half-yearly"></div>
				<div class="month-item-grid half-yearly"></div>
				<div class="month-item-grid half-yearly"></div>
				<div class="month-item-grid half-yearly"></div>
				<div class="month-item-grid half-yearly"></div>
			</div>
			<div id="yr-calendar-schedules-canvas"></div>
		</div>
	'
	# QUARTER CALENDAR
	'calendar-quarterly' 	: '
		<div class="calendar-spot">
			<div id="yr-calendar-months-list" class="header-quarterly"></div>
			<div id="yr-calendar-months-grid">
				<div class="month-item-grid quarterly"></div>
				<div class="month-item-grid quarterly"></div>
				<div class="month-item-grid quarterly"></div>
			</div>
			<div id="yr-calendar-schedules-canvas"></div>
		</div>
	'
	# MONTH CALENDAR
	'calendar-monthly'		: '
		<div class="calendar-spot">
			<div id="yr-calendar-months-list">
				<div class="month-item-header-list monthly">Outubro</div>
			</div>
			<div id="yr-calendar-months-grid" class="month-calendar"></div>
		</div>
	'
	# List templates 
	'list-yearly' 				: '
		<div class="calendar-spot span12">
			<table id="list-yearly"></table>
		</div>'
	'list-half-yearly'		: '
		<div class="calendar-spot span12">
			<table id="list-half-yearly"></table>
		</div>'
	'list-quarterly'			: '
		<div class="calendar-spot span12">
			<table id="list-quarterly"></table>
		</div>'
	'list-monthly' 				: '
		<div class="calendar-spot span12">
			<table id="list-monthly"></table>
		</div>'
}

