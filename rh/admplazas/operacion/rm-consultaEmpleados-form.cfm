<cfset url.fhasta = '' >
<cfinvoke component="rh.Componentes.RH_AplicaMovimientoPlaza" method="plazasActivas" returnvariable="data" > 
	<cfinvokeargument name="RHPPid" value="#url.RHPPid#">	
	<cfinvokeargument name="desde" 	value="#LSParseDateTime(url.fdesde)#" >
	
	<cfif isdefined("url.fhasta") and len(trim(url.fhasta))>
		<cfinvokeargument name="hasta" value="#LSParseDateTime(url.fhasta)#" >
	</cfif>
	
	<cfinvokeargument name="mostrarcesados" value="false" >
</cfinvoke>

<cfquery name="plaza" datasource="#session.DSN#">
	select RHPPcodigo as codigo, RHPPdescripcion as descr
	from RHPlazaPresupuestaria
	where RHPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHPPid#">
</cfquery>

<table width="100%" border="0" cellspacing="0">
	<tr>
		<td valign="top"  width="55%">
			<table width="95%" align="center" cellpadding="2" cellspacing="0">
				<tr><td>&nbsp;</td></tr>
				<cfoutput>
				<tr><td colspan="3" align="center"><font size="3"><strong>#session.Enombre#</strong></font></td></tr>
				<tr><td colspan="3" align="center" ><font size="2"><strong>Consulta de Empleados afectados por movimiento de plaza</strong></font></td></tr>
				<tr><td colspan="3" align="center"><font size="2"><strong>Plaza Presupuestaria: #trim(plaza.codigo)# - #plaza.descr#</strong></font></td></tr>
				</cfoutput>
			
				<tr>
					<td class="tituloListas">Identificaci&oacute;n</td>
					<td class="tituloListas">Empleado</td>
					<td class="tituloListas">Plaza</td>
				</tr>
				<cfoutput query="data" group="DEidentificacion">
					<tr>
						<td>#data.DEidentificacion#</td>
						<td>#data.DEnombre# #data.DEapellido1# #data.DEapellido2#</td>
						<td>#data.RHPcodigo# - #data.RHPdescripcion#</td>
					</tr>
				</cfoutput>
				<cfif data.recordcount eq 0 >
					<tr><td colspan="3" align="center" style="padding:3px;"><strong>No existen empleados que puedan ser afectados por el movimiento.</strong></td></tr>
				<cfelse>
					<tr><td colspan="3" align="center">--- Fin de la Consulta ---</td></tr>
				</cfif>
				<tr><td>&nbsp;</td></tr>
			</table>
		</td>
	</tr>
</table>