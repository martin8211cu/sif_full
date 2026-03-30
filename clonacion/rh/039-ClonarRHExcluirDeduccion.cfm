<cf_dbstruct name="#arguments.Tabla#" returnvariable="rsStruct" datasource="#arguments.conexionO#">

<cfif isdefined("rsStruct") and rsStruct.RecordCount neq 0 >
	<cfquery dbtype="query" name="rscampos">
		select *
		from rsStruct 
		where rsStruct.identity = 0
		and upper(rsStruct.name) not in ('ECODIGO','MCODIGO')
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

<cf_dbdatabase table="#arguments.Padre#" datasource="#form.DSNO#" returnvariable="PadreOrigen">
<cf_dbdatabase table="#arguments.Padre#" datasource="#form.DSND#" returnvariable="PadreDestino">

<cf_dbdatabase table="TDeduccion" datasource="#form.DSNO#" returnvariable="TDeduccion_O">
<cf_dbdatabase table="TDeduccion" datasource="#form.DSND#" returnvariable="TDeduccion_D">

<cfset tmpRHExcluirDeduccion = 'tmpRHExcluirDeduccion' >

<cfif not isdefined("form.chkSQL")>
	<cftransaction>
		<cftry>
			<cfquery datasource="#arguments.conexionD#" name="rsExisten">
				Select * from RHExcluirDeduccion Where 
					CPid in (select CPid from CalendarioPagos where Ecodigo=#EcodigoNuevo#)
					and TDid in (select TDid from TDeduccion where Ecodigo=#EcodigoNuevo#)
			</cfquery>
			
			<!---<cf_dump var="#rsExisten#">--->
			
			<cfif isdefined("rsExisten") and rsExisten.RecordCount neq 0>
				<cfquery datasource="#arguments.conexionD#" name="x">
					delete from RHExcluirDeduccion Where 
						CPid in (select CPid from CalendarioPagos where Ecodigo=#EcodigoNuevo#)
						and TDid in (select TDid from TDeduccion where Ecodigo=#EcodigoNuevo#)
				</cfquery>
			</cfif>

			<cfquery datasource="#arguments.conexionD#" name="x">
				insert into RHExcluirDeduccion(#campos#)
					Select b2.CPid, c2.TDid
						from #TablaOrigen# a,
							#PadreOrigen# b1, #PadreDestino# b2,
							#TDeduccion_O# c1, #TDeduccion_D# c2
							Where a.CPid	=	b1.CPid
								and   a.TDid	=	c1.TDid
								and   b1.CPcodigo	=	b2.CPcodigo
								and   b1.Tcodigo	=	b2.Tcodigo
								and   b1.Ecodigo	=	#EcodigoViejo#
								and   b2.Ecodigo	=	#EcodigoNuevo#
								and   c1.TDcodigo	=	c2.TDcodigo
								and   c1.Ecodigo	=	#EcodigoViejo#
								and   c2.Ecodigo	=	#EcodigoNuevo#
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
			from RHExcluirDeduccion a, 
				CalendarioPagos b1, #TDeduccion_O# c1
				Where a.CPid	=	b1.CPid
					and   a.TDid	=	c1.TDid
					and   b1.Ecodigo	=	#EcodigoViejo#
					and   c1.Ecodigo	=	#EcodigoViejo#
	</cfquery>
	
	<cfset insert_campos = ''>
	<cfset hilera = '/* Deducciones Excluir por Calendario #chr(13)# Deducciones Excluir por Calendario, se crea una tabla temporal tmpRHExcluirDeduccion que es usada para hacer actualizaciones mas adelante */ #chr(13)#' >
	
	<cfset temporal = 'create table #tmpRHExcluirDeduccion# (#cinsert#)'>
	
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
		<cfset sql_insert = "insert into #tmpRHExcluirDeduccion#(#icampos#) values (#insert_campos#">
		<cfset hilera = hilera & sql_insert & '#chr(13)#'>
		<cfset insert_campos = ''>
	</cfloop>

<!-------------------------------------------------------------------------------------------->

<cfset hilera = hilera & '#chr(13)#/* Deducciones Excluir por Calendario */#chr(13)#'>
	
	<cfset hilera = hilera & '#chr(13)#/* Actualiza en la temporal Deducciones Excluir por Calendario */#chr(13)#
	update tmpRHExcluirDeduccion set CPid = (
	Select b2.CPid
	from tmpCalendarioPagos b1, tmpTDeduccion c1,
		CalendarioPagos b2, TDeduccion c2
		Where tmpRHExcluirDeduccion.CPid	=	b1.CPid
			and   tmpRHExcluirDeduccion.TDid	=	c1.TDid
			and   b1.CPcodigo	=	b2.CPcodigo
			and   b1.Tcodigo	=	b2.Tcodigo
			and   b1.Ecodigo	=	#EcodigoViejo#
			and   b2.Ecodigo	=	#EcodigoNuevo#
			and   c1.TDcodigo	=	c2.TDcodigo
			and   c1.Ecodigo	=	#EcodigoViejo#
			and   c2.Ecodigo	=	#EcodigoNuevo#)
	,TDid = (Select c2.TDid
	from tmpCalendarioPagos b1, tmpTDeduccion c1,
		CalendarioPagos b2, TDeduccion c2
		Where tmpRHExcluirDeduccion.CPid	=	b1.CPid
			and   tmpRHExcluirDeduccion.TDid	=	c1.TDid
			and   b1.CPcodigo	=	b2.CPcodigo
			and   b1.Tcodigo	=	b2.Tcodigo
			and   b1.Ecodigo	=	#EcodigoViejo#
			and   b2.Ecodigo	=	#EcodigoNuevo#
			and   c1.TDcodigo	=	c2.TDcodigo
			and   c1.Ecodigo	=	#EcodigoViejo#
			and   c2.Ecodigo	=	#EcodigoNuevo#)'>
		
	<cfset hilera = hilera & '#chr(13)#/* Insert Deducciones Excluir por Calendario ya actulizado */#chr(13)#
	insert into RHExcluirDeduccion  (#icampos#) (select #icampos# from tmpRHExcluirDeduccion) #chr(13)#'>	

	<cfset archivo = "#TablaOrigen#">
	<cfset LvarDir = expandPath("/clonacion/scripts/")>

	<cfset txtfile = #LvarDir#&'039-RHExcluirDeduccion.txt'>
	<cffile action="write" nameconflict="overwrite" file="#txtfile#" output="#hilera#" charset="utf-8">

	<cfset session.LvarFiles = session.LvarFiles & '039-RHExcluirDeduccion.txt,'>
	
</cfif>

<!---<cf_dump var="x">--->


