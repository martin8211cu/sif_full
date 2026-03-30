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
		select  count(count(1)) as check1
		from #table_name#
		group by CAcodigo,Ppaisori
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
<cfset Ppaisori=#rsImportador.Ppaisori#>
<!---Validacion del Pais --->
<cfquery name="rsSQL" datasource="#session.dsn#">
	select count(1) as total
	from #table_name# a
	where a.CAcodigo='#CAcodigo#'
	and not exists(select Ppais from Pais b
					where b.Ppais='#Ppaisori#')
</cfquery>
<cfif rsSQL.total gt 0>
	<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error!El codigo del pais no esta registrado en el sistema(#Ppaisori#)!')
	</cfquery>
</cfif>
<!---Validacion del Codigo--->
<cfquery name="rsSQL" datasource="#session.dsn#">
	select count(1) as total
	from #table_name# a
	where a.CAcodigo='#CAcodigo#'
	and not exists(select CAcodigo from CodigoAduanal b
					where  b.CAcodigo='#CAcodigo#'
					and b.Ecodigo=#session.Ecodigo#)	
</cfquery>
<cfif rsSQL.total gt 0>
	<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error!El codigo aduanal no existe en el sistema(#CAcodigo#)!')
	</cfquery>
</cfif>
<!---Validacion del codigo de Impuesto--->
<cfquery name="rsSQL" datasource="#session.dsn#">
	select count(1) as total
	from #table_name# a
	where a.CAcodigo='#CAcodigo#'
	and not exists(select Icodigo from Impuestos b
					where b.Icodigo='#Icodigo#')
</cfquery>
<cfif rsSQL.total gt 0>
	<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error!El codigo del impuesto no existe(#Icodigo#)!')
	</cfquery>
</cfif>
<!--- Validacion de llaves --->
	<cfquery name="rs" datasource="#session.dsn#">
		select CAid from CodigoAduanal where CAcodigo='#CAcodigo#'
		and Ecodigo=#session.Ecodigo#
	</cfquery>
	<cfif rs.recordcount gt 0>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select count (1) as total 
			from ImpuestosCodigoAduanal
			where CAid=#rs.CAid#
			and Ppaisori='#Ppaisori#'
		</cfquery>	
		<cfif rsSQL.total gt 0>
		<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error!Ya existe un codigo aduanal(#CAcodigo#) en este pais (#Ppaisori#)!')
		</cfquery>
	</cfif>
</cfif>

</cfloop>
<cfquery name="rsERR" datasource="#session.dsn#">
	select count(1) as cantidad from #errores#
</cfquery>

<cfif rsERR.cantidad eq 0>
<cfloop query="rsImportador">
	<cfquery name="rs" datasource="#session.dsn#">
		select CAid from CodigoAduanal where CAcodigo='#rsImportador.CAcodigo#'
		and Ecodigo=#session.Ecodigo#
	</cfquery>
	<cfquery name="rsInsertaDetalleCA" datasource="#session.dsn#">
		insert into ImpuestosCodigoAduanal
			(CAid, Ppaisori, Ecodigo, Icodigo, Usucodigo,
			 fechaalta, porcCIF, porcFOB, porcSegLoc, porcFletLoc,
			 porcAgeAdu, BMUsucodigo)
		values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.CAid#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#rsImportador.Ppaisori#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#rsImportador.Icodigo#">,
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
