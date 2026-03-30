<cfquery name="rsServiciosDisponibles" datasource="#session.dsn#">
	select TScodigo, TSnombre
	from ISBservicioTipo
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by TScodigo
</cfquery>

<cfoutput>
	<cf_web_portlet_start tituloalign="left" titulo="Tipos de Servicio">
		<table border="0" cellpadding="2" cellspacing="0" width="100%">
			<cfloop query="rsServiciosDisponibles">
			  <tr>
				<td align="right"><label>#rsServiciosDisponibles.TScodigo#</label></td>
				<td nowrap>
					#rsServiciosDisponibles.TSnombre#
				</td>
			  </tr>
			</cfloop>
		</table>
	<cf_web_portlet_end>  
</cfoutput>
