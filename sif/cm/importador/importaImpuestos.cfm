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
		group by Icodigo
		having count(1) > 1
	</cfquery>
	<cfif check1.check1 gt 0>
		<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error!Codigo del Impuesto aparece duplicado en el archivo!')
		</cfquery>
	</cfif>	

<!--- Validaciones --->
<!--- Existencia del Impuesto --->
<cfloop query="rsImportador">
	<cfquery name="rsCheck2" datasource="#session.dsn#">	
		select 1 as check2,Icodigo
		from #table_name# a
		where  exists(
				select 1
				from Impuestos d
				where a.Icodigo = ltrim(rtrim(d.Icodigo))
				and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and a.Icodigo='#rsImportador.Icodigo#'
			)
		and a.Icodigo='#rsImportador.Icodigo#'	
	</cfquery>
	<cfif rsCheck2.check2 gt 0>	
		<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error!El codigo del impuesto ya existe en el sistema(#rsCheck2.Icodigo#)!')
		</cfquery>
	</cfif>
<!--- Validacion de la cuenta contable --->
	<cfquery name="rsCheck2" datasource="#session.dsn#">
		select count (1) as total
			from #table_name# a
			where 
			(	select count(1)
				    from CFinanciera b
				    where b.CFformato='#Ccuenta#'
				    and b.Ecodigo=#session.Ecodigo#
				  )  = 0
		and a.Icodigo='#rsImportador.Icodigo#'
	</cfquery>
	<cfif rsCheck2.total gt 0>	
		<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error!La cuenta contable no existe en el sistema(#rsImportador.Ccuenta#)!')
		</cfquery>
		<!--- Validacion de movimientos de la cuenta financiera --->
	<cfelse>
		<cfquery name="rsCheck2" datasource="#session.dsn#">
			select count (1) as total
				from #table_name# a
				where 
				(	select count(1)
						from CFinanciera b
						where b.CFformato='#Ccuenta#'
						and b.Ecodigo=#session.Ecodigo#
						and CFmovimiento='S'
					  )  = 0
			and a.Icodigo='#rsImportador.Icodigo#'
		</cfquery>
		<cfif rsCheck2.total gt 0>	
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error!La cuenta no acepta movimientos(#rsImportador.Ccuenta#)!')
			</cfquery>
		</cfif>
	</cfif>
</cfloop>

<cfquery name="rsERR" datasource="#session.dsn#">
	select count(1) as cantidad from #errores#
</cfquery>

<cfif rsERR.cantidad eq 0>
	<cfloop query="rsImportador">
		<cfquery name="cuenta" datasource="#session.dsn#">
			select Ccuenta from CFinanciera b
				where b.CFformato='#rsImportador.Ccuenta#'
				and b.Ecodigo=#session.Ecodigo#
		</cfquery>
		<cfquery name="rsImpuesto" datasource="#session.DSN#">
			insert into Impuestos
			(Ecodigo,Icodigo,Idescripcion,Iporcentaje,Ccuenta,Icompuesto,Icreditofiscal,Usucodigo,Ifecha,BMUsucodigo)
			values 
			(<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#rsImportador.Icodigo#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#rsImportador.Idescripcion#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#rsImportador.Iporcentaje#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#cuenta.Ccuenta#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#rsImportador.Icompuesto#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#rsImportador.Icreditofiscal#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 				
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> 
			)
		</cfquery>			
	</cfloop>
</cfif>
<cfif rsERR.cantidad gt 0>
		<cfquery name="ERR" datasource="#session.DSN#">
			select Error as MSG
			from #errores#
			order by Error
		</cfquery>
		<cfreturn>		
</cfif>	