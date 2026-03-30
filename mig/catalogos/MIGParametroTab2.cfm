<cfset fechaini = DateFormat(Now(),'mm/dd/yyyy')>
<cfset fechafin = DateFormat(Now(),'mm/dd/yyyy')>

<cfif isdefined ('form.MIGParid')>
	<cfquery datasource="#Session.DSN#" name="rsEncPar">
		select 
				MIGParid,
				MIGParcodigo,
				MIGPardescripcion,
				MIGPartipo,
				MIGParsubtipo,
				case MIGParactual
					when 'S' then 'Sí'
					when 'N' then 'No'
				end as MIGParactual,
				case Dactiva
					when  0 then 'Inactivo'
					when  1 then 'Activo'
				else 'Dactiva desconocido'
				end as Dactiva
		from MIGParametros
		where MIGParid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MIGParid#">
	</cfquery>
</cfif> 

<cfoutput>
	
		<table cellpadding="0" cellspacing="" border="0" width="100%">
			<tr><td align="center" style=" height:20; background-color:F3F3F3; color:666666">
						<strong>Par&aacute;metro #htmlEditFormat(rsEncPar.MIGParcodigo)# - #htmlEditFormat(rsEncPar.MIGPardescripcion)# </strong>
			</td></tr>
		</table>

		<table width="50%" border="0" align="left">
				<tr>
					<td align="left">
						<cfinvoke component="commons.Componentes.pListas" method="pListaRH"
							tabla="MIGParametrosdet a
									inner join MIGParametros b
										    on a.MIGParid = b.MIGParid
										   and a.Ecodigo  = b.Ecodigo"
							columnas="a.MIGPardetid,a.Pfechainicial,a.Pfechafinal,a.Valorcalificacion,a.Peso,b.MIGParid"
							desplegar="Pfechainicial, Pfechafinal, Valorcalificacion"
							etiquetas="Fecha Inicial, Fecha Final, Calificaci&oacute;n"
							formatos="D,D,S"
							filtro="a.MIGParid=#form.MIGParid# and a.Ecodigo=#session.Ecodigo# Order By a.Pfechainicial, a.Pfechafinal"
							align="left,left,left"
							checkboxes="N"
							keys="MIGPardetid"
							filtrar_automatico="true"
							mostrar_filtro="true"
							MaxRows="15"
							pageindex="65"
							ira="MIGParametro.cfm?Tab=2&MIGParid=#form.MIGParid#"
							filtrar_por="Pfechainicial, Pfechafinal, &nbsp;, &nbsp;"
							showEmptyListMsg="true">
					</td>
				</tr>
		</table>
		
		<form name="form3" method="post" action="MIGParametroSQL.cfm" onSubmit="return validaDet(this);">
		<cfset LvarIniciales=false>
		<cfset LvarFecini="">
		<cfset LvarFecfin="">
		
		<cfif not isdefined ('form.MIGPardetid')>
			<cfset mododet='ALTA'>
		<cfelse>
			<cfset mododet='CAMBIO'>
		</cfif>
		<cfif isdefined ('URL.MIGPardetid')>
			<cfset mododet='CAMBIO'>
			<cfset form.MIGPardetid=url.MIGPardetid>
		</cfif>
		
		<cfif mododet EQ "CAMBIO" >
			<cfquery datasource="#Session.DSN#" name="rsCalifPar">
					select 
								MIGPardetid,
								MIGParid,
								Pfechainicial,
								Pfechafinal,
								Valorcalificacion,
								Peso
					from MIGParametrosdet		
					where MIGPardetid= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MIGPardetid#">
			</cfquery>
			<input type="hidden" name="MIGPardetid" id="MIGPardetid" value="#rsCalifPar.MIGPardetid#">
			<cfset LvarFecini=rsCalifPar.Pfechainicial>
			<cfset LvarFecfin=rsCalifPar.Pfechafinal>
			<cfset LvarIniciales=true>
		</cfif>
		<input type="hidden" name="MIGParid" id="MIGParid" value="#form.MIGParid#">
		<input type="hidden" name="MIGParcodigo" id="MIGParcodigo" value="#rsEncPar.MIGParcodigo#" />
			<table  width="50%" border="0" align="right">
					<tr>
						<td align="right">Fecha Inicio:&nbsp;</td>
					  	<td colspan="2" valign="top">
					   		<cfset fechaini = LSDateFormat(Now(),'dd/mm/yyyy')>
							<cfif mododet NEQ 'ALTA'>
								<cfset fechaini = DateFormat(rsCalifPar.Pfechainicial,'dd/mm/yyyy') >
							</cfif>
							<cf_sifcalendario form="form3" value="#fechaini#" name="Pfechainicial" tabindex="1">
						</td>
					</tr>
					<tr>
						<td align="right">Fecha Final:&nbsp;</td>
					  	<td colspan="2" valign="top">
					  		<cfset fechafin = LSDateFormat(Now(),'dd/mm/yyyy')>
							<cfif mododet NEQ 'ALTA'>
								<cfset fechafin = LSDateFormat(rsCalifPar.Pfechafinal,'dd/mm/yyyy') >
							</cfif>
							<cf_sifcalendario form="form3" value="#fechafin#" name="Pfechafinal" tabindex="1">
						</td>
					</tr>
			
					<tr>
						<td nowrap align="right">Calificaci&oacute;n (%):</td>
						<td align="left">
							<cfif mododet NEQ 'ALTA'>
								<cf_inputNumber name="Valorcalificacion"  value="#rsCalifPar.Valorcalificacion#" enteros="14" decimales="0" negativos="false" comas="no">
							<cfelse>
								<cf_inputNumber name="Valorcalificacion"  value="" enteros="14" decimales="0" negativos="false" comas="no">
							</cfif>
						</td>
					</tr>
					<tr>
						<td nowrap align="right">Peso:</td>
						<td align="left">
							<cfif mododet NEQ 'ALTA'>
								<cf_inputNumber name="Peso"  value="#rsCalifPar.Peso#" enteros="14" decimales="0" negativos="false" comas="no">
							<cfelse>
								<cf_inputNumber name="Peso"  value="" enteros="14" decimales="0" negativos="false" comas="no">
							</cfif>
						</td>
					</tr>
					<tr>
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td align="center" ><cf_botones sufijo='Det' modo='#mododet#'  tabindex="2">
					</tr>
			</table>
		</form>
</cfoutput>

<script language="JavaScript1.2" type="text/javascript">
	var nuevo=0;
	var validar = true;
	function funcOpen(id) {
			var width = 750;
			var height = 450;
			var top = (screen.height - height) / 2;
			var left = (screen.width - width) / 2;
			<cfoutput>
			nuevo = window.open('formDepartamentos.cfm?bandera=1&mododet=ALTA&MIGParid=#form.MIGParid#','Caracteristicas','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
			</cfoutput>
			nuevo.focus();
			window.onfocus = closePopUp;
			return false;	
		}
		
		function closePopUp(){
			if(nuevo) {
				if(!nuevo.closed) nuevo.close();
				nuevo=null;
				document.form3.submit();
		  	}
		}
</script>

<script type="text/javascript">
	var validar = true;
	function deshabilitarValidacion()
	{
		validar = false;
	}
	function fnFechaYMD(fechaDMY)	{
		return (fechaDMY.substr(6,4) + fechaDMY.substr(3,2) + fechaDMY.substr(0,2));
	}
	function validaDet(formulario)	{
			var error_input;
			var error_msg = '';
	
			if (!validar)
				return true;
	
		<!---  
			<cfdump var="#form#">
			<cf_dump var="#URL#">
		--->
		
		if (form3.Pfechainicial.value == form3.Pfechafinal.value) {
			error_msg += "\n - La fecha inicial debe ser diferente a la fecha final";
			error_input = formulario.Pfechainicial;
		}

		if (fnFechaYMD(formulario.Pfechainicial.value) >= fnFechaYMD(formulario.Pfechafinal.value)) {
			error_msg += "\n - La fecha final debe ser mayor a la fecha inicial.";
			error_input = formulario.Pfechainicial;
		}

		Calif = form3.Valorcalificacion.value;
		Calif = Calif.replace(/(^\s*)|(\s*$)/g,"");
		if (Calif.length==0){
			error_msg += "\n - Se debe digitar la calificación.";
			error_input = formulario.Valorcalificacion;
		}
		if (form3.Pfechainicial.value == "") {
			error_msg += "\n - La fecha inicial no puede quedar en blanco.";
			error_input = formulario.Pfechainicial;
		}
		if (form3.Pfechafinal.value == "") {
			error_msg += "\n - La fecha final no puede quedar en blanco.";
			error_input = formulario.Pfechafinal;
		}

		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
	}
</script>