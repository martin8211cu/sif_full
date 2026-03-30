<script language="javascript1.2" type="text/javascript">
	// ===========================================================================================
	//								Conlis de Procesos
	// ===========================================================================================
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height){
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlis() {
		popUpWindow("ConlisProcesos.cfm?SScodigo="+document.form1.SScodigo.value+"&SRcodigo="+document.form1.SRcodigo.value,250,350,650,350);
	}
	// ===========================================================================================
</script>

<!--- Modo --->
<cfif isdefined("form.SPcodigo") and len(trim(form.SPcodigo)) gt 0>
	<cfset modo = 'CAMBIO'>
<cfelse>
	<cfset modo = 'ALTA'>
</cfif>

<cfquery name="rsRoles" datasource="asp">
	select SRcodigo, SRdescripcion
	from SRoles
	where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">
	  and SRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SRcodigo#">
	order by SRcodigo, SRdescripcion
</cfquery>

<cfif modo neq 'ALTA'>
	<cfquery name="rsForm" datasource="asp">
		select a.SRcodigo, a.SScodigo, a.SMcodigo, a.SPcodigo, b.SPdescripcion
		from SProcesosRol a, SProcesos b
		where a.SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">
		  and a.SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SMcodigo#">
		  and a.SPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SPcodigo#">
		  and a.SRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SRcodigo#">
		  and a.SScodigo=b.SScodigo
		  and a.SMcodigo=b.SMcodigo
		  and a.SPcodigo=b.SPcodigo
		order by a.SRcodigo, a.SScodigo, a.SMcodigo, a.SPcodigo, b.SPdescripcion
	</cfquery>
</cfif>

<SCRIPT src="/cfmx/sif/js/utilesMonto.js"></SCRIPT>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script type="text/javascript" language="javascript1.2">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script>

<cfoutput>
<form name="form1" method="post" action="procesos-rol-sql.cfm">
	<cfif isdefined("form.fSScodigo") and len(trim(form.fSScodigo)) gt 0><input type="hidden" name="fSScodigo" value="#form.fSScodigo#"></cfif>
	<cfif isdefined("form.fSMcodigo") and len(trim(form.fSMcodigo)) gt 0><input type="hidden" name="fSMcodigo" value="#form.fSMcodigo#"></cfif>
	<cfif isdefined("form.fProceso") and len(trim(form.fProceso)) gt 0><input type="hidden" name="fProceso" value="#form.fProceso#"></cfif>
	
	<table width="100%" cellpadding="0" cellspacing="0" border="0">

		<!--- Rol --->
		<tr>
			<td align="right" class="etiquetaCampo">Grupo:&nbsp;</td>
			<td align="left"><b>#rsRoles.SRcodigo# - #rsRoles.SRdescripcion#<b/>
				<input name="SRcodigo" type="hidden" value="#form.SRcodigo#">
				<input name="SScodigo" type="hidden" value="#form.SScodigo#">
			</td>
		</tr>

		<!--- Proceso --->
		<tr>
			<td align="right" class="etiquetaCampo" nowrap>Proceso:&nbsp;</td>
			<td align="left" nowrap>
				<input type="hidden" name="SMcodigo" value="<cfif modo neq 'ALTA'>#form.SMcodigo#</cfif>">
				<input type="hidden" name="SPcodigo" value="<cfif modo neq 'ALTA'>#form.SPcodigo#</cfif>">

				<!--- par apoder cambiar el proceso, que es llave, guardo la llave anterior--->
				<input type="hidden" name="SMcodigo2" value="<cfif modo neq 'ALTA'>#form.SMcodigo#</cfif>">
				<input type="hidden" name="SPcodigo2" value="<cfif modo neq 'ALTA'>#form.SPcodigo#</cfif>">

				<input type="text" name="SPproceso" readonly size="55" maxlength="255" onFocus="this.select();" value="<cfif modo neq 'ALTA'>#rsForm.SPdescripcion#</cfif>" >
				<a href="##">
					<img src="../../imagenes/home.gif" alt="Lista de Procesos" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlis();">
				</a> 
			</td>
		</tr>

		<!--- Botones --->
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="2" align="center">
				<cfif modo neq 'ALTA'>
					<input type="submit" name="Eliminar" value="Eliminar" onClick="deshabilitarValidacion();">
					<input type="submit" name="Nuevo" value="Nuevo" onClick="deshabilitarValidacion()">
				<cfelse>
					<input type="submit" name="Agregar" value="Agregar">
				</cfif>
				<input type="submit" name="btnRoles" value="Grupos" onClick="javascript:deshabilitarValidacion();">
			</td>
		</tr>

	</table>
	
</form> 
</cfoutput>

<script language="javascript1.2" type="text/javascript">
	// ****************************************
	//              QForms  
	// ****************************************
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	<cfif modo eq 'ALTA'>
		objForm.SPproceso.required = true;
		objForm.SPproceso.description = "Proceso";


/*
		objForm.SScodigo.required = true;
		objForm.SScodigo.description = "Sistema";
	
		objForm.SMcodigo.required = true;
		objForm.SMcodigo.description = "Módulo";
	
		objForm.SPcodigo.required = true;
		objForm.SPcodigo.description = "Código";
	*/
	</cfif>	

	function deshabilitarValidacion() {
		objForm.SPproceso.required = false;

/*
		objForm.SScodigo.required = false;
		objForm.SMcodigo.required = false;
		objForm.SPcodigo.required = false;
*/		
	}
</script>