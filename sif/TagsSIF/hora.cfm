<!--- 
Modificado por Carlos Masís Peralta
Fecha 07/08/2014
Se actualiza con las funcionalidades del Bootstrap Timepicker
--->

<!---
<script language="JavaScript" src="/cfmx/sif/js/utilesMonto.js"></script>
--->
<cfif not isDefined("request.time")>
	<cfsavecontent variable="Timepicker">
	    <script src="/cfmx/commons/js/bootstrap-timepicker.min.js"></script>
		<link href="/cfmx/commons/css/bootstrap-responsive.css" rel="stylesheet" type="text/css" />
		<link href="/cfmx/commons/css/bootstrap-timepicker.min.css" rel="stylesheet" type="text/css" />
	</cfsavecontent>

	<cfhtmlhead text = #Timepicker# >
	<cfset request.time = 1>

</cfif>

<cfset def = QueryNew('hora')>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" 	default="#Session.DSN#" type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 		default="form1" 		type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.query" 		default="#def#" 		type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.name" 		default="hora" 			type="string"> <!--- Nombre del campo de la hora --->
<cfparam name="Attributes.value" 		default="" 				type="string"> <!--- valor por defecto --->
<cfparam name="Attributes.tabindex" 	default="" 				type="string"> <!--- número del tabindex --->
<cfparam name="Attributes.onBlur" 		default="" 				type="string"> <!--- función en el evento onBlur --->
<cfparam name="Attributes.onChange" 	default="" 				type="string"> <!--- función en el evento onChange --->
<cfparam name="Attributes.formato" 		default="####:####" 	type="string"> <!--- función en el evento onBlur --->
<cfparam name="Attributes.valign" 		default="baseline" 		type="string"> <!--- valign--->
<cfparam name="Attributes.image" 		default="true" 			type="boolean"> <!--- Visualizar el image del calendario --->
<cfparam name="Attributes.style" 		default="" 				type="string">
<cfparam name="Attributes.enterAction" 	default="" 				type="string">
<cfparam name="Attributes.readOnly" 	default="false" 		type="boolean">
<cfparam name="Attributes.class" 		default=""				type="string"><!--- propiedad class ---->
<cfparam name="Attributes.obligatorio"  default="0"				type="string"><!--- el campo es obligatorio dentro del formulario (integracion parsley)--->

<cfparam name="Request.jsMask" default="false">

<cfif Request.jsMask EQ false>
	<cfset Request.jsMask = true>
	<script language="JavaScript" src="/cfmx/sif/js/calendar.js"></script>
	<script src="/cfmx/sif/js/MaskApi/masks.js"></script>
	<cfif NOT isdefined("request.scriptOnEnterKeyDefinition")><cf_onEnterKey></cfif>
</cfif>
<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
	<cfset LvarMinutos = Evaluate('#obj#')>
<cfelse>
	<cfset LvarMinutos = Attributes.value>
</cfif>
<cfif LvarMinutos EQ "">
	<cfset LvarHHMM = "">
<cfelse>
	<cfset LvarHHMM = int(LvarMinutos / 60)>
	<cfset LvarHHMM = "#numberFormat(LvarHHMM,"00")#:#numberFormat(LvarMinutos - LvarHHMM*60,"00")#">
</cfif>
<cfoutput>
<table width="" border="0" cellspacing="0" cellpadding="0">
	<tr valign="#Attributes.valign#"> 
      <td nowrap valign="#Attributes.valign#">
	  	<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
		  	<cfset obj = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.name')#')#')">
		</cfif>
		<input type="hidden"
			name="#Attributes.name#" id="#Attributes.name#" value="#LvarMinutos#"
		>
		<!--- Se agrega el nuevo input para la hora --->
		<div class="input-append bootstrap-timepicker">
            <input title="#Attributes.formato#" size="5" maxlength="5"
            name="#Attributes.name#_HHMM" id="#Attributes.name#_HHMM" value="#LvarHHMM#" type="text" class="input-small"
            <cfif Attributes.readOnly>
				tabindex="-1"
				disabled="true"
				style="border:solid 1px ##CCCCCC; background:inherit;"
			<cfelseif Len(Trim(Attributes.tabindex)) GT 0 >
				tabindex="#Attributes.tabindex#" 
			</cfif>
			<cfif Len(Attributes.style)>style="#Attributes.style#"</cfif> 
			<cfif Len(Trim(Attributes.class)) GT 0>class="#Attributes.class#"</cfif> <!--- Class, podemos utilizarla para buscar el componente por jquery --->
			obligatorio="#Attributes.obligatorio#"		<!--- Indica que es obligatorio dentro del formulario, validaciones con parsley --->

            >

            <cfif Attributes.image and not Attributes.readOnly>
            	<span class="add-on fa fa-clock-o fa-lg"></span>
            </cfif>
        </div>

        

		<!--- <input type="text" title="#Attributes.formato#" size="4" maxlength="5"
			name="#Attributes.name#_HHMM" id="#Attributes.name#_HHMM" value="#LvarHHMM#"
			<cfif Attributes.readOnly>
				tabindex="-1"
				readonly
				style="border:solid 1px ##CCCCCC; background:inherit;"
			<cfelseif Len(Trim(Attributes.tabindex)) GT 0 >
				tabindex="#Attributes.tabindex#" 
			</cfif>
			<cfif Len(Attributes.style)>style="#Attributes.style#"</cfif> 
			<cfif Len(Trim(Attributes.class)) GT 0>class="#Attributes.class#"</cfif> <!--- Class, podemos utilizarla para buscar el componente por jquery --->
			obligatorio="#Attributes.obligatorio#"		<!--- Indica que es obligatorio dentro del formulario, validaciones con parsley --->
		>
			<cfif Attributes.image and not Attributes.readOnly>
				<a href="javascript:void(0)" tabindex="-1" id="img_#Attributes.form#_#Attributes.name#"> 	
					<img src="/cfmx/sif/imagenes/clock.jpg" alt="Relo" name="Relo#Attributes.name#" width="18" 
						height="18" border="0" 
						onClick="javascript: document.#Attributes.form#.#Attributes.name#_HHMM.focus(); sbPopup_#Attributes.name#_HHMM();"></a>
			</cfif> --->
		</td>
	</tr>
</table>
<script language="JavaScript1.2">
<!---	oDateMask = new Mask("####:####", "string");
	oDateMask.attach(document.#Attributes.form#.#Attributes.name#_HHMM,"####:####", "string", "fnValidate_#Attributes.name#_HHMM()", "", "", "", "");
--->
	function fnValidate_#Attributes.name#_HHMM()
	{
		var mm = document.#Attributes.form#.#Attributes.name#;
		var hh = document.#Attributes.form#.#Attributes.name#_HHMM;
		mm.value = "";
		if (hh.value == "")
			return "";
		
	<!---	if (hh.value.length != 5 || hh.value.substring(0,2) > "23" || hh.value.substr(3,2) > "59")
		{
			alert("Hora incorrecta");
			hh.focus();
			hh.select();
			return "";
		} --->

		if(hh.value.length == 5)
		{
			mm.value = new Number (hh.value.substring(0,2))*60 + new Number (hh.value.substr(3,2));
			<cfif IsDefined('Attributes.onChange')>#Attributes.onChange#;</cfif>
		}
		else
		{
			mm.value = new Number (hh.value.substring(0,1))*60 + new Number (hh.value.substr(2,2));
			<cfif IsDefined('Attributes.onChange')>#Attributes.onChange#;</cfif>
		}

		
		return mm.value;
	}

	function set#Attributes.name#_HHMM(minutos)
	{
		var mm = document.#Attributes.form#.#Attributes.name#;
		var hh = document.#Attributes.form#.#Attributes.name#_HHMM;
		mm.value = "";
		hh.value = "";
		minutos = parseInt(minutos);
		var LvarHH = parseInt(minutos / 60);
		var LvarMM = minutos - LvarHH*60;

		mm.value = minutos;
		if (LvarHH > 23 || LvarMM > 59)		return;
		if (LvarHH < 10)					LvarHH = "0" + LvarHH + "";
		if (LvarMM < 10)					LvarMM = "0" + LvarMM + "";
		hh.value = LvarHH + ":" + LvarMM;
		
		<cfif IsDefined('Attributes.onChange')>#Attributes.onChange#;</cfif>
	}

	var popup_#Attributes.name#_HHMM = false;
	function sbPopup_#Attributes.name#_HHMM()
	{
		if(popup_#Attributes.name#_HHMM)
		{
			if(!popup_#Attributes.name#_HHMM.closed) popup_#Attributes.name#_HHMM.close();
		}
		popup_#Attributes.name#_HHMM = open
			("/cfmx/sif/Utiles/hora.cfm?Hora=#Attributes.name#", '#Attributes.name#_HHMM', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width=230,height=510');
	}
</script>
<script type="text/javascript">
    $('###Attributes.name#_HHMM').timepicker({
        minuteStep: 15,
        template: 'dropdown',
        showSeconds: false,
        showMeridian: false
    });

    <!--- Acá se deben agregar las funciones que se ejecutan cuando el control de la hora se actualiza (onChange) --->
	$('###Attributes.name#_HHMM').timepicker().on('changeTime.timepicker', function(e) {
	    fnValidate_#Attributes.name#_HHMM();
	});
</script>	  
</cfoutput>