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
            <!--- CUENTA EMPLEADO: LONGITUD: 15 CARACTERES Y QUE SEA NUMERICO> --->
			<cfif len(trim(rsTESTD.TESTPcuenta)) neq 15>
                <cfthrow message="La cuenta #rsTESTD.TESTPcuenta# no tiene la longitud de 15 caracteres ">
            </cfif>
            <cfif not isnumeric(rsTESTD.TESTPcuenta)>
                <cfthrow message=" La Cuenta #rsTESTD.TESTPcuenta# debe contener unicamente digitos numerico">
            </cfif>
		</cfloop>
	</cffunction>
		

	<cffunction name="Generar" output="no" access="public" returntype="struct">
		<cfargument name="TESTLid"			type="numeric">
        
        <cfset LvarResult = structNew()>
		<cfset LvarResult.FileName = "TEF-BNCR-interno" & LvarConsecutivo &".env">
		<cfset LvarResult.File = expandPath("./") & getTickCount() & ".tmp">
		<cfset LvarResult.HayError = false>
		<cfset LvarError = "">
        
        
		<!--- 1- Registro Tipo 1 - Encabezado --->	

		<cfquery name="cuentas" datasource="#session.dsn#">			
		insert into #Datos# (detalle)
			select 
		        '1' 		#_Cat#            																						<!--- Tipo de Registro (siempre es 1) --->
				'003139' 	#_Cat# 																									<!--- siempre es 003139--->
				'#LSDateFormat(now(),'ddmmyyyy')#' #_Cat#     
				RIGHT('000000' #_Cat#('#LvarConsecutivo#'),6) #_Cat# 			 													<!--- Transferencia real--->
                RIGHT('000000' #_Cat#('#LvarConsecutivo#'),6) #_Cat#																<!--- Transferencia interna--->
				'1'       #_Cat# 			 																						<!--- Tipo de Transferencia  (1=1 Deb  a N Creditos)--->				
				<cf_dbfunction name="sRepeat"	args="'0',4"         datasource="#session.dsn#">  #_Cat#   							<!--- CÃ³digo de error--->
				<cf_dbfunction name="sRepeat"	args="'0',12"        datasource="#session.dsn#">  #_Cat#   							<!--- Total transferencia--->
				<cf_dbfunction name="sRepeat"	args="'0',7"         datasource="#session.dsn#">  #_Cat#   							<!--- Tipo de Cambio Compra--->
				<cf_dbfunction name="sRepeat"	args="'0',7"         datasource="#session.dsn#">  #_Cat#   							<!--- Tipo de Cambio Venta--->
				<cf_dbfunction name="sRepeat"	args="'0',10"        datasource="#session.dsn#">   						         	<!--- Fijo 10 ceros --->
			    as salida
				from dual				
		</cfquery>	
        
		<!--- 2- Registro del Debito (una sola linea, del patrono ) --->	
        
		<!----======= NUMERO DE CUENTA : Cuenta que debita ==========---->
        <cfquery name="rsCuenta" datasource="#session.dsn#">
            select ltrim(rtrim(CBcodigo)) as Cuenta, <!---Se utilizaba el CBcc pero al parecer no se usa el simpe sino el interno--->
                #Arguments.TESTLid# as documento,
                'Pago grupo Nacion' as razon
            FROM TESordenPago op
            inner join CuentasBancos a
                 on a.CBid = op.CBidPago
            where op.TESid	   = #session.Tesoreria.TESid#	
            and a.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">	 
            and op.TESTLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TESTLid#">
        </cfquery>
		<!--- CUENTA DE DONDE SE DEBITA: LONGITUD: 15 CARACTERES Y QUE SEA NUMERICO> --->
		<!---<cfif len(trim(rsCuenta.Cuenta)) neq 15>
            <cfthrow message="La Cuenta a debitar #rsCuenta.Cuenta# no tiene la longitud de 15 caracteres ">
        </cfif>--->
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
			select 	'2' #_Cat#       																							<!--- 2=Debito   3=Credito   ---->			    
				<cf_dbfunction name="sPart"	 args="'#rsCuenta.Cuenta#',6,3" datasource="#session.dsn#" > #_Cat#  					<!--- Oficina de apertura de cta ---->
				<cf_dbfunction name="sPart"	 args="'#rsCuenta.Cuenta#',1,3" datasource="#session.dsn#" > #_Cat#	   				<!--- 100=Cta Corr   200=Cta Ahorros  300=Cta Electr ---->
				<cf_dbfunction name="sPart"	 args="'#rsCuenta.Cuenta#',4,2" datasource="#session.dsn#" > #_Cat# 					<!--- 01=Colones   02=Dolares ---->
				<cf_dbfunction name="sPart"	 args="'#rsCuenta.Cuenta#',9,7" datasource="#session.dsn#" > #_Cat# 	<!--- Cta empresa con digito verificador ---->
				'00000001' #_Cat#       																						<!--- Numero de comprobante siempre 00000001  ---->
				RIGHT('000000000000' #_Cat#('#rsMonto.Monto#'),12) #_Cat# 														<!--- Total de salarios a pagar  ----> 	
				' '#_Cat#  
				LEFT('#rsCuenta.razon#' #_Cat# '                              ',29) #_Cat# 										<!---- Concepto de pago  ----> 				 			
				'00'
				as salida
			from dual
		</cfquery>	
        	
		<!--- 3- Registro de los Creditos  (una linea por cada proveedor) --->
        <cf_dbfunction name="OP_concat" returnvariable="_cat">
        
		<cfquery name="rsTESTD" datasource="#session.dsn#">
			SELECT 
            	cb.CBcc,
				td.TESTDid,
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
        <cfloop query="rsTESTD">
            <cfquery name="cuentas" datasource="#session.dsn#">
                insert into #Datos# (detalle)
                select 	
                    '3'  #_Cat#          																				<!--- 2=Debito   3=Credito    ---->
                    <cf_dbfunction name="sPart"	 args="'#rsTESTD.TESTPcuenta#',6,3" datasource="#session.dsn#">  #_Cat#   <!----Oficina de apertura de cta  substring(c.DEcuenta,6,3)  ---->
                    <cf_dbfunction name="sPart"	 args="'#rsTESTD.TESTPcuenta#',1,3" datasource="#session.dsn#">  #_Cat#	<!--- 100=Cta Corr   200=Cta Ahorros  300=Cta Electr-- 01=Colones   02=Dolares  ---->
                    <cf_dbfunction name="sPart"	 args="'#rsTESTD.TESTPcuenta#',4,2" datasource="#session.dsn#">  #_Cat# <!--- 01=Colones   02=Dolares  ---->
                    <cf_dbfunction name="sPart"	 args="'#rsTESTD.TESTPcuenta#',9,6" datasource="#session.dsn#">  #_Cat# <!--- Cta empl. sin digito verificador  ---->
                    <cf_dbfunction name="sPart"	 args="'#rsTESTD.TESTPcuenta#',15,1" datasource="#session.dsn#">  #_Cat#	<!--- Cta empl (solo el digito verificador)   ---->
                    '00000001'  #_Cat#   																				<!--- cedula = comprobante  ---->
                    RIGHT('000000000000' #_Cat#('#rsTESTD.monto#'),12) #_Cat#   							<!--- Monto de cada linea---->  
                    ' '#_Cat#
                    LEFT('#rsTESTD.descripcion#' #_cat# '                                                 ',29) #_Cat#  <!---- Concepto de pago ----> 
                    '00' as Salida
                from dual
            </cfquery>
            <cfset LvarSumaCuenta= #LvarSumaCuenta# + mid(#rsTESTD.TESTPcuenta#,9,6)>
		</cfloop>	
        
        				
		<!--- 4- Linea de Totales --->		
        
		<cfset suma_cuentas = #LvarSumaCuenta#>
        <cfset totalSumas = #rsMonto.Monto#*2>
        
		<cfif len(trim(suma_cuentas))  >
		<!---- El campo rsMonto.Monto es la sumatoria de los débitos y los créditos , al duplicarse genera un monto q incluye el debito + el credito por partida doble   	     
		      ----->   
        <cfquery name="cuentas" datasource="#session.dsn#">
            insert into #Datos# (detalle)
              select 
                '4' #_Cat#             										<!--- Tipo de Registro (siempre es 4)   --->
                RIGHT('000000000000000' #_Cat# ('#totalSumas#'),15) #_Cat#	<!--- Suma de montos    --->                      
                RIGHT('0000000000' #_Cat# '#suma_cuentas#',10) #_Cat#    	<!--- Suma de cuentas sin digito verificador   ---> 
				'0000000000'   		#_Cat# 									<!--- 10 ceros Lugar para el testkey (lo calcula el programa del cliente)   --->	
                '000000000000'   	#_Cat#  								<!--- 12 ceros Monto en dolares (colones x TC compra   --->	
                '000000000000'   	#_Cat#									<!--- 12 ceros Monto en colones     --->	
                '00000000'           										<!--- N/A--->	
                as salida
        	from dual
        </cfquery>
		<cfelse>
			<cfthrow message="Error Procesando Exportador del Banco Nacional, solicite soporte del producto al proveedor de Servicio">
		</cfif>	
			
       
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
