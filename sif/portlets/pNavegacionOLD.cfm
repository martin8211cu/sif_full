<cfparam name="returnName" default="Regresar">
<cfif isdefined("Regresar")>
	<cfparam name="returnRef" default="#Regresar#">
<cfelseif isdefined("url.Regresar")>
	<cfparam name="returnRef" default="#url.Regresar#">
</cfif>
<cfoutput>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
<tr bgcolor="##A0BAD3"> <!--- bgcolor="##A0BAD3" --->
	<td><a href="/cfmx/home/menu/sistema.cfm?s=SIF">
		<font color="##000000" size="-1">
		&nbsp;Inicio&nbsp;
		</font>
		</a></td>
	<td><font color="##000000" size="-1">|</font></td>
	<td nowrap><a href="#ModuleRef#">
		<font color="##000000" size="-1">&nbsp;#ModuleName#&nbsp;</font>
	</a></td>
	<cfif isDefined("subModuleRef") and isDefined("subModuleName")>
	<td><font color="##000000" size="-1">|</font></td>
	<td nowrap><a href="#subModuleRef#">
		<font color="##000000" size="-1">&nbsp;#subModuleName#&nbsp;</font>
	</a></td>
	</cfif>
	<cfif isdefined("returnRef")>
	<td><font color="##000000" size="-1">|</font></td>
	<td><a href="#returnRef#">
		<font color="##000000" size="-1">&nbsp;#returnName#&nbsp;</font>
	</a>
	</cfif>
	</td>
	<td width="100%"><font color="##A0BAD3" size="+1">M</font></td>

	
</tr>
</table>
</cfoutput>