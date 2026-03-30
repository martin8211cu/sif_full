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
			<cfset iscampos = iscampos & 'a.'& rsStruct.name &','>	
			<cfset itipos  = itipos  &  rsStruct.cf_type & ','>
		<cfelse>
			<cfset cinsert = cinsert & rsStruct.name & ' '& rsStruct.db_type & #largo#>	
			<cfset icampos = icampos & rsStruct.name>	
			<cfset iscampos = iscampos & 'a.'& rsStruct.name>	
			<cfset itipos  = itipos  & rsStruct.cf_type & ','>		
		</cfif>
		<cfset nReg1 = nReg1 + 1 >
	</cfloop>	
</cfif>
<cf_dbdatabase table="#arguments.Tabla#" datasource="#form.DSNO#" returnvariable="TablaOrigen">
<cf_dbdatabase table="#arguments.Tabla#" datasource="#form.DSND#" returnvariable="TablaDestino">

<cfset tmpRHTipoAccion = 'tmpRHTipoAccion' >

<cfset TablaOrigen1 = 'CIncidentes' >


<cfif not isdefined("form.chkSQL")>
	<cftransaction>
		<cftry>
			<cfquery datasource="#arguments.conexionD#" name="rsExisten">
				Select Ecodigo,RHTcodigo from RHTipoAccion Where Ecodigo=#EcodigoNuevo#
					and RHTcodigo in (select RHTcodigo from #TablaOrigen# where Ecodigo = #EcodigoViejo#)
			</cfquery>
			
			<!---<cfdump var="#rsExisten#">--->
			
			<cfif isdefined("rsExisten") and rsExisten.RecordCount neq 0>
				<cfloop query="rsExisten" >
				<cfloop index = "lcampo" list = "#campos#" delimiters = ",">
					<cfquery datasource="#arguments.conexionD#" name="x">
						update RHTipoAccion  set  #lcampo#   = 	(select  #lcampo#   from #TablaOrigen# v
																 Where v.Ecodigo = #EcodigoViejo# 
																	and v.RHTcodigo = '#rsExisten.RHTcodigo#' )
							 Where Ecodigo = #EcodigoNuevo# 
									and RHTcodigo = '#rsExisten.RHTcodigo#'
					</cfquery>
				</cfloop>
				</cfloop>
			</cfif>
			<cfquery datasource="#arguments.conexionD#" name="x">
				insert into RHTipoAccion(Ecodigo,#campos#)
					Select #EcodigoNuevo#, #campos#
						From #TablaOrigen# 
							Where Ecodigo= #EcodigoViejo#
								and RHTcodigo not in (select RHTcodigo from #TablaDestino# a where a.Ecodigo = #EcodigoNuevo#)
			</cfquery>

			<cfquery datasource="#arguments.conexionD#" name="x">
				update RHTipoAccion
					set CIncidente1= (Select c.CIid 
							  from #TablaOrigen1# b, CIncidentes c
							  Where b.Ecodigo = #EcodigoViejo#
									   and RHTipoAccion.CIncidente1 = b.CIid
							   and b.CIcodigo=c.CIcodigo
							   and c.Ecodigo = #EcodigoNuevo#)
					Where Ecodigo = #EcodigoNuevo#
					and CIncidente1 is not null
			</cfquery>
			
			<cfquery datasource="#arguments.conexionD#" name="x">
				update RHTipoAccion
				set CIncidente2= (Select c.CIid 
						  from #TablaOrigen1# b, CIncidentes c
						  Where b.Ecodigo = #EcodigoViejo#
								   and RHTipoAccion.CIncidente2 = b.CIid
						   and b.CIcodigo=c.CIcodigo
						   and c.Ecodigo = #EcodigoNuevo#)
				Where Ecodigo = #EcodigoNuevo#
				and CIncidente2 is not null
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
	<cfset hilera = '/* Tipos de Accion #chr(13)# Clonacion Tipos Accion, se crea una tabla temporal tmpRHTipoAccion que es usada para hacer actualizaciones mas adelante */ #chr(13)#' >
	<cfset temporal = 'create table #tmpRHTipoAccion# (#cinsert#)'>
	
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
		<cfset sql_insert = "insert into #tmpRHTipoAccion#(#icampos#) values (#insert_campos#">
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
	<cfset hilera = hilera & '#chr(13)#/*Encabezado tipos de accion*/#chr(13)#'>
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
	
	<cfset hilera = hilera & '#chr(13)# /*Actulizacion de datos */ #chr(13)#
	update RHTipoAccion
	set CIncidente1= (Select c.CIid 
	  from tmpCIncidentes b, CIncidentes c
	  Where b.Ecodigo = #EcodigoViejo#
			   and RHTipoAccion.CIncidente1 = b.CIid
	   and b.CIcodigo=c.CIcodigo
	   and c.Ecodigo = #EcodigoNuevo#)
	Where Ecodigo = #EcodigoNuevo#
	and CIncidente1 is not null #chr(13)#'>
					
					
	<cfset hilera = hilera & '#chr(13)# 
	update RHTipoAccion
	set CIncidente2= (Select c.CIid 
	  from tmpCIncidentes b, CIncidentes c
	  Where b.Ecodigo = #EcodigoViejo#
			   and RHTipoAccion.CIncidente2 = b.CIid
	   and b.CIcodigo=c.CIcodigo
	   and c.Ecodigo = #EcodigoNuevo#)
	Where Ecodigo = #EcodigoNuevo#
	and CIncidente2 is not null #chr(13)#'>
	
	<cfset archivo = "#TablaOrigen#">
	<cfset LvarDir = expandPath("/clonacion/scripts/")>

	<cfset txtfile = #LvarDir#&'021-RHTipoAccion.txt'>
	<cffile action="write" nameconflict="overwrite" file="#txtfile#" output="#hilera#" charset="utf-8">

	<cfset session.LvarFiles = session.LvarFiles & '021-RHTipoAccion.txt,'>
</cfif>
