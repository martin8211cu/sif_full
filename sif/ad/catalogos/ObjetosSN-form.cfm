<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_ObjetosSocioNegocios" default = "Objetos del Socio de Negocios" returnvariable="LB_ObjetosSocioNegocios" xmlfile = "ObjetosSN-form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Descripcion" default = "Descripci&oacute;n" returnvariable="LB_Descripcion" xmlfile = "ObjetosSN-form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_NombreArchivo" default = "Nombre Archivo" returnvariable="LB_NombreArchivo" xmlfile = "ObjetosSN-form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Archivo" default = "Archivo" returnvariable="LB_Archivo" xmlfile = "ObjetosSN-form.xml">



<cfset modo = 'ALTA'>
<cfif isdefined("form.SNOid") and len(trim(form.SNOid))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif modo neq 'ALTA' or isdefined("form.SNcodigo") and isdefined("form.SNOid") and len(trim(form.SNOid))>
<cfset modo='CAMBIO'>
	<cfquery name="rsSNegociosObjeto" datasource="#session.DSN#">
		select a.SNOid, a.Ecodigo, a.SNcodigo, a.SNOdescripcion, a.SNOarchivo as nombre_archivo, a.SNOcontenttype as extencion,
		a.SNOcontenido as dato, a.ts_rversion
		from SNegociosObjetos a
			inner join SNegocios b
				on a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
				and a. SNOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNOid#">
				and a.Ecodigo = b.Ecodigo
				and a.SNcodigo = b.SNcodigo
	</cfquery>
</cfif>

<cfoutput>
<form enctype="multipart/form-data" action="ObjetosSN-sql.cfm" method="post" name="form6" onsubmit="javascript:document.form6.dir.value=document.form6.OLPdato.value;"><!---  --->
	<input type="hidden" name="SNcodigo" value="#form.SNcodigo#">
	<table width="100%" border="0" cellpadding="2" cellspacing="0" align="center">
		<tr>
			<td align="center" colspan="2"><strong>#LB_ObjetosSocioNegocios#</strong></td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td align="right" nowrap><strong>#LB_Descripcion#:</strong>&nbsp;</td>
			<td><input type="text" name="SNOdescripcion"  value="<cfif modo neq 'ALTA'>#HTMLEditFormat(rsSNegociosObjeto.SNOdescripcion)#</cfif>" size="60" maxlength="100"></td>
		</tr>

		<tr>
			<td align="right" nowrap><strong>#LB_NombreArchivo#:</strong>&nbsp;</td>
			<td><input type="text" readonly="true" name="SNOarchivo"  value="<cfif modo neq 'ALTA'>#HTMLEditFormat(rsSNegociosObjeto.nombre_archivo)#</cfif>" size="60" maxlength="100"></td>
		</tr>

		<tr>
			<td align="right" nowrap><strong>#LB_Archivo#:</strong>&nbsp;</td>
			<td>
				<input type="file" name="OLPdato" value="" onchange="javascript:trataArchivo(this.value);">
				<input type="hidden" name="nArchivo" value="">
			</td>
		</tr>
		<tr>
			<td colspan="2" nowrap>&nbsp;</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<cf_botones modo =#modo# form ="form6" sufijo="Objetos">
		    </td>
		</tr>
	</table>
	<cfif modo neq "ALTA">
		<cfset ts = "">
		<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsSNegociosObjeto.ts_rversion#" returnvariable="ts">
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
		<input type="hidden" name="SNOid" value="#rsSNegociosObjeto.SNOid#">
	</cfif>
</form>
</cfoutput>

<cf_qforms objForm="objForm6" form="form6">
<script type="text/javascript" language="JavaScript1.2" >
	objForm6.SNOdescripcion.required = true;
	objForm6.SNOdescripcion.description="Descripción";

	objForm6.SNOarchivo.required = true;
	objForm6.SNOarchivo.description="Nombre del Archivo";

	<cfif modo EQ 'ALTA'>
		objForm6.OLPdato.required = true;
		objForm6.OLPdato.description="Archivo";
	</cfif>

	function deshabilitarValidacion(){
		objForm6.SNOdescripcion.required = false;
		objForm6.SNOarchivo.required = false;
		objForm6.OLPdato.required = false;
	}

	<!--- javascript:document.form6.nArchivo.value=this.value; --->
	function trataArchivo(file){
		if(file != ""){
			var arrayNameFile = file.split("\\");
			if(arrayNameFile[arrayNameFile.length - 1] !== undefined){
				var arrayNameFile2 = arrayNameFile[arrayNameFile.length - 1].split(".");
				if(arrayNameFile2.length > 0){
					document.form6.SNOarchivo.value = arrayNameFile2[0];
				}
			}
			document.form6.nArchivo.value = file;
		}
	}

</script>