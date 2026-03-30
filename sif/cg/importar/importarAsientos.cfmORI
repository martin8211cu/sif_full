<cfscript>
	bcheck1 = false; // Chequeo de Fechas
	bcheck2 = false; // Chequeo de Monedas
	bcheck3 = false; // Chequeo de Oficinas
	bcheck4 = false; // Chequeo de Monto solo en Debito o en Credito
	bcheck5 = false; // Chequeo de Centro Funcional
	bcheck6 = false; // Chequeo de Tipos de Cambio
	bcheck7 = true; // Chequeo de Montos
	bcheck8 = true; // Chequeo de Montos
</cfscript>

<!--- Eliminar cualquier detalle contenido en el lote de importación --->
<cfquery name="rsDelete" datasource="#Session.DSN#">
	delete from DContablesImportacion
	where ECIid = #Session.ImportarAsientos.ECIid#
</cfquery>

<!--- Chequear Validez de Fecha de los Asientos --->
<cfquery name="rsCheck1" datasource="#Session.DSN#">
	select count(1) as check1
	from #table_name# a
	where not exists(
		select 1
		from EContablesImportacion b
		where b.Efecha = a.Fecha
		and b.ECIid = #Session.ImportarAsientos.ECIid#
	)
</cfquery>
<cfset bcheck1 = rsCheck1.check1 LT 1>

<!--- Chequear Validez de las Monedas presentes en los Asientos --->
<cfif bcheck1>
	<cfquery name="rsCheck2" datasource="#Session.DSN#">
		select count(1) as check2
		from #table_name# a
		where not exists(
			select 1
			from Monedas b
			where b.Miso4217 = a.Miso4217
			and b.Ecodigo = #Session.Ecodigo#
		)
	</cfquery>
	<cfset bcheck2 = rsCheck2.check2 LT 1>
</cfif>

<!--- Chequear Validez de las Oficinas presentes en los Asientos --->
<cfif bcheck2>
	<cfquery name="rsCheck3" datasource="#Session.DSN#">
		select count(1) as check3
		from #table_name# a
		where not exists(
			select 1
			from Oficinas c
			where c.Oficodigo = a.Oficodigo
			and c.Ecodigo = (case when (a.EcodigoRef is not null and a.EcodigoRef <> 0 and a.EcodigoRef <> -1) then a.EcodigoRef else #Session.Ecodigo# end)
		)
	</cfquery>
	<cfset bcheck3 = rsCheck3.check3 LT 1>
</cfif>

<!--- Chequear Validez de las Oficinas presentes en los Asientos --->
<cfif bcheck3>
	<cfquery name="rsCheck4" datasource="#Session.DSN#">
		select count(1) as check4
		from #table_name# a
		where (MontoDeb <> 0 and MontoCred <> 0) or (MontoDebLoc <> 0 and MontoCredLoc <> 0)
	</cfquery>
	<cfset bcheck4 = rsCheck4.check4 LT 1>
</cfif>
<cfif bcheck4>
	<cfset bcheck5 = 'TRUE'>
	<!--- Verifica el parametro 982 Importar Asientos Cotables con Centro Funcional --->
    <cfquery name="rsParametro" datasource="#session.DSN#">
        select Pvalor
        from Parametros
        where Ecodigo = #session.Ecodigo#
        and Pcodigo = 982
    </cfquery>
    
    <cfset LvarImportarCF = 0>
    <cfif isdefined('rsParametro') and rsParametro.recordcount GT 0 and rsParametro.Pvalor EQ 1>
        <cfset LvarImportarCF = 1>

        <cfquery name="rsCheck5" datasource="#Session.DSN#">
            select count(1) as check5
            from #table_name# a
             where a.CFcodigo is not null
             and rtrim(a.CFcodigo) <> ''
             and not exists(
                select 1
                from CFuncional b
                where b.Ecodigo = #session.Ecodigo#
                and b.CFcodigo = a.CFcodigo
                )
        </cfquery>

        <cfset bcheck5 = rsCheck5.check5 LT 1>
    </cfif>
</cfif>

<cfif bcheck5>
	<cfset bcheck6 = 'TRUE'>
    <cfset bcheck7 = 'TRUE'>
    <cfset bcheck8 = 'TRUE'>

   	<cfquery name="rsCheck6" datasource="#Session.DSN#">
        Select count(1) as check6
        from #table_name#
        where Dtipocambio <> round((<cf_dbfunction name="to_float" args="MontoDebLoc" datasource="#Session.DSN#"> / <cf_dbfunction name="to_float" args="MontoDeb" datasource="#Session.DSN#">),4) 
          and MontoDeb > 0
    </cfquery>
    
   	<cfquery name="rsCheck61" datasource="#Session.DSN#">
        Select count(1) as check61
        from #table_name#
        where Dtipocambio <> round((<cf_dbfunction name="to_float" args="MontoCredLoc" datasource="#Session.DSN#"> / <cf_dbfunction name="to_float" args="MontoCred" datasource="#Session.DSN#">),4)
          and MontoCred > 0
    </cfquery>
	
    <cfquery name="rsCheck62" datasource="#Session.DSN#">
        Select MontoDebLoc, MontoDeb, Dtipocambio
        from #table_name#
        where MontoDeb > 0
    </cfquery>
    
    <cfquery name="rsCheck63" datasource="#Session.DSN#">
        Select MontoCredLoc, MontoCred, Dtipocambio
        from #table_name#
        where  MontoCred > 0
    </cfquery>
    
	<cfset bcheck6 = (rsCheck6.check6 + rsCheck61.check61) LT 1>
    <cfset bcheck7 = abs( numberFormat( (rsCheck62.MontoDeb*rsCheck62.Dtipocambio - rsCheck62.MontoDebLoc),"0.00") ) GT 0.01>
    <cfset bcheck8 = abs( numberFormat( (rsCheck63.MontoCred*rsCheck63.Dtipocambio - rsCheck63.MontoCredLoc),"0.00") ) GT 0.01>
</cfif>

<cfif bcheck6 and (not bcheck7 or not bcheck8)>
<!---<cfif bcheck5>--->
	<cfquery name="rsObtieneMonedaLocal" datasource="#Session.DSN#">
		select m.Mcodigo, m.Miso4217
		from Empresas e
			inner join Monedas m
				on m.Mcodigo = e.Mcodigo
		where e.Ecodigo = #Session.Ecodigo#
	</cfquery>

	<cfif rsObtieneMonedaLocal.recordcount GT 0>
		<cfset LvarMcodigo = rsObtieneMonedaLocal.Mcodigo>
		<cfset LvarMiso4217 = rsObtieneMonedaLocal.Miso4217>

		<cfquery name="rsActualizaMontos" datasource="#Session.DSN#">
			update #table_name#
			set MontoDebLoc = MontoDeb, MontoCredLoc = MontoCred, Dtipocambio = 1.00
			where Miso4217  =  '#LvarMiso4217#'
		</cfquery>	
		
	</cfif>

	<!---  Actualizar el monto en la moneda origen cuando no está indicada en el archivo origen --->
	<cfquery name="rsActualizaMontos" datasource="#Session.DSN#">
		update #table_name#
			set MontoDebLoc = round(MontoDeb * Dtipocambio, 2)
		where MontoDeb <> 0
		  and coalesce(MontoDebLoc, 0) = 0
	</cfquery>	

	<cfquery name="rsActualizaMontos" datasource="#Session.DSN#">
		update #table_name#
			set MontoCredLoc = round(MontoCred * Dtipocambio, 2)
		where MontoCred <> 0
		  and coalesce(MontoCredLoc, 0) = 0
	</cfquery>	

	<cfquery name="rsActualizaMontos" datasource="#Session.DSN#">
		update #table_name#
			set MontoDebLoc = coalesce(MontoDebLoc, 0.00), MontoCredLoc = coalesce(MontoCredLoc, 0.00)
		where MontoDebLoc is null or MontoCredLoc is null
	</cfquery>	

	<cfquery name="rsActualizaMontos" datasource="#Session.DSN#">
		update #table_name#
			set Dtipocambio = round((convert(float,MontoDebLoc) / convert(float,MontoDeb)),4)
		where MontoDebLoc <> 0 
		  and MontoDeb <> 0
	</cfquery>	
    
	<cfquery name="rsActualizaMontos" datasource="#Session.DSN#">
		update #table_name#
			set Dtipocambio = round((convert(float,MontoCredLoc) / convert(float,MontoCred)),4)
		where MontoCredLoc <> 0 
		  and MontoCred <> 0
	</cfquery>	
    
	<!--- INSERTAR LOS ASIENTOS CONTABLES EN TABLA DE IMPORTACION --->
	<cfquery name="rsEncabezado" datasource="#Session.DSN#">
		select b.Cconcepto, b.Ereferencia
		from EContablesImportacion b
		where b.ECIid = #Session.ImportarAsientos.ECIid#
		and b.Ecodigo = #Session.Ecodigo#
	</cfquery>
    
	<cfquery name="rsDocs" datasource="#Session.DSN#">
		select a.Fecha, 
			   case when (a.EcodigoRef is not null and a.EcodigoRef <> 0 and a.EcodigoRef <> -1) then a.EcodigoRef
					else #Session.Ecodigo#
			   end as EcodigoRef, 
			   a.Periodo, a.Mes, a.Ddescripcion, a.Ddocumento, a.CFformato, 
			   round(coalesce(a.MontoDeb, 0.00),2) as MontoDeb, round(coalesce(a.MontoCred, 0.00),2) as MontoCred, 
			   round(coalesce(a.MontoDebLoc, 0.00), 2) as MontoDebLoc, round(coalesce(a.MontoCredLoc, 0.00),2) as MontoCredLoc, 
			   coalesce(a.Dtipocambio, 1.00) as Dtipocambio, b.Mcodigo, c.Ocodigo 
               <cfif LvarImportarCF eq 1>
               		, a.CFcodigo
               </cfif>
		from #table_name# a
			inner join Monedas b
				on a.Miso4217 = b.Miso4217
				and b.Ecodigo = #Session.Ecodigo#
		
			inner join Oficinas c
				on c.Oficodigo = a.Oficodigo
				and c.Ecodigo = (case when (a.EcodigoRef is not null and a.EcodigoRef <> 0 and a.EcodigoRef <> -1) then a.EcodigoRef else #Session.Ecodigo# end)
	</cfquery>

	<cfloop query="rsDocs">   
    	<cfset LvarcurrentRow =  #rsDocs.currentRow#>
        <cfset LvarEcodigoRef =  #rsDocs.EcodigoRef#>
        <cfset LvarFecha =  #rsDocs.Fecha#>
        <cfset LvarPeriodo =  #rsDocs.Periodo#>
        <cfset LvarMes =  #rsDocs.Mes#>
        <cfset LvarDdescripcion =  #rsDocs.Ddescripcion#>
        <cfset LvarDdocumento =  #rsDocs.Ddocumento#>
        <cfset LvarEreferencia =  #rsEncabezado.Ereferencia#>
        <cfset LvarMontoDeb =  #rsDocs.MontoDeb#>
        <cfset LvarMontoDebLoc =  #rsDocs.MontoDebLoc#>
		<cfset LvarCFformato =  #rsDocs.CFformato#>
        <cfset LvarOcodigo =  #rsDocs.Ocodigo#>
        <cfset LvarMcodigo =  #rsDocs.Mcodigo#>
        <cfset LvarMontoCred =  #rsDocs.MontoCred#>
        <cfset LvarMontoCredLoc =  #rsDocs.MontoCredLoc#>
        <cfset LvarDtipocambio =  #rsDocs.Dtipocambio#>
        <cfset LvarCconcepto =  #rsEncabezado.Cconcepto#>
        <cfif LvarImportarCF eq 1>
	        <cfset LvarCFcodigo =  #rsDocs.CFcodigo#>
        </cfif>
        
		<cfquery name="rsInsert" datasource="#Session.DSN#">
			insert into DContablesImportacion (
				DCIconsecutivo, 
				ECIid, 
				Ecodigo, 
				EcodigoRef, 
				DCIEfecha, 
				Eperiodo, 
				Emes, 
				Ddescripcion, 
				Ddocumento, 
				Dreferencia, 
				Dmovimiento, 
				CFformato, 
				Ocodigo, 
				Mcodigo, 
				Doriginal, 
				Dlocal, 
				Dtipocambio, 
				Cconcepto, 
				BMfalta, 
				BMUsucodigo
				<cfif LvarImportarCF eq 1>
					, CFcodigo
				</cfif>
                )
			values (
				#LvarcurrentRow#,
				#Session.ImportarAsientos.ECIid#,
				#Session.Ecodigo#,
				#LvarEcodigoRef#,
				<cfqueryparam cfsqltype="cf_sql_date" value="#LvarFecha#">,
				<cfqueryparam cfsqltype="cf_sql_smallint" value="#LvarPeriodo#">,
				<cfqueryparam cfsqltype="cf_sql_smallint" value="#LvarMes#">,
				'#LvarDdescripcion#',
				'#LvarDdocumento#',
				'#LvarEreferencia#',
				<cfif LvarMontoDeb NEQ 0 or LvarMontoDebLoc NEQ 0>
					'D', 
				<cfelse>
					'C', 
				</cfif>
				'#LvarCFformato#',
				#LvarOcodigo#,
				#LvarMcodigo#,
				<cfif Len(Trim(LvarMontoDeb)) and LvarMontoDeb NEQ 0>
					#LvarMontoDeb#, 
				<cfelse>
					#LvarMontoCred#, 
				</cfif>
				<cfif Len(Trim(LvarMontoDebLoc)) and LvarMontoDebLoc NEQ 0>
					#LvarMontoDebLoc#, 
				<cfelse>
					#LvarMontoCredLoc#, 
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_float" value="#LvarDtipocambio#">, 
				#LvarCconcepto#,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
				#Session.Usucodigo#
                <cfif LvarImportarCF eq 1>
					, '#LvarCFcodigo#'
                </cfif>
			)
		</cfquery>
        <cfquery name="rsSele" datasource="#Session.DSN#">
    	select Dtipocambio, (Doriginal / Dlocal) as tipo
		from DContablesImportacion
    </cfquery>
    </cfloop>

<cfelse>

	<cfif not bcheck1>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'Fecha no corresponde al encabezado de importación' as MSG, a.Fecha as FECHA
			from #table_name# a
			where not exists(
				select 1
				from EContablesImportacion b
				where b.Efecha = a.Fecha
				and b.ECIid = #Session.ImportarAsientos.ECIid#
			)
		</cfquery>

	<cfelseif not bcheck2>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'Código de Moneda no existe para la empresa' as MSG, a.Miso4217 as CODIGO_MONEDA
			from #table_name# a
			where not exists(
				select 1
				from Monedas b
				where b.Miso4217 = a.Miso4217
				and b.Ecodigo = #Session.Ecodigo#
			)
		</cfquery>
		
	<cfelseif not bcheck3>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'Código de Oficina no existe para la empresa origen o empresa referencia' as MSG, a.Oficodigo as CODIGO_OFICINA
			from #table_name# a
			where not exists(
				select 1
				from Oficinas c
				where c.Oficodigo = a.Oficodigo
				and c.Ecodigo = (case when (a.EcodigoRef is not null and a.EcodigoRef <> 0 and a.EcodigoRef <> -1) then a.EcodigoRef else #Session.Ecodigo# end)
			)
		</cfquery>

	<cfelseif not bcheck4>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'Las Transacciones tienen montos al Debito y al Credito, Incorrecto' as MSG, 
				a.CFformato as Cuenta, 
				a.Oficodigo as CODIGO_OFICINA, 
				a.Ddocumento as Documento, 
				a.MontoDeb as Debitos, 
				a.MontoCred as Creditos
			from #table_name# a
			where (MontoDeb <> 0 and MontoCred <> 0) or (MontoDebLoc <> 0 and MontoCredLoc <> 0)
		</cfquery>
	<cfelseif not bcheck5>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'El Centro funcional utilizado no existe en el sistema' as MSG, 
				a.CFcodigo as CODIGO_CENTRO_FUNCIONAL
			from #table_name# a
             where a.CFcodigo is not null
             and rtrim(a.CFcodigo) <> ''
             and not exists(
                select 1
                from CFuncional b
                where b.Ecodigo = #session.Ecodigo#
                and b.CFcodigo = a.CFcodigo
            )
		</cfquery>
    <cfelseif not bcheck6>   
    	<cfquery name="ERR" datasource="#Session.DSN#">
        Select distinct 'El tipo de Cambio indicado, no corresponde a la división de los montos entre la moneda local y original' as MSG, 
        				Dtipocambio as TIPO_CAMBIO,
                        MontoDebLoc	as MONTO_LOCAL,
                        MontoDeb as MONTO_ORI,
                        round((<cf_dbfunction name="to_float" args="MontoDebLoc" datasource="#Session.DSN#"> / <cf_dbfunction name="to_float" args="MontoDeb" datasource="#Session.DSN#">),4) as TIPO_CAMBIO_CALCULADO,
                        'D' as MOVIMIENTO
        from #table_name#
        where Dtipocambio <> round((<cf_dbfunction name="to_float" args="MontoDebLoc" datasource="#Session.DSN#"> / <cf_dbfunction name="to_float" args="MontoDeb" datasource="#Session.DSN#">),4)
          and MontoDeb > 0
        union
        Select 'El tipo de Cambio indicado, no corresponde a la división de los montos entre la moneda local y original' as MSG, 
        				Dtipocambio as TIPO_CAMBIO,
                        MontoCredLoc as MONTO_LOCAL,
                        MontoCred as MONTO_ORI,
                        round((<cf_dbfunction name="to_float" args="MontoCredLoc" datasource="#Session.DSN#"> / <cf_dbfunction name="to_float" args="MontoCred" datasource="#Session.DSN#">),4) as TIPO_CAMBIO_CALCULADO,
                        'C' as MOVIMIENTO
        from #table_name#
        where Dtipocambio <> round((<cf_dbfunction name="to_float" args="MontoCredLoc" datasource="#Session.DSN#"> / <cf_dbfunction name="to_float" args="MontoCred" datasource="#Session.DSN#">),4)
          and MontoCred > 0
        </cfquery>               
    <cfelseif bcheck7 or bcheck8>    
        <cfquery name="ERR" datasource="#Session.DSN#">
        Select distinct 'El monto de la moneda local indicado, no corresponde a la multiplicacion del monto original por el tipo de cambio' as MSG, 
        				Dtipocambio as TIPO_CAMBIO,
                        MontoDebLoc	as MONTO_LOCAL,
                        MontoDeb as MONTO_ORI,
                        'D' as MOVIMIENTO
        from #table_name#
        where  MontoDeb > 0
        and abs(MontoDeb * Dtipocambio - MontoDebLoc) > 0.01
        union
        Select 'El monto de la moneda local indicado, no corresponde a la multiplicacion del monto original por el tipo de cambio' as MSG,
        				Dtipocambio as TIPO_CAMBIO,
                        MontoCredLoc as MONTO_LOCAL,
                        MontoCred as MONTO_ORI,
                        'C' as MOVIMIENTO
        from #table_name#
        where MontoCred > 0
        and abs(MontoCred * Dtipocambio - MontoCredLoc) > 0.01
        </cfquery>   
	</cfif>
</cfif>
