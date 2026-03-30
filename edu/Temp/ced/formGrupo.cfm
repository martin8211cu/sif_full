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

<cfif modo NEQ "ALTA">
	<cfquery name="rsGrupo" datasource="#Session.DSN#">
		select convert(varchar, a.Ncodigo) as Ncodigo, convert(varchar, b.Gcodigo) as Gcodigo, convert(varchar, c.GRcodigo) as GRcodigo, c.GRnombre
		from Nivel a, Grado b, Grupo c
		where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
		and a.Ncodigo = b.Ncodigo
		and b.Ncodigo = c.Ncodigo
		and b.Gcodigo = c.Gcodigo
		and c.GRcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.GRcodigo#">
	</cfquery>

	<cfquery datasource="#Session.DSN#" name="rsHayCursos">
		select 1 from Curso
		where GRcodigo  = <cfqueryparam value="#rsGrupo.GRcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>

</cfif>

<script language="JavaScript" src="../../js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	
	function validaForm(f) {
		if (f.Ncodigo.obj.disabled) {
			f.Ncodigo.obj.disabled = false;
		}
		return true;
	}
	
	function crearNuevoNivel(c) {
		if (c.value == "0") {
			c.selectedIndex = 0;
			location.href='Nivel.cfm?RegresarURL=Grupo.cfm';
		}
		else if (c.value == "") 
			c.selectedIndex = 0;
	}
	
	function crearNuevoGrado(c) {
		if (c.value == "0") {
			c.selectedIndex = 0;
			location.href='Grado.cfm?RegresarURL=Grupo.cfm';
		}
		else if (c.value == "") 
			c.selectedIndex = 0;
	}

</script>

<form action="SQLGrupo.cfm" method="post" name="form1" onSubmit="javascript:return validaForm(this);">
<cfif modo NEQ "ALTA">
	<input type="hidden" name="GRcodigo" value="<cfoutput>#rsGrupo.GRcodigo#</cfoutput>">
</cfif>
<cfif isdefined("Form.FNcodigo") and isdefined("Form.FGcodigo")>
	<input type="hidden" name="FNcodigo" value="<cfoutput>#Form.FNcodigo#</cfoutput>">
	<input type="hidden" name="FGcodigo" value="<cfoutput>#Form.FGcodigo#</cfoutput>">
</cfif>
<table align="center" width="100%" border="0">
<tr>
  	<td class="tituloMantenimiento" colspan="2"><cfif modo eq "ALTA">
          Nuevo Grupo 
          <cfelse>
          Modificar Grupo 
        </cfif>
	</td>
</tr>
<tr valign="baseline"> 
	  <td align="right" valign="middle" nowrap> Nombre </td>
    <td>
	  	<input name="GRnombre" onfocus="javascript:this.select();"  type="text" value="<cfif modo NEQ "ALTA"><cfoutput>#rsGrupo.GRnombre#</cfoutput></cfif>" size="50" maxlength="255" alt="El Nombre del Grupo"> 
    </td>
</tr>  
<tr valign="baseline"> 
	<td nowrap align="right">
		Nivel
	</td>
    <td nowrap> 
        <select name="Ncodigo" id="Ncodigo" tabindex="1" onchange="javascript: crearNuevoNivel(this); cargarGrados(this, this.form.Gcodigo, '<cfif modo NEQ "ALTA"><cfoutput>#rsGrupo.Gcodigo#</cfoutput></cfif>', false)">
          <cfoutput query="rsNiveles"> 
            <option value="#Ncodigo#" <cfif modo NEQ "ALTA" AND rsGrupo.Ncodigo EQ rsNiveles.Ncodigo>selected</cfif>>#Ndescripcion#</option>
          </cfoutput> 
          <option value="">-------------------</option>
          <option value="0">Crear Nuevo ...</option>
        </select>
	</td>
</tr>
<tr valign="baseline"> 
	<td nowrap align="right">Grado
	</td>
    <td>
        <select name="Gcodigo" id="Gcodigo" tabindex="1" onchange="javascript: crearNuevoGrado(this);">
          <cfoutput query="rsGrado"> 
            <option value="#Codigo#">#rsGrado.Gdescripcion#</option>
          </cfoutput> 
          <option value="">-------------------</option>
          <option value="0">Crear Nuevo ...</option>
        </select>
	</td>
</tr>
<tr valign="baseline"> 
	<td colspan="2" align="center" nowrap><cfinclude template="../../portlets/pBotones.cfm"> &nbsp; 
		<!---
	  	<input type="hidden" name="Gcodigo" value="<cfif modo NEQ "ALTA"><cfoutput>#rsGrado.Gcodigo#</cfoutput></cfif>"> 
        <input type="hidden" name="Ganual" value="<cfif modo NEQ "ALTA"><cfoutput>#rsGrado.Ganual#</cfoutput></cfif>"> 
        <input type="hidden" name="_Ncodigo" value="<cfif modo NEQ "ALTA"><cfoutput>#rsGrado.Ncodigo#</cfoutput></cfif>">
		<input type="hidden" name="Ayuda" value="1">
	<cfif modo NEQ "ALTA">	
		<cfoutput>	
			<input type="hidden" name="HayMateria" value="#rsHayMateria.recordCount#">
			<input type="hidden" name="HayGrupos" value="#rsHayGrupos.recordCount#">
			<input type="hidden" name="HayHorario" value="#rsHayHorario.recordCount#">
		</cfoutput>
	</cfif>
	--->
	</td>
</tr>
</table>

</form>
<script language="JavaScript">

	function deshabilitarValidacion() {
		objForm.GRnombre.required = false;
		objForm.Ncodigo.required = false;
		objForm.Gcodigo.required = false;
	}

	/*
	// Se aplica la descripcion del Grado 
	function __isTieneDependencias() {
		if(btnSelected("Baja", this.obj.form)) {
				// Valida que el Grado no tenga dependencias con otros.
				var msg = "";
				
				if (new Number(this.obj.form.HayMateria.value) > 0) {
					msg = msg + "materias"
				}
				if (new Number(this.obj.form.HayGrupos.value) > 0) {
					if (msg != "") msg += ', ';
					msg = msg + "grupos"
				}
				if (new Number(this.obj.form.HayHorario.value) > 0) {
					if (msg != "") msg += ', ';
					msg = msg + "horarios"
				}
				if (msg != "")
				{
					this.error = "Usted no puede eliminar el Grado " + this.obj.form.Gdescripcion.value + " porque éste tiene asociado: " + msg + ".";
					this.obj.form.Gdescripcion.focus();
				}
		}
	}
	*/
	
	qFormAPI.errorColor = "#FFFFCC";
	//_addValidator("isTieneDependencias", __isTieneDependencias);
	
	objForm = new qForm("form1");

	<cfif modo EQ "ALTA">
		objForm.GRnombre.required = true;
		objForm.GRnombre.description = "Nombre";
		objForm.Ncodigo.required = true;
		objForm.Ncodigo.description = "Nivel";
		objForm.Gcodigo.required = true;
		objForm.Gcodigo.description = "Grado";
	<cfelseif modo EQ "CAMBIO">
		objForm.GRnombre.required = true;
		objForm.GRnombre.description = "Nombre";
		objForm.Ncodigo.required = true;
		objForm.Ncodigo.description = "Nivel";
		objForm.Gcodigo.required = true;
		objForm.Gcodigo.description = "Grado";
	</cfif>
</script>
