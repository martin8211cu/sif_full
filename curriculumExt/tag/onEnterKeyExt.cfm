<cfsilent>
<cfif ThisTag.ExecutionMode NEQ "START">
	<cfreturn>
</cfif>
<!---
	Autor Ing. Óscar Bonilla, MBA, 2-AGO-2006
	*
	* Modifica el comportamiento de la tecla <enter> en todos los campos de entrada de una pantalla,
	*	cambiando automáticamente la lógica de los eventos onKeyDown y onKeyPress.
	*
	* Una vez implementado, si se presiona la tecla <enter>:
	*	- NUNCA se ejecutará la lógica colocada en los eventos onKeyDown y onKeyPress, pero siempre se ejecutara onBlur.
	*		Pero en onBlur se puede preguntar por la variable global CF_onEnterKey que indica si se presionó o no el enter:
	*		- <input ... onblur="if (CF_onEnterKey) logica_para_enter; logica_para_blur;">
	*	- El comportamiento cambiado depende del enterAction de cada campo:
	*	  enterAction = coalesce(enterAction, enterActionDefault, asp..Preferencias.enterActionDefault, "submit")
	*		submit	= Fuerza el blur del objeto y devuelve el foco al objeto, 
	*				  luego busca el primerBotónSubmit y si existe lo ejecuta: 
	*						primerBotónSubmit.click();
	*		tab		= busca el siguienteObjeto y le pasa el foco: 
	*						siguienteObjeto.focus();
	*		none	= Fuerza el blur del objeto y devuelve el foco al objeto: 
	*						objeto.blur(); objeto.focus(); objeto.select();
	*
	*
	*
	* Utilización:
	* Ya está implementado en los siguientes tags, por lo que en la mayoría de las pantallas ya está implementado:
	*	<CF_template>, <CF_templateStart>, <CF_templateCSS>, <CF_qForms>, <CF_conlis>/<CF_IFramesStatus>, 
	*	<CF_inputNumber>/<CF_monto>, <CF_sifCalendario>, <CF_boton>, <CF_botones> 
	*	y en el Componente pListasEXT
	* Sólo es necesario utilizarlo:
	* 1. Si no se utilizan los tags/componentes nombrados. Si no se indica el enterActionDefault, utiliza el de Preferencias del Usuario
	*		<CF_onEnterAction [enterActionDefault="{submit,tab,none}"]>
	* 2. Si se desea cambiar el enterActionDefault de una pantalla particular,
	*	si se coloca varias veces en un mismo Request, el comportamiento default es el último indicado.
	*		<CF_onEnterAction enterActionDefault="{submit,tab,none}">
	* 3. Si se desea cambiar el comportamiento para un Campo en particular:
	*	 a. En los tags standares: <cf_inputNumber>, <cf_monto>, <cf_sifcalendario>, <cf_conlis>
	*			atributo enterAction = "{submit,tab,none}" cambiará el enterAction para el campo
	*	 b. En los tags html: <input>, <select>, etc...
	*			Sutituir los eventos onKeyDown y onKeyPress por <CF_onEnterKey enterAction="" onKeyDown="" onKeyPress="">
	*			atributo enterAction = {submit,tab,none} cambiará el enterAction para el campo:
	*				- ejempo 1:	<input ... <cf_onEnterKey enterAction="tab" 	onKeyDown="Logica_cuando_no_se_presiona_enter;" onKeyPress="Logica_cuando_no_se_presiona_enter;"> ...>
	*				- ejempo 2:	<input ... <cf_onEnterKey enterAction="submit" 	onKeyDown="Logica_cuando_no_se_presiona_enter;" onKeyPress="Logica_cuando_no_se_presiona_enter;"> ...>
	*
--->
<cfparam name="Attributes.enterActionDefault"		default="" 		type="string">	<!--- Inicializa el enterAction default del documento: submit, tab, none --->

<cfparam name="Attributes.enterAction"				default="" 		type="string">	<!--- Cambia el enterAction para un Input --->
<cfparam name="Attributes.onKeyDown"				default=":" 	type="string">	<!--- onKeyDown adicional --->
<cfparam name="Attributes.onKeyPress"				default=":" 	type="string">	<!--- onKeyPress adicional --->

<cfset Attributes.enterActionDefault = lcase(Attributes.enterActionDefault)>
<cfset Attributes.enterAction		 = lcase(Attributes.enterAction)>
<cfif Attributes.enterAction NEQ "" AND Attributes.enterActionDefault NEQ "">
	<cfthrow message="ERROR EN LA DEFINICION DEL CF_OnEnterKey: El atributo 'enterActionDefault' y 'enterAction' son excluyentes">
<cfelseif Attributes.enterActionDefault NEQ "" AND NOT listFind("submit,tab,none",Attributes.enterActionDefault)>
	<cfthrow message="ERROR EN LA DEFINICION DEL CF_OnEnterKey: El atributo 'enterActionDefault' solo permite: submit,tab,none">
<cfelseif Attributes.enterAction NEQ "" AND NOT listFind("submit,tab,none",Attributes.enterAction)>
	<cfthrow message="ERROR EN LA DEFINICION DEL CF_OnEnterKey: El atributo 'enterAction' solo permite: submit,tab,none">
<cfelseif Attributes.enterAction NEQ "" AND (Attributes.onKeyDown EQ ":" OR Attributes.onKeyPress EQ ":")>
	<cfthrow message="ERROR EN LA DEFINICION DEL CF_OnEnterKey: El atributo 'enterAction' requiere los atributos 'onKeyDown' y 'onKeyPress'">
</cfif>

</cfsilent>
<cfif Attributes.enterAction NEQ "">
	<cfif Attributes.onKeyDown  EQ "true"><cfset Attributes.onKeyDown  = ""></cfif>
	<cfif Attributes.onKeyPress EQ "true"><cfset Attributes.onKeyPress = ""></cfif>
	<cfoutput>
	onKeyDown	= "CF_onEnterAction = '#Attributes.enterAction#';#Attributes.onKeyDown#"
	onKeyPress	= "CF_onEnterAction = '#Attributes.enterAction#';#Attributes.onKeyPress#"
	</cfoutput>
	<cfreturn>
</cfif>
<cfif NOT isdefined("request.scriptOnEnterKeyDefinition")>
	<cfset request.scriptOnEnterKeyDefinition = true>
	<cfif Attributes.enterActionDefault EQ "">
		<cfparam name="session.sitio.enterActionDefault" default="submit">
		<cfset Attributes.enterActionDefault = session.sitio.enterActionDefault>
	</cfif>
	<cfoutput>
	<!-- Rutinas de Control del CF_onKeyEnter para el documento -->
	<input type="text" style="display:none;">
	<script language="javascript" type="text/javascript" src="/tag/utilesOnEnterKeyExt.js"></script>
	</cfoutput>
</cfif>
