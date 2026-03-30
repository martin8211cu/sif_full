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
		select convert(varchar,CRMTEVid) as CRMTEVid,
			CRMTEVcodigo,
			CRMTEVdescripcion,
			CRMTEVseguimiento,
			CRMTEVpublico,
			ts_rversion
		from CRMTipoEvento
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
			and CRMTEVid=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.CRMTEVid#">
	</cfquery>
</cfif>
<cf_templatecss>


<form name="formTipoEvento" method="post" action="SQLtipoEvento.cfm" onSubmit="return validar(this);">
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
		<input type="hidden" name="CRMTEVid" value="<cfif modo NEQ 'ALTA'>#rsForm.CRMTEVid#</cfif>">	
	</cfif>
	
	<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr> 
		  <td colspan="2" class="tituloAlterno">
		  	<cfif modo neq 'ALTA'>
				Modificaci&oacute;n de Tipo de Evento
			<cfelse>
				Nuevo de Tipo de Evento				
			</cfif>
		  </td>
		</tr>	
		<tr> 
		  <td width="30%">&nbsp;</td>
		  <td>&nbsp;</td>
		</tr>

		<tr> 
		  <td><div align="right">C&oacute;digo:&nbsp;</div></td>
		  <td>
			<input name="CRMTEVcodigo" type="text" id="CRMTEVcodigo" tabindex="1" onfocus="javascript:this.select();" value="<cfif modo neq 'ALTA'>#Trim(rsForm.CRMTEVcodigo)#</cfif>" size="10" maxlength="10" alt="El C&oacute;digo del tipo de evento" <cfif modo neq 'ALTA'>disabled</cfif> >
		  </td>
		</tr>

		<tr> 
		  <td><div align="right">Descripci&oacute;n:&nbsp;</div></td>
		  <td><input name="CRMTEVdescripcion" id="CRMTEVdescripcion" type="text" tabindex="2" value="<cfif modo neq 'ALTA'>#rsForm.CRMTEVdescripcion#</cfif>" size="60" maxlength="80" onFocus="javascript:this.select();" alt="La Descripci&oacute;n" ></td>
		</tr>

		<tr> 
		  <td></td>
		  <td><input type="checkbox" value="chk" <cfif modo neq 'ALTA' and rsForm.CRMTEVseguimiento eq '1' >checked</cfif> name="CRMTEVseguimiento">Requiere seguimiento</td>
		</tr>

		<tr> 
		  <td></td>
		  <td><input type="checkbox" value="chk" <cfif modo neq 'ALTA' and rsForm.CRMTEVpublico eq '1' >checked</cfif> name="CRMTEVpublico">Evento Público</td>
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
		f.obj.CRMTEVcodigo.disabled = false;
		return true;
	}
	
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formTipoEvento");

	objForm.CRMTEVcodigo.required = true;
	objForm.CRMTEVcodigo.description="Código del Tipo de Evento";
	objForm.CRMTEVdescripcion.required = true;
	objForm.CRMTEVdescripcion.description="Descripción";
	
	function deshabilitarValidacion(){
		objForm.CRMTEVcodigo.required = false;
		objForm.CRMTEVdescripcion.required = false;
	}
</script>