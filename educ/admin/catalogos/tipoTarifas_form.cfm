<!--- Establecimiento del modo --->
<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("form.modo")>
		<cfset modo="ALTA"> 
	<cfelseif #form.modo# EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>
<cfif isdefined("Url.TTcodigo") and not isdefined("form.TTcodigo")>
	<cfset Form.TTcodigo = Url.TTcodigo>
</cfif>

<!---       Consultas      --->
<cfif modo NEQ 'ALTA'>
	<cfquery name="rsForm" datasource="#session.DSN#">
		select convert(varchar,Ecodigo) as Ecodigo
			, convert(varchar,TTcodigo) as TTcodigo
			, TTnombre
			, TTtipo
		from TarifasTipo
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and TTcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TTcodigo#">
	</cfquery>

	<cfquery datasource="#Session.DSN#" name="rsHayPeriodos">
		Select *
		from PeriodoTarifas
		where TTcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TTcodigo#">
	</cfquery>	
</cfif>

<script type="text/javascript" language="JavaScript">
	function irALista() {
		location.href = "tipoTarifas.cfm";
	}
</script>

<script language="JavaScript" src="/cfmx/educ/js/qForms/qforms.js">//</script>
<script language="JavaScript" src="/cfmx/educ/js/utilesMonto.js">//</script>

<form action="tipoTarifas_SQL.cfm" method="post" name="formTipoTarifas" >
	<cfif modo neq 'ALTA'>
		<cfoutput>	
			<input type="hidden" name="TTcodigo"  value="<cfif isdefined('rsForm') and rsForm.recordCount GT 0>#rsForm.TTcodigo#</cfif>">			
			<input type="hidden" name="rsHayPeriodos"  value="<cfif isdefined('rsHayPeriodos') and rsHayPeriodos.recordCount GT 0>#rsHayPeriodos.recordCount#<cfelse>0</cfif>">			
		</cfoutput>
	</cfif>
  <table width="100%" border="0" cellpadding="1" cellspacing="1">
    <tr> 
      <td class="tituloMantenimiento" colspan="3" align="center"> <font size="3"> 
        <cfif modo eq "ALTA">
          Nuevo 
          <cfelse>
          Modificar 
        </cfif>
			Tipo de Tarifa
        </font></td>
    </tr>
    <tr> 
      <td width="46%" align="right" valign="baseline">Nombre</td>
      <td width="50%" valign="baseline"><input name="TTnombre" type="text" id="TTnombre" onfocus="javascript:this.select();" value="<cfif modo neq 'ALTA'><cfoutput>#rsForm.TTnombre#</cfoutput></cfif>" size="60" maxlength="255"></td>
      <td width="4%" align="right" valign="middle">
	  	<cf_sifayuda width="650" height="450" name="imgAyuda" Tip="false">
	  </td>
    </tr>
    <tr> 
      <td align="right"> Tipo: </td>
      <td colspan="2" align="left"><select name="TTtipo" id="TTtipo">
        <option value="1" <cfif modo NEQ 'ALTA' and rsForm.TTtipo EQ 1> selected</cfif>>Matricula</option>
        <option value="2" <cfif modo NEQ 'ALTA' and rsForm.TTtipo EQ 2> selected</cfif>>Curso</option>
        <option value="3" <cfif modo NEQ 'ALTA' and rsForm.TTtipo EQ 3> selected</cfif>>Otros</option>
      </select> 
      </td>
    </tr>
    <tr> 
      <td align="center">&nbsp;</td>
      <td colspan="2" align="center">&nbsp;</td>
    </tr>
    <tr> 
      <td align="center" colspan="3"> <cfset mensajeDelete = "¿Desea Eliminar este Tipo de Tarifa?"> 
        <cfinclude template="/educ/portlets/pBotones.cfm">
		<input type="button" name="btnLista"  tabindex="1" value="Lista de Tipos de Tarifas" onClick="javascript: irALista();">
	  </td>
    </tr>
  </table>
</form>	  

<script language="JavaScript">
	
//---------------------------------------------------------------------------------------		
	function deshabilitarValidacion() {
		objForm.TTnombre.required = false;
		objForm.TTtipo.required = false;		
	}
//---------------------------------------------------------------------------------------		
	function habilitarValidacion() {
		objForm.TTnombre.required = true;
		objForm.TTtipo.required = true;				
	}
//---------------------------------------------------------------------------------------	
	function __isTieneDependencias() {
		if(btnSelected("Baja", this.obj.form)) {
			// Valida que el tipo de Tarifa no tenga dependencias.
			var msg = "";
			if (new Number(this.obj.form.rsHayPeriodos.value) > 0) {
				msg = msg + " Períodos de Tarifas";
			}
			if (msg != ""){
				this.error = "Usted no puede eliminar el tipo de Tarifa '" + this.obj.form.TTnombre.value + "' porque ésta tiene asociado: " + msg + ".";
				this.obj.form.TTnombre.focus();
			}
		}
	}	
//---------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/educ/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
//---------------------------------------------------------------------------------------
	qFormAPI.errorColor = "#FFFFCC";
	_addValidator("isTieneDependencias", __isTieneDependencias);
	objForm = new qForm("formTipoTarifas");
//---------------------------------------------------------------------------------------
	objForm.TTnombre.required = true;
	objForm.TTnombre.description = "Nombre";
	objForm.TTtipo.required = true;
	objForm.TTtipo.description = "Tipo";
	
	<cfif modo NEQ "ALTA">
		objForm.TTnombre.validateTieneDependencias();
	</cfif>	
</script>
