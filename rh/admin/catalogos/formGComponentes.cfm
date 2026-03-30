<cfif isdefined("Url.RHCAid") and not isdefined("form.RHCAid")><cfset form.RHCAid = url.RHCAid></cfif><!--- Llave de la tabla --->
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td valign="top">
		<cfset filtro = ''>
		<cfset navegacion = ''>
		<!---  FILTRO --->
		<cfif isdefined("url.PAGENUM") and not isdefined("form.Pagina")><cfset form.Pagina = url.PAGENUM></cfif>
		<cfif isdefined("form.PAGENUM") and not isdefined("form.Pagina")><cfset form.Pagina = form.PAGENUM></cfif>
		<cfif isdefined("url.fRHCAcodigo") and not isdefined("form.fRHCAcodigo")><cfset form.fRHCAcodigo = url.fRHCAcodigo></cfif>
		<cfif isdefined("url.fRHCAdescripcion") and not isdefined("form.fRHCAdescripcion")><cfset form.fRHCAdescripcion = url.fRHCAdescripcion></cfif>
		<cfif isdefined("Form.fRHCAcodigo")>
<!--- 			<cfset filtro = filtro & " and RHCAcodigo like '%" & Form.fRHCAcodigo & "%'">
 --->			<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE('&'),DE('')) & "fRHCAcodigo=" & Form.fRHCAcodigo>
		</cfif>
		<cfif isdefined("Form.fRHCAdescripcion")>
<!--- 			<cfset filtro = filtro & " and RHCAdescripcion like '%" & Form.fRHCAdescripcion & "%'">
 --->			<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE('&'),DE('')) & "fRHCAdescripcion=" & Form.fRHCAdescripcion>
		</cfif>
		<form action="GComponentes.cfm" method="post" name="formfiltro" style="margin:0">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="AreaFiltro">
			  <tr>
				<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
				<td><strong><cfoutput>#LB_CODIGO#</cfoutput></strong></td>
				<td><strong><cfoutput>#LB_DESCRIPCION#</cfoutput></strong></td>
				<td>&nbsp;</td>
			  </tr>
			  <tr>
				<td><input name="fRHCAcodigo" type="text" id="fRHCAcodigo" size="5" maxlength="5" <cfif isdefined('Form.fRHCAcodigo')>value="<cfoutput>#Form.fRHCAcodigo#</cfoutput>"</cfif>></td>
				<td><input name="fRHCAdescripcion" type="text" id="fRHCAdescripcion" <cfif isdefined('Form.fRHCAdescripcion')>value="<cfoutput>#Form.fRHCAdescripcion#</cfoutput>"</cfif> size="40" maxlength="80"></td>
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="BTN_Filtrar"
				Default="Filtrar"
				XmlFile="/rh/generales.xml"
				returnvariable="BTN_Filtrar"/>

				<td><input type="submit" value="Filtrar" name="#BTN_Filtrar#"></td>
			  </tr>
			</table>
		</form>
		<cfquery name="lista" datasource="#session.DSN#">
			select RHCAid,RHCAcodigo,
				case when <cf_dbfunction name="length" args="RHCAdescripcion" datasource="#Session.DSN#">  > 30 then {fn concat(substring(RHCAdescripcion,1,30) ,'...' )} else RHCAdescripcion end as RHCAdescripcion
			from RHComponentesAgrupados
			where Ecodigo = #Session.Ecodigo#
			<cfif isdefined("Form.fRHCAcodigo") and len(trim(Form.fRHCAcodigo)) gt 0 >
				and RHCAcodigo like '%#Form.fRHCAcodigo#%'
<!--- 				<cfset filtro = filtro & " and RHCAcodigo like '%" & Form.fRHCAcodigo & "%'">
				<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE('&'),DE('')) & "fRHCAcodigo=" & Form.fRHCAcodigo>
 --->			</cfif>
			<cfif isdefined("Form.fRHCAdescripcion") and len(trim(Form.fRHCAdescripcion)) gt 0>
				and RHCAdescripcion like '%#Form.fRHCAdescripcion#%'
<!--- 				<cfset filtro = filtro & " and RHCAdescripcion like '%" & Form.fRHCAdescripcion & "%'">
				<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE('&'),DE('')) & "fRHCAdescripcion=" & Form.fRHCAdescripcion>
 --->			</cfif>
			order by RHCAorden, RHCAcodigo, RHCAdescripcion
		</cfquery>
		<!--- LISTA --->
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_CuandoLaListaEstaVacia"
		Default="-- No se han agregado Grupos de Componentes a esta Empresa. --"
		returnvariable="MSG_CuandoLaListaEstaVacia"/>



		<cfinvoke
		 component="rh.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRHRet">
			<cfinvokeargument name="query" value="#lista#"/>
			<cfinvokeargument name="desplegar" value="RHCAcodigo,RHCAdescripcion"/>
			<cfinvokeargument name="etiquetas" value="#LB_CODIGO#,#LB_DESCRIPCION#"/>
			<cfinvokeargument name="formatos" value="S,S"/>
			<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo# #filtro# order by RHCAorden, RHCAcodigo, RHCAdescripcion"/>
			<cfinvokeargument name="align" value="left,left"/>
			<cfinvokeargument name="ajustar" value="S"/>
			<cfinvokeargument name="irA" value="GComponentes.cfm"/>
			<cfinvokeargument name="maxRows" value="10"/>
			<cfinvokeargument name="keys" value="RHCAid"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
			<cfinvokeargument name="EmptyListMsg" value="#MSG_CuandoLaListaEstaVacia#"/>
		</cfinvoke>
	</td>
	<td valign="top">&nbsp;&nbsp;&nbsp;</td>
    <td valign="top">
		<cfif isdefined("url.PAGENUM") and not isdefined("form.PAGENUM")><cfset form.PAGENUM = url.PAGENUM></cfif>
		<cfset MODO = "ALTA">
		<cfif isdefined("Form.RHCAid")>
			<cfset MODO = "CAMBIO">
		</cfif>
		<cfquery name="rsCodigos" datasource="#session.dsn#">
			select RHCAcodigo
			from RHComponentesAgrupados
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		</cfquery>
		<cfif (MODO neq "ALTA")>
			<cfquery name="rsRHCAablaSalarial" datasource="#session.dsn#">
				select RHCAid, RHCAcodigo, RHCAdescripcion, RHCAorden, RHCAmComponenteExclu,RHCAmExcluyeSB, ts_rversion
				from RHComponentesAgrupados
				where RHCAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCAid#">
			</cfquery>
			<cfset ts = "">
			<cfinvoke
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsRHCAablaSalarial.ts_rversion#"/>
			</cfinvoke>
		</cfif>
		<script language="JavaScript1.2" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
		<script language="JavaScript1.2" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
		<form action="SQLGComponentes.cfm" method="post" name="form1">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
 			  <tr>
				<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
				<td>
					<table width="500" align="center"  border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td><strong><cfoutput>#LB_CODIGO#</cfoutput>&nbsp;:</strong></td>
						<td><cfif (MODO neq "ALTA")><input name="RHCAcodigo" type="text" id="RHCAcodigo" size="5" maxlength="5" value="<cfoutput>#Trim(rsRHCAablaSalarial.RHCAcodigo)#</cfoutput>"><cfelse><input name="RHCAcodigo" type="text" id="RHCAcodigo" size="5" maxlength="5"></cfif></td>
					  </tr>
					  <tr>
						<td><strong><cfoutput>#LB_DESCRIPCION#</cfoutput>&nbsp;:</strong></td>
						<td><input name="RHCAdescripcion" type="text" id="RHCAdescripcion" <cfif (MODO neq "ALTA")>value="<cfoutput>#rsRHCAablaSalarial.RHCAdescripcion#</cfoutput>"</cfif> size="80" maxlength="80"></td>
					  </tr>
					  <tr>
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_Orden"
						Default="Orden"
						returnvariable="LB_Orden"/>

						<td><strong><cfoutput>#LB_Orden#</cfoutput>&nbsp;:</strong></td>
						<td>
							<input type="text"
								name="RHCAorden" id="RHCAorden"
								onKeyPress="return acceptNum(event)"
								onFocus="javascript:this.select();"
								maxlength="10"
								size="10"
								value="<cfif (MODO neq "ALTA")><cfoutput>#rsRHCAablaSalarial.RHCAorden#</cfoutput></cfif>">
						</td>
					  </tr>
					  <tr>
						<td>&nbsp;</td>
						<td><input type="checkbox" id="RHCAmComponenteExclu" name="RHCAmComponenteExclu" <cfif (MODO neq "ALTA") and rsRHCAablaSalarial.RHCAmComponenteExclu eq 1>checked</cfif>><strong><cf_translate key="LB_Componenteexclusivo">Componente Exclusivo</cf_translate></strong></td>
					  </tr>
					  <!--- OPARRALES 2018-07-27 Para excluir Componente de Salario Base en las escalas salariales (Ej. Componente de temporada) --->
					  <tr>
						<td>&nbsp;</td>
						<td><input type="checkbox" id="RHCAmExcluyeSB" name="RHCAmExcluyeSB" <cfif (MODO neq "ALTA") and rsRHCAablaSalarial.RHCAmExcluyeSB eq 1>checked</cfif>><strong><cf_translate key="LB_Componenteexclusivo">Excluye Salario Base</cf_translate></strong></td>
					  </tr>
					  <tr>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
					  </tr>
					</table>
				</td>
			  </tr>
			  <tr>
				<td colspan="3">&nbsp;</td>
				</tr>
			  <tr>
				<td>
					<cfif (MODO neq "ALTA")>

						<cf_botones modo="#MODO#" include="GenerarNV" includevalues="Componentes">
						<input type="hidden" name="PAGENUM" <cfif isdefined("Form.PAGENUM")>value="<cfoutput>#Form.PAGENUM#</cfoutput>"</cfif>>
						<input type="hidden" name="RHCAid" value="<cfoutput>#rsRHCAablaSalarial.RHCAid#</cfoutput>">
						<input type="hidden" name="ts_rversion" value="<cfoutput>#ts#</cfoutput>">
					<cfelse>
						<cf_botones modo="#MODO#">
					</cfif>
				</td>
			  </tr>
			  <tr>
				<td colspan="3">&nbsp;</td>
				</tr>
			  <tr>
				<td colspan="3">
					<table width="500"  border="0" cellspacing="1" cellpadding="1" class="Ayuda">
						<tr>
							<td>
							<cf_translate key="AYUDA_ComponenteExclusivo">
							<strong>Componente Exclusivo: </strong> Retringir&aacute; que m&aacute;s de un componente de este grupo sea agregado a una misma acci&oacute;n de personal.
							</cf_translate>
							</td>
						</tr>
					</table>

				</td>
				</tr>
			</table>
		</form>
		<script language="javascript" type="text/javascript">
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_NoPuedeExistirOtroGrupoDeComponentesSalarialesConElMismoCodigo"
		Default=" ya existe, no puede existir otro Grupo de Componentes Salariales con el mismo Código."
		returnvariable="MSG_NoPuedeExistirOtroGrupoDeComponentesSalarialesConElMismoCodigo"/>

		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_El"
		Default="El"
		returnvariable="MSG_El"/>

			<!--//
			// Qforms. especifica la ruta donde el directorio "/qforms/" está localizado
			qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
			// Qforms. carga todas las librerías por defecto
			qFormAPI.include("*");
			//inicializa qforms en la página
			qFormAPI.errorColor = "#FFFFCC";
			//crea el objeto qforms
			objForm = new qForm("form1");
			//funciones agregadas de validación
			function _Field_isCodeExistence(){
				if (this.obj.value != "") {
					<cfoutput query="rsCodigos">
						if (this.obj.value=="#Trim(rsCodigos.RHCAcodigo)#"
						<cfif MODO neq "ALTA">
							&& this.obj.value != "#Trim(rsRHCAablaSalarial.RHCAcodigo)#"
						</cfif>
						){
							this.error = "#MSG_El# " + this.description + "#MSG_NoPuedeExistirOtroGrupoDeComponentesSalarialesConElMismoCodigo#";
						}
					</cfoutput>
				}
			}

			_addValidator("isCodeExistence", _Field_isCodeExistence);

		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_DigiteElCodigo"
		Default=" Código"
		XmlFile="/rh/generales.xml"
		returnvariable="MSG_DigiteElCodigo"/>

		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_DigiteLaDescripcion"
		Default=" Descripción"
		XmlFile="/rh/generales.xml"
		returnvariable="MSG_DigiteLaDescripcion"/>

		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_DigiteElOrden"
		Default=" Orden"
		returnvariable="MSG_DigiteElOrden"/>



			//asigna las validaciones
			objForm.RHCAcodigo.description = "<cfoutput>#JSStringFormat('#MSG_DigiteElCodigo#')#</cfoutput>";
			objForm.RHCAdescripcion.description = "<cfoutput>#JSStringFormat('#MSG_DigiteLaDescripcion#')#</cfoutput>";
			objForm.RHCAorden.description = "<cfoutput>#JSStringFormat('#MSG_DigiteElOrden#')#</cfoutput>";
			objForm.RHCAcodigo.required = true;
			objForm.RHCAdescripcion.required = true;
			objForm.RHCAorden.required = true;

			/*Validaciones Especiales*/
			objForm.RHCAcodigo.validateCodeExistence();

			/*Validaciones en OnBlur*/
			objForm.RHCAcodigo.validate = true;

			/*Focus*/
			objForm.RHCAcodigo.obj.focus();

			//funciones
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_SeleccionarUnaTablaSalarialParaPoderDarMantenimientoASusVigencias"
			Default=" Debe seleccionar una Tabla Salarial, para poder dar mantenimiento a sus vigencias."
			returnvariable="MSG_SeleccionarUnaTablaSalarialParaPoderDarMantenimientoASusVigencias"/>



			function funcGenerarNV(){
				if (!objForm.RHCAid || objForm.RHCAid.getValue()==''){
					alert("<cfoutput>#JSStringFormat('#MSG_SeleccionarUnaTablaSalarialParaPoderDarMantenimientoASusVigencias#')#</cfoutput>");
					return false;
				}
				deshabilitarValidacion();
				objForm.obj.action = "Componentes.cfm";
				return true;
			}

			function habilitarValidacion(){
				objForm.RHCAcodigo.required = true;
				objForm.RHCAdescripcion.required = true;
				objForm.RHCAorden.required = true;
			}

			function deshabilitarValidacion(){
				objForm.RHCAcodigo.required = false;
				objForm.RHCAdescripcion.required = false;
				objForm.RHCAorden.required = false;
			}

			//-->
		</script>
	</td>
  </tr>
</table>