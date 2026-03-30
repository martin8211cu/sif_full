<cfprocessingdirective pageEncoding="utf-8">
<!--- TRADUCCIONES --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Titulo	= t.Translate('LB_Titulo',		'Gestion de Reportes', 			'GestionReportes.xml')>
<cfset LB_TituloVE	= t.Translate('LB_TituloVE',	'Consultar/Editar Reporte', 		'GestionReportes.xml')>
<cfset LB_TituloN	= t.Translate('LB_TituloN',		'Nuevo Reporte',			 		'GestionReportes.xml')>
<cfset LB_TituloCol	= t.Translate('LB_TituloCol',	'Columnas', 						'GestionReportes.xml')>
<cfset LB_Codigo	= t.Translate('LB_Codigo',		'C&oacute;digo', 							'GestionReportes.xml')>
<cfset LB_Desc		= t.Translate('LB_Desc',		'Descripci&oacute;n', 						'GestionReportes.xml')>
<cfset LB_Modulo	= t.Translate('LB_Modulo',		'M&oacute;dulo', 						'GestionReportes.xml')>
<cfset LB_Exclusivo	= t.Translate('LB_Exclusivo',	'Exclusivo', 						'GestionReportes.xml')>
<cfset LB_Si		= t.Translate('LB_Si',			'Si', 								'GestionReportes.xml')>
<cfset LB_No		= t.Translate('LB_No',			'No', 								'GestionReportes.xml')>
<cfset LB_Selec		= t.Translate('LB_Selec',		'-- Seleccionar --', 				'GestionReportes.xml')>
<cfset LB_Ninguno	= t.Translate('LB_Ninguno',		'Ninguno', 							'GestionReportes.xml')>
<cfset LB_Relaciones= t.Translate('LB_Relaciones',	'Relaciones', 						'GestionReportes.xml')>
<cfset LB_Variables	= t.Translate('LB_Variables',	'Variables', 						'GestionReportes.xml')>
<cfset LB_Consulta	= t.Translate('LB_Consulta',	'Consulta', 						'GestionReportes.xml')>
<cfset LB_Guardar	= t.Translate('LB_Guardar',		'Guardar', 							'GestionReportes.xml')>
<cfset LB_Nuevo		= t.Translate('LB_Nuevo',		'Nuevo', 							'GestionReportes.xml')>
<cfset LB_Eliminar	= t.Translate('LB_Eliminar',	'Eliminar Reporte', 				'GestionReportes.xml')>
<cfset LB_OriDat	= t.Translate('LB_OriDat',		'Origenes de Datos', 				'GestionReportes.xml')>
<cfset LB_Columnas	= t.Translate('LB_Columnas',	'Columnas', 						'GestionReportes.xml')>
<cfset LB_Publico   = t.Translate('LB_Publico',     'P&uacute;blico',                   'GestionReportes.xml')>
<cfset MSG_Eliminar	= t.Translate('MSG_Eliminar','Se eliminar&aacute; el reporte y todas sus versiones asociadas. Deseas Eliminar?', 		'GestionReportes.xml')>
<cfset MSG_Falla	= t.Translate('MSG_Falla','Ocurri&oacute; una Falla, verificar el Query', 	'GestionReportes.xml')>
<!--- CSS --->
<style type="text/css">
	/*.container{
		border: 0px;
	}
	.container2{
		max-width: 250px;
	}*/
	label{
		font-style:normal;
		float: left;
		display: inline-block;
		padding-top: 2px;
		width:140px;
	    text-align:left;
	}
	#forma{
		text-align: center;
	}
	/*div{
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
	}*/
</style>
<!--- VARIABLES --->
<cfparam name="modo" default="">
<cfparam name="varRPTId" default="0">
<cf_navegacion name="modo">
<cf_navegacion name="RPTId">
<!--- HUB --->
<cfswitch expression="#modo#">
	<!--- NUEVO --->
	<cfcase value="ALTA">
		<cfinclude template="EditarGestionReportes.cfm">
	</cfcase>
	<!--- CONSULTAR --->
	<cfcase value="VISTA">
		<cfinclude template="EditarGestionReportes.cfm">
	</cfcase>
	<!--- EDITAR --->
	<cfcase value="CAMBIO">
		<cfinclude template="EditarGestionReportes.cfm">
	</cfcase>
	<cfdefaultcase>
		<cfinclude template="listaGestionReportes.cfm">
	</cfdefaultcase>
</cfswitch>

<cfhtmlhead text="<script src='/cfmx/commons/GeneraReportes/js/ReporteOD.js'></script>">
<cfhtmlhead text="<script src='/cfmx/commons/GeneraReportes/js/ReporteColumna.js'></script>">

