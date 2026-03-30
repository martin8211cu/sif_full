<cfcomponent output="no">
	<cffunction name="Verificar" output="no" access="public" returntype="void">
		<cfargument name="TESTLid"		type="numeric">
		<cfargument name="TESTLdatos"	type="string">
		<cfargument name="TESTGid"		type="numeric">
        
        <cfset LvarTESTGid = #Arguments.TESTGid#>
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
                ,'Orden Pago:' #_Cat# <cf_dbfunction name="to_char" args="op.TESOPnumero"> as descripcion
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
			<cfset LvarCta = fnVerificaCC(rsTESTD.TESTPcuenta,rsTESTD.BcodigoACH,rsTESTD.Bdescripcion,rsTESTD.TESOPbeneficiarioId)>
		</cfloop>

         <!---====== NUMERO ARCHIVO: Calcular el numero de consecutivo de archivo, envio de mas de un archivo el mismo dia ======----->

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
        <cfif LvarConsecutivoColones GTE 1000>
            <cfset LvarConsecutivoColones = 1>
        </cfif>
        
        
		<cfif not isnumeric(LvarConsecutivoDolares)>
			<cfthrow message="El consecutivo en dolares para generacion no es numerico">
            <cfabort>
		</cfif>
		<cfif LvarConsecutivoDolares LTE 0 >
            <cfthrow message = "No se puede tener un consecutivo menor a 0, por favor cambie el consecutivo en dolares en parametros de generacion TRE">
            <cfabort>
        </cfif>
        <cfif LvarConsecutivoDolares GTE 1000>
            <cfset LvarConsecutivoDolares = 1>
        </cfif>


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
        
        <cfinvoke component="sif.Componentes.Translate"
        method="Translate"
        Key="Existen_cuentas_clientes_con_formato_incorrecto_El_formato_debe_ser_numerico_y_de_17_dígitos_continuos"
        Default="Existen cuentas clientes con formato incorrecto. El formato debe ser numérico y de 17 dígitos continuos."
        returnvariable="MG_CuentaCliente"/> 
        
        <cfset vs_cedjuridica 	= ''>	<!---Cedula juridica de la empresa ---->
        <cfset vs_cedusuario 	= ''>	<!---Cedula del empleado que genera el archivo ---->
        <cfset vn_testkey 		= 0>	<!---Testkey calculado ----->
        <cfset vn_documento 	= 0>	<!---Documento---->
        <cfset vb_cedregistro = true >  <!---Variable booleana para validar que el usuario pueda realizar la exportacion---->
        <cfset vb_cedjuridica = true >  <!---Variable booleana para validar que la empresa tenga cedula juridica---->
        
        <cf_dbtemp name="DatosBancos" returnvariable="Datos" datasource="#session.DSN#"><!---Tabla temporal de datos que van a ser insertados ---->
            <cf_dbtempcol name="Datos" 	type="char(194)"  	mandatory="no">
            <cf_dbtempcol name="Orden"	type="int" 			mandatory="no">
        </cf_dbtemp>
        
		<cfset LvarMoneda= fnMoneda(rsTESTD.Miso4217Pago)>
        <cfif LvarMoneda eq 01> 
        	<cfset LvarConsecutivo=#LvarConsecutivoColones#>
        <cfelseif LvarMoneda eq 02>
        	<cfset LvarConsecutivo=#LvarConsecutivoDolares#>
        </cfif>

                
        <cfset LvarResult = structNew()>
		<cfset LvarResult.FileName = "TEF-BCR-interno" & LvarConsecutivo &".txt">
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
				b.Bdescripcion, b.BcodigoACH,b.Bid
                ,'Orden Pago:' #_Cat# <cf_dbfunction name="to_char" args="op.TESOPnumero"> as descripcion
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

        
        <!---====== NUMERO NEGOCIO: Número de cédula jurídica de la empresa ====---->
        <cfquery name="rsCedJuridica" datasource="#session.DSN#">
            select ltrim(rtrim(Bcodigocli)) as cedulajuridica			
            from Bancos 
            where Bid = #rsTESTD.Bid#
                and Ecodigo = #session.Ecodigo#
        </cfquery>
        <cfif isdefined("rsCedJuridica") and len(trim(rsCedJuridica.cedulajuridica))>
            <cfset vs_cedjuridica = Replace(rsCedJuridica.cedulajuridica,'-','','all')><!---Reemplazando los guiones--->
        <cfelse>
            <cfthrow message = "No se ha definido la cédula jurídica (Identificación) de la empresa">
            <cfabort>
        </cfif>
        <!---====== CEDULA REGISTRO: Cedula del funcionario de la empresa que genera el archivo =====--->
        <cfquery name="rsCedRegistra" datasource="#session.DSN#"><!--- Cedula(Identificacion) del funcionario ---->
            select b.Pid as Identificacion
            from Usuario a
                inner join DatosPersonales b
                    on a.datos_personales = b.datos_personales 
            where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
                and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
        </cfquery>
        <cfif isdefined("rsCedRegistra") and len(trim(rsCedRegistra.Identificacion))>
            <cfset vs_cedusuario = trim(Replace(rsCedRegistra.Identificacion,'-','','all'))><!---Reemplazando los guiones--->
        <cfelse>
			<cfthrow message = "El usuario no puede realizar la exportación">
            <cfabort>
        </cfif>
        
        <cfif vb_cedregistro and vb_cedjuridica>
            <!---====== TESTKEY ======------>	
            <cf_dbtemp name="TestKey" returnvariable="TestKey" datasource="#session.DSN#">
                <cf_dbtempcol name="Valor1" 			type="varchar(50)"  mandatory="no">
                <cf_dbtempcol name="CBcc"				type="varchar(50)" mandatory="no">
                <cf_dbtempcol name="ValorA"				type="varchar(50)" mandatory="no">
                <cf_dbtempcol name="ValorB"				type="varchar(50)" mandatory="no">
                <cf_dbtempcol name="Largo"				type="int" mandatory="no">
                <cf_dbtempcol name="Liquido"			type="numeric(12,2)" mandatory="no">
                <cf_dbtempcol name="Largo2"				type="int" mandatory="no">
            </cf_dbtemp>		
            <cfquery name="rs1" datasource="#session.DSN#">
                insert into #TestKey# (Valor1,CBcc,ValorA,Largo,Liquido,Largo2)
                select  <cf_dbfunction name="string_part" args="cta.TESTPcuenta,6,3">,
                        coalesce(cta.TESTPcuenta,cb.CBcc) as CBcc,
                        coalesce(cta.TESTPcuenta,cb.CBcc) as ValorA,
                        coalesce((<cf_dbfunction name="length" args="ltrim(rtrim(cta.TESTPcuenta))">)-9,0) as columna,
                        case TESOPtotalPago when 0 then 1 else TESOPtotalPago end,
                        coalesce((<cf_dbfunction name="length" args="ltrim(rtrim(cta.TESTPcuenta))">)-6,0)

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
                  and <cf_dbfunction name="length" args="rtrim(cta.TESTPcuenta)"> > 10
            </cfquery>
            <cfquery name="temporal" datasource="#session.DSN#">
                select * from #TestKey#
            </cfquery>
            <cfif temporal.RecordCount NEQ 0>
                <cfset vn_largo = IIf(temporal.Largo lt 0, '0', '#temporal.Largo#')>
                <cfset vn_largo2 = IIf(temporal.Largo2 lt 0, '0', '#temporal.Largo2#')>
                <cfquery datasource="#session.DSN#">
                    update #TestKey# set ValorA = <cf_dbfunction name="string_part" args="ValorA,9,#vn_largo#">
                </cfquery>
                <cfquery datasource="#session.DSN#">
                    update #TestKey# set ValorB = <cf_dbfunction name="string_part" args="CBcc,6,#vn_largo2#">
                </cfquery>
                <cftry>
                    <cfquery name="TKey" datasource="#session.DSN#">
                        select 	sum(<cf_dbfunction name="to_number" args="Valor1"> + <cf_dbfunction name="to_number" args="ValorA">) + sum(floor(<cf_dbfunction name="to_number" args="ValorB">/Liquido)) as TKey
                        from #TestKey# 
                    </cfquery>
                <cfcatch type="any">
                    <cf_throw message="#MG_CuentaCliente#" errorcode="6035">
                </cfcatch>	
                </cftry>
                <cfset vn_testkey = TKey.TKey>	
                <!---========= 1.INSERTAR LINEA DE CONTROL ==========---->
                <cfif 12-len(trim(vs_cedjuridica)) GT 0>
                    <cfset vs_cedjuridica = repeatString('0',12-len(trim(vs_cedjuridica)))&vs_cedjuridica>
                </cfif>
                <cfif 12-len(trim(vs_cedusuario)) GT 0>
                    <cfset vs_cedusuario = repeatString('0',12-len(trim(vs_cedusuario)))&vs_cedusuario>
                </cfif>
                <cfif 12-len(trim(vn_testkey)) GT 0>
                    <cfset vn_testkey = repeatString('0',12-len(trim(vn_testkey)))&vn_testkey>
                </cfif>
                <cfif 3-len(trim(LvarConsecutivo)) GT 0>
                    <cfset LvarConsecutivo = repeatString('0',3-len(trim(LvarConsecutivo)))&LvarConsecutivo>
                </cfif>
                <cfquery name="Control" datasource="#session.DSN#">
                    insert into #Datos# (Datos,Orden)
                    values( 						
                            {fn concat('000',
                            <!---{fn concat('#trim(Mid(trim(vs_cedjuridica),1,12))#', Me indican que siempre es el numero 000000102844--->
                            {fn concat('000000102844',
                            {fn concat('#trim(Mid(trim(LvarConsecutivo),1,3))#',
                            {fn concat('#LSDateFormat(now(),'ddmmyyyy')#',
                            {fn concat('#trim(Mid(trim(vs_cedusuario),1,12))#',
                            {fn concat('#trim(Mid(trim(vn_testkey),1,12))#',
                            {fn concat('#RepeatString('0',6)#',
                            {fn concat('#RepeatString(' ',6)#',
                            {fn concat('TLB',
                            {fn concat('#RepeatString(' ',128)#',
                            {fn concat('D'
                            )})})})})})})})})})})}					
                            ,1
                            )
                </cfquery>	
                
                
                <!----======= 2. INSERTAR LINEA DE REGISTRO QUE DEBITA ==========---->
                
                <!----======= NUMERO DE CUENTA CLIENTE: Cuenta que debita ==========---->
                <cfquery name="rsCuentaCliente" datasource="#session.dsn#">
                    select ltrim(rtrim(CBcc)) as CuentaCliente, 
                    	#Arguments.TESTLid# as documento,
                        coalesce(TESOPinstruccion,'Pago de Trasferencia')	as razon
               		FROM TESordenPago op
                    inner join CuentasBancos a
                         on a.CBid = op.CBidPago
                    where op.TESid	   = #session.Tesoreria.TESid#	
                    and a.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">	 
                    and op.TESTLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TESTLid#">	
                </cfquery>
				
				<cfset LvarCta = fnVerificaCC(rsCuentaCliente.CuentaCliente,rsTESTD.BcodigoACH,rsTESTD.Bdescripcion,rsTESTD.TESOPbeneficiarioId)>

                <!---============ SUMA DE LOS MONTOS A ACREDITAR POR CADA OP (REGISTROS DE DETALLE)(Total a debitar) ==============---->
                <cfquery name="rsMonto" datasource="#session.dsn#">
                    select sum(coalesce(<cf_dbfunction name="to_number" args="(TESOPtotalPago) * 100">,0)) as Monto
                    from TESordenPago op
                    where op.TESid	   = #session.Tesoreria.TESid#	
                      and op.TESTLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TESTLid#">
                </cfquery>
                
                <cfif 17-len(trim(LvarCta)) GT 0>
                    <cfset CuentaCliente = repeatString('0',17-len(trim(#LvarCta#)))&#LvarCta#>
                <cfelse>
                    <cfset CuentaCliente = #LvarCta#>
                </cfif>
                <cfif 8-len(trim(rsCuentaCliente.documento)) GT 0>
                    <cfset documento = repeatString('0',8-len(trim(rsCuentaCliente.documento)))&rsCuentaCliente.documento>
                <cfelse>
                    <cfset documento = rsCuentaCliente.documento>
                </cfif>
                <cfif 12-len(trim(rsMonto.Monto)) GT 0>
                    <cfset Monto = repeatString('0',12-len(trim(rsMonto.Monto)))&rsMonto.Monto>
                <cfelse>
                    <cfset Monto = rsMonto.Monto>
                </cfif>
                <cfif len(trim(rsCuentaCliente.razon)) EQ 0>
                    <cfset razon='Pago de planilla'>
                </cfif>
                <cfset LvarMoneda= fnMoneda(rsTESTD.Miso4217Pago)>
                <!----======= 2. INSERTAR LINEA DE REGISTRO QUE DEBITA ==========---->
                <cfquery name="insertaLineaRegistroDebita"  datasource="#session.DSN#">		
                    insert into #Datos# (Datos,Orden)
                    values( 
                            {fn concat('000',
                            {fn concat('#Mid(trim(CuentaCliente),1,17)#',
                            {fn concat('#LvarMoneda#',
                            {fn concat('4',
                            {fn concat('0000',
                            {fn concat('#Mid(documento,1,8)#',
                            {fn concat('#Mid(Monto,1,12)#',
                            {fn concat('#LSDateFormat(now(),'ddmmyyyy')#',
                            {fn concat('00',
                            {fn concat('00',
                            {fn concat('#RepeatString(' ',20)#',
                            {fn concat('#RepeatString(' ',20)#',
                            {fn concat('#RepeatString(' ',25)#',
                            {fn concat('#RepeatString(' ',20)#',
                            {fn concat('#RepeatString(' ',50)#'					
                            )})})})})})})})})})})})})})})}
                            ,2)				  			
                </cfquery>
            
                <!---=========== 3. INSERTAR LINEAS DE DATOS (Creditos) ===========---->
                
				<cfquery name="rsDatos" datasource="#session.dsn#">
                    SELECT 
                        cb.CBcc as CtaCliente,
                        coalesce(<cf_dbfunction name="to_number" args="(op.TESOPtotalPago) * 100">,0) as Monto,
                        coalesce(c.TESBeneficiarioId,sn.SNidentificacion) as Cedula,
                        coalesce(c.TESBemail,sn.SNemail) as Correo,
                        #Arguments.TESTLid# as documento,
                        coalesce(TESOPinstruccion,'Pago de Trasferencia')	as razon,

                        td.TESTDid,
                        td.TESTDfechaGeneracion,
                        op.TESOPid, 
                        op.TESOPnumero, 
                        op.TESOPbeneficiarioId,
                        op.TESOPbeneficiario #_Cat# coalesce(op.TESOPbeneficiarioSuf,'') as TESOPbeneficiario, 
                        op.Miso4217Pago, 
                        op.TESOPinstruccion,
                        cta.TESTPcuenta,
                        b.Bdescripcion, b.BcodigoACH,b.Bid
                        ,'Orden Pago:' #_Cat# <cf_dbfunction name="to_char" args="op.TESOPnumero"> as descripcion
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

                
                <cfloop query="rsDatos"><!----Insertar en tabla para exportación---->		
                	
					<cfset LvarMoneda= fnMoneda(rsDatos.Miso4217Pago)>
					<cfset LvarCta = fnVerificaCC(rsDatos.TESTPcuenta,rsDatos.BcodigoACH,rsDatos.Bdescripcion,rsDatos.TESOPbeneficiarioId)>

					<cfif (17-len(trim(LvarCta))) GT 0>
                        <cfset vCtaCliente = repeatString('0',17-len(trim(LvarCta)))& LvarCta>				
                    <cfelse>
                        <cfset vCtaCliente = LvarCta>
                    </cfif>
					<cfif (20-len(trim(rsDatos.Cedula))) GT 0>
                        <cfset LvarCedula = rsDatos.Cedula & repeatString(' ',20-len(trim(rsDatos.Cedula))) >				
                    <cfelse>
                        <cfset LvarCedula = rsDatos.Cedula>
                    </cfif>
					<cfif (50-len(trim(rsDatos.Correo))) GT 0>
                        <cfset LvarEmail = rsDatos.Correo & repeatString(' ',50-len(trim(rsDatos.Correo))) >				
                    <cfelse>
                        <cfset LvarEmail = rsDatos.Correo>
                    </cfif>
					<cfif (20-len(trim(rsDatos.descripcion))) GT 0>
                        <cfset LvarDescripcion = rsDatos.descripcion & repeatString(' ',20-len(trim(rsDatos.descripcion))) >				
                    <cfelse>
                        <cfset LvarDescripcion = rsDatos.descripcion>
                    </cfif>
                    <cfif (8-len(trim(rsDatos.currentRow))) GT 0>
                        <cfset vdocumento = repeatString('0',8-len(trim(rsDatos.currentRow)))& rsDatos.currentRow>
                    <cfelse>
                        <cfset vdocumento = rsDatos.currentRow>
                    </cfif>
                    <cfif (12-len(trim(rsDatos.Monto))) GT 0>
                        <cfset vMonto = repeatString('0',12-len(trim(rsDatos.Monto)))& rsDatos.Monto>
                    <cfelse>
                        <cfset vMonto = rsDatos.Monto>
                    </cfif>
                    <cfif len(trim(rsDatos.razon)) EQ 0>
                        <cfset vrazon = 'Pago de Transferencia'>
                    <cfelse>
                        <cfset vrazon =rsDatos.razon>
                    </cfif>
                    <cfquery name="Registros" datasource="#session.DSN#">
                        insert into #Datos# (Datos,Orden)
                        values( 	
                                {fn concat('000',
                                {fn concat('#Mid(vCtaCliente,1,17)#',
                                {fn concat('#LvarMoneda#',
                                {fn concat('2',
                                {fn concat('0000',
                                {fn concat('#Mid(vdocumento,1,8)#',
                                {fn concat('#Mid(vMonto,1,12)#',
                                {fn concat('#LSDateFormat(now(),'ddmmyyyy')#',
                                {fn concat('00',
                                {fn concat('00',
                                {fn concat('#Mid(LvarCedula,1,17)#',
                                {fn concat('#Mid(LvarDescripcion,1,20)#',
                                {fn concat('#RepeatString(' ',25)#',
                                {fn concat('#RepeatString(' ',20)#',
                                {fn concat('#Mid(LvarEmail,1,50)#'
                                )})})})})})})})})})})})})})})}
                                ,
                                3)				  
                    </cfquery>

                </cfloop>	
                <cfquery name="ERR" datasource="#session.DSN#">
                    select Datos,Orden from #Datos#
                    order by Orden asc
                </cfquery>
                
				<cfloop query="ERR">
        			<cfset fnCrearLinea(#ERR.Datos#)>
				</cfloop>	
            </cfif>
        </cfif>	

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

	


	<cffunction name="FnVerificaCC" output="no" access="private" returntype="string">
		<cfargument name="CC"			type="string">
		<cfargument name="BCO"			type="string">
		<cfargument name="Banco"		type="string">
		<cfargument name="Bene"			type="string">		

		<cfset var LvarCta = trim(Arguments.CC)>
		<cfset var LvarBco = trim(Arguments.Bco)>
		<cfset var LvarBene = trim(Arguments.Bene)>
        
        
		<!---Se comenta pues al parecer en NACION no se ocupa de 17 caracteres--->
		<!---<cfif len(LvarCta) NEQ 17>
		  <cfthrow message="Cuenta Cliente debe ser de 17 caracteres: #LvarCta#  Beneficiario: #LvarBene#">
		</cfif>--->
	
		<cfif trim(LvarBCO) EQ "">
			<cfthrow message="No se ha registrado el Código Nacional de Banco para Transferencias Interbancarias en el Banco Destino '#Arguments.Banco#'">
		</cfif>
		<cfif not isnumeric(LvarBCO)>
			<cfthrow message="Código Nacional de Banco para Transferencias Interbancarias en el Banco Destino '#Arguments.Banco#' no es numérico: #LvarBco#">
		</cfif>
		<cfif LvarBCO GT 999>
			<cfthrow message="Código Nacional de Banco para Transferencias Interbancarias en el Banco Destino '#Arguments.Banco#' mayor a 999: #LvarBco#">
		</cfif>

		<cfset LvarBCO = right("000#LvarBco#",3)>
        <!---Se comenta pues al parecer en NACION no empieza con el Código Nacional de Banco--->
<!---		<cfif left(LvarCta,3) NEQ LvarBco>
		  <cfthrow message="Cuenta Cliente '#LvarCta#' no empieza con el Código Nacional de Banco para Transferencias Interbancarias en el Banco '#Arguments.Banco#': #LvarBCO#">
		</cfif>--->

		<cfset LvarDV  = mid (LvarCta,17,1)>
		<cfset LvarCta = mid (LvarCta,1,16)>
		<cfset LvarDVG = fnDigitoVerificador(LvarCta)>
        <!---Se comenta pues al parecer en NACION no se utiliza el digito verificador--->
		<!---<cfif LvarDV NEQ LvarDVG>
		  <cfthrow message="Digito Verificador de Cuenta Cliente '#Arguments.CC#' debe ser #LvarDVG#">
		</cfif>--->
		
		<cfreturn "#LvarCta##LvarDVG#">
	</cffunction>

	<!---<cffunction name="FnGeneraCodReferencia" output="no" access="private" returntype="string">
		<cfargument name="OP"			type="numeric">

		<cfset var LvarOP	= trim(Arguments.OP)>
		<cfset var LvarRef	= trim(Arguments.OP)>

		<cfif len(LvarOP) GT 9>
			<cfthrow message="Numero de Orden de Pago no puede ser mayor a 999,999,999: #LvarOP#">
		</cfif>

		<!---<cfif LvarSS GT 99>
			<cfthrow message="Prefijo YYYYMMDDEEESSCC para Referencia: Servicio mayor a 99: #LvarSS#">
		</cfif>
		<cfif LvarCC GT 99>
			<cfthrow message="Prefijo YYYYMMDDEEESSCC para Referencia: Consecutivo mayor a 99: #LvarCC#">
		</cfif>--->

		<cfset LvarOP  = Right("000000000" & LvarOP, 9)>
		<cfset LvarRef = dateformat(LvarFecha,"YYYYMMDD") & numberFormat(LvarEEE,"000") & numberFormat(00,"00") & numberFormat(00,"00") & LvarOP>
		<cfset LvarDVG = fnDigitoVerificador(LvarRef)>

		<cfreturn LvarRef & LvarDVG>
	</cffunction>--->

	<cffunction name="fnDigitoVerificador" output="no" access="private" returntype="string">
		<cfargument name="dato"			type="numeric">

		<cfset var MODULO	= 11>
		<cfset var PESOS	= "1234567891234567891234567891234567">
		<cfset var LONGMAX	= len(PESOS)+1>
  
		<cfset var LvarHileraPesos	= "">
		<cfset var LvarSumaDigitos 	= 0>
		<cfset var LvarDato			= trim(Arguments.dato)>
		<cfset var LvarLongitud		= Len(LvarDato)>
		<cfset var i          		= 0>

		<cfset var LvarPesos = Mid(PESOS, LONGMAX - LvarLongitud, LONGMAX)>

		<cfloop index="i" from="1" to="#LvarLongitud#">
			<cfset LvarSumaDigitos += Val(Mid(LvarDato, i, 1)) * Val(Mid(LvarPesos, i, 1))>
		</cfloop>
		<cfset LprmDigito = LvarSumaDigitos Mod MODULO>
		<cfIf LprmDigito EQ 10>
			<cfset LprmDigito = 1>
		</cfIf>
		<cfreturn LprmDigito>
	</cffunction>

	<cffunction name="fnMoneda" output="no" access="private" returntype="string">
		<cfargument name="Miso4217"			type="string">
		<cfif Arguments.Miso4217 EQ "CRC">
			<cfreturn "01">
		<cfelseif Arguments.Miso4217 EQ "USD">
			<cfreturn "02">
		<cfelse>
			<cfthrow message="Codigo de moneda no permitido: #Arguments.Miso4217#">
		</cfif>
	</cffunction>
</cfcomponent>
