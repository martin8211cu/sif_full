<script language='Javascript' src="/cfmx/sif/js/utilesMonto.js"> </script>
<cfset modoreq = 'ALTA' >
<cfif isdefined("form.id_doc")>
	<cfset modoreq = 'CAMBIO' >
</cfif>
<cfif modoreq neq 'ALTA'>
	<cfquery name="data" datasource="#session.tramites.dsn#">
		select id_doc,id_requisito,nombre_archivo,resumen,ts_rversion 
		from TPRequisitoDoc
		where id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#" >
		and id_doc = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_doc#">
	</cfquery>
</cfif>
<cfoutput>
<table width="100%" align="center" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td width="50%" valign="top">
		<form name="form3" method="post" style="margin:0;"  enctype="multipart/form-data" action="TP_requisitosDocssql.cfm" onsubmit="return validar3(this);">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td bgcolor="##ECE9D8" style="padding:3px;" colspan="2"><font size="1"><cfif modoreq eq 'ALTA'>Agregar</cfif>&nbsp;Documento</font></td></tr>
			<tr><td>&nbsp;</td></tr>			
			<tr>
				<cfif modoreq NEQ "ALTA">
					<td width="30%" align="right">Nombre del archivo:&nbsp;</td>
					<td width="70%">
						<strong>#data.nombre_archivo#</strong>
					</td>		
				<cfelse>
					<td width="30%" align="right">Ruta del archivo:&nbsp;</td>
					<td width="70%">
						<input name="ruta" type="file" id="ruta">
					</td>		
				</cfif>
			</tr>
			<tr>
			<td  valign="top" nowrap align="right">Resumen (opcional):</td>
				<td>
				<textarea name="resumen" cols="50" rows="5"  <cfif modoreq NEQ "ALTA">readonly</cfif>><cfif modoreq NEQ "ALTA">#data.resumen#</cfif></textarea>
				</td>
			</tr>	
			
			<tr>
				<td colspan="4" align="center">
					<cfif modoreq neq 'ALTA'>
						<input type="submit" name="Eliminar" value="Eliminar" onClick="javascript: if ( confirm('Desea eliminar el registro?') ){  deshabilitarValidacion(); return true;} return false;">
						<input type="button" name="Nuevo" value="Nuevo" onClick="javascript:location.href='Tp_Requisitos.cfm?id_requisito=#form.id_requisito#&tab=5';">
					<cfelse>
						<input type="submit" name="Agregar" value="Agregar" >
					</cfif>
					<input type="button" name="Lista" value="Ir a lista" onClick="javascript:location.href='Tp_RequisitosList.cfm';">

				</td>
			</tr>
			
		</table>
			<cfset ts = "">
			<cfif modoreq NEQ "ALTA">
				<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#data.ts_rversion#" returnvariable="ts"></cfinvoke>
			</cfif>
			<input type="hidden" name="ts_rversion" value="<cfif modoreq NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>">
			<input type="hidden" name="id_requisito" value="#form.id_requisito#" >
			<input type="hidden" name="id_doc" value="<cfif modoreq NEQ "ALTA"><cfoutput>#data.id_doc#</cfoutput></cfif>">
		</form>
	</td>
	<td width="50%" valign="top">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td bgcolor="##ECE9D8" style="padding:3px;" colspan="2"><font size="1">Documentación Asociada al Trámite</font></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td>
					<cfquery name="rsLista2" datasource="#session.tramites.dsn#">
						select id_doc,id_requisito,nombre_archivo,tipo_mime , '5' as tab 
						from TPRequisitoDoc
						where id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#">
						order by nombre_archivo
					</cfquery>
					<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
						<cfinvokeargument name="query" value="#rsLista2#"/>
						<cfinvokeargument name="desplegar" value="nombre_archivo,tipo_mime"/>
						<cfinvokeargument name="etiquetas" value="Archivo,tipo"/>
						<cfinvokeargument name="formatos" value="V,V"/>
						<cfinvokeargument name="align" value="left,left"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="irA" value="Tp_Requisitos.cfm"/>
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
						<cfinvokeargument name="keys" value="id_doc,id_requisito,tab"/>
						<cfinvokeargument name="formname" value="lista2"/>
					</cfinvoke>
				</td>
			</tr>
		</table>				
	</td>
</tr>
<tr><td colspan="2">&nbsp;</td></tr>
</table>
<script type="text/javascript" language="javascript1.2">
	function validar3(f){
		var msj = '';
		<cfif modoreq EQ "ALTA">
		if ( document.form3.ruta.value == '' ){
			var msj = msj + ' - La ruta del archivo es requerida.\n';
		}
		</cfif>
		if ( msj != ''){
			msj = 'Se presentaron los siguientes errores:\n' + msj;
			alert(msj)
			return false;
		}
		return true
	}
</script>


</cfoutput>

