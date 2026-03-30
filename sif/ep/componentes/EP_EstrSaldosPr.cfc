<!--- 	
	Realizado por: Ernesto Raúl Bravo Gómez
	Fecha : 07/Junio/2013
	Motivo:	Creación de la tabla temporal para los reportes de saldos presupuestales
--->

<cfcomponent output="no">
	<cffunction name="CG_EstructuraSaldo" access="public" output="no" returntype="string">
		<cfargument name="IDEstrPro" 	type="numeric" 	required="yes">
		<cfargument name="PerInicio" 	type="numeric" 	required="yes">
		<cfargument name="MesInicio" 	type="numeric" 	required="yes">
		<cfargument name="PerFin" 		type="numeric" 	required="yes">
		<cfargument name="MesFin" 		type="numeric" 	required="yes">	
		<cfargument name="PerIniPP" 	type="numeric" 	required="yes">
		<cfargument name="MesIniPP" 	type="numeric" 	required="yes">				
		<cfargument name='MonedaLoc' 	type='boolean' 	required="yes">
		<cfargument name="Mcodigo" 		type="numeric" 	required="no">	
		<cfargument name="GvarConexion" type="string"   required="yes">
		
 		<cfset FechaCreacion = #dateFormat(now(),"DDMMYYYYHHMMSSSS")#>
		<cfset TablaTem = 'SaldosEstr'&#FechaCreacion#>
        		
 		<cf_dbtemp name="#TablaTem#" returnVariable="SaldosEstr" datasource="#GvarConexion#">
			<cf_dbtempcol name="ID_GpoCat"    		type="int" >
            <cf_dbtempcol name="ID_Grupo"    		type="int" >
			<cf_dbtempcol name="ID_EstrPro"    		type="int" >
			<cf_dbtempcol name="ID_EstrCtaVal"    	type="int" >
			<cf_dbtempcol name="Ecodigo"    		type="int" >			
			<cf_dbtempcol name="Cmayor"  			type="char(4)" >
			<cf_dbtempcol name="Cformato"  			type="varchar(100)" >			
			<cf_dbtempcol name="Ccuenta"			type="varchar(100)"	>
			<cf_dbtempcol name="CPCpresupuestado"	type="money" >
			<cf_dbtempcol name="CPCpresup_Anual"	type="money" >
            <cf_dbtempcol name="CPCmodificado"		type="money" >
            <cf_dbtempcol name="CPCmodificacion_Excesos"	type="money" >
            <cf_dbtempcol name="CPCvariacion"		type="money" >
            <cf_dbtempcol name="CPCtrasladado"		type="money" >
            <cf_dbtempcol name="CPCreservado_Anterior"		type="money" >
            <cf_dbtempcol name="CPCcomprometido_Anterior"	type="money" >
            <cf_dbtempcol name="CPCreservado_Presupuesto"	type="money" >
            <cf_dbtempcol name="CPCreservado"		type="money" >
            <cf_dbtempcol name="CPCcomprometido"	type="money" >
            <cf_dbtempcol name="CPCnrpsPendientes"	type="money" >
            <cf_dbtempcol name="CPCejecutado"		type="money" >
            <cf_dbtempcol name="CPCpagado"			type="money" >
            <cf_dbtempcol name="CPCtrasladadoE"		type="money" >
            <cf_dbtempcol name="CPCautsPendientes"	type="money" >
            <cf_dbtempcol name="CPCejercido"		type="money" >
            <cf_dbtempcol name="CPCejecutadoNC"		type="money" >
            
            <cf_dbtempcol name="CPCmodificadoAnual"	type="money" >
            <cf_dbtempcol name="CPCmodif_ExcAnual"	type="money" >
            <cf_dbtempcol name="CPCtras_Anual"		type="money" >
            <cf_dbtempcol name="CPCtrasE_Anual"		type="money" >
			<cf_dbtempcol name="CPCpresupPeriodo"	type="money" >
            
            
			<cf_dbtempcol name="PCDcatid"    		type="int">
			<cf_dbtempcol name="PCDvalor" 	 		type="varchar(20)" >
			<cf_dbtempcol name="PCDdescripcion" 	type="varchar(100)" >
			<cf_dbtempcol name="ClasCatCon" 		type="int">
			<cf_dbtempcol name="PCDcatidH"    		type="int">
			<cf_dbtempcol name="PCDvalorH" 	 		type="varchar(20)" >
			<cf_dbtempcol name="PCDdescripcionH" 	type="varchar(100)" >
			<cf_dbtempcol name="SoloHijos" 			type="bit"  default="0">
            
		</cf_dbtemp>
		
		<!----Parametro si es moneda local
		<cfquery datasource="#Gvarconexion#" name="rsMonLoc">
			select m.Mcodigo
            from Monedas m
	        inner join Empresas e
    	    on m.Ecodigo = e.Ecodigo
   	        and m.Mcodigo = e.Mcodigo
       	    and e.Ecodigo = <cfqueryparam cfsqltype ="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		--->
        
		<cfquery datasource="#GvarConexion#" name="rsSaldos">
				insert into #SaldosEstr# (ID_GpoCat, ID_Grupo, ID_EstrPro, ID_EstrCtaVal, Ecodigo, Cmayor, Cformato, Ccuenta,
                CPCpresupuestado,CPCpresup_Anual,CPCmodificado,CPCmodificacion_Excesos,CPCvariacion,CPCtrasladado,CPCreservado_Anterior,
                CPCreservado_Presupuesto,CPCreservado,CPCcomprometido,CPCnrpsPendientes,CPCejecutado,CPCpagado,CPCtrasladadoE,
                CPCautsPendientes,CPCejercido,CPCejecutadoNC,CPCmodificadoAnual,CPCmodif_ExcAnual,CPCtras_Anual,CPCtrasE_Anual,CPCpresupPeriodo,
                
                PCDcatid, PCDvalor, PCDdescripcion,ClasCatCon, SoloHijos,PCDcatidH,PCDvalorH, PCDdescripcionH)	
                
				select distinct X.ID_Grupo, gcm.ID_Grupo, cge.ID_Estr, X.ID_EstrCtaVal, c.Ecodigo, c.Cmayor, c.CPformato, c.CPcuenta,
                 
				CPCpresupuestado = isnull((select SUM(CPCpresupuestado) from CPresupuestoControl 
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerIniPP#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
                                    
								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesIniPP#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
                                    
                                and CPcuenta = c.CPcuenta)
                                ,0.00),
				CPCpresup_Anual = isnull((select SUM(CPCpresupuestado) from CPresupuestoControl 
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerIniPP#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
                                    
<!---								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesIniPP#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
--->                                    
                                and CPcuenta = c.CPcuenta)
                                ,0.00),
                                
				CPCmodificado = isnull((select SUM(CPCmodificado) from CPresupuestoControl 
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
                                and CPcuenta = c.CPcuenta)
                                ,0.00),
				CPCmodificacion_Excesos = isnull((select SUM(CPCmodificacion_Excesos) from CPresupuestoControl 
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
                                and CPcuenta = c.CPcuenta)
                                ,0.00),
				CPCvariacion = isnull((select SUM(CPCvariacion) from CPresupuestoControl 
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
                                and CPcuenta = c.CPcuenta)
                                ,0.00),
				CPCtrasladado = isnull((select SUM(CPCtrasladado) from CPresupuestoControl 
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
                                and CPcuenta = c.CPcuenta)
                                ,0.00),
				CPCreservado_Anterior = isnull((select SUM(CPCreservado_Anterior) from CPresupuestoControl 
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
                                and CPcuenta = c.CPcuenta)
                                ,0.00),
				CPCreservado_Presupuesto = isnull((select SUM(CPCreservado_Presupuesto) from CPresupuestoControl 
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
                                and CPcuenta = c.CPcuenta)
                                ,0.00),
				CPCreservado = isnull((select SUM(CPCreservado) from CPresupuestoControl 
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
                                and CPcuenta = c.CPcuenta)
                                ,0.00),
				CPCcomprometido = isnull((select SUM(CPCcomprometido) from CPresupuestoControl 
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
                                and CPcuenta = c.CPcuenta)
                                ,0.00),
				CPCnrpsPendientes = isnull((select SUM(CPCnrpsPendientes) from CPresupuestoControl 
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
                                and CPcuenta = c.CPcuenta)
                                ,0.00),
				CPCejecutado = isnull((select SUM(CPCejecutado) from CPresupuestoControl 
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
                                and CPcuenta = c.CPcuenta)
                                ,0.00),
                                
				CPCpagado = isnull((select SUM(CPCpagado) from CPresupuestoControl 
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
                                and CPcuenta = c.CPcuenta)
                                ,0.00),
				CPCtrasladadoE = isnull((select SUM(CPCtrasladadoE) from CPresupuestoControl 
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
                                and CPcuenta = c.CPcuenta)
                                ,0.00),
				CPCautsPendientes = isnull((select SUM(CPCautsPendientes) from CPresupuestoControl 
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
                                and CPcuenta = c.CPcuenta)
                                ,0.00),
				CPCejercido = isnull((select SUM(CPCejercido) from CPresupuestoControl 
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
                                and CPcuenta = c.CPcuenta)
                                ,0.00),
				CPCejecutadoNC = isnull((select SUM(CPCejecutadoNC) from CPresupuestoControl 
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
                                and CPcuenta = c.CPcuenta)
                                ,0.00),
				CPCmodificadoAnual = isnull((select SUM(CPCmodificado) from CPresupuestoControl 
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerIniPP#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
                                    
<!---								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesIniPP#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
--->                                    
                                and CPcuenta = c.CPcuenta)
                                ,0.00),
				CPCmodif_ExcAnual = isnull((select SUM(CPCmodificacion_Excesos) from CPresupuestoControl 
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerIniPP#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
                                    
<!---								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesIniPP#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
--->                                    
                                and CPcuenta = c.CPcuenta)
                                ,0.00),
				CPCtras_Anual = isnull((select SUM(CPCtrasladado) from CPresupuestoControl 
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerIniPP#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
                                    
<!---								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesIniPP#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
--->                                    
                                and CPcuenta = c.CPcuenta)
                                ,0.00),
				CPCtrasE_Anual = isnull((select SUM(CPCtrasladadoE) from CPresupuestoControl 
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerIniPP#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
                                    
<!---								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesIniPP#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
--->                                    
                                and CPcuenta = c.CPcuenta)
                                ,0.00),
				CPCpresupPeriodo = isnull((select SUM(CPCpresupuestado) from CPresupuestoControl 
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
                                and CPcuenta = c.CPcuenta)
                                ,0.00),
                                
                X.PCDcatid, X.PCDvalor, X.PCDdescripcion,0, SoloHijos = isnull(X.SoloHijos,0), Y.PCDcatidref, 
                Y.PCDvalor, Y.PCDdescripcion
                
				from CGEstrProgCtaM cge
                
				left join CPresupuesto c on cge.CGEPCtaMayor = c.Cmayor
                
				left join CPresupuestoControl sc on sc.CPcuenta = c.CPcuenta  
                
				left join CGGrupoCtasMayor gcm on gcm.ID_Grupo = cge.ID_Grupo and gcm.ID_Estr = cge.ID_Estr
                
				left join (select distinct c.Cmayor, c.CPformato, c.CPcuenta, sc.CPCmes, sc.CPCano, cc.PCDvalor, cc.PCDdescripcion,                            epvd.ID_EstrCtaVal, epvd.PCDcatid, epv.ID_Grupo, epv.SoloHijos 
			 			    from CGEstrProgCtaM cge
                            
						    inner join CPresupuesto c on cge.CGEPCtaMayor = c.Cmayor                             
							inner join PCDCatalogoCuentaP nm on nm.CPcuenta = c.CPcuenta                             
							inner join CPresupuestoControl sc on sc.CPcuenta = c.CPcuenta
                            
							inner join CGDEstrProgVal epvd on epvd.PCDcatid = nm.PCDcatid	
							inner join CGEstrProgVal epv on epv.ID_EstrCtaVal = epvd.ID_EstrCtaVal
						   	and epv.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEstrPro#">
                            		 
			 				inner join PCDCatalogo cc on cc.PCDcatid = epvd.PCDcatid
                             
							where cge.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEstrPro#">
							and c.CPmovimiento = 'S'
							and sc.CPCmes between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#"> 
							and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#"> 							
							and sc.CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#"> 
							and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">) 
                            as X on X.CPcuenta = c.CPcuenta and 																				                            X.CPformato = c.CPformato 	
                            
				left join (select distinct c.Cmayor, c.CPformato, c.CPcuenta, sc.CPCmes, sc.CPCano, cc.PCDvalor, cc.PCDdescripcion,                            epvd.PCDcatidref
						    from CGEstrProgCtaM cge
						    inner join CPresupuesto  c on cge.CGEPCtaMayor = c.Cmayor 
							inner join PCDCatalogoCuentaP nm on nm.CPcuenta = c.CPcuenta 
                            
							inner join CPresupuestoControl sc on sc.CPcuenta = c.CPcuenta
                            
							inner join CGDDetEProgVal epvd on epvd.PCDcatidref = nm.PCDcatid	
							inner join CGEstrProgVal epv on epv.ID_EstrCtaVal = epvd.ID_EstrCtaVal 
							and epv.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEstrPro#">
                             
							inner join PCDCatalogo cc on cc.PCDcatid = epvd.PCDcatidref
                            
							where cge.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEstrPro#">
							and c.CPmovimiento = 'S'
							and sc.CPCmes between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#"> 
							and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#"> 							
							and sc.CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#"> 
							and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">) 
                            as Y on Y.CPcuenta = c.CPcuenta and 																				                            Y.CPformato = c.CPformato 	
                            	
				where sc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and cge.ID_Estr =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEstrPro#"> 
				and c.CPmovimiento = 'S'
				and sc.CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#"> 
				and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#"> 
				and sc.CPCmes between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#"> 
				and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#"> 
		</cfquery>
		<!---Elimina las cuentas que se deben incluir o excluir por cuenta de mayor--->
		<cfquery name="rsCtasIncExcl" datasource="#GvarConexion#">
			select distinct cc.Cformato, epc.Ccuenta, cge.CGEPCtaMayor, cge.CGEPInclCtas 
			from CGEstrProgCtaM cge 
			inner join CGEstrProgCtaD epc on epc.ID_Estr = cge.ID_Estr
			inner join CContables cc on epc.Ccuenta = cc.Ccuenta and substring(Cformato,1,4) = cge.CGEPCtaMayor
			where 
			cc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and cge.ID_Estr =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEstrPro#"> 				
		</cfquery>
		
		<cfquery name="rsSaldos" datasource="#GvarConexion#">
			select * from #SaldosEstr#
		</cfquery>
		
		
		<cfif rsCtasIncExcl.recordcount GT 0>
			<cfloop query="rsCtasIncExcl">
				<cfif rsCtasIncExcl.CGEPInclCtas EQ 2>
					<cfquery datasource="#GvarConexion#">
						delete #SaldosEstr#
						where Cmayor = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCtasIncExcl.CGEPCtaMayor#">
                        
						and Ccuenta not in (select epc.Ccuenta 
											from CGEstrProgCtaM cge 
											inner join CGEstrProgCtaD epc on epc.ID_Estr = cge.ID_Estr
                                            
											inner join CPresupuesto cc on epc.Ccuenta = cc.CPcuenta and substring(CPformato,1,4) = cge.CGEPCtaMayor
                                            
											where cc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
											and cge.ID_Estr =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEstrPro#"> 		
											and cge.CGEPCtaMayor = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCtasIncExcl.CGEPCtaMayor#">)
					</cfquery>
				<cfelseif rsCtasIncExcl.CGEPInclCtas EQ 3>
					<cfquery datasource="#session.dsn#">
						delete #SaldosEstr#
						where Cmayor = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCtasIncExcl.CGEPCtaMayor#">
						and Ccuenta in (select epc.Ccuenta 
										from CGEstrProgCtaM cge 
										inner join CGEstrProgCtaD epc on epc.ID_Estr = cge.ID_Estr
                                        
										inner join CPresupuesto cc on epc.Ccuenta = cc.CPcuenta and substring(CPformato,1,4) = cge.CGEPCtaMayor
                                        
										where cc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
										and cge.ID_Estr =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEstrPro#"> 		
										and cge.CGEPCtaMayor = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCtasIncExcl.CGEPCtaMayor#">)
					</cfquery>						
				</cfif>
			</cfloop>
		</cfif>
		
		<cfquery name="ClasifiCatCon" datasource="#GvarConexion#">
			select PCEcatidClasificado as PCEcatid
			from CGEstrProg
			where ID_Estr =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEstrPro#">
		</cfquery>
		
		<cfquery name="CtasMayorEstr" datasource="#GvarConexion#">
			select distinct Cmayor
			from #SaldosEstr#
		</cfquery>
		
		<cfif isdefined("ClasifiCatCon") and ClasifiCatCon.PCEcatid NEQ 0>
			<cfloop query="CtasMayorEstr">
				<cfquery datasource="#GvarConexion#">	
			<!--- select distinct nm.PCDcatid, nm.PCEcatid, cd.PCCDvalor, PCCDclaid, cd.PCCDdescripcion, s.Cformato --->
			    	 update #SaldosEstr# set ClasCatCon = cc.PCCDclaid
					 from CGEstrProg ep 
					 inner join #SaldosEstr# s on s.ID_EstrPro = ep.ID_Estr
                     
					 inner join PCDCatalogoCuentaP nm on nm.CPcuenta = s.Ccuenta 
                     			 
					 inner join PCDClasificacionCatalogo cc on cc.PCDcatid = nm.PCDcatid  ---and c.PCDcatid = nm.PCDcatid
                     
					 inner join PCClasificacionD cd on cd.PCCEclaid = cc.PCCEclaid and cc.PCCDclaid = cd.PCCDclaid
					 where s.Cmayor = <cfqueryparam cfsqltype="cf_sql_integer" value="#CtasMayorEstr.Cmayor#">
					 and ep.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEstrPro#">
					 and ep.PCEcatidClasificado != 0
					 and nm.PCEcatid = <cfqueryparam cfsqltype="cf_sql_integer" value="#ClasifiCatCon.PCEcatid#"> 
				</cfquery>
			</cfloop>
		</cfif>
	
    	<!---ELIMINA VALORES DEL PCDCatalogo QUE NO ESTAN EN LA ESTRUCTURA PROGRAMATICA --->
        <cfquery datasource="#GvarConexion#" name="RSElimina">
        	delete
            from #SaldosEstr#
            where coalesce(PCDcatid,'0') not in 
            	(select a.PCDcatid 
            	 from CGDEstrProgVal a
                 	inner join CGEstrProgVal b
                    on a.ID_EstrCtaVal = b.ID_EstrCtaVal and b.ID_Estr = #SaldosEstr#.ID_EstrPro)
			and ID_EstrPro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDEstrPro#">
        </cfquery>

        <!---ELIMINA HIJOS CUANDO LA ESTRUCTURA PROGRAMATICA CONTIENE HIJOS--->
		<cf_dbfunction name="op_concat" datasource="#GvarConexion#" returnvariable="_Cat">
        <cfquery datasource="#GvarConexion#" name="RSElimina">
        	delete
            from #SaldosEstr#
           where convert(varchar,coalesce(PCDcatid,'0')) #_Cat# '-' #_Cat# convert(varchar,coalesce(PCDcatidH,'0')) not in 
            (select convert(varchar,coalesce(b.PCDcatid,'0')) #_Cat# '-' #_Cat# convert(varchar,coalesce(a.PCDcatidref,'0'))
             from CGDDetEProgVal a
				inner join CGDEstrProgVal b
                 	inner join CGEstrProgVal c
                    on b.ID_EstrCtaVal = c.ID_EstrCtaVal and c.SoloHijos = 1
                on a.ID_DEstrCtaVal = b.ID_DEstrCtaVal 
             where c.ID_Estr = #SaldosEstr#.ID_EstrPro
             and b.PCDcatid = #SaldosEstr#.PCDcatid)
             and #SaldosEstr#.ID_EstrPro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDEstrPro#">
			 and #SaldosEstr#.SoloHijos = 1
        </cfquery>
	<cfreturn SaldosEstr>
	</cffunction>
	
	<cffunction name="CG_EstructuraMovimientos" access="private" output="no">
	</cffunction>	
</cfcomponent>

