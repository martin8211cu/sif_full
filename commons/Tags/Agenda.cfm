<iframe frameborder="0" name="AgendaAjax" id="AgendaAjax" height="0" width="0" src=""></iframe>
<cfif not isdefined ('request.colorpicker')>
	<script src="/cfmx/jquery/librerias/colorpicker.js" type="text/javascript"></script>
    <cfset request.colorpicker =true>
</cfif>
<cfif not isdefined ('request.jquery.qtip')>
<script src="/cfmx/jquery/librerias/jquery.qtip-1.0.0-rc3.min.js" type="text/javascript"></script>
    <cfset request.jquery.qtip =true>
</cfif>
<cfparam name="Attributes.width" default="40"><!---Esta es el tamaño del calendario, esta dando en %, tamaño maximo 100---> 

<!-- Incluir CSS para jQuery Frontera Calendario plugin (Obligatorio para el calendario plugin) -->
<link rel="stylesheet" type="text/css" href="/cfmx/jquery/estilos/jquery-frontier-cal-1.3.2.css" />

<!-- Include CSS for color picker plugin (Not required for calendar plugin. Used for example.) -->
<link rel="stylesheet" type="text/css" href="/cfmx/jquery/estilos/colorpicker.css" />

<!-- Include CSS for JQuery UI (Required for calendar plugin.) -->
<link rel="stylesheet" type="text/css" href="/cfmx/jquery/estilos/jquery-ui-1.8.1.custom.css" />

<link rel="stylesheet" type="text/css" href="/cfmx/jquery/estilos/agenda-sapiens.css" />

<!--Include JQuery Core (Required for calendar plugin)
** This is our IE fix version which enables drag-and-drop to work correctly in IE. See README file in js/jquery-core folder. **
-->


<style>
body { font-size:100%; }
.shadow {
	-moz-box-shadow: 3px 3px 4px #aaaaaa;
	-webkit-box-shadow: 3px 3px 4px #aaaaaa;
	box-shadow: 3px 3px 4px #aaaaaa;
	/* For IE 8 */
	-ms-filter: "progid:DXImageTransform.Microsoft.Shadow(Strength=4, Direction=135, Color='#aaaaaa')";
}
</style>

<!---Pinta las fechas de la Agenda--->
	<cfinvoke component="commons.Componentes.Agenda" method="GetAgenda" returnvariable="rsIntems">
		<cfinvokeargument name="CAAgrupado" value="Rvac">
	</cfinvoke>
 
<script type="text/javascript">
var valor="OFF";
var repit='OFF';
$(document).ready(function(){	
var clickAgendaItem = "";
var clickDate = "";
var Elimino_ID="";
var Elimino_EndDay="";
var Elimino_Descripcion="";

	/**
	 * Initializes calendar with current year & month
	 * specifies the callbacks for day click & agenda item click events
	 * then returns instance of plugin object
	 */
	 var jfcalplugin = $("#mycal").jFrontierCal({
		date: new Date(),
		dayClickCallback: myDayClickHandler,
		agendaClickCallback: myAgendaClickHandler,
	//	agendaDropCallback: myAgendaDropHandler,
		agendaMouseoverCallback: myAgendaMouseoverHandler,
		applyAgendaTooltipCallback: myApplyTooltip,
		agendaDragStartCallback : myAgendaDragStart,
		agendaDragStopCallback : myAgendaDragStop,
		dragAndDropEnabled: true
	}).data("plugin");
	date= new Date(),
	mes = date.getMonth()+1;
	año = date.getFullYear();
	CargaAgendaMes(mes,año);
	
	/**
	 * Do something when dragging starts on agenda div
	 */
	function myAgendaDragStart(eventObj,divElm,agendaItem){
		// destroy our qtip tooltip
		if(divElm.data("qtip")){
			divElm.qtip("destroy");
		}
			
	};

	function myAgendaDragStop(eventObj,divElm,agendaItem){
	};
	
	/**
	 * @param divElm - jquery object for agenda div element
	 * @param agendaItem - javascript object containing agenda data.
	 */
	function myApplyTooltip(divElm,agendaItem){

	// Destroy currrent tooltip if present
		if(divElm.data("qtip")){
			divElm.qtip("destroy");
		}
		
		var displayData = "";
		var title = agendaItem.title;
		var fecha = agendaItem.fecha;
		var endDate = agendaItem.endDate;
		var allDay = agendaItem.allDay;
		var data = agendaItem.data;
		var LvarFecha = endDate.getFullYear()+"-"+(endDate.getMonth()+1)+"-"+endDate.getDate()			

		displayData += "<h3> " + title+ "</h3>";
		displayData += "<h4> Fecha :" + LvarFecha + "</h4> ";

		// use the user specified colors from the agenda item.
		var backgroundColor = agendaItem.displayProp.backgroundColor;
		var foregroundColor = agendaItem.displayProp.foregroundColor;
		var myStyle = {
			border: {
				width: 5,
				radius: 10
			},
			padding: 10, 
			textAlign: "left",
			tip: true,
			name: "dark" // other style properties are inherited from dark theme		
		};
		if(backgroundColor != null && backgroundColor != ""){
			myStyle["backgroundColor"] = backgroundColor;
		}
		if(foregroundColor != null && foregroundColor != ""){
			myStyle["color"] = foregroundColor;
		}
		// apply tooltip
		divElm.qtip({
			content: displayData,
			position: {
				corner: {
					tooltip: "bottomMiddle",
					target: "topMiddle"			
				},
				adjust: { 
					mouse: true,
					x: 0,
					y: -50
				},
				target: "mouse"
			},
			show: { 
				when: { 
					event: 'mouseover'
				}
			},
			style: myStyle
		});
	};

	/**
	 * Make the day cells roughly 3/4th as tall as they are wide. this makes our calendar wider than it is tall. 
	 */
	jfcalplugin.setAspectRatio("#mycal",0.75);

	/**
	 * Called when user clicks day cell
	 * use reference to plugin object to add agenda item
	 */
	function myDayClickHandler(eventObj){
		// Get the Date of the day that was clicked from the event object
		var date = eventObj.data.calDayDate;
		// store date in our global js variable for access later
		clickDate = date.getFullYear() + "-" + (date.getMonth()+1) + "-" + date.getDate();
			// open our Agregar dialog
		$('#add-event-form').dialog('open');		
	};

	/**
	 * Called when user clicks and agenda item
	 * use reference to plugin object to Editar agenda item
	 */
	function myAgendaClickHandler(eventObj){
		// Get ID of the agenda item from the event object
		var agendaId = eventObj.data.agendaId;		
		// pull agenda item from calendar
		// Get the Date of the day that was clicked from the event object
		var agendaItem = jfcalplugin.getAgendaItemById("#mycal",agendaId);	
		clickAgendaItem = agendaItem;
		$("#display-event-form").dialog('open');
	};
	
	/**
	 * Called when user drops an agenda item into a day cell.
	 */
	function myAgendaDropHandler(eventObj){
		// Get ID of the agenda item from the event object
		var agendaId = eventObj.data.agendaId;
		// date agenda item was dropped onto
		var date = eventObj.data.calDayDate;
		// Pull agenda item from calendar
		var fecha = date.getFullYear() + "-" + (date.getMonth()+1) + "-" + date.getDate();
		if(confirm("¿Esta seguro de querer mover este evento?"+fecha+"   ID  "+ agendaId)){
			var agendaItem = jfcalplugin.getAgendaItemById("#mycal",agendaId);	
			$(this).dialog('close');
		//	CambioAgendaFI(fecha,agendaId);
		}
	
			
	};
	
	function fnAjax(){
			var xmlhttp=false;
			try {
				xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
			} catch (e) {
			try {
				xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
			} catch (E) {
				xmlhttp = false;
			}
			}
			
			if (!xmlhttp && typeof XMLHttpRequest!='undefined') {
				xmlhttp = new XMLHttpRequest();
			}
			return xmlhttp;
	};
	/**
	 * Called when a user mouses over an agenda item	
	 */
	function myAgendaMouseoverHandler(eventObj){
		var agendaId = eventObj.data.agendaId;
		var agendaItem = jfcalplugin.getAgendaItemById("#mycal",agendaId);
		//alert("You moused over agenda item " + agendaItem.title + " at location (X=" + eventObj.pageX + ", Y=" + eventObj.pageY + ")");
	};
	/**
	 * Initialize jquery ui datepicker. set date format to yyyy-mm-dd for easy parsing
	 */
	$("#dateSelect").datepicker({
		showOtherMonths: true,
		selectOtherMonths: true,
		changeMonth: true,
		changeYear: true,
		showButtonPanel: true,
		dateFormat: 'yy-mm-dd'
		
	});
	/**
	 * Set datepicker to current date
	 */
	$("#dateSelect").datepicker('setDate', new Date());
	/**
	 * Use reference to plugin object to a specific year/month
	 */
	$("#dateSelect").bind('change', function() {
		var selectedDate = $("#dateSelect").val();
		var dtArray = selectedDate.split("-");
		var year = dtArray[0];
		// jquery datepicker months start at 1 (1=January)		
		var month = dtArray[1];
		// strip any preceeding 0's		
		month = month.replace(/^[0]+/g,"")	
		CargaAgendaMes(month,year);	
		var day = dtArray[2];
		// plugin uses 0-based months so we subtrac 1

		
		jfcalplugin.showMonth("#mycal",year,parseInt(month-1).toString());
		
	});	
	/**
	 * Initialize previous month button
	 */
	$("#BtnPreviousMonth").button();
	$("#BtnPreviousMonth").click(function() {
		
		jfcalplugin.showPreviousMonth("#mycal");
		// update the jqeury datepicker value
		var calDate = jfcalplugin.getCurrentDate("#mycal"); // returns Date object
		var cyear = calDate.getFullYear();
		// Date month 0-based (0=January)
		var cmonth = calDate.getMonth();
		CargaAgendaMes(cmonth+1,cyear);
		var cday = calDate.getDate();

		// jquery datepicker month starts at 1 (1=January) so we add 1
		$("#dateSelect").datepicker("setDate",cyear+"-"+(cmonth+1)+"-"+cday);
		return false;
	});
	/**
	 * Initialize next month button
	 */
	$("#BtnNextMonth").button();
	$("#BtnNextMonth").click(function() {
		jfcalplugin.showNextMonth("#mycal");
		// update the jqeury datepicker value
		var calDate = jfcalplugin.getCurrentDate("#mycal"); // returns Date object
		var cyear = calDate.getFullYear();
		// Date month 0-based (0=January)
		var cmonth = calDate.getMonth();
		CargaAgendaMes(cmonth+1,cyear);
		var cday = calDate.getDate();
	
		// jquery datepicker month starts at 1 (1=January) so we add 1
		$("#dateSelect").datepicker("setDate",cyear+"-"+(cmonth+1)+"-"+cday);
		return false;
	});
	
	/**
	 * Initialize delete all agenda items button
	 */
	$("#BtnDeleteAll").button();
	$("#BtnDeleteAll").click(function() {	
		jfcalplugin.deleteAllAgendaItems("#mycal");	
		return false;
	});		
	
	/**
	 * Initialize iCal test button
	 */
	$("#BtnICalTest").button();
	$("#BtnICalTest").click(function() {
		// Please note that in Google Chrome this will not work with a local file. Chrome prevents AJAX calls
		// from reading local files on disk.		
		jfcalplugin.loadICalSource("#mycal",$("#iCalSource").val(),"html");	
		return false;
	});	

	/**
	 * Initialize Agregar modal form
	 */

	$("#add-event-form").dialog({
		autoOpen: false,
		width: 310,
		modal: false,
		buttons: {
			'Agregar': function() {
				var descripcion = jQuery.trim($("#descripcion").val());	
				if(descripcion == ""){
					alert("Por favor llenar el campo \"Descripcion del feriado\".");
				}else{
					var fecha = $("#fecha").val();
					var repites=0;
					if(valor=='OFF'){
						repites =0;
					}
					else{
						repites =1;					
					}
						var startDtArray = fecha.split("-");
						var startYear = startDtArray[0];
						// jquery datepicker months start at 1 (1=January)		
						var startMonth = startDtArray[1];
							
						var startDay = startDtArray[2];
						// strip any preceeding 0's		
						startMonth = startMonth.replace(/^[0]+/g,"");
						startDay = startDay.replace(/^[0]+/g,"");
					
						var fechaObj = new Date(parseInt(startYear),parseInt(startMonth)-1,parseInt(startDay));		
				
					//Llamo para guardar en BD
					src="/cfmx/commons/Utiles/AgendaAjax.cfm?modo=ALTA&descripcion="+descripcion+"&fecha="+fecha+"&repite="+valor;
						ajax = fnAjax();
						ajax.open("GET", src, true);
						ajax.onreadystatechange=function() {
							if (ajax.readyState==4) {
								$("#mycal").data("plugin").addAgendaItem(
									"#mycal",
									descripcion,
									fechaObj,
									fechaObj,
									false,
									{check:repites},
									{
										backgroundColor: $("#colorBackground").val(),
										foregroundColor: $("#colorForeground").val()
									},parseInt(jQuery.trim(ajax.responseText)));
							}
						}
						ajax.send(null);
								
					$(this).dialog('close');
				}
			},
			Cancelar: function() {
				$(this).dialog('close');
			}
		},
		open: function(event, ui){
			// initialize start date picker
			$("#fecha").datepicker({
				showOtherMonths: true,
				selectOtherMonths: true,
				changeMonth: true,
				changeYear: true,
				showButtonPanel: true,
				dateFormat: 'yy-mm-dd'
			});
			// initialize with the date that was clicked			
			$("#fecha").val(clickDate);
			$("#colorSelectorBackground").ColorPicker({
				color: "#333333",
				onShow: function (colpkr) {
					$(colpkr).css("z-index","10000");
					$(colpkr).fadeIn(500);
					return false;
				},
				onHide: function (colpkr) {
					$(colpkr).fadeOut(500);
					return false;
				},
				onChange: function (hsb, hex, rgb) {
					$("#colorSelectorBackground div").css("backgroundColor", "#" + hex);
					$("#colorBackground").val("#" + hex);
				}
			});
			//$("#colorBackground").val("#1040b0");		
			$("#colorSelectorForeground").ColorPicker({
				color: "#ffffff",
				onShow: function (colpkr) {
					$(colpkr).css("z-index","10000");
					$(colpkr).fadeIn(500);
					return false;
				},
				onHide: function (colpkr) {
					$(colpkr).fadeOut(500);
					return false;
				},
				onChange: function (hsb, hex, rgb) {
					$("#colorSelectorForeground div").css("backgroundColor", "#" + hex);
					$("#colorForeground").val("#" + hex);
				}
			});
			// put focus on first form input element
			$("#descripcion").focus();
		},
		close: function() {
		// reset form elements when we close so they are fresh when the dialog is opened again.
			$("#fecha").datepicker("destroy");
			$("#endDate").datepicker("destroy");
			$("#fecha").val("");
			$("#endDate").val("");	
			$("#descripcion").val("");
			
		}
	});

	/**
	 * Initialize display event form.
	 */
	$("#display-event-form").dialog({
		autoOpen: false,
		width: 340,
		modal: false,
		buttons: {		
			Cancelar: function() {
				$(this).dialog('close');
			},
			'Actualizar': function() {
				var descripcion = jQuery.trim($("#descripcion2").val());
				if(descripcion == ""){
					alert("Por favor llenar el campo \"Descripcion del feriado\".");
				}else{
					var repite=0;
					if(repit=='OFF'){
						repite=0;	
					}
					else{
						repite=1;
					}
					var endDate = $("#endDate").val();
					var endDtArray = endDate.split("-");
					var endYear = endDtArray[0];
					// jquery datepicker months start at 1 (1=January)		
					var endMonth = endDtArray[1];		
					var endDay = endDtArray[2];
					// strip any preceeding 0's		
					endMonth = endMonth.replace(/^[0]+/g,"");
					endDay = endDay.replace(/^[0]+/g,"");
					if(clickAgendaItem != null){
						jfcalplugin.deleteAgendaItemById("#mycal",clickAgendaItem.agendaId);
						jfcalplugin.deleteAgendaItemById("#mycal",clickAgendaItem.agendaId);
					}
					var endDateObj = new Date(parseInt(endYear),parseInt(endMonth)-1,parseInt(endDay));
					// add new event to the calendar
					$("#mycal").data("plugin").addAgendaItem(
						"#mycal",
						descripcion,
						endDateObj,
						endDateObj,
						false,
						{check:repite},
						{
							backgroundColor: $("#colorBackground").val(),
							foregroundColor: $("#colorForeground").val()
						},clickAgendaItem.agendaId
					);
					CambioAgenda(descripcion,endDate,repit,clickAgendaItem.agendaId);
					$(this).dialog('close');
				}				
			},
			'Eliminar': function() {
				//pregunto se repite
				if(repit=='OFF'){
					//Eliminando
						if(clickAgendaItem != null){
							$("#mycal").data("plugin").deleteAgendaItemById("#mycal",clickAgendaItem.agendaId);
							$("#mycal").data("plugin").deleteAgendaItemById("#mycal",clickAgendaItem.agendaId);
							//Elimino de la BD
							BajaAgenda(clickAgendaItem.agendaId);
						}
						$(this).dialog('close');
				}
				else{
					//abro una instancia para proceso de eliminacion
					var endDate = $("#endDate").val();
					Elimino_ID = clickAgendaItem.agendaId;
					Elimino_EndDay = endDate;
					Elimino_Descripcion = jQuery.trim($("#descripcion2").val());
							$(this).dialog('close');
							$("#box").dialog('open');
				}
			}			
		},
		//Funcion que se ejecuta al Abrir el Pop-Up del Itemp
		open: function(event, ui){
			if(clickAgendaItem != null){
				var title = clickAgendaItem.title;
				var endDate = clickAgendaItem.endDate;
				var IDUNIQUE = clickAgendaItem.agendaId;
				var data = clickAgendaItem.data.check;
				var muestraCheck="";
				repit='OFF';
				if(data==1){
					repit='ON';
					muestraCheck='checked="checked"';
				}
				var LvarFecha = endDate.getFullYear()+"-"+(endDate.getMonth()+1)+"-"+endDate.getDate()			
				// in our example add agenda modal form we put some fake data in the agenda data. we can retrieve it here.
				$("#display-event-form").append(
					"<b>Descripcion del Feriado <b> <br><input type='text' name='descripcion2' id='descripcion2' value='"+title+"'  /><br></br>"+	
					"<b>Fecha</br> <input type='text' name='endDate' value='"+LvarFecha+"' id='endDate' class='text ui-widget-content ui-corner-all'  style='margin-bottom: 12px; width: 50%; padding: 0.4em;'/><br>	<input type='checkbox' name='repite2' id='repite2' "+muestraCheck+" onclick='fijar();' >Repetir cada A&ntilde;o"
				);						
			};		
		
			$("#endDate").datepicker({
				showOtherMonths: true,
				selectOtherMonths: true,
				changeMonth: true,
				changeYear: true,
				showButtonPanel: true,
				dateFormat: 'yy-mm-dd'
			});
			// initialize color pickers
			$("#colorSelectorBackground").ColorPicker({
				color: "#333333",
				onShow: function (colpkr) {
					$(colpkr).css("z-index","10000");
					$(colpkr).fadeIn(500);
					return false;
				},
				onHide: function (colpkr) {
					$(colpkr).fadeOut(500);
					return false;
				},
				onChange: function (hsb, hex, rgb) {
					$("#colorSelectorBackground div").css("backgroundColor", "#" + hex);
					$("#colorBackground").val("#" + hex);
				}
			});
			//$("#colorBackground").val("#1040b0");		
			$("#colorSelectorForeground").ColorPicker({
				color: "#ffffff",
				onShow: function (colpkr) {
					$(colpkr).css("z-index","10000");
					$(colpkr).fadeIn(500);
					return false;
				},
				onHide: function (colpkr) {
					$(colpkr).fadeOut(500);
					return false;
				},
				onChange: function (hsb, hex, rgb) {
					$("#colorSelectorForeground div").css("backgroundColor", "#" + hex);
					$("#colorForeground").val("#" + hex);
				}
			});		
			// put focus on first form input element
			$("#descripcion2").focus();
		},
		close: function() {
			// clear agenda data
			document.getElementById('fechaB').value = document.getElementById('endDate').value;
			$("#endDate").datepicker("destroy");
			// reset form elements when we close so they are fresh when the dialog is opened again.
			$("#endDate").val("");
			$("#display-event-form").html("");
		}
	});
	$("#box").dialog({
		autoOpen: false,
		width: 510,
		modal: false,
		buttons: {		
				Cancelar: function() {
					$(this).dialog('close');
				},
				'Todos los eventos del Feriado': function() {
					//Elimino, no antes de consultar las dependencias
						if(clickAgendaItem != null){
							$("#mycal").data("plugin").deleteAgendaItemById("#mycal",clickAgendaItem.agendaId);
							$("#mycal").data("plugin").deleteAgendaItemById("#mycal",clickAgendaItem.agendaId);
							//Elimino de la BD
							BajaAgenda(clickAgendaItem.agendaId);
						}
						$(this).dialog('close');
				},	
				'Solo esta Vez': function() {
					//Redujo la fecha del año hecho(fecha final) al año anterior
					//y genero para el año proximo en adelante 
					//Ejemplo FI 2008 Feriado X FF 6100 Hoy es 2011 elimino solo esta vez 
					//dejando FI 2008 Feriado X FF 2010 y CREO uno nuevo FI 2012 Feriado X FF 6100					
					// Cambio queda con el repite pero con fecha fin nueva.
					var descripcion = Elimino_Descripcion;
						var endDtArray = document.getElementById('fechaB').value.split("-");
						// jquery datepicker months start at 1 (1=January)	
						var yearN = parseInt(endDtArray[0]);
						var yearF = endDtArray[0];
						var fechaN = yearN+1;
						var endYear = yearF-1;	
						var endMonth = endDtArray[1];		
						var endDay = endDtArray[2];
						// strip any preceeding 0's		
						endMonth = endMonth.replace(/^[0]+/g,"");
						endDay = endDay.replace(/^[0]+/g,"");
						if(clickAgendaItem != null){
							jfcalplugin.deleteAgendaItemById("#mycal",Elimino_ID);
							jfcalplugin.deleteAgendaItemById("#mycal",Elimino_ID);
						}
						var endDateObj = endYear+"-"+endMonth+"-"+endDay;
						var startDateObj = fechaN+"-"+endMonth+"-"+endDay;
					CambioAgendaFechaFin(endDateObj,Elimino_ID);
					//Inserto el nuevo elemento
						src="/cfmx/commons/Utiles/AgendaAjax.cfm?modo=ALTA&descripcion="+descripcion+"&fecha="+startDateObj+"&repite=ON";
						ajax = fnAjax();
						ajax.open("GET", src, true);
						ajax.onreadystatechange=function() {
							if (ajax.readyState==4) {
								//simplemente esperando
							}
						}
						ajax.send(null);
										
					$(this).dialog('close');			
				}
		}
	});

 	/**
	 * Initialize our tabs
	 */
	$("#tabs").tabs({
		/*
		 * Our calendar is initialized in a closed tab so we need to resize it when the example tab opens.
		 */
		show: function(event, ui){
			if(ui.index == 1){
				jfcalplugin.doResize("#mycal");
			}
		}	
	});	
		
	function CargaAgendaMes(mes,year){	
						src="/cfmx/commons/Utiles/AgendaAjax.cfm?modo=MES&mes="+mes+"&years="+year;
						ajax = fnAjax();
						ajax.open("GET", src, true);
						ajax.onreadystatechange=function() {
							if (ajax.readyState==4) {
							var miString = ajax.responseText;
							var result = ""
							var contador=0;
							var aValores = new Array();
								for (i=0;i<miString.length-1;i++) {
									if(miString.charAt(i)!='/'){
										result += miString.charAt(i);
									}
									else {
										aValores[contador]=result;
										result="";
										contador++;
									}
								} 
								var inserciones = contador/4;
								
								var array = 0;
								for (i=0;i<inserciones;i++) {
									var descripcion =aValores[array];
									array++;
									var fecha = aValores[array];
									var startDtArray =aValores[array].split("-");
									array++;
									var startYear = startDtArray[0];
									// jquery datepicker months start at 1 (1=January)		
									var startMonth = startDtArray[1];		
									var startDay = startDtArray[2];
									// strip any preceeding 0's		
									startMonth = startMonth.replace(/^[0]+/g,"");
									startDay = startDay.replace(/^[0]+/g,"");
									var repi =aValores[array];
									array++;
									var fechaObj = new Date(parseInt(startYear),parseInt(startMonth)-1,parseInt(startDay));	
										$("#mycal").data("plugin").addAgendaItem(
											"#mycal",
											descripcion,
											fechaObj,
											fechaObj,
											false,
											{check:repi},
											{
												backgroundColor: $("#colorBackground").val(),
												foregroundColor: $("#colorForeground").val()
											},parseInt(jQuery.trim(aValores[array])));
											array++;
								}
							}	
						}
						ajax.send(null);	
	};
});
	function fijar(){		
		if (repit=='OFF'){
			 repit = 'ON';
		}
		else{
			repit = 'OFF';
		}
	};
	
//Eventos Ajax
function CambioAgenda(descrip,fech,repi,CAAid){
	document.getElementById("AgendaAjax").src="/cfmx/commons/Utiles/AgendaAjax.cfm?modo=CAMBIO&descripcion="+descrip+"&fecha="+fech+"&repite="+repi+"&CAAid="+CAAid;
	}
	
function CambioAgendaFechaFin(fech,CAAid){
	document.getElementById("AgendaAjax").src="/cfmx/commons/Utiles/AgendaAjax.cfm?modo=CAMBIOFechaFin&fecha="+fech+"&CAAid="+CAAid;
	}

function BajaAgenda(CAAid){
	document.getElementById("AgendaAjax").src="/cfmx/commons/Utiles/AgendaAjax.cfm?modo=BAJA&CAAid="+CAAid;
	}

</script>
 <input type="hidden" name="fechaB" id="fechaB" value=""/>
<div id="example" style="margin: auto; width:<cfoutput>#Attributes.width#</cfoutput>%;">
	<!--Div del Toolbar del Encabezado--->
    <div id="toolbar" class="ui-widget-header ui-corner-all" style="padding:3px; vertical-align: middle; white-space:nowrap; overflow: hidden;">
   
        <button id="BtnPreviousMonth">Mes Anterior</button>
        <button id="BtnNextMonth">Mes Siguiente</button>
        &nbsp;&nbsp;&nbsp;
        Fecha: 
		<input type="text" id="dateSelect" size="12"/>
		&nbsp;&nbsp;&nbsp; 
     </div>
	<!--Div del Contenedor de la Agenda-->
	<div id="mycal">	
    </div>
</div>
<!-- debugging-->
<div id="calDebug"></div>

<!-- Agregar modal form -->
<style type="text/css">
label, input.text, select { display:block; }
fieldset { padding:0; border:0; margin-top:25px; }
.ui-dialog .ui-state-error { padding: .3em; }
.validateTips { border: 1px solid transparent; padding: 0.3em; }
</style>
<select  name="startHour" class="text ui-widget-content ui-corner-all" id="startHour" style="margin-bottom:12px; width:0%; padding: .4em; visibility: hidden;">
     <option value="12" SELECTED>12</option>
</select>	
<select name="startMin" class="text ui-widget-content ui-corner-all" id="startMin" style="margin-bottom:12px; width:0%; padding: .4em; visibility: hidden;">
    <option value="00" selected>00</option>
</select>
<select name="startMeridiem" class="text ui-widget-content ui-corner-all" id="startMeridiem" style="margin-bottom:12px; width:0%; padding: .4em; visibility: hidden;">
    <option value="AM" selected>AM</option>
</select>
<select name="endMeridiem" class="text ui-widget-content ui-corner-all" id="endMeridiem" style="margin-bottom:12px; width:0%; padding: .4em; visibility: hidden;">
  <option value="AM" selected>AM</option>
</select>
<select name="endMin" class="text ui-widget-content ui-corner-all" id="endMin" style="margin-bottom:12px; width:0%; padding: .4em; visibility: hidden;">
  <option value="00" selected>00</option>
</select>
<select name="endHour" class="text ui-widget-content ui-corner-all" id="endHour" style="margin-bottom:12px; width:0%; padding: .4em; visibility: hidden;">
  <option value="12" selected>12</option>
</select>
<div id="add-event-form" title="Agregar un Nuevo Feriado">
<form>    
<label for="name">Descripcion del Feriado</label>
    <input type="text" name="descripcion" id="descripcion" class="text ui-widget-content ui-corner-all" style="margin-bottom:12px; width:95%; padding: .4em;"/>
<label for="feriado">Fecha del Feriado</label>
          <input type="text" name="fecha" id="fecha" value="" class="text ui-widget-content ui-corner-all" style="margin-bottom:12px; width:60%; padding: .4em;"/>
 <input type="checkbox" name="repite" id="repite" onclick="pintar();">Repetir cada A&ntilde;o
</form>
</div>
	<script>
	function pintar(){		
		if (valor=='OFF'){
			 valor = 'ON';
		}
		else{
			valor = 'OFF';
		}
	};
	</script>
<!--Este es el Div que se usa para la edicion del agenda--->	
<div id="display-event-form" title="Editar Feriados"> </div>
<!--Este es el Div que se usa para la explicacion de eliminar un evento periodico de agenda--->		
<div id="box" class="dialog" title="Eliminar Evento Periodico">
	¿Deseas suprimir únicamente este evento, todos los eventos de este feriado?<br /><br/>
    *Solo esta vez* Se conservarán todos los demás eventos del feriado.<br/>
    *Todos los eventos del feriado* Se eliminarán todos los eventos del feriado.
</div> 