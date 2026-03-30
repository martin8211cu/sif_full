<cfif not isdefined("Session.ImportarAsientos")>
	<cfset Session.ImportarAsientos = StructNew()>
</cfif>

<cfquery name="rsParametro" datasource="#session.DSN#">
	select Pvalor
    from Parametros
    where Ecodigo = #session.Ecodigo#
    and Pcodigo = 982
</cfquery>

<cfset LvarImportardor = 'CG_ASIENTOS'>
<cfif isdefined('rsParametro') and rsParametro.recordcount GT 0 and rsParametro.Pvalor EQ 1>
	<cfset LvarImportardor = 'CG_ASIENTOCF'>
</cfif>

<table width="100%" border="0" cellspacing="1" cellpadding="1">
  <tr>
	<td valign="top" width="60%">
		<cf_sifFormatoArchivoImpr EIcodigo = #LvarImportardor#>
	</td>
	<td align="center" style="padding-left: 15px " valign="top">
		<cf_sifimportar EIcodigo="#LvarImportardor#" mode="in" />
	</td>
  </tr>
  <tr><td colspan="3" align="center"><input type="button" name="Regresar" value="Regresar" onClick="javascript:location.href='DocContablesImportacion.cfm'"></td></tr>
  <tr><td colspan="3" align="center">&nbsp;</td></tr>
</table>
