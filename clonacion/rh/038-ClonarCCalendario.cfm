	<cf_dbstruct name="#arguments.Tabla#" returnvariable="rsStruct" datasource="#arguments.conexionO#">

<cfif isdefined("rsStruct") and rsStruct.RecordCount neq 0 >
	<cfquery dbtype="query" name="rscampos">
		select *
		from rsStruct 
		where rsStruct.identity = 0
			and upper(rsStruct.name) not in ('ECODIGO','MCODIGO')
	</cfquery>
	
	<!---<cf_dump var="#rscampos#">--->
	
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

<cf_dbdatabase table="CIncidentes" datasource="#form.DSNO#" returnvariable="CIncidentes_O">
<cf_dbdatabase table="CIncidentes" datasource="#form.DSND#" returnvariable="CIncidentes_D">

<cfset tmpCCalendario = 'tmpCCalendario' >

<cfif not isdefined("form.chkSQL")>
	<cftransaction>
		<cftry>
			<cfquery datasource="#arguments.conexionD#" name="rsExisten">
				Select * from CCalendario Where 
					CPid in (select CPid from CalendarioPagos where Ecodigo=#EcodigoNuevo#)
					and CIid in (select CIid from CIncidentes where Ecodigo=#EcodigoNuevo#)
			</cfquery>
			
			<!---<cf_dump var="#rsExisten#">--->
			
			<cfif isdefined("rsExisten") and rsExisten.RecordCount neq 0>
				<cfquery datasource="#arguments.conexionD#" name="x">
					delete from CCalendario Where 
						CPid in (select CPid from CalendarioPagos where Ecodigo=#EcodigoNuevo#)
						and CIid in (select CIid from CIncidentes where Ecodigo=#EcodigoNuevo#)
				</cfquery>
			</cfif>
			
			<cfquery datasource="#arguments.conexionD#" name="x">
				insert into CCalendario(#campos#)
					Select b2.CPid, c2.CIid
						from #TablaOrigen# a,
							#PadreOrigen# b1, #PadreDestino# b2,
							#CIncidentes_O# c1, #CIncidentes_D# c2
							Where a.CPid=b1.CPid
								and   a.CIid		=	c1.CIid
								and   b1.CPcodigo	=	b2.CPcodigo
								and   b1.Tcodigo	=	b2.Tcodigo
								and   b1.Ecodigo	=	#EcodigoViejo#
								and   b2.Ecodigo	=	#EcodigoNuevo#
								and   c1.CIcodigo	=	c2.CIcodigo
								and   c1.Ecodigo	=	#EcodigoViejo#
								and   c2.Ecodigo	=	#EcodigoNuevo#
			</cfquery>
			<cfcatch type="any">
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
			from CCalendario a,
				CalendarioPagos b1, #CIncidentes_O# c1
				Where a.CPid = b1.CPid
					and   a.CIid		=	c1.CIid
					and   b1.Ecodigo	=	#EcodigoViejo#
					and   c1.Ecodigo	=	#EcodigoViejo#
	</cfquery>
	
	<cfset insert_campos = ''>
	<cfset hilera = '/* Conceptos Pago por Calendario #chr(13)# Conceptos Pago por Calendario, se crea una tabla temporal tmpCCalendario que es usada para hacer actualizaciones mas adelante */ #chr(13)#' >
	
	<cfset temporal = 'create table #tmpCCalendario# (#cinsert#)'>
	
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
		<cfset sql_insert = "insert into #tmpCCalendario#(#icampos#) values (#insert_campos#">
		<cfset hilera = hilera & sql_insert & '#chr(13)#'>
		<cfset insert_campos = ''>
	</cfloop>

<!-------------------------------------------------------------------------------------------->

<cfset hilera = hilera & '#chr(13)#/* Conceptos Pago por Calendario */#chr(13)#'>
	
	<cfset hilera = hilera & '#chr(13)#/* Conceptos Pago por Calendario */#chr(13)#
	update tmpCCalendario set CPid = (
	Select b2.CPid
	from tmpCalendarioPagos b1, tmpCIncidentes c1,
		CalendarioPagos b2, CIncidentes c2
		Where tmpCCalendario.CPid	=	b1.CPid
			and   tmpCCalendario.CIid	=	c1.CIid
			and   b1.CPcodigo	=	b2.CPcodigo
			and   b1.Tcodigo	=	b2.Tcodigo
			and   b1.Ecodigo	=	#EcodigoViejo#
			and   b2.Ecodigo	=	#EcodigoNuevo#
			and   c1.CIcodigo	=	c2.CIcodigo
			and   c1.Ecodigo	=	#EcodigoViejo#
			and   c2.Ecodigo	=	#EcodigoNuevo#)
	,CIid = (Select c2.CIid
	from tmpCalendarioPagos b1, tmpCIncidentes c1,
		CalendarioPagos b2, CIncidentes c2
		Where tmpCCalendario.CPid	=	b1.CPid
			and   tmpCCalendario.CIid	=	c1.CIid
			and   b1.CPcodigo	=	b2.CPcodigo
			and   b1.Tcodigo	=	b2.Tcodigo
			and   b1.Ecodigo	=	#EcodigoViejo#
			and   b2.Ecodigo	=	#EcodigoNuevo#
			and   c1.CIcodigo	=	c2.CIcodigo
			and   c1.Ecodigo	=	#EcodigoViejo#
			and   c2.Ecodigo	=	#EcodigoNuevo#)'>
		
	<cfset hilera = hilera & '#chr(13)#/*Insert detalle de Conceptos Pago por Calendario ya actulizado	*/#chr(13)#
	insert into CCalendario  (#icampos#) (select #icampos# from tmpCCalendario) #chr(13)#'>	
	
	<cfset archivo = "#TablaOrigen#">
	<cfset LvarDir = expandPath("/clonacion/scripts/")>

	<cfset txtfile = #LvarDir#&'038-CCalendario.txt'>
	<cffile action="write" nameconflict="overwrite" file="#txtfile#" output="#hilera#" charset="utf-8">

	<cfset session.LvarFiles = session.LvarFiles & '038-CCalendario.txt,'>
	
</cfif>

<!---<cf_dump var="x">--->


