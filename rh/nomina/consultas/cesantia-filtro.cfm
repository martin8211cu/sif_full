<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">Recursos Humanos</cf_templatearea>
	
	<cf_templatearea name="body">
		<cf_templatecss>
		<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reporte de Cesant&iacute;a de Empleados'>
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<cfoutput>
			<cfparam name="ordenamiento" default="1">
			<cfparam name="mostrarComo" default="1">
			<form name="form1" method="post" style="margin:0;" action="cesantia.cfm">
				<table align="center" width="100%" cellpadding="2" cellspacing="0">
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td align="right" width="35%"><strong><cf_translate key="LB_CentroFuncional" xmlfile="/rh/generales.xml">Centro Funcional</cf_translate>:</strong>&nbsp;</td>
						<td><cf_rhcfuncional id="CFpk" tabindex="1"></td>
					</tr>

					<!---
					<tr>
						<td align="right" valign="middle"></td>
						<td>
							<table width="100%" cellpadding="0" cellspacing="0">
								<tr>
									<td width="1%"><input type="checkbox" name="dependencias" id="dependencias" tabindex="1"></td>
									<td ><label for="dependencias">Incluir Centros Funcionales dependientes</label></td>
								</tr>
							</table>
						</td>
					</tr>
					--->

					<tr>
						<td width="10%" align="right"><strong><cf_translate key="LB_FECHA" xmlfile="/rh/generales.xml">Fecha</cf_translate>:</strong>&nbsp;</td>
						<td width="70%" >
							<cf_sifcalendario name="fecha">
						</td>
					</tr>
						<td align="right" valign="top"><strong><cf_translate  key="LB_MostrarPor">Mostrar Por</cf_translate>:&nbsp;</strong></td>
						<td>
							<cfoutput>										
								<table width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="E8E8E8">
									<tr>
										<td width="50%"><input name="mostrarComo" id="mostrarComo1" type="radio"  value="1" <cfif mostrarComo EQ 1>checked</cfif>>
											<label for="mostrarComo1"><cf_translate key="LB_NombreApellido">Nombre, Apellido</cf_translate></label></td>
										<td width="50%"><input name="mostrarComo" id="mostrarComo2" type="radio"  value="2" <cfif mostrarComo EQ 2>checked</cfif>>
											<label for="mostrarComo2"><cf_translate key="LB_ApellidoNombre">Apellido, Nombre</cf_translate></label></td>
									</tr>
								</table>
							</cfoutput>
						</td>
					</tr>
					
					<tr>
						<td align="right" valign="top"><strong><cf_translate  key="LB_OrdenadoPor">Ordenado Por</cf_translate>:&nbsp;</strong></td>
						<td>
							<cfoutput>										
								<table width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="E8E8E8">
									<tr>
										<td width="50%">
											<!----type="checkbox"--->
											<input name="ordenamiento" id="ctrofuncionalNA" type="radio"  value="1" <cfif ordenamiento EQ 1>checked</cfif>
												onClick="javascript: if (this.checked == false){
																		document.filtro.ctrofuncionalNA.checked=true;
																	}else{
																		document.filtro.nombreapellido.checked=false;
																		document.filtro.apellidonombre.checked=false;}">
											<label for="ctrofuncionalNA"><cf_translate key="LB_CentroFuncionalNombreApellido">Centro Funcional, Nombre, Apellido</cf_translate></label>
										</td>
										<td width="50%">
											<input name="ordenamiento" id="ctrofuncionalAN" type="radio" value="2" <cfif ordenamiento EQ 2>checked</cfif>
												 <cfif isdefined("form.ctrofuncional")>checked</cfif>
												onClick="javascript: if (this.checked == false){
																		document.filtro.ctrofuncionalAN.checked=true;
																	}else{
																		document.filtro.nombreapellido.checked=false;
																		document.filtro.apellidonombre.checked=false;
																		document.filtro.nombreapellido.checked=false;}">
											<label for="ctrofuncionalAN"><cf_translate key="LB_CentroFuncionalApellidoNombre">Centro Funcional, Apellido, Nombre</cf_translate></label>
										</td>
									</tr>
									<tr>
										<td width="50%">
											<input name="ordenamiento" id="apellidonombre" type="radio" value="3"  <cfif ordenamiento EQ 3>checked</cfif>
												<cfif isdefined("form.apellidonombre")>checked</cfif>
												onClick="javascript: if (this.checked == false){
																		document.filtro.apellidonombre.checked=true;
																	}else{
																		document.filtro.ctrofuncionalNA.checked=false;
																		document.filtro.ctrofuncionalAN.checked=false;
																		document.filtro.nombreapellido.checked=false;
																		}">
											<label for="apellidonombre"><cf_translate  key="LB_ApellidoNombre">Apellido, Nombre</cf_translate></label>
										</td>
										<td width="50%">
											<input name="ordenamiento" id="nombreapellido" type="radio" value="4"  <cfif ordenamiento EQ 4>checked</cfif>
												<cfif isdefined("form.nombreapellido")>checked</cfif>
												onClick="javascript: if (this.checked == false){
																		document.filtro.nombreapellido.checked=false;
																	}else{
																		document.filtro.ctrofuncionalAN.checked=false;
																		document.filtro.apellidonombre.checked=false;}">
											<label for="nombreapellido"><cf_translate  key="LB_NombreApellido">Nombre, Apellido</cf_translate></label>
										</td>
									</tr>
								</table>										
							</cfoutput>
						</td>
					</tr>
					

					<tr><td colspan="3" align="center"><cf_botones tabindex="1" include="Consultar" exclude="Alta,Limpiar"></td></tr>
					<tr><td>&nbsp;</td></tr>
				</table>
			</form>	
			</cfoutput>
		</cf_web_portlet>

		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_FECHA"
			Default="Fecha"
			xmlfiles="/rh/generales.xml"
			returnvariable="LB_FECHA"/>


		<cf_qforms>
		<script type="text/javascript" language="javascript1.2">
			/*
			objForm.CFpk.required = true;
			objForm.CFpk.description = 'Centro Funcional';
			*/
			objForm.fecha.required = true;
			objForm.fecha.description = '<cfoutput>#LB_FECHA#</cfoutput>';
		</script>

	</cf_templatearea>
</cf_template>