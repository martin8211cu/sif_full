<!---
<script language="JavaScript" src="/js/utilesMonto.js"></script>
--->
<cfset def = QueryNew('fecha')>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" default="#Session.DSN#" type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.name" default="fecha" type="string"> <!--- Nombre del campo de la fecha --->
<cfparam name="Attributes.value" default="" type="string"> <!--- valor por defecto --->
<cfparam name="Attributes.tabindex" default="" type="string"> <!--- número del tabindex --->
<cfparam name="Attributes.onBlur" default="" type="string"> <!--- función en el evento onBlur --->
<cfparam name="Attributes.onChange" default="" type="string"> <!--- función en el evento onChange --->
<cfparam name="Attributes.formato" default="dd/mm/yyyy" type="string"> <!--- función en el evento onBlur --->
<cfparam name="Attributes.valign" default="baseline" type="string"> <!--- valign--->
<cfparam name="Attributes.image" default="true" type="boolean"> <!--- Visualizar el image del calendario --->
<cfparam name="Attributes.style" default="" type="string">
<cfparam name="Attributes.enterAction" default="" type="string">
<cfparam name="Attributes.readOnly" default="false" type="boolean">

<cfparam name="Request.jsMask" default="false">

<cfif Request.jsMask EQ false>
	<cfset Request.jsMask = true>
	<script language="JavaScript" src="/js/calendar.js"></script>
	<script src="/js/MaskApi/masks.js"></script>
	<cfif NOT isdefined("request.scriptOnEnterKeyDefinition")><cf_onEnterKey></cfif>
</cfif>
<cfoutput>
<table width="" border="0" cellspacing="0" cellpadding="0">
	<tr valign="#Attributes.valign#"> 
      <td nowrap valign="#Attributes.valign#">
	  	<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
		  	<cfset obj = "Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.name')#')#')">
		</cfif>
		<input
			name="#Attributes.name#" type="text" title="#Attributes.formato#"
			<cfif Attributes.readOnly>
				tabindex="-1"
				readonly
				style="border:solid 1px ##CCCCCC; background:inherit;"
			</cfif>
			id="#Attributes.name#" 
			<cfif Len(Trim(Attributes.tabindex)) GT 0 and not Attributes.readOnly> tabindex="#Attributes.tabindex#" </cfif>
			value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#LSDateFormat(Evaluate('#obj#'),'DD/MM/YYYY')#<cfelse>#Attributes.value#</cfif>"
			size="10"  
			maxlength="11"
			<cfif Len(Attributes.style)>style="#Attributes.style#"</cfif> >
			<cfif Attributes.image and not Attributes.readOnly>
				<a href="javascript:void(0)" tabindex="-1" id="img_#Attributes.form#_#Attributes.name#"> 	
					<img src="/imagenes/DATE_D.gif" alt="Calendario" name="Calendar#Attributes.name#" width="16" 
						height="14" border="0" 
						onClick="javascript: document.#Attributes.form#.#Attributes.name#.focus(); showCalendar('document.#Attributes.form#.#Evaluate('Attributes.name')#');">
				</a>
			</cfif>
			<script language="JavaScript1.2">
				oDateMask = new Mask("#Attributes.formato#", "date");
				oDateMask.attach(document.#Attributes.form#.#Attributes.name#,"#Attributes.formato#", "date", "#Attributes.OnBlur#", "", "", "#Attributes.OnChange#", "#Attributes.enterAction#");
			</script>	  
		</td>
	</tr>
</table>
</cfoutput>