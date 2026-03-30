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
		select RHPEid, RHPEcodigo, RHPEdescripcion, ts_rversion
		from RHPuestosExternos
		where RHPEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPEid#">
	</cfquery>
</cfif>

<!--- registros existentes --->
<cfquery name="rsCodigos" datasource="#session.DSN#">
	select rtrim(RHPEcodigo) as RHPEcodigo
	from RHPuestosExternos
</cfquery>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElCodigoDePuestoExternoYaExiste"
	Default="El Código de Puesto Externo ya existe"
	returnvariable="MSG_ElCodigoDePuestoExternoYaExiste"/>

<!--- Javascript --->
<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
	function codigos(obj){
		if (obj.value != "") {
			var dato    = obj.value;
			var temp    = new String();
	
			<cfloop query="rsCodigos">
				temp = '<cfoutput>#rsCodigos.RHPEcodigo#</cfoutput>';
				if (dato == temp){
					alert('<cfoutput>#MSG_ElCodigoDePuestoExternoYaExiste#</cfoutput>.');
					obj.value = "";
					obj.focus();
					return false;
				}
			</cfloop>
		}	
		return true;
	}

	function validar(f){
		f.obj.RHPEcodigo.disabled = false;
		return true;
	}

	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

</script>

<cfoutput>
	<form name="form1" method="post" action="PuestosExt-sql.cfm" onSubmit="return validar(this);">
	<cfif modo EQ "CAMBIO">
		<input type="hidden" name="RHPEid" value="#rsForm.RHPEid#">
	</cfif>
	  <table width="100%" border="0" cellspacing="0" cellpadding="2">
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr> 
		  <td class="fileLabel" align="right" nowrap><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate>:&nbsp;</td>
		  <td>
			<input name="RHPEcodigo" type="text" value="<cfif modo neq 'ALTA'>#trim(rsForm.RHPEcodigo)#</cfif>" tabindex="1" size="10" maxlength="10" <cfif modo neq 'ALTA'>onchange="javascript:codigos(this);"<cfelse>onblur="javascript:codigos(this);"</cfif> onfocus="javascript:this.select();" >
		  </td>
		</tr>
		<tr> 
		  <td class="fileLabel" align="right" nowrap><cf_translate key="LB_Decripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate>:&nbsp;</td>
		  <td><input name="RHPEdescripcion" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#rsForm.RHPEdescripcion#</cfif>" size="53" maxlength="80" onFocus="javascript:this.select();" ></td>
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
		<tr>
			<td>
			<input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>">
			</td>
		</tr>
	  </table>
	</form>
</cfoutput>
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

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.RHPEcodigo.required = true;
	objForm.RHPEcodigo.description="<cfoutput>#MSG_Codigo#</cfoutput>";
	objForm.RHPEdescripcion.required = true;
	objForm.RHPEdescripcion.description="<cfoutput>#MSG_Descripcion#</cfoutput>";
	function deshabilitarValidacion(){
		objForm.RHPEcodigo.required = false;
		objForm.RHPEdescripcion.required = false;
	}
	document.form1.RHPEcodigo.focus();
</script>