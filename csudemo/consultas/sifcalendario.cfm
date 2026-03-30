<!---
<script language="JavaScript" src="/cfmx/sif/js/utilesMonto.js"></script>
--->
<cfset def = QueryNew('fecha')>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" default="" type="String"> <!--- Nombre de la conexión --->
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

<cfparam name="Request.jsMask" default="false">

<cfif Request.jsMask EQ false>
	<script language="JavaScript" src="/cfmx/csudemo/consultas/js/calendar.js"></script>
	<script src="/cfmx/csudemo/consultas/js/MaskApi/masks.js"></script>
	<cfset Request.jsMask = true>
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
			id="#Attributes.name#" 
			<cfif Len(Trim(Attributes.tabindex)) GT 0> tabindex="#Attributes.tabindex#" </cfif>
			value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#LSDateFormat(Evaluate('#obj#'),'DD/MM/YYYY')#<cfelse>#Attributes.value#</cfif>"
			size="10"  
			maxlength="11"
			<cfif Len(Attributes.style)>style="#Attributes.style#"</cfif> >
			<cfif Attributes.image>			
				<a href="javascript:void(0)" tabindex="-1"> 	
					<img src="/cfmx/sif/imagenes/DATE_D.gif" alt="Calendario" name="Calendar#Attributes.name#" width="16" 
						height="14" border="0" 
						onClick="javascript: showCalendar('document.#Attributes.form#.#Evaluate('Attributes.name')#');">
				</a>
			</cfif>
			<script language="JavaScript1.2">
				oDateMask = new Mask("#Attributes.formato#", "date");
				oDateMask.attach(document.#Attributes.form#.#Attributes.name#,"#Attributes.formato#", "date", "#Attributes.OnBlur#", "", "", "#Attributes.OnChange#");
			</script>	  
		</td>
	</tr>
</table>
</cfoutput>