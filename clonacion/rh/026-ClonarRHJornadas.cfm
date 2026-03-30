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
	
	<cfset cinsert = ''>
	<cfset icampos = ''>
	<cfset iscampos = ''>
	<cfset itipos  = ''>
	<cfset nReg1 = 1 >
	
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
			<cfset iscampos = iscampos & ' a.' & rsStruct.name &','>	
			
			<cfset itipos  = itipos  &  rsStruct.cf_type & ','>
			
		<cfelse>
			<cfset cinsert = cinsert & rsStruct.name & ' '& rsStruct.db_type & #largo#>	
			<cfset icampos = icampos & rsStruct.name>	
			<cfset iscampos = iscampos & ' a.' & rsStruct.name>	
			<cfset itipos  = itipos  & rsStruct.cf_type & ','>		
		</cfif>
		<cfset nReg1 = nReg1 + 1 >
	</cfloop>
</cfif>
<cf_dbdatabase table="#arguments.Tabla#" datasource="#form.DSNO#" returnvariable="TablaOrigen">
<cf_dbdatabase table="#arguments.Tabla#" datasource="#form.DSND#" returnvariable="TablaDestino">

<cf_dbdatabase table="CIncidentes" datasource="#form.DSNO#" returnvariable="CIncidentes_O">
<cf_dbdatabase table="CIncidentes" datasource="#form.DSND#" returnvariable="CIncidentes_D">

<cfset tmpRHJornadas = 'tmpRHJornadas' >

<cfif not isdefined("form.chkSQL")>
	<cftransaction>
		<cftry>
			<cfquery datasource="#arguments.conexionD#" name="rsExisten">
				Select Ecodigo, RHJcodigo from RHJornadas Where Ecodigo=#EcodigoNuevo#
					and RHJcodigo in (select RHJcodigo from #TablaOrigen# where Ecodigo = #EcodigoViejo#)
			</cfquery>
			
				<!---<cfdump var="#rsExisten#">--->

			<cfif isdefined("rsExisten") and rsExisten.RecordCount neq 0>
				<cfloop query="rsExisten" >
					<cfloop index = "lcampo" list = "#campos#" delimiters = ",">
						<cfquery datasource="#arguments.conexionD#" name="x">
							update RHJornadas  set  #lcampo#   = 	(select  #lcampo#   from #TablaOrigen# v
																	 Where v.Ecodigo = #EcodigoViejo# 
																		and v.RHJcodigo = '#rsExisten.RHJcodigo#' )
								 Where Ecodigo = #EcodigoNuevo# 
										and RHJcodigo = '#rsExisten.RHJcodigo#'
						</cfquery>
					</cfloop>
				</cfloop>
				
				<!---<cfquery datasource="#arguments.conexionD#">
					delete from RHTPuestos Where Ecodigo=#EcodigoNuevo#
						and RHTPcodigo in (select RHTPcodigo from #TablaOrigen# where Ecodigo = #EcodigoViejo#)
				</cfquery>--->

			</cfif>
			<cfquery datasource="#arguments.conexionD#" name="x">

				insert into RHJornadas(Ecodigo, #campos#)
					Select #EcodigoNuevo#, #campos#
						From #TablaOrigen# 
							Where Ecodigo= #EcodigoViejo#
								and RHJcodigo not in (select RHJcodigo from #TablaDestino# a where a.Ecodigo = #EcodigoNuevo#)
					
			</cfquery>

			<cfquery datasource="#arguments.conexionD#" name="x">
				
				update RHJornadas
					set RHJincFeriados = (Select c.CIid
						from #CIncidentes_O# b, #CIncidentes_D# c
							Where RHJornadas.RHJincFeriados = b.CIid
							and b.Ecodigo 	= #EcodigoViejo#
							and b.CIcodigo 	= c.CIcodigo
						and c.Ecodigo 	= #EcodigoNuevo#)
				Where Ecodigo 	= #EcodigoNuevo#
			</cfquery>

			<cfquery datasource="#arguments.conexionD#" name="x">
				update RHJornadas
				set RHJincAusencia = (Select c.CIid
						from #CIncidentes_O# b, #CIncidentes_D# c
							Where RHJornadas.RHJincAusencia = b.CIid
							and b.Ecodigo	= #EcodigoViejo#
							and b.CIcodigo	= c.CIcodigo
							and c.Ecodigo	= #EcodigoNuevo#)
				Where Ecodigo = #EcodigoNuevo#
			</cfquery>
			
			<cfquery datasource="#arguments.conexionD#" name="x">
				update RHJornadas
				set RHJincHJornada = (Select c.CIid
					from #CIncidentes_O# b, #CIncidentes_D# c
						Where RHJornadas.RHJincHJornada = b.CIid
						and b.Ecodigo=#EcodigoViejo#
						and b.CIcodigo=c.CIcodigo
						and c.Ecodigo=#EcodigoNuevo#)
				Where Ecodigo=#EcodigoNuevo#
			</cfquery>
				
			<cfquery datasource="#arguments.conexionD#" name="x">
				update RHJornadas
				set RHJincExtraA = (Select c.CIid
						from #CIncidentes_O# b, #CIncidentes_D# c
							Where RHJornadas.RHJincExtraA = b.CIid
							and b.Ecodigo=#EcodigoViejo#
							and b.CIcodigo=c.CIcodigo
							and c.Ecodigo=#EcodigoNuevo#)
				Where Ecodigo=#EcodigoNuevo#
			</cfquery>

			<cfquery datasource="#arguments.conexionD#" name="x">
				update RHJornadas
				set RHJincExtraB = (Select c.CIid
					from #CIncidentes_O# b, #CIncidentes_D# c
						Where RHJornadas.RHJincExtraB = b.CIid
						and b.Ecodigo=#EcodigoViejo#
						and b.CIcodigo=c.CIcodigo
						and c.Ecodigo=#EcodigoNuevo#)
				Where Ecodigo=#EcodigoNuevo#
			</cfquery>
				
			<cfcatch type="database">
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
	</cfquery>
	
	<cfset insert_campos = ''>
	<cfset hilera = '/* Jornadas #chr(13)#se crea una tabla temporal tmpRHJornadas que es usada para hacer actualizaciones mas adelante */ #chr(13)#' >
	
	<cfset temporal = 'create table #tmpRHJornadas# (#cinsert#)'>
	
	<cfset hilera = hilera & temporal & '#chr(13)#'>

	<cfloop query="rsOrigen">
		
		<cfset idata  = ListToArray(icampos,',') >
		<cfset itypes = ListToArray(itipos,',') >

<!---<cf_dump var="#itypes#">--->

<!---		<cfloop from="1" to ="#arraylen(idata)#" index="i">--->
		<cfloop from="1" to =1 index="i">
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
		<cfset sql_insert = "insert into #tmpRHJornadas#(#icampos#) values (#insert_campos#">
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
	<cfset hilera = hilera & '#chr(13)#/* Jornadas */#chr(13)#'>
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
	
	<cfset hilera = hilera & '#chr(13)#/* Actualizacion de las incidencias asociadas a la jornada */#chr(13)#'>
	
	<cfset hilera = hilera & 'update RHJornadas
					set RHJincFeriados = (Select c.CIid
						from tmpCIncidentes b, CIncidentes c
							Where RHJornadas.RHJincFeriados = b.CIid
							and b.Ecodigo 	= #EcodigoViejo#
							and b.CIcodigo 	= c.CIcodigo
						and c.Ecodigo 	= #EcodigoNuevo#)
				Where Ecodigo 	= #EcodigoNuevo#' & '#chr(13)#'>
					
					
	<cfset hilera = hilera & 'update RHJornadas
				set RHJincAusencia = (Select c.CIid
						from tmpCIncidentes b, CIncidentes c
							Where RHJornadas.RHJincAusencia = b.CIid
							and b.Ecodigo	= #EcodigoViejo#
							and b.CIcodigo	= c.CIcodigo
							and c.Ecodigo	= #EcodigoNuevo#)
				Where Ecodigo = #EcodigoNuevo#' & '#chr(13)#'>
					
	<cfset hilera = hilera & 'update RHJornadas
				set RHJincHJornada = (Select c.CIid
					from tmpCIncidentes b, CIncidentes c
						Where RHJornadas.RHJincHJornada = b.CIid
						and b.Ecodigo=#EcodigoViejo#
						and b.CIcodigo=c.CIcodigo
						and c.Ecodigo=#EcodigoNuevo#)
				Where Ecodigo=#EcodigoNuevo#' & '#chr(13)#'>
				
	<cfset hilera = hilera & 'update RHJornadas
				set RHJincExtraA = (Select c.CIid
						from tmpCIncidentes b, CIncidentes c
							Where RHJornadas.RHJincExtraA = b.CIid
							and b.Ecodigo=#EcodigoViejo#
							and b.CIcodigo=c.CIcodigo
							and c.Ecodigo=#EcodigoNuevo#)
				Where Ecodigo=#EcodigoNuevo#' & '#chr(13)#'>
			
	<cfset hilera = hilera & 'update RHJornadas
				set RHJincExtraB = (Select c.CIid
					from tmpCIncidentes b, CIncidentes c
						Where RHJornadas.RHJincExtraB = b.CIid
						and b.Ecodigo=#EcodigoViejo#
						and b.CIcodigo=c.CIcodigo
						and c.Ecodigo=#EcodigoNuevo#)
				Where Ecodigo=#EcodigoNuevo#' & '#chr(13)#'>

	<cfset archivo = "#TablaOrigen#">
	<cfset LvarDir = expandPath("/clonacion/scripts/")>

	<cfset txtfile = #LvarDir#&'026-RHJornadas.txt'>
	<cffile action="write" nameconflict="overwrite" file="#txtfile#" output="#hilera#" charset="utf-8">

	<cfset session.LvarFiles = session.LvarFiles & '026-RHJornadas.txt,'>
</cfif>


