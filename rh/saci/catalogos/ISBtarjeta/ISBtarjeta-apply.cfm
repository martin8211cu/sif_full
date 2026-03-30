<cfif IsDefined("form.Cambio")>	

	<cf_dbupload filefield="MTlogo" returnvariable="upload_MTlogo" queryparam="false"/>

	<cfinvoke component="saci.comp.ISBtarjeta"
		method="Cambio" 
		MTid="#form.MTid#"
		MTnombre="#form.MTnombre#"
		MTmascara="#form.MTmascara#"
		MTlogo="#upload_MTlogo.contents#"
		Habilitado="#IsDefined('form.Habilitado')#"
		ts_rversion="#form.ts_rversion#"/>

	<cflocation url="ISBtarjeta.cfm?MTid=#URLEncodedFormat(form.MTid)#">

<cfelseif IsDefined("form.Baja")>

	<cfinvoke component="saci.comp.ISBtarjeta"
		method="Baja" 
		MTid="#form.MTid#"/>

<cfelseif IsDefined("form.Nuevo")>

<cfelseif IsDefined("form.Alta")>	
	<cf_dbupload filefield="MTlogo" returnvariable="upload_MTlogo" queryparam="false"/>
	<cfinvoke component="saci.comp.ISBtarjeta"
		method="Alta" 
		MTnombre="#form.MTnombre#"
		MTmascara="#form.MTmascara#"
		MTlogo="#upload_MTlogo.contents#"
		Habilitado="#IsDefined('form.Habilitado')#"/>
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cflocation url="ISBtarjeta.cfm">
