<!---<cf_dump var="#form#">--->

<cf_dbfunction name="OP_concat" returnvariable="CAT" >
	<cfquery name="rsPlazaPresup" datasource="#session.DSN#">
		Select 
			 Escenarios.RHEdescripcion  as planilla
			,tabFormula.RHPPid
			,Escenarios.RHEid 		
			,Cfunc.CFdescripcion as unidad        
			,Ofc.Odescripcion  
			,Ofc.Oficodigo
			,tabFormula.fdesdeplaza 
			,tabFormula.fhastaplaza
			,Puestos.RHPcodigo
			,Puestos.RHPdescpuesto 
			,Plz.RHPcodigo as codigoPlz	  
			, Plz.RHPid
			,tabFormula.RHFid 
			,Escenarios.RHEid
			 , (case when Plz.CFidconta  is null then  Cfunc.CFcodigo
	else  (select CFcodigo  from  CFuncional where CFid =Plz.CFidconta  )  end) as  centroCostos
			,DEmp.DEidentificacion
			,DEmp.DEapellido1 #CAT# ' ' #CAT# DEmp.DEapellido1 #CAT# ' ' #CAT#  DEmp.DEapellido2 as Nombre 		
			,jorna.RHJcodigo
		
			
		from RHFormulacion tabFormula			
			,RHEscenarios Escenarios
			,RHPlazaPresupuestaria PlzPresup
			,RHPlazas Plz
			,RHPuestos Puestos
			,CFuncional Cfunc
			,Oficinas  Ofc
			
			,LineaTiempo LTiempo 
			,DatosEmpleado DEmp
			,RHJornadas jorna
			
		where tabFormula.RHEid = Escenarios.RHEid 
		and tabFormula.Ecodigo =  Escenarios.Ecodigo 
		<cfif isdefined('form.RHEID') and len(trim(form.RHEID))>
			and Escenarios.RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEID#">
		</cfif>	
		<!--- Con Escenarios Activos--->
		and Escenarios.RHEestado='A' 
		and Escenarios.Ecodigo =<cfqueryparam  cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		
		and PlzPresup.Ecodigo = tabFormula.Ecodigo
		and PlzPresup.RHPPid = tabFormula.RHPPid 
		<cfif isdefined('form.RHPPIDD') and isdefined('form.RHPPIDH') and len(trim(form.RHPPIDD)) and len(trim(form.RHPPIDH)) >
			and PlzPresup.RHPPid between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPPIDD#"> and  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPPIDH#"> 
		<cfelseif isdefined('form.RHPPIDD') and len(trim(form.RHPPIDD))>				
			and PlzPresup.RHPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPPIDD#">		
		</cfif>
				
		and Plz.Ecodigo = PlzPresup.Ecodigo
		and Plz.RHPPid = PlzPresup.RHPPid 
		
		and Puestos.Ecodigo =  Plz.Ecodigo
		and Puestos.RHPcodigo   = Plz.RHPpuesto
		
		and Cfunc.Ecodigo = Plz.Ecodigo
		and Cfunc.CFid = Plz.CFid
		
		<!--- Filtra por la Unidad --->
		<cfif isdefined('form.CFid') and len(trim(form.CFid))>
			and Cfunc.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
		</cfif>
		
		and Ofc.Ecodigo = Cfunc.Ecodigo
		and Ofc.Ocodigo = Cfunc.Ocodigo
		
		and LTiempo.Ecodigo =<cfqueryparam  cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and getdate() between  LTiempo.LTdesde and LTiempo.LThasta
		and LTiempo.RHPid = Plz.RHPid
							
		and DEmp.Ecodigo =  LTiempo.Ecodigo 
		and DEmp.DEid =  LTiempo.DEid
							
		and jorna.Ecodigo =   LTiempo.Ecodigo 
		and jorna.RHJid =  LTiempo.RHJid
				
	</cfquery>
<!---<cf_dump var="#rsPlazaPresup#">--->
	


<!----================ PINTA EL REPORTE ================---->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>
<cfinclude template="DetallComponentesXPlazaPresup-rep.cfm">