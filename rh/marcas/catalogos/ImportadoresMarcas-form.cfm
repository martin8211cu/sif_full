<cfif isdefined("url.EIid") and len(trim(url.EIid))>
	<cfset form.EIid = url.EIid>
</cfif>
<cfif isdefined("Form.EIid") and Len(Trim(Form.EIid))>
	<cfset modo="CAMBIO">
<cfelse>
	<cfset modo="ALTA">
</cfif>
<cfif modo EQ "CAMBIO">
	<cfquery name="rsImportadores" datasource="#session.DSN#">
		select RHIMcodigo, RHIMdescripcion, EIid, ts_rversion
		from RHImportadoresMarcas
		where EIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>	
</cfif>
<cfquery name="Importadores" datasource="sifcontrol">
	select EIcodigo, EIid, EIdescripcion
	from EImportador
	where EImodulo = 'rh.marcas' 
		and EIimporta = 1
	<!---and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">--->
</cfquery>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Codigo"
	Default="Código"
	returnvariable="LB_Codigo"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripción"
	returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Importador"
	Default="Importador"
	returnvariable="LB_Importador"/>
	
<cfoutput>
<form action="ImportadoresMarcas-sql.cfm" method="post" name="form1">		
	<table width="100%" border="0" cellspacing="2" cellpadding="0">
		<tr>
		  <td align="right" nowrap><strong>#LB_Codigo#:</strong>&nbsp;</td>
		  <td nowrap>
		  	<input type="text" name="RHIMcodigo" id="RHIMcodigo" tabindex="1" value="<cfif modo neq "ALTA">#JSStringFormat(rsImportadores.RHIMcodigo)#</cfif>" size="10" maxlength="10" onFocus="this.select();">
		  </td>
	    </tr>
		<tr>
		  <td align="right" nowrap><strong>#LB_Descripcion#:</strong>&nbsp;</td>
		  <td nowrap>
			<input type="text" name="RHIMdescripcion" id="RHIMdescripcion" tabindex="1" value="<cfif modo neq "ALTA">#JSStringFormat(rsImportadores.RHIMdescripcion)#</cfif>" size="40" maxlength="80" onFocus="this.select();">
		  </td>
   		</tr>
		<tr>
		  <td align="right" nowrap><strong>#LB_Importador#:</strong>&nbsp;</td>
		  <td nowrap>
			<select name="EIid" tabindex="1">
				<cfloop query="Importadores">
					<option value="#Importadores.EIid#" <cfif modo neq "ALTA" and rsImportadores.EIid EQ Importadores.EIid>selected</cfif>>#Importadores.EIcodigo# - #Importadores.EIdescripcion#</option>
				</cfloop>
			</select>
		  </td>
   		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td colspan="2" align="center">
				<cf_botones modo="#modo#" tabindex="1">
				<!--- <cfinclude template="/rh/portlets/pBotones.cfm"> --->
			</td>
		</tr>
		<cfset ts = "">
		<cfif modo neq "ALTA">
			<cfinvoke 
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts">
			  <cfinvokeargument name="arTimeStamp" value="#rsImportadores.ts_rversion#"/>
			</cfinvoke>
		</cfif>
		<input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'>#ts#</cfif>">
		<tr><td colspan="2" align="center">&nbsp;</td></tr>
	</table>
</form>
</cfoutput>
<cf_qforms form="form1">
<script type="text/javascript" language="javascript1.2">
	objForm.RHIMcodigo.required = true;
	objForm.RHIMcodigo.description="<cfoutput>#LB_Codigo#</cfoutput>";
	objForm.RHIMdescripcion.required = true;
	objForm.RHIMdescripcion.description="<cfoutput>#LB_Descripcion#</cfoutput>";
	objForm.EIid.required = true;
	objForm.EIid.description="<cfoutput>#LB_Importador#</cfoutput>";	
	function habilitarValidacion() {
		objForm.RHIMcodigo.required = true;
		objForm.RHIMdescripcion.required = true;
		objForm.EIid.required = true;
	}	
	function deshabilitarValidacion() {
		objForm.RHIMcodigo.required = false;
		objForm.RHIMdescripcion.required = false;
		objForm.EIid.required = false;
	}
</script>
