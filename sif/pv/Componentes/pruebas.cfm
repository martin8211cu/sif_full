<cfinvoke 
		component="sif.pv.Componentes.pv_FA_Trae_Valores_Cierre"
		method="Cierre" returnvariable="rs">
		<cfinvokeargument name="FAM01COD" value="1"/> 
		
</cfinvoke>

<!--- <cfdump var="#rs#"> --->

<!--- 
<cfinvoke 
		component="sif.pv.Componentes.pv_FA_Trae_Valores_Cierre"
		method="Cierre" returnvariable="rs2">
		<cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#"/>
		<cfinvokeargument name="Ocodigo" value="0"/> 

</cfinvoke>

<cfdump var="#rs2#">
 --->
