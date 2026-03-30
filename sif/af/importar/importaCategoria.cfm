<cf_dbtemp name="errores" returnvariable="errores" datasource="#session.DSN#">
	 <cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp> 

<cfquery  name="rsImportador" datasource="#session.dsn#">
  select * from #table_name# 
</cfquery>

<cfset session.Importador.SubTipo = "2">			
<cfloop query="rsImportador">
<cfset session.Importador.Avance = rsImportador.currentRow/rsImportador.recordCount>

<cfif len(trim(rsImportador.ACcodigodesc)) neq "">
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select 
		ACcodigo, 
		ACcodigodesc, 
		ACdescripcion, 
		ACvutil, 
		ACcatvutil, 
		ACmetododep, 
		ACmascara, 
		cuentac, 
		BMUsucodigo
		ts_rversion 
			from ACategoria 
			where Ecodigo  = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and ACcodigodesc = '#rsImportador.ACcodigodesc#'
	</cfquery>
</cfif>
<cfif (rsImportador.currentRow mod 179 EQ 0)>
	<cfoutput>
		<!-- Flush:
			#repeatString("*",1024)#
		-->
	</cfoutput>
	<cfflush interval="64">
</cfif>
	
<cfquery name="rsPeriodo" datasource="#session.dsn#">
	select Pvalor
	from Parametros 
	where Ecodigo = #session.Ecodigo#
	and Pcodigo = 50
</cfquery>

<cfquery name="rsMes" datasource="#session.dsn#">
	select Pvalor
	from Parametros 
	where Ecodigo = #session.Ecodigo#
	and Pcodigo = 60
</cfquery>

<!---Validar archivo de texto--->
<!--- Existencia de lineas blancas en el archivo de texto--->
	<cfif len(trim(rsImportador.ACcodigodesc)) eq 0 or len(trim(rsImportador.ACdescripcion)) eq 0 or len(trim(rsImportador.ACvutil)) eq 0
		or len(trim(rsImportador.ACcatvutil)) eq 0 or len(trim(rsImportador.ACmetododep)) eq 0 or len(trim(rsImportador.ACmascara)) eq 0>
		
		<cfquery name="ERR" datasource="#session.DSN#"><!--- Valida que la vida util no sea menor que cero--->
			insert into #errores# (Error)
			values ('Error! Existen Columnas en el archivo que estan en blanco')
		</cfquery>
	</cfif>
	
	<cfif isdefined("rsSQL") and rsSQL.recordcount gt 0>
	<!---Validacion: Existencia del Activo en el archivo de texto--->
		<cfquery datasource="#session.dsn#" name="Busca">
			select ACcodigodesc, count(1) as cantidad
			from #table_name# 
			where ACcodigodesc = '#rsImportador.ACcodigodesc#'
			group by ACcodigodesc
			having count(1)>1
		</cfquery>
		
	<cfif Busca.cantidad gt 0 >
		<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error. El Código (#rsImportador.ACcodigodesc#) esta repetido en el archivo!')
		</cfquery>
	</cfif>
	</cfif>
	<!--- --->
		
	<cfquery name="data" datasource="#session.DSN#">
		select max(ACcodigo) as ACcodigo
		from ACategoria 
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
	</cfquery>
			
	<cfif data.RecordCount gt 0 and len(trim(data.ACcodigo))>
		<cfset vACcod = data.ACcodigo + 1>
	</cfif>

<!--- --->

	<cfquery name="rsErrores" datasource="#session.DSN#">
		select count(1) as cantidad
		from #errores#
	</cfquery>
	
	<cfif rsErrores.cantidad eq 0>
		<cfquery datasource="#session.dsn#" name="rs">
			select count(1) as cantidad from ACategoria where ACcodigodesc='#rsSQL.ACcodigodesc#'
		</cfquery>
		<cfif rs.cantidad eq 0>
			<cfquery datasource="#session.dsn#">
				insert into ACategoria 
					(
					Ecodigo, 
					ACcodigo, 
					ACcodigodesc, 
					ACdescripcion, 
					ACvutil, 
					ACcatvutil, 
					ACmetododep, 
					ACmascara, 
					cuentac,
					BMUsucodigo
					)
				values( 
					#session.Ecodigo#,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#vACcod#">,		
					<cfqueryparam value="#rsImportador.ACcodigodesc#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#rsImportador.ACdescripcion#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#rsImportador.ACvutil#" cfsqltype="cf_sql_integer">,
					<cfif rsImportador.ACcatvutil EQ "S">
						'S',
					<cfelse>
						'N',
					</cfif>
					<cfqueryparam value="#rsImportador.ACmetododep#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#rsImportador.ACmascara#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#rsImportador.cuentac#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					  )
			 </cfquery>
			 
		<cfelse>
				<cfquery datasource="#session.dsn#">
					update  ACategoria 
						set 
						ACdescripcion = <cfqueryparam value="#rsImportador.ACdescripcion#" cfsqltype="cf_sql_varchar">,
						ACvutil = <cfqueryparam value="#rsImportador.ACvutil#" cfsqltype="cf_sql_integer">,
						ACcatvutil = <cfif isdefined("rsImportador.ACcatvutil")>'S'<cfelse>'N'</cfif>,
						ACmetododep = <cfqueryparam value="#rsImportador.ACmetododep#" cfsqltype="cf_sql_integer">,
						ACmascara = <cfqueryparam value="#rsImportador.ACmascara#" cfsqltype="cf_sql_varchar">,
						cuentac = <cfqueryparam value="#rsImportador.cuentac#" cfsqltype="cf_sql_varchar">   
					where 
					Ecodigo = #session.Ecodigo#
					and ACcodigo = #rsSQL.ACcodigo#
				</cfquery>
			</cfif>
		</cfif>
</cfloop>		

<cfquery name="rsErrores" datasource="#session.DSN#">
	select count(1) as cantidad
	from #errores#
</cfquery>

<cfif rsErrores.cantidad gt 0>
	<cfquery name="ERR" datasource="#session.DSN#">
		select Error as MSG
		from #errores#
	</cfquery>
	<cfreturn>		
</cfif>
<cfset session.Importador.SubTipo = 3>
