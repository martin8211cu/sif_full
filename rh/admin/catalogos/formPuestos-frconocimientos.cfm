<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="MSG_ElPorcentajeDebeEstarEnElRango0_100" default="El porcentaje debe estar en el rango 0-100" returnvariable="MSG_ElPorcentajeDebeEstarEnElRango0_100" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_SePresentaronLosSiguientesErrores" default="Se presentaron los siguientes errores" returnvariable="MSG_SePresentaronLosSiguientesErrores" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Primordial" default="Primordial" returnvariable="LB_Primordial" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Basica" default="Básica" returnvariable="LB_Basica" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Complementaria" default="Complementaria" returnvariable="LB_Complementaria" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Deseable" default="Deseable" returnvariable="LB_Deseable" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Conocimiento" default="Conocimiento"returnvariable="MSG_Conocimiento" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="MGS_Nivel" default="Nivel" returnvariable="MGS_Nivel" component="sif.Componentes.Translate" method="Translate"xmlfile="/rh/generales.xml"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<!-- Establecimiento del modo -->
<cfset modo = 'ALTA'>
<cfif isdefined('url.RHCid') and not isdefined('form.RHCid')>
	<cfset form.RHCid = url.RHCid>
</cfif>
<cfif isdefined("form.RHCid") and len(trim(form.RHCid))>
	<cfset modo = 'CAMBIO'>
</cfif>

<!--- Form --->
<cfquery name="data_puesto" datasource="#session.DSN#">
	select coalesce(RHPcodigoext, RHPcodigo) as RHPcodigoext, RHPcodigo, RHPdescpuesto
	from RHPuestos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
</cfquery>
<!--- Cuestionarios ---->
<cfquery name="rsCuestionarios" datasource="#session.dsn#">
	select b.PCnombre, b.PCid, b.PCcodigo
	from RHEvaluacionCuestionarios a
			inner join PortalCuestionario b
				on a.PCid = b.PCid
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!--- Form --->
<cfif modo neq 'ALTA'>
	<cfquery name="rsForm" datasource="#session.DSN#">
		select a.RHCid, a.RHPcodigo, a.Ecodigo, a.RHNid, a.RHCnotamin*100 as RHCnotamin, a.RHCtipo, b.RHPdescpuesto, c.RHCcodigo, c.RHCdescripcion 
		,a.RHCpeso, coalesce(a.PCid,c.PCid) as PCid
		from RHConocimientosPuesto a, RHPuestos b, RHConocimientos c
		where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and b.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
		  and a.RHCid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
		  and a.RHPcodigo=b.RHPcodigo
		  and a.Ecodigo=b.Ecodigo
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

<!--- Javascript --->
<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript1.2" type="text/javascript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	
	function porcentaje(obj){
		if (obj.value < 0 || obj.value > 100 ){
			mensaje = '#MSG_SePresentaronLosSiguientesErrores#:\n';
			mensaje += ' - #MSG_ElPorcentajeDebeEstarEnElRango0_100#.';
			alert(mensaje);
			return false;
		}
		return true;
	}
</script>


<table width="100%">
	<tr width="50%">
		<td align="left" valign="top">
			<cfset navegar = "">
			<cfset navegar = navegar & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "filtrado=Filtrar">
	
			<cfif isdefined("Form.sel")>
				<cfset navegar = navegar & Iif(Len(Trim(navegar)) NEQ 0, DE("&"), DE("")) & "sel=" & form.sel>				
			</cfif>
			<cfif isdefined("Form.o")>
				<cfset navegar = navegar & Iif(Len(Trim(navegar)) NEQ 0, DE("&"), DE("")) & "o=" & form.o>
			</cfif>
			<cfif isdefined("Form.RHPcodigo")>
				<cfset navegar = navegar & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHPcodigo=#trim(form.RHPcodigo)#">
			</cfif>
			<cfif isdefined("Form.codigoFiltro") and Len(Trim(Form.codigoFiltro)) NEQ 0>
				<cfset navegar = navegar & Iif(Len(Trim(navegar)) NEQ 0, DE("&"), DE("")) & "codigoFiltro=" & Form.codigoFiltro>
			</cfif>
			<cfif isdefined("Form.descripcionFiltro") and Len(Trim(Form.descripcionFiltro)) NEQ 0>
				<cfset navegar = navegar & Iif(Len(Trim(navegar)) NEQ 0, DE("&"), DE("")) & "descripcionFiltro=" & Form.descripcionFiltro>
			</cfif>
			
			<cfquery name="QueryLista" datasource="#session.DSN#">
				Select d.RHPcodigo as RHPcodigo, b.RHCid, b.RHCcodigo, 
						{fn concat(<cf_dbfunction name="string_part" args="b.RHCdescripcion,1,45">,'...')} as RHCdescripcion,
 						a.RHNid, 
					   c.RHNcodigo,a.RHCtipo,
					   case a.RHCtipo 
					   when 0 then '#LB_Primordial#' 
					   when 1 then '#LB_Basica#' 
					   when 2 then '#LB_Complementaria#' 
					   when 3 then '#LB_Deseable#' end as tipo_descripcion,a.RHCpeso,
					   a.RHCnotamin, '#form.o#' as o, '#form.sel#' as sel
				from RHConocimientosPuesto a 
					inner join RHConocimientos b
					   on a.RHCid = b.RHCid 
					left outer join RHNiveles c  
					   on a.Ecodigo = c.Ecodigo 
					   and a.RHNid = c.RHNid 
					   and c.Ecodigo = #session.Ecodigo#
					left outer join RHPuestos d
					   on a.Ecodigo = d.Ecodigo
					   and a.RHPcodigo = d.RHPcodigo
				where d.RHPcodigo = '#form.RHPcodigo#'
				and a.Ecodigo = #session.Ecodigo#
			    order by RHCtipo, RHCdescripcion
			</cfquery>
			<cfset filtro = " a.RHPcodigo = '#form.RHPcodigo#'
				   and a.Ecodigo = #session.Ecodigo#
				   and c.Ecodigo = #session.Ecodigo#
				   and a.RHCid = b.RHCid
				   and a.Ecodigo*=c.Ecodigo
				   and a.RHNid*=c.RHNid
				   order by RHCtipo, RHCdescripcion" >
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				key="LB_Conocimiento"
				default="Conocimiento"
				returnvariable="LB_Conocimiento"/>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				key="LB_Nivel"
				default="Nivel"
				returnvariable="LB_Nivel"/>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				key="LB_Peso"
				default="Peso"
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
				<cfinvokeargument name="irA" value="Puestos.cfm"/>
				<cfinvokeargument name="debug" value="N"/>
				<cfinvokeargument name="Cortes" value="tipo_descripcion"/>
				<cfinvokeargument name="navegacion" value="#navegar#"/>
			</cfinvoke>
		</td>

		<td valign="top" align="center">

			<form name="form1" method="post" action="SQLPuestos-frconocimientos.cfm">
			<cfoutput>
			<table align="center" width="90%" border="0" cellspacing="0" cellpadding="0">
				<tr>
				  <td nowrap colspan="4" align="left">&nbsp;</td>
				</tr>
			
				<tr>
					<td colspan="4">
						<table width="100%">
							<tr> 
								<td nowrap width="35%" align="right"><strong><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate>:&nbsp;</strong></td>
							  	<td nowrap>#Trim(data_puesto.RHPcodigoext)#</td>
							</tr>
							<tr>
							  	<td nowrap align="right"><strong><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate>:&nbsp;</strong></td>
							  	<td nowrap >#data_puesto.RHPdescpuesto# </td>
							</tr>
							<tr>
							  	<td nowrap align="right"><strong><cf_translate key="LB_Conocimiento">Conocimiento</cf_translate>:&nbsp;</strong></td>
							  	<td nowrap>
									<cfif modo neq 'ALTA'>
										<cf_rhconocimiento query="#rsForm#" tabindex="1" size="25" inactivos="1">
										<input type="hidden" name="RHCid_2" value="#rsForm.RHCid#" tabindex="-1">
									<cfelse>
										<cf_rhconocimiento tabindex="1" size="25"  inactivos="1">
									</cfif>
							  	</td>
							</tr>
							<tr align="center">
							 	<td align="right"><strong><cf_translate key="LB_Nivel" XmlFile="/rh/generales.xml">Nivel</cf_translate>:&nbsp;</strong></td>
							  	<td align="left">
									<select name="RHNid" tabindex="1" style="width:250px;">
										<cfloop query="rsNiveles">
											<option value="#RHNid#" <cfif modo neq 'ALTA' and rsNiveles.RHNid eq rsForm.RHNid>selected</cfif>   >#RHNcodigo# - <cfif len(#RHNdescripcion#) GT 60>#RHNdescCorta#<cfelse>#RHNdescripcion#</cfif></option>
										</cfloop>
									</select>&nbsp;
							  	</td>
							</tr>
							<tr align="center">
							  	<td align="right" nowrap><strong><cf_translate key="LB_Tipo">Tipo</cf_translate>:&nbsp;</strong></td>
							  	<td align="left" >
									<select name="RHCtipo" tabindex="1">
										<option value="0" <cfif modo neq 'ALTA' and rsForm.RHCtipo eq 0 >selected</cfif> ><cf_translate key="CMB_Primordial">Primordial</cf_translate></option>
										<option value="1" <cfif modo neq 'ALTA' and rsForm.RHCtipo eq 1 >selected</cfif>><cf_translate key="CMB_Basica">B&aacute;sica</cf_translate></option>
										<option value="2" <cfif modo neq 'ALTA' and rsForm.RHCtipo eq 2 >selected</cfif>><cf_translate key="CMB_Complementaria">Complementaria</cf_translate></option>
										<option value="3" <cfif modo neq 'ALTA' and rsForm.RHCtipo eq 3 >selected</cfif>><cf_translate key="CMB_Deseable">Deseable</cf_translate></option>
									</select>
									<input type="hidden" name="tipo_descripcion" value="" tabindex="-1">
							  	</td>
							</tr>
			
							<tr align="center">
							  	<td align="right" nowrap><strong><cf_translate key="LB_NotaMinima">Nota M&iacute;nima</cf_translate>:&nbsp;</strong></td>
							  	<td align="left" >
									<input type="text" name="RHCnotamin" size="5" maxlength="5" style="text-align:right" tabindex="1"
										value="<cfif modo neq 'ALTA' and len(trim(rsForm.RHCnotamin))>#LSNumberFormat(rsForm.RHCnotamin,',9')#</cfif>" 
										onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" 
										onblur="javascript:fm(this,2); porcentaje(this);" 
										onfocus="this.select();" >
                              	</td>
						  </tr>
							<tr align="center">
							  	<td align="right" nowrap><strong><cf_translate key="LB_Peso" XmlFile="/rh/generales.xml">Peso</cf_translate>:&nbsp;</strong></td>
							  	<td align="left" >
									<input type="text" name="RHCpeso"  size="6" maxlength="6" style="text-align:right" tabindex="1"
										value="<cfif modo neq 'ALTA' and len(trim(rsForm.RHCpeso))>#LSNumberFormat(rsForm.RHCpeso,',.00')#</cfif>" 
										onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
										onblur="javascript:fm(this,2); porcentaje(this);" 
										onfocus="this.select();" >
							  	</td>
							</tr>
							<tr>
								<td align="right" nowrap><strong><cf_translate key="LB_Cuestionario">Cuestionario</cf_translate>:</strong></td>
								<td>							
									<select name="PCid" id="PCid" tabindex="1" style="width:250px;">
										<option value="">--- <cf_translate key="CMB_NoEspecificado" XmlFile="/rh/generales.xml">No especificado</cf_translate> ---</option> 
										<cfloop query="rsCuestionarios">
											<option value="#rsCuestionarios.PCid#" <cfif modo NEQ 'ALTA' and rsCuestionarios.PCid EQ rsForm.PCid>selected</cfif>>#HTMLEditFormat(rsCuestionarios.PCcodigo)#-#HTMLEditFormat(rsCuestionarios.PCnombre)#</option>
										</cfloop>
									</select>
								</td>
							</tr>
							<tr>
								<cfif isdefined("Aprobacion") and len(trim(Aprobacion)) and Aprobacion eq 'A'>
									<td colspan="2" align="center">
										<cfif modo neq 'ALTA'>
											<cfinvoke component="sif.Componentes.Translate"
												method="Translate"
												key="BTN_Modificar"
												default="Modificar"
												xmlfile="/rh/generales.xml"
												returnvariable="BTN_Modificar"/>
											<cfinvoke component="sif.Componentes.Translate"
												method="Translate"
												key="BTN_Eliminar"
												default="Eliminar"
												xmlfile="/rh/generales.xml"
												returnvariable="BTN_Eliminar"/>
											<cfinvoke component="sif.Componentes.Translate"
												method="Translate"
												key="BTN_Nuevo"
												default="Nuevo"
												xmlfile="/rh/generales.xml"
												returnvariable="BTN_Nuevo"/>
											<cfinvoke component="sif.Componentes.Translate"
												method="Translate"
												key="MSG_DeseaEliminarElRegegistro"
												default="Desea eliminar el registro?"
												xmlfile="/rh/generales.xml"
												returnvariable="MSG_DeseaEliminarElRegegistro"/>
	
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
									<td class="ayuda" colspan="2"><cf_translate key="MSG_ParaPoderAgregarOModificarConocimientosTecnicosDebeDeRealizarloDesdeElPerfilIdealDelPuesto">Para poder agregar o modificar conocimientos t&eacute;cnicos debe de realizarlo desde el perfil ideal del puesto</cf_translate>.</td>
								</cfif>	
							</tr>
						</table>
					</td>
				</tr>
				<tr>
				  	<td nowrap colspan="4">
						<input type="hidden" name="RHPcodigo" id="RHPcodigo" value="#Trim(data_puesto.RHPcodigo)#">
						<input type="hidden" name="PageNum" value="<cfif isdefined("form.PageNum")>#form.PageNum#<cfelseif isdefined("url.PageNum_Lista")>#url.PageNum_Lista#<cfelse>1</cfif>">
				  	</td>
				</tr>
			</table>
			</cfoutput>
			</form>
		</td>	
	</tr>	
</table>	
	
<script language="JavaScript1.2" type="text/javascript">
	function funcRHCid(){
		if(document.form1.PCid_RHCid.value != ''){
			document.form1.PCid.value = document.form1.PCid_RHCid.value;
		}else{
			document.form1.PCid.value = '';		
		}
	}
	<cfoutput>
	function __isPorcentaje() {
		if (objForm.RHCnotamin.value < 0 || objForm.RHCnotamin.value > 100 ){
				this.error = "#MSG_ElPorcentajeDebeEstarEnElRango0_100#"
			}
		}

	qFormAPI.errorColor = "##FFFFCC";
	objForm = new qForm("form1");

	_addValidator("isPorcentaje", __isPorcentaje);

	objForm.RHCcodigo.required = true;
	objForm.RHNid.required = true;
	objForm.RHCcodigo.description = "#MSG_Conocimiento#";
	objForm.RHNid.description = "#MGS_Nivel#";
	objForm.RHCnotamin.validatePorcentaje();		
</cfoutput>
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
