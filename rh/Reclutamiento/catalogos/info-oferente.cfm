
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_SeleccionarOferente"
	Default="Seleccionar Oferente"
	returnvariable="LB_SeleccionarOferente"/>


<!--- Se utiliza cuando el que consulta es el empleado --->

	
					

	<cfif isdefined("Form.RHOid")>
		<cfquery datasource="#Session.DSN#" name="rsOferente">
			select a.RHOid, a.Ecodigo, a.NTIcodigo, a.RHOidentificacion, a.RHOnombre, a.RHOapellido1, a.RHOapellido2,  
				   a.RHOdireccion,  a.RHOtelefono1, a.RHOtelefono2, a.RHOemail, a.RHOfechanac, a.RHOobs1, a.RHOobs2, a.RHOobs3,
				   a.RHOdato1, a.RHOdato2, a.RHOdato3, a.RHOdato4, a.RHOdato5, a.RHOinfo1, a.RHOinfo2, a.RHOinfo3,
				   b.NTIdescripcion, a.ts_rversion, a.Ppais,
					case a.RHOcivil
					when 0 then '<cf_translate key="CMB_SolteroA">Soltero(a)</cf_translate>'
					when 1 then '<cf_translate key="CMB_CasadoA">Casado(a)</cf_translate>'
					when 2 then '<cf_translate key="CMB_DivorciadoA">Divorciado(a)</cf_translate>'
					when 3 then '<cf_translate key="CMB_ViudoA">Viudo(a)</cf_translate>'
					when 4 then '<cf_translate key="CMB_UnionLibre">Union Libre</cf_translate>'
					when 5 then '<cf_translate key="CMB_SeparadoA">Separado(a)</cf_translate>'
					else  '' end as  RHOcivil,
					case a.RHOsexo 										   
					when 'M' then '<cf_translate key="CMB_Masculino">Masculino</cf_translate>'
					when 'F' then '<cf_translate key="CMB_Femenino">Femenino</cf_translate>'
					else  '' end as  RHOsexo

			from DatosOferentes a 
			  inner join NTipoIdentificacion b
				on  a.NTIcodigo = b.NTIcodigo
				and b.Ecodigo = #Session.Ecodigo#
			where a.RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">
			<cfif Session.cache_empresarial EQ 0>
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			</cfif>
		</cfquery>
	</cfif>
<cfoutput>
<table width="98%" align="center" border="0" cellpadding="3" cellspacing="0">
  <tr>
    <td width="10%" rowspan="9" align="center" valign="top" style="padding-left: 10px; padding-right: 10px; padding-top: 10px;" nowrap>
	  	<cfif isdefined('form.RHOid') and LEN(form.RHOid) GT 0>
			<table width="100%" border="1" cellspacing="0" cellpadding="0">
			  <tr>
				<td align="center">
				  <cfinclude template="/rh/Reclutamiento/catalogos/frame-foto.cfm">
				</td>
			  </tr>
			</table>
		</cfif>
	</td> 
	<td class="fileLabel" width="15%" nowrap><cf_translate key="NombreExp">Nombre Completo</cf_translate>: </td>
	<td colspan="3"><b><font size="3">#rsOferente.RHOnombre# #rsOferente.RHOapellido1# #rsOferente.RHOapellido2#</font></b></td>
    <td width="18%" align="right">
		<cfif not isdefined("consulta")>
			<a href="lista-oferentes.cfm">#LB_SeleccionarOferente#: <img src="/cfmx/rh/imagenes/find.small.png" name="imageBusca" id="imageBusca" border="0"></a>
		</cfif>
	</td>
  </tr>
  <tr>
    <td class="fileLabel" nowrap><cf_translate key="CedulaExp">#rsOferente.NTIdescripcion#</cf_translate>:</td>
	<td width="30%">#rsOferente.RHOidentificacion#</td>

    <td class="fileLabel" nowrap width="11%"></td>
	<td colspan="2"></td>
  </tr>
  <tr>
    <td class="fileLabel" nowrap><cf_translate key="SexExp">Sexo</cf_translate>:</td>
	<td>#rsOferente.RHOsexo#</td>
    <td class="fileLabel" nowrap width="11%"></td>
	<td colspan="2"></td>
  </tr>
  <tr>
    <td class="fileLabel" nowrap><cf_translate key="EstadoCivilExp">Estado Civil</cf_translate>:</td>
	<td>#rsOferente.RHOcivil#</td>
	<td class="fileLabel" nowrap width="11%"></td>
  </tr>
  <tr>
    <td class="fileLabel" nowrap><cf_translate key="FecNacExp">Fecha de Nacimiento</cf_translate>:</td>
	<td><cf_locale name="date" value="#rsOferente.RHOfechanac#"/></td>
  </tr>
  <tr>
    <td class="fileLabel" nowrap><cf_translate key="DireccionExp">Direccion</cf_translate>:</td>
	<td>#rsOferente.RHOdireccion#</td>
  </tr>
</table>
</cfoutput>
