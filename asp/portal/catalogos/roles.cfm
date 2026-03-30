<cf_templateheader title="Mantenimiento de Grupos">
	<cfif isdefined("url.fSScodigo") and not isdefined("form.fSScodigo")>
		<cfparam name="form.fSScodigo" default="#url.fSScodigo#">
	</cfif>
	<cfif isdefined("url.fSRcodigo") and not isdefined("form.fSRcodigo")>
		<cfparam name="form.fSRcodigo" default="#url.fSRcodigo#">
	</cfif>
	<cfif isdefined("Url.fSRdescripcion") and not isdefined("form.fSRdescripcion")>
		<cfparam name="form.fSRdescripcion" default="#url.fSRdescripcion#">
	</cfif>

	<cfset filtro = "">
	<cfset additionalCols = "">
	<cfset navegacion = "">
	
	<cfif isdefined("form.fSScodigo") and Len(Trim(form.fSScodigo)) NEQ 0>
		<cfset filtro = filtro & " and a.SScodigo = '#form.FSScodigo#'" >
		<cfset additionalCols = additionalCols & "'#form.fSScodigo#' as fSScodigo, ">
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fSScodigo=" & form.fSScodigo>
	</cfif>	
	<cfif isdefined("form.fSRcodigo") and Len(Trim(form.fSRcodigo)) NEQ 0>
		<cfset filtro = filtro &  " and upper(b.SRcodigo) like upper('%#form.fSRcodigo#%')" >
		<cfset additionalCols = additionalCols & "'#form.fSRcodigo#' as fSRcodigo, ">
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fSRcodigo=" & form.fSRcodigo>
	</cfif>	
	<cfif isdefined("form.fSRdescripcion") and Len(Trim(form.fSRdescripcion)) NEQ 0>
		<cfset filtro = filtro & " and upper(b.SRdescripcion) like upper('%#form.fSRdescripcion#%')" >
		<cfset additionalCols = additionalCols & "'#form.fSRdescripcion#' as fSRdescripcion, ">
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fSRdescripcion=" & Form.fSRdescripcion>
	</cfif>	

	<!--- Sistemas Existentes --->
	<cfquery name="rsSistemas" datasource="asp">
		select 	rtrim(SScodigo) as SScodigo, 
				<!---rtrim(SScodigo) || ' - ' || SSdescripcion as SSdescripcion--->
				{fn concat({fn concat(rtrim(SScodigo), ' - ')}, SSdescripcion)} as SSdescripcion
		from SSistemas
		order by SScodigo, SSdescripcion
	</cfquery>

	<cf_web_portlet_start titulo="Mantenimiento de Grupos">
		<cfinclude template="frame-header.cfm">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr><td colspan="2"><cfinclude template="/home/menu/pNavegacion.cfm"></td></tr>	
			<tr>
				<td valign="top" align="center">&nbsp;</td>
				<td valign="top" align="center">&nbsp;</td>
			</tr>
			
			<tr>
				<td width="60%" valign="top" align="center">
					<form action="#CurrentPage#" method="post" name="filtro" id="filtro" style="margin: 0;">
						<table width="100%"  border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
							<tr>
								<td class="etiquetaCampo" align="right">Sistema:</td>
								<td align="left">
									<select name="fSScodigo">
										<option value=""></option>
										<cfoutput query="rsSistemas">
											<option value="#SScodigo#"<cfif isdefined('form.fSScodigo') and form.fSScodigo EQ rsSistemas.SScodigo> selected</cfif>>#SScodigo#</option>
										</cfoutput>
									</select>
								</td>
								<td align="left"><img src="edit.gif" alt="Editar sistema" width="19" height="17" border="0" onClick="location.href='sistemas.cfm?SScodigo='+escape(filtro.fSScodigo.value)"></td>
								<td class="etiquetaCampo" align="right">C&oacute;digo:</td>
								<td align="left">
									<input name="fSRcodigo" type="text" id="fSRcodigo" size="5" maxlength="10" value="<cfif isdefined('form.fSRcodigo')><cfoutput>#form.fSRcodigo#</cfoutput></cfif>">
								</td>
								<td class="etiquetaCampo" align="right">Descripci&oacute;n:</td>
								<td align="left">
									<input name="fSRdescripcion" type="text" id="fSRdescripcion" size="20" maxlength="50" value="<cfif isdefined('form.fSRdescripcion')><cfoutput>#form.fSRdescripcion#</cfoutput></cfif>">
								</td>
								<td align="center"><input type="submit" name="btnBuscar" value="Filtrar"></td>
							</tr>
						</table>
					</form>

					<cfinvoke component="commons.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
						<cfinvokeargument name="tabla" value="SSistemas a, SRoles b"/>
						<cfinvokeargument name="columnas" value="#additionalCols# rtrim(a.SScodigo) as SScodigo, {fn concat({fn concat(rtrim(a.SScodigo) , ' - ' )},  a.SSdescripcion )} as Sistema, rtrim(b.SRcodigo) as SRcodigo, b.SRdescripcion "/>
						<cfinvokeargument name="desplegar" value="SRcodigo, SRdescripcion"/>
						<cfinvokeargument name="etiquetas" value="Código, Descripción del Grupo"/>
						<cfinvokeargument name="formatos" value=""/>
						<cfinvokeargument name="filtro" value="a.SScodigo = b.SScodigo #filtro# order by a.SScodigo, a.SSdescripcion, b.SRcodigo, b.SRdescripcion"/>
						<cfinvokeargument name="align" value="left, left"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="irA" value="roles.cfm"/>
						<cfinvokeargument name="maxRows" value="80"/>
						<cfinvokeargument name="keys" value="SScodigo, SRcodigo"/>
						<cfinvokeargument name="cortes" value="Sistema"/>
						<cfinvokeargument name="conexion" value="asp"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>
						<cfinvokeargument name="MaxRows" value="80"/>
						<cfinvokeargument name="showEmptyListMsg" value="#true#"/>
					</cfinvoke>
				</td>
				<td rowspan="2" align="center" valign="top">
					<cfinclude template="roles-form.cfm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
