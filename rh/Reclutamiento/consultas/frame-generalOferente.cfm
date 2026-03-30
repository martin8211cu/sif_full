<cf_translatedata name="get" tabla="RHEtiquetasOferente" col="RHEtiqueta" returnvariable="LvarRHEtiqueta">
<cfquery name="rsEtiquetas" datasource="#Session.DSN#">
	select RHEcol,
		   #LvarRHEtiqueta# as RHEtiqueta,
		   RHrequerido
	from RHEtiquetasOferente
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOferente.Ecodigo#">
	and RHdisplay = 1
	and RHEcol like 'RHO%'
</cfquery>
<cfoutput>
<table width="100%" border="0" cellpadding="3" cellspacing="0">

	<tr>
  		<cfset form.RHOid = rsOferente.RHOid>
    	<td width="10%" rowspan="9" align="center" valign="top" 
			style="padding-left: 10px; padding-right: 10px; padding-top: 10px;" nowrap>
			<cfinclude template="../../Reclutamiento/catalogos/frame-foto.cfm">
		</td> 
  	</tr>
  	<tr><td>&nbsp;</td></tr>
  	<tr><td>&nbsp;</td></tr>
	<tr>
<td align="right" class="fileLabel" width="10%" nowrap><cf_translate key="LB_NombreCompleto">Nombre Completo</cf_translate>:</td>
	<td><b><font size="3">#rsOferente.RHOnombre# #rsOferente.RHOapellido1# #rsOferente.RHOapellido2#</font></b></td>	
	</tr>
  <tr>
    <td align="right"class="fileLabel" nowrap>#rsOferente.NTIdescripcion#:</td>
	<td>#rsOferente.RHOidentificacion#</td>
  </tr>
  <tr>
    <td align="right" class="fileLabel" nowrap><cf_translate key="LB_Sexo">Sexo</cf_translate>:</td>
	<td>#rsOferente.Sexo#</td>
  </tr>
  <tr>
    <td  align="right"class="fileLabel" nowrap><cf_translate key="LB_EstadoCivil">Estado Civil</cf_translate>:</td>
	<td>#rsOferente.EstadoCivil#</td>
  </tr>
  <tr>
    <td  nowrap="nowrap"  align="right"><cf_translate key="LB_Translate">Fecha de Nacimiento</cf_translate>:</td>
	<td>#LSDateFormat(rsOferente.FechaNacimiento,'dd/mm/yyyy')#</td>
  </tr>
  <tr>
    <td colspan="2"><cf_direccion negrita="false" action="input" title="" key="#rsOferente.id_direccion#" ></td>
  </tr>

  <cfif rsEtiquetas.recordCount GT 0>
  <cfloop query="rsEtiquetas">
	  <tr>
	     <td class="fileLabel" nowrap>&nbsp;</td> 
		<td class="fileLabel" nowrap>#rsEtiquetas.RHEtiqueta#:</td>
		<td>#Evaluate("rsOferente.#rsEtiquetas.RHEcol#")#</td>
	  </tr>
  </cfloop>
  </cfif>
</table>
</cfoutput>
