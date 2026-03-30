<cfset debug = false >

<cfif isdefined("url.btnContabilizar")>
	<cfset form.btnContabilizar = url.btnContabilizar>
</cfif>
<cfif isdefined("url.chk") and len(url.chk)>
	<cfset form.chk = url.chk>
</cfif>
<cfif isdefined("form.btnContabilizar") and isdefined("form.chk") and len(form.chk)>
	<cfset Arreglo = ListToArray(form.chk)>
	<cfloop from="1" to="#ArrayLen(Arreglo)#" index="idx">
		<cfinvoke  component="rh.Componentes.RH_ContabilizaNominaH" method="ContabilizaNominaH" returnvariable="data">
			<cfinvokeargument name="RCNid" value="#Arreglo[idx]#" />
			<cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#"/>
			<cfinvokeargument name="Usucodigo" value="#Session.Usucodigo#"/>
			<cfinvokeargument name="debug" value="false" />
		</cfinvoke>
		
		<cfif isdefined("data") and data.RecordCount gt 0 >
			<cfinclude template="PagoErrores.cfm">
			<cfabort>
		</cfif> 
	</cfloop>
</cfif>
<cflocation url="contabilizaNominaH.cfm">