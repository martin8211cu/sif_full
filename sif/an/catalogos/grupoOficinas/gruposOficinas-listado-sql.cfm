

<cfquery name="rsReporte" datasource="#session.DSN#">
select	a.GOid,
		a.GOcodigo, 
		a.GOnombre, 
		c.Odescripcion
		,case when (select count(z.GOid)
					from AnexoGOficinaDet z
					where z.GOid = a.GOid 
					)= 0
		then 'No hay Oficinas' end as vacio
		
from AnexoGOficina a
	left outer join AnexoGOficinaDet b
	on  	a.GOid = b.GOid
	left outer join Oficinas c
	on  	b.Ocodigo = c.Ocodigo
	and		a.Ecodigo = c.Ecodigo

where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">

</cfquery>
 
<cfset formato = "flashpaper">

<!--- INVOCA EL REPORTE --->
<cfreport format="#formato#" template= "gruposOficinas-listado.cfr" query="rsReporte">
	<cfreportparam name="Ecodigo" value="#session.Ecodigo#">
	<!--- <cfreportparam name="Edescripcion" value="#session.Enombre#"> --->
</cfreport>


