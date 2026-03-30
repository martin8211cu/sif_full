<cfset xx = QueryNew('Version')>
<cfset QueryAddRow(xx)><cfset QuerySetCell(xx,'Version','1.0')>
<cfset QueryAddRow(xx)><cfset QuerySetCell(xx,'Version','1.1.Z')>
<cfset QueryAddRow(xx)><cfset QuerySetCell(xx,'Version','1.9')>
<cfset QueryAddRow(xx)><cfset QuerySetCell(xx,'Version','2.4.k')>
<cfset QueryAddRow(xx)><cfset QuerySetCell(xx,'Version','no pistola')>
<cfset QueryAddRow(xx)>
<cfset QueryAddRow(xx)><cfset QuerySetCell(xx,'Version','4.x')>
<cfset QueryAddRow(xx)><cfset QuerySetCell(xx,'Version','5.0.1')>

<cfinvoke component="sif/Componentes/Workflow/utils" method="version_incrementa"
	VersionQuery = '#xx#' returnvariable="zz">
	
	<!--- <cfdump var="#zz#"> --->