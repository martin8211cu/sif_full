<cfparam name="Attributes.text">
<cfparam name="Attributes.type" default="information">

<cfset typelist = 'error,fatal,information,warning'>
<cfset colorlist = 'red,red,green,yellow'>
<cfset typeindex = ListFind(typelist, Attributes.type)>
<cfif typeindex is 0>
	<cfthrow message="Atributo type inválido.  Debe ser uno de #typelist#">
</cfif>
<cfoutput>
	<cfset myuuid = CreateUUID()>
	<div style="text-align:center;background-color:#ListGetAt(colorlist,typeindex)#;padding:4px" id="#HTMLEditFormat(myuuid)#">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr><td align="left"><td align="center" style="text-align:center;color:white;font-weight:bold;">
	# HTMLEditFormat(Attributes.text) #</td><td align="right" style="color:white;cursor:pointer;" onclick="document.getElementById('#HTMLEditFormat(myuuid)#').style.display='none';"><strong>x</strong></td>
	</table>
	</div>
</cfoutput>