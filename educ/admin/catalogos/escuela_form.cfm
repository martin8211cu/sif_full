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

<cfquery name="rsFacultad" datasource="#session.DSN#">
	Select Fnombre
		, Fcodificacion
	from Facultad
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and Fcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Fcodigo#">
</cfquery>
<cfif modo NEQ 'ALTA'>
	<cfquery name="rsForm" datasource="#session.DSN#">
		Select 
			convert(varchar,EScodigo) as EScodigo
			, EScodificacion
			, ESnombre
			, ESprefijo
			, ts_rversion
		from Escuela
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and Fcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Fcodigo#">
			and EScodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EScodigo#">
	</cfquery>
	<cfquery datasource="#Session.DSN#" name="rsHayCarreras">	
		Select *
		from Carrera
		where EScodigo=<cfqueryparam value="#Form.EScodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>	
</cfif>

<script language="JavaScript" src="/cfmx/educ/js/qForms/qforms.js">//</script>
<script language="JavaScript" src="/cfmx/educ/js/utilesMonto.js">//</script>

<cfoutput>
<form action="escuela_SQL.cfm" method="post" name="formEscuela">
	<input type="hidden" name="nivel" value="#Form.nivel#">
	<input type="hidden" name="Fcodigo" id="Fcodigo" value="#Form.Fcodigo#">	
	<cfif modo neq 'ALTA'>
		<cfset ts = "">	
			<input type="hidden" name="EScodigo" id="EScodigo" value="#rsForm.EScodigo#">
			<cfinvoke component="educ.componentes.DButils" method="toTimeStamp"returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#" size="32">					
			<input type="hidden" name="HayCarreras"  value="<cfif isdefined('rsHayCarreras') and rsHayCarreras.recordCount GT 0>#rsHayCarreras.recordCount#<cfelse>0</cfif>">			
	</cfif>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
      <tr> 
        <td class="tituloMantenimiento" colspan="3" align="center"> <font size="3"> 
          <cfif modo eq "ALTA">
            Nueva 
            <cfelse>
            Modificar  
          </cfif>
			   #session.parametros.Escuela# 
          </font></td>
      </tr>
      <tr> 
        <td align="right" valign="baseline" class="fileLabel">#session.parametros.Facultad#: </td>
        <td colspan="2" align="left" valign="baseline" class="fileLabel">#rsFacultad.Fnombre#</td>
      </tr>
      <tr> 
        <td align="right" class="fileLabel"> C&oacute;digo: </td>
        <td colspan="2" align="left"><input name="EScodificacion" align="left" type="text" id="EScodificacion" size="15" maxlength="15" value="<cfif modo NEQ "ALTA">#rsForm.EScodificacion#</cfif>" onfocus="javascript: this.select();">
        </td>
      </tr>
      <tr> 
        <td align="right" valign="baseline" class="fileLabel">Nombre: </td>
        <td colspan="2" valign="baseline"><input name="ESnombre" type="text" id="ESnombre" onfocus="javascript:this.select();" value="<cfif modo neq 'ALTA'>#rsForm.ESnombre#</cfif>" size="50" maxlength="50"></td>
      </tr>
      <tr> 
        <td align="right" valign="baseline" class="fileLabel">Prefijo para Materias: 
        </td>
        <td colspan="2" valign="baseline"><input name="ESprefijo" type="text" id="ESprefijo" onfocus="javascript:this.select();" value="<cfif modo neq 'ALTA'>#rsForm.ESprefijo#</cfif>" size="4" maxlength="4"></td>
      </tr>
      <tr> 
        <td align="center" colspan="3"> <cfset mensajeDelete = "¿Desea Eliminar esta #session.parametros.Escuela# ?"> 
          <cfinclude template="/educ/portlets/pBotones.cfm"> <cfif modo NEQ "ALTA">
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
		objForm.ESnombre.required = false;
		objForm.EScodificacion.required = false;
	}
//---------------------------------------------------------------------------------------		
	function habilitarValidacion() {
		objForm.ESnombre.required = true;
		objForm.EScodificacion.required = true;
	}
//---------------------------------------------------------------------------------------	
	// Se aplica la descripcion del Concepto 
	function __isTieneDependencias() {
		if(btnSelected("Baja", this.obj.form)) {
			// Valida que no tenga dependencias.
			var msg = "";
			if (new Number(this.obj.form.HayCarreras.value) > 0) {
				msg = msg + "<cfoutput>#session.parametros.Escuela#</cfoutput>s"
			}
			if (msg != ""){
				this.error = "Usted no puede eliminar la <cfoutput>#session.parametros.Escuela#</cfoutput> '" + this.obj.form.ESnombre.value + "' porque éste tiene asociado: " + msg + ".";
				this.obj.form.ESnombre.focus();
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
	objForm = new qForm("formEscuela");
//---------------------------------------------------------------------------------------
	objForm.ESnombre.required = true;
	objForm.ESnombre.description = "Nombre";
	objForm.EScodificacion.required = true;
	objForm.EScodificacion.description = "Codificación";
	<cfif modo NEQ "ALTA">
		objForm.ESnombre.validateTieneDependencias();
	</cfif>	
</script>
