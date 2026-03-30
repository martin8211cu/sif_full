<cfset modo = 'ALTA'>
<cfif isdefined("form.DDAid") and len(trim(form.DDAid))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif modo NEQ 'ALTA'>
	<cfquery name="rsdataObj" datasource="#session.DSN#">
		select DDAid, CMPid, DDAnombre, DDAextension, ts_rversion
		from DDocumentosAdjuntos
		where DDAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DDAid#">
			and DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DSlinea1#">
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

<form enctype="multipart/form-data" action="ObjetosSolicitudes-sql.cfm?DSlinea1=#form.DSlinea1#" method="post" name="form1" onsubmit="javascript:document.form1.dir.value=document.form1.DDAdocumento.value;" >
	<table width="100%" border="0" cellpadding="2" cellspacing="0" align="center" >		
		<tr>
			<td align="right" nowrap><strong>Nombre Archivo:</strong>&nbsp;</td>
			<td><input type="text" name="DDAnombre"  value="<cfif modo neq 'ALTA'>#HTMLEditFormat(rsdataObj.DDAnombre)#</cfif>" size="60" maxlength="100"></td>
		</tr>	

		<tr>
			<td align="right" nowrap><strong>Archivo:</strong>&nbsp;</td>
			<td>
				<input type="file" name="DDAdocumento" value=""  onChange="javascript:extraeNombre(this.value);">
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
				<input name="Cerrar" type="button" value="Cerrar" onClick="javascript:cerrar();">		 
			</td>
		</tr>	
	
		<cfif modo neq "ALTA">
			<cfset ts = "">
			<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsdataObj.ts_rversion#" returnvariable="ts">
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#">
			<input type="hidden" name="DDAid" value="#rsdataObj.DDAid#">
		</cfif>
	</table>
	
</form>
</cfoutput>

<script type="text/javascript" language="JavaScript1.2" >
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
		
	objForm.DDAnombre.required = true;
	objForm.DDAnombre.description="Nombre del Archivo";
	
	<cfif modo EQ 'ALTA'> 
		objForm.DDAdocumento.required = true;
		objForm.DDAdocumento.description="Archivo";
	</cfif>
	
	function deshabilitarValidacion(){		
		objForm.DDAnombre.required = false;
		objForm.DDAdocumento.required = false;
	}

	function cerrar(data) {
		window.close();		
	}
	
	function extraeNombre(value){
		var tmp =  value.split('\\');
		var dato = tmp[tmp.length-1];
		document.form1.nArchivo.value=value; 
		document.form1.DDAnombre.value=dato;
	}
	
</script>