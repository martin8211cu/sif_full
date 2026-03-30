<cf_templateheader title="Creación de Parches">
<cfinclude template="mapa.cfm">
<h1>Iniciar un parche nuevo</h1>
<cfoutput>

<cf_web_portlet_start titulo="Iniciar un parche nuevo" width="700">

<p>
<strong>	Precaución:
</strong>	Está a punto de iniciar un parche nuevo.
	La información con que ha estado trabajando podría perderse si no ha
	generado el parche.
	
	&iquest; Desea iniciar un parche nuevo, o prefiere guardar primero el parche
	actual ?
	<cfif Len(session.parche.guid) EQ 0>
		<p>
		<strong>N.B.:</strong> Nunca antes ha guardado este parche</p>
	</cfif>
</p>
<p>
	Por favor confirme si desea iniciar un parche nuevo ahora.
</p>

   	<form action="admreset-control.cfm" method="post">
		<input type="submit" name="ok" value="Iniciar un parche nuevo">
		<input type="submit" name="guardar" value="Guardar el parche actual">
	</form>
<cf_web_portlet_end>
</cfoutput>
<cf_templatefooter>
