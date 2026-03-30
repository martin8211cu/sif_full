<!---Llamamos al componente de Ruta --->
<cfset r = createObject("component","rh.Componentes.GeneraCFDIs.RutaCFDI")>
<cfset pathruta = r.getRuta(Pcodigo = "17400")>
<cfset ruta = "#pathruta#/#Session.FileCEmpresa#/#Session.Ecodigo#">
<cfset ruta = replace(ruta, '\', '/', 'all')>
<cfset rutaCert = replace(pathruta, '\', '/', 'all')><!---Se realiza doble replace debido a que la primera no estaba regresando los diagonales correctos --->
<cfset rutaCert = replace(rutaCert, '\', '/', 'all')>
<!---  --->

<cfif !DirectoryExists("#ruta#") >
	<cfset DirectoryCreate("#ruta#")>
</cfif>
<cfif !DirectoryExists("#ruta#/imgQR") >
	<cfset DirectoryCreate("#ruta#/imgQR")>
</cfif>
<cfif !DirectoryExists("#ruta#/xmlST") >
	<cfset DirectoryCreate("#ruta#/xmlST")>
</cfif>
<cfif !DirectoryExists("#ruta#/Nomina#Year(now())#") >
	<cfset DirectoryCreate("#ruta#/Nomina#Year(now())#")>
</cfif>
<cfif !DirectoryExists("#ruta#/Liquidacion-Finiquito#Year(now())#") >
	<cfset DirectoryCreate("#ruta#/Liquidacion-Finiquito#Year(now())#")>
</cfif>
<cfif !DirectoryExists("#ruta#/Buro")>
<cfset DirectoryCreate("#ruta#/Buro")>
</cfif>
<cfif !DirectoryExists("#ruta#/DescargasXMLZip") >
	<cfset DirectoryCreate("#ruta#/DescargasXMLZip")>
</cfif>

<cfif !DirectoryExists('#rutaCert#/Certificado')>
	<cfset DirectoryCreate("#rutaCert#/Certificado")>
</cfif>

<cfset Caller.ruta="#ruta#">
<cfset Caller.rutaCert="#rutaCert#">
