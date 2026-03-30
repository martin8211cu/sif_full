<cfif isdefined("Url.fidentificacion") and Len(Trim(Url.fidentificacion))>
	<cfparam name="Form.fidentificacion" default="#Url.fidentificacion#">
</cfif>
<cfif isdefined("Url.fnombre") and Len(Trim(Url.fnombre))>
	<cfparam name="Form.fnombre" default="#Url.fnombre#">
</cfif>
<cfif isdefined("Url.fapellido1") and Len(Trim(Url.fapellido1))>
	<cfparam name="Form.fapellido1" default="#Url.fapellido1#">
</cfif>
<cfif isdefined("Url.fapellido2") and Len(Trim(Url.fapellido2))>
	<cfparam name="Form.fapellido2" default="#Url.fapellido2#">
</cfif>

<cfset navegacion = "">
<cfif isdefined("Form.fidentificacion") and Len(Trim(Form.fidentificacion))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "fidentificacion=" & Form.fidentificacion>
</cfif>
<cfif isdefined("Form.fnombre") and Len(Trim(Form.fnombre))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "fnombre=" & Form.fnombre>
</cfif>
<cfif isdefined("Form.fapellido1") and Len(Trim(Form.fapellido1))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "fapellido1=" & Form.fapellido1>
</cfif>
<cfif isdefined("Form.fapellido2") and Len(Trim(Form.fapellido2))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "fapellido2=" & Form.fapellido2>
</cfif>


<script language="javascript" type="text/javascript">
	function limpiarfuncionario() {
		document.filtro.fidentificacion.value = '';
		document.filtro.fnombre.value = '';
		document.filtro.fapellido1.value = '';
		document.filtro.fapellido2.value = '';
	}
</script>

<cfoutput>
	<table width="100%" border="0" cellspacing="1" cellpadding="0">
		<tr> 
			<td valign="top" width="100%">
				<form name="filtro" method="post" action="#GetFileFromPath(GetTemplatePath())#" style="margin: 0%">
					<table border="0" cellpadding="2" width="100%" class="areaFiltro" >
						<tr> 
							<td width="1%"><strong>Identificaci&oacute;n:</strong></td>
							<td><input type="text" name="fidentificacion" maxlength="30" size="20" value="<cfif isdefined("form.fidentificacion")>#fidentificacion#</cfif>"></td>
							<td width="1%"><strong>Nombre:</strong></td>
							<td><input type="text" name="fnombre" maxlength="60" size="20" value="<cfif isdefined("form.fnombre")>#trim(form.fnombre)#</cfif>"></td>
							<td width="1%" nowrap><strong>1er Apellido:</strong></td>
							<td><input type="text" name="fapellido1" maxlength="60" size="20" value="<cfif isdefined("form.fapellido1")>#trim(form.fapellido1)#</cfif>"></td>
							<td nowrap width="1%"><strong>2do Apellido:</strong></td>
							<td><input type="text" name="fapellido2" maxlength="60" size="20" value="<cfif isdefined("form.fapellido2")>#trim(form.fapellido2)#</cfif>"></td>
							<td align="right">
								<input type="submit" name="btnFiltrar" value="Filtrar">
								<input type="button" name="btnLimpiar" value="Limpiar" onClick="javascript: limpiarfuncionario();">
							</td>
						</tr>
					</table>
				</form>
				<cfquery name="rsLista" datasource="#session.tramites.dsn#">
					select a.id_inst, a.id_funcionario, 
						   b.id_persona, b.identificacion_persona, b.nombre || ' ' || b.apellido1 || ' ' || b.apellido2 as nombre_completo,
						   c.codigo_inst, c.nombre_inst, c.codigo_inst || ' - ' || c.nombre_inst as institucion
					from TPFuncionario a
						inner join TPPersona b
							on b.id_persona = a.id_persona
						<cfif isdefined("form.fidentificacion") and len(trim(form.fidentificacion))>
							and upper(b.identificacion_persona) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(UCase(form.fidentificacion))#%">
						</cfif>
						<cfif isdefined("form.fnombre") and len(trim(form.fnombre))>
							and upper(b.nombre) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(UCase(form.fnombre))#%">
						</cfif>
						<cfif isdefined("form.fapellido1") and len(trim(form.fapellido1))>
							and upper(b.apellido1) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(UCase(form.fapellido1))#%">
						</cfif>
						<cfif isdefined("form.fapellido2") and len(trim(form.fapellido2))>
							and upper(b.apellido2) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(UCase(form.fapellido2))#%">
						</cfif>
						inner join TPInstitucion c
							on c.id_inst = a.id_inst
					<cfif isdefined("Form.id_inst") and Len(Trim(Form.id_inst))>
					where a.id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_inst#">
					</cfif>
					order by c.codigo_inst, b.nombre, b.apellido1, b.apellido2
				</cfquery>
				
				<cfinvoke 
				component="sif.Componentes.pListas"
				method="pListaQuery"
				returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsLista#"/>
					<cfinvokeargument name="desplegar" value="identificacion_persona, nombre_completo"/>
					<cfinvokeargument name="etiquetas" value="Identificaci&oacute;n, Nombre"/>
					<cfinvokeargument name="formatos" value="S,S"/>
					<cfinvokeargument name="align" value="left,left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="keys" value="id_inst, id_persona, id_funcionario"/>
					<cfif not (isdefined("Form.id_inst") and Len(Trim(Form.id_inst)))>
						<cfinvokeargument name="cortes" value="institucion"/>
					</cfif>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
				</cfinvoke>
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
	</table>
</cfoutput>
