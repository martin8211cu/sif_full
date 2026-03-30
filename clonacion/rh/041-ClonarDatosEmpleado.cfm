<!---<cf_dump var="#form#">--->

<cf_dbstruct name="#arguments.Tabla#" returnvariable="rsStruct" datasource="#arguments.conexionO#">

<cfif isdefined("rsStruct") and rsStruct.RecordCount neq 0 >
	<cfquery dbtype="query" name="rscampos">
		select *
		from rsStruct 
		where rsStruct.identity = 0
			and upper(rsStruct.name) not in ('ECODIGO')
	</cfquery>
	
<!---	<cf_dump var="#rscampos#">--->

	<cfset campos = ''>
	<cfset tipos  = ''>
	
	<cfset nReg = 1 >
	
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

</cfif>	
	<cf_dbdatabase table="#arguments.Tabla#" datasource="#form.DSNO#" returnvariable="TablaOrigen">
	<cf_dbdatabase table="#arguments.Tabla#" datasource="#form.DSND#" returnvariable="TablaDestino">
	
	<cf_dbdatabase table="Bancos" datasource="#form.DSNO#" returnvariable="Bancos_O">
	<cf_dbdatabase table="Bancos" datasource="#form.DSND#" returnvariable="Bancos_D">
	
	<cf_dbdatabase table="CIncidentes" datasource="#form.DSNO#" returnvariable="CIncidentes_O">
	<cf_dbdatabase table="CIncidentes" datasource="#form.DSND#" returnvariable="CIncidentes_D">


	<cf_dbdatabase table="LineaTiempo" datasource="#form.DSNO#" returnvariable="LineaTiempo_O">
	<cf_dbdatabase table="RHPlazas" datasource="#form.DSNO#" returnvariable="RHPlazas_O">
	<cf_dbdatabase table="CFuncional" datasource="#form.DSNO#" returnvariable="CFuncional_O">


<cfif not isdefined("form.chkSQL")>
	<cftransaction>
		<cftry>
			<cfquery datasource="#arguments.conexionD#" name="rsExisten">
				Select Ecodigo,DEidentificacion from DatosEmpleado Where Ecodigo=#EcodigoNuevo#
					and DEidentificacion in (select DEidentificacion from #TablaOrigen# where Ecodigo = #EcodigoViejo#)
			</cfquery>
	
		<!---	<cf_dump var="#rsExisten#">--->
			
			<!---<cfif isdefined("rsExisten") and rsExisten.RecordCount neq 0>
				<cfloop query="rsExisten" >
					<cfloop index = "lcampo" list = "#campos#" delimiters = ",">
						<cfquery datasource="#arguments.conexionD#" name="x">
							update Oficinas  set  #lcampo#   = 	(select  #lcampo#   from #TablaOrigen# v
																	 Where v.Ecodigo = #EcodigoViejo# 
																		and v.Ocodigo = #rsExisten.Ocodigo# )
								 Where Ecodigo = #EcodigoNuevo# 
										and Ocodigo = #rsExisten.Ocodigo#
						</cfquery>
					</cfloop>
				</cfloop>
			</cfif>--->
			
			<cfquery datasource="#arguments.conexionD#" name="x">
				insert into DatosEmpleado(Ecodigo,#campos#)
					Select #EcodigoNuevo#, #campos#
						From #TablaOrigen# 
							Where Ecodigo= #EcodigoViejo#
								<cfif isdefined('form.EmpleadoidList')>
									and DEid in (#form.EmpleadoidList#)
								</cfif>
								and (select count(1) from #TablaDestino# a where a.Ecodigo = #EcodigoNuevo# and DEidentificacion = a.DEidentificacion) = 0
								
							

					<!---Select distinct #EcodigoNuevo#, Bid, NTIcodigo, null, DEidentificacion, 
						DEnombre, DEapellido1, DEapellido2, CBTcodigo, DEcuenta, 
						CBcc, a.Mcodigo, DEdireccion, DEtelefono1, DEtelefono2, 
						DEemail, DEcivil, DEfechanac, DEsexo, DEcantdep, 
						DEobs1, DEobs2, DEobs3, 
						DEdato1, DEdato2, DEdato3, DEdato4, DEdato5, 
						DEinfo1, DEinfo2, DEinfo3, 
						a.Usucodigo, a.Ulocalizacion, 
						DEsistema, DEusuarioportal, 
						DEtarjeta, DEpassword, Ppais, 
						DEfanuales, DEfvacaciones, 
						a.BMUsucodigo, DEidcorp, DEporcAnticipo, 
						DEobs4, DEobs5, DEdato6, DEdato7, DEinfo4, DEinfo5
						
					from #TablaOrigen#  a, #LineaTiempo_O# b, #RHPlazas_O# c, #CFuncional_O# d
					
					Where a.DEid = b.DEid
						and b.RHPid = c.RHPid
						and c.CFid = d.CFid
						<!---and d.CFcodigo in ('517000000','517300000')--->
						and a.Ecodigo = #EcodigoViejo#
						and getdate() between LTdesde and LThasta--->
			</cfquery>
			
		<!---	<cf_dump var="#x#">--->


			<cfquery datasource="#arguments.conexionD#" name="Actualiza">
				update DatosEmpleado
				set Bid=(Select b.Bid
					from #Bancos_O# a, #Bancos_D# b
					Where DatosEmpleado.Bid = a.Bid
					and a.Ecodigo		=	#EcodigoViejo#
					and a.Bdescripcion	=	b.Bdescripcion
					and b.Ecodigo		=	#EcodigoNuevo#)
				Where Ecodigo = #EcodigoNuevo#
			</cfquery>
			
			<cfquery datasource="#arguments.conexionD#" name="Actualiza">
				update DatosEmpleado
					set Mcodigo=(Select Mcodigo
						from Empresas a
						Where DatosEmpleado.Ecodigo = a.Ecodigo)
					Where Ecodigo = #EcodigoNuevo#
			</cfquery>
			<!---<cf_dump var="#x#">--->
			<cfcatch type="any">
				<cftransaction action="rollback"/>
				<cfset  ErrorMessage  =  '#cfcatch.Detail#>'>
				<cfrethrow>
			</cfcatch>
		</cftry>
	</cftransaction>
<cfelse>
	<cfquery datasource="#arguments.conexionD#" name="x">
		Select #EcodigoNuevo# as Ecodigo, #campos#
			From #TablaOrigen# 
				Where Ecodigo= #EcodigoViejo#
					<cfif isdefined('form.EmpleadoidList')>
						and DEid in (#form.EmpleadoidList#)
					</cfif>
	</cfquery>
	
	<!---<cf_dump var="#x#">--->
	
	<cfset insert_campos = ''>
	<cfset hilera = '/* Informacion de empleados, este script se genera en base a los datos seleccionados pueden ser todos o solo los seccionados */'& '#chr(13)#' & '#chr(13)#'>
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
	
	<cfset hilera = hilera & 'update DatosEmpleado
				set Bid=(Select b.Bid
					from tmpBancos a, #Bancos_D# b
					Where DatosEmpleado.Bid = a.Bid
					and a.Ecodigo		=	#EcodigoViejo#
					and a.Bdescripcion	=	b.Bdescripcion
					and b.Ecodigo		=	#EcodigoNuevo#)
				Where Ecodigo = #EcodigoNuevo#' & '#chr(13)#'>
					
					
	<cfset hilera = hilera & 'update RHJornadas
				set RHJincAusencia = (Select c.CIid
						from tmpCIncidentes b, #CIncidentes_D# c
							Where RHJornadas.RHJincAusencia = b.CIid
							and b.Ecodigo	= #EcodigoViejo#
							and b.CIcodigo	= c.CIcodigo
							and c.Ecodigo	= #EcodigoNuevo#)
				Where Ecodigo = #EcodigoNuevo#' & '#chr(13)#'>
					
	<cfset hilera = hilera & 'update DatosEmpleado
					set Mcodigo=(Select Mcodigo
						from Empresas a
						Where DatosEmpleado.Ecodigo = a.Ecodigo)
					Where Ecodigo = #EcodigoNuevo#' & '#chr(13)#'>
				
	<cfset archivo = "#TablaOrigen#">
	<cfset LvarDir = expandPath("/clonacion/scripts/")>

	<cfset txtfile = #LvarDir#&'041-DatosEmpleado.txt'>
	<cffile action="write" nameconflict="overwrite" file="#txtfile#" output="#hilera#" charset="utf-8">

	<cfset session.LvarFiles = session.LvarFiles & '041-DatosEmpleado.txt,'>

</cfif>	
