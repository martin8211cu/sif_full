<cf_dbstruct name="#arguments.Tabla#" returnvariable="rsStruct" datasource="#arguments.conexionO#">

<cfif isdefined("rsStruct") and rsStruct.RecordCount neq 0 >
	<cfquery dbtype="query" name="rscampos">
		select *
		from rsStruct 
		where rsStruct.identity = 0
			and upper(rsStruct.name) not in ('ECODIGO','ECID')
	</cfquery>
	
	<!---<cfdump var="#rscampos#">--->
	
	<cfset campos  = ''>
	<cfset Scampos = ''>
	<cfset tipos   = ''>
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

<cfset tmpDCargas = 'tmpDCargas' >

<cfif not isdefined("form.chkSQL")>
	<cftransaction>
		<cftry>
			<cfquery datasource="#arguments.conexionD#" name="rsExisten">
				Select *
					from   #TablaOrigen# a,  #PadreDestino# c
						Where a.ECid	=	c.ECid
							and c.Ecodigo	=	#EcodigoNuevo#
					<!---	and a.DCcodigo  in (Select a.DCcodigo from #TablaDestino# a, #PadreDestino# b
														 Where b.Ecodigo = #EcodigoNuevo# 
															and a.DCcodigo = b.DCcodigo	)		
			--->					
			</cfquery>
	
<!---			<cfif isdefined("rsExisten") and rsExisten.RecordCount neq 0>
				<cfquery datasource="#arguments.conexionD#">
					delete from CIncidentesD
						where CIid in ( Select a.CIid 
										from CIncidentesD a, CIncidentes b
										 Where b.Ecodigo = #EcodigoNuevo# 
											and a.CIid = b.CIid)
				</cfquery>
			</cfif>--->

			<cfquery datasource="#arguments.conexionD#" name="x">
			
				insert into DCargas(Ecodigo, ECid, #Scampos#)
					Select #EcodigoNuevo#, c.ECid, #Scampos# 
						from   #TablaOrigen# a, #PadreOrigen# b, #PadreDestino# c
							Where a.Ecodigo	=	#EcodigoViejo#
								and a.ECid	=	b.ECid
								and c.Ecodigo	=	#EcodigoNuevo#
								and b.ECcodigo	=	c.ECcodigo
								and a.DCcodigo not in (Select a.DCcodigo from #TablaDestino# a, #PadreDestino# b
																			 Where b.Ecodigo = #EcodigoNuevo# 
																				and a.ECid = b.ECid	)
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
		Select #iscampos#
			from   #TablaOrigen# a, #PadreOrigen# b
				Where a.Ecodigo	=	#EcodigoViejo#
					and a.ECid	=	b.ECid
	</cfquery>
	
	<cfset insert_campos = ''>
	<cfset hilera = '/* Detalle de Cargas #chr(13)# Clonacion Detalle Cargas, se crea una tabla temporal tmpDCargas que es usada para hacer actualizaciones mas adelante */ #chr(13)#' >
	
	<cfset temporal = 'create table #tmpDCargas# (#cinsert#)'>
	
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
		<cfset sql_insert = "insert into #tmpDCargas#(#icampos#) values (#insert_campos#">
		<cfset hilera = hilera & sql_insert & '#chr(13)#'>
		<cfset insert_campos = ''>
	</cfloop>

<!-------------------------------------------------------------------------------------------->



<cfset hilera = hilera & '#chr(13)#/* Detalle de Cargas */#chr(13)#'>
	
	<cfset hilera = hilera & '#chr(13)#/*Actulizacion de CIid en la tabla temporal*/ #chr(13)# 
	update tmpDCargas set ECid = (
	Select  c.ECid
	from tmpECargas b, ECargas c
	Where tmpDCargas.Ecodigo =	#EcodigoViejo#
		and tmpDCargas.ECid =	b.ECid
		and c.Ecodigo	=	1198
		and b.ECcodigo	=	c.ECcodigo), Ecodigo = #EcodigoNuevo#'>
		
	<cfset hilera = hilera & '#chr(13)#/*Insert de detalle de tipos deduccion ya actulizado	*/#chr(13)#
	insert into DCargas  (ECid,Ecodigo,#campos#) (select ECid,Ecodigo,#campos# from tmpDCargas)'>	
	
	<cfset archivo = "#TablaOrigen#">
	<cfset LvarDir = expandPath("/clonacion/scripts/")>

	<cfset txtfile = #LvarDir#&'034-DCargas.txt'>
	<cffile action="write" nameconflict="overwrite" file="#txtfile#" output="#hilera#" charset="utf-8">

	<cfset session.LvarFiles = session.LvarFiles & '034-DCargas.txt,'>
</cfif>
<!---<cf_dump var="x">--->


