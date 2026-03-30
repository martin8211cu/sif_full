<cfscript>
	bcheck0 = false; // Chequeo del código de transacción
	bcheck1 = false; // Chequeo de existencia de la transaccion
	bcheck2 = false; // Chequeo del Banco
	bcheck3 = false; // Chequeo de la Cuenta Bancaria
	bcheck4 = false; // Chequeo de la cuenta contable
	bcheck5 = false; // Chequeo del Centro Funcional
	bcheck6 = false; // Chequeo de nombre de documento unico
	bcheck7 = false; // Chequeo de movimientos sin fecha ni tipo de cambio
	bcheck10 = false; // Chequeo de Integridad de Encabezados
</cfscript>

<!---NUEVO IMPORTADOR Movimentos Bancarios
Realizado por E. Raúl Bravo Gómez 05-02-2013 --->

<!--- Crea Tabla Temporal --->
<cf_dbtemp name="Cobros" returnvariable="Cobros" datasource="#session.dsn#">
    <cf_dbtempcol name="Ecodigo" type="numeric" mandatory="true">
    <cf_dbtempcol name="CodTrans" type="char(2)">
    <cf_dbtempcol name="CodBanc" type="varchar(20)">
    <cf_dbtempcol name="CtaBanc" type="varchar(50)">
    <cf_dbtempcol name="Docto" type="char(20)">
    <cf_dbtempcol name="TipoCamb" type="float">
    <cf_dbtempcol name="DMmonto" type="money">
    <cf_dbtempcol name="FechaTrans" type="datetime">
    <cf_dbtempcol name="Referencia" type="char(25)">
    <cf_dbtempcol name="Ccuenta" type="char(100)">
    <cf_dbtempcol name="CFcodigo" type="char(10)">
</cf_dbtemp>

<!---Se realiza lo siguiente: Se verifican los encabezados y se realizan las validaciones necesarias --->

<!--- Verifica si el código de transacción existe --->
<cfquery name="rsCheck0" datasource="#Session.DSN#">
    select count(1) as check0
    from #table_name# a
    where not exists
    (
        select 1 
        from BTransacciones 
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
        and BTcodigo = a.CodTrans
      ) 
</cfquery>
<cfset bcheck0 = rsCheck0.check0 LT 1>
<!---Vefifica que el banco exista--->
<cfif bcheck0>
	<cfquery name="rsCheck1" datasource="#Session.DSN#">
		select count(1) as check1 
        from #table_name# a
        where not exists 
        (select 1 
         from Bancos 
         where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
         and Bcodigo = a.CodBanc
		)
	</cfquery>
	<cfset bcheck1 = rsCheck1.check1 LT 1>
</cfif>
<!---Verifica que el Movimiento no exista  --->
<cfif bcheck1>
	<cfquery name="rsCheck2" datasource="#Session.DSN#">
        select count(1) as check2
        from #table_name# a
        where exists (select 1 
                        from EMovimientos
                        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
                        and CBid = (select CBid from CuentasBancos 
         				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
         				and CBdescripcion = a.CodBanc)
                        and BTid = (select BTid from BTransacciones 
        								 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
    									 and BTcodigo = a.CodTrans)
                        and EMdocumento = a.Docto) 
	</cfquery>
    <cfset bcheck2 = rsCheck2.check2 LT 1>
</cfif>
<!--- Verifica que la relacion banco/cuenta bancaria exista--->
<cfif bcheck2>
	<cfquery name="rsCheck3" datasource="#Session.DSN#">
		select count(1) as check3
		from #table_name# a
		where not exists
        (
			select 1
			from CuentasBancos
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
            and CBcodigo = a.CtaBanc
            and CBid = (select CBid from Bancos 
         				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
         				and Bcodigo = a.CodBanc)
		)
	</cfquery>
	<cfset bcheck3 = rsCheck3.check3 LT 1>
</cfif>

<!--- Verifica que la cuenta contable exista --->
<cfif bcheck3>
	<cfquery name="rsCheck4" datasource="#Session.DSN#">
		select count(1) as check4
		from #table_name# a
		where not exists
        (
			select 1
			from CFinanciera
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
            and ltrim(rtrim(CFformato)) = ltrim(rtrim(a.Ccuenta))
		)
	</cfquery>
	<cfset bcheck4 = rsCheck4.check4 LT 1>
</cfif>
<!---Verifica que el Centro Funcional exista--->
<cfif bcheck4>
	<cfquery name="rsCheck5" datasource="#Session.DSN#">
		select count(1) as check5
		from #table_name# a
		where not exists
        (
			select 1
			from CFuncional
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
            and CFcodigo = a.CFcodigo
		)
	</cfquery>
	<cfset bcheck5 = rsCheck5.check5 LT 1>
</cfif>

<!---Verifica que el Nombre del documento no se repita--->
<cfif bcheck5>
    <cfquery name="rsCheck6" datasource="#Session.DSN#">
        select count(1) as check6
        from #table_name# a
        where exists (select 1 
                        from EMovimientos
                        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
                        and EMdocumento = a.Docto) 
	</cfquery>
	<cfset bcheck6 = rsCheck6.check6 LT 1>
</cfif>

<!---Verifica que no se presenten movimientos sin fecha ni tipo de cambio---> 
<cfif bcheck6>
	<cfquery name="rsCheck7" datasource="#Session.DSN#">
		select count(1) as check7
		from #table_name# a
		where isnull(a.TipoCamb,'')   = '' 
        and   isnull(a.FechaTrans,'') = ''
	</cfquery>
	<cfset bcheck7 = rsCheck7.check7 LT 1>
</cfif>

<!---Verifica Integridad de Encabezados --->
<cfif bcheck7>
    <cfquery name="rsEncabezado" datasource="#Session.DSN#">
    	insert #Cobros# (Ecodigo, CodTrans, CodBanc, CtaBanc, Docto, TipoCamb, DMmonto, FechaTrans, Referencia, Ccuenta, CFcodigo)
        select distinct Ecodigo, CodTrans, CodBanc, CtaBanc, Docto, TipoCamb, DMmonto, FechaTrans, Referencia, Ccuenta, CFcodigo
       	from #table_name#
    </cfquery>
    
    <cfquery name="rsCheck10" datasource="#Session.DSN#">
		select count(1) as check10
		from #table_name# a
        where exists
        (
			select 1
			from #Cobros# b
           where a.Docto = b.Docto
           and (isnull(a.Ecodigo,'') != isnull(b.Ecodigo,'')
			   	or isnull(a.CodTrans,'') != isnull(b.CodTrans,'')
    	        or isnull(a.CodBanc,'') != isnull(b.CodBanc,'')
                or isnull(a.CtaBanc,'') != isnull(b.CtaBanc,'')
    	        or isnull(a.TipoCamb,'') != isnull(b.TipoCamb,'')
                or isnull(a.FechaTrans,'') != isnull(b.FechaTrans,'')
	            or isnull(b.Referencia,'') != isnull(a.Referencia,'')
	            )
		)
	</cfquery>
	<cfset bcheck10 = rsCheck10.check10 LT 1>
</cfif>

<cfif bcheck10>
    <cfquery name="rsEncabezado" datasource="#Session.DSN#">
    	select distinct Ecodigo, CodTrans, CodBanc, CtaBanc, Docto, TipoCamb, FechaTrans, Referencia
       	from #table_name#    
    </cfquery>
    
	<cfloop query="rsEncabezado">
        <cfquery name="rsCodTran" datasource="#Session.DSN#">
            select BTid
            from BTransacciones 
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
            and BTcodigo = '#rsEncabezado.CodTrans#'
        </cfquery>
        <cfquery name="rsCodBanco" datasource="#Session.DSN#">
            select CBid,Mcodigo
            from CuentasBancos
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
            and CBcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEncabezado.CtaBanc#">
            and CBid = (select CBid from Bancos 
                        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
                        and Bcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEncabezado.CodBanc#">)
        </cfquery>
		<cfif len(rsEncabezado.TipoCamb) eq 0 or rsEncabezado.TipoCamb eq 0>
            <cfquery name="rsTC" datasource="#Session.DSN#">
                select from Htipocambio tc
                    round(
                        coalesce(
                        (	case 
                            when cb.Mcodigo = #rsCodBanco.Mcodigo# then 1.00 
                            else tc.TCcompra 
                            end
                        )
                        , 1.0000)
                    ,4) as EMtipocambio
                where 	tc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
                and tc.Mcodigo = #rsCodBanco.Mcodigo#
                and tc.Hfecha  <= #rsEncabezado.FechaTrans#
                and tc.Hfechah >  #rsEncabezado.FechaTrans#
            </cfquery>
            <cfset TC = #rsTC.EMtipocambio#>
        <cfelse>
            <cfset TC = #rsEncabezado.TipoCamb#>
        </cfif>
            
    	<cfquery datasource="#Session.DSN#">
			insert into EMovimientos ( 
								Ecodigo, 
								BTid, 
								CBid, 
								EMtipocambio, 
								EMdocumento, 
								EMreferencia, 
								EMfecha, 
								EMdescripcion, 
								EMtotal, 
								EMusuario)
					 values ( <cfqueryparam value="#session.Ecodigo#"    cfsqltype="cf_sql_integer">,
                     		#rsCodTran.BTid#,
                            #rsCodBanco.CBid#,
                            #TC#,
                            '#rsEncabezado.Docto#',
                            '#rsEncabezado.Referencia#',
                            <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp" value="#rsEncabezado.FechaTrans#" voidNull>,
                            '#rsEncabezado.Docto#',
                            0,
                            <cfqueryparam value="#session.usuario#"    cfsqltype="cf_sql_varchar">)
			<cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="insert">
        <cfset EMid = "#insert.identity#">
        <cfquery datasource="#Session.DSN#">
        	insert into DMovimientos ( EMid, Ecodigo, Ccuenta, DMmonto, DMdescripcion,CFcuenta)
            select 
            	#EMid#,
                <cfqueryparam value="#session.Ecodigo#"    cfsqltype="cf_sql_integer">,
                c.Ccuenta, DMmonto, DescTrans, cf.CFcuenta
                from #table_name# a, CContables c, CFinanciera cf
            where cf.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
            and rtrim(ltrim(cf.CFformato)) = rtrim(ltrim(a.Ccuenta))
            and cf.Ecodigo = c.Ecodigo
            and c.Ccuenta = cf.Ccuenta
            and a.Docto = '#rsEncabezado.Docto#'
        </cfquery>
        <cfquery name="rsTotal" datasource="#Session.DSN#">
        	select sum(DMmonto) as Total from #table_name#
            where Docto = '#rsEncabezado.Docto#'
        </cfquery>
        <cfquery datasource="#Session.DSN#">
        	update EMovimientos
            set EMtotal = #rsTotal.Total#
            where EMdocumento = '#rsEncabezado.Docto#' 
            and   Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
        </cfquery>
    </cfloop>
    <cfquery datasource="#session.DSN#">
        drop table #Cobros#
    </cfquery>
<cfelse>
	<!--- Fallo Check0 --->
	<cfif not bcheck0>
    	<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'El código de transacción bancaria no existe en el sistema: ' as MSG, a.Docto as Documento, a.CodTrans as Transaccion_Pago
            from #table_name# a
            where not exists
            (
                select 1 
                from BTransacciones 
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
                and BTcodigo = a.CodTrans
            ) 
        </cfquery>
        
    <!--- Fallo Check1 --->      
	<cfelseif not bcheck1>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'El banco no existe: ' as MSG, a.CodBanc as Banco
            from #table_name# a
            where not exists 
            (select 1 
             from Bancos 
             where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
             and Bcodigo = a.CodBanc
            )
		</cfquery>
	
    <!--- Fallo Check2 --->      
	<cfelseif not bcheck2>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'Ya existe un movimiento en el sistema: ' as MSG, a.Docto as Documento, a.TranPago as Transaccion_Pago
            from #table_name# a
            where exists (select 1 
                            from EMovimientos
                            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
                            and CBid = (select CBid from CuentasBancos 
                            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
                            and Bcodigo = a.CodBanc)
                            and BTid = (select BTid from BTransacciones 
                                             where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
                                             and BTcodigo = a.CodTrans)
                            and EMdocumento = a.Docto) 
		</cfquery>
        
	<!--- Fallo Check3 --->    
	<cfelseif not bcheck3>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'La cuenta bancaria no existe: ' as MSG, a.CtaBanc as CUENTA
            from #table_name# a
            where not exists
            (
                select 1
                from CuentasBancos
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
                and CBcodigo = a.CtaBanc
                and CBid = (select CBid from Bancos 
                            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
                            and Bcodigo = a.CodBanc)
            )
		</cfquery>
	
	<!--- Fallo Check4 --->
    <cfelseif not bcheck4>
		<cfquery name="ERR" datasource="#session.DSN#">		
			select distinct 'Cuenta contable no existe: ' as MSG, a.Ccuenta as CUENTA_CONTABLE
            from #table_name# a
            where not exists
            (
                select 1
                from CFinanciera
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
                and ltrim(rtrim(CFformato)) = ltrim(rtrim(a.Ccuenta))
            )
		</cfquery>        

	<!--- Fallo Check5 ---> 
	<cfelseif not bcheck5>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct El Centro Funcional no existe: ' as MSG, a.CFcodigo as CENTRO_FUNC
            from #table_name# a
            where not exists
            (
                select 1
                from CFuncional
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
                and CFcodigo = a.CFcodigo
            )
		</cfquery>        

	<!--- Fallo Check6 --->		
    <cfelseif not bcheck6>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'Ya existe un movimento con el mismo nombre: ' as MSG, a.Docto as DOCUMENTO_PAGO
            from #table_name# a
            where exists (select 1 
                            from EMovimientos
                            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
                            and EMdocumento = a.Docto) 
		</cfquery>
        
    <!--- Fallo Check7 --->	
    <cfelseif not bcheck7>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'Documento a sin fecha y sin tipo de cambio ' as MSG, a.Docto, a.TipoCamb as TIPO_CAMB, a.FechaTrans as FECHA_TRANSACCION
            from #table_name# a
            where isnull(a.TipoCamb,'')   = '' 
            and   isnull(a.FechaTrans,'') = ''
		</cfquery>
	<cfelse>
		<!--- Fallo Check10 --->		
	    <cfif not bcheck10>
			<cfquery name="ERR" datasource="#session.DSN#">
				select distinct 'Error en Integridad de Documento, verifique los detalles: ' as MSG, a.Docto
                from #table_name# a
                where exists
                (
                    select 1
                    from #Cobros# b
                   where a.Docto = b.Docto
                   and (isnull(a.Ecodigo,'') != isnull(b.Ecodigo,'')
                        or isnull(a.CodTrans,'') != isnull(b.CodTrans,'')
                        or isnull(a.CodBanc,'') != isnull(b.CodBanc,'')
                        or isnull(a.CtaBanc,'') != isnull(b.CtaBanc,'')
                        or isnull(a.TipoCamb,'') != isnull(b.TipoCamb,'')
                        or isnull(a.DMmonto,'') != isnull(b.DMmonto,'') 
                        or isnull(a.FechaTrans,'') != isnull(b.FechaTrans,'')
                        or isnull(b.Referencia,'') != isnull(a.Referencia,'')
                        or isnull(a.Ccuenta,'') != isnull(b.Ccuenta,'')
                        or isnull(a.CFcodigo,'') != isnull(b.CFcodigo,'')
                        )
                )
			</cfquery>
            <cfquery datasource="#session.DSN#">
                drop table #Cobros#
            </cfquery>
		</cfif>
	</cfif>
</cfif>


