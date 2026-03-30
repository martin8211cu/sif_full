<cfoutput>
<cfif modo neq 'ALTA' and isdefined('GECIid') and len(trim('GECIid'))>
	<cfquery name="rsSelectDatos" datasource="#session.dsn#">
		select 	GECIid, GECid, GECIorigen, GECIdestino, GECIhotel, GECIfsalida,GECIhinicio,
                GECIhfinal, GECIlineaAerea, GECInumeroVuelo, ts_rversion  
            from GECitinerario  
                where GECIid  = #GECIid# 	
	</cfquery>	
    <cfset GECIfsalida=rsSelectDatos.GECIfsalida>
	<cfset GECIhinicio=rsSelectDatos.GECIhinicio>
	<cfset GECIhfinal=rsSelectDatos.GECIhfinal>	
    <cfset ts_rversion=rsSelectDatos.ts_rversion>
<cfelse>
	<cfset GECIfsalida="">
	<cfset GECIhinicio="0">
	<cfset GECIhfinal="0">	
</cfif>

<cfform action="catalogoItinerarioComision-SQL.cfm" method="post" name="form1" onSubmit="return validar(this);">
	<table align="center">
		<tr> 
			<td align="right" nowrap>Ciudad Origen:&nbsp;</td>
			<td>
				<input name="GECIorigen" type="text" value="<cfif modo neq "ALTA" >#trim(rsSelectDatos.GECIorigen)#</cfif>" size="10" maxlength="10"  alt="Ciudad Origen" onFocus="this.select();"> 
			</td>
		</tr>
		<tr> 
			<td align="right" nowrap>Ciudad Destino:&nbsp;</td>
			<td>
				<input name="GECIdestino" type="text"  value="<cfif modo neq "ALTA">#rsSelectDatos.GECIdestino#</cfif>" size="10" maxlength="10" onFocus="this.select();"  alt="Ciudad Destino">
			</td>
		</tr>
		<tr> 
			<td align="right" nowrap>Hotel:&nbsp;</td>
			<td>
				<input name="GECIhotel" type="text"  value="<cfif modo neq "ALTA">#rsSelectDatos.GECIhotel#</cfif>" size="20" maxlength="20" onFocus="this.select();"  alt="Hotel">
			</td>
		</tr>
        <tr>
			<td nowrap align="right">Fecha de Salida:&nbsp;&nbsp;</td>
			<td colspan="5"><cf_sifcalendario name="GECIfsalida" tabindex="1" value="#LSDateFormat(GECIfsalida,'dd/mm/yyyy')#"></td>
		</tr>
        <tr> 
      		<td nowrap align="right">Hora Inicio:</td>
      		<td>
				<cf_hora name="GECIhinicio" form="form1" value="#GECIhinicio#">
			</td>
	    </tr>
		<tr> 
      		<td nowrap align="right">Hora Fin:</td>
			<td>
				<cf_hora name="GECIhfinal" form="form1" value="#GECIhfinal#">
			</td>
		</tr>
        
		<tr> 
			<td align="right" nowrap>Linea Aerea:&nbsp;</td>
			<td>
				<input name="GECIlineaAerea" type="text"  value="<cfif modo neq "ALTA">#rsSelectDatos.GECIlineaAerea#</cfif>" size="20" maxlength="20" onFocus="this.select();"  alt="Linea Aerea">
			</td>
		</tr>
		<tr> 
			<td align="right" nowrap>Numero de vuelo:&nbsp;</td>
			<td>
				<input name="GECInumeroVuelo" type="text"  value="<cfif modo neq "ALTA">#rsSelectDatos.GECInumeroVuelo#</cfif>" size="5" maxlength="20" onFocus="this.select();"  alt="Numero de vuelo">
			</td>
		</tr>
        
		<tr valign="baseline"> 
			<td colspan="2" align="right" nowrap > 
				<!---<cfset Lvar_botones = 'ImportarI'>
				<cfset Lvar_botonesV = 'Importar Plantilla Viático'>	--->
				
				<cf_botones modo="#modo#" tabindex="1" ><!---include="#Lvar_botones#" includevalues="#Lvar_botonesV#"--->
			</td>
		</tr>
		
		<tr> 
      	<td colspan="2">
				<input type="hidden" name="modo" value="#modo#" />
				<input type="hidden" name="BMUsucodigo" value="#session.usucodigo#" />
				<input type="hidden" name="Ecodigo" value="#session.Ecodigo#" />
				<input type="hidden" name="GECid" value="#form.GECid#" />
                
					<cfif modo neq "ALTA">
			<input type="hidden" id="GECIid" name="GECIid" value="#rsSelectDatos.GECIid#" />
				<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#ts_rversion#" returnvariable="ts">
					</cfinvoke>
				</cfif>
			<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>">
			</td>
    	</tr>
  	</table>
</cfform>

<cf_qforms form="form1">
<script language="javascript1" type="text/javascript">
		<!---objForm.GECIorigen.description = "Ciudad Origen";
		objForm.GECIdestino.description = "Ciudad Destino";
		objForm.GECIhotel.description = "Hotel";
		objForm.GECIfsalida.description = "Fecha de Salida";
		objForm.GECIhinicio.description = "Hora Inicio";
		objForm.GECIhfinal.description = "Hora Fin";
		objForm.GECIlineaAerea.description = "Linea Aerea";
		objForm.GECInumeroVuelo.description = "Numero de vuelo";--->


		<!---objForm.GECIorigen.required = true;
		objForm.GECIdestino.required = true;
		objForm.GECIhotel.required = true;
		objForm.GECIfsalida.required = true;
		objForm.GECIhinicio.required = true;
		objForm.GECIhfinal.required = true;
		objForm.GECIlineaAerea.required = true;
		objForm.GECInumeroVuelo.required = true;--->
		
	function fnFechaYYYYMMDD (LvarFecha)
	{
		return LvarFecha.substr(6,4)+LvarFecha.substr(3,2)+LvarFecha.substr(0,2);
	}
	
	function validar(form1){
		if (!btnSelected('Nuevo',document.form1) && !btnSelected('Baja',document.form1) && !btnSelected('IrLista',document.form1)){
			var error_input;
			var error_msg = '';
	
		<!---if (fnFechaYYYYMMDD(document.form1.GEPVfechaini.value) > fnFechaYYYYMMDD(document.form1.GEPVfechafin.value))
		{
			alert ("La Fecha de Inicio debe ser menor a la Fecha Final");
			return false;
		}--->

	// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
	}
}   

	function deshabilitarValidacion() {
		<!---objForm.GECIorigen.required = false;
		objForm.GECIdestino.required = false;
		objForm.GECIhotel.required = false;
		objForm.GECIfsalida.required = false;
		objForm.GECIhinicio.required = false;
		objForm.GECIhfinal.required = false;
		objForm.GECIlineaAerea.required = false;
		objForm.GECInumeroVuelo.required = false;--->
	}

 
</script>
</cfoutput>
