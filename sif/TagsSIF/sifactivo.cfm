<cfset def = QueryNew('Aid')>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Conexion" default="#Session.DSN#" type="String"> 			<!--- Nombre de la conexión --->
<cfparam name="Attributes.form" 				type="String" 	default="form1"> 	<!--- Nombre del form --->
<cfparam name="Attributes.query" 				type="query" 	default="#def#"> 	<!--- consulta por defecto --->
<cfparam name="Attributes.name" 				type="string" 	default="Aid"> 		<!--- Nombre del Id --->
<cfparam name="Attributes.placa" 				type="string" 	default="Aplaca"> 	<!--- Nombre de la Placa --->
<cfparam name="Attributes.desc" 				type="string" 	default="Adescripcion"> <!--- Nombre de la Descripción --->
<cfparam name="Attributes.frame" 				type="string" 	default="frocupacion"> 	<!--- Parametro obsoleto --->
<cfparam name="Attributes.tabindex" 			type="string" 	default="-1"> <!--- número del tabindex --->
<cfparam name="Attributes.size" 				type="string" 	default="30"> <!--- tamaño del objeto de la Descripción --->
<cfparam name="Attributes.modificable" 			type="boolean" 	default="true">  <!--- No permite modificar el valor cuando es false --->
<cfparam name="Attributes.permitenuevo" 		type="boolean" 	default="false"> <!--- permite digitar una placa inexistente --->
<cfparam name="Attributes.debug" 				type="boolean" 	default="false"> <!--- DEFAULT No --->
<cfparam name="Attributes.showEmptyListMsg" 	type="boolean" 	default="false"> <!--- DEFAULT False --->
<cfparam name="Attributes.EmptyListMsg" 		type="string" 	default="--- No se encontraron Registros ---"> <!--- DEFAULT --- No se encontraron Registros --- --->
<cfparam name="Attributes.funcion" 				type="string" 	default=""><!--- Funcion a ejecutar ejemplo con ANA V. --->
<cfparam name="Attributes.fparams" 				type="string" 	default=""><!--- Parámetros de la función a ejecutar, ejemplo com Angélica. --->
<cfparam name="Attributes.craf" 				type="boolean" 	default="false"><!--- para utilizar este tag en control de responsables : Permite solo activos con documento --->
<cfparam name="Attributes.crafpermiteinactivos" type="boolean" 	default="false"><!--- para utilizar este tag en control de responsables : Permite solo activos con documento activo --->
<cfparam name="Attributes.onfocus" 				type="string" 	default="">
<cfparam name="Attributes.onkeyup" 				type="string" 	default="">
<cfparam name="Attributes.onchange" 			type="string" 	default="">
<cfparam name="Attributes.onkeydown" 			type="string" 	default="">
<cfparam name="Attributes.onkeypress" 			type="string" 	default="">
<cfparam name="Attributes.onblur" 				type="string" 	default="">
<cfparam name="Attributes.MetodoDep"			type="integer" 	default="0"><!---Metodo de Depreciación (1-Linea Recta) (2-Suma de Digitos) (3-Por Actividad)--->

<!--- Attributes.permitir_retirados: Por defecto el conlis no muestra ni se permite digitar Activos retirados pero si el parámetro se prende si los permite --->
<cfparam name="Attributes.permitir_retirados" 	type="boolean" default="false">

<cfparam name="Attributes.OtrasTablas" 		 	type="string" default="">
<cfparam name="Attributes.OtrosFiltros" 		type="string" default="">

<cfset Attributes.valuesArray = ArrayNew(1)>
<cfif isdefined('Attributes.query') and ListLen(Attributes.query.columnList) GT 1>
	<cfset ArrayAppend(Attributes.valuesArray,Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.name')#')#'))>
	<cfset ArrayAppend(Attributes.valuesArray,Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.placa')#')#'))>
	<cfset ArrayAppend(Attributes.valuesArray,Trim('#Evaluate('Attributes.query.#Evaluate('Attributes.desc')#')#'))>
</cfif>

<cfif Attributes.modificable>
	<cfset Lvar_modificables = "N, S, N">
<cfelse>
	<cfset Lvar_modificables = "N, N, N">
</cfif>
<cf_dbfunction name="now" returnvariable ="Lvar_Fecha">
<cfif not Attributes.permitir_retirados>
	<cfset Attributes.OtrosFiltros = Attributes.OtrosFiltros & " and Astatus = 0">
</cfif>
<cfif Attributes.craf>
	<cfset Attributes.OtrasTablas = Attributes.OtrasTablas & " inner join AFResponsables afr  on afr.Ecodigo = Activos.Ecodigo and afr.Aid = Activos.Aid">
	<cfif not Attributes.crafpermiteinactivos>
		 <cfset Attributes.OtrosFiltros = Attributes.OtrosFiltros & " and #Lvar_Fecha# between afr.AFRfini and AFRffin">
	</cfif>
</cfif>

<cfif Attributes.MetodoDep GT 0>
	<cfset Attributes.OtrasTablas  = Attributes.OtrasTablas & " inner join ACategoria acat on acat.ACcodigo = Activos.ACcodigo">
	<cfset Attributes.OtrosFiltros = Attributes.OtrosFiltros & " and acat.ACmetododep = #Attributes.MetodoDep#">
</cfif>

<cf_conlis campos="#Attributes.name#, #Attributes.placa#, #Attributes.desc#" 
	size			= "0,20,#Attributes.size#"
	title			= "Lista de Activos"
	desplegables	= "N, S, S"
	modificables	= "#Lvar_modificables#"
	readonly		= "#FindNoCase('S',Lvar_modificables) eq 0#"
	columnas		= "Activos.Aid as #Attributes.name#, Activos.Aplaca as #Attributes.placa#, Activos.Adescripcion as #Attributes.desc#"
	tabla			= "Activos #Attributes.OtrasTablas#"
	filtro			= "Activos.Ecodigo = #session.ecodigo# #Attributes.OtrosFiltros# order by Aplaca"
	desplegar		= "#Attributes.placa#, #Attributes.desc#"
	filtrar_por		= "Activos.Aplaca, Activos.Adescripcion"
	etiquetas		= "Placa, Descripci&oacute;n"
	formatos		= "S, S"
	align			= "left, left"
	asignar			= "#Attributes.name#, #Attributes.placa#, #Attributes.desc#"
	asignarFormatos	= "I, S, S"
	valuesArray		= "#Attributes.valuesArray#"
	maxRows			= "20"
	maxRowsQuery	= "200"
	conexion		= "#Attributes.Conexion#"
	form			= "#Attributes.form#"
	tabindex		= "#Attributes.tabindex#"
	debug			= "#Attributes.debug#"
	showEmptyListMsg= "#Attributes.showEmptyListMsg#"
	EmptyListMsg	= "#Attributes.EmptyListMsg#"
	funcion			= "#Attributes.funcion#"
	fparams			= "#Attributes.fparams#"
	permitenuevo	= "#Attributes.permitenuevo#"
	onfocus			= "#Attributes.onfocus#"
	onkeyup			= "#Attributes.onkeyup#"
	onchange		= "#Attributes.onchange#"
	onkeydown		= "#Attributes.onkeydown#"
	onkeypress		= "#Attributes.onkeypress#"
	onblur			= "#Attributes.onblur#"
	>