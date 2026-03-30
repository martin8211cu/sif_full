<cf_dbstruct name="#arguments.Tabla#" returnvariable="rsStruct" datasource="#arguments.conexionO#">

<cfif isdefined("rsStruct") and rsStruct.RecordCount neq 0 >
	<cfquery dbtype="query" name="rscampos">
		select *
		from rsStruct 
		where rsStruct.identity = 0
			and upper(rsStruct.name) not in ('ECODIGO','RVID')
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

<cf_dbdatabase table="#arguments.Padre#" datasource="#form.DSNO#" returnvariable="PadreOrigen">
<cf_dbdatabase table="#arguments.Padre#" datasource="#form.DSND#" returnvariable="PadreDestino">
<cfset tmpDRegimenVacaciones = 'tmpDRegimenVacaciones' >

<cfif not isdefined("form.chkSQL")>
	<cftransaction>
		<cftry>
			<cfquery datasource="#arguments.conexionD#" name="rsExisten">
				Select a.RVid 
					from DRegimenVacaciones a, RegimenVacaciones b
					 	Where b.Ecodigo = #EcodigoNuevo# and a.RVid = b.RVid
			</cfquery>
			
			<cfif isdefined("rsExisten") and rsExisten.RecordCount neq 0>
				<cfquery datasource="#arguments.conexionD#">
					delete from DRegimenVacaciones
						where RVid in ( Select a.RVid 
										from DRegimenVacaciones a, RegimenVacaciones b
										 Where b.Ecodigo = #EcodigoNuevo# 
											and a.RVid = b.RVid)
				</cfquery>
			</cfif>

			<cfquery datasource="#arguments.conexionD#" name="x">
				insert into DRegimenVacaciones(RVid,#campos#)
					Select c.RVid, #Scampos#
					from #TablaOrigen# a, #PadreOrigen# b, RegimenVacaciones c
						Where a.RVid=b.RVid
						and b.Ecodigo= #EcodigoViejo#
						and b.RVcodigo= c.RVcodigo
						and c.Ecodigo= #EcodigoNuevo#
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
				Where a.RVid=b.RVid
				and b.Ecodigo= #EcodigoViejo#
	</cfquery>
	
	

	<cfset insert_campos = ''>
	<cfset hilera = '/* Clonacion de datos Detalle Regimen de vacaciones, se crea una tabla temporal tmpDRegimenVacaciones que es usada para hacer actualizaciones mas adelante */'& '#chr(13)#' >
	
	<cfset temporal = 'create table #tmpDRegimenVacaciones# (#cinsert#)'>
	
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
		<cfset sql_insert = "insert into #tmpDRegimenVacaciones#(#icampos#) values (#insert_campos#">
		<cfset hilera = hilera & sql_insert & '#chr(13)#'>
		<cfset insert_campos = ''>
	</cfloop>
	
<!-------------------------------------------------------------------------------------------->

	<cfquery datasource="#arguments.conexionD#" name="x">
<!---	esta es la version vieja pero no funciona por la regla de 3 ljimenez
		Select c.RVid, #Scampos#
			from #TablaOrigen# a, #PadreOrigen# b, RegimenVacaciones c
				Where a.RVid=b.RVid
				and b.Ecodigo= #EcodigoViejo#
				and b.RVcodigo= c.RVcodigo
				and c.Ecodigo= #EcodigoNuevo#
--->				
		Select b.RVid, #Scampos#
			from #TablaOrigen# a, #PadreOrigen# b
				Where a.RVid=b.RVid
				and b.Ecodigo= #EcodigoViejo#
				
			<!---	and b.RVcodigo= c.RVcodigo
				and c.Ecodigo= #EcodigoNuevo#--->
	</cfquery>

	<cfset insert_campos = ''>
	<cfset hilera = hilera & '#chr(13)# /* Cloanacion Detalle de vacaciones */ #chr(13)# 
	declare @RVid  numeric 
	select @RVid  =  max(RVid) from RegimenVacaciones where Ecodigo = 1198 #chr(13)#'>
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
		<cfset sql_insert = "insert into #arguments.Tabla#(RVid,#campos#) values (@RVid,#insert_campos#">
		<cfset hilera = hilera & sql_insert & '#chr(13)#'>
		<cfset insert_campos = ''>
	</cfloop>
	
	<cfset hilera = hilera & '/* Actulizacion de RVid utilizando las tambla temporal creada en el script  011 */ #chr(13)#' >
	
	
	<!--- actulizacion del detalle de vacaciones
	<cfset hilera = hilera & ' #chr(13)# update DRegimenVacaciones 
	set RVid = (select b.RVid
		from RegimenVacaciones b, tmpRegimenVacaciones a
			where b.Ecodigo = #EcodigoNuevo#
			and b.RVcodigo = a.RVcodigo
			and a.RVid = RVid) #chr(13)#'>--->
	
	<cfset archivo = "#TablaOrigen#">
	<cfset LvarDir = expandPath("/clonacion/scripts/")>

	<cfset txtfile = #LvarDir#&'012-DRegimenVacaciones.txt'>
	<cffile action="write" nameconflict="overwrite" file="#txtfile#" output="#hilera#" charset="utf-8">

	<cfset session.LvarFiles = session.LvarFiles & '012-DRegimenVacaciones,'>	

</cfif>

<!---<cfdump var="#x#">--->


