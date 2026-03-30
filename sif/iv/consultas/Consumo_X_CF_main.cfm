<cfset parametros = "">
<cfif isdefined("form.TipoReporte")>
	<cfset parametros = "&TipoReporte=#form.TipoReporte#">
</cfif>
<cfif isdefined("form.CFcodigoDes") and len(trim(form.CFcodigoDes))>
	<cfset parametros = "&CFcodigoDes=#form.CFcodigoDes#">
</cfif>
<cfif isdefined("form.CFcodigoHas") and len(trim(form.CFcodigoHas))>
	<cfset parametros = parametros & "&CFcodigoHas=#form.CFcodigoHas#">
</cfif>
<cfif isdefined("form.AlmcodigoIni") and len(trim(form.AlmcodigoIni))>
	<cfset parametros = parametros & "&AlmcodigoIni=#form.AlmcodigoIni#">
</cfif>
<cfif isdefined("form.AlmcodigoFin") and len(trim(form.AlmcodigoFin))>
	<cfset parametros = parametros & "&AlmcodigoFin=#form.AlmcodigoFin#">
</cfif>
<cfif isdefined("form.FechaDes") and len(trim(form.FechaDes))>
	<cfset parametros = parametros & "&FechaDes=#form.FechaDes#">
</cfif>
<cfif isdefined("form.FechaHas") and len(trim(form.FechaHas))>
	<cfset parametros = parametros & "&FechaHas=#form.FechaHas#">
</cfif>
<cfif isdefined("form.chk_CorteAlmacen") and len(trim(form.chk_CorteAlmacen))>
	<cfset parametros = parametros & "&chk_CorteAlmacen=#form.chk_CorteAlmacen#">
</cfif>
<cfif isdefined("form.chk_CorteOgasto") and len(trim(form.chk_CorteOgasto))>
	<cfset parametros = parametros & "&chk_CorteOgasto=#form.chk_CorteOgasto#">
</cfif>

<cfif TipoReporte eq 1>
	<cfset LvarIrA = 'Consumo_X_CF_FormDet.cfm'>
<cfelse>
	<cfset LvarIrA = 'Consumo_X_CF_FormRes.cfm'>
</cfif>
<cf_templateheader title="Consulta de Consumo por Centro Funcional">
	<cfinclude template="../../portlets/pNavegacion.cfm">
    <cf_web_portlet_start border="true" titulo="Consulta de Consumo por Centro Funcional" skin="#Session.Preferences.Skin#">
    	<table width="100%"  border="0" cellpadding="0" cellspacing="0">
         	<tr>
            	<td width="98%" align="right" valign="top" nowrap>
                	<cf_rhimprime datos="/sif/iv/consultas/#LvarIrA#" paramsuri="#parametros#" regresar="/cfmx/sif/iv/consultas/Consumo_X_CF.cfm?1=1#parametros#"> 
                	<iframe name="printerIframe" id="printerIframe" src="about:blank"></iframe> 
                </td>
                <td width="2%" align="left">                    
                   <cf_htmlReportsHeaders irA="/sif/iv/consultas/#LvarIrA#" FileName="Consumo_Por_CF.xls" title="Consumo Por CF" preview="no" Print ="no" Back ="no">
				</td>
           	</tr>
            <tr>
            	<td colspan="2"><cfinclude template="#LvarIrA#"></td></tr>
        </table>	
	<cf_web_portlet_end>	
<cf_templatefooter>