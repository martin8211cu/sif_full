

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ExportacionDeAsientos"
	Default="Exportaci&oacute;n  del Asiento Contable"	
	returnvariable="LB_ExportacionDeAsientos"/>	

	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
				
		
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
		<cf_web_portlet_start titulo="<cfoutput>#LB_ExportacionDeAsientos#</cfoutput>">
			<cfoutput>#pNavegacion#</cfoutput>
			
					
			<!---=================== TRADUCCION ======================---->			
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Lista_de_Relaciones_de_Calculo"
				Default="Lista de Relaciones de C&aacute;lculo"	
				returnvariable="LB_Lista_de_Relaciones_de_Calculo"/>				
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Relacion_de_Calculo"
				Default="Relaci&oacute;n de C&aacute;lculo"	
				returnvariable="LB_Relacion_de_Calculo"/>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Tipo_de_Nomina"
				Default="Tipo de N&oacute;mina"	
				returnvariable="LB_Tipo_de_Nomina"/>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_No_se_encotraron_relaciones_de_calculo"
				Default="No se encotraron relaciones de cálculo"	
				returnvariable="LB_No_se_encotraron_relaciones_de_calculo"/>			
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="BTN_Generar_Exportador"
				Default="Seleccionar"
				returnvariable="BTN_Generar_Exportador"/>	
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_Exportador_No_Definido"
				Default="Debe definir el Exportador de Asientos en los Parametros Generales"
				returnvariable="MSG_Exportador_No_Definido"/>	
				
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_SeleccionarRelacionCalculo"
				Default="Debe primero seleccionar la Relación de Cálculo: "
				returnvariable="MSG_SeleccionarRelacionCalculo"/>		
				
				<!--- JavaScript --->
				<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
				<script language="JavaScript" type="text/javascript">
				// specify the path where the "/qforms/" subfolder is located
				qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
				// loads all default libraries
				qFormAPI.include("*");
				</script>			
																		
				<cfquery name="rsParametros" datasource="#Session.DSN#">
				select Pvalor
				from RHParametros
				where Pcodigo=2050
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				</cfquery>


							
				<cfif len(trim(rsParametros.Pvalor)) GT 0> 
				<cfset EIcodigo = '#rsParametros.Pvalor#'>	
										
				<cfquery name="rs" datasource="sifcontrol">
				  select EIcodigo, EIid
				  from EImportador
				  where EIcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#EIcodigo#">
				</cfquery>													
					<cfset EIid= rs.EIid>					
				<cfelse> 
				    <cfthrow message="#MSG_Exportador_No_Definido#"> 
				</cfif>  
				

			<form name="form" action="GeneraExportAsientos.cfm" method="post">
				<table width="98%" cellpadding="0" cellspacing="0">	
				<tr><td>&nbsp;</td>	</tr>	
				<tr><td>&nbsp;</td>	</tr>			
					<tr>					
			
						<td nowrap class="fileLabel" align="right"><cf_translate key="LB_CodigoDelCalendarioDePago">Código del Calendario de Pago</cf_translate> :&nbsp;</td>
    						<td nowrap colspan="7">
							<!--- Número de Nómina --->
							<!--- <cf_sifcalendario form="filtro"> --->
							<cf_rhcalendariopagos form="form" historicos="true" tcodigo="true" pintaRCDescripcion="true" >
					        </td>
						  <td colspan="2" align="center">
						  <cfoutput><input type="submit" name="btn_consultar" value="#BTN_Generar_Exportador#" /></cfoutput>
						</td>
					</tr>	 						
				</table>
			</form>
		<cf_web_portlet_end>
	<cf_templatefooter>	
	
	<script language="JavaScript" type="text/javascript">
	//Instancia de qForm
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form");
	//Validaciones 
	objForm.CPid.required = true;
	objForm.CPid.description = "Nómina";		
    </script> 
	

