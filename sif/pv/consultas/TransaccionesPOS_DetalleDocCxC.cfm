<cfif isdefined('url.numerofax01ntr')>
	<cfif isnumeric(url.numerofax01ntr)>
		<!--- Agregar este indice a la tabla HDocumentos:
			create index HDocumentos10 on HDocumentos ( FAX01NTR )
		--->
		<cfquery name="rsDocumentoPOS" datasource="#session.dsn#">
			select d.HDid, d.SNcodigo, d.Ddocumento, sn.SNnumero
			from HDocumentos d
				inner join SNegocios sn
				on sn.SNcodigo = d.SNcodigo
				and sn.Ecodigo = d.Ecodigo
			where d.FAX01NTR = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.numerofax01ntr#">
		</cfquery>
		<cfif rsDocumentoPOS.recordcount GT 0>
			<cfset form.HDid = rsDocumentoPOS.HDid>
			<cfset form.SNcodigo = rsDocumentoPOS.SNcodigo>
			<cfset form.Ddocumento = rsDocumentoPOS.Ddocumento>
			<cfset form.SNnumero = rsDocumentoPOS.SNnumero>
			<cfset url.pop = false>
			<cfinclude template="/sif/cc/consultas/RFacturasCC2-DetalleDoc.cfm">
		</cfif>
	</cfif>
</cfif>
