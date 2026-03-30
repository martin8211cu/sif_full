<cfscript>
	bcheck1 = false; // Chequeo de Fechas
	bcheck2 = false; // Chequeo de Monedas
	bcheck3 = false; // Chequeo de Oficinas
	bcheck4 = false; // Chequeo de Monto solo en Debito o en Credito
	bcheck5 = false; // Chequeo de Integridad en encabezados de las ##Polizas
	bcheck6 = false; // Chequeo de existencia previa de las ##Polizas
</cfscript>

<!---NUEVO IMPORTADOR MASIVO DE ASIENTOS--->

<!---Se realiza lo siguiente: Se verifica si el encabezado indicado en la Consulta realizada ya existe 
Si no existe se 
se Agrega una Poliza, se Toma el maximo ECid generado, Se agrega y valida el detalle basados en ese ECid.
Si existe se toma el ECid de esta poliza, Se agrega y valida el detalle basados en ese ECid. --->

   
<!---Genera los Encabezados--->
<cfquery name="rsEncabezado" datasource="#Session.DSN#">
	select distinct EDocBase,Concepto,Edescrip,Referencia,Reversible,Fecha,Periodo,Mes
	into ##Polizas
	from #table_name#
</cfquery>

<!---Verifica que no existan Encabezados repetidos --->
<cfquery name="rsCheck5" datasource="#Session.DSN#">
	select count(1) as check5
	from #table_name# a
	where exists(
		select 1
		from ##Polizas b
		where b.EDocBase = a.EDocBase
		and (	b.Edescrip != a.Edescrip
			or b.Referencia != a.Referencia
			or b.Reversible != a.Reversible
			or b.Fecha != a.Fecha
			or b.Periodo != a.Periodo
			or b.Mes != a.Mes
            or b.Concepto != a.Concepto) )
</cfquery>
<cfset bcheck5 = rsCheck5.check5 LT 1>

<cfif bcheck5>
	<!--- Verifica que la Poliza a cargar no exista con anterioridad--->
	<cfquery name="rsCheck6" datasource="#Session.DSN#">
		select count(1) as check6 
        from #table_name# a
        where exists 
        (select 1 
        from EContables
        where Edocbase = a.EDocBase
        and Ecodigo =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">)
        or exists 
        (select 1 
        from HEContables
        where Edocbase = a.EDocBase
        and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">)
        or exists 
        (select 1 
        from EContablesImportacion
        where Edocbase = a.EDocBase
        and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">)
	</cfquery>
    <cfset bcheck6 = rsCheck6.check6 LT 1>
</cfif>

<cfif bcheck6>
	<!--- Inserta los encabezados de las ##Polizas --->
    <cfquery name="rsEncabezados" datasource="#Session.DSN#">
    	select *
        from ##Polizas 
    </cfquery>
	<cfif rsEncabezados.recordcount GT 0>
    <cfloop query="rsEncabezados">
    	<cfset varReversa = 0>
		<cfif rsEncabezados.Reversible EQ 'S'>
        	<cfset varReversa = 1>
        </cfif>
    	<cfquery datasource="#Session.DSN#">
            insert into EContablesImportacion
            (
                Ecodigo,
                Cconcepto,
                Eperiodo,
                Emes,
                Efecha,
                Edescripcion,
                Edocbase,
                Ereferencia,
                ECIreversible,
                BMfalta,
                BMUsucodigo 
            )
            values(
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEncabezados.Concepto#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEncabezados.Periodo#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEncabezados.Mes#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#rsEncabezados.Fecha#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEncabezados.Edescrip#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEncabezados.EDocBase#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEncabezados.Referencia#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#varReversa#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
                 )
    	</cfquery>
    </cfloop>
    	<cfquery datasource="#Session.DSN#">
        	update #table_name#
            set Idpoliza = b.ECIid
            from #table_name# a, EContablesImportacion b
            where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
            and a.EDocBase = b.Edocbase
        </cfquery>
        
		<!--- Chequear Validez de Fecha de los Asientos --->
    	<cfquery name="rsCheck1" datasource="#Session.DSN#">
        	select count(1) as check1
	        from #table_name# a
    	    where not exists(
        	    select 1
            	from EContablesImportacion b
	            where b.Efecha = a.Fecha
    	        and b.ECIid = a.Idpoliza
        	)
	    </cfquery>
    	<cfset bcheck1 = rsCheck1.check1 LT 1>
	</cfif>
</cfif>

<!--- Chequear Validez de las Monedas presentes en los Asientos --->
<cfif bcheck1>
	<cfquery name="rsCheck2" datasource="#Session.DSN#">
		select count(1) as check2
		from #table_name# a
		where not exists(
			select 1
			from Monedas b
			where b.Miso4217 = a.Miso4217
			and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
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
			and c.Ecodigo = (case when (a.EcodigoRef is not null and a.EcodigoRef <> 0 and a.EcodigoRef <> -1) then a.EcodigoRef else <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> end)
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

	<cfquery name="rsObtieneMonedaLocal" datasource="#Session.DSN#">
		select m.Mcodigo, m.Miso4217
		from Empresas e
			inner join Monedas m
				on m.Mcodigo = e.Mcodigo
		where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>

	<cfif rsObtieneMonedaLocal.recordcount GT 0>
		<cfset LvarMcodigo = rsObtieneMonedaLocal.Mcodigo>
		<cfset LvarMiso4217 = rsObtieneMonedaLocal.Miso4217>

		<cfquery name="rsActualizaMontos" datasource="#Session.DSN#">
			update #table_name#
			set MontoDebLoc = MontoDeb, MontoCredLoc = MontoCred, Dtipocambio = 1.00
			where Miso4217  =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarMiso4217#">
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
	<cfquery name="rsDocs" datasource="#Session.DSN#">
		select a.Fecha, 
			   case when (a.EcodigoRef is not null and a.EcodigoRef <> 0 and a.EcodigoRef <> -1) then a.EcodigoRef
					else <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			   end as EcodigoRef, 
			   a.Periodo, a.Mes, a.Ddescripcion, a.Ddocumento, a.CFformato, 
			   round(coalesce(a.MontoDeb, 0.00),2) as MontoDeb, round(coalesce(a.MontoCred, 0.00),2) as MontoCred, 
			   round(coalesce(a.MontoDebLoc, 0.00), 2) as MontoDebLoc, round(coalesce(a.MontoCredLoc, 0.00),2) as MontoCredLoc, 
			   coalesce(a.Dtipocambio, 1.00) as Dtipocambio, b.Mcodigo, c.Ocodigo, a.Idpoliza, a.Referencia,a.Concepto
		from #table_name# a
			inner join Monedas b
				on a.Miso4217 = b.Miso4217
				and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		
			inner join Oficinas c
				on c.Oficodigo = a.Oficodigo
				and c.Ecodigo = (case when (a.EcodigoRef is not null and a.EcodigoRef <> 0 and a.EcodigoRef <> -1) then a.EcodigoRef else <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> end)
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
				BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDocs.currentRow#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDocs.Idpoliza#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDocs.EcodigoRef#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#rsDocs.Fecha#">,
				<cfqueryparam cfsqltype="cf_sql_smallint" value="#rsDocs.Periodo#">,
				<cfqueryparam cfsqltype="cf_sql_smallint" value="#rsDocs.Mes#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDocs.Ddescripcion#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDocs.Ddocumento#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDocs.Referencia#">,
				<cfif rsDocs.MontoDeb NEQ 0 or rsDocs.MontoDebLoc NEQ 0>
					'D', 
				<cfelse>
					'C', 
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDocs.CFformato#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDocs.Ocodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDocs.Mcodigo#">,
				<cfif Len(Trim(rsDocs.MontoDeb)) and rsDocs.MontoDeb NEQ 0>
					<cfqueryparam cfsqltype="cf_sql_money" value="#rsDocs.MontoDeb#">, 
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_money" value="#rsDocs.MontoCred#">, 
				</cfif>
				<cfif Len(Trim(rsDocs.MontoDebLoc)) and rsDocs.MontoDebLoc NEQ 0>
					<cfqueryparam cfsqltype="cf_sql_money" value="#rsDocs.MontoDebLoc#">, 
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_money" value="#rsDocs.MontoCredLoc#">, 
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_float" value="#rsDocs.Dtipocambio#">, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDocs.Concepto#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			)
		</cfquery>
	</cfloop>
    <cfquery datasource="#session.DSN#">
			drop table ##Polizas
    </cfquery>

<cfelse>

	<cfif not bcheck5>
    	<cfquery name="ERR" datasource="#session.DSN#">
        	select distinct 'Revise los detalles del encabezado, error de integridad de los encabezados' as MSG, EDocBase as DOCUMENTO
			from #table_name# a
			where exists(
				select 1
				from ##Polizas b
				where b.EDocBase = a.EDocBase
				and (	b.Edescrip != a.Edescrip
					or b.Referencia != a.Referencia
					or b.Reversible != a.Reversible
					or b.Fecha != a.Fecha
					or b.Periodo != a.Periodo
					or b.Mes != a.Mes
        		    or b.Concepto != a.Concepto) )
        </cfquery>

    <cfelseif not bcheck6>
		<cfquery name="ERR" datasource="#session.DSN#">
        	select distinct 'Poliza ya Existe en Contabilidad' as MSG, a.EDocBase as DOCUMENTO
	        from #table_name# a
	        where exists 
    	    (select 1 
        	from EContables
	        where Edocbase = a.EDocBase
    	    and Ecodigo =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">)
        	or exists 
	        (select 1 
    	    from HEContables
        	where Edocbase = a.EDocBase
	        and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">)
    	    or exists 
        	(select 1 
	        from EContablesImportacion
    	    where Edocbase = a.EDocBase
        	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">)
		</cfquery>   
              
	<cfelseif not bcheck1>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'Fecha no corresponde al encabezado de importación' as MSG, a.Fecha as FECHA
			from #table_name# a
			where not exists(
				select 1
				from EContablesImportacion b
				where b.Efecha = a.Fecha
				and b.ECIid = a.Idpoliza
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
				and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
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
				and c.Ecodigo = (case when (a.EcodigoRef is not null and a.EcodigoRef <> 0 and a.EcodigoRef <> -1) then a.EcodigoRef else <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> end)
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
		
	</cfif>
    <cfquery datasource="#session.DSN#">
		delete EContablesImportacion 
        from EContablesImportacion a, ##Polizas b
        where a.Edocbase = b.EDocBase
        and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
        
        drop table ##Polizas
    </cfquery>
</cfif>
