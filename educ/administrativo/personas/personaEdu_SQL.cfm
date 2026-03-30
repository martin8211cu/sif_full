<cfif form.TipoPersona EQ 'A'>		<!--- Alumno --->
	<cfset action="alumno.cfm">
<cfelseif form.TipoPersona EQ 'DO'>	<!--- Docente --->
	<cfset action="docente.cfm">
<cfelseif form.TipoPersona EQ 'DI'>	<!--- Director --->					
	<cfset action="director.cfm">
<cfelseif form.TipoPersona EQ 'PG'>	<!--- Profesor Guia --->
	<cfset action="profGuia.cfm">
</cfif>
<cfset modo="ALTA">
<cfif not isdefined("Form.Nuevo")>
	<!--- Se elimino la transaccion porque se tiene que insertar en bases de datos idferentes, en 'universidad' y en 'asp' --->
	<!--- <cftransaction> --->
		<cftry>
			<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
			<cfif isdefined("Form.Alta")>
				<cfif not isdefined("Form.Ppersona") or (isdefined("Form.Ppersona") and Len(Trim(Form.Ppersona)) EQ 0)>
					<cfquery name="rsDatosCuenta" datasource="asp">
						select rtrim(a.LOCIdioma) as LOCIdioma, b.Ppais
						from CuentaEmpresarial a, Direcciones b
						where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
						and a.id_direccion = b.id_direccion
					</cfquery>

					<cfquery name="ABC_Docente" datasource="#Session.DSN#">
						declare @Ppersona numeric
						
						insert PersonaEducativo(Ecodigo)
						values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">)
						
						select @Ppersona = @@identity
						
						select convert(varchar, @Ppersona) as Ppersona
					</cfquery>
				
					<!--- Insercion del Usuario en el Framework --->
					
					<!--- Inserta los datos personales --->
					<cf_datospersonales action="readform" name="data1">
					<cf_datospersonales action="insert" name="data1" data="#data1#">
					<!--- Inserta la direccion --->
					<cf_direccion action="readform" name="data2">
					<cf_direccion action="insert" name="data2" data="#data2#">

					<!--- Inserta el usuario, le asocia la direccion y los datos personales --->
					<cfset usuario = sec.crearUsuario(
						Session.CEcodigo
						, data2.id_direccion
						, data1.datos_personales
						, rsDatosCuenta.LOCIdioma
						, LSParseDateTime('01/01/6100')
						, "*"
						, true
					)>

					<!--- Asociar Referencia --->
					<cfset ref = sec.insUsuarioRef(usuario, Session.EcodigoSDC, 'PersonaEducativo', ABC_Docente.Ppersona)>
					
				<cfelse>
					<cfset u = sec.getUsuarioByRef(Form.Ppersona, Session.EcodigoSDC, 'PersonaEducativo')>
					<cfif u.RecordCount is 0 >
						<cfthrow message="No se encontro la persona en UsuarioReferencia (PersonaEducativo)">
					</cfif>
					<!--- Actualizacion de los datos personales en el Framework --->
					<cf_datospersonales action="readform" name="data1">
					<cf_datospersonales action="update" key="#u.datos_personales#" name="data1" data="#data1#">
					<!--- Modifica la direccion --->
					<cf_direccion action="readform" name="data2">
					<cf_direccion action="update" key="#u.id_direccion#" name="data2" data="#data2#">
					<!--- Buscar el usuario asociado a la persona --->
					<cfset usuario = u.Usucodigo>

					<!--- Asociar Referencia --->
					<cfset ref = sec.insUsuarioRef(usuario, Session.EcodigoSDC, 'PersonaEducativo', Form.Ppersona)>
				</cfif>
				
				<cfset rol = "">
				<cfif form.TipoPersona EQ 'A'>		<!--- Alumno --->
					<cfset action="alumno.cfm">
					<cfset rol = "ALUMNO">
				<cfelseif form.TipoPersona EQ 'DO'>	<!--- Docente --->
					<cfset action="docente.cfm">
					<cfset rol = "DOCENTE">
				<cfelseif form.TipoPersona EQ 'DI'>	<!--- Director --->					
					<cfset action="director.cfm">
					<cfset rol = "DIRECTOR">
				<cfelseif form.TipoPersona EQ 'PG'>	<!--- Profesor Guia --->
					<cfset action="profGuia.cfm">
					<cfset rol = "GUIA">
				</cfif>						
				<!--- Asignacion de ROL al usario --->
				<cfset ref = sec.insUsuarioRol(usuario, Session.EcodigoSDC, Session.Menues.SScodigo, rol)>
				
			<cfelseif isdefined("Form.Baja")>
				<cfset u = sec.getUsuarioByRef(Form.llavePersona, Session.EcodigoSDC, 'PersonaEducativo')>
				<cfif u.RecordCount is 0 >
					<cfthrow message="No se encontro la persona en UsuarioReferencia (PersonaEducativo)">
				</cfif>
				<!--- Quitar de ROL al usario --->
				<cfset rol = "">
				<cfif form.TipoPersona EQ 'A'>		<!--- Alumno --->
					<cfset action="alumno.cfm">
					<cfset rol = "ALUMNO">
				<cfelseif form.TipoPersona EQ 'DO'>	<!--- Docente --->
					<cfset action="docente.cfm">
					<cfset rol = "DOCENTE">
				<cfelseif form.TipoPersona EQ 'DI'>	<!--- Director --->					
					<cfset action="director.cfm">
					<cfset rol = "DIRECTOR">
				<cfelseif form.TipoPersona EQ 'PG'>	<!--- Profesor Guia --->
					<cfset action="profGuia.cfm">
					<cfset rol = "GUIA">
				</cfif>						
				<cfset sec.delUsuarioRol(u.Usucodigo, Session.EcodigoSDC, Session.Menues.SScodigo, rol)>
				<!---
				<script language="JavaScript" type="text/javascript">
					alert('La inhabilitación de usuarios esta deshabilitada momentaneamente.');
				</script>
				--->
			<cfelseif isdefined("Form.Cambio")>
				<cfset u = sec.getUsuarioByRef(Form.llavePersona, Session.EcodigoSDC, 'PersonaEducativo')>
				<cfif u.RecordCount is 0 >
					<cfthrow message="No se encontro la persona en UsuarioReferencia (PersonaEducativo)">
				</cfif>
				<!--- Actualizacion de los datos personales en el Framework --->
				<cf_datospersonales action="readform" name="data1">
				<cf_datospersonales action="update" key="#u.datos_personales#" name="data1" data="#data1#">
				<!--- Modifica la direccion --->
				<cf_direccion action="readform" name="data2">
				<cf_direccion action="update" key="#u.id_direccion#" name="data2" data="#data2#">
				
				<cfif form.TipoPersona EQ 'A'>		<!--- Alumno --->
					<cfset action="alumno.cfm">
				<cfelseif form.TipoPersona EQ 'DO'>	<!--- Docente --->
					<cfset action="docente.cfm">
				<cfelseif form.TipoPersona EQ 'DI'>	<!--- Director --->
					<cfset action="director.cfm">
				<cfelseif form.TipoPersona EQ 'PG'>	<!--- Profesor Guia --->
					<cfset action="profGuia.cfm">					
				</cfif>
				<cfset modo = "CAMBIO">
			</cfif>
		<cfcatch type="any">
			<cftransaction action="rollback">
			<cfinclude template="/educ/errorpages/BDerror.cfm">
			<cfabort>
		</cfcatch>
		</cftry>
	<!--- </cftransaction> --->
</cfif>

<cfoutput>
	<form action="#action#" method="post">
		<cfif modo NEQ "ALTA" and isdefined("Form.llavePersona") and Len(Trim(Form.llavePersona)) NEQ 0>	
			<cfif form.TipoPersona EQ 'A'>		<!--- Alumno --->
				<input type="hidden" name="Apersona" value="#Form.llavePersona#">
			<cfelseif form.TipoPersona EQ 'DO'>	<!--- Docente --->
				<input type="hidden" name="DOpersona" value="#Form.llavePersona#">
			<cfelseif form.TipoPersona EQ 'DI'>	<!--- Director --->					
				<input type="hidden" name="DIpersona" value="#Form.llavePersona#">
			<cfelseif form.TipoPersona EQ 'DI'>	<!--- Profesor Guia --->					
				<input type="hidden" name="PGpersona" value="#Form.llavePersona#">				
			</cfif>
		</cfif>
		
		<input type="hidden" name="TP" value="#Form.TipoPersona#">	
		<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
		<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
	</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
