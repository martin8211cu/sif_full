<!-- Establecimiento del modo -->
<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("form.modo")>
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
		select NPcodigo, NPdescripcion, ts_rversion
		from NProfesional
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and NPcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NPcodigo#">
	</cfquery>
</cfif>

<cfquery name="rsCodigos" datasource="#session.DSN#">
	select NPcodigo 
	from NProfesional
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif modo neq 'ALTA'>
		and NPcodigo!=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NPcodigo#">
	</cfif>
</cfquery>

<!--- Javascript --->
<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->

	function trim(dato) {
		dato = dato.replace(/^\s+|\s+$/g, '');
		return dato;
	}

	function validar(){
		document.form1.NPcodigo.disabled = false;
		return true;
	}

</script>

<form name="form1" method="post" action="SQLNProfesional.cfm" onSubmit="return validar();" >
	<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr><td>&nbsp;</td></tr>
		
		<tr> 
			<td align="right"><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate>:&nbsp;</td>
			<td>
				<input name="NPcodigo" type="text" tabindex="1" <cfif modo neq 'ALTA'>disabled</cfif>  value="<cfif modo neq 'ALTA'>#trim(rsForm.NPcodigo)#</cfif>" size="7" maxlength="5" onFocus="javascript:this.select();" onblur="javascript:existe(this);" >
			</td>
		</tr>
		
		<tr> 
			<td align="right"><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate>:&nbsp;</td>
			<td><input name="NPdescripcion" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#rsForm.NPdescripcion#</cfif>" size="70" maxlength="80" onFocus="javascript:this.select();" ></td>
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
		
		<tr><td><input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'>#ts#</cfif>"></td></tr>
		
	</table>  
	</cfoutput>
</form>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElCodigoDeNivelProfesionalYaExiste"
	Default="El Código de Nivel Profesional ya existe"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_ElCodigoDeNivelProfesionalYaExiste"/>
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
	
	function existe(){
		objForm.NPcodigo.obj.value = trim(objForm.NPcodigo.obj.value);
		if (objForm.NPcodigo.obj.value != "") {
			var empresa = <cfoutput>#session.Ecodigo#</cfoutput>
			var dato    = trim(objForm.NPcodigo.obj.value) + "|" + empresa;
			var temp    = new String();
	
			<cfloop query="rsCodigos">
				temp = '<cfoutput>#ucase(trim(rsCodigos.NPcodigo))#</cfoutput>' + "|" + empresa
				if (dato.toUpperCase() == temp){
					if (this.value){
						this.error = '<cfoutput>#MSG_ElCodigoDeNivelProfesionalYaExiste#</cfoutput>.';
					}
					else{
						alert('<cfoutput>#MSG_ElCodigoDeNivelProfesionalYaExiste#</cfoutput>');
						objForm.NPcodigo.obj.focus();
					}
					objForm.NPcodigo.obj.value = "";
				}
			</cfloop>
		}	
	}
	_addValidator("isExiste", existe);
<cfoutput>
	objForm.NPcodigo.required = true;
	objForm.NPcodigo.description="#MSG_Codigo#";
	objForm.NPdescripcion.required = true;
	objForm.NPdescripcion.description="#MSG_Descripcion#";
</cfoutput>	
	objForm.NPcodigo.validateExiste();
	objForm.NPcodigo.Validate = true;
	
	function deshabilitarValidacion(){
		objForm.NPcodigo.required = false;
		objForm.NPdescripcion.required = false;
	}
	
	function limpiar(){
		objForm.NPcodigo.obj.value = "";
		objForm.NPdescripcion.obj.value = "";


	}
	
</script>