<cfcomponent>
	<!---Crea un nuevo tipo de Variación Presupuestal--->
	<cffunction name="AltaTipoVariacion"  access="public" returntype="numeric">
		<cfargument name="Conexion" 	    type="string"   required="no">
		<cfargument name="Ecodigo" 		    type="numeric"  required="no">
		<cfargument name="FPTVCodigo" 	    type="string"  	required="yes">
		<cfargument name="FPTVDescripcion"  type="string"  	required="yes">
		<cfargument name="FPTVTipo" 		type="numeric"  required="yes">
		<cfargument name="BMUsucodigo"      type="numeric"  required="no">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.BMUsucodigo')>
			<cfset Arguments.BMUsucodigo = session.Usucodigo>
		</cfif>
		<cfif Arguments.FPTVTipo eq -1 and fnExistePO()>
			<cfthrow message="Ya existe un Tipo de Periódo Ordinario para esta empresa.">
		</cfif>
		<cfquery datasource="#Arguments.Conexion#" name="rsATVE">
			insert into TipoVariacionPres
			( Ecodigo,FPTVCodigo,FPTVDescripcion,FPTVTipo,BMUsucodigo)
			values
			(
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.Ecodigo#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Trim(Arguments.FPTVCodigo)#" len="20">,
				<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Trim(Arguments.FPTVDescripcion)#" len="100">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.FPTVTipo#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.BMUsucodigo#">
			 )
		<cf_dbidentity1>
		</cfquery>
			  <cf_dbidentity2 name="rsATVE">
			  <cfreturn #rsATVE.identity#>
	</cffunction>
	<!---Modifica un tipo de Variación Presupuestal---><strong></strong>
	<cffunction name="CambioTipoVariacion"  access="public" returntype="numeric">
		<cfargument name="Conexion" 	    type="string"   required="no">
		<cfargument name="Ecodigo" 		    type="numeric"  required="no">
		<cfargument name="FPTVCodigo" 	    type="string"  	required="yes">
		<cfargument name="FPTVDescripcion"  type="string"  	required="yes">
		<cfargument name="FPTVTipo" 		type="numeric"  required="yes">
		<cfargument name="FPTVid"      		type="numeric"  required="yes">
		<cfargument name="ts_rversion"      type="any"  	required="yes">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif not isdefined('Arguments.BMUsucodigo')>
			<cfset Arguments.BMUsucodigo = session.Usucodigo>
		</cfif>
		
		<cf_dbtimestamp datasource="#Arguments.Conexion#" table="TipoVariacionPres"redirect="TipoVariacion.cfm?FPTVid=#Arguments.FPTVid#" timestamp="#Arguments.ts_rversion#"				
			field1="FPTVid" 
			type1="numeric"
			value1="#Arguments.FPTVid#">
		<cfquery datasource="#Arguments.Conexion#" name="rsActual">
			select FPTVTipo from TipoVariacionPres where FPTVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPTVid#">
		</cfquery>	
				
		<cfif rsActual.FPTVTipo EQ -1 and fnExistePO(Arguments.FPTVid)>
			<cfthrow message="Ya existe un Tipo de Periódo Ordinario para esta empresa.">
		</cfif>
		
		<cfquery datasource="#Arguments.Conexion#" name="rsATVE">
			update TipoVariacionPres set 
				Ecodigo			=	<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.Ecodigo#"> ,
				FPTVCodigo 		= 	<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Trim(Arguments.FPTVCodigo)#" 	  len="20">,
				FPTVDescripcion =	<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Trim(Arguments.FPTVDescripcion)#" len="100">,
				FPTVTipo 		= 	<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.FPTVTipo#">,
				BMUsucodigo 	= 	<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.BMUsucodigo#">
			where FPTVid		= 	<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.FPTVid#">
		</cfquery>
		<cfreturn Arguments.FPTVid>
	</cffunction>
	<!---Eliminación de un tipo de Variacion Presupuestal--->
	<cffunction name="BajaTipoVariacion"  access="public">
		<cfargument name="Conexion" 	    type="string"   required="no">
		<cfargument name="FPTVid" 		    type="numeric"  required="yes">
		<cfargument name="ts_rversion"      type="any"  	required="yes">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cf_dbtimestamp datasource="#Arguments.Conexion#" table="TipoVariacionPres"redirect="TipoVariacion.cfm?FPTVid=#Arguments.FPTVid#" timestamp="#Arguments.ts_rversion#"				
			field1="FPTVid" 
			type1="numeric"
			value1="#Arguments.FPTVid#">
			
		<cfquery datasource="#Arguments.Conexion#" name="rsATVE">
			delete from TipoVariacionPres
			  where FPTVid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.FPTVid#">
		</cfquery>
	</cffunction>
	<!---Objetine toda la informacion referente a la Variacion Presupuestal--->
	<cffunction name="GetTipoVariacion"  access="public" returntype="query">
		<cfargument name="Conexion" 	    type="string"   required="no">
		<cfargument name="FPTVid" 		    type="numeric"  required="yes">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>

		<cfquery datasource="#Arguments.Conexion#" name="rsATVE">
			select  FPTVid,Ecodigo,FPTVCodigo,FPTVDescripcion,FPTVTipo,BMUsucodigo,ts_rversion 
			   from TipoVariacionPres
			  where FPTVid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.FPTVid#">
		</cfquery>
			  <cfreturn rsATVE>
	</cffunction>
	
	<!--- Verifica si existe un tipo de variacion como Periodo Ordinario--->
	<cffunction name="fnExistePO"  access="public" returntype="numeric">
		<cfargument name="FPTVid" 		type="numeric"  required="no">
		<cfargument name="Conexion" 	type="string"   required="no">
		<cfargument name="Ecodigo" 	    type="string"   required="no">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>

		<cfquery name="ExistePO" datasource="#Arguments.Conexion#">
			select 1 
			from TipoVariacionPres 
			where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			  and FPTVTipo = -1 <!--- Es PO --->
			  <cfif isdefined('Arguments.FPTVid') and len(trim(Arguments.FPTVid))>
			  	and FPTVid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPTVid#">
			  </cfif>
		</cfquery>
		<cfreturn ExistePO.recordcount>
	</cffunction>
<!---=================================================================================================
	          Al aprobar un traslado Presupuestal mediante una Variacion del presupuesto, 
       esta tienen que modificar las Solicitudes de Compra, Ordenes de Compra y NAP Involucrados,
	                             siempre y cuando sea multiperiodo
==================================================================================================--->

<!---
	Cancelar NAP SC viejo
	Crear Nuevo NAP SC nuevo
	
	Obtener todas las OCs Asociadas:
		Cancelar NAP OC vieja
		Actualizar DOrdenCM con datos de PlanCompras (Incluyendo Impuestos) como ponderación entre OCvieja y SCvieja
		Calcula Impuestos y Totales de EOrdenCM (Quitando Impuestos por Linea)
		Crear Nuevo NAP OC nueva
		Actualizar NAP OC
		Actualizar NAPref OC (excluye NAP Reversion)
	
	Actualizar DSolicitudCompraCM con datos de PlanCompras: DScantidadNAP, DSmontoOriNAP
	Actualizar NAP SC
	Actualizar NAPref SC (excluye NAP Reversion)
--->
<cffunction name="ModificarPCGcompras" access="public">
		<cfargument name="Conexion" 			type="string"   required="no">
        <cfargument name="Ecodigo" 	    		type="numeric"  required="no">
        <cfargument name="NumeroVariaciacion" 	type="string"  	required="yes">
		<cfargument name="ESidsolicitud" 	  	type="numeric" 	required="yes">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>

		<cf_dbtemp name="mdfcNAP" returnVariable="CPNAPD" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="Linea" 			identity="yes"		type="numeric" mandatory="yes">
			<cf_dbtempcol name="Ecodigo" 		type="integer"      mandatory="yes">
			<cf_dbtempcol name="CPNAPnum" 		type="integer"      mandatory="yes">
			<cf_dbtempcol name="CPNAPDlinea"	type="integer"      mandatory="yes">
			<cf_dbtempcol name="CPcuenta" 		type="numeric"      mandatory="yes">
			<cf_dbtempcol name="Ocodigo" 		type="numeric"      mandatory="yes">
			<cf_dbtempcol name="SignoMonto"		type="money"  		mandatory="yes">
			<cf_dbtempcol name="SignoCantidad"	type="float"  	    mandatory="no">
			<cf_dbtempcol name="PCGDid" 		type="numeric"      mandatory="no">
		</cf_dbtemp>

		<cfset LvarNAPs = "">
		<cfif NOT LEN(TRIM(Arguments.NumeroVariaciacion))>
			<cfthrow message="No se ha definido un ID como linea de la variación">
		</cfif>
        <cfif NOT ISDEFINED('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
        <cfif NOT ISDEFINED('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		
		<!---Se valida la Solicitud de Orden de Compra--->
		<cfquery name="rsSC" datasource="#Arguments.Conexion#">
		     select count(1) cantidad  
             	from DSolicitudCompraCM 
             where ESidsolicitud = #Arguments.ESidsolicitud#
              and PCGDid is not null  
		</cfquery>
		<cfif rsSC.cantidad EQ 0 >		
		   <cfthrow message="No existe la Solicitud de Compra o no tiene lineas de detalle ligadas al plan de Compras">
		</cfif>
		<!---Obtencion del numero de NAP(Es el mismo para todas las lineas de la SC) y el ID de la linea del Plan de Compra----->	
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#"> 
			Select a.NAP
				from ESolicitudCompraCM a
				 where a.Ecodigo       = #Arguments.Ecodigo#
				   and a.ESidsolicitud = #Arguments.ESidsolicitud#
		</cfquery>

		<cfset NAP_SC_VIEJO = rsSQL.NAP>
		<cfif len(trim(NAP_SC_VIEJO)) eq 0>
		  <cfthrow message="La Solicitud de Orden de Compra a Modificar no tiene un NAP asociado">		
		</cfif>
		
				<!---- Obtengo informacion de la OC asociada a las SC ------>
		<cfquery name="rsOrdenCM" datasource="#Arguments.Conexion#">
            select 
                a.PCGDID, a.DSlinea,
                b.NAP as NAP_OC_VIEJO,
                a.EOidorden,
                a.DOlinea,
                a.EOnumero,
                a.Icodigo
              from DOrdenCM a
                inner join EOrdenCM b
                    on a.EOidorden = b.EOidorden
            where b.Ecodigo		   = #Arguments.Ecodigo#
              and a.ESidsolicitud  = #Arguments.ESidsolicitud# 
              and b.EOestado	   = 10
			order by a.EOidorden		
		</cfquery>		
        
		<cfquery name="rsCPPid" datasource="#Arguments.Conexion#">
		  Select a.CPPid 
		     from PCGplanCompras a 
		        inner join PCGDplanCompras b
				    on a.PCGEid = b.PCGEid
			where b.PCGDid = #rsOrdenCM.PCGDID#		
			 and b.Ecodigo = #Arguments.Ecodigo#
		</cfquery>		
		
		<cfset LvarCPPid =  #rsCPPid.CPPid#>	
		
		<cfset LvarNAPs = listAppend(LvarNAPs,NAP_SC_VIEJO)>
		<!------ Crea un nuevo NAP para REVERSAR la SC -------->
	    <cfset NAP_SC_REVERSION = fnNuevoNAPnum (#Arguments.Conexion#,#Arguments.Ecodigo#)>
		
		 <cfquery name="rsNAPS" datasource="#Arguments.Conexion#">		 
			insert into CPNAP
			( 			
						Ecodigo,
                        CPNAPnum,
                        CPPid,
                        CPCano,
                        CPCmes,
                        CPNAPfecha,
                        CPNAPmoduloOri,
                        CPNAPdocumentoOri,
                        CPNAPreferenciaOri,
                        CPNAPfechaOri,
                        UsucodigoOri,
                        UsucodigoAutoriza,
                        CPOid,
                        CPNAPnumReversado,
                        CPNAPnumModificado,
                        CFid,
                        CPNAPcongelado,
                        BMUsucodigo,					
                        EcodigoOri
                )			   
                select      
                        n.Ecodigo,
                        #NAP_SC_REVERSION#,
                        n.CPPid,
                        n.CPCano,
                        n.CPCmes,
                        n.CPNAPfecha,
                        n.CPNAPmoduloOri,
                        n.CPNAPdocumentoOri,
                        <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="REV: #NumeroVariaciacion#">,
                        n.CPNAPfechaOri,
                        n.UsucodigoOri,
                        n.UsucodigoAutoriza,
                        n.CPOid,
                        n.CPNAPnumReversado,
                        n.CPNAPnumModificado,
                        n.CFid,
                        n.CPNAPcongelado,
                        #session.Usucodigo#,				
                        n.EcodigoOri
                from CPNAP n
                where n.Ecodigo		= #Arguments.Ecodigo#
                  and n.CPNAPnum	= #NAP_SC_VIEJO#
           </cfquery>
				
		<!---- Cancelo las lineas del NAP de la SC ------>
		<cfquery name="rsCPNAPdetalleCancela" datasource="#Arguments.Conexion#">
		 Insert into CPNAPdetalle
		    (
			        Ecodigo,
                    CPNAPnum,
                    CFcuenta, 
                    CPPid ,
                    CPCano, 
                    CPCmes, 
                    CPcuenta, 
                    Ocodigo, 
                    CPNAPDtipoMov, 
                    Mcodigo, 
                    CPNAPDtipoCambio, 
                    CPNAPDsigno,
                    CPCPtipoControl,
                    CPCPcalculoControl,
                    CPNAPDdisponibleAntes,
                    CPNAPDconExceso,
                    CPNAPnumRef,
                    CPNAPDlineaRef,
                    CPPidLiquidacion,
                    CPNAPDreferenciado,
                    CPNAPDutilizado,
                    BMUsucodigo,
                    PCGDid,
                    PCGDcantidad,
                    PCGDcantidadAntes,
                    PCGDdisponibleAntes,
                    CPNAPDlinea,
                    CPNAPDmontoOri, 
                    CPNAPDmonto
			)
			 select 
                    Ecodigo,
                    #NAP_SC_REVERSION#,
                    CFcuenta, 
                    CPPid ,
                    CPCano, 
                    CPCmes, 
                    CPcuenta, 
                    Ocodigo, 
                    CPNAPDtipoMov, 
                    Mcodigo, 
                    CPNAPDtipoCambio, 
                    CPNAPDsigno,
                    CPCPtipoControl,
                    CPCPcalculoControl,
                    CPNAPDdisponibleAntes,
                    CPNAPDconExceso,
                    CPNAPnum,
                    CPNAPDlinea,
                    CPPidLiquidacion,
                    CPNAPDreferenciado,
                    CPNAPDutilizado,
                    BMUsucodigo,				
                    PCGDid,
                    PCGDcantidad,
                    PCGDcantidadAntes,
                    PCGDdisponibleAntes,
                    -CPNAPDlinea,
                    -CPNAPDmontoOri, 
                    -CPNAPDmonto
                from CPNAPdetalle
                    where Ecodigo	= #Arguments.Ecodigo#
                    and CPNAPnum	= #NAP_SC_VIEJO# 
		</cfquery>
		<cfset sbActualizaSaldoAnterior(Arguments.Ecodigo, NAP_SC_REVERSION)>

		
		<!---Actualizar el SC----> 
    	  <!----Genero un numero de NAP para la solicitud de compra----->
		  <cfset NAP_SC_NUEVO = fnNuevoNAPnum (#Arguments.Conexion#,#Arguments.Ecodigo#)>
            
		  <!--- Inserto Nuevo NAP para la SC --->	  
		  <cfquery name="rsNAPS" datasource="#Arguments.Conexion#"> 
		    insert into CPNAP
			(
			        Ecodigo,
					CPNAPnum,
					CPPid,
					CPCano,
					CPCmes,
					CPNAPfecha,
					CPNAPmoduloOri,
					CPNAPdocumentoOri,
					CPNAPreferenciaOri,
					CPNAPfechaOri,
					UsucodigoOri,
					UsucodigoAutoriza,
					CPOid,
					CPNAPnumReversado,
					CPNAPnumModificado,
					CFid,
					CPNAPcongelado,
					BMUsucodigo,					
					EcodigoOri
			)			   
			select      
		            n.Ecodigo,
					#NAP_SC_NUEVO#,
					n.CPPid,
					n.CPCano,
					n.CPCmes,
					n.CPNAPfecha,
					n.CPNAPmoduloOri,
					n.CPNAPdocumentoOri,
					<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="VAR: #NumeroVariaciacion#">,
					n.CPNAPfechaOri,
					n.UsucodigoOri,
					n.UsucodigoAutoriza,
					n.CPOid,
					n.CPNAPnumReversado,
					n.CPNAPnumModificado,
					n.CFid,
					n.CPNAPcongelado,
					#session.usucodigo#,					
					n.EcodigoOri
			from CPNAP n
			where n.Ecodigo		= #Arguments.Ecodigo#
			  and n.CPNAPnum	= #NAP_SC_VIEJO#
		</cfquery>
		
        <!----- Inserto las lineas del Detalle del Nuevo NAP de SC con los nuevos valores------>
		<cfquery name="rsCPNAPdetalleNuevo" datasource="#Arguments.Conexion#">
		 Insert into CPNAPdetalle
		    (
			    Ecodigo,
				CPNAPnum,
				CFcuenta, 
				CPPid ,
				CPCano, 
				CPCmes, 
				CPcuenta, 
				Ocodigo, 
				CPNAPDtipoMov, 
				Mcodigo, 
				CPNAPDtipoCambio, 
				CPNAPDsigno,
				CPCPtipoControl,
				CPCPcalculoControl,
				CPNAPDdisponibleAntes,
				CPNAPDconExceso,
				CPNAPnumRef,
				CPNAPDlineaRef,
				CPPidLiquidacion,
				CPNAPDreferenciado,
				CPNAPDutilizado,
				BMUsucodigo,
				PCGDid,
				PCGDcantidad,
				PCGDcantidadAntes,
				PCGDdisponibleAntes,
				CPNAPDlinea,
				CPNAPDmontoOri, 
				CPNAPDmonto
			)
			select 
				NapD.Ecodigo,
				#NAP_SC_NUEVO#,
				NapD.CFcuenta, 
				NapD.CPPid ,
				NapD.CPCano, 
				NapD.CPCmes, 
				NapD.CPcuenta, 
				NapD.Ocodigo, 
				NapD.CPNAPDtipoMov, 
				NapD.Mcodigo, 
				NapD.CPNAPDtipoCambio, 
				NapD.CPNAPDsigno,
				NapD.CPCPtipoControl,
				NapD.CPCPcalculoControl,
				0, 
				NapD.CPNAPDconExceso,
				NapD.CPNAPnumRef,
				NapD.CPNAPDlineaRef,
				NapD.CPPidLiquidacion,
				NapD.CPNAPDreferenciado, 
				NapD.CPNAPDutilizado,
				NapD.BMUsucodigo,				
				NapD.PCGDid,
				pcg.PCGDcantidad,
				0,
				0,
				NapD.CPNAPDlinea,
				pcg.PCGDcostoOri, 
				pcg.PCGDautorizado
			from CPNAPdetalle NapD
            	left outer join PCGDplanComprasMultiperiodo pcg 
                	on pcg.PCGDid = NapD.PCGDid
				where Ecodigo	= #Arguments.Ecodigo#
			    and CPNAPnum	= #NAP_SC_VIEJO# 
		</cfquery>
		<cfset sbActualizaSaldoAnterior(Arguments.Ecodigo, NAP_SC_NUEVO)>
	
		<cfoutput query="rsOrdenCM" group="EOidorden"><!---Para cada orden se calcula ----->
			<cfset LvarNAPs = listAppend(LvarNAPs,rsOrdenCM.NAP_OC_VIEJO)>
			<!------ Crea un nuevo NAP para REVERSAR la OC -------->
			<cfset NAP_OC_REVERSION = fnNuevoNAPnum (#Arguments.Conexion#,#Arguments.Ecodigo#)>
            
             <cfquery name="rsNAPS" datasource="#Arguments.Conexion#">
			   insert into CPNAP
                (		
				        Ecodigo,
                        CPNAPnum,
                        CPPid,
                        CPCano,
                        CPCmes,
                        CPNAPfecha,
                        CPNAPmoduloOri,
                        CPNAPdocumentoOri,
                        CPNAPreferenciaOri,
                        CPNAPfechaOri,
                        UsucodigoOri,
                        UsucodigoAutoriza,
                        CPOid,
                        CPNAPnumReversado,
                        CPNAPnumModificado,
                        CFid,
                        CPNAPcongelado,
                        BMUsucodigo,					
                        EcodigoOri
                )			   
                select      
                        n.Ecodigo,
                        #NAP_OC_REVERSION#,
                        n.CPPid,
                        n.CPCano,
                        n.CPCmes,
                        n.CPNAPfecha,
                        n.CPNAPmoduloOri,
                        n.CPNAPdocumentoOri,
                        <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="REV: #NumeroVariaciacion#">,
                        n.CPNAPfechaOri,
                        n.UsucodigoOri,
                        n.UsucodigoAutoriza,
                        n.CPOid,
                        n.CPNAPnumReversado,
                        n.CPNAPnumModificado,
                        n.CFid,
                        n.CPNAPcongelado,
                        #session.Usucodigo#,				
                        n.EcodigoOri
                from CPNAP n
                where n.Ecodigo		= #Arguments.Ecodigo#
                  and n.CPNAPnum	= #rsOrdenCM.NAP_OC_VIEJO#
            </cfquery>
				
			<!----- Reversa los detalles del NAP de la OC------>
            <cfquery name="rsCPNAPdetalleCancela" datasource="#Arguments.Conexion#">
             Insert into CPNAPdetalle
                (
                  Ecodigo,
                    CPNAPnum,
                    CFcuenta, 
                    CPPid ,
                    CPCano, 
                    CPCmes, 
                    CPcuenta, 
                    Ocodigo, 
                    CPNAPDtipoMov, 
                    Mcodigo, 
                    CPNAPDtipoCambio, 
                    CPNAPDsigno,
                    CPCPtipoControl,
                    CPCPcalculoControl,
                    CPNAPDdisponibleAntes,
                    CPNAPDconExceso,
                    CPNAPnumRef,
                    CPNAPDlineaRef,
                    CPPidLiquidacion,
                    CPNAPDreferenciado,
                    CPNAPDutilizado,
                    BMUsucodigo,
                    PCGDid,
                    PCGDcantidad,
                    PCGDcantidadAntes,
                    PCGDdisponibleAntes,

                    CPNAPDlinea,
                    CPNAPDmontoOri, 
                    CPNAPDmonto
                )
                select 
                    Ecodigo,
                    #NAP_OC_REVERSION#,
                    CFcuenta, 
                    CPPid ,
                    CPCano, 
                    CPCmes, 
                    CPcuenta, 
                    Ocodigo, 
                    CPNAPDtipoMov, 
                    Mcodigo, 
                    CPNAPDtipoCambio, 
                    CPNAPDsigno,
                    CPCPtipoControl,
                    CPCPcalculoControl,
                    0,
                    CPNAPDconExceso,
                    CPNAPnum,
                    CPNAPDlinea,
                    CPPidLiquidacion,
                    CPNAPDreferenciado,
                    CPNAPDutilizado,
                    BMUsucodigo,				
                    PCGDid,
                    PCGDcantidad,
                    0,
                    0,
                    -CPNAPDlinea,
                    -CPNAPDmontoOri, 
                    -CPNAPDmonto
                  from CPNAPdetalle
				 where Ecodigo	= #Arguments.Ecodigo#
				   and CPNAPnum	= #rsOrdenCM.NAP_OC_VIEJO# 
            </cfquery>
			<cfset sbActualizaSaldoAnterior(Arguments.Ecodigo, NAP_OC_REVERSION)>

			<cfoutput><!---Para cada linea de la orden se consulta el monto autorizado ----->
				<cfquery name="rsPlanCM" datasource="#Arguments.Conexion#">
					Select  PCGDcostoOri, PCGDcantidad		   
					from PCGDplanComprasMultiperiodo
				   where PCGDid = #rsOrdenCM.PCGDid#
				</cfquery>

				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				  select count(1) 	as cantidad
					from DOrdenCM
				   where PCGDID  = #rsOrdenCM.PCGDID#
				</cfquery>
				<cfif rsSQL.cantidad EQ 1>
					<cfset LvarPonderacion  = "">
				<cfelse>
					<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					  select DScantidadNAP, DSmontoOriNAP
						from DSolicitudCompraCM
					   where DSlinea  = #rsOrdenCM.DSlinea#
					</cfquery>
					<!--- DSmontoOriNAP es el PCGDcostoOri viejo, se va modificar al final de este proceso por el nuevo --->
					<cfset LvarPonderacion  = "* ((DOtotal-DOmontodesc+DOimpuestoCosto) / #rsSQL.DSmontoOriNAP#)">
				</cfif>

				<cfif rsPlanCM.PCGDcantidad EQ 0>
					<cfset LvarCant = 1>
				<cfelse>
					<cfset LvarCant = rsPlanCM.PCGDcantidad>
				</cfif>
				<cfquery name="rsUpdateMonto" datasource="#Arguments.Conexion#">
					update DOrdenCM set 
						 DOtotal        = round(#rsPlanCM.PCGDcostoOri# #LvarPonderacion#,2), 
						 DOcantidad     = #LvarCant# #LvarPonderacion#,
						 DOpreciou      = 0,
						 DOmontodesc 	= 0
					 where Ecodigo = #Arguments.Ecodigo#				 
					   and DOlinea = #rsOrdenCM.DOlinea#			   			       
				</cfquery>
			</cfoutput> <!---Fin detalles de la OC  ----->
            
			<!---Calcula Impuestos por linea y totales del encabezado ----->
			<cfinvoke 	component	= "sif.Componentes.CM_AplicaOC"
						method		= "calculaTotalesEOrdenCM"
						EOidorden				= "#rsOrdenCM.EOidorden#"
						CalcularSinImpuestos	= "true"
			/>
 
			<!------ Crea un nuevo NAP para la OC -------->
			<cfset NAP_OC_NUEVO = fnNuevoNAPnum (#Arguments.Conexion#,#Arguments.Ecodigo#)>
            
             <cfquery name="rsNAPS" datasource="#Arguments.Conexion#"> 
                insert into CPNAP
                (
                        Ecodigo,
                        CPNAPnum,
                        CPPid,
                        CPCano,
                        CPCmes,
                        CPNAPfecha,
                        CPNAPmoduloOri,
                        CPNAPdocumentoOri,
                        CPNAPreferenciaOri,
                        CPNAPfechaOri,
                        UsucodigoOri,
                        UsucodigoAutoriza,
                        CPOid,
                        CPNAPnumReversado,
                        CPNAPnumModificado,
                        CFid,
                        CPNAPcongelado,
                        BMUsucodigo,					
                        EcodigoOri
                )			   
                select      
                        n.Ecodigo,
                        #NAP_OC_NUEVO#,
                        n.CPPid,
                        n.CPCano,
                        n.CPCmes,
                        n.CPNAPfecha,
                        n.CPNAPmoduloOri,
                        n.CPNAPdocumentoOri,
                        <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="VAR: #NumeroVariaciacion#">,
                        n.CPNAPfechaOri,
                        n.UsucodigoOri,
                        n.UsucodigoAutoriza,
                        n.CPOid,
                        n.CPNAPnumReversado,
                        n.CPNAPnumModificado,
                        n.CFid,
                        n.CPNAPcongelado,
                        #session.Usucodigo#,				
                        n.EcodigoOri
                from CPNAP n
                where n.Ecodigo		= #Arguments.Ecodigo#
                  and n.CPNAPnum	= #rsOrdenCM.NAP_OC_VIEJO#
            </cfquery>

            <!---Inserta los nuevos detalles del NAP detalle con los nuevos montos de la OC ----->
            <cfquery name="rsCPNAPdetalleNuevo" datasource="#Arguments.Conexion#">
             Insert into CPNAPdetalle
                (
                  Ecodigo,
                    CPNAPnum,
                    CPNAPDlinea,
                    CFcuenta, 
                    CPPid ,
                    CPCano, 
                    CPCmes, 
                    CPcuenta, 
                    Ocodigo, 
                    CPNAPDtipoMov, 
                    Mcodigo, 
                    CPNAPDtipoCambio, 
                    CPNAPDsigno,
                    CPCPtipoControl,
                    CPCPcalculoControl,
                    CPNAPDdisponibleAntes,
                    CPNAPDconExceso,
                    CPNAPnumRef,
                    CPNAPDlineaRef,
                    CPPidLiquidacion,
                    CPNAPDreferenciado,
                    CPNAPDutilizado,
                    BMUsucodigo,
                    PCGDid,
                    PCGDcantidadAntes,
                    PCGDdisponibleAntes,

                    PCGDcantidad, CPNAPDmontoOri, CPNAPDmonto
                )
                select 
                    NapD.Ecodigo,
                    #NAP_OC_NUEVO#,
                    NapD.CPNAPDlinea,
                    NapD.CFcuenta, 
                    NapD.CPPid ,
                    NapD.CPCano, 
                    NapD.CPCmes, 
                    NapD.CPcuenta, 
                    NapD.Ocodigo, 
                    NapD.CPNAPDtipoMov, 
                    NapD.Mcodigo, 
                    NapD.CPNAPDtipoCambio, 
                    NapD.CPNAPDsigno,
                    NapD.CPCPtipoControl,
                    NapD.CPCPcalculoControl,
					0,
                    NapD.CPNAPDconExceso,
					NapD.CPNAPnumRef,			<!--- HAY QUE ACTUALIZAR AL #NAP_SC_NUEVO# --->
                    NapD.CPNAPDlineaRef,
                    NapD.CPPidLiquidacion,
                    NapD.CPNAPDreferenciado,
                    NapD.CPNAPDutilizado,
                    #session.Usucodigo#,				
                    NapD.PCGDid,
                    0,
                    0,
                    o.DOcantidad,
                    round(
	                    case when CPNAPDmonto < 0 then -1 else 1 end *	round(o.DOtotal-o.DOmontodesc+o.DOimpuestoCosto, 2) 
						* CPNAPDtipoCambio
					, 2),
					case when CPNAPDmonto < 0 then -1 else 1 end *	round(o.DOtotal-o.DOmontodesc+o.DOimpuestoCosto, 2) 
                from CPNAPdetalle NapD
					inner join DOrdenCM o
						 on o.EOidorden = #rsOrdenCM.EOidorden#
						and o.DOconsecutivo = abs(NapD.CPNAPDlinea)
                	left outer join PCGDplanComprasMultiperiodo pcg 
                		on pcg.PCGDid = NapD.PCGDid
                    where o.Ecodigo	= #Arguments.Ecodigo#
                      and CPNAPnum	= #rsOrdenCM.NAP_OC_VIEJO# 
            </cfquery>
   			<cfset sbActualizaSaldoAnterior(Arguments.Ecodigo, NAP_OC_NUEVO)>
        
			<!---- Cambia el NAP en el encabezado de la Orden de Compra ----->
            <cfquery name="rsUpdateNapEOC" datasource="#Arguments.Conexion#">
               update EOrdenCM 
               	  set NAP = #NAP_OC_NUEVO#
				where Ecodigo  = #Arguments.Ecodigo#					 
				  and EOnumero = #rsOrdenCM.EOnumero#
				  and EOestado = 10				       
            </cfquery>
				
			<!---- Cambia el NAP de Referencia viejo al NAP de la OC nuevo, excluyendo el NAP de reversion ----->
            <cfquery name="rsUpdateNapSC" datasource="#Arguments.Conexion#">
               update CPNAPdetalle 
			      set CPNAPnumRef 	= #NAP_OC_NUEVO# 
				where Ecodigo      	= #Arguments.Ecodigo#	
				  and CPNAPnumRef	= #rsOrdenCM.NAP_OC_VIEJO#
				  and CPNAPnum		<> #NAP_OC_REVERSION# 
            </cfquery>
		</cfoutput><!----- Termino con las OC ----->

	    <!------- Actualizo detalle SC con datos del Plan de Compras ------->
		<cfquery name="rsUpdateNapSC" datasource="#Arguments.Conexion#">
		   update DSolicitudCompraCM 
                set DScantidadNAP = (select PCGDcantidad from PCGDplanComprasMultiperiodo where PCGDid = DSolicitudCompraCM.PCGDid), 
				    DSmontoOriNAP = (select PCGDcostoOri from PCGDplanComprasMultiperiodo where PCGDid = DSolicitudCompraCM.PCGDid)
		     where Ecodigo       = #Arguments.Ecodigo#
			  and  ESidsolicitud = #Arguments.ESidsolicitud#      
		</cfquery>

	    <!------- Actualizo la SC con referencia al nuevo NAP ------->
		<cfquery name="rsUpdateNapSC" datasource="#Arguments.Conexion#">
		   update ESolicitudCompraCM 
                set NAP = #NAP_SC_NUEVO#
		     where Ecodigo       = #Arguments.Ecodigo#
			  and  ESidsolicitud = #Arguments.ESidsolicitud#      
		</cfquery>
		
		<!---- Actualizo el NAP de la OC con la referencia del Nuevo NAP de la SC ---------> 
		<cfquery datasource="#Arguments.Conexion#">
		   update CPNAPdetalle 
			  set CPNAPnumRef 	= #NAP_SC_NUEVO# 
			where Ecodigo      	= #Arguments.Ecodigo#	
			  and CPNAPnumRef	= #NAP_SC_VIEJO#
			  and CPNAPnum		<> #NAP_SC_REVERSION# 
		</cfquery>

		<!---- Actualizo Utilizado por las Referencias ---------> 
		<cfquery datasource="#Arguments.Conexion#">
		   update CPNAPdetalle 
		      set CPNAPDutilizado =
			  		coalesce(
						(
						select sum(-CPNAPDmonto)
						  from CPNAPdetalle d
						 where d.Ecodigo	 = CPNAPdetalle.Ecodigo
						   and d.CPNAPnumRef = CPNAPdetalle.CPNAPnum
						   and d.CPNAPDlineaRef = CPNAPdetalle.CPNAPDlinea
						)
					,0)
		        , CPNAPDreferenciado =
					case when 
						(
						select count(1)
						  from CPNAPdetalle d
						 where d.Ecodigo	 = CPNAPdetalle.Ecodigo
						   and d.CPNAPnumRef = CPNAPdetalle.CPNAPnum
						   and d.CPNAPDlineaRef = CPNAPdetalle.CPNAPDlinea
						) > 0 
						then 1 
						else 0
					end
			where Ecodigo      	= #Arguments.Ecodigo#	
			  and CPNAPnum		in (#LvarNAPs#)
		</cfquery>
	</cffunction>

	<cffunction name="fnNuevoNAPnum" access="private" output="no">
		<cfargument name="Conexion" 	    type="string"   required="no">
		<cfargument name="Ecodigo" 		    type="numeric"  required="no">
		
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
        
        <cfinvoke component="sif.Componentes.PRES_Presupuesto" method="fnSiguienteCPNAPnum" returnvariable="LvarNEW">
		
			<cfinvokeargument name="Ecodigo" 			value="#Arguments.Ecodigo#">
			<cfinvokeargument name="Conexion" 	    	value="#Arguments.Conexion#">	
		</cfinvoke>		
		<cfif len(trim(LvarNEW)) eq  0 >
			<cfthrow message="No se pudo generar el nuevo NAP. Operacion cancelada">       
		</cfif>
		<cfset LvarNAPs = listAppend(LvarNAPs,LvarNEW)>
		<cfreturn LvarNEW>
	</cffunction>
	
	<cffunction name="sbActualizaSaldoAnterior">
		<cfargument name="Ecodigo" type="numeric">
		<cfargument name="NAP"     type="numeric">
	
	    <cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
	
		<cfquery name="rsCPNAPD" datasource="#Arguments.Conexion#">
			delete from #CPNAPD#
		</cfquery>
		<cfquery name="rsCPNAPD" datasource="#Arguments.Conexion#">
			insert into #CPNAPD#
				(Ecodigo, CPNAPnum, CPNAPDlinea, CPcuenta, Ocodigo, SignoMonto, SignoCantidad, PCGDid)
			select Ecodigo, CPNAPnum, CPNAPDlinea, CPcuenta, Ocodigo, CPNAPDsigno * CPNAPDmonto, CPNAPDsigno * PCGDcantidad, PCGDid
			  from CPNAPdetalle
			 where Ecodigo	= #Arguments.Ecodigo#
			   and CPNAPnum	= #Arguments.NAP# 
			 order by CPNAPDsigno * CPNAPDmonto desc
		</cfquery>
	
		<cfquery datasource="#Arguments.Conexion#">
			update CPNAPdetalle
			   set CPNAPDdisponibleAntes =
						coalesce(
							(
							select sum(CPCpresupuestado + CPCmodificado + CPCmodificacion_Excesos + CPCvariacion + CPCtrasladado + CPCtrasladadoE
									 -(CPCreservado_Anterior + CPCcomprometido_anterior + CPCreservado_presupuesto + CPCreservado + CPCcomprometido + CPCejecutado + CPCejecutadoNC)
									  )
							  from CPresupuestoControl
							 where Ecodigo	= CPNAPdetalle.Ecodigo
							   and CPPid 	= CPNAPdetalle.CPPid
							   and CPcuenta = CPNAPdetalle.CPcuenta
							   and Ocodigo  = CPNAPdetalle.Ocodigo
		
							   and CPCanoMes >= 
											case CPCPcalculoControl
												when 1  then CPNAPdetalle.CPCano * 100 + CPNAPdetalle.CPCmes	<!--- Mensual:		solo el mismo mes --->
												when 2  then 0													<!--- Acumulado:	del Inicio hasta el mismo mes --->
												when 3  then 0													<!--- Total:		del Inicio al Final --->
											end
							   and CPCanoMes <= 
											case CPCPcalculoControl
												when 1  then CPNAPdetalle.CPCano * 100 + CPNAPdetalle.CPCmes
												when 2  then CPNAPdetalle.CPCano * 100 + CPNAPdetalle.CPCmes
												when 3  then 300012 
											end
						)
						,0)
						+
						coalesce(
							(
								select sum(dd.SignoMonto)
								  from #CPNAPD# dd
								 where dd.Ecodigo	= CPNAPdetalle.Ecodigo
								   and dd.CPNAPnum	= CPNAPdetalle.CPNAPnum
								   and dd.CPcuenta  = CPNAPdetalle.CPcuenta
								   and dd.Ocodigo   = CPNAPdetalle.Ocodigo
								   and dd.Linea 	< (select Linea from #CPNAPD# ddd where ddd.Ecodigo=CPNAPdetalle.Ecodigo AND ddd.CPNAPnum=CPNAPdetalle.CPNAPnum AND ddd.CPNAPDlinea=CPNAPdetalle.CPNAPDlinea)
							)
						,0)
                    ,PCGDdisponibleAntes =
						(
								select sum(PCGDautorizado - PCGDreservado - PCGDcomprometido - PCGDejecutado)
								  from PCGDplanCompras pcg
								 where pcg.PCGDid = CPNAPdetalle.PCGDid
						)
						+
						coalesce(
							(
								select sum(dd.SignoMonto)
								  from #CPNAPD# dd
								 where dd.PCGDid = CPNAPdetalle.PCGDid
								   and dd.Linea  < (select Linea from #CPNAPD# ddd where ddd.Ecodigo=CPNAPdetalle.Ecodigo AND ddd.CPNAPnum=CPNAPdetalle.CPNAPnum AND ddd.CPNAPDlinea=CPNAPdetalle.CPNAPDlinea)
							)
						,0)
                    ,PCGDcantidadAntes = 
						(
								select 	sum(PCGDcantidad-PCGDcantidadCompras)
								  from PCGDplanCompras pcg
								 where pcg.PCGDid = CPNAPdetalle.PCGDid
						)
						+
						coalesce(
							(
								select sum(dd.SignoCantidad)
								  from #CPNAPD# dd
								 where dd.PCGDid = CPNAPdetalle.PCGDid
								   and dd.Linea  < (select Linea from #CPNAPD# ddd where ddd.Ecodigo=CPNAPdetalle.Ecodigo AND ddd.CPNAPnum=CPNAPdetalle.CPNAPnum AND ddd.CPNAPDlinea=CPNAPdetalle.CPNAPDlinea)
							)
						, 0)
			 where Ecodigo	= #Arguments.Ecodigo#
			   and CPNAPnum	= #Arguments.NAP# 
		</cfquery>

		<!---------------------------------------------------------------->
		<!-----    Control de presupuesto y del plan de compras    ------->
		<!---------------------------------------------------------------->
		
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			update  CPresupuestoControl
			   set	CPCreservado 	= round(CPCreservado +
						coalesce((
							select sum(CPNAPDmonto)
							  from CPNAPdetalle
							 where Ecodigo	= CPresupuestoControl.Ecodigo
							   and CPNAPnum = #Arguments.NAP#
							   and CPCano	= CPresupuestoControl.CPCano
							   and CPCmes	= CPresupuestoControl.CPCmes
							   and CPcuenta	= CPresupuestoControl.CPcuenta
							   and Ocodigo	= CPresupuestoControl.Ocodigo
							   and CPNAPDtipoMov = 'RC'
						),0), 2)
				  ,	CPCcomprometido 	= round(CPCcomprometido +
						coalesce((
							select sum(CPNAPDmonto)
							  from CPNAPdetalle
							 where Ecodigo	= CPresupuestoControl.Ecodigo
							   and CPNAPnum = #Arguments.NAP# 
							   and CPCano	= CPresupuestoControl.CPCano
							   and CPCmes	= CPresupuestoControl.CPCmes
							   and CPcuenta	= CPresupuestoControl.CPcuenta
							   and Ocodigo	= CPresupuestoControl.Ocodigo
							   and CPNAPDtipoMov = 'CC'
						),0), 2)
			 where	Ecodigo	= #session.Ecodigo#
			   and	CPPid	= #LvarCPPid#
			   and	
					(
						select count(1)
						  from CPNAPdetalle
						 where Ecodigo	= CPresupuestoControl.Ecodigo
						   and CPNAPnum = #Arguments.NAP#
						   and CPCano	= CPresupuestoControl.CPCano
						   and CPCmes	= CPresupuestoControl.CPCmes
						   and CPcuenta	= CPresupuestoControl.CPcuenta
						   and Ocodigo	= CPresupuestoControl.Ocodigo
					) > 0
		</cfquery>
		
		<cfquery datasource="#Arguments.Conexion#">
			update PCGDplanCompras
			   set 	PCGDreservado 		= round(PCGDreservado +
						coalesce((
							select sum(CPNAPDmonto)
							  from CPNAPdetalle
							 where Ecodigo	= PCGDplanCompras.Ecodigo
							   and CPNAPnum = #Arguments.NAP#
							   and PCGDid	= PCGDplanCompras.PCGDid
							   and CPNAPDtipoMov = 'RC'
						),0) , 2)
				  ,	PCGDcomprometido	= round(PCGDcomprometido		+ 
						coalesce((
							select sum(CPNAPDmonto)
							  from CPNAPdetalle
							 where Ecodigo	= PCGDplanCompras.Ecodigo
							   and CPNAPnum = #Arguments.NAP#
							   and PCGDid	= PCGDplanCompras.PCGDid
							   and CPNAPDtipoMov = 'CC'
						),0) , 2)
				  ,	PCGDcantidadCompras	= PCGDcantidadCompras	+ 
						coalesce((
							select sum(PCGDcantidad)
							  from CPNAPdetalle
							 where Ecodigo	= PCGDplanCompras.Ecodigo
							   and CPNAPnum = #Arguments.NAP#
							   and PCGDid	= PCGDplanCompras.PCGDid
							   and CPNAPDtipoMov in ('RC','CC')
							   and PCGDxCantidad = 1
						),0)
			 where 
					(
						select count(1)
						  from CPNAPdetalle
						 where Ecodigo	= PCGDplanCompras.Ecodigo
						   and CPNAPnum = #Arguments.NAP#
						   and PCGDid	= PCGDplanCompras.PCGDid
					) > 0
			   and PCGDxPlanCompras = 1
		</cfquery>	
	</cffunction>
	
</cfcomponent>