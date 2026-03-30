<cfparam name="Attributes.cuentaorigen" type="string">
<cfparam name="Attributes.complemento" type="string">
<cfparam name="Attributes.returnvariable" type="string" default="">

<cfif Attributes.cuentaorigen neq "" and Attributes.complemento neq "">

	<!--- Toma la cuenta origen y busca por ocurrecias en donde hay _ (underscores) --->
	<cfset cuentaresultante = #Attributes.complemento#>
	<cfloop condition="(find('_',cuentaresultante,1) neq 0)">
			
		<cfset pos = find('_',cuentaresultante,1)>
		<cfset caracter = mid(Attributes.cuentaorigen,pos,1)>		
		<cfset cuentaresultante = mid(cuentaresultante,1,pos-1) & caracter & mid(cuentaresultante,pos+1,len(cuentaresultante))>

	</cfloop>

	<cfif cuentaresultante neq "">
		<cfset Caller[Attributes.returnvariable] = cuentaresultante>
	</cfif>
	
</cfif>