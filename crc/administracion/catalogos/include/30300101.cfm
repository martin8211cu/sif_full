<cfset objParams = createObject("component", "crc.Componentes.CRCParametros")>
<cfset val = objParams.GetParametroInfo('30300101')>

<cfset thisPath = ExpandPath("/crc/cobros/operacion/ImportarBancos/importadores/")>
<cfset thisDirectory = GetDirectoryFromPath(thisPath)>


<cfdirectory 
	action="list" 
	directory="#thisDirectory#" 
	recurse="false" 
	name="_components"
	filter="*.cfc"
	sort="Name"
>

<cfoutput>
	<select name="f_30300101">
		<option value=""> --Seleccione-- </option>
		<cfloop query="_components">
			<option value="#replace(_components.Name,'.cfc','','all')#"
					<cfif replace(_components.Name,'.cfc','','all') eq val.Valor> selected</cfif>	
			> 
				#replace(_components.Name,'.cfc','','all')# </option>
		</cfloop>
	</select>
</cfoutput>

