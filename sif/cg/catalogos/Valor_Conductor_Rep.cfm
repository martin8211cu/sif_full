<cfoutput>
<cf_templatecss>
<cfquery name="resultado" datasource="#session.dsn#">
	select CGCmodo, CGCidc,CGCdescripcion from CGConductores c
	where CGCid=#url.CGCid#
</cfquery>
<cfquery name="rsEmp" datasource="#session.dsn#">
	select Edescripcion  from Empresas
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
</cfquery>

<cfset id = #resultado.CGCidc#>
<!---modo = 1 -Clasificacion--->
<cfif #url.modo# eq 1>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select 
		ox.CGCperiodo,
		ox.CGCmes,
		ox.CGCvalor,
		o.PCCDvalor,
		o.PCCDdescripcion
		 from PCClasificacionD o
			inner join PCClasificacionE e
			on e.PCCEclaid=o.PCCEclaid	
			inner join CGParamConductores ox
			on ox.PCCDclaid=o.PCCDclaid
			and ox.Ecodigo=o.Ecodigo
	
			and ox.CGCid=#url.CGCid#
			and ox.CGCvalor !=0
			where o.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
			and e.PCCEclaid=#id#	
			and o.PCCDvalor='#url.valor#'
	</cfquery>
	<cfquery name="rsSQL1" datasource="#session.dsn#">
			select ox.CGCperiodo,
				ox.CGCmes,
				ox.CGCvalor,
				o.PCCDvalor,
				ox.CGCid,
				(select CGCdescripcion from CGConductores where CGCid=ox.CGCid) as descrip
			from PCClasificacionD o
				inner join PCClasificacionE e
				on e.PCCEclaid=o.PCCEclaid	
				inner join CGParamConductores ox
				on ox.PCCDclaid=o.PCCDclaid
				and ox.Ecodigo=o.Ecodigo
				and ox.CGCvalor !=0
				where o.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
				and e.PCCEclaid=#id#	
				and o.PCCDvalor='#url.valor#'
	</cfquery>
<!---Dibujo del reporte consulta uno Clasificacion--->
<cf_web_portlet_start border="true" titulo="Reporte por Conductor:#resultado.CGCdescripcion#" skin="#Session.Preferences.Skin#">
<table width="100%" border="0" cellpadding="5">
	<tr><td align="center"><strong>#rsEmp.Edescripcion#</strong></td></tr>
	<tr><td align="center"><strong>Fecha:&nbsp;</strong>#LSDateFormat(Now(),"DD/MM/YYYY")#</td></tr>
	<tr><td align="center"><strong>Reporte de Valores por Conductor</strong></td></tr>

	<tr>
		<td>
			<strong>Codigo/Descripcion</strong>#rsSQL.PCCDvalor#-#rsSQL.PCCDdescripcion#
		</td>
	</tr>
	<tr>
		<table width="100%" cellpadding="0" cellspacing="0" border="1" cellpadding="5" cellspacing="5">
			<tr>
				<td align="center"><strong>Peri&oacute;do</strong></td>
				<td align="center"><strong>Mes</strong></td>
				<td align="center"><strong>Valor</strong></td>
			</tr>
			<tr>	
				<cfloop query="rsSQL">
					<tr class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>" align="center">
						<td align="center">#rsSQL.CGCperiodo#</td>
						<td align="center">#rsSQL.CGCmes#</td>
						<td align="center">#rsSQL.CGCvalor#</td>
					</tr>
				</cfloop>
			</tr>
		</table>		
	</tr>
	<tr><td>&nbsp;</td></tr>	
	<tr><td>&nbsp;</td></tr>	
</table>
<cf_web_portlet_end>
<!---Dibujo del reporte consulta dos Clasificacion--->
<cf_web_portlet_start border="true" titulo="Reporte por detalle de conductor:#rsSQL.PCCDvalor#-#rsSQL.PCCDdescripcion#" skin="#Session.Preferences.Skin#">
<table width="100%" border="0">
	<tr><td align="center"><strong>#rsEmp.Edescripcion#</strong></td></tr>
	<tr><td align="center"><strong>Fecha:&nbsp;</strong>#LSDateFormat(Now(),"DD/MM/YYYY")#</td></tr>
	<tr><td align="center"><strong>Reporte de Valores por Detalle de conductor</strong></td></tr>
	<tr>
		<table width="100%" cellpadding="0" cellspacing="0" border="1">
			<tr>
				<td align="center"><strong>Conductor</strong></td>
				<td align="center"><strong>Peri&oacute;do</strong></td>
				<td align="center"><strong>Mes</strong></td>
				<td align="center"><strong>Valor</strong></td>
			</tr>
			<tr>	
				<cfloop query="rsSQL1">
					<tr class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>" align="center">
						<td align="left">#rsSQL1.descrip#</td>
						<td align="center">#rsSQL1.CGCperiodo#</td>
						<td align="center">#rsSQL1.CGCmes#</td>
						<td align="center">#rsSQL1.CGCvalor#</td>
					</tr>
				</cfloop>
			</tr>
		</table>		
	</tr>	
</table>
<cf_web_portlet_end>

</cfif>

<!---modo = 2 -Catalogo--->
<cfif #url.modo# eq 2>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select 
		ox.CGCperiodo,
		ox.CGCmes,
		ox.CGCvalor,
		o.PCDvalor,
		o.PCDdescripcion
		
		
		from PCDCatalogo o
			inner join PCECatalogo e
			on e.PCEcatid=o.PCEcatid
			
			inner join CGParamConductores ox
			on ox.PCDcatid=o.PCDcatid
			and ox.Ecodigo=o.Ecodigo	
			and ox.CGCid=#url.CGCid#
			and ox.CGCvalor !=0
			where o.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
			and e.PCEcatid=#id#	
			and o.PCDvalor='#url.valor#'
		
			
	</cfquery>
	<cfquery name="rsSQL1" datasource="#session.dsn#">
			select ox.CGCperiodo,
				ox.CGCmes,
				ox.CGCvalor,
				o.PCDvalor,
				ox.CGCid,
				(select CGCdescripcion from CGConductores where CGCid=ox.CGCid) as descrip
			from PCDCatalogo o
			inner join PCECatalogo e
			on e.PCEcatid=o.PCEcatid			
			inner join CGParamConductores ox
			on ox.PCDcatid=o.PCDcatid
			and ox.Ecodigo=o.Ecodigo	
			and ox.CGCvalor !=0
			where o.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">
			and e.PCEcatid=#id#	
			and o.PCDvalor='#url.valor#'
	</cfquery>
<!---Dibujo del reporte consulta uno Clasificacion--->
<cf_web_portlet_start border="true" titulo="Valores por Conductor:#resultado.CGCdescripcion#" skin="#Session.Preferences.Skin#">
<table width="100%" border="0">
	<tr><td align="center"><strong>#rsEmp.Edescripcion#</strong></td></tr>
	<tr><td align="center"><strong>Fecha:&nbsp;</strong>#LSDateFormat(Now(),"DD/MM/YYYY")#</td></tr>
	<tr><td align="center"><strong>Reporte de Valores por Conductor </strong></td></tr>

	<tr>
		<td>
			<strong>Codigo/Descripcion</strong>#rsSQL.PCDvalor#-#rsSQL.PCDdescripcion#
		</td>
	</tr>
	<tr>
		<table width="100%" cellpadding="0" cellspacing="0" border="1">
			<tr>
				<td align="center"><strong>Peri&oacute;do</strong></td>
				<td align="center"><strong>Mes</strong></td>
				<td align="center"><strong>Valor</strong></td>
			</tr>
			<tr>	
				<cfloop query="rsSQL">
					<tr class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>" align="center">
						<td align="center">#rsSQL.CGCperiodo#</td>
						<td align="center">#rsSQL.CGCmes#</td>
						<td align="center">#rsSQL.CGCvalor#</td>
					</tr>
				</cfloop>
			</tr>
		</table>		
	</tr>
	<tr><td>&nbsp;</td></tr>	
	<tr><td>&nbsp;</td></tr>	
</table>
<cf_web_portlet_end>
<!---Dibujo del reporte consulta dos Clasificacion--->
<cf_web_portlet_start border="true" titulo="Reporte por detalle de Conductor:#rsSQL.PCDvalor#-#rsSQL.PCDdescripcion#" skin="#Session.Preferences.Skin#">
<table width="100%" border="0">
	<tr><td align="center"><strong>#rsEmp.Edescripcion#</strong></td></tr>
	<tr><td align="center"><strong>Fecha:&nbsp;</strong>#LSDateFormat(Now(),"DD/MM/YYYY")#</td></tr>
	<tr><td align="center"><strong>Reporte por Detalle de Conductor</strong></td></tr>
	<tr>
		<table width="100%" cellpadding="0" cellspacing="0" border="1">
			<tr>
				<td align="center"><strong>Conductor</strong></td>
				<td align="center"><strong>Peri&oacute;do</strong></td>
				<td align="center"><strong>Mes</strong></td>
				<td align="center"><strong>Valor</strong></td>
			</tr>
			<tr>	
				<cfloop query="rsSQL1">
					<tr class="<cfif currentrow mod 2>listaPar<cfelse>listaNon</cfif>" align="center">
						<td align="left">#rsSQL1.descrip#</td>
						<td align="center">#rsSQL1.CGCperiodo#</td>
						<td align="center">#rsSQL1.CGCmes#</td>
						<td align="center">#rsSQL1.CGCvalor#</td>
					</tr>
				</cfloop>
			</tr>
		</table>		
	</tr>	
</table>
<cf_web_portlet_end>

</cfif>
</cfoutput>