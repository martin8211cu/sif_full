<cf_dbstruct name="#arguments.Tabla#" returnvariable="rsStruct" datasource="#arguments.conexionO#">

<!---<cfset EcodigoViejo = 1181>--->

<cfif isdefined("rsStruct") and rsStruct.RecordCount neq 0 >
	<cfquery dbtype="query" name="rscampos">
		select *
		from rsStruct 
		where rsStruct.identity = 0
			and upper(rsStruct.name) not in  ('ECODIGO','CIID')
	</cfquery>
	
<!---	<cfdump var="#rscampos#">--->
	
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

<cfset tmpCIncidentesD = 'tmpCIncidentesD' >

<cfif not isdefined("form.chkSQL")>
	<cftransaction>
		<cftry>
			<cfquery datasource="#arguments.conexionD#" name="rsExisten">
				Select a.CIid,b.Ecodigo
				from #TablaDestino# a, #PadreDestino# b
				 Where b.Ecodigo = #EcodigoNuevo# 
					and a.CIid = b.CIid
			</cfquery>
<!---			rsExisten
			<cfdump var="#rsExisten#">--->
	
			<cfif isdefined("rsExisten") and rsExisten.RecordCount neq 0>
				<cfquery datasource="#arguments.conexionD#">
					delete from CIncidentesD
						where CIid in ( Select a.CIid 
										from CIncidentesD a, CIncidentes b
										 Where b.Ecodigo = #EcodigoNuevo# 
											and a.CIid = b.CIid)
				</cfquery>
			</cfif>

			<cfquery datasource="#arguments.conexionD#" name="x">
			
				insert into CIncidentesD(CIid, #campos#)
					Select c.CIid, #Scampos# 
						from   #TablaOrigen# a, #PadreOrigen# b, #PadreDestino# c
							Where a.CIid = b.CIid
								and b.CIcodigo = c.CIcodigo
								and c.Ecodigo	= #EcodigoNuevo#
								and b.Ecodigo	= #EcodigoViejo#
								and c.CIid not in (Select a.CIid from #TablaDestino# a, #PadreDestino# b
																			 Where b.Ecodigo = #EcodigoNuevo# 
																				and a.CIid = b.CIid	)
								order by c.CIid
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
		Select  #iscampos#
			from   #TablaOrigen# a, #PadreOrigen# b
				Where a.CIid = b.CIid
					and b.Ecodigo	= #EcodigoViejo#					
	</cfquery>

	<cfset insert_campos = ''>
	<cfset hilera = '/* Detalle de las incidencias  #chr(13)# Clonacion detalle incidencias, se crea una tabla temporal tmpCIncidentesD que es usada para hacer actualizaciones mas adelante */ #chr(13)#' >
	
	<cfset temporal = 'create table #tmpCIncidentesD# (#cinsert#)'>
	
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
		<cfset sql_insert = "insert into #tmpCIncidentesD#(#icampos#) values (#insert_campos#">
		<cfset hilera = hilera & sql_insert & '#chr(13)#'>
		<cfset insert_campos = ''>
	</cfloop>

<!-------------------------------------------------------------------------------------------->

<cfset hilera = hilera & '#chr(13)#/* Detalle de tipos incidencias*/#chr(13)#'>
	
	<cfset hilera = hilera & '#chr(13)#/*Actulizacion de CIid en la tabla temporal*/ #chr(13)# 
	update tmpCIncidentesD set CIid = (select b.CIid from tmpCIncidentes a, CIncidentes b
	where   a.CIcodigo   = b.CIcodigo
        and b.Ecodigo = #EcodigoNuevo#
        and  tmpCIncidentesD.CIid = a.CIid )'>
		
	<cfset hilera = hilera & '#chr(13)#/*Insert de detalle de tipos deduccion ya actulizado	*/#chr(13)#
	insert into CIncidentesD  (#icampos#) (select #icampos# from tmpCIncidentesD)'>	

	
	<cfset archivo = "#TablaOrigen#">
	<cfset LvarDir = expandPath("/clonacion/scripts/")>

	<cfset txtfile = #LvarDir#&'019-CIncidentesD.txt'>
	<cffile action="write" nameconflict="overwrite" file="#txtfile#" output="#hilera#" charset="utf-8">

	<cfset session.LvarFiles = session.LvarFiles & '019-CIncidentesD.txt,'>
</cfif>
<!---<cfdump var="#x#">--->


