<!---
<script language="JavaScript" src="/cfmx/sif/js/utilesMonto.js"></script>
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

<cfparam name="Request.jsMask" default="false">

<cfif Request.jsMask EQ false>
	<script language="JavaScript" src="/cfmx/sif/js/calendar.js"></script>
	<script src="/cfmx/sif/js/MaskApi/masks.js"></script>
	<script language="JavaScript1.2">
		function MaskTest(obj, v, m, e){
			var oMask = new Mask(m, "date");
			if (v.length > 0) {
				var n = oMask.format(v);
				if (oMask.error.length != 0) {
					alert(oMask.error);
					obj.value="";
					return false;
				}
			}
			return true;
		}
	</script>
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
			ONKEYUP="if(Key(event)==13) {this.blur();}"
			maxlength="11">
			<cfif Attributes.image>			
			<a href="##" tabindex="-1"> <img  id="#Attributes.name#IMG" src="/cfmx/sif/imagenes/DATE_D.gif" alt="Calendario" name="Calendar#Attributes.name#" width="16" height="14" border="0" onClick="javascript: showCalendar('document.#Attributes.form#.#Evaluate('Attributes.name')#');"></a>
			</cfif>
			<script language="JavaScript1.2">
				oDateMask = new Mask("#Attributes.formato#", "date");
				oDateMask.attach(document.#Attributes.form#.#Attributes.name#,"#Attributes.formato#", "date");
			</script>	  
			
		</td>
	</tr>
</table>
</cfoutput>
