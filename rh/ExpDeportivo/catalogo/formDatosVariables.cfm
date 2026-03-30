<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="CMB_Seleccionar"
Default="Seleccionar"
XmlFile="/rh/ExpDeportivo/generales.xml"
returnvariable="CMB_Seleccionar"/>

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
<!--- <cf_dump var="#form.modo#"> --->
<!--- Consultas --->
<cfquery name="rsUnidades" datasource="#session.DSN#">
	select EDUid,EDUcodigo ,EDUdescripcion from  EDUnidades
	order by EDUcodigo
</cfquery>


<cfif modo neq 'ALTA'>
	<!--- Form --->
	 <cfquery name="rsForm" datasource="#session.DSN#">
		select EDUid,EDDid,EDDcodigo,EDDdescripcion, ts_rversion, EDDtipopintado
		from EDDatosVariables
		where EDDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDDid#">
	</cfquery>
</cfif>


<!--- Javascript --->
<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
	function validar(f){
		f.obj.EDDcodigo.disabled = false;
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


<form name="form1" method="post" action="SQLDatosVariables.cfm" onSubmit="return validar(this);"><!---  --->
  <cfoutput>
  <tr>
			
	  <table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr><td>&nbsp;</td></tr>
		<tr>
		  <td nowrap>&nbsp;<cf_translate key="LB_Categoria" XmlFile="/rh/ExpDeportivo/generales.xml">Categor&iacute;a</cf_translate></td>
		
		  <td nowrap><cf_translate key="LB_Codigo" XmlFile="/rh/ExpDeportivo/generales.xml">C&oacute;digo</cf_translate></td>
		  
		  <td nowrap><cf_translate key="LB_Descripcion" XmlFile="/rh/ExpDeportivo/generales.xml">Descripci&oacute;n</cf_translate>&nbsp;</td>
		  <td nowrap>	<cf_translate key="LB_Tipo" XmlFile="/rh/generales.xml">Tipo</cf_translate>&nbsp;</td>
		  </tr>
		  <tr>
		  		 
		  <td nowrap>&nbsp;&nbsp;<select name="categoria" id="categoria"><option value=""><cfoutput>#CMB_Seleccionar#</cfoutput></option><option value="1"><cfoutput>Expediente Medico</cfoutput></option><option value="2"><cfoutput>Expediente Fisico</cfoutput></option><option value="3"><cfoutput>Otro</cfoutput></option></select></td>
		 <td nowrap><input name="EDDcodigo" type="text" value="<cfif modo neq 'ALTA'>#trim(rsForm.EDDcodigo)#</cfif>"  tabindex="1" size="5" maxlength="5"  onfocus="javascript:this.select();" ></td>
		  
		  <td nowrap><input name="EDDdescripcion" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#rsForm.EDDdescripcion#</cfif>" size="60" maxlength="80" onFocus="javascript:this.select();" ></td>
		 
		 <td><select name="Tipo" id="Tipo">
          <option value="">#CMB_Seleccionar#</option>
          <option value="1"<cfif modo neq 'ALTA' and rsForm.EDDtipopintado eq 1 >selected</cfif>>
            <cf_translate key="CMB_SeleccionUnica" XmlFile="/rh/generales.xml">Selecci&oacute;n &Uacute;nica</cf_translate>
          </option>
          <option value="2"<cfif modo neq 'ALTA' and rsForm.EDDtipopintado eq 2 >selected</cfif>>
            <cf_translate key="CMB_SeleccionMultiple" XmlFile="/rh/generales.xml">Selecci&oacute;n M&uacute;ltiple</cf_translate>
            </option>
          <option value="3"<cfif modo neq 'ALTA' and rsForm.EDDtipopintado eq 3 >selected</cfif>>
            <cf_translate key="CMB_Valorizacion" XmlFile="/rh/generales.xml">Valorizaci&oacute;n</cf_translate>
            </option>
          <option value="4"<cfif modo neq 'ALTA' and rsForm.EDDtipopintado eq 4 >selected</cfif>>
            <cf_translate key="CMB_Desarrollo" XmlFile="/rh/generales.xml">Desarrollo</cf_translate>
            </option>
          <option value="5"<cfif modo neq 'ALTA' and rsForm.EDDtipopintado eq 5 >selected</cfif>>
            <cf_translate key="CMB_Etiqueta" XmlFile="/rh/generales.xml">Etiqueta</cf_translate>
            </option>
        </select></td> 
		</tr>
		 <tr><td>&nbsp;</td></tr>
		 <tr>
		  <td nowrap>&nbsp;<cf_translate key="LB_Unidades" XmlFile="/rh/ExpDeportivo/generales.xml">Unidades</cf_translate>&nbsp;</td>
		  </tr>
		  <tr>
		  <td>&nbsp; 
		  	<cf_EDUnidades>
		  </td>
		  	  
		</tr> 
		<tr><td>&nbsp; </td></tr>
		<tr> 
				<td colspan="6" align="center"> 
				<cfset tabindex="1"> 
				<cfinclude template="/rh/portlets/pBotones.cfm">			</td> 
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
		<input type="hidden" name="EDDid" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.EDDid#</cfoutput></cfif>">
	  </cfif>
  </cfoutput>
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
	

<script language="JavaScript1.2" type="text/javascript">
	<cfif modo NEQ 'ALTA'>
		document.form1.EDDdescripcion.focus();
	<cfelse>
		document.form1.EDDcodigo.focus();
	</cfif>

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	<cfoutput>
		objForm.EDDcodigo.required = true;
		objForm.EDDcodigo.description="#MSG_Codigo#";
		objForm.EDDdescripcion.required = true;
		objForm.EDDdescripcion.description="#MSG_Descripcion#";
		
	</cfoutput>

	function deshabilitarValidacion(){
		objForm.EDDcodigo.required = false;
		objForm.EDDdescripcion.required = false;
		
	}
	
</script>





































































































































































































































































































































































































