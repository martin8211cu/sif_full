<cf_dbstruct name="#arguments.Tabla#" returnvariable="rsStruct" datasource="#arguments.conexionO#">

<!---<cfset EcodigoViejo = 1181>--->

<cfif isdefined("rsStruct") and rsStruct.RecordCount neq 0 >
	<cfquery dbtype="query" name="rscampos">
		select *
		from rsStruct 
		where rsStruct.identity = 0
			and upper(rsStruct.name) not in ('ECODIGO')
	</cfquery>
	
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
				Select Ecodigo,RHTPcodigo from RHTPuestos Where Ecodigo=#EcodigoNuevo#
					and RHTPcodigo in (select RHTPcodigo from #TablaOrigen# where Ecodigo = #EcodigoViejo#)
			</cfquery>

			<cfif isdefined("rsExisten") and rsExisten.RecordCount neq 0>
				<!---<cfloop query="rsExisten" >
					<cfloop index = "lcampo" list = "#campos#" delimiters = ",">
						<cfquery datasource="#arguments.conexionD#" name="x">
							update RHTPuestos  set  #lcampo#   = 	(select  #lcampo#   from #TablaOrigen# v
																	 Where v.Ecodigo = #EcodigoViejo# 
																		and v.RHTPcodigo = '#rsExisten.RHTPcodigo#' )
								 Where Ecodigo = #EcodigoNuevo# 
										and RHTPcodigo = '#rsExisten.RHTPcodigo#'
						</cfquery>
					</cfloop>
				</cfloop>--->
				
				<cfquery datasource="#arguments.conexionD#">
					delete from RHTPuestos Where Ecodigo=#EcodigoNuevo#
						and RHTPcodigo in (select RHTPcodigo from #TablaOrigen# where Ecodigo = #EcodigoViejo#)
				</cfquery>
			</cfif>
			
			<cfquery datasource="#arguments.conexionD#" name="x">
				insert into RHTPuestos(Ecodigo,#campos#)
					Select #EcodigoNuevo#, #campos#
						From #TablaOrigen# 
						Where Ecodigo= #EcodigoViejo#
							and RHTPcodigo not in (select RHTPcodigo from #TablaDestino# a where a.Ecodigo = #EcodigoNuevo#)
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
		Select #EcodigoNuevo# as Ecodigo, #campos#
			From #TablaOrigen# 
				Where Ecodigo= #EcodigoViejo#
	</cfquery>
	<cfset insert_campos = ''>
	<cfset hilera = '#chr(13)#/* Tipos de Puestos */#chr(13)#'>
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
		<cfset sql_insert = "insert into #arguments.Tabla#(Ecodigo,#campos#) values (#x.Ecodigo#,#insert_campos#">
		<cfset hilera = hilera & sql_insert & '#chr(13)#'>
		<cfset insert_campos = ''>
	</cfloop>

	<cfset archivo = "#TablaOrigen#">
	<cfset LvarDir = expandPath("/clonacion/scripts/")>

	<cfset txtfile = #LvarDir#&'024-RHTPuestos.txt'>
	<cffile action="write" nameconflict="overwrite" file="#txtfile#" output="#hilera#" charset="utf-8">

	<cfset session.LvarFiles = session.LvarFiles & '024-RHTPuestos.txt,'>
</cfif>
