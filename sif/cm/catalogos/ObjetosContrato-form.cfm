<cfset modo = 'ALTA'>
<cfif isdefined("form.OCid") and len(trim(form.OCid))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif modo NEQ 'ALTA'>
	<cfquery name="rsdataObj" datasource="#session.DSN#">
		select OCid, ECid, OCdescripcion, OCarchivo,OCextension, ts_rversion
		from ObjetosContrato
		where OCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCid#">
			and ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#">
	</cfquery>
</cfif>

<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

<cfoutput>
<form enctype="multipart/form-data" action="ObjetosContratos-sql.cfm" method="post" name="form1" onsubmit="javascript:document.form1.dir.value=document.form1.OLPdato.value;" >
	<input type="hidden" name"SNcodigo" value="#form.SNcodigo#">
	<table width="100%" border="0" cellpadding="2" cellspacing="0" align="center" >
		<tr>
			<td align="right" nowrap><strong>Descripci&oacute;n:</strong>&nbsp;</td>
			<td><input type="text" name="OCdescripcion"  value="<cfif modo neq 'ALTA'>#HTMLEditFormat(rsdataObj.OCdescripcion)#</cfif>" size="60" maxlength="100"></td>
		</tr>	

		<tr>
			<td align="right" nowrap><strong>Nombre Archivo:</strong>&nbsp;</td>
			<td><input type="text" name="OCarchivo"  value="<cfif modo neq 'ALTA'>#HTMLEditFormat(rsdataObj.OCarchivo)#</cfif>" size="60" maxlength="100"></td>
		</tr>	

		<tr>
			<td align="right" nowrap><strong>Archivo:</strong>&nbsp;</td>
			<td>
				<input type="file" name="OLPdato" value="" onblur="javascript:document.form1.nArchivo.value=this.value;">
				<input type="hidden" name="nArchivo" value="">
			</td>
		</tr>
		
		<tr><td colspan="2" nowrap>&nbsp;</td></tr>
						  
		<tr>
			<td colspan="2" align="center">
				<cfif modo EQ "ALTA">
					<input type="submit" name="Alta" value="Agregar"  >
					<input type="reset" name="Limpiar" value="Limpiar" >
				<cfelse>	
				<input type="submit" name="Cambio" value="Modificar" >					
                <input type="submit" name="Baja" value="Eliminar" onclick="javascript:return confirm('¿Desea Eliminar el Registro?');">
				<input type="submit" name="Nuevo" value="Nuevo" onClick="javascript:deshabilitarValidacion();" >			
				</cfif>
				<input name="Regresar" type="button" value="Regresar" onClick="javascript:contratos('#form.ECid#');">		  </td>
		</tr>	
	
		<cfif modo neq "ALTA">
			<cfset ts = "">
			<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsdataObj.ts_rversion#" returnvariable="ts">
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#">
			<input type="hidden" name="OCid" value="#rsdataObj.OCid#">
		</cfif>

		<input type="hidden" name="ECid" value="#form.ECid#">
		
	</table>
	
</form>
</cfoutput>

<script type="text/javascript" language="JavaScript1.2" >
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	
	objForm.OCdescripcion.required = true;
	objForm.OCdescripcion.description="Descripción";
	
	objForm.OCarchivo.required = true;
	objForm.OCarchivo.description="Nombre del Archivo";
	
	<cfif modo EQ 'ALTA'> 
		objForm.OLPdato.required = true;
		objForm.OLPdato.description="Archivo";
	</cfif>
	
	function deshabilitarValidacion(){
		objForm.OCdescripcion.required = false;
		objForm.OCarchivo.required = false;
		objForm.OLPdato.required = false;
	}

	function contratos(data) {
		if (data!="") {
			document.form1.modo='CAMBIO';		
			document.form1.action='contratos.cfm';
			document.form1.submit();
		}
		return false;
	}
</script>
