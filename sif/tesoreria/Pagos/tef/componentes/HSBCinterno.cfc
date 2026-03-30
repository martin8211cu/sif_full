<cfcomponent output="no">
	<cffunction name="Verificar" output="no" access="public" returntype="void">
		<cfargument name="TESTLid"		type="numeric">
		<cfargument name="TESTLdatos"	type="string">
		<cfargument name="TESTGid"		type="numeric">
		
	</cffunction>
		

	<cffunction name="Generar" output="no" access="public" returntype="struct">
		<cfargument name="TESTLid"			type="numeric">
        
        <cf_dbtemp name="Datos" returnvariable="DatosBAC" datasource="#session.dsn#">
            <cf_dbtempcol name="TipoCuenta" 		type="char(3)" mandatory="no">
            <cf_dbtempcol name="CuentaBancaria"		type="char(17)" mandatory="no">
            
            <cf_dbtempcol name="Fijo"   			type="char(2)" mandatory="no">
            <cf_dbtempcol name="Monto"				type="char(18)" mandatory="no">			
            <cf_dbtempcol name="Beneficiario"		type="char(60)" mandatory="no">
            <cf_dbtempcol name="Cedula"  			type="char(20)" mandatory="no">
            <cf_dbtempcol name="Referencia"			type="char(60)" mandatory="no">
            <cf_dbtempcol name="Fijo2"   			type="char(1)" mandatory="no">
        </cf_dbtemp>
        
		<cfset LvarFecha	= createODBCDate(now())>
        <cfset LvarResult = structNew()>
		<cfset LvarResult.FileName = "TEF-HSBC-interno" & DateFormat(LvarFecha, "YYYYMMDD") &".txt">
		<cfset LvarResult.File = expandPath("./") & getTickCount() & ".tmp">
		<cfset LvarResult.HayError = false>
		<cfset LvarError = "">

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
				op.TESOPinstruccion,
				cta.TESTPcuenta,
                cta.TESTPtipoDet,
				b.Bdescripcion, b.BcodigoACH,
				coalesce(c.TESBeneficiarioId,sn.SNidentificacion) as Cedula,
				<!---'Orden de Pago Num:' #_Cat# ---><cf_dbfunction name="to_char" args="op.TESOPnumero"> as descripcion
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
                left join TESbeneficiario c 
					on c.TESBid = cta.TESBid 
                left join SNegocios sn 
                    on sn.SNid = op.SNid      
			where op.TESid	   = #session.Tesoreria.TESid#	
              and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">	 
			  and op.TESTLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TESTLid#">	
			order by op.TESOPnumero
		</cfquery>
		
		<!--- Concatenador --->
        <cf_dbfunction name="OP_concat" returnvariable="CAT" >
        <!--- INSERTA EL DETALLE --->
        <cfloop query="rsTESTD">
        
            <cfset LvarMonto = Mid(rtrim(rsTESTD.TESOPtotalPago),1,13)>
			
            <cfif len(trim(#rsTESTD.TESTPtipoDet#)) eq 0>
            	<cfthrow message="Falta definir el detalle de tipo de cuenta para el socio/beneficiario:#rsTESTD.TESOPbeneficiario# en -> Cuentas Destino para Pago por Transferencia ">
            </cfif>
            <cfquery name="rsInsert" datasource="#session.DSN#">
                insert into #DatosBAC# (
                    TipoCuenta, 
                    CuentaBancaria, 
                    Fijo,
                    Monto, 
                    Beneficiario, 
                    Cedula, 
                    Referencia, 
                    Fijo2 
				)
                values( rtrim('#rsTESTD.TESTPtipoDet#'),
                        '#rsTESTD.TESTPcuenta#',
                        '1',
                        '#rsTESTD.TESOPtotalPago#',
                        '#rsTESTD.TESOPbeneficiario#',
                        '#rsTESTD.Cedula#',
                    	'#rsTESTD.descripcion#',
                        '0'
                )
            </cfquery>
		</cfloop>              
    
        <cfquery name="rsDatos" datasource="#session.DSN#">
            Select  
                    TipoCuenta, 
                    CuentaBancaria, 
                    Fijo,
                    Monto, 
                    Beneficiario, 
                    Cedula, 
                    Referencia, 
                    Fijo2 
            from #DatosBAC#
        </cfquery> 
        <!---Se le agregan mas espacios  excepto al ultimo para que no queden pegados--->
        <cfloop query="rsDatos">
        	<cfset fnCrearLinea(
				fnJustifica('#rsDatos.TipoCuenta#',		6,	'I')&
				fnJustifica('#rsDatos.CuentaBancaria#',	20,	'I')&
				fnJustifica('#rsDatos.Fijo#',			4,	'I')&
				fnJustifica('1',						4,	'I')&
				fnJustifica('#rsDatos.Monto#',			21,	'I')&
				fnJustifica('#rsDatos.Beneficiario#',	63,	'I')&
				fnJustifica('#rsDatos.Cedula#',			23,	'I')&
				fnJustifica('#rsDatos.Referencia#',		10,	'I')&
				fnJustifica('#rsDatos.Fijo2#',			1,	'I')			
				)>
        </cfloop>
		<cfreturn LvarResult>
	</cffunction>
    
    <cffunction name="fnJustifica" output="no" access="private" returntype="string">
        <cfargument name="texto"			type="string">
        <cfargument name="longuitud"		type="numeric">
        <cfargument name="tipo"				type="string">
        
        <cfset LvarTexto= "">
        <cfif Arguments.tipo eq 'I'>
        	<cfset LvarTexto= left(rtrim(Arguments.texto) & repeatstring(' ', Arguments.longuitud),Arguments.longuitud)>
        <cfelseif Arguments.tipo eq 'D'>
        	<cfset LvarTexto= right( repeatstring(' ', Arguments.longuitud) & rtrim(Arguments.texto),Arguments.longuitud)>
        <cfelseif Arguments.tipo eq '0'>
        	<cfset LvarTexto= right( repeatstring('0', Arguments.longuitud) & rtrim(Arguments.texto),Arguments.longuitud)>
        <cfelse>
        	<cfthrow message="La funcion de justificacion necesita ser a la derecha, izquierda o con ceros">
        </cfif>
		
        <cfreturn LvarTexto>
	</cffunction>

    <cffunction name="fnCrearLinea" output="no" access="private" returntype="void">
        <cfargument name="texto"			type="string">
        
        <cfset var LvarTexto = "">
        <cfset LvarTexto &= Arguments.texto>
        <cffile action="append" file="#LvarResult.File#" output="#LvarTexto#" addnewline="yes">
	</cffunction>

	<cffunction name="fnMoneda" output="no" access="private" returntype="string">
		<cfargument name="Miso4217"			type="string">
		<cfif Arguments.Miso4217 EQ "CRC">
			<cfreturn "1">
		<cfelseif Arguments.Miso4217 EQ "USD">
			<cfreturn "2">
		<cfelse>
			<cfthrow message="Codigo de moneda no permitido: #Arguments.Miso4217#">
		</cfif>
	</cffunction>
</cfcomponent>
