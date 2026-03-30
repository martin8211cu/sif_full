<cfif isdefined("url.tipo_ident") and not isdefined("form.tipo_ident")>
	<cfset form.tipo_ident = url.tipo_ident >
</cfif>

<script language="javascript" type="text/javascript">
function asignar(identificacion_persona){ 
	window.opener.document.form1.identificacion_persona.value = identificacion_persona
	//window.opener.TraeNombre(identificacion_persona);
	window.close();
 }
</script>

	<table width="100%" border="0" cellspacing="1" cellpadding="0">
	<tr> 
		<td valign="top" width="40%">
			<form style="margin: 0%" name="filtro" method="post">
				<cfoutput>
				<table  border="0" width="100%" class="areaFiltro" >
					<tr> 
						<td>Identificaci&oacute;n:</td>
						<td>Nombre:</td>
						<td>Primer Apellido:</td>
						<td>Segundo Apellido:</td>
					</tr>
					<tr> 
						<td><input type="text" name="fidentificacion"  maxlength="20" size="15" value="<cfif isdefined("form.fidentificacion")>#fidentificacion#</cfif>"></td>
						<td><input type="text" name="fnombre"  maxlength="60" size="20" value="<cfif isdefined("form.fnombre")>#fnombre#</cfif>"></td>
						<td><input type="text" name="fapellido1" maxlength="60" size="20" value="<cfif isdefined("form.fapellido1")>#fapellido1#</cfif>"></td>
						<td><input type="text" name="fapellido2"  maxlength="60" size="20" value="<cfif isdefined("form.fapellido2")>#fapellido2#</cfif>"></td>
						
						<td align="right"><input type="submit" name="btnFiltrar" value="Buscar"></td>
						<td align="left"><input type="button" name="btnLimpiar" value="Limpiar" onClick="javasript: limpiar();"> </td>
					</tr>
				</table>
				</cfoutput>

			</form>
			<cfquery name="rsLista0" datasource="#session.tramites.dsn#" maxrows="100">
				<cf_dbrowcount1 rows="100" datasource="#session.tramites.dsn#">
				select   identificacion_persona,
						 nombre , 
						 apellido1, 
						 apellido2,	
						 a.id_persona
				from     TPPersona a
				where 1=1
				<cf_dbrowcount2 rows="100" datasource="#session.tramites.dsn#">
				<cfif isdefined("form.fidentificacion") and len(trim(form.fidentificacion))>
					  and identificacion_persona like '%#UCase(trim(form.fidentificacion))#%'
				</cfif>
				<cfif isdefined("form.fnombre") and len(trim(form.fnombre))>
					  and nombre like '%#UCase(trim(form.fnombre))#%'
				</cfif>
				<cfif isdefined("form.fapellido1") and len(trim(form.fapellido1))>
					and apellido1 = '%#UCase(trim(form.fapellido1))#'
				</cfif>
				<cfif isdefined("form.fapellido2") and len(trim(form.fapellido2))>
					and apellido2 = '%#UCase(trim(form.fapellido2))#'
				</cfif>
				<!--- order by nombre,apellido1,apellido2 --->
				order by identificacion_persona
			</cfquery>
			<cfquery name="rsLista" dbtype="query">
				select * from rsLista0
				order by identificacion_persona
			</cfquery>
			<cfinvoke 
			component="sif.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsLista#"/>
				<cfinvokeargument name="desplegar" value="identificacion_persona,nombre,apellido1,apellido2"/>
				<cfinvokeargument name="etiquetas" value="Identificaci&oacute;n,Nombre,Apellidos, "/>
				<cfinvokeargument name="formatos" value="S,S,S,S"/>
				<cfinvokeargument name="align" value="left,left,left,left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="keys" value="id_persona"/>
				<cfinvokeargument name="funcion" value="asignar"/>
				<cfinvokeargument name="fparams" value="identificacion_persona"/>
			</cfinvoke>
		</td>
	</tr>
	<tr><td colspan="3">&nbsp;</td></tr> 
	</table>
<script language="javascript" type="text/javascript">
function limpiar(){
	document.filtro.fidentificacion.value = '';
	document.filtro.fnombre.value = '';
	document.filtro.fapellido1.value = '';
	document.filtro.fapellido2.value = '';
}
</script>
