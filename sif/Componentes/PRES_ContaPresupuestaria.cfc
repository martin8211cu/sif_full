<cfcomponent>  
	<cf_dbfunction name="op_concat" returnvariable="CAT">

 	<cffunction name="CreaTablas" output="no" returntype="string" access="public">
		<cfargument name='Conexion' type='string' required='false'>

		<cf_dbtemp name="CPGUBP1" returnvariable="ContaGubParam" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="Ecodigo" 			type="numeric"      mandatory="yes">
			<cf_dbtempcol name="TipoPres" 			type="char(1)"      mandatory="yes">
			<cf_dbtempcol name="TipoMov"			type="char(2)"      mandatory="yes">
			<cf_dbtempcol name="Momento"			type="char(1)"      mandatory="yes">
			<cf_dbtempcol name="TipoMovDBCR"		type="char(1)"      mandatory="yes">
			<cf_dbtempcol name="Cmayor"				type="char(4)"      mandatory="yes">
			<cf_dbtempcol name="Sec"				type="int"		    mandatory="yes">
		</cf_dbtemp>

		<cf_dbtemp name="CPGUBM1" returnvariable="ContaGubMovs" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="Ecodigo" 			type="numeric"      mandatory="yes">
			<cf_dbtempcol name="NAP"	 			type="numeric"      mandatory="yes">
			<cf_dbtempcol name="Linea"	 			type="numeric"      mandatory="yes">
			<cf_dbtempcol name="CPcuenta"			type="numeric"      mandatory="yes">
			<cf_dbtempcol name="TipoPres" 			type="char(1)"      mandatory="yes">
			<cf_dbtempcol name="TipoMov"			type="char(2)"      mandatory="yes">
			<cf_dbtempcol name="Momento"			type="char(1)"      mandatory="yes">
			<cf_dbtempcol name="RevMomento"			type="bit"      	mandatory="yes">
			<cf_dbtempcol name="TipoMovDBCR"		type="char(1)"      mandatory="yes">
			<cf_dbtempcol name="Monto"				type="money"      	mandatory="yes">
			<cf_dbtempcol name="CFformato" 			type="varchar(100)" mandatory="yes">
			<cf_dbtempcol name="CFcuenta"			type="numeric"      mandatory="no">
			<cf_dbtempcol name="PCEMid"		 		type="numeric"      mandatory="no">
			<cf_dbtempcol name="CtaOrd"		 		type="int"      mandatory="no">
			
		</cf_dbtemp>
	</cffunction>

	<cffunction name="sbAgregaEnAsiento">
		<cfargument name='Ecodigo'	type='numeric'>
		<cfargument name='NAP'		type='string' default="">
		<cfargument name='CPNAPIid' type='string' default="">
		<cfargument name='Conexion' type='string' required='false'>
<!--- Control Evento Inicia --->                                         
        <cfargument name='NumeroEvento' type='string' required='false' default="">
<!--- Control Evento Fin ---> 
		<cfargument name='Momentos' type='string' required='false' >
        
		<cfset GvarConexion = Arguments.Conexion>

		<cfquery name="rsSQL" datasource="#GvarConexion#">
			select Pvalor
			  from Parametros
			 where Ecodigo = #Arguments.Ecodigo#
			   and Pcodigo = 1140
		</cfquery>  
        
		<cfif rsSQL.Pvalor NEQ "S">
			<cfreturn>
		</cfif>
        
        <cfquery name="rsPreComp" datasource="#GvarConexion#">
        	select Pvalor
			  from Parametros
			 where Ecodigo = #Arguments.Ecodigo#
			   and Pcodigo = 1390
        </cfquery>
		        
		<cfset CreaTablas(GvarConexion)>
		
		<cfif Arguments.CPNAPIid NEQ "">
			<cfquery name="rsNAPs" datasource="#GvarConexion#">
				select n.Ecodigo, n.CPNAPnum, n.CPPid
				  from CPNAPsIntercompany i
				  	inner join CPNAP n
						 on n.Ecodigo	= i.Ecodigo
						and n.CPNAPnum	= i.CPNAPnum
				 where CPNAPIid = #Arguments.CPNAPIid#
                 
			</cfquery>
		<cfelse>
			<cfquery name="rsNAPs" datasource="#GvarConexion#">
				select n.Ecodigo, n.CPNAPnum, n.CPPid
				  from CPNAP n
				 where n.Ecodigo	= #Arguments.Ecodigo#
				   and n.CPNAPnum	= #Arguments.NAP#                  
			</cfquery>
		</cfif>
        
        <!---<cfquery name="rsNAPsDetalle" datasource="#GvarConexion#">
        	select * from CPNAPdetalle n
            where n.Ecodigo	= #Arguments.Ecodigo#
				   and n.CPNAPnum	= #Arguments.NAP#
                   and n.CPNAPDmonto >0
        </cfquery>
        
		<cf_dump var="#rsNAPs#">--->
        
		<cfloop query="rsNAPs">
			<cfset GvarCPPid	= rsNAPs.CPPid>
			<cfset GvarEcodigo	= rsNAPs.Ecodigo>
			<cfset GvarSec = 0>

			<cfquery name="rsSQL" datasource="#GvarConexion#">
				select CPPfechaDesde
				  from CPresupuestoPeriodo
				 where CPPid	= #GvarCPPid#
			</cfquery>
            
			<cfset Lvar2012 = rsSQL.CPPfechaDesde GTE createdate(2012,1,1)>

			<cfset sbInsertEgresos('A',  'A', 'D', 'A')>
			<cfset sbInsertEgresos('M',  'A', 'D', 'M')>
			<cfset sbInsertEgresos('VC', 'A', 'D', 'VC')>

			<cfset sbInsertEgresos('T',  'T', 'D', '*')>
			<cfset sbInsertEgresos('TE', 'T', 'D', '*')>

			<cfif Lvar2012>
            	<cfif  rsPreComp.Pvalor NEQ "S">
                	<!---Aqui  se Elimina  el Momento  Presupuestal  del  Precompromiso,  El Momento 'R' pasa a 'C' en  base al Parámetro--->
					<cfset sbInsertEgresos('RA', 'R', 'RA','D')>
                    <cfset sbInsertEgresos('RC', 'R', 'RC','D')>
                    <cfset sbInsertEgresos('RP', 'R', 'RP','D')>
                    <cfset sbInsertEgresos('CA', 'R', 'RA','D')>
                </cfif>
				<cfif  rsPreComp.recordCount GT 0 and  rsPreComp.Pvalor EQ "S">
					<cfset sbInsertEgresos('CA', 'C', 'RA','D')>
    			</cfif>            
                
				<cfset sbInsertEgresos('CA', 'C', 'CA','RA')>
                
                <cfif Arguments.Momentos EQ 0><!--- Para cuando es necesario generar Precompromiso y Compromiso en  el  CC   --->
					<cfif  rsPreComp.recordCount GT 0 and  rsPreComp.Pvalor EQ "S">
                        <cfset sbInsertEgresos('CC', 'C', 'RC','D')>
                    <cfelse>
                        <cfset sbInsertEgresos('CC', 'R', 'RC','D')>
                    </cfif>
					<cfset sbInsertEgresos('CC', 'C', 'CC','RC')>
                 <cfelseif Arguments.Momentos EQ 1> 
                    <cfif  rsPreComp.recordCount GT 0 and  rsPreComp.Pvalor EQ "S">
                    	<cfset sbInsertEgresos('CC', 'C', 'CC','D')>
                    <cfelse>
                    	<cfset sbInsertEgresos('CC', 'C', 'CC','RC')>    
                    </cfif>    
                <cfelseif  Arguments.Momentos EQ 2>    
                	<cfif  rsPreComp.recordCount GT 0 and  rsPreComp.Pvalor EQ "S">
                    	<cfset sbInsertEgresos('CC', 'C', 'CC','D')>
                    <cfelse>
                    	<cfset sbInsertEgresos('CC', 'C', 'CC','RC')>    
                    </cfif>
                <cfelse>
                	<cfset sbInsertEgresos('CC', 'C', 'CC','RC')>
                </cfif>
				
				<cfif Arguments.Momentos EQ 0 ><!--- Para cuando es necesario generar Precompromiso, Compromiso y Devengado en  el  E   --->
					<cfif  rsPreComp.recordCount GT 0 and rsPreComp.Pvalor EQ "S">
                        <cfset sbInsertEgresos('E',  'C', 'RC','D')>
                    <cfelse>    
                        <cfset sbInsertEgresos('E',  'R', 'RC','D')>
                    </cfif>                
						<cfset sbInsertEgresos('E',  'C', 'CC','RC')>
                        <cfset sbInsertEgresos('E',  'D', 'E', 'CC')>
                	<cfelseif Arguments.Momentos EQ 2>
                    	<cfset sbInsertEgresos('E',  'D', 'E', 'CC')>
                    <cfelseif Arguments.Momentos EQ 3>
                    	<cfif  rsPreComp.recordCount GT 0 and rsPreComp.Pvalor EQ "S">
                        	<cfset sbInsertEgresos('E',  'C', 'CC','D')>
                        <cfelse>
                    		<cfset sbInsertEgresos('E',  'C', 'CC','RC')>
                        </cfif> 
                        <cfset sbInsertEgresos('E',  'D', 'E', 'CC')>   
                </cfif>
                
            <cfelse>
				<cfset sbInsertEgresos('CA', 'C', 'CA','D')>
				<cfset sbInsertEgresos('CC', 'C', 'CC','D')>
	
				<cfset sbInsertEgresos('E',  'C', 'CC','D')>
				<cfset sbInsertEgresos('E',  'D', 'E', 'CC')>
			</cfif>
						
			<cfset sbInsertEgresos('EJ', 'E', 'EJ','E')>
			<cfset sbInsertEgresos('P',  'P', 'P', 'EJ')>
	
			<cfset sbInsertIngresos('A',  'A', 'A', 'D')>
			<cfset sbInsertIngresos('M',  'A', 'M', 'D')>
			<cfset sbInsertIngresos('VC', 'A', 'VC','D')>
			<cfset sbInsertIngresos('T',  'T', '*', 'D')>
			<cfset sbInsertIngresos('TE', 'T', '*', 'D')>
			<cfset sbInsertIngresos('E',  'D', 'D', 'E')>
			<cfset sbInsertIngresos('P',  'P', 'E', 'P')>
		</cfloop>
		
		<cfinvoke 	component			= "PRES_Presupuesto"	
					method				= "fnTipoPresupuesto" 	
					returnvariable		= "LvarTipPres"
					
					CPPid				= "#GvarCPPid#"
					Ctipo				= "my.Ctipo"
					CPresupuestoAlias	= "cp"
					IncluirCOSTOS		= "true"
		/>
		
		<cfquery name="rsEliminaCmayorPC" datasource="#GvarConexion#">
        	select distinct Cmayor from CPtipoMovContable where  CPCCtipo = 'E' and CPTMtipoMov in('RC', 'RA','RP')
        </cfquery>        
        
		<cfloop index="i" from="1" to="2">

			<cfquery datasource="#GvarConexion#">
				insert into #ContaGubMovs# (Ecodigo, NAP, CPcuenta, Linea, TipoMov, Momento, RevMomento, Monto, TipoMovDBCR, TipoPres, CFformato, PCEMid, CtaOrd)
				select 	n.Ecodigo, n.CPNAPnum, n.CPcuenta, 
					<cfif i EQ 1>
						n.CPNAPDlinea, 
						n.CPNAPDtipoMov,
						p.Momento,
						CASE WHEN n.CPNAPDmonto < 0  THEN 1 ELSE 0 END,
						abs(n.CPNAPDmonto),
						CASE 
							WHEN n.CPNAPDmonto >= 0  THEN p.TipoMovDBCR
							WHEN p.TipoMovDBCR = 'D' THEN 'C' ELSE 'D'
						END, 
					<cfelse>
						n.CPNAPDPid, 
						n.CPNAPDPtipoMov,
						p.Momento,
						CASE WHEN n.CPNAPDPmonto < 0 THEN 1 ELSE 0 END,
						abs(n.CPNAPDPmonto),
						CASE 
							WHEN n.CPNAPDPmonto >= 0  THEN p.TipoMovDBCR
							WHEN p.TipoMovDBCR = 'D' THEN 'C' ELSE 'D'
						END, 
					</cfif>
						#preserveSingleQuotes(LvarTipPres)#,
						--- MAYOR DE CUENTA DE ORDEN
						p.Cmayor, vg.PCEMid, 0
				  <cfif Arguments.CPNAPIid NEQ "">
				  from CPNAPsIntercompany ic
					<cfif i EQ 1>
					inner join CPNAPdetalle n
					<cfelse>
					inner join CPNAPdetallePagado n
					</cfif>
						inner join CPresupuesto cp
								inner join CtasMayor my  on my.Ecodigo=cp.Ecodigo and my.Cmayor = cp.Cmayor
								inner join CPVigencia vg on vg.Ecodigo=cp.Ecodigo and vg.CPVid = cp.CPVid
							on cp.CPcuenta = n.CPcuenta
						inner join #ContaGubParam# p
							 on p.Ecodigo	= n.Ecodigo
							and p.TipoPres	= #preserveSingleQuotes(LvarTipPres)#
						<cfif i EQ 1>
							and p.TipoMov	= n.CPNAPDtipoMov
						<cfelse>
							and p.TipoMov	= n.CPNAPDPtipoMov
						</cfif>
					 on n.Ecodigo	= ic.Ecodigo
					and n.CPNAPnum	= ic.CPNAPnum
				 where ic.CPNAPIid = #Arguments.CPNAPIid#
				<cfelse>
					<cfif i EQ 1>
					  from CPNAPdetalle n
					<cfelse>
					  from CPNAPdetallePagado n
					</cfif>
					inner join CPresupuesto cp
							inner join CtasMayor my  on my.Ecodigo=cp.Ecodigo and my.Cmayor = cp.Cmayor
							inner join CPVigencia vg on vg.Ecodigo=cp.Ecodigo and vg.CPVid = cp.CPVid
						on cp.CPcuenta = n.CPcuenta
					inner join #ContaGubParam# p
						 on p.Ecodigo	= n.Ecodigo
						and p.TipoPres	= #preserveSingleQuotes(LvarTipPres)#
					<cfif i EQ 1>
						and p.TipoMov	= n.CPNAPDtipoMov
					<cfelse>
						and p.TipoMov	= n.CPNAPDPtipoMov
					</cfif>
				 where n.Ecodigo	= #Arguments.Ecodigo#
				   and n.CPNAPnum	= #Arguments.NAP#
				</cfif>
                
				   and (SELECT count(1) FROM CPtipoCtas 
				   		 WHERE CPPid = #GvarCPPid# AND Ecodigo = cp.Ecodigo AND Cmayor = cp.Cmayor 
						   AND <cf_dbfunction name="LIKE" args="cp.CPformato,CPTCmascara"> AND CPTCtipo = 'X') = 0
				<cfif  rsPreComp.recordCount GT 0 and rsPreComp.Pvalor EQ 'S' >
                <!---Elimina CmayorPC --->
                	and p.Cmayor not in (select Cmayor from CPtipoMovContable where Ecodigo = #Arguments.Ecodigo# and  CPCCtipo = 'E' and CPTMtipoMov in('RC', 'RA','RP'))  <!--- p.Cmayor <> #rsEliminaCmayorPC.Cmayor#---> 
                </cfif>
                <!--- Condición para  Eliminar las Reversas --->
               <!--- <cfif i EQ 1>
                	and  n.CPNAPDmonto > 0 
                <cfelse>
                	and n.CPNAPDPmonto > 0
                </cfif>--->
                <!--- Hasta Aqui  termina la condición para eliminar  las reversas--->
				<cfif i EQ 1>
					order by n.Ecodigo, n.CPNAPnum, n.CPNAPDlinea, p.Sec
				<cfelse>
					order by n.Ecodigo, n.CPNAPnum, n.CPNAPDPid, p.Sec
				</cfif>
			</cfquery>	
		</cfloop>
		<cfquery datasource="#GvarConexion#" name="rsParams">
			select * from #ContaGubParam#					        
        </cfquery>

		
        
		<cfquery datasource="#GvarConexion#" name="rsCtasOrden">
			select * from #ContaGubMovs#	
            	<cfif rsPreComp.Pvalor EQ 'S' >
                <!---Elimina CmayorPC ---><!---
                	where CFformato not in (select Cmayor from CPtipoMovContable where  CPCCtipo = 'E' and CPTMtipoMov in('RC', 'RA','RP')) <> #rsEliminaCmayorPC.Cmayor#  --->
                </cfif>
		</cfquery>
        	<!---<cf_dump var="#rsPreComp#">--->
			<!---<cf_dump var="#rsParams#">--->
	<!---<cf_dump var="#rsCtasOrden#">--->
    
    
		<cfloop query="rsCtasOrden">
			<cfset LineaN = #rsCtasOrden.Linea#>
			
			<cfquery name="MascaraCta" datasource="#GvarConexion#">
				select PCNid, PCNlongitud, PCNdep, PCNcontabilidad, PCNpresupuesto, PCNdescripcion, Ctipo
				from PCNivelMascara NM
				inner join CtasMayor M on NM.PCEMid = M.PCEMid
				where Cmayor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCtasOrden.CFformato#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCtasOrden.Ecodigo#">
			</cfquery> 


			<cf_dbtemp name="MASCARAP" returnvariable="varMACARAP" datasource="#Arguments.Conexion#">
                    <cf_dbtempcol name="Ecodigo" 			type="numeric"      mandatory="yes">
                    <cf_dbtempcol name="PCEMid" 			type="numeric"      mandatory="yes">
                    <cf_dbtempcol name="PCNid"				type="int"	      	mandatory="yes">
                    <cf_dbtempcol name="PCNidP"				type="int"      	mandatory="yes">
					<cf_dbtempcol name="PCNdep"				type="int"      	mandatory="no">
                    <cf_dbtempcol name="PCNdescripcion"		type="varchar(100)" mandatory="yes">
			</cf_dbtemp>
           
		    <cfquery datasource="#GvarConexion#">
               	insert #varMACARAP# (Ecodigo, PCEMid, PCNid, PCNidP, PCNdep, PCNdescripcion)
                select <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">, 
                PCEMid, PCNid, 0, PCNdep, PCNdescripcion
                from PCNivelMascara 
                where PCEMid = <cfqueryparam  cfsqltype="cf_sql_integer" value="#rsCtasOrden.PCEMid#"> 
                and PCNpresupuesto = 1 
             </cfquery>	
		
			<cfloop query="MascaraCta">
			    <cfquery datasource="#GvarConexion#">
                	declare @nivel int
                    select @nivel = 0
                    update #varMACARAP#
                    set @nivel = @nivel + 1, PCNidP = @nivel
                </cfquery>
                
				<cfquery datasource="#GvarConexion#" name="rsValorM">
					select PCDvalor, PCNdep from #varMACARAP# mk 
					inner join PCDCatalogoCuentaP cubo on cubo.CPcuenta = #rsCtasOrden.CPcuenta# and cubo.PCDCniv = mk.PCNidP
					inner join PCDCatalogo cv on cv.PCDcatid = cubo.PCDcatid
					where mk.PCEMid = <cfqueryparam  cfsqltype="cf_sql_integer" value="#rsCtasOrden.PCEMid#"> 
					and mk.PCNdescripcion like substring('#MascaraCta.PCNdescripcion#',1,CASE WHEN mk.PCNdep IS NULL THEN LEN('#MascaraCta.PCNdescripcion#')
WHEN mk.PCNdep IS NOT NULL THEN CASE CHARINDEX('(','#MascaraCta.PCNdescripcion#') WHEN 0 THEN LEN('#MascaraCta.PCNdescripcion#') ELSE  CHARINDEX('(','#MascaraCta.PCNdescripcion#')END -1 END)#CAT# '%'																				
 				</cfquery>
				
				<cfquery datasource="#GvarConexion#">
					update #ContaGubMovs# set CFformato = CFformato #CAT# '-' #CAT# 
					<cfif rsValorM.PCDvalor NEQ ''>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsValorM.PCDvalor#">
					<cfelse>
						<cfquery name="rsCatConta" datasource="#GvarConexion#">
							select Pvalor, PCEdescripcion
							from Parametros P
							inner join PCECatalogo C on P.Pvalor = C.PCEcatid
							where Pcodigo = 1380
							and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						</cfquery>	
						<cfif isdefined("rsCatConta") and rsCatConta.Pvalor EQ ''>
							<cfthrow message="No se ha definido el Clasificador de Gasto para las Cuentas de Orden">
						</cfif>
											
						<cfquery name="rsValor" datasource="#GvarConexion#">
							select PCCDvalor from #varMACARAP# mk 
							inner join PCDCatalogoCuentaP cubo on cubo.CPcuenta = <cfqueryparam  cfsqltype="cf_sql_integer" value="#rsCtasOrden.CPcuenta#"> and cubo.PCDCniv = mk.PCNidP
							inner join PCDClasificacionCatalogo clv on clv.PCDcatid = cubo.PCDcatid
							inner join PCClasificacionD clvv on clvv.PCCDclaid = clv.PCCDclaid
							where mk.PCEMid= <cfqueryparam  cfsqltype="cf_sql_integer" value="#rsCtasOrden.PCEMid#">  
							and mk.PCNdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCatConta.PCEdescripcion#">
							union
							select ValorDef = right(('XXXXXXXXXX'+convert(varchar,'X')),#MascaraCta.PCNlongitud#)
						</cfquery>
						
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsValor.PCCDvalor#">										
						
					</cfif>
					where substring(CFformato,1,4) = substring (<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCtasOrden.CFformato#">,1,4)
					and Linea = #LineaN#
					and CtaOrd = 0
				</cfquery>
			</cfloop>
			<cfquery datasource="#GvarConexion#">
				update #ContaGubMovs# set CtaOrd = 1
				where substring(CFformato,1,4) = substring (<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCtasOrden.CFformato#">,1,4)
				and Linea = #LineaN#
				and CtaOrd = 0
			</cfquery>
		</cfloop>
		
		<cfquery datasource="#GvarConexion#" name="rsRevCta">
			select CFformato from  #ContaGubMovs#		
		</cfquery>

		<cfloop query="rsRevCta">
			<cfif find('X',#rsRevCta.CFformato#,1)>
				<cfthrow message="No es posible armar la cuenta de Orden: #rsRevCta.CFformato#">
			</cfif>			 
		</cfloop>
		
		<cfquery datasource="#GvarConexion#">
			update #ContaGubMovs#
			   set CFcuenta =
			   			(
							select CFcuenta
							  from CFinanciera
							 where Ecodigo		= #ContaGubMovs#.Ecodigo
							   and CFformato	= #ContaGubMovs#.CFformato
						)
		</cfquery>
		
		<cfquery name="rsCtas" datasource="#GvarConexion#">
			select distinct Ecodigo, CFformato
			  from #ContaGubMovs#
			 where CFcuenta is null
		</cfquery>
				
		<cfloop query="rsCtas">
			<cfinvoke 	component		= "PC_GeneraCuentaFinanciera"
						method			= "fnGeneraCuentaFinanciera"
						returnvariable	= "LvarMSG"
			>
				<cfinvokeargument name="Lprm_Ecodigo" 			value="#rsCtas.Ecodigo#">
				<cfinvokeargument name="Lprm_CFformato" 		value="#rsCtas.CFformato#">
				<cfinvokeargument name="Lprm_fecha" 			value="#now()#">
				<cfinvokeargument name="Lprm_TransaccionActiva" value="true">
			</cfinvoke>
			
			<cfif LvarMSG NEQ "OLD" AND LvarMSG NEQ "NEW">
				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					select Edescripcion
					  from Empresas
					 where Ecodigo = #rsCtas.Ecodigo#
				</cfquery>
				<cfthrow message="ERROR EN CONTABILIDAD PRESUPUESTARIA #rsSQL.Edescripcion#: #LvarMSG#">
			</cfif>
		</cfloop>

		<cfquery datasource="#GvarConexion#">
			update #ContaGubMovs#
			   set CFcuenta =
			   			(
							select CFcuenta
							  from CFinanciera
							 where Ecodigo		= #ContaGubMovs#.Ecodigo
							   and CFformato	= #ContaGubMovs#.CFformato
						)
			 where CFcuenta is null
		</cfquery>
		<!---<cf_dumpTable var = "#ContaGubMovs#">--->
        
		<!--- Creacion y generación automática de la poliza presupuestal:  esto debería indicarse en CreaIntPresuesto para que la tabla temporal se cree fuera de la transaccion --->
		<cfif not isdefined("request.INTARC")>
			<cfset request.PRES_ContaPresupuestaria = true>
			<cfinvoke 	component="CG_GeneraAsiento"
						method="CreaIntarc" 
						CrearPresupuesto = "false"
			/>
		</cfif>

	
		<cfquery datasource="#session.dsn#">
			insert into #request.INTARC# 
				( 
					INTORI, INTREL, INTDOC, INTREF, 
					INTFEC, Periodo, Mes, Ocodigo, 
					INTTIP, INTDES, 
					CFcuenta, Ccuenta, 
					Mcodigo, 
					INTMOE, INTCAM, INTMON
<!--- Control Evento Inicia --->                                         
                     ,NumeroEvento
<!--- Control Evento Fin --->                                         
				)
			select
					nap.CPNAPmoduloOri, 1, nap.CPNAPdocumentoOri, nap.CPNAPreferenciaOri,
					<cf_dbfunction name="date_format" args="nap.CPNAPfecha,YYYYMMDD">,nap.CPCano, nap.CPCmes, 
					(select min(Ocodigo) from Oficinas where Ecodigo=i.Ecodigo), 
					i.TipoMovDBCR, 
					CASE 
						WHEN i.Momento = 'T' and i.RevMomento = 1 THEN 'ORI.'
						WHEN i.RevMomento = 1 then 'REV.' 
						ELSE rtrim(' ') 
					END
					#CAT#
					CASE i.Momento
						WHEN 'A' THEN 'AUTORIZADO: '
						WHEN 'T' THEN 'TRASLADO: '
						WHEN 'R' THEN 'PRECOMPROMISO: '
						WHEN 'C' THEN 'COMPROMISO: '
						WHEN 'D' THEN 'DEVENGADO: '
						WHEN 'E' THEN 'EJERCIDO: '
						WHEN 'P' THEN 'PAGADO: '
					END
					#CAT#
					CASE 
						WHEN i.RevMomento = 1 then '-' 
						ELSE rtrim(' ') 
					END
					#CAT#
					RTRIM(i.TipoMov) #CAT# ' ' #CAT# cp.CPformato, 
					i.CFcuenta, 
					cf.Ccuenta,
					(select Mcodigo from Empresas where Ecodigo=i.Ecodigo), 
					round(i.Monto,2), 1, round(i.Monto,2)
<!--- Control Evento Inicia --->                                         
                     ,'#Arguments.NumeroEvento#'
<!--- Control Evento Fin --->                                         
			from #ContaGubMovs# i
				inner join CPNAP nap
					 on nap.Ecodigo	 = i.Ecodigo
					and nap.CPNAPnum = i.NAP
				inner join CPresupuesto cp
					 on cp.CPcuenta	= i.CPcuenta
				inner join CFinanciera cf
					 on cf.CFcuenta	= i.CFcuenta
             <cfif Arguments.Momentos NEQ 0 >   
            	where i.RevMomento <> 1 
                  or (i.RevMomento = 1 and nap.CPNAPmoduloOri = 'TEOP')
   			 </cfif>    	      
		</cfquery>
                	
	<cfquery name="rsIntarc" datasource="#GvarConexion#">
            	select * from #request.INTARC#
            </cfquery>
               <!---<cf_dumptofile select ="select * from #request.INTARC#">--->
             <!---<cf_dump var="#rsIntarc#">--->
            
            <!---<cf_dumpTable var = "#request.INTARC#"> --->
            
		<!--- Verifica que el Asiento esté Balanceado en Moneda Local --->
		<cfquery name="rsBlanceado" datasource="#arguments.conexion#">
			select 	count(1) 													as CANT,
					sum(0.005) 													as PERMIT,  <!--- 0.005 --->
					sum(case when INTTIP = 'D' then INTMON else -INTMON end) 	as DIF, 
					sum(case when INTTIP = 'D' then INTMON end) 				as DBS, 
					sum(case when INTTIP = 'C' then INTMON end) 				as CRS
			  from #request.INTARC#
		</cfquery>

		<cfif rsBlanceado.CANT GT 0 AND abs(rsBlanceado.DIF) GT rsBlanceado.PERMIT>
			<cfset LvarVieneDeInterfaz = (isdefined("url._soinInterfaz__")) AND url._soinInterfaz__ EQ url.ID>
			<cfif LvarVieneDeInterfaz>
				<cfthrow message="Poliza desbalanceada por Contabilidad Presupuestal. Debitos=#numberFormat(rsBlanceado.DBS,",9.00")#, Creditos=#numberFormat(rsBlanceado.CRS,",9.00")#.">
			<cfelse>
				<cfoutput>
				<font color="##FF0000" style="font-size:18px">
					Poliza desbalanceada por Contabilidad Presupuestal. Debitos=#numberFormat(rsBlanceado.DBS,",9.00")#, #numberFormat(rsBlanceado.CRS,",9.00")#. Proceso Cancelado!
					<BR><BR><BR>
				</font>
				</cfoutput>

				<!--- Pinta el Asiento Contable --->
				<cfquery name="rsNAP" datasource="#GvarConexion#">
					select Ecodigo,CPNAPnum,CPCano,CPCmes,CPNAPfecha,CPNAPmoduloOri,CPNAPdocumentoOri,CPNAPreferenciaOri,CPNAPfechaOri
					  from CPNAP
					 where Ecodigo  = #arguments.Ecodigo#
					   and CPNAPnum = #arguments.NAP#
				</cfquery>
				<cfinvoke 	component		= "sif.Componentes.CG_GeneraAsiento" 
							method			= "PintaAsiento" 
				>
					<cfinvokeargument name="Ecodigo"		value="#rsNAP.Ecodigo#"/>
					<cfinvokeargument name="Eperiodo"		value="#rsNAP.CPCano#"/>
					<cfinvokeargument name="Emes"			value="#rsNAP.CPCmes#"/>
					<cfinvokeargument name="Efecha"			value="#rsNAP.CPNAPfecha#"/>
					<cfinvokeargument name="Oorigen"		value="#rsNAP.CPNAPmoduloOri#"/>
					<cfinvokeargument name="Edocbase"		value="#rsNAP.CPNAPdocumentoOri#"/>
					<cfinvokeargument name="Ereferencia" 	value="#rsNAP.CPNAPreferenciaOri#"/>						
					<cfinvokeargument name="Edescripcion" 	value="CONTABILIDAD PRESUPUESTARIA NAP #rsNAP.CPNAPnum#, #rsNAP.CPNAPmoduloOri#: #rsNAP.CPNAPreferenciaOri#-#rsNAP.CPNAPdocumentoOri#"/>
				</cfinvoke>

				<cf_dump select="select * from CPNAPdetalle     where Ecodigo = #arguments.Ecodigo# and CPNAPnum = #arguments.NAP#" abort="no">
				<cf_dump select="select * from CPNAPdetallePagado where Ecodigo = #arguments.Ecodigo# and CPNAPnum = #arguments.NAP#" abort="no">
				<cftransaction action="rollback" />
				<cf_abort errorInterfaz="La póliza no esta Balanceada en Moneda Local. Debitos=#numberFormat(rsBlanceado.DBS,",9.00")#, #numberFormat(rsBlanceado.CRS,",9.00")#. Proceso Cancelado!">
			</cfif>
		</cfif>

		<cfif rsBlanceado.CANT GT 0 AND isDefined("request.PRES_ContaPresupuestaria_IDcontable")>
			<cfquery name="rsDContables" datasource="#GvarConexion#">
				select max(Dlinea) as Dlinea
				  from DContables
				 where IDcontable = #request.PRES_ContaPresupuestaria_IDcontable#
			</cfquery>
			<cfquery datasource="#GvarConexion#">
				update #Request.intarc#
				   set Dlinea = #rsDContables.Dlinea# + (select count(1) from #Request.intarc# x where x.INTLIN <= #Request.intarc#.INTLIN)
			</cfquery>
			<cfquery name="rsDContables" datasource="#GvarConexion#">
				select Ecodigo, Cconcepto, Eperiodo, Emes, Edocumento
				  from DContables
				 where IDcontable 	= #request.PRES_ContaPresupuestaria_IDcontable#
				   and Dlinea 		= #rsDContables.Dlinea#
			</cfquery>
			
            
			<cfquery datasource="#GvarConexion#">
				insert into DContables (
					 IDcontable, Dlinea, Ecodigo, Cconcepto,
					 Eperiodo, Emes, Edocumento, Ddocumento,
					 Ocodigo, Ddescripcion, Dmovimiento, 
					 Ccuenta, CFcuenta,
					 Doriginal, Dlocal, Mcodigo, Dtipocambio, Dreferencia, CFid)
				select 
					#request.PRES_ContaPresupuestaria_IDcontable#,
					Dlinea,
					#rsDContables.Ecodigo#,
					#rsDContables.Cconcepto#,
					
					#rsDContables.Eperiodo#,
					#rsDContables.Emes#,
					#rsDContables.Edocumento#,
					INTDOC,
					
					Ocodigo, INTDES, INTTIP, 
					CASE 
						WHEN CFcuenta IS NOT NULL AND Ccuenta = 0
						THEN 
							(select min(Ccuenta) 
							   from CFinanciera
							  where CFinanciera.CFcuenta = #Request.intarc#.CFcuenta
							)
						ELSE
							Ccuenta
					END,
					CASE 
						WHEN CFcuenta IS NOT NULL
							THEN CFcuenta
						ELSE
							(select min(CFcuenta) 
							   from CFinanciera
							  where CFinanciera.Ccuenta = #Request.intarc#.Ccuenta
							)
					END,
					round(INTMOE, 2), round(INTMON, 2), Mcodigo, INTCAM, INTREF, CFid
				from #Request.intarc#
				order by INTLIN
			</cfquery>
		<cfelseif rsBlanceado.CANT GT 0 AND isDefined("request.PRES_ContaPresupuestaria")>
			<cfquery name="rsNAP" datasource="#GvarConexion#">
				select Ecodigo,CPNAPnum,CPCano,CPCmes,CPNAPfecha,CPNAPmoduloOri,CPNAPdocumentoOri,CPNAPreferenciaOri,CPNAPfechaOri
				  from CPNAP
				 where Ecodigo  = #arguments.Ecodigo#
				   and CPNAPnum = #arguments.NAP#
			</cfquery>
						
			<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="LvarIDcontable">
				<cfinvokeargument name="Ecodigo"		value="#rsNAP.Ecodigo#"/>
				<cfinvokeargument name="Eperiodo"		value="#rsNAP.CPCano#"/>
				<cfinvokeargument name="Emes"			value="#rsNAP.CPCmes#"/>
				<cfinvokeargument name="Efecha"			value="#rsNAP.CPNAPfecha#"/>
				<cfinvokeargument name="Oorigen"		value="#rsNAP.CPNAPmoduloOri#"/>
				<cfinvokeargument name="Edocbase"		value="#rsNAP.CPNAPdocumentoOri#"/>
				<cfinvokeargument name="Ereferencia" 	value="#rsNAP.CPNAPreferenciaOri#"/>						
				<cfinvokeargument name="Edescripcion" 	value="CONTABILIDAD PRESUPUESTARIA NAP #rsNAP.CPNAPnum#, #rsNAP.CPNAPmoduloOri#: #rsNAP.CPNAPreferenciaOri#-#rsNAP.CPNAPdocumentoOri#"/>
				<cfinvokeargument name="NAP" 			value="#rsNAP.CPNAPnum#"/>
			</cfinvoke>
			<cfquery name="rsIntarc" datasource="#GvarConexion#">
            	select * from #request.INTARC#
            </cfquery>
            <!---    <cf_dumptofile select ="select * from #INTARC#">
            <cf_dump var="#rsIntarc#">--->
			<cfquery datasource="#GvarConexion#">
				delete from #request.INTARC#
			</cfquery>
		</cfif>
<!---		
	<cf_dump select="select * from #request.intPresupuesto#" abort="no">
	<cf_dump select="select * 
			  from CPNAPdetalle n
			 where n.Ecodigo	= #Arguments.Ecodigo#
			   and n.CPNAPnum	= #Arguments.NAP#"
		abort="no"
	>
	<cf_dump select="select * 
			  from CPNAPdetallePagado n
			 where n.Ecodigo	= #Arguments.Ecodigo#
			   and n.CPNAPnum	= #Arguments.NAP#"
		abort="yes"
	>
	<cf_dump select="select * 
			  from CPNAPdetalle n
			 where n.Ecodigo	= #Arguments.Ecodigo#
			   and n.CPNAPnum	= #Arguments.NAP#"
		abort="no"
	>
	<cf_dump select="select * 
			  from CPNAPdetallePagado n
			 where n.Ecodigo	= #Arguments.Ecodigo#
			   and n.CPNAPnum	= #Arguments.NAP#"
		abort="no"
	>
	<cf_dump select="select * from #request.intarc#">
	<cf_dump select="select * from #ContaGubMovs#" abort="no">
	<cf_dump select="select * 
			  from CPNAPdetalle n
			 where n.Ecodigo	= #Arguments.Ecodigo#
			   and n.CPNAPnum	= #Arguments.NAP#"
	>
	<cf_dump select="select * from #request.intarc#">
	
--->
	</cffunction>

	<cffunction name="sbInsertEgresos">
		<cfargument name="TipoMov">
		<cfargument name="Momento">
		<cfargument name="TipoMovCmayor_1">
		<cfargument name="TipoMovCmayor_2">
		<cfset sbInsertParametros('E','Egresos', Arguments.TipoMov,Arguments.Momento,Arguments.TipoMovCmayor_1,Arguments.TipoMovCmayor_2)>
	</cffunction>      

	<cffunction name="sbInsertIngresos">
		<cfargument name="TipoMov">
		<cfargument name="Momento">
		<cfargument name="TipoMovCmayor_1">
		<cfargument name="TipoMovCmayor_2">
		<cfset sbInsertParametros('I','Ingresos', Arguments.TipoMov,Arguments.Momento,Arguments.TipoMovCmayor_1,Arguments.TipoMovCmayor_2)>
		<cfset sbInsertParametros('C','Costos',   Arguments.TipoMov,Arguments.Momento,Arguments.TipoMovCmayor_2,Arguments.TipoMovCmayor_1)>
	</cffunction>

	<cffunction name="sbInsertParametros">
		<cfargument name="TipoPres">
		<cfargument name="TipoPresDes">
		<cfargument name="TipoMov">
		<cfargument name="Momento">
		<cfargument name="TipoMovCmayor_1">
		<cfargument name="TipoMovCmayor_2">

		<cfif Arguments.TipoPres EQ "I">
			<cfset LvarTipoPresDes = "Ingresos">
		<cfelseif Arguments.TipoPres EQ "C">
			<cfset LvarTipoPresDes = "Costos">
		<cfelseif Arguments.TipoPres EQ "E">
			<cfset LvarTipoPresDes = "Egresos">
		<cfelse>
			<cfthrow message="Tipo Presupuesto '#Arguments.TipoPres#' incorrecto">
		</cfif>
		
		<cfif Arguments.TipoMovCmayor_1 NEQ "*">
			<cfquery name="rsSQL" datasource="#GvarConexion#"><!---'CC', 'C', 'CC','RC'--->
				select Ecodigo, Cmayor
				  from CPtipoMovContable
				 where CPPid		= #GvarCPPid#
				   and CPCCtipo		= '#Arguments.TipoPres#'
				   and CPTMtipoMov	= '#Arguments.TipoMovCmayor_1#'
			</cfquery>
            <cfset Ecodigo = rsSQL.Ecodigo>
			<cfif rsSQL.recordCount EQ 0>
            	<cfif rsPreComp.recordCount GT 0 and  rsPreComp.Pvalor EQ 'S'>
                	<cfif  Arguments.TipoMovCmayor_1 EQ  'RA' OR Arguments.TipoMovCmayor_1 EQ  'RC' OR Arguments.TipoMovCmayor_1 EQ  'RP'>
                		<cfset Ecodigo = session.Ecodigo>
                     <cfelse>
						<cfthrow message="Falta Configurar la Cuenta de Orden de #LvarTipoPresDes# para el tipo movimiento '#Arguments.TipoMovCmayor_1#'">
                	</cfif> 
                <cfelse>
					<cfthrow message="Falta Configurar la Cuenta de Orden de #LvarTipoPresDes# para el tipo movimiento '#Arguments.TipoMovCmayor_1#'">    
                </cfif>

			<!---</cfif>--->
			<cfelse>
				<cfset GvarSec ++>
				<cfquery datasource="#GvarConexion#">
                    insert into #ContaGubParam#
                        (Ecodigo,TipoPres,TipoMov,Momento,TipoMovDBCR,Sec,Cmayor)
                    values (
                        #Ecodigo#,
                        '#Arguments.TipoPres#',
                        '#Arguments.TipoMov#',
                        '#Arguments.Momento#',
                        'D',
                        #GvarSec#,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSQL.Cmayor#">
                    )
                </cfquery>
          </cfif>
		</cfif>
				
		<cfif Arguments.TipoMovCmayor_2 NEQ "*">
			<cfquery name="rsSQL" datasource="#GvarConexion#">
				select Ecodigo, Cmayor
				  from CPtipoMovContable
				 where CPPid		= #GvarCPPid#
				   and CPCCtipo		= '#Arguments.TipoPres#'
				   and CPTMtipoMov	= '#Arguments.TipoMovCmayor_2#'
			</cfquery>
            <cfset Ecodigo = rsSQL.Ecodigo>
			<cfif rsSQL.recordCount EQ 0>
            	<cfif rsPreComp.recorCount GT 0 and rsPreComp.Pvalor EQ 'S'>
					<cfif Arguments.TipoMovCmayor_2 EQ  'RA' OR Arguments.TipoMovCmayor_2 EQ  'RC' OR Arguments.TipoMovCmayor_2 EQ  'RP'>
                		<cfset Ecodigo = session.Ecodigo>
                	<cfelse>
						<cfthrow message="Falta Configurar la Cuenta de Orden de #LvarTipoPresDes# para el tipo movimiento '#Arguments.TipoMovCmayor_2#'">
                	</cfif>
                <cfelse>
						<cfthrow message="Falta Configurar la Cuenta de Orden de #LvarTipoPresDes# para el tipo movimiento '#Arguments.TipoMovCmayor_2#'">   
				</cfif>
			<cfelse>
				<cfset GvarSec ++>
                <cfquery datasource="#GvarConexion#">
                    insert into #ContaGubParam#
                        (Ecodigo,TipoPres,TipoMov,Momento,TipoMovDBCR,Sec,Cmayor)
                    values (
                        #Ecodigo#,
                        '#Arguments.TipoPres#',
                        '#Arguments.TipoMov#',
                        '#Arguments.Momento#',
                        'C',
                        #GvarSec#,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSQL.Cmayor#">
                    )
                </cfquery>
            </cfif>
		</cfif>
	</cffunction>
	
	<cffunction name="AsientoCierre">
		<cfargument name="Ecodigo">
		<cfargument name="Periodo">
		<cfargument name="Mes">
		<cfargument name="Conexion">

		<!---
			Asiento de Cierre:
			1) Determinar superavit o deficit presupuestario (Ingreso Cobrado contra Egreso Devengado pagado o no):
				Si 9309 Ingreso cobrado >= 9410 Egresos pagados + 9409 Egresos ejercidos + 9411 Egresos Devengados
					Es SUPERAVIT
				sino
					Es DEFICIT
			
			2) Cierre de Ingresos no cobrados: 
			
			2.1) MATAR el Ingreso Autorizado contra TODO lo no cobrado
			(En lugar de devolver Devengado a por Recibir y luego matar por Recibir contra Ingreso Autorizado)
			
				 9308 Ingreso Devengado (-Saldo de Ingreso Devengado)
				 9307 Ingreso por Recibir (-Saldo de Ingreso x Recibir)
								 9306 Ingreso Autorizado (Saldos Ingreso Devengado + Saldo Ingreso x Recibir)
			
			3) Cierre de Egresos no pagados:
			
			3.1) MATAR el Egreso Autorizado contra TODO lo no devengado:
			(En lugar de devolver Comprometido a PorComprometer, luego porComprometer a por Recibir y luego matar por Recibir contra Ingreso Autorizado)
				 9406 Egreso Autorizado (Saldos Egresos Comprometido+PreComprometido+PorEjercer)
								 9408 Egreso Comprometido      (-Saldo Egreso Comprometido)
								 9412 Egreso PreComprometido   (-Saldo Egreso PreComprometido)
								 9407 Egreso x Ejercer         (-Saldo Egreso Por Ejercer)
			3.2) Pasar a "ADEFAS" TODO lo devengado no pagado:
				 9501 ADEFAS (Saldos Egresos Ejercido+Devengado) 
								 9409 Egreso Ejercido      (-Saldo Egreso Ejercido)
								 9411 Egreso Devengado  (-Saldo Egreso Devengado)
			4) Asiento Final y Cierre Ejercicio:
			 
			4.1 ) Si es SUPERAVIT:
			4.1.1) Asiento Final:
				Mata Ingreso cobrado + Egreso Pagado + ADEFAS contra Superavit
								 9410 Superavit Financiero (Saldos Ingreso Cobrado - (Egreso Pagado + ADEFAS) )
				 9309 Ingreso cobrado (-Saldo Ingreso cobrado) 
								 9410 Egreso Pagado (-Saldo Egreso Pagado)
								 9501 ADEFAS (-Saldo ADEFAS) 
			4.1.2) Asiento Cierre:
				Mata Ingreso Autorizado + Egreso Autorizados contra Superavit
			
				 9406 Egreso Autorizado   (Saldo Ingreso Autorizado - Saldo Superavit)
				 9410 Superavit Financiero (-Saldo Superavit)
								 9306 Ingreso Autorizado (-Saldo Ingreso Autorizado)
			
			 
			4.2 ) Si es DEFICIT:
			4.2.1) Asiento Final:
				Mata Ingreso cobrado + Egreso Pagado + ADEFAS contra Deficit
				 9503 Deficit Financiero (Saldos Egreso Pagado + ADEFAS - Ingreso Cobrado)
				 9309 Ingreso cobrado (-Saldo Ingreso cobrado) 
								 9410 Egreso Pagado (-Saldo Egreso Pagado)
								 9501 ADEFAS (-Saldo ADEFAS) 
			4.2.2) Asiento Cierre:
				Mata Ingreso Autorizado + Egreso Autorizados contra Deficit
			
				 9406 Egreso Autorizado (Saldo Ingreso Autorizado + Saldo Deficit)
								 9503 Deficit Financiero   	(-Saldo Deficit)
								 9306 Ingreso Autorizado 	(-Saldo Ingreso Autorizado)

			RESOLVIENDO LA ECUACION:
				Nomenclatura:  TipoCuenta_Momento
						Donde: TipoCuenta: I=Ingreso, E=Egreso=Gasto y Costo
						Momento:    A=Autorizado = Presupuesto Ordinario + Modificacion + Variacion Cambiaria
									D=Disponible, R=Reservado, C=Comprometido,
									E=Ejecutado o Devengado ni Ejercido ni Pagado, 
									EJ=Ejercido no Pagado, P=Pagado o Cobrado	
			1) Determinar el Resultado es superavit o deficit:
				 Si Ingreso cobrado (I_P) >= Egreso Devengado pagado o no (E_E+E_EJ+E_P)
					Resultado = Superavit
				 sino
					Resultado = Deficit
			2.1) Matar Ingreso no cobrado			I_A = I_A - (I_D+I_R+I_C+I_E+I_EJ)
			3.1) Matar Egreso no devengado			E_A = E_A - (E_D+E_R+E_C)
			3.2) Matar Egreso devengado no pagado	ADFAS = -(E_E+E_EJ)
			4.1) Matar Pagados y ADFAS				Resultado = -(I_P - E_P - ADEFAS)
			4.2) Matar Autorizados					Resultado = Resultado + (I_A - E_A)

			5) Resolviendo la ecuación:
						Resultado = - I_P + E_P + (E_E+E_EJ)
									+ I_A - (I_D+I_R+I_C+I_E+I_EJ)
									- (E_A - (E_D+E_R+E_C))
						Resultado   = I_A - (I_D+I_R+I_C+I_E+I_EJ+I_P)
									-(
									  E_A - (E_D+E_R+E_C+E_E+E_EJ+E_P)
									 )
						Resultado = 0 - 0 = 0
				Claro esto teórico, porque:
				5.1) Si hay cuentas abiertas, el Autorizado puede ser menor a los demás, por tanto, da negativo.  
					 Sobre todo en los ingresos, no hay ningún problema en vender más de lo Autorizado.
				5.2) Si hay cuentas cerradas con movimientos en moneda extranjera, el pagado en moneda local 
					 puede ser mayor al ejecutado, que no se controla, por tanto, da negativo		
		--->
		
		<!--- Parametros --->
		<cfset LvarFecha	= createDate(Arguments.Periodo, Arguments.Mes, 1)>
		<cfset LvarFecha	= dateAdd("M",+1,LvarFecha)>
		<cfset LvarFecha	= dateAdd("D",-1,LvarFecha)>
		<cfset LvarINTFEC	= dateFormat(LvarFecha,"YYYYMMDD")>

		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select Mcodigo
			  from Empresas
			 where Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfset LvarMcodigoLocal = rsSQL.Mcodigo>

		<cfinvoke 	component		= "PRES_Presupuesto"
					method			= "rsCPresupuestoPeriodo" 
					returnvariable	= "rsSQL"
					
					Ecodigo			= "#Arguments.Ecodigo#"
					ModuloOrigen	= "CGCP"
					FechaDocumento	= "#LvarFecha#"
					AnoDocumento	= "#Arguments.Periodo#"
					MesDocumento	= "#Arguments.Mes#"
		/>
		<cfset LvarCPPid = rsSQL.CPPid>
        
		<cfif LvarCPPid EQ "">
			<cfreturn>
		</cfif>

		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select Pvalor
			  from Parametros
			 where Ecodigo = #Arguments.Ecodigo#
			   and Pcodigo = 1140
		</cfquery>
		<cfif rsSQL.Pvalor NEQ "S">
			<cfreturn>
		</cfif>

		<cfquery name="rsConceptoContableE" datasource="#Arguments.Conexion#">
			select min(Cconcepto) as Cconcepto
			from ConceptoContable
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			and Oorigen = 'CGCP'
		</cfquery>
		
        <!---SML 19/06/2014. Modificacion en la poliza presupuestal para que no se considere la cuenta de Precompromiso--->
        <cfquery name="rsPreComp" datasource="#session.DSN#">
        	select Pvalor
			  from Parametros
			 where Ecodigo = #Arguments.Ecodigo#
			   and Pcodigo = 1390
        </cfquery>

		<!--- 1) Determinar superavit o deficit presupuestario (Ingreso Cobrado contra Egreso Devengado pagado o no) --->
		<cfquery name="rsIngresoPagado" datasource="#Arguments.Conexion#">
			select coalesce(sum(SLinicial + DLdebitos - CLcreditos),0) as Total
			  from SaldosContables s
				inner join CContables c
					 on c.Ccuenta 	= s.Ccuenta
					and c.Cmayor	in (
										select Cmayor from CPtipoMovContable 
										 where CPPid	= #LvarCPPid#
										   and CPCCtipo IN ('I','C') and CPTMtipoMov in ('P')
										)
				    and c.Cmovimiento = 'S'
			 where s.Ecodigo	= #Arguments.Ecodigo#
			   and s.Speriodo	= #Arguments.Periodo#
			   and s.Smes		= #Arguments.Mes#
		</cfquery>
		<cfquery name="rsEgresoDevengado" datasource="#Arguments.Conexion#">
			select coalesce(sum(SLinicial + DLdebitos - CLcreditos),0) as Total
			  from SaldosContables s
				inner join CContables c
					on c.Ccuenta 	= s.Ccuenta
					and c.Cmayor	in (
										select Cmayor from CPtipoMovContable 
										 where CPPid	= #LvarCPPid#
										   and CPCCtipo = 'E' and CPTMtipoMov in ('P','EJ','E','E2')
									  	)
				    and c.Cmovimiento = 'S'
			 where s.Ecodigo	= #Arguments.Ecodigo#
			   and s.Speriodo	= #Arguments.Periodo#
			   and s.Smes		= #Arguments.Mes#
		</cfquery>
		<cfset LvarEsSuperavit = abs(rsIngresoPagado.Total) GTE abs(rsEgresoDevengado.Total)>
        
		<cfif LvarEsSuperavit>
			<cfquery name="rsRESULTADOs" datasource="#session.dsn#">
				select  'Superavit' as Tipo, 'Cuenta de Superavit para Cierre Contabilidad Presupuestaria' as CtaTipo, 
						Pvalor as CFcuenta, 0 as Ccuenta
				  from Parametros
				 where Ecodigo = #Arguments.Ecodigo#
				   and Pcodigo = 1141
			</cfquery>
		<cfelse>
			<cfquery name="rsRESULTADOs" datasource="#session.dsn#">
				select  'Déficit' as Tipo, 'Cuenta de Déficit para Cierre Contabilidad Presupuestaria' as CtaTipo, 
						Pvalor as CFcuenta, 0 as Ccuenta
				  from Parametros
				 where Ecodigo = #Arguments.Ecodigo#
				   and Pcodigo = 1142
			</cfquery>
		</cfif>
		<cfif rsRESULTADOs.CFcuenta EQ "">
			<cfif LvarEsSuperavit>
				<cfthrow message="Falta parametrizar la Cuenta de Superavit para Cierre Contabilidad Presupuestaria">
			<cfelse>
				<cfthrow message="Falta parametrizar la Cuenta de Deficit para Cierre Contabilidad Presupuestaria">
			</cfif>
		</cfif>
		<cfquery name="rsRESULTADOs" datasource="#session.dsn#">
			select 	'#rsRESULTADOs.Tipo#' as Tipo, '#rsRESULTADOs.CtaTipo#' as CtaTipo, 
					CFcuenta, Ccuenta
			  from CFinanciera
			 where CFcuenta = #rsRESULTADOs.CFcuenta#
		</cfquery>
		
		<!--- ADEFAS: Adeudos Periodos Anteriores --->
		<cfquery name="rsADEFAS" datasource="#session.dsn#">
			select Pvalor as CFcuenta, 0 as Ccuenta
			  from Parametros
			 where Ecodigo = #Arguments.Ecodigo#
			   and Pcodigo = 1143
		</cfquery>
		<cfif rsADEFAS.CFcuenta EQ "" and rsADEFAS.RecordCount EQ 1>
			<cfthrow message="Falta parametrizar la Cuenta de Adeudos Periodos Anteriores">
		<cfelseif rsADEFAS.CFcuenta EQ rsRESULTADOs.CFcuenta>
			<cfthrow message="La Cuenta de Adeudos Periodos Anteriores no debe estar parametrizada igual que la #rsRESULTADOs.CtaTipo#">
		</cfif>
		
        <cfif rsADEFAS.CFcuenta NEQ "" and rsADEFAS.RecordCount EQ 1>
		<cfquery name="rsADEFAS" datasource="#session.dsn#">
			select CFcuenta, Ccuenta
			  from CFinanciera
			 where CFcuenta = #rsADEFAS.CFcuenta#
		</cfquery>
        </cfif>

		<!--- Genera las cuentas que aún no se han generado --->
		<cfquery name="rsCtas" datasource="#Arguments.Conexion#">
			select 	distinct
						(select min(Cmayor) from CPtipoMovContable where CPPid=#LvarCPPid# and CPCCtipo IN ('I','C') and CPTMtipoMov = 'A') #CAT#
							<cf_dbfunction name="spart" args="c.Cformato,5,100">
						as Cformato
			  from SaldosContables s
				inner join CContables c
					 on c.Ccuenta = s.Ccuenta
					and c.Cmayor	in (
										select Cmayor from CPtipoMovContable 
										 where CPPid	= #LvarCPPid#
										   and CPCCtipo IN ('I','C')
									  	)
				    and c.Cmovimiento = 'S'
			 where s.Ecodigo	= #Arguments.Ecodigo#
			   and s.Speriodo	= #Arguments.Periodo#
			   and s.Smes		= #Arguments.Mes#
			   and	(
						select count(1)
						  from CContables 
						 where Ecodigo = s.Ecodigo 
						   and Cformato = 	(select min(Cmayor) from CPtipoMovContable where CPPid=#LvarCPPid# and CPCCtipo IN ('I','C') and CPTMtipoMov = 'A') #CAT#
											<cf_dbfunction name="spart" args="c.Cformato,5,100">
					)  = 0
			UNION
			select 	distinct
						(select min(Cmayor) from CPtipoMovContable where CPPid=#LvarCPPid# and CPCCtipo = 'E' and CPTMtipoMov = 'A') #CAT#
							<cf_dbfunction name="spart" args="c.Cformato,5,100">
						as Cformato
			  from SaldosContables s
				inner join CContables c
					 on c.Ccuenta = s.Ccuenta
					and c.Cmayor	in (
										select Cmayor from CPtipoMovContable 
										 where CPPid	= #LvarCPPid#
										   and CPCCtipo = 'E' 
									  	)
				    and c.Cmovimiento = 'S'
			 where s.Ecodigo	= #Arguments.Ecodigo#
			   and s.Speriodo	= #Arguments.Periodo#
			   and s.Smes		= #Arguments.Mes#
			   and	(
						select count(1)
						  from CContables 
						 where Ecodigo = s.Ecodigo 
						   and Cformato = 	(select min(Cmayor) from CPtipoMovContable where CPPid=#LvarCPPid# and CPCCtipo = 'E' and CPTMtipoMov = 'A') #CAT#
											<cf_dbfunction name="spart" args="c.Cformato,5,100">
					)  = 0
		</cfquery>
       <!--- <cf_dump var = "#rsCtas#">--->
		<cfloop query="rsCtas">
			<cfinvoke 	component		= "PC_GeneraCuentaFinanciera"
						method			= "fnGeneraCuentaFinanciera"
						returnvariable	= "LvarMSG"
			>
				<cfinvokeargument name="Lprm_Ecodigo" 			value="#Arguments.Ecodigo#">
				<cfinvokeargument name="Lprm_CFformato" 		value="#rsCtas.Cformato#">
				<cfinvokeargument name="Lprm_fecha" 			value="#now()#">
				<cfinvokeargument name="Lprm_TransaccionActiva" value="true">
			</cfinvoke>
			
			<cfif LvarMSG NEQ "OLD" AND LvarMSG NEQ "NEW">
				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					select Edescripcion
					  from Empresas
					 where Ecodigo = #Arguments.Ecodigo#
				</cfquery>
				<cfthrow message="ERROR EN CIERRE CONTABILIDAD PRESUPUESTARIA #rsSQL.Edescripcion#: #LvarMSG#">
			</cfif>
		</cfloop>
		
		<!--- INICIA EL ASIENTO DE CIERRE --->
		<cfquery datasource="#Arguments.Conexion#">
			delete from #request.INTARC# 
		</cfquery>
		<!--- 2) Cierre de Ingresos no cobrados: 
					Ingresos no cobrados ('D','RC','RA','RP','CC','CA','E','E2','EJ')(todos menos 'P') 
						se matan contra Ingresos Autorizados
		--->
		<!--- Ingresos no Cobrados --->
		<cfquery name="rsEgresoDevengado" datasource="#Arguments.Conexion#">
			insert into #request.INTARC# 
				( 
					INTORI, INTREL, INTDOC, INTREF, 
					INTFEC, Periodo, Mes, 
					INTDES, INTTIP,
					Mcodigo, INTCAM, 

					LIN_IDREF,
					Ocodigo, Ccuenta, 
					INTMOE, INTMON
				)
			select 	'CGCP', 0, 'CIERRE #Arguments.Periodo#-#Arguments.Mes#', 'CONTA PRESUPUESTAL', 
					'#LvarINTFEC#', #Arguments.Periodo#, #Arguments.Mes#, 
					'Cierre Ingresos no Cobrados contra Autorizado', 'D',
					#LvarMcodigoLocal#, 1, 
					
					1, 									<!--- LIN_IDREF: 1=Ingresos no cobrados --->
					s.Ocodigo, s.Ccuenta,
					- (SLinicial + DLdebitos - CLcreditos),
					- (SLinicial + DLdebitos - CLcreditos)
			  from SaldosContables s
				inner join CContables c
					 on c.Ccuenta	= s.Ccuenta
					and c.Cmayor	in (
										select Cmayor from CPtipoMovContable 
										 where CPPid=#LvarCPPid#
										   and CPCCtipo IN ('I','C') and CPTMtipoMov in ('D','RC','RA','RP','CC','CA','E','E2','EJ')
									  	)
				    and c.Cmovimiento = 'S'
			 where s.Ecodigo	= #Arguments.Ecodigo#
			   and s.Speriodo	= #Arguments.Periodo#
			   and s.Smes		= #Arguments.Mes#
		</cfquery>

		<!--- Ingresos Autorizados --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into #request.INTARC# 
				( 
					INTORI, INTREL, INTDOC, INTREF, 
					INTFEC, Periodo, Mes, 
					INTDES, INTTIP,
					Mcodigo, INTCAM, 

					LIN_IDREF,
					Ocodigo, Ccuenta,  
					INTMOE, INTMON
				)
			select 	'CGCP', 0, 'CIERRE #Arguments.Periodo#-#Arguments.Mes#', 'CONTA PRESUPUESTAL', 
					'#LvarINTFEC#', #Arguments.Periodo#, #Arguments.Mes#, 
					'Cierre Ingresos no Cobrados contra Autorizado', 'D',
					#LvarMcodigoLocal#, 1, 
					
					2, 									<!--- LIN_IDREF: 2=Ingresos Autorizados --->
					s.Ocodigo, 
					(
						select Ccuenta 
						  from CContables 
						 where Ecodigo  = 	c.Ecodigo 
						   and Cformato = 	(select min(Cmayor) from CPtipoMovContable where CPPid=#LvarCPPid# and CPCCtipo IN ('I','C') and CPTMtipoMov = 'A') #CAT#
											<cf_dbfunction name="spart" args="c.Cformato,5,100">
					),
					- INTMOE,
					- INTMON
			  from #request.INTARC# s
				inner join CContables c
					 on c.Ccuenta = s.Ccuenta
			 where LIN_IDREF = 1
		</cfquery>
		<!--- 3) Cierre de Egresos no pagados: 
					Egresos no devengados ('D','RC','RA','RP','CC','CA') se matan contra Egresos Autorizados
					Egresos devengados no pagados ('EJ','E') pasan a ADEFAS (Adeudo de Ejercicios Fiscales Anteriores)
		--->
		<!--- Egresos no Devengados --->
		<cfquery name="rsEgresoDevengado" datasource="#Arguments.Conexion#">
			insert into #request.INTARC# 
				( 
					INTORI, INTREL, INTDOC, INTREF, 
					INTFEC, Periodo, Mes, 
					INTDES, INTTIP,
					Mcodigo, INTCAM, 

					LIN_IDREF,
					Ocodigo, Ccuenta,  
					INTMOE, INTMON
				)
			select 	'CGCP', 0, 'CIERRE #Arguments.Periodo#-#Arguments.Mes#', 'CONTA PRESUPUESTAL', 
					'#LvarINTFEC#', #Arguments.Periodo#, #Arguments.Mes#, 
					'Cierre Egresos no Devengados contra Autorizado', 'D',
					#LvarMcodigoLocal#, 1, 
					
					3, 									<!--- LIN_IDREF: 3=Egresos no devengados --->
					s.Ocodigo, s.Ccuenta,  
					- (SLinicial + DLdebitos - CLcreditos),
					- (SLinicial + DLdebitos - CLcreditos)
			  from SaldosContables s
				inner join CContables c
					 on c.Ccuenta	= s.Ccuenta
					and c.Cmayor	in (
										select Cmayor from CPtipoMovContable 
										 where CPPid=#LvarCPPid#
										   and CPCCtipo = 'E' and CPTMtipoMov in ('D','CC','CA'
                           <!---SML 19/06/2014. Quitar las cuentas de precompromiso de acuerdo al parametro 1390--->
                           								<cfif isdefined('rsPreComp') and rsPreComp.Pvalor EQ 'N'>
                                           										  ,'RC','RA','RP'
                                                        </cfif>)
										)
				    and c.Cmovimiento = 'S'
			 where s.Ecodigo	= #Arguments.Ecodigo#
			   and s.Speriodo	= #Arguments.Periodo#
			   and s.Smes		= #Arguments.Mes#
		</cfquery>
		<!--- Egresos Autorizados --->
		<cfquery name="rsEgresoDevengado" datasource="#Arguments.Conexion#">
			insert into #request.INTARC# 
				( 
					INTORI, INTREL, INTDOC, INTREF, 
					INTFEC, Periodo, Mes, 
					INTDES, INTTIP,
					Mcodigo, INTCAM, 

					LIN_IDREF,
					Ocodigo, Ccuenta,  
					INTMOE, INTMON
				)
			select 	'CGCP', 0, 'CIERRE #Arguments.Periodo#-#Arguments.Mes#', 'CONTA PRESUPUESTAL', 
					'#LvarINTFEC#', #Arguments.Periodo#, #Arguments.Mes#, 
					'Cierre Egresos no Devengados contra Autorizado', 'D',
					#LvarMcodigoLocal#, 1, 
					
					4, 									<!--- LIN_IDREF: 4=Egresos Autorizados --->
					s.Ocodigo,
					(
						select Ccuenta 
						  from CContables 
						 where Ecodigo  = 	c.Ecodigo 
						   and Cformato = 	(select min(Cmayor) from CPtipoMovContable where CPPid=#LvarCPPid# and CPCCtipo = 'E' and CPTMtipoMov = 'A') #CAT#
											<cf_dbfunction name="spart" args="c.Cformato,5,100">
					),
					- INTMOE,
					- INTMON
			  from #request.INTARC# s
				inner join CContables c
					 on c.Ccuenta = s.Ccuenta
			 where LIN_IDREF = 3
		</cfquery>


		<!--- Egresos Devengados No Pagados --->
        
        <cfif len(rsADEFAS.CFcuenta) GT 0 and rsADEFAS.RecordCount EQ 1>
		<cfquery name="rsEgresoDevengado" datasource="#Arguments.Conexion#">
			insert into #request.INTARC# 
				( 
					INTORI, INTREL, INTDOC, INTREF, 
					INTFEC, Periodo, Mes, 
					INTDES, INTTIP,
					Mcodigo, INTCAM, 

					LIN_IDREF,
					Ocodigo, Ccuenta,  
					INTMOE, INTMON
				)
			select 	'CGCP', 0, 'CIERRE #Arguments.Periodo#-#Arguments.Mes#', 'CONTA PRESUPUESTAL', 
					'#LvarINTFEC#', #Arguments.Periodo#, #Arguments.Mes#, 
					'Cierre Egresos Devengados No Pagados contra ADEFAS', 'D',
					#LvarMcodigoLocal#, 1, 
					
					5, 									<!--- LIN_IDREF: 5=Egresos Devengados No Pagados --->
					s.Ocodigo, s.Ccuenta,
					- (SLinicial + DLdebitos - CLcreditos),
					- (SLinicial + DLdebitos - CLcreditos)
			  from SaldosContables s
				inner join CContables c
					 on c.Ccuenta	= s.Ccuenta
					and c.Cmayor	in (
										select Cmayor from CPtipoMovContable 
										 where CPPid=#LvarCPPid#
										   and CPCCtipo = 'E' and CPTMtipoMov in ('E','E2','EJ')
										)
				    and c.Cmovimiento = 'S'
			 where s.Ecodigo	= #Arguments.Ecodigo#
			   and s.Speriodo	= #Arguments.Periodo#
			   and s.Smes		= #Arguments.Mes#
		</cfquery>

		<!--- ADEFAS: Adeudos Periodos Anteriores --->
		<cfquery name="rsEgresoDevengado" datasource="#Arguments.Conexion#">
			insert into #request.INTARC# 
				( 
					INTORI, INTREL, INTDOC, INTREF, 
					INTFEC, Periodo, Mes, 
					INTDES, INTTIP,
					Mcodigo, INTCAM, 

					LIN_IDREF,
					Ocodigo, Ccuenta,  
					INTMOE, INTMON
				)
			select 	'CGCP', 0, 'CIERRE #Arguments.Periodo#-#Arguments.Mes#', 'CONTA PRESUPUESTAL', 
					'#LvarINTFEC#', #Arguments.Periodo#, #Arguments.Mes#, 
					'Cierre Egresos Devengados No Pagados contra ADEFAS', 'D',
					#LvarMcodigoLocal#, 1, 
					
					6, 									<!--- LIN_IDREF: 6=ADFAS --->
					s.Ocodigo,
					#rsADEFAS.Ccuenta#,
					- sum(INTMOE),
					- sum(INTMON)
			  from #request.INTARC# s
			 where LIN_IDREF = 5
			 group by s.Ocodigo
		</cfquery>
		</cfif>
		<!--- 4) Asiento Final: 
					Mata Ingreso Cobrado + Egreso Pagado + ADEFAS contra Superavit/Deficit
		--->
		<!--- Ingresos y Egresos Pagados --->
		<cfquery name="rsEgresoDevengado" datasource="#Arguments.Conexion#">
			insert into #request.INTARC# 
				( 
					INTORI, INTREL, INTDOC, INTREF, 
					INTFEC, Periodo, Mes, 
					INTDES, INTTIP,
					Mcodigo, INTCAM, 

					LIN_IDREF,
					Ocodigo, Ccuenta,  
					INTMOE, INTMON
				)
			<!--- Matar Ingresos y Egresos Pagados --->
			select 	'CGCP', 0, 'CIERRE #Arguments.Periodo#-#Arguments.Mes#', 'CONTA PRESUPUESTAL', 
					'#LvarINTFEC#', #Arguments.Periodo#, #Arguments.Mes#, 
					'Asiento Final: Egresos e Ingresos Pagados y ADEFAS contra #rsRESULTADOs.Tipo#', 'D',
					#LvarMcodigoLocal#, 1, 
					
					7, 									<!--- LIN_IDREF: 7=Ingresos/Egresos Pagados y ADEFAS--->
					s.Ocodigo, s.Ccuenta,
					- (SLinicial + DLdebitos - CLcreditos),
					- (SLinicial + DLdebitos - CLcreditos)
			  from SaldosContables s
				inner join CContables c
					 on c.Ccuenta	= s.Ccuenta
					and c.Cmayor	in (
										select Cmayor from CPtipoMovContable 
										 where CPPid=#LvarCPPid#
										   and CPCCtipo in ('I','E','C') and CPTMtipoMov = 'P'
										)
				    and c.Cmovimiento = 'S'
			 where s.Ecodigo	= #Arguments.Ecodigo#
			   and s.Speriodo	= #Arguments.Periodo#
			   and s.Smes		= #Arguments.Mes#
			UNION
			<!--- Matar ADEFAS --->
            <cfif len(rsADEFAS.CFcuenta) GT 0 and rsADEFAS.RecordCount EQ 1>
			select 	'CGCP', 0, 'CIERRE #Arguments.Periodo#-#Arguments.Mes#', 'CONTA PRESUPUESTAL', 
					'#LvarINTFEC#', #Arguments.Periodo#, #Arguments.Mes#, 
					'Asiento Final: Egresos e Ingresos Pagados y ADEFAS contra #rsRESULTADOs.Tipo#', 'D',
					#LvarMcodigoLocal#, 1, 
					
					7, 									<!--- LIN_IDREF: 7=Ingresos/Egresos Pagados y ADEFAS--->
					s.Ocodigo,
					#rsADEFAS.Ccuenta#,
					- sum(INTMOE),
					- sum(INTMON)
			  from #request.INTARC# s
			 where LIN_IDREF = 6
			 group by s.Ocodigo
             <cfelse>
			  select 	'CGCP', 0, 'CIERRE #Arguments.Periodo#-#Arguments.Mes#', 'CONTA PRESUPUESTAL', 
					'#LvarINTFEC#', #Arguments.Periodo#, #Arguments.Mes#, 
					'Asiento de cierre del Egreso Devengado No Pagado', 'D',
					#LvarMcodigoLocal#, 1, 
					
					7, 									<!--- LIN_IDREF: 7=Ingresos/Egresos Pagados--->
					s.Ocodigo, s.Ccuenta,
					- (SLinicial + DLdebitos - CLcreditos),
					- (SLinicial + DLdebitos - CLcreditos)
			  from SaldosContables s
				inner join CContables c
					 on c.Ccuenta	= s.Ccuenta
					and c.Cmayor	in (
										select Cmayor from CPtipoMovContable 
										 where CPPid=#LvarCPPid#
										   and CPCCtipo = 'E' and CPTMtipoMov in ('E','E2','EJ')
										)
				    and c.Cmovimiento = 'S'
			 where s.Ecodigo	= #Arguments.Ecodigo#
			   and s.Speriodo	= #Arguments.Periodo#
			   and s.Smes		= #Arguments.Mes#	
             </cfif>
		</cfquery>
		<!--- Resultados: Superavit o Deficit --->
		<cfquery name="rsEgresoDevengado" datasource="#Arguments.Conexion#">
			insert into #request.INTARC# 
				( 
					INTORI, INTREL, INTDOC, INTREF, 
					INTFEC, Periodo, Mes, 
					INTDES, INTTIP,
					Mcodigo, INTCAM, 

					LIN_IDREF,
					Ocodigo, Ccuenta,  
					INTMOE, INTMON
				)
			select 	'CGCP', 0, 'CIERRE #Arguments.Periodo#-#Arguments.Mes#', 'CONTA PRESUPUESTAL', 
					'#LvarINTFEC#', #Arguments.Periodo#, #Arguments.Mes#, 
					'Asiento Final: Egresos e Ingresos Pagados y ADEFAS contra #rsRESULTADOs.Tipo#', 'D',
					#LvarMcodigoLocal#, 1, 
					
					8, 									<!--- LIN_IDREF: 8=Superavit/Deficit --->
					s.Ocodigo,
					#rsRESULTADOs.Ccuenta#,
					- sum(INTMOE),
					- sum(INTMON)
			  from #request.INTARC# s
			 where LIN_IDREF = 7
			 group by s.Ocodigo
		</cfquery>

		<!--- 5) Asiento de Cierre: 
					Mata Ingreso Autorizado + Egreso Autorizados contra Superavit/Deficit
		--->
		<!--- Ingresos y Egresos Autorizados --->
		<cfquery name="rsEgresoDevengado" datasource="#Arguments.Conexion#">
			insert into #request.INTARC# 
				( 
					INTORI, INTREL, INTDOC, INTREF, 
					INTFEC, Periodo, Mes, 
					INTDES, INTTIP,
					Mcodigo, INTCAM, 

					LIN_IDREF,
					Ocodigo, Ccuenta,  
					INTMOE, INTMON
				)
			select 	'CGCP', 0, 'CIERRE #Arguments.Periodo#-#Arguments.Mes#', 'CONTA PRESUPUESTAL', 
					'#LvarINTFEC#', #Arguments.Periodo#, #Arguments.Mes#, 
					'Asiento Cierre: Egresos e Ingresos Autorizados contra #rsRESULTADOs.Tipo#', 'D',
					#LvarMcodigoLocal#, 1, 
					
					9, 									<!--- LIN_IDREF: 9=Ingresos y Egresos Autorizados --->
					x.Ocodigo, x.Ccuenta,
					sum(x.Monto),
					sum(x.Monto)
			  from (
						<!--- Saldo final de mes --->
						select 	s.Ocodigo, s.Ccuenta,
								- (SLinicial + DLdebitos - CLcreditos) as Monto
						  from SaldosContables s
							inner join CContables c
								 on c.Ccuenta	= s.Ccuenta
								and c.Cmayor	in (
													select Cmayor from CPtipoMovContable 
													 where CPPid=#LvarCPPid#
													   and CPCCtipo in ('I','E','C') and CPTMtipoMov in ('A','M','VC')
													)
								and c.Cmovimiento = 'S'
						 where s.Ecodigo	= #Arguments.Ecodigo#
						   and s.Speriodo	= #Arguments.Periodo#
						   and s.Smes		= #Arguments.Mes#
						UNION
						<!--- Movimientos del Asiento --->
						select 	s.Ocodigo, s.Ccuenta,
								- INTMON as Monto
						  from #request.INTARC# s
						 where LIN_IDREF in (2,4)
					) x
			 group by x.Ccuenta, x.Ocodigo
		</cfquery>
		<!--- Resultados: Superavit o Deficit --->
		<cfquery name="rsEgresoDevengado" datasource="#Arguments.Conexion#">
			insert into #request.INTARC# 
				( 
					INTORI, INTREL, INTDOC, INTREF, 
					INTFEC, Periodo, Mes, 
					INTDES, INTTIP,
					Mcodigo, INTCAM, 

					LIN_IDREF,
					Ocodigo, Ccuenta,  
					INTMOE, INTMON
				)
			select 	'CGCP', 0, 'CIERRE #Arguments.Periodo#-#Arguments.Mes#', 'CONTA PRESUPUESTAL', 
					'#LvarINTFEC#', #Arguments.Periodo#, #Arguments.Mes#, 
					'Asiento Cierre: Egresos e Ingresos Autorizados contra #rsRESULTADOs.Tipo#', 'D',
					#LvarMcodigoLocal#, 1, 
					
					10, 									<!--- LIN_IDREF: 10=Superavit/Deficit --->
					s.Ocodigo, 
					#rsRESULTADOs.Ccuenta#,
					- sum(INTMOE),
					- sum(INTMON)
			  from #request.INTARC# s
			 where LIN_IDREF = 9
			 group by s.Ocodigo
		</cfquery>
        
        <cfquery name="rsTotal" datasource="#session.DSN#">
        	select INTMON,INTMOE from #request.INTARC#
            where Ccuenta in (select Ccuenta FROM CContables
							  where Cmayor = 8240 and Cmovimiento = 'S')
        </cfquery>
     	<!---<cf_dump var = "#rsTotal#">--->
        <cfinvoke component="CG_GeneraAsiento" returnvariable="IDcontable" method="GeneraAsiento">
			<cfinvokeargument name="Oorigen"		value="CGCP">
			<cfinvokeargument name="Cconcepto"		value="#rsConceptoContableE.Cconcepto#">
			<cfinvokeargument name="Eperiodo"		value="#Arguments.Periodo#">
			<cfinvokeargument name="Emes"			value="#Arguments.Mes#">
			<cfinvokeargument name="Efecha"			value="#LvarFecha#">
			<cfinvokeargument name="Edescripcion"	value="Cierre de la Contabilidad Presupuestal">
			<cfinvokeargument name="Edocbase"		value="CIERRE #Arguments.Periodo#-#Arguments.Mes#">
			<cfinvokeargument name="Ereferencia"	value="CONTA PRESUPUESTAL">
			<cfinvokeargument name="interfazconta"	value="true">
			<cfinvokeargument name="debug"			value="false">
			<cfinvokeargument name="CierreAnual"	value="true">
		</cfinvoke>	
		<cfquery name="updEContable" datasource="#Arguments.Conexion#">
			update EContables
			   set ECtipo = 1
			 where IDcontable = #IDcontable#
		</cfquery>
<!--- Cierre Anual de Contabilid​ad Presupuest​aria despues de retroactiv​os Inicia--->
 		<!---<cfif IDcontable gt 0>--->
            <cfquery name="Update_PRECierreCont" datasource="#Arguments.Conexion#">
                update PRECierreCont 
                set EConsec = 0
                where Ecodigo=#Arguments.Ecodigo#
            </cfquery>  
            <cfquery name="Insert_PRECierreCont" datasource="#Arguments.Conexion#">
                insert into PRECierreCont (Ecodigo,IDcontable,Eperiodo,Emes,EConsec,BMUsucodigo)
                values (#Arguments.Ecodigo#,#IDcontable#,#Arguments.Periodo#,#Arguments.Mes#,1,#session.Usucodigo#)
            </cfquery>
        <!---</cfif>--->
<!--- Cierre Anual de Contabilid​ad Presupuest​aria despues de retroactiv​os Inicia--->
		<cfreturn IDcontable>
	</cffunction>

	<cffunction name="NAPinicio">
		<cfargument name="Ecodigo">
		<cfargument name="Periodo">
		<cfargument name="Mes">
		<cfargument name="Conexion">

		<!---
			NAP de Apertura:
				Pasar todos los detalles de CxP Ejecutados no pagados (EDsaldo/Dtotal) a Ejecución inicio año
				Pasar todos los detalles de CxC Ejecutados no cobrados a Ejecución inicio año
		--->
		<cfset LvarFecha	= createDate(Arguments.Periodo, Arguments.Mes, 1)>

		<cfquery datasource="#Arguments.Conexion#">
			delete from #request.IntPresupuesto# 
		</cfquery>

		<cfquery datasource="#Arguments.Conexion#">
			delete from #request.intarc# 
		</cfquery>

		<!--- Saldos de CxP --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into #request.intPresupuesto#
				( 	
					ModuloOrigen,
					NumeroDocumento,
					NumeroReferencia,
					FechaDocumento,
					AnoDocumento,
					MesDocumento,
					CFcuenta,
					CPcuenta,
					Ocodigo,
					Mcodigo,
					MontoOrigen,
					TipoCambio,
					Monto,
					TipoMovimiento
				)
			select  'CGCP',
					'INICIO #Arguments.Periodo#-#Arguments.Mes#',
					'CONTA PRESUPUESTAL',
					<cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LvarFecha#">,
					#Arguments.Periodo#,
					#Arguments.Mes#,
					min(d.CFcuenta),
					d.CPcuenta,
					d.Ocodigo,
					d.Mcodigo,
					round(sum(d.CPNAPDmontoOri * (EDsaldo/Dtotal)),2),
					avg(EDtcultrev),
					round(round(sum(d.CPNAPDmontoOri * (EDsaldo/Dtotal)),2)*avg(EDtcultrev),2),
					d.CPNAPDtipoMov
			from EDocumentosCP cxp
				inner join CPNAP n
					 on n.Ecodigo	= cxp.Ecodigo
					and n.CPNAPnum	= cxp.NAP
                    and n.CPCano < <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Periodo#">
				inner join CPNAPdetalle d
					 on d.Ecodigo		= n.Ecodigo
					and d.CPNAPnum		= n.CPNAPnum
					and d.CPNAPDtipoMov	in ('E','E2')
			where cxp.Ecodigo		= #Arguments.Ecodigo#
			  and cxp.EDsaldo		> 0
			  and cxp.Dtotal		> 0
			  and coalesce(cxp.NAP,0) <> 0
			group by d.CPcuenta,
					 d.Ocodigo,
					 d.Mcodigo,
					 d.CPNAPDtipoMov
		</cfquery>
		<!--- Saldos de CxC --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into #request.intPresupuesto#
				( 	
					ModuloOrigen,
					NumeroDocumento,
					NumeroReferencia,
					FechaDocumento,
					AnoDocumento,
					MesDocumento,
					CFcuenta,
					CPcuenta,
					Ocodigo,
					Mcodigo,
					MontoOrigen,
					TipoCambio,
					Monto,
					TipoMovimiento
				)
			select  'CGCP',
					'INICIO #Arguments.Periodo#-#Arguments.Mes#',
					'CONTA PRESUPUESTAL',
					<cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LvarFecha#">,
					#Arguments.Periodo#,
					#Arguments.Mes#,
					min(d.CFcuenta),
					d.CPcuenta,
					d.Ocodigo,
					d.Mcodigo,
					round(sum(d.CPNAPDmontoOri * (Dsaldo/Dtotal)),2),
					avg(Dtcultrev),
					round(round(sum(d.CPNAPDmontoOri * (Dsaldo/Dtotal)),2)*avg(Dtcultrev),2),
					d.CPNAPDtipoMov
			from Documentos cxc
				inner join CPNAP n
					  on n.Ecodigo				= cxc.Ecodigo
					 and n.CPNAPmoduloOri		= 'CCFC'
					 and n.CPNAPdocumentoOri	= cxc.Ddocumento
					 and n.CPNAPreferenciaOri	= cxc.CCTcodigo
                     and n.CPCano < <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Periodo#">
				inner join CPNAPdetalle d
					 on d.Ecodigo		= n.Ecodigo
					and d.CPNAPnum		= n.CPNAPnum
					and d.CPNAPDtipoMov	in ('E','E2')
			where cxc.Ecodigo		= #Arguments.Ecodigo#
			  and cxc.Dsaldo		> 0
			  and cxc.Dtotal		> 0
			group by d.CPcuenta,
					 d.Ocodigo,
					 d.Mcodigo,
					 d.CPNAPDtipoMov
		</cfquery>
		<!--- Nominas no pagadas --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into #request.intPresupuesto#
				( 	
					ModuloOrigen,
					NumeroDocumento,
					NumeroReferencia,
					FechaDocumento,
					AnoDocumento,
					MesDocumento,
					CFcuenta,
					CPcuenta,
					Ocodigo,
					Mcodigo,
					MontoOrigen,
					TipoCambio,
					Monto,
					TipoMovimiento
				)
			select  'CGCP',
					'INICIO #Arguments.Periodo#-#Arguments.Mes#',
					'CONTA PRESUPUESTAL',
					<cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LvarFecha#">,
					#Arguments.Periodo#,
					#Arguments.Mes#,
					(select min(CFcuenta) from CFinanciera where CPcuenta = d.CPcuenta),
					d.CPcuenta,
					d.Ocodigo,
					d.Mcodigo,
					d.CPNAPDmontoOri,
					d.CPNAPDtipoCambio,
					d.CPNAPDmonto,
					d.CPNAPDtipoMov
			 from CPNAPdetalle d
	             inner join CPNAP n 
                	on d.Ecodigo		= n.Ecodigo
					and d.CPNAPnum		= n.CPNAPnum
                    and n.CPCano < <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Periodo#">
			where d.Ecodigo		= #Arguments.Ecodigo#
			  and d.CPNAPnum	in 
			  		(
						select H.NAP
						  from sif_interfaces..IE925 e 
							inner join sif_interfaces..ID925 d 	on d.ID=e.ID 
							inner join TESsolicitudPago sp 		on sp.TESSPid = d.Id_Solicitud
							inner join HEContables H 			on H.Edocbase = e.Num_Nomina and H.Cconcepto = e.Cconcepto and H.Eperiodo = e.Periodo and H.Emes = e.Mes
						   where sp.EcodigoOri	= d.Ecodigo
						     and sp.TESSPestado	= 11
					)
			  and d.CPNAPDtipoMov	in ('E','E2')
		</cfquery>
		<cfset request.CP_DescompromisosAutomatico = true>
		<cfset request.PRES_ContaPresupuestaria = true>
		<cfinvoke 	component			= "sif.Componentes.PRES_Presupuesto"	
					method				= "ControlPresupuestario"
					returnvariable		= "LvarNAP"
					
					Ecodigo				= "#Arguments.Ecodigo#"
					ModuloOrigen 		= "CGCP"
					NumeroDocumento		= "INICIO #Arguments.Periodo#-#Arguments.Mes#"
					NumeroReferencia	= "CONTA PRESUPUESTAL"
					FechaDocumento		= "#LvarFecha#"
					AnoDocumento		= "#Arguments.Periodo#"
					MesDocumento		= "#Arguments.Mes#"
		/>
		<cfreturn LvarNAP>
	</cffunction>
</cfcomponent>


