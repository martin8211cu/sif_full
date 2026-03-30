<cfcomponent output="no">
	<cffunction name="fnAltaEncDoc" access="public" returntype="numeric" output="yes" hint="Grabar el encabezado en la tabla de trabajo">
		<cfargument name='CPTcodigo' 	type='string' 	required='true'>
		<cfargument name='EDdocumento' 	type='string' 	required='true'>
		<cfargument name='SNcodigo' 	type="numeric" 	required='true'>
        <cfargument name='Mcodigo' 		type="numeric" 	required='true'>
        <cfargument name='EDtipocambio' type="numeric" 	required='true'>
        <cfargument name='EDdescuento' 	type="numeric" 	required='true'>
        <cfargument name='EDimpuesto' 	type="numeric" 	required='true'>
        <cfargument name='EDtotal' 		type="numeric" 	required='true'>
        <cfargument name='Ocodigo' 		type="numeric" 	required='true'>
        <cfargument name="Ccuenta" 		type="numeric" 	required="no"	 	default="-1" hint="Cuentas del Socio de Negocios">
        <cfargument name='EDfecha' 		type="date" 	required='true'>
        <cfargument name="Rcodigo" 		type="string" 	required="false" 	default="-1">

        <cfargument name='usuario' 		type="string" 	required='false' 	default='null'>
        <cfargument name='EDdocref' 	type="numeric" 	required='false' 	default='-1'>
        <cfargument name='EDfechaarribo' type="date" 	required='true'>
        <cfargument name='id_direccion' type="numeric" 	required='false' 	default="-1">
        <cfargument name='TESRPTCid' 	type="numeric" 	required='false' 	default='-1'>
        <cfargument name='Usucodigo' 	type="numeric" 	required='true'>

		<cfargument name='debug' 		type='string' 	required='false' 	default="N">
		<cfargument name="Conexion" 	type="string" 	required="false" 	hint="Nombre del DataSource">
		<cfargument name='PintaAsiento' type="boolean" 	required='false' 	default='no'>
        <cfargument name='ActivarTran'  type="boolean" 	required='true'>
        
        <cfargument name='EDAdquirir'   type="boolean" 	required='true' 	default="0">
        <cfargument name='EDexterno'  	type="boolean" 	required='true' 	default="1" hint="1-No se Podra modificar en CXP">
        <cfargument name="Ecodigo"  	type="numeric" 	required="no" 		hint="Codigo Interno de la empresa donde se caiga la Factura de CXP">
        <cfargument name="Folio"  		type="numeric" 	required="no" 		default="-1" hint="Folio">
        <cfargument name="SNidentificacion"  type="string" 	required="no" 		default="" hint="identificacion del Socio de negocio">
        <cfargument name="Miso4217"  		 type="string" 	required="no" 		default="" hint="ISO de la moneda">

        <CFIF NOT ISDEFINED('Arguments.Ecodigo') AND ISDEFINED('Session.Ecodigo')>
        	<CFSET Arguments.Ecodigo = Session.Ecodigo>
        </CFIF>
        <CFIF NOT ISDEFINED('Arguments.Conexion') AND ISDEFINED('Session.DSN')>
        	<CFSET Arguments.Conexion = Session.DSN>
        </CFIF>
        
        <!---►►Valida la empresa enviada◄◄--->
        <cfquery name="rsEmpresa" datasource="#Arguments.Conexion#">
        	select Edescripcion from Empresas where Ecodigo = #Arguments.Ecodigo#
        </cfquery>
        <cfif NOT rsEmpresa.RecordCount>
        	<cfthrow message="La empresa enviada no existe (Ecodigo = #Arguments.Ecodigo#)">
        </cfif>
        
        <!---►►Validacion de la moneda--->
        <cfif Arguments.Mcodigo EQ -1 and LEN(TRIM(Arguments.Miso4217))>
        	<cfquery name="rsMoneda" datasource="#Arguments.Conexion#">
            	select Mcodigo 
                	from Monedas 
                where Ecodigo  = #Arguments.Ecodigo# 
                  and Miso4217 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Miso4217#">
            </cfquery>
            <cfif NOT rsMoneda.Recordcount>
            	<cfthrow message="La moneda #Arguments.Miso4217# no existe en la empresa #rsEmpresa.Edescripcion#">
            <cfelse>
            	<cfset Arguments.Mcodigo = rsMoneda.Mcodigo>
            </cfif>
        <cfelseif Arguments.Mcodigo NEQ -1>
        	<cfquery name="rsMoneda" datasource="#Arguments.Conexion#">
            	select Mcodigo 
                	from Monedas 
                where Ecodigo = #Arguments.Ecodigo# 
                  and Mcodigo = #Arguments.Mcodigo#
            </cfquery>
            <cfif NOT rsMoneda.Recordcount>
            	<cfthrow message="La moneda (Mcodigo = #Arguments.Mcodigo#) no existe en la empresa #rsEmpresa.Edescripcion#">
            </cfif>
        <cfelse>
        	<cfthrow message="No se envio la moneda del Documento">
        </cfif>
        
        <!---►►Valida el Socio de Negocios◄◄--->
        <cfif Arguments.SNcodigo EQ -1 and LEN(TRIM(Arguments.SNidentificacion))>
            <cfquery name="rsSN" datasource="#Arguments.Conexion#">
                select SNidentificacion, SNnombre , SNcodigo
                    from SNegocios 
                 where Ecodigo  		= #Arguments.Ecodigo#
                   and SNidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.SNidentificacion#">
            </cfquery>
            <cfif NOT rsSN.recordCount>
                <cfthrow message="El Socio de Negocios '#Arguments.SNidentificacion#' no existe en la empresa #rsEmpresa.Edescripcion#">
            <cfelse>
                <cfset Arguments.SNcodigo = rsSN.SNcodigo>
            </cfif>
        <cfelseif Arguments.SNcodigo NEQ -1>
         	<cfquery name="rsSN" datasource="#Arguments.Conexion#">
                select SNidentificacion, SNnombre , SNcodigo
                    from SNegocios 
                 where Ecodigo  = #Arguments.Ecodigo#
                   and SNcodigo = #Arguments.SNcodigo#
            </cfquery>
            <cfif NOT rsSN.recordCount>
                <cfthrow message="El Socio de Negocios (SNcodigo = #Arguments.SNcodigo#) no existe en la empresa #rsEmpresa.Edescripcion#">
            </cfif>
        <cfelse>
        	<cfthrow message="No se envio Codigo, ni Identificacion del Socio de negocios">
        </cfif>
        
        <!---►►Valida la cuentas del Socio de Negocios◄◄--->
        <cfif Arguments.Ccuenta EQ -1>
        	<cfquery name="rsCuenta" datasource="#Arguments.Conexion#">
        		select SNcuentacxp
                     from SNegocios
                  where Ecodigo  = #Arguments.Ecodigo#
                    and SNcodigo = #Arguments.SNcodigo#
             </cfquery> 
             <cfif NOT rsCuenta.recordCount OR NOT LEN(TRIM(rsCuenta.SNcuentacxp))>                       
        		<cfthrow message="No se pudo recuperar la Cuenta por Pagar del Socio de Negocios #rsSN.SNidentificacion#-#rsSN.SNnombre# en la empresa #rsEmpresa.Edescripcion#">
        	<cfelse>
            	<cfset Arguments.Ccuenta = rsCuenta.SNcuentacxp>
            </cfif>
        </cfif>
        
        <!---►►Valida la direccion del Socio de Negocios◄◄--->
        <cfif Arguments.id_direccion EQ -1>
        	<cfquery name="rsDir" datasource="#Arguments.Conexion#">
        		select id_direccion
                	from SNegocios
                   where Ecodigo  = #Arguments.Ecodigo# 
                     and SNcodigo = #Arguments.SNcodigo#
           </cfquery>
           <cfif NOT rsDir.recordCount>
        		<cfthrow message="No se pudo recuperar la dirección del Socios de Negocios #rsSN.SNidentificacion# en la empresa #rsEmpresa.Edescripcion#">	
           <cfelse>
           		<cfset Arguments.id_direccion = rsDir.id_direccion>
           </cfif>
        </cfif>
        
        <!---►►Forma de Construcción de Cuentas S=Normal, N=Por Origen Contable◄◄--->
		<cfquery name="rsParam" datasource="#Arguments.Conexion#">
            select Pvalor
            from Parametros
            where Ecodigo =  #Arguments.Ecodigo# 
              and Pcodigo = 2
        </cfquery>
        <cfset LvarComplementoXorigen = (rsParam.Pvalor EQ 'N')>

        <cfquery name="rsExisteEncab" datasource="#Arguments.Conexion#">
            select count(1) as valor
              from EDocumentosCxP 
             where Ecodigo     =  #Arguments.Ecodigo# 
               and CPTcodigo   = <cfqueryparam cfsqltype="cf_sql_char" 	  value="#Arguments.CPTcodigo#">
               and EDdocumento = <cfqueryparam cfsqltype="cf_sql_char" 	  value="#Arguments.EDdocumento#">
               and SNcodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.SNcodigo#">				  
        </cfquery>
        <cfset existe = false>    
        <cfif rsExisteEncab.valor NEQ 0> 
            <cfset existe = true>
            <cfthrow message="El documento #EDdocumento#, con la transacción #Arguments.CPTcodigo# para el socio de negocios (SNcodigo) #Arguments.SNcodigo# de la empresa #rsEmpresa.Edescripcion# ya existe en el módulo de Cuentas por Pagar, proceso cancelado!">
        <cfelse>
            <cfquery name="rsExisteEncabEnBitacora" datasource="#Arguments.Conexion#">
                select count(1) as valor
                  from BMovimientosCxP 
                 where Ecodigo    =  #Arguments.Ecodigo# 
                   and CPTcodigo  = <cfqueryparam cfsqltype="cf_sql_char"    value="#Arguments.CPTcodigo#">	
                   and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char"    value="#Arguments.EDdocumento#">
                   and SNcodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.SNcodigo#"> 
            </cfquery>				

            <cfif rsExisteEncabEnBitacora.valor NEQ 0> 
                <cfset existe = true> <script>alert("El documento ya existe en la bitácora");</script> 
                <cfthrow message="El documento #EDdocumento#, con la transacción #Arguments.CPTcodigo# para el socio de negocios (SNcodigo) #Arguments.SNcodigo# de la empresa #rsEmpresa.Edescripcion# ya existe en la bitácora, proceso cancelado!">
            </cfif>		
        </cfif>									

            <cfif not existe>
                <cfquery name="TransaccionCP" datasource="#Arguments.Conexion#">
                    select CPTtipo 
                      from CPTransacciones 
                     where Ecodigo   = #Arguments.Ecodigo# 
                       and CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CPTcodigo#">
                </cfquery>
                <cfquery name="rsInsertEDocCP" datasource="#Arguments.Conexion#">
                    insert into EDocumentosCxP (Ecodigo, CPTcodigo, EDdocumento, SNcodigo, Mcodigo, EDtipocambio,
                                                EDdescuento, EDporcdescuento, EDimpuesto, EDtotal, Ocodigo, Ccuenta, EDfecha, 
                                                Rcodigo, EDusuario, EDselect, EDdocref, EDfechaarribo, id_direccion, TESRPTCid, BMUsucodigo,TESRPTCietu,
                                                folio,EDAdquirir,EDexterno)
                    values ( <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.Ecodigo#"> ,
                             <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.CPTcodigo#">,
                             <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.EDdocumento#">,
                             <cf_jdbcquery_param cfsqltype="cf_sql_integer" 	value="#Arguments.SNcodigo#">,
                             <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.Mcodigo#">,
                             <cf_jdbcquery_param cfsqltype="cf_sql_float" 		value="#Arguments.EDtipocambio#">,
                             <cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Arguments.EDdescuento#">,
                             0.00,
                             <cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Arguments.EDimpuesto#">,
                             <cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Arguments.EDtotal#">,
                             <cf_jdbcquery_param cfsqltype="cf_sql_integer" 	value="#Arguments.Ocodigo#">, 
                             <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Arguments.Ccuenta#">,
                             <cf_jdbcquery_param cfsqltype="cf_sql_date" 		value="#Arguments.EDfecha#">,
                             <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.Rcodigo#"   voidnull null="#Arguments.Rcodigo EQ -1#">,
                           	 <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	value="#Session.usuario#">,
                              0,
                             <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.EDdocref#" voidnull null="#Arguments.EDdocref EQ -1#">,	
						   <cfif isdefined("Arguments.EDfechaarribo") and len(trim(Arguments.EDfechaarribo))>
                             <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#Arguments.EDfechaarribo#">,
                           <cfelse>
                             <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#Arguments.EDfecha#">,  
                           </cfif>
						   <cfif isdefined("Arguments.id_direccion") and len(trim(Arguments.id_direccion))>
                              <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.id_direccion#">,
                           <cfelse>
                                null,
                           </cfif>
                         	  <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.TESRPTCid#" voidnull null="#Arguments.TESRPTCid EQ -1#">,
                          	  <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> 
                           <cfif TransaccionCP.CPTtipo EQ 'C'>,1<cfelse>,0</cfif><!--- 1=Documento Normal CR, 0=Documento Contrario DB --->		
                              ,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.Folio#" voidnull null="#Arguments.Folio EQ -1#"> 
                              ,<cf_jdbcquery_param cfsqltype="cf_sql_bit" 	  value="#Arguments.EDAdquirir#">
                              ,<cf_jdbcquery_param cfsqltype="cf_sql_bit" 	  value="#Arguments.EDexterno#">
                                )
               		 <cf_dbidentity1 datasource="#Arguments.Conexion#">
				</cfquery>
				<cf_dbidentity2 datasource="#Arguments.Conexion#" name="rsInsertEDocCP" >
            </cfif>
        <cfreturn rsInsertEDocCP.identity>
    </cffunction>
	
    <cffunction name="fnAltaDetDoc" access="public" output="yes" hint="Grabar el detalle en la tabla de trabajo">
        <cfargument name='ActivarTran'  		type="boolean" 	required='true'>
        <cfargument name='IDdocumento'  		type="numeric" 	required='true' 	default='no'>
        <cfargument name='Linea'  				type="numeric" 	required='true' 	default='no'>
        <cfargument name='Cid'  				type="numeric" 	required='false' 	default='no'> 
        <cfargument name='Alm_Aid'  			type="numeric" 	required='false' 	default='-1'> 
        <cfargument name='Dcodigo'  			type="numeric" 	required='false' 	default='-1'> 
        <cfargument name='Ccuenta'  			type="numeric" 	required='false' 	default='-1'> 
        <cfargument name='Aid'  				type="numeric" 	required='false' 	default='-1'> 
        <cfargument name='DOlinea' 	 			type="numeric" 	required='false' 	default='no'> 
        <cfargument name='CFid'  				type="numeric" 	required='false' 	default='-1'> 
        <cfargument name='DDdescripcion'		type="string" 	required='true' 	default='no'> 
        <cfargument name='DDdescalterna'  		type="string" 	required='false' 	default='no'> 
        <cfargument name='DDcantidad'  			type="numeric" 	required='true' 	default='no'> 
        <cfargument name='DDpreciou'  			type="numeric" 	required='true' 	default='no'> 
        <cfargument name='DDdesclinea'  		type="numeric" 	required='true' 	default='no'> 
        <cfargument name='DDporcdesclin'		type="numeric" 	required='true'		default='no'> 
        <cfargument name='DDtotallinea'  		type="numeric" 	required='true'> 
        <cfargument name='DDtipo'  				type="string" 	required='true' 	default='no'> 
        <cfargument name='BMUsucodigo'  		type="numeric" 	required='false' 	default='no'> 
        <cfargument name="Icodigo"  			type="string" 	required="false" 	default="" hint="Codigo del Impuesto"> 
        <cfargument name="Ucodigo"  			type="string" 	required="false" 	default="" hint="Unidad de Medida"> 
        <cfargument name='OCTtipo'  			type="string" 	required='false' 	default='-1'> 
        <cfargument name='OCTtransporte'  		type="string" 	required='false' 	default='-1'> 
        <cfargument name='OCTfechaPartida'  	type="date" 	required='false' 	default='-1'> 
        <cfargument name='OCTobservaciones' 	type="string" 	required='false' 	default='-1'> 
        <cfargument name='OCCid'  				type="numeric" 	required='false' 	default='-1'> 
        <cfargument name='OCid'  				type="numeric" 	required='false' 	default='-1'> 
        <cfargument name='DDtransito'  			type="numeric" 	required='false' 	default='0'> 
        <cfargument name='DDfembarque'  		type="date" 	required='false'> 
        <cfargument name='DDembarque'  			type="string" 	required='false' 	default='no'> 
        <cfargument name='DDobservaciones'  	type="string" 	required='false' 	default='no'> 
        <cfargument name='ContractNo'  			type="string" 	required='false' 	default='no'> 
        <cfargument name='DDimpuestoInterfaz'	type="numeric" 	required='false' 	default='no'> 
        <cfargument name='CFcuenta'  			type="numeric" 	required='false' 	default='-1'> 
        <cfargument name='PCGDid'  				type="numeric" 	required='false' 	default='no'> 
        <cfargument name='FPAEid'  				type="numeric" 	required='false' 	default='no'> 
        <cfargument name='CFComplemento'  		type="string" 	required='false' 	default='no'> 
        <cfargument name='OBOid'  				type="numeric" 	required='false' 	default='no'> 
        <cfargument name='DSespecificacuenta'	type="numeric" 	required='false' 	default='0'>
        <cfargument name="Conexion" 			type="string" 	required="no" 		hint="Nombre del DataSource">
        <cfargument name="Ecodigo" 				type="numeric" 	required="no" 		hint="Codigo Interno de la empresa">
        
        <CFIF NOT ISDEFINED('Arguments.Ecodigo') AND ISDEFINED('Session.Ecodigo')>
        	<CFSET Arguments.Ecodigo = Session.Ecodigo>
        </CFIF>
        <CFIF NOT ISDEFINED('Arguments.Conexion') AND ISDEFINED('Session.DSN')>
        	<CFSET Arguments.Conexion = Session.DSN>
        </CFIF>
        
        <!---►►Valida la empresa enviada◄◄--->
        <cfquery name="rsEmpresa" datasource="#Arguments.Conexion#">
        	select Edescripcion from Empresas where Ecodigo = #Arguments.Ecodigo#
        </cfquery>
        <cfif NOT rsEmpresa.RecordCount>
        	<cfthrow message="La empresa enviada no existe (Ecodigo = #Arguments.Ecodigo#)">
        </cfif>
        
        <!---►►Valida el Impuesto◄◄--->
        <cfif NOT LEN(TRIM(Arguments.Icodigo)) OR Arguments.Icodigo EQ -1>
        	 <cfquery name="rsImpuesto" datasource="#Arguments.Conexion#">
        	 	select min(Icodigo) as Icodigo
                	from Impuestos 
                where Iporcentaje = 0    
                   and Ecodigo    = #Arguments.Ecodigo#
            </cfquery>
            <cfif NOT rsImpuesto.recordCount>
            	<cfthrow  message="La empresa #rsEmpresa.Edescripcion# no tienen definido el Impuesto Exento">
            <cfelse>
            	<cfset Arguments.Icodigo = rsImpuesto.Icodigo>
            </cfif>
        <cfelse>
        	<cfquery name="rsImpuesto" datasource="#Arguments.Conexion#">
            		select min(Icodigo) 
                	from Impuestos 
                where Ecodigo = #Arguments.Ecodigo#
                  and Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Icodigo#">
            </cfquery>
            <cfif NOT rsImpuesto.RecordCount>
            	<cfthrow message="El codigo de Impuesto #Arguments.Icodigo# no existe en la empresa #rsEmpresa.Edescripcion#">
            </cfif>
        </cfif>
        
        <!---►►Valida la Unidad de Medida--->
        <cfif LEN(TRIM(Arguments.Ucodigo))>
        	<cfquery name="rsImpuesto" datasource="#Arguments.Conexion#">
            	select 1 
                	from Unidades 
                where Ecodigo = #Arguments.Ecodigo#
                  and Ucodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ucodigo#"> 
            </cfquery>
            <cfif NOT rsImpuesto.RecordCount>
            	<cfthrow message="La unidad #Arguments.Ucodigo# no existe en la empresa #rsEmpresa.Edescripcion#">
            </cfif>
        </cfif>
        
        <cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
        
        <!---►►Forma de Construcción de Cuentas S=Normal, N=Por Origen Contable◄◄--->
        <cfquery name="rsParam" datasource="#Arguments.Conexion#">
            select Pvalor
            from Parametros
            where Ecodigo =  #Arguments.Ecodigo# 
              and Pcodigo = 2
        </cfquery>
        <cfset LvarComplementoXorigen = (rsParam.Pvalor EQ 'N')>

        <cfset LvarAlm_Aid = "">
        <cfif find(Arguments.DDtipo, "A,T")>
            <cfset LvarAlm_Aid = Arguments.Alm_Aid>
            <cfquery name="rsConsultaDepto" datasource="#Arguments.Conexion#">
                select Dcodigo 
                	from Almacen
                 where Ecodigo = #Arguments.Ecodigo#
                   and Almcodigo in (select  Almcodigo
                                        from Almacen
                                        where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Alm_Aid#">)
            </cfquery>
        </cfif>
        
        <cfparam name="Arguments.DDtipo" default="">
        <cfif LvarComplementoXorigen>
            <!--- Cuando la cuenta no es digitada: AF = Cta Transito, sino ArmaCta Por Origenes y Complementos Financieros --->
            <cfif Arguments.DDtipo EQ "F">
                <cfquery name="rsCuentaActivo" datasource="#Arguments.Conexion#">
                    select <cf_dbfunction name="to_char" args="a.Pvalor"> as Pvalor, b.Cformato, b.Cdescripcion 
                    from Parametros a 
                    	inner join CContables b
                      		<cf_dbfunction name="to_char" args="a.Pvalor"> = <cf_dbfunction name="to_char" args="b.Ccuenta">
                    where a.Ecodigo =  #Arguments.Ecodigo# 
                      and a.Pcodigo = 240
                </cfquery>
                <cfset cuentaDetalle = rsCuentaActivo.Pvalor>
                <cfset cuentaFDetalle = "">
            <cfelse>
            	<cfthrow message="No implementado obtencion de cta. transito,con Construcción de Cuentas por Complemento Financiero del Origen Contable Activado">
                <cfif isdefined('Arguments.Cid') and LEN(TRIM(Arguments.Cid))>
                    <cfquery name="rsCCid" datasource="#Arguments.Conexion#">
                        select CCid
                        from Conceptos
                        where Cid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Cid#">
                    </cfquery>
                    <cfset Cconcepto = rsCCid.CCid>
                <cfelse>
                    <cfset Cconcepto = "">
                </cfif>

                <cfinvoke component="sif.Componentes.CG_Complementos" method="TraeCuenta" returnvariable="Cuentas">
                    <cfinvokeargument name="Oorigen" 			value="CPFC">
                    <cfinvokeargument name="Ecodigo" 			value="#Arguments.Ecodigo#">
                    <cfinvokeargument name="Conexion" 			value="#Arguments.Conexion#">
                    <cfinvokeargument name="Oficinas" 			value="#Arguments.Ocodigo#">
                    <cfinvokeargument name="SNegocios" 			value="#Arguments.SNcodigo#">
                    <cfinvokeargument name="CPTransacciones" 	value="#Arguments.CPTcodigo#">
                    <cfinvokeargument name="Articulos" 			value="#Arguments.Aid#">
                    <cfinvokeargument name="Almacen" 			value="#Arguments.Almacen#">
                    <cfinvokeargument name="Conceptos" 			value="#Arguments.Cid#">
                    <cfinvokeargument name="CFuncional" 		value="#Arguments.CFid#">
                    <cfinvokeargument name="Monedas" 			value="Arguments.Mcodigo">
                    <cfinvokeargument name="Clasificaciones" 	value="">
                    <cfinvokeargument name="CConceptos" 		value="#Cconcepto#"> 
               </cfinvoke>
                <cfset cuentaDetalle = Cuentas.Ccuenta>
                <cfset cuentaFDetalle = Cuentas.CFcuenta>
            </cfif>
        <cfelse>
            <cfset cuentaDetalle = Arguments.Ccuenta>
            <cfset cuentaFDetalle = ''>
        </cfif>
		
            <cfquery name="rsInsertDDocCP" datasource="#Arguments.Conexion#">
                insert into DDocumentosCxP 
                    (	IDdocumento,
                        Aid,
                        Cid,
                        DDdescripcion,
                        DDdescalterna,
                        CFid,
                        Alm_Aid,  
                        Dcodigo,
                        DDcantidad,
                        DDpreciou, 
                        DDdesclinea,
                        DDporcdesclin, 
                        DDtotallinea, 
                        DDtipo, 
                        Ccuenta,
                        CFcuenta,
                        Ecodigo, 
                        OCTtipo,
                        OCTtransporte,
                        OCTfechaPartida,
                        OCTobservaciones,
                        OCCid,
                        OCid,						
                        Icodigo,
                        BMUsucodigo,
                        DSespecificacuenta )
                        <!---Aca Agregar la Actividad Empresarial y el Complemento--->
                values	 (
                    <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.IDdocumento#">,
                    <cfif  isDefined("Arguments.DDtipo") and  Arguments.DDtipo eq 'A'>
                        <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.Aid#" voidNull null="#Arguments.Aid EQ -1#">,
                    <cfelseif isDefined("Arguments.DDtipo") and  Arguments.DDtipo eq 'T'>
                        <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.AidT#" voidNull null="#Arguments.AidT EQ -1#">,
                    <cfelseif isDefined("Arguments.DDtipo") and  Arguments.DDtipo eq 'O'>
                        <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.AidOD#" voidNull null="#Arguments.AidOD EQ -1#">,
                    <cfelse>
                        <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
                    </cfif>
                    <cfif  isDefined("Arguments.DDtipo") and  Arguments.DDtipo eq 'S' and Arguments.Cid NEQ '-1'>
                        <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.Cid#">,
                    <cfelse>	
                        <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">, 
                    </cfif>				
                    <CF_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.DDdescripcion#">,
                    <CF_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.DDdescalterna#">,
                   
                    <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.CFid#" null="#Arguments.CFid EQ -1#">,
                   	
    
                    <cfif LvarAlm_Aid NEQ "">
                        <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarAlm_Aid#" voidNull null="#LvarAlm_Aid EQ -1#">,
                        <CF_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsConsultaDepto.Dcodigo#" voidNull null="#rsConsultaDepto.Dcodigo EQ -1#">,
                    <cfelse>
                        <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">, 	
                        <CF_jdbcquery_param cfsqltype="cf_sql_integer" value="null">,
                    </cfif>
                    
                    <CF_jdbcquery_param cfsqltype="cf_sql_float" value="#Arguments.DDcantidad#">,
                    #ABS(LvarOBJ_PrecioU.enCF(Arguments.DDpreciou))#,
                    <CF_jdbcquery_param cfsqltype="cf_sql_money" value="#Arguments.DDdesclinea#">,
                    <CF_jdbcquery_param cfsqltype="cf_sql_float" value="#Arguments.DDporcdesclin#">,
                    <CF_jdbcquery_param cfsqltype="cf_sql_money" value="#numberFormat(ABS(Arguments.DDtotallinea),"9.00")#">,
                    <CF_jdbcquery_param cfsqltype="cf_sql_char" value="#Arguments.DDtipo#">,
                    
                    <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="#cuentaDetalle#" voidnull null="#cuentaDetalle EQ -1#">,
                   
                    <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="#cuentaFDetalle#" voidnull null="#cuentaFDetalle EQ -1#">,
                    <cfif isdefined('Arguments.Ecodigo_CcuentaD') and Arguments.Ecodigo_CcuentaD neq -1>
                        #Arguments.Ecodigo_CcuentaD#,
                    <cfelse>    
                        #Arguments.Ecodigo# ,
                    </cfif>    
                    <cfif  isDefined("Arguments.DDtipo") and (Arguments.DDtipo eq 'T' or Arguments.DDtipo eq 'O')>
                        <CF_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.OCTtipo#">,
                    <cfelse>	
                        <CF_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">,
                    </cfif>
                    <cfif  isDefined("Arguments.DDtipo") and (Arguments.DDtipo eq 'T' or Arguments.DDtipo eq 'O')>
                        <CF_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.OCTtransporte#">,
                    <cfelse>
                        <CF_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">,
                    </cfif>
                    <cfif  isDefined("Arguments.DDtipo") and (Arguments.DDtipo eq 'T' or Arguments.DDtipo eq 'O') and (Arguments.OCTfechaPartida) NEQ '-1'>
                        <CF_jdbcquery_param cfsqltype="cf_sql_date" value="#LSDateFormat(Arguments.OCTfechaPartida,'YYYY/MM/DD')#">,
                    <cfelse><CF_jdbcquery_param cfsqltype="cf_sql_timestamp" value="null">,</cfif>
                    <cfif  isDefined("Arguments.DDtipo") and (Arguments.DDtipo eq 'T' or Arguments.DDtipo eq 'O')>
                        <CF_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Arguments.OCTobservaciones#">,
                    <cfelse><CF_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">,
                    </cfif>
                    <cfif  isDefined("Arguments.DDtipo") and  Arguments.DDtipo eq 'O'>
                        <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.OCCid#">,
                    <cfelse><CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
                    </cfif>
                    <cfif  isDefined("Arguments.DDtipo") and  Arguments.DDtipo eq 'O'>
                        <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.OCid#">,
                    <cfelse>
                        <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
                    </cfif>
                        <CF_jdbcquery_param cfsqltype="cf_sql_char" value="#Arguments.Icodigo#">,
                    <cfif isDefined("session.Usucodigo") and Len(Trim(session.Usucodigo)) GT 0 > 
                        <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                    <cfelse>
                        <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
                    </cfif>
                    <cfif isDefined("Arguments.chkEspecificarcuenta") and  len(trim(Arguments.chkEspecificarcuenta)) gt 0>
                        1
                    <cfelse>
                        0
                    </cfif>
                ) 		
            </cfquery>
            
            <!--- PROCESO DE ACTUALIZACION DEL TOTAL DEL DOCUMENTO Y TOTAL DE IMPUESTOS --->
            <cfquery name="rsSQL" datasource="#Arguments.Conexion#">
                select  a.EDdescuento,
                        coalesce(
                            (
                                select sum(DDtotallinea)
                                  from DDocumentosCxP
                                 where IDdocumento = a.IDdocumento
                            ) 
                        ,0.00) as SubTotal
                  from EDocumentosCxP a
                 where a.IDdocumento	= #Arguments.IDdocumento#
            </cfquery>

			<cfif rsSQL.EDdescuento GT rsSQL.Subtotal>
                <cfquery datasource="#Arguments.Conexion#">
                    update EDocumentosCxP
                       set EDdescuento = 0
                   where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDdocumento#">
                </cfquery>
			</cfif>
            
			<!--- CALCULO DEL TOTAL DE IMPUESTO y Descuento a nivel de documento POR LINEA DEL DOCUMENTO --->
			<!---ACTUALIZA EL ENCABEZADO DEL DOCUMENTO CON LOS TOTALES --->
			<!--- DDtotallin	= precio * cantidad - DDdesclinea --->
			<!--- EDtotal		= sum(DDtotallin) + Impuestos - EDdescuento --->
            <!--- <cfinvoke component="sif.Componentes.CP_PosteoDocumentosCxP" method="CP_CalcularDocumento">
             	<cfinvokeargument name="IDdoc" 				value="#Arguments.IDdocumento#">
                <cfinvokeargument name="CalcularImpuestos" 	value="true">
                <cfinvokeargument name="Ecodigo" 			value="#Arguments.Ecodigo#">
                <cfinvokeargument name="conexion" 			value="#Arguments.Conexion#">
           </cfinvoke>  --->
	</cffunction>
    
	<cffunction name="fnAplicarDoc" access="public" output="yes" hint="Aplica el Documento de Cuentas Por Pagar">
		<cfargument name="IDdocumento" 	type="numeric" 	required="yes"		hint="Id del Documento a Aplicar">
        <cfargument name="Conexion" 	type="string" 	required="no"	 	hint="Nombre del DataSource">
        <cfargument name='ActivarTran'  type="boolean" 	required='false'>
        <cfargument name="Ecodigo" 		type="numeric" 	required="no" 		hint="Codigo Interno de la empresa">
        
        <CFIF NOT ISDEFINED('Arguments.Ecodigo') AND ISDEFINED('Session.Ecodigo')>
        	<CFSET Arguments.Ecodigo = Session.Ecodigo>
        </CFIF>
        <CFIF NOT ISDEFINED('Arguments.Conexion') AND ISDEFINED('Session.DSN')>
        	<CFSET Arguments.Conexion = Session.DSN>
        </CFIF>
        
        <cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
        <cfif isdefined("Arguments.IDdocumento") and len(trim(Arguments.IDdocumento))>
            <cfparam name="Arguments.chk" default="#Arguments.IDdocumento#">
        </cfif>
        <cfif isDefined("Arguments.chk")>
            <cfset chequeados = ListToArray(Arguments.chk)>
            <cfset cuantos    = ArrayLen(chequeados)>
    
            <!--- mismo doc.recurrente en varias facturas --->
            <cfquery name="parametroRec" datasource="#Arguments.Conexion#">
                select coalesce(Pvalor, '1') as Pvalor
                 from Parametros
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                  and Pcodigo = 880
            </cfquery>
    
            <!--- mes auxiliar --->
            <cfquery name="mes" datasource="#Arguments.Conexion#">
                select Pvalor
                 from Parametros
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                  and Pcodigo = 60
            </cfquery>
            <!--- periodo auxiliar --->
            <cfquery name="periodo" datasource="#Arguments.Conexion#">
                select Pvalor
                 from Parametros
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                  and Pcodigo = 50
            </cfquery>
            <cfif len(trim(mes.pvalor)) and len(trim(periodo.pvalor))>
                <cfset fecha = createdate(periodo.pvalor, mes.pvalor , 1) >
                <cfset fechaaplic = createdate( periodo.pvalor, mes.pvalor, DaysInMonth(fecha) ) >
            </cfif>	
    
            <cfloop index="CountVar" from="1" to="#cuantos#">
                <cfset valores = ListToArray(chequeados[CountVar],"|")>
                
                <!--- Valida las garantias, si la factura lo requiere--->
                <cfinvoke component="sif.Componentes.garantia" method="fnProcesarGarantias" returnvariable="LvarAccion"
                    Ecodigo	= "#Arguments.Ecodigo#"
                    tipo 	= "C"
                    ID		= "#valores[1]#"
                />
                <cfif parametroRec.Pvalor neq 0>
                    <cfquery name="recurrente" datasource="#Arguments.Conexion#">
                        select IDdocumentorec
                        from EDocumentosCxP
                        where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#valores[1]#">			  
                    </cfquery>
                    <cfif len(trim(recurrente.IDdocumentorec))>
                        <cfquery name="rsFechaUltima" datasource="#Arguments.Conexion#">
                            select HEDfechaultaplic
                            from HEDocumentosCP
                            where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#recurrente.IDdocumentorec#">			  
                        </cfquery>
                        <cfif len(trim(rsFechaUltima.HEDfechaultaplic)) and datecompare(fechaaplic, rsFechaUltima.HEDfechaultaplic) lte 0>
                            <cfset request.Error.backs = 1 >
                            <cf_errorCode	code = "50344"
                                msg  = "El documento no puede ser aplicado, pues ya existe un documento aplicado con el mismo documento recurrente para el mes @errorDat_1@ y período @errorDat_2@."
                                errorDat_1="#month(fechaaplic)#"
                                errorDat_2="#year(fechaaplic)#"
                            >
                        </cfif>
                    </cfif>
                </cfif>

                <!---►►Realiza la Aplicación de la factura◄◄--->
                <cfinvoke component="sif.Componentes.CP_PosteoDocumentosCxP" method="PosteoDocumento">
                	<cfinvokeargument name="IDdoc" 				 value="#valores[1]#">
                    <cfinvokeargument name="Ecodigo" 			 value="#Arguments.Ecodigo#">
                    <cfinvokeargument name="usuario" 			 value="#Session.usuario#">
                    <cfinvokeargument name="debug" 			   	 value="N">
                    <cfinvokeargument name="USA_tran" 			 value="FALSE">
                    <cfinvokeargument name="EntradasEnRecepcion" value="true">
                </cfinvoke>

                <!--- modifica la ultima fecha de aplicacion --->
                <cfif parametroRec.Pvalor neq 0>
                    <cfif len(trim(recurrente.IDdocumentorec))>
                        <cfif isdefined("fechaaplic")>
                            <cfquery datasource="#Arguments.Conexion#">
                                update HEDocumentosCP
                                set HEDfechaultaplic = <cfqueryparam cfsqltype="cf_sql_date" value="#fechaaplic#">
                                where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#recurrente.IDdocumentorec#">			  
                            </cfquery>
                        </cfif>
                    </cfif>
                </cfif>
            </cfloop>
        </cfif>
	</cffunction>
    
    <cffunction name="fnGenerarPolizasParciales" access="public" output="yes" hint="Copiar la poliza padre en 1 hija" returntype="numeric">
		<cfargument name="formulario" 	type="struct">
        <cfargument name="Conexion" 	type="string" 	required="no" hint="Nombre del DataSource">
        <cfargument name='ActivarTran'  type="boolean" 	required='false'>
        <cfargument name='debug'  		type="boolean" 	required='false'>
        <cfargument name='Ecodigo'  	type="numeric" 	required='false'>
        
        <CFIF NOT ISDEFINED('Arguments.Conexion') AND ISDEFINED('Session.DSN')>
        	<CFSET Arguments.Conexion = Session.DSN>
        </CFIF>
        <CFIF NOT ISDEFINED('Arguments.Ecodigo') AND ISDEFINED('Session.Ecodigo')>
        	<CFSET Arguments.Ecodigo = Session.Ecodigo>
        </CFIF>
       
        <!--- Genera un consecutivo para la póliza desalmacenaje parcial --->
        <!--- Todos los EPDidpadre se crearon con null, solo se guarda el EPDidpadre cuando se crea una poliza desalmacenaje parcial (hija) --->
        <cfquery name="rsConsecutivo" datasource="#Arguments.Conexion#">
        	select count(1) as cantidad
             from EPolizaDesalmacenaje
            where EPDidpadre = #Arguments.formulario.EPDid#
        </cfquery>
        <cfif rsConsecutivo.cantidad eq 0>
        	<cfset LvarConsecutivo = 1>
        <cfelse>
        	<cfset LvarConsecutivo = rsConsecutivo.cantidad + 1>
        </cfif>
        
        <cf_dbfunction name="sPart" args="rtrim(EPDnumero),1,17" returnvariable="corte_var"><!--- solamente puede hacer 999 desalmacenajes parciales pues si el consecutivo llega a 1000 va dar error pues el campo es de 20 caracteres --->
        <cf_dbfunction name="concat" args="#corte_var#*'_'*'#LvarConsecutivo#'" returnvariable="concatena_var" delimiters="*">
        <cf_dbfunction name="length" args="rtrim(EPDnumero)" returnvariable="longitud_var">
        
        <cfquery name="rsInsEPolizaDesalmacenajeHija" datasource="#Arguments.conexion#">
        	insert into EPolizaDesalmacenaje (
                CMAAid, 
                Ecodigo, 
                EPDnumero, 
                SNcodigo, 
                CMAid, 
                CMSid, 
                Mcodigoref, 
                EPDtcref, 
                EPDfecha, 
                EPDdescripcion, 
                EPDpaisori, 
                EPDpaisproc, 
                EPDtotbultos, 
                EPDpesobruto, 
                EPDpesoneto, 
                EPDobservaciones, 
                Usucodigo, 
                fechaalta, 
                EPDestado, 
                EPembarque, 
                BMUsucodigo, 
                EPDFOBDecAduana, 
                EPDFletesDecAduana, 
                EPDSegurosDecAduana, 
                EPDGastosDecAduana, 
                PermiteDesParcial,
                EPDidpadre 
            )
            select 
            	CMAAid, 
                Ecodigo, 
                #preservesinglequotes(concatena_var)#,
                SNcodigo, 
                CMAid, 
                CMSid, 
                Mcodigoref, 
                EPDtcref, 
                EPDfecha, 
                EPDdescripcion, 
                EPDpaisori, 
                EPDpaisproc, 
                EPDtotbultos, 
                EPDpesobruto, 
                EPDpesoneto, 
                EPDobservaciones, 
                Usucodigo, 
                fechaalta, 
                EPDestado, 
                EPembarque, 
                BMUsucodigo, 
                EPDFOBDecAduana, 
                EPDFletesDecAduana, 
                EPDSegurosDecAduana, 
                EPDGastosDecAduana, 
                0, <!--- No se puede hacer desalmacenajes parciales de una póliza hija --->
                EPDid
            from EPolizaDesalmacenaje
            where EPDid = #Arguments.formulario.EPDid#
            <cf_dbidentity1 datasource="#Arguments.Conexion#">
        </cfquery>
        <cf_dbidentity2 datasource="#Arguments.Conexion#" name="rsInsEPolizaDesalmacenajeHija">
        
        <cfquery datasource="#Arguments.conexion#">
        	insert into DPolizaDesalmacenaje (
                EPDid, 
                DOlinea, 
                DDlinea, 
                Ecodigo, 
                CMtipo, 
                Cid, 
                Aid, 
                Alm_Aid, 
                ACcodigo, 
                ACid, 
                CAid, 
                Icodigo, 
                Ucodigo, 
                CMSid, 
                DPDpaisori, 
                DPDcantidad, 
                DPDpeso, 
                DPDmontofobreal, 
                DPDmontocifreal, 
                DPDimpuestosreal, 
                DPDsegurosreal, 
                DPDfletesreal, 
                DPDaduanalesreal, 
                DPDmontofobest, 
                DPDmontocifest, 
                DPDimpuestosest, 
                DPDsegurosest, 
                DPDfletesest, 
                DPDaduanalesest, 
                DPDvalordeclarado, 
                Usucodigo,
                fechaalta, 
                DPDdescripcion, 
                DPDcostoudescoc, 
                DPcostodec, 
                DPsegurodec, 
                DPfeltedec, 
                DPseguropropio, 
                DPDcantreclamo, 
                DPDobsreclamo, 
                DPDporcimpCApoliza, 
                DPDporcimpCAarticulo, 
                Icodigoarticulo, 
                CAidarticulo, 
                DPDfletesprorrat, 
                DPDsegurosprorrat, 
                DPDimpuestosrecup,
                
                DPDfletesrealRCPar,
                DPDsegurosrealRCPar,
                DPDaduanalesrealRCPar
                
            )
            select 
            	#rsInsEPolizaDesalmacenajeHija.identity#, 
                DOlinea, 
                DDlinea, 
                Ecodigo, 
                CMtipo, 
                Cid, 
                Aid, 
                Alm_Aid, 
                ACcodigo, 
                ACid, 
                CAid, 
                Icodigo, 
                Ucodigo, 
                CMSid, 
                DPDpaisori, 
                DPDcantidad, 
                DPDpeso, 
                DPDmontofobreal, 
                DPDmontocifreal, 
                DPDimpuestosreal, 
                DPDsegurosreal, 
                DPDfletesreal, 
                DPDaduanalesreal, 
                DPDmontofobest, 
                DPDmontocifest, 
                DPDimpuestosest, 
                DPDsegurosest, 
                DPDfletesest, 
                DPDaduanalesest, 
                DPDvalordeclarado, 
                #session.Usucodigo#, 
                <cf_dbfunction name="now">, 
                DPDdescripcion, 
                DPDcostoudescoc, 
                DPcostodec, 
                DPsegurodec, 
                DPfeltedec, 
                DPseguropropio, 
                DPDcantreclamo, 
                DPDobsreclamo, 
                DPDporcimpCApoliza, 
                DPDporcimpCAarticulo, 
                Icodigoarticulo, 
                CAidarticulo, 
                DPDfletesprorrat, 
                DPDsegurosprorrat, 
                DPDimpuestosrecup,
                
                DPDfletesreal,
                DPDsegurosreal,
                DPDaduanalesreal
            from DPolizaDesalmacenaje
            where EPDid = #Arguments.formulario.EPDid#
        </cfquery>
        
        <!--- Actualiza las candidades de la nueva póliza hija --->
        <cfloop collection="#Arguments.formulario#" item="e">
			<cfif FindNoCase("DPDcantidad_", e) NEQ 0>
                <cfset linea2 = Mid(e, 13, Len(e))>
                <cfif NOT LEN(TRIM(Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))))>
                	<cfthrow message="No se digitaron Correctamente las cantidades de la nueva poliza">
                </cfif>
                <cfloop list="#linea2#" delimiters="_" index="o">                    
                    <!--- Busca los datos del padre para la línea que se le va a cambiar la cantidad. Solo debe encontrar un registro --->
                    <cfquery name="rsDatosPadre" datasource="#Arguments.Conexion#">
                        select
                            DPDcantidad, 
                            DPDpeso,
                            DPDmontofobreal, 
                            DPDmontocifreal, 
                            DPDimpuestosreal, 
                            DPDsegurosreal, 
                            DPDfletesreal, 
                            DPDaduanalesreal, 
                            DPDmontofobest, 
                            DPDmontocifest, 
                            DPDimpuestosest, 
                            DPDsegurosest, 
                            DPDfletesest, 
                            DPDaduanalesest, 
                            DPDvalordeclarado, 
                            DPDcostoudescoc, 
                            DPcostodec, 
                            DPsegurodec, 
                            DPfeltedec, 
                            DPseguropropio, 
                            coalesce(DPDcantreclamo,0) 		 as DPDcantreclamo, 
                            coalesce(DPDporcimpCApoliza,0) 	 as DPDporcimpCApoliza, 
                            coalesce(DPDporcimpCAarticulo,0) as DPDporcimpCAarticulo, 
                            Coalesce(DPDfletesprorrat,0) 	 as DPDfletesprorrat, 
                            Coalesce(DPDsegurosprorrat,0) 	 as DPDsegurosprorrat, 
                            Coalesce(DPDimpuestosrecup,0) 	 as DPDimpuestosrecup
                        from DPolizaDesalmacenaje
                        where EPDid = #Arguments.formulario.EPDid#
                        and DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#o#">
                    </cfquery>
                    
                    <cfif rsDatosPadre.recordcount eq 0>
                        <cfthrow message="No se encontró el registro de la póliza padre, no se puede actualizar la póliza hija. Póngase en contacto con sus compañeros de soporte.">
                    </cfif>

					<!---►►Si la poliza Hija o la padre no tienen cantidad, se elimina la linea de la hija◄◄--->
                    <cfif Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2)) EQ 0 OR rsDatosPadre.DPDcantidad EQ 0>
                    	<cfquery datasource="#Arguments.Conexion#">
                        	delete DPolizaDesalmacenaje 
                            where EPDid   = #rsInsEPolizaDesalmacenajeHija.identity#
                        	  and DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#o#">
                        </cfquery>
                    <cfelse>
                     <!---►►Si tienen Cantidad la poliza padre y la hijas, se aplica Regla de 3 para la poliza hija: ((Cantidad Nueva * Monto Viejo) / Cantidad Vieja) = Monto Nuevo◄◄--->
                     <cfquery datasource="#Arguments.Conexion#">
                        update DPolizaDesalmacenaje 
                        set
                            DPDcantidad = 			<cf_jdbcquery_param cfsqltype="cf_sql_float" value="#Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))#">, 
                            DPDmontofobreal = 		((#Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))# * #rsDatosPadre.DPDmontofobreal#) / #rsDatosPadre.DPDcantidad#), 
                            DPDmontocifreal = 		((#Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))# * #rsDatosPadre.DPDmontocifreal#) / #rsDatosPadre.DPDcantidad#), 
                            
                            <!---►►Impuesto Real◄◄--->
                            DPDimpuestosreal = 		((#Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))# * #rsDatosPadre.DPDimpuestosreal#) / #rsDatosPadre.DPDcantidad#), 
                            DPDimpuestosrealRCPar = ((#Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))# * #rsDatosPadre.DPDimpuestosreal#) / #rsDatosPadre.DPDcantidad#), 
                            
                            <!---►►Impuesto Recuperable◄◄--->
							DPDimpuestosrecup  =  	((#Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))# * #rsDatosPadre.DPDimpuestosrecup#) / #rsDatosPadre.DPDcantidad#),
                            DPDimpuestosrecupRCPar= ((#Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))# * #rsDatosPadre.DPDimpuestosrecup#) / #rsDatosPadre.DPDcantidad#),
                             
							<!---►►Seguros Internos◄◄--->
                            DPDsegurosreal = 		((#Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))# * #rsDatosPadre.DPDsegurosreal#) / #rsDatosPadre.DPDcantidad#), 
                            DPDsegurosrealRCPar=    ((#Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))# * #rsDatosPadre.DPDsegurosreal#) / #rsDatosPadre.DPDcantidad#), 
                            
							<!---►►Fletes Internos◄◄--->
                            DPDfletesreal = 		((#Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))# * #rsDatosPadre.DPDfletesreal#) / #rsDatosPadre.DPDcantidad#), 
                            DPDfletesrealRCPar = 	((#Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))# * #rsDatosPadre.DPDfletesreal#) / #rsDatosPadre.DPDcantidad#), 
                            
                            <!---►►Gastos Internos◄◄--->
                            DPDaduanalesreal = 		((#Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))# * #rsDatosPadre.DPDaduanalesreal#) / #rsDatosPadre.DPDcantidad#), 
                            DPDaduanalesrealRCPar=  ((#Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))# * #rsDatosPadre.DPDaduanalesreal#) / #rsDatosPadre.DPDcantidad#), 
                            
                            DPDmontofobest = 		((#Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))# * #rsDatosPadre.DPDmontofobest#) / #rsDatosPadre.DPDcantidad#), 
                            DPDmontocifest = 		((#Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))# * #rsDatosPadre.DPDmontocifest#) / #rsDatosPadre.DPDcantidad#), 
                            DPDimpuestosest = 		((#Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))# * #rsDatosPadre.DPDimpuestosest#) / #rsDatosPadre.DPDcantidad#), 
                            DPDsegurosest = 		((#Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))# * #rsDatosPadre.DPDsegurosest#) / #rsDatosPadre.DPDcantidad#), 
                            DPDfletesest = 			((#Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))# * #rsDatosPadre.DPDfletesest#) / #rsDatosPadre.DPDcantidad#), 
                            DPDaduanalesest = 		((#Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))# * #rsDatosPadre.DPDaduanalesest#) / #rsDatosPadre.DPDcantidad#), 
                            DPDvalordeclarado = 	((#Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))# * #rsDatosPadre.DPDvalordeclarado#) / #rsDatosPadre.DPDcantidad#), 
                            DPDcostoudescoc = 		((#Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))# * #rsDatosPadre.DPDcostoudescoc#) / #rsDatosPadre.DPDcantidad#), 
                            DPcostodec = 			((#Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))# * #rsDatosPadre.DPcostodec#) / #rsDatosPadre.DPDcantidad#), 
                            DPsegurodec = 			((#Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))# * #rsDatosPadre.DPsegurodec#) / #rsDatosPadre.DPDcantidad#), 
                            DPfeltedec = 			((#Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))# * #rsDatosPadre.DPfeltedec#) / #rsDatosPadre.DPDcantidad#), 
                            DPseguropropio = 		((#Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))# * #rsDatosPadre.DPseguropropio#) / #rsDatosPadre.DPDcantidad#), 
                            DPDcantreclamo = 		((#Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))# * #rsDatosPadre.DPDcantreclamo#) / #rsDatosPadre.DPDcantidad#), 
                            DPDporcimpCApoliza = 	((#Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))# * #rsDatosPadre.DPDporcimpCApoliza#) / #rsDatosPadre.DPDcantidad#), 
                            DPDporcimpCAarticulo = 	((#Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))# * #rsDatosPadre.DPDporcimpCAarticulo#) / #rsDatosPadre.DPDcantidad#), 
                            DPDfletesprorrat = 		((#Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))# * #rsDatosPadre.DPDfletesprorrat#) / #rsDatosPadre.DPDcantidad#), 
                            DPDsegurosprorrat = 	((#Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))# * #rsDatosPadre.DPDsegurosprorrat#) / #rsDatosPadre.DPDcantidad#)
                           
                        where EPDid = #rsInsEPolizaDesalmacenajeHija.identity#
                        and DOlinea = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#o#">
                    </cfquery>

                    <!--- Regla de 3 para la póliza padre: ((Cantidad Nueva * Monto Viejo) / Cantidad Vieja) = Monto Nuevo --->
                     <cfquery datasource="#Arguments.Conexion#">
                        update DPolizaDesalmacenaje 
                        set
                            DPDcantidad = 			DPDcantidad - #Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))#, 
                            DPDmontofobreal = 		(((DPDcantidad - #Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))#) * #rsDatosPadre.DPDmontofobreal#) / #rsDatosPadre.DPDcantidad#), 
                            DPDmontocifreal = 		(((DPDcantidad - #Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))#) * #rsDatosPadre.DPDmontocifreal#) / #rsDatosPadre.DPDcantidad#), 
                            DPDimpuestosreal = 		(((DPDcantidad - #Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))#) * #rsDatosPadre.DPDimpuestosreal#) / #rsDatosPadre.DPDcantidad#), 
                            DPDsegurosreal = 		(((DPDcantidad - #Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))#) * #rsDatosPadre.DPDsegurosreal#) / #rsDatosPadre.DPDcantidad#), 
                            DPDfletesreal = 		(((DPDcantidad - #Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))#) * #rsDatosPadre.DPDfletesreal#) / #rsDatosPadre.DPDcantidad#), 
                            DPDaduanalesreal = 		(((DPDcantidad - #Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))#) * #rsDatosPadre.DPDaduanalesreal#) / #rsDatosPadre.DPDcantidad#), 
                            DPDmontofobest = 		(((DPDcantidad - #Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))#) * #rsDatosPadre.DPDmontofobest#) / #rsDatosPadre.DPDcantidad#), 
                            DPDmontocifest = 		(((DPDcantidad - #Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))#) * #rsDatosPadre.DPDmontocifest#) / #rsDatosPadre.DPDcantidad#), 
                            DPDimpuestosest = 		(((DPDcantidad - #Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))#) * #rsDatosPadre.DPDimpuestosest#) / #rsDatosPadre.DPDcantidad#), 
                            DPDsegurosest = 		(((DPDcantidad - #Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))#) * #rsDatosPadre.DPDsegurosest#) / #rsDatosPadre.DPDcantidad#), 
                            DPDfletesest = 			(((DPDcantidad - #Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))#) * #rsDatosPadre.DPDfletesest#) / #rsDatosPadre.DPDcantidad#), 
                            DPDaduanalesest = 		(((DPDcantidad - #Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))#) * #rsDatosPadre.DPDaduanalesest#) / #rsDatosPadre.DPDcantidad#), 
                            DPDvalordeclarado = 	(((DPDcantidad - #Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))#) * #rsDatosPadre.DPDvalordeclarado#) / #rsDatosPadre.DPDcantidad#), 
                            DPDcostoudescoc = 		(((DPDcantidad - #Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))#) * #rsDatosPadre.DPDcostoudescoc#) / #rsDatosPadre.DPDcantidad#), 
                            DPcostodec = 			(((DPDcantidad - #Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))#) * #rsDatosPadre.DPcostodec#) / #rsDatosPadre.DPDcantidad#), 
                            DPsegurodec = 			(((DPDcantidad - #Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))#) * #rsDatosPadre.DPsegurodec#) / #rsDatosPadre.DPDcantidad#), 
                            DPfeltedec = 			(((DPDcantidad - #Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))#) * #rsDatosPadre.DPfeltedec#) / #rsDatosPadre.DPDcantidad#), 
                            DPseguropropio = 		(((DPDcantidad - #Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))#) * #rsDatosPadre.DPseguropropio#) / #rsDatosPadre.DPDcantidad#), 
                            DPDcantreclamo = 		(((DPDcantidad - #Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))#) * #rsDatosPadre.DPDcantreclamo#) / #rsDatosPadre.DPDcantidad#), 
                            DPDporcimpCApoliza = 	(((DPDcantidad - #Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))#) * #rsDatosPadre.DPDporcimpCApoliza#) / #rsDatosPadre.DPDcantidad#), 
                            DPDporcimpCAarticulo = 	(((DPDcantidad - #Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))#) * #rsDatosPadre.DPDporcimpCAarticulo#) / #rsDatosPadre.DPDcantidad#), 
                            DPDfletesprorrat = 		(((DPDcantidad - #Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))#) * #rsDatosPadre.DPDfletesprorrat#) / #rsDatosPadre.DPDcantidad#), 
                            DPDsegurosprorrat = 	(((DPDcantidad - #Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))#) * #rsDatosPadre.DPDsegurosprorrat#) / #rsDatosPadre.DPDcantidad#), 
                            DPDimpuestosrecup  =  	(((DPDcantidad - #Evaluate('Arguments.formulario.DPDcantidad_'&trim(linea2))#) * #rsDatosPadre.DPDimpuestosrecup#) / #rsDatosPadre.DPDcantidad#)
                        where EPDid = #Arguments.formulario.EPDid#
                        and DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#o#">
                    </cfquery>
                </cfif>
                </cfloop>
            </cfif>
        </cfloop>
        
        <!--- Si todas las lineas ya fueron utilizadas entonces cierra la póliza padre--->
        <cfquery name="rsVerificaPoliza" datasource="#Arguments.Conexion#">
            select sum(DPDcantidad) as DPDcantidad
             from DPolizaDesalmacenaje
            where EPDid = #Arguments.formulario.EPDid# 
        </cfquery>
        <cfif rsVerificaPoliza.DPDcantidad eq 0>
        	<cfquery datasource="#Arguments.Conexion#">
                UPDATE EPolizaDesalmacenaje
                 SET EPDestado = 10
                WHERE EPDid = #Arguments.formulario.EPDid#
            </cfquery>
        </cfif>
        <cfreturn 1>
    </cffunction>
    
</cfcomponent>