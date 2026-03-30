<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Error_al_tratar_de_ejecutar_el_reporte"
	Default="Error al tratar de ejecutar el reporte"
	xmlfile="/rh/repUsuario/ejecutar-reporte.xml"
	returnvariable="vError"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Revise_su_reporte_para_determinar_posibles_errores"
	Default="Revise su reporte para determinar posibles errores"
	xmlfile="/rh/repUsuario/ejecutar-reporte.xml"
	returnvariable="vError1"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_No_se_pueden_ejecutar_reportes_que_requieren_parametros"
	Default="No se pueden ejecutar reportes que requieren parámetros"
	xmlfile="/rh/repUsuario/ejecutar-reporte.xml"
	returnvariable="vError2"/>

<cfset empresa = session.Ecodigo>	

<!--- JCG  --->
<!--- comento lo siguiente debido a que cftry toma la salida del reporte como un error --->
<!---
<cfif isdefined("form.ruta") and isdefined("form.directorio") and isdefined("form.archivo") and len(trim(form.ruta))  and len(trim(form.directorio)) and len(trim(form.archivo))>
	<cftry>
		<cfset archivo = "#trim(replace(form.ruta,'\','/', 'ALL'))#/#trim(form.directorio)#/#trim(form.archivo)#">
		<cfreport format="#form.formato#" template="#archivo#" query="#MyQuery#" overwrite="yes">
		<cfreportparam name="empresa" value="8">
		</cfreport>
	<cfcatch type="any">
		<script type="text/javascript" language="javascript1.2">
			alert('<cfoutput>#vError#:\n - #vError1# \n - #vError2#</cfoutput>.');
			location.href = 'ejecutar-reporte.cfm';
		</script>
	</cfcatch>
	</cftry>
</cfif>
--->

<cfset archivo = "#trim(replace(form.ruta,'\','/', 'ALL'))#/#trim(form.directorio)#/#trim(form.archivo)#">
		<cfreport format="#form.formato#" template="#archivo#"  overwrite="yes">
		<cfreportparam name="empresa" value="#session.Ecodigo#">
		<cfreportparam name="desde" value="#form.desde#">
		<cfreportparam name="hasta" value="#form.hasta#">
		</cfreport>


