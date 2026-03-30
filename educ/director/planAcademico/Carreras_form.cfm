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

<cfquery name="rsEscuela" dbtype="query">
	select * from rsEscuela where EScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.EScodigo#">
</cfquery>
<cfif modo NEQ 'ALTA'>
	<cfquery name="rsForm" datasource="#session.DSN#">
		Select convert(varchar,CARcodigo) as CARcodigo
			, convert(varchar,EScodigo) as EScodigo
			, CARnombre
			, CARcodificacion
			, ts_rversion
		from Carrera
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and CARcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CARcodigo#">
	</cfquery>
	<cfquery datasource="#Session.DSN#" name="rsHayPlanEstudios">	
		Select *
		from PlanEstudios
		where CARcodigo=<cfqueryparam value="#Form.CARcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>	
</cfif>


<script language="JavaScript" src="../../js/qForms/qforms.js">//</script>
<script language="JavaScript" src="../../js/utilesMonto.js">//</script>

<cfoutput>
<form action="Carreras_SQL.cfm" method="post" name="formCarreras">
	<input type="hidden" name="nivel" value="#Form.nivel#">
	<input type="hidden" name="EScodigo" value="#Form.EScodigo#">
	<cfif modo neq 'ALTA'>
		<cfset ts = "">	
			<input type="hidden" name="CARcodigo" id="CARcodigo" value="#rsForm.CARcodigo#">
			<cfinvoke component="educ.componentes.DButils" method="toTimeStamp"returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#" size="32">					
			<input type="hidden" name="HayPlanEstudios"  value="<cfif isdefined('rsHayPlanEstudios') and rsHayPlanEstudios.recordCount GT 0>#rsHayPlanEstudios.recordCount#<cfelse>0</cfif>">			
	</cfif>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
		  <td class="tituloMantenimiento" colspan="3" align="center">
		  	<font size="3">
				<cfif modo eq "ALTA">
					Nueva Carrera
					  <cfelse>
					Modificar Carrera
				</cfif></font></td>
		</tr>
      <tr> 
        <td align="right" class="fileLabel">#session.parametros.Facultad#:</td>
        <td class="fileLabel">
			<cfif isdefined("rsEscuela")>
				#rsEscuela.ESfacultad#
			</cfif>
		</td>
        <td align="right" rowspan="2">
			<cf_sifayuda width="650" height="450" name="imgAyuda" Tip="false">
		</td>
      </tr>
      <tr> 
        <td align="right" class="fileLabel">#session.parametros.Escuela#:</td>
        <td class="fileLabel">
			<cfif isdefined("rsEscuela")>
				#rsEscuela.ESescuela#
			</cfif>
		</td>
      </tr>
		<tr>
          <td align="right" class="fileLabel"> C&oacute;digo: </td>
          <td colspan="2" align="left"><input name="CARcodificacion" align="left" type="text" id="CARcodificacion" size="15" maxlength="15" value="<cfif modo NEQ "ALTA">#rsForm.CARcodificacion#</cfif>" onfocus="javascript: this.select();">
          </td>
	  </tr>
		<tr> 
		  <td align="right" valign="baseline" class="fileLabel">Nombre: </td>
		  <td colspan="2" valign="baseline"><input name="CARnombre" type="text" id="CARnombre" onfocus="javascript:this.select();" value="<cfif modo neq 'ALTA'>#rsForm.CARnombre#</cfif>" size="50" maxlength="50"></td>
		</tr>
		<tr> 
		  <td align="center" colspan="3">
		  	<cfset mensajeDelete = "¿Desea Eliminar esta Carrera?">
		  	<cfinclude template="../../portlets/pBotones.cfm">
			<cfif modo NEQ "ALTA">
			  <input type="submit" name="btnNuevoPlan" value="Nuevo Plan de Estudios" onClick="javascript: deshabilitarValidacion();">
			</cfif>
		  </td>
		</tr>
	  </table>
</form>
</cfoutput>	  

<script language="JavaScript">

//---------------------------------------------------------------------------------------		
	function deshabilitarValidacion() {
		objForm.CARnombre.required = false;
		objForm.CARcodificacion.required = false;
	}
//---------------------------------------------------------------------------------------		
	function habilitarValidacion() {
		objForm.CARnombre.required = true;
		objForm.CARcodificacion.required = true;
	}
//---------------------------------------------------------------------------------------	
	// Se aplica la descripcion del Concepto 
	function __isTieneDependencias() {
		if(btnSelected("Baja", this.obj.form)) {
			// Valida que no tenga dependencias.
			var msg = "";
			if (new Number(this.obj.form.HayPlanEstudios.value) > 0) {
				msg = msg + "Planes de Estudio"
			}
			if (msg != ""){
				this.error = "Usted no puede eliminar La carrera '" + this.obj.form.CARnombre.value + "' porque éste tiene asociado: " + msg + ".";
				this.obj.form.CARnombre.focus();
			}
		}
	}	
//---------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
//---------------------------------------------------------------------------------------
	qFormAPI.errorColor = "#FFFFCC";
	_addValidator("isTieneDependencias", __isTieneDependencias);
	objForm = new qForm("formCarreras");
//---------------------------------------------------------------------------------------
	objForm.CARnombre.required = true;
	objForm.CARnombre.description = "Nombre";
	objForm.CARcodificacion.required = true;
	objForm.CARcodificacion.description = "Codificación";
	<cfif modo NEQ "ALTA">
		objForm.CARnombre.validateTieneDependencias();
	</cfif>	
</script>