<cf_dbstruct name="#arguments.Tabla#" returnvariable="rsStruct" datasource="#arguments.conexionO#">

<!---<cfset EcodigoViejo = 1121>--->

<cfif isdefined("rsStruct") and rsStruct.RecordCount neq 0 >
	<cfquery dbtype="query" name="rscampos">
		select *
		from rsStruct 
		where rsStruct.identity = 0
			and upper(rsStruct.name) not in ('ECODIGO','MCODIGO','CCUENTA')
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

<cf_dbdatabase table="#arguments.Padre#" datasource="#form.DSNO#" returnvariable="PadreOrigen">
<cf_dbdatabase table="#arguments.Padre#" datasource="#form.DSND#" returnvariable="PadreDestino">

<cf_dbdatabase table="CContables" datasource="#form.DSNO#" returnvariable="CContables_O">

<cfif not isdefined("form.chkSQL")>
	<cftransaction>
		<cftry>
			<cfquery datasource="#arguments.conexionD#" name="rsExisten">
				Select Ecodigo,* from CuentasBancos Where Ecodigo=#EcodigoNuevo# and CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
			</cfquery>
			
			<!---<cf_dump var="#rsExisten#">--->
				
				<cfif isdefined("rsExisten") and rsExisten.RecordCount neq 0>
					<cfquery datasource="#arguments.conexionD#" name="x">
						delete from CuentasBancos Where Ecodigo=#EcodigoNuevo#
					</cfquery>
				</cfif>
				
				<cfquery datasource="#arguments.conexionD#" name="x">
					insert into CuentasBancos(Ecodigo, Mcodigo, Ccuenta, #campos#)
						Select  #EcodigoNuevo#,  b.Mcodigo, d.Ccuenta, #campos#
							from #TablaOrigen# a, Empresas b, #CContables_O# c, CContables d
							Where a.Ecodigo	=	#EcodigoViejo#
								and b.Ecodigo	=	#EcodigoNuevo#
								and c.Ccuenta	=	a.Ccuenta
								and c.Cformato	=	d.Cformato
								and d.Ecodigo	=	#EcodigoNuevo#
				</cfquery>
						
				<cfquery datasource="#arguments.conexionD#" name="x">
					update CuentasBancos
					set Bid =(Select c.Bid 
						 from #PadreOrigen# b, #PadreDestino# c
						 where CuentasBancos.Bid = b.Bid
						 and b.Ecodigo = #EcodigoViejo#
						 and b.Bdescripcion = c.Bdescripcion
						 and c.Ecodigo = #EcodigoNuevo#)
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
		Select  #EcodigoNuevo#,  b.Mcodigo, d.Ccuenta, #campos#
			from #TablaOrigen# a, Empresas b, #CContables_O# c, CContables d
			Where a.Ecodigo	=	#EcodigoViejo#
				and b.Ecodigo	=	#EcodigoNuevo#
				and c.Ccuenta	=	a.Ccuenta
				and c.Cformato	=	d.Cformato
				and d.Ecodigo	=	#EcodigoNuevo#
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
	
	<cfset hilera = hilera & 'update CuentasBancos
					set Bid =(Select c.Bid 
						 from tmpBancos b, #PadreDestino# c
						 where CuentasBancos.Bid = b.Bid
						 and b.Ecodigo = #EcodigoViejo#
						 and b.Bdescripcion = c.Bdescripcion
						 and c.Ecodigo = #EcodigoNuevo#)
					Where Ecodigo = #EcodigoNuevo#' & '#chr(13)#'>

	<cfset archivo = "#TablaOrigen#">
	<cfset LvarDir = expandPath("/clonacion/scripts/")>

	<cfset txtfile = #LvarDir#&'032-CuentasBancos.txt'>
	<cffile action="write" nameconflict="overwrite" file="#txtfile#" output="#hilera#" charset="utf-8">

	<cfset session.LvarFiles = session.LvarFiles & '032-CuentasBancos.txt,'>	

</cfif>

<!---<cf_dump var="#x#">--->


