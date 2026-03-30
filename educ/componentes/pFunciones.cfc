<cfcomponent>
	<cffunction name="fnOpcion" output="true" displayname="fnOpcion" hint="fnOpcion">
		<cfargument name="Titulo" type="string">
		<cfargument name="Pagina" type="string">
	<tr> 
		<cfif Titulo EQ "">
		<td colspan=2>&nbsp;
			
		</td>
		<cfelse>
		<td align="right" valign="middle" width="30">
			<a href="#Pagina#"><img src="/cfmx/educ/imagenes/menues/ftv4doc.gif" width="24" height="22" border="0"></a>
		</td>
		<td style="padding-right: 10px;" nowrap>
			<font size="2"><a href="#Pagina#">#Titulo#</a></font>
		</td>
	</cfif>
	</tr>
	</cffunction>
</cfcomponent>