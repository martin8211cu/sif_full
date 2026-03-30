<!--- Pinta un Botón con efecto onMouseOver, onMouseOut, y con funcionalidad en onClick --->
<cfparam name="Attributes.texto" type="string" default=""><!--- Texto del boton. --->
<cfparam name="Attributes.index" type="string" default=""><!--- Index del botón, requerido si pinta más de un botón en la misma pantalla. --->
<cfparam name="Attributes.size" type="string" default="0">
<cfparam name="Attributes.doevents" type="boolean" default="true"><!--- Realizar eventos, realizar los eventos onMouseOver y onMouseOut. --->
<!--- Link o Funcion, si se define link y función se ejectua solo el link --->
<cfparam name="Attributes.link" type="string" default="">
<cfparam name="Attributes.funcion" type="string" default="">
<!--- Estilos, para ver los estilo disponibles, ver la sección de estilos --->
<cfparam name="Attributes.estilo" type="numeric" default="1">
<!--- Parámetros por defecto de las imágenes, si se utiliza un estilo se actualizan estos parámetros, si se definen estos parámetros y estilo, se utiliza solo el estilo. --->
<cfparam name="Attributes.td_image_1" type="string" default="boton1a_r1_c1.gif|boton1a_r1_c1.gif|27|23"><!--- td1:nombre_imagen|nombre_imagen_onMouseOut|width|height --->
<cfparam name="Attributes.td_image_2" type="string" default="boton1a_r1_c2.gif|boton1a_r1_c2.gif|0|23|top|Tahoma|14|##608686|bold"><!--- td2:nombre_imagen|nombre_imagen_onMouseOut|width|height|valign|font|size|color|weight --->
<cfparam name="Attributes.td_image_3" type="string" default="boton1a_r1_c3.gif|boton1a_r1_c3.gif|23|23"><!--- td3:nombre_imagen|nombre_imagen_onMouseOut|width|height --->
<!--- Estilos --->
<!--- Estilo 1: Por defecto, verde grande, oscuro, si eventos.--->
<!--- Estilo 2: Verde pequeño, claro.--->
<cfswitch expression="#Attributes.estilo#">
	<cfcase value="2">
		<cfset Attributes.td_image_1="boton2a_r1_c1.gif|boton2a_r2_c1.gif|20|25">
		<cfset Attributes.td_image_2="boton2a_r1_c2.gif|boton2a_r2_c2.gif|0|25|middle|Tahoma|12|##00544A|normal">
		<cfset Attributes.td_image_3="boton2a_r1_c3.gif|boton2a_r2_c3.gif|15|25">
	</cfcase>
	<!--- Estilo 3: Azul grande, oscuro, si eventos. --->
	<cfcase value="3">
		<cfset Attributes.td_image_1="boton3a_r1_c1.gif|boton3a_r1_c1.gif|21|23">
		<cfset Attributes.td_image_2="boton3a_r1_c2.gif|boton3a_r1_c2.gif|0|23|top|Tahoma|14|##C8D9DF|bold">
		<cfset Attributes.td_image_3="boton3a_r1_c3.gif|boton3a_r1_c3.gif|21|23">
	</cfcase>
	<!--- Estilo 4: Azul pequeño, claro. --->
	<cfcase value="4">
		<cfset Attributes.td_image_1="boton4a_r1_c1.gif|boton4a_r2_c1.gif|33|25">
		<cfset Attributes.td_image_2="boton4a_r1_c2.gif|boton4a_r2_c2.gif|0|25|middle|Tahoma|12|##83909C|normal">
		<cfset Attributes.td_image_3="boton4a_r1_c3.gif|boton4a_r2_c3.gif|20|25">
	</cfcase>
	<!--- Estilo 5: Azul mas pequeño, claro. --->
	<cfcase value="5">
		<cfset Attributes.td_image_1="boton5a_r1_c1.gif|boton5a_r2_c1.gif|21|16">
		<cfset Attributes.td_image_2="boton5a_r1_c2.gif|boton5a_r2_c2.gif|0|16|middle|Tahoma|9|##02698F|normal">
		<cfset Attributes.td_image_3="boton5a_r1_c3.gif|boton5a_r2_c3.gif|12|16">
	</cfcase>
	<!--- Estilo 6: Verde mas pequeño, claro. --->
	<cfcase value="6">
		<cfset Attributes.td_image_1="boton6a_r1_c1.gif|boton6a_r2_c1.gif|21|16">
		<cfset Attributes.td_image_2="boton6a_r1_c2.gif|boton6a_r2_c2.gif|0|16|middle|Tahoma|9|##02698F|normal">
		<cfset Attributes.td_image_3="boton6a_r1_c3.gif|boton6a_r2_c3.gif|13|16">
	</cfcase>
	<!--- Estilo 7: Gris grande, claro, si eventos. --->
	<cfcase value="7">
		<cfset Attributes.td_image_1="boton7a_r1_c1.gif|boton7a_r1_c1.gif|21|23">
		<cfset Attributes.td_image_2="boton7a_r1_c2.gif|boton7a_r1_c2.gif|0|23|top|Tahoma|14|##999999|bold">
		<cfset Attributes.td_image_3="boton7a_r1_c3.gif|boton7a_r1_c3.gif|21|23">
	</cfcase>
	<!--- Estilo 8: Gris pequeño, claro. --->
	<cfcase value="8">
		<cfset Attributes.td_image_1="boton8a_r1_c1.gif|boton8a_r2_c1.gif|32|25">
		<cfset Attributes.td_image_2="boton8a_r1_c2.gif|boton8a_r2_c2.gif|0|25|middle|Tahoma|12|##999999|normal">
		<cfset Attributes.td_image_3="boton8a_r1_c3.gif|boton8a_r2_c3.gif|17|25">
	</cfcase>
	<!--- Estilo 9: Gris mas pequeño, claro. --->
	<cfcase value="9">
		<cfset Attributes.td_image_1="boton9a_r1_c1.gif|boton9a_r2_c1.gif|20|16">
		<cfset Attributes.td_image_2="boton9a_r1_c2.gif|boton9a_r2_c2.gif|0|16|middle|Tahoma|9|##999999|normal">
		<cfset Attributes.td_image_3="boton9a_r1_c3.gif|boton9a_r2_c3.gif|9|16">
	</cfcase>
	<!--- Estilo 10: Morado mas pequeño, oscuro. --->
	<cfcase value="10">
		<cfset Attributes.td_image_1="boton10a_r1_c1.gif|boton10a_r1_c1.gif|10|16">
		<cfset Attributes.td_image_2="boton10a_r1_c2.gif|boton10a_r1_c2.gif|0|16|middle|Tahoma|9|##FFFFFF|normal">
		<cfset Attributes.td_image_3="boton10a_r1_c3.gif|boton10a_r1_c3.gif|10|16">
	</cfcase>
</cfswitch>
<!--- ***INICIO*** --->
<cfset x = ListToArray(Attributes.td_image_1,'|')>
<cfset y = ListToArray(Attributes.td_image_2,'|')>
<cfset z = ListToArray(Attributes.td_image_3,'|')>
<script language="javascript" type="text/javascript">
	function cf_boton_preloadImages<cfoutput>#Attributes.index#</cfoutput>() { //v3.0
	  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
		var i,j=d.MM_p.length,a=cf_boton_preloadImages<cfoutput>#Attributes.index#</cfoutput>.arguments; for(i=0; i<a.length; i++)
		if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
	}
	<cfoutput>
	function cf_boton_mouseover#Attributes.index#(){
		<cfif Attributes.doevents>
		document.getElementById("td_boton_1#Attributes.index#").src="/cfmx/home/public/imagen.cfm?f=/sif/imagenes/cf_boton/#x[2]#";
		document.getElementById("td_boton_2#Attributes.index#").className="styletd_boton_2#Attributes.index#mouseover";
		document.getElementById("td_boton_3#Attributes.index#").src="/cfmx/home/public/imagen.cfm?f=/sif/imagenes/cf_boton/#z[2]#";
		</cfif>
	}
	function cf_boton_mouseout#Attributes.index#(){
		<cfif Attributes.doevents>
		document.getElementById("td_boton_1#Attributes.index#").src="/cfmx/home/public/imagen.cfm?f=/sif/imagenes/cf_boton/#x[1]#";
		document.getElementById("td_boton_2#Attributes.index#").className="styletd_boton_2#Attributes.index#mouseout";
		document.getElementById("td_boton_3#Attributes.index#").src="/cfmx/home/public/imagen.cfm?f=/sif/imagenes/cf_boton/#z[1]#";
		</cfif>
	}
	function cf_boton_click#Attributes.index#(){
		<cfif len(trim(Attributes.link)) gt 0>
		location.href="#Attributes.link#";
		<cfelseif len(trim(Attributes.funcion)) gt 0>
		#Attributes.funcion#;
		</cfif>
	}
	</cfoutput>
</script>
<cfoutput>
<style type="text/css">
	.styletd_boton_2#Attributes.index#mouseover{background-image:url("/cfmx/home/public/imagen.cfm?f=/sif/imagenes/cf_boton/#y[2]#"); }
	.styletd_boton_2#Attributes.index#mouseout{background-image:url("/cfmx/home/public/imagen.cfm?f=/sif/imagenes/cf_boton/#y[1]#"); }
</style>
<table border="0" cellspacing="0" cellpadding="0"<cfif Attributes.size NEQ '0'>  width="#Attributes.size#"</cfif>>
  <tr <cfif Attributes.doevents> style="cursor:pointer" </cfif> onMouseOver="javascript:cf_boton_mouseover#Attributes.index#();" onMouseOut="javascript:cf_boton_mouseout#Attributes.index#();" onClick="javascript:cf_boton_click#Attributes.index#();">
    <td width="1%"><img id="td_boton_1#Attributes.index#" src="/cfmx/home/public/imagen.cfm?f=/sif/imagenes/cf_boton/#x[1]#" width="#x[3]#" height="#x[4]#"></td>
    <td name="td_boton_2#Attributes.index#" id="td_boton_2#Attributes.index#" class="styletd_boton_2#Attributes.index#mouseout" height="#y[4]#" valign="#y[5]#"><font style="font-family:#y[6]#; font-size:#y[7]#px; color:#y[8]#; font-weight:#y[9]#">#Attributes.texto#</font></td>
    <td width="1%"><img id="td_boton_3#Attributes.index#" src="/cfmx/home/public/imagen.cfm?f=/sif/imagenes/cf_boton/#z[1]#" width="#z[3]#" height="#z[4]#"></td>
  </tr>
</table>
<script language="javascript" type="text/javascript">
	//cf_boton_preloadImages#Attributes.index#('/cfmx/home/public/imagen.cfm?f=/sif/imagenes/cf_boton/#x[1]#','/cfmx/home/public/imagen.cfm?f=/sif/imagenes/cf_boton/#x[2]#','/cfmx/home/public/imagen.cfm?f=/sif/imagenes/cf_boton/#y[1]#','/cfmx/home/public/imagen.cfm?f=/sif/imagenes/cf_boton/#y[2]#','/cfmx/home/public/imagen.cfm?f=/sif/imagenes/cf_boton/#z[1]#','/cfmx/home/public/imagen.cfm?f=/sif/imagenes/cf_boton/#z[2]#');
</script>
<cfif not isdefined("request.scriptOnEnterKeyDefinition")><cf_onEnterKey></cfif>
</cfoutput>
<!--- ***FIN*** --->