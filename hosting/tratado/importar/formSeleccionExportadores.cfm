<cfquery name="rsScripts" datasource="sifcontrol">
	select a.EIid, a.EIcodigo, a.EImodulo, a.EIdescripcion
		from EImportador a 
		inner join  EImportadorEmpresa b 
		on a.EIid = b.EIid
		and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigosdc#"> 
		inner join  EImportadorUsuario c 
		on b.EIid = c.EIid
		and  b.Ecodigo = c.Ecodigo
		and  c.Usucodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> 
		where not a.EIcodigo like '%.[0-9][0-9][0-9]'
		and a.EIexporta  = 1
		<cfif isdefined("FORM.MODULO") and len(trim(FORM.MODULO)) and FORM.MODULO neq 'TODOS' >
			and a.EImodulo  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.MODULO#">
		</cfif>
	union
	select a.EIid, a.EIcodigo, a.EImodulo, a.EIdescripcion
		from EImportador a 
		inner join  EImportadorEmpresa b 
		on a.EIid = b.EIid
		and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigosdc#"> 
		left outer join  EImportadorUsuario c 
		on b.EIid = c.EIid
		and  b.Ecodigo = c.Ecodigo
		and c.EIid is null
		and c.Ecodigo is null
		and c.Usucodigo is null		
		where not a.EIcodigo like '%.[0-9][0-9][0-9]'
		and a.EIexporta  = 1
		<cfif isdefined("FORM.MODULO") and len(trim(FORM.MODULO)) and FORM.MODULO neq 'TODOS' >
			and a.EImodulo  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(FORM.MODULO)#">
		</cfif>
</cfquery>

					
<cfoutput>
<form name="form" action="IMP_SolicitarParametros.cfm" method="post">
	<input type="hidden" name="MODULO" value="#FORM.MODULO#">
	<input type="hidden" name="PARAMETROS" value="#FORM.PARAMETROS#">
	<cfif rsScripts.recordcount gt 0>
		<table width="100%"  border="0" cellspacing="0" cellpadding="2">
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr>
			  <td align="right" style="padding-right: 10px; "><strong><cf_translate  key="LB_Empresa">Empresa</cf_translate>:</strong></td>
			  <td>#Session.Enombre#</td>
		  </tr>
			<tr> 
				<td align="right" width="50%" style="padding-right: 10px; ">
					<strong><cf_translate  key="LB_SeleccioneElScriptQueDeseaEjecutar">Seleccione el Script que desea ejecutar</cf_translate>:</strong>
				</td>
				<td> 
					<select name="EIid">
						<cfloop query="rsScripts">
							<option value="#EIid#">#EIcodigo# - #EIdescripcion#</option>
						</cfloop>
					</select>
				</td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr align="center">
			  <td colspan="2" style="padding-right: 10px; ">
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="BTN_Siguiente"
				Default="Siguiente"
				returnvariable="BTN_Siguiente"/>
				<input name="btnSiguiente" type="submit" id="btnSiguiente" value="#BTN_Siguiente#">
			  </td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
		</table>
	<cfelse>
		<table width="100%"  border="0" cellspacing="0" cellpadding="2">
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr>
			  <td align="center" colspan="2" style="padding-right: 10px; "><strong><cf_translate  key="LB_Empresa">Empresa</cf_translate>:</strong>  #Session.Enombre#</td>
		  </tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>		  
			<tr> 
				<td align="center"  colspan="2" style="padding-right: 10px; ">
					<cf_translate  key="LB_ElUsuario">El Usuario</cf_translate>  <strong>#Session.usulogin#</strong>  <cf_translate  key="LB_NoTieneDerechosParaUtilizarElExportador">no tiene derechos para utilizar el exportador</cf_translate>
				</td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
		</table>
	</cfif>	
	
</form>
</cfoutput>
