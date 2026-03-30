<!--- **** Define el modo en Alta, si los parametros estan definidos, el tipo del modo pasa a Cambio ***--->
<cfset modo = 'ALTA'>
<cfif  isdefined('form.PCDcatid') and len(trim(form.PCDcatid))
   and isdefined('form.Cmayor') and len(trim(form.Cmayor))
   and isdefined('form.PCEcatidref') and len(trim(form.PCEcatidref))>
   		<cfset modo = 'CAMBIO'>
</cfif>

<!--- Si el modo es de tipo Cambio, realiza las consultas (query's) a la tabla PCDCatalogoRefMayor  --->
   <!--- Consulta que selecciona los campos de la tabla para pintarlos en el formulario ---> 
<cfif modo eq 'CAMBIO'>
	<cfquery name="data" datasource="#session.DSN#">
		select PCDcatid, Ecodigo, Cmayor, PCEcatidref, ts_rversion
		from PCDCatalogoRefMayor
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and  PCDcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">
		and  Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Cmayor#">
		and  PCEcatidref = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatidref#">
	</cfquery>
	<!--- *** Consulta que selecciona los campos de la tabla para pintarlos en el conlis Catalogo ***--->
	<cfquery name="rsF_PCEcatid" datasource="#Session.DSN#">
		select PCEcatid as PCEcatidref,
				PCEcodigo as PCEcodigo,
				PCEdescripcion as PCEdescripcion
		from PCECatalogo
		where CEcodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
		and PCEcatid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatidref#">
	</cfquery>
</cfif>

<!---  ************************** Se encarga de pintar el formulario *****************************  --->
<cfoutput>
<form name="form1" method="post" action="CuentasRefMayor-sql.cfm" onSubmit="javascript: return validar(this);">
	<!--- Si los parametros estan definidos y no vacios, pinta el campo de catalogo y cuenta 
		  de una forma oculta --->
	<cfif isdefined("Form.PCEcatidref") and Len(Trim(Form.PCEcatidref))>
		<input type="hidden" name="PCEcatidref_ant" value="#form.PCEcatidref#">
	</cfif>
	<cfif isdefined("Form.Cmayor") and Len(Trim(Form.Cmayor))>
		<input type="hidden" name="Cmayor_ant" value="#form.Cmayor#">
	</cfif>
	<input type="hidden" name="PCEcatid" value="#form.PCEcatid#">
	<input type="hidden" name="PCDcatid" value="#form.PCDcatid#">
	<cfif isdefined("Form.IncVal")>
		<input type="hidden" name="IncVal" value="#form.IncVal#">
	</cfif>	
	<!---  *******************  Pinta el conlis de Cuenta y el de Catalogo  ******************** --->
	<table width="100%" cellpadding="0" cellspacing="0">
		<tr>
        	<td nowrap><strong>Cuenta Mayor:</strong></td>
           	<td>
				<cfif modo NEQ 'ALTA'>
        			<cf_sifCuentasMayor idquery="#Data.Cmayor#" size="50" tabindex = "1">
        		<cfelse>
        			<cf_sifCuentasMayor size="50" tabindex = "1">
      			</cfif>
			</td>
        </tr>
		<tr>
        	
			<td width="16%" height="39"><strong>Cat&aacute;logo:</strong></td>
			<td width="84%"> 
				<cfif MODO NEQ 'ALTA'>
					<cf_sifcatalogos name="PCEcatidref" frame="filtroFrame" llave="#Form.PCEcatidref#" codigo="PCEcodigo" desc="PCEdescripcion" query="#rsF_PCEcatid#" form="form1" Conexion="#Session.DSN#" size="50" tabindex="1">
				<cfelse>
					<cf_sifcatalogos name="PCEcatidref" frame="filtroFrame" codigo="PCEcodigo" desc="PCEdescripcion" form="form1" Conexion="#Session.DSN#" size="50" tabindex="1">
				</cfif>
			</td>
        </tr>
		<!--- ************************* Se encarga de pintar los botones ***********************--->
        <tr>
			<td colspan="3" align="center" valign="top">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td nowrap>
							<cfif modo neq 'ALTA'>
								<cf_botones modo="Cambio" include="Regresar">
							<cfelse>
								<cf_botones modo="Alta" include="Regresar">
							</cfif>
						</td>
					</tr>
				</table>
			</td>
		</tr>	
	</table>		
	<cfif modo neq 'ALTA'>
		<cfset ts = "">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
			artimestamp="#data.ts_rversion#" returnvariable="ts">
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
	</cfif>
</form>

<!--- *********************** Se encarga de manejar los errores ***************************--->
<cf_qforms>
<script language="javascript">
<!--//
	objForm.Cmayor.required = true;
	objForm.Cmayor.description = "#JSStringFormat('Cuenta Mayor')#";
	objForm.PCEcatidref.required = true;
	objForm.PCEcatidref.description = "#JSStringFormat('Catálogo')#";
	function habilitarValidacion(){
		objForm.Cmayor.required = true;
		objForm.PCEcatidref.required = true;
	}
	function deshabilitarValidacion(){
		objForm.Cmayor.required = false;
		objForm.PCEcatidref.required = false;
	}
	function funcRegresar() {
		document.form1.action = 'Catalogos.cfm';
		document.form1.submit();
		return false;
	}
//-->
</script>
</cfoutput>