<cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")>
<cfsavecontent variable="formula">
	x=2;
	y=10
	total = x*y;
</cfsavecontent>

<cfset values     = RH_Calculadora.calculate(formula)>
<cfset calc_error = RH_Calculadora.getCalc_error()>
<cfif Not IsDefined("values")>
	<cfif isdefined("presets_text")>
		<cfoutput>dio este error: #calc_error# </cfoutput>
		>
	<cfelse>
		<cf_throw message="#calc_error#" >
	</cfif>
</cfif>
<cfdump var="#values.get('total')#"/>
<cfoutput>#values.get('total').toString()#</cfoutput>
