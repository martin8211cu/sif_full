<cf_templateheader title="Reporte de Usuarios de Solicitudes de Pago por Empresa">
<cf_web_portlet_start title="Reporte de Usuarios de Solicitudes de Pago por Empresa">
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">

<form name="form1" method="post" action="ReporteUsuarioSolPago_sql.cfm">
	
	<table width="100%" align="center" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>
		<tr>
			<td style="width:17%">&nbsp;</td>
			<td nowrap="nowrap" align="right" style="width:10%">
				<strong>Centro Funcional:&nbsp;</strong>
			</td>

			<td align="left">
				<cf_navegacion name="filtro_CFid" default="-1" session>
				<cfif form.filtro_CFid EQ "">
					<cfset form.filtro_CFid = -1>
				</cfif>
				<cfquery name="rsFiltro_CFid" datasource="#session.DSN#">
					select CFid as filtro_CFid, CFcodigo as filtro_CFcodigo, CFdescripcion as filtro_CFdescripcion
					  from CFuncional
					 where CFid = #form.filtro_CFid#
				</cfquery>
				<cf_rhcfuncional 
					form="form1" 
					id="filtro_CFid"
					name="filtro_CFcodigo"
					desc="filtro_CFdescripcion" 
					query="#rsFiltro_CFid#"
					titulo="Seleccione el Centro Funcional" 
					size="40" excluir="-1" tabindex="1"
				>
				<cfif form.filtro_CFid NEQ "-1">
					<cfset LvarFiltro_CF = "and tu.CFid = #form.filtro_CFid#">
				<cfelse>
					<cfset LvarFiltro_CF = "">
				</cfif>
			</td>
		</tr>
		
		<tr>
			<td>&nbsp;</td>
			<td align="right"><strong>Usuario:&nbsp;</strong></td>
			<td align="left">
				<cf_sifusuario conlis="true" size="40">
			</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td width="1%" nowrap align="right"><strong>Es Solicitante de Pago:</strong>&nbsp;</td>
			<td align="left">
				<input type="checkbox" name="TESUSPsolicitante" id="TESUSPsolicitante" value="1" >
			</td>
		</tr>

		<tr>
			<td>&nbsp;</td>
			<td width="1%" nowrap align="right"><strong>Es Aprobador de Solicitudes:</strong>&nbsp;</td>
			<td align="left">
				<input type="checkbox" name="TESUSPaprobador" id="TESUSPaprobador" value="1">
			</td>
		</tr>
	
		<tr>
			<td>&nbsp;</td>
			<td width="1%" nowrap align="right"><strong>&nbsp;- Monto Máximo a Aprobar:</strong>&nbsp;</td>
			<td align="left">
				<cf_inputNumber name="TESUSPmontoMax" enteros=13 decimales=2 />
				<span id="lblMonto">
				(En blanco no tiene límite de aprobación)
				</span>
			</td>
		</tr>
	
		<tr>
			<td>&nbsp;</td>
			<td width="1%" nowrap align="right"><strong>&nbsp;- Puede cambiar la Tesorería de Pago:</strong>&nbsp;</td>
			<td align="left">
				<input type="checkbox" name="TESUSPcambiarTES" id="TESUSPcambiarTES" value="1">
			</td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>
	</table>

	<cf_botones values='Generar'>
<!--- 	filtrar_Por="Usulogin, dp.Pnombre #LvarCNCT# ' ' #LvarCNCT# dp.Papellido1 #LvarCNCT# ' ' #LvarCNCT# dp.Papellido2, TESUSPsolicitante, TESUSPaprobador, TESUSPmontoMax, TESUSPcambiarTES" --->
</form>
<cf_web_portlet_end>
<cf_templatefooter>