<cfif isdefined("url.CMPid") and not isdefined("form.CMPid") and len(trim(url.CMPid))>
	<cfset form.CMPid = url.CMPid>
</cfif>
<!---<cfset modo = 'Alta'><!--- Solo se puede entrar en modo cambio --->
<cfif isdefined("form.CMPid") and len(trim(form.CMPid)) and not isdefined("form.Nuevo")>
	<cfset modo = 'Cambio'>
</cfif>--->

<!---<cfif modo neq 'Alta'>--->
    <cfquery name="rsDetalleSeguimiento" datasource="#session.DSN#">
    	select
        	a.COSGid, a.COEGid, a.COSGObservación, a.COSGFecha, a.COSGUsucodigo, a.BMUsucodigo, c.CMPProceso
        from COSeguiGarantia a
			inner join COEGarantia b 
			on b.COEGid = a.COEGid
			inner join CMProceso c
			on c.CMPid  = b.CMPid
        where a.COEGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.COEGid#">
    </cfquery>
<!---</cfif>--->

<cf_templateheader title="Conavi - Seguimientos">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
	<cf_web_portlet_start skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Detalle Seguimiento de Garantias'>
		<cfoutput>
            <form name="form1" action="SeguimientoGarantias_SQL.cfm" method="post">               
            <cf_navegacion name="CMPid" default="" 	navegacion="navegacion">
                <table cellpadding="2" cellspacing="0" align="center" border="0" width="100%">                    
					<tr>
                    	<td align="right" nowrap><strong>COSGid</strong></td>
            			<td nowrap>
                		<input type="hidden" id="COSGid" name="COSGid" value="#rsDetalleSeguimiento.COSGid#" tabindex="1">
                		#rsDetalleSeguimiento.COSGid# </td>
                    </tr>
                    <tr>
                    	<td align="right" nowrap><strong>COEGid</strong></td>
            			<td nowrap>
                		<input type="hidden" id="COEGid" name="COEGid" value="#rsDetalleSeguimiento.COEGid#" tabindex="1">
                		#rsDetalleSeguimiento.COEGid# </td>
                    </tr>
					<tr>
                    	<td align="right" nowrap><strong>CMPProceso</strong></td>
            			<td nowrap>
                		<input type="hidden" id="CMPProceso" name="CMPProceso" value="#rsDetalleSeguimiento.CMPProceso#" tabindex="1">
                		#rsDetalleSeguimiento.CMPProceso# </td>
                    </tr>
                    <tr>
                    	<td align="right" nowrap><strong>COSGObservación</strong></td>
            			<td nowrap>
                		<input type="hidden" id="COSGObservación" name="COSGObservación" value="#rsDetalleSeguimiento.COSGObservación#" tabindex="1">
                		#rsDetalleSeguimiento.COSGObservación# </td>                    </tr>
					<tr>
                    	<td align="right" nowrap><strong>COSGFecha</strong></td>
            			<td nowrap>
                		<input type="hidden" id="COSGFecha" name="COSGFecha" value="#rsDetalleSeguimiento.COSGFecha#" tabindex="1">
                		#rsDetalleSeguimiento.COSGFecha# </td>
                    </tr>	
					<tr>
                    	<td align="right" nowrap><strong>COSGUsucodigo</strong></td>
            			<td nowrap>
                		<input type="hidden" id="COSGUsucodigo" name="COSGUsucodigo" value="#rsDetalleSeguimiento.COSGUsucodigo#" tabindex="1">
                		#rsDetalleSeguimiento.COSGUsucodigo# </td>
                    </tr>
					<tr>
                    	<td align="right" nowrap><strong>COSGFecha</strong></td>
            			<td nowrap>
                		<input type="hidden" id="BMUsucodigo" name="BMUsucodigo" value="#rsDetalleSeguimiento.BMUsucodigo#" tabindex="1">
                		#rsDetalleSeguimiento.BMUsucodigo# </td>
                    </tr>					
					<tr>
					<input type="submit" name="Regresar" class="btnAnterior" value="Regresar" onclick="javascript: this.form.botonSel.value = this.name; if (window.funcRegresar) return funcRegresar();" tabindex="1">

                	</tr>
				</table>			
           </form>
        </cfoutput>
    <cf_web_portlet_end>
<cf_templatefooter>

<SCRIPT LANGUAGE="JavaScript">	
function funcRegresar() {								
	document.form.action='/cfmx/sif/conavi/garantia/catalogos/SeguimientoGarantias-form.cfm?Pagina=1';	
	document.form.submit();					
}
</SCRIPT>

