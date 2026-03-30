<!---<cf_dump var="#form#">--->
<cfif isdefined("url.CPid") and len(trim(url.CPid))>
	<cfset form.CPid = url.CPid>
</cfif>
<cfif isdefined("url.FechaPublic")>
	<cfset form.FechaPublic = url.FechaPublic >
</cfif>
	
<cfset Fecha= DateFormat(#form.FechaPublic#, "dd/mm/yyyy") >
<cfset Nuevafecha = DateAdd('m', -6, #Fecha#)>
<!---<cf_dump var="">--->

<cfquery name="rsFuncXDepto" datasource="#session.DSN#">
		select  DE.DEidentificacion
				,<cf_dbfunction name="concat" args="DE.DEapellido1+' '+DE.DEapellido2+'  '+DE.DEnombre" delimiters="+"> as Nombre			
				,jor.RHJdescripcion as jornada
				,puestos.RHPdescpuesto as puesto
								
			,coalesce(( DLab.DLporcplaza +  coalesce((select  coalesce(sum(LTRecar.LTporcplaza),0)  from LineaTiempoR LTRecar  where  LTRecar.DEid = DLab.DEid group by LTRecar.DEid ) ,0) ),0 )as sumaPorcPlaza
			 ,CFunc.CFid
		
		from RHTipoAccion TAcc,
			DatosEmpleado de,
			 LineaTiempo lt, 
				DLaboralesEmpleado DLab
				
			inner join RHPuestos puestos
				on puestos.RHPcodigo = DLab.RHPcodigo
				and puestos.Ecodigo  = DLab.Ecodigo
				
			inner join RHJornadas jor
				on jor.RHJid = DLab.RHJid
				and jor.Ecodigo = DLab.Ecodigo
				
			inner join DatosEmpleado DE
				on DE.DEid = DLab.DEid
				and DE.Ecodigo = DLab.Ecodigo
		
			inner join RHPlazas PLZ
				on PLZ.RHPid = DLab.RHPid
				and PLZ.Ecodigo = DLab.Ecodigo
			
					inner join CFuncional CFunc
					on CFunc.CFid = PLZ.CFid
					and  CFunc.Ecodigo = PLZ.Ecodigo
					<cfif isdefined('form.CFid')>
						and CFunc.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
					</cfif>
			
		where <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">  between lt.LTdesde and lt.LThasta
		and lt.Ecodigo = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		
		and de.Ecodigo = lt.Ecodigo
		and de.DEid = lt.DEid
		
		and DLab.Ecodigo = lt.Ecodigo
		and DLab.DEid = lt.DEid	
		and DLab.DLfvigencia <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Nuevafecha#">
		
		and TAcc.Ecodigo = DLab.Ecodigo
		and TAcc.RHTid = DLab.RHTid
		and TAcc.RHTcomportam = 1 <!--- Para las acciones de tipo nombramiento --->
		and TAcc.RHTtiponomb = 0 <!--- Tipo de nombramiento permanente --->
		
		order by <cf_dbfunction name="concat" args="DE.DEapellido1+' '+DE.DEapellido2+'  '+DE.DEnombre" delimiters="+">
</cfquery>
<!---<cf_dump var="#rsFuncXDepto#">--->

<cfquery name="rsConPorcenM50" dbtype="query">
	select *
	from rsFuncXDepto
	where sumaPorcPlaza > 50
</cfquery>
	
<!---<cf_dump var="#rsConPorcenM50#">--->


<!----================ PINTA EL REPORTE ================---->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ReporteDeDeduccionesAsoc" Default="Reporte de las deducciones de la Asociaci&oacute;n Solidarista " returnvariable="LB_ReporteDeDeduccionesAsoc"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ReporteFuncXDepto" Default="Reporte funcionarios de departamento" returnvariable="LB_ReporteFuncXDepto"/>

<cfinclude template="RepFuncXDepto-rep.cfm">