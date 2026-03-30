<cfif isdefined("Form.Cambio")>
  <cfset modo="CAMBIO">
  <cfelse>
  <cfif not isdefined("Form.modo")>
    <cfset modo="ALTA">
    <cfelseif Form.modo EQ "CAMBIO">
    <cfset modo="CAMBIO">
    <cfelse>
    <cfset modo="ALTA">
  </cfif>
</cfif>

<cfquery name="rsAnexo" datasource="#Session.DSN#">
	select 	<cf_dbfunction name="to_char" args="AnexoId"> as AnexoId, 
			AnexoDes, 
			AnexoUsu, 
			<cf_dbfunction name="to_date" args="AnexoFec"> as AnexoFec
	from Anexo
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	<cfif isdefined("Form.AnexoId") and AnexoId NEQ "">
		and AnexoId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AnexoId#">
	</cfif>
</cfquery>
<cf_dbfunction name="today" returnvariable= "hoy"> 
 <cfform method="post" name="form1" action="SQLAnexo.cfm">
    <table align="center">
    <tr valign="baseline"> 
      <td nowrap align="right">Descripción:</td>
	  <cfoutput>
      <td><input type="text" name="AnexoDes" value="<cfif modo nEQ 'ALTA'>#rsAnexo.AnexoDes#</cfif>" size="50" maxlength="100"></td>
	  </cfoutput>
    </tr>
    <tr valign="baseline"> 
      <td nowrap align="right">Fecha:</td>
      <td>
	  <cfinput type="text" name="AnexoFec" size="12" maxlength="12" required="yes" validate="eurodate" message="La fecha digitada no es válida!" 
	  value="#iif(modo EQ 'ALTA',DE(hoy),DE(DateFormat(rsAnexo.AnexoFec,'DD/MM/YYYY')))#">
		<a href="#" > <img src="/cfmx/sif/imagenes/DATE_D.gif" alt="Calendario" name="Calendar" width="16" height="14" border="0" onClick="javascript: showCalendar('document.form1.AnexoFec');"></a>		  
	  </td>
    </tr>
    <tr valign="baseline">
      <td colspan="2" align="right" nowrap><div align="center"><cfinclude template="/sif/portlets/pBotones.cfm"></div></td>
    </tr>
  </table>
  <cfoutput>
  <input type="hidden" name="AnexoId" value="<cfif modo neq "ALTA">#rsAnexo.AnexoId#</cfif>">
  </cfoutput>
</cfform>