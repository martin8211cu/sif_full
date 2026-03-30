<cf_templateheader title="Facturación de medios">
<cf_web_portlet_start titulo="Facturación de medios">
  <cfparam name="url.tab" default="fact">
  <cf_tabs width="970">
    <cf_tab text="Facturas" id="fact" selected="#url.tab is 'fact'#" >
      <cfif url.tab is 'fact'>
	  	<cfif IsDefined('url.LFlote') and Len(url.LFlote)>
	        <cfinclude template="ISBfacturaMedios-form.cfm">
		<cfelse>
	        <cfinclude template="ISBfacturaMedios.cfm">
		</cfif>
      </cfif>
    </cf_tab>
    <cf_tab text="Correos recibidos" id="inbox" selected="#url.tab is 'inbox'#">
      <cfif url.tab is 'inbox'>
		<cfset FMEinout = 'in'>
	  	<cfif IsDefined('url.FMEmailid') and Len(url.FMEmailid)>
			<cfinclude template="ISBfacturaMediosEmail-form.cfm">
		<cfelse>
			<cfinclude template="ISBfacturaMediosEmail.cfm">
		</cfif>
      </cfif>
    </cf_tab>
    <cf_tab text="Correos enviados" id="sent" selected="#url.tab is 'sent'#">
      <cfif url.tab is 'sent'>
	  	<cfset FMEinout = 'out'>
	  	<cfif IsDefined('url.FMEmailid') and Len(url.FMEmailid)>
			<cfinclude template="ISBfacturaMediosEmail-form.cfm">
		<cfelse>
			<cfinclude template="ISBfacturaMediosEmail.cfm">
		</cfif>
      </cfif>
    </cf_tab>
    <cf_tab text="Bandeja de entrada" id="spam" selected="#url.tab is 'spam'#">
      <cfif url.tab is 'spam'>
	  	<cfif IsDefined('url.messagenumber') And Len(url.messagenumber)>
	        <cfinclude template="spam-det.cfm">
		<cfelse>
	        <cfinclude template="spam.cfm">
		</cfif>
      </cfif>
    </cf_tab>
    <cf_tab text="Liquidaciones" id="liq" selected="#url.tab is 'liq'#">
      <cfif url.tab is 'liq'>
	  	<cfif IsDefined('url.FMEarchivo') And Len(url.FMEarchivo)>
	        <cfinclude template="ISBfacturaMediosArchivo-form.cfm">
		<cfelseif IsDefined('url.imp') And url.imp is 'y'>
	        <cfinclude template="ISBfacturaMediosArchivo-import.cfm">
		<cfelse>
	        <cfinclude template="ISBfacturaMediosArchivo.cfm">
		</cfif>
      </cfif>
    </cf_tab>
  </cf_tabs>
<cf_web_portlet_end> 
<script type="text/javascript">
function tab_set_current(n) {
	location.replace('?tab=' + n);
}
</script>
<cf_templatefooter>
