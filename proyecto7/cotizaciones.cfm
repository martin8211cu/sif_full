<link href="css/MenuModulos.css" rel="stylesheet" type="text/css">
	<script>
		!window.jQuery && document.write('<script src="/cfmx/jquery/Core/jquery-1.6.1.js"><\/script>');
	</script>
<cfset lvarProvCorp = false>
<cfquery name="rsProvCorp" datasource="#session.DSN#">
	select Pvalor 
	from Parametros 
	where Ecodigo=#session.Ecodigo#
	and Pcodigo=5100
</cfquery>
<cfif rsProvCorp.recordcount gt 0 and rsProvCorp.Pvalor eq 'S'>
	<cfset lvarProvCorp = true>
	
	<cfquery name="rsDProvCorp" datasource="#session.DSN#">
		select DPCecodigo as Ecodigo, Edescripcion
		from DProveduriaCorporativa dpc
			inner join Empresas e
				on e.Ecodigo = dpc.DPCecodigo
		where dpc.Ecodigo = #session.Ecodigo#
		union
			select e.Ecodigo, e.Edescripcion
			from Empresas e
			where e.Ecodigo = #session.Ecodigo#
			order by 2
	</cfquery>
 </cfif>
<cf_templateheader title="Gestion de Autorizaciones" bloquear="false">
  	<div id="circle-menu2">
    	<div  class="titulo">Cotizaciones</div>
        <br />
        <cfinclude template="formcotizaciones.cfm">
	</div>
<cf_templatefooter>
