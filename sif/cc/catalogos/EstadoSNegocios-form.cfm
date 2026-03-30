<!---    <cfdump var="#form#">--->
<cfset modo="ALTA">

<cfif isdefined("url.ESNid") and LEN(TRIM(url.ESNid)) and (url.ESNid gt 0) and not isdefined("form.ESNid")>
	<cfset form.ESNid = url.ESNid>
</cfif>

<cfif isdefined("form.ESNid")and (form.ESNid) GT 0>
	<cfset modo="CAMBIO">
</cfif>
<cfif modo NEQ "ALTA">
	<cfquery name="rsEstadoSNegocios" datasource="#Session.DSN#" >
		select  ESNid, ESNcodigo, ESNdescripcion, ESNfacturacion, ts_rversion
		from EstadoSNegocios 
		where ESNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESNid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>
</cfif> 	


<cfoutput>
<form action="EstadoSNegocios-SQL.cfm" method="post" name="form1">
	<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">	
	<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">	
	<input name="filtro_ESNcodigo" type="hidden" value="<cfif isdefined('form.filtro_ESNcodigo')>#form.filtro_ESNcodigo#</cfif>">
	<input name="filtro_ESNdescripcion" type="hidden" value="<cfif isdefined('form.filtro_ESNdescripcion')>#form.filtro_ESNdescripcion#</cfif>">
	<input name="filtro_Factura" type="hidden" value="<cfif isdefined('form.filtro_Factura')>#form.filtro_Factura#</cfif>">

  <table width="100%" height="75" align="center" cellpadding="2" cellspacing="0" border="0">
		<tr> 
			<td width="27%" align="right" valign="baseline" nowrap><strong>C&oacute;digo:&nbsp;</strong></td>
			<td><input name="ESNcodigo" tabindex="1" type="text" value="<cfif modo NEQ 'ALTA'>#trim(rsEstadoSNegocios.ESNcodigo)#</cfif>" size ="5" maxlength ="4"></td>
		</tr>
		<tr> 
			<td width="27%" align="right" valign="baseline" nowrap><strong>Descripci&oacute;n:&nbsp;</strong></td>
			<td><input name="ESNdescripcion"  tabindex="1" type="text" value="<cfif modo NEQ 'ALTA'>#rsEstadoSNegocios.ESNdescripcion#</cfif>" size ="50" maxlength ="80"></td>
		</tr>
		<tr> 
			<td width="27%" align="right" valign="baseline" nowrap><strong>Permite&nbsp;Facturaci&oacute;n:&nbsp;</strong></td>
			<td align="left"><input name="ESNfacturacion" tabindex="1" type="checkbox" <cfif modo NEQ 'ALTA' and rsEstadoSNegocios.ESNfacturacion EQ 1>checked</cfif> > </td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr> 
			<td colspan="8" align="center" valign="baseline" nowrap>
				<cf_botones modo =#modo# tabindex="2">
			</td>
		</tr>
	</table>

<cfset ts = "">
  <cfif modo NEQ "ALTA">
    <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
		<cfinvokeargument name="arTimeStamp" value="#rsEstadoSNegocios.ts_rversion#"/>
	</cfinvoke>
</cfif>  
  <cfoutput>
  <input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>">
  <cfif modo NEQ "ALTA">
  <input type="hidden" name="ESNid" value="#form.ESNid#">
  </cfif>
  </cfoutput>
</form>
</cfoutput>
<cf_qforms form="form1">
<SCRIPT LANGUAGE="JavaScript">

	objForm.ESNcodigo.required = true;
	objForm.ESNcodigo.description = 'Código';
	objForm.ESNdescripcion.required= true;
	objForm.ESNdescripcion.description = 'Descripción';	

	function deshabilitarValidacion(){
		objForm.ESNcodigo.required = false;
		objForm.ESNdescripcion.required= false;
	}

	function habilitarValidacion(){
		objForm.ESNcodigo.required = true;
		objForm.ESNdescripcion.required= true;
	}

<!--//
	function funcRegresar() {
		deshabilitarValidacion();
		document.form1.action='../MenuCC.cfm';
		document.form1.submit();
	}
	//-->
	document.form1.ESNcodigo.focus();
</SCRIPT>