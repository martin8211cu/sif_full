<cfsilent>
<cfif ThisTag.ExecutionMode NEQ "START">
	<cfreturn>
</cfif>
<!--- 
	Autor Ing. Óscar Bonilla, MBA, 2-AGO-2006
	*
	* Facilita la definición y automatiza los controles para los campos Input que sólo aceptan números
	* La mayor mejora sobre <CF_monto> es que el tamaño del campo y la cantidad de dígitos permitidos son independientes:
	*	CANTIDAD_DIGITOS = enteros + decimales
	* 	Si no se indica SIZE, el tamaño del campo se calcula automáticamente a partir de los otros atributos:
	*		SIZE = CANTIDAD_DIGITOS + punto_decimal(si dec>0) + cantitdad_comas(si COMAS=true) + signo_negativo(si NEGATIVOS=true)
	* Si se indica codigoNumerico="true" entonces se fuerza: 
	*	decimales = 0, negativos = false, comas = false y deja ceros a la izquierda
	* Si no se indica codigoNumerico entonces los negativos y comas se dejan a voluntad del programador
	* El atributo enterAction cambia el comportamiento del <enter> para el campo con respecto al enterActionDefault
	*
	* Nuevos atributos: readOnly, default, onFocus, onKeyDown
	*
	* Utilización: 
	*	<cf_inputNumber name="Codigo" value="00001" enteros="5"  codigoNumerico="yes">
	*	<cf_inputNumber name="Total"  value="45.45" enteros="15" decimales="2" negativos="false" comas="yes">
 --->
<cfset def = QueryNew('Aid')>
<cfparam name="Attributes.query" 			default="#def#" type="query">	<!--- Query con valor del Campo --->
<cfparam name="Attributes.form" 			default="form1" type="String">	<!--- Nombre del form --->
<cfparam name="Attributes.name" 			default="Numero" type="string">	<!--- Nombre del campo --->
<cfparam name="Attributes.value" 			default="" 		type="string">	<!--- Valor --->
<cfparam name="Attributes.default" 			default="" 		type="string">	<!--- Valor default cuando no se envía value ni query --->
<cfparam name="Attributes.readonly" 		default="false"	type="boolean">	<!--- Indica si se permite modificar el numero --->
<cfparam name="Attributes.modificable" 		default="#NOT Attributes.readonly#" 	
															type="boolean">	<!--- Indica si se permite modificar el numero --->
<cfparam name="Attributes.esHora" 			default="false"	type="boolean">	<!--- Tamaño del campo en pantalla --->
	
<cfif Attributes.esHora>
	<cfset LvarChrPto = ":">
	<cfset LvarEsHoraW = "width:3em;">
	<cfset Attributes.size 				= 4>
	<cfset Attributes.enteros 			= 2>
	<cfset Attributes.decimales 		= 2>
	<cfset Attributes.negativos 		= false>
	<cfset Attributes.comas 			= false>
	<cfset Attributes.codigoNumerico	= false>
<cfelse>
	<cfset LvarChrPto = ".">
	<cfset LvarEsHoraW = "">
	<cfparam name="Attributes.size" 			default="-1"	type="numeric">	<!--- Tamaño del campo en pantalla --->
	<cfparam name="Attributes.enteros" 			default="-1"	type="numeric">	<!--- Cantidad de enteros del Monto --->
	<cfparam name="Attributes.decimales" 		default="0" 	type="numeric">	<!--- Cantidad de decimales del Monto, puede ser 0 --->
	<cfparam name="Attributes.negativos" 		default="false"	type="boolean">	<!--- Permite Negativos --->
	<cfparam name="Attributes.comas" 			default="true"	type="boolean"> <!--- Formatear con Comas (separador de miles) --->
	<cfparam name="Attributes.codigoNumerico"	default="false" type="boolean"> <!--- Deja ceros a la izq, decimales = 0, negativos = false y comas = false --->
</cfif>
<cfparam name="Attributes.formatValue" 		default="true" 	type="boolean">	<!--- Valida y formatea attribute.value, se pone en NO cuando no se tiene el value todavía --->
<cfparam name="Attributes.class" 			default="" 		type="string">	<!--- class asociado a la caja de texto --->
<cfparam name="Attributes.style" 			default="" 		type="string">	<!--- style asociado a la caja de texto --->
<cfparam name="Attributes.tabIndex" 		default="" 		type="string">	<!--- Número del tabindex --->

<cfparam name="Attributes.onFocus" 			default="" 		type="string"> 
<cfparam name="Attributes.onKeydown" 		default="" 		type="string"> 
<cfparam name="Attributes.onChange" 		default="" 		type="string"> 
<cfparam name="Attributes.onBlur" 			default="" 		type="string"> 
<cfparam name="Attributes.onmouseout"		default="" 		type="string"> 


<cfparam name="Attributes.tagName" 			default="CF_inputNumber"	type="string"> 

<cfparam name="Attributes.enterAction" 		default="" 		type="string">	<!--- Cambia el enterAction default del cf_onEnter: submit, tab, none --->
<cfparam name="Attributes.obligatorio"  	default="0"				type="string"><!--- el campo es obligatorio dentro del formulario (integracion parsley)--->

<cfset Attributes.enterAction = lcase(Attributes.enterAction)>
<cfif Attributes.enterAction NEQ "" AND NOT listFind("submit,tab,enter",Attributes.enterAction)>
	<cf_errorCode	code = "50686"
					msg  = "ERROR EN LA DEFINICION DEL @errorDat_1@: El atributo ENTERACTION solo puede cambiarse a: submit, tab, none. '@errorDat_2@' incorrecto."
					errorDat_1="#Attributes.tagName#"
					errorDat_2="#Attributes.enterAction#"
	>
</cfif>

<cfif Attributes.enteros EQ -1 AND Attributes.size NEQ -1>
	<cf_errorCode	code = "50687"
					msg  = "ERROR EN LA DEFINICION DEL @errorDat_1@: El atributo SIZE no es suficiente, debe utilizar ENTEROS"
					errorDat_1="#Attributes.tagName#"
	>
<cfelseif Attributes.enteros EQ -1>
	<cfset Attributes.enteros = 10>
</cfif>

<cfif isdefined("Attributes.onKeyUp") or isdefined("Attributes.onKeyPress")>
	<cf_errorCode	code = "50688"
					msg  = "ERROR EN LA DEFINICION DEL @errorDat_1@: No se permiten los eventos ONKEYPRESS ni ONKEYUP, puede utilizar ONKEYDOWN"
					errorDat_1="#Attributes.tagName#"
	>
</cfif>

<cfif Attributes.codigoNumerico>
	<cfset Attributes.decimales = 0>
	<cfset Attributes.negativos = false>
	<cfset Attributes.comas		= false>
	<cfset LvarJScodigoNumerico = "true">
<cfelse>
	<cfset LvarJScodigoNumerico = "false">
</cfif>

<cfif Attributes.enteros EQ 0>
	<cfset Attributes.enteros = 1>
</cfif>
<cfset LvarSize = Attributes.enteros + Attributes.decimales>
<cfif Attributes.decimales GT 0>
	<cfset LvarSize = LvarSize + 1>
<cfelse>
</cfif>
<cfif Attributes.comas>
	<cfset LvarSize = LvarSize + int((Attributes.enteros-1)/3)>
</cfif>
<cfif Attributes.negativos>
	<cfset LvarSize = LvarSize + 1>
</cfif>

<cfif Attributes.comas>
	<cfset LvarJScomas = "true">
<cfelse>
	<cfset LvarJScomas = "false">
</cfif>
<cfif Attributes.negativos>
	<cfset LvarJSnegativos = "true">
<cfelse>
	<cfset LvarJSnegativos = "false">
</cfif>

<cfif Attributes.decimales lt 0 or Attributes.decimales gt 15>
	<cf_errorCode	code = "50689"
					msg  = "ERROR EN LA DEFINICION DEL @errorDat_1@: No se permite menos de 0 decimales o mas que 15 decimales."
					errorDat_1="#Attributes.tagName#"
	>
</cfif>

<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
	<cfset LvarValue = trim(Evaluate("Attributes.query.#Attributes.name#"))>
<cfelse>
	<cfset LvarValue = trim(Attributes.value)>
</cfif>					
<cfif not isNumeric(Attributes.default)>
	<cfset Attributes.default = "">
</cfif>

<cfif not Attributes.formatValue>
	<cfset LvarValue = LvarValue>
<cfelseif not isNumeric(LvarValue)>
	<cfset LvarValue = Attributes.default>
<cfelseif Attributes.codigoNumerico>
	<cfset LvarValue = LvarValue>
<cfelseif isNumeric(LvarValue)>
	<cfif Attributes.decimales EQ 0>
		<cfset LvarFmt = "0">
	<cfelse>
		<cfset LvarFmt = "0.#RepeatString('0',Attributes.decimales)#">
	</cfif>
	<cfif Attributes.comas>
		<cfset LvarFmt = ",#LvarFmt#">
	</cfif>
	<cfset LvarValue = LSNumberFormat(LvarValue,LvarFmt)>
</cfif>
<cfset Attributes.name = trim(Attributes.name)>
</cfsilent>
<cffunction name="sbOnEnterKey" output="true" access="private">
	<cfif not isdefined("request.scriptOnEnterKeyDefinition")><cf_onEnterKey></cfif>
</cffunction>
<cfoutput>

<cfif not isdefined("request.scriptMontoDefinition")>
	<script language="javascript" type="text/javascript">
		function setReadOnly_inputNumber(pform, pname, pReadOnly)
		{
			if (pReadOnly)
			{
				document.forms[pform][pname].tabIndex 			= "-1";
				document.forms[pform][pname].readOnly			= true;
				document.forms[pform][pname].style.border		= "solid 1px ##CCCCCC";
				document.forms[pform][pname].style.backGround	= "inherit";
			}
			else
			{
				document.forms[pform][pname].tabIndex 			= "#Attributes.tabindex#";
				document.forms[pform][pname].readOnly			= false;
				document.forms[pform][pname].style.border		= "inset 2px ##CCCCCC";
				document.forms[pform][pname].style.backGround	= "";
			}
		}
	</script>
</cfif>

<cfscript>
	if (Attributes.esHora)
		LvarValue = replace(LvarValue,".",":","ALL");
	if (not isdefined("request.scriptMontoDefinition")) 
	{
		fnWriteLN('<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>');
		request.scriptMontoDefinition = 1;
		if (not isdefined("request.scriptOnEnterKeyDefinition")) 
		{
			sbOnEnterKey();
		}
	}
	fnWriteLN(		'	<!-- #Attributes.tagName#: "#Attributes.name#" -->' & chr(13));
	fnWriteLN(		'	<input	type		= "text"');
	fnWriteLN(		'		name		= "#Attributes.name#" id="#Attributes.name#"');
	fnWriteLN(		'		value		= "#LvarValue#"');
	if (len(Attributes.class))
	{
		fnWriteLN(	'		class		= "#Attributes.class#"');
	}
	if (not Attributes.modificable)
	{
		fnWriteLN(	'		readonly');
		Attributes.tabIndex	= "-1";
		if (len(trim(Attributes.style)) eq 0) 
		{
			Attributes.style	= "border:solid 1px ##CCCCCC; background:inherit;#Attributes.style#";
		}
	}
	fnWriteLN(		'		style		= "text-align:right;#LvarEsHoraW##Attributes.style#"');
	if (Len(Trim(Attributes.tabIndex)) GT 0)
	{
		fnWriteLN(	'		tabindex	= "#Attributes.tabIndex#"');
	}
	fnWriteLN(		'		onfocus		= "this.value=qf(this); this.select();#Attributes.onfocus#"');

	if (Attributes.enterAction EQ "")
	{
		LvarEnterAction = "";
	}
	else
	{
		LvarEnterAction = "CF_onEnterAction = ''#Attributes.enterAction#''; ";
		Attributes.onkeydown = "#LvarEnterAction#" & Attributes.onkeydown;
	}
	if (len(Attributes.onkeydown))
	{
		fnWriteLN(	'		onkeydown	= "#Attributes.onkeydown#"');
	}

	fnWriteLN(		'		onkeypress	= "#LvarEnterAction#return _CFinputText_onKeyPress(this,event,#Attributes.enteros#,#Attributes.decimales#,#LvarJSnegativos#,#LvarJScomas#,''#LvarChrPto#'');"');
	fnWriteLN(		'		onkeyup		= "_CFinputText_onKeyUp(this,event,#Attributes.enteros#,#Attributes.decimales#,#LvarJSnegativos#,#LvarJScomas#,''#LvarChrPto#'');"');
	fnWriteLN(		'		onblur		= "fm(this,#Attributes.decimales#,#LvarJScomas#,#LvarJScodigoNumerico#,''#Attributes.default#'',''#LvarChrPto#''); if (window.func#Attributes.name#) window.func#Attributes.name#();#Attributes.onBlur#"');
	
	if (len(Attributes.onChange))
	{
		fnWriteLN(	'		onChange	= "#Attributes.onChange#"');
	}
	if (len(Attributes.onmouseout))
	{
		fnWriteLN(	'		onmouseout	= "#Attributes.onmouseout#"');
	}
	
	if (Attributes.size LTE 0)
	{
		Attributes.size = LvarSize;
		if (not Attributes.comas and Attributes.decimales EQ 0)
		{
			Attributes.size = Attributes.size + 1;
		}
	}
	fnWriteLN(		'		size		= "#Attributes.size#"');
	fnWriteLN(		'		maxlength	= "#LvarSize+1#"');
	fnWriteLN(		'		obligatorio = "#Attributes.obligatorio#"');
	fnWriteLN(		'	>');
	
	function fnWriteLN(x)
	{
		writeOutput(x & "
");
	}
</cfscript>
</cfoutput>


