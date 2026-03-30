<!--- 
	Creado por Gustavo Fonseca H.
		Fecha: 17-1-2006.
		Motivo: Nuevo proceso de Asignación de Facturas Recurrentes.

	Yu 14/02/2006
		Se agrego codigo para poner el bit de EDrecurrente solamente en aquellos documentos que aparecen en pantalla
--->
<cftransaction>
	<cfif isdefined("Form.IDDOCUMENTO") and Len(Trim(Form.IDDOCUMENTO))>
			<cfquery datasource="#session.DSN#">
				update HEDocumentosCP
					set EDrecurrente = 0
				where IDdocumento in  (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDDOCUMENTO#" list="yes">)
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
			</cfquery>
	</cfif>
	
	<cfif isdefined("form.chk")>
			<cfquery datasource="#session.DSN#">
				update HEDocumentosCP
					set EDrecurrente = 1
				where IDdocumento in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.chk#" list="yes">)
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
	</cfif>
</cftransaction> 
<cflocation addtoken="no" url="AsignaFacRecurrente.cfm?SNcodigo=#form.SNcodigo#">