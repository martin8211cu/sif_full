<!-- Establecimiento del modoTab4 -->
<cfif form.USUARIO neq 'JEFECFNM'>
	<cfset modoTab4 = 'ALTA'>
	<cfif isdefined("form.RHCid") and len(trim(form.RHCid))>
		<cfset modoTab4 = 'CAMBIO'>
	</cfif>
	
	<!--- Form --->
	<cfif modoTab4 neq 'ALTA'>
		<cfquery name="rsForm" datasource="#session.DSN#">
			select a.RHCid, a.RHDPPid, x.Ecodigo, a.RHNid, a.RHCnotamin*100 as RHCnotamin, a.RHCtipo, c.RHCcodigo, c.RHCdescripcion 
			,a.RHCpeso,coalesce(a.PCid,c.PCid) as PCid
			from RHConocimientoPuestoP a, RHDescripPuestoP x, RHConocimientos c
			where x.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and a.RHDPPid = x.RHDPPid
			  and c.Ecodigo= x.Ecodigo
			  and a.RHDPPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHDPPid#">
			  and a.RHCid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
			  and a.RHCid=c.RHCid
		</cfquery>
	</cfif>
	
	<!--- niveles --->
	<cfquery name="rsNiveles" datasource="#session.dsn#">
		select RHNid, RHNcodigo, 
			RHNdescripcion,
			{fn concat(<cf_dbfunction name="string_part" args="RHNdescripcion,1,45">,'...')} as RHNdescCorta
		from RHNiveles
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and RHNhabcono = 'C'
		order by RHNcodigo
	</cfquery>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_ElPorcentajeDebeEstarEnElRango0_100"
		Default="El porcentaje debe estar en el rango 0-100"
		returnvariable="MSG_ElPorcentajeDebeEstarEnElRango0_100"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_SePresentaronLosSiguientesErrores"
		Default="Se presentaron los siguientes errores"
		returnvariable="MSG_SePresentaronLosSiguientesErrores"/>
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
	<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
	<script language="JavaScript1.2" type="text/javascript">
		// specify the path where the "/qforms/" subfolder is located
		qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
		// loads all default libraries
		qFormAPI.include("*");
		
		function porcentaje(obj){
			if (obj.value < 0 || obj.value > 100 ){
				mensaje = '<cfoutput>#MSG_SePresentaronLosSiguientesErrores#</cfoutput>:\n';
				mensaje += ' - <cfoutput>#MSG_ElPorcentajeDebeEstarEnElRango0_100#</cfoutput>.';
				alert(mensaje);
				return false;
			}
			return true;
		}
	</script>
	<table width="100%">
		<tr width="100%">
			<td align="left" valign="top">
				<cfset navegar = "">
				<cfset navegar = navegar & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "filtrado=Filtrar">
		
				<cfif isdefined("Form.sel")>
					<cfset navegar = navegar & Iif(Len(Trim(navegar)) NEQ 0, DE("&"), DE("")) & "sel=" & form.sel>				
				</cfif>
				<cfif isdefined("Form.o")>
					<cfset navegar = navegar & Iif(Len(Trim(navegar)) NEQ 0, DE("&"), DE("")) & "o=" & form.o>
				</cfif>
				<cfif isdefined("Form.RHDPPid")>
					<cfset navegar = navegar & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHDPPid=#trim(form.RHDPPid)#">
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
	
				<cfquery name="QueryLista" datasource="#session.DSN#">
					Select 	a.RHDPPid,
							a.RHCid, 
							b.RHCcodigo, 
							{fn concat(<cf_dbfunction name="string_part" args="b.RHCdescripcion,1,45">,'...')} as RHCdescripcion,
							a.RHNid, 
							c.RHNcodigo,
							a.RHCtipo,
							case a.RHCtipo 
							when 0 then '#LB_Primordial#' 
							when 1 then '#LB_Basica#' 
							when 2 then '#LB_Complementaria#' 
							when 3 then '#LB_Deseable#' end as tipo_descripcion,
							a.RHCpeso,
							a.RHCnotamin, 
							'#form.o#' as o, 
							'#form.sel#' as sel, '#form.USUARIO#' as usuario
					from RHConocimientoPuestoP a 
						inner join RHDescripPuestoP x
							on a.RHDPPid = x.RHDPPid
							and x.Ecodigo = <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer">
						inner join RHConocimientos b
						   on a.RHCid = b.RHCid 
						left outer join RHNiveles c  
						   on x.Ecodigo = c.Ecodigo 
						   and a.RHNid = c.RHNid 
						   and c.Ecodigo = x.Ecodigo
					where a.RHDPPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHDPPid#">
					order by RHCtipo, RHCdescripcion
				</cfquery>
				<cfset filtro = " a.RHDPPid = '#form.RHDPPid#'
					   and x.Ecodigo = #session.Ecodigo#
					   and c.Ecodigo = x.Ecodigo
					   and a.RHCid = b.RHCid
					   and a.Ecodigo*=c.Ecodigo
					   and a.RHNid*=c.RHNid
					   order by RHCtipo, RHCdescripcion" >
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Conocimiento"
					Default="Conocimiento"
					returnvariable="LB_Conocimiento"/>
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
	
				<cfinvoke 
				 component="rh.Componentes.pListas"
				 method="pListaQuery"
				 returnvariable="pListaEmpl">
					<cfinvokeargument name="query" value="#QueryLista#"/>
					<cfinvokeargument name="desplegar" value="RHCdescripcion, RHNcodigo,RHCpeso"/>
					<cfinvokeargument name="etiquetas" value="#LB_Conocimiento#, #LB_Nivel#,#LB_Peso#"/>
					<cfinvokeargument name="formatos" value="S,S,M"/>
					<cfinvokeargument name="formName" value="listaconocimientos"/>
					<cfinvokeargument name="align" value="left,left,right"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfif form.USUARIO eq 'ASESOR'>
						<cfinvokeargument name="irA" value="PerfilPuesto.cfm"/> 
					<cfelse>
						<cfinvokeargument name="irA" value="ApruebaPerfilPuesto.cfm"/> 
					</cfif>
					<!--- <cfinvokeargument name="MaxRows" value="3"/> --->
					
					<cfinvokeargument name="debug" value="N"/>
					<cfinvokeargument name="Cortes" value="tipo_descripcion"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="navegacion" value="#navegar#"/>
					<cfinvokeargument name="keys" value="RHDPPid,RHCid"/>
				</cfinvoke>
			</td>
	
			<td valign="top" align="center">
	
				<form name="formTB4" method="post" action="SQLPerfilPuesto.cfm">
				<cfoutput>
				<table align="center" width="90%" border="0" cellspacing="0" cellpadding="0">
					<tr>
					  <td nowrap colspan="4" align="left">&nbsp;</td>
					</tr>
					<tr>
						<td bgcolor="##A0BAD3"  colspan="4">
							<cfinclude template="frame-botones2.cfm">
						</td>
				   </tr>
					<tr>
						<td colspan="4">
							<table width="100%">
								<tr>
									<td nowrap align="right"><strong><cf_translate key="LB_Conocimiento">Conocimiento</cf_translate>:&nbsp;</strong></td>
									<td nowrap>
										<cfif modoTab4 neq 'ALTA'>
											<cf_rhconocimiento query="#rsForm#" tabindex="1" size="25" form="formTB4" inactivos="1">
											<input type="hidden" name="RHCid_2" value="#rsForm.RHCid#" tabindex="-1">
										<cfelse>
											<cf_rhconocimiento tabindex="1" size="25" form="formTB4" inactivos="1">
										</cfif>
									</td>
								</tr>
								<tr align="center">
									<td align="right"><strong><cf_translate key="LB_Nivel" XmlFile="/rh/generales.xml">Nivel</cf_translate>:&nbsp;</strong></td>
									<td align="left">
										<select name="RHNid" tabindex="1" style="width:250px;">
											<cfloop query="rsNiveles">
												<option value="#RHNid#" <cfif modoTab4 neq 'ALTA' and rsNiveles.RHNid eq rsForm.RHNid>selected</cfif>   >#RHNcodigo# - <cfif len(#RHNdescripcion#) GT 60>#RHNdescCorta#<cfelse>#RHNdescripcion#</cfif></option>
											</cfloop>
										</select>&nbsp;
									</td>
								</tr>
								<tr align="center">
									<td align="right" nowrap><strong><cf_translate key="LB_Tipo">Tipo</cf_translate>:&nbsp;</strong></td>
									<td align="left" >
										<select name="RHCtipo" tabindex="1">
											<option value="0" <cfif modoTab4 neq 'ALTA' and rsForm.RHCtipo eq 0 >selected</cfif> ><cf_translate key="CMB_Primordial">Primordial</cf_translate></option>
											<option value="1" <cfif modoTab4 neq 'ALTA' and rsForm.RHCtipo eq 1 >selected</cfif>><cf_translate key="CMB_Basica">B&aacute;sica</cf_translate></option>
											<option value="2" <cfif modoTab4 neq 'ALTA' and rsForm.RHCtipo eq 2 >selected</cfif>><cf_translate key="CMB_Complementaria">Complementaria</cf_translate></option>
											<option value="3" <cfif modoTab4 neq 'ALTA' and rsForm.RHCtipo eq 3 >selected</cfif>><cf_translate key="CMB_Deseable">Deseable</cf_translate></option>
										</select>
										<input type="hidden" name="tipo_descripcion" value="" tabindex="-1">
									</td>
								</tr>
				
								<tr align="center">
									<td align="right" nowrap><strong><cf_translate key="LB_NotaMinima">Nota M&iacute;nima</cf_translate>:&nbsp;</strong></td>
									<td align="left" >
										<input type="text" name="RHCnotamin" size="5" maxlength="3" style="text-align:right" tabindex="1"
											value="<cfif modoTab4 neq 'ALTA' and len(trim(rsForm.RHCnotamin))>#LSNumberFormat(rsForm.RHCnotamin,',9')#</cfif>" 
											onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" 
											onBlur="javascript:fm(this,0); porcentaje(this);" 
											onfocus="this.select();" >
									</td>
							  </tr>
								<tr align="center">
									<td align="right" nowrap><strong><cf_translate key="LB_Peso" XmlFile="/rh/generales.xml">Peso</cf_translate>:&nbsp;</strong></td>
									<td align="left" >
										<input type="text" name="RHCpeso"  size="5" maxlength="3" style="text-align:right" tabindex="1"
											value="<cfif modoTab4 neq 'ALTA' and len(trim(rsForm.RHCpeso))>#LSNumberFormat(rsForm.RHCpeso,',9')#</cfif>" 
											onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" 
											onBlur="javascript:fm(this,0); porcentaje(this);" 
											onfocus="this.select();" >
									</td>
								</tr>
								<tr>
									<td align="right" nowrap><strong><cf_translate key="LB_Cuestionario">Cuestionario</cf_translate>:</strong></td>
									<td>							
										<select name="PCid" id="PCid" tabindex="1" style="width:250px;">
											<option value="">--- <cf_translate key="CMB_NoEspecificado" XmlFile="/rh/generales.xml">No especificado</cf_translate> ---</option> 
											<cfloop query="rsCuestionarios">
												<option value="#rsCuestionarios.PCid#" <cfif modoTab4 NEQ 'ALTA' and rsCuestionarios.PCid EQ rsForm.PCid>selected</cfif>>#HTMLEditFormat(rsCuestionarios.PCcodigo)#-#HTMLEditFormat(rsCuestionarios.PCnombre)#</option>
											</cfloop>
										</select>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td nowrap colspan="4">
							<input type="hidden" name="Observaciones" 	id="Observaciones" value="">
							<input type="hidden" name="Boton" 	        id="Boton" value="">
							<input type="hidden" name="RHDPPid" value="<cfoutput>#form.RHDPPid#</cfoutput>">
							<input type="hidden" name="PageNum" value="<cfif isdefined("form.PageNum")>#form.PageNum#<cfelseif isdefined("url.PageNum_Lista")>#url.PageNum_Lista#<cfelse>1</cfif>">
							<input name="sel"    type="hidden" value="4">
							<input name="o" 	 type="hidden" value="4">
							<input name="USUARIO" 	 type="hidden" value="<cfoutput>#FORM.USUARIO#</cfoutput>">
						</td>
					</tr>
				</table>
				</cfoutput>
				</form>
			</td>	
		</tr>	
	</table>	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_Conocimiento"
		Default="Conocimiento"
		returnvariable="MSG_Conocimiento"/>	
		
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_Conocimiento_es_requerido"
		Default="El conocimiento es requerido"
		returnvariable="MSG_Conocimiento_es_requerido"/>	
			
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MGS_Nivel"
		Default="Nivel"
		XmlFile="/rh/generales.xml"
		returnvariable="MGS_Nivel"/>
		
	<script language="JavaScript1.2" type="text/javascript">
	
		function __isPorcentaje() {
			if (objForm.RHCnotamin.value < 0 || objForm.RHCnotamin.value > 100 ){
					this.error = "#MSG_ElPorcentajeDebeEstarEnElRango0_100#"
				}
			}
	
		qFormAPI.errorColor = "#FFFFCC";
		objForm = new qForm("formTB4");
	
		_addValidator("isPorcentaje", __isPorcentaje);
	<cfoutput>
		objForm.RHCcodigo.required = true;
		objForm.RHNid.required = true;
		objForm.RHCcodigo.description = "#MSG_Conocimiento#";
		objForm.RHNid.description = "#MGS_Nivel#";
		objForm.RHCnotamin.validatePorcentaje();		
	</cfoutput>
		function validaconocimientos(){
			if (document.formTB4.RHCcodigo.value == ''){
				alert('<cfoutput>#MSG_Conocimiento_es_requerido#</cfoutput>');
				return false;
			}
				return true;
		}
	
	
	
		function deshabilitarValidacion(){
			objForm.RHCcodigo.required = false;
			objForm.RHNid.required = false;
		}
		function habilitarValidacion(){
			objForm.RHCcodigo.required = true;
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
	<table width="100%" border="0">
		<tr>
			<td>
				<cfset navegar = "">
				<cfset navegar = navegar & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "filtrado=Filtrar">
		
				<cfif isdefined("Form.sel")>
					<cfset navegar = navegar & Iif(Len(Trim(navegar)) NEQ 0, DE("&"), DE("")) & "sel=" & form.sel>				
				</cfif>
				<cfif isdefined("Form.o")>
					<cfset navegar = navegar & Iif(Len(Trim(navegar)) NEQ 0, DE("&"), DE("")) & "o=" & form.o>
				</cfif>
				<cfif isdefined("Form.RHDPPid")>
					<cfset navegar = navegar & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHDPPid=#trim(form.RHDPPid)#">
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
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_NotaMinima"
					Default="Nota Mínima"
					returnvariable="LB_NotaMinima"/>					
					
	
				<cfquery name="QueryLista" datasource="#session.DSN#">
					Select 	a.RHDPPid,
							a.RHCid, 
							b.RHCcodigo, 
							{fn concat(<cf_dbfunction name="string_part" args="b.RHCdescripcion,1,100">,'...')} as RHCdescripcion,
							a.RHNid, 
							c.RHNcodigo,
							a.RHCtipo,
							case a.RHCtipo 
							when 0 then '#LB_Primordial#' 
							when 1 then '#LB_Basica#' 
							when 2 then '#LB_Complementaria#' 
							when 3 then '#LB_Deseable#' end as tipo_descripcion,
							a.RHCpeso,
							a.RHCnotamin, 
							'#form.o#' as o, 
							'#form.sel#' as sel, '#form.USUARIO#' as usuario
					from RHConocimientoPuestoP a 
						inner join RHDescripPuestoP x
							on a.RHDPPid = x.RHDPPid
							and x.Ecodigo = <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer">
						inner join RHConocimientos b
						   on a.RHCid = b.RHCid 
						left outer join RHNiveles c  
						   on x.Ecodigo = c.Ecodigo 
						   and a.RHNid = c.RHNid 
						   and c.Ecodigo = x.Ecodigo
					where a.RHDPPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHDPPid#">
					order by RHCtipo, RHCdescripcion
				</cfquery>
				<cfset filtro = " a.RHDPPid = '#form.RHDPPid#'
					   and x.Ecodigo = #session.Ecodigo#
					   and c.Ecodigo = x.Ecodigo
					   and a.RHCid = b.RHCid
					   and a.Ecodigo*=c.Ecodigo
					   and a.RHNid*=c.RHNid
					   order by RHCtipo, RHCdescripcion" >
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Conocimiento"
					Default="Conocimiento"
					returnvariable="LB_Conocimiento"/>
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
	
				<cfinvoke 
				 component="rh.Componentes.pListas"
				 method="pListaQuery"
				 returnvariable="pListaEmpl">
					<cfinvokeargument name="query" value="#QueryLista#"/>
					<cfinvokeargument name="desplegar" value="RHCdescripcion, RHNcodigo,RHCpeso,RHCnotamin"/>
					<cfinvokeargument name="etiquetas" value="#LB_Conocimiento#, #LB_Nivel#,#LB_Peso#,#LB_NotaMinima#"/>
					<cfinvokeargument name="formatos" value="S,S,M,M"/>
					<cfinvokeargument name="formName" value="listaconocimientos"/>
					<cfinvokeargument name="align" value="left,left,right,right"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="debug" value="N"/>
					<cfinvokeargument name="Cortes" value="tipo_descripcion"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="navegacion" value="#navegar#"/>
					<cfinvokeargument name="keys" value="RHDPPid,RHCid"/>
					<cfinvokeargument name="keys" value="RHDPPid,RHCid"/>
					<cfinvokeargument name="showLink" value="false"/>
					<!--- <cfinvokeargument name="MaxRows" value="2"/> --->
				</cfinvoke>
			</td>
		</tr>
	</table>
</cfif>