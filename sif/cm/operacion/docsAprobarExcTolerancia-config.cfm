

<cfinclude template="docum-funciones.cfm">


<!--- Carga los parámetros que vienen por url --->

<!--- 1. Documento actual --->

<!--- 1.1. Id del documento de recepción actual --->
<cfif isdefined("url.EDRid") and not isdefined("form.EDRid")>
	<cfset form.EDRid = url.EDRid>
</cfif>

<!--- 2. Filtro de detalles --->

<!--- 2.1. Número de parte de las líneas --->
<cfif isdefined("url.numparteF") and not isdefined("form.numparteF")>
	<cfset form.numparteF = url.numparteF>
</cfif>
<!--- 2.2. Descripción alterna --->
<cfif isdefined("url.DOalternaF") and not isdefined("form.DOalternaF")>
	<cfset form.DOalternaF = url.DOalternaF>
</cfif>
<!--- 2.3. Observaciones de la línea --->
<cfif isdefined("url.DOobservacionesF") and not isdefined("form.DOobservacionesF")>
	<cfset form.DOobservacionesF = url.DOobservacionesF>
</cfif>
<!--- 2.4. Código de artículo --->
<cfif isdefined("url.AcodigoF") and not isdefined("form.AcodigoF")>
	<cfset form.AcodigoF = url.AcodigoF>
</cfif>
<!--- 2.5. Descripción de la línea --->
<cfif isdefined("url.DOdescripcionF") and not isdefined("form.DOdescripcionF")>
	<cfset form.DOdescripcionF = url.DOdescripcionF>
</cfif>
<!--- 2.6. Comprador de la orden de compra --->
<cfif isdefined("url.CMCid1") and not isdefined("form.CMCid1")>
	<cfset form.CMCid1 = url.CMCid1>
<cfelseif not isdefined("url.CMCid1") and not isdefined("form.CMCid1") and isdefined("session.compras.comprador")>
	<cfset form.CMCid1 = session.compras.comprador>
</cfif>
<!--- 2.7. Filtro para las líneas (todas, generan reclamo, no generan reclamo) --->
<cfif isdefined("url.Reclamo") and not isdefined("form.Reclamo")>
	<cfset form.Reclamo = url.Reclamo>
</cfif>

<!--- 3. Línea actual --->

<!--- 3.1. Id de la línea actual en modo cambio --->
<cfif isdefined("url.DDRlinea") and not isdefined("form.DDRlinea")>
	<cfset form.DDRlinea = url.DDRlinea>
</cfif>

<cfif not isdefined("form.PageNum_lista") and isdefined("url.PageNum_lista")>
	<cfset form.PageNum_lista = url.PageNum_lista>
</cfif>
