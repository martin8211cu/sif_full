<cfset def = QueryNew('fecha')>

<cfparam name="Attributes.Conexion"	 	default="#Session.DSN#" type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 		default="form1" 		type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.query"	 	default="#def#" 		type="query">  <!--- consulta por defecto --->
<cfparam name="Attributes.name" 		default="fecha"	 		type="string"> <!--- Nombre del campo de la fecha --->
<cfparam name="Attributes.value" 		default="" 				type="string"> <!--- valor por defecto --->
<cfparam name="Attributes.tabindex" 	default="" 				type="string"> <!--- número del tabindex --->
<cfparam name="Attributes.onBlur" 		default="" 				type="string"> <!--- función en el evento onBlur --->
<cfparam name="Attributes.onChange" 	default="" 				type="string"> <!--- función en el evento onChange --->
<cfparam name="Attributes.Function" 	default="" 				type="string"> <!--- Se Dispara cuando se cambia desde el Input o cuando se selecciona desde el calendario(ojo rempleza la funcion Onchange)--->
<cfparam name="Attributes.formato" 		default="" 				type="string"> <!--- Formato de la fecha--->
<cfparam name="Attributes.valign" 		default="baseline" 		type="string"> <!--- Alineacion Vertical--->
<cfparam name="Attributes.image" 		default="true" 			type="boolean"><!--- Visualizar el image del calendario --->
<cfparam name="Attributes.style" 		default="" 				type="string">
<cfparam name="Attributes.enterAction" 	default="" 				type="string">
<cfparam name="Attributes.readOnly" 	default="false" 		type="boolean">
<cfparam name="Attributes.idioma" 		default=""              type="string">
<cfparam name="Attributes.class" 		default=""				type="string"><!--- propiedad class ---->
<cfparam name="Attributes.obligatorio"  default="0"				type="string"><!--- el campo es obligatorio dentro del formulario (integracion parsley)--->
<cfparam name="Attributes.nameFechaFin"  default=""			type="string"> <!--- nombre del input de fecha con el cual se va a limitar el rango (tomar el name como fecha inicio, nameFechafin como fecha final) --->
<cfparam name="Attributes.nameFechaInicio"  default=""			type="string"> <!--- nombre del input de fecha con el cual se va a limitar el rango (tomar el nameFechaInicio como fecha inicio, name como fecha final) --->


<!---►►Si se envia el Function remplaza el onchage◄◄--->
<cfif LEN(TRIM(Attributes.Function))>
	<cfset Attributes.onChange = Attributes.Function>
</cfif>

<cfif not isdefined("request.idiomaFormatoFecha")>
	<cfset request.idiomaFormatoFecha = 'dd/mm/yyyy'>
	<cfif not isdefined("session.Idioma")>
		<cfset session.Idioma = 'es'>
	</cfif>
		<cfquery datasource="sifcontrol" name="rsFF">
			select Iformatofecha from Idiomas where Icodigo='#trim(session.Idioma)#'
		</cfquery>
		<cfif len(trim(rsFF.Iformatofecha))>
			<cfset request.idiomaFormatoFecha =  rsFF.Iformatofecha>
		</cfif>
</cfif>	

<cfif not len(trim(Attributes.formato))>
	<cfset Attributes.formato = request.idiomaFormatoFecha>	
</cfif>


<!---- obtiene el formato deacuerdo al idioma---->
<cfif not isdefined("Request.jsSifcalendarIdioma")>
		<cfif len(trim(attributes.idioma))>
			<cfset LvarIdioma = attributes.idioma>
		<cfelseif len(trim(session.idioma))>
			<cfset LvarIdioma = session.idioma>
		<cfelse>
			<cfset LvarIdioma = 'es'>
		</cfif>
		<!----<cfset LvarIdioma='english'>---->
		<cfset Request.jsSifcalendarIdioma='es'>
		<cfif findNoCase("en", LvarIdioma)>
			<cfset Request.jsSifcalendarIdioma = 'en'>
		<cfelseif findNoCase("fr", LvarIdioma)>
			<cfset Request.jsSifcalendarIdioma = 'fr'>
		<cfelseif findNoCase("pt", LvarIdioma)>
			<cfset Request.jsSifcalendarIdioma = 'pt'>
		</cfif>
</cfif>	

<!---- inserta las librerias a utilizar---->
<cfif not isdefined("Request.jsSifcalendar")>
	<cfset Request.jsSifcalendar = true> 
	<cfset Request.jsMask = true>
	<script>window.jQuery || document.write('<script src="/cfmx/jquery/librerias/jquery-2.0.2.min.js"><\/script>')</script>
	<script src="/cfmx/sif/js/MaskApi/masks.js"></script>
	<cfif NOT isdefined("request.scriptOnEnterKeyDefinition")><cf_onEnterKey></cfif>
	<link rel="stylesheet" type="text/css" media="screen" href="/cfmx/jquery/estilos/datepicker.min.css" />
	<script language="JavaScript" src="/cfmx/jquery/librerias/bootstrap-datepicker.min.js"></script>
	<cfif request.jsSifcalendarIdioma neq 'en'>
		<!----
		<script type="text/javascript" src="/cfmx/jquery/librerias/locales/bootstrap-datepicker.<cfoutput>#Request.jsSifcalendarIdioma#</cfoutput>.js"></script>
		----->
	</cfif>
	<cfif request.jsSifcalendarIdioma neq 'es'>
	<!--- <script type="text/javascript">$(document).ready(function() {MaskAPIsetLanguage('<cfoutput>#request.jsSifcalendarIdioma#</cfoutput>');});</script> --->
	</cfif>

	<cfif Attributes.formato neq 'dd/mm/yyyy'>
		<script type="text/javascript">

			function setDateTimeSifCalendar(e){ 
				var x = $(e).attr('id');
				x = x.substring(6,x.length);
				if($(e).val()!=0){
						$(e).datepicker('setValue', $(e).val());
						<cfif Attributes.formato eq 'mm/dd/yyyy'>
				   			<cfoutput>$("##"+x).val($(e).val().substring(3,5)+'/'+$(e).val().substring(0,2)+'/'+$(e).val().substring(6,10));</cfoutput>
				   		<cfelseif Attributes.formato eq 'yyyy/mm/dd'>
				   			<cfoutput>$("##"+x).val($(e).val().substring(3,5)+'/'+$(e).val().substring(0,2)+'/'+$(e).val().substring(6,10));</cfoutput>
				   		</cfif>
				}
				else{
					$("#"+x).val('');
				}
			}
		</script>
	</cfif>
</cfif>


<cfoutput>

	<cfset LvarCalendarPre =''>
	<cfset LvarCalendarPreFunction = 'OnBlur="#Attributes.OnBlur#"  OnChange="#Attributes.OnChange#"'>
	<cfif LEN(TRIM(Attributes.Function))>
		<cfset Attributes.onChange = Attributes.Function/>
	</cfif>

	<cfset LvarValue =attributes.value>
	<cfset LvarValueVisual =''>

	<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
	  	<cfset obj = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.name')#')#')">
	  	<cfset attributes.value = LSDateFormat(Evaluate('#obj#'),'DD/MM/YYYY')>
	</cfif>

	<cfif len(trim(attributes.value))>
   		<cfset LvarValueVisual = LSDateFormat(attributes.value,'#Attributes.formato#')>
    </cfif>

	<cfif Attributes.formato neq 'dd/mm/yyyy'>
		<input type='hidden' id="#Attributes.name#" name="#Attributes.name#" value="#LvarValue#">	
		<cfset LvarCalendarPre ='jsCDTP'>
		<cfset LvarCalendarPreFunction ='onblur="#Attributes.OnBlur#" onchange="setDateTimeSifCalendar(this);#Attributes.OnChange#"; '>
	</cfif>


	<input type='text' title="#Attributes.formato#" <cfif Attributes.readOnly> tabindex="-1" readOnly="readOnly" </cfif>
			placeholder="#Attributes.formato#" autocomplete="off" maxlength="10" size="10" id="#LvarCalendarPre##Attributes.name#" name="#LvarCalendarPre##Attributes.name#"  #LvarCalendarPreFunction# 
			value="#LvarValueVisual#"
			<cfif Len(Attributes.style)>style="#Attributes.style#"</cfif> 
			<cfif Len(Trim(Attributes.class)) GT 0>class="#Attributes.class#"</cfif> <!---- Class, podemos utilizarla para buscar el componente por jquery ------>
			obligatorio="#Attributes.obligatorio#"		<!--- Indica que es obligatorio dentro del formulario, validaciones con parsley --->
			<cfif Len(Trim(Attributes.tabindex)) GT 0 and not Attributes.readOnly> tabindex="#Attributes.tabindex#" </cfif>
	/>
	<cfif not Attributes.readOnly>
		<script type="text/javascript">
		    $(function () {
		    	 $('###LvarCalendarPre##Attributes.name#').datepicker({
					    format: "#Attributes.formato#",
					    todayBtn: "linked",
					    language: "#Request.jsSifcalendarIdioma#",
					    calendarWeeks: true,
					    autoclose: true,
					    todayHighlight: true,
					    immediateUpdates: false
					            
					    
					}).keydown(function(e) {var code = e.keyCode || e.which;if (code == '9') {$(".datepicker").css('display','none');}}
				  ).on("changeDate",function (e) {

				  		<cfif len(trim(Attributes.nameFechaFin)) GT 0>
				  			validaFecha#Attributes.name#();
				  		</cfif>
				  		<cfif len(trim(Attributes.nameFechaInicio)) GT 0>
				  			validaFecha#Attributes.nameFechaInicio#();
				  		</cfif>
						#Attributes.OnChange#


						  
				 }).change(function(e){<cfif len(trim(Attributes.nameFechaFin)) GT 0>
				  			validaFecha#Attributes.name#();
				  		</cfif>
				  		<cfif len(trim(Attributes.nameFechaInicio)) GT 0>
				  			validaFecha#Attributes.nameFechaInicio#();
				  		</cfif>
				 }).blur(function(e){<cfif len(trim(Attributes.nameFechaFin)) GT 0>
				  			validaFecha#Attributes.name#();
				  		</cfif>
				  		<cfif len(trim(Attributes.nameFechaInicio)) GT 0>
				  			validaFecha#Attributes.nameFechaInicio#();
				  		</cfif>
				 });

				 

		    });
			<cfif Attributes.formato neq 'dd/mm/yyyy'>
		 		$(function () {
		 			setDateTimeSifCalendar($('###LvarCalendarPre##Attributes.name#'));
			    });
		    </cfif>
			oDateMask = new Mask("#Attributes.formato#", "date");
			oDateMask.attach(document.getElementById('#LvarCalendarPre##Attributes.name#'),"#Attributes.formato#", "date", "#Attributes.OnBlur#", "", "", "<cfif Attributes.formato neq 'dd/mm/yyyy'>setDateTimeSifCalendar(this);</cfif>#Attributes.OnChange#", "#Attributes.enterAction#");

		<cfif len(trim(Attributes.nameFechaFin)) GT 0>
			function validaFecha#Attributes.name#(){
		        var fechaInicio = $('###Attributes.name#').val();
		        var fechaFin = $('###Attributes.nameFechaFin#').val();
		       
		        var fechaInicioComp = new Date(fechaInicio.substring(6,10), fechaInicio.substring(3,5),fechaInicio.substring(0,2));
		        var fechaFinComp = new Date(fechaFin.substring(6,10), fechaFin.substring(3,5),fechaFin.substring(0,2));
		        var fechaBase = new Date('1900', '01','01');
		        var fechaAno2000 = new Date('2000', '01','01');


       			if((fechaInicioComp > fechaBase) && (fechaFinComp > fechaBase)){
					
		            if( fechaFinComp < fechaInicioComp){

		                var largoDia = String(fechaInicioComp.getDate()).length;
		                if(largoDia <2){
		                    var dia = String('0'+fechaInicioComp.getDate()) ;
		                }else{
		                    var dia = fechaInicioComp.getDate() ;
		                }

		                var largoMes = String(fechaInicioComp.getMonth()).length;
		                if(largoMes <2){
		                    var mes = String('0'+fechaInicioComp.getMonth())  ;
		                }else{
		                    var mes = fechaInicioComp.getMonth() ;
		                }
		                 

		                var ano =  fechaInicioComp.getFullYear();

		                $('###Attributes.nameFechaFin#').val(dia+'/'+mes+'/'+ano);
						$('###Attributes.nameFechaFin#').datepicker( 'update',dia+'/'+mes+'/'+ano);
						

		            }
		        }


		    }

	    </cfif>
		
		</script>
	</cfif>
</cfoutput> 
