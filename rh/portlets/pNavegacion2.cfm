<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Regresar"
	Default="Regresar"
	returnvariable="LB_Regresar"/> 
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/sif/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>	
	

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Autogestion"
	Default="Autogesti&oacute;n"
	XmlFile="/sif/rh/generales.xml"
	returnvariable="LB_Autogestion"/>		
	
<cfoutput>
<table width="100%" border="0" cellpadding="4" cellspacing="0" bgcolor="##DFDFDF">
  <tr align="left">
    <td nowrap>
		<cfif Session.Params.ModoDespliegue EQ 1>
		<a href="/cfmx/rh/index.cfm" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true; ">#LB_RecursosHumanos#</a>
		<cfelseif Session.Params.ModoDespliegue EQ 0>
		<a href="/cfmx/rh/autogestion/Menuautogestion.cfm" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true; ">#LB_Autogestion#</a>
		</cfif>
    </td>
    <td nowrap>|</td>
	<cfif isdefined("navBarItems")>
		<cfloop index="i" from="1" to="#ArrayLen(navBarItems)#">
			<td nowrap>
				<cfif navBarLinks[i] neq ""><a href="#navBarLinks[i]#" onMouseOver="javascript: window.status='#navBarStatusText[i]#'; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1"></cfif>
				#navBarItems[i]#
				<cfif navBarLinks[i] neq ""></a></cfif>
			</td>
			<td nowrap>|</td>
		</cfloop>
	</cfif>
    <td nowrap width="100%">
	<cfif isDefined("funcion")>
		<a href="javascript: #funcion#();" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true; ">#LB_Regresar#</a>
    <cfelseif isDefined("Regresar")>
		<a href="#Regresar#" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true; ">#LB_Regresar#</a>
    <cfelse>
		<cfif Session.Params.ModoDespliegue EQ 1>
			<a href="/cfmx/rh/index.cfm" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true; ">#LB_Regresar#</a>
		<cfelse>
			<a href="/cfmx/rh/autogestion/Menuautogestion.cfm" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true; ">#LB_Regresar#</a>
		</cfif>
    </cfif>
    </td>
  </tr>
</table>
</cfoutput>