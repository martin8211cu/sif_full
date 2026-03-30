<cfparam name="Attributes.name" type="string">
<cfparam name="Attributes.value" type="string" default="">
<cfparam name="Attributes.tipo_dato" type="string">
<cfparam name="Attributes.mascara" type="string" default="">
<cfparam name="Attributes.formato" type="string" default="">
<cfparam name="Attributes.valor_minimo" type="string" default="0">
<cfparam name="Attributes.valor_maximo" type="string" default="0">
<cfparam name="Attributes.longitud" type="string" default="20">
<cfparam name="Attributes.escala" type="string" default="0">
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form --->

<cfoutput>
<cfswitch expression="#Attributes.tipo_dato#">
	<cfcase value="N">
		<cfset Attributes.value = Replace(Attributes.value,',','','all')>
		<cfif Attributes.value eq '' or not isNumeric(Attributes.value)><cfset Attributes.value = 0.00></cfif>
		<cf_monto name="#Attributes.name#" value="#Attributes.value#" size="#Attributes.longitud#">
	</cfcase>
	<cfcase value="F">
		<cfif Attributes.value eq '' or not isDate(Attributes.value)><cfset Attributes.value = Now()></cfif>
		<cf_sifcalendario name="#Attributes.name#" value="#LSDateFormat(Attributes.value,'dd/mm/yyyy')#" 
			form="#Attributes.form#">
	</cfcase>
	<cfcase value="B">
		<cfif Attributes.value eq '' or Not ListContains('1,0',Attributes.value)><cfset Attributes.value = 0></cfif>
		<input type="checkbox" name="#Attributes.name#" <cfif Attributes.value eq 1>checked</cfif>>
	</cfcase>
	<cfdefaultcase>
		<cfif Attributes.longitud LT 20>
			<cfset Attributes.longitud = 20>
		<cfelseif Attributes.longitud GT 60>
			<cfset Attributes.longitud = 60>
		</cfif>
		<input type="text" name="#Attributes.name#" value="#Attributes.value#" size="#Attributes.longitud#" maxlength="#Attributes.longitud#">
	</cfdefaultcase>
</cfswitch>
</cfoutput>