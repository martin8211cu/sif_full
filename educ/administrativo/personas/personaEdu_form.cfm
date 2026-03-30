<cfif isdefined('form.TP') and form.TP NEQ ''>
	<cfset TipoPersona = form.TP>
<cfelse>
	<cfset TipoPersona = "N">
</cfif>
<cfset LlavePersona = ''>
<cfif isdefined("form.Apersona") and form.Apersona NEQ ''>
	<cfset TipoPersona = "A">		<!--- Alumno --->
	<cfif isdefined('form.Apersona') and form.Apersona NEQ ''>
		<cfset LlavePersona = form.Apersona>	
	</cfif>
<cfelseif isdefined("form.DOpersona") and form.DOpersona NEQ ''>
	<cfset TipoPersona = "DO">	<!--- Docente --->
	<cfif isdefined('form.DOpersona') and form.DOpersona NEQ ''>
		<cfset LlavePersona = form.DOpersona>
	</cfif>
<cfelseif isdefined("form.DIpersona") and form.DIpersona NEQ ''>
	<cfset TipoPersona = "DI">	<!--- Director --->
	<cfif isdefined('form.DIpersona') and form.DIpersona NEQ ''>
		<cfset LlavePersona = form.DIpersona>
	</cfif>	
<cfelseif isdefined("form.PGpersona") and form.PGpersona NEQ ''>
	<cfset TipoPersona = "PG">	<!--- Profesor Guia --->
	<cfif isdefined('form.PGpersona') and form.PGpersona NEQ ''>
		<cfset LlavePersona = form.PGpersona>
	</cfif>	
</cfif>

<!--- Establecimiento del modo --->
<cfif isdefined("form.Cambio") and LlavePersona NEQ ''>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO" and LlavePersona NEQ ''>
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>
	
<!---       Consultas      --->
<cfif modo NEQ 'ALTA'>
 	<cfquery name="rsForm" datasource="#session.DSN#">
		Select 
			convert(varchar,Ppersona) as llavePersona,
			pd.Ppais
			, convert(varchar,pd.id_direccion) as id_direccion						
			, convert(varchar,pd.datos_personales) as datos_personales
		from PersonaDatos pd
		where pd.Ppersona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#LlavePersona#"> 
			and pd.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery> 
</cfif>

<cfset titulo = "Registro de ">
<cfif TipoPersona EQ 'A'>
	<cfset titulo = titulo & "Alumnos">
<cfelseif TipoPersona EQ 'DO'>
	<cfset titulo = titulo & "Docentes">				
<cfelseif TipoPersona EQ 'DI'>		
	<cfset titulo = titulo & "Directores">
<cfelseif TipoPersona EQ 'PG'>							
	<cfset titulo = titulo & "Profesores Gu&iacute;a">		
<cfelse>
	<cfset titulo = titulo & "Personas">
</cfif>

<cfset navBarItems = ArrayNew(1)>
<cfset navBarLinks = ArrayNew(1)>

<script language="JavaScript" src="/cfmx/educ/js/qForms/qforms.js">//</script>
<form name="formPersonaEdu" method="post" action="personaEdu_SQL.cfm" style="margin: 0"  enctype="multipart/form-data">
	<cfoutput>
		<cfif modo neq 'ALTA'>
			<input type="hidden" name="llavePersona" value="#rsForm.llavePersona#">
			<input type="hidden" name="datos_personales" value="#rsForm.datos_personales#">
			<input type="hidden" name="id_direccion" value="#rsForm.id_direccion#">
		</cfif>
		<input type="hidden" name="TipoPersona" value="#TipoPersona#">		
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<cfif modo NEQ 'ALTA'>
		  <tr>
			<td colspan="4" align="center" class="tituloMantenimiento">
				Modificaci&oacute;n
				<cfif TipoPersona EQ 'A'>
					Alumno
				<cfelseif TipoPersona EQ 'DO'>
					Docente				
				<cfelseif TipoPersona EQ 'DI'>		
					Director				
				<cfelseif TipoPersona EQ 'PG'>		
					Profesor Gu&iacute;a									
				<cfelse>
					Persona
				</cfif>			
			</td>
		  </tr>
		<cfelse>
		  <tr>
			<td colspan="4" align="center" class="tituloMantenimiento">
				Nuevo
				<cfif TipoPersona EQ 'A'>
					Alumno
				<cfelseif TipoPersona EQ 'DO'>
					Docente				
				<cfelseif TipoPersona EQ 'DI'>		
					Director				
				<cfelseif TipoPersona EQ 'PG'>		
					Profesor Gu&iacute;a														
				<cfelse>
					Persona
				</cfif>			
			</td>
		  </tr>
		  <tr>
			<td colspan="2" align="right">
				<strong>Persona Existente:&nbsp;&nbsp;</strong>
			</td>
			<td colspan="2">
				<cf_selPersona name="Ppersona" form="formPersonaEdu">
			</td>
		  </tr>
		</cfif>
		  <tr>  
			<td colspan="4">
				<cfif modo neq 'ALTA'>
					<cf_datospersonales form="formPersonaEdu" action="input" key="#rsForm.datos_personales#">
				<cfelse>	
					<cf_datospersonales form="formPersonaEdu" action="input">
				</cfif>		  
			</td>
		  </tr>  		  
		  
		  <tr>  
			<td colspan="4">
				<cfif modo neq 'ALTA'>
					<cf_direccion action="input" key="#rsForm.id_direccion#" >
				<cfelse>	
					<cfquery name="rsCuentaPais" datasource="asp">
						select Ppais
						from CuentaEmpresarial a, Direcciones b
						where a.id_direccion=b.id_direccion
						and CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
					</cfquery>
					<cf_direccion action="new" name="data">
					<cfset data.pais = rsCuentaPais.Ppais >
					<cf_direccion action="input" data="#data#">
				</cfif>		  
			</td>
		  </tr>  		  
		  <tr>  
			<td align="right">&nbsp;</td>
			<td>&nbsp;</td>
			<td colspan="2">&nbsp;</td>
		  </tr>  
		  <tr>  
			<td align="center" colspan="4">
				<cfif TipoPersona EQ 'A'>		<!--- Alumno --->
					<cfset mensajeDelete = "¿Desea Inhabilitar este Alumno ?">
				<cfelseif TipoPersona EQ 'DO'>	<!--- Docente --->
					<cfset mensajeDelete = "¿Desea Inhabilitar este Docente ?">	
				<cfelseif TipoPersona EQ 'DI'>	<!--- Director --->		
					<cfset mensajeDelete = "¿Desea Inhabilitar este Director ?">	
				<cfelseif TipoPersona EQ 'PG'>	<!--- Profesor Guia --->		
					<cfset mensajeDelete = "¿Desea Inhabilitar este Profesor Gu&iacute;a ?">
				</cfif>
				
				<cfinclude template="/educ/portlets/pBotones.cfm">
				<input type="button" name="Regresar" value="Ir a Lista" onClick="javascript:lista();">   
			</td>
		  </tr>    
		  <tr>  
			<td align="right">&nbsp;</td>
			<td>&nbsp;</td>
			<td colspan="2">&nbsp;</td>
		  </tr>  
		</table>
	</cfoutput>	
</form>

<cfif modo neq 'ALTA'>
	<table width="90%" border="0" cellspacing="0" cellpadding="0" align="center">
	  <tr>
		<td align="center">&nbsp;</td>
	  </tr>	
	  <tr>
		<td align="center">
			<cfif TipoPersona EQ 'A'>		<!--- Alumno --->
				<cfinclude template="planEstudiosAlumno.cfm">			
			<cfelseif TipoPersona EQ 'DO'>	<!--- Docente --->
				<cfinclude template="docenteMateria.cfm">
			<cfelseif TipoPersona EQ 'DI'>	<!--- Director --->		
				<cfinclude template="directorEscuela.cfm">
			<cfelseif TipoPersona EQ 'PG'>	<!--- Profesor Guia --->		
				<cfinclude template="profGuiaAlumno.cfm">				
			</cfif>	
		</td>
	  </tr>
	</table>
</cfif>

<script language="JavaScript">
//---------------------------------------------------------------------------------------		
	function lista(){
		<cfif TipoPersona EQ 'A'>		<!--- Alumno --->
			location.href='alumno.cfm';
		<cfelseif TipoPersona EQ 'DO'>	<!--- Docente --->
			location.href='docente.cfm';
		<cfelseif TipoPersona EQ 'DI'>	<!--- Director --->		
			location.href='director.cfm';
		<cfelseif TipoPersona EQ 'PG'>	<!--- Profesor Guia --->		
			location.href='profGuia.cfm';
		</cfif>		
	}
//---------------------------------------------------------------------------------------
	function deshabilitarValidacion() {
		objForm.id.required = false;
		objForm.nombre.required = false;
		objForm.email1.required = false;
	}
//---------------------------------------------------------------------------------------	
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/educ/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
//---------------------------------------------------------------------------------------
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formPersonaEdu");
//---------------------------------------------------------------------------------------	
	objForm.id.required = true;
	objForm.id.description = "Identificación";
	objForm.nombre.required = true;
	objForm.nombre.description = "Nombre";
	<cfif modo EQ "ALTA">
		objForm.email1.required = true;
		objForm.email1.description = "Email";
	</cfif>
</script>