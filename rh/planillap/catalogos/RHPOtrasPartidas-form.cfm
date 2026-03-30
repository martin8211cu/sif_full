<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>
<cfset modo = "ALTA">
<cfif isdefined("url.RHPOPid") and len(trim(url.RHPOPid))>
	<cfset form.RHPOPid = url.RHPOPid>
</cfif>
<cfif isdefined("form.RHPOPid") and len(trim(form.RHPOPid))>
	<cfset modo = "CAMBIO">
</cfif>

<cfif modo neq 'ALTA'>
	<cfquery datasource="#session.dsn#" name="data">
		select 	a.RHPOPid, a.CPPid, a.CPformato, a.CPdescripcion, a.ts_rversion, a.RHPOPdistribucionCF
		from  RHPOtrasPartidas a
		where  a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.RHPOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPOPid#"> 
	</cfquery>	
</cfif>

<cfoutput>
<form action="RHOtrasPartidas-sql.cfm"  method="post" name="form1" id="form1">
	<table width="100%" cellpadding="0" cellspacing="0">		
		<tr>
			<td align="right" nowrap="nowrap"><strong>Per&iacute;odo Presupuestario:&nbsp;</strong></td>	
			<td colspan="3">
				<cf_cboCPPid form="form1" tabindex="1">
			</td>
		</tr>
        <tr>
			<td align="right"><strong>Distribuir por C. Funcional:&nbsp;</strong></td>
			<td>
				<input name="RHPOPdistribucionCF" id="RHPOPdistribucionCF" type="checkbox" tabindex="2" onclick="fnCambiarDistribucion(this.checked)" <cfif isdefined('data') and data.RHPOPdistribucionCF>checked</cfif>>
			</td>
		</tr>
		<tr>
			<td align="right"><div id="divDistribucion" style="font-weight:bold">Objeto de Gasto:&nbsp;</div></td>
			<td>
				<input name="CPformato" size="40" id="CPformato" type="text" value="<cfif modo NEQ 'ALTA'>#trim(data.CPformato)#</cfif>" maxlength="80" onfocus="this.select()" tabindex="2">
			</td>
		</tr>
		<tr>
			<td align="right"><strong>Descripci&oacute;n:&nbsp;</strong></td>
			<td>
				<input name="CPdescripcion" size="40" id="CPdescripcion" type="text" value="<cfif modo NEQ 'ALTA'>#trim(data.CPdescripcion)#</cfif>" maxlength="80" onfocus="this.select()" tabindex="2">
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="2" class="formButtons" align="center">
				<cfif modo eq 'ALTA'>
					<input type="submit" name="Alta" value="Agregar" onClick="javascript: habilitarValidacion();">
					<input type="reset" name="Limpiar" value="Limpiar">
				<cfelse>
					<input type="submit" name="Cambio" value="Modificar" onClick="habilitarValidacion();">
					<input type="submit" name="Baja" value="Eliminar" onClick="if (confirm('Desea eliminar el registro?') ){deshabilitarValidacion(); return true;} return false;">
					<input type="submit" name="Nuevo" value="Nuevo" onClick="deshabilitarValidacion();">
				</cfif>
			</td>
		</tr>
	</table>
	<cfif modo neq 'ALTA'>
		<input type="hidden" name="RHPOPid" value="#data.RHPOPid#">
		<cfset ts = "">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
				artimestamp="#data.ts_rversion#" returnvariable="ts">
			</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
	</cfif>
</form>
</cfoutput>
<script language="JavaScript" type="text/javascript">	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.CPPid.description="Cuenta de Presupuesto";		
	objForm.CPPid.required = true;
	objForm.CPformato.description="Formato";	
	objForm.CPformato.required = true;			
	objForm.CPdescripcion.description="Descripci&oacute;n";	
	objForm.CPdescripcion.required = true;	
		
	function habilitarValidacion(){
		objForm.CPPid.required = true;
		objForm.CPformato.required = true;
		objForm.CPdescripcion.required = true;
	}

	function deshabilitarValidacion(){
		objForm.CPPid.required = false;
		objForm.CPformato.required = false;
		objForm.CPdescripcion.required = false;
	}
	
	function fnCambiarDistribucion(v){
		document.getElementById("divDistribucion").innerHTML = ( v ? "Objeto de Gasto:&nbsp;" : "Cuenta:&nbsp;")
	}
	fnCambiarDistribucion(document.form1.RHPOPdistribucionCF.checked)
</script>


