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

<cfif isdefined("Form.TEid") and Len(Trim(Form.TEid))>
	<cfset modo = "CAMBIO">
</cfif>

<!--- Consultas --->
<cfif modo NEQ "ALTA">
	<!--- Form --->
	<cfquery name="rsForm" datasource="#session.DSN#">
		select TEid, TEcodigo, 
			CEcodigo, TEdescripcion, 
			Usucodigo, Ulocalizacion, TEfecha, ts_rversion
		from TipoExpediente
		where TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">
		  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	</cfquery>

</cfif>

<!--- registros existentes --->
<cfquery name="rsCodigos" datasource="#session.DSN#">
	select rtrim(TEcodigo) as TEcodigo
	from TipoExpediente
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	<cfif modo NEQ 'ALTA'>
		and TEid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">
	</cfif>
</cfquery>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElCodigoDeTipoDeExpedienteYaExiste"
	Default="El Código de Tipo de Expediente ya existe"
	returnvariable="MSG_ElCodigoDeTipoDeExpedienteYaExiste"/>

<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<SCRIPT src="/cfmx/rh/js/utilesMonto.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">

	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->

	function codigos(obj){
		if (obj.value != "") {
			var empresa = <cfoutput>#Session.CEcodigo#</cfoutput>
			var dato    = trim(obj.value) + "|" + empresa;
			var temp    = new String();
	
			<cfloop query="rsCodigos">
				temp = '<cfoutput>#Trim(rsCodigos.TEcodigo)#</cfoutput>' + "|" + empresa
				if (dato == temp){
					alert('<cfoutput>#MSG_ElCodigoDeTipoDeExpedienteYaExiste#</cfoutput>.');
					obj.value = "";
					obj.focus();
					return false;
				}
			</cfloop>
		}	
		return true;
	}

	function validar(f){
		f.obj.TEcodigo.disabled = false;
		return true;
	}
	
	function deshabilitarValidacion() {
		objForm.TEcodigo.required = false;
		objForm.TEdescripcion.required = false;		
	}
	
	function AccionesTipo() {
		document.form1.action = 'AccionesTipoExpediente.cfm';
	}

	function FormatosTipo() {
		document.form1.action = 'FormatosPrincipal.cfm';
	}
	
	function ConceptosTipo() {
		document.form1.action = 'ConceptosExp-lista.cfm';
	}
	
	function UsuariosTipo() {
		document.form1.action = 'UsuariosExp-lista.cfm';
	}
	
</script>

<form name="form1" method="post" action="SQLTiposExpediente.cfm" 
onSubmit="
	if (this.botonSel.value != 'Baja' 
	&& this.botonSel.value != 'Nuevo' 
	&& this.botonSel.value != 'btnAcciones' 
	&& this.botonSel.value != 'btnUsuarios'
	&& this.botonSel.value != 'btnFormatos' 
	&& this.botonSel.value != 'btnConceptos'
	) return validar(this);">
<cfoutput>
	<table width="100%" border="0" cellspacing="1" cellpadding="1">
	  <tr>
	  	<td>&nbsp;</td>
	  </tr>	  
	  <tr>
		<td width="31%" align="right"><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate>:</td>
		<td width="69%">
			<input type="text" name="TEcodigo" <cfif modo NEQ 'ALTA'> readonly </cfif>  size="11" maxlength="10" tabindex="1"
				value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.TEcodigo#</cfoutput></cfif>" 
				onblur="javascript:codigos(this);" onfocus="javascript:this.select();">
			<input type="hidden" name="TEid" value="<cfif modo NEQ 'ALTA'>#rsForm.TEid#</cfif>" >
		</td>
	  </tr>
	  <tr>
	    <td align="right" nowrap><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate>:</td>
	    <td>
			<input type="text" name="TEdescripcion" size="80" maxlength="80" tabindex="1"
			value="<cfif modo NEQ 'ALTA'>#rsForm.TEdescripcion#</cfif>" onFocus="javascript:this.select();" ></td>
      </tr>
	  
	  <tr>
		<td colspan="2">
			<div align="center">
				<cfset tabindex="1">
				<cfinclude template="/rh/portlets/pBotones.cfm">
			</div>
		</td>
	  </tr>
		
		<!--- ts_rversion --->
		<cfset ts = "">	
		<cfif modo neq "ALTA">
			<cfinvoke 
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
			</cfinvoke>
		</cfif>
		<input type="hidden" name="TEfecha" value="<cfif modo NEQ 'ALTA'><cfoutput>#LSDateFormat(rsForm.TEfecha,'DD/MM/YYYY')#</cfoutput></cfif>">
	  	<input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>">

	</table>
</cfoutput>
</form>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Descripcion"
	Default="Descripción"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Codigo"
	Default="Código"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_Codigo"/>
<script language="JavaScript1.2" type="text/javascript">

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
<cfoutput>
	objForm.TEcodigo.required = true;
	objForm.TEcodigo.description="#MSG_Codigo#";
	objForm.TEdescripcion.required = true;
	objForm.TEdescripcion.description="#MSG_Descripcion#";
</cfoutput>
</script>