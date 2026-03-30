<!---<cf_dump var="#form#">--->
<cfif isdefined('form.FECHA')>
	<cfset nuevaFecha= DateFormat(#form.FECHA#, "mmmm d, yyyy")>
</cfif>

<cfquery name="rsGastadoCompXPlz" datasource="#session.DSN#">
	select  			
		 HCalNom.RCDescripcion 
		,HCalNom.RCdesde
		,HCalNom.RChasta 
		,HPagos.DEid 
		,HPagos.RCNid
		,HPagos.RHPid
		,plz.RHPcodigo
		,plz.RHPdescripcion
		,plz.CFid 
		,ofic.Odescripcion as oficina
		,Dpto.Deptocodigo 
		,Dpto.Ddescripcion 		
		,sum(PEmontores) as montoSalBase
		
	from CalendarioPagos calPago	
		 ,HRCalculoNomina HCalNom
		 ,HPagosEmpleado HPagos 
		 ,RHPlazas plz
		 ,Oficinas ofic
		 ,Departamentos Dpto 
		 ,HSalarioEmpleado sqlEmpl 
	 
	where 
	calPago.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">			
	<cfif isdefined('form.FECHA') and len(trim(form.FECHA))>
		and calPago.CPhasta = <cfqueryparam cfsqltype="cf_sql_date" value="#nuevaFecha#"> 
	</cfif>	
	<cfif isdefined('form.anno') and len(trim(form.anno))>	
		and calPago.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.anno#">
	</cfif>
	 <cfif isdefined('form.CPcodigo' ) and len(trim(form.CPcodigo)) >
		and calPago.CPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rtrim(form.CPcodigo)#">
	</cfif>	
	 <cfif isdefined('form.Tcodigo' ) and len(trim(form.Tcodigo)) >
		and calPago.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Tcodigo#">
	</cfif>	
	
	and HCalNom.RCNid = calPago.CPid 
	
	and sqlEmpl.RCNid = HCalNom.RCNid
	and HPagos.RCNid = sqlEmpl.RCNid
	and HPagos.DEid = sqlEmpl.DEid
	
	and plz.Ecodigo = calPago.Ecodigo 
	and plz.RHPid = HPagos.RHPid
	
	and ofic.Ecodigo = calPago.Ecodigo 
	and ofic.Ocodigo = HPagos.Ocodigo
	
	and Dpto.Ecodigo = calPago.Ecodigo 
	and Dpto.Dcodigo = HPagos.Dcodigo 
	
	group by 
	
			 HCalNom.RCDescripcion,
			 HCalNom.RCdesde,
			 HCalNom.RChasta, 
			 HPagos.RCNid, 
			 HPagos.DEid, 
			 HPagos.RHPid, 			
			 plz.RHPdescripcion,
			 plz.RHPcodigo,
			 plz.CFid,
			 ofic.Odescripcion, 
			 Dpto.Deptocodigo, 
		     Dpto.Ddescripcion
			 
	order by	
	
			 HCalNom.RCDescripcion,
			 HCalNom.RCdesde,
			 HCalNom.RChasta, 
			 HPagos.RCNid, 
			 HPagos.DEid, 
			 HPagos.RHPid, 			
			 plz.RHPdescripcion,
			 plz.RHPcodigo,
			 plz.CFid,
			 ofic.Odescripcion, 
			 Dpto.Deptocodigo, 
		     Dpto.Ddescripcion	
			 	 
</cfquery>
<!---<cf_dump var="#rsGastadoCompXPlz#">--->




<!----================ PINTA EL REPORTE ================---->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>
<cfinclude template="ReporteGastadporplaza-rep.cfm">