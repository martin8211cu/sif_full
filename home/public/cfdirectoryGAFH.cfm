<cfset rootdir = expandpath('')>
<cfset directorio = "#rootdir#/sif/cc/reportes">
<cfset directorio = replace(directorio, '\', '/', 'all') >
<cfdirectory action="list" directory="#directorio#" name="rsLista">
	
<cfset LvarCuerpoEmail = session.Ecodigo&'_'&'Estado_Cuenta_CuerpoEmail_gen'&'.cfm'>

<cfloop query="rsLista">
	<cfif findnocase(LvarCuerpoEmail, Name,1) GT 0>
    	Encontrado <cfoutput>#LvarCuerpoEmail#</cfoutput><br>
    <cfelse>
    	No encontrado <cfoutput>#LvarCuerpoEmail#</cfoutput><br>
	</cfif>
</cfloop>
 