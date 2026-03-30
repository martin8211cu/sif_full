<!--- =============================== --->
<!--- TRADUCCION --->
<!--- =============================== --->
<!--- TABS --->
    <cfinvoke component="sif.Componentes.Translate"
        method="Translate"
        key="LB_Cargas"
        Default="Cargas"
        returnvariable="LB_Cargas"/>  
        
   <cfinvoke component="sif.Componentes.Translate"
        method="Translate"
        key="LB_Salarios"
        Default="Salarios"
        returnvariable="LB_Salarios"/>
        
  <cfinvoke component="sif.Componentes.Translate"
        method="Translate"
        key="LB_Incidencias"
        Default="Incidencias"
        returnvariable="LB_Incidencias"/>  	
        
<cfset tabChoice = 1>

<cfif isdefined("Url.o") and not isdefined("Form.o")>
	<cfset Form.o = Url.o>
</cfif>

<cfif isdefined("Form.o")>
	<cfset tabChoice = Val(Form.o)>
<cfelse>
	<cfset tabChoice = 1>
</cfif>

<cfset tabNames = ArrayNew(1)>
<cfset tabNames[1] = "#LB_Salarios#">
<cfset tabNames[2] = "#LB_Incidencias#">
<cfset tabNames[3] = "#LB_Cargas#">


<cfset tabLinks = ArrayNew(1)>
<cfset tabLinks[1] = "distribucion.cfm?o=1&sel=1">
<cfset tabLinks[2] = "distribucion.cfm?o=2&sel=1">
<cfset tabLinks[3] = "distribucion.cfm?o=3&sel=1">


<cfset tabStatusText = ArrayNew(1)>
<cfset tabStatusText[1] = "">
<cfset tabStatusText[2] = "">
<cfset tabStatusText[3] = "">


<!---
validar la seguridad
--->
<cfset tabAccess = ArrayNew(1)>
<cfset proceso = Trim(Replace(cgi.SCRIPT_NAME,'/cfmx','','one')) >
<cfset tabAccess[1] = true>
<cfset tabAccess[2] = true>
<cfset tabAccess[3] = true>

<cfif not tabAccess[tabChoice]>
	<cfloop from="1" to="#ArrayLen(tabAccess)#" index="i">
		<cfif tabAccess[i]>
			<cfset tabChoice = i>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>