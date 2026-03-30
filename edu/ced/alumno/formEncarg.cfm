<cfif isdefined("Url.persona") and not isdefined("Form.persona")>
	<cfparam name="Form.persona" default="#Url.persona#">
</cfif> 
<cfif isdefined("Url.o") and not isdefined("Form.o")>
	<cfparam name="Form.o" default="#Url.o#">
</cfif> 

<cfif isdefined("form.persona")>
	<cfparam name="Form.persona" default="#form.persona#">
</cfif> 


<cfset modo = 'Alta'>
<cfif isdefined("Form.persona") and len(trim(form.persona))>
	<cfset modo = 'Cambio'>
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
		from PersonaEducativo a
		inner join Alumnos d
		   on d.CEcodigo = a.CEcodigo
		  and d.persona = a.persona
		inner join Estudiante e
		   on e.Ecodigo = d.Ecodigo
		inner join Promocion f
		   on f.PRcodigo = d.PRcodigo
		inner join Grado g
		   on g.Gcodigo = f.Gcodigo
		inner join Pais b
		   on b.Ppais = a.Ppais
		inner join TipoIdentificacion c
		   on c.TIcodigo = a.TIcodigo
		where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and a.persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
	</cfquery>
	
	<!--- Para cargar en memoria el codigo del estudiante "Ecodigo" por si se retira o no --->
	<cfquery datasource="#Session.Edu.DSN#" name="rsform_Ecodigo">
		Select convert(varchar,a.Ecodigo) as Ecodigo
		from Alumnos a
		inner join Estudiante b
		   on b.persona = a.persona
		  and b.Ecodigo = a.Ecodigo
		where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		  and a.persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#persona#">
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
	from Nivel b
	inner join Grado c
	   on c.Ncodigo = b.Ncodigo
	inner join Promocion a
	   on a.Gcodigo = c.Gcodigo
	  and a.Ncodigo = c.Ncodigo
	where b.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		and a.PRactivo=1
	order by b.Norden,c.Gorden,a.PRcodigo
</cfquery>

<cfif isdefined("Form.persona") and len(trim(form.persona)) neq 0>
	<cfinclude template="../../portlets/pAlumnoCED.cfm">
</cfif>
	<form action="SQLAlumno.cfm" method="post" enctype="multipart/form-data" id="formAlumno" name="form1">
		<cfoutput>
		<input name="persona" type="hidden" value="<cfif isdefined("form.persona")>#form.persona#</cfif>"> 
		<input name="tab" type="hidden" value="<cfif isdefined("Form.tab")>#form.tab#</cfif>"> 
		<input name="Pagina" type="hidden" value="<cfif isdefined('form.Pagina')>#form.Pagina#</cfif>">
		<input name="form_Ecodigo" id="form_Ecodigo" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsform_Ecodigo.Ecodigo#</cfoutput></cfif>" type="hidden">
		<!--- Campos del filtro para la lista de alumnos --->
		<cfif isdefined("Form.Filtro_Estado")>
			<input type="hidden" name="Filtro_Estado" value="#Form.Filtro_Estado#">
		</cfif>		   
		<cfif isdefined("Form.Filtro_Grado")>
			<input type="hidden" name="Filtro_Grado" value="#Form.Filtro_Grado#">
		</cfif>		
		<cfif isdefined("Form.Filtro_Ndescripcion")>
			<input type="hidden" name="Filtro_Ndescripcion" value="#Form.Filtro_Ndescripcion#">
		</cfif>		
		<cfif isdefined("Form.Filtro_Nombre")>
			<input type="hidden" name="Filtro_Nombre" value="#Form.Filtro_Nombre#">
		</cfif>
		<cfif isdefined("Form.Filtro_Pid")>
			<input type="hidden" name="Filtro_Pid" value="#Form.Filtro_Pid#">
		</cfif>
		<input type="hidden" name="NoMatr" value="<cfif isdefined("Form.NoMatr")>#Form.NoMatr#</cfif>">
		</cfoutput>
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
<cf_qforms>

<script> 
// Validacion para el form de agregar encargados por alumno	
	<cfif modo EQ "CAMBIO">
		objFormAE = new qForm("formAgregaEncar");	
		objFormAE.NombreEncar.required = true;
		objFormAE.NombreEncar.description = "encargado";
	</cfif>
</script>
