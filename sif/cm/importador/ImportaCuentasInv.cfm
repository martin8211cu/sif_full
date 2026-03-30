<!---mcz--->
<!---======== Tabla temporal de errores  ========--->
<cf_dbtemp name="errores" returnvariable="errores" datasource="#session.DSN#">
	<cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp> 

<cfquery name="rsImportador" datasource="#session.dsn#">
	select * from #table_name#
</cfquery>

<!--- Validar que no existan duplicados en el archivo --->
	<cfquery name="check1" datasource="#session.dsn#">
		select  count(1) as check1
		from #table_name#
		group by IACcodigogrupo
		having count(1) > 1
	</cfquery>
	<!--- <cfdump var="#check1.check1#"> --->
	<cfif check1.check1 gt 0>
		<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error!Codigo del grupo aparece duplicado en el archivo!')
		</cfquery>
	</cfif>	
	
<cfloop query="rsImportador">

	<!--- Validacion de la llave principal --->
	<cfquery name="rs" datasource="#session.dsn#">
		select count(1) as total
			from #table_name# a, IAContables b
			where a.IACcodigogrupo=b.IACcodigogrupo
			and a.IACcodigogrupo='#IACcodigogrupo#'
	</cfquery>
	<cfif rs.total GT 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error!El registro que desea insertar ya existe en el sistema!(#rsImportador.IACcodigogrupo#)!')
			</cfquery>
		</cfif>
	
	<!--- Validacion de la cuenta de inventario --->
	<cfquery name="rs" datasource="#session.dsn#">
		select count (1) as total
			from #table_name# a
			where 
			(	select count(1)
				    from CFinanciera b
				    where b.CFformato='#IACinventariof#'
				    and b.Ecodigo=#session.Ecodigo#
				  )  = 0
			and a.IACcodigogrupo='#IACcodigogrupo#'
	</cfquery>
	<cfif rs.total gt 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error!La cuenta de inventario no es valida(#rsImportador.IACinventariof#)!')
			</cfquery>
	</cfif>
		
	<!--- Validacion de la cuenta de ingajustef --->
	<cfquery name="rs" datasource="#session.dsn#">
		select count (1) as total
			from #table_name# a
			where (
					select count(1)
					from CFinanciera b
					where b.CFformato='#IACingajustef#'
					and b.Ecodigo=#session.Ecodigo#
					)=0
		and a.IACcodigogrupo='#IACcodigogrupo#'
	</cfquery>
	<cfif rs.total gt 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error!La cuenta de Ing Ajuste no es valida(#IACingajustef#)!')
			</cfquery>
		</cfif>
		
	<!--- Validacion de la cuenta de gastoajustef --->
	<cfquery name="rs" datasource="#session.dsn#">
		select count (1) as total
			from #table_name# a
			where (
							select count(1)
							from CFinanciera b
							where b.CFformato='#IACgastoajustef#'
							and b.Ecodigo=#session.Ecodigo#
							)=0
		and a.IACcodigogrupo='#IACcodigogrupo#'
	</cfquery>
	<cfif rs.total gt 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error!La cuenta de Gasto Ajuste no es valida(#IACgastoajustef#)!')
			</cfquery>
		</cfif>
		
	<!--- Validacion de la cuenta de IACcompraf --->
	<cfquery name="rs" datasource="#session.dsn#">
		select count (1) as total
			from #table_name# a
			where (
							select count(1)
							from CFinanciera b
							where b.CFformato='#IACcompraf#'
							and b.Ecodigo=#session.Ecodigo#
							)=0
		and a.IACcodigogrupo='#IACcodigogrupo#'
	</cfquery>
	<cfif rs.total gt 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error!La cuenta de compra no es valida(#IACcompraf#)!')
			</cfquery>
		</cfif>
		
	<!--- Validacion de la cuenta de IACingventaf--->
	<cfquery name="rs" datasource="#session.dsn#">
		select count (1) as total
			from #table_name# a
			where (
							select count(1)
							from CFinanciera b
							where b.CFformato='#IACingventaf#'
							and b.Ecodigo=#session.Ecodigo#
							)=0
		and a.IACcodigogrupo='#IACcodigogrupo#'
	</cfquery>
	<cfif rs.total gt 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error!La cuenta de ingreso de venta no es valida(#IACingventaf#)!')
			</cfquery>
		</cfif>
		
	<!--- Validacion de la cuenta de IACcostoventaf--->
	<cfquery name="rs" datasource="#session.dsn#">
		select count (1) as total
			from #table_name# a
			where(
							select count(1)
							from CFinanciera b
							where b.CFformato='#IACcostoventaf#'
							and b.Ecodigo=#session.Ecodigo#
							)=0
		and a.IACcodigogrupo='#IACcodigogrupo#'
	</cfquery>
	<cfif rs.total gt 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error!La cuenta costo de venta no es valida(#IACcostoventaf#)!')
			</cfquery>
		</cfif>
		
	<!--- Validacion de la cuenta de IACtransitof--->
	<cfquery name="rs" datasource="#session.dsn#">
		select count (1) as total
			from #table_name# a
				where (	select count(1)
						from CFinanciera b
						where b.CFformato='#IACtransitof#'
						and b.Ecodigo=#session.Ecodigo#
						)=0
		and a.IACcodigogrupo='#IACcodigogrupo#'
	</cfquery>
	<cfif rs.total gt 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error!La cuenta de transito no es valida(#IACtransitof#)!')
			</cfquery>
		</cfif>
		
</cfloop>

<cfquery name="rsErr" datasource="#session.dsn#">
	select count(1) as cantidad from #errores# 
</cfquery>
		

<!--- Inserciones --->
<cfif rsErr.cantidad eq 0>
<cfloop query="rsImportador">
	<cfquery name="inventario" datasource="#session.dsn#">
		select Ccuenta from CFinanciera where CFformato='#rsImportador.IACinventariof#'
	</cfquery>
	<cfquery name="ingajuste" datasource="#session.dsn#">
		select Ccuenta from CFinanciera where CFformato='#rsImportador.IACingajustef#'
	</cfquery>
		<cfquery name="gasto" datasource="#session.dsn#">
		select Ccuenta from CFinanciera where CFformato='#rsImportador.IACgastoajustef#'
	</cfquery>
	<cfquery name="compra" datasource="#session.dsn#">
		select Ccuenta from CFinanciera where CFformato='#rsImportador.IACcompraf#'
	</cfquery>	
	<cfquery name="venta" datasource="#session.dsn#">
		select Ccuenta from CFinanciera where CFformato='#rsImportador.IACingventaf#'
	</cfquery>
	<cfquery name="costo" datasource="#session.dsn#">
		select Ccuenta from CFinanciera where CFformato='#rsImportador.IACcostoventaf#'
	</cfquery>
	<cfquery name="transito" datasource="#session.dsn#">
		select Ccuenta from CFinanciera where CFformato='#rsImportador.IACtransitof#'
	</cfquery>	
	
	<cfquery name="rsIns" datasource="#session.dsn#">
		insert into IAContables
			(Ecodigo, 
			IACcodigogrupo,
			IACdescripcion,			
			IACinventario, 
			IACingajuste, 
			IACgastoajuste, 
			IACcompra,
			IACingventa, 
			IACcostoventa, 
			IACtransito)
        values
			(#session.Ecodigo#,
			'#rsImportador.IACcodigogrupo#',
			'#rsImportador.IACdescripcion#',
			#inventario.Ccuenta#,
			#ingajuste.Ccuenta#,
			#gasto.Ccuenta#,
			#compra.Ccuenta#,
			#venta.Ccuenta#,
			#costo.Ccuenta#,
			#transito.Ccuenta#
			)
	</cfquery>	
	</cfloop>
<cfelse>

	<cfquery name="ERR" datasource="#session.DSN#">
			select Error as MSG
			from #errores#
			order by Error
	</cfquery>
	<cfreturn>	
</cfif>

