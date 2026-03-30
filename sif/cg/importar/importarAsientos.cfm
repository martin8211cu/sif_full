<cfscript>
	bcheck1 = false; // Chequeo de Fechas
	bcheck2 = false; // Chequeo de Monedas
	bcheck3 = false; // Chequeo de Oficinas
	bcheck4 = false; // Chequeo de Monto solo en Debito o en Credito
	bcheck5 = false; // Chequeo de Centro Funcional
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
			set Dtipocambio = MontoDebLoc / MontoDeb
		where MontoDebLoc <> 0 
		  and MontoDeb <> 0
	</cfquery>	

	<cfquery name="rsActualizaMontos" datasource="#Session.DSN#">
		update #table_name#
			set Dtipocambio = MontoCredLoc / MontoCred
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
			   ,a.uuid
		from #table_name# a
			inner join Monedas b
				on a.Miso4217 = b.Miso4217
				and b.Ecodigo = #Session.Ecodigo#
		
			inner join Oficinas c
				on c.Oficodigo = a.Oficodigo
				and c.Ecodigo = (case when (a.EcodigoRef is not null and a.EcodigoRef <> 0 and a.EcodigoRef <> -1) then a.EcodigoRef else #Session.Ecodigo# end)
	</cfquery>

	<cfloop query="rsDocs">   
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
				,uuid
                )
			values (
				#rsDocs.currentRow#,
				#Session.ImportarAsientos.ECIid#,
				#Session.Ecodigo#,
				#rsDocs.EcodigoRef#,
				<cfqueryparam cfsqltype="cf_sql_date" value="#rsDocs.Fecha#">,
				<cfqueryparam cfsqltype="cf_sql_smallint" value="#rsDocs.Periodo#">,
				<cfqueryparam cfsqltype="cf_sql_smallint" value="#rsDocs.Mes#">,
				'#rsDocs.Ddescripcion#',
				'#rsDocs.Ddocumento#',
				'#rsEncabezado.Ereferencia#',
				<cfif rsDocs.MontoDeb NEQ 0 or rsDocs.MontoDebLoc NEQ 0>
					'D', 
				<cfelse>
					'C', 
				</cfif>
				'#rsDocs.CFformato#',
				#rsDocs.Ocodigo#,
				#rsDocs.Mcodigo#,
				<cfif Len(Trim(rsDocs.MontoDeb)) and rsDocs.MontoDeb NEQ 0>
					#rsDocs.MontoDeb#, 
				<cfelse>
					#rsDocs.MontoCred#, 
				</cfif>
				<cfif Len(Trim(rsDocs.MontoDebLoc)) and rsDocs.MontoDebLoc NEQ 0>
					#rsDocs.MontoDebLoc#, 
				<cfelse>
					#rsDocs.MontoCredLoc#, 
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_float" value="#rsDocs.Dtipocambio#">, 
				#rsEncabezado.Cconcepto#,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
				#Session.Usucodigo#
                <cfif LvarImportarCF eq 1>
					, '#rsDocs.CFcodigo#'
                </cfif>
				,'#rsDocs.uuid#'
			)
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
	</cfif>
</cfif>
