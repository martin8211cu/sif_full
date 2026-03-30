<cf_template>
	<cf_templatearea name="title">Aprobaci&oacute;n de Incidencias
	</cf_templatearea>
	
	<cf_templatearea name="header">
	</cf_templatearea>
	
	<cf_templatearea name="body">
		<cfinclude template="/home/menu/pNavegacion.cfm">
		<cfinclude template="/rh/marcas/operacion/lista-aprobacionIncidencias.cfm">
		
		<form name="form1">
			<div align="center">
				<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Regresar"
						Default="Regresar"
						XmlFile="/sif/generales.xml"
						returnvariable="BTN_Regresar"
				/>	
				<cfif isdefined("url.from") and url.from NEQ "">
					<input type="button" name="btnRegresar" onClick="location.href = '/cfmx/sif/tr/consultas/#url.from#.cfm';" value="&lt;&lt; #BTN_Regresar#">
				<cfelse>
					<input type="button" name="btnRegresar" onClick="history.back()" value="&lt;&lt; #BTN_Regresar#">
				</cfif>
			</div>	
		</form>
	</cf_templatearea>
</cf_template>