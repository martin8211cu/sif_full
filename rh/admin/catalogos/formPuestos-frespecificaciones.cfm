<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Limpiar" Default="Limpiar" returnvariable="BTN_Limpiar"/>
<cfif isdefined("url.RHPcodigo") and not isdefined("form.RHPcodigo")>
	<cfset form.RHPcodigo = url.RHPcodigo >
</cfif>

<cfset modo = 'ALTA'>

<cfif isdefined("form.RHDDVlinea") and len(trim(form.RHDDVlinea))>
	<cfset modo = 'CAMBIO'>	
</cfif>

<cfif modo EQ 'CAMBIO'>
	<cfquery name="data" datasource="#Session.DSN#">
		select a.Ecodigo, a.RHEDVid, a.RHDDVlinea, a.RHDDVvalor, a.RHDVPorden, a.BMUsucodigo, a.fechaalta
		from RHDVPuesto a, RHPuestos b
		where a.Ecodigo = b.Ecodigo and a.RHPcodigo = b.RHPcodigo
		and b.RHPcodigo = <cfqueryparam value="#form.RHPcodigo#" cfsqltype="cf_sql_char">
		and a.Ecodigo = <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer">
		and a.RHDDVlinea = <cfqueryparam value="#form.RHDDVlinea#" cfsqltype="cf_sql_numeric">
	</cfquery>
</cfif>

<cfquery name="rsLista" datasource="#session.DSN#">
	select  d.RHPcodigo,
			a.RHDDVlinea, 
			a.RHEDVid,	
			a.RHDVPorden,
			b.RHDDVcodigo,
			b.RHDDVdescripcion, 
			c.RHEDVdescripcion,
			c.RHEDVcodigo,
			{fn concat('<img border=''0'' onClick=''javascript: eliminar("', 
			{fn concat(rtrim(a.RHPcodigo),
			{fn concat('","',
			{fn concat(<cf_dbfunction name="to_char" args="a.RHDDVlinea">,'");'' src=''/cfmx/rh/imagenes/Borrar01_S.gif''>')})})})}
			 as borrar,
			'#form.o#' as o, '#form.sel#' as sel
	from  RHDVPuesto a								
			left outer join RHDDatosVariables b
				on a.RHDDVlinea = b.RHDDVlinea
				and a.Ecodigo = b.Ecodigo
			left outer join RHEDatosVariables c
				on a.RHEDVid = c.RHEDVid
				and a.Ecodigo = c.Ecodigo	
			left outer join RHPuestos d
			    on a.Ecodigo = d.Ecodigo
				and a.RHPcodigo = d.RHPcodigo 
	where d.RHPcodigo = <cfqueryparam value="#form.RHPcodigo#" cfsqltype="cf_sql_char">
		and a.Ecodigo = <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer">
	order by b.RHDDVdescripcion				
</cfquery>

<table width="100%">
	<tr>
		<td width="49%" valign="top">								
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_CodigoValor"
				Default="C&oacute;digo Valor"
				XmlFile="/rh/generales.xml"
				returnvariable="LB_CodigoValor"/>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Descripcion"
				Default="Descripci&oacute;n"
				XmlFile="/rh/generales.xml"
				returnvariable="LB_Descripcion"/>

			
			<cfif isdefined("Aprobacion") and len(trim(Aprobacion)) and Aprobacion eq 'A'>
				<cfinvoke
						component="rh.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet"> 
					<cfinvokeargument name="query" value="#rsLista#"/> 
					<cfinvokeargument name="desplegar" value="RHDDVcodigo, RHDDVdescripcion, borrar"/> 
					<cfinvokeargument name="etiquetas" value="#LB_CodigoValor#, #LB_Descripcion#, "/> 
					<cfinvokeargument name="formatos" value="S,S,S"/> 
					<cfinvokeargument name="align" value="left,left,right"/> 
					<cfinvokeargument name="ajustar" value="N"/> 
					<cfinvokeargument name="checkboxes" value="N"/> 
					<cfinvokeargument name="irA" value="Puestos.cfm"/> 
					<cfinvokeargument name="keys" value="RHDDVlinea"/> 
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="cortes" value="RHEDVcodigo"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
				</cfinvoke> 			
			<cfelse>
				<cfinvoke
						component="rh.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet"> 
					<cfinvokeargument name="query" value="#rsLista#"/> 
					<cfinvokeargument name="desplegar" value="RHDDVcodigo, RHDDVdescripcion"/> 
					<cfinvokeargument name="etiquetas" value="#LB_CodigoValor#, #LB_Descripcion#"/> 
					<cfinvokeargument name="formatos" value="S,S"/> 
					<cfinvokeargument name="align" value="left,left"/> 
					<cfinvokeargument name="ajustar" value="N"/> 
					<cfinvokeargument name="checkboxes" value="N"/> 
					<cfinvokeargument name="irA" value="Puestos.cfm"/> 
					<cfinvokeargument name="keys" value="RHDDVlinea"/> 
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="cortes" value="RHEDVcodigo"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
				</cfinvoke> 			
			</cfif>
		</td>
		<td valign="top" align="center">
			<form name="form1" method="post" action="SQLPuestosEspecificaciones.cfm" onSubmit="javascript: return valida();">
				<!---Input con las variables para navegar en los tabs --->
				<input name="sel" type="hidden" value="1">
				<input name="o" type="hidden" value="4">
				
				<input type="hidden" name="RHPcodigo" value="<cfoutput>#form.RHPcodigo#</cfoutput>">				
					
				<cfoutput>
			  	<table align="center" width="98%" border="0" cellspacing="0" cellpadding="0">
					<tr>
					<td width="2%">&nbsp;</td>
					<td valign="middle">
						<table>
							<tr>
								<td nowrap align="right"><strong><cf_translate key="LB_DatosVariables" XmlFile="/rh/generales.xml">Datos Variables</cf_translate>:</strong></td>
								<td width="87%" align="right">
									<cfset id = ""> <!--- RHEDVID del registro en modo cambio---->

									<cfif modo EQ "CAMBIO">
										<cfset id = data.RHEDVid>
									</cfif>
									<cf_rhDatosVariables idquery="#id#" tabindex="1">
									<cfif modo EQ 'ALTA'>
										<cfset form.RHEDVcodigo = ''>
										<cfset form.RHEDVdescripcion = ''>
										<cfset form.RHDDVcodigo = ''>
										<cfset form.RHDDVdescripcion = ''>
									</cfif>
								</td>
							</tr>

							<tr>
								<td nowrap align="right"><strong><cf_translate key="LB_Valores" XmlFile="/rh/generales.xml">Valores</cf_translate>:&nbsp;</strong></td>								
								<td width="87%" align="right">
									<cfset linea = ""> <!--- RHDDVlinea del registro en modo cambio---->
									<!---
									<cfif isdefined("form.RHDDVlinea") and len(trim(form.RHDDVlinea))>
										<cfset linea = form.RHDDVlinea >
									</cfif>
									--->
									<cfif modo EQ "CAMBIO">
										<cfset linea = data.RHDDVlinea>
									</cfif>
									<cf_rhDatosVariablesD filtrado="S" idquery ="#linea#" tabindex="1">
								</td>
							</tr>
							<tr>
								<td nowrap  align="right"><strong><cf_translate key="LB_Orden" XmlFile="/rh/generales.xml">Orden</cf_translate>:&nbsp;</strong></td>
								<td>
                                	<cfif modo NEQ 'CAMBIO'>
										<cfset form.RHDVPorden = 1>
                                    </cfif>
                               		<cf_inputNumber name="RHDVPorden"  size="10" enteros="4" decimales="0" comas= "false" value="#form.RHDVPorden#">
							</tr>
							<tr>
							  <td nowrap align="right"><strong><cf_translate key="LB_Observacion" XmlFile="/rh/generales.xml">Observaci&oacute;n</cf_translate>:&nbsp;</strong></td>
							  <td>&nbsp;</td>
						    </tr>
							<tr>
							  <td colspan="2">
									<cfif modo EQ "CAMBIO">
										<cf_rheditorhtml name="RHDDVvalor" value="#Trim(data.RHDDVvalor)#" tabindex="1">
									<cfelse>
										<cf_rheditorhtml name="RHDDVvalor" tabindex="1">
									</cfif>
							  </td>
						    </tr>
							
							<tr>
								<cfif isdefined("Aprobacion") and len(trim(Aprobacion)) and Aprobacion eq 'A'>
									<cfif modo EQ 'CAMBIO'>
										<td align="center" colspan="2">
	
											<cfinvoke component="sif.Componentes.Translate"
												method="Translate"
												Key="BTN_Modificar"
												Default="Modificar"
												XmlFile="/rh/generales.xml"
												returnvariable="BTN_Modificar"/>
											<cfinvoke component="sif.Componentes.Translate"
												method="Translate"
												Key="BTN_Nuevo"
												Default="Nuevo"
												XmlFile="/rh/generales.xml"
												returnvariable="BTN_Nuevo"/>
											<cfinvoke component="sif.Componentes.Translate"
												method="Translate"
												Key="BTN_Recuperar"
												Default="Recuperar"
												returnvariable="BTN_Recuperar"/>
											<input type="submit" name="btnModificar" class="btnGuardar" value="#BTN_Modificar#" tabindex="1">
											<input type="button" name="btnNuevo" 	 class="btnNuevo" 	value="#BTN_Nuevo#" 	onClick="javascript: funcLimpia();" tabindex="1">
											<input type="button" name="btnRecuperar" class="BtnNormal"  value="#BTN_Recuperar#" onClick="javascript: recuperar(this.form);" tabindex="1">
											<input type="button" name="btnLimpiar" 	 class="btnLimpiar" value="#BTN_Limpiar#"   tabindex="1" onclick="LimpiarEditor()" />
											
										</td>
									<cfelse>
										<td align="center" colspan="2">
											<cfinvoke component="sif.Componentes.Translate"
												method="Translate"
												Key="BTN_Agregar"
												Default="Agregar"
												XmlFile="/rh/generales.xml"
												returnvariable="BTN_Agregar"/>
	
											<input type="submit" name="btnAgregar" class="BtnGuardar" value="#BTN_Agregar#" tabindex="1">
                                            <input type="button" name="btnLimpiar" class="btnLimpiar" value="#BTN_Limpiar#" tabindex="1" onclick="LimpiarEditor()" />
										</td>
									</cfif>
								<cfelse>
									<td class="ayuda" colspan="2"><cf_translate key="MSG_ParaPoderAgregarOModificarDatosVariablesDebeDeRealizarloDesdeElPerfilIdealDelPuesto">Para poder agregar o modificar datos variables debe de realizarlo desde el perfil ideal del puesto</cf_translate>.</td>
								</cfif>
							</tr>
							<cfif isdefined("Aprobacion") and len(trim(Aprobacion)) and Aprobacion eq 'A'>
							<cfif modo EQ 'CAMBIO'>
							<tr>
								<td colspan="2" class="areaFiltro">
									<cf_translate key="MSG_ElBotonRecuperarSeUtilizaParaPecuperarElValorOriginalDefinidoEnElCatalogoDeDatosVariables">
									El bot&oacute;n <strong>Recuperar</strong> se utiliza para recuperar 
									el valor original definido en el cat&aacute;logo de datos variables
									</cf_translate>
								</td>
							</tr>
							</cfif>
							</cfif>
						</table>
					</td>
					</tr>
			  	</table>
				</cfoutput>
			</form>
		</td>
	</tr>
</table>
<iframe name="frRecuperar" id="frRecuperar" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" style="visibility: hidden;"></iframe>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DeseaEliminarElDatoVariable"
	Default="Desea eliminar el Dato Variable?"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_DeseaEliminarElDatoVariable"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DebeSeleccionarUnDatoVariableYElValorDelMismo"
	Default="Debe seleccionar un dato variable y el valor del mismo"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_DebeSeleccionarUnDatoVariableYElValorDelMismo"/>

<script language="JavaScript1.2" type="text/javascript">	
	<!--- Funcion para recuperar el valor que hay en el catálogo de datos variables --->
<cfoutput>
	var oEditor = CKEDITOR.instances.RHDDVvalor;
	function recuperar(f) {
		var params = "?dato="+f.RHDDVlinea.value;
		var fr = document.getElementById("frRecuperar");
		fr.src = "formPuestos-recuperar.cfm"+params;
	}
	
	<!--- Función para llenar el campo de valor --->
	function fillValue(v) {
		oEditor.setData(v);
	}
	function LimpiarEditor()
	{
		oEditor.setData('');
	}

	//Funcion para limpiar los campos
	function funcLimpia(){
		document.form1.submit();						
	}
		
	//Funcion para eliminar un dato asigna al form de la lista los valores y lo envia
	function eliminar(CodPuesto, Linea){
		if (!confirm('#MSG_DeseaEliminarElDatoVariable#')) return false;				
			document.lista.action = 'SQLPuestosEspecificaciones.cfm';			
			document.lista.RHDDVLINEA.value = Linea;
			document.lista.RHPCODIGO.value = CodPuesto;
			document.lista.submit();			
	}
	
	//Valida que el conlis 1 tenga datos
	function valida(){
		if (document.form1.RHEDVid.value == '' || document.form1.RHDDVlinea.value == ''){
			alert('#MSG_DebeSeleccionarUnDatoVariableYElValorDelMismo#');
			return false;
		}
		else{
			return true;
		}
	}
</cfoutput>	
</script>