<cfif isdefined("form.Bid") and len(trim(form.Bid)) gt 0>
	<cfset MODO  =  "CAMBIO">
<cfelse>
	<cfset MODO  =  "ALTA">
</cfif>
<cfquery name="rsBancos" datasource="#Session.DSN#">
	select Bid, Bdescripcion
	from Bancos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<cfquery name="rsFormatos" datasource="sifcontrol">
	select EIid, EIdescripcion
	from EImportador
	where EIexporta = 1
	and EImodulo = 'rh.reppag'   
	and not EIcodigo like '%.[0-9][0-9][0-9]'
</cfquery>
<!--- <cfquery name="rsBancosFormato" datasource="#session.DSN#">
	select Bid
	from RHExportaciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
 --->
 <cfif MODO neq "ALTA">
	<cfquery name="rsFORM" datasource="#Session.DSN#">
			select a.Bid, a.EIid, RHEdescripcion, b.Bdescripcion as Banco, a.ts_rversion
			from RHExportaciones a, Bancos b
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and a.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">
			and a.EIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIid#">
			and a.Bid = b.Bid
	</cfquery>
</cfif>
<script language="javascript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

<!---==================== TRADUCCION =======================----->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Banco"
	Default="Banco"	
	returnvariable="LB_Banco"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Formato"
	Default="Formato"	
	returnvariable="LB_Formato"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Descripcion"
	Default="Descripción"	
	returnvariable="MSG_Descripcion"/>
	
<cfoutput>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
<form action="SQLFExportacion.cfm" method="post" name="form1" onSubmit="document.form1.Bid.disabled = false;">
  <cfif MODO neq "ALTA">
  	<cfinvoke 
		component="sif.Componentes.DButils"
		method="toTimeStamp"
		returnvariable="ts">
		<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
	</cfinvoke>

	<input type="hidden" name="ts_rversion" value="#ts#">
  </cfif>
  <tr>
    <td rowspan="9" nowrap class="fileLabel">&nbsp;</td>
	<td colspan="2" nowrap bgcolor="##E2E2E2" class="subTitulo" align="center"><cfif MODO neq "ALTA"><cf_translate key="LB_Modificacion_de">MODIFICACION DE</cf_translate><cfelse><cf_translate key="LB_Nuevo">NUEVO</cf_translate></cfif><cf_translate key="LB_Formato_de_exportacion"> FORMATO DE EXPORTACION</cf_translate><cfif MODO neq "ALTA"><cf_translate key="LB_Para"> PARA</cf_translate> #rsFORM.BANCO#</cfif></td>
	<td rowspan="9" nowrap class="fileLabel">&nbsp;</td>
  </tr>
  <tr>
	<td nowrap class="fileLabel" align="right"></td>
    <td nowrap class="fileLabel">&nbsp;</td>
    </tr>
  <tr>
    <td nowrap class="fileLabel" align="right">#LB_Banco#: </td>
    <td nowrap class="fileLabel"><select name="Bid" <cfif MODO neq "ALTA">disabled</cfif>>
		<cfloop query="rsBancos">
			<option value="#Bid#" <cfif MODO neq "ALTA" and rsFORM.Bid eq Bid>selected</cfif>>#Bdescripcion#</option>
		</cfloop>
    </select></td>
    </tr>
  <tr>
    <td nowrap class="fileLabel" align="right">#LB_Formato#: </td>
    <td nowrap class="fileLabel"><select name="EIid">
		<cfloop query="rsFormatos">
			<option value="#rsFormatos.EIid#" <cfif (MODO neq "ALTA") and (trim(rsFORM.EIid) eq trim(rsFormatos.EIid))>selected</cfif>>#rsFormatos.EIdescripcion#</option>
		</cfloop>
    </select>
	</td>
    </tr>
  <tr>
    <td nowrap class="fileLabel" align="right"><cf_translate key="LB_Descripcion">Descripci&oacute;n</cf_translate>: </td>
    <td nowrap class="fileLabel"><input type="text" name="RHEdescripcion" <cfif MODO neq "ALTA">value="#rsForm.RHEdescripcion#"</cfif> size="40" maxlength="80"></td>
    </tr>
  <tr>
    <td nowrap class="fileLabel" align="right"></td>
    <td nowrap class="fileLabel">&nbsp;</td>
    </tr>
  <tr>
    <td colspan="2" nowrap class="fileLabel" align="center"><cfinclude template="/rh/portlets/pBotones.cfm"></td>
    </tr>
  <tr>
    <td nowrap class="fileLabel" align="right"></td>
    <td nowrap class="fileLabel">&nbsp;</td>
    </tr>
</form>
</table>
</cfoutput>
<script language="JavaScript1.2" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	<cfoutput>
		objForm.Bid.required = true;
		objForm.Bid.description="#LB_Banco#";
		objForm.EIid.required = true;
		objForm.EIid.description="#LB_Formato#";
		objForm.RHEdescripcion.required = true;
		objForm.RHEdescripcion.description = "#MSG_Descripcion#";
	</cfoutput>	

	function deshabilitarValidacion(){
		objForm.Bid.required = false;
		objForm.EIid.required = false;
		objForm.RHEdescripcion.required = false;
	}
	function limpiar(){
document.form1.reset();
}
	
	<!---
	/* 	
	//Validación eliminada el 27 de Abril del 2004 porque se habilito la posibilidad de tener mas de un formato para la misma empresa, 
	//en la BD, por requerimiento de SOIN.
	function _existeFormatoParaBanco(){
		<cfoutput query="rsBancosFormato">
			if (objForm.Bid.getValue()=='#Bid#'
			<cfif MODO neq "ALTA">
				&& objForm.Bid.getValue() != '#rsFORM.Bid#'
			</cfif>			
			)
				objForm.Bid.throwError("Error. El Banco seleccionado ya tiene definido un formato. NO puede agregar otro formato para el mismo Banco. Puede cambiar el existente, o eliminarlo y crear otro.");
		</cfoutput>
	}
	
	objForm.onValidate = _existeFormatoParaBanco;
	*/
	--->
</script>