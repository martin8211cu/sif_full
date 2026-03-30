<cfif isDefined("url.SScodigo")>
	<cfset form.SScodigo = url.SScodigo></cfif>
<cfif isDefined("url.fSScodigo")>
	<cfset form.fSScodigo = url.fSScodigo></cfif>
<cfif isDefined("url.SMcodigo")>
	<cfset form.SMcodigo = url.SMcodigo></cfif><cf_templateheader title="Mantenimiento de Módulos">
	<cfif isdefined("Url.FSScodigo") and not isdefined("Form.FSScodigo")>
		<cfparam name="Form.FSScodigo" default="#Url.FSScodigo#">
	</cfif>
	<cfif isdefined("Url.FSMcodigo") and not isdefined("Form.FSMcodigo")>
		<cfparam name="Form.FSMcodigo" default="#Url.FSMcodigo#">
	</cfif>
	<cfif isdefined("Url.FSMdescripcion") and not isdefined("Form.FSMdescripcion")>
		<cfparam name="Form.FSMdescripcion" default="#Url.FSMdescripcion#">
	</cfif>

	<cfset filtro = "">
	<cfset additionalCols = "">
	<cfset navegacion = "">

	<cfif isdefined("Form.FSScodigo") and Len(Trim(Form.FSScodigo)) NEQ 0>
		<cfset filtro = filtro & " and a.SScodigo = '#Form.FSScodigo#'" >
		<cfset additionalCols = additionalCols & "'#Form.FSScodigo#' as FSScodigo, ">
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FSScodigo=" & Form.FSScodigo>
	</cfif>
	<cfif isdefined("Form.FSMcodigo") and Len(Trim(Form.FSMcodigo)) NEQ 0>
		<cfset filtro = filtro &  " and upper(b.SMcodigo) like upper('%#Form.FSMcodigo#%')" >
		<cfset additionalCols = additionalCols & "'#Form.FSMcodigo#' as FSMcodigo, ">
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FSMcodigo=" & Form.FSMcodigo>
	</cfif>
	<cfif isdefined("Form.FSMdescripcion") and Len(Trim(Form.FSMdescripcion)) NEQ 0>
		<cfset filtro = filtro & " and upper(b.SMdescripcion) like upper('%#Form.FSMdescripcion#%')" >
		<cfset additionalCols = additionalCols & "'#Form.FSMdescripcion#' as FSMdescripcion, ">
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FSMdescripcion=" & Form.FSMdescripcion>
	</cfif>

	<!--- Sistemas Existentes --->
	<cfquery name="rsSistemas" datasource="asp">
		select 	rtrim(SScodigo) as SScodigo,
				{fn concat({fn concat(rtrim(SScodigo), ' - ')}, SSdescripcion)} as SSdescripcion <!--- rtrim(SScodigo) || ' - ' || SSdescripcion as SSdescripcion --->
		from SSistemas
		order by SScodigo, SSdescripcion
	</cfquery>

	<cf_web_portlet_start titulo="Mantenimiento de Módulos">
		<cfinclude template="frame-header.cfm">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr><td colspan="2"><cfinclude template="/home/menu/pNavegacion.cfm"></td></tr>
			<tr>
				<td valign="top" align="center">&nbsp;</td>
				<td valign="top" align="center">&nbsp;</td>
			</tr>

			<tr>
				<td width="60%" valign="top" align="center">
					<form action="#CurrentPage#" method="post" style="margin: 0;" name="filtro" id="filtro">
						<table width="100%"  border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
							<tr>
								<td class="etiquetaCampo" align="right">Sistema:</td>
							  <td align="left">
									<select name="FSScodigo">
										<option value=""></option>
										<cfoutput query="rsSistemas">
											<option value="#SScodigo#"<cfif isdefined('Form.FSScodigo') and trim(Form.FSScodigo) EQ trim(rsSistemas.SScodigo)> selected</cfif>>#SScodigo#</option>
										</cfoutput>
									</select>
								</td>
								<td align="left"><img src="edit.gif" alt="Editar sistema" width="19" height="17" border="0" onClick="location.href='sistemas.cfm?SScodigo='+escape(filtro.FSScodigo.value)"></td>
								<td class="etiquetaCampo" align="right">C&oacute;digo:</td>
								<td align="left">
									<input name="FSMcodigo" type="text" id="FSMcodigo" size="5" maxlength="10" value="<cfif isdefined('Form.FSMcodigo')><cfoutput>#Form.FSMcodigo#</cfoutput></cfif>">
								</td>
								<td class="etiquetaCampo" align="right">Descripci&oacute;n:</td>
								<td align="left">
									<input name="FSMdescripcion" type="text" id="FSMdescripcion" size="20" maxlength="50" value="<cfif isdefined('Form.FSMdescripcion')><cfoutput>#Form.FSMdescripcion#</cfoutput></cfif>">
								</td>
								<td align="center"><input type="submit" name="btnBuscar" value="Filtrar"></td>
							</tr>
						</table>
					</form>

					<cfinvoke component="commons.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
						<cfinvokeargument name="tabla" value="SSistemas a inner join SModulos b	on a.SScodigo = b.SScodigo left join SGModulos c on b.SGcodigo = c.SGcodigo "/>
						<cfinvokeargument name="columnas" value="#additionalCols# rtrim(a.SScodigo) as SScodigo, {fn concat({fn concat(rtrim(a.SScodigo), ' - ')}, a.SSdescripcion)} as Sistema, rtrim(b.SMcodigo) as SMcodigo, b.SMdescripcion, b.SMorden, b.SGcodigo, c.SGdescripcion"/>
						<cfinvokeargument name="desplegar" value="SMorden, SMcodigo, SMdescripcion"/>
						<cfinvokeargument name="etiquetas" value="Ord, Código, Descripción del Módulo"/>
						<cfinvokeargument name="formatos" value=""/>
						<cfinvokeargument name="filtro" value="a.SScodigo = b.SScodigo #filtro# order by a.SSorden, a.SSdescripcion,a.SScodigo, b.SMorden, b.SMdescripcion, b.SMcodigo"/>
						<cfinvokeargument name="align" value="left, left, left"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="irA" value="modulos.cfm"/>
						<cfinvokeargument name="maxRows" value="20"/>
						<cfinvokeargument name="keys" value="SScodigo, SMcodigo"/>
						<cfinvokeargument name="cortes" value="Sistema"/>
						<cfinvokeargument name="conexion" value="asp"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>
						<cfinvokeargument name="MaxRows" value="80"/>
						<cfinvokeargument name="showEmptyListMsg" value="#true#"/>
					</cfinvoke>
				</td>
				<td rowspan="2" align="center" valign="top">
					<cfinclude template="modulos-form.cfm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
