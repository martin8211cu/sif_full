

<cfquery name="rsReporte" datasource="#session.DSN#">
select	a.GEid,
		a.GEcodigo, 
		a.GEnombre, 
		c.Edescripcion	
		,case when (select count(z.GEid)
					from AnexoGEmpresaDet z
					where z.GEid = a.GEid 
					)= 0
		then 'No hay Empresas'	end as vacio
from AnexoGEmpresa a
	left outer join AnexoGEmpresaDet b
	on  	a.GEid = b.GEid
	left outer join Empresas c
	on  	b.Ecodigo = c.Ecodigo
	and		a.CEcodigo = c.cliente_empresarial

where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">

</cfquery>
 
<cfset formato = "flashpaper">

<!--- INVOCA EL REPORTE --->
<cfreport format="#formato#" template= "gruposEmpresas-listado.cfr" query="rsReporte">
	<cfreportparam name="CEcodigo" value="#session.CEcodigo#">
	<!--- <cfreportparam name="Edescripcion" value="#session.Enombre#"> --->
</cfreport>


