<cfparam name="navegacion" type="array">
<cfoutput>
<table class="navbar" width="100%" ><tr>
	<td nowrap align="left"><a tabindex="-1" href="/cfmx/home/index.cfm">Inicio</a> &gt; 
	
	<cfloop from="1" to="#ArrayLen(navegacion)#" index="i">
	<cfif i gt 1> &gt; </cfif>
	 
	<a tabindex="-1" href="#HTMLEditFormat(ListFirst(navegacion[i]))#">#HTMLEditFormat(ListRest(navegacion[i]))#</a>
	</cfloop>
	</td>	
	
	<td nowrap align="right"><a tabindex="-1" href="/cfmx/home/menu/passch.cfm">Cambiar contrase&ntilde;a </a> 
	|
	<a tabindex="-1" href="/cfmx/home/public/logout.cfm">Salir</a></td>
</tr>
</table></cfoutput>