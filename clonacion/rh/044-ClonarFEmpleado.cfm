<!---<cfdump var="#form#">--->

<cf_dbstruct name="#arguments.Tabla#" returnvariable="rsStruct" datasource="#arguments.conexionO#">

<cfif isdefined("rsStruct") and rsStruct.RecordCount neq 0 >
	<cfquery dbtype="query" name="rscampos">
		select *
		from rsStruct 
		where rsStruct.identity = 0
			and upper(rsStruct.name) not in ('ECODIGO', 'DEID')
	</cfquery>
	
	<!---<cf_dump var="#rscampos#">--->

	<cfset campos = ''>
	<cfset Scampos = ''>
	<cfset tipos  = ''>
	
	<cfset nReg = 1 >
	
	<cfloop query="rscampos">
		<cfif  #nReg# NEQ #rscampos.recordCount#> 
			<cfset campos = campos & rscampos.name & ','>
			<cfset Scampos = Scampos & 'a.'&rscampos.name & ','>
			<cfset tipos  = tipos & rscampos.cf_type & ','>
		<cfelse>
			<cfset campos = campos & rscampos.name>
			<cfset Scampos = Scampos & 'a.'&rscampos.name>
			<cfset tipos  = tipos & rscampos.cf_type & ','>
		</cfif>
		<cfset nReg = nReg + 1 >
	</cfloop>
</cfif>

<cf_dbdatabase table="#arguments.Tabla#" datasource="#form.DSNO#" returnvariable="TablaOrigen">
<cf_dbdatabase table="#arguments.Tabla#" datasource="#form.DSND#" returnvariable="TablaDestino">
<cf_dbdatabase table="#arguments.Padre#" datasource="#form.DSNO#" returnvariable="PadreOrigen">
<cf_dbdatabase table="#arguments.Padre#" datasource="#form.DSND#" returnvariable="PadreDestino">

<cfif not isdefined("form.chkSQL")>
	<cftransaction>
		<cftry>
			<cfquery datasource="#arguments.conexionD#" name="x">
				insert into FEmpleado(DEid,#campos#)
					Select c.DEid, #Scampos#
						From #TablaOrigen# a, #PadreOrigen# b, #PadreDestino# c
							Where a.DEid = b.DEid
								and b.Ecodigo			=	#EcodigoViejo#
								and b.DEidentificacion	=	c.DEidentificacion
								and c.Ecodigo			=	#EcodigoNuevo#
								and c.DEid not in (select a.DEid from FEmpleado a, DatosEmpleado b
														where Ecodigo = #EcodigoNuevo#
														and a.DEid = b.DEid)
			</cfquery>
			<!---<cf_dump var="#x#">--->
			<cfcatch type="any">
				<cftransaction action="rollback"/>
				<cfset  ErrorMessage  =  '#cfcatch.Detail#>'>
				<!---<cfrethrow message="#ErrorMessage#">--->
				<cfrethrow>
			</cfcatch>
		</cftry>
	</cftransaction>
<cfelse>
	<cfquery datasource="#arguments.conexionD#" name="x">
		Select c.DEid, #Scampos#
			From #TablaOrigen# a, #PadreOrigen# b, #PadreDestino# c
				Where a.DEid = b.DEid
					and b.Ecodigo			=	#EcodigoViejo#
					and b.DEidentificacion	=	c.DEidentificacion
					and c.Ecodigo			=	#EcodigoNuevo#
					<!---and c.DEid not in (select a.DEid from FEmpleado a, DatosEmpleado b
											where Ecodigo = #EcodigoNuevo#
											and a.DEid = b.DEid)--->
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
		<cfset sql_insert = "insert into #arguments.Tabla#(DEid,#campos#) values (#x.DEid#,#insert_campos#">
		<cfset hilera = hilera & sql_insert & '#chr(13)#'>
		<cfset insert_campos = ''>
	</cfloop>

	<cfset archivo = "#TablaOrigen#">
	<cfset LvarDir = expandPath("/clonacion/scripts/")>

	<cfset txtfile = #LvarDir#&'044-FEmpleado.txt'>
	<cffile action="write" nameconflict="overwrite" file="#txtfile#" output="#hilera#" charset="utf-8">

	<cfset session.LvarFiles = session.LvarFiles & '044-FEmpleado.txt,'>

</cfif>	
