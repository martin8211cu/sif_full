<cfsetting requesttimeout="3600">

<cf_template template="#session.sitio.template#">
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_EjecucionDeScriptsDeExportacion"
	Default="Ejecuci&oacute;n de Scripts de Exportaci&oacute;n "
	returnvariable="LB_EjecucionDeScriptsDeExportacion"/> 
	
	<cf_templatearea name="title">
		<cfoutput>#LB_EjecucionDeScriptsDeExportacion#</cfoutput>
	</cf_templatearea>
	<cf_templatearea name="body">
	<cf_web_portlet_start titulo="#LB_EjecucionDeScriptsDeExportacion#">
		<cfquery name="rsScript" datasource="sifcontrol">
			select EIid, EIcodigo, EImodulo, EIexporta, EIimporta, EIdescripcion
			from EImportador
			where EIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIid#">
			order by upper(EIcodigo)
		</cfquery>
		
		<cfquery name="rsDetalle" datasource="sifcontrol">
			select DInumero, DInombre, DIdescripcion, DItipo, DIlongitud
			from DImportador
			where EIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIid#">
			and DInumero < 0
		</cfquery>
		
		<cfif rsScript.EIimporta EQ 1>
			<cfset modo = "in">
		<cfelseif rsScript.EIexporta EQ 1>
			<cfset modo = "out">
		</cfif>
		
		<cfoutput>
			<cfif isdefined("modo")>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td colspan="2" align="center">&nbsp;</td>
				  </tr>
				<tr>
				  <td align="right" style="padding-right: 10px; "><strong><cf_translate  key="LB_Empresa">Empresa</cf_translate>:</strong></td>
				  <td>#Session.Enombre#</td>
				</tr>
				<tr> 
					<td align="right" width="30%" style="padding-right: 10px; ">
						<strong><cf_translate  key="LB_ScriptAEjecutar">Script a ejecutar</cf_translate>:</strong>
					</td>
					<td> 
						#rsScript.EIcodigo# - #rsScript.EIdescripcion#
					</td>
				</tr>
				  <tr>
					<td align="center">&nbsp;</td>
					<td>
						<cf_sifimportar EIcodigo="#rsScript.EIcodigo#"  mode="out">
							<cfloop collection="#Form#" item="key">
								<cf_sifimportarparam name="#key#" value="#StructFind(Form, key)#">
							</cfloop>
						</cf_sifimportar>
					</td>
				  </tr>
				  <tr>
					<td colspan="2" align="center">
						<form name="form" action="ScriptExec.cfm" method="post">
							<input type="hidden" name="MODULO" value="#FORM.MODULO#">
							<input type="hidden" name="PARAMETROS" value="#FORM.PARAMETROS#">
							<input type="hidden" name="EIid" value="#Form.EIid#">
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							  <tr>
								<td align="center">
									<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="BTN_Anterior"
									Default="Anterior"
									returnvariable="BTN_Anterior"/>
									<input name="btnAnterior" type="submit" id="btnAnterior" value="<cfoutput>#BTN_Anterior#</cfoutput>" onClick="javascript: Regresar();">
								</td>
							  </tr>
							</table>
						</form>
					</td>
				  </tr>
				  <tr>
					<td colspan="2" align="center">&nbsp;</td>
				  </tr>
				</table>
			</cfif>
		</cfoutput>
		<cf_web_portlet_end>
	</cf_templatearea>
</cf_template>

<script language="JavaScript1.2" type="text/javascript">
	function Regresar(){
		document.form.action="IMP_SolicitarParametros.cfm";
		document.form.submit();
	}	

</script>
