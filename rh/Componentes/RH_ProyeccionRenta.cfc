<!---============================================================================================================================
 Componente para el manejo de proyeccion de Renta y liquidacion de la misma, tanto desde Expediente y Nomina como de Autogestion
No Cambiar el Orden de los Argumentos ya que se trabaja con createobject "miFuncion(param1,param2, param3)"
===============================================================================================================================--->
<cfcomponent>
<!---==================Funcion Para la obtencion de los datos de un Empleado==================--->    
	<cffunction name="GetEmpleado" access="public" returntype="query">
    	 <cfargument name="Conexion"  type="string"  required="no">
         <cfargument name="ecodigo"   type="numeric" required="no">
         <cfargument name="cecodigo"  type="numeric" required="no">
         <cfargument name="usucodigo" type="numeric" required="no">
         <cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
        <cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
        <cfif not isdefined('Arguments.cecodigo')>
			<cfset Arguments.cecodigo = session.cecodigo>
		</cfif>
         <cfif not isdefined('Arguments.usucodigo')>
			<cfset Arguments.usucodigo = session.usucodigo>
		</cfif>
        
        <cfquery name="rsDatosEmpleado" datasource="#Arguments.Conexion#">
            select llave
            from UsuarioReferencia ur
              inner join Empresa em 
                 on em.Ecodigo = ur.Ecodigo
                and em.Ereferencia = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                and em.CEcodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.cecodigo#">
            where ur.Usucodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.usucodigo#">
              and ur.STabla = 'DatosEmpleado'
        </cfquery>
        <cfif rsDatosEmpleado.RecordCount EQ 0 OR NOT LEN(TRIM(rsDatosEmpleado.llave))>
        	<cfinvoke key="MSG_ERROR_DEID"	default="Error. No se encontró el Empleado Asociado con su Usuario!" returnvariable="MSG_ERROR_DEID" component="sif.Componentes.Translate" method="Translate"/>
            <cf_throw message="#MSG_ERROR_DEID#" errorcode="5045">
        </cfif>
        <cfreturn rsDatosEmpleado>
    </cffunction>
<!---►►►►==================Obtienen el Paramentro 30: Tabla de Impuesto de Renta==================--->
    <cffunction name="GetParam30" access="public" returntype="query">
    	 <cfargument name="Conexion"  type="string"  required="no">
         <cfargument name="ecodigo"   type="numeric" required="no">
         <cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		 </cfif>
         <cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		 </cfif>
         
         <cfquery name="rsIRc" datasource="#Arguments.Conexion#">
            select Pvalor as IRcodigo, Pdescripcion
             from RHParametros 
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#"> 
              and Pcodigo = 30
		</cfquery>
         <cfif rsIRc.RecordCount EQ 0 OR NOT LEN(TRIM(rsIRc.IRcodigo))>
         	<cfinvoke key="MSG_ERROR_ImpuestoRenta"	default="Error. La empresa no tiene el impuesto de renta Definido!" returnvariable="MSG_ERROR_ImpuestoRenta" component="sif.Componentes.Translate" method="Translate"/>
         	<cfthrow message="#MSG_ERROR_ImpuestoRenta#">
         </cfif>
         <cfreturn rsIRc>
    </cffunction>
<!---►►►►==================Obtienen el Encabezado de la liquidacion de la Renta==================--->
    <cffunction name="GetEliquidacionRenta" access="public" returntype="query">
    	<cfargument name="RHRentaId" type="numeric"  required="no">
        <cfargument name="DEid"  	 type="numeric"  required="no">
        <cfargument name="Filtro"  	 type="string"   required="no">
        <cfargument name="Tipo"  	 type="string"   required="no">
        <cfargument name="EIRid"  	 type="numeric"  required="no">
        <cfargument name="Periodo"   type="numeric"  required="no">
        <cfargument name="Mes"  	 type="numeric"  required="no">
        <cfargument name="Conexion"  type="string"   required="no">
        <cfargument name="Ecodigo"   type="numeric"  required="no">

        <cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
	    </cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
	    </cfif>
        
        <cfquery name="rsRHLiquidacionRenta" datasource="#Arguments.Conexion#">
            select RHRentaId, EIRid, Nversion,case Estado 
                                               when 0  then 'En Proceso' 
                                               when 10 then 'En Revisión'
                                               when 20 then 'Rechazado'
                                               when 30 then 'Finalizado' end Estado, USRInicia, DEid
             from RHLiquidacionRenta
            where 1=1
            <cfif isdefined('Arguments.RHRentaId') and Arguments.RHRentaId NEQ -1>
            	and RHRentaId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHRentaId#"> 
            </cfif>
            <cfif isdefined('Arguments.EIRid') and Arguments.EIRid NEQ -1>
            	and EIRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EIRid#"> 
            </cfif>
            <cfif isdefined('Arguments.DEid') and Arguments.DEid NEQ -1>
            	and DEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
            </cfif>
             <cfif isdefined('Arguments.Periodo') and Arguments.Periodo NEQ -1>
            	and Periodo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Periodo#">
            </cfif>
            <cfif isdefined('Arguments.Mes') and Arguments.Mes NEQ -1>
            	and Mes  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mes#">
            </cfif>
            <cfif isdefined('Arguments.Tipo') and Arguments.Tipo NEQ -1>
              	and Tipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tipo#">
            </cfif>
            <cfif isdefined('Arguments.Filtro') and Arguments.Filtro NEQ '-1'>
           		#PreserveSingleQuotes(Arguments.Filtro)#
            </cfif>
        </cfquery>
    	<cfreturn rsRHLiquidacionRenta>
    </cffunction>
<!---►►►►==================Obtienen el Impuesto de Renta==================--->    
    <cffunction name="GetEImpuestoRenta" access="public" returntype="query">
    	<cfargument name="DEid"  		type="numeric"   required="no">
        <cfargument name="IRcodigo"  	type="string"    required="no">
        <cfargument name="EIRid"  		type="numeric"   required="no">		
        <cfargument name="ListsEIRid"  	type="string"    required="no">
        <cfargument name="EIRetado"  	type="numeric"   required="no"><!---0=LISTO 1-CAPTURA--->
        <cfargument name="FiltroExtra"  type="string"   required="no">
        <cfargument name="Conexion"  	type="string"    required="no">
         
         <cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
	    </cfif>
         
        <cf_dbfunction name="dateadd" args="IRfactormeses, EIRdesde,MM" returnvariable="FechaHastaTemp">
		<cf_dbfunction name="dateadd" args="-1!#FechaHastaTemp#!DD"     returnvariable="FechaHasta" delimiters="!" >

        <cfquery name="rsIRs" datasource="#Arguments.Conexion#">
            select a.EIRid, b.IRcodigo, b.IRdescripcion, a.EIRdesde, #PreserveSingleQuotes(FechaHastaTemp)# as EIRhasta, EIRestado,
                <cf_dbfunction name="date_part" args="yy,a.EIRhasta"> 	as periodoHasta, 
                <cf_dbfunction name="date_part" args="yyyy,a.EIRdesde"> as AnoDesde,
                <cf_dbfunction name="date_part" args="mm,a.EIRdesde">   as mesDesde,
                <cf_dbfunction name="date_part" args="dd,a.EIRdesde">   as diaDesde,
                <cf_dbfunction name="date_part" args="dd,a.EIRhasta"> 	as diaHasta, 
                <cf_dbfunction name="date_part" args="mm;#PreserveSingleQuotes(FechaHasta)#"   delimiters = ";"> as mesHasta,
                <cf_dbfunction name="date_part" args="yyyy;#PreserveSingleQuotes(FechaHasta)#" delimiters = ";"> as AnoHasta,
                #FechaHastaTemp# as FechaHastaCal
               
            from EImpuestoRenta a
                inner join ImpuestoRenta b
                    on a.IRcodigo = b.IRcodigo
              where 1 = 1
            <cfif isdefined('Arguments.IRcodigo') and Arguments.IRcodigo NEQ -1>
            	and rtrim(a.IRcodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.IRcodigo#">
            </cfif>
            <cfif isdefined('Arguments.EIRestado') and Arguments.EIRestado NEQ -1>
            	and a.EIRestado = #Arguments.EIRestado#
            </cfif>
            <cfif isdefined('Arguments.ListEIRid') and Arguments.ListEIRid NEQ -1>
                and not <cf_whereInList Column="a.EIRid" ValueList="#Arguments.ListEIRid#" cfsqltype="cf_sql_numeric">
            </cfif>
            <cfif isdefined('Arguments.EIRid') and Arguments.EIRid NEQ -1>
            	and a.EIRid = #Arguments.EIRid#
            </cfif>
            <cfif isdefined('Arguments.DEid') and Arguments.DEid NEQ -1>
             	and EIRhasta > = (select EVfantig 
                					from EVacacionesEmpleado 
                                   where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">  
                                  )
            </cfif>
            <cfif isdefined('Arguments.FiltroExtra') and Arguments.FiltroExtra NEQ -1>
            	and #PreserveSingleQuotes(Arguments.FiltroExtra)#
            </cfif>
            order by a.EIRdesde desc
        </cfquery>
        <cfreturn rsIRs>
	</cffunction>
<!---►►►►==================Agrega un Encabezado de la Liquidacion de Renta==================--->        
	<cffunction name="AltaRHLiquidacionRenta" access="public" returntype="numeric">
		<cfargument name="DEid" 		type="numeric" 	required="yes">
		<cfargument name="periodo" 		type="numeric" 	required="yes">
		<cfargument name="EIRid" 		type="numeric" 	required="true">
		<cfargument name="mes" 			type="numeric" 	required="yes">
		<cfargument name="Nversion" 	type="numeric" 	required="yes">
		<cfargument name="USRInicia" 	type="string" 	required="yes">  
        <cfargument name="Ecodigo" 		type="numeric" 	required="no">
        <cfargument name="Conexion"  	type="string"   required="no">
        <cfargument name="Tipo"  		type="string"   required="no" default="P">
        <cfargument name="Usucodigo"  	type="numeric"  required="no">
        
        <cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
	    </cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
	    </cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
			<cfset Arguments.Usucodigo = session.Usucodigo>
	    </cfif>
                        	
        <cfquery datasource="#Arguments.Conexion#" name="rsAltaDLiq">
            insert into RHLiquidacionRenta(
                    EIRid,DEid,Periodo,Mes,Ecodigo,Nversion,BMUsucodigo,USRInicia,Tipo,BMfechaalta,
                    montopagoempresa, montootrospagos,montodeduccionesf , montoretencion, montootrasret,
                    Estado, RentaAnual,RentaRetenida,ImpuestoRetener,RetenidoExceso, 
                    RentaImponible, ImpuestoAnualDet, CreditoIVA)
            values(
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EIRid#">, 
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">, 
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.periodo#">, 
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.mes#">, 
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">, 
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Nversion#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">, 
                    <cfqueryparam cfsqltype="cf_sql_char" 	 value="#Arguments.USRInicia#">, 
                    <cfqueryparam cfsqltype="cf_sql_char" 	 value="#Arguments.Tipo#">, 
                    <cf_dbfunction name="now">,
                    0,0,0,0,0,
                    0,0,0,0,0,  												 
                    0,0,0
                  )	
             <cf_dbidentity1 datasource="#session.DSN#">							
      </cfquery>
      		<cf_dbidentity2 name="rsAltaDLiq" datasource="#session.DSN#">		
      <cfreturn rsAltaDLiq.identity>
	</cffunction>
<!---►►►►==================Agrega un Detalle de la Liquidacion de Renta==================--->        
	<cffunction name="AltaRHDLiquidacionRenta" access="public">
		<cfargument name="EIRid" 			type="numeric" 	required="true">
        <cfargument name="Nversion" 		type="numeric" 	required="yes">
        <cfargument name="DEid" 			type="numeric" 	required="yes">
        <cfargument name="Tipo"  			type="string"   required="no" default="P">
		<cfargument name="RHCRPTid" 		type="string" 	required="yes">  
        <cfargument name="periodo" 			type="numeric" 	required="yes">
		<cfargument name="mes" 				type="numeric" 	required="yes">
        <cfargument name="MontoEmpleado" 	type="numeric" 	required="no">
        <cfargument name="MontoHistorico" 	type="numeric" 	required="no">
        <cfargument name="MontoAutorizado" 	type="numeric" 	required="no">
        <cfargument name="Observaciones" 	type="string" 	required="no">
        <cfargument name="Usucodigo"  		type="numeric"  required="no">
        <cfargument name="Conexion"  		type="string"   required="no">

        <cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
	    </cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
			<cfset Arguments.Usucodigo = session.Usucodigo>
	    </cfif>
                        	
        <cfquery datasource="#Arguments.Conexion#">
         insert into RHDLiquidacionRenta(EIRid,Nversion,DEid,Tipo, Periodo,Mes,RHCRPTid,MontoHistorico,MontoEmpleado,MontoAutorizado,Observaciones,BMfechaalta,BMUsucodigo)
			values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EIRid#">,
            		<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Nversion#">,
			  		<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tipo#">,
			  		<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.periodo#">,
			  		<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Mes#">,
			  		<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHCRPTid#">,
					<cfqueryparam cfsqltype="cf_sql_money" 	 value="#Arguments.MontoHistorico#">,
					<cfqueryparam cfsqltype="cf_sql_money" 	 value="#Arguments.MontoEmpleado#">,
					<cfqueryparam cfsqltype="cf_sql_money"   value="#Arguments.MontoAutorizado#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Observaciones#">,
					<cf_dbfunction name="now">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
			)
      </cfquery>		
	</cffunction>
<!---►►►►==================Cambia un Encabezado de la Liquidacion de Renta==================--->        
	<cffunction name="CambioRHLiquidacionRenta" access="public">
		<cfargument name="RHRentaId" 		type="numeric" 	required="yes">
        <cfargument name="Estado"  			type="string"   required="no">
        <cfargument name="RentaAnual" 		type="numeric" 	required="no">
        <cfargument name="RentaRetenida" 	type="numeric" 	required="no">
        <cfargument name="ImpuestoRetener" 	type="numeric" 	required="no">
        <cfargument name="RetenidoExceso" 	type="numeric" 	required="no">
        <cfargument name="RentaImponible" 	type="numeric" 	required="no">
        <cfargument name="ImpuestoAnualDet" type="numeric" 	required="no">
        <cfargument name="CreditoIVA" 		type="numeric" 	required="no">
        <cfargument name="Ecodigo" 			type="numeric" 	required="no">
        <cfargument name="Conexion"  		type="string"   required="no">
        <cfargument name="Usucodigo"  		type="numeric"  required="no">
 
        <cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
	    </cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
	    </cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
			<cfset Arguments.Usucodigo = session.Usucodigo>
	    </cfif>
                        	
        <cfquery datasource="#Arguments.Conexion#">
            update RHLiquidacionRenta
                 set BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
                    ,BMfechaalta = <cf_dbfunction name="now">
                <cfif isdefined('Arguments.Estado') and Arguments.Estado NEQ '-1'>
                    ,Estado =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Estado#">
                </cfif>
                <cfif isdefined('Arguments.RentaAnual') and Arguments.RentaAnual NEQ -1>
                    ,RentaAnual =  <cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#Arguments.RentaAnual#">
                </cfif>
                 <cfif isdefined('Arguments.RentaRetenida') and Arguments.RentaRetenida NEQ -1>
                    ,RentaRetenida =  <cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#Arguments.RentaRetenida#">
                </cfif>
                 <cfif isdefined('Arguments.ImpuestoRetener') and Arguments.ImpuestoRetener NEQ -1>
                    ,ImpuestoRetener =  <cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#Arguments.ImpuestoRetener#">
                </cfif>
                 <cfif isdefined('Arguments.RetenidoExceso') and Arguments.RetenidoExceso NEQ -1>
                    ,RetenidoExceso =  <cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#Arguments.RetenidoExceso#">
                </cfif>
                 <cfif isdefined('Arguments.RentaImponible') and Arguments.RentaImponible NEQ -1>
                    ,RentaImponible =  <cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#Arguments.RentaImponible#">
                </cfif>
                 <cfif isdefined('Arguments.ImpuestoAnualDet') and Arguments.ImpuestoAnualDet NEQ -1>
                    ,ImpuestoAnualDet =  <cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#Arguments.ImpuestoAnualDet#">
                </cfif>
                 <cfif isdefined('Arguments.CreditoIVA') and Arguments.CreditoIVA NEQ -1>
                    ,CreditoIVA =  <cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#Arguments.CreditoIVA#">
                </cfif>
            where RHRentaId   = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.RHRentaId#">
       </cfquery>		
	</cffunction>
<!---►►►►==================Cambia un Encabezado de la Liquidacion de Renta==================--->        
	<cffunction name="CambioRHDLiquidacionRenta" access="public">
		<cfargument name="RHRentaId" 		type="numeric" 	required="yes">
        <cfargument name="RHCRPTid" 		type="numeric" 	required="yes">
        <cfargument name="MontoHistorico" 	type="numeric" 	required="no">
        <cfargument name="MontoEmpleado" 	type="numeric" 	required="no">
        <cfargument name="MontoAutorizado" 	type="numeric" 	required="no">
        <cfargument name="Observaciones" 	type="string" 	required="no">
        <cfargument name="Ecodigo" 		type="numeric" 	required="no">
        <cfargument name="Conexion"  	type="string"   required="no">
        <cfargument name="Usucodigo"  	type="numeric"  required="no">

        <cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
	    </cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
	    </cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
			<cfset Arguments.Usucodigo = session.Usucodigo>
	    </cfif>
                        	
        <cfquery datasource="#Arguments.Conexion#">
            update RHDLiquidacionRenta
                 set BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
                    ,BMfechaalta = <cf_dbfunction name="now">
                <cfif isdefined('Arguments.MontoHistorico') and Arguments.MontoHistorico NEQ -1>
                    ,MontoHistorico =  <cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#Arguments.MontoHistorico#">
                </cfif>
                 <cfif isdefined('Arguments.MontoEmpleado') and Arguments.MontoEmpleado NEQ -1>
                    ,MontoEmpleado =  <cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#Arguments.MontoEmpleado#">
                </cfif>
                 <cfif isdefined('Arguments.MontoAutorizado') and Arguments.MontoAutorizado NEQ -1>
                    ,MontoAutorizado =  <cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#Arguments.MontoAutorizado#">
                </cfif>
                <cfif isdefined('Arguments.Observaciones') and Arguments.Observaciones NEQ '-1'>
                    ,Observaciones =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Observaciones#">
                </cfif>
            where RHRentaId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHRentaId#">
              and RHCRPTid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHCRPTid#">
       </cfquery>		
	</cffunction>
<!---►►►►====Obtienen las cargas Sociales del Empleado-Con solo un insidente que este ligado a la columna, ya toda la columna se le aplica las cargas Sociales===--->      
	<cffunction name="GetCargasEmpleado" access="public" returntype="numeric">
    	<cfargument name="DEid"			 type="numeric"	required="yes">
        <cfargument name="RHCRPTid"		 type="numeric"	required="yes">
        <cfargument name="EsSalarioBase" type="boolean"	required="yes" default="False">
        <cfargument name="Conexion" 	type="string"   required="no">
        <cfargument name="Ecodigo" 		type="string"   required="no">
        
        <cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
	    </cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
	    </cfif>
        <cfset listDClinea = GetParam2120()>
        <cfquery name="rsCarga" datasource="#Arguments.Conexion#">
            select coalesce(a.CEvaloremp,b.DCvaloremp,0.00) as valor
            from CargasEmpleado a
                inner join DCargas b
                  on b.DClinea = a.DClinea
                inner join ECargas c
                  on c.ECid = b.ECid
            where DEid 		  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">	
              and ECauto 	  = 1
              and DCprovision = 0
              and (CEvaloremp > 0 or DCvaloremp > 0)
              and a.DClinea in (#listDClinea#)
        </cfquery>
	
		<cfif EsSalarioBase>
            <cfreturn rsCarga.valor>	
        <cfelse>
        	<cfquery name="rsCargaReporte" datasource="#Arguments.Conexion#">
            	select count(1) cantidad
                	from RHConceptosColumna a 
                    	inner join CIncidentes b
                    		on b.CIid = a.CIid
                 where RHCRPTid  = #Arguments.RHCRPTid# 
            </cfquery>
            <cfquery name="rsCargaExclusion" datasource="#Arguments.Conexion#">
            	select count(1) cantidad
                 from RHConceptosColumna a
                        inner join CIncidentes b
                                    on b.CIid = a.CIid 
                        inner join  DCTDeduccionExcluir c
                          on c.CIid = b.CIid
                        inner join DCargas d
                          on d.DClinea = c.DClinea
                    where a.RHCRPTid  = #Arguments.RHCRPTid#  
                      and d.DClinea in (#listDClinea#)
            </cfquery>
            <cfif rsCargaExclusion.cantidad GT 0 and rsCargaExclusion.cantidad EQ rsCargaReporte.cantidad>
            	<cfreturn 0>
            <cfelseif rsCargaExclusion.cantidad GT 0 and rsCargaExclusion.cantidad LT rsCargaReporte.cantidad>
            	 <cfreturn rsCarga.valor>
           	<cfelseif rsCargaExclusion.cantidad EQ 0>	
            	 <cfquery name="rsCargaRep" datasource="#Arguments.Conexion#">
                    select case when (select count(1) 
                                        from CIncidentes c  
                                            inner join RHConceptosColumna d
                                                on c.CIid = d.CIid
                                         where c.CInocargasley = 0
                                           and d.RHCRPTid  = #Arguments.RHCRPTid#
                                          ) > 0 then coalesce(a.CEvaloremp,b.DCvaloremp) <!---Si NO existe una excepcion y el concepto de pago Aplica Carga de Ley . se CALCULA--->
                                 else 0.00 end<!---Si NO existe una excepcion y el concepto de pago NO Aplica Carga de Ley . NO CALCULA--->
                               as valor
                    from CargasEmpleado a
                        inner join DCargas b
                          on b.DClinea = a.DClinea
                        inner join ECargas c
                          on c.ECid = b.ECid
                    where DEid 		  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">	
                      and ECauto 	  = 1
                      and DCprovision = 0
                      and (CEvaloremp > 0 or DCvaloremp > 0)
                      and a.DClinea in (#listDClinea#)
                </cfquery>
                <cfif rsCargaRep.RecordCount GT 0>
        			<cfreturn rsCargaRep.valor>	
       	 		<cfelse>
        			<cfreturn 0>
        		</cfif>
            </cfif> 
        </cfif>
	</cffunction> 
<!---►►►►==================Obtienen el Detalle de la(s) liquidacion de la Renta==================--->    
    <cffunction name="GetRHDLiquidacionRenta" access="public" returntype="query">
   		
        <cfargument name="RHRentaId" type="numeric"  required="no">
        <cfargument name="RHCRPTid"  type="numeric"  required="no">
         
        <cfargument name="EIRid" 	type="numeric"  required="no">
        <cfargument name="DEid" 	type="numeric"  required="no">
        <cfargument name="Nversion" type="numeric"  required="no">
       
        <cfargument name="Tipo" 	type="string"   required="no" default="P">
        <cfargument name="Periodo" 	type="numeric"  required="no">
        <cfargument name="Mes" 		type="numeric"  required="no">
        <cfargument name="Conexion" type="string"   required="no">
        
        <cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
	    </cfif>
        <cfquery name="rsDatosD" datasource="#Arguments.Conexion#">
           select DEid,Periodo, Mes ,MontoHistorico, MontoEmpleado, MontoAutorizado,PorcCargaSocial,RentaRetenida,IGSSAut,IGSSEmp,Coalesce(rtrim(Observaciones),'Sin Observaciones') as Observaciones,
          		(select min(RHROid) from RHRentaOrigenes where RHRentaId = RHDLiquidacionRenta.RHRentaId and RHCRPTid = RHDLiquidacionRenta.RHCRPTid) RHROid
              from RHDLiquidacionRenta
              where RHRentaId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHRentaId#">
                and RHCRPTid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHCRPTid#">
              <cfif isdefined('Arguments.EIRid') and Arguments.EIRid NEQ -1>
              	and EIRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EIRid#">
              </cfif>
              <cfif isdefined('Arguments.DEid') and Arguments.DEid NEQ -1>
              	and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
              </cfif>
              <cfif isdefined('Arguments.Nversion') and Arguments.Nversion NEQ -1>
              	and Nversion = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Nversion#">
              </cfif>
              <cfif isdefined('Arguments.Tipo') and Arguments.Tipo NEQ -1>
              	and Tipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tipo#">
              </cfif>
              <cfif isdefined('Arguments.Periodo') and Arguments.Periodo NEQ -1>
              	and Periodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Periodo#">
			  </cfif>
              <cfif isdefined('Arguments.Mes') and Arguments.Mes NEQ -1>
              	and Mes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mes#">
			  </cfif>
              	
              order by Periodo asc, Mes asc
		</cfquery>
        <cfreturn rsDatosD>
    </cffunction>
<!---►►►►==================Obtiene Las lineas del reporte==================--->   
    <cffunction name="GetLineasReporte" access="public" returntype="query"> 
     	<cfargument name="RHRPTNcodigo" type="string"   required="yes">
        <cfargument name="RHCRPTcodigo" type="string"   required="no">
    	<cfargument name="Ecodigo" 		type="numeric" 	required="no">
		<cfargument name="Conexion" 	type="string"   required="no">
       
        <cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
	    </cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
	    </cfif>
        <cfquery name="rsLineas" datasource="#Arguments.Conexion#">
            select RHCRPTid,RHCRPTcodigo,RHCRPTdescripcion, RHRPTNcodigo, b.RHRPTNOrigen
              from RHReportesNomina a
                inner join RHColumnasReporte b
                  on b.RHRPTNid = a.RHRPTNid 
                 where a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                   and Rtrim(a.RHRPTNcodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Arguments.RHRPTNcodigo)#">
                <cfif isdefined('Arguments.RHCRPTcodigo')>
                   and Rtrim(b.RHCRPTcodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Arguments.RHCRPTcodigo)#">    
                </cfif>
        </cfquery>
        <cfreturn rsLineas>
     </cffunction>
<!---►►►►==================Obtiene el total de IGSS==================--->        
     <cffunction name="GetTotalIGSS" access="public" returntype="query">
		<cfargument name="RHRentaId" type="numeric"  required="yes">
        <cfargument name="EIRid" 	 type="numeric"  required="no">
		<cfargument name="DEid" 	 type="numeric"  required="no">
        <cfargument name="Conexion"  type="string"   required="no">
		<cfargument name="Ecodigo" 	 type="numeric"  required="no">
        <cfargument name="Tipo" 	 type="string" 	 required="no" default="P">
        
		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
	    </cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
	    </cfif>
        	
		<cfquery name="rsSumaIGSS" datasource="#Arguments.Conexion#">		
				select  coalesce(sum(IGSSCal),0) as IGSSCal,
						coalesce(sum(IGSSEmp),0) as IGSSEmp,
					    coalesce(sum(IGSSAut),0) as IGSSAut
				
				from RHDLiquidacionRenta  DL
                	inner join RHColumnasReporte CR
						on CR.RHCRPTid	= DL.RHCRPTid	
                	inner join RHReportesNomina  RN
                    	on RN.RHRPTNid  = CR.RHRPTNid
				where rtrim(RN.RHRPTNcodigo) = 'GLRB'	
                  and RN.Ecodigo 	  		 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#"> 
                  <cfif isdefined('Arguments.Mes') and Arguments.Mes NEQ -1>
                  and DL.EIRid		  		 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EIRid#">
                  </cfif>
                  <cfif isdefined('Arguments.Mes') and Arguments.Mes NEQ -1>
				  and DL.DEid 		  		 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#"> 
                  </cfif>
				  and DL.Tipo 		  		 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Tipo#"> 
		</cfquery>	
		<cfreturn rsSumaIGSS>		
	</cffunction>
<!---►►►►FUNCION QUE RETORNA EL MONTO DEDUCIBLE DE RENTA MONTO QUE SE REGISTRA COMO DEDUCIBLE DENTRO DE LA TABLA DE RENTA --->
	<cffunction name="GetDeducible" access="public" returntype="numeric">
		<cfargument name="EIRid"	type="numeric" required="true">
		<cfargument name="IRcodigo" type="string"  required="true">
        <cfargument name="Conexion" type="string"  required="no">
         
         <cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
	    </cfif>
        
		<cfquery name="rsMonto" datasource="#Arguments.Conexion#">
			select coalesce(sum(DCDvalor),0) as DCDvalor
			from ConceptoDeduc b
			inner join DConceptoDeduc c
				  on c.CDid = b.CDid
			where b.IRcodigo = <cfqueryparam cfsqltype="cf_sql_char" 	value="#Arguments.IRcodigo#">
			  and c.EIRid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EIRid#">
		</cfquery>		
		<cfreturn rsMonto.DCDvalor>
	</cffunction>	
<!---►►►►FUNCION PARA OBTENER EL MONTO DE RENTA APLICADO A LA TABLA --->
	<cffunction name="ObtieneRenta" access="public" returntype="numeric">
		<cfargument name="EIRid" 	type="numeric" required="true">
		<cfargument name="Monto" 	type="numeric" required="true">
		<cfargument name="Conexion" type="string"  required="no">
         
		 <cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
	    </cfif>
        
		<cfquery name="rsDatosRenta" datasource="#Arguments.Conexion#">
			select ((#Arguments.monto# - DIRinf) * (DIRporcentaje/100)) + DIRmontofijo as Renta
			from  EImpuestoRenta a
			inner join DImpuestoRenta b
				  on b.EIRid = a.EIRid
			where a.EIRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EIRid#">
			  and <cfqueryparam cfsqltype="cf_sql_numeric" value="#Monto#"> between DIRinf and DIRsup 
		</cfquery>		
		<cfset Lvar_Renta = 0>
		<cfif rsDatosRenta.Renta GT 0>
			<cfset Lvar_Renta = rsDatosRenta.Renta>
         </cfif>
		<cfreturn Lvar_Renta>
	</cffunction> 
<!---►►►►FUNCION QUE OBTIENE MONTO DE RENTA RENTENIDA --->   
	<cffunction name="ObtieneRentaRetenida" access="public" returntype="numeric">
		<cfargument name="Ecodigo" 		type="numeric" required="no">
		<cfargument name="DEid" 		type="numeric" required="true">
		<cfargument name="FechaDesde" 	type="numeric" required="yes">
		<cfargument name="FechaHasta" 	type="numeric" required="yes">
        <cfargument name="Conexion" 	type="string"  required="no">
        
        <cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
	    </cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
	    </cfif>
        
		<cfquery name="rsRenta" datasource="#Arguments.Conexion#">
			select sum(SErenta) as monto
			from HRCalculoNomina a
			inner join HSalarioEmpleado b
				on b.RCNid = a.RCNid
			where a.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			 and b.DEid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
			 and (RCdesde between <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.FechaDesde#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.FechaHasta#">
			   or RChasta between <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.FechaDesde#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.FechaHasta#">) 
		</cfquery>
	
			<cfset Lvar_RentaR = 0>
		<cfif rsRenta.RecordCount and rsRenta.monto GT 0>
			<cfset Lvar_RentaR = rsRenta.Monto>
		</cfif>
		<cfreturn Lvar_RentaR>
	</cffunction>
<!---►►►►Obtienen el Total [Empleado-Autorizado-Calulado] por linea--->    
    <cffunction name="ObtieneTotal" access="public" returntype="numeric">
        <cfargument name="Ecodigo" 		type="numeric" required="yes">
        <cfargument name="RHCRPTid" 	type="numeric" required="yes">
        <cfargument name="DEid" 		type="numeric" required="yes">
        <cfargument name="SalarioBase" 	type="numeric" required="yes">
        <cfargument name="Tipo" 		type="numeric" required="yes">
        <cfargument name="Periodo" 		type="numeric" required="no">
        <cfargument name="Mes" 			type="numeric" required="no">
        <cfargument name="FechaDesde"   type="date"    required="no">
		<cfargument name="FechaHasta"   type="date"    required="no">
      
        <!---►►►►►►►►►►►►SALARIO BASE◄◄◄◄◄◄◄◄◄◄◄◄--->
        <cfset Lvar_SalBase = 0>
        <cfif Arguments.SalarioBase EQ 1>
            <cfquery name="SalarioBase" datasource="#session.DSN#">
                select coalesce(sum(SEsalariobruto),0) as monto
                  from HRCalculoNomina a
                    inner join HSalarioEmpleado b
                       on b.RCNid = a.RCNid
                    inner join CalendarioPagos c
                       on c.CPid = a.RCNid 
                where b.DEid 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                  
				  <cfif isdefined('Arguments.Periodo') and Arguments.Periodo NEQ -1 and isdefined('Arguments.Mes') and Arguments.Mes NEQ -1>
                      and c.CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Periodo#">
                      and c.CPmes 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mes#">
                  
				  <cfelseif isdefined('Arguments.FechaDesde') and isdefined('Arguments.FechaHasta')>
                      and (RCdesde between <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.FechaDesde#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.FechaHasta#">
                        or RChasta between <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.FechaDesde#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.FechaHasta#">) 
                  </cfif>
                  	  and c.CPtipo not in (2)<!---No tome en cuenta las nomina de tipo anticipo---> 	
            </cfquery>			
            <cfif SalarioBase.monto GT 0>
                <cfset Lvar_SalBase = SalarioBase.monto>
            </cfif>
        </cfif>		
        <!---►►►►►►►►►►►►CONCEPTOS DE PAGO◄◄◄◄◄◄◄◄◄◄◄◄--->
        <cfset Lvar_CIid    = 0>
        <cfset MontoInc		= 0>	
        <cfquery name="rsCIid" datasource="#session.DSN#">
            select distinct CIid
              from RHConceptosColumna
            where RHCRPTid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.RHCRPTid#">
              and CIid is not null
        </cfquery>				
        <cfif rsCIid.RecordCount>
            <cfset Lvar_CIid = ValueList(rsCIid.CIid)>
        </cfif>
        <cfquery name="rsSumaCIid" datasource="#session.DSN#">
            select coalesce(sum(ICmontores),0) as monto
            from HIncidenciasCalculo a
            inner join CalendarioPagos b
                on b.CPid = a.RCNid
            inner join CIncidentes c
                on c.CIid = a.CIid
                and c.Ecodigo = b.Ecodigo
            where DEid 		  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
              <cfif isdefined('Arguments.Periodo') and Arguments.Periodo NEQ -1 and isdefined('Arguments.Mes') and Arguments.Mes NEQ -1>
                  and b.CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Periodo#">
                  and b.CPmes 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mes#">
              <cfelseif isdefined('Arguments.FechaDesde') and isdefined('Arguments.FechaHasta')>
              	  and ICfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.FechaDesde#"> 
                  and <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.FechaHasta#">
              </cfif>    
              and b.CPtipo not in (2)
              and a.CIid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_CIid#" list="yes">)
        </cfquery>
        <cfif rsSumaCIid.RecordCount and rsSumaCIid.Monto GT 0>
            <cfset MontoInc = rsSumaCIid.Monto>
        </cfif>
        <!---►►►►►►►►►►►►DEDUCCIONES◄◄◄◄◄◄◄◄◄◄◄◄--->
        <cfset Lvar_TDid 	= 0>	
         <cfset MontoDeduc  = 0>
        <cfquery name="rsTDid" datasource="#session.DSN#">
            select distinct TDid
             from RHConceptosColumna
             where RHCRPTid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.RHCRPTid#">
               and TDid is not null
        </cfquery>
        <cfif rsTDid.RecordCount >
            <cfset Lvar_TDid = ValueList(rsTDid.TDid)>
        </cfif>
        <cfquery name="rsSumaTDid" datasource="#session.DSN#">
            select coalesce(sum(DCvalor),0) as monto
             from HDeduccionesCalculo a
                inner join DeduccionesEmpleado b
                    on b.Did = a.Did
                inner join TDeduccion c
                    on c.TDid = b.TDid
                inner join CalendarioPagos d
                    on d.CPid = a.RCNid
            where a.DEid 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
              and c.TDid in  (  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_TDid#" list="yes">)
              and c.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
              <cfif isdefined('Arguments.Periodo') and Arguments.Periodo NEQ -1 and isdefined('Arguments.Mes') and Arguments.Mes NEQ -1>
                and d.CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Periodo#">
                and d.CPmes 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mes#">
              <cfelseif isdefined('Arguments.FechaDesde') and isdefined('Arguments.FechaHasta')>
                and (<cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.FechaDesde#"> between Dfechaini and Dfechafin
			      or <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.FechaHasta#"> between Dfechaini and Dfechafin)
              </cfif>
              and d.CPtipo not in (2)
        </cfquery>
        <cfif rsSumaTDid.RecordCount and rsSumaTDid.Monto GT 0>
            <cfset MontoDeduc = rsSumaTDid.Monto>
        </cfif>
        <!---►►►►►►►►►►►►CARGAS◄◄◄◄◄◄◄◄◄◄◄◄--->
        <cfset Lvar_DClinea = 0>
        <cfset MontoCargas  = 0>
        <cfquery name="rsCarga" datasource="#session.DSN#">
            select distinct DClinea
            from RHConceptosColumna
            where RHCRPTid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.RHCRPTid#">
              and DClinea is not null
        </cfquery>
        <cfif rsCarga.RecordCount >
            <cfset Lvar_DClinea = ValueList(rsCarga.DClinea)>
        </cfif>
        <cfquery name="rsSumaCargas" datasource="#session.DSN#">
            select coalesce(sum(CCvaloremp),0) as monto
            from HRCalculoNomina a
            inner join HCargasCalculo b
                on b.RCNid = a.RCNid
            inner join CalendarioPagos c
                on c.CPid = a.RCNid
            where b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                and b.DClinea in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_DClinea#" list="yes">)
              <cfif isdefined('Arguments.Periodo') and Arguments.Periodo NEQ -1 and isdefined('Arguments.Mes') and Arguments.Mes NEQ -1>
                and c.CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Periodo#">
                and c.CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mes#">
              <cfelseif isdefined('Arguments.FechaDesde') and isdefined('Arguments.FechaHasta')>
              	 and (<cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.FechaDesde#"> between RCdesde and RChasta
			  		or <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.FechaHasta#"> between RCdesde and RChasta)
              </cfif>
              and c.CPtipo not in (2)
        </cfquery>
        <cfif rsSumaCargas.RecordCount and rsSumaCargas.Monto GT 0>
            <cfset MontoCargas = rsSumaCargas.Monto>
        </cfif>
        <!---►►►►►►►►►►►►Retorno de los Valores◄◄◄◄◄◄◄◄◄◄◄◄--->
        <cfif Arguments.Tipo EQ 1>
            <cfset result = Lvar_SalBase + MontoInc -(MontoDeduc + MontoCargas)> 
        <cfelseif Arguments.Tipo EQ 2>
            <cfset result = (MontoDeduc + MontoCargas) + ABS(MontoInc)><!---ABS(MontoInc) = Esto dara problemas cuando metan incidencias Positivas que no sea Bono 14--->
         <cfelseif Arguments.Tipo EQ 3>
            <cfset result = (MontoDeduc + MontoCargas) - MontoInc> 					
        </cfif>
        <cfreturn result>
    </cffunction> 
<!---►►►►Obtencion del parametro 2120◄◄◄◄◄--->
	<cffunction name="GetParam2120" access="public" returntype="string">
        <cfargument name="Ecodigo" 		type="numeric" required="no">
        <cfargument name="Conexion" 	type="string"  required="no">
        
        <cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
	    </cfif>
        <cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
	    </cfif>
        <cfquery name="rsParam" datasource="#Arguments.Conexion#">
        	select Pvalor as Pvalor
            	from RHParametros 
             where Pcodigo = 2120 
               and Ecodigo = #Arguments.Ecodigo#
        </cfquery>
       	<cfif rsParam.RecordCount EQ 0 or NOT  LEN(TRIM(rsParam.Pvalor))>
        	<cfthrow message="La empresa no tienen definido el parámetro Cargas del IGSS(ISRR).">
        </cfif>
        <cfreturn rsParam.Pvalor>
    </cffunction>
<!---►►►►Funcion para verificar si existe una proyeccion de la Liquidacion Finalizada◄◄◄--->
    <cffunction name="ExisteProyeccionFinalizada" access="public" returntype="boolean">
        <cfargument name="EIRid" 		type="numeric" required="no">
        <cfargument name="DEid" 		type="numeric" required="no">
        <cfargument name="PeriodoD" 	type="numeric" required="no">
        <cfargument name="MesD" 		type="numeric" required="no">
        <cfargument name="PeriodoH" 	type="numeric" required="no">
        <cfargument name="MesH" 		type="numeric" required="no">
        <cfargument name="Conexion" 	type="string"  required="no">
        
        <cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
	    </cfif>
         <cfquery name="MaxVersion" datasource="#Arguments.Conexion#">
        	 select max(Nversion) as Nversion 
             	from RHLiquidacionRenta 
                  where EIRid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EIRid#">
                    and DEid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                    and Tipo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="P">
                   <!---Perido/Mes de la proyección debe ser MAYOR al "periodo/Mes DESDE" de la liquidacion--->
                    and (
                   		(Periodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PeriodoD#"> AND Mes >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MesD#">) OR 
                         Periodo > <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PeriodoD#"> 
                        )
                  <!---Perido/Mes de la proyección debe ser MENOR al "periodo/Mes HASTA" de la liquidacion--->
                    and (
                   		(Periodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PeriodoH#"> AND Mes <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MesH#">) OR 
                         Periodo < <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PeriodoH#"> 
                        )
                   and Estado = 30
         </cfquery>
        <cfreturn MaxVersion.RecordCount GT 0 and LEN(TRIM(MaxVersion.Nversion))>
    </cffunction>
<!---►►►►Function para la abtencio del IGSS, tomandolo de los historicos◄◄◄--->
    <cffunction name="ObtieneIGSS" access="public" returntype="numeric">
        <cfargument name="DEid" 	  type="numeric" required="true">
        <cfargument name="FechaDesde" type="numeric" required="yes">
        <cfargument name="FechaHasta" type="numeric" required="yes">
        <cfargument name="Ecodigo" 	  type="numeric" required="no">
        <cfargument name="Conexion"   type="string"  required="no">
            
        <cfif not isdefined('Arguments.Conexion')>
            <cfset Arguments.Conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
            <cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
    
        <cfquery name="rsIGSSPagado" datasource="#Arguments.Conexion#">
            select coalesce(sum(cc.CCvaloremp),0) as empleado
             from HCargasCalculo cc
                inner join DCargas d
                    on d.DClinea = cc.DClinea
                inner join ECargas e
                    on e.ECid = d.ECid  
                inner join HRCalculoNomina CalcNom		
                    on CalcNom.RCNid = cc.RCNid
            where cc.DEid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
              and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">			
              and cc.CCvaloremp is not null
              and cc.CCvaloremp <> 0	
              and e.ECauto = 1				
              and (RCdesde between <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.FechaDesde#"> 
                               and <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.FechaHasta#">
                or RChasta between <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.FechaDesde#"> 
                               and <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.FechaHasta#">)
            group by e.ECdescripcion, e.ECid 
        </cfquery>
        
        <cfset Lvar_IGSS = 0>
        <cfif rsIGSSPagado.RecordCount and rsIGSSPagado.empleado GT 0>
            <cfset Lvar_IGSS = rsIGSSPagado.empleado>
        </cfif>
        <cfreturn Lvar_IGSS>
    </cffunction>
<!---►►►►Funccion para Cargar la Ultima Proyeccion a una Liquidacion de Renta◄◄◄--->
    <cffunction name="CargaProyeccionRenta" access="public">
        <cfargument name="RHRentaId"   type="numeric" required="true">
      	<cfargument name="Autorizador" type="string"  required="true">
        <cfargument name="Conexion"   type="string"  required="no">
        
        <cfif not isdefined('Arguments.Conexion')>
            <cfset Arguments.Conexion = session.dsn>
        </cfif>
        <cfif Arguments.Autorizador>
        	<cfset USRInicia = "Autorizacion">
        <cfelse>
        	<cfset USRInicia = "Usuario">
        </cfif>
    	<!---►►Se obtienen el Encabezado de la Proyeccion Finalizada◄◄◄--->
        <cfquery datasource="#Arguments.Conexion#" name="RsP">
        	select DEid,Periodo,Mes,EIRid
              from RHLiquidacionRenta
            where RHRentaId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHRentaId#">   
        </cfquery>
        <!---►►Se obtinene los detalles de la Proyeccion Finalizada◄◄--->
        <cfquery name="PreUpdate" datasource="#Arguments.Conexion#">
            select RHCRPTid
                from RHDLiquidacionRenta 
            where RHRentaId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHRentaId#">
             group by RHCRPTid
        </cfquery>
        
		<cftransaction>
			<cfset RHRentaIdNEW = AltaRHLiquidacionRenta(RsP.DEid,RsP.periodo,RsP.EIRid,RsP.mes,1,USRInicia,session.Ecodigo,Arguments.Conexion,'L', session.Usucodigo)>
     		<cfloop query="PreUpdate">
                <cfquery name="dataUpdate" datasource="#Arguments.Conexion#">
                    select sum(Coalesce(MontoHistorico,0))   as MontoHistorico,
                    	   sum(Coalesce(MontoEmpleado,0))    as MontoEmpleado,
                           sum(Coalesce(MontoAutorizado,0))  as MontoAutorizado
                      from RHDLiquidacionRenta 
                      where RHRentaId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHRentaId#">
                        and RHCRPTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PreUpdate.RHCRPTid#">
                </cfquery>
                <!---Se Actualiza el Monto del Empleado y el Monto Autorizado de la liquidacion con el monto Autorizado de la Ultima Proyeccion Finalizada--->	
                    <cfquery name="Update" datasource="#Arguments.Conexion#">
                       insert into RHDLiquidacionRenta 
						(EIRid, Nversion, DEid, Tipo, RHCRPTid, Periodo, Mes, 
                         MontoHistorico, MontoEmpleado, MontoAutorizado, PorcCargaSocial, 
                         Observaciones, BMUsucodigo, BMfechaalta, DLRingresos, 
                         DLRdeduccionPersonal, DLRigss, DLRseguroVida, DLRgastosMedicos, DLRpensiones, DLRotrosGastos, DLRporcentajeBase, DLRdeduccionBase, 
                         DLRimpuestoFijo, DLRretenciones, DLRcreditoIva, RentaRetenida, RentaRetenidaAut, IGSSEmp, IGSSAut, IGSSCal, 
                         RHRentaId)
				      values 
                        (#RsP.EIRid#,1,#RsP.DEid#, 'L',#PreUpdate.RHCRPTid#,#RsP.Periodo#,#RsP.Mes#, 
                         #dataUpdate.MontoHistorico#,#dataUpdate.MontoEmpleado#,#dataUpdate.MontoAutorizado#, 0, 
                         '', #session.Usucodigo#, <cf_dbfunction name="now">,0, 
                         0,0,0,0,0,0,0,0, 
                         0,0,0,0,0,0,0,0,
                         #RHRentaIdNEW#)
                    </cfquery>
            </cfloop>
            <!---Copiado de las rentas de otros y Ex patrones--->
             <cfquery datasource="#Arguments.Conexion#">
                  insert into RHRentaOrigenes 
                        ( RHRentaId,    RHCRPTid,NIT,FechaIni,FechaFin,RentaNetaAut,RentaNetaEmp,BMfechaalta,BMUsucodigo)
                  select #RHRentaIdNEW#,RHCRPTid,NIT,FechaIni,FechaFin,RentaNetaAut,RentaNetaEmp,<cf_dbfunction name="now">,#session.Usucodigo#
                   from RHRentaOrigenes
                   where RHRentaId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHRentaId#">
             </cfquery>
        </cftransaction>
    </cffunction>
<!---►►►►OBTIENE LOS PERIODOS PENDIENTES DE UNA NOMINA ORDINARIA --->
	<cffunction name="ObtienePeriodosPendientes" access="public" returntype="numeric">
		<cfargument name="Ecodigo"  type="numeric" required="yes">
		<cfargument name="DEid" 	type="numeric" required="yes">
		<cfargument name="periodo"  type="numeric" required="yes">
		
		<!--- Sacar la maxima nomina de la persona en el año fiscal  --->	
		
		<cfquery name="rsAlgunaNomina" datasource="#session.DSN#" >
			select b.RCNid		
			from HRCalculoNomina a
				inner join CalendarioPagos c
					on c.CPid = a.RCNid 
				inner join HSalarioEmpleado b
					on b.RCNid = a.RCNid
			where b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
			and c.CPperiodo =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.periodo#">
			and c.CPtipo=0  <!---Solo Nominas Ordinarias	--->
		</cfquery>
		
		<cfif rsAlgunaNomina.recordCount NEQ 0>
			
			<cfquery name="rsMaxNominaAñoFiscal" datasource="#session.DSN#" >
				select  max(b.RCNid) as maximaRNid				
				from HRCalculoNomina a
					inner join CalendarioPagos c
						on c.CPid = a.RCNid 
					inner join HSalarioEmpleado b
						on b.RCNid = a.RCNid
				where b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
				and c.CPperiodo =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.periodo#">
				and c.CPtipo=0  <!---Solo Nominas Ordinarias	--->
			</cfquery>
					
			<cfset maxRNid= #rsMaxNominaAñoFiscal.maximaRNid#>	
		
			<!---  Para la ultima nomina calculada se obtiene Periodo, Mes ,Tipo de Nomina y Ecodigo 	--->	 
			 <cfquery name="rsObtieneInfo" datasource="#session.DSN#">
				 select calendario.CPperiodo as periodo, 
						calendario.CPmes as mes,
						nomina.Tcodigo as Tcodigo, 
						nomina.Ecodigo  
		
				from  HRCalculoNomina nomina, CalendarioPagos calendario
							
				where nomina.RCNid=#maxRNid#
				and nomina.Ecodigo = calendario.Ecodigo
				and nomina.Tcodigo = calendario.Tcodigo
				and nomina.RCNid= calendario.CPid 	
				and calendario.CPtipo = 0   <!---Solo Nominas Ordinarias	--->		 
			 </cfquery>
					 
			 <cfset Tcodigo=rsObtieneInfo.Tcodigo >
					 
			 <!--- Cantidad de Nominas cerradas (que esten en la tabla HRCalculoNomina ) de ese tipo de nomina, periodo y mes  	 --->
			 <cfquery name="rsCerradas" datasource="#session.DSN#">
						select  count(nomina.RCNid)as NominasCerradas
						from CalendarioPagos calend, HRCalculoNomina nomina
						where calend.Tcodigo= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Tcodigo#"> 
						and calend.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
						and calend.CPperiodo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.periodo#">			
						and calend.CPtipo = 0   <!---Solo Nominas Ordinarias	--->
						and nomina.RCNid = calend.CPid  
						and nomina.Tcodigo = calend.Tcodigo 
						and nomina.Ecodigo = calend.Ecodigo		 
			 </cfquery>
			 
			 <cfset nominasCerradas= #rsCerradas.NominasCerradas#>
			 
			 <!--- Cantidad de Nominas encontradas para ese periodo y mes   --->
			 <cfquery name="rsNominasEncontradas" datasource="#session.DSN#">
			 select  count(calend.CPid )as cantNominas
						from CalendarioPagos calend
						where calend.Tcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Tcodigo#"> 
						and calend.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
						and calend.CPperiodo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.periodo#">					
						and calend.CPtipo = 0   --Solo Nominas Ordinarias		 
			</cfquery>
			<cfset nominasEncontradas= #rsNominasEncontradas.cantNominas#>
			<cfset periodosPendientes =#nominasEncontradas# - #nominasCerradas# >
		<cfelse>
			
			<cfset periodosPendientes = 0 >
		</cfif>
		
		<cfreturn periodosPendientes >	
	</cffunction>
<!---►►►►Actualización de los montos del Enzabezado◄◄◄◄--->
    <cffunction name="UpdMontosRHLiquidacionRenta" access="public">
        <cfargument name="RHRentaId" 		 type="numeric" required="true">
        <cfargument name="RHLIVAplanilla_A"  type="numeric" required="no"   default="-1">
		<cfargument name="RHLIVAplanilla_E"  type="numeric" required="no"   default="-1">
        <cfargument name="RHLRentaRetenida"  type="numeric" required="no"   default="-1">
        <cfargument name="Ecodigo" 			 type="numeric" required="no">
        <cfargument name="Conexion" 		 type="string"  required="no">
            
        <cfif not isdefined('Arguments.Conexion')>
            <cfset Arguments.Conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
            <cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        
        <cfquery datasource="#Arguments.Conexion#">
        	update RHLiquidacionRenta
            	set BMUsucodigo = #session.Usucodigo#
                <cfif ISDEFINED('Arguments.RHLIVAplanilla_A') AND Arguments.RHLIVAplanilla_A NEQ -1>
                   ,RHLIVAplanilla_A = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHLIVAplanilla_A#">
                </cfif>
                <cfif ISDEFINED('Arguments.RHLIVAplanilla_E') AND Arguments.RHLIVAplanilla_E NEQ -1>
                   ,RHLIVAplanilla_E = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHLIVAplanilla_E#">
                </cfif>
                <cfif ISDEFINED('Arguments.RHLRentaRetenida') AND Arguments.RHLRentaRetenida NEQ -1>
                   ,RHLRentaRetenida = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHLRentaRetenida#">
                </cfif>
        	 where RHRentaId   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHRentaId#"> 
        </cfquery>
    </cffunction>
<!---►►►►INSERTA EL DETALLE PARA CADA UNA DE LAS COLUMNAS DEL REPORTE--->	
    <cffunction name="InsertaDesgloce" access="public" returntype="query">
        <cfargument name="RHRentaId" 	type="numeric" 	required="yes"> 
        <cfargument name="EIRid" 		type="numeric" 	required="yes">
        <cfargument name="DEid" 		type="numeric" 	required="yes">
        <cfargument name="Nversion" 	type="numeric" 	required="yes">
        <cfargument name="RHCRPTid" 	type="numeric" 	required="yes">
        <cfargument name="SalarioBase" 	type="numeric" 	required="yes">
        <cfargument name="Codigo" 		type="string" 	required="yes">
        <cfargument name="RHRPTNcodigo" type="string" 	required="yes">
        <cfargument name="Autorizacion" type="numeric"	required="no">	
        <cfargument name="AnoDesde" 	type="numeric" 	required="yes">
        <cfargument name="MesDesde" 	type="numeric" 	required="yes">
        <cfargument name="AnoHasta" 	type="numeric" 	required="yes">
        <cfargument name="MesHasta" 	type="numeric" 	required="yes">
        <cfargument name="IRcodigo" 	type="string" 	required="no"> 
        
        <cfset RHRPTNcodigo  	= Arguments.RHRPTNcodigo>
        <cfset Lvar_SalarioBase = 0>
        <cfset Lvar_DeducPer 	= 0>
        <cfset Lvar_IGSS 		= 0>
        <cfset Lvar_CREFIS 		= 0>
            
        <cfswitch expression="#Ucase(trim(RHRPTNcodigo))#">  
            <cfcase value="GLRB"> <!--- Salario Bruto --->
                <cfset Lvar_TipoSuma = 1>
            </cfcase>
            <cfcase value="GLRD"> <!--- Deducciones --->
                <cfset Lvar_TipoSuma = 2>	
            </cfcase>	
            <cfcase value="GLRC"> <!---LAS CREDITO FISCAL--->
                <cfset Lvar_TipoSuma = 3>	
            </cfcase>				
        </cfswitch>
            
        <cfswitch expression="#Ucase(trim(Arguments.Codigo))#">
            <cfcase value="SalarioBruto">
                <cfset Lvar_SalarioBase = 1>
            </cfcase>
            <cfcase value="DeducPer">								
                <cfset Lvar_DeducPer = 1>
            </cfcase>
            <cfcase value="Cuotas">
                <cfset Lvar_IGSS = 1>
            </cfcase>
            <cfcase value="CREFIS">
                <cfset Lvar_CREFIS = 1>
            </cfcase>
        </cfswitch>	
        
        <cfset Lvar_Carga = GetCargasEmpleado(Arguments.DEid,Arguments.RHCRPTid,Lvar_SalarioBase )>
        
        <!--- VERIFICA QUE EXISTA EL DESGLOCE DE LA VERSION DE LA PROYECCION --->
        <cfquery name="rsVerifica" datasource="#session.DSN#">
            select 1
            from RHDLiquidacionRenta
            where EIRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EIRid#">
              and DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
              and Tipo = 'P' <!--- PROYECCION --->
              and Nversion = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Nversion#">
              and RHCRPTid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.RHCRPTid#">
        </cfquery>	
        
        <cfset versAnt= #Arguments.Nversion#-1>
        <cfquery name="rsVersionAnterior" datasource="#session.DSN#">
            select 1
            from RHDLiquidacionRenta
            where EIRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EIRid#">
              and DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
              and Tipo = 'P' <!--- PROYECCION --->
              and Nversion = <cfqueryparam cfsqltype="cf_sql_integer" value="#versAnt#">
              and RHCRPTid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.RHCRPTid#">
        </cfquery>	
        
        <cfset version = #Arguments.Nversion#>
        <cfif ((rsVerifica.RecordCount EQ 0) and (rsVersionAnterior.RecordCount GT 0))>
            <cfset version = #Arguments.Nversion#-1>			
        </cfif>
        
        <!--- La idea es que los montos historicos se actualicen en cualquier momento que se reabre la nomina --->
        <!--- O se esta trabajando con una versión nueva si rsVerifica.RecordCount EQ 0 , pero existe una anterior --->
        <cfif rsVerifica.RecordCount GT 0  or ((rsVerifica.RecordCount EQ 0) and (rsVersionAnterior.RecordCount GT 0)) >					
        
                <!--- Traer los montos de los historicos actualizados a cualquier momento en que se abre --->
                                
                <cfif Lvar_TipoSuma EQ 1 >						
                    <cfif Lvar_SalarioBase EQ 1>		
                            
                            <!--- Actualizar los montos del Salario Base mes a mes --->						
                                <cfset lvarMes 			= Arguments.mesDesde>
                                <cfset lvarPeriodo	    = Arguments.AnoDesde>
                                <cfset lvarMesHasta 	= Arguments.mesHasta>
                                <cfset lvarPeriodoHasta = Arguments.AnoHasta>
                                <cfloop condition="TRUE">
                                    <cfif (lvarPeriodo EQ lvarPeriodoHasta AND lvarMes GT lvarMesHasta) or lvarPeriodo GT lvarPeriodoHasta>
                                        <cfbreak>
                                    </cfif>
                                                                 
                                    <cfset Lvar_Dato = ObtieneTotal(session.Ecodigo,Arguments.RHCRPTid,Arguments.DEid,Lvar_SalarioBase,Lvar_TipoSuma,lvarPeriodo,lvarMes)>		  
                                    <!--- ACTUALIZA EL VALOR DEL HISTORICO --->																				
                                    <cfquery name="rsInsertaCreditoFiscal" datasource="#session.DSN#">
                                        update RHDLiquidacionRenta
                                           set MontoHistorico = <cfqueryparam cfsqltype="cf_sql_money" value="#Lvar_Dato#">
                                                            
                                        where EIRid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EIRid#">
                                          and Nversion 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Nversion#">
                                          and DEid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                                          and Tipo 		= 'P'
                                          and RHCRPTid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHCRPTid#">						
                                    </cfquery>	
                                    
                                    <cfif lvarMes EQ 12>
                                        <cfset lvarPeriodo = lvarPeriodo +1>
                                        <cfset lvarMes = 1>
                                    <cfelse>
                                        <cfset lvarMes = lvarMes + 1>
                                     </cfif>																
                                </cfloop>
                        </cfif>
                    </cfif>			
                    <!--- Que pasa con los demás conceptos? !!! --->
                    
                    <!--- Traigase los datos --->											
                    <cfquery name="rsDatosD" datasource="#session.DSN#">
                        select *
                        from RHDLiquidacionRenta
                        where EIRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EIRid#">
                          and DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                          and Tipo = 'P' <!--- PROYECCION --->
                          and Nversion = <cfqueryparam cfsqltype="cf_sql_integer" value="#version#">
                          and RHCRPTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHCRPTid#">
                          order by Mes asc
                    </cfquery>	
                                
        <cfelse>	
            <!--- INSERTA LOS REGISTROS PARA CADA UNO DE LOS MESES DEPENDIENDO EL MOMENTO EN Q SE ESTA GENERANDO LA PROYECCION, SI HAY UN CALCULO PARA ESOS MESES--->
            <!--- SE TOMAN EL VALOR QUE SE TIENE EN EL AÑO ACTUAL, SI NO SE TOMA EL VALOR QUE TUVO EL AÑO ANTERIOR  --->
            
            <!--- HISTÓRICOS DEL AÑO DE VIGENCIA  ---->
                    
            <cfset lvarMes 			= Arguments.mesDesde>
            <cfset lvarPeriodo	    = Arguments.AnoDesde>
            <cfset lvarMesHasta 	= Arguments.mesHasta>
            <cfset lvarPeriodoHasta = Arguments.AnoHasta>
            <cfloop condition="TRUE">
                    <cfif (lvarPeriodo EQ lvarPeriodoHasta AND lvarMes GT lvarMesHasta) or lvarPeriodo GT lvarPeriodoHasta>
                        <cfbreak>
                    </cfif>			
                <!---  INSERTANDO EL DETALLE PARA LOS CONCEPTOS DE LA RENTA BRUTA  ---> 
                 <cfif Lvar_TipoSuma EQ 1 >			
                     <cfif Lvar_SalarioBase EQ 1>												 
                         <cfset Lvar_Dato = ObtieneTotal(session.Ecodigo,Arguments.RHCRPTid,Arguments.DEid,Lvar_SalarioBase,Lvar_TipoSuma,lvarPeriodo,lvarMes)>		  
                         <cfset Lvar_DatoIGSS = ObtieneIGSS(Arguments.DEid,lvarPeriodo,lvarMes, true) >					
                         <cfset LvarRentaRentenida = ObtieneRentaRetenida(Session.Ecodigo,Arguments.DEid,createDate(lvarPeriodo,lvarMes,1), dateadd('d',-1,dateadd('m',1,Createdate(lvarPeriodo,lvarMes,1))))>
                         
                         <cfquery name="InsertaDetalle" datasource="#session.DSN#">
                            insert into RHDLiquidacionRenta(RHRentaId,EIRid, Nversion, DEid, Tipo, RHCRPTid, Periodo, Mes, MontoHistorico, MontoEmpleado, MontoAutorizado, PorcCargaSocial, BMUsucodigo, BMfechaalta,RentaRetenida,RentaRetenidaAut , IGSSEmp, IGSSAut, IGSSCal)	
                            values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHRentaId#">,
                                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EIRid#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Nversion#">,
                                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">,
                                    'P', <!--- PROYECCION --->
                                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHCRPTid#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarPeriodo#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarMes#">,
                                    <cfqueryparam cfsqltype="cf_sql_money" 	 value="#Lvar_Dato#">,
                                    <cfqueryparam cfsqltype="cf_sql_money" 	 value="#Lvar_Dato#">,
                                    <cfqueryparam cfsqltype="cf_sql_money" 	 value="#Lvar_Dato#">,
                                    <cfqueryparam cfsqltype="cf_sql_float" 	 value="#Lvar_Carga#">,
                                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
                                    <cf_dbfunction name="now">,
                                    <cfqueryparam cfsqltype="cf_sql_money"   value="#LvarRentaRentenida#">,
                                    <cfqueryparam cfsqltype="cf_sql_money"   value="#LvarRentaRentenida#">,
                                    <cfqueryparam cfsqltype="cf_sql_money"   value="#Lvar_Dato * (Lvar_Carga/100)#">,
                                    <cfqueryparam cfsqltype="cf_sql_money"   value="#Lvar_Dato * (Lvar_Carga/100)#">,
                                    <cfqueryparam cfsqltype="cf_sql_money"   value="#Lvar_Dato * (Lvar_Carga/100)#">)
                        </cfquery>																											
                    <cfelse>				
                        <!--- INSERTA EL DETALLE PARA LOS DEMAS CONCEPTO DEL AÑO EN VIGENCIA --->						
                        <cfset Lvar_Dato = ObtieneTotal(session.Ecodigo,Arguments.RHCRPTid,Arguments.DEid,Lvar_SalarioBase,Lvar_TipoSuma,lvarPeriodo,lvarMes)>
                        
                        <cfquery name="InsertaDetalle" datasource="#session.DSN#">
                            insert into RHDLiquidacionRenta(RHRentaId,EIRid, Nversion, DEid, Tipo, RHCRPTid, Periodo, Mes, MontoHistorico, MontoEmpleado, MontoAutorizado, PorcCargaSocial, BMUsucodigo, BMfechaalta,RentaRetenida,RentaRetenidaAut , IGSSEmp, IGSSAut,IGSSCal)	
                            values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHRentaId#">,
                                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EIRid#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Nversion#">,
                                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">,
                                    'P', <!--- PROYECCION --->
                                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHCRPTid#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarPeriodo#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarMes#">,
                                    <cfqueryparam cfsqltype="cf_sql_money"   value="#Lvar_Dato#">,
                                    <cfqueryparam cfsqltype="cf_sql_money" 	 value="#Lvar_Dato#">,
                                    <cfqueryparam cfsqltype="cf_sql_money" 	 value="#Lvar_Dato#">,
                                    <cfqueryparam cfsqltype="cf_sql_float" 	 value="#Lvar_Carga#">,
                                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
                                    <cf_dbfunction name="now">,
                                    0,0,
                                    <cfqueryparam cfsqltype="cf_sql_money"   value="#Lvar_Dato * (Lvar_Carga/100)#">,
                                    <cfqueryparam cfsqltype="cf_sql_money" 	 value="#Lvar_Dato * (Lvar_Carga/100)#">,
                                    <cfqueryparam cfsqltype="cf_sql_money" 	 value="#Lvar_Dato * (Lvar_Carga/100)#">)
                        </cfquery>													
                </cfif>
                
                <!---  INSERTANDO EL DETALLE PARA LOS CONCEPTOS DE LA DEDUCCION  --->		
                <cfelseif Lvar_TipoSuma EQ 2 >	
                                        
                        <cfif (Lvar_DeducPer NEQ 1 ) and (Lvar_IGSS NEQ 1)  >	
                            <cfset Deduccion = ObtieneTotal(session.Ecodigo,Arguments.RHCRPTid,Arguments.DEid,Lvar_SalarioBase,Lvar_TipoSuma,lvarPeriodo,lvarMes)>	
                            <cfquery name="InsertaDetalle" datasource="#session.DSN#">
                            insert into RHDLiquidacionRenta(RHRentaId,EIRid, Nversion, DEid, Tipo, RHCRPTid, Periodo, Mes, MontoHistorico, MontoEmpleado, MontoAutorizado, BMUsucodigo, BMfechaalta,RentaRetenida,RentaRetenidaAut , IGSSEmp, IGSSAut , IGSSCal)	
                            values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHRentaId#">,
                                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EIRid#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Nversion#">,
                                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">,
                                    'P', <!--- PROYECCION --->
                                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHCRPTid#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarPeriodo#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarMes#">,
                                    <cfqueryparam cfsqltype="cf_sql_money"   value="#Deduccion#">,
                                    <cfqueryparam cfsqltype="cf_sql_money"   value="#Deduccion#">,
                                    <cfqueryparam cfsqltype="cf_sql_money"   value="#Deduccion#">,								
                                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
                                    <cf_dbfunction name="now">,
                                    0,0,0,0,0)
                        </cfquery>						
                            
                        </cfif>
              </cfif>
              <cfif lvarMes EQ 12>
                <cfset lvarPeriodo = lvarPeriodo +1>
                <cfset lvarMes = 1>
            <cfelse>
                <cfset lvarMes = lvarMes + 1>
             </cfif>																
        </cfloop>
             
         <!--- INSERTANDO EN TOTAL LA DEDUCCION DE TIPO DEDUCCIONES PERSONALES EN EL MES DESDE DE EL PERIODO FISCAL --->	
         <cfif (Lvar_DeducPer EQ 1 )>	 		
                <cfset DeduccPersonales = GetDeducible(Arguments.EIRid, Arguments.IRcodigo)>			
                <cfquery name="InsertaDetalle" datasource="#session.DSN#">
                            insert into RHDLiquidacionRenta(RHRentaId,EIRid, Nversion, DEid, Tipo, RHCRPTid, Periodo, Mes, MontoHistorico, MontoEmpleado, MontoAutorizado, BMUsucodigo, BMfechaalta,RentaRetenida,RentaRetenidaAut , IGSSEmp, IGSSAut, IGSSCal)	
                            values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHRentaId#">,
                                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EIRid#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Nversion#">,
                                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">,
                                    'P', <!--- PROYECCION --->
                                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHCRPTid#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarPeriodo#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarMes#">,
                                    <cfqueryparam cfsqltype="cf_sql_money" value="#DeduccPersonales#">,
                                    <cfqueryparam cfsqltype="cf_sql_money" value="#DeduccPersonales#">,
                                    <cfqueryparam cfsqltype="cf_sql_money" value="#DeduccPersonales#">,								
                                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
                                    <cf_dbfunction name="now">,
                                    0,0,0,0,0)
                </cfquery>									
         </cfif>
         
         <!--- INSERTANDO EL CREDITO FISCAL con valor de cero para que posteriormente el empleado y autorizador la actualicen de acuerdo al MONTO DADO --->	 
         <cfif Lvar_TipoSuma EQ 3>	 
                <cfquery name="rsSumaRentaBruta" datasource="#session.DSN#">		
                    select  coalesce(sum(DLiquidacion.MontoHistorico),0) as MontoHistorico , coalesce(sum(DLiquidacion.MontoEmpleado),0) as MontoEmpleado , 		    coalesce(sum(DLiquidacion.MontoAutorizado),0) as MontoAutorizado
                    from RHDLiquidacionRenta  DLiquidacion, RHReportesNomina  ReporNom,  RHColumnasReporte ColumRep
                
                    where DLiquidacion.EIRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EIRid#">
                    and DLiquidacion.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#"> 
                    and DLiquidacion.Tipo = 'P' 
                    and DLiquidacion.Nversion = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Nversion#">
                        
                    and Rtrim(ReporNom.RHRPTNcodigo) = 'GLRB'	
                    and ReporNom.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
                    
                    and ColumRep.RHRPTNid  = ReporNom.RHRPTNid 			
                    and DLiquidacion.RHCRPTid = ColumRep.RHCRPTid					
                </cfquery>	
                
                <cfset CredHist= (rsSumaRentaBruta.MontoHistorico *0.12 ) * 0.5 >
                <cfset CredEmpl= 0 >
                <cfset CredAut= 0 >
                                        
                <cfquery name="InsertaCreditoFiscal" datasource="#session.DSN#">
                        insert into RHDLiquidacionRenta(RHRentaId, EIRid, Nversion, DEid, Tipo, RHCRPTid, Periodo, Mes, MontoHistorico, MontoEmpleado, MontoAutorizado,BMUsucodigo, BMfechaalta,RentaRetenida,RentaRetenidaAut , IGSSEmp, IGSSAut, IGSSCal)	
                                values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHRentaId#">,
                                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EIRid#">,
                                        <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Nversion#">,
                                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">,
                                        'P', <!--- PROYECCION --->
                                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHCRPTid#">,
                                        <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarPeriodo#">,
                                        <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarMes#">,
                                        <cfqueryparam cfsqltype="cf_sql_money" value="#CredHist#">,
                                        <cfqueryparam cfsqltype="cf_sql_money" value="#CredEmpl#">,
                                        <cfqueryparam cfsqltype="cf_sql_money" value="#CredAut#">,								
                                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
                                        <cf_dbfunction name="now">,
                                        0,0,0,0,0)
                    </cfquery>					 	 
         </cfif>		
         
        <cfquery name="rsDatosD" datasource="#session.DSN#">
            select *
            from RHDLiquidacionRenta
            where EIRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EIRid#">
              and DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
              and Tipo = 'P' <!--- PROYECCION --->
              and Nversion = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Nversion#">
              and RHCRPTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHCRPTid#">
              order by Mes asc
        </cfquery>	
        
            
    </cfif>				
        <cfreturn rsDatosD>		
    </cffunction>
<!---►►►►Agrega nuevos Origenes de Otros Patrones y Expatrones◄◄◄--->
    <cffunction name="AltaRentaOrigenes" access="public">
           <cfargument name="RHRentaId"  	type="numeric" required="yes">
           <cfargument name="RHCRPTid"  	type="numeric" required="yes">
           <cfargument name="NIT"  			type="string"  required="yes" default="">
           <cfargument name="FechaIni"  	type="numeric" required="yes" default="#now()#">
           <cfargument name="FechaFin"  	type="numeric" required="yes" default="#now()#">
           <cfargument name="RentaNetaAut"  type="numeric" required="yes" default="0">
           <cfargument name="RentaNetaEmp"  type="numeric" required="yes" default="0">
           
           <cfargument name="Conexion"  type="string"  required="no">
                
            <cfif not isdefined('Arguments.Conexion')>
                <cfset Arguments.Conexion = session.dsn>
            </cfif>
            
            <cfquery datasource="#Arguments.Conexion#">
                insert into RHRentaOrigenes 
                (RHRentaId, RHCRPTid, NIT, FechaIni, FechaFin, RentaNetaAut, RentaNetaEmp, BMfechaalta, BMUsucodigo)
                values (
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHRentaId#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHCRPTid#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.NIT#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_date" 	 value="#Arguments.FechaIni#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_date" 	 value="#Arguments.FechaFin#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RentaNetaAut#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RentaNetaEmp#">,
                <cf_dbfunction name="now">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                )
            </cfquery>
    </cffunction>
<!---►►►►Clonacion de Versiones--->
    <cffunction name="ClonarProyeccionRenta" access="public">
        <cfargument name="RHRentaId" 	type="numeric" required="yes">
        <cfargument name="Autorizador"  type="boolean" required="yes" default="false">
        <cfargument name="Conexion"     type="string"  required="no">
                
        <cfif not isdefined('Arguments.Conexion')>
            <cfset Arguments.Conexion = session.dsn>
        </cfif>
        
        <cfquery name="rsIns" datasource="#Arguments.Conexion#">
            select EIRid,DEid,Periodo,Mes,Tipo,Ecodigo,montopagoempresa,montootrospagos,montodeduccionesf,montoretencion,montootrasret,RentaAnual,RentaRetenida,ImpuestoRetener,RetenidoExceso,RentaImponible,ImpuestoAnualDet,CreditoIVA,RHLIVAplanilla_A,RHLIVAplanilla_E,RHLRentaRetenida,Nversion
             from RHLiquidacionRenta
            where RHRentaId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHRentaId#">
        </cfquery>
        <cftransaction>
            <!---Encabezado--->
            <cfquery name="rsInsert" datasource="#Arguments.Conexion#">
                 insert into RHLiquidacionRenta 
                      (EIRid,DEid,Periodo,Mes,Ecodigo,
                      montopagoempresa,montootrospagos,montodeduccionesf,montoretencion,montootrasret,
                      RentaAnual,RentaRetenida,ImpuestoRetener,RetenidoExceso,RentaImponible,ImpuestoAnualDet,CreditoIVA,RHLIVAplanilla_A,RHLIVAplanilla_E,RHLRentaRetenida,
                      Tipo,Estado,Nversion,BMUsucodigo,BMfechaalta,
                      USRInicia)
                  values
                      (#rsIns.EIRid#,#rsIns.DEid#,#rsIns.Periodo#,#rsIns.Mes#,#rsIns.Ecodigo#,
                      #rsIns.montopagoempresa#,#rsIns.montootrospagos#,#rsIns.montodeduccionesf#,#rsIns.montoretencion#,#rsIns.montootrasret#,
                      <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsIns.RentaAnual#" 		voidnull>,
                      <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsIns.RentaRetenida#" 		voidnull>,
                      <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsIns.ImpuestoRetener#" 	voidnull>,
                      <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsIns.RetenidoExceso#" 	voidnull>,
                      <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsIns.RentaImponible#" 	voidnull>,
                      <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsIns.ImpuestoAnualDet#" 	voidnull>,
                      <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsIns.CreditoIVA#" 		voidnull>,
                      <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsIns.RHLIVAplanilla_A#" 	voidnull>,
                      <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsIns.RHLIVAplanilla_E#" 	voidnull>,
                      <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsIns.RHLRentaRetenida#" 	voidnull>,
                      <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#rsIns.Tipo#" 				voidnull>,
                      0,#rsIns.Nversion+1#,#session.Usucodigo#,<cf_dbfunction name="now">,
                      <cfif Arguments.Autorizador>'Autorizacion'<cfelse>'Usuario'</cfif>)
                 <cf_dbidentity1>
            </cfquery>
                <cf_dbidentity2 name="rsInsert">
            <!---Detale--->
            <cfquery datasource="#Arguments.Conexion#">
               insert into RHDLiquidacionRenta 
                      (EIRid,Nversion,DEid,Tipo,RHCRPTid,Periodo,Mes,MontoHistorico,MontoEmpleado,MontoAutorizado,PorcCargaSocial,Observaciones,DLRingresos,DLRdeduccionPersonal,DLRigss,DLRseguroVida,DLRgastosMedicos,DLRpensiones,DLRotrosGastos,DLRporcentajeBase,DLRdeduccionBase,DLRimpuestoFijo,DLRretenciones,DLRcreditoIva,RentaRetenida,RentaRetenidaAut,IGSSEmp,IGSSAut,IGSSCal,IGSS,DLRlinea,RHRentaId,BMUsucodigo,BMfechaalta)
                select EIRid,Nversion,DEid,Tipo,RHCRPTid,Periodo,Mes,MontoHistorico,MontoEmpleado,MontoAutorizado,PorcCargaSocial,Observaciones,DLRingresos,DLRdeduccionPersonal,DLRigss,DLRseguroVida,DLRgastosMedicos,DLRpensiones,DLRotrosGastos,DLRporcentajeBase,DLRdeduccionBase,DLRimpuestoFijo,DLRretenciones,DLRcreditoIva,RentaRetenida,RentaRetenidaAut,IGSSEmp,IGSSAut,IGSSCal,IGSS,DLRlinea,#rsInsert.identity#,#session.Usucodigo#,<cf_dbfunction name="now">
                 from RHDLiquidacionRenta
               where RHRentaId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHRentaId#">
            </cfquery>
            <!---Origenes--->
            <cfquery datasource="#Arguments.Conexion#">
                insert into RHRentaOrigenes 
                      (RHCRPTid,NIT,FechaIni,FechaFin,RentaNetaAut,RentaNetaEmp,BMUsucodigo,BMfechaalta,RHRentaId)
               select RHCRPTid,NIT,FechaIni,FechaFin,RentaNetaAut,RentaNetaEmp,#session.Usucodigo#,<cf_dbfunction name="now">,#rsInsert.identity#
                from RHRentaOrigenes
               where RHRentaId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHRentaId#">
            </cfquery>
        </cftransaction>
    </cffunction>
</cfcomponent>