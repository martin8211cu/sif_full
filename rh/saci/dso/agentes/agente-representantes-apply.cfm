<cfinclude template="agente-params.cfm">

<cfset duenno = Form.Pquien>
<cfset sufijo = "_CT">

<cfinclude template="/saci/vendedor/venta/representante-apply.cfm">
<cfinclude template="agente-redirect.cfm">
