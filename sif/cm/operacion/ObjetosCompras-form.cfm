<cfset modo = 'ALTA'>
<cfif isdefined("form.CMNDAid") and len(trim(form.CMNDAid))>
	<cfset modo = 'CAMBIO'>
</cfif>
	<cfif isdefined ('form.CMNid') and len(rtrim(#form.CMNid#))>
		<cfset NotaId = #form.CMNid#>
	<cfelseif isdefined ('url.NotaId') and len(rtrim(#url.NotaId#))>
		 <cfset NotaId = #url.NotaId#>
	</cfif>

<cfif modo NEQ 'ALTA'>
	<cfquery name="rsdataObj" datasource="#session.DSN#">
		select CMNid, CMNDAid, CMNDAnombre, CMNDAextension, CMNDAdocumento, Usucodigo, CMNDAfechaAlta, BMUsucodigo, ts_rversion
		from CMNDocumentoAdjunto
		where CMNDAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMNDAid#">
			and CMNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#NotaId#">
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

<form enctype="multipart/form-data" action="ObjetosCompras-sql.cfm?CMNid=#NotaId#" method="post" name="form1" onsubmit="javascript:document.form1.dir.value=document.form1.CMNDAdocumento.value;" >
	<table width="100%" border="0" cellpadding="2" cellspacing="0" align="center" >		
		<tr>
			<td align="right" nowrap><strong>Nombre Archivo:</strong>&nbsp;</td>
			<td><input type="text" name="CMNDAnombre"  value="<cfif modo neq 'ALTA'>#HTMLEditFormat(rsdataObj.CMNDAnombre)#</cfif>" size="60" maxlength="100"></td>
		</tr>	

		<tr>
			<td align="right" nowrap><strong>Archivo:</strong>&nbsp;</td>
			<td>
				<input type="file" name="CMNDAdocumento" value=""  onChange="javascript:extraeNombre(this.value);">
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
				<input name="Regresar" type="button" value="Regresar" onClick="javascript:contratos('#NotaId#');">		 
			</td>
		</tr>	
	
		<cfif modo neq "ALTA">
			<cfset ts = "">
			<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsdataObj.ts_rversion#" returnvariable="ts">
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#">
			<input type="hidden" name="CMNDAid" value="#rsdataObj.CMNDAid#">
		</cfif>
	</table>
	
</form>
</cfoutput>

<script type="text/javascript" language="JavaScript1.2" >
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
		
	objForm.CMNDAnombre.required = true;
	objForm.CMNDAnombre.description="Nombre del Archivo";
	
	<cfif modo EQ 'ALTA'> 
		objForm.CMNDAdocumento.required = true;
		objForm.CMNDAdocumento.description="Archivo";
	</cfif>
	
	function deshabilitarValidacion(){		
		objForm.CMNDAnombre.required = false;
		objForm.CMNDAdocumento.required = false;
	}

	function contratos(data) {
		if (data!="") {
		   <!---  f.opt.value = "2"; --->    		
			document.form1.action='compraProceso.cfm';
			document.form1.submit();
		}
		return false;
	}
	
	function extraeNombre(value){
		var tmp =  value.split('\\');
		var dato = tmp[tmp.length-1];
		document.form1.nArchivo.value=value; 
		document.form1.CMNDAnombre.value=dato;
	}
	
</script>