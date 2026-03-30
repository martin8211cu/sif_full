<cfcomponent>
	<!--- Variables Globales --->
	<cfset GvarConexion   = Session.Dsn>
	<cfset GvarEcodigo    = Session.Ecodigo>	
	<cfset GvarUsuario    = Session.Usuario>
	<cfset GvarUsucodigo  = Session.Usucodigo>
	<cfset GvarEnombre    = Session.Enombre>
	<cfset GvarMinFecha   = DateAdd('yyyy',-50,Now())>
	<cfset GvarLinea      = 1>

    <cffunction name="process" access="public" output="no">
	 	<!--- Argumentos --->
		<cfargument name="query"       required="yes" type="query">
		<cfargument name="TransActiva" required="no"  type="boolean" default="false">
        <cfargument name="comVol"      required="no"  type="boolean" default="false">
        <cfargument name="interfaz"    required="no"  type="boolean" default="true" hint="Para saber si es interfaz o sistema, en caso de sistema no debe dar error si no hay datos">
        <cfargument name="Debug"       required="no"  type="boolean" default="false" hint="para invokar y debuguear desde home public fuente invokeCOM_Calculo">
        
        <cfif #Arguments.TransActiva#>                     			
			<cfset process2(Arguments.query, Arguments.comVol, Arguments.interfaz,Arguments.Debug)>
		<cfelse>          
			<cftransaction> 
            	<cfset process2(Arguments.query, Arguments.comVol, Arguments.interfaz,Arguments.Debug)>
            </cftransaction>
        </cfif>      
    </cffunction>

    <cffunction name="process2" access="private" output="no">
	 	<!--- Argumentos --->
		<cfargument name="query"       required="yes" type="query">
        <cfargument name="comVol"      required="no"  type="boolean" default="false">
        <cfargument name="interfaz"    required="no"  type="boolean" default="true" hint="Para saber si es interfaz o sistema, en caso de sistema no debe dar error si no hay datos">
        <cfargument name="Debug"       required="no"  type="boolean" default="false" hint="para invokar y debuguear desde home public fuente invokeCOM_Calculo">

		<!--- <cfif #session.usulogin# eq "ymena">
        	<cfset arguments.Debug = true>
        </cfif>  --->     
        
		<cfif arguments.Debug>
    		<cfdump var="query total ">
            <cfdump var="#query#"><br>
        </cfif>    
        
		<cfoutput query="query">
			<cfset GvarCalculo    	= true>
            <cfset GvarCalculoVol 	= true>
            <cfset GvarCalculoVolR 	= true>
            <cfset GvarCalculoVolRE	= true>
            <cfset GvarCalculoPP  	= true>
            <cfset GvarCalculoPPC 	= true> 
            <cfset GvarCalculoAge 	= true>
			<!---varaible de resultado--->
            <cfset GvarCalculoRes    	= ''>
            <cfset GvarCalculoVolRes 	= ''>
            <cfset GvarCalculoVolRRes 	= ''>
            <cfset GvarCalculoVolRERes	= ''>
            <cfset GvarCalculoPPRes  	= ''>
            <cfset GvarCalculoPPCRes 	= ''> 
            <cfset GvarCalculoAgeRes 	= ''>
        	<!---1 Validaciones --->
			
			<!---Estado--->
			<cfif isdefined("query.Estado") and len(trim(query.Estado)) and (UCase(query.Estado) eq 'R' or UCase(query.Estado) eq 'P')>
            	<cfset Estado = query.Estado>
            <cfelse>
            	<cfthrow message="Error Interfaz 719. El estado indicado es inv&aacute;lido. Proceso Cancelado!">
            </cfif>
            
			<!---Documento--->    
            <cfif isdefined("query.Ddocumento") and len(trim(query.Ddocumento))>
            	<cfset Ddocumento = query.Ddocumento>
            <cfelse>
            	<cfthrow message="Error Interfaz 719. El documento indicado para la factura no puede ser vac&iacute;o. Proceso Cancelado!">
            </cfif>
			
			<!---Validacion de la Empresa--->
			<cfif query.Ecodigo gt 0>
				<cfset Ecodigo  = getValidEmpresa (query.Ecodigo)>
            <cfelseif query.Ecodigo eq 0>
                <cfset Ecodigo  = GvarEcodigo>
            </cfif>
            
            <!---Valida el tipo de socio; si es Socio y estamos en el rebajo de comisiones SOLO CALCULA Pronto Pago Cliente--->
            <cfif isdefined('query.PtipoSN') and query.PtipoSN  eq '0' > 
            	<cfif isdefined('query.invokadoDesde') and query.invokadoDesde  eq 'RebajoComision'>
					<cfset GvarCalculoVol 	= false> <cfset GvarCalculoVolRes 	= 'es Socio y estamos en el rebajo de comisiones SOLO CALCULA Pronto Pago Cliente'>
                    <cfset GvarCalculoVolR 	= false> <cfset GvarCalculoVolRRes 	= 'es Socio y estamos en el rebajo de comisiones SOLO CALCULA Pronto Pago Cliente'>
                	<cfset GvarCalculoVolRE	= false> <cfset GvarCalculoVolRERes	= 'es Socio y estamos en el rebajo de comisiones SOLO CALCULA Pronto Pago Cliente'>
                    <cfset GvarCalculoPP  	= false> <cfset GvarCalculoPPRes  	= 'es Socio y estamos en el rebajo de comisiones SOLO CALCULA Pronto Pago Cliente'>
                    <cfset GvarCalculoAge 	= false> <cfset GvarCalculoAgeRes 	= 'es Socio y estamos en el rebajo de comisiones SOLO CALCULA Pronto Pago Cliente'>
                   
                    <cfset GvarCalculoPPC 	= true>
                    <cfif arguments.Debug>
                        <cfdump var="Es socio por lo cual solo comisiona Pronto Pago Cliente, ya q estamos en rebaja comision,  las demas false"><br>
                    </cfif>
                <cfelseif isdefined('query.invokadoDesde') and query.invokadoDesde  eq 'ParaOlla'>
                    <cfset GvarCalculoPPC = false> <cfset GvarCalculoPPCRes = 'Es socio por lo cual va para la olla y NO  comisiona'>
                    <cfif arguments.Debug>
                        <cfdump var="Es socio por lo cual va para la olla y NO  comisiona Pronto Pago Cliente"><br>
                    </cfif>
                </cfif>
            <cfelseif not isdefined('query.PtipoSN')  and isdefined('query.invokadoDesde') and query.invokadoDesde  eq 'ParaOlla'>
            	<!---Sino trae el PtipoSN y esta definido que es paraOlla significa que es de contado, y NO debe comisionar pronto pago--->
				<cfset GvarCalculoPPC = false> <cfset GvarCalculoPPCRes = 'Es de contado por lo cual va  para la olla y NO  comisiona'>
                <cfif arguments.Debug>
                    <cfdump var="Es de contado por lo cual va  para la olla y NO  comisiona Pronto Pago Cliente"><br>
                </cfif>
            </cfif>
            
            <!---Volumen--->	
			<cfif isdefined("query.IndComVol") and len(trim(query.IndComVol)) and (UCase(query.IndComVol) eq 'S' or UCase(query.IndComVol) eq 'N')>
                <cfif UCase(query.IndComVol) eq 'N'>
                	<cfset GvarCalculoVol = false> <cfset GvarCalculoVolRes = 'query.IndComVol se envio en N'>
                    <cfif arguments.Debug>
                        <cfdump var="GvarCalculoVol se puso en false linea buscar: query.IndComVol"><br>
                    </cfif>
                </cfif>
            <cfelse>
            	<cfthrow message="Error Interfaz 719. El indicador de comisi&oacute;n de Volumen es inv&aacute;lido. Proceso Cancelado!">
            </cfif>
			<!---Volumen Radio--->	
			<cfif isdefined("query.IndComVolR") and len(trim(query.IndComVolR)) and (UCase(query.IndComVolR) eq 'S' or UCase(query.IndComVolR) eq 'N')>
                <cfif UCase(query.IndComVolR) eq 'N'>
                	<cfset GvarCalculoVolR = false> <cfset GvarCalculoVolRRes = 'query.IndComVolR se envio en N'>
                    <cfif arguments.Debug>
                        <cfdump var="GvarCalculoVolR se puso en false linea buscar: query.IndComVolR"><br>
                    </cfif>
                </cfif>
            <cfelse>
            	<cfthrow message="Error Interfaz 719. El indicador de comisi&oacute;n de Volumen Radio es inv&aacute;lido. Proceso Cancelado!">
            </cfif>
			<!---Volumen Radio Especial--->	
			<cfif isdefined("query.IndComVolRE") and len(trim(query.IndComVolRE)) and (UCase(query.IndComVolRE) eq 'S' or UCase(query.IndComVolRE) eq 'N')>
                <cfif UCase(query.IndComVolRE) eq 'N'>
                	<cfset GvarCalculoVolRE = false> <cfset GvarCalculoVolRERes = 'query.IndComVolRE se envio en N'>
                    <cfif arguments.Debug>
                        <cfdump var="GvarCalculoVolRE se puso en false linea buscar: query.IndComVolRE"><br>
                    </cfif>
                </cfif>
            <cfelse>
            	<cfthrow message="Error Interfaz 719. El indicador de comisi&oacute;n de Volumen Radio Especial es inv&aacute;lido. Proceso Cancelado!">
            </cfif>
            <!---Agencia--->
            <cfif isdefined("query.IndComAge") and len(trim(query.IndComAge)) and (UCase(query.IndComAge) eq 'S' or UCase(query.IndComAge) eq 'N')>
                <cfif UCase(query.IndComAge) eq 'N'>
                	<cfset GvarCalculoAge = false> <cfset GvarCalculoAgeRes = 'query.IndComAge se envio en N'>
                    <cfif arguments.Debug>
                        <cfdump var="GvarCalculoAge se puso en false linea buscar: query.IndComAge"><br>
                    </cfif>
                </cfif>
            <cfelse>
            	<cfthrow message="Error Interfaz 719. El indicador de comisi&oacute;n de Agencia es inv&aacute;lido. Proceso Cancelado!">
            </cfif>
            <!---Pronto Pago --->
            <cfif isdefined("query.IndComPP") and len(trim(query.IndComPP)) and (UCase(query.IndComPP) eq 'S' or UCase(query.IndComPP) eq 'N')>
                <cfif UCase(query.IndComPP) eq 'N'>
                	<cfset GvarCalculoPP = false> <cfset GvarCalculoPPRes = 'query.IndComPP se envio en N'> 
                    <cfif arguments.Debug>
                        <cfdump var="GvarCalculoPP se puso en false linea buscar: query.IndComPP"><br>
                    </cfif>
                </cfif>
            <cfelse>
            	<cfthrow message="Error Interfaz 719. El indicador de comisi&oacute;n de Pronto Pago es inv&aacute;lido. Proceso Cancelado!">
            </cfif>
            <!---Pronto Pago Cliente--->
			<cfif isdefined("query.IndComPPC") and len(trim(query.IndComPPC)) and (UCase(query.IndComPPC) eq 'S' or UCase(query.IndComPPC) eq 'N')>
                <cfif UCase(query.IndComPPC) eq 'N'>
                	<cfset GvarCalculoPPC = false> <cfset GvarCalculoPPCRes = 'query.IndComPPC se envio en N'> 
                    <cfif arguments.Debug>
                        <cfdump var="GvarCalculoPPC se puso en false linea buscar: query.IndComPPC"><br>
                    </cfif>
                </cfif>
            <cfelse>
            	<cfthrow message="Error Interfaz 719. El indicador de comisi&oacute;n de Pronto Pago Cliente es inv&aacute;lido. Proceso Cancelado!">
            </cfif>

            <!---valida transaccion--->
            <cfset Valid_Tran = getValidTransaccion(query.CCTcodigo,Ecodigo)>
            
			<!---valida socio de negocios--->
            <cfset Valid_SNegocios 	= getValidSNegocios(query.SNnumero, Ecodigo)>
            
            <!---Valida si el estado del socio es L = Legal no debe comisionar--->
            <cfif #Valid_SNegocios.estadoSocio# eq 'L'>
            	<cfset GvarCalculo    	= false> <cfset GvarCalculoRes	 	= 'Socio es Legal por lo cual no comisiona'>
				<cfset GvarCalculoVol 	= false> <cfset GvarCalculoVolRes 	= 'Socio es Legal por lo cual no comisiona'>
                <cfset GvarCalculoVolR 	= false> <cfset GvarCalculoVolRRes 	= 'Socio es Legal por lo cual no comisiona'>
                <cfset GvarCalculoVolRE	= false> <cfset GvarCalculoVolRERes = 'Socio es Legal por lo cual no comisiona'>
                <cfset GvarCalculoPP  	= false> <cfset GvarCalculoPPRes 	= 'Socio es Legal por lo cual no comisiona'>
                <cfset GvarCalculoPPC 	= false> <cfset GvarCalculoPPCRes 	= 'Socio es Legal por lo cual no comisiona'>
                <cfset GvarCalculoAge 	= false> <cfset GvarCalculoAgeRes 	= 'Socio es Legal por lo cual no comisiona'>
                <cfif arguments.Debug>
                    <cf_dump var="El socio es Legal no Comisiona"><br>
                </cfif>
            </cfif>
            
			<cfif isdefined("query.ValidaFPago") and #query.ValidaFPago# eq false>
            	<!---Se manda en el query que NO valide forma de pago de otra forma si tiene que validar--->	
			<!--- <cfelseif isdefined("query.Pcodigo") and isdefined("query.CCTcodigoE")>--->
            <cfelseif GvarCalculoPP or GvarCalculoPPC> <!---si ya estan en false no se validan--->
            	<!---Valida las formas de pago, para que no comisiones PP  --->           
                <cfquery name="rsFormasPago" datasource="#GvarConexion#">
                    select COMRFPGanaPP
                    from 
                    <cfif isdefined("query.Pcodigo") and isdefined("query.CCTcodigoE")>
                    	PFPagos 
                    <cfelse>
                    	FPagos 
                    </cfif> a
                    inner join COMRestriccionesFPago b
                        on b.COMRFormaPago =a.Tipo  
                    where 	1=1
                    <cfif isdefined("query.Pcodigo") and isdefined("query.CCTcodigoE")>
                    	and ltrim(rtrim(CCTcodigo)) = ltrim(rtrim(<cfqueryparam value="#query.CCTcodigoE#" cfsqltype="cf_sql_varchar">))
                    	and ltrim(rtrim(Pcodigo))  = ltrim(rtrim(<cfqueryparam value="#query.Pcodigo#" cfsqltype="cf_sql_varchar">))
                    <cfelse>
                    	and FCid 		= <cfqueryparam value="#query.FCid#" cfsqltype="cf_sql_numeric">
                    	and ETnumero  	= <cfqueryparam value="#query.ETnumero#" cfsqltype="cf_sql_numeric">
                    </cfif>
                </cfquery>
    
                <cfloop query="rsFormasPago">
                    <cfif rsFormasPago.COMRFPGanaPP eq 'N'>
                        <cfset GvarCalculoPP  = false> <cfset GvarCalculoPPRes  = 'rsFormasPago no comisiona'>
                        <cfset GvarCalculoPPC = false> <cfset GvarCalculoPPCRes = 'rsFormasPago no comisiona'>
                        <cfif arguments.Debug>
                            <cfdump var="GvarCalculoPP y GvarCalculoPPC se puso en false linea buscar: rsFormasPago.COMRFPGanaPP"><br>
                        </cfif>
                    </cfif>
                </cfloop>

            </cfif>
			
            <!---Restricciones--->
            <cfquery name="rsRESTR" datasource="#GvarConexion#">
            	select Restriccion
                from COMResTransaccion
                where CCTcodigo = <cfqueryparam value="#query.CCTcodigo#" cfsqltype="cf_sql_char">
            </cfquery>
            
            <cfset restricciones = ValueList(rsRESTR.Restriccion,",")>
            
			<cfif ListFindNoCase(restricciones, 'NOPAGCOM')>
            	<cfset GvarCalculo = false> <cfset GvarCalculoRes = 'restriccion NOPAGCOM'>
                <cfif arguments.Debug>
                    <cfdump var="GvarCalculo se puso en false linea buscar: ListFindNoCase(restricciones"><br>
                </cfif>
            </cfif>
            
            <cfif ListFindNoCase(restricciones, 'NOPAGPP') and isdefined("query.IndComPP") and UCase(query.IndComPP) eq 'S'>
            	<cfset GvarCalculoPP = false> <cfset GvarCalculoPPRes = 'restriccion NOPAGPP'>
                <cfif arguments.Debug>
                    <cfdump var="GvarCalculoPP se puso en false linea buscar: ListFindNoCase(restricciones"><br>
                </cfif>
            </cfif>

			
			<!---Esto se hace para poder pasarle al COM_Calculo la fecha que se quiere usar de expedido, ya que puede venir
            de un deposito (MLibros) o del encabezado del cobro o facturacion y cuando tiene formas de pago puede venir cheque o de libros  --->
            <cfif isdefined('query.Dfechaexpedido') and len(trim(#query.Dfechaexpedido#)) gt 0>
                
            	<cfset LvarDfechaexpedido = dateFormat(#query.Dfechaexpedido#, "YYYY/MM/DD")>
                <cfquery name="rsRESTR" datasource="#GvarConexion#">
                    update COMEDocumentos
                        set Dfechaexpedido =  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarDfechaexpedido#">
                    where Ddocumento = <cfqueryparam value="#query.Ddocumento#" cfsqltype="cf_sql_char">
                    and CCTcodigo    = <cfqueryparam value="#query.CCTcodigo#" cfsqltype="cf_sql_char">
                    and Ecodigo      = <cfqueryparam value="#GvarEcodigo#" cfsqltype="cf_sql_integer">
                    and SNcodigo     = <cfqueryparam value="#Valid_SNegocios.SNcodigo#" cfsqltype="cf_sql_integer">
                </cfquery>
            </cfif>

			<!---Detalle datos--->
            <cf_dbfunction name="to_date00"	args="ce.Dfecha"  returnvariable="fecha" > 
            <cf_dbfunction name="to_date00"	args="ce.Dfechaexpedido"  returnvariable="fechaE" > 
            <cf_dbfunction name="to_date00"	args="ce.Dvencimiento"  returnvariable="fechaV" > 
            <cfquery name="rsFact" datasource="#GvarConexion#">
            	select COMEDid,COMEDindContado,RESNid,ce.SNcodigo,Subtotal,Total,
                coalesce(COMEindCVG,'N') as COMEindCVG, 
                coalesce(COMEindCVRG,'N') as COMEindCVRG,
                coalesce(COMEindCVREG,'N') as COMEindCVREG,
                coalesce(COMEindCAG,'N') as COMEindCAG, 
                coalesce(COMEindCPPG,'N') as COMEindCPPG,
                coalesce(COMEindCPPCG,'N') as COMEindCPPCG,
                #fechaE# as Dfechaexpedido, #fechaV# as Dvencimiento, #fecha# as Dfecha, ce.Mcodigo
				,doc.Dtipocambio 
                from COMEDocumentos ce
                inner join CCTransacciones cct
                on cct.CCTcodigo = ce.CCTcodigo
                and cct.Ecodigo  = ce.Ecodigo
                inner join HDocumentos doc
                on doc.Ddocumento =ce.Ddocumento
                where ce.Ddocumento = <cfqueryparam value="#query.Ddocumento#" cfsqltype="cf_sql_char">
                and ce.CCTcodigo = <cfqueryparam value="#query.CCTcodigo#" cfsqltype="cf_sql_char">
                and ce.Ecodigo   = <cfqueryparam value="#GvarEcodigo#" cfsqltype="cf_sql_integer">
                and cct.CCTtipo   = <cfqueryparam value="D" cfsqltype="cf_sql_char">
                and ce.SNcodigo 	 = <cfqueryparam value="#Valid_SNegocios.SNcodigo#" cfsqltype="cf_sql_integer">
            </cfquery>

            <!---Si no hay datos de detalle y es interfaz da error, sino es interfaz hace un return ya que no comisiona y la factura sigue--->
            <cfif rsFact.recordcount eq 0 and #arguments.interfaz#>
            	<cfquery name="rsEmpresa" datasource="#GvarConexion#">
                    select Edescripcion from Empresas where Ecodigo = <cfqueryparam value="#GvarEcodigo#" cfsqltype="cf_sql_integer">
                </cfquery>
            	<cfthrow message="Error Interfaz 719. No existe la factura para el Documento: #query.Ddocumento# y Transacci&oacute;n: #query.CCTcodigo# para la empresa #rsEmpresa.Edescripcion#. Proceso Cancelado!">
            <cfelseif rsFact.recordcount eq 0 >
                <cfif arguments.Debug>
                    <cfdump var="la consulta sobre COMEDocuentos no trajo nada linea 262, aqui hace retur"><br>
                    <cf_dump var="#rsFact#"><br>
                </cfif> 
                <cfreturn>
            </cfif>
            
            <!---Determina si ya existe un calculo previo del volumen de Radio--->
			<cfquery name="rsRadioExiste" datasource="#GvarConexion#">
                select VolumenGLR, VolumenGLRE 
                from COMLotes
                where Ecodigo = <cfqueryparam value="#GvarEcodigo#" cfsqltype="cf_sql_integer">
                and COMEDid = <cfqueryparam value="#rsFact.COMEDid#" cfsqltype="cf_sql_numeric">
            </cfquery>

            
			<!---validacion si solo está calculando la comisión de volumen (viene de la pantalla de Calculo de Comision de Volumen COM_GenCOMVol-SQL.cfm)
				y si ya existen otras comisiones generadas no debe borrarlas --->
            <cfif arguments.comVol>
                <cfquery name="rsFacturas" datasource="#session.dsn#">
                    select 1
                    from COMCalculo com
                        inner join COMEDocumentos ce
                        on ce.COMEDid = com.COMEDid
                        and ce.Ecodigo = com.Ecodigo
                    where com.Ecodigo  = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">   
                    and com.RESNid   = <cfqueryparam value="#form.RESNid#" cfsqltype="cf_sql_numeric">        
                    and com.COMEDid = <cfqueryparam value="#rsFact.COMEDid#" cfsqltype="cf_sql_numeric">
                    and (com.ProntoPago + com.ProntoPagoCliente + com.montoAgencia) > 0
                    and ( (select coalesce(d.Dsaldo,0) 
                          from Documentos d
                          where d.Ddocumento = ce.Ddocumento
                          and d.CCTcodigo    = ce.CCTcodigo
                          and d.Ecodigo      = ce.Ecodigo
                          and d.SNcodigo 	 = ce.SNcodigo) = 0  <!----- si la factura tiene saldo cero--->
                          or ( not exists (select 1 from Documentos d <!----- o si la factura no existe end Documentos y si end HDocumentos, es que ya fue cancelada--->
                                where d.Ddocumento = ce.Ddocumento
                                and d.CCTcodigo    = ce.CCTcodigo
                                and d.Ecodigo      = ce.Ecodigo
                                and d.SNcodigo 	 = ce.SNcodigo)
                              and
                             exists (select 1 
                                   from HDocumentos 
                                     where Ddocumento = ce.Ddocumento
                                     and CCTcodigo    = ce.CCTcodigo
                                     and Ecodigo      = ce.Ecodigo
                                     and SNcodigo 	   = ce.SNcodigo)  
                              )
                        )
                </cfquery>
            </cfif>   

            <!---Borrar la Comision generada anteriormente para esta factura--->
			<cfset varBorrar    = true>
            <cfif isdefined('rsFacturas') and rsFacturas.recordcount gt 0>
				<cfset varBorrar    = false>
            </cfif>


            <cfif varBorrar>
                <cfquery datasource="#GvarConexion#">
                    insert  into COMCalculo_Bit( 
                        Accion,COMEDid,RESNid,Estado,Mcodigo,
                        ProntoPago,ProntoPagoCliente,PorcentajePP,
                        VolumenGN,VolumenGLR,VolumenGLRE,
                        montoAgencia,Ecodigo,BMUsucodigo,fecha
                        )
                    select
                        'Delete COMCalculo',COMEDid,RESNid,Estado,Mcodigo,
                        ProntoPago,ProntoPagoCliente,PorcentajePP,
                        VolumenGN,VolumenGLR,VolumenGLRE,
                        montoAgencia,Ecodigo,#session.usucodigo#, #now()#
                    from COMCalculo
                    where Ecodigo = <cfqueryparam value="#GvarEcodigo#" cfsqltype="cf_sql_integer">
                    and COMEDid = <cfqueryparam value="#rsFact.COMEDid#" cfsqltype="cf_sql_numeric">
                </cfquery>

                <cfquery datasource="#GvarConexion#">
                    delete 
                    from COMCalculo
                    where Ecodigo = <cfqueryparam value="#GvarEcodigo#" cfsqltype="cf_sql_integer">
                    and COMEDid = <cfqueryparam value="#rsFact.COMEDid#" cfsqltype="cf_sql_numeric">
                </cfquery>
            </cfif>   
            
                        
            <!--- Busca Moneda Local --->
            <cfquery name="rsMonedaL" datasource="#GvarConexion#">
                select m.Mcodigo, m.Miso4217 
                from Empresas e 
                inner join Monedas m 
                    on e.Ecodigo = m.Ecodigo and e.Mcodigo = m.Mcodigo
                where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
            </cfquery>
            
            <cfif isdefined("rsMonedaL") and rsMonedaL.Mcodigo NEQ	rsFact.Mcodigo> 
                <!---<cfset Valid_TipoCambioR	= getValidTipoCambio(rsFact.Mcodigo,rsFact.Dfecha,GvarEcodigo)>
                <cfset Valid_TipoCambio     = Valid_TipoCambioR.TCcompra>--->
                <cfset Valid_TipoCambio     = #rsFact.Dtipocambio#>                
                
            <cfelse>
                <cfset Valid_TipoCambio		= 1>
            </cfif>
            
            <!---volumen--->    
            <cfif isdefined("rsFact.COMEindCVG") and UCase(rsFact.COMEindCVG) eq 'S'>
            	<cfset GvarCalculoVol = false> <cfset GvarCalculoVolRes = 'rsFact.COMEindCVG es S'>
                <cfif arguments.Debug>
                    <cfdump var="GvarCalculoVol se puso en false linea buscar: rsFact.COMEindCVG"><br>
                </cfif>
            </cfif>
            <!---volumen radio--->    
            <cfif isdefined("rsFact.COMEindCVRG") and UCase(rsFact.COMEindCVRG) eq 'S'>
            	<cfset GvarCalculoVolR = false> <cfset GvarCalculoVolRRes = 'rsFact.COMEindCVRG es S'>
                <cfif arguments.Debug>
                    <cfdump var="GvarCalculoVolR se puso en false linea buscar: rsFact.COMEindCVRG"><br>
                </cfif>
            </cfif>
            <!---volumen radio--->    
            <cfif isdefined("rsFact.COMEindCVREG") and UCase(rsFact.COMEindCVREG) eq 'S'>
            	<cfset GvarCalculoVolRE = false> <cfset GvarCalculoVolRERes = 'rsFact.COMEindCVREG es S'>
                <cfif arguments.Debug>
                    <cfdump var="GvarCalculoVolRE se puso en false linea buscar: rsFact.COMEindCVREG"><br>
                </cfif>
            </cfif>
            <!---agencia--->
            <cfif isdefined("rsFact.COMEindCAG") and UCase(rsFact.COMEindCAG) eq 'S'>
            	<cfset GvarCalculoAge = false> <cfset GvarCalculoAgeRes = 'rsFact.COMEindCAG es S'>
                <cfif arguments.Debug>
                    <cfdump var="GvarCalculoAge se puso en false linea buscar: rsFact.COMEindCAG"><br>
                </cfif>
            </cfif>
            <!---pronto pago--->
            <cfif isdefined("rsFact.COMEindCPPG") and UCase(rsFact.COMEindCPPG) eq 'S'>
            	<cfset GvarCalculoPP  = false> <cfset GvarCalculoPPRes = 'rsFact.COMEindCPPG es S'>
                <cfif arguments.Debug>
                    <cfdump var="GvarCalculoPP se puso en false linea buscar: rsFact.COMEindCPPG"><br>
                </cfif>
            </cfif>
            <!---pronto pago cliente--->
            <cfif isdefined("rsFact.COMEindCPPCG") and UCase(rsFact.COMEindCPPCG) eq 'S'>
            	<cfset GvarCalculoPPC  = false> <cfset GvarCalculoPPCRes = 'rsFact.COMEindCPPCG es S'>
                <cfif arguments.Debug>
                    <cfdump var="GvarCalculoPPC se puso en false linea buscar: rsFact.COMEindCPPCG"><br>
                </cfif>
            </cfif>

            <cfset montoRes   = 0>
            <cfset montoResPP = 0>
            <cfset subTotF    = rsFact.Subtotal>
            <cfset subTotFPP  = subTotF>

            <cfif isdefined("rsFact.COMEDindContado") and UCase(rsFact.COMEDindContado) eq 'N'>
                <cfquery name="rsDocu" datasource="#GvarConexion#">
                    select Dsaldo 
                    from Documentos 
                    where Ddocumento = <cfqueryparam value="#query.Ddocumento#" cfsqltype="cf_sql_char">
                    and CCTcodigo    = <cfqueryparam value="#query.CCTcodigo#" cfsqltype="cf_sql_char">
                    and Ecodigo      = <cfqueryparam value="#GvarEcodigo#" cfsqltype="cf_sql_integer">
                    and SNcodigo 	 = <cfqueryparam value="#Valid_SNegocios.SNcodigo#" cfsqltype="cf_sql_integer">
                </cfquery>
                <cfif rsDocu.recordcount gt 0>
                	<cfset totalP = rsDocu.Dsaldo - query.MontoAbono>
                    <cfif totalP gt 0>
                    	<cfset GvarCalculo = false> <cfset GvarCalculoRes = 'rsDocu.Dsaldo - query.MontoAbono gt 0'>
                    </cfif>
                <cfelse>
                    <cfquery name="rsHDocu" datasource="#GvarConexion#">
                        select Dsaldo 
                        from HDocumentos 
                        where Ddocumento = <cfqueryparam value="#query.Ddocumento#" cfsqltype="cf_sql_char">
                        and CCTcodigo    = <cfqueryparam value="#query.CCTcodigo#" cfsqltype="cf_sql_char">
                        and Ecodigo      = <cfqueryparam value="#GvarEcodigo#" cfsqltype="cf_sql_integer">
                        and SNcodigo 	 = <cfqueryparam value="#Valid_SNegocios.SNcodigo#" cfsqltype="cf_sql_integer">
                    </cfquery>
                    <cfif rsHDocu.recordcount eq 0>
                    	<cfset GvarCalculo = false> <cfset GvarCalculoRes = 'No hay datos en rsHDocu'>
                        <cfif arguments.Debug>
                            <cfdump var="GvarCalculo se puso en false linea buscar: rsHDocu.recordcount eq 0"><br>
                        </cfif>
                    </cfif>
                </cfif> 

            <cfelseif isdefined("rsFact.COMEDindContado") and UCase(rsFact.COMEDindContado) neq 'N' and GvarCalculoPP and isdefined("query.ID")>
            	<cfquery name="rsDetI" datasource="#GvarConexion#">	
            		select *
                    from ID719 
                    where ID   = <cfqueryparam value="#query.ID#" cfsqltype="cf_sql_numeric"> 
                    and SecFac = <cfqueryparam value="#query.SecFac#" cfsqltype="cf_sql_numeric"> 
                </cfquery>
                <!---Comparar Mcodigo del pago con la factura--->
                <cfloop query="rsDetI">
                	<cfquery name="rsRESFP" datasource="#GvarConexion#">	
                        select COMRFPGanaPP
                        from COMRestriccionesFPago
                        where COMRFormaPago = <cfqueryparam value="#rsDetI.FormaPago#" cfsqltype="cf_sql_char"> 
                        and Ecodigo = <cfqueryparam value="#GvarEcodigo#" cfsqltype="cf_sql_integer"> 
                	</cfquery>        
                    <cfif trim(rsRESFP.COMRFPGanaPP) eq 'N'>
                		<cfset montoResPP = montoResPP + rsDetI.MontoFP>    	
                    </cfif>
                </cfloop>
				<cfset subTotFPP  = subTotFPP - montoResPP>
                <cfif subTotFPP lte 0>     
                    <cfset GvarCalculoPP = false> <cfset GvarCalculoPPRes = 'subTotFPP - montoResPP lte 0'>
                </cfif>
 			</cfif> 
            
			<cfif GvarCalculo> 
                <cfquery name="rsBMov" datasource="#GvarConexion#">
                    select b.Dtotal,b.CCTcodigo , b.Ddocumento, c.CCTpago
                    from BMovimientos b
                    inner join CCTransacciones c
                    on c.CCTcodigo = b.CCTcodigo
                    and c.Ecodigo = b.Ecodigo
                    where b.Ecodigo = <cfqueryparam value="#GvarEcodigo#" cfsqltype="cf_sql_integer">
                    and CCTRcodigo    = <cfqueryparam value="#query.CCTcodigo#" cfsqltype="cf_sql_char">
                    and DRdocumento   = <cfqueryparam value="#query.Ddocumento#" cfsqltype="cf_sql_char"> 
                </cfquery> 

                <cfloop query="rsBMov">
                    <cfquery name="rsRESTRM" datasource="#GvarConexion#">
                        select ltrim(rtrim(Restriccion)) as Restriccion
                        from COMResTransaccion
                        where CCTcodigo = <cfqueryparam value="#rsBMov.CCTcodigo#" cfsqltype="cf_sql_char">
                    </cfquery>
                    
                    <cfif rsRESTRM.recordcount>
                        <cfset lvarRebajo = rsBMov.Dtotal> 
						<cfif isdefined("rsBMov.CCTpago") and rsBMov.CCTpago eq 0>
                             <cfquery name="rsRebajo" datasource="#GvarConexion#">
                                select (coalesce(DDtotal,0) + coalesce(DDimpuesto,0)) as totalnc, coalesce(DDtotal,0) as subtotalnc
                                from HDDocumentos 
                                where Ddocumento = <cfqueryparam value="#rsBMov.Ddocumento#" cfsqltype="cf_sql_char">
                            </cfquery> 
                            <!--- Se sobreescribe  lvarRebajo --->
                            <cfif rsRebajo.totalnc gt 0 and rsRebajo.subtotalnc gt 0>
                                <cfset lvarRebajo = (rsBMov.Dtotal/rsRebajo.totalnc) * rsRebajo.subtotalnc> 
                            </cfif>
                        </cfif>

                        <cfset restriccionesM = ValueList(rsRESTRM.Restriccion,",")>
                        <cfif ListFindNoCase(restriccionesM, 'NOPAGCOM')>
                            <cfset montoRes   = montoRes + lvarRebajo>
                        <cfelseif GvarCalculoPP and ListFindNoCase(restriccionesM, 'NOPAGPP')>
                            <cfset montoResPP = montoResPP + lvarRebajo>	
                        </cfif>
                    </cfif>
                </cfloop>
                <cfif arguments.Debug>
                    <cfdump var="subTotF:#subTotF# - montoRes:#montoRes# , subTotFPP: #subTotFPP# - ( montoRes: #montoRes# + montoResPP: #montoResPP#)"><br>
                   <!--- <cfdump var="#rsFact#">--->
                </cfif> 
                
                <cfset subTotF   = subTotF - montoRes>
                <cfset subTotFPP = subTotFPP - (montoRes+montoResPP)>
                <cfif subTotF lte 0>
                    <cfset GvarCalculo = false> <cfset GvarCalculoRes = 'subTotF lte 0'>
                <cfelseif subTotFPP lte 0>     
                    <cfset GvarCalculoPP = false> <cfset GvarCalculoPPRes = 'subTotFPP lte 0'>
                </cfif>
            </cfif>

            <!---calcula la diferencia en días para el pronto pago--->
            <!---busca el feriado inmediato entre la fecha de emisión y fecha de expedido, no debe sumarlos todos solo los mas proximos--->
			<cfset FecDiaNoHabil = DateAdd('d',-1,rsFact.Dfechaexpedido)>
			<cfset LvarEsDiaHabil = false>

            <cfloop condition="#LvarEsDiaHabil# eq false">
                <cfquery name="rsDias" datasource="#GvarConexion#">
                    select * 
                    from COMDiasHabiles 
                    where COMDHferiado = <cfqueryparam value="#FecDiaNoHabil#" cfsqltype="cf_sql_date">
                </cfquery>      
	            <cfif rsDias.recordcount eq 0>
					<cfset LvarEsDiaHabil = true>
	            <cfelse> 
					<cfset FecDiaNoHabil = DateAdd('d',-1,FecDiaNoHabil)>
	            </cfif>                      
            </cfloop>
            
			<cfset CantDiasNoHabiles = DateDiff('d', FecDiaNoHabil, rsFact.Dfechaexpedido) >
			<cfset CantDiasNoHabiles = CantDiasNoHabiles -1 >

            
            <cfset cantD = 0 >
            <cfset cantD = DateDiff('d', rsFact.Dfecha, rsFact.Dfechaexpedido)>
			<cfif arguments.Debug>
                <cfdump var="cantD - CantDiasNoHabiles: #cantD# - #CantDiasNoHabiles#"><br>
            </cfif>    
	        <cfset cantD = cantD - CantDiasNoHabiles>


            <cfquery name="rsPlazo" datasource="#GvarConexion#">
                select coalesce(convert(int, d.SNCDvalor),0) as plazo
                    from SNClasificacionE e
                        join SNClasificacionD d
                            on d.SNCEid = e.SNCEid
                        inner join SNClasificacionSN sn
                            on sn.SNCDid = d.SNCDid
                            and sn.SNid = (SELECT distinct SNid FROM SNegocios WHERE Ecodigo=#GvarEcodigo# and SNcodigo=#rsFact.SNcodigo#)
                    where ( e.Ecodigo is null or e.Ecodigo = #GvarEcodigo# )
                      and e.SNCEcodigo ='CVenta'
            </cfquery>
            
            <cfif len(trim(#rsPlazo.plazo#)) eq 0 >
            	<cfset plazo = 0>
                <cfdump var="El plazo1:  #plazo#"><br>
            <cfelse>
            	<cfset plazo = #rsPlazo.plazo#>
                <cfdump var="El plazo2:  #plazo#"><br>
            </cfif>

            <cfif DateDiff('d', rsFact.Dfecha, rsFact.Dvencimiento)  eq #cantD# and plazo lt #cantD# >
				<cfif arguments.Debug>
                    <cfdump var="cantD - plazo: #cantD# - #plazo#"><br>
                </cfif>    
                <cfset cantD = plazo >                              
            </cfif>    

			<cfif DateDiff('d', rsFact.Dfecha, rsFact.Dvencimiento)  lt #cantD# >
				<cfset GvarCalculoVol 	= false> <cfset GvarCalculoVolRes 	= 'dias de diferencia rsFact.Dfecha, rsFact.Dvencimiento lt cantD'> 
                <cfset GvarCalculoVolR 	= false> <cfset GvarCalculoVolRRes 	= 'dias de diferencia rsFact.Dfecha, rsFact.Dvencimiento lt cantD'> 
                <cfset GvarCalculoVolRE	= false> <cfset GvarCalculoVolRERes	= 'dias de diferencia rsFact.Dfecha, rsFact.Dvencimiento lt cantD'> 
                <cfset GvarCalculoPP 	= false> <cfset GvarCalculoPPRes 	= 'dias de diferencia rsFact.Dfecha, rsFact.Dvencimiento lt cantD'> 
				<cfif arguments.Debug>
                    <cfdump var="GvarCalculoVol,GvarCalculoVolR,GvarCalculoVolRE y GvarCalculoPP se puso en false linea buscar: rsFact.Dfecha, rsFact.Dvencimiento"><br>
                    <cfdump var="dias de diferencia entre #rsFact.Dfecha#  y  #rsFact.Dvencimiento#  ES menor #cantD#"><br>
                                        
                </cfif>
            </cfif>    

            <cfset volumenR  = 0>
            <cfset volumenRE = 0>
            <cfset volumenGN = 0>
            <cfset montoGN   = 0>
            <cfset montoGLR  = 0>
            <cfset montoPP 	 = 0>
            <cfset montoPPC  = 0>
            <cfset montoAge  = 0>
            
            <cfquery name="rsRESNidGenerico" datasource="#GvarConexion#" maxrows="500">
                select RESNid   
                from  RolEmpleadoSNegocios 
                    where  AliasRol = 'N/A'
                    and Ecodigo = #GvarEcodigo#
            </cfquery>
            
            <cfif rsFact.RESNid  eq rsRESNidGenerico.RESNid>
            	<cfset GvarCalculoAge = false> <cfset GvarCalculoAgeRes = 'Es agencia generica, no comisiona agencia'>
                <cfif arguments.Debug>
                    <cfdump var="GvarCalculoAge se puso en false porque es agencia generica linea buscar: rsFact.RESNid  eq rsRESNidGenerico.RESNid "><br>
                </cfif>
            </cfif>

           	<!---Suma el monto de la agencia padre e hijas
			     Buscar el Socio Relacionado. Si no SR, buscar donde sea el el SR.--->
			<!---busca el socio de la agencia--->
            <cfquery name="rsSocioAgencia" datasource="#GvarConexion#">
            	select SNcodigo
                from RolEmpleadoSNegocios
                where Ecodigo = <cfqueryparam value="#GvarEcodigo#" cfsqltype="cf_sql_integer">
                and RESNid = <cfqueryparam value="#rsFact.RESNid#" cfsqltype="cf_sql_numeric">
            </cfquery>
            <!---Con el socio de la agencia busca el padre --->
            <cfquery name="rsSocioRelacionado" datasource="#GvarConexion#">
            	select SNidPadre, SNid, SNcodigo
                from SNegocios
                where Ecodigo = <cfqueryparam value="#GvarEcodigo#" cfsqltype="cf_sql_integer">
                and SNcodigo = <cfqueryparam value="#rsSocioAgencia.SNcodigo#" cfsqltype="cf_sql_numeric">
            </cfquery>
            
            <cfset LvarSocioPadre = rsSocioRelacionado.SNcodigo>
            
            <!---si tiene padre entonces--->
            <cfif len(trim(#rsSocioRelacionado.SNidPadre#)) gt 0 >
            	<!---buscar hijas (hermanas donde tengan el mismo papa en comun)--->
                <cfquery name="rsHijas" datasource="#GvarConexion#">
                    select SNcodigo
                    from SNegocios
                    where Ecodigo = <cfqueryparam value="#GvarEcodigo#" cfsqltype="cf_sql_integer">
                    and SNidPadre = <cfqueryparam value="#rsSocioRelacionado.SNidPadre#" cfsqltype="cf_sql_numeric">
                </cfquery>
                
                <!---buscar papa donde el SNid = SNidPadre--->
                <cfquery name="rsPapa" datasource="#GvarConexion#">
                    select SNcodigo
                    from SNegocios
                    where Ecodigo = <cfqueryparam value="#GvarEcodigo#" cfsqltype="cf_sql_integer">
                    and SNid = <cfqueryparam value="#rsSocioRelacionado.SNidPadre#" cfsqltype="cf_sql_numeric">
                </cfquery>
				<cfset LvarSocioPadre = rsPapa.SNcodigo>
                
            <cfelse> <!---sino tiene padre es porque la agencia puede ser el padre--->
            	<!---buscar hijas--->
                <cfquery name="rsHijas" datasource="#GvarConexion#">
                    select SNcodigo
                    from SNegocios
                    where Ecodigo = <cfqueryparam value="#GvarEcodigo#" cfsqltype="cf_sql_integer">
                    and SNidPadre = <cfqueryparam value="#rsSocioRelacionado.SNid#" cfsqltype="cf_sql_numeric">
                </cfquery>
            </cfif>
            
            <cfset LvarSocios = #LvarSocioPadre#>
            <cfloop query="rsHijas">
				<cfset LvarSocios = "#LvarSocios#,#rsHijas.SNcodigo#">
            </cfloop>
            
            <cfquery name="rsRESNidPadreHijas" datasource="#GvarConexion#">
            	select RESNid
                from RolEmpleadoSNegocios
                where Ecodigo = <cfqueryparam value="#GvarEcodigo#" cfsqltype="cf_sql_integer">
                and SNcodigo  in (#LvarSocios#)
            </cfquery>
            
            <cfloop query="rsRESNidPadreHijas">
            
                <cfquery name="rsVolumenV" datasource="#GvarConexion#">
                    select (COMVVmontoCoGN + COMVVmontoCrGN) as montoGN, (COMVVmontoCoGLR + COMVVmontoCrGLR) as montoGLR
                    from COMVolumenVentas
                    where Ecodigo = <cfqueryparam value="#GvarEcodigo#" cfsqltype="cf_sql_integer">
                    and RESNid = <cfqueryparam value="#rsRESNidPadreHijas.RESNid#" cfsqltype="cf_sql_numeric">
                    and COMVVmes = <cf_dbfunction name="date_part"	args="mm, #rsFact.Dfecha#">
                    and COMVVano = <cf_dbfunction name="date_part"	args="yyyy, #rsFact.Dfecha#">
                </cfquery>
                <cfif isdefined("rsVolumenV") and rsVolumenV.recordcount>
					<cfset montoGLR  = montoGLR + rsVolumenV.montoGLR>                    
					<cfset montoGN   = montoGN + rsVolumenV.montoGN >
                </cfif>
            </cfloop>
            <!---Despues del loop de padreHijas se deben sumar el montoGLR al montoGN--->           
			<cfset montoGN   = montoGN + montoGLR>

            <!---Pasar los montos a Moneda Local  
            <cfset montoGN   = (montoGN * Valid_TipoCambio)>
            <cfset montoGLR  = (montoGLR * Valid_TipoCambio)> --->          

            
            <!---Los rangos y el volumen estan en moneda local, TOMAR EN CUENTA--->
            <cfquery name="rsPorcVolGN" datasource="#GvarConexion#">
            	select COMPVporcentajeVolumen
                from COMPorcentajesVol
                where RESNid = <cfqueryparam value="#rsFact.RESNid#" cfsqltype="cf_sql_numeric">
                and COMPVtipo = <cfqueryparam value="GN" cfsqltype="cf_sql_char">
                and COMPVfechaRige <= <cfqueryparam value="#rsFact.Dfecha#" cfsqltype="cf_sql_date"> 
                and #montoGN# between COMPVrangoMinimo and COMPVrangoMaximo
                and Ecodigo = <cfqueryparam value="#GvarEcodigo#" cfsqltype="cf_sql_integer">
                and COMPVfechaRige = (
                                    select max(COMPVfechaRige)
                                    from COMPorcentajesVol
                                    where RESNid = <cfqueryparam value="#rsFact.RESNid#" cfsqltype="cf_sql_numeric">
                                    and COMPVtipo = <cfqueryparam value="GN" cfsqltype="cf_sql_char">
                                    and COMPVfechaRige <= <cfqueryparam value="#rsFact.Dfecha#" cfsqltype="cf_sql_date">                      
                                    and Ecodigo = <cfqueryparam value="#GvarEcodigo#" cfsqltype="cf_sql_integer">
                                    ) <!--- Subquery trae la fecha mas reciente, pues solo se deben validar de ese corte--->
                order by COMPVfechaRige DESC
            </cfquery>
            
			<cfif arguments.Debug>
                <cfdump var="Query del Porcentaje de Volumen GN:">
                <cfdump var="#rsPorcVolGN#"><br>
            </cfif>
            
            <cfquery name="rsPorcVolR" datasource="#GvarConexion#">
            	select COMPVporcentajeVolumen
                from COMPorcentajesVol
                where RESNid = <cfqueryparam value="#rsFact.RESNid#" cfsqltype="cf_sql_numeric">
                and COMPVtipo = <cfqueryparam value="GLR" cfsqltype="cf_sql_char">
                and COMPVfechaRige <= <cfqueryparam value="#rsFact.Dfecha#" cfsqltype="cf_sql_date"> 
                and #montoGLR# between COMPVrangoMinimo and COMPVrangoMaximo
                and Ecodigo = <cfqueryparam value="#GvarEcodigo#" cfsqltype="cf_sql_integer">
                and COMPVfechaRige = (
                                    select max(COMPVfechaRige)
                                    from COMPorcentajesVol
                                    where RESNid = <cfqueryparam value="#rsFact.RESNid#" cfsqltype="cf_sql_numeric">
                                    and COMPVtipo = <cfqueryparam value="GLR" cfsqltype="cf_sql_char">
                                    and COMPVfechaRige <= <cfqueryparam value="#rsFact.Dfecha#" cfsqltype="cf_sql_date">                      
                                    and Ecodigo = <cfqueryparam value="#GvarEcodigo#" cfsqltype="cf_sql_integer">
                                    ) <!--- Subquery trae la fecha mas reciente, pues solo se deben validar de ese corte--->
                order by COMPVfechaRige DESC
            </cfquery>
            
            <cfquery name="rsPorcVolRE" datasource="#GvarConexion#">
            	select COMPVporcentajeVolumen
                from COMPorcentajesVol
                where RESNid = <cfqueryparam value="#rsFact.RESNid#" cfsqltype="cf_sql_numeric">
                and COMPVtipo = <cfqueryparam value="GLRE" cfsqltype="cf_sql_char">
                and COMPVfechaRige <= <cfqueryparam value="#rsFact.Dfecha#" cfsqltype="cf_sql_date"> 
                and #montoGLR# between COMPVrangoMinimo and COMPVrangoMaximo
                and Ecodigo = <cfqueryparam value="#GvarEcodigo#" cfsqltype="cf_sql_integer">
                and COMPVfechaRige = (
                                    select max(COMPVfechaRige)
                                    from COMPorcentajesVol
                                    where RESNid = <cfqueryparam value="#rsFact.RESNid#" cfsqltype="cf_sql_numeric">
                                    and COMPVtipo = <cfqueryparam value="GLRE" cfsqltype="cf_sql_char">
                                    and COMPVfechaRige <= <cfqueryparam value="#rsFact.Dfecha#" cfsqltype="cf_sql_date">                      
                                    and Ecodigo = <cfqueryparam value="#GvarEcodigo#" cfsqltype="cf_sql_integer">
                                    ) <!--- Subquery trae la fecha mas reciente, pues solo se deben validar de ese corte--->
                order by COMPVfechaRige DESC
            </cfquery>
            
            <!---Restarle los dias feriados de rsDias.recordcount--->
            <!---Agregar campo nuevo a la interfaz, para conocer quien paga--->
                <cfif arguments.Debug>
                    <cfdump var="CantD: #cantD#"><br>
                </cfif>

            <cfquery name="rsPorcPP" datasource="#GvarConexion#">
                select COMPPPporcentaje
                from COMPorcentajesPP
                where RESNid = <cfqueryparam value="#rsFact.RESNid#" cfsqltype="cf_sql_numeric">
                and COMPPPtipo = <cfqueryparam value="A" cfsqltype="cf_sql_char">
                and COMPPPdias >= <cfqueryparam value="#cantD#" cfsqltype="cf_sql_integer">
                and Ecodigo = <cfqueryparam value="#GvarEcodigo#" cfsqltype="cf_sql_integer">
				order by COMPPPdias asc
            </cfquery>

			<cfif arguments.Debug>
                <cfdump var="Query del Porcentaje Agencia: ">
                <cfdump var="#rsPorcPP#"><br>
            </cfif>
            
            <cfquery name="rsPorcPPCliente" datasource="#GvarConexion#">
                select COMPPPporcentaje
                from COMPorcentajesPP
                where RESNid = <cfqueryparam value="#rsFact.RESNid#" cfsqltype="cf_sql_numeric">
                and COMPPPtipo = <cfqueryparam value="C" cfsqltype="cf_sql_char">
                and COMPPPdias >= <cfqueryparam value="#cantD#" cfsqltype="cf_sql_integer">
                and Ecodigo = <cfqueryparam value="#GvarEcodigo#" cfsqltype="cf_sql_integer">
				order by COMPPPdias asc
            </cfquery>
			<cfif arguments.Debug>
                <cfdump var="Query del Porcentaje Cliente: ">
                <cfdump var="#rsPorcPPCliente#"><br>
            </cfif>
            
            <cfif GvarCalculo>
            	<!---No tomar en cuenta el Total, sino el subtotal--->
            	<cfquery name="rsDetDo" datasource="#GvarConexion#">
                    select COMEDid,COMDDid,COMcodEmpresa,COMcodProducto,COMcodSeccion,Subtotal
                    from COMDDocumentos 
                    where COMEDid = <cfqueryparam value="#rsFact.COMEDid#" cfsqltype="cf_sql_numeric">
                </cfquery>
                <cfdump var="este es el rsDetDo">
                <cfdump var="#rsDetDo#">
                <cfset LvarSubtotal = 0>
                <cfloop query="rsDetDo">
                	<!---Tomar en cuenta y crear opcion de seleccionar todos con valor * --->
                    
                    <cfquery name="rsMaResGeneral" datasource="#GvarConexion#">
                        select coalesce(COMRganaPP,'N') as COMRganaPP, coalesce(COMRganaVolumen,'N') as COMRganaVolumen, 'S' as COMRganaAgencia , COMRporcentajeAgencia
                        from COMRestriccionesGeneral	
                        where Ecodigo = <cfqueryparam value="#GvarEcodigo#" cfsqltype="cf_sql_integer">
                        and COMRcodEmpresa in <cfif isdefined("rsDetDo.COMcodEmpresa") and len(trim(rsDetDo.COMcodEmpresa))>
                            					('#trim(rsDetDo.COMcodEmpresa)#','*')
                    						  <cfelse>
                                             	('')
                                              </cfif>
                        and COMRcodProducto in <cfif isdefined("rsDetDo.COMcodProducto") and len(trim(rsDetDo.COMcodProducto))>
                        						('#trim(rsDetDo.COMcodProducto)#','*')
                                               <cfelse>
                                              	('')
                    						 </cfif>
                    </cfquery>
					<cfset LvarConsulta = #rsMaResGeneral#>

                    <cfquery name="rsMaResDetallado" datasource="#GvarConexion#">
                        select coalesce(COMRganaPP, '') as COMRganaPP, coalesce(COMRganaVolumen, '')  as COMRganaVolumen, coalesce(COMRganaAgencia, '') as COMRganaAgencia, COMRporcentajeAgencia
                        from COMRestricciones	
                        where Ecodigo = <cfqueryparam value="#GvarEcodigo#" cfsqltype="cf_sql_integer">
                        and RESNid = <cfqueryparam value="#rsFact.RESNid#" cfsqltype="cf_sql_numeric">
                        and SNcodigo = <cfqueryparam value="#rsFact.SNcodigo#" cfsqltype="cf_sql_integer">
                        and COMRcodEmpresa in <cfif isdefined("rsDetDo.COMcodEmpresa") and len(trim(rsDetDo.COMcodEmpresa))>
                                                ('#trim(rsDetDo.COMcodEmpresa)#','*')
                                              <cfelse>
                                                ('')
                                              </cfif>
                        and COMRcodProducto in <cfif isdefined("rsDetDo.COMcodProducto") and len(trim(rsDetDo.COMcodProducto))>
                                                ('#trim(rsDetDo.COMcodProducto)#','*')
                                               <cfelse>
                                                ('')
                                             </cfif>
                        and COMRcodSeccion in<cfif isdefined("rsDetDo.COMcodSeccion") and len(trim(rsDetDo.COMcodSeccion))>
                                                ('#trim(rsDetDo.COMcodSeccion)#','*')
                                             <cfelse>
                                                ('')
                                             </cfif>
                    </cfquery>
                    <cfif rsMaResDetallado.recordcount>                        
                        <!---<cfset LvarConsulta = #rsMaResDetallado#>--->
                    	<cfif isdefined("rsMaResDetallado.COMRganaPP") and UCase(trim(rsMaResDetallado.COMRganaPP)) NEQ ''>
	                        <cfset LvarConsulta.COMRganaPP = #rsMaResDetallado.COMRganaPP#>
                        </cfif>
                    	<cfif isdefined("rsMaResDetallado.COMRganaVolumen") and UCase(trim(rsMaResDetallado.COMRganaVolumen)) NEQ ''>
	                        <cfset LvarConsulta.COMRganaVolumen = #rsMaResDetallado.COMRganaVolumen#>
                        </cfif>
                    	<cfif isdefined("rsMaResDetallado.COMRganaAgencia") and UCase(trim(rsMaResDetallado.COMRganaAgencia)) NEQ ''>
	                        <cfset LvarConsulta.COMRganaAgencia = #rsMaResDetallado.COMRganaAgencia#>
	                        <cfset LvarConsulta.COMRporcentajeAgencia = #rsMaResDetallado.COMRporcentajeAgencia#>
                        </cfif>
                    </cfif> 
                    <cfif arguments.Debug>
                        <!---<cfdump var="este es el resulta del las restricciones generales:"><br>
                        <cfdump var="#rsMaResGeneral#"><br>
                         <cfdump var="y este es el resulta del las restricciones detalladas:"><br>
                        <cfdump var="#rsMaResDetallado#"><br>--->
                         <!---<cfdump var="y este es el resultado de la combinacion de las 2 LvarConsulta:"><br>
                        <cfdump var="#LvarConsulta#"><br>--->
                    </cfif>
  					
                   
                    <cfif LvarConsulta.recordcount>
                    	<cfset LvarSubtotal = rsDetDo.Subtotal>
						<cfif arguments.Debug>
                            <!---<cfdump var="LvarSubtotal:#LvarSubtotal#"><br>
                            <cfdump var="montoRes:#montoRes#"><br>--->
                        </cfif>

						<cfif montoRes gt 0>

							<cfif arguments.Debug>
                                <cfdump var="montoRes:mayor a 0"><br>
                            </cfif>

							<cfif montoRes gt LvarSubtotal>
                                <cfif arguments.Debug>
                                    <cfdump var="montoRes:#montoRes#  mayor a LvarSubtotal:#LvarSubtotal# "><br>
                                </cfif>
                                <cfset LvarSubtotal = 0>
                                <cfset montoRes = montoRes - rsDetDo.Subtotal>
    
                                <cfif arguments.Debug>
                                    <cfdump var="montoRes:#montoRes#  y  LvarSubtotal:#LvarSubtotal# "><br>
                                </cfif>

							<cfelseif LvarSubtotal gt montoRes>  
                                <cfif arguments.Debug>
                                    <cfdump var="LvarSubtotal:#LvarSubtotal# mayor a montoRes:#montoRes#  "><br>
                                </cfif>
                                <cfset LvarSubtotal = LvarSubtotal - montoRes >
                                <cfset montoRes = 0>
                                <cfif arguments.Debug>
                                    <cfdump var="LvarSubtotal:#LvarSubtotal# y  montoRes:#montoRes#  "><br>
                                </cfif>
                                
	                        <cfelse>
                            <cfif arguments.Debug>
                                <cfdump var="son iguales "><br>
                            </cfif>
                
							<cfset LvarSubtotal = 0 >
                            <cfset montoRes = 0>
                        </cfif>
		            </cfif>
					<cfif isdefined("LvarConsulta.COMRganaPP") and UCase(trim(LvarConsulta.COMRganaPP)) eq 'S'>
                        <cfif GvarCalculoPP>
                            <cfset montoPP = montoPP + LvarSubtotal>
                        </cfif>
                        <cfif GvarCalculoPPC>
                            <cfset montoPPC = montoPPC + LvarSubtotal>
                        </cfif>
                    </cfif>
                    <cfif isdefined("LvarConsulta.COMRganaVolumen") and UCase(trim(LvarConsulta.COMRganaVolumen)) eq 'S'>
                        <cfif GvarCalculoVol>
                            <cfif trim(rsDetDo.COMcodEmpresa) eq 'GLR'>
                                <cfset volumenR  = volumenR +  LvarSubtotal>
                                <cfset volumenGN = volumenGN + LvarSubtotal>  
                            <cfelse>
                                <cfset volumenGN = volumenGN + LvarSubtotal>                           	
                            </cfif>	
                        </cfif>
                    </cfif> 
                    <cfdump var="el volumenR:#volumenR# y el volumenGN:#volumenGN# y COMcodEmpresa:#rsDetDo.COMcodEmpresa#">                          
                    <cfif isdefined("LvarConsulta.COMRganaAgencia") and UCase(trim(LvarConsulta.COMRganaAgencia)) eq 'S'>
                        <cfif GvarCalculoAge>
                            <cfset montoAge = montoAge + (LvarSubtotal * (LvarConsulta.COMRporcentajeAgencia/100))>
                        </cfif>
                    </cfif>
                        
                    </cfif>
                </cfloop> 
                <cfset montoPP   = (montoPP   * Valid_TipoCambio)>
                <cfset montoPPC  = (montoPPC  * Valid_TipoCambio)>
	            <cfset montoAge  = (montoAge  * Valid_TipoCambio)>               
                <cfset volumenR  = (volumenR  * Valid_TipoCambio)>               
                <cfset volumenGN = (volumenGN * Valid_TipoCambio)>   
                <!---SE ponen los montos en 0 si ya existe en COMlotes xq se esta duplicando.. la solucion es crear otro indicador para radio,
				pero se va a esperar la aceptacion de nacion--->
                <cfif rsRadioExiste.recordcount and (rsRadioExiste.VolumenGLR gt 0 or rsRadioExiste.VolumenGLRE gt 0)>
                	<cfset volumenR  = 0>               
                </cfif>
                
                <cfif arguments.Debug>
                    <cfdump var="Montos calculados sin multiplicar por el porcentaje
                    montoPP:#montoPP#, montoPPC:#montoPPC# ,montoAge:#montoAge# , volumenR:#volumenR# , volumenGN:#volumenGN# linea 976 ">
                    <br>
                    <cfdump var="valores a calcular GvarCalculo:#GvarCalculo#, GvarCalculoPP:#GvarCalculoPP#, GvarCalculoPPC:#GvarCalculoPPC#, 
                    GvarCalculoVol:#GvarCalculoVol#, GvarCalculoVolR:#GvarCalculoVolR#, GvarCalculoVolRE:#GvarCalculoVolRE#, GvarCalculoAge:#GvarCalculoAge# linea 979"><br>
                </cfif> 
                  
            </cfif>

			<cfif GvarCalculo>
                <cfif GvarCalculoPP and montoPP gt 0 and isdefined("rsPorcPP.COMPPPporcentaje") and rsPorcPP.COMPPPporcentaje gt 0>
                    <cfset prontopago = montoPP * (rsPorcPP.COMPPPporcentaje/100)>
                    <cfif arguments.Debug>
                        <cfdump var="#rsPorcPP#"><br>
                        <cfdump var="Monto final a inserar en pp:#prontopago#"><br>
                    </cfif>
                <cfelseif GvarCalculoPP>
                    <cfset GvarCalculoPP = false> <cfset GvarCalculoPPRes = 'montoPP o rsPorcPP.COMPPPporcentaje no es gt 0'>
                    <cfif arguments.Debug>
                        <cfdump var="GvarCalculoPP se puso en false, montoPP:#montoPP# linea buscar: rsPorcPP.COMPPPporcentaje"><br>
                    </cfif>
                </cfif>
                <cfif GvarCalculoPPC and montoPPC gt 0 and isdefined("rsPorcPPCliente.COMPPPporcentaje") and rsPorcPPCliente.COMPPPporcentaje gt 0>
                    <cfset prontopagoCliente = montoPPC * (rsPorcPPCliente.COMPPPporcentaje/100)>
                <cfelseif GvarCalculoPPC>
                    <cfset GvarCalculoPPC = false> <cfset GvarCalculoPPCRes = 'montoPPC o rsPorcPPCliente.COMPPPporcentaje no es gt 0'>
                    <cfif arguments.Debug>
                        <cfdump var="GvarCalculoPPC CLIENTE se puso en false montoPPC:#montoPPC# deberia ser mayor a 0 ,linea buscar: rsPorcPPCliente.COMPPPporcentaje"><br>
                        <cfdump var="#rsPorcPPCliente#"><br>
                    </cfif>
                </cfif>
                
                <cfset montoVolumenR = 0>                           
                <cfset montoVolumenRE = 0>                           
                <cfset montoVolumenGN = 0>   
                <!---volumen--->                        
                <cfif GvarCalculoVol>
                    <cfif volumenGN gt 0 and isdefined("rsPorcVolGN.COMPVporcentajeVolumen") and rsPorcVolGN.COMPVporcentajeVolumen gt 0>
                        <cfset montoVolumenGN = volumenGN * (rsPorcVolGN.COMPVporcentajeVolumen/100)>
                    </cfif>
                    <cfif montoVolumenGN eq 0>
                        <cfset GvarCalculoVol = false> <cfset GvarCalculoVolRes = 'montoVolumenGN eq 0'>
                        <cfif arguments.Debug>
                            <cfdump var="GvarCalculoVol se puso en false xq montoVolumenGN eq 0 linea buscar: montoVolumenGN eq 0 "><br>
                        </cfif>
                    </cfif>
                </cfif>  
                
                <!---volumen Radio--->                        
                <cfif GvarCalculoVolR>
                    <cfif volumenR gt 0 and isdefined("rsPorcVolR.COMPVporcentajeVolumen") and rsPorcVolR.COMPVporcentajeVolumen gt 0>
						<cfset montoVolumenR = volumenR * (rsPorcVolR.COMPVporcentajeVolumen/100)>
					</cfif>
					<cfif montoVolumenR eq 0>
                        <cfset GvarCalculoVolR = false> <cfset GvarCalculoVolRRes = 'montoVolumenR eq 0'>
                    </cfif>
                </cfif>

                <!---volumen Especial--->                        
                <cfif GvarCalculoVolRE>
                    <cfif volumenR gt 0 and isdefined("rsPorcVolRE.COMPVporcentajeVolumen") and rsPorcVolRE.COMPVporcentajeVolumen gt 0>
						<cfset montoVolumenRE = volumenR * (rsPorcVolRE.COMPVporcentajeVolumen/100)>
					</cfif>
					<cfif montoVolumenRE eq 0>
                        <cfset GvarCalculoVolRE = false> <cfset GvarCalculoVolRERes = 'montoVolumenRE eq 0'>
                    </cfif>
                </cfif>

                <!---Agencia--->
                <cfset agenciaM = 0>
                <cfif GvarCalculoAge and montoAge gt 0>
                    <cfset agenciaM = montoAge>
                </cfif>
                <!---Los % de PP se suman--->
                <cfset LvarPorcentaje = 0>
                <cfif GvarCalculoPP and isdefined('rsPorcPP.COMPPPporcentaje')  and rsPorcPP.COMPPPporcentaje gt 0>
                    <cfset LvarPorcentaje = LvarPorcentaje + #rsPorcPP.COMPPPporcentaje#>
                </cfif>
                <cfif GvarCalculoPPC and isdefined('rsPorcPPCliente.COMPPPporcentaje')  and rsPorcPPCliente.COMPPPporcentaje gt 0>
                    <cfset LvarPorcentaje = LvarPorcentaje + #rsPorcPPCliente.COMPPPporcentaje#>
                </cfif>
                
                <cfif arguments.Debug>
                    <cfdump var="valores si alguno se cumple inserta en COMCalculo, GvarCalculo: #GvarCalculo#,  GvarCalculoPP:#GvarCalculoPP#,GvarCalculoPPC:#GvarCalculoPPC# 
                    GvarCalculoVol:#GvarCalculoVol#, GvarCalculoVolR:#GvarCalculoVolR#, GvarCalculoVolRE:#GvarCalculoVolRE#,
                     GvarCalculoAge:#GvarCalculoAge#, COMEDid:#rsFact.COMEDid# linea 1100"><br>
                    <!---<cfdump var="montos prontopago:#prontopago#,prontopagoCliente:#prontopagoCliente# 
                    montoVolumenGN:#montoVolumenGN#,  agenciaM:#agenciaM# linea 825"><br>--->
                </cfif>
                
                
                <cfif GvarCalculoPP or GvarCalculoPPC or GvarCalculoVol or GvarCalculoVolR or GvarCalculoVolRE or GvarCalculoAge>
                    <cfif varBorrar>	<!---valida si debe actualizar o insertar si ya existia un registro--->
                        <cfquery  datasource="#GvarConexion#">
                            insert into COMCalculo (COMEDid,RESNid,Estado,Mcodigo,ProntoPago,ProntoPagoCliente,PorcentajePP,VolumenGN,VolumenGLR,VolumenGLRE,montoAgencia,Ecodigo,BMUsucodigo)
                            values(
                                #rsFact.COMEDid#,
                                #rsFact.RESNid#,
                                '#query.Estado#',
                                #rsMonedaL.Mcodigo#,
                                <cfif GvarCalculoPP  	and isdefined('prontopago')>#prontopago#<cfelse>0</cfif>,
                                <cfif GvarCalculoPPC 	and isdefined('prontopagoCliente')>#prontopagoCliente#<cfelse>0</cfif>,
                                #LvarPorcentaje# ,
                                <cfif GvarCalculoVol 	and isdefined('montoVolumenGN')>#montoVolumenGN#<cfelse>0</cfif>,
                                <cfif GvarCalculoVolR 	and isdefined('montoVolumenR')>#montoVolumenR#<cfelse>0</cfif>,
                                <cfif GvarCalculoVolRE 	and isdefined('montoVolumenRE')>#montoVolumenRE#<cfelse>0</cfif>,
                                <cfif GvarCalculoAge 	and isdefined('agenciaM')>#agenciaM#<cfelse>0</cfif>,
                                #GvarEcodigo#,
                                #session.usucodigo#
                            )
                        </cfquery>
                    <cfelse>                    
                        
                        <cfquery datasource="#GvarConexion#">
                            insert  into COMCalculo_Bit( 
                                Accion,COMEDid,RESNid,Estado,Mcodigo,
                                ProntoPago,ProntoPagoCliente,PorcentajePP,
                                VolumenGN,VolumenGLR,VolumenGLRE,
                                montoAgencia,Ecodigo,BMUsucodigo,fecha
                                )
                            select
                                'update COMCalculo',COMEDid,RESNid,Estado,Mcodigo,
                                ProntoPago,ProntoPagoCliente,PorcentajePP,
                                VolumenGN,VolumenGLR,VolumenGLRE,
                                montoAgencia,Ecodigo,#session.usucodigo#,#now()#
                                from COMCalculo
                            where COMEDid = #rsFact.COMEDid#
                                and RESNid = #rsFact.RESNid#
                                and Ecodigo = #GvarEcodigo#
                        </cfquery>

                        <cfquery  datasource="#GvarConexion#">
                            update COMCalculo 
                                set ProntoPago = <cfif GvarCalculoPP  and isdefined('prontopago')>#prontopago#<cfelse>ProntoPago</cfif>,
                                    ProntoPagoCliente	= <cfif GvarCalculoPPC and isdefined('prontopagoCliente')>#prontopagoCliente#<cfelse>ProntoPagoCliente</cfif>,
                                    PorcentajePP 		= <cfif (GvarCalculoPPC or GvarCalculoPP) and isdefined('LvarPorcentaje')>#LvarPorcentaje#<cfelse>PorcentajePP</cfif>,
                                    VolumenGN 			= <cfif GvarCalculoVol and isdefined('montoVolumenGN')>#montoVolumenGN#<cfelse>VolumenGN</cfif>,
                                    VolumenGLR 			= <cfif GvarCalculoVolR and isdefined('montoVolumenR')>#montoVolumenR#<cfelse>VolumenGLR</cfif>,
                                    VolumenGLRE 		= <cfif GvarCalculoVolRE and isdefined('montoVolumenRE')>#montoVolumenRE#<cfelse>VolumenGLRE</cfif>,
                                    montoAgencia 		= <cfif GvarCalculoAge and isdefined('agenciaM')>#agenciaM#<cfelse>montoAgencia</cfif>
                            where COMEDid = #rsFact.COMEDid#
                                and RESNid = #rsFact.RESNid#
                                and Ecodigo = #GvarEcodigo#
                        </cfquery>
                    </cfif>
                <cfelseif arguments.comVol>
                    <cfquery name="rsUpdComi" datasource="#GvarConexion#">
                        update COMEDocumentos set COMEindCVG = 'E' <!---Excepcion---> 
                        	where COMEDid = #rsFact.COMEDid#
                    </cfquery>
                </cfif>
                
                <!---Solo cuando es interfaz inserta DocumentosFormaPago--->
                <cfif isdefined("rsDetI") and rsDetI.recordcount>
                    <cfloop query="rsDetI">
                        <cfquery name="rsMoneda" datasource="#GvarConexion#">
                            select Mcodigo 
                            from Monedas 
                            where Miso4217 = <cfqueryparam value="#rsDetI.Miso4217#" cfsqltype="cf_sql_char">
                            and Ecodigo = <cfqueryparam value="#GvarEcodigo#" cfsqltype="cf_sql_integer">
                        </cfquery>
                        <cfquery name="rsFPagos" datasource="#GvarConexion#">
                            insert into DocumentosFormaPago (COMEDid,FormaPago,MontoFP,Mcodigo) 
                            values (#rsFact.COMEDid#,'#rsDetI.FormaPago#',#rsDetI.MontoFP#,#rsMoneda.Mcodigo#)
                        </cfquery>
                    </cfloop>
                </cfif>
                
                <!---Pronto Pago--->
                <cfif GvarCalculoPP and isdefined("prontopago") and prontopago gt 0>
                    <cfquery datasource="#GvarConexion#">
                        <!---insert into #LvarOE# (Miso4217, COMcodigo, Monto)--->
                        insert into sif_interfaces..OE719 (Miso4217,CodCom,MontoCom,BMUsucodigo)
                        values ('#rsMonedaL.Miso4217#','COMPP',#prontopago#,#GvarUsucodigo#)
                    </cfquery>
                </cfif>
                <!---Pronto Pago Cliente--->
                <cfif GvarCalculoPPC and isdefined("prontopagoCliente") and prontopagoCliente gt 0>
                    <cfquery datasource="#GvarConexion#">
                        <!---insert into #LvarOE# (Miso4217, COMcodigo, Monto)--->
                        insert into sif_interfaces..OE719 (Miso4217,CodCom,MontoCom,BMUsucodigo)
                        values ('#rsMonedaL.Miso4217#','COMPPC',#prontopagoCliente#,#GvarUsucodigo#)
                    </cfquery>
                </cfif>
                <!---Volumen--->
                <cfif GvarCalculoVol and isdefined("montoVolumenGN") and montoVolumenGN gt 0>
                    <cfquery datasource="#GvarConexion#">
                        <!---insert into #LvarOE# (Miso4217, COMcodigo, Monto)--->
                        insert into sif_interfaces..OE719 (Miso4217,CodCom,MontoCom,BMUsucodigo)
                        values ('#rsMonedaL.Miso4217#','COMVOLGN',#montoVolumenGN#,#GvarUsucodigo#)
                    </cfquery>
                </cfif>
				<!---Volumen Radio--->
				<cfif GvarCalculoVolR and isdefined("montoVolumenR") and montoVolumenR gt 0>
                    <cfquery datasource="#GvarConexion#">
                        <!---insert into #LvarOE# (Miso4217, COMcodigo, Monto)--->
                        insert into sif_interfaces..OE719 (Miso4217,CodCom,MontoCom,BMUsucodigo)
                        values ('#rsMonedaL.Miso4217#','COMVOLGLR',#montoVolumenR#,#GvarUsucodigo#)
                    </cfquery>
                </cfif>
                <!---Volumen Radio Especial--->
                <cfif GvarCalculoVolRE and isdefined("montoVolumenRE") and montoVolumenRE gt 0>
                    <cfquery datasource="#GvarConexion#">
                        <!---insert into #LvarOE# (Miso4217, COMcodigo, Monto)--->
                        insert into sif_interfaces..OE719 (Miso4217,CodCom,MontoCom,BMUsucodigo)
                        values ('#rsMonedaL.Miso4217#','COMVOLGLRESP',#montoVolumenRE#,#GvarUsucodigo#)
                    </cfquery>
                </cfif>
                <!---Agencia--->
                <cfif GvarCalculoAge and isdefined("agenciaM") and agenciaM gt 0>
                    <cfquery datasource="#GvarConexion#">
                        <!---insert into #LvarOE# (Miso4217, COMcodigo, Monto)--->
                        insert into sif_interfaces..OE719 (Miso4217,CodCom,MontoCom,BMUsucodigo)
                        values ('#rsMonedaL.Miso4217#','COMAGE',#agenciaM#,#GvarUsucodigo#)
                    </cfquery>
                </cfif>
            <cfelse>
                <cfif arguments.comVol>
                    <cfquery name="rsUpdComi" datasource="#GvarConexion#">
                        update COMEDocumentos set COMEindCVG = 'E' <!---Excepcion---> where COMEDid = #rsFact.COMEDid#
                    </cfquery>
                </cfif>
            </cfif>
            
            <!---Resultados--->
            <cfquery name="rsInsertComi" datasource="#GvarConexion#">
                insert into COMCalculoRes (
                    COMEDid,		CCTcodigo, 		Ddocumento,			Ecodigo,	
                    COMCalculo,		COMCalculoDet,  ProntoPagoCliInd,	ProntoPagoCDet,   
                    ProntoPagoInd,	ProntoPagoDet,	VolumenGNInd,		VolumenGNDet,
                    VolumenGLRInd,  VolumenGLRDet,	VolumenGLREInd,		VolumenGLREDet,
					AgenciaInd,     AgenciaDet,		comVol,             interfaz,	
                    BMUsucodigo,    fecha      
                    )
                values(
                    #rsFact.COMEDid#,
                    '#query.CCTcodigo#',
                    '#query.Ddocumento#',
                    #GvarEcodigo#,
                    <cfqueryparam cfsqltype="cf_sql_bit" value="#GvarCalculo#">,
                    '#GvarCalculoRes#',
                    <cfqueryparam cfsqltype="cf_sql_bit" value="#GvarCalculoPPC#">,
                    '#GvarCalculoPPCRes#',
                    <cfqueryparam cfsqltype="cf_sql_bit" value="#GvarCalculoPP#">,
                    '#GvarCalculoPPRes#',
                    <cfqueryparam cfsqltype="cf_sql_bit" value="#GvarCalculoVol#">,
                    '#GvarCalculoVolRes#',
                    <cfqueryparam cfsqltype="cf_sql_bit" value="#GvarCalculoVolR#">,
                    '#GvarCalculoVolRRes#',
                    <cfqueryparam cfsqltype="cf_sql_bit" value="#GvarCalculoVolRE#">,
                    '#GvarCalculoVolRERes#',
                    <cfqueryparam cfsqltype="cf_sql_bit" value="#GvarCalculoAge#">,
                    '#GvarCalculoAgeRes#',
                    <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.comVol#">,
                    <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.interfaz#">,
                    #session.Usucodigo#,
                    #now()#
                )
            </cfquery>

	  </cfoutput>

        <cfif arguments.Debug>
            <cf_dump var="Se para el debug"><br>
        </cfif>
    </cffunction>
	
	<!---
		Metodo: 
			getValidEmpresa
		Resultado:
			Verifica el codigo de la Empresa enviado sea correcto.
			Si no encuentra un valor, aborta el proceso.
	--->
	<cffunction access="private" name="getValidEmpresa" output="no" returntype="numeric">
		<cfargument name="Ecodigo"   required="yes" type="numeric">
		
        <cfquery name="rsEmpresa" datasource="#GvarConexion#">
			select Ecodigo
            from Empresas 
            WHERE Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		</cfquery>
        
		<cfif rsEmpresa.recordcount EQ 0 >
			<cfthrow message="Error en Interfaz 719. No se encontro la Empresa con el codigo #Arguments.Ecodigo#, por la tanto no se puede continuar con el proceso de calculo de Comision. Proceso Cancelado!.">
		</cfif>
		<cfreturn rsEmpresa.Ecodigo>
	</cffunction>
    
    <!---
		Metodo: 
			getValidTransaccion
		Resultado:
			Verifica que el codigo de la transaccion dada en la interfaz
			sea correcto, si no encuentra un valor, aborta el proceso.
	--->
	<cffunction access="private" name="getValidTransaccion" output="no" returntype="string">
		<cfargument name="CCTcodigo" required="yes" type="string">
		<cfargument name="Ecodigo" required="yes" type="numeric">
        
        <cfquery name="rsTran" datasource="#GvarConexion#">
			select CCTcodigo, CCTtipo
            from CCTransacciones
			where CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CCTcodigo)#">
            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		</cfquery>
		<cfif rsTran.recordcount EQ 0 >
			<cfthrow message="Error en Interfaz 719. La Transacci&oacute;n es inv&aacute;lida, El C&oacute;digo indicado no corresponde a ninguna Transacci&oacute;n v&aacute;lida en la Empresa. Proceso Cancelado!.">
		</cfif>
		<cfreturn rsTran.CCTcodigo>
	</cffunction>
    
	<!---
		Metodo: 
			getValidSNegocios
		Resultado:
			Devuelve el id asociado al codigo de Socio de Negocio de la Orden de Pago dada por la interfaz.
			Si no encuentra un valor, aborta el proceso.
	--->
	<cffunction access="private" name="getValidSNegocios" output="no" returntype="query">
		<cfargument name="SNnumero" required="yes" type="string">
        <cfargument name="Ecodigo" required="yes" type="numeric">
	
        <cfquery name="rsSNegocios" datasource="#GvarConexion#">
			select a.SNid, a.SNcodigo, b.ESNcodigo as estadoSocio
            from SNegocios a
            inner join EstadoSNegocios b
				on a.ESNid = b.ESNid 
                and a.Ecodigo = b.Ecodigo
			where a.SNnumero = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.SNnumero)#">
            and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">			
		</cfquery>
        <cfif rsSNegocios.recordcount EQ 0 >
        	 <cfquery name="rsNombre" datasource="#GvarConexion#">
                select Edescripcion from Empresas where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
            </cfquery>
			<cfthrow message="Error en Interfaz 719. El N&uacute;mero del Socio de Negocio no corresponde con ningun socio en la Empresa #rsNombre.Edescripcion#. Proceso Cancelado!.">
		</cfif>
		<cfreturn rsSNegocios>
	</cffunction>
	<!---
		Metodo: 
			getValidMcodigo
		Resultado:
			Devuelve el Mcodigo asociado al Miso4217 dada por la interfaz.
			Si no encuentra un valor, aborta el proceso.
	--->
	<cffunction access="private" name="getValidMcodigo" output="no" returntype="query">
		<cfargument name="Miso4217" required="yes" type="string">
        <cfargument name="Ecodigo" required="yes" type="numeric">
		<cfquery name="query" datasource="#GvarConexion#">
			select Mcodigo, Miso4217
			from Monedas 
            where Miso4217 = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.Miso4217)#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		</cfquery>
		<cfif query.recordcount EQ 0 >
			<cfthrow message="Error en Interfaz 719. El C&oacute;digo de la Moneda de la Cuenta no corresponde con ninguna moneda en la Empresa. Proceso Cancelado!.">
		</cfif>
		<cfreturn query>
	</cffunction>
	
	<!---
		Metodo: 
			getValidFecha
		Resultado:
			Devuelve una Fecha de Documento Valida
	--->
	<cffunction access="private" name="getValidFecha" output="no" returntype="date">
		<cfargument name="Fecha" required="yes" type="date">
		<cfif Arguments.Fecha lt GvarMinFecha or Arguments.Fecha gt DateAdd('yyyy',99,GvarMinFecha)>
			<cfthrow message="Error en Interfaz 719. FechaDocumeno es inv&aacute;lido, La Fecha del Documento no es v&aacute;lida en la Empresa #GvarEnombre#. Proceso Cancelado!.">
		</cfif>
		<cfreturn Arguments.Fecha>
	</cffunction>
	
    <!---
		Metodo:
			getTipoCambio
		Resultado:
			Obtiene el Tipo de cambio de la moneda indicada en la fecha indicada,
			la moneda esperada es en codigo Miso4217
	--->
	<cffunction access="private" name="getValidTipoCambio" output="no" returntype="query"> 
	  <cfargument name="Mcodigo" required="yes" type="numeric">
	  <cfargument name="Fecha" required="no" type="date" default="#now()#">
      <cfargument name="Ecodigo" required="yes" type="numeric">
	  <cfset var retTC = 1.00>
	  <cfquery name="rsTC" datasource="#GvarConexion#">
		   select 
		   		coalesce(h.TCcompra,1) as TCcompra,
				coalesce(h.TCventa,1)  as TCventa
		   from Htipocambio h
		   where h.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		     and h.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mcodigo#">
		     and h.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Fecha#">
		     and h.Hfecha = (
		     select max(h2.Hfecha)
		     from Htipocambio h2
		     where h2.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		       and h2.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mcodigo#">
		       and h2.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Fecha#">)
 	 </cfquery>
 	 <cfif isdefined('rsTC') and rsTC.recordCount GT 0>
	 	<cfset retTC = rsTC.TCcompra>
	 </cfif>
 	 <cfreturn rsTC>
  </cffunction>

	   
</cfcomponent>
