<cfcomponent output="no">
	<cffunction name="Verificar" output="no" access="public" returntype="void">
		<cfargument name="TESTLid"		type="numeric">
		<cfargument name="TESTLdatos"	type="string">
		<cfargument name="TESTGid"		type="numeric">

		<cfset LvarTESTGid = #Arguments.TESTGid#>
        <cf_dbfunction name="OP_concat"	returnvariable="_Cat">
        
        <cf_dbtemp name="Datos" returnvariable="Datos" datasource="#session.dsn#">
            <cf_dbtempcol name="detalle"  type="char(255)" mandatory="no">
        </cf_dbtemp>
        
        <cf_dbtemp name="Datos2" returnvariable="Datos2" datasource="#session.dsn#">
			<cf_dbtempcol name="detalle"  type="char(255)" mandatory="no">
		</cf_dbtemp>
        
        
         <!---====== NUMERO ARCHIVO: Calcular el numero de consecutivo de archivo, envio de mas de un archivo el mismo dia ======----->

		<cfset LvarConsecutivo = listGetAt(Arguments.TESTLdatos,1)>
        
		<cfif not isnumeric(LvarConsecutivo)>
			<cfthrow message="El consecutivo para generacion no es numerico">
            <cfabort>
		</cfif>
		<cfif LvarConsecutivo LTE 0 >
            <cfthrow message = "No se puede tener un consecutivo menor a 0, por favor cambie el consecutivo en parametros de generacion TRE">
            <cfabort>
        </cfif>
        <cfif LvarConsecutivo GTE 1000>
            <cfset LvarConsecutivo = 1>
        </cfif>
		<cfset LvarFecha	= createODBCDate(now())>
        
		<cf_dbfunction name="OP_concat" returnvariable="_cat">
		<cfquery name="rsTESTD" datasource="#session.dsn#">
			SELECT 
				td.TESTDid,
				op.TESOPid, 
				op.TESOPnumero, 
				op.TESOPbeneficiarioId,
				op.TESOPbeneficiario #_Cat# coalesce(op.TESOPbeneficiarioSuf,'') as TESOPbeneficiario, 
				op.Miso4217Pago, 
				op.TESOPtotalPago,
				op.TESOPinstruccion,
				cta.TESTPcuenta,
				b.Bdescripcion, b.BcodigoACH
                ,'Orden de Pago Num:' #_Cat# <cf_dbfunction name="to_char" args="op.TESOPnumero"> as descripcion
			 FROM TESordenPago op
				inner join CuentasBancos cb
					 on cb.CBid = op.CBidPago
				inner join TEStransferenciasD td
					 on td.TESid 	= op.TESid
					and td.TESOPid 	= op.TESOPid
					and td.TESTLid	= op.TESTLid
				inner join TEStransferenciaP cta
					 on cta.TESid 	= op.TESid
					and cta.TESTPid	= op.TESTPid
				inner join Bancos b
					 on b.Bid = cta.Bid
			where op.TESid	   = #session.Tesoreria.TESid#	
              and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">	 
			  and op.TESTLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TESTLid#">	
			order by op.TESOPnumero
		</cfquery>
 		<cfloop query="rsTESTD">
            <!--- CUENTA EMPLEADO: LONGITUD: 17 CARACTERES Y QUE SEA NUMERICO> --->
			<cfif len(trim(rsTESTD.TESTPcuenta)) neq 17>
                <cfthrow message="La cuenta #rsTESTD.TESTPcuenta# no tiene la longitud de 17 caracteres ">
            </cfif>
            <cfif not isnumeric(rsTESTD.TESTPcuenta)>
                <cfthrow message=" La Cuenta #rsTESTD.TESTPcuenta# debe contener unicamente digitos numerico">
            </cfif>
		</cfloop>
          <cfquery name="rsMontoTotal" datasource="#session.dsn#">
            select sum(coalesce(<cf_dbfunction name="to_number" args="(TESOPtotalPago) * 100">,0)) as Monto
            from TESordenPago op
            where op.TESid	   = #session.Tesoreria.TESid#	
              and op.TESTLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TESTLid#">
        </cfquery>
        <cfif rsTESTD.Miso4217Pago eq'CRC'>
        	<cfset moneda = '01'>
        <cfelse>
        	<cfset moneda = '02'>
        </cfif>

	</cffunction>
		

	<cffunction name="Generar" output="no" access="public" returntype="struct">
		<cfargument name="TESTLid"			type="numeric">
        
        <cfset LvarResult = structNew()>
		<cfset LvarResult.FileName = "TEF-BNCR-SINPE" & LvarConsecutivo &".tef">
		<cfset LvarResult.File = expandPath("./") & getTickCount() & ".tmp">
		<cfset LvarResult.HayError = false>
		<cfset LvarError = "">
        
		<!--- 1- Registro Tipo 1 - Encabezado --->	

		<cfquery name="cuentas" datasource="#session.dsn#">			
		insert into #Datos# (detalle)
			select 
		        '1' 		#_Cat#            																<!--- Tipo de Registro (siempre es 1) --->
				'000000000008275' 	#_Cat# 																	<!--- Identificacion unica de cliente 15 digitos--->
                '2' 	#_Cat# 																				<!--- Tipo identificacion del cliente --->
                '000300756620900' 	#_Cat# 																	<!--- Identificacion del cliente --->
				'#LSDateFormat(now(),'ddmmyyyy')#' #_Cat#     												<!--- Fecha procesamiento --->
                RIGHT('00000' #_Cat#('#LvarConsecutivo#'),5) #_Cat# 			 							<!--- Numero de trasferencia --->
                '1'       #_Cat# 			 																<!--- Tipo Transaccion--->	
                <cf_dbfunction name="sRepeat"	args="'0',4"         datasource="#session.dsn#">  #_Cat#   	<!--- Cóigo de error SFB--->
                <cf_dbfunction name="sRepeat"	args="'0',4"         datasource="#session.dsn#">  #_Cat#   	<!--- Código de error SINPE-Canales--->
                <cf_dbfunction name="sRepeat"	args="'0',16"         datasource="#session.dsn#">  #_Cat#   <!--- Monto total aplicado SFB--->
                <cf_dbfunction name="sRepeat"	args="'0',16"         datasource="#session.dsn#">  #_Cat#   <!--- Monto total aplicado SINPE--->
                <cf_dbfunction name="sRepeat"	args="'0',7"         datasource="#session.dsn#">  #_Cat#   	<!--- Tipo Compra--->
                <cf_dbfunction name="sRepeat"	args="'0',7"         datasource="#session.dsn#">  #_Cat#   	<!--- Tipo venta---> 
				RIGHT('0000000000000000' #_Cat#('#rsMontoTotal.Monto#'),16) #_Cat# 			 				<!--- Sumatoria de Montos--->
              	'0000000000' 																				<!--- Sumatoria de Correlativos--->
			    as salida
				from dual				
		</cfquery>	
        
		<!--- 2- Registro del Debito (una sola linea, del patrono ) --->	
        
		<!----======= NUMERO DE CUENTA : Cuenta que debita ==========---->
        <cfquery name="rsCuenta" datasource="#session.dsn#">
            select ltrim(rtrim(CBcodigo)) as Cuenta, <!---Se utilizaba el CBcc pero al parecer no se usa el simpe sino el interno--->
                #Arguments.TESTLid# as documento,
                'Pago Superintendencia de Telecomunicaciones  (SUTEL)' as razon
            FROM TESordenPago op
            inner join CuentasBancos a
                 on a.CBid = op.CBidPago
            where op.TESid	   = #session.Tesoreria.TESid#	
            and a.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">	 
            and op.TESTLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TESTLid#">
        </cfquery>
		<!--- CUENTA DE DONDE SE DEBITA: LONGITUD: 17 CARACTERES Y QUE SEA NUMERICO>
		<cfif len(trim(rsCuenta.Cuenta)) neq 17>
            <cfthrow message="La Cuenta a debitar #rsCuenta.Cuenta# no tiene la longitud de 17 caracteres ">
        </cfif> --->
        <cfset  rsCuenta.Cuenta = replace("#rsCuenta.Cuenta#","-","","All")>
        <cfif not isnumeric(rsCuenta.Cuenta)>
            <cfthrow message="La Cuenta a debitar  #rsCuenta.Cuenta# debe contener unicamente digitos numerico">
        </cfif>

		<!---============ SUMA DE LOS MONTOS A ACREDITAR POR CADA OP (REGISTROS DE DETALLE)(Total a debitar) ==============---->
        <cfquery name="rsMonto" datasource="#session.dsn#">
            select sum(coalesce(<cf_dbfunction name="to_number" args="(TESOPtotalPago) * 100">,0)) as Monto
            from TESordenPago op
            where op.TESid	   = #session.Tesoreria.TESid#	
              and op.TESTLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TESTLid#">
        </cfquery>

	    <cfquery name="cuentas" datasource="#session.dsn#">
			insert into #Datos# (detalle)
			select 	'2' #_Cat#       																		<!--- 2=Debito ---->
            	'00001' #_Cat# 		    																	<!--- Numero de la linea comienza en 1 - 5 digit---->
                '1' #_Cat# 		    																		<!--- Tipo de cuenta  ---->
				RIGHT('00000000000000000' #_Cat#('#rsCuenta.Cuenta#'),17) #_Cat# 							<!--- Numero de cuenta 17 digit---->
				'00000001'  #_Cat#   																		<!--- Numero de comprobante 8 digit---->
				RIGHT('000000000000000' #_Cat#('#rsMonto.Monto#'),15) #_Cat# 								<!--- Monto incluido decimales 15 digit---->
				'#moneda#' #_Cat# 																			<!--- Monoda monto 01-colones 02-dolares ---->
				LEFT('#rsCuenta.razon#' #_Cat# '                                             ',45) #_Cat#	<!--- Concepto 45 digitos  ---->
				'00'																						<!--- Estado del registro siempre 00  ----> 	
				as salida
			from dual
		</cfquery>	
        	
		<!--- 3- Registro de los Creditos  (una linea por cada proveedor) --->
        <cf_dbfunction name="OP_concat" returnvariable="_cat">
        
		<cfquery name="rsTESTD" datasource="#session.dsn#">
			SELECT 
            	cb.CBcc,
				td.TESTDid,
                op.SNid,
                op.TESBid,
                td.TESTDfechaGeneracion,
				op.TESOPid, 
				op.TESOPnumero, 
				op.TESOPbeneficiarioId,
				op.TESOPbeneficiario #_Cat# coalesce(op.TESOPbeneficiarioSuf,'') as TESOPbeneficiario, 
				op.Miso4217Pago, 
				op.TESOPtotalPago,
                <cf_dbfunction name="to_number" args="(op.TESOPtotalPago) * 100"> as monto,
				op.TESOPinstruccion,
				cta.TESTPcuenta,
				b.Bdescripcion, b.BcodigoACH,b.Bid
                ,'Orden de Pago Num:' #_Cat# <cf_dbfunction name="to_char" args="op.TESOPnumero"> as descripcion
			 FROM TESordenPago op
				inner join CuentasBancos cb
					 on cb.CBid = op.CBidPago
				inner join TEStransferenciasD td
					 on td.TESid 	= op.TESid
					and td.TESOPid 	= op.TESOPid
					and td.TESTLid	= op.TESTLid
				inner join TEStransferenciaP cta
					 on cta.TESid 	= op.TESid
					and cta.TESTPid	= op.TESTPid
				inner join Bancos b
					 on b.Bid = cta.Bid
			where op.TESid	   = #session.Tesoreria.TESid#	
              and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">	 
			  and op.TESTLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TESTLid#">	
			order by op.TESOPnumero
		</cfquery>

		
        <cfset LvarSumaCuenta= mid(#rsCuenta.Cuenta#,9,6)>
        <cfset numerolinea = 2>
        <cfloop query="rsTESTD">
           	<cfif len(trim(rsTESTD.TESBid)) eq 0 >
                    <cfquery name="rsBeneficia" datasource="#session.dsn#">
                          select SNtipo, SNidentificacion from SNegocios  where SNid = #rsTESTD.SNid#
                    </cfquery>
            <cfelse>
                <cfquery name="rsBeneficia" datasource="#session.dsn#">
                      select TESBtipoId as SNtipo, TESBeneficiarioId  as SNidentificacion  from TESbeneficiario where TESBid = #rsTESTD.TESBid#
                </cfquery>
            </cfif>
            <cfif rsBeneficia.recordcount eq 0>
                <cfthrow message="La Cuenta a debitar  #rsCuenta.Cuenta# falta configurar los datos de identifacion del beneficiario, como identificacion y tipo">
            </cfif>
				<cfif rsBeneficia.SNtipo eq 'F'>
                        <cfset IDbene = 1>
                    <cfelseif rsBeneficia.SNtipo eq 'J'>
                        <cfset IDbene = 2>
                     <cfelse>
                        <cfset IDbene = 3>
                     </cfif>
                     <cfset IDentificacion = replace("#rsBeneficia.SNidentificacion#","-","","ALL")>
                     <cfset IDentificacion = trim("#IDentificacion#")>
            <cfquery name="cuentas" datasource="#session.dsn#">
                insert into #Datos# (detalle)
                select 	
                   '3'  #_Cat#          																		<!--- 3=Credito    ---->
                   RIGHT('00000' #_Cat#('#numerolinea#'),5) #_Cat#												<!--- Numero de la linea comienza en 2 - 5 digit---->
                   '2'  #_Cat#   																				<!--- Tipo de la cuenta CC = 2 SBF = 1 ---->
                   '#rsTESTD.TESTPcuenta#' #_Cat#																<!--- Cuenta  ---->
                    '00000001'  #_Cat#   																		<!--- Numero de comprobante  ---->
                    RIGHT('000000000000000'#_Cat#('#rsTESTD.monto#'),15) #_Cat#   								<!--- Monto de cada linea---->  
                    '#moneda#' #_Cat# 																			<!--- Moneda 01-colones 02-dolares ---->
                    LEFT('#rsTESTD.descripcion#' #_cat# '                                             ',45) #_Cat#  <!--- Concepto ----> 
                    '00' #_Cat#																		<!--- Estado del registro 00 ----> 
                    '#IDbene#' #_Cat#																<!--- ID Benefi 1 fisica 2 juridica 3 extranje ----> 
                    RIGHT('000000000000000'#_Cat#('#IDentificacion#'),15) #_Cat#						<!--- ID Beneficiario ----> 
                    LEFT('#rsTESTD.descripcion#' #_cat# '                    ',20) 					<!--- detalle especial ----> 
                     as Salida
                from dual
            </cfquery>
             <cfset numerolinea = numerolinea +1>
            <cfset LvarSumaCuenta= #LvarSumaCuenta# + mid(#rsTESTD.TESTPcuenta#,9,6)>
		</cfloop>	
        
       
		<cfquery name="ERR" datasource="#session.DSN#">
		   select detalle from #Datos#
		</cfquery>			
                
        <cfloop query="ERR">
            <cfset fnCrearLinea(trim(#ERR.detalle#))>
        </cfloop>	

		<cfset LvarConsActua = #LvarConsecutivo# + 1>
        <cfquery name="rsSQL" datasource="#session.dsn#">
            update TEStransferenciaG2
            set TESTGvalor = '#LvarConsActua#'
             where TESTGid		= #LvarTESTGid#
               and Ecodigo		= #session.Ecodigo#
               and TESTGdato	= 'Consecutivo'
               and TESTGtipo	= 'L'
		</cfquery>

        
		<cfreturn LvarResult>
	</cffunction>
    

    <cffunction name="fnCrearLinea" output="no" access="private" returntype="void">
        <cfargument name="texto"			type="string">
        
        <cfset var LvarTexto = "">
        <cfset LvarTexto &= Arguments.texto & chr(13) & chr(10)>
        <cffile action="append" file="#LvarResult.File#" output="#LvarTexto#" addnewline="no">
	</cffunction>
</cfcomponent>
