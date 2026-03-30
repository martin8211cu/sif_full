<!--- 
	- Modificado por Gustavo Fonseca H.
		Fecha: 4-8-2005
		Motivo: - Se modifica para arreglar la seguridad de CxC en los procesos de facturas y notas de crédito, para que seguridad sepa 
				con cual de los dos procesos está trabajando. Esto porque se estaba trabajando con un archivo para los dos procesos.
				- Se agrega el botón nuevo en el form para que no tenga que salir hasta la lista para hacer uno nuevo (CHAVA).
--->
<cfif isdefined ("url.LvarEDid") and len(trim(url.LvarEDid))> <!--- Tiene que ver con el boton nuevo desde el form --->
	<cfset LvarEDid = 1>
</cfif>
<cfset LvarTipo = 'D'>
<cfinclude template="RegistroDocumentosCC.cfm">	