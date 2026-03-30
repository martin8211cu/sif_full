<!-- Establecimiento del modoTab3 -->
<cfif form.USUARIO neq 'JEFECFNM'>
	<cfset modoTab3 = 'ALTA'>
	<cfif isdefined("form.RHHid") and len(trim(form.RHHid))>
		<cfset modoTab3 = 'CAMBIO'>
	</cfif>
	
	<!--- Consultas --->
	
	
	<cfquery name="data_bezinger" datasource="#session.DSN#">
		select Pvalor
		from RHParametros
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Pcodigo=450
	</cfquery>
	
	<cfif modoTab3 neq 'ALTA'>
		<cfquery name="rsForm" datasource="#session.DSN#">
			select a.RHHid, x.RHDPPid, x.Ecodigo, a.RHNid, 
				   a.RHNnotamin*100 as RHNnotamin, a.RHHtipo, 
				   c.RHHcodigo, c.RHHdescripcion, RHHpeso,RHHpesoJefe, a.ubicacionB,
				   a.PCid
			from RHHabilidadPuestoP a, RHDescripPuestoP x, RHHabilidades c
			where x.Ecodigo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and c.Ecodigo		=  x.Ecodigo
			  and a.RHDPPid	    = x.RHDPPid
			  and a.RHDPPid     = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHDPPid#">
			  and a.RHHid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHid#">
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
		select b.PCnombre, b.PCid,b.PCcodigo
		from RHEvaluacionCuestionarios a
				inner join PortalCuestionario b
					on a.PCid = b.PCid
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	
	<!--- Javascript --->
	<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
	<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
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
				<cfif isdefined("Form.USUARIO")>
					<cfset navegar = navegar & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "USUARIO=#trim(form.USUARIO)#">
				</cfif>
				
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Primordial"
					Default="Primordial"
					returnvariable="LB_Primordial"/>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Basica"
					Default="Básica"
					returnvariable="LB_Basica"/>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Complementaria"
					Default="Complementaria"
					returnvariable="LB_Complementaria"/>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Deseable"
					Default="Deseable"
					returnvariable="LB_Deseable"/>
	
				<cfquery name="rsLista" datasource="#session.DSN#">
					select  a.RHDPPid, b.RHHid, b.RHHcodigo, 
							{fn concat(<cf_dbfunction name="string_part" args="b.RHHdescripcion,1,45">,'...')} as RHHdescripcion,  
							a.RHNid, c.RHNcodigo,a.RHHtipo,a.RHHpeso,a.RHHpesoJefe,
							a.ubicacionB,
							case a.RHHtipo 
							when 0 then '#LB_Primordial#' 
							when 1 then '#LB_Basica#' 
							when 2 then '#LB_Complementaria#' 
							when 3 then '#LB_Deseable#' end as tipo_descripcion,
							a.RHNnotamin, '#form.o#' as o, '#form.sel#' as sel,
							b.RHHcodigo,'#form.USUARIO#' as usuario
					from RHHabilidadPuestoP a 
						inner join RHDescripPuestoP x
							on a.RHDPPid = x.RHDPPid
						inner join  RHHabilidades b 
							on a.RHHid = b.RHHid
						left outer join RHNiveles c
							on x.Ecodigo = c.Ecodigo
							and a.RHNid = c.RHNid
							and c.Ecodigo = #session.Ecodigo#
					where a.RHDPPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHDPPid#">
					and x.Ecodigo = <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer">
					order by RHHtipo, RHHdescripcion
				</cfquery>
					   
				<cfset filtro = " a.RHDPPid = '#form.RHDPPid#'
					   and x.Ecodigo = #session.Ecodigo#
					   and c.Ecodigo = #session.Ecodigo#
					   and a.RHHid = b.RHHid
					   and x.Ecodigo*=c.Ecodigo
					   and a.RHNid*=c.RHNid
					   order by RHHtipo, RHHdescripcion" >
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Nivel"
					Default="Nivel"
					returnvariable="LB_Nivel"/>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Peso"
					Default="Peso"
					returnvariable="LB_Peso"/>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_PesoJefe"
					Default="Peso Jefe"
					returnvariable="LB_PesoJefe"/>	
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Habilidad"
					Default="Habilidad"
					returnvariable="LB_Habilidad"/>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Descripcion"
					Default="Descripci&oacute;n"
					XmlFile="/rh/generales.xml"
					returnvariable="LB_Descripcion"/>
					   
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
					<cfif form.USUARIO eq 'ASESOR'>
						<cfinvokeargument name="irA" value="PerfilPuesto.cfm"/> 
					<cfelse>
						<cfinvokeargument name="irA" value="ApruebaPerfilPuesto.cfm"/> 
					</cfif>
					<cfinvokeargument name="debug" value="N"/>
					<cfinvokeargument name="Cortes" value="tipo_descripcion"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="navegacion" value="#navegar#"/>
					<cfinvokeargument name="keys" value="RHDPPid,RHHid,usuario"/>
					<!--- <cfinvokeargument name="MaxRows" value="3"/> --->
				</cfinvoke>
			</td>
	
			<td valign="top" align="center">
				<form name="formTB3" method="post" action="SQLPerfilPuesto.cfm">
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_EliminarHabilidadRequeridaParaEstePuesto"
						Default="Eliminar habilidad requerida para este puesto"
						returnvariable="MSG_EliminarHabilidadRequeridaParaEstePuesto"/>
				
				<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="#MSG_EliminarHabilidadRequeridaParaEstePuesto#." style="display:none;">
				<cfoutput>
				  <table align="center" width="90%" border="0" cellspacing="0" cellpadding="0">
			
					<tr><td nowrap align="left" colspan="6">&nbsp;</td></tr>
					<tr>
						<td bgcolor="##A0BAD3"  colspan="6">
							<cfinclude template="frame-botones2.cfm">
						</td>
				   </tr>
					<tr>
						<td colspan="6" align="center">
							<table width="100%">
								<tr>
								  <td nowrap align="right"><strong><cf_translate key="LB_Habilidad">Habilidad</cf_translate>:&nbsp;</strong></td>
								  <td nowrap >
									<table>
										<tr>
											<td nowrap>
												<cfif modoTab3 neq 'ALTA'>
													<cf_rhhabilidad query="#rsForm#" tabindex="1" size="25" form="formTB3">
													<input type="hidden" name="RHHid_2" value="#rsForm.RHHid#">
												<cfelse>
													<cf_rhhabilidad tabindex="1" size="25" form="formTB3">
												</cfif>
											</td>
											<td nowrap></td>
										</tr>
									</table>
								</tr>
							
								<tr align="center">
								  <td align="right"><strong><cf_translate key="LB_Nivel" XmlFile="/rh/generales.xml">Nivel</cf_translate>:&nbsp;</strong></td>
								  <td align="left">
									<select name="RHNid" tabindex="1" style="width:250px;">
										<!---<option value=""></option>--->
										<cfloop query="rsNiveles">
											<option value="#RHNid#" <cfif modoTab3 neq 'ALTA' and rsNiveles.RHNid eq rsForm.RHNid>selected</cfif>   >#RHNcodigo# - <cfif len(#RHNdescripcion#) GT 60>#RHNdescCorto#<cfelse>#RHNdescripcion#</cfif></option>
										</cfloop>
									</select>
								  </td>
								</tr>
				
								<tr align="center">
								  <td align="right"><strong><cf_translate key="LB_Tipo">Tipo</cf_translate>:&nbsp;</strong></div></td>
								  <td align="left" >
									<select name="RHHtipo" tabindex="1">
										<option value="0" <cfif modoTab3 neq 'ALTA' and rsForm.RHHtipo eq 0 >selected</cfif> ><cf_translate key="CMB_Primordial">Primordial</cf_translate></option>
										<option value="1" <cfif modoTab3 neq 'ALTA' and rsForm.RHHtipo eq 1 >selected</cfif> ><cf_translate key="CMB_Basica">B&aacute;sica</cf_translate></option>
										<option value="2" <cfif modoTab3 neq 'ALTA' and rsForm.RHHtipo eq 2 >selected</cfif> ><cf_translate key="CMB_Complementaria">Complementaria</cf_translate></option>
										<option value="3" <cfif modoTab3 neq 'ALTA' and rsForm.RHHtipo eq 3 >selected</cfif> ><cf_translate key="CMB_Deseable">Deseable</cf_translate></option>
									</select>
								  </td>
								</tr>
				
								<tr align="center">
								  <td align="right" nowrap><strong><cf_translate key="LB_NotaMinima">Nota M&iacute;nima</cf_translate>:&nbsp;</strong></td>
								  <td align="left" >
									<input type="text" name="RHNnotamin" tabindex="1" size="5" maxlength="3"
										value="<cfif modoTab3 neq 'ALTA' and len(trim(rsForm.RHNnotamin))>#LSNumberFormat(rsForm.RHNnotamin,',9')#</cfif>"  
										style="text-align:right" 
										onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" 
										onBlur="javascript:fm(this,0); porcentaje(this);" 
										onfocus="this.select();">
								  </td>
							  </tr>
								<tr align="center">
								  <td align="right" nowrap><strong><cf_translate key="LB_Peso" XmlFile="/rh/generales.xml">Peso</cf_translate>:&nbsp;</strong></div></td>
								  <td align="left" >
									<input type="text" name="RHHpeso" size="6" maxlength="6" tabindex="1"
										value="<cfif modoTab3 neq 'ALTA' and len(trim(rsForm.RHHpeso))>#LSNumberFormat(rsForm.RHHpeso,'___.__')#</cfif>" 
										style="text-align:right" 
										onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
										onBlur="javascript:fm(this,2); porcentaje(this);" 
										onfocus="this.select();">
								  </td>
								</tr>
								<tr align="center">
								  <td align="right" nowrap><strong><cf_translate key="LB_PesoJefatura" XmlFile="/rh/generales.xml">Peso por Jefatura</cf_translate>:&nbsp;</strong></div></td>
								  <td align="left" >
									<input type="text" name="RHHpesoJefe" size="6" maxlength="6" tabindex="1"
										value="<cfif modoTab3 neq 'ALTA' and len(trim(rsForm.RHHpesoJefe ))>#LSNumberFormat(rsForm.RHHpesoJefe ,'___.__')#</cfif>" 
										style="text-align:right" 
										onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
										onBlur="javascript:fm(this,2); porcentaje(this);" 
										onfocus="this.select();">
								  </td>
								</tr>			
								<cfif data_bezinger.Pvalor eq 1 >
									<tr align="center">
									  <td align="right" nowrap><strong><cf_translate key="LB_UbicacionBenziger">Ubicaci&oacute;n Benziger</cf_translate>:&nbsp;</strong></div></td>
									  <td align="left" >
										<select name="ubicacionB" tabindex="1">
											<option value=""></option>
											<option value="BL" <cfif modoTab3 neq 'ALTA' and rsForm.ubicacionB eq 'BL' >selected</cfif>><cf_translate key="CMB_BasalIzq">Basal Izquierdo</cf_translate></option>
											<option value="BR" <cfif modoTab3 neq 'ALTA' and rsForm.ubicacionB eq 'BR' >selected</cfif>><cf_translate key="CMB_BasalDer">Basal Derecho</cf_translate></option>
											<option value="FR" <cfif modoTab3 neq 'ALTA' and rsForm.ubicacionB eq 'FR' >selected</cfif>><cf_translate key="CMB_FrontalDer">Frontal Derecho</cf_translate></option>
											<option value="FL" <cfif modoTab3 neq 'ALTA' and rsForm.ubicacionB eq 'FL' >selected</cfif>><cf_translate key="CMB_FrontalIzq">Frontal Izquierdo</cf_translate></option>
										</select>
									  </td>
									</tr>
								</cfif>
								<tr>
									<td align="right" nowrap><strong><cf_translate key="LB_Cuestionario">Cuestionario</cf_translate>:</strong></td>
									<td>							
										<select name="PCid" id="PCid" tabindex="1" style="width:250px;">
											<option value="">--- <cf_translate key="CMB_NoEspecificado" XmlFile="/rh/generales.xml">No especificado</cf_translate> ---</option> 
											<cfloop query="rsCuestionarios">
												<option value="#rsCuestionarios.PCid#" <cfif modoTab3 NEQ 'ALTA' and rsCuestionarios.PCid EQ rsForm.PCid>selected</cfif>>#HTMLEditFormat(rsCuestionarios.PCcodigo)# - #HTMLEditFormat(rsCuestionarios.PCnombre)#</option>
											</cfloop>
										</select>
									</td>
								</tr>
								<tr><td colspan="2" align="center">&nbsp;</td></tr>
							</table>
						</td>
					</tr>
				
					<tr><td colspan="6">&nbsp;</td></tr>
					
					<tr>
					  <td nowrap colspan="6">
						<input type="hidden" name="PageNum" value="<cfif isdefined("form.PageNum")>#form.PageNum#<cfelseif isdefined("url.PageNum_Lista")>#url.PageNum_Lista#<cfelse>1</cfif>">
					  </td>
					</tr>
				  </table>
				</cfoutput>
				<input type="hidden" name="Observaciones" 	id="Observaciones" value="">
				<input type="hidden" name="Boton" 	        id="Boton" value="">
				<input type="hidden" name="RHDPPid" value="<cfoutput>#form.RHDPPid#</cfoutput>">
				<input name="sel"    type="hidden" value="3">
				<input name="o" 	 type="hidden" value="3">
				<input name="USUARIO" 	 type="hidden" value="<cfoutput>#FORM.USUARIO#</cfoutput>">
				</form>
		</td></tr>							
	</table>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_ElPorcentajeDebeEstarEnElRango0_100"
		Default="El porcentaje debe estar en el rango 0-100."
		returnvariable="MSG_ElPorcentajeDebeEstarEnElRango0_100"/>
	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_Nivel"
		Default="Nivel"
		XmlFile="/rh/generales.xml"
		returnvariable="MSG_Nivel"/>
	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_Habilidad"
		Default="Habilidad"
		returnvariable="MSG_Habilidad"/>
		
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_Habilidad_es_requerida"
		Default="La habilidad es requerida"
		returnvariable="MSG_Habilidad_es_requerida"/>	
	
	<script language="JavaScript1.2" type="text/javascript">
		function funcRHHid(){
			<cfif isdefined('data_bezinger') and data_bezinger.recordCount GT 0>
				<cfif data_bezinger.Pvalor EQ 1>
					if(document.formTB3.RHHubicacionB_RHHid.value != '')
						document.formTB3.ubicacionB.value = document.formTB3.RHHubicacionB_RHHid.value;
				</cfif>
			</cfif>
	
			if(document.formTB3.PCid_RHHid.value != '')
				document.formTB3.PCid.value = document.formTB3.PCid_RHHid.value;
		}
	
		function __isPorcentaje() {
			if (objForm.RHNnotamin.value < 0 || objForm.RHNnotamin.value > 100 ){
					this.error = "<cfoutput>#MSG_ElPorcentajeDebeEstarEnElRango0_100#</cfoutput>"
			}
		}
	
		qFormAPI.errorColor = "#FFFFCC";
		objForm = new qForm("formTB3");
	
		_addValidator("isPorcentaje", __isPorcentaje);
	<cfoutput>
		objForm.RHHcodigo.required = true;
		objForm.RHNid.required = true;
		objForm.RHHcodigo.description = "#MSG_Habilidad#";
		objForm.RHNid.description = "#MSG_Nivel#";
		objForm.RHNnotamin.validatePorcentaje();		
	</cfoutput>
		function validaHabilidades(){
			if (document.formTB3.RHHcodigo.value == ''){
				alert('<cfoutput>#MSG_Habilidad_es_requerida#</cfoutput>');
				return false;
			}
				return true;
		}
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
				mensaje = '<cfoutput>#MSG_ElPorcentajeDebeEstarEnElRango0_100#</cfoutput>';
				obj.value = '';
				alert(mensaje);
				return false;
			}
			return true;
		}
		
	</script>
<cfelse>
	<table width="100%">
		<tr width="100%">
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
				<cfif isdefined("Form.USUARIO")>
					<cfset navegar = navegar & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "USUARIO=#trim(form.USUARIO)#">
				</cfif>
				
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Primordial"
					Default="Primordial"
					returnvariable="LB_Primordial"/>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Basica"
					Default="Básica"
					returnvariable="LB_Basica"/>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Complementaria"
					Default="Complementaria"
					returnvariable="LB_Complementaria"/>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Deseable"
					Default="Deseable"
					returnvariable="LB_Deseable"/>
	
				<cfquery name="rsLista" datasource="#session.DSN#">
					select  a.RHDPPid, b.RHHid, b.RHHcodigo, 
							{fn concat(<cf_dbfunction name="string_part" args="b.RHHdescripcion,1,100">,'...')} as RHHdescripcion,  
							a.RHNid, c.RHNcodigo,a.RHHtipo,a.RHHpeso,
							a.ubicacionB,
							case a.RHHtipo 
							when 0 then '#LB_Primordial#' 
							when 1 then '#LB_Basica#' 
							when 2 then '#LB_Complementaria#' 
							when 3 then '#LB_Deseable#' end as tipo_descripcion,
							a.RHNnotamin, '#form.o#' as o, '#form.sel#' as sel,
							b.RHHcodigo,'#form.USUARIO#' as usuario
					from RHHabilidadPuestoP a 
						inner join RHDescripPuestoP x
							on a.RHDPPid = x.RHDPPid
						inner join  RHHabilidades b 
							on a.RHHid = b.RHHid
						left outer join RHNiveles c
							on x.Ecodigo = c.Ecodigo
							and a.RHNid = c.RHNid
							and c.Ecodigo = #session.Ecodigo#
					where a.RHDPPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHDPPid#">
					and x.Ecodigo = <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer">
					order by RHHtipo, RHHdescripcion
				</cfquery>
					   
				<cfset filtro = " a.RHDPPid = '#form.RHDPPid#'
					   and x.Ecodigo = #session.Ecodigo#
					   and c.Ecodigo = #session.Ecodigo#
					   and a.RHHid = b.RHHid
					   and x.Ecodigo*=c.Ecodigo
					   and a.RHNid*=c.RHNid
					   order by RHHtipo, RHHdescripcion" >
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Nivel"
					Default="Nivel"
					returnvariable="LB_Nivel"/>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Peso"
					Default="Peso"
					returnvariable="LB_Peso"/>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Habilidad"
					Default="Habilidad"
					returnvariable="LB_Habilidad"/>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Descripcion"
					Default="Descripci&oacute;n"
					XmlFile="/rh/generales.xml"
					returnvariable="LB_Descripcion"/>
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_NotaMinima"
					Default="Nota Mínima"
					returnvariable="LB_NotaMinima"/>
					   
				<cfinvoke 
				 component="rh.Componentes.pListas"
				 method="pListaQuery"
				 returnvariable="pListaEmpl">
					<cfinvokeargument name="query" value="#rsLista#"/>
					<cfinvokeargument name="desplegar" value="RHHcodigo,RHHdescripcion,RHNcodigo,ubicacionB,RHHpeso,RHNnotamin"/>
					<cfinvokeargument name="etiquetas" value="#LB_Habilidad#, #LB_Descripcion#,#LB_Nivel#,Benziger,#LB_Peso#,#LB_NotaMinima#"/>
					<cfinvokeargument name="formatos" value="S,S,S,S,M,M"/>
					<cfinvokeargument name="formName" value="listahabilidades"/>
					<cfinvokeargument name="align" value="lef, left, center, center,right,right"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="debug" value="N"/>
					<cfinvokeargument name="Cortes" value="tipo_descripcion"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="navegacion" value="#navegar#"/>
					<cfinvokeargument name="keys" value="RHDPPid,RHHid,usuario"/>
					<cfinvokeargument name="showLink" value="false"/>
					<!--- <cfinvokeargument name="MaxRows" value="1"/> --->
				</cfinvoke>
			</td>
		</tr>
	</table>
</cfif>	
