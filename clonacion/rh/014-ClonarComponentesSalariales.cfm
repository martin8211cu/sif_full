<cf_dbstruct name="#arguments.Tabla#" returnvariable="rsStruct" datasource="#arguments.conexionO#">

<cfif isdefined("rsStruct") and rsStruct.RecordCount neq 0 >
	<cfquery dbtype="query" name="rscampos">
		select *
		from rsStruct 
		where rsStruct.identity = 0
			and upper(rsStruct.name) not in ('ECODIGO','CAID')
	</cfquery>
	
	<cfset campos = ''>
	<cfset Scampos = ''>
	<cfset tipos  = ''>
	<cfset nReg = 1 >
	
	<cfloop query="rscampos">
		<cfif  #nReg# NEQ #rscampos.recordCount#> 
			<cfset Scampos = Scampos & 'a.'&rscampos.name & ','>
			<cfset campos = campos & rscampos.name & ','>
			<cfset tipos  = tipos & rscampos.cf_type & ','>
		<cfelse>
			<cfset Scampos = Scampos & 'a.'&rscampos.name>
			<cfset campos = campos & rscampos.name>
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
			<cfquery datasource="#arguments.conexionD#" name="rsExisten">
				Select a.CAid, a.CScodigo
				from ComponentesSalariales a, RHComponentesAgrupados b
				 Where b.Ecodigo = #EcodigoNuevo# 
					and a.CAid = b.RHCAid
			</cfquery>
			
			<!---<cf_dump var="#rsExisten#">--->
			<cfif isdefined("rsExisten") and rsExisten.RecordCount neq 0>
				<cfloop query="rsExisten" >
					<cfloop index = "lcampo" list = "#campos#" delimiters = ",">
						<cfquery datasource="#arguments.conexionD#" name="y">
						
								update ComponentesSalariales set #lcampo# = (select  #lcampo#   from  #TablaOrigen# v
																		 Where v.Ecodigo = #EcodigoViejo# 
																			and v.CScodigo = '#rsExisten.CScodigo#')
									 Where Ecodigo = #EcodigoNuevo# 
											and CScodigo = '#rsExisten.CScodigo#'

							</cfquery>
					</cfloop>
				</cfloop>
			</cfif>

			<cfquery datasource="#arguments.conexionD#" name="x">
				insert into ComponentesSalariales(Ecodigo, CAid, #campos#)
					Select #EcodigoNuevo#, c.RHCAid, #campos# 
						from   #TablaOrigen# a, #PadreOrigen# b, RHComponentesAgrupados c
							Where a.CAid 	= b.RHCAid
								and a.Ecodigo 	= #EcodigoViejo#
								and b.RHCAcodigo= c.RHCAcodigo
								and c.Ecodigo	= #EcodigoNuevo#
								and a.CScodigo not in (select CScodigo from #TablaOrigen# a where a.Ecodigo = #EcodigoNuevo#)
								
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
		Select #EcodigoNuevo# as Ecodigo, a.CAid, #campos# 
						from   #TablaOrigen# a, #PadreOrigen# b
							Where a.CAid 	= b.RHCAid
								and a.Ecodigo 	= #EcodigoViejo#
							
		
		
		<!---Select #EcodigoNuevo# as Ecodigo, c.RHCAid as CAid, #campos# 
						from   #TablaOrigen# a, #PadreOrigen# b, RHComponentesAgrupados c
							Where a.CAid 	= b.RHCAid
								and a.Ecodigo 	= #EcodigoViejo#
								and b.RHCAcodigo= c.RHCAcodigo
								and c.Ecodigo	= #EcodigoNuevo#
								and a.CScodigo not in (select CScodigo from #TablaOrigen# a where a.Ecodigo = #EcodigoNuevo#)--->
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
		<cfset sql_insert = "insert into #arguments.Tabla#(Ecodigo,CAid,#campos#) values (#x.Ecodigo#,#x.CAid#,#insert_campos#">
		<cfset hilera = hilera & sql_insert & '#chr(13)#'>
		<cfset insert_campos = ''>
	</cfloop>
	
	<cfset hilera = hilera & ' #chr(13)# /*Actualizacion de CAid */  #chr(13)# update ComponentesSalariales set CAid = 
	(select c.RHCAid  from tmpRHComponentes a, RHComponentesAgrupados c
	 where a.RHCAcodigo = c.RHCAcodigo 
	and a.RHCAid = ComponentesSalariales.CAid
	and  c.Ecodigo = #EcodigoNuevo#) #chr(13)#'>

	<cfset archivo = "#TablaOrigen#">
	<cfset LvarDir = expandPath("/clonacion/scripts/")>

	<cfset txtfile = #LvarDir#&'014-ComponentesSalariales.txt'>
	<cffile action="write" nameconflict="overwrite" file="#txtfile#" output="#hilera#" charset="utf-8">

	<cfset session.LvarFiles = session.LvarFiles & '014-ComponentesSalariales,'>
</cfif>

<!---<cfdump var="#x#">--->


