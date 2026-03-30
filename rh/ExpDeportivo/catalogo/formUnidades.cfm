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
		select EDUid,EDUcodigo,EDUdescripcion, ts_rversion
		from EDUnidad
		where EDUid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDUid#">
	</cfquery>
</cfif>


<!--- Javascript --->
<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
	function validar(f){
		f.obj.EDUcodigo.disabled = false;
		return true;
	}

	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

<!--- <cfform  title="Crear nuevo parche" id="form1" name="form1" method="post" 
	onSubmit="return validar(this);" action="SQLPosiciones.cfm" format="flash"> --->


<form name="form1" method="post" action="SQLUnidades.cfm" onSubmit="return validar(this);"><!---  --->
  <cfoutput>
	  <table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr> 
		  <td align="right"><cf_translate key="LB_Codigo" XmlFile="/rh/ExpDeportivo/generales.xml">C&oacute;digo</cf_translate>:&nbsp;</td>
		  <td>
			<input name="EDUcodigo" type="text" value="<cfif modo neq 'ALTA'>#trim(rsForm.EDUcodigo)#</cfif>" tabindex="1" size="5" maxlength="5"  onfocus="javascript:this.select();" >
		  </td>
		</tr>
		<tr> 
		  <td align="right" nowrap><cf_translate key="LB_Decripcion" XmlFile="/rh/ExpDeportivo/generales.xml">Descripci&oacute;n</cf_translate>:&nbsp;</td>
		  <td><input name="EDUdescripcion" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#rsForm.EDUdescripcion#</cfif>" size="60" maxlength="80" onFocus="javascript:this.select();" ></td>
		</tr>
		 <!--- <tr> 
		 <td align="right" nowrap><cf_translate key="LB_Equivalencia" XmlFile="/rh/ExpDeportivo/generales.xml">Equivalencia</cf_translate>:&nbsp;</td> --->
		  <!--- <td><input 
																		name="EDUequivalencia" 
																		type="text" 
																		id="EDUequivalencia"  
																		tabindex="1"
																		style="text-align: right; font-size:10px" 
																		onBlur="javascript: fm(this,0);"  
																		onFocus="javascript:this.value=qf(this); this.select();"  
																		onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" 
																		value="<cfif isdefined("rsForm.EDUequivalencia") and len(trim(rsForm.EDUequivalencia))>#rsForm.EDUequivalencia#</cfif>">
		  </td>
		</tr> --->
	
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
	  <cfif modo neq "ALTA">
		<input type="hidden" name="EDUid" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.EDUid#</cfoutput></cfif>">
	  </cfif>
  </cfoutput>
  <cfif isdefined("url.popup") and url.popup eq "s">
<input type="hidden" name="popup" value="s" />

</cfif>
 </form> 
<!---</cfform>--->
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
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Equivalencias"
	Default="Equivalencias"
	XmlFile="/rh/ExpDeportivo/generales.xml"
	returnvariable="MSG_Equivalencias"/>

<script language="JavaScript1.2" type="text/javascript">
	<cfif modo NEQ 'ALTA'>
		document.form1.EDUdescripcion.focus();
	<cfelse>
		document.form1.EDUcodigo.focus();
	</cfif>

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	<cfoutput>
		objForm.EDUcodigo.required = true;
		objForm.EDUcodigo.description="#MSG_Codigo#";
		objForm.EDUdescripcion.required = true;
		objForm.EDUdescripcion.description="#MSG_Descripcion#";
	</cfoutput>

	function deshabilitarValidacion(){
		objForm.EDUcodigo.required = false;
		objForm.EDUdescripcion.required = false;
	}
	
</script>