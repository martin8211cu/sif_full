
<cfset arreglo = ListToArray(Form.CHK,",")>
<cfset CPTcodigo 	= "">
<cfset IDdocumento 	= "">
<cfset modulo = "CXP">

<cfloop from="1" to="#ArrayLen(arreglo)#" index="id">
	<cfset arreglo2 = ListToArray(#arreglo[id]#,"|")>
	<cfset CPTcodigo = Trim(arreglo2[2])>
	<cfset IDdocumento = Trim(arreglo2[1])>
		<cfinvoke 
			component="sif.Componentes.ReversionDocNoFact" 
			method="Reversion" 
				Modulo="#modulo#"
				debug="false"
				ReversarTotal="#Form.TIPO#"
				CPTcodigo="#CPTcodigo#"
				IDdocumento="#IDdocumento#"
		/> 
</cfloop>
<cflocation url="NoFac-lista.cfm">


