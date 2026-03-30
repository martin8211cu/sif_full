<!---<cf_dump var="#form#">--->
<cfif isdefined("url.FechaPublic")>
	<cfset form.FechaPublic = url.FechaPublic >
</cfif>
<cfif isdefined("url.RHPcodigo")>
	<cfset form.RHPcodigo = url.RHPcodigo>
</cfif>



<cfset Fecha= DateFormat(#form.FechaPublic#, "dd/mm/yyyy") >
<cfset Nuevafecha = DateAdd('m', -6, #Fecha#)>
<!---<cf_dump var="">--->

<cfquery name="rsFuncXDepto" datasource="#session.DSN#">
		select  DE.DEidentificacion
				,<cf_dbfunction name="concat" args="DE.DEapellido1+' '+DE.DEapellido2+'  '+DE.DEnombre" delimiters="+"> as Nombre
				,jor.RHJdescripcion as jornada
				,puestos.RHPcodigo
				,puestos.RHPdescpuesto as puesto
				,CFunc.CFdescripcion as escuela
				,ofic.Odescripcion as sede
			,coalesce(( DLab.DLporcplaza +  coalesce((select  coalesce(sum(LTRecar.LTporcplaza),0)  from LineaTiempoR LTRecar  where  LTRecar.DEid = DLab.DEid group by LTRecar.DEid ) ,0) ),0 )as sumaPorcPlaza
			 ,CFunc.CFid

		from RHTipoAccion TAcc,
			 LineaTiempo lt,
			DatosEmpleado DE
			inner join DLaboralesEmpleado DLab
				on DE.DEid = DLab.DEid
				and DE.Ecodigo = DLab.Ecodigo

			inner join Oficinas ofic
				on 	ofic.Ocodigo = DLab.Ocodigo
				and ofic.Ecodigo = DLab.Ecodigo

			inner join RHPuestos puestos
				on puestos.RHPcodigo = DLab.RHPcodigo
				and puestos.Ecodigo  = DLab.Ecodigo
				 <cfif isdefined('form.RHPcodigo') >
					and puestos.RHPcodigo =<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPcodigo#" >
				 </cfif >
			inner join RHJornadas jor
				on jor.RHJid = DLab.RHJid
				and jor.Ecodigo = DLab.Ecodigo


			inner join RHPlazas PLZ
				on PLZ.RHPid = DLab.RHPid
				and PLZ.Ecodigo = DLab.Ecodigo

					inner join CFuncional CFunc
					on CFunc.CFid = PLZ.CFid
					and  CFunc.Ecodigo = PLZ.Ecodigo


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

		order by CFunc.CFdescripcion, <cf_dbfunction name="concat" args="DE.DEapellido1+' '+DE.DEapellido2+'  '+DE.DEnombre" delimiters="+">
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


<cfinclude template="RepFuncProfesor-rep.cfm">