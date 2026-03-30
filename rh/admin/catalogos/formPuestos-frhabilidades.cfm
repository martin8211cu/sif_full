<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_Primordial" default="Primordial" returnvariable="LB_Primordial" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Basica" default="Básica" returnvariable="LB_Basica"component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Complementaria" default="Complementaria"returnvariable="LB_Complementaria" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Deseable" default="Deseable" returnvariable="LB_Deseable" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Nivel" default="Nivel" returnvariable="LB_Nivel" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_PesoJefe" default="Peso Jefe" returnvariable="LB_PesoJefe" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Peso" default="Peso" returnvariable="LB_Peso" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Habilidad" default="Habilidad" returnvariable="LB_Habilidad" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Descripcion" default="Descripci&oacute;n" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="BTN_Modificar" default="Modificar" returnvariable="BTN_Modificar" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="BTN_Eliminar" default="Eliminar" returnvariable="BTN_Eliminar" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="BTN_Nuevo" default="Nuevo" returnvariable="BTN_Nuevo" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="MSG_DeseaEliminarElRegegistro" default="Desea eliminar el registro?" returnvariable="MSG_DeseaEliminarElRegegistro" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="MSG_ElPorcentajeDebeEstarEnElRango0_100" default="El porcentaje debe estar en el rango 0-100." returnvariable="MSG_ElPorcentajeDebeEstarEnElRango0_100" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Nivel" default="Nivel" returnvariable="MSG_Nivel" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="MSG_Habilidad" default="Habilidad" returnvariable="MSG_Habilidad" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_ListaDeItems" default="Lista de Items" returnvariable="MSG_ListaDeItems" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_NoSeEncontraronItemsPorHabilidad" default="No se encontraron Items por Habilidad" returnvariable="MSG_NoSeEncontraronItemsPorHabilidad" component="sif.Componentes.Translate" method="Translate"/>

<cfinvoke Key="LB_Codigo" Default="C&oacute;digo" returnvariable="LB_Codigo" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<!-- Establecimiento del modo -->
<cfset modo = 'ALTA'>
<cfif isdefined("form.RHHid") and len(trim(form.RHHid))>
	<cfset modo = 'CAMBIO'>
</cfif>

<!--- Consultas --->

<!--- Form --->
<cfquery name="data_puesto" datasource="#session.DSN#">
	select coalesce(RHPcodigoext, RHPcodigo) as RHPcodigoext,RHPcodigo, RHPdescpuesto
	from RHPuestos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
</cfquery>
<cfquery name="data_bezinger" datasource="#session.DSN#">
	select Pvalor
	from RHParametros
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Pcodigo=450
</cfquery>

<cfif modo neq 'ALTA'>
	<cfquery name="rsForm" datasource="#session.DSN#">
		select a.RHHid, a.RHPcodigo, a.Ecodigo, a.RHNid, 
			   a.RHNnotamin*100 as RHNnotamin, a.RHHtipo, b.RHPdescpuesto, 
			   c.RHHcodigo, c.RHHdescripcion, RHHpeso,RHHpesoJefe, a.ubicacionB,
			   a.PCid,RHIHid
		from RHHabilidadesPuesto a, RHPuestos b, RHHabilidades c
		where a.Ecodigo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and b.Ecodigo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and c.Ecodigo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and b.RHPcodigo 	= <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
		  and a.RHHid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHid#">
		  and a.RHPcodigo	= b.RHPcodigo
		  and a.Ecodigo		= b.Ecodigo
		  and a.RHHid		= c.RHHid
	</cfquery>
</cfif>

<!--- niveles --->
<cfquery name="rsNiveles" datasource="#session.dsn#">
	select 	RHNid, 
			RHNcodigo,RHNdescripcion as RHNdescripcion,
			{fn concat(<cf_dbfunction name="string_part" args="RHNdescripcion,1,57">,'...')} as RHNdescCorto
	from RHNiveles
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and RHNhabcono = 'H'
	order by RHNcodigo
</cfquery>

<!--- Cuestionarios ---->
<cfquery name="rsCuestionarios" datasource="#session.dsn#">
	select b.PCnombre, b.PCid, b.PCcodigo
	from RHEvaluacionCuestionarios a
			inner join PortalCuestionario b
				on a.PCid = b.PCid
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!--- Javascript --->
<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript1.2" type="text/javascript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script>

<table width="100%">
	<tr width="50%">
		<td align="left" valign="top">

			<cfset navegar = "">
			<cfset navegar = navegar & "&filtrado=Filtrar">
			<cfif isdefined("Form.sel")>
				<cfset navegar = navegar & "&sel=#form.sel#" >
			</cfif>
			<cfif isdefined("Form.o")>
				<cfset navegar = navegar & "&o=#form.o#" >
			</cfif>
			<cfif isdefined("Form.RHPcodigo")>
				<cfset navegar = navegar & "&RHPcodigo=#trim(form.RHPcodigo)#">
			</cfif>
			<cfif isdefined("Form.codigoFiltro") and Len(Trim(Form.codigoFiltro)) NEQ 0>
				<cfset navegar = navegar & "&codigoFiltro=#Form.codigoFiltro#" >
			</cfif>
			<cfif isdefined("Form.descripcionFiltro") and Len(Trim(Form.descripcionFiltro)) NEQ 0>
				<cfset navegar = navegar & "&descripcionFiltro=#Form.descripcionFiltro#">
			</cfif>
			

			<cfquery name="rsLista" datasource="#session.DSN#">
				select  d.RHPcodigo, b.RHHid, b.RHHcodigo, 
						{fn concat(<cf_dbfunction name="string_part" args="b.RHHdescripcion,1,45">,'...')} as RHHdescripcion,  
						a.RHNid, c.RHNcodigo,a.RHHtipo,a.RHHpeso,a.RHHpesoJefe,
						a.ubicacionB,
						case a.RHHtipo 
						when 0 then '#LB_Primordial#' 
						when 1 then '#LB_Basica#' 
						when 2 then '#LB_Complementaria#' 
						when 3 then '#LB_Deseable#' end as tipo_descripcion,
						a.RHNnotamin, '#form.o#' as o, '#form.sel#' as sel,
						b.RHHcodigo
				from RHHabilidadesPuesto a 
					inner join  RHHabilidades b 
						on a.RHHid = b.RHHid
					left outer join RHNiveles c
						on a.Ecodigo = c.Ecodigo
						and a.RHNid = c.RHNid
						and c.Ecodigo = #session.Ecodigo#
					left outer join RHPuestos d
					    on a.Ecodigo = d.Ecodigo
						and a.RHPcodigo = d.RHPcodigo
				where d.RHPcodigo = '#form.RHPcodigo#'
				and a.Ecodigo = #session.Ecodigo#
				order by RHHtipo, RHHdescripcion
			</cfquery>
				   
			<cfset filtro = " a.RHPcodigo = '#form.RHPcodigo#'
				   and a.Ecodigo = #session.Ecodigo#
				   and c.Ecodigo = #session.Ecodigo#
				   and a.RHHid = b.RHHid
				   and a.Ecodigo*=c.Ecodigo
				   and a.RHNid*=c.RHNid
				   order by RHHtipo, RHHdescripcion" >
				   
			<cfinvoke 
			 component="rh.Componentes.pListas"
			 method="pListaQuery"
			 returnvariable="pListaEmpl">
				<cfinvokeargument name="query" value="#rsLista#"/>
				<cfinvokeargument name="desplegar" value="RHHcodigo,RHHdescripcion,RHNcodigo,ubicacionB,RHHpeso,RHHpesoJefe"/>
				<cfinvokeargument name="etiquetas" value="#LB_Habilidad#, #LB_Descripcion#,#LB_Nivel#,Benziger,#LB_Peso#,#LB_PesoJefe#"/>
				<cfinvokeargument name="formatos" value="S,S,S,S,M,M"/>
				<cfinvokeargument name="formName" value="listahabilidades"/>
				<cfinvokeargument name="align" value="lef, left, center, center,right,right"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="Puestos.cfm"/>
				<cfinvokeargument name="debug" value="N"/>
				<cfinvokeargument name="Cortes" value="tipo_descripcion"/>
				<cfinvokeargument name="navegacion" value="#navegar#"/>
				<cfinvokeargument name="keys" value="RHPcodigo,RHHid"/>
			</cfinvoke>
		</td>

		<td valign="top" align="center">
			<form name="form1" method="post" action="SQLPuestos-frhabilidades.cfm">
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					key="MSG_EliminarHabilidadRequeridaParaEstePuesto"
					default="Eliminar habilidad requerida para este puesto"
					returnvariable="MSG_EliminarHabilidadRequeridaParaEstePuesto"/>
			
			<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="#MSG_EliminarHabilidadRequeridaParaEstePuesto#." style="display:none;">
			<cfoutput>
			  <table align="center" width="90%" border="0" cellspacing="0" cellpadding="0">
		
				<tr><td nowrap align="left" colspan="6">&nbsp;</td></tr>
			
				<tr>
					<td colspan="6" align="center">
						<table width="100%">
							<tr> 
							  <td nowrap align="right"><strong><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate>:&nbsp;</strong></td>
							  <td nowrap>#Trim(data_puesto.RHPcodigoext)#</td>
							</tr>
						
							<tr>
							  <td nowrap align="right"><strong><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate>:&nbsp;</strong></td>
							  <td nowrap >#data_puesto.RHPdescpuesto# </td>
							</tr>
						
							<tr>
							  <td nowrap align="right"><strong><cf_translate key="LB_Habilidad">Habilidad</cf_translate>:&nbsp;</strong></td>
							  <td nowrap >
							  	<table>
									<tr>
										<td nowrap>
							  				<cfif modo neq 'ALTA'>
												<cf_rhhabilidad query="#rsForm#" tabindex="1" size="30">
												<input type="hidden" name="RHHid_2" value="#rsForm.RHHid#">
											<cfelse>
												<cf_rhhabilidad tabindex="1" size="25">
											</cfif>
										</td>
										<td nowrap></td>
									</tr>
								</table>
							</tr>
							<tr>
							  <td nowrap align="right"><strong><cf_translate key="LB_ItemHabilidad">Item Habilidad</cf_translate>:&nbsp;</strong></td>
							  <td nowrap >
							  	<table>
									<tr>
										<td nowrap>
											<cfif modo neq 'ALTA' and LEN(TRIM(rsform.RHIHid))>
												<cfquery name="rsItem" datasource="#session.DSN#">
													select RHIHid,RHIHorden,RHIHdescripcion
													from RHIHabilidad
													where RHHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsform.RHHid#">
													  and RHIHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsform.RHIHid#">
												</cfquery>
												<cfset vArrayItem=ArrayNew(1)>
												<cfset ArrayAppend(vArrayItem,rsItem.RHIHid)>
												<cfset ArrayAppend(vArrayItem,rsItem.RHIHorden)>
												<cfset ArrayAppend(vArrayItem,rsItem.RHIHdescripcion)>
											<cfelse><cfset vArrayItem=ArrayNew(1)></cfif>
							  				<cf_conlis
												campos="RHIHid,RHIHorden,RHIHdescripcion"
												desplegables="N,S,S"
												modificables="N,S,N"
												size="0,10,25"
												title="#MSG_ListaDeItems#"
												tabla="RHIHabilidad"
												columnas="RHIHid,RHIHorden,RHIHdescripcion"
												filtro="RHHid = $RHHid,numeric$
															order by RHIHorden"
												desplegar="RHIHorden,RHIHdescripcion"
												filtrar_por="RHIHorden,RHIHdescripcion"
												etiquetas="#LB_Codigo#, #LB_Descripcion#"
												formatos="S,S"
												align="left,left"
												asignar="RHIHid,RHIHorden,RHIHdescripcion"
												asignarformatos="S, S, S"
												showEmptyListMsg="true"
												EmptyListMsg="-- #MSG_NoSeEncontraronItemsPorHabilidad# --"
												tabindex="1"
												valuesArray="#vArrayItem#">
										</td>
										<td nowrap></td>
									</tr>
								</table>
							</tr>
							<tr align="center">
							  <td align="right"><strong><cf_translate key="LB_Nivel" XmlFile="/rh/generales.xml">Nivel</cf_translate>:&nbsp;</strong></td>
							  <td align="left">
								<select name="RHNid" tabindex="1" style="width:275px;">
									<cfloop query="rsNiveles">
										<option value="#RHNid#" <cfif modo neq 'ALTA' and rsNiveles.RHNid eq rsForm.RHNid>selected</cfif>   >#RHNcodigo# - <cfif len(#RHNdescripcion#) GT 60>#RHNdescCorto#<cfelse>#RHNdescripcion#</cfif></option>
									</cfloop>
								</select>
							  </td>
							</tr>
			
							<tr align="center">
							  <td align="right"><strong><cf_translate key="LB_Tipo">Tipo</cf_translate>:&nbsp;</strong></div></td>
							  <td align="left" >
								<select name="RHHtipo" tabindex="1">
									<option value="0" <cfif modo neq 'ALTA' and rsForm.RHHtipo eq 0 >selected</cfif> ><cf_translate key="CMB_Primordial">Primordial</cf_translate></option>
									<option value="1" <cfif modo neq 'ALTA' and rsForm.RHHtipo eq 1 >selected</cfif> ><cf_translate key="CMB_Basica">B&aacute;sica</cf_translate></option>
									<option value="2" <cfif modo neq 'ALTA' and rsForm.RHHtipo eq 2 >selected</cfif> ><cf_translate key="CMB_Complementaria">Complementaria</cf_translate></option>
									<option value="3" <cfif modo neq 'ALTA' and rsForm.RHHtipo eq 3 >selected</cfif> ><cf_translate key="CMB_Deseable">Deseable</cf_translate></option>
								</select>
							  </td>
							</tr>
			
							<tr align="center">
                              <td align="right" nowrap><strong><cf_translate key="LB_NotaMinima">Nota M&iacute;nima</cf_translate>:&nbsp;</strong></td>
                              <td align="left" >
                                <input type="text" name="RHNnotamin" tabindex="1" size="6" maxlength="3"
									value="<cfif modo neq 'ALTA' and len(trim(rsForm.RHNnotamin))>#LSNumberFormat(rsForm.RHNnotamin,',9')#</cfif>"  
									style="text-align:right" 
									onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" 
									onblur="javascript:fm(this,0); porcentaje(this);" 
									onfocus="this.select();">
                              </td>
						  </tr>
							<tr align="center">
							  <td align="right" nowrap><strong><cf_translate key="LB_Peso" XmlFile="/rh/generales.xml">Peso</cf_translate>:&nbsp;</strong></div></td>
							  <td align="left" >
								<input type="text" name="RHHpeso" size="6" maxlength="6" tabindex="1"
									value="<cfif modo neq 'ALTA' and len(trim(rsForm.RHHpeso))>#LSNumberFormat(rsForm.RHHpeso,'___.__')#</cfif>" 
									style="text-align:right" 
									onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
									onblur="javascript:fm(this,2); porcentaje(this);" 
									onfocus="this.select();">
							  </td>
							</tr>	
							<tr align="center">
							  <td align="right" nowrap><strong><cf_translate key="LB_PesoJefatura" XmlFile="/rh/generales.xml">Peso por Jefatura</cf_translate>:&nbsp;</strong></div></td>
							  <td align="left" >
								<input type="text" name="RHHpesoJefe" size="6" maxlength="6" tabindex="1"
									value="<cfif modo neq 'ALTA' and len(trim(rsForm.RHHpesoJefe))>#LSNumberFormat(rsForm.RHHpesoJefe,'___.__')#</cfif>" 
									style="text-align:right" 
									onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
									onblur="javascript:fm(this,2); porcentaje(this);" 
									onfocus="this.select();">
							  </td>
							</tr>		
							<cfif data_bezinger.Pvalor eq 1 >
								<tr align="center">
								  <td align="right" nowrap><strong><cf_translate key="LB_UbicacionBenziger">Ubicaci&oacute;n Benziger</cf_translate>:&nbsp;</strong></div></td>
								  <td align="left" >
									<select name="ubicacionB" tabindex="1">
										<option value=""></option>
										<option value="BL" <cfif modo neq 'ALTA' and rsForm.ubicacionB eq 'BL' >selected</cfif>><cf_translate key="CMB_BasalIzq">Basal Izquierdo</cf_translate></option>
										<option value="BR" <cfif modo neq 'ALTA' and rsForm.ubicacionB eq 'BR' >selected</cfif>><cf_translate key="CMB_BasalDer">Basal Derecho</cf_translate></option>
										<option value="FR" <cfif modo neq 'ALTA' and rsForm.ubicacionB eq 'FR' >selected</cfif>><cf_translate key="CMB_FrontalDer">Frontal Derecho</cf_translate></option>
										<option value="FL" <cfif modo neq 'ALTA' and rsForm.ubicacionB eq 'FL' >selected</cfif>><cf_translate key="CMB_FrontalIzq">Frontal Izquierdo</cf_translate></option>
									</select>
								  </td>
								</tr>
							</cfif>
							<tr>
								<td align="right" nowrap><strong><cf_translate key="LB_Cuestionario">Cuestionario</cf_translate>:</strong>&nbsp;</td>
								<td>							
									<select name="PCid" id="PCid" tabindex="1" style="width:275px;">
										<option value="">--- <cf_translate key="CMB_NoEspecificado" XmlFile="/rh/generales.xml">No especificado</cf_translate> ---</option> 
										<cfloop query="rsCuestionarios">
											<option value="#rsCuestionarios.PCid#" <cfif modo NEQ 'ALTA' and rsCuestionarios.PCid EQ rsForm.PCid>selected</cfif>>#HTMLEditFormat(rsCuestionarios.PCcodigo)#-#HTMLEditFormat(rsCuestionarios.PCnombre)#</option>
										</cfloop>
									</select>
								</td>
							</tr>
							<tr><td colspan="2" align="center">&nbsp;</td></tr>
							
							<tr>
								<cfif isdefined("Aprobacion") and len(trim(Aprobacion)) and Aprobacion eq 'A'>	
									<td colspan="2" align="center">
										<cfif modo neq 'ALTA'>
	
											<input type="submit" name="Modificar" value="#BTN_Modificar#" tabindex="1">	
											<input type="submit" name="Eliminar" value="#BTN_Eliminar#" tabindex="1" onclick="javascript:if (confirm('#MSG_DeseaEliminarElRegegistro#')) {deshabilitarValidacion(); return true;} return false;">
											<input type="submit" name="Nuevo" value="#BTN_Nuevo#" tabindex="1" onclick="javascript:deshabilitarValidacion()" >
										<cfelse>
											<cfinvoke component="sif.Componentes.Translate"
												method="Translate"
												key="BTN_Agregar"
												default="Agregar"
												xmlfile="/rh/generales.xml"
												returnvariable="BTN_Agregar"/>
											<input type="submit" name="Agregar" value="#BTN_Agregar#" tabindex="1">
										</cfif>
									</td>
								<cfelse>
								   <td class="ayuda" colspan="2"><cf_translate key="MSG_ParaPoderAgregarOModificarHabilidadesConductualesDebeDeRealizarloDesdeElPerfilIdealDelPuesto">Para poder agregar o modificar habilidades conductualess debe de realizarlo desde el perfil ideal del puesto</cf_translate>.</td>
								</cfif>
							</tr>

						</table>
					</td>
				</tr>
			
				<tr><td colspan="6">&nbsp;</td></tr>
				
				<tr>
				  <td nowrap colspan="6">
					<input type="hidden" name="RHPcodigo" id="RHPcodigo" value="#Trim(data_puesto.RHPcodigo)#">
					<input type="hidden" name="PageNum" value="<cfif isdefined("form.PageNum")>#form.PageNum#<cfelseif isdefined("url.PageNum_Lista")>#url.PageNum_Lista#<cfelse>1</cfif>">
				  </td>
				</tr>
			  </table>
			</cfoutput>
			</form>
	</td></tr>							
</table>

<script language="JavaScript1.2" type="text/javascript">
	function funcRHHid(){
		//alert('PCid_RHHid ' + document.form1.PCid_RHHid.value + ' -- RHHubicacionB_RHHid ' + document.form1.RHHubicacionB_RHHid.value)
		
		<cfif isdefined('data_bezinger') and data_bezinger.recordCount GT 0>
			<cfif data_bezinger.Pvalor EQ 1>
				if(document.form1.RHHubicacionB_RHHid.value != '')
					document.form1.ubicacionB.value = document.form1.RHHubicacionB_RHHid.value;
			</cfif>
		</cfif>

		if(document.form1.PCid_RHHid.value != ''){
			document.form1.PCid.value = document.form1.PCid_RHHid.value;
		}else{
			document.form1.PCid.value = '';
		}
	}
<cfoutput>
	function __isPorcentaje() {
		if (objForm.RHNnotamin.value < 0 || objForm.RHNnotamin.value > 100 ){
				this.error = "#MSG_ElPorcentajeDebeEstarEnElRango0_100#"
		}
	}

	qFormAPI.errorColor = "##FFFFCC";
	objForm = new qForm("form1");

	_addValidator("isPorcentaje", __isPorcentaje);

	objForm.RHHcodigo.required = true;
	objForm.RHNid.required = true;
	objForm.RHHcodigo.description = "#MSG_Habilidad#";
	objForm.RHNid.description = "#MSG_Nivel#";
	objForm.RHNnotamin.validatePorcentaje();		

	function deshabilitarValidacion(){
		objForm.RHHcodigo.required = false;
		objForm.RHNid.required = false;
	}
	function habilitarValidacion(){
		objForm.RHHcodigo.required = true;
		objForm.RHNid.required = true;
	}

	function porcentaje(obj){
		if (trim(obj.value) != '' && ( obj.value < 0 || obj.value > 100 ) ){
			mensaje = '#MSG_ElPorcentajeDebeEstarEnElRango0_100#';
			obj.value = '';
			alert(mensaje);
			return false;
		}
		return true;
	}
</cfoutput>	
</script>
