<cfinclude template="fnUriNotExists.cfm">

<cfif isDefined("url.fSScodigo")>
	<cfset form.fSScodigo = url.SScodigo></cfif>
<cfif isDefined("url.fSMcodigo")>
	<cfset form.fSMcodigo = url.fSMcodigo></cfif>
<cfif isDefined("url.SScodigo")>
	<cfset form.SScodigo = url.SScodigo></cfif>
<cfif isDefined("url.SMcodigo")>
	<cfset form.SMcodigo = url.SMcodigo></cfif>
<cfif isDefined("url.SMcodigo")>
	<cfset form.SPcodigo = url.SPcodigo></cfif>
	<cf_templateheader title="Verificación de Componentes">
	<cf_web_portlet_start titulo="Verificación de Componentes">
		<cfinclude template="frame-header.cfm">
		<cfparam name="form.tipoVer" default="1">
		<cfquery name="rsSC" datasource="asp">
			select * from SComponentes
			<cfif form.tipoVer GT "2">
						, SProcesos
					where SComponentes.SScodigo = SProcesos.SScodigo
					  and SComponentes.SMcodigo = SProcesos.SMcodigo
					  and SComponentes.SPcodigo = SProcesos.SPcodigo
					<cfif form.tipoVer EQ "3">
					  and SProcesos.SPanonimo = 1
					<cfelseif form.tipoVer EQ "4">
					  and SProcesos.SPpublico = 1
					<cfelseif form.tipoVer EQ "5">
					  and SProcesos.SPmenu    = 0
					</cfif>
			<cfelse>
				where SCtipo <> 'O'
			</cfif>
		</cfquery>
		<form name="verifica" method="post">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr><td colspan="12"><cfinclude template="/home/menu/pNavegacion.cfm"></td></tr>	
			<tr><td colspan="12">&nbsp;</td></tr>	
			<tr>
				<td colspan="12">
					<select name="tipoVer" onChange="this.form.submit();">
						<option value="1"<cfif form.tipoVer EQ 1> selected</cfif>>Componentes No Existentes</option>
						<option value="2"<cfif form.tipoVer EQ 2> selected</cfif>>Componentes con Nombre Incorrecto</option>
						<option value="3"<cfif form.tipoVer EQ 3> selected</cfif>>Componentes de Procesos Anónimos</option>
						<option value="4"<cfif form.tipoVer EQ 4> selected</cfif>>Componentes de Procesos Publicos</option>
						<option value="5"<cfif form.tipoVer EQ 5> selected</cfif>>Componentes de Procesos que no se muestran en Menú</option>
					</select>
				</td>
			</tr>	
			<tr><td colspan="12">&nbsp;</td></tr>	
			<tr style="background-color: #666666; color:#FFFFFF">
				<td><strong>SISTEMA</strong></td>
				<td><strong>MODULO</strong></td>
				<td><strong>PROCESO</strong></td>
				<td><strong>TIPO</strong></td>
				<td><strong>COMPONENTE</strong></td>
				<td><strong>NOMBRE CORRECTO</strong></td>
			</tr>
			<cfset LvarColor = "">
			<cfoutput query="rsSC">
				<cfif form.tipoVer EQ 1>
					<cfset LvarUri = fnUriNotExists(SCuri,SCtipo)>
					<cfset LvarMostrar = LvarUri.NotExists NEQ 0>
				<cfelseif form.tipoVer EQ 2>
					<cfset LvarUri = fnUriNotExists(SCuri,SCtipo)>
					<cfset LvarMostrar = LvarUri.NotExists EQ 1>
				<cfelse>
					<cfset LvarUri.NotExists = 0>
					<cfset LvarMostrar = true>
				</cfif>
				<cfif LvarMostrar>
					<cfif LvarColor EQ "">
						<cfset LvarColor = "##CCCCCC">
					<cfelse>
						<cfset LvarColor = "">
					</cfif>
					
					<tr style="cursor:pointer; background-color:#LvarColor#;"
						onClick="javascript:location.href='componentes.cfm?SScodigo=#URLEncodedFormat(SScodigo)#&fSScodigo=#URLEncodedFormat(SScodigo)#&SMcodigo=#URLEncodedFormat(SMcodigo)#&fSMcodigo=#URLEncodedFormat(SMcodigo)#&SPcodigo=#URLEncodedFormat(SPcodigo)#&SCuri=#URLEncodedFormat(SCuri)#';"
						 >
						<td>#SScodigo#</td>
						<td>#SMcodigo#</td>
						<td>#SPcodigo#</td>
						<td><cfif SCtipo EQ 'P'>Página<cfelseif SCtipo EQ 'O'>Opción<cfelse>Directorio</cfif></td>
						<td>#SCuri#</td>
						<td><cfif LvarUri.NotExists EQ 1><cfif LvarUri.Uri EQ "">No se digitó Path<strong></cfif>#LvarUri.Uri#</strong><cfelse>&nbsp;</cfif></td>
					</tr>
				</cfif>
			</cfoutput>
		</table>
		</form>
	<cf_web_portlet_end>
<cf_templatefooter>
