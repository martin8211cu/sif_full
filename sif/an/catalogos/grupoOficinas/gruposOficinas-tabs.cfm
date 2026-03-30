<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Titulo" 	default="Grupos de Oficinas" 
returnvariable="LB_Titulo" xmlfile="gruposOficinas-tabs.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_DatosGenerales" 	default="Datos Generales" 
returnvariable="LB_DatosGenerales" xmlfile="gruposOficinas-tabs.xml"/>

<cf_templateheader title="#LB_Titulo#">
<cf_web_portlet_start titulo="#LB_Titulo#">

<cfinclude template="/home/menu/pNavegacion.cfm">

<cfif isdefined('url.GOid') and not isdefined('form.GOid')>
	<cfparam name="form.GOid" default="#url.GOid#">
</cfif>

<cfset modo = 'ALTA'>
<cfif isdefined('form.GOid') and len(trim(form.GOid))>
	<cfset modo = 'CAMBIO'>
</cfif>
<!--- 
<cfdump  label="Url" var="#url#">
<cfdump label="form"  var="#form#">
<cfdump label="modo"  var="#modo#">
<cfabort> --->
 
<style type="text/css">

<!--
.topmenu,.topmenu a {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12px; color:#000000 }
.topmenusel,.topmenusel a {font-family: Verdana, Arial, Helvetica, sans-serif; font-weight:bold;
 font-size: 12px; background-color:#3366CC; color:white}
-->
</style>
<cfif not isdefined("url.tab")>
 <cfparam name="url.tab" default="1">
</cfif>

<table border="0" cellpadding="4" cellspacing="1" bordercolor="#999999">
 	<tr>
   		<td>
			<cf_tabs width="100%" onclick="tab_set_current_doc">
				<cf_tab text="#LB_DatosGenerales#" selected="#url.tab eq 1#">
					<cfif url.tab EQ 1>
						<cfinclude template="gruposOficinas-tab#url.tab#.cfm">
					</cfif>
			 	</cf_tab>
			 <cfif (modo EQ 'CAMBIO')> 
					
						<cf_tab text="Oficinas" selected="#url.tab eq 2#">
							<cfif url.tab EQ 2>
							<cfinclude template="gruposOficinas-tab#url.tab#.cfm">
							</cfif>
						</cf_tab> 
			  </cfif>
			 </cf_tabs> 
		</td>
	
	</tr>
</table>

<cf_web_portlet_end>
<cf_templatefooter>
<script language="javascript" type="text/javascript">
	function tab_set_current (n){
		location.href='gruposOficinas-form.cfm?tab='+escape(n);
	}	
	function tab_set_current_doc (n){
			<cfif isdefined("form.GOid") and len(trim(form.GOid))>
				location.href="gruposOficinas-tabs.cfm?GOid=<cfoutput>#form.Goid#</cfoutput> &tab="+escape(n);
			</cfif>
	}
</script>
