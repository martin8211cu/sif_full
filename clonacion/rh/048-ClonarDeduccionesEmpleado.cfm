<!---<cfdump var="#form#">--->

<cf_dbstruct name="#arguments.Tabla#" returnvariable="rsStruct" datasource="#arguments.conexionO#">

<cfif isdefined("rsStruct") and rsStruct.RecordCount neq 0 >
	<cfquery dbtype="query" name="rscampos">
		select *
		from rsStruct 
		where rsStruct.identity = 0
			and upper(rsStruct.name) not in ('ECODIGO', 'DEID', 'TDID')
	</cfquery>
	
	<!---<cf_dump var="#rscampos#">--->

	<cfset campos = ''>
	<cfset Scampos = ''>
	<cfset tipos  = ''>
	
	<cfset nReg = 1 >
	
	<cfloop query="rscampos">
		<cfif  #nReg# NEQ #rscampos.recordCount#> 
			<cfset campos = campos & rscampos.name & ','>
			<cfset Scampos = Scampos & 'a.'&rscampos.name & ','>
			<cfset tipos  = tipos & rscampos.cf_type & ','>
		<cfelse>
			<cfset campos = campos & rscampos.name>
			<cfset Scampos = Scampos & 'a.'&rscampos.name>
			<cfset tipos  = tipos & rscampos.cf_type & ','>
		</cfif>
		<cfset nReg = nReg + 1 >
	</cfloop>
</cfif>	

<cf_dbdatabase table="#arguments.Tabla#" datasource="#form.DSNO#" returnvariable="TablaOrigen">
<cf_dbdatabase table="#arguments.Tabla#" datasource="#form.DSND#" returnvariable="TablaDestino">
<cf_dbdatabase table="#arguments.Padre#" datasource="#form.DSNO#" returnvariable="PadreOrigen">
<cf_dbdatabase table="#arguments.Padre#" datasource="#form.DSND#" returnvariable="PadreDestino">

<cf_dbdatabase table="SNegocios" datasource="#form.DSNO#" returnvariable="SNegocios_O">
<cf_dbdatabase table="SNegocios" datasource="#form.DSND#" returnvariable="SNegocios_D">

<cf_dbdatabase table="TDeduccion" datasource="#form.DSNO#" returnvariable="TDeduccion_O">
<cf_dbdatabase table="TDeduccion" datasource="#form.DSND#" returnvariable="TDeduccion_D">

<cfif not isdefined("form.chkSQL")>
	<cftransaction>
		<cftry>
			<!---<cfquery datasource="#arguments.conexionD#" name="rsExisten">
				select a.DEid from DVacacionesEmpleado a, DatosEmpleado b
					where b.Ecodigo = #EcodigoNuevo#
					and a.DEid = b.DEid
			</cfquery>

			<cfif isdefined("rsExisten") and rsExisten.RecordCount neq 0>
				<cfquery datasource="#arguments.conexionD#">
					delete from DVacacionesEmpleado
						where DEid in (select a.DEid from DVacacionesEmpleado a, DatosEmpleado b
														where b.Ecodigo = #EcodigoNuevo#
														and a.DEid = b.DEid)
				</cfquery>
			</cfif>--->

			<cfquery datasource="#arguments.conexionD#" name="x">
				insert into DeduccionesEmpleado(DEid,Ecodigo, TDid, #campos#)
					Select b2.DEid, b2.Ecodigo, c2.TDid, #Scampos#
					
					from #TablaOrigen# a, 
						 #PadreOrigen# b1,  #TDeduccion_O# c1, #SNegocios_O# d1,
						 #PadreDestino# b2, #TDeduccion_D# c2, #SNegocios_D# d2
					Where 
						a.DEid=b1.DEid
						and a.TDid		=	c1.TDid
						and a.SNcodigo	=	d1.SNcodigo
						and b1.Ecodigo	=	#EcodigoViejo#
						and c1.Ecodigo	=	#EcodigoViejo#
						and d1.Ecodigo	=	#EcodigoViejo#
						
						
						and b1.DEidentificacion		=	b2.DEidentificacion
						and b1.DEnombre				=	b2.DEnombre
						and b1.DEapellido1			=	b2.DEapellido1
						and b2.Ecodigo				=	#EcodigoNuevo#
					
						and c1.TDcodigo				=	c2.TDcodigo
						and c2.Ecodigo				=	#EcodigoNuevo#
					
						and d1.SNcodigo				=	d2.SNcodigo
						and d2.Ecodigo				=	#EcodigoNuevo#
						
						and b2.DEid not in (select a.DEid from DeduccionesEmpleado a, DatosEmpleado b
												where b.Ecodigo = #EcodigoNuevo#
												and a.DEid = b.DEid)
			</cfquery>
			<!---<cf_dump var="#x#">--->
			<cfcatch type="any">
				<cftransaction action="rollback"/>
				<cfset  ErrorMessage  =  '#cfcatch.Detail#>'>
				<!---<cfrethrow message="#ErrorMessage#">--->
				<cfrethrow>
			</cfcatch>
		</cftry>
	</cftransaction>
<cfelse>
	<cfquery datasource="#arguments.conexionD#" name="x">
		Select b2.DEid, b2.Ecodigo, c2.TDid, #Scampos#
			
			from #TablaOrigen# a, 
				 #PadreOrigen# b1,  #TDeduccion_O# c1, #SNegocios_O# d1,
				 #PadreDestino# b2, #TDeduccion_D# c2, #SNegocios_D# d2
			Where 
				a.DEid=b1.DEid
				and a.TDid		=	c1.TDid
				and a.SNcodigo	=	d1.SNcodigo
				and b1.Ecodigo	=	#EcodigoViejo#
				and c1.Ecodigo	=	#EcodigoViejo#
				and d1.Ecodigo	=	#EcodigoViejo#
				
				
				and b1.DEidentificacion		=	b2.DEidentificacion
				and b1.DEnombre				=	b2.DEnombre
				and b1.DEapellido1			=	b2.DEapellido1
				and b2.Ecodigo				=	#EcodigoNuevo#
			
				and c1.TDcodigo				=	c2.TDcodigo
				and c2.Ecodigo				=	#EcodigoNuevo#
			
				and d1.SNcodigo				=	d2.SNcodigo
				and d2.Ecodigo				=	#EcodigoNuevo#
				
				<!---and b2.DEid not in (select a.DEid from DeduccionesEmpleado a, DatosEmpleado b
										where b.Ecodigo = #EcodigoNuevo#
										and a.DEid = b.DEid)--->
	</cfquery>
	<cfset insert_campos = ''>
	<cfset hilera = ''>
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
		<cfset sql_insert = "insert into #arguments.Tabla#(DEid, Ecodigo, TDid,#campos#) values (#x.DEid#, #x.Ecodigo#, #x.TDid#,#insert_campos#">
		<cfset hilera = hilera & sql_insert & '#chr(13)#'>
		<cfset insert_campos = ''>
	</cfloop>

	<cfset archivo = "#TablaOrigen#">
	<cfset LvarDir = expandPath("/clonacion/scripts/")>

	<cfset txtfile = #LvarDir#&'048-DeduccionesEmpleado.txt'>
	<cffile action="write" nameconflict="overwrite" file="#txtfile#" output="#hilera#" charset="utf-8">

	<cfset session.LvarFiles = session.LvarFiles & '048-DeduccionesEmpleado.txt,'>

</cfif>	
