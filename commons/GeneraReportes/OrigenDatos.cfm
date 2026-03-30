<cfprocessingdirective pageEncoding="utf-8">
<!--- TRADUCCIONES --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Titulo	= t.Translate('LB_Titulo',		'Origenes de Datos', 				'OrigenDatos.xml')>
<cfset LB_TituloVE	= t.Translate('LB_TituloVE',	'Consultar/Editar Origen de Datos', 'OrigenDatos.xml')>
<cfset LB_TituloCol	= t.Translate('LB_TituloCol',	'Columnas', 						'OrigenDatos.xml')>

<cfset LB_Codigo	= t.Translate('LB_Codigo',		'Código', 							'OrigenDatos.xml')>
<cfset LB_Desc		= t.Translate('LB_Desc',		'Descripción', 						'OrigenDatos.xml')>
<cfset LB_Catego	= t.Translate('LB_Catego',		'Categoría', 						'OrigenDatos.xml')>
<cfset LB_Exclusivo	= t.Translate('LB_Exclusivo',	'Exclusivo', 						'OrigenDatos.xml')>
<cfset LB_Si		= t.Translate('LB_Si',			'Si', 								'OrigenDatos.xml')>
<cfset LB_No		= t.Translate('LB_No',			'No', 								'OrigenDatos.xml')>
<cfset LB_Selec		= t.Translate('LB_Selec',		'-- Seleccionar --', 				'OrigenDatos.xml')>
<cfset LB_Relaciones= t.Translate('LB_Relaciones',	'Relaciones', 						'OrigenDatos.xml')>
<cfset LB_Variables	= t.Translate('LB_Variables',	'Variables', 						'OrigenDatos.xml')>
<cfset LB_Consulta	= t.Translate('LB_Consulta',	'Consulta', 						'OrigenDatos.xml')>
<cfset LB_Eliminar	= t.Translate('LB_Eliminar',	'Eliminar Origen de Datos', 		'OrigenDatos.xml')>

<cfset MSG_Eliminar	= t.Translate('MSG_Eliminar','Deseas eliminar el Origen de Datos?', 'OrigenDatos.xml')>
<cfset MSG_Falla	= t.Translate('MSG_Falla','Ocurrió una Falla, verificar el Query', 	'OrigenDatos.xml')>
<!---  --->
<cfset LB_TMRelacion = t.Translate('LB_TMRelacion','Relaciones','OrigenDatos_Variables.xml')>


<!--- CSS --->
<style type="text/css">
	.container{
		border: 0px;
	}
	.container2{
		max-width: 250px;
	}
	label{
		font-style:normal;
		float: left;
		display: inline-block;
		padding-top: 2px;
		width:70px;
	    text-align:left;
	}
	div{
		text-align: left;
		height: auto;
	}
	li {
	    margin: 0;
	    padding: 0.2em;
	}
	ul {
		margin: 0;
		padding: 0;
	}
</style>
<!--- <cf_dump var=#varProc#> --->
<!--- VARIABLES --->
<cfparam name="varProc" default="">
<cfif structKeyExists(url,"varProc")>
	<cfset varProc = #url.varProc#>
</cfif>
<cfset varEdit = false>

<!--- HUB --->
<cfswitch expression="#varProc#">
	<cfcase value="COD">
	</cfcase>
	<!--- NUEVO --->
	<cfcase value="NOD">
		<cfset varEdit = true>
		<cfset modo = "ALTA">
		<cfset varODId = 0>
		<cfinclude template="EditarOrigenDatos.cfm">
	</cfcase>
	<!--- CONSULTAR --->
	<cfcase value="VOD">
		<cfset varEdit = false>
		<cfset modo = "CAMBIO">
		<cfset varODId = #url.ODID#>
		<cfinclude template="EditarOrigenDatos.cfm">
	</cfcase>
	<!--- EDITAR --->
	<cfcase value="EOD">
		<cfset varEdit = true>
		<cfset modo = "CAMBIO">
		<cfset varODId = #url.ODID#>
		<cfinclude template="EditarOrigenDatos.cfm">
	</cfcase>
	<cfdefaultcase>
		<cfinclude template="listaOrigenDatos.cfm">
	</cfdefaultcase>
</cfswitch>
