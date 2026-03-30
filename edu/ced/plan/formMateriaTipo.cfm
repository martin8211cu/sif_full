<cfset modo="ALTA">
<cfif isdefined("Form.MTcodigo") and len(trim("Form.MTcodigo")) NEQ 0 and Form.MTcodigo gt 0>
    <cfset modo="CAMBIO">
</cfif>

<!--- ==================== --->
<!---       Consultas      --->
<!--- ==================== --->
<!--- 1. Form --->
<cfquery name="rsForm" datasource="#Session.Edu.DSN#">
	select convert(varchar,MTcodigo) as MTcodigo, substring(MTdescripcion,1,50) as MTdescripcion
	from MateriaTipo
	<cfif isdefined("form.MTcodigo") and form.MTcodigo neq "">
		where MTcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MTcodigo#">
		  and CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	</cfif>	  
</cfquery>
<cfif modo NEQ "ALTA" and isdefined("Form.MTcodigo") and len(trim("Form.MTcodigo")) GT 0>
	<!--- 3. Validaciones de dependencias--->
	<!---  Rodolfo JImenez Jara, SOIN, 03/12/2002 --->
	<cfquery datasource="#Session.Edu.DSN#" name="rsHayMateria">
		select 1 from Materia
		where MTcodigo  = <cfqueryparam value="#Form.MTcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>
</cfif>	  
<script language="JavaScript" src="../../js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	
</script>

<form action="SQLMateriaTipo.cfm" method="post" name="materiatipo" style="margin:0">
  	<input type="hidden" name="Pagina" value="<cfoutput>#form.Pagina#</cfoutput>">
	<input type="hidden" name="Filtro_MTdescripcion" value="<cfoutput>#form.Filtro_MTdescripcion#</cfoutput>">
  <cfoutput> 
   
    <table width="100%" border="0" cellpadding="0" cellspacing="0">
     
      <tr> 
        <td  class="tituloAlterno" colspan="2" align="center"><font size="3"> 
          <cfif modo eq "ALTA">
            Nuevo Tipo de Materia 
            <cfelse>
            Modificar Tipo de Materia 
          </cfif>
          </font></td>
      </tr>
      <tr> 
        <td align="right" valign="baseline">Descripci&oacute;n:</td>
        <td valign="baseline"><input name="MTdescripcion" type="text" size="50" maxlength="255" alt="El valor de la Descripci&oacute;n" value="<cfif modo NEQ "ALTA"><cfoutput>#rsForm.MTdescripcion#</cfoutput></cfif>"></td>
      </tr>
      <tr> 
        <td align="center" colspan="2"><cf_botones modo="#modo#"></td>
      </tr>
      <cfif modo neq 'ALTA'>
        <tr> 
          <td colspan="2">
		  	<input type="hidden" name="MTcodigo"  value="#rsForm.MTcodigo#">
			<input type="hidden" name="HayMateria"  value="#rsHayMateria.recordCount#">
		  </td>
        </tr>
      </cfif>
    </table>
	</cfoutput>
</form>

<script language="JavaScript">

	function deshabilitarValidacion() {
		objForm.MTdescripcion.required = false;
	}
	
	function habilitarValidacion() {
		objForm.MTdescripcion.required = true;
	}	
	
	// Se aplica la descripcion del Grado 
	function __isTieneDependencias() {
		if(btnSelected("Baja", this.obj.form)) {
				// Valida que el Grado no tenga dependencias con otros.
				var msg = "";
				//alert(new Number(this.obj.form.HayMateria.value)); 
				if (new Number(this.obj.form.HayMateria.value) > 0) {
					msg = msg + "materias"
				}
				if (msg != "")
				{
					this.error = "Usted no puede eliminar el Tipo de Materia '" + this.obj.form.MTdescripcion.value + "' porque éste tiene asociado: " + msg + ".";
					this.obj.form.MTdescripcion.focus();
				}
		}
	}
	
	qFormAPI.errorColor = "#FFFFCC";
	_addValidator("isTieneDependencias", __isTieneDependencias);
	objForm = new qForm("materiatipo");
	
	<cfif modo EQ "ALTA">
		objForm.MTdescripcion.required = true;
		objForm.MTdescripcion.description = "Descripción";
	<cfelse>
		objForm.MTdescripcion.required = true;
		objForm.MTdescripcion.description = "Descripción";
	</cfif>
	
	objForm.MTdescripcion.validateTieneDependencias();
</script>

