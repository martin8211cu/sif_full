<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">

<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
	if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    	document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  	else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
//-->
</script>

	  <cfinclude template="/rh/Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>

		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
	            <cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="HistoricoDePagosRealizados"
				Default="Hist&oacute;rico de Pagos Realizados"
				returnvariable="HistoricoDePagosRealizados"/>
				
				
				  <cfif isdefined("url.DEid") and not isdefined("form.DEid") >
							<cfset form.DEid = url.DEid>
		            </cfif>	             
			<cf_web_portlet_start titulo="#HistoricoDePagosRealizados#">
		  	<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td>
						<cf_htmlReportsHeaders
						irA="expediente-globalcons.cfm?DEid=#form.DEid#"
						FileName="Historico.xls"
						title="Historico">
					</td>
				</tr>
			  <tr>
				<td>
					<cfoutput>
					<cfif  isdefined('session.menues.SMcodigo') and ucase(session.menues.SMcodigo) eq "AUTO" >
						<cfset Session.Params.ModoDespliegue = 0 >
						<cfset regresar = "expediente-cons.cfm">
					<cfelse>
						<cfset Session.Params.ModoDespliegue = 1 >
						<cfset regresar = "expediente-globalcons.cfm?DEid=#form.DEid#">						
					</cfif>
					</cfoutput>	
				</td>
			  </tr>
			  <tr><td>&nbsp;</td></tr>
		    </table>
			<cfoutput>
				<!--- <cf_rhreporte principal="#regresar#" datos="/rh/expediente/consultas/formHistoricoPagos.cfm"> --->
				<cfinclude template="formHistoricoPagos.cfm">
                <cfif isdefined("regresar") and len(trim(regresar)) GT 0>
                    <form name="x" action="_self" method="post">
                    <cf_botones values="Regresar">
                    </form>
                    <script language="javascript" type="text/javascript">
                        function funcRegresar(){
                            document.location.href="#regresar#";
							return false;
                        }
                    </script>
                </cfif>
			</cfoutput>
		            <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
<cf_templatefooter>