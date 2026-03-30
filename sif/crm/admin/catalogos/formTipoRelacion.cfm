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
		select convert(varchar,CRMTRid) as CRMTRid,
			CRMTRcodigo,
			CRMTRdescripcion,
			ts_rversion
		from CRMTipoRelacion
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
			and CRMTRid=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.CRMTRid#">
	</cfquery>
</cfif>

<form name="formTipoRelacion" method="post" action="SQLtipoRelacion.cfm" onSubmit="return validar(this);">
	<cfoutput>

	<cfif modo NEQ 'ALTA'>
		<cfset ts = "">	
		<cfif modo neq "ALTA">
			<cfinvoke 
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
			</cfinvoke>
		</cfif>
		<input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'>#ts#</cfif>">	
		<input type="hidden" name="CRMTRid" value="<cfif modo NEQ 'ALTA'>#rsForm.CRMTRid#</cfif>">	
	</cfif>
	
	<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr> 
		  <td colspan="2" class="tituloAlterno">
		  	<cfif modo neq 'ALTA'>
				Modificaci&oacute;n de Tipo de Relaci&oacute;n
			<cfelse>
				Nuevo de Tipo de Relaci&oacute;n				
			</cfif>		  
		  </td>
		</tr>
		<tr> 
		  <td width="35%">&nbsp;</td>
		  <td>&nbsp;</td>
		</tr>
		<tr> 
		  <td><div align="right">C&oacute;digo:&nbsp;</div></td>
		  <td>
			<input name="CRMTRcodigo" type="text" id="CRMTRcodigo" tabindex="1" onfocus="javascript:this.select();" value="<cfif modo neq 'ALTA'>#Trim(rsForm.CRMTRcodigo)#</cfif>" size="10" maxlength="10" alt="El C&oacute;digo del tipo de relaci&oacute;n" <cfif modo neq 'ALTA'>disabled</cfif> >
		  </td>
		</tr>
		<tr> 
		  <td><div align="right">Descripci&oacute;n:&nbsp;</div></td>
		  <td><input name="CRMTRdescripcion" id="CRMTRdescripcion" type="text" tabindex="2" value="<cfif modo neq 'ALTA'>#rsForm.CRMTRdescripcion#</cfif>" size="70" maxlength="80" onFocus="javascript:this.select();" alt="La Descripci&oacute;n" ></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<cfinclude template="../../portlets/pBotones.cfm">	
			</td>
		</tr>
	</table>  
  </cfoutput>
</form>


<!--- Javascript --->
<!--- <script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js"></script> --->
<SCRIPT SRC="../../../js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
	function validar(f){
		f.obj.CRMTRcodigo.disabled = false;
		return true;
	}
	
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formTipoRelacion");

	objForm.CRMTRcodigo.required = true;
	objForm.CRMTRcodigo.description="Código del Tipo de Relación";
	objForm.CRMTRdescripcion.required = true;
	objForm.CRMTRdescripcion.description="Descripción";
	
	function deshabilitarValidacion(){
		objForm.CRMTRcodigo.required = false;
		objForm.CRMTRdescripcion.required = false;
	}
</script>