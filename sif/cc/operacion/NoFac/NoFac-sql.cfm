<cfset arreglo = ListToArray(Form.CHK,",")>
<cfset CCTcodigo 	= "">
<cfset Ddocumento 	= "">
<cfset CCTCodigoRef = "">
<cfset modulo = "CXC">

<cfif len(trim(form.tipo)) EQ 0>
	<script language="javascript1.4" type="text/javascript">
		alert("Debe Seleccionar un tipo de Reversion para Ejecutar el Proceso");
	</script>
<cfelse>
	<cfloop from="1" to="#ArrayLen(arreglo)#" index="id">
		<cfset arreglo2 = ListToArray(#arreglo[id]#,"|")>
		<cfset CCTcodigo = Trim(arreglo2[1])>
		<cfset Ddocumento = Trim(arreglo2[2])>
		<cfset CCTCodigoRef = Trim(arreglo2[3])>
			<cfinvoke 
				component="sif.Componentes.ReversionDocNoFact" 
				method="Reversion" 
					Modulo="#modulo#"
					debug="false"
					ReversarTotal="#Form.TIPO#"
					CCTcodigo="#CCTcodigo#"
					CCTCodigoRef="#CCTCodigoRef#"
					Ddocumento="#Ddocumento#"
			/> 
	</cfloop>
</cfif>

<cflocation url="NoFac-lista.cfm">


