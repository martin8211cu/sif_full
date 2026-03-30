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
		select EDPid, EDPcodigo, EDPdescripcion, ts_rversion
		from EDPosiciones
		where EDPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDPid#">
	</cfquery>
</cfif>


<!--- Javascript --->
<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
	function validar(f){
		f.obj.EDPcodigo.disabled = false;
		return true;
	}

	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

<form name="form1" method="post" action="Posiciones-SQL.cfm" onSubmit="return validar(this);"><!---  --->
<cfif isdefined("url.popup") and url.popup eq "s">
<input type="hidden" name="popup" value="s" />

</cfif>
  <cfoutput> 
	  <table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr> 
		  <td align="right"><cf_translate key="LB_Codigo" XmlFile="/rh/ExpDeportivo/generales.xml">C&oacute;digo</cf_translate>:&nbsp;</td>
		  <td>
			<input name="TEcodigo" type="text" value="<cfif modo neq 'ALTA'>#trim(rsForm.EDPcodigo)#</cfif>" tabindex="1" size="5" maxlength="5"  onfocus="javascript:this.select();" >
		  </td>
		</tr>
		<tr> 
		  <td align="right" nowrap><cf_translate key="LB_Decripcion" XmlFile="/rh/ExpDeportivo/generales.xml">Descripci&oacute;n</cf_translate>:&nbsp;</td>
		  <td><input name="TEdescripcion" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#rsForm.EDPdescripcion#</cfif>" size="60" maxlength="80" onFocus="javascript:this.select();" ></td>
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
	 
		<input type="hidden" name="TEDPd" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.EDPid#</cfoutput></cfif>">
	 
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
		document.form1.EDPdescripcion.focus();
	<cfelse>
		document.form1.EDPcodigo.focus();
	</cfif>

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	<cfoutput>
		objForm.EDPcodigo.required = true;
		objForm.EDPcodigo.description="#MSG_Codigo#";
		objForm.EDPdescripcion.required = true;
		objForm.EDPdescripcion.description="#MSG_Descripcion#";
	</cfoutput>

	function deshabilitarValidacion(){
		objForm.EDPcodigo.required = false;
		objForm.EDPdescripcion.required = false;
	}
	
</script>















































































































































































































































































