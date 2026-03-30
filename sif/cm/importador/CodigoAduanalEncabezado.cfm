<!---mcz--->
<!---======== Tabla temporal de errores  ========--->

<cf_dbtemp name="errores" returnvariable="errores" datasource="#session.DSN#">
	<cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp> 

<cfquery name="rsImportador" datasource="#session.dsn#">
select * from #table_name#
</cfquery>
<!---<cfquery name="rs" datasource="#session.dsn#">
select * from Impuestos
</cfquery>
<cf_dump var="#rs#">--->
<!--- Validar que no existan duplicados en el archivo --->
	<cfquery name="check1" datasource="#session.dsn#">
		select  count(1) as check1
		from #table_name#
		group by CAcodigo
		having count(1) > 1
	</cfquery>
	<cfif check1.check1 gt 0>
		<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error!Codigo del Aduana aparece duplicado en el archivo!')
		</cfquery>
	</cfif>	

<cfloop query="rsImportador">
<cfset CAcodigo=#rsImportador.CAcodigo#>
<cfset Icodigo=#rsImportador.Icodigo#>

<!--- Validaciones --->
<!--- Existencia del codigo  --->

<cfquery name="rsSQL" datasource="#session.dsn#">
	select count(1) as total
	from #table_name# a, CodigoAduanal b
	where a.CAcodigo=b.CAcodigo
	and a.CAcodigo='#CAcodigo#'
</cfquery>
<cfif rsSQL.total gt 0>	
		<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error!El codigo aduanal que se desea insertar ya existe en el sistema(#CAcodigo#)!')
		</cfquery>
</cfif>
<!--- Existencia del codigo de impuesto--->
<cfquery name="rsSQL" datasource="#session.dsn#">
	select count(1) as total
	from #table_name# a
	where a.CAcodigo='#CAcodigo#'
	and not exists(select Icodigo from Impuestos b
					where b.Icodigo='#Icodigo#'
					and b.Ecodigo =  #session.Ecodigo#)
</cfquery> 

<cfif rsSQL.total gt 0>	
	<cfquery name="ERR" datasource="#session.DSN#">
		insert into #errores# (Error)
		values ('Error!El codigo de impuesto no existe en el sistema(#Icodigo#)!')
	</cfquery>
</cfif>
</cfloop>

<cfquery name="rsERR" datasource="#session.dsn#">
	select count(1) as cantidad from #errores#
</cfquery>

<cfif rsERR.cantidad eq 0>
<cfloop query="rsImportador">
	<cfquery name="rsInsertaEncabezadoCA" datasource="#session.dsn#">
		insert into CodigoAduanal
			(Ecodigo, 
			Icodigo,
			CAcodigo,
			CAdescripcion,
			Usucodigo,
			fechaalta, 
			porcCIF,
			porcFOB, 
			porcSegLoc,
			porcFletLoc,
			porcAgeAdu,
			BMUsucodigo)
			values
		(<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
		<cfqueryparam cfsqltype="cf_sql_char" value="#rsImportador.Icodigo#">,					
		<cfqueryparam cfsqltype="cf_sql_char" value="#rsImportador.CAcodigo#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsImportador.CAdescripcion#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
		<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
		0.00, 0.00, 0.00, 0.00, 0.00,
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
