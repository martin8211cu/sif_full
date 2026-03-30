<cfcomponent>
	<!---???Validas que todos los Centros Funcionales tengan la Actividad Empresarial???--->
	<cffunction name="ValidaActividadEmpresarial" 
				access="public" hint="Verifica que exista la Actividad Empresarial en los Centros Funcionales de la Póliza en la Nómina"
				 returntype="any">
    	<cfargument name="RCNid" 	type="numeric" required="yes" hint="Id del Nomina">
	   	<cfargument name="Errores" 	type="any" required="yes" hint="Tabla de Errores">		
        <cfargument name="Conexion" type="string"  required="no"  hint="nombre del DataSource">			
		 
		<cf_dbfunction name="OP_concat" returnvariable="CAT">		 
		<cfquery name="InsertErrores" datasource="#session.dsn#">
				insert into #Errores#(tiporeg, descripcion, tipoerr)
				select distinct 91, 'El Centro Funcional ' #CAT# rtrim(CFcodigo) #CAT# '. ' #CAT# rtrim(CFdescripcion) #CAT# ' no tiene definido la Actividad Empresarial' as ErrorDetectado, 8
				from RCuentasTipo rct
					inner join CFuncional cf
					on rct.CFid = cf.CFid
				Where Coalesce(cf.CFComplemento,'') = ''
				and Coalesce(rct.valor,'') <>''  <!--- Máscaras que hay que armar --->
				and rct.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
		</cfquery>	
		<cfreturn #Errores#>
	</cffunction>
	<!---???Actualiza el formato de RCuentasTipo???--->
	<cffunction name="ActualizaFormatoRCuentasTipo" access="public" hint="Actualiza el formato de RCuentasTipo">
    	<cfargument name="RCNid" 	type="numeric" required="yes" hint="Id del Nomina">
        <cfargument name="Periodo" 	type="numeric" required="no"  hint="Periodo">
        <cfargument name="Mes" 		type="numeric" required="no"  hint="Mes">
        <cfargument name="Conexion" type="string"  required="no"  hint="nombre del DataSource">
        
    	<cfif NOT ISDEFINED('Arguments.conexion') AND ISDEFINED('SESSION.DSN')>
        	<CFSET Arguments.conexion = session.dsn>	
        </cfif>
        
        <cfobject component="sif.Componentes.AplicarMascara" name="mascara">
        <!---??Activar Transaccionabilidad de Actividad Empresarial??--->
        <cfquery name="rsAE" datasource="#session.dsn#">
            select Coalesce(Pvalor,'N') as Pvalor 
                from Parametros 
              where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                and Pcodigo = 2200
        </cfquery>
		<!---??Se obtienen los datos necesarios para el armado de la cuenta--->
        <cfquery datasource="#Arguments.conexion#" name="RsCuentas">
				select  distinct 
						rct.CFid,
						Coalesce(rct.cuenta,'') 		as MascaraFinanciera,
						Coalesce(rct.valor,'')   		as ComplementoOG, <!---Complemento del Objeto de gasto		   (?)--->
						Coalesce(pp.Complemento,'') 	as ComplementoPP, <!---Complemento de la plaza presupuestaria  (*)--->
						Coalesce(pu.Complemento,'') 	as ComplementoMP, <!---Complemento del Maestro de Puestos 	   (!)--->
						Coalesce(cf.CFComplemento,'') 	as ComplementoAE  <!---Complemento de la Actividad empresarial (_)--->
						
					from RCuentasTipo rct
						left outer join RHPlazaPresupuestaria pp
							on pp.RHPPid = rct.RHPPid
							
						left outer join LineaTiempo lt
								inner join RHPuestos p
										inner join RHMaestroPuestoP pu
											on pu.RHMPPid = p.RHMPPid
									on p.RHPcodigo = lt.RHPcodigo
								   and p.Ecodigo   = lt.Ecodigo
							on lt.DEid = rct.DEid
							and <cf_dbfunction name="now"> between lt.LTdesde and lt.LThasta
						 
						left outer join CFuncional cf
							on cf.CFid = rct.CFid
							
				where rct.RCNid = #Arguments.RCNid#
				<cfif ISDEFINED('Arguments.Periodo')>
					and Periodo 	= #Arguments.Periodo#
				</cfif>
				<cfif ISDEFINED('Arguments.Mes')>
					and Mes 	= #Arguments.Mes#
				</cfif>
				and Coalesce(rct.valor,'')<>''  <!--- 20111031 Se Hace el ciclo únicamente para las cuentas que hay que armar, se eliminan las de cuenta fija --->
        </cfquery>
        <cfloop query="RsCuentas">
            <cfset LvarFormatoCuenta = TRIM(RsCuentas.MascaraFinanciera)>
            <!---??Remplaza los (?) por el Complemento del Objeto de gasto??--->
			<cfif LEN(TRIM(RsCuentas.ComplementoOG))>
                <cfset LvarFormatoCuenta = mascara.AplicarMascara(LvarFormatoCuenta,TRIM(RsCuentas.ComplementoOG),'?')>
            </cfif>
            <!---??Remplaza los (*) por el Complemento de la plaza presupuestaria??--->
            <cfif LEN(TRIM(RsCuentas.ComplementoPP))>
                <cfset LvarFormatoCuenta = mascara.AplicarMascara(LvarFormatoCuenta,TRIM(RsCuentas.ComplementoPP),'*')>
            </cfif>
            <!---??Remplaza los (!) por el Complemento del Maestro de Puestos??--->
            <cfif LEN(TRIM(RsCuentas.ComplementoMP))>
                <cfset LvarFormatoCuenta = mascara.AplicarMascara(LvarFormatoCuenta,TRIM(RsCuentas.ComplementoMP),'!')>
            </cfif>
            <!---??Remplaza los (_) por el Complemento del Maestro de la Actividad Empresarial??--->
            <cfif LEN(TRIM(RsCuentas.ComplementoAE)) and rsAE.Pvalor EQ 'S'>
                <cfset LvarFormatoCuenta = mascara.AplicarMascara(LvarFormatoCuenta,replace(TRIM(RsCuentas.ComplementoAE),'-',''),'_')>
            </cfif>
            <cfquery datasource="#arguments.conexion#">
                update RCuentasTipo 
                    set Cformato =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(LvarFormatoCuenta)#">
				where RCNid = #Arguments.RCNid#
				<cfif ISDEFINED('Arguments.Periodo')>
				  and Periodo 	= #Arguments.Periodo#
				</cfif>
				<cfif ISDEFINED('Arguments.Mes')>
				  and Mes 	= #Arguments.Mes#
				</cfif>
				  and CFid						=  #RsCuentas.CFid#
				  and Coalesce(cuenta,'')		= '#RsCuentas.MascaraFinanciera#'
				  and Coalesce(valor,'')		= '#RsCuentas.ComplementoOG#'
            </cfquery>
        </cfloop>
    </cffunction>
    
    
    <!---???Actualiza el formato de Incidencias???--->
	<cffunction name="ActualizaFormatoIncidencias" access="public" hint="Actualiza el formato de las incidencias">
    	<cfargument name="Iid" 		type="string"  required="yes" hint="Listado de Id de las incidencias">
        <cfargument name="Conexion" type="string"  required="no"  hint="nombre del DataSource">
        
    	<cfif NOT ISDEFINED('Arguments.conexion') AND ISDEFINED('SESSION.DSN')>
        	<CFSET Arguments.conexion = session.dsn>	
        </cfif>
        
        <cfobject component="sif.Componentes.AplicarMascara" name="mascara">
        <!---??Activar Transaccionabilidad de Actividad Empresarial??--->
        <cfquery name="rsAE" datasource="#Arguments.conexion#">
            select Coalesce(Pvalor,'N') as Pvalor 
                from Parametros 
              where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                and Pcodigo = 2200
        </cfquery>
		<!---??Se obtienen los datos necesarios para el armado de la cuenta--->
        <cfquery datasource="#Arguments.conexion#" name="RsCuentas">
           select  Inc.Iid,
           		   Coalesce(cf.CFcuentac,'')   		as MascaraFinanciera,
           		   Coalesce(Ci.CIcuentac,'')  	 	as ComplementoOG, <!---Complemento del Objeto de gasto		   (?)--->
                   Coalesce(pp.Complemento,'') 		as ComplementoPP, <!---Complemento de la plaza presupuestaria  (*)--->
                   Coalesce(pu.Complemento,'') 		as ComplementoMP, <!---Complemento del Maestro de Puestos 	   (!)--->
                   Coalesce(cf.CFComplemento,'') 	as ComplementoAE  <!---Complemento de la Actividad empresarial (_)--->
              from Incidencias Inc
              
              	left outer join CIncidentes Ci
                	on Ci.CIid = Inc.CIid
                    
              	left outer join LineaTiempo lt
                	inner join RHPuestos p
                            inner join RHMaestroPuestoP pu
                                on pu.RHMPPid = p.RHMPPid
                    	on p.RHPcodigo = lt.RHPcodigo
                       and p.Ecodigo   = lt.Ecodigo
               		on lt.DEid = Inc.DEid
                    and <cf_dbfunction name="now"> between lt.LTdesde and lt.LThasta
                 
                 left outer join RHPlazas pl
                 		left outer join CFuncional cf
                        	on cf.CFid = pl.CFid
                 	on pl.RHPid = lt.RHPid
                    
                left outer join RHPlazaPresupuestaria pp
                	on pp.RHPPid = pl.RHPPid
                    
           where Iid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Iid#" list="yes">)  
        </cfquery>
        <cfloop query="RsCuentas">
            <cfset LvarFormatoCuenta = TRIM(RsCuentas.MascaraFinanciera)>
            <!---??Remplaza los (?) por el Complemento del Objeto de gasto??--->
            <cfif LEN(TRIM(RsCuentas.ComplementoOG))>
                <cfset LvarFormatoCuenta = mascara.AplicarMascara(LvarFormatoCuenta,TRIM(RsCuentas.ComplementoOG),'?')>
            </cfif>
            <!---??Remplaza los (*) por el Complemento de la plaza presupuestaria??--->
            <cfif LEN(TRIM(RsCuentas.ComplementoPP))>
                <cfset LvarFormatoCuenta = mascara.AplicarMascara(LvarFormatoCuenta,TRIM(RsCuentas.ComplementoPP),'*')>
            </cfif>
            <!---??Remplaza los (!) por el Complemento del Maestro de Puestos??--->
            <cfif LEN(TRIM(RsCuentas.ComplementoMP))>
                <cfset LvarFormatoCuenta = mascara.AplicarMascara(LvarFormatoCuenta,TRIM(RsCuentas.ComplementoMP),'!')>
            </cfif>
            <!---??Remplaza los (_) por el Complemento del Maestro de la Actividad Empresarial??--->
            <cfif LEN(TRIM(RsCuentas.ComplementoAE)) and rsAE.Pvalor EQ 'S'>
                <cfset LvarFormatoCuenta = mascara.AplicarMascara(LvarFormatoCuenta,replace(TRIM(RsCuentas.ComplementoAE),'-',''),'_')>
            </cfif>
            
            <cfquery datasource="#arguments.conexion#">
                update Incidencias 
                    set CFormato    =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(LvarFormatoCuenta)#">,
                        complemento =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(RsCuentas.ComplementoOG)#">
                where Iid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#RsCuentas.Iid#">
            </cfquery>
        </cfloop>
    </cffunction>
    
   
    <!---???Actualiza el formato de Incidencias???--->
	<cffunction name="ActualizaFormatoRHCLTPlaza" access="public" hint="Actualiza el formato de los traslados de Plazas">
    	<cfargument name="RHLTPid" 	type="numeric" required="yes" hint="ID de Linea de Tiempo Plaza">
        <cfargument name="Conexion" type="string"  required="no"  hint="nombre del DataSource">
        
    	<cfif NOT ISDEFINED('Arguments.conexion') AND ISDEFINED('SESSION.DSN')>
        	<CFSET Arguments.conexion = session.dsn>	
        </cfif>
        
        <cfobject component="sif.Componentes.AplicarMascara" name="mascara">
        <!---??Activar Transaccionabilidad de Actividad Empresarial??--->
        <cfquery name="rsAE" datasource="#session.dsn#">
            select Coalesce(Pvalor,'N') as Pvalor 
                from Parametros 
              where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                and Pcodigo = 2200
        </cfquery>
        
		<!---??Se obtienen los datos necesarios para el armado de la cuenta--->
        <cfquery datasource="#Arguments.conexion#" name="RsCuentas">
			select tp.RHCLTPid,
            		Coalesce(cf.CFcuentac,'')     as MascaraFinanciera,
                    Coalesce(cs.CScomplemento,'') as ComplementoOG, <!---Complemento del Objeto de gasto		 (?)--->
                    Coalesce(pp.Complemento,'')   as ComplementoPP, <!---Complemento de la plaza presupuestaria  (*)--->
                    Coalesce(pu.Complemento,'')   as ComplementoMP, <!---Complemento del Maestro de Puestos 	 (!)--->
                    Coalesce(cf.CFComplemento,'') as ComplementoAE  <!---Complemento de la Actividad empresarial (_)--->
                    
              from RHCLTPlaza tp
              
              	left outer join RHLineaTiempoPlaza ltp
                		inner join RHPlazaPresupuestaria pp
							on pp.RHPPid = ltp.RHPPid
                            
                        inner join RHMaestroPuestoP pu
							on pu.RHMPPid = ltp.RHMPPid
                            
					on ltp.RHLTPid = tp.RHLTPid
                    
                left outer join CFuncional cf
					on cf.CFid = ltp.CFidautorizado
                    
                left outer join ComponentesSalariales cs
					on cs.CSid = tp.CSid
                    
            where tp.RHLTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHLTPid#">
		</cfquery>	

        <cfloop query="RsCuentas">
            <cfset LvarFormatoCuenta = TRIM(RsCuentas.MascaraFinanciera)>
            <!---??Remplaza los (?) por el Complemento del Objeto de gasto??--->
            <cfif LEN(TRIM(RsCuentas.ComplementoOG))>
                <cfset LvarFormatoCuenta = mascara.AplicarMascara(LvarFormatoCuenta,TRIM(RsCuentas.ComplementoOG),'?')>
            </cfif>
            <!---??Remplaza los (*) por el Complemento de la plaza presupuestaria??--->
            <cfif LEN(TRIM(RsCuentas.ComplementoPP))>
                <cfset LvarFormatoCuenta = mascara.AplicarMascara(LvarFormatoCuenta,TRIM(RsCuentas.ComplementoPP),'*')>
            </cfif>
            <!---??Remplaza los (!) por el Complemento del Maestro de Puestos??--->
            <cfif LEN(TRIM(RsCuentas.ComplementoMP))>
                <cfset LvarFormatoCuenta = mascara.AplicarMascara(LvarFormatoCuenta,TRIM(RsCuentas.ComplementoMP),'!')>
            </cfif>
            <!---??Remplaza los (_) por el Complemento del Maestro de la Actividad Empresarial??--->
            <cfif LEN(TRIM(RsCuentas.ComplementoAE)) and rsAE.Pvalor EQ 'S'>
                <cfset LvarFormatoCuenta = mascara.AplicarMascara(LvarFormatoCuenta,replace(TRIM(RsCuentas.ComplementoAE),'-',''),'_')>
            </cfif>
            
            <cfquery datasource="#arguments.conexion#">
                update RHCLTPlaza 
                    set CFformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(LvarFormatoCuenta)#">
                where RHCLTPid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RsCuentas.RHCLTPid#">
            </cfquery>
        </cfloop>
    </cffunction>
</cfcomponent>