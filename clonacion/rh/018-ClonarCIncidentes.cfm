<cf_dbstruct name="#arguments.Tabla#" returnvariable="rsStruct" datasource="#arguments.conexionO#">

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
	
	
	<cfset cinsert = ''>
	<cfset icampos = ''>
	<cfset itipos  = ''>
	<cfset nReg1 = 1 >
	
	<cfloop query="rsStruct">
		<cfif rsStruct.cf_type  EQ 'S'>
			<cfset largo = '(#rsStruct.len#) null'> 
		<cfelse> 
			<cfset largo = ' null'>  
		</cfif>
		<cfif rsStruct.dbm_type  EQ 'L'>
			<cfset largo = ' DEFAULT 0'> 
		</cfif>
		
		<cfif  #nReg1# NEQ #rsStruct.recordCount#> 
			<cfset cinsert = cinsert & rsStruct.name & ' '& rsStruct.db_type & #largo# & ','>	
			<cfset icampos = icampos & rsStruct.name &','>	
			<cfset itipos  = itipos  &  rsStruct.cf_type & ','>
		<cfelse>
			<cfset cinsert = cinsert & rsStruct.name & ' '& rsStruct.db_type & #largo#>	
			<cfset icampos = icampos & rsStruct.name>	
			<cfset itipos  = itipos  & rsStruct.cf_type & ','>		
		</cfif>
		<cfset nReg1 = nReg1 + 1 >
	</cfloop>

</cfif>

<cf_dbdatabase table="#arguments.Tabla#" datasource="#form.DSNO#" returnvariable="TablaOrigen">
<cf_dbdatabase table="#arguments.Tabla#" datasource="#form.DSND#" returnvariable="TablaDestino">

<cf_dbdatabase table="CContables" datasource="#form.DSNO#" returnvariable="CContables_O">
<cf_dbdatabase table="CContables" datasource="#form.DSND#" returnvariable="CContables_D">

<cfset tmpCIncidentes = 'tmpCIncidentes' >


<cfif not isdefined("form.chkSQL")>
	<cftransaction>
		<cftry>
			<cfquery datasource="#arguments.conexionD#" name="rsExisten">
				Select Ecodigo,CIcodigo from CIncidentes Where Ecodigo=#EcodigoNuevo#
					and CIcodigo in (select CIcodigo from #TablaOrigen# where Ecodigo = #EcodigoViejo#)
			</cfquery>
			
			<cfif isdefined("rsExisten") and rsExisten.RecordCount neq 0>
				<cfloop query="rsExisten" >
					<cfloop index = "lcampo" list = "#campos#" delimiters = ",">
						<cfquery datasource="#arguments.conexionD#" name="ActualizaCampos">
							update CIncidentes  set  #lcampo#   = 	(select  #lcampo#   from #TablaOrigen# v
																	 Where v.Ecodigo = #EcodigoViejo# 
																		and v.CIcodigo = '#rsExisten.CIcodigo#' )
								 Where Ecodigo = #EcodigoNuevo# 
										and CIcodigo = '#rsExisten.CIcodigo#'
						</cfquery>
					</cfloop>
				</cfloop>
			</cfif>
			
			<cfquery datasource="#arguments.conexionD#" name="Inserta">
				insert into CIncidentes(Ecodigo,#campos#)
					Select #EcodigoNuevo#, #campos#
						From #TablaOrigen# 
							Where Ecodigo= #EcodigoViejo#
								and CIcodigo not in (select CIcodigo from CIncidentes a where a.Ecodigo = #EcodigoNuevo#)
			</cfquery>	
					
			
			<cfquery datasource="#arguments.conexionD#" name="ActualizaCuenta">
				update CIncidentes
					set Ccuenta=(Select c.Ccuenta 
						from #CContables_O# b, #CContables_D# c
						Where CIncidentes.Ccuenta=b.Ccuenta
						and b.Ecodigo  = #EcodigoViejo#
						and b.Cformato = c.Cformato
						and c.Ecodigo  = #EcodigoNuevo#)
					Where Ccuenta is not null
					and Ecodigo=#EcodigoNuevo#	
			</cfquery>	
			<cfcatch type="any">
				<cftransaction action="rollback"/>
				<cfset  ErrorMessage  =  '#cfcatch.Detail#>'>
				<cfrethrow>
			</cfcatch>
		</cftry>
	</cftransaction>
<cfelse>

	<!---incluir los datos de origen para hacer la actualizacion regla de tres--->
	<cfquery datasource="#arguments.conexionD#" name="rsOrigen">
		Select #icampos#
			From #TablaOrigen# 
				Where Ecodigo= #EcodigoViejo#
					<!---and CIcodigo not in (select CIcodigo from CIncidentes a where a.Ecodigo = #EcodigoNuevo#)--->
	</cfquery>

	<cfset insert_campos = ''>
	<cfset hilera = '#chr(13)#/*Crea tabla temporal para hacer la actulizacion de "regla de 3" de datos requeridos*/#chr(13)#'>
	<cfset temporal = 'create table #tmpCIncidentes# (#cinsert#)'>
	
	<cfset hilera = hilera & temporal & '#chr(13)#'>
	
	<cfloop query="rsOrigen">
		<cfset idata  = ListToArray(icampos,',') >
		<cfset itypes = ListToArray(itipos,',') >
		
		<cfloop from="1" to ="#arraylen(idata)#" index="i">
			<cfif len(trim(evaluate('rsOrigen.#idata[i]#'))) NEQ 0> 
				<cfset valor = trim(evaluate('rsOrigen.#idata[i]#'))> 
				<cfif #itypes[i]# EQ 'S'>
					<cfset valor = "'#valor#'">
				</cfif>
				<cfif #itypes[i]# EQ 'D'>
					<cfset valor ="'" & LSDateformat(LSParseDateTime(valor),'YYYYMMDD') & "'">
				</cfif>
			<cfelse> 
				<cfset valor = 'null' >
			</cfif>
			<cfset insert_campos = insert_campos & #valor#>
			<cfif i NEQ #arraylen(idata)#>
				<cfset insert_campos = insert_campos & ','>
			<cfelse>
				<cfset insert_campos = insert_campos & ')'>
			</cfif>
		</cfloop>
		<cfset sql_insert = "insert into #tmpCIncidentes#(#icampos#) values (#insert_campos#">
		<cfset hilera = hilera & sql_insert & '#chr(13)#'>
		<cfset insert_campos = ''>
		
	</cfloop>

<!-------------------------------------------------------------------------------------------->

	<cfquery datasource="#arguments.conexionD#" name="x">
		Select #EcodigoNuevo# as Ecodigo, #campos#
						From #TablaOrigen# 
							Where Ecodigo= #EcodigoViejo#
	</cfquery>
	<cfset insert_campos = ''>
	<cfset hilera = hilera & '#chr(13)#/*insert encabezado de incidencias*/#chr(13)#'>
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
	
	<cfset hilera = hilera & '#chr(13)#/*Actulizacion de las cuentas contables utilizando tabla temporal*/#chr(13)#'>
	
	<cfset hilera = hilera & 'update CIncidentes
	set Ccuenta=(Select c.Ccuenta 
		from tmpCContables b, CContables c
		Where CIncidentes.Ccuenta=b.Ccuenta
		and b.Ecodigo  = #EcodigoViejo#
		and b.Cformato = c.Cformato
		and c.Ecodigo  = #EcodigoNuevo#)
	Where Ccuenta is not null
	and Ecodigo=#EcodigoNuevo#' & '#chr(13)#'>

	<cfset archivo = "#TablaOrigen#">
	<cfset LvarDir = expandPath("/clonacion/scripts/")>

	<cfset txtfile = #LvarDir#&'018-CIncidentes.txt'>
	<cffile action="write" nameconflict="overwrite" file="#txtfile#" output="#hilera#" charset="utf-8">

	<cfset session.LvarFiles = session.LvarFiles & '018-CIncidentes.txt,'>

</cfif>

