<cf_dbstruct name="#arguments.Tabla#" returnvariable="rsStruct" datasource="#arguments.conexionO#">

<!---<cf_dump var="#rsStruct#">--->

<cfif isdefined("rsStruct") and rsStruct.RecordCount neq 0 >
	<cfquery dbtype="query" name="rscampos">
		select *
		from rsStruct 
		where rsStruct.identity = 0
			and upper(rsStruct.name) not in ('ECODIGO','TDID')
			
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
			<cfset iscampos = iscampos & 'a.' & rsStruct.name &','>	
			
			<cfset itipos  = itipos  &  rsStruct.cf_type & ','>
			
		<cfelse>
			<cfset cinsert = cinsert & rsStruct.name & ' '& rsStruct.db_type & #largo#>	
			<cfset icampos = icampos & rsStruct.name>	
			<cfset iscampos = iscampos & 'a.' & rsStruct.name>	
			<cfset itipos  = itipos  & rsStruct.cf_type & ','>		
		</cfif>
		<cfset nReg1 = nReg1 + 1 >
	</cfloop>
	
</cfif>
<cf_dbdatabase table="#arguments.Tabla#" datasource="#form.DSNO#" returnvariable="TablaOrigen">
<cf_dbdatabase table="#arguments.Tabla#" datasource="#form.DSND#" returnvariable="TablaDestino">

<cf_dbdatabase table="#arguments.Padre#" datasource="#form.DSNO#" returnvariable="PadreOrigen">
<cf_dbdatabase table="#arguments.Padre#" datasource="#form.DSND#" returnvariable="PadreDestino">

<cfset tmpFDeduccion = 'tmpFDeduccion' >

<cfif not isdefined("form.chkSQL")>
	<cftransaction>
		<cftry>
			
			<cfquery datasource="#arguments.conexionD#" name="rsExisten">
				Select a.TDid 
					from FDeduccion a, TDeduccion b
						 Where b.Ecodigo = #EcodigoNuevo# 
							and a.TDid = b.TDid
			</cfquery>

			<cfif isdefined("rsExisten") and rsExisten.RecordCount neq 0>
				<cfquery datasource="#arguments.conexionD#">
					delete from FDeduccion
						where TDid in ( Select a.TDid 
											from FDeduccion a, TDeduccion b
												 Where b.Ecodigo = #EcodigoNuevo# 
													and a.TDid = b.TDid)
				</cfquery>
			</cfif>

			<cfquery datasource="#arguments.conexionD#" name="x">
				insert into FDeduccion(TDid,#campos#)
					Select c.TDid, #Scampos#
						from #TablaOrigen# a, #PadreOrigen# b, TDeduccion c
							Where a.TDid   = b.TDid
								and b.Ecodigo  =  #EcodigoViejo#
								and b.TDcodigo = c.TDcodigo
								and c.Ecodigo  = #EcodigoNuevo#
			</cfquery>

			<cfcatch type="database">
				<cftransaction action="rollback"/>
				<cfset  ErrorMessage  =  '#cfcatch.Detail#>'>
				<cfthrow message="#ErrorMessage#">
			</cfcatch>
		</cftry>
	</cftransaction>
<cfelse>

<!---incluir los datos de origen para hacer la actualizacion regla de tres--->
	<cfquery datasource="#arguments.conexionD#" name="rsOrigen">
		Select #iscampos#
			from #TablaOrigen# a, #PadreOrigen# b
				Where a.TDid   = b.TDid
					and b.Ecodigo  =  #EcodigoViejo#
	</cfquery>
	
	<cfset insert_campos = ''>
	<cfset hilera = '/* Detalle de las deducciones  #chr(13)# Clonacion detalle deducciones, se crea una tabla temporal tmpFDeduccion que es usada para hacer actualizaciones mas adelante */ #chr(13)#' >
	<cfset temporal = 'create table #tmpFDeduccion# (#cinsert#)'>
	
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
		<cfset sql_insert = "insert into #tmpFDeduccion#(#icampos#) values (#insert_campos#">
		<cfset hilera = hilera & sql_insert & '#chr(13)#'>
		<cfset insert_campos = ''>
	</cfloop>

<!-------------------------------------------------------------------------------------------->

	<cfset hilera = hilera & '#chr(13)#/* Detalle de tipos deducciones*/#chr(13)#'>
	
	<cfset hilera = hilera & '#chr(13)#/*Actulizacion de TDid en la tabla temporal*/ #chr(13)# 
	update tmpFDeduccion set TDid = (select b.TDid from tmpTDeduccion a, TDeduccion b
	where   a.TDcodigo   = b.TDcodigo
        and b.Ecodigo = #EcodigoNuevo#
        and  tmpFDeduccion.TDid = a.TDid )'>
		
	<cfset hilera = hilera & '#chr(13)#/*Insert de detalle de tipos deduccion ya actulizado	*/#chr(13)#
	insert into FDeduccion  (#icampos#) (select #icampos# from tmpFDeduccion)'>	
	
	<cfset archivo = "#TablaOrigen#">
	<cfset LvarDir = expandPath("/clonacion/scripts/")>

	<cfset txtfile = #LvarDir#&'016-FDeduccion.txt'>
	<cffile action="write" nameconflict="overwrite" file="#txtfile#" output="#hilera#" charset="utf-8">

	<cfset session.LvarFiles = session.LvarFiles & '016-FDeduccion.txt,'>
</cfif>

<!---<cfdump var="#x#">--->


