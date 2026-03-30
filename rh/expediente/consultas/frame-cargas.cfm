<cfquery name="rsAnotaciones" datasource="#Session.DSN#">
	select a.DEid,
		   c.ECdescripcion, 
		   a.DClinea,
		   b.DCdescripcion, 
		   CEdesde, 
		   CEhasta, 
		   6 as o, 
		   1 as sel

	from CargasEmpleado a
	
	inner join DCargas b
	on a.DClinea=b.DClinea 
	
	inner join ECargas c
	on b.ECid=c.ECid 

	where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleado.DEid#">
	and c.Ecodigo=b.Ecodigo
	  and c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	order by DEid,c.ECdescripcion, b.DCdescripcion

</cfquery>

<cfset carga = "">
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">

<cfif rsAnotaciones.recordCount GT 0>
	<cfoutput>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
			  <td width="6%" align="center" nowrap class="tituloListas">&nbsp;</td> 
			  <td width="38%" align="center" nowrap class="tituloListas"><cf_translate key="Carga">Carga</cf_translate></td>
			  <td width="29%" align="center" nowrap class="tituloListas"><cf_translate key="FechaDesde">Fecha Desde</cf_translate></td>
			  <td width="27%" align="center" nowrap class="tituloListas"><cf_translate key="FechaHasta">Fecha Hasta</cf_translate></td>
		    </tr>
				<cfloop query="rsAnotaciones">
					<cfif carga NEQ #ECdescripcion#>
						<tr class="listaCorte">
						  <td colspan="4"><strong>#ECdescripcion#</strong></td> 
				      </tr>
						<cfset carga = "#ECdescripcion#">
					</cfif>
				
					<tr>
					  <td align="center">&nbsp;</td> 
					  <td align="left">#DCdescripcion#.</td>
					  <td align="center"><cfif len(trim(rsAnotaciones.CEdesde))>#LSdateFormat(rsAnotaciones.CEdesde,'dd/mm/yyyy')#<cfelse>&nbsp;</cfif></td>
					  <td align="center"><cfif len(trim(rsAnotaciones.CEhasta))>#LSDateFormat(rsAnotaciones.CEhasta,'dd/mm/yyyy')#<cfelse>&nbsp;</cfif></td>
				    </tr>
				</cfloop>
	</table>
	</cfoutput>
<cfelse>
	<cf_translate key="MSG_Elempleadonotienecargasasociadasactualmente">El empleado no tiene cargas asociadas actualmente</cf_translate>
</cfif>
