<cfquery name="rsPeridoMes" datasource="#session.DSN#">
    select max(AFBDid) as AFBDid
    from AFBDepartamentos
    where CFid = 22
      and Ecodigo = 100
</cfquery>
<cfset LvarAFBDid = rsPeridoMes.AFBDid>

<cfif len(trim(LvarAFBDid)) eq 0>
es cero
</cfif>


<!--- <cf_dbfunction name="string_part"  args="b.Adescripcion,1,40" returnvariable= "DesActivo">
<cf_dbfunction name="string_part"  args="g.AFRdescripcion,1,15" returnvariable= "DesAFRetiroCuentas">
<cf_dbfunction name="concat"       args="'Gasto por Retiro por ';#PreserveSingleQuotes(DesAFRetiroCuentas)#; ' de ';#PreserveSingleQuotes(DesActivo)#" returnvariable= "INTDES10" delimiters=";"> 
<cf_dbfunction name="concat"       args="'Gasto por Retiro por ';#PreserveSingleQuotes(DesAFRetiroCuentas)#; ' de ';#PreserveSingleQuotes(DesActivo)#" returnvariable= "INTDES12" delimiters=";"> 
<cf_dbfunction name="concat"       args="'Ingreso por Retiro ';#PreserveSingleQuotes(DesAFRetiroCuentas)#; ' de ';#PreserveSingleQuotes(DesActivo)#" returnvariable= "INTDES13" delimiters=";"> 
<cfoutput>#INTDES10#</cfoutput><br />
<cfoutput>#INTDES12#</cfoutput><br />
<cfoutput>#INTDES13#</cfoutput>							 --->

<!--- 

<cf_dbfunction name="string_part"  args="b.Adescripcion,1,40" returnvariable= "DesActivo">
<cf_dbfunction name="string_part"  args="g.AFRdescripcion,1,15" returnvariable= "DesAFRetiroCuentas">
<cf_dbfunction name="concat"       args="'Gasto por Retiro por ';#PreserveSingleQuotes(DesAFRetiroCuentas)#; ' de ';#PreserveSingleQuotes(DesActivo)#" returnvariable= "INTDES10" delimiters=";"> 

<cfoutput>#INTDES10#</cfoutput> --->


<!--- <cfset Application.Politicas_PCuenta['sesion.multiple_203'] = 3>

<cfoutput>La variable ahora guarda: #Application.Politicas_PCuenta['sesion.multiple_203']#</cfoutput> --->