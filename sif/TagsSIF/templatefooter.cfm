
<cfsilent>
<cfparam name="Attributes.template" type="string" default="">

<cfif ThisTag.ExecutionMode IS 'End' OR ThisTag.HasEndTag IS 'YES'>
	<cf_errorCode	code = "50717" msg = "cf_templatefooter no debe tener tag de cierre">
</cfif>

<cfif Not IsDefined('Request.templatefooterdata')>
	<cf_errorCode	code = "50718" msg = "cf_templateheader debe preceder a cf_templatefooter">
</cfif>
</cfsilent>
<cfoutput>#Request.templatefooterdata#</cfoutput>

<cfif !isDefined("request.UseTemplatefooter")>
    <cfset request.UseTemplatefooter = true>
    <cfif isdefined('session.sitio.footer') and LEN(trim(session.sitio.footer))>
    	<cfinclude template="#session.sitio.footer#">	
    <cfelse>
    	<cfif session.monitoreo.SScodigo eq 'RH'>
            <cfif isdefined('url.s') and url.s eq 'SIF'>
            <cfelse>
                <cfif REFind('soinasp01_sapiens.css',session.sitio.CSS)>
                    <table width="980" height="42" align="center" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width="140" bgcolor="172465" background="/cfmx/plantillas/Sapiens/css/sapiens/portlet/soin_logo.gif" ></td>
                            <td width="600" bgcolor="172465" background="/cfmx/plantillas/Sapiens/css/sapiens/portlet/logo.gif" align="center">
                            <cfoutput><font color="##FFFFFF">&##169;</font></cfoutput>
                            <font color="#FFFFFF">SOIN, Soluciones Integrales 2010. Este producto está protegido por copyright y distribuido bajo
                            licencias que restringen la copia, modificación, distribución y descompilación.</font></td>
                            <td width="240" background="/cfmx/plantillas/Sapiens/css/sapiens/portlet/final.jpg">&nbsp;</td>
                        </tr>
                    </table>
                </cfif>
            </cfif>
        </cfif>
    </cfif>
    <cfset session.porlets ="">
    <cfif isdefined('Request.bloquear') and Request.bloquear>
    	<cfhtmlhead text='<script type="text/javascript">$.unblockUI();</script>'>
    </cfif>
</cfif>

