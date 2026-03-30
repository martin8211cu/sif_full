<script src="/cfmx/rh/js/utilesMonto.js"></script>

<!-- Establecimiento del modo -->
<cfif isdefined("form.Cambio") or isdefined('form.RHPcodigo') and len(trim(form.RHPcodigo)) gt 0>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfset valoresCambioPuestoP = ArrayNew(1)>	<!---Valores del puesto presupuestario---->
<!--- Consultas --->
<cfif modo neq 'ALTA'>
	<!--- Form --->
	
	<cfquery name="rsForm" datasource="#session.DSN#">
		select 	RHTPid, 
				<!---coalesce(a.RHPcodigoext,a.RHPcodigo) as RHPcodigo, Este muestra la info en el form de puestos.cfm---> 
				a.RHPcodigo,
				a.RHPcodigoext,
				a.RHPdescpuesto, 
				a.RHOcodigo, 
				b.RHOdescripcion, 
				a.RHPEid, 
				c.RHPEcodigo, 
				c.RHPEdescripcion, 
				a.BMusuario,
				a.BMfecha,
				a.BMusumod,
				a.BMfechamod,
				a.RHPfechaaprob,
				a.DEidaprueba,
				a.RHPactivo,
				a.RHPfactiva,
				a.CFid,
				d.CFcodigo,
				d.CFdescripcion,
				a.ts_rversion,
				RHGMid,
				e.RHMPPid,
				e.RHMPPcodigo,
				e.RHMPPdescripcion,
				a.RHDDVlinea,
				a.RHDDVlineaFidelidad,
				a.HE2,
				a.HE3
		from RHPuestos a
			left outer join RHOcupaciones b
			on a.RHOcodigo = b.RHOcodigo

			left outer join RHPuestosExternos c
			on a.RHPEid = c.RHPEid
			
			left outer join CFuncional d
			on a.CFid = d.CFid
			and a.Ecodigo = d.Ecodigo
			
			left outer join RHMaestroPuestoP e
				on a.RHMPPid = e.RHMPPid
				and a.Ecodigo = e.Ecodigo
				
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
	</cfquery>
	<cfset ArrayAppend(valoresCambioPuestoP, rsForm.RHMPPid)>
	<cfset ArrayAppend(valoresCambioPuestoP, rsForm.RHMPPcodigo)>
	<cfset ArrayAppend(valoresCambioPuestoP, rsForm.RHMPPdescripcion)>
</cfif>

<!--- registros existentes --->
<cfquery name="rsCodigos" datasource="#session.DSN#">
	select rtrim(coalesce(RHPcodigoext, RHPcodigo)) as RHPcodigo
	from RHPuestos
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!--- Tipos de Puestos --->
<cfquery name="rsTipos" datasource="#session.dsn#">
	select RHTPid, RHTPcodigo, RHTPdescripcion
	from RHTPuestos
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!--- Grupos de Materias --->
<cfquery name="rsGruposMat" datasource="#session.dsn#">
	Select RHGMid,RHGMcodigo,Descripcion
	from RHGrupoMaterias
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!----Verificar parámetro de planillapresupuestaria---->
<cfquery name="rsVerificaPP" datasource="#session.DSN#">
	select Pvalor from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo = 540
</cfquery>
<cfset vb_planillap = rsVerificaPP.Pvalor>
<cfif vb_planillap eq "">
	<cfset vb_planillap = -1>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_EsNecesarioIngresarLosParametrosGeneralesAntesDeIngresarUnPuestoDeseaIncluirLosParametros"
	Default="Es necesario ingresar los parámetros generales antes de ingresar un puesto \n\nDesea incluir los parámetros?"
	returnvariable="MSG_EsNecesarioIngresarLosParametrosGeneralesAntesDeIngresarUnPuestoDeseaIncluirLosParametros"/>	

	<script language="JavaScript1.2" type="text/javascript">
		if (confirm('<cfoutput>#MSG_EsNecesarioIngresarLosParametrosGeneralesAntesDeIngresarUnPuestoDeseaIncluirLosParametros#</cfoutput>')) {
			location.href="Parametros.cfm";
		}
		else{
			history.back();
		}
		
		
		
	</script>
</cfif>

<!--- Javascript --->
<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>


<form name="form1" method="post" action="SQLPuestos-frinfo.cfm" onSubmit="return fin();">
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
		<cfoutput>
			<tr> 
				<td align="right" width="20%"></td>
				<td align="left" width="80%"></td>
			</tr>
			<tr>
				<td align="right">&nbsp;</td>
				<td align="left">&nbsp;</td>
			</tr>

			<tr> 
				<td align="right"><strong><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate>:&nbsp;</strong></td>
				<td align="left">	
					<input name="RHPcodigo" type="text" tabindex="1"
							value="<cfif modo neq 'ALTA'>#Trim(rsForm.RHPcodigo)#</cfif>" 
							<cfif modo neq 'ALTA'>disabled</cfif> size="10" maxlength="10" 
							onFocus="javascript:this.select();">
					<cfif modo neq 'ALTA'>
					<strong><strong><cf_translate key="LB_CodigoAlterno" XmlFile="/rh/generales.xml">C&oacute;digo Alterno</cf_translate>:&nbsp;</strong>
					<input name="RHPcodigoext" type="text" tabindex="1" size="10" maxlength="10" value="#Trim(rsForm.RHPcodigoext)#" onFocus="javascript:this.select();"/>
					</cfif>
				</td>	   	 
			</tr>	
			<tr> 
				<td align="right"><strong><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate>:&nbsp;</strong></td>
			  	<td align="left">
					<input name="RHPdescpuesto" type="text" tabindex="1"
							value="<cfif modo neq 'ALTA'>#HTMLEditFormat(rsForm.RHPdescpuesto)#</cfif>" 
							size="70" maxlength="80" onFocus="javascript:this.select();">
				</td>						
			</tr>
			<tr>
				<td align="right"><div align="right"><strong><cf_translate key="LB_EmpleadoqueAprueba">Empleado que aprueba</cf_translate>:&nbsp;</strong></div></td>
				<td width="21%">
					<cfif modo NEQ "ALTA">
						<cf_rhempleado query="#rsForm#" tabindex="1" size = "60">			
					<cfelse>
						<cf_rhempleado tabindex="1" size = "50">
					</cfif>
				</td>	
			</tr>
			<tr>
				<td align="right"><strong><cf_translate key="LB_FechaDeAprobacion">Fecha de aprobación</cf_translate>:&nbsp;</strong></td>
				<td width="22%">
					<cfif modo NEQ "ALTA">
						<cfset fecha = LSDateFormat(rsForm.RHPfechaaprob, "DD/MM/YYYY")>
					<cfelse>
						<cfset fecha = LSDateFormat(Now(), "DD/MM/YYYY")>
					</cfif>
					<cf_sifcalendario form="form1" value="#fecha#" name="RHPfechaaprob" tabindex="1">
				</td>
			</tr>
			<tr>
			  <td><div align="right"><strong><cf_translate key="LB_CentroFuncional" XmlFile="/rh/generales.xml">Centro Funcional</cf_translate>: </strong></div></td>
			  <td>
			  	<cfif modo NEQ "ALTA">
					<cf_rhcfuncional query="#rsForm#" tabindex="1">
				<cfelse>
			  		<cf_rhcfuncional tabindex="1">
				</cfif>
			  </td>
			</tr>
			<cfif Modo NEQ "ALTA">
			<tr>
			  <td align="right"><strong><cf_translate key="LB_FechaDeInactivacion">Fecha de Inactivaci&oacute;n</cf_translate>:</strong></td>
			  <td align="left">
			  	<!--- Este campo debe cumplir las siguientes reglas:
					Para inactivar				
					1. Verficar que no exista un funcionario activo a la fecha de hoy que este utilizando una plaza
					que tenga asociado dicho puesto. En caso de que esto ocurra enviar un mensaje de error indicando 
					de esta situación.
					2. No se puede inactivar un puesto si existe un concurso activo en el proceso de reclutamiento y
					selección.
					Funcionamiento de la fecha
					1. Cuando se inactiva se guarda la fecha de ese momento (Now()).
					2. Cuando se activa se guarda la fecha en blanco (NULL).
					Para Mostrarlo
					1. Cuando está inactivo se muestra la fecha de inactivación.
					2. Cuando estpa activo no se muestra la fecha.
				 --->
				 <table width="1%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td nowrap>
							<cfif rsForm.RHPactivo eq 1>
								<cf_translate key="MSG_ElPuestoSeEncuentraActivo">El Puesto se encuentra activo</cf_translate>.&nbsp;
							<cfelse>
								#LSDateFormat(rsForm.RHPfactiva,'dd/mm/yyyy')#&nbsp;
							</cfif>
					</td>
					<td>
						<table width="1%"  border="0" cellspacing="0" cellpadding="0" class="Ayuda">
						  <tr>
							<td>
								<input type="hidden" name="RHPactivoanterior" id="RHPactivoanterior" value="#rsForm.RHPactivo#">
								<input type="hidden" name="RHPcodigoextanterior" id="RHPcodigoextanterior" value="#rsForm.RHPcodigoext#">
								<input type="checkbox" name="RHPactivo" id="RHPactivo" tabindex="1"
								<cfif rsForm.RHPactivo eq 0>
									checked
								</cfif>
								>
							</td>
							<td nowrap>
								<p>
									<strong><cf_translate key="CHK_InactivarPuesto">Inactivar Puesto</cf_translate>.&nbsp;</strong>
								</p>
							</td>
						  </tr>
						</table>
					</td>
				  </tr>
				</table>
			  </td>
		  </tr>
		  </cfif>			
			<tr>
				<td align="right"><strong><cf_translate key="LB_Ocupacion" XmlFile="/rh/generales.xml">Ocupaci&oacute;n</cf_translate>:&nbsp;</strong></td>
				<td align="left">
					<cfif modo neq 'ALTA'>
					  	<cf_rhocupacion query="#rsForm#" tabindex="1">
					<cfelse>	
					  	<cf_rhocupacion tabindex="1">
					</cfif>
				</td>	
			</tr>
			<tr>
				<td align="right"><strong><cf_translate key="LB_PuestoExterno">Puesto Externo</cf_translate>:</strong>&nbsp;</td>
				<td align="left">
					<cfif modo neq 'ALTA'>
					  	<cf_rhpuestoexterno query="#rsForm#" tabindex="1">
					<cfelse>	
					  	<cf_rhpuestoexterno tabindex="1">
					</cfif>
				</td>
			</tr>
			<tr>
				<td align="right"><strong><cf_translate key="LB_Tipo" XmlFile="/rh/generales.xml">Tipo</cf_translate>:&nbsp;</strong></td>
				<td align="left">
					<select name="RHTPid" tabindex="1">
						<option value=""></option>
					  	<cfloop query="rsTipos">
							<option value="#rsTipos.RHTPid#" 
									<cfif modo neq "ALTA" and rsForm.RHTPid eq RHTPid>selected</cfif>>
								#rsTipos.RHTPcodigo# - #rsTipos.RHTPdescripcion#
							</option>
					  </cfloop>
					</select>
				</td>
			</tr>
			<tr>
				<td align="right"><strong><cf_translate key="LB_ProgramaDeCapacitacion">Programa de Capacitaci&oacute;n:&nbsp;</cf_translate></strong></td>
				<td nowrap>
					<table width="200" border="0" cellpadding="0" cellspacing="0">
					  <tr>
						<td>
							<select name="RHGMid" onChange="javascript:cambiaGrupo(this);" tabindex="1">
								<option value="-1"></option>
								<cfloop query="rsGruposMat">
									<option value="#rsGruposMat.RHGMid#" 
											<cfif modo neq "ALTA" and rsForm.RHGMid NEQ '' and rsForm.RHGMid eq rsGruposMat.RHGMid> selected</cfif>>
										#rsGruposMat.RHGMcodigo# - #rsGruposMat.Descripcion#
									</option>
							  </cfloop>
							</select>								
						</td>
						<td>
						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="ALT_ListaDeMateriasDelGrupo"
							Default="Lista de Materias del Grupo"
							returnvariable="ALT_ListaDeMateriasDelGrupo"/>
						
							<div id="detMatGrupo">
								<a href="##" tabindex="-1"><img src="/cfmx/rh/imagenes/findsmall.gif" alt="#ALT_ListaDeMateriasDelGrupo#" name="imagen" border="0" align="absmiddle" onClick='javascript: doConlisMateriaGrupo();'></a>		
							</div>
						</td>
					  </tr>
					</table>
				</td>
			</tr>
			<tr>
				<td align="right"><strong><cf_translate key="LB_PuestoPresupuestario">Puesto Presupuestario</cf_translate>:&nbsp;</strong></td>														
				<td>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_ListaDePuestosPresupuestarios"
						Default="Lista de Puestos Presupuestarios"
						returnvariable="LB_ListaDePuestosPresupuestarios"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_Codigo"
						Default="C&oacute;digo"
						XmlFile="/rh/generales.xml"
						returnvariable="LB_Codigo"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_Descripcion"
						Default="Descripci&oacute;n"
						XmlFile="/rh/generales.xml"
						returnvariable="LB_Descripcion"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_NoSeEncontraronRegistros"
						Default="No se encontraron registros"
						XmlFile="/rh/generales.xml"
						returnvariable="MSG_NoSeEncontraronRegistros"/>

					<cf_conlis 
						campos="RHMPPid, RHMPPcodigo, RHMPPdescripcion"
						asignar="RHMPPid, RHMPPcodigo, RHMPPdescripcion"
						size="0,10,30"
						desplegables="N,S,S"
						modificables="N,S,N"						
						title="#LB_ListaDePuestosPresupuestarios#"
						tabla="RHMaestroPuestoP "
						columnas="RHMPPid, RHMPPcodigo, RHMPPdescripcion"
						filtro="Ecodigo = #Session.Ecodigo# "
						filtrar_por="RHMPPcodigo, RHMPPdescripcion"
						desplegar="RHMPPcodigo, RHMPPdescripcion"
						etiquetas="#LB_Codigo#, #LB_Descripcion#"
						formatos="S,S"
						align="left,left"								
						asignarFormatos="S,S,S"
						form="form1"
						valuesArray="#valoresCambioPuestoP#"
						showEmptyListMsg="true"
						EmptyListMsg=" --- #MSG_NoSeEncontraronRegistros# --- "
						tabindex="1"
					/> 	
				</td>
			</tr>
			</cfoutput>

			<tr>
				<td align="right"><strong><cf_translate key="LB_Poliza_Riesgos">P&oacute;liza de Riesgos</cf_translate>:&nbsp;</strong></td>
				<td>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_Seleccionar"
						Default="Seleccionar"
						XmlFile="/rh/generales.xml"
						returnvariable="LB_Seleccionar"/>
				
					<cfquery name="rs_poliza" datasource="#session.DSN#">
						select a.RHEDVid, a.RHEDVcodigo, a.RHEDVdescripcion, b.RHDDVlinea, b.RHDDVcodigo, b.RHDDVdescripcion, b.RHDDVvalor
						from RHEDatosVariables a, RHDDatosVariables b
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and a.RHEDVtipo = 1
						  and b.RHEDVid=a.RHEDVid
						order by a.RHEDVcodigo	, b.RHDDVcodigo					
					</cfquery>
					<select name="RHDDVlinea">
						<option value=""><cfoutput>-#LB_Seleccionar#-</cfoutput></option>
						<cfoutput query="rs_poliza" group="RHEDVcodigo">
						<optgroup label="#trim(rs_poliza.RHEDVcodigo)# - #rs_poliza.RHEDVdescripcion#" >
							<cfoutput>
							<option value="#rs_poliza.RHDDVlinea#" <cfif isdefined("rsForm.RHDDVlinea") and rsForm.RHDDVlinea eq rs_poliza.RHDDVlinea>selected</cfif> >#trim(rs_poliza.RHDDVcodigo)# - #rs_poliza.RHDDVdescripcion#</option>
							</cfoutput>
						</optgroup>
						</cfoutput>
					</select>
				</td>
			</tr>

			<tr>
				<td align="right"><strong><cf_translate key="LB_Poliza_Fidelidad">P&oacute;liza de Fidelidad</cf_translate>:&nbsp;</strong></td>
				<td>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_Seleccionar"
						Default="Seleccionar"
						XmlFile="/rh/generales.xml"
						returnvariable="LB_Seleccionar"/>
				
					<cfquery name="rs_poliza" datasource="#session.DSN#">
						select a.RHEDVid, a.RHEDVcodigo, a.RHEDVdescripcion, b.RHDDVlinea, b.RHDDVcodigo, b.RHDDVdescripcion, b.RHDDVvalor
						from RHEDatosVariables a, RHDDatosVariables b
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and a.RHEDVtipo = 2
						  and b.RHEDVid=a.RHEDVid
						order by a.RHEDVcodigo	, b.RHDDVcodigo					
					</cfquery>
					<select name="RHDDVlineaFidelidad">
						<option value=""><cfoutput>-#LB_Seleccionar#-</cfoutput></option>
						<cfoutput query="rs_poliza" group="RHEDVcodigo">
						<optgroup label="#trim(rs_poliza.RHEDVcodigo)# - #rs_poliza.RHEDVdescripcion#" >
							<cfoutput>
							<option value="#rs_poliza.RHDDVlinea#" <cfif isdefined("rsForm.RHDDVlineaFidelidad") and rsForm.RHDDVlineaFidelidad eq rs_poliza.RHDDVlinea>selected</cfif> >#trim(rs_poliza.RHDDVcodigo)# - #rs_poliza.RHDDVdescripcion#</option>
							</cfoutput>
						</optgroup>
						</cfoutput>
					</select>
				</td>
			</tr>
			<!--- 2019-03-07 OPARRALES Modificacion para agregar Factor de Horas Extras. --->
			<cfoutput>
				<tr>
					<td align="right">
						<strong>
							<cf_translate key="LB_Horas_Dobles">Factor de Horas Extras Dobles</cf_translate>:&nbsp;
						</strong>
					</td>
					<td>
						<input name="txtHE2" id="txtHE2" type="text" tabindex="1" 
							value="<cfif modo neq 'ALTA'>#Trim(rsForm.HE2)#<cfelse>0</cfif>" 
							size="10" maxlength="10" 
							onFocus="javascript:this.select(); this.value=qf(this);"> 
					</td>
				</tr>
				
				<tr>
					<td align="right">
						<strong>
							<cf_translate key="LB_Horas_Triples">Factor de Horas Extras Triples</cf_translate>:&nbsp;
						</strong>
					</td>
					<td>
						<input name="txtHE3" id="txtHE3" type="text" tabindex="1" 
							value="<cfif modo neq 'ALTA'>#Trim(rsForm.HE3)#<cfelse>0</cfif>" 
							size="10" maxlength="10" 
							onFocus="javascript:this.select(); this.value=qf(this); ">
					</td>
				</tr>
			</cfoutput>
			



			<cfoutput>
			<cfif modo neq 'ALTA'>
				<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec" />
				<cfset dataUsuario = sec.getUsuarioByCodNoEmp(rsForm.BMusuario,'DatosEmpleado') >
				<!---<cfset dataUsuario = sec.Pnombre & " " & sec.Papellido1 & " " & sec.Papellido2 >--->
				<tr>
					<td align="right"><strong><cf_translate key="LB_FechaDeCreacion">Fecha de Creaci&oacute;n</cf_translate>:&nbsp;</strong></td>
					<td>#LSDateFormat(rsForm.BMfecha ,'dd/mm/yyyy')#</td>
				</tr>
				<tr>
					<td align="right"><div align="right"><strong><cf_translate key="LB_UsuarioDeCreacion">Usuario de Creaci&oacute;n</cf_translate>:&nbsp;</strong></div></td>
					<td>#dataUsuario.Pnombre# #dataUsuario.Papellido1# #dataUsuario.Papellido2#</td>
				</tr>
				<tr>
					<td align="right"><div align="right"><strong><cf_translate key="LB_FechaDeModificacion">Fecha de Modificaci&oacute;n</cf_translate>:&nbsp;</strong></div></td>
					<td><cfif len(trim(rsForm.BMfechamod)) >#LSDateFormat(rsForm.BMfechamod ,'dd/mm/yyyy')#<cfelse>-</cfif></td>
				</tr>
				<tr>
					<td align="right"><div align="right"><strong><cf_translate key="LB_UsuarioDeModificacion">Usuario de Modificac&oacute;n</cf_translate>:&nbsp;</strong></div></td>
					<td>
						<cfif len(trim(rsForm.BMusumod))>
							<cfset dataUsuarioMod = sec.getUsuarioByCodNoEmp(rsForm.BMusumod, 'DatosEmpleado') >
							#dataUsuarioMod.Pnombre# #dataUsuarioMod.Papellido1# #dataUsuarioMod.Papellido2#
						<cfelse>
							-
						</cfif>
					</td>
				</tr>
			</cfif>
			<tr><td colspan="2"></td></tr>	
			<tr>
				<td colspan="2" align="center">
					<cfinclude template="/rh/portlets/pBotones.cfm">
				</td>
			</tr>
			<cfset ts = "">	
			<cfif modo neq "ALTA">
				<cfinvoke 
					component="sif.Componentes.DButils"
					method="toTimeStamp"
					returnvariable="ts">
					<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
				</cfinvoke>
			</cfif>
			<tr>
				<td>
					<input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>">
				</td>
			</tr>
		</cfoutput>
		</table>  

</form>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Codigo"
	Default="Código"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_Codigo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Descripcion"
	Default="Descripción"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_PuestoPresupuestario"
	Default="Puesto Presupuestario"
	returnvariable="MSG_PuestoPresupuestario"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Ocupacion"
	Default="Ocupación"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_Ocupacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Tipo"
	Default="Tipo"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_Tipo"/>


<script language="JavaScript1.2" type="text/javascript">

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
<cfoutput>
	objForm.RHPcodigo.required = true;
	objForm.RHPcodigo.description="#MSG_Codigo#";
	objForm.RHPdescpuesto.required = true;
	objForm.RHPdescpuesto.description="#MSG_Descripcion#";
	<cfif vb_planillap>
		objForm.RHMPPid.required = true;
	</cfif>
	objForm.RHMPPid.description = "#MSG_PuestoPresupuestario#";
	//objForm.RHOcodigo.required = true;
	objForm.RHOcodigo.description="#MSG_Ocupacion#";
	//objForm.RHTPid.required = true;
	objForm.RHTPid.description="#MSG_Tipo#";
</cfoutput>	
	var popUpWin=0;
	//Levanta el Conlis
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
	
	function cambiaGrupo(obj){
		/*
		if(obj.value != '-1'){
			document.getElementById("detMatGrupo").style.display = '';
		}else{
			document.getElementById("detMatGrupo").style.display = 'none';		
		}
		*/
	}
		
	function doConlisMateriaGrupo(){
		var params ="";
		params = "?RHGMid=" + document.form1.RHGMid.value;
		popUpWindow("/cfmx/rh/admin/catalogos/matXgrupo.cfm"+params,250,200,650,400);
	}
	
	
	function deshabilitarValidacion(){		
		objForm.RHPcodigo.required = false;
		objForm.RHPdescpuesto.required = false;
		objForm.RHOcodigo.required = false;
		objForm.RHTPid.required = false;
		objForm.RHMPPid.required = false;
	}
	
	function deshabilitarValidacion(){		
		objForm.RHPcodigo.required = true;
		objForm.RHPdescpuesto.required = true;		
		//objForm.RHOcodigo.required = true;
		//objForm.RHTPid.required = true;
	}

	function inicio(){
		return true;
	}
	
	function fin(){
		objForm.RHPcodigo.obj.disabled = false;
		return true;
	}
	
	inicio();
	cambiaGrupo(document.form1.RHGMid);

</script>
