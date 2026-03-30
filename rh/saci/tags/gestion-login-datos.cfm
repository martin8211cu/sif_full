
<cfquery datasource="#Attributes.Conexion#" name="rsLog">
	select 	a.LGnumero,a.LGlogin
	from 	ISBlogin a
	where 	a.LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idlogin#">
			and a.Habilitado =1
</cfquery>

<cfquery datasource="#Attributes.Conexion#" name="rsServicios">
	select distinct b.TScodigo,b.TSnombre
	,case when b.TStipo='A' then  '<img src=''/cfmx/saci/images/outlog.gif''  border=''0'' style=''border:0;margin:0;'' width=''13'' height=''14''>'
		  when b.TStipo='C' then '<img src=''/cfmx/saci/images/outlog1.gif''  border=''0'' style=''border:0;margin:0;'' width=''13'' height=''14''>'
					else '' end as tipo
	from ISBserviciosLogin a
		inner join ISBservicioTipo b
		on b.TScodigo = a.TScodigo
		and b.Habilitado = 1
	where a.LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idlogin#">
	and a.Habilitado = 1
</cfquery>
<cfoutput>
<table width="100%" cellpadding="2" cellspacing="0" border="0">
	<tr>
		<td style="text-align:justify">
			Información principal sobre el login. 
		</td>
	</tr>
	
	<tr>
		<td>
			<cf_web_portlet_start title="Datos">
				<cfif LoginBloqueado>
					<table  class="cfmenu_menu" width="100%" cellpadding="2" cellspacing="0" border="0">
						<tr><td align="center"><label style="color:##660000">Estado: Bloqueado</label></td></tr>
					</table>
				</cfif>	
				<table  class="cfmenu_menu" width="100%" cellpadding="2" cellspacing="0" border="0">
					<tr class="cfmenu_menu">
						<td><label><cf_traducir key="login">Login</cf_traducir></label></td>
						<td>&nbsp;<label><cf_traducir key="servicio">Servicio</cf_traducir> Asociados</label></td>
					</tr>
					<tr>
						<td valign="top">#rsLog.LGlogin#</td>
						<td>
						<cfloop query="rsServicios">
							<table border="0" cellpadding="0" cellspacing="0"><tr>
							<td height="14" width="13" align="right" nowrap>#rsServicios.tipo#</td>
							<td>#rsServicios.TSnombre#<br></td>
							</tr></table>
						</cfloop>
						</td>
					</tr>
				</table>
				
			<cf_web_portlet_end> 
		</td>
	</tr>
</table>
</cfoutput>