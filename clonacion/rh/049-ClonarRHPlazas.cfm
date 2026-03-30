<!---<cf_dump var="#form#">--->

<cf_dbstruct name="#arguments.Tabla#" returnvariable="rsStruct" datasource="#arguments.conexionO#">

<cfif isdefined("rsStruct") and rsStruct.RecordCount neq 0 >
	<cfquery dbtype="query" name="rscampos">
		select *
		from rsStruct 
		where rsStruct.identity = 0
			and upper(rsStruct.name) not in ('ECODIGO', 'DEID', 'TDID','RHPPID')
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

<cf_dbdatabase table="DLaboralesEmpleado" datasource="#form.DSNO#" returnvariable="DLaboralesEmpleado_O">

<cf_dbdatabase table="Departamentos" datasource="#form.DSNO#" returnvariable="Departamentos_O">
<cf_dbdatabase table="Departamentos" datasource="#form.DSND#" returnvariable="Departamentos_D">

<cf_dbdatabase table="Oficinas" datasource="#form.DSNO#" returnvariable="Oficinas_O">
<cf_dbdatabase table="Oficinas" datasource="#form.DSND#" returnvariable="Oficinas_D">

<cf_dbdatabase table="CFuncional" datasource="#form.DSNO#" returnvariable="CFuncional_O">
<cf_dbdatabase table="CFuncional" datasource="#form.DSND#" returnvariable="CFuncional_D">

<cfif not isdefined("form.chkSQL")>
	<cftransaction>
		<cftry>
			<cfquery datasource="#arguments.conexionD#" name="rsExisten">
				Select Ecodigo
						from RHPlazas
							Where  Ecodigo = #EcodigoNuevo#
			</cfquery>

			<cfif isdefined("rsExisten") and rsExisten.RecordCount neq 0>
				<cfquery datasource="#arguments.conexionD#">
					delete from RHPlazas
						where Ecodigo = #EcodigoNuevo#
														
				</cfquery>
			</cfif>

			<cfquery datasource="#arguments.conexionD#" name="x">
				insert into RHPlazas(Ecodigo, #campos#)
					Select #EcodigoNuevo#, #Scampos#
						from #TablaOrigen# a
							Where  a.Ecodigo =	#EcodigoViejo#
							
								
								
					<!--- esta es la opcion para pasar solo los plazas de empleados nombrados
					Select #EcodigoNuevo#, #Scampos#
						from #TablaOrigen# a, #DLaboralesEmpleado_O# b,  #PadreOrigen# c,  #PadreDestino# d
							Where  a.Ecodigo			=	#EcodigoViejo#
								and    a.RHPid				=	b.RHPid
								and    b.DEid				=	c.DEid
								and    c. DEidentificacion	=	d.DEidentificacion
								and    c.DEnombre			=	d.DEnombre
								and    c.DEapellido1		=	d.DEapellido1
								and    d.Ecodigo			=	#EcodigoNuevo#--->
				</cfquery>
				
				

				<!---<cf_dump var="#x#">--->
						
							<!---revisar para que no duplicar datos
							and c.DEid not in (select a.DEid from DeduccionesEmpleado a, DatosEmpleado b
												where b.Ecodigo = #EcodigoNuevo#
												and a.DEid = b.DEid)--->
			

			<!---Dcodigo de Departamentos--->
			<cfquery datasource="#arguments.conexionD#" name="Actualiza">
				update RHPlazas
				set Dcodigo = (Select c.Dcodigo
						from #Departamentos_O# b, #Departamentos_D# c
						Where b.Ecodigo			=	#EcodigoViejo#
						and RHPlazas.Dcodigo	=	b.Dcodigo
						and b.Deptocodigo		=	c.Deptocodigo
						and c.Ecodigo			=	#EcodigoNuevo#)
				Where Ecodigo = #EcodigoNuevo#
			</cfquery>
			
			
			<!---Ocodigo de Oficinas--->
			<cfquery datasource="#arguments.conexionD#" name="Actualiza">
				update RHPlazas
				set Ocodigo = (Select c.Ocodigo
						from #Oficinas_O# b, #Oficinas_D# c
						Where b.Ecodigo			=	#EcodigoViejo#
						and RHPlazas.Ocodigo	=	b.Ocodigo
						and b.Oficodigo			=	c.Oficodigo
						and c.Ecodigo			=	#EcodigoNuevo#)
				Where Ecodigo	=	#EcodigoNuevo#
			</cfquery>
			
			
			<!---CFid de Centros Funcionales--->
			<cfquery datasource="#arguments.conexionD#" name="Actualiza">
				update RHPlazas
				set CFid = (Select c.CFid
						from #CFuncional_O# b, #CFuncional_D# c
						Where b.Ecodigo		=	#EcodigoViejo#
						and RHPlazas.CFid	=	b.CFid
						and b.CFcodigo		=	c.CFcodigo
						and c.Ecodigo		=	#EcodigoNuevo#)
				Where Ecodigo	=	#EcodigoNuevo#
			</cfquery>			
			
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
		Select #EcodigoNuevo# as Ecodigo, #Scampos#
			from #TablaOrigen# a
				Where  a.Ecodigo =	#EcodigoViejo#
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
		<cfset sql_insert = "insert into #arguments.Tabla#(Ecodigo,#campos#) values (#x.Ecodigo#,#insert_campos#">
		<cfset hilera = hilera & sql_insert & '#chr(13)#'>
		<cfset insert_campos = ''>
	</cfloop>
	
	<cfset hilera = hilera & 'update RHPlazas
				set Dcodigo = (Select c.Dcodigo
						from tmpDepartamentos b, #Departamentos_D# c
						Where b.Ecodigo			=	#EcodigoViejo#
						and RHPlazas.Dcodigo	=	b.Dcodigo
						and b.Deptocodigo		=	c.Deptocodigo
						and c.Ecodigo			=	#EcodigoNuevo#)
				Where Ecodigo = #EcodigoNuevo#' & '#chr(13)#'>
					
					
	<cfset hilera = hilera & 'update RHPlazas
				set Ocodigo = (Select c.Ocodigo
						from tmpOficinas b, #Oficinas_D# c
						Where b.Ecodigo			=	#EcodigoViejo#
						and RHPlazas.Ocodigo	=	b.Ocodigo
						and b.Oficodigo			=	c.Oficodigo
						and c.Ecodigo			=	#EcodigoNuevo#)
				Where Ecodigo	=	#EcodigoNuevo#' & '#chr(13)#'>
					
	<cfset hilera = hilera & 'update RHPlazas
				set CFid = (Select c.CFid
						from tmpCFuncional b, #CFuncional_D# c
						Where b.Ecodigo		=	#EcodigoViejo#
						and RHPlazas.CFid	=	b.CFid
						and b.CFcodigo		=	c.CFcodigo
						and c.Ecodigo		=	#EcodigoNuevo#)
				Where Ecodigo	=	#EcodigoNuevo#' & '#chr(13)#'>

	<cfset archivo = "#TablaOrigen#">
	<cfset LvarDir = expandPath("/clonacion/scripts/")>

	<cfset txtfile = #LvarDir#&'049-RHPlazas.txt'>
	<cffile action="write" nameconflict="overwrite" file="#txtfile#" output="#hilera#" charset="utf-8">

	<cfset session.LvarFiles = session.LvarFiles & '049-RHPlazas.txt,'>	
</cfif>	
