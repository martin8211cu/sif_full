<cfparam name="Attributes.tipo" default="1" type="numeric">
<cfparam name="Attributes.width" default="200" type="string">
<cfparam name="Attributes.alignTitle" default="left" type="string">
<cfparam name="Attributes.valignText" default="top" type="string">
<cfparam name="Attributes.alignText" default="left" type="string">
<cfparam name="Attributes.text" default="Texto" type="string">
<cfparam name="Attributes.color" default="black" type="string">
<cfparam name="Attributes.fontFamily" default="Georgia, 'Times New Roman', Times, serif" type="string">
<cfparam name="Attributes.fontSize" default="14px" type="string">
<cfparam name="Attributes.link" default="" type="string">
<cfparam name="Attributes.index" default="1" type="numeric">

<cfoutput>

	<cfif Attributes.tipo EQ 1>
		<cfset img = "/cfmx/sif/imagenes/menues/Gen_Opciones">
	<cfelseif Attributes.tipo EQ 2>
		<cfset img = "/cfmx/sif/imagenes/menues/Gen_Opciones2">
	<cfelseif Attributes.tipo EQ 3>
		<cfset img = "/cfmx/sif/imagenes/menues/Gen1_EstructuraOrg">
	</cfif>

	<style type="text/css">
	<!--
	.menuTitleStyle#Attributes.index# {
		color: #Attributes.color#;
		font-weight: bold;
		font-family: #Attributes.fontFamily#;
		font-size: #Attributes.fontSize#;
		background-image: url('#img#_cen.gif');
		<cfif Len(Trim(Attributes.link)) NEQ 0>
		cursor: pointer;
		</cfif>
	}
	
	.menuTitleStyle#Attributes.index#_2 {
		color: #Attributes.color#;
		font-weight: bold;
		font-family: #Attributes.fontFamily#;
		font-size: #Attributes.fontSize#;
		background-image: url('/cfmx/sif/imagenes/menues/Gen2_EstructuraOrg_cen.gif');
		<cfif Len(Trim(Attributes.link)) NEQ 0>
		cursor: pointer;
		</cfif>
	}
	-->
	</style>

	<cfif Attributes.tipo EQ 3>
		<script language="javascript" type="text/javascript">
			function changeStyle(i, mouserOverEvent) {
				var izq = document.getElementById("mt3izq"+i);
				var cen = document.getElementById("mt3cen"+i);
				var der = document.getElementById("mt3der"+i);
				if (mouserOverEvent) {
					if (izq) izq.src = '/cfmx/sif/imagenes/menues/Gen2_EstructuraOrg_izq.gif';
					if (cen) cen.className = 'menuTitleStyle#Attributes.index#_2';
					if (der) der.src = '/cfmx/sif/imagenes/menues/Gen2_EstructuraOrg_der.gif';
				} else {
					if (izq) izq.src = '#img#_izq.gif';
					if (cen) cen.className = 'menuTitleStyle#Attributes.index#';
					if (der) der.src = '#img#_der.gif';
				}
			}
		</script>
	</cfif>

	<table width="#Attributes.width#" border="0" cellpadding="0" cellspacing="0" align="#Attributes.alignTitle#">
	  <tr <cfif Len(Trim(Attributes.link)) NEQ 0>onClick="javascript: location.href = '#Trim(Attributes.link)#'; "</cfif> <cfif Attributes.tipo EQ 3>onMouseOver="javascript: changeStyle(#Attributes.index#, true);" onMouseOut="javascript: changeStyle(#Attributes.index#, false);"</cfif>>
		<td width="1" nowrap><img name="mt3izq#Attributes.index#" id="mt3izq#Attributes.index#" src="#img#_izq.gif"></td>
		<td name="mt3cen#Attributes.index#" id="mt3cen#Attributes.index#" class="menuTitleStyle#Attributes.index#" width="#Attributes.width#" background="#img#_cen.gif" valign="#Attributes.valignText#" align="#Attributes.alignText#"nowrap>&nbsp;#Attributes.text#&nbsp;</td>
		<td width="1" nowrap><img name="mt3der#Attributes.index#" id="mt3der#Attributes.index#" src="#img#_der.gif"></td>
	  </tr>
	</table>
</cfoutput>
