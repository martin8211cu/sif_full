<cfcomponent output="no">
	<cffunction name="Verificar" output="no" access="public" returntype="void">
		<cfargument name="TESTLid"		type="numeric">
		<cfargument name="TESTLdatos"	type="string">
		<cfargument name="TESTGid"		type="numeric">
		
        <cfset LvarTESTGid = Arguments.TESTGid>

		<!--- Consecutivo de Archivo--->
        <cfset LvarConsecutivoColones = listGetAt(Arguments.TESTLdatos,1)>
		<cfset LvarConsecutivoDolares = listGetAt(Arguments.TESTLdatos,2)>

		<cfif not isnumeric(LvarConsecutivoColones)>
			<cfthrow message="El consecutivo en colones para generacion no es numerico">
            <cfabort>
		</cfif>
		<cfif LvarConsecutivoColones LTE 0 >
            <cfthrow message = "No se puede tener un consecutivo menor a 0, por favor cambie el consecutivo en colones en parametros de generacion TRE">
            <cfabort>
        </cfif>
       
        
		<cfif not isnumeric(LvarConsecutivoDolares)>
			<cfthrow message="El consecutivo en dolares para generacion no es numerico">
            <cfabort>
		</cfif>
		<cfif LvarConsecutivoDolares LTE 0 >
            <cfthrow message = "No se puede tener un consecutivo menor a 0, por favor cambie el consecutivo en dolares en parametros de generacion TRE">
            <cfabort>
        </cfif>
       

		<cfset LvarPlanColones	= fnLeerDato(Arguments.TESTGid,"Numero plan colones")>	<!--- Viene de Parametros generacion TRE --->
		<cfset LvarPlanDolares	= fnLeerDato(Arguments.TESTGid,"Numero plan dolares")>	<!--- Viene de Parametros generacion TRE  --->
		<cfset LvarFecha	= createODBCDate(now())>
        
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


	</cffunction>
		
	<cffunction name="fnLeerDato" output="no" returntype="string">
		<cfargument name="TESTGid"		type="numeric">
		<cfargument name="TESTGdato">
	
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select TESTGvalor
			  from TEStransferenciaG2
			 where TESTGid		= #Arguments.TESTGid#
			   and Ecodigo		= #session.Ecodigo#
			   and TESTGdato	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TESTGdato#">
			   and TESTGtipo	= 'E'
			 order by TESTGsec
		</cfquery>
		<cfif trim(rsSQL.TESTGvalor) EQ "">
			<cfthrow message="No se ha parametrizado '#Arguments.TESTGdato#' en parámetros Generación TRE">
		</cfif>

		<cfreturn trim(rsSQL.TESTGvalor)>
	</cffunction>

	<cffunction name="Generar" output="no" access="public" returntype="struct">
		<cfargument name="TESTLid"			type="numeric">
        
        <cf_dbtemp name="Datos" returnvariable="DatosBAC" datasource="#session.dsn#">
            <cf_dbtempcol name="NumRegistro"  		type="numeric" identity="yes">
            <cf_dbtempcol name="TipoRegistro" 		type="char(1)" mandatory="no">
            <cf_dbtempcol name="NumeroPlan"   		type="char(4)" mandatory="no">	
            <cf_dbtempcol name="NumeroEnvio"  		type="char(5)" mandatory="no">			
            <cf_dbtempcol name="CuentaBancaria"		type="char(20)"  mandatory="no">
            <cf_dbtempcol name="NumeroRegistro"  	type="char(5)" mandatory="no">		
            <cf_dbtempcol name="Periodo"  			type="numeric" mandatory="no">
            <cf_dbtempcol name="Mes"  				type="numeric" mandatory="no">
            <cf_dbtempcol name="Dia"  				type="numeric" mandatory="no">		
            <cf_dbtempcol name="Monto"				type="numeric(18,0)" mandatory="no">			
            <cf_dbtempcol name="TotalRegistros"		type="char(5)" mandatory="no">	
            <cf_dbtempcol name="DescripCobroPago"	type="char(30)" mandatory="no">
            <cf_dbtempcol name="CodigoError"		type="char(1)" mandatory="no">
            <cf_dbtempcol name="NombreBeneficiario"	type="char(60)" mandatory="no">
        
            <cf_dbtempkey cols="NumRegistro">
        </cf_dbtemp>

		<cfset LvarMoneda= fnMoneda(rsTESTD.Miso4217Pago)>
        <cfif LvarMoneda eq 01> 
        	<cfset LvarConsecutivo=#LvarConsecutivoColones#>
        <cfelseif LvarMoneda eq 02>
        	<cfset LvarConsecutivo=#LvarConsecutivoDolares#>
        </cfif>

        <cfset LvarResult = structNew()>
		<cfset LvarResult.FileName = "TEF-BAC-interno" & LvarConsecutivo &".txt">
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
		
		<!--- Número de Plan (tipo de contrato con el BAC es parametrizado y depende de la moneda) --->
       	
		<cfset LvarMoneda= fnMoneda(rsTESTD.Miso4217Pago)>
        <!---Cuando es Colones--->
        <cfif LvarMoneda eq 1>
        	<cfset LvarNumeroPlan = LvarPlanColones>	<!--- Viene de Parametros generacion TRE --->
		<!---Cuando es Dolares--->	
        <cfelseif LvarMoneda eq 2>
        	<cfset LvarNumeroPlan= LvarPlanDolares>		<!--- Viene de Parametros generacion TRE  --->
        </cfif>
    
        <cfquery name="rsNumReg" datasource="#session.dsn#">
            select count(1) as NumRegistros,sum(TESOPtotalPago) as total
            from TESordenPago op
			where op.TESid	   = #session.Tesoreria.TESid#	
			  and op.TESTLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TESTLid#">
        </cfquery>
    
        <cfset LvarMontoTotal = Mid(rtrim(rsNumReg.total),1,13)>
        <cfset LvarMontoTotal = LvarMontoTotal * 100>
        <cfset LvarNumeroRegistro = 0>
        
		<!--- INSERTA EL ENCABEZADO --->
		<cfquery name="rsInsert" datasource="#session.DSN#">
            insert into #DatosBAC# (
                TipoRegistro, 
                NumeroPlan, 
                NumeroEnvio,
                CuentaBancaria, 
                NumeroRegistro, 
                Periodo, 
                Mes, 
                Dia, 
                Monto, 
                TotalRegistros, 
                DescripCobroPago, 
                CodigoError,
                NombreBeneficiario
                )
            values(	rtrim('B'), 
                    '#LvarNumeroPlan#',
                    '#LvarConsecutivo#',
                    '',
                    '#LvarNumeroRegistro#',
                    #datepart("yyyy",rsTESTD.TESTDfechaGeneracion)#,
                    #datepart("m",rsTESTD.TESTDfechaGeneracion)#,
                    #datepart("d",rsTESTD.TESTDfechaGeneracion)#,
                    #LvarMontoTotal#,
                    '#rsNumReg.NumRegistros#',
                    '',
                    '',
                    ''
				)
    	</cfquery> 
        
		<!--- Concatenador --->
        <cf_dbfunction name="OP_concat" returnvariable="CAT" >
        <!--- INSERTA EL DETALLE --->
        <cfloop query="rsTESTD">
			<cfset LvarNumeroRegistro = LvarNumeroRegistro+1>
            
            <cfset LvarMonto = Mid(rtrim(rsTESTD.TESOPtotalPago),1,13)>
			<cfset LvarMonto = LvarMonto * 100>

            <cfquery name="rsInsert" datasource="#session.DSN#">
                insert into #DatosBAC# (
                    TipoRegistro, 
                    NumeroPlan, 
                    NumeroEnvio,
                    CuentaBancaria, 
                    NumeroRegistro, 
                    Periodo, 
                    Mes, 
                    Dia, 
                    Monto, 
                    TotalRegistros, 
                    DescripCobroPago, 
                    CodigoError,
                    NombreBeneficiario
                    )
                values( rtrim('T'),
                        '#LvarNumeroPlan#',
                        '#LvarConsecutivo#',
                        '#rsTESTD.TESOPbeneficiarioId#',
                        '#LvarNumeroRegistro#',
                        #datepart("yyyy",rsTESTD.TESTDfechaGeneracion)#,
                        #datepart("m",rsTESTD.TESTDfechaGeneracion)#,
                        #datepart("d",rsTESTD.TESTDfechaGeneracion)#,
                        #LvarMonto#,
                        '0',
                    	'#rsTESTD.descripcion#',
                        '',
                        '#rsTESTD.TESOPbeneficiario#' 
                )
            </cfquery>
		</cfloop>              
    
        <cfquery name="rsDatos" datasource="#session.DSN#">
            Select  TipoRegistro, 
                    NumeroPlan, 
                    NumeroEnvio,
                    CuentaBancaria, 
                    NumeroRegistro,
                    Periodo,
                    Mes,
                    Dia,
                    Monto, 
                    TotalRegistros,
                    DescripCobroPago,
                    CodigoError,
                    NombreBeneficiario
            from #DatosBAC#
            order by NumeroRegistro 
        </cfquery> 
        
        
        <cfloop query="rsDatos">
        	<cfset fnCrearLinea(
				fnJustifica('#rsDatos.TipoRegistro#',		1,	'D')&
				fnJustifica('#rsDatos.NumeroPlan#',			4,	'D')&
				fnJustifica('#rsDatos.NumeroEnvio#',		5,	'D')&
				fnJustifica('#rsDatos.CuentaBancaria#',		20,	'I')&
				fnJustifica('#rsDatos.NumeroRegistro#',		5,	'D')&
				fnJustifica('#rsDatos.Periodo#',			4,	'D')&
				fnJustifica('#rsDatos.Mes#',				2,	'D')&
				fnJustifica('#rsDatos.Dia#',				2,	'D')&
				fnJustifica('#rsDatos.Monto#',				13,	'D')&
				fnJustifica('#rsDatos.TotalRegistros#',		5,	'D')&
				fnJustifica('#rsDatos.DescripCobroPago#',	30,	'I')&
				fnJustifica('#rsDatos.CodigoError#'	,		1,	'D')&
				fnJustifica('#rsDatos.NombreBeneficiario#',	60,	'I')				
				)>
        </cfloop>
        
        <cfset LvarConsActua = #LvarConsecutivo# + 1>
        <cfquery name="rsSQL" datasource="#session.dsn#">
            update TEStransferenciaG2
            set TESTGvalor = '#LvarConsActua#'
             where TESTGid		= #LvarTESTGid#
               and Ecodigo		= #session.Ecodigo#
               and TESTGdato	= 
                <cfif LvarMoneda eq 01> 
					'Consecutivo Colones'
                <cfelseif LvarMoneda eq 02>
                    'Consecutivo Dolares'
                </cfif>
               and TESTGtipo	= 'L'
		</cfquery>

   		
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
