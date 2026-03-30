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
		select TEid,TEcodigo,TEdescripcion, ts_rversion
		from DivisionEquipo
		where TEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TEid#">
	</cfquery>
</cfif>


<!--- Javascript --->
<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
	function validar(f){
		f.obj.TEcodigo.disabled = false;
		return true;
	}

	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

<form name="form1" method="post" action="DivisionEquipo-SQL.cfm" onSubmit="return validar(this);"><!---  --->
<cfif isdefined("url.popup") and url.popup eq "s">
<input type="hidden" name="popup" value="s" />

</cfif>
  <cfoutput> 
	  <table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr> 
		  <td align="right"><cf_translate key="LB_Codigo" XmlFile="/rh/ExpDeportivo/generales.xml">C&oacute;digo</cf_translate>:&nbsp;</td>
		  <td>
			<input name="TEcodigo" type="text" value="<cfif modo neq 'ALTA'>#trim(rsForm.TEcodigo)#</cfif>" tabindex="1" size="5" maxlength="5"  onfocus="javascript:this.select();" >
		  </td>
		</tr>
		<tr> 
		  <td align="right" nowrap><cf_translate key="LB_Decripcion" XmlFile="/rh/ExpDeportivo/generales.xml">Descripci&oacute;n</cf_translate>:&nbsp;</td>
		  <td><input name="TEdescripcion" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#rsForm.TEdescripcion#</cfif>" size="60" maxlength="80" onFocus="javascript:this.select();" ></td>
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
	 
		<input type="hidden" name="TEid" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.TEid#</cfoutput></cfif>">
	 
  </cfoutput>
 </form> 

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Codigo"
	Default="Código"
	XmlFile="/rh/ExpDeportivo/generales.xml"
	returnvariable="MSG_Codigo"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Descripcion"
	Default="Descripción"
	XmlFile="/rh/ExpDeportivo/generales.xml"
	returnvariable="MSG_Descripcion"/>

<script language="JavaScript1.2" type="text/javascript">
	<cfif modo NEQ 'ALTA'>
		document.form1.TEdescripcion.focus();
	<cfelse>
		document.form1.TEcodigo.focus();
	</cfif>

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	<cfoutput>
		objForm.TEcodigo.required = true;
		objForm.TEcodigo.description="#MSG_Codigo#";
		objForm.TEdescripcion.required = true;
		objForm.TEdescripcion.description="#MSG_Descripcion#";
	</cfoutput>

	function deshabilitarValidacion(){
		objForm.TEcodigo.required = false;
		objForm.TEdescripcion.required = false;
	}
	
</script>















































































































































































































































































