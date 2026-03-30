<cfinvoke component="cmMisFunciones" 
	returnvariable="rs" 
	method="fnVerMonedas">
	<!--- <cfinvokeargument name="id" value="2"> --->
</cfinvoke>

<table border="3">
	<tr>
		<td>
			<cfinvoke 
				 component="sif.Componentes.pListas"
				 method="pListaQuery"
				 returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rs#"/>
				<cfinvokeargument name="desplegar" value="Mnombre, Ecodigo, Msimbolo"/>
				<cfinvokeargument name="etiquetas" value="Nombre, Codigo, Simbolo"/>
				<cfinvokeargument name="formatos" value="A,A,A"/>
				<cfinvokeargument name="align" value="left, right, right"/>
				<cfinvokeargument name="ajustar" value="N,S,S"/>
				<cfinvokeargument name="irA" value="origen.cfm"/>
				<cfinvokeargument name="navegacion" value=""/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="keys" value="Ecodigo"/>
				<cfinvokeargument name="filtrar_por" value="Ecodigo"/>
				<cfinvokeargument name="mostrar_filtro" value="false"/>
			</cfinvoke>		
		</td>
	</tr>
</table>

<!---
<table width="40%">
	<tr bgcolor="#CCFFFF">
		<td width="50%"><strong>Nombre</strong></td>
		<td width="10%" align="right"><strong>Simbolo</strong></td>		
		<td width="10%" align="right"><strong>Codigo</strong></td>
	</tr>
	<cfloop query="rs">
		<tr>
			<td><a href="destino.cfm?id=<cfoutput>#rs.Ecodigo#</cfoutput>">
				<cfoutput>#rs.Mnombre#</cfoutput></a></td>
			<td align="right"><cfoutput>#rs.Msimbolo#</cfoutput></td>
			<td align="right"><cfoutput>#rs.Ecodigo#</cfoutput></td>
		</tr>
	</cfloop>
</table>

--->