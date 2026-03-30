<cfparam name="form.Pagina" default="1">
<cfparam name="form.MaxRows" default="15">	
				
<cfset tab_ids = 'area,prod,pt,arc'>
<cfparam name="form.tab" default="-default-">

<cfif Not ListFind(tab_ids, form.tab)>
	<cfset form.tab=ListFirst(tab_ids)>
</cfif>

<cfif isdefined('url.OTcodigo') and not isdefined("form.OTcodigo") >
	<cfset form.OTcodigo = url.OTcodigo>
</cfif>     

<cf_templateheader title="Registro de OT">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Registro de OT'>
    <cfinclude template="../../../sif/portlets/pNavegacion.cfm">

                <cfinclude template="formOTMaestro.cfm">
    
    
    <cf_tabs>
    <cf_tab text="Areas" id="area" selected="#form.tab is ListGetAt(tab_ids, 1)#">
		 <cfinclude template="formProdArea.cfm">  
	</cf_tab>
    <cf_tab text="Insumos" id="prod" selected="#form.tab is ListGetAt(tab_ids, 2)#">
		<cfinclude template="formProdMP.cfm">
	</cf_tab>
    <cf_tab text="Producto Terminado" id="pt" selected="#form.tab is ListGetAt(tab_ids, 3)#">
        <cfinclude template="formProdProducto.cfm">
	</cf_tab>
    <cf_tab text="Archivo" id="arc" selected="#form.tab is ListGetAt(tab_ids, 4)#">
        <cfinclude template="formProdArchivo.cfm">
	</cf_tab>
    </cf_tabs>
    
	<cf_web_portlet_end>	
<cf_templatefooter>
