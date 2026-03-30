
<!---<cf_dump var="#form#">--->
<cfif isdefined('form.FECHA')>
	<cfset nuevaFecha= DateFormat(#form.FECHA#, "mmmm d, yyyy")>
</cfif>

<cfquery name="rsGastadoXPlanillaCFunc" datasource="#session.DSN#">
		Select  
			  HCalNom.Tcodigo		
			,HCalNom.RCDescripcion
			,HCalNom.RCdesde
			,HCalNom.RChasta		
			,HCalNom.RCNid					
			,plz.CFid 
			,CFunc.CFdescripcion 
			,ofic.Odescripcion 
			,Dpto.Deptocodigo 
			,Dpto.Ddescripcion 
			,sum(PEmontores) as montoSalBase 
			
		from CalendarioPagos calPago	
			,HRCalculoNomina HCalNom	
			,HSalarioEmpleado sqlEmpl 
			,HPagosEmpleado HPagos 
			,RHPlazas plz
			,CFuncional CFunc
			,Oficinas ofic
			,Departamentos Dpto 
					 
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
				
		and HCalNom.Ecodigo = calPago.Ecodigo
		and HCalNom.RCNid = calPago.CPid
		
		and sqlEmpl.RCNid = HCalNom.RCNid 
		
		and HPagos.RCNid = sqlEmpl.RCNid
		and HPagos.DEid = sqlEmpl.DEid
		
		and plz.Ecodigo = calPago.Ecodigo 
		and plz.RHPid = HPagos.RHPid
		
		and CFunc.Ecodigo =calPago.Ecodigo 
		and CFunc.CFid =  plz.CFid
		
		and ofic.Ecodigo = calPago.Ecodigo 
		and ofic.Ocodigo = HPagos.Ocodigo
		
		and Dpto.Ecodigo = calPago.Ecodigo 
		and Dpto.Dcodigo = HPagos.Dcodigo 
		
		group by  
				 HCalNom.Tcodigo		
				,HCalNom.RCDescripcion
				,HCalNom.RCdesde
				,HCalNom.RChasta
				,HCalNom.RCNid
				,plz.CFid
				,CFunc.CFdescripcion 
				,ofic.Odescripcion  
				,Dpto.Deptocodigo 
				,Dpto.Ddescripcion 
			
		order by  
				HCalNom.Tcodigo		
				,HCalNom.RCDescripcion
				,HCalNom.RCdesde
				,HCalNom.RChasta
				,HCalNom.RCNid
				,plz.CFid
				,CFunc.CFdescripcion 
				,ofic.Odescripcion  
				,Dpto.Deptocodigo 
				,Dpto.Ddescripcion 		
								
</cfquery>
<!---<cf_dump var="#rsGastadoCompXPlz#">--->

<!----================ PINTA EL REPORTE ================---->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>
<cfinclude template="ReporteGastadporPlanillaXCentroFunc-rep.cfm">

	

