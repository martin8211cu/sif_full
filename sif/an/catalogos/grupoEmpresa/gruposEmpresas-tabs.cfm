<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Titulo" 	default="Grupos de Empresas" 
returnvariable="LB_Titulo" xmlfile="gruposEmpresas-tabs.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_DatosGenerales" 	default="Datos Generales" 
returnvariable="LB_DatosGenerales" xmlfile="gruposEmpresas-tabs.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Empresas" 	default="Empresas" 
returnvariable="LB_Empresas" xmlfile="gruposEmpresas-tabs.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Mensajes" 	default="Seleccione las Empresas que pertenecen al grupo" 
returnvariable="LB_Mensajes" xmlfile="gruposEmpresas-tabs.xml"/>
<cf_templateheader title="#LB_Titulo#">
<cf_web_portlet_start titulo="#LB_Titulo#">

<cfinclude template="/home/menu/pNavegacion.cfm">

<cfif isdefined('url.GEid') and not isdefined('form.GEid')>
	<cfparam name="form.GEid" default="#url.GEid#">
</cfif>

<cfset modo = 'ALTA'>
<cfif isdefined('form.GEid') and len(trim(form.GEid))>
	<cfset modo = 'CAMBIO'>
</cfif>

 
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
						<cfinclude template="gruposEmpresas-tab#url.tab#.cfm">
					</cfif>
			 	</cf_tab>
			 <cfif (modo EQ 'CAMBIO')> 
					
						<cf_tab text="#LB_Empresas#" selected="#url.tab eq 2#">
							<cfif url.tab EQ 2>
							<cfinclude template="gruposEmpresas-tab#url.tab#.cfm">
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
		location.href='gruposEmpresas-form.cfm?tab='+escape(n);
	}	
	function tab_set_current_doc (n){
			<cfif isdefined("form.GEid") and len(trim(form.GEid))>
				location.href="gruposEmpresas-tabs.cfm?GEid=<cfoutput>#form.GEid#</cfoutput> &tab="+escape(n);
			</cfif>
	}
</script>
