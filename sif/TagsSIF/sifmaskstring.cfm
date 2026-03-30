<!--- 
********************* TAG de Máscaras  String *****************************************
** Hecho por: Marcel de M.																**
** Fecha: 20 Mayo de 2003																**
** Este TAG crea un objeto de tipo TEXT que solicite un formato de máscara definido		**
******************************************************************************************
--->
<!---
<cfquery name="def" datasource="asp">
	select '' as fecha
</cfquery>
--->
<cfset def = QueryNew("fecha") >

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" default="#Session.DSN#" type="String"> <!--- Nombre de la conexión --->
<cfparam name="Attributes.form" default="form1" type="String"> <!--- Nombre del form --->
<cfparam name="Attributes.query" default="#def#" type="query"> <!--- consulta por defecto --->
<cfparam name="Attributes.name" default="fecha" type="string"> <!--- Nombre del campo de la fecha --->
<cfparam name="Attributes.value" default="" type="string"> <!--- valor por defecto --->
<cfparam name="Attributes.tabindex" default="" type="string"> <!--- número del tabindex --->
<cfparam name="Attributes.formato" default="" type="string"> <!--- función en el evento formato mascara --->
<cfparam name="Attributes.size" default="20" type="string"> <!--- tamaño del objeto --->
<cfparam name="Attributes.maxlength" default="20" type="string"> <!--- ancho del objeto --->
<cfparam name="Attributes.mostrarmascara" default="false" type="boolean"> <!--- ancho del objeto --->

<cfparam name="Request.jsMask" default="false">
<cfset Attributes.formato = replacenocase(Attributes.formato,"x","##","all")>

<cfif Request.jsMask EQ false>
	<script language="JavaScript" src="/cfmx/sif/js/calendar.js"></script>
	<script src="/cfmx/sif/js/MaskApi/masks.js"></script>
	<cfset Request.jsMask = true>
</cfif>

	<script language="JavaScript1.2">
		function MaskTest(obj,v, m, e){
			var oMask = new Mask(m, "string");
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

<cfoutput>
	<input 
		name="#Attributes.name#" type="text" title="#Attributes.formato#"
		id="#Attributes.name#" 
		<cfif Len(Trim(Attributes.tabindex)) GT 0> tabindex="#Attributes.tabindex#" </cfif>
		value="<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>#Attributes.query#.#Attributes.name#<cfelse>#Attributes.value#</cfif>" 
		size="#Attributes.size#" 
		maxlength="#Attributes.maxlength#">
		<cfif attributes.mostrarmascara >
		&nbsp;(#Attributes.formato#)
		</cfif>
		<script language="JavaScript1.2">
			document.#Attributes.form#.reset();
			oStringMask = new Mask("#Attributes.formato#", "string");
			oStringMask.attach(document.#Attributes.form#.#Attributes.name#,"#Attributes.formato#", "string");
		</script>	  
</cfoutput>