<cfif isdefined("Url.persona") and not isdefined("Form.persona")>
	<cfparam name="Form.persona" default="#Url.persona#">
</cfif> 

<cfif isdefined("form.persona")>
	<cfparam name="Form.persona" default="#form.persona#">
</cfif> 

<cfif isdefined("Url.modo") and not isdefined("Form.modo")>
	<cfparam name="Form.modo" default="#Url.modo#">
</cfif>			

<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<!--- 1. Form  --->
<cfif modo EQ "CAMBIO" >
	<cfquery datasource="#Session.Edu.DSN#" name="rsForm">
		Select convert(varchar,a.persona) as persona, 
		       convert(varchar,a.CEcodigo) as CEcodigo, 
			   a.Pnombre, Papellido1, Papellido2, a.Ppais, 
			   b.Pnombre, a.TIcodigo, TInombre, Pid, 
			   convert(varchar,Pnacimiento,103) Pnacimiento, Psexo, 
			   Pemail1, Pemail2, Pdireccion, Pcasa, 
			   Pfoto, PfotoType, PfotoName, Pemail1validado, 
			   convert(varchar,d.PRcodigo) as PRcodigo, Aretirado,
			   isnull(Gdescripcion,'sin grado asociado') as Gdescripcion,
			   e.autorizado
		from PersonaEducativo a, Pais b, TipoIdentificacion c, Alumnos d, Estudiante e, Promocion f, Grado g
		where a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and a.CEcodigo=d.CEcodigo
			and a.persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
			and a.Ppais=b.Ppais
			and a.TIcodigo=c.TIcodigo
			and a.persona=d.persona
			and d.Ecodigo=e.Ecodigo
			and d.PRcodigo=f.PRcodigo
			and f.Gcodigo=g.Gcodigo		
	</cfquery>
	
	<!--- Para cargar en memoria el codigo del estudiante "Ecodigo" por si se retira o no --->
	<cfquery datasource="#Session.Edu.DSN#" name="rsform_Ecodigo">
		Select convert(varchar,a.Ecodigo) as Ecodigo
		from Alumnos a, Estudiante b
		where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and a.persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#persona#">
			and a.persona=b.persona
			and a.Ecodigo=b.Ecodigo
	</cfquery>	
</cfif>

<!--- Para el combo de tipos de Identificacion  --->
<cfquery datasource="#Session.Edu.DSN#" name="rsTipoIdentif">
	select TIcodigo,TInombre from TipoIdentificacion
</cfquery>

<!---  Para el combo de paises  --->
<cfquery datasource="#Session.Edu.DSN#" name="rsPaises">
	select Ppais,Pnombre from Pais 
</cfquery>

<cfquery datasource="#Session.Edu.DSN#" name="rsPromo">
	select convert(varchar,PRcodigo) as PRcodigo,(PRdescripcion + ': ' + Gdescripcion) as PRdescripcion 
	from Nivel b, Grado c, Promocion  a
	where b.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		and a.PRactivo=1
		and b.Ncodigo=c.Ncodigo
		and a.Gcodigo=c.Gcodigo
		and a.Ncodigo=c.Ncodigo
		and a.Gcodigo=c.Gcodigo
	order by b.Norden,c.Gorden,a.PRcodigo
</cfquery>
<link href="../../css/edu.css" rel="stylesheet" type="text/css">
<h2 class="tab">Encargado</h2>
	<form action="SQLAlumno.cfm" method="post" enctype="multipart/form-data" id="formAlumno" name="formAlumno">
		<input name="persona" id="persona" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.persona#</cfoutput></cfif>" type="hidden"> 
		<input name="MODO" id="MODO" value="<cfoutput>#modo#</cfoutput>" type="hidden">
		<input name="form_Ecodigo" id="form_Ecodigo" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsform_Ecodigo.Ecodigo#</cfoutput></cfif>" type="hidden">
	</form>
		<table width="100%" border="0">
			<tr>
				<td valign="top">
					<cfinclude template="formAgregaEncar.cfm">
				</td> 
				<td valign="top">
					<!--- <cfif modo EQ 'CAMBIO'> --->
					<cfif isdefined("form.persona")>
						<cfinclude template="listaEncarAsoc.cfm">
						</td>
					<cfelse>
						&nbsp;
					</cfif>
			</tr>
		</table>

<script language="JavaScript" type="text/javascript" src="../../js/calendar.js" >//</script>
<script language="JavaScript" type="text/javascript" src="../../js/utilesMonto.js">//</script>
<script language="JavaScript" type="text/javascript" src="js/formAlumno.js">//</script> 
<script language="JavaScript" src="../../js/qForms/qforms.js">//</script>
<script language="JavaScript" type="text/JavaScript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script> 		
<script> 
// Validacion para el form de agregar encargados por alumno	
	<cfif modo EQ "CAMBIO">
		qFormAPI.errorColor = "#FFFFCC";
		objFormAE = new qForm("formAgregaEncar");	
	
		objFormAE.NombreEncar.required = true;
		objFormAE.NombreEncar.description = "encargado";
/*		objFormAE.PdireccionEncar.required = true;
		objFormAE.PdireccionEncar.description = "dirección";
		objFormAE.PidEncar.required = true;
		objFormAE.PidEncar.description = "identificación";
		objFormAE.FechaNacEncar.required = true;
		objFormAE.FechaNacEncar.description = "encargado";  */				
	</cfif>
</script>
