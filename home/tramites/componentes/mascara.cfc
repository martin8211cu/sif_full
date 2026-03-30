<cfcomponent>
<!---
		Definiciones
		Mascara:
			Es una mascara a como la captura el usuario
			Los caracteres validas son 0-9, que representan
			cualquier número, 'X' para indicar alfanumericos
			y los signos se toman textualmente
		regex:
			Expresion regular para javascript
		RE:
			Expresion regular para coldfusion
	--->
<cffunction name="mascara2regex" access="public" returntype="string" output="false">
  <cfargument name="mascara" type="string" required="yes">
  <cfset var ret = Trim(Arguments.mascara)>
  <cfset ret = Replace(ret, '[', '\[', 'all')>
  <cfset ret = REReplace(ret, '[0-9]', '\d', 'all')>
  <cfset ret = REReplace(ret, '[A-Z]', '[A-Za-z0-9]', 'all')>
  <cfif Len(ret) EQ 0>
    <cfset ret='.+'>
  </cfif>
  <cfset ret = '^' & ret & '$'>
  <cfreturn ret>
</cffunction>
</cfcomponent>
