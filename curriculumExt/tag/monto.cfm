<cfsilent>
<cfif ThisTag.ExecutionMode NEQ "START">
	<cfreturn>
</cfif>
<!---
	Autor Ing. Óscar Bonilla, MBA, 2-AGO-2006
	*
	* Implementa la utilización del tag <CF_inputNumber> manteniendo la funcionalidad anterior.
	* El <CF_monto> se deja para compatiblidad con pantallas existentes, pero se debe seguir utilizando el <CF_inputNumber>
	* El <CF_monto> tiene 2 comportamientos muy diferentes:
	*	Si el tiene decimales, entonces:
	*		SIZE 		= cantidad_enteros + cantidad_decimales + cantidad_comas + signo_negativo_si_hay
	*		COMAS 		= YES
	*		NEGATIVOS	= YES/NO (se indica)
	*		(al indicar el SIZE hay que tomar en cuenta todas las cantidades de caracteres a digitar 
	*		 excepto el punto decimal, que sí lo aumenta automáticamente)
	*	Si el no tiene decimales, entonces se utiliza únicamente para Codigos_Numericos:
	*		SIZE 		= cantidad_digitos
	*		COMAS 		= NO
	*		NEGATIVOS 	= NO
	*		(no se debe utilizar para datos Enteros puesto que:
	*		 no permite ni comas, ni negativos, ni elimina los ceros de la izquierda)
	* El atributo enterAction cambia el comportamiento del <enter> para el campo con respecto al enterActionDefault
	* Utilización: 
	*	<cf_monto name="Codigo" value="00001" size="5" decimales="0">
	*	<cf_monto name="Total"  value="45.45" size="8" decimales="2" negativos="false">
	*    equivale respectivamente a:
	*	<cf_inputNumber name="Codigo" value="00001" enteros="5" codigoNumerico="yes">
	*	<cf_inputNumber name="Total"  value="45.45" enteros="5" decimales="2" negativos="false" comas="yes">
 --->
<cfset def = QueryNew('Aid')>
<cfparam name="Attributes.query" 			default="#def#" type="query">	<!--- Query con valor del Campo --->
<cfparam name="Attributes.form" 			default="form1" type="String">	<!--- Nombre del form --->
<cfparam name="Attributes.name" 			default="Numero" type="string">	<!--- Nombre del campo --->
<cfparam name="Attributes.value" 			default="0"		type="string">	<!--- Valor --->
<cfparam name="Attributes.readonly" 		default="false"	type="boolean">	<!--- Indica si se permite modificar el numero --->
<cfparam name="Attributes.modificable" 		default="#NOT Attributes.readonly#" type="boolean">

<cfparam name="Attributes.size" 			default="20"	type="numeric">	<!--- Tamaño del campo en pantalla --->
<cfparam name="Attributes.decimales" 		default="2" 	type="numeric">	<!--- Cantidad de decimales del Monto, puede ser 0 --->
<cfparam name="Attributes.negativos" 		default="false"	type="boolean">	<!--- Permite Negativos --->
<cfparam name="Attributes.class" 			default="" 		type="string">	<!--- class asociado a la caja de texto --->
<cfparam name="Attributes.style" 			default="" 		type="string">	<!--- style asociado a la caja de texto --->
<cfparam name="Attributes.tabIndex" 		default="" 		type="string">	<!--- Número del tabindex --->

<cfparam name="Attributes.onChange" 		default="" type="string"> 
<cfparam name="Attributes.onBlur" 			default="" type="string"> 

<cfparam name="Attributes.enterAction" 		default="" 		type="string">	<!--- Cambia el enterAction default del cf_onEnter: submit, tab, none --->


<cfif isdefined("Attributes.enteros")>
	<cfthrow message="ERROR EN LA DEFINICION DEL cf_monto: El atributo ENTEROS no es permitido, debe utilizar SIZE">
</cfif>

<cfif not isNumeric(Attributes.value) and len(trim(Attributes.value)) gt 0>
	<cfset Attributes.value = 0 >
</cfif>

<cfif Attributes.decimales GT 0 AND Attributes.size LT Attributes.decimales+2>
	<cfset Attributes.size = Attributes.decimales+2>
</cfif>

<cfif Attributes.decimales GT 0>
	<cfset LvarEnteros 			= Attributes.size + 1>
	<cfset LvarEnteros 			= LvarEnteros - (Attributes.decimales+1)>
	<cfset LvarEnteros 			= LvarEnteros - int(LvarEnteros/4)>
	<cfif Attributes.negativos>
		<cfset LvarEnteros 		= LvarEnteros - 1>
	</cfif>
	<cfset Attributes.comas 	= true>
	<cfset LvarCodigoNumerico 	= false>
<cfelse>
	<cfset LvarEnteros 			= Attributes.size>
	<cfset Attributes.negativos	= false>
	<cfset Attributes.comas 	= false>
	<cfset LvarCodigoNumerico 	= true>
</cfif>
</cfsilent>
<CF_inputNumber 
	query			= "#Attributes.query#"
	form			= "#Attributes.form#"
	name			= "#Attributes.name#"
	value			= "#Attributes.value#"
	default			= "0"
	modificable		= "#Attributes.modificable#"
	
	enteros			= "#LvarEnteros#"
	codigoNumerico	= "#LvarCodigoNumerico#"
	decimales		= "#Attributes.decimales#"
	negativos		= "#Attributes.negativos#"
	comas			= "#Attributes.comas#"

	class			= "#Attributes.class#"
	style			= "#Attributes.style#"
	tabIndex		= "#Attributes.tabIndex#"

	onChange		= "#Attributes.onChange#"
	onBlur			= "#Attributes.onBlur#"
	
	enterAction		= "#Attributes.enterAction#"
	tagName			= "CF_monto"
>