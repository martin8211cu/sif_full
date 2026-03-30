<cfif isdefined("Form.Cambio")>  
	<cfset modo="CAMBIO">
<cfelse>  
	<cfif not isdefined("Form.modo")>    
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>  
</cfif>
<cfif isdefined("url.id_tipoinst") and Len("url.id_tipoinst") gt 0>
	<cfset form.id_tipoinst = url.id_tipoinst >
	<cfset form.Cambio = "Cambiar" >
</cfif>


<cfif isdefined("Form.id_tipoinst") AND Len(Trim(Form.id_tipoinst)) GT 0 >
	<cfquery name="rsDatos" datasource="#session.tramites.dsn#">
		SELECT id_tipoinst ,codigo_tipoinst ,nombre_tipoinst,ts_rversion 
		FROM TPTipoInst 
		WHERE id_tipoinst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tipoinst#">
	</cfquery>
</cfif>
<SCRIPT SRC="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	qFormAPI.include("*");
</SCRIPT>

<cfoutput>
<form method="post" name="form1" action="Tp_TpoInstitucionSQL.cfm">
	<table align="center" width="100%" cellpadding="2" cellspacing="0">
		<tr><td class="tituloMantenimiento" colspan="2"><font size="1"><cfif modo neq 'ALTA'>Modificar<cfelse>Agregar</cfif> Tipo de Instituci&oacute;n</font></td></tr>
		<tr valign="baseline"> 
			<td nowrap align="right">C&oacute;digo:</td>
			<td>
				<input type="text" name="codigo_tipoinst" style="text-transform:uppercase;" 
				value="<cfif modo NEQ "ALTA">#rsDatos.codigo_tipoinst#</cfif>" 
				size="10" maxlength="10" onfocus="javascript:this.select();" >
			</td>
		</tr>
		<tr valign="baseline"> 
			<td nowrap align="right">Descripci&oacute;n:</td>
			<td>
				<input type="text" name="nombre_tipoinst" 
				value="<cfif modo NEQ "ALTA">#rsDatos.nombre_tipoinst#</cfif>" 
				size="60" maxlength="100" onfocus="javascript:this.select();" >
			</td>
		</tr>		
		<tr><td>&nbsp;</td></tr>
		<tr valign="baseline">
			<td colspan="2" align="center" nowrap>
				<cfinclude template="../../../sif/portlets/pBotones.cfm">
			</td>
		</tr>
		<tr valign="baseline"> 
			<cfset ts = "">
			<cfif modo NEQ "ALTA">
				<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsDatos.ts_rversion#" returnvariable="ts">
				</cfinvoke>
			</cfif>
			<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>">
			<input type="hidden" name="id_tipoinst" value="<cfif modo NEQ "ALTA">#rsDatos.id_tipoinst#</cfif>">
		</tr>
	</table>
</form>
</cfoutput>
<SCRIPT LANGUAGE="JavaScript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.codigo_tipoinst.required = true;
	objForm.codigo_tipoinst.description="Código";				
	objForm.nombre_tipoinst.required = true;
	objForm.nombre_tipoinst.description="Descripción";				

	function deshabilitarValidacion(){
		objForm.codigo_tipoinst.required = false;
		objForm.nombre_tipoinst.required = false;
	}
</SCRIPT>


