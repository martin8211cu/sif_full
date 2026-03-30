<cf_dbstruct name="#arguments.Tabla#" returnvariable="rsStruct" datasource="#arguments.conexionO#">


<!---<cfset EcodigoViejo = 1186>--->

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
	
	<cf_dbdatabase table="#arguments.Tabla#" datasource="#form.DSNO#" returnvariable="TablaOrigen">
	<cf_dbdatabase table="#arguments.Tabla#" datasource="#form.DSND#" returnvariable="TablaDestino">
	
	<cf_dbdatabase table="Empresas" datasource="#form.DSNO#" returnvariable="Empresas_O">
	<cf_dbdatabase table="Empresas" datasource="#form.DSND#" returnvariable="Empresas_D">
	
</cfif>
<cfif not isdefined("form.chkSQL")>
	<cftransaction>
		<cftry>
			<cfquery datasource="#arguments.conexionD#" name="rsExisten">
				Select Ecodigo,Cmayor from CtasMayor Where Ecodigo=#EcodigoNuevo#
					and Cmayor in (select Cmayor from #TablaOrigen# where Ecodigo = #EcodigoViejo#)
			</cfquery>
			
			<!---<cf_dump var="#rsExisten#">--->
			
			<cfif isdefined("rsExisten") and rsExisten.RecordCount neq 0>
				<cfloop query="rsExisten" >
					<cfloop index = "lcampo" list = "#campos#" delimiters = ",">
						<cfquery datasource="#arguments.conexionD#" name="x">
							update CtasMayor  set  #lcampo#   = 	(select  #lcampo#   from #TablaOrigen# v
																	 Where v.Ecodigo = #EcodigoViejo# 
																		and v.Cmayor = '#rsExisten.Cmayor#')
								 Where Ecodigo = #EcodigoNuevo# 
										and Cmayor = '#rsExisten.Cmayor#'
						</cfquery>
					</cfloop>
				</cfloop>
			</cfif>
			
			<cfquery datasource="#arguments.conexionD#" name="x">
				insert into CtasMayor(Ecodigo,#campos#)
					Select #EcodigoNuevo#, #campos#
						From #TablaOrigen# 
						Where Ecodigo= #EcodigoViejo#
							and Cmayor not in (select Cmayor from #TablaDestino# a where a.Ecodigo = #EcodigoNuevo#)
			</cfquery>
			
			
			<cfquery datasource="#arguments.conexionD#" name="x">
				update CtasMayor set CEcodigo = (Select cliente_empresarial 
									from #Empresas_D#  c
										Where CtasMayor.Ecodigo = c.Ecodigo
											and c.Ecodigo  = #EcodigoNuevo#)
					Where Ecodigo = #EcodigoNuevo#
			</cfquery>
			
			<cfcatch type="any">
				<cftransaction action="rollback"/>
				<cfset  ErrorMessage  =  '#cfcatch.Detail#>'>
				<cfthrow message="#ErrorMessage#">

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
		<cfset sql_insert = "insert into #arguments.Tabla#(Ecodigo,#campos#) values (#x.Ecodigo#,#insert_campos#">
		<cfset hilera = hilera & sql_insert & '#chr(13)#'>
		<cfset insert_campos = ''>
	</cfloop>
	
	<cfset hilera = hilera &  '#chr(13)# /* Actulizacion de CEcodigo utilizando los valores de Tabla empresas Local */ #chr(13)# 
					update CtasMayor set CEcodigo = (Select cliente_empresarial 
							from #Empresas_D#  c
								Where CtasMayor.Ecodigo = c.Ecodigo
									and c.Ecodigo  = #EcodigoNuevo#)
					Where Ecodigo = #EcodigoNuevo#' & '#chr(13)#'>

	<cfset archivo = "#TablaOrigen#">
	<cfset LvarDir = expandPath("/clonacion/scripts/")>

	<cfset txtfile = #LvarDir#&'003-CtasMayor.txt'>
	<cffile action="write" nameconflict="overwrite" file="#txtfile#" output="#hilera#" charset="utf-8">

	<cfset session.LvarFiles = session.LvarFiles & '003-CtasMayor.txt,'>

</cfif>
