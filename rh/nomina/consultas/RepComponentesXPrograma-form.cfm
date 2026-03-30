<!---<cf_dump var="#form#">--->

	
	<cfquery name="rsCompxProg" datasource="#session.DSN#">
		select  ofic.Odescripcion ,
				d.CScodigo,
				d.CSdescripcion, 
				sum(c.Monto) as Monto
							 
				from RHEscenarios a
				inner join RHFormulacion b
					on b.RHEid = a.RHEid
					and  b.Ecodigo = a.Ecodigo
				
				inner join RHCFormulacion c
					on c.RHFid = b.RHFid
					and c.Ecodigo = b.Ecodigo
				
				inner join ComponentesSalariales d
					on d.CSid = c.CSid
					and d.Ecodigo = c.Ecodigo
				
				inner join RHPlazaPresupuestaria e
					on e.RHPPid = b.RHPPid
					and e.Ecodigo = d.Ecodigo
				
				inner join RHPlazas f
					on f.RHPPid = e.RHPPid
					and f.Ecodigo = e.Ecodigo
				
				inner join CFuncional g
					on g.CFid = f.CFid
					and g.Ecodigo = f.Ecodigo
											
				inner join Oficinas ofic
					on ofic.Ocodigo = g.Ocodigo
					and ofic.Ecodigo = a.Ecodigo
					
				<cfif isdefined ('form.Ocodigo') and len(trim(form.Ocodigo))>	
					and ofic.Ocodigo = #form.Ocodigo# 
				</cfif>
				
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">	
				<cfif isdefined('form.RHEid')>											     								
					and a.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
				</cfif> 	
				
				group by ofic.Odescripcion , d.CScodigo, d.CSdescripcion	
				order by ofic.Odescripcion , d.CScodigo, d.CSdescripcion                           
	</cfquery>

<!---<cf_dump var="#rsCompxProg#">--->

<!----================ PINTA EL REPORTE ================---->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>
<cfinclude template="RepComponentesXPrograma-rep.cfm">