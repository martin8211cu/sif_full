<cf_dbstruct name="#arguments.Tabla#" returnvariable="rsStruct" datasource="#arguments.conexionO#">

<!---<cfset EcodigoViejo = 1181>--->

<cfif isdefined("rsStruct") and rsStruct.RecordCount neq 0 >
	<cfquery dbtype="query" name="rscampos">
		select *
		from rsStruct 
		where rsStruct.identity = 0
			and upper(rsStruct.name) not in ('ECODIGO')
	</cfquery>
	
<!---	<cf_dump var="#rscampos#">--->
	
	<cfset campos = ''>
	<cfset tipos  = ''>
	<cfset nReg = 1 >
	
	<cfloop query="rscampos">
		<cfif  #nReg# NEQ #rscampos.recordCount#> 
			<cfset campos = campos & rscampos.name & ','>
			<cfset tipos  = tipos & rscampos.cf_type & ','>
		<cfelse>
			<cfset campos = campos & rscampos.name>
			<cfset tipos  = tipos & rscampos.cf_type & ','>
		</cfif>
		<cfset nReg = nReg + 1 >
	</cfloop>
</cfif>
<cf_dbdatabase table="#arguments.Tabla#" datasource="#form.DSNO#" returnvariable="TablaOrigen">
<cf_dbdatabase table="#arguments.Tabla#" datasource="#form.DSND#" returnvariable="TablaDestino">

<cfif not isdefined("form.chkSQL")>
	<cftransaction>
		<cftry>
			<cfquery datasource="#arguments.conexionD#" name="rsExisten">
				Select Ecodigo, RHTMcodigo from RHTipoMovimiento Where Ecodigo=#EcodigoNuevo#
					and RHTMcodigo in (select RHTMcodigo from #TablaOrigen# where Ecodigo = #EcodigoViejo#)
			</cfquery>
			
				<!---<cfdump var="#rsExisten#">--->

			<cfif isdefined("rsExisten") and rsExisten.RecordCount neq 0>
				<cfloop query="rsExisten" >
					<cfloop index = "lcampo" list = "#campos#" delimiters = ",">
						<cfquery datasource="#arguments.conexionD#" name="x">
							update RHTipoMovimiento  set  #lcampo#   = 	(select  #lcampo#   from #TablaOrigen# v
																	 Where v.Ecodigo = #EcodigoViejo# 
																		and v.RHTMcodigo = '#rsExisten.RHTMcodigo#' )
								 Where Ecodigo = #EcodigoNuevo# 
										and RHTMcodigo = '#rsExisten.RHTMcodigo#'
						</cfquery>
					</cfloop>
				</cfloop>
				
				<!---<cfquery datasource="#arguments.conexionD#">
					delete from RHTPuestos Where Ecodigo=#EcodigoNuevo#
						and RHTPcodigo in (select RHTPcodigo from #TablaOrigen# where Ecodigo = #EcodigoViejo#)
				</cfquery>--->

			</cfif>
			<cfquery datasource="#arguments.conexionD#" name="x">

				insert into RHTipoMovimiento(Ecodigo,BMUsucodigo , #campos#)
					Select #EcodigoNuevo#,BMUsucodigo , #campos#
						From #TablaOrigen# 
							Where Ecodigo= #EcodigoViejo#
								and RHTMcodigo not in (select RHTMcodigo from #TablaDestino# a where a.Ecodigo = #EcodigoNuevo#)
			</cfquery>
				
			<cfcatch type="database">
				<cftransaction action="rollback"/>
				<cfset  ErrorMessage  =  '#cfcatch.Detail#>'>
				<cfrethrow>

			</cfcatch>
		</cftry>
	</cftransaction>
<cfelse>
	<cfquery datasource="#arguments.conexionD#" name="x">
		Select #EcodigoNuevo# as Ecodigo,BMUsucodigo , #campos#
						From #TablaOrigen# 
							Where Ecodigo= #EcodigoViejo#
								<!---and RHTMcodigo not in (select RHTMcodigo from #TablaDestino# a where a.Ecodigo = #EcodigoNuevo#)--->
	</cfquery>
	<cfset insert_campos = ''>
	<cfset hilera = ''>
	<cfloop query="x">
		<cfset data  = ListToArray(campos,',') >
		<cfset types = ListToArray(tipos,',') >
		
		<cfloop from="1" to ="#arraylen(data)#" index="i">
			<cfif len(trim(evaluate('x.#data[i]#'))) NEQ 0> 
				<cfset valor = trim(evaluate('x.#data[i]#'))> 
				<cfif #types[i]# EQ 'S'>
					<cfset valor = "'#valor#'">
				</cfif>
				<cfif #types[i]# EQ 'D'>
					<cfset valor ="'" & LSDateformat(LSParseDateTime(valor),'YYYYMMDD') & "'">
				</cfif>
			<cfelse> 
				<cfset valor = 'null' >
			</cfif>
			<cfset insert_campos = insert_campos & #valor#>
			<cfif i NEQ #arraylen(data)#>
				<cfset insert_campos = insert_campos & ','>
			<cfelse>
				<cfset insert_campos = insert_campos & ')'>
			</cfif>
		</cfloop>
		<cfset sql_insert = "insert into #arguments.Tabla#(Ecodigo,#campos#) values (#x.Ecodigo#,#x.BMUsucodigo#,#insert_campos#">
		<cfset hilera = hilera & sql_insert & '#chr(13)#'>
		<cfset insert_campos = ''>
	</cfloop>

	<cfset archivo = "#TablaOrigen#">
	<cfset LvarDir = expandPath("/clonacion/scripts/")>

	<cfset txtfile = #LvarDir#&'050-RHTipoMovimiento.txt'>
	<cffile action="write" nameconflict="overwrite" file="#txtfile#" output="#hilera#" charset="utf-8">

	<cfset session.LvarFiles = session.LvarFiles & '050-RHTipoMovimiento.txt,'>
</cfif>


