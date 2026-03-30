<cfparam name="url.TAtarifa" type="numeric">
<cfparam name="url.TAlinea"  type="numeric">
<cfparam name="url.TAdia" default="">
<cfparam name="url.TAhoraDesde" default="">
<cfquery datasource="#session.dsn#" name="data">
	select *
	from  ISBtarifaHorario where TAtarifa =
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TAtarifa#" null="#Len(url.TAtarifa) Is 0#">
	and TAlinea =
		<cfqueryparam cfsqltype="cf_sql_integer" value="#url.TAlinea#" null="#Len(url.TAlinea) Is 0#">
	and TAdia =
		<cfqueryparam cfsqltype="cf_sql_integer" value="#url.TAdia#" null="#Len(url.TAdia) Is 0#">
	and TAhoraDesde =
		<cfqueryparam cfsqltype="cf_sql_time" value="#url.TAhoraDesde#" null="#Len(url.TAhoraDesde) Is 0#">
	</cfquery>

<cfoutput>

<script type="text/javascript">
<!--
	function validarHor(formulario)
	{
		var error_input;
		var error_msg = '';
		// Validando tabla: ISBtarifaHorario - Horario para la tarifa 
				// Columna: TAtarifa Identificador tarifa numeric
				if (formulario.TAtarifa.value == "") {
					error_msg += "\n - Identificador tarifa no puede quedar en blanco.";
					error_input = formulario.TAtarifa;
				}
			
				// Columna: TAlinea Detalle de tarifa int
				if (formulario.TAlinea.value == "") {
					error_msg += "\n - Detalle de tarifa no puede quedar en blanco.";
					error_input = formulario.TAlinea;
				}
			
				// Columna: TAdia Dia (D=1..S=7) tinyint
				if (formulario.TAdia.value == "") {
					error_msg += "\n - Dia (D=1..S=7) no puede quedar en blanco.";
					error_input = formulario.TAdia;
				}
			
				// Columna: TAhoraDesde Hora desde time
				if (formulario.TAhoraDesde.value == "") {
					error_msg += "\n - Hora desde no puede quedar en blanco.";
					error_input = formulario.TAhoraDesde;
				}
			
				// Columna: TAhoraHasta Hora hasta time
				if (formulario.TAhoraHasta.value == "") {
					error_msg += "\n - Hora hasta no puede quedar en blanco.";
					error_input = formulario.TAhoraHasta;
				}
						
		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			if (error_input && error_input.focus) error_input.focus();
			return false;
		}
		return true;
	}
	function funcNuevoHor(){
		location.href = 'ISBtarifa-edit.cfm?TAtarifa=# JSStringFormat( URLEncodedFormat(url.TAtarifa)) #&TAlinea=# JSStringFormat( URLEncodedFormat(url.TAlinea)) #';
		return false;
	}
//-->
</script>

<form action="ISBtarifaHorario-apply.cfm" onsubmit="return validarHor(this);" enctype="multipart/form-data" method="post" name="formDetHorario" id="formDetHorario">
	<input name="TAtarifa" id="TAtarifa" type="hidden" value="#HTMLEditFormat(url.TAtarifa)#"   >
	<input name="TAlinea" id="TAlinea" type="hidden" value="#HTMLEditFormat(url.TAlinea)#" >
	<table summary="Tabla de entrada">
	<tr><td colspan="2" class="subTitulo">
	Horario para la tarifa
	</td></tr>
	
		<tr><td valign="top"><label for="TAdia">Día</label>
		</td><td valign="top">
		<input id="_TAdia" name="_TAdia" type="hidden" value="#HTMLEditFormat(data.TAdia)#">
		<select name="TAdia">
		<cfloop from="1" to="7" index="miDia">
			<option value="#miDia#" <cfif miDia is data.TAdia>selected</cfif>>
			#ListGetAt('Domingo,Lunes,Martes,Miércoles,Jueves,Viernes,Sábado', miDia )#
			</option>
		</cfloop>
		</select>
		
		</td></tr>
		
		<tr><td valign="top"><label for="TAhoraDesde">Hora desde</label>
		</td><td valign="top" nowrap>
		
			<!------<input name="TAhoraDesde" id="TAhoraDesde" type="text" value="#TimeFormat(data.TAhoraDesde,'HH:mm')#" 
				maxlength="8" tabindex="1" size="6"
				onfocus="this.select()"  >---->
			<input id="_TAhoraDesde" name="_TAhoraDesde" type="hidden" value="#TimeFormat(data.TAhoraDesde,'HH:mm')#">
			<cf_inputTime name="TAhoraDesde" form="formDetHorario" value="#TimeFormat(data.TAhoraDesde,'HH:mm')#">
			(inclusive)
		
		</td>
		</tr>
		
		<tr><td valign="top"><label for="TAhoraHasta">Hora hasta</label>
		</td><td valign="top" nowrap>
		
			<!----------<input name="TAhoraHasta" id="TAhoraHasta" type="text" value="#TimeFormat(data.TAhoraHasta,'HH:mm')#" 
				maxlength="8" tabindex="1" size="6"
				onfocus="this.select()"  >----->
			<cf_inputTime name="TAhoraHasta" form="formDetHorario" value="#TimeFormat(data.TAhoraHasta,'HH:mm')#">
			(exclusive)
		
		</td>
		</tr>
		
	<tr><td colspan="2" class="formButtons">
		<cfif data.RecordCount>
			<cf_botones  regresar="ISBtarifaHorario.cfm" modo="CAMBIO" sufijo="Hor">
		<cfelse>
			<cf_botones  regresar="ISBtarifaHorario.cfm" modo="ALTA" sufijo="Hor">
		</cfif>
	</td></tr>
	</table>
	
	
			<input type="hidden" name="BMUsucodigo" value="#HTMLEditFormat(data.BMUsucodigo)#">
		<cfset ts = "">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="#data.ts_rversion#" returnvariable="ts">
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#">
		
</form>

</cfoutput>

