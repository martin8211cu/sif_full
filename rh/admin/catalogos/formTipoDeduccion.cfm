<cfif isdefined('url.modo') and not isdefined('form.modo')>
	<cfset form.modo = url.modo>
</cfif>
<cfif isdefined('url.TDid') and not isdefined('form.TDid')>
	<cfset form.TDid = url.TDid>
</cfif>

<!-- Establecimiento del modo -->
<cfif isdefined("form.Cambio")>
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


<!--- Consultas --->
<cfif modo NEQ "ALTA">
	<!--- Form --->
	<cfquery name="rsForm" datasource="#session.DSN#">
		select <!---convert(varchar,TDid) as --->TDid, TDcodigo, TDdescripcion, TDfecha,
			   TDobligatoria, TDprioridad, TDparcial, TDordmonto, TDordfecha, a.TDesajuste,
			   TDfinanciada, Ccuenta, CFcuenta, cuentaint, CFcuentaint, TDrenta, TDclave, TDcodigoext, TDley, TDdrenta,TDfoa, a.SNcodigo, b.SNnumero, b.SNnombre,RHCSATid,
			   a.ts_rversion,a.TDespecie,TDFondoAhorro,TDFondoAhorroEmp
		from TDeduccion a
		left outer join SNegocios b
			on a.SNcodigo=b.SNcodigo
			and a.Ecodigo = b.Ecodigo
		where TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid#">
		  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
</cfif>

<!--- registros existentes --->
<cfquery name="rsCodigos" datasource="#session.DSN#">
	select rtrim(TDcodigo) as TDcodigo
	from TDeduccion
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif modo neq 'ALTA'>
		and TDid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid#">
	</cfif>
</cfquery>

<!--- VERIFICA SI LA EMPRESA ES DE GUATEMALA PARA MOSTRAR OTROS DATOS --->
<cfquery name="rsEmpresa" datasource="#session.dsn#">
	select 1
	from Empresa e
		inner join Direcciones d
		on d.id_direccion = e.id_direccion
		and Ppais = 'GT'
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
</cfquery>
<!--- VERIFICA PARAMETRO PARA MOSTRAR CLAVE Y CODIGO UTILIZADO EN PROCESO DE INTERFAZ CON SAP (OE) --->
<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="2010" default="" returnvariable="InterfazCatalogos"/>

<!--- Javascript --->
<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	<cfif modo NEQ "ALTA">
	<cfoutput>
	function funcPermisos() {
		location.href =  "TipoDeduccionPermiso.cfm?TDid=#Form.TDid#";
		return false;
	}
	</cfoutput>
	</cfif>

	//-->
</script>
<style type="text/css">
<!--
.style1 {font-size: 9px}
-->
</style>

<form name="form1" method="post" action="SQLTipoDeduccion.cfm">
	<cfif isdefined('PageNum')>
		<input name="PageNum" type="hidden" value="<cfoutput>#PageNum#</cfoutput>"/>
	</cfif>
	<cfoutput>
		<table width="98%" border="0" cellspacing="0" cellpadding="2" align="center">
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
				<td align="right" width="22%">#LB_CODIGO#:&nbsp;</td>
				<td width="28%" >
					<input type="text" name="TDcodigo" value="<cfif modo NEQ 'ALTA'>#trim(rsForm.TDcodigo)#</cfif>" size="7" maxlength="5" onfocus="this.select();" onblur="javascript:codigos(this);" >
			  </td>
			</tr>

			<tr>
				<td align="right" width="22%">#LB_DESCRIPCION#:&nbsp;</td>
				<td >
					<input type="text" name="TDdescripcion" value="<cfif modo NEQ 'ALTA'>#rsForm.TDdescripcion#</cfif>" size="60" maxlength="60" onfocus="this.select();" >
				</td>
			</tr>

			<tr>
				<tr>
						<td align="right" width="22%">#MSG_ConceptoSAT#:&nbsp;</td>
						<td>
						<cfquery name="rsConceptoSAT" datasource="#session.DSN#">
								select RHCSATid,RHCSATcodigo,RHCSATdescripcion from dbo.RHCFDIConceptoSAT
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
								and RHCSATtipo = 'D'
								union
								select RHCSATid,RHCSATcodigo,RHCSATdescripcion from dbo.RHCFDIConceptoSAT
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
								and RHCSATtipo = 'P' and RHCSATcodigo='002' and RHCSATOtroPago = 1
								order by RHCSATcodigo
						</cfquery>
						<select name="ConceptoSAT" id="ConceptoSAT">
								<option value=0>-- <cf_translate key="LB_seleccionar" xmlfile="/rh/generales.xml"><cfoutput>Seleccione una opción</cfoutput></cf_translate> --</option>
								<cfloop query="rsConceptoSAT">
										<option value="#rsConceptoSAT.RHCSATid#" <cfif modo NEQ "ALTA" and rsConceptoSAT.RHCSATid eq rsForm.RHCSATid>selected</cfif> >#rsConceptoSAT.RHCSATcodigo# #rsConceptoSAT.RHCSATdescripcion#</option>
								</cfloop>
						</select>
						</td>
				</tr>
			</tr>
			
			<tr>
				<td align="right" width="22%">#LB_Prioridad#:&nbsp;</td>
				<td>
					<input type="text" name="TDprioridad" value="<cfif modo NEQ 'ALTA'>#rsForm.TDprioridad#<cfelse>1</cfif>" size="10" maxlength="10" onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,0);"  onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;">
				</td>
			</tr>

			<tr>
				<td align="right" width="22%">
			  <cf_translate XmlFile="/rh/generales.xml" key="LB_Cuenta">Cuenta</cf_translate>:&nbsp;</td>
				<td>
					<cfif modo NEQ 'ALTA' >
						<cfif rsForm.Ccuenta NEQ ''> <!--- El campo Ccuenta puede ser nulo, si no es nulo carga el Tag ---->
							<!--- Query para traer los datos de la cuenta: Ccuenta ---->
							<cfquery name="rsCuenta" datasource="#session.DSN#">
								select CFcuenta, Cmayor, Ccuenta, CFdescripcion, CFformato
								from CFinanciera f
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.Ccuenta#">
							</cfquery>
							<!--- CFcuenta, Cmayor, Ccuenta, Cdescripcion  =  names de los inputs donde se guardaran los datos si NO va usa los default que son los mismos ---->
							<cf_cuentas Conlis="S" frame="frame0" auxiliares="N" movimiento="S" query="#rsCuenta#" descwidth="13">
						<cfelse>
							<cf_cuentas Conexion="#session.DSN#" Conlis="S" frame="frame0" auxiliares="N" movimiento="S" form="form1"  descwidth="13" >
						</cfif>
					<cfelse>
						<cf_cuentas Conexion="#session.DSN#" Conlis="S" frame="frame0" auxiliares="N" movimiento="S" form="form1"  descwidth="13">
					</cfif>
				</td>
			</tr>

			<tr>
				<td align="right" width="22%" nowrap>
			  <cf_translate  key="LB_CuentaIntereses">Cuenta Intereses</cf_translate>:&nbsp;</td>
				<td>
					<cfif modo NEQ 'ALTA' >
						<cfif rsForm.cuentaint NEQ ''> <!--- El campo cuentaint puede ser nulo, si no es nulo carga el Tag ---->
							<!--- Query para traer los datos de la cuenta: cuentaint en modo CAMBIO ---->
							<cfquery name="rsCuenta" datasource="#session.DSN#">
								select CFcuenta, Cmayor, Ccuenta, CFdescripcion, CFformato
								from CFinanciera f
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.cuentaint#">
							</cfquery>
							<!--- CFcuenta, Cmayor, Ccuenta, Cdescripcion  =  names de los inputs donde se guardaran los datos ---->
							<cf_cuentas Conlis="S" frame="frame1" auxiliares="N" movimiento="S" CFcuenta="CFcuenta_cuentaint" Cmayor="Cmayor_cuentaint" ccuenta="Ccuenta_cuentaint" Cdescripcion="CFdescripcion_cuentaint" cformato="CFformato_cuentaint" query="#rsCuenta#" descwidth="13">

						<cfelse>
							<cf_cuentas Conexion="#session.DSN#" Conlis="S" frame="frame1" auxiliares="N" movimiento="S" form="form1" CFcuenta="CFcuenta_cuentaint" Cmayor="Cmayor_cuentaint" ccuenta="Ccuenta_cuentaint" Cdescripcion="CFdescripcion_cuentaint" cformato="CFformato_cuentaint" descwidth="13" >
						</cfif>
					<cfelse>
						<cf_cuentas Conexion="#session.DSN#" Conlis="S" frame="frame1" auxiliares="N" movimiento="S" form="form1" CFcuenta="CFcuenta_cuentaint" Cmayor="Cmayor_cuentaint" ccuenta="Ccuenta_cuentaint" Cdescripcion="CFdescripcion_cuentaint" cformato="CFformato_cuentaint" descwidth="13">
					</cfif>
				</td>
			</tr>

			<tr>
				<td align="right" width="22%" nowrap>
			  Socio de Negocio por defecto:&nbsp;</td>
				<td>


					<cfif modo NEQ "ALTA">
						<cf_rhsociosnegociosFA query="#rsForm#">
						<!---<script language="JavaScript1.2" type="text/javascript">
							<cfif modo neq 'ALTA'>
								document.form1.SNnumero.focus();
								document.form1.SNnumero.blur();
							</cfif>
						</script>--->
					<cfelse>
						<cf_rhsociosnegociosFA>
					</cfif>
				</td>
			</tr>

			<tr>
				<td align="right" width="22%" valign="top">
			  <cf_translate  key="LB_Criterio">Criterio</cf_translate>:&nbsp;</td>
				<td>
					<table width="53%"  border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td valign="middle">
								&nbsp;&nbsp;
								<input type="radio" name="TDcriterio" value="1" <cfif modo NEQ 'ALTA' and rsForm.TDordmonto EQ 1>checked</cfif>><cf_translate  key="RAD_MontoAscendente">&nbsp;Monto Ascendente</cf_translate>
							</td>
							<td>
								<input type="radio" name="TDcriterio" value="4" <cfif modo NEQ 'ALTA' and rsForm.TDordfecha EQ 2>checked</cfif>><cf_translate  key="RAD_FechaDescendente">&nbsp;Fecha Descendente</cf_translate>
							</td>
						</tr>
						<tr>
							<td>
								&nbsp;&nbsp;
								<input type="radio" name="TDcriterio" value="3" <cfif modo NEQ 'ALTA' and rsForm.TDordfecha EQ 1>checked</cfif>><cf_translate  key="RAD_FechaAscendente">&nbsp;Fecha Ascendente</cf_translate>
							</td>
							<td>
								<input type="radio" name="TDcriterio" value="2" <cfif (modo NEQ 'ALTA' and rsForm.TDordmonto EQ 2) or (modo EQ 'ALTA')>checked</cfif>><cf_translate  key="RAD_MontoDescendente">&nbsp;Monto Descendente</cf_translate>
							</td>
						</tr>
					</table>
				</td>
			</tr>

			<tr><td colspan="2"></td></tr>
			<tr><td colspan="2"></td></tr>
			<tr><td colspan="2"></td></tr>
			<tr><td colspan="2"></td></tr>

			<tr>
				<td>&nbsp;</td>
				<td align="left">
					<table align="left" width="25%">
						<tr>
							<td>
								&nbsp;&nbsp;
								<input type="checkbox" name="TDley" value="1" onclick="funcMarcar(this.value)" <cfif modo NEQ 'ALTA' and rsForm.TDley EQ 1>checked</cfif>>
								#LB_Ley#
							</td>
						</tr>
						<tr>
							<td >
								&nbsp;&nbsp;
								<input type="checkbox" name="TDobligatoria" value="1" <cfif modo NEQ 'ALTA' and rsForm.TDobligatoria EQ 1>checked</cfif>>
								#LB_Obligatoria#
							</td>
						</tr>
						<tr>		
							<td>
								&nbsp;&nbsp;
								<input type="checkbox" name="TDparcial" value="1" <cfif modo NEQ 'ALTA' and rsForm.TDparcial EQ 1>checked</cfif>>
								<cf_translate  key="LB_PagoParcial">Pago Parcial</cf_translate>
							</td>
						</tr>
						<tr>	
							<td>
								&nbsp;&nbsp;
								<input type="checkbox" name="TDfinanciada" value="1" <cfif modo NEQ 'ALTA' and rsForm.TDfinanciada EQ 1>checked</cfif>>
								<cf_translate  key="LB_Financiada">Financiada</cf_translate>
							</td>
						</tr>	

						<tr>
							<td>
								&nbsp;&nbsp;
								<input type="checkbox" name="TDrenta" value="1" <cfif modo NEQ 'ALTA' and rsForm.TDrenta EQ 1>checked</cfif>>
								<cf_translate  key="LB_Renta">Renta</cf_translate>
							</td>
						</tr>
						<tr>
							<td>
								&nbsp;&nbsp;
								<input type="checkbox" name="TDesajuste" value="1"<cfif modo NEQ 'ALTA' and rsForm.TDesajuste EQ 1>checked</cfif>>
								Ajuste ISR
							</td>
						</tr>
					</table>
					<table>
						<tr>
							<td>
								&nbsp;&nbsp;
								<input type="checkbox" name="TDdrenta" value="1" <cfif modo NEQ 'ALTA' and rsForm.TDdrenta EQ 1>checked</cfif>>
								#LB_DespuesRenta#
							</td>
						</tr>
						<tr>
							<td>
								&nbsp;&nbsp;
								<input type="checkbox" name="TDfoa" value="1" <cfif modo NEQ 'ALTA' and rsForm.TDfoa EQ 1>checked</cfif>>
								#LB_PrestFOA#
								</td>
						</tr>

						<tr>
							<td>&nbsp;&nbsp;
								<input type="checkbox" name="TDespecie" value="1" <cfif modo NEQ 'ALTA' and rsForm.TDespecie EQ 1>checked</cfif>>
								<cf_translate  key="LB_TDespecie">Pago en Especie</cf_translate>
							</td>
						</tr>

						<tr>
							<td>&nbsp;&nbsp;
								<input type="checkbox" name="TDFondoAhorro" value="1" <cfif modo NEQ 'ALTA' and rsForm.TDFondoAhorro EQ 1>checked</cfif>>
								<cf_translate  key="LB_TDFondoAhorro">Fondo de Ahorro Patr&oacute;n</cf_translate>
							</td>
						</tr>

						<tr>
							<td>&nbsp;&nbsp;
								<input type="checkbox" name="TDFondoAhorroEmp" value="1" <cfif modo NEQ 'ALTA' and rsForm.TDFondoAhorroEmp EQ 1>checked</cfif>>
								<cf_translate  key="LB_TDFondoAhorroEmp">Fondo de Ahorro Empleado</cf_translate>
							</td>
						</tr>
					</table>
				</td>
			</tr>

			
			<cfif rsEmpresa.RecordCount NEQ 0 OR (LEN(TRIM(InterfazCatalogos)) and InterfazCatalogos EQ 1)>
			<tr>
				<td align="right" width="22%" >
			  <cf_translate  key="LB_Clave">Clave</cf_translate>:&nbsp;</td>
				<td><input name="TDclave" type="text" size="6" maxlength="4" value="<cfif modo NEQ 'ALTA'>#rsForm.TDclave#</cfif>" /></td>
			</tr>
			<tr>
				<td align="right" width="22%">
			  <cf_translate  key="LB_CodigoExterno">C&oacute;digo Externo</cf_translate>:&nbsp;</td>
				<td><input name="TDcodigoext" type="text" size="6" maxlength="5" value="<cfif modo NEQ 'ALTA'>#TRIM(rsForm.TDcodigoext)#</cfif>" /></td>
			</tr>
			</cfif>
			<tr><td colspan="2"></td></tr>
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
				<td colspan="2">
					<table width="93%">
						<tr>
							<td align="center">
								<!--- <cfinclude template="/rh/portlets/pBotones.cfm"> --->
								<cfset Lvar_Botones = ''>
								<cfif modo NEQ "ALTA">
								<!--- 	<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="BTN_Permiso"
									Default="Permisos"
									returnvariable="BTN_Permiso"/>
									<input type="button" name="btnPermiso" value="#BTN_Permiso#" onClick="javascript: verPermisos(this.form);">
				--->					<cfset Lvar_Botones = Lvar_Botones &'Permisos'>
								</cfif>
								<cf_botones modo='#modo#' include="#Lvar_Botones#">
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>

		<!--- OCULTOS --->
		<input type="text" name="nada" value="" class="cajasinbordeb">
		<input type="hidden" name="TDid" value="<cfif modo NEQ 'ALTA'>#rsForm.TDid#</cfif>">

		<!--- ts_rversion --->
		<cfset ts = "">
		<cfif modo neq "ALTA">
			<cfinvoke
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
			</cfinvoke>
		</cfif>
		<input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'>#ts#</cfif>">
	</cfoutput>
</form>

<script language="JavaScript1.2" type="text/javascript">

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Codigo"
	Default="Código"
	returnvariable="MSG_Codigo"/>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Descripcion"
	Default="Descripción"
	returnvariable="MSG_Descripcion"/>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Prioridad"
	Default="Prioridad"
	returnvariable="MSG_Prioridad"/>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Criterio"
	Default="Criterio"
	returnvariable="MSG_Criterio"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElCodigoDeTipoDeDeduccionYaExiste"
	Default="El Código de Tipo de Deducción ya existe"
	returnvariable="MSG_ElCodigoDeTipoDeDeduccionYaExiste"/>


	objForm.TDcodigo.required = true;
	objForm.TDcodigo.description="<cfoutput>#MSG_Codigo#</cfoutput>";

	objForm.TDdescripcion.required = true;
	objForm.TDdescripcion.description="<cfoutput>#MSG_Descripcion#</cfoutput>";

	objForm.TDprioridad.required = true;
	objForm.TDprioridad.description = "<cfoutput>#MSG_Prioridad#</cfoutput>";

	objForm.TDcriterio.required = true;
	objForm.TDcriterio.description = "<cfoutput>#MSG_Criterio#</cfoutput>";

	function deshabilitarValidacion(){
		objForm.TDcodigo.required      = false;
		objForm.TDdescripcion.required = false;
		objForm.TDprioridad.required = false;
		objForm.TDcriterio.required = false;
	}


function limpiar(){
		document.form1.reset();
		}

	function codigos(obj){
		if (obj.value != "") {
			var empresa = <cfoutput>#session.Ecodigo#</cfoutput>
			var dato    = obj.value + "|" + empresa;
			var temp    = new String();


			<cfloop query="rsCodigos">
				temp = '<cfoutput>#rsCodigos.TDcodigo#</cfoutput>' + "|" + empresa
				if (dato == temp){
					alert('<cfoutput>#MSG_ElCodigoDeTipoDeDeduccionYaExiste#</cfoutput>');
					obj.value = "";
					obj.focus();
					return false;
				}
			</cfloop>
		}
		return true;
	}

function funcMarcar(LvarV){
	if (LvarV=1){
		document.form1.TDobligatoria.checked=true;
	}
	else{
		document.form1.TDobligatoria.checked=false;
	}
}


</script>