<cf_dbstruct name="#arguments.Tabla#" returnvariable="rsStruct" datasource="#arguments.conexionO#">

<cfif isdefined("rsStruct") and rsStruct.RecordCount neq 0 >
	<cfquery dbtype="query" name="rscampos">
		select *
		from rsStruct 
		where rsStruct.identity = 0
			and upper(rsStruct.name) not in ('ECODIGO','RHJID')
	</cfquery>
	
	
	<cfset campos = ''>
	<cfset Scampos = ''>
	<cfset tipos  = ''>
	<cfset nReg = 1 >
	
	<cfset cinsert = ''>
	<cfset icampos = ''>
	<cfset iscampos = ''>
	<cfset itipos  = ''>
	<cfset nReg1 = 1 >
	
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

<cf_dbdatabase table="#arguments.Padre#" datasource="#form.DSNO#" returnvariable="PadreOrigen">
<cf_dbdatabase table="#arguments.Padre#" datasource="#form.DSND#" returnvariable="PadreDestino">

<cfset tmpRHComportamientoJornada = 'tmpRHComportamientoJornada' >
<cfif not isdefined("form.chkSQL")>
	<cftransaction>
		<cftry>
			<cfquery datasource="#arguments.conexionD#" name="rsExisten">
				Select a.RHJid 
					from RHComportamientoJornada a, RHJornadas b
					 	Where b.Ecodigo = #EcodigoNuevo# and a.RHJid = b.RHJid
			</cfquery>
			
			<!---<cfdump var="#rsExisten#">--->

			<cfif isdefined("rsExisten") and rsExisten.RecordCount neq 0>
				<cfquery datasource="#arguments.conexionD#">
					delete from RHComportamientoJornada
							where RHJid in ( Select a.RHJid 
											from RHComportamientoJornada a, RHJornadas b
											 Where b.Ecodigo = #EcodigoNuevo# 
												and a.RHJid = b.RHJid)
				</cfquery>
			</cfif>
			
			<cfquery datasource="#arguments.conexionD#" name="x">
				insert into RHComportamientoJornada(RHJid, #campos#)
					Select c.RHJid, #Scampos#
						from #TablaOrigen# a, #PadreOrigen# b, #PadreDestino# c
							Where a.RHJid		= b.RHJid
								and b.Ecodigo	= #EcodigoViejo#
								and b.RHJcodigo	= c.RHJcodigo
								and c.Ecodigo	= #EcodigoNuevo#
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
		Select #iscampos#
			From #TablaOrigen# a, #PadreOrigen# b
				Where a.RHJid		= b.RHJid
					and b.Ecodigo	= #EcodigoViejo#
	</cfquery>
		
	<cfset insert_campos = ''>
	<cfset hilera = '/* Comportamiento de Jornadas #chr(13)#se crea una tabla temporal tmpRHComportamientoJornada que es usada para hacer actualizaciones mas adelante */ #chr(13)#' >
	
	<cfset temporal = 'create table #tmpRHComportamientoJornada# (#cinsert#)'>
	
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
		<cfset sql_insert = "insert into #tmpRHComportamientoJornada#(#icampos#) values (#insert_campos#">
		<cfset hilera = hilera & sql_insert & '#chr(13)#'>
		<cfset insert_campos = ''>
	</cfloop>

<!-------------------------------------------------------------------------------------------->

<cfset hilera = hilera & '#chr(13)#/* Comportamiento de Jornadas */#chr(13)#'>
	
	<cfset hilera = hilera & '#chr(13)#/* Actualiza en la temporal Comportamiento de jornadas */#chr(13)#
	update tmpRHComportamientoJornada set RHJid = (
	Select c.RHJid
	from tmpRHJornadas b, RHJornadas c
	Where tmpRHComportamientoJornada.RHJid = b.RHJid
		and b.Ecodigo	= #EcodigoViejo#
		and b.RHJcodigo	= c.RHJcodigo)'>
		
	<cfset hilera = hilera & '#chr(13)#/* Insert Deducciones Excluir por Calendario ya actulizado */#chr(13)#
	insert into RHComportamientoJornada  (RHJid,#campos#) (select RHJid, #campos# from tmpRHComportamientoJornada) #chr(13)#'>	

	
	<cfset archivo = "#TablaOrigen#">
	<cfset LvarDir = expandPath("/clonacion/scripts/")>

	<cfset txtfile = #LvarDir#&'028-RHComportamientoJornada.txt'>
	<cffile action="write" nameconflict="overwrite" file="#txtfile#" output="#hilera#" charset="utf-8">

	<cfset session.LvarFiles = session.LvarFiles & '028-RHComportamientoJornada.txt,'>
</cfif>
<!---<cf_dump var="#x#">--->


