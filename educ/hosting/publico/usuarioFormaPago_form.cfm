 <!--- Establecimiento del modo --->
<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("form.modo")>
		<cfset modo="ALTA">
	<cfelseif #form.modo# EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	<cfif modo EQ "ALTA">
		Nueva Forma de Pago
	<cfelse>
		Modificar Forma de Pago
	</cfif>
</cf_templatearea>
<cf_templatearea name="left">
	<cfinclude template="pMenu.cfm">
</cf_templatearea>
<cf_templatearea name="body">

<!---       Consultas      --->
<cfif modo NEQ 'ALTA'>
	<cfquery name="rsForm" datasource="sdc">
		select convert(varchar,v.VFPcodigo) as VFPcodigo
			, convert(varchar,v.FPcodigo) as FPcodigo
			, v.VFPnombre
			, v.VFPdefault
		from UsuarioFormaPago u, ValorFormaPago v
		where u.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		  and u.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">
		  and u.VFPcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.VFPcodigo#">
		  and v.VFPcodigo = u.VFPcodigo
	</cfquery>
</cfif>

<cfquery name="rsFormaPago" datasource="sdc">
	select convert(varchar,FPcodigo) as FPcodigo
		, FPnombre
	from FormaPago
</cfquery>


<cf_templatecss>
<script language="JavaScript" src="/cfmx/sif/js/qForms/qforms.js">//</script>
<form action="usuarioFormaPago_SQL.cfm" method="post" name="formUsuarioFormaPago" style="margin:0 ">
	<cfif modo NEQ 'ALTA'>
		<input name="VFPcodigo" type="hidden" value="<cfoutput>#form.VFPcodigo#</cfoutput>">
	</cfif>
	<table width="95%" border="0" cellpadding="2" cellspacing="0" align="center">
		<tr> 
		  <td align="right" valign="middle"><strong>Nombre</strong>:&nbsp;</td>
		  <td valign="baseline"><input name="VFPnombre" type="text" id="VFPnombre" onfocus="javascript:this.select();" value="<cfif modo neq 'ALTA'><cfoutput>#rsForm.VFPnombre#</cfoutput></cfif>" size="60" maxlength="60"></td>
		</tr>
		<tr> 
		  <td width="28%" align="right" valign="middle" nowrap><strong>Forma de Pago</strong>:&nbsp;</td>
		  <td width="72%" valign="baseline">	      
		  <select name="FPcodigo" id="FPcodigo">
		    <cfoutput query="rsFormaPago">
		      <option value="#rsFormaPago.FPcodigo#" <cfif modo NEQ 'ALTA' and rsForm.FPcodigo EQ rsFormaPago.FPcodigo> selected</cfif>>#rsFormaPago.FPnombre#</option>
	        </cfoutput>
	      </select></td>
		</tr>
		<tr> 
		  <td width="28%" align="right" valign="middle" nowrap><strong>Usar por defecto</strong>:&nbsp;</td>
		  <td width="72%" valign="baseline"><input name="VFPdefault" type="checkbox" id="VFPdefault" value="1" <cfif modo NEQ 'ALTA' and rsForm.VFPdefault EQ 1> checked</cfif>>	      
		  </td>
		</tr>				
		<tr> 
		  <td colspan="2">&nbsp;</td>
		</tr>				
		<cfif modo NEQ 'ALTA'>
		<tr> 
		  <td colspan="2">
				<cf_web_portlet width="98%" border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Datos de la Forma de Pago">		
					<cfinclude template="valorFormaPagoDatos_form.cfm">
				</cf_web_portlet>
		  </td>
		</tr>				
		<tr> 
		  <td colspan="2">&nbsp;</td>
		</tr>				
		</cfif>
		<tr> 
		  <td colspan="2" align="center">
		  	<cfset mensajeDelete = "¿Desea Eliminar la Forma de Pago ?">
		  	<cfinclude template="/sif/portlets/pBotones.cfm">
			<input type="submit" name="btnLista" value="Ir a lista" onClick="javascript:<cfif modo NEQ 'ALTA'>this.form.VFPcodigo.value='';</cfif>this.form.action='usuarioFormaPago.cfm';deshabilitarValidacion();">
		  </td>
		</tr>				
  </table>
</form>	  
<script language="JavaScript">
//---------------------------------------------------------------------------------------		
	function deshabilitarValidacion() {
		objForm.VFPnombre.required = false;		
		objForm.FPcodigo.required = false;
		if (objForm.FPDcantidad)
			VFPDdeshabilitarValidacion();
	}
//---------------------------------------------------------------------------------------		
	function habilitarValidacion() {
		objForm.VFPnombre.required = true;		
		objForm.FPcodigo.required = true;
		if (objForm.FPDcantidad)
			VFPDhabilitarValidacion();
	}	
//---------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
//---------------------------------------------------------------------------------------
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formUsuarioFormaPago");
//---------------------------------------------------------------------------------------
	objForm.VFPnombre.required = true;
	objForm.VFPnombre.description = "Nombre";		
	objForm.FPcodigo.required = true;
	objForm.FPcodigo.description = "Forma de Pago";	
	if (objForm.FPDcantidad)
		VFPDdefinirValidacion();
</script>

</cf_templatearea>
</cf_template>
