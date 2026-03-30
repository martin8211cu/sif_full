
<cfquery name="rsComponentesPlazaPresup" datasource="#session.DSN#">
		
select  ofic.Odescripcion, g.CFcodigo , g.CFdescripcion , CFcuentac as centroCostos
		  ,count(f.RHPid) as cantidadPlazas, a.RHEid
		  ,(sum(LT.LTporcplaza/100 ) + coalesce(sum(RLT.LTporcplaza/100),0)) as tiemposCompl 
                  
	from RHEscenarios a

	inner join RHFormulacion b
		on b.RHEid = a.RHEid
		and b.Ecodigo = a.Ecodigo
	
	inner join RHPlazaPresupuestaria e
		on e.RHPPid = b.RHPPid
		and e.Ecodigo = b.Ecodigo

	inner join RHPlazas f
		on f.RHPPid = e.RHPPid
		and f.Ecodigo = e.Ecodigo
		
	inner join LineaTiempo LT
		on LT.RHPid = f.RHPid
		and getdate() between LT.LTdesde and LT.LThasta		
		
	
	left outer join LineaTiempoR RLT
		on RLT.RHPid = f.RHPid
		and getdate() between RLT.LTdesde and RLT.LThasta		

	inner join CFuncional g
		on g.CFid = f.CFid
		and g.Ecodigo = f.Ecodigo

	inner join Oficinas ofic
		on ofic.Ocodigo = g.Ocodigo
		and ofic.Ecodigo = a.Ecodigo

	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">	
	<!--- Con Escenarios Activos--->
	and a.RHEestado='A' 
		
group by ofic.Odescripcion, g.CFcodigo ,g.CFdescripcion , CFcuentac, a.RHEid		  
</cfquery>


<!----================ PINTA EL REPORTE ================---->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>

<cfinclude template="DetallComponentesXCentroCosto-rep.cfm">