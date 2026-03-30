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

<cfif modo NEQ 'ALTA'>
	<cfquery name="rsForm" datasource="#session.DSN#">
		Select Fnombre
			, Fcodificacion
			, ts_rversion
		from Facultad
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and Fcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Fcodigo#">
	</cfquery>
	<cfquery datasource="#Session.DSN#" name="rsHayEscuelas">	
		Select *
		from Escuela
		where Fcodigo=<cfqueryparam value="#Form.Fcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>	
</cfif>

<script language="JavaScript" src="/cfmx/educ/js/qForms/qforms.js">//</script>
<script language="JavaScript" src="/cfmx/educ/js/utilesMonto.js">//</script>

<cfoutput>
<form action="facultad_SQL.cfm" method="post" name="formFacultad">
	<input type="hidden" name="nivel" value="#Form.nivel#">
	<cfif modo neq 'ALTA'>
		<cfset ts = "">	
			<input type="hidden" name="Fcodigo" id="Fcodigo" value="#Form.Fcodigo#">
			<cfinvoke component="educ.componentes.DButils" method="toTimeStamp"returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#" size="32">					
			<input type="hidden" name="HayEscuelas"  value="<cfif isdefined('rsHayEscuelas') and rsHayEscuelas.recordCount GT 0>#rsHayEscuelas.recordCount#<cfelse>0</cfif>">			
	</cfif>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
      <tr> 
        <td class="tituloMantenimiento" colspan="3" align="center"> <font size="3"> 
          <cfif modo eq "ALTA">
            Nueva 
            <cfelse>
            Modificar 
          </cfif>
		  #session.parametros.Facultad#
          </font></td>
      </tr>
      <tr> 
        <td align="right" class="fileLabel"> C&oacute;digo: </td>
        <td colspan="2" align="left"><input name="Fcodificacion" align="left" type="text" id="Fcodificacion" size="15" maxlength="15" value="<cfif modo NEQ "ALTA">#rsForm.Fcodificacion#</cfif>" onfocus="javascript: this.select();"> 
        </td>
      </tr>
      <tr> 
        <td align="right" valign="baseline" class="fileLabel">Nombre: </td>
        <td colspan="2" valign="baseline"><input name="Fnombre" type="text" id="Fnombre" onfocus="javascript:this.select();" value="<cfif modo neq 'ALTA'>#rsForm.Fnombre#</cfif>" size="50" maxlength="50"></td>
      </tr>
      <tr> 
        <td align="center" colspan="3"> <cfset mensajeDelete = "¿Desea Eliminar esta #session.parametros.Facultad#?"> 
          <cfinclude template="/educ/portlets/pBotones.cfm"> <cfif modo NEQ "ALTA">
            <input type="submit" name="btnNuevoPlan" value="Nueva #session.parametros.Escuela#" onClick="javascript: deshabilitarValidacion();">
          </cfif> 
		  <input name="btnLista" type="button" id="btnLista" value="Ir a Lista" onClick="javascript: listaFacultades();">
		  </td>
      </tr>
    </table>
</form>
</cfoutput>	  

<script language="JavaScript">
//---------------------------------------------------------------------------------------		
	function listaFacultades(){
		location.href='facultades.cfm';
	}
//---------------------------------------------------------------------------------------		
	function deshabilitarValidacion() {
		objForm.Fnombre.required = false;
		objForm.Fcodificacion.required = false;
	}
//---------------------------------------------------------------------------------------		
	function habilitarValidacion() {
		objForm.Fnombre.required = true;
		objForm.Fcodificacion.required = true;
	}
//---------------------------------------------------------------------------------------	
	// Se aplica la descripcion del Concepto 
	function __isTieneDependencias() {
		if(btnSelected("Baja", this.obj.form)) {
			// Valida que no tenga dependencias.
			var msg = "";
			if (new Number(this.obj.form.HayEscuelas.value) > 0) {
				msg = msg + "<cfoutput>#session.parametros.Escuela#</cfoutput>s"
			}
			if (msg != ""){
				this.error = "Usted no puede eliminar la <cfoutput>#session.parametros.Facultad#</cfoutput> '" + this.obj.form.Fnombre.value + "' porque ésta tiene asociadas: " + msg + ".";
				this.obj.form.Fnombre.focus();
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
	objForm = new qForm("formFacultad");
//---------------------------------------------------------------------------------------
	objForm.Fnombre.required = true;
	objForm.Fnombre.description = "Nombre";
	objForm.Fcodificacion.required = true;
	objForm.Fcodificacion.description = "Codificación";
	<cfif modo NEQ "ALTA">
		objForm.Fnombre.validateTieneDependencias();
	</cfif>	
</script>