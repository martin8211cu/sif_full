<cfscript>
	bcheck1 = false; // Chequeo del Codigo del Documento
	bcheck2 = false; // Chequeo del Centro Funcional
	bcheck3 = false; // Chequeo de Cuenta Contable
	bcheck4 = false; // Chequeo de Codigo Impuesto
</cfscript>

<!--- Chequeo del Documento--->
<cfquery name="rsCheck1" datasource="#Session.DSN#">
	select count(1) as check1
	from #table_name# a
	where not exists(
		select 1
		from EMovimientos b
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and ltrim(rtrim(b.EMdocumento)) = rtrim(ltrim(a.Documento))
			and b.EMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EMid#">
	)
</cfquery>

<cfset bcheck1 = rsCheck1.check1 LTE 0>

<!--- Chequeo del Centro Funcional --->
<cfif bcheck1>
	<cfquery name="rsCheck2" datasource="#Session.DSN#">
		select count(1) as check2
		from #table_name# a
		where not exists(
				select 1 from CFuncional b
				where rtrim(ltrim(b.CFcodigo)) = rtrim(ltrim(a.CentroFuncional))
				and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		)
	</cfquery>
	<cfset bcheck2 = rsCheck2.check2 LTE 0>
</cfif>

<!--- Chequeo de Cuenta Contable --->
<cfif bcheck2>
	<cfquery name="rsCheck3" datasource="#Session.DSN#">
		select count(1) as check3
		from #table_name# a
		where not exists(
			select 1
			from CFinanciera b
			where rtrim(ltrim(b.CFformato)) = ltrim(rtrim(a.CuentaContable))
			 	and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		)
	</cfquery>
	<cfset bcheck3 = rsCheck3.check3 LTE 0>
</cfif>



<!--- OPARRALES 2018-10-26 Se agrega validacion para insertar el Icodigo --->
<cfif bcheck3>
	<cfquery name="rsCheckIcodigo" datasource="#Session.DSN#">
		select count(1) as check4
		from #table_name# a
		where not exists(
				select 1 from Impuestos b
				where rtrim(ltrim(b.Icodigo)) = rtrim(ltrim(a.Icodigo))
				and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		)
	</cfquery>
	<cfset bcheck4 = rsCheckIcodigo.check4 LTE 0>
</cfif>
<!--- OPARRALES 2018-10-26 FIN VALIDACION Icodigo --->

<cfif bcheck4>
	<cfquery datasource ="#session.DSN#" name="rsPrueba">
	    insert into DMovimientos (EMid,Ecodigo,Ccuenta,Dcodigo, CFid,DMmonto,DMdescripcion,CFcuenta,Icodigo)
		select b.EMid, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
			c.Ccuenta,
			0,
			d.CFid,
			a.Monto,
			a.Descripcion,
		    c.CFcuenta,
		    i.Icodigo
		from EMovimientos b
			inner join #table_name# a on ltrim(rtrim(b.EMdocumento)) = rtrim(ltrim(a.Documento))
			inner join CFinanciera c on rtrim(ltrim(c.CFformato)) = ltrim(rtrim(a.CuentaContable))
				and b.Ecodigo = c.Ecodigo
			inner join CFuncional d on rtrim(ltrim(d.CFcodigo)) = rtrim(ltrim(a.CentroFuncional))
				and b.Ecodigo = d.Ecodigo
			inner join Impuestos i on RTrim(LTrim(i.Icodigo)) = RTrim(LTrim(a.Icodigo))
				and i.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and b.EMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EMid#">
	</cfquery>
	
	<cfquery datasource ="#session.DSN#">
		update EMovimientos
		set EMtotal =
				(select coalesce(sum(DMmonto),0) as DMmonto
				 from DMovimientos
				 where EMid = EMovimientos.EMid)
		where EMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EMid#">
	</cfquery>
<cfelse>
	<cfif bcheck1 EQ 'false'>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'Existe una linea que corresponde al movimiento' as MSG, a.Documento
			from #table_name# a
			where not exists(
				select 1
				from EMovimientos b
				where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					and ltrim(rtrim(b.EMdocumento)) = rtrim(ltrim(a.Documento))
					and b.EMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EMid#">
			)
		</cfquery>
	<cfelseif bcheck2 EQ 'false'>
		<cfquery name="ERR" datasource="#Session.DSN#">
			select distinct 'El Centro Funcional no existe' as MSG, a.CentroFuncional as CentroFuncional
			from #table_name# a
			where not exists(
					select 1 from CFuncional b
					where rtrim(ltrim(b.CFcodigo)) = ltrim(rtrim(a.CentroFuncional))
					and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			)
		</cfquery>
	<cfelseif bcheck3 EQ 'false'>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'La cuenta no existe' as MSG, a.CuentaContable as CuentaContable
			from #table_name# a
			where not exists(
				select 1
				from CFinanciera b
				where rtrim(ltrim(b.CFformato)) = ltrim(rtrim(a.CuentaContable))
				 	and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			)
		</cfquery>
	<cfelseif bcheck4 eq 'false'>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'El Impuesto no existe' as MSG, a.Icodigo as Icodigo
			from #table_name# a
			where not exists(
				select 1
				from Impuestos b
				where rtrim(ltrim(b.Icodigo)) = ltrim(rtrim(a.Icodigo))
				 	and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			)
		</cfquery>
	</cfif>
</cfif>
