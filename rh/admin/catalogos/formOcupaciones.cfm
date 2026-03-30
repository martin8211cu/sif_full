<!-- Establecimiento del modo -->
<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<!--- Consultas --->
<cfif modo neq 'ALTA'>
	<!--- Form --->
	 <cfquery name="rsForm" datasource="#session.DSN#">
		select RHOcodigo, RHOdescripcion, ts_rversion
		from RHOcupaciones
		where RHOcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHOcodigo#">
	</cfquery>
</cfif>

<!--- registros existentes --->
<cfquery name="rsCodigos" datasource="#session.DSN#">
	select rtrim(RHOcodigo) as RHOcodigo
	from RHOcupaciones
</cfquery>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElCodigoDeOcupacionYaExiste"
	Default="El Código de Ocupación ya existe"
	returnvariable="MSG_ElCodigoDeOcupacionYaExiste"/>

<!--- Javascript --->
<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
	function codigos(obj){
		if (obj.value != "") {
			var dato    = obj.value;
			var temp    = new String();
	
			<cfloop query="rsCodigos">
				temp = '<cfoutput>#rsCodigos.RHOcodigo#</cfoutput>';
				if (dato == temp){
					alert('<cfoutput>#MSG_ElCodigoDeOcupacionYaExiste#</cfoutput>.');
					obj.value = "";
					obj.focus();
					return false;
				}
			</cfloop>
		}	
		return true;
	}

	function validar(f){
		f.obj.RHOcodigo.disabled = false;
		return true;
	}

	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>


<form name="form1" method="post" action="SQLOcupaciones.cfm" onSubmit="return validar(this);">
  <cfoutput>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr><td colspan="2">&nbsp;</td></tr>
    <tr> 
      <td align="right"><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate>:&nbsp;</td>
      <td>
	  	<input name="RHOcodigo" type="text" value="<cfif modo neq 'ALTA'>#trim(rsForm.RHOcodigo)#</cfif>" <cfif modo neq 'ALTA'>disabled</cfif> tabindex="1" size="10" maxlength="10" onblur="javascript:codigos(this);" onfocus="javascript:this.select();" >
	  </td>
    </tr>
    <tr> 
      <td align="right" nowrap><cf_translate key="LB_Decripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate>:&nbsp;</td>
      <td><input name="RHOdescripcion" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#rsForm.RHOdescripcion#</cfif>" size="60" maxlength="80" onFocus="javascript:this.select();" ></td>
    </tr>

	<tr><td>&nbsp;</td></tr>
	<tr>
		<td colspan="2" align="center">
			<cfset tabindex="1">
			<cfinclude template="/rh/portlets/pBotones.cfm">
		</td>
	</tr>

	<cfset ts = "">	
	<cfif modo neq "ALTA">
		<cfinvoke 
			component="sif.Componentes.DButils"
			method="toTimeStamp"
			returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
		</cfinvoke>
	</cfif>
	<tr><td><input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>"></td></tr>

  </table>  
  </cfoutput>
</form>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Codigo"
	Default="Código"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_Codigo"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Descripcion"
	Default="Descripción"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_Descripcion"/>

<script language="JavaScript1.2" type="text/javascript">
	<cfif modo NEQ 'ALTA'>
	document.form1.RHOdescripcion.focus();
	<cfelse>
	document.form1.RHOcodigo.focus();
	</cfif>

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
<cfoutput>

	objForm.RHOcodigo.required = true;
	objForm.RHOcodigo.description="#MSG_Codigo#";
	objForm.RHOdescripcion.required = true;
	objForm.RHOdescripcion.description="#MSG_Descripcion#";
</cfoutput>

	function deshabilitarValidacion(){
		objForm.RHOcodigo.required = false;
		objForm.RHOdescripcion.required = false;
	}
	
</script>