<cfcomponent>
	<!---<cffunction name="GetRHTipoAccionCambio" access="public" returntype="query">
    	<cfreturn GetRHTipoAccion('CMB')>
	</cffunction>--->
    <!---<cffunction name="GetRHTipoAccionIncap" access="public" returntype="query">
    	<cfreturn GetRHTipoAccion('INC')>
	</cffunction>
    <cffunction name="GetRHTipoAccionVacas" access="public" returntype="query">
    	<cfreturn GetRHTipoAccion('VAC')>
	</cffunction>--->
<!---    <cffunction name="GetRHTipoAccionNombramiento" access="public" returntype="query">
    	<cfreturn GetRHTipoAccion('NOM')>
	</cffunction>
    <cffunction name="GetRHTipoAccionNombramientoTemporal" access="public" returntype="query">
    	<cfreturn GetRHTipoAccion('TEM')>
	</cffunction>--->
    <!---<cffunction name="GetRHTipoAccionAnulacion" access="public" returntype="query">
    	<cfreturn GetRHTipoAccion('VAN')>
	</cffunction>--->
<!---================================================================================================--->
	<cffunction name="GetRHTipoAccion" access="public" returntype="query">
        <cfargument name="RHTcodigo" 	type="string"  required="no" hint="Codigo del Tipo Accion">
        <cfargument name="conexion"     type="string"  required="no" hint="Nombre del DataSource">
        <cfargument name="Ecodigo" 	    type="numeric" required="no" hint="Codigo de la Empresa">
		<cfargument name="RHTcomportam" type="numeric" required="no" hint="Comportamiento de la Acción">
        <cfargument name="RHTtiponomb"  type="numeric" required="no" hint="Tipo de Nombramiento(0-Permanente,1-Practicante,2-Transitorio,3-Ocasional)">
        <cfargument name="RHTid" 		type="numeric" required="no" hint="Id del Tipo de Acción">
        
		 <cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfquery name="rsRHTipoAccion" datasource="#Arguments.conexion#">
        	select RHTid,Ecodigo,RHTcodigo,RHTdesc,RHTpaga,RHTpfijo,RHTpmax,RHTcomportam,RHTposterior,RHTautogestion,RHTindefinido,
                   RHTcempresa,RHTctiponomina,RHTcregimenv,RHTcoficina,RHTcdepto,RHTcplaza,RHTcpuesto,RHTccomp,RHTcsalariofijo,
                   RHTccatpaso,RHTvisible,RHTcjornada,RHTidtramite,RHTnorenta,RHTnocargas,RHTnodeducciones,RHTnoretroactiva,RHTcuentac,
                   CIncidente1,CIncidente2,RHTcantdiascont,RHTnocargasley,RHTnoveriplaza,RHTliquidatotal,BMUsucodigo,RHTdatoinforme,
                   RHTpension,RHTnomarca,RHTfanual,RHTfvacacion,RHTalerta,RHTdiasalerta,ts_rversion,RHTtiponomb,RHTafectafantig,
                   RHTafectafvac,RHTespecial,RHTnopagaincidencias,RHTNoMuestraCS,RHTporc,RHTporcsal,RHTporcPlazaCHK,RHTsubcomportam,
                   RHCatParcial,RHAcumAnualidad
            	from RHTipoAccion
            where Ecodigo = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
            <cfif isdefined('Arguments.RHTcodigo')>
             and RHTcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.RHTcodigo#">
            </cfif>
			<cfif isdefined('Arguments.RHTcomportam')>
             and RHTcomportam = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Arguments.RHTcomportam#">
            </cfif>
            <cfif isdefined('Arguments.RHTtiponomb')>
             and RHTtiponomb = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Arguments.RHTtiponomb#">
            </cfif>
            <cfif isdefined('Arguments.RHTid')>
             and RHTid = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Arguments.RHTid#">
            </cfif>
            
        </cfquery>
		<cfreturn rsRHTipoAccion>
	</cffunction>
<!---================================================================================================--->
	<cffunction name="AltaRHAccion" access="public" returntype="numeric">
        <cfargument name="DEid" 					type="numeric" 	required="yes">
        <cfargument name="RHTid" 					type="numeric" 	required="yes">
        <cfargument name="DLfvigencia" 				type="date" 	required="no" default="#NOW()#">
        <cfargument name="DLffin" 					type="any" 		required="no" default="">
        <cfargument name="DLobs" 					type="string" 	required="no" default="">        
        <cfargument name="EcodigoRef" 				type="numeric" 	required="no" default="-1">
        <cfargument name="RHAporcsal" 				type="numeric" 	required="no" default="100">
        <cfargument name="RHItiporiesgo" 			type="numeric" 	required="no" default="-1" hint="Tipo de Riesgo">
        <cfargument name="RHIconsecuencia" 			type="numeric" 	required="no" default="-1" hint="Consecuencia">
        <cfargument name="RHIcontrolincapacidad" 	type="numeric" 	required="no" default="-1" hint="Control de Incapacidad">
        <cfargument name="RHfolio" 					type="string" 	required="no" default="">
        <cfargument name="RHporcimss" 				type="numeric" 	required="no" default="-1">
        <cfargument name="Ulocalizacion" 			type="string" 	required="no">
        <cfargument name="Tcodigo" 					type="string" 	required="no" default=""   hint="Tipo de Nomina">
        <cfargument name="RHJid" 					type="numeric" 	required="no" default="-1" hint="Jornada">
        <cfargument name="Dcodigo" 					type="numeric" 	required="no" default="-1" hint="Departamento">
        <cfargument name="Ocodigo" 					type="numeric" 	required="no" default="-1" hint="Codigo de Oficina">
        <cfargument name="RHPcodigo" 				type="string" 	required="no" default=""   hint="Codigo del Puesto">
        <cfargument name="RVid"		 				type="numeric" 	required="no" default="-1" hint="Regimen de Vacaciones">
        <cfargument name="RHPid"		 			type="numeric" 	required="no" default="-1" hint="Plaza">
        <cfargument name="DLsalario"		 		type="numeric" 	required="no" default="-1" hint="Salario">
        <cfargument name="RHAporc" 					type="numeric" 	required="no" default="100" hint="Porcentaje de la Plaza">
        <cfargument name="RHAvdisf" 				type="numeric" 	required="no" default="-1" hint="Cantidad de días de vacaciones">
        
        
        
        <cfargument name="Ecodigo" 					type="numeric" 	required="no">
        <cfargument name="UsuCodigo"   				type="numeric" 	required="no" hint="Usuario del Portal">
        <cfargument name="conexion"    				type="string"  	required="no" hint="Nombre del DataSource">
        
        <cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.UsuCodigo') and isdefined('session.UsuCodigo')>
        	<cfset Arguments.UsuCodigo = session.UsuCodigo>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfif not isdefined('Arguments.Ulocalizacion') and isdefined('session.Ulocalizacion')>
        	<cfset Arguments.Ulocalizacion = session.Ulocalizacion>
        </cfif>        
 
        <cfquery name="ABC_RHAcciones" datasource="#Arguments.conexion#">
				insert into RHAcciones (Ecodigo, DEid, RHTid, DLfvigencia, DLffin, DLobs, Usucodigo, Ulocalizacion, EcodigoRef,RHAporcsal,
										RHItiporiesgo, RHIconsecuencia, RHIcontrolincapacidad, RHfolio, RHporcimss,BMUsucodigo,BMfecha,
                                        Tcodigo,RHJid,Dcodigo,Ocodigo,RHPcodigo,RVid,RHPid,DLsalario,RHAporc,RHAvdisf)
				values (
					<cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#Arguments.Ecodigo#">, 
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#Arguments.DEid#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#Arguments.RHTid#">, 
					<cf_jdbcquery_param cfsqltype="cf_sql_date" 	 value="#Arguments.DLfvigencia#">, 
					<cf_jdbcquery_param cfsqltype="cf_sql_date"      value="#Arguments.DLffin#" voidnull>, 
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#Arguments.DLobs#" voidnull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#Arguments.Usucodigo#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_char"      value="#Arguments.Ulocalizacion#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#Arguments.EcodigoRef#" voidnull null="#Arguments.EcodigoRef EQ -1#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#Arguments.RHAporcsal#">,
                    <cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#Arguments.RHItiporiesgo#" voidnull null="#Arguments.RHItiporiesgo EQ -1#">,
                    <cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#Arguments.RHIconsecuencia#" voidnull null="#Arguments.RHIconsecuencia EQ -1#">,
                    <cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#Arguments.RHIcontrolincapacidad#" voidnull null="#Arguments.RHIcontrolincapacidad EQ -1#">,
                    <cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#Arguments.RHfolio#" voidnull>,
					<cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#Arguments.RHporcimss#" voidnull null="#Arguments.RHporcimss EQ -1#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#Arguments.UsuCodigo#">,
					<cf_jdbcquery_param cfsqltype="cf_sql_date"      value="#now()#">,
                    <cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#Arguments.Tcodigo#"   voidnull>,
                    <cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#Arguments.RHJid#"     voidnull null="#Arguments.RHJid EQ -1#">,
                    <cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#Arguments.Dcodigo#"   voidnull null="#Arguments.Dcodigo EQ -1#">,
                    <cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#Arguments.Ocodigo#"   voidnull null="#Arguments.Ocodigo EQ -1#">,
                    <cf_jdbcquery_param cfsqltype="cf_sql_varchar"   value="#Arguments.RHPcodigo#" voidnull>,
                    <cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#Arguments.RVid#"      voidnull null="#Arguments.RVid EQ -1#">,
                    <cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#Arguments.RHPid#"     voidnull null="#Arguments.RHPid EQ -1#">,
                    <cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#Arguments.DLsalario#" voidnull null="#Arguments.DLsalario EQ -1#">,
                    <cf_jdbcquery_param cfsqltype="cf_sql_numeric"   value="#Arguments.RHAporc#"   voidnull null="#Arguments.RHAporc EQ -1#">,
                    <cf_jdbcquery_param cfsqltype="cf_sql_integer"   value="#Arguments.RHAvdisf#"  voidnull null="#Arguments.RHAvdisf EQ -1#">
				)
				<cf_dbidentity1 datasource="#Session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#Session.DSN#" name="ABC_RHAcciones">
            <cfreturn ABC_RHAcciones.identity>
    </cffunction>
	<!---================================================================================================--->
	<cffunction name="AltaRHDAcciones" access="public">
     	<cfargument name="RHAlinea" 	  type="numeric" 	required="no" hint="Línea de la Acción">
        <cfargument name="Ecodigo" 		  type="numeric" 	required="no" hint="Codigo de la Empresa">
        <cfargument name="UsuCodigo"   	  type="numeric" 	required="no" hint="Usuario del Portal">
        <cfargument name="conexion"    	  type="string"  	required="no" hint="Nombre del DataSource">
        <cfargument name="Ulocalizacion"  type="string" 	required="no">
        <cfargument name="RHDAmontobase"  type="numeric" 	required="no" default="0">
        <cfargument name="RHDAmontores"   type="numeric" 	required="no" default="0">
        <cfargument name="CSid"   		  type="numeric" 	required="no" default="0">
        <cfargument name="RHDAunidad"     type="numeric" 	required="no" default="1" hint="Unidades">
        
        <cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.UsuCodigo') and isdefined('session.UsuCodigo')>
        	<cfset Arguments.UsuCodigo = session.UsuCodigo>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfif not isdefined('Arguments.Ulocalizacion') and isdefined('session.Ulocalizacion')>
        	<cfset Arguments.Ulocalizacion = session.Ulocalizacion>
        </cfif>
        <cfquery name="insComponente" datasource="#Arguments.conexion#">
            insert into RHDAcciones (RHAlinea, CSid, RHDAunidad, RHDAmontobase, RHDAmontores, Usucodigo, Ulocalizacion) values
            	   (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">, 
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CSid#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHDAunidad#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHDAmontobase#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHDAmontores#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">, 
                    <cfqueryparam cfsqltype="cf_sql_char"    value="#Arguments.Ulocalizacion#">
                    )
        </cfquery>
	</cffunction>
    
    <cffunction name="fnAgregaConceptosPago" access="public">
    	<cfargument name="RHAlinea"     type="numeric" 	required="yes">
        <cfargument name="DEid"     	type="numeric" 	required="yes">
    	<cfargument name="RHTid"     	type="numeric" 	required="yes">
        
        <cfquery name="rsTipoAccion" datasource="#Session.DSN#">
            select RHTcomportam
            from RHTipoAccion
            where RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTid#">
		</cfquery>
        <cfif rsTipoAccion.RHTcomportam NEQ 1 >
            <cfquery name="checkMaxLTid" datasource="#session.DSN#">
                select max (LThasta) as Fhasta
                from LineaTiempo 
                where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">						
            </cfquery>
            
            <cfif isdefined("checkMaxLTid") or (checkMaxLTid.recordcount GT 0) >
                <cfset Fhasta= "#checkMaxLTid.Fhasta#">	
            <cfelse>
                <cfset Fhasta = '61000101'>
            </cfif>
            <cfquery datasource="#session.DSN#">
                update RHAcciones
                set DLffin = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fhasta#">
                Where RHAlinea=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
                and DLffin is null 
            </cfquery>
       </cfif>
     	<cfquery name="rsConsTipoAccion" datasource="#Session.DSN#">
            select RHTcomportam, RHTcempresa, RHTnoveriplaza, RHTpfijo, coalesce(RHTsubcomportam,0) as RHTsubcomportam
            from RHTipoAccion
            where RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHTid#">
		</cfquery>
    	<cfquery name="rsConceptos" datasource="#Session.DSN#">
            select a.DLfvigencia, 
                   a.DLffin, 
                   a.DEid, 
                   <cfif rsConsTipoAccion.RHTcomportam EQ 9 and rsConsTipoAccion.RHTcempresa EQ 1>
                   a.EcodigoRef as Ecodigo, 
                   <cfelse>
                   a.Ecodigo, 
                   </cfif>
                   a.RHTid, 
                   a.RHAlinea, 
                   coalesce(a.RHJid, 0) as RHJid, 
                   c.CIid, 
                   c.CIcantidad, c.CIrango, c.CItipo, c.CIcalculo, c.CIdia, c.CImes
                   ,CIsprango, coalesce(CIspcantidad,0) as CIspcantidad, coalesce(CImescompleto,0) as CImescompleto
            from RHAcciones a, ConceptosTipoAccion b, CIncidentesD c
            where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
            and a.RHTid = b.RHTid
            and b.CIid = c.CIid
        </cfquery>
        <cfloop query="rsConceptos">		
        	<cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")>			
            <cfset FVigencia = LSDateFormat(rsConceptos.DLfvigencia, 'DD/MM/YYYY')>
            <cfset FFin = LSDateFormat(rsConceptos.DLffin, 'DD/MM/YYYY')>
            <cfset current_formulas = rsConceptos.CIcalculo>
            
            <cfset presets_text = RH_Calculadora.get_presets(CreateDate(ListGetAt(FVigencia,3,'/'), ListGetAt(FVigencia,2,'/'), ListGetAt(FVigencia,1,'/')),
                                           CreateDate(ListGetAt(FFin,3,'/'), ListGetAt(FFin,2,'/'), ListGetAt(FFin,1,'/')),
                                           rsConceptos.CIcantidad,
                                           rsConceptos.CIrango,
                                           rsConceptos.CItipo,
                                           rsConceptos.DEid,
                                           rsConceptos.RHJid,
                                           rsConceptos.Ecodigo,
                                           rsConceptos.RHTid,
                                           rsConceptos.RHAlinea,
                                           rsConceptos.CIdia,
                                           rsConceptos.CImes,
                                           "", <!--- Tcodigo solo se requiere si no va RHAlinea--->
                                           FindNoCase('SalarioPromedio', current_formulas), <!--- optimizacion - SalarioPromedio es el calculo más pesado--->
                                           'false',
                                           '',
                                           FindNoCase('DiasRealesCalculoNomina', current_formulas) <!--- optimizacion - DiasRealesCalculoNomina es el segundo calculo mas pesado--->
                                           , 0
                                           , '' 
                                           ,rsConceptos.CIsprango
                                           ,rsConceptos.CIspcantidad
                                           ,rsConceptos.CImescompleto)>
            <cfset values = RH_Calculadora.calculate( presets_text & ";" & current_formulas )>
            <cfset calc_error = RH_Calculadora.getCalc_error()>
            <cfif Not IsDefined("values")>
                <cfif isdefined("presets_text")>
                    <cf_throw message="#presets_text# & '----' & #current_formulas# & '-----' & #calc_error#">
                <cfelse>
                    <cf_throw message="#calc_error#" >
                </cfif>
            </cfif>
            
            <cfquery name="updConceptos" datasource="#Session.DSN#">
                insert into RHConceptosAccion(RHAlinea, CIid, RHCAimporte, RHCAres, RHCAcant, CIcalculo,BMUsucodigo,BMfecha)
                values (
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConceptos.CIid#">,
                    <cfqueryparam cfsqltype="cf_sql_money" value="#values.get('importe').toString()#">,
                    <cfqueryparam cfsqltype="cf_sql_money" value="#values.get('resultado').toString()#">,
                    <cfqueryparam cfsqltype="cf_sql_float" value="#values.get('cantidad').toString()#">,
                    <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#presets_text & ';' & current_formulas#">
                    ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
                    ,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                )
            </cfquery> 
        </cfloop>
    </cffunction>
</cfcomponent>


<!---
Value	Label
1	Nombramiento
2	Cese
3	Vacaciones
4	Permiso
5	Incapacidad
6	Cambio
7	Anulación
8	Aumento
9	Cambio Empresa
10	Anotaciones
11	Cambio Antigüedad
12	Recargos Plazas
13	Ausencia / Falta
14	Cambio de Puesto
--->