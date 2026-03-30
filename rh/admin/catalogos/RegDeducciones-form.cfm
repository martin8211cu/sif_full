<cfif isdefined("Url.EIDlote") and not isdefined("Form.EIDlote")>
	<cfset Form.EIDlote = Url.EIDlote>
</cfif>
<cfif isdefined("Url.DEidentificacion") and not isdefined("Form.DEidentificacion")>
	<cfset Form.DEidentificacion = Url.DEidentificacion>
</cfif>
<cfif isdefined("Url.DIDreferencia") and not isdefined("Form.DIDreferencia")>
	<cfset Form.DIDreferencia = Url.DIDreferencia>
</cfif>
<cfif isdefined("Url.DIDmetodo") and not isdefined("Form.DIDmetodo")>
	<cfset Form.DIDmetodo = Url.DIDmetodo>
</cfif>
<cfif isdefined("Url.DIDfechaini") and not isdefined("Form.DIDfechaini")>
	<cfset Form.DIDfechaini = Url.DIDfechaini>
</cfif>
<cfif isdefined("Url.DIDfechafin") and not isdefined("Form.DIDfechafin")>
	<cfset Form.DIDfechafin = Url.DIDfechafin>
</cfif>
<cfif isdefined("Url.btnBuscar") and not isdefined("Form.btnBuscar")>
	<cfset Form.btnBuscar = Url.btnBuscar>
</cfif>

<cfif isdefined("Form.EIDlote") and Len(Trim(Form.EIDlote)) NEQ 0>
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<cfif isdefined("Form.DIDid") and Len(Trim(Form.DIDid)) NEQ 0>
	<cfset modoDet = "CAMBIO">
<cfelse>
	<cfset modoDet = "ALTA">
</cfif>

<cfset filtro = "">
<cfif isdefined("Form.EIDlote") and Len(Trim(Form.EIDlote)) NEQ 0>
	<cfset navegacion = "btnBuscar=Buscar&EIDlote=" & Form.EIDlote>
<cfelse>
	<cfset navegacion = "btnBuscar=Buscar">
</cfif>

<cfif isdefined("Form.DEidentificacion") and Len(Trim(Form.DEidentificacion)) NEQ 0>
	<cfset filtro = filtro & " and a.DIDidentificacion = '" & Form.DEidentificacion & "'">
	<cfset navegacion = navegacion & "&DEidentificacion=" & Form.DEidentificacion>
</cfif>

<cfif isdefined("Form.DIDreferencia") and Len(Trim(Form.DIDreferencia)) NEQ 0>
	<cfset filtro = filtro & " and a.DIDreferencia = '" & Form.DIDreferencia & "'">
	<cfset navegacion = navegacion & "&DIDreferencia=" & Form.DIDreferencia>
</cfif>

<cfif isdefined("Form.DIDmetodo") and Len(Trim(Form.DIDmetodo)) NEQ 0>
	<cfset filtro = filtro & " and a.DIDmetodo = " & Form.DIDmetodo>
	<cfset navegacion = navegacion & "&DIDmetodo=" & Form.DIDmetodo>
<cfelseif isdefined("Form.DIDmetodo")>
	<cfset navegacion = navegacion & "&DIDmetodo=" >
</cfif>

<cfif isdefined("Form.DIDfechaini") and Len(Trim(Form.DIDfechaini)) NEQ 0>
	<cfset filtro = filtro & " and a.DIDfechaini = convert(datetime, '" & Form.DIDfechaini & "', 103)">
	<cfset navegacion = navegacion & "&DIDfechaini=" & Form.DIDfechaini>
</cfif>

<cfif isdefined("Form.DIDfechafin") and Len(Trim(Form.DIDfechafin)) NEQ 0>
	<cfset filtro = filtro & " and a.DIDfechafin = convert(datetime, '" & Form.DIDfechafin & "', 103)">
	<cfset navegacion = navegacion & "&DIDfechafin=" & Form.DIDfechafin>
</cfif>

<!---====== Traducciones =======--->
<!---Boton Agregar--->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Agregar"
	Default="Agregar"
	XmlFile="/rh/generales.xml"
	returnvariable="vAgregar"/>
<!---Boton Buscar ---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Buscar"
	Default="Buscar"
	XmlFile="/rh/generales.xml"
	returnvariable="vBuscar"/>
<!---Boton Modificar ---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Modificar"
	Default="Cambiar"
	XmlFile="/rh/generales.xml"
	returnvariable="vCambiar"/>
<!---Boton Eliminar ---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Eliminar"
	Default="Eliminar"
	XmlFile="/rh/generales.xml"
	returnvariable="vEliminar"/>
<!----Boton Nuevo ---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Nuevo"
	Default="Nuevo"
	XmlFile="/rh/generales.xml"
	returnvariable="vNuevo"/>
<!---Alert javascript Eliminar---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Esta_seguro_de_que_desea_eliminar_esta_deduccion"
	Default="¿Est&aacute; seguro de que desea eliminar esta deducci&oacute;n?"
	returnvariable="vSeguroEliminar"/>
<!--Alert javascript Eliminar Encabezado(deducciones) --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Esta_seguro_de_que_desea_eliminar_este_lote_de_deducciones"
	Default="¿Est&aacute; seguro de que desea eliminar este lote de deducciones?"
	returnvariable="vEliminarLote"/>
<!---Lista identificacion ---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Identificacion"
	Default="Identificaci&oacute;n"
	xmlfile="/rh/generales.xml"
	returnvariable="vIdentificacion"/>
<!---Lista Nombre ---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_NombreCompleto"
	Default="Nombre Completo"
	returnvariable="vNombreCompleto"/>
<!---Lista Metodo ---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Metodo"
	Default="Método"
	returnvariable="vMetodo"/>
<!---Lista Referencia ---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Referencia"
	Default="Referencia"
	returnvariable="vReferencia"/>
<!---Lista Valor ---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Valor"
	Default="Valor"
	returnvariable="vValor"/>
<!---Lista Fecha inicio ---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaInicioLista"
	Default="Fecha de Inicio"
	returnvariable="vFInicioLista"/>
<!---Lista Fecha fin ---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaFinLista"
	Default="Fecha Fin"
	returnvariable="vFFinLista"/>
<!---Qforms Empleado---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Empleado"
	Default="Empleado"
	xmlfile="/rh/generales.xml"
	returnvariable="vQEmpleado"/>
<!---Qforms Socio Negocio ---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_SocioNegocio"
	Default="Socio Negocio"
	xmlfile="/rh/generales.xml"
	returnvariable="vQSocioNegocio"/>
<!--Qforms tipo deduccion --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_TipoDeduccion"
	Default="Tipo de Deducci&oacute;n"
	returnvariable="vQTipoDeduccion"/>
<!--Qforms Monto deduccion --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_MontoPrestamo"
	Default="Monto Pr&eacute;stamo"
	returnvariable="vQMtoPrestamo"/>
<!---Titulo del porlet ---->
<cfif modoDet EQ "CAMBIO">
	<cfset tit = "Modificar Deducci&oacute;n">
<cfelse>
	<cfset tit = "Agregar Deducci&oacute;n">
</cfif>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_TituloPorletDetalleDeduccion"
	Default="#tit#"
	returnvariable="vTituloPorletDetalle"/>
<!---==========================---->

<cfif modo EQ "CAMBIO">
	<cfquery name="rsEncabezado" datasource="#Session.DSN#">
		select 	b.SNnombre,
				{fn concat({fn concat(c.TDcodigo,' - ')},c.TDdescripcion)} as TipoDeduccion
		from EIDeducciones a, SNegocios b, TDeduccion c
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.EIDlote = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.EIDlote#">
		and a.TDid = c.TDid
		and a.SNcodigo = b.SNcodigo
		and a.Ecodigo = b.Ecodigo
	</cfquery>

	<cfif modoDet EQ "CAMBIO">
		<cfquery name="rsDetalle" datasource="#Session.DSN#">
			select b.DEid,
				  {fn concat({fn concat({fn concat({ fn concat(b.DEnombre, ' ') },b.DEapellido1)}, ' ')},b.DEapellido2) } as NombreEmp,
				   b.DEidentificacion,
				   b.NTIcodigo,
				   rtrim(a.DIDreferencia) as referencia,
				   a.DIDmetodo as metodo,
				   a.DIDvalor as valor,
				   a.DIDmonto as monto,
				   a.DIDfechaini as fechaini,
				   a.DIDfechafin as fechafin,
				   a.DIDcontrolsaldo as controlsaldo,
				   a.ts_rversion
			from DIDeducciones a, DatosEmpleado b
			where a.EIDlote = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.EIDlote#">
			and a.DIDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DIDid#">
			and a.DIDidentificacion = b.DEidentificacion
			and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
	</cfif>
</cfif>

<script language="JavaScript" src="/cfmx/sif/js/qForms/qforms.js">//</script>
<script language="javascript" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	function validaForm(f) {

		if (document.form1.DIDmetodo.value == 0 && document.form1.DIDvalor.value > 100){
			alert("El valor del metodo de tipo porcentaje debe ser menor o igual a 100");
			return false;
		}

		if (document.form1.DIDfechafin.value == ''){
			document.form1.DIDfechafin.value = '01/01/6100'
		}

		<cfif modo EQ "CAMBIO">
			f.obj.DIDvalor.value = qf(f.obj.DIDvalor.value);
			f.obj.DIDmonto.value = qf(f.obj.DIDmonto.value);
		</cfif>
		return true;
	}

	function doConlisImport() {
		window.open("RegDeducciones-import.cfm", "ImportarDeducciones");
	}

	//-->
</script>

<cfoutput>
<form name="form1" method="post" action="RegDeducciones-sql.cfm" onSubmit="javascript: return validaForm(this);" style="margin: 0;">
	<cfif modo EQ "CAMBIO">
		<input type="hidden" name="EIDlote" id="EIDlote" value="#Form.EIDlote#">
	</cfif>
	<cfif modoDet EQ "CAMBIO">
		<input type="hidden" name="DIDid" id="DIDid" value="#Form.DIDid#">
		<cfset ts = "">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" arTimeStamp="#rsDetalle.ts_rversion#" returnvariable="ts">
		</cfinvoke>
		<input type="hidden" name="ts_rversion" id="ts_rversion" value="#ts#">
	</cfif>
	<cfif isdefined("Form.PageNum")>
		<input type="hidden" name="Pagina" id="Pagina" value="#Form.PageNum#">
	</cfif>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
	  <tr>
	  	<td colspan="<cfif modo EQ 'CAMBIO'>7<cfelse>4</cfif>" align="center" nowrap>&nbsp;

		</td>
	  </tr>
	  <tr>
	  	<cfif modo EQ "CAMBIO">
			<td align="right" nowrap class="fileLabel"><cf_translate key="LB_Lote">Lote:</cf_translate></td>
			<td nowrap>#Form.EIDlote#</td>
		</cfif>
		<td align="right" nowrap class="fileLabel"><cf_translate key="LB_SocioNegocio" xmlfile="/rh/generales.xml">Socio de Negocio:</cf_translate></td>
		<td nowrap>
			<cfif modo EQ "CAMBIO">
				#rsEncabezado.SNnombre#
			<cfelse>
				<cf_rhsociosnegociosFA SNtiposocio="A" form="form1">
			</cfif>
		</td>
		<td align="right" nowrap class="fileLabel">#vQTipoDeduccion#</td>
		<td nowrap>
			<cfif modo neq 'ALTA'>
				#rsEncabezado.TipoDeduccion#
			<cfelse>
				<cf_rhtipodeduccion size="40" form="form1" validate="1">
			</cfif>
		</td>
	  	<cfif modo EQ 'CAMBIO'>
			<td align="right" nowrap>
				<input type="submit" name="btnEliminar" id="btnEliminar" value="#vEliminar#" onClick="javascript: inhabilitarValidacion(); return (confirm('#vEliminarLote#'));">
			</td>
		</cfif>
	  </tr>
	<cfif modo NEQ 'CAMBIO'>
	  <tr>
	  	<td colspan="<cfif modo EQ 'CAMBIO'>7<cfelse>4</cfif>" align="center" nowrap>&nbsp;

		</td>
	  </tr>
	  <tr>
	  	<td colspan="<cfif modo EQ 'CAMBIO'>7<cfelse>4</cfif>" align="center" nowrap>
			<input type="submit" name="btnAgregar" id="btnAgregar" value="#vAgregar#">
		</td>
	  </tr>
	</cfif>
	 <cfif modo EQ "CAMBIO">
	  <tr>
	  	<td colspan="<cfif modo EQ 'CAMBIO'>7<cfelse>4</cfif>" align="center" nowrap>&nbsp;</td>
	  </tr>
	  <tr>
	  	<td colspan="<cfif modo EQ 'CAMBIO'>7<cfelse>4</cfif>" align="center" nowrap>
		  <cf_web_portlet_start border="true" titulo="#vTituloPorletDetalle#" skin="#Session.Preferences.Skin#">
			<table width="100%" border="0" cellspacing="0" cellpadding="3" align="center">
			  <tr>
				<td align="right" nowrap class="fileLabel"><cf_translate key="LB_Empleado" xmlfile="/rh/generales.xml">*Empleado:</cf_translate></td>
				<td colspan="7" nowrap>
					<cfif modoDet NEQ "ALTA">
						<cf_rhempleado size="70" form="form1" query="#rsDetalle#" >
					<cfelseif isdefined("Form.btnBuscar") and isdefined("Form.DEid") and Len(Trim(Form.DEid)) NEQ 0>
						<cfquery name="rsEmpBuscar" datasource="#Session.DSN#">
							select DEid,
								   {fn concat({fn concat({fn concat({ fn concat(b.DEnombre, ' ') },b.DEapellido1)}, ' ')},b.DEapellido2) },
								   b.DEidentificacion,
								   b.NTIcodigo
							from DatosEmpleado b
							where b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
							and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						</cfquery>
						<cf_rhempleado size="70" form="form1" query="#rsEmpBuscar#" >
					<cfelse>
						<cf_rhempleado size="70" form="form1" >
					</cfif>
				</td>
			  </tr>
			  <tr>
				<td align="right" nowrap class="fileLabel"><cf_translate key="LB_Referencia">*Referencia:</cf_translate></td>
				<td>
					<input name="DIDreferencia" id="DIDreferencia" type="text" value="<cfif modoDet EQ 'CAMBIO'>#rsDetalle.referencia#<cfelseif isdefined("Form.btnBuscar") and isdefined("Form.DIDreferencia")>#Form.DIDreferencia#</cfif>" size="22" maxlength="20" onfocus="javascript: this.select();">
				</td>
				<td align="right" nowrap class="fileLabel"><cf_translate key="LB_Metodo">*M&eacute;todo:</cf_translate></td>
				<td>
					<select name="DIDmetodo">
						<option value="">-- Seleccione --</option>
						<option value="0"
							<cfif isdefined("form.btnBuscar")>
								<cfif isdefined("Form.DIDmetodo") and Trim(Form.DIDmetodo) EQ 0>
								selected
								</cfif>
							<cfelse>
								<cfif modoDet EQ 'CAMBIO' and rsDetalle.metodo EQ 0>selected</cfif>
							</cfif>
						>Porcentaje</option>

						<option value="1"
							<cfif isdefined("form.btnBuscar")>
								<cfif isdefined("Form.DIDmetodo") and Trim(Form.DIDmetodo) EQ 1>
								selected
								</cfif>
							<cfelse>
									<cfif modoDet EQ 'CAMBIO' and rsDetalle.metodo EQ 1 >selected</cfif>
							</cfif>
						>Valor</option>

						<option value="2" <cfif isdefined("form.btnBuscar")><cfif isdefined("Form.DIDmetodo") and Trim(Form.DIDmetodo) EQ 2>selected</cfif>
							<cfelse>
									<cfif modoDet EQ 'CAMBIO' and rsDetalle.metodo EQ 2 >selected</cfif>
							</cfif>
						>VUMA</option>

						<option value="3" <cfif isdefined("form.btnBuscar")><cfif isdefined("Form.DIDmetodo") and Trim(Form.DIDmetodo) EQ 3>selected</cfif>
							<cfelse>
									<cfif modoDet EQ 'CAMBIO' and rsDetalle.metodo EQ 3 >selected</cfif>
							</cfif>
						>VUMI</option>

						<option value="4" <cfif isdefined("form.btnBuscar")><cfif isdefined("Form.DIDmetodo") and Trim(Form.DIDmetodo) EQ 4>selected</cfif>
							<cfelse>
									<cfif modoDet EQ 'CAMBIO' and rsDetalle.metodo EQ 4 >selected</cfif>
							</cfif>
						>Cuota Fija</option>
						<option value="5" <cfif isdefined("form.btnBuscar")><cfif isdefined("Form.DIDmetodo") and Trim(Form.DIDmetodo) EQ 5>selected</cfif>
							<cfelse>
									<cfif modoDet EQ 'CAMBIO' and rsDetalle.metodo EQ 5 >selected</cfif>
							</cfif>
						>FONACOT</option>

					</select>
				</td>
				<td align="right" nowrap class="fileLabel"><cf_translate key="LB_Valor">Valor:</cf_translate></td>
				<td>
					<input name="DIDvalor" id="DIDvalor" type="text" size="20" maxlength="18" style="text-align: right;" onblur="javascript:  if((document.form1.DIDmetodo.value == 0) && (this.value > 100)){ alert('El valor del porcentaje debe ser menor a 100'); return false}  fm(this,2);"  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modoDet EQ 'CAMBIO'>#rsDetalle.valor#<cfelse>0.00</cfif>">
				</td>
				<td align="right" nowrap class="fileLabel"><cf_translate key="LB_MontoPrestamo">Monto Pr&eacute;stamo:</cf_translate></td>
				<td>
					<input name="DIDmonto" id="DIDmonto" type="text" size="20" maxlength="18" style="text-align: right;" onblur="javascript: fm(this,2);"  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modoDet EQ 'CAMBIO'>#rsDetalle.monto#<cfelse>0.00</cfif>">
				</td>
			  </tr>
			  <tr>
				<td align="right" nowrap class="fileLabel"><cf_translate key="LB_FechaDeInicio">*Fecha de Inicio: </cf_translate></td>
				<td>
					<cfif modoDet NEQ "ALTA">
						<cfset fechaini = LSDateFormat(rsDetalle.fechaini,'dd/mm/yyyy') >
					<cfelseif isdefined("Form.btnBuscar") and isdefined("Form.DIDfechaini") and Len(Trim(Form.DIDfechaini)) NEQ 0>
						<cfset fechaini = LSDateFormat(Form.DIDfechaini,'dd/mm/yyyy') >
					<cfelse>
						<cfset fechaini = "" >
					</cfif>
					<cf_sifcalendario form="form1" name="DIDfechaini" value="#fechaini#">
				</td>
				<td align="right" nowrap class="fileLabel"><cf_translate key="LB_FechaFin">*Fecha Fin:</cf_translate></td>
				<td>
					<cfif modoDet NEQ "ALTA">
						<cfset fechafin = LSDateFormat(rsDetalle.fechafin,'dd/mm/yyyy') >
					<cfelseif isdefined("Form.btnBuscar") and isdefined("Form.DIDfechafin") and Len(Trim(Form.DIDfechafin)) NEQ 0>
						<cfset fechafin = LSDateFormat(Form.DIDfechafin,'dd/mm/yyyy') >
					<cfelse>
						<cfset fechafin = "" >
					</cfif>
					<cf_sifcalendario form="form1" name="DIDfechafin" value="#fechafin#">
				</td>
				<td align="right" nowrap class="fileLabel">
					<input type="checkbox" name="DIDcontrolsaldo" id="DIDcontrolsaldo" value="1" <cfif modoDet EQ 'CAMBIO' and rsDetalle.controlsaldo EQ 1>checked</cfif>>
				</td>
				<td>
					<cf_translate key="CHK_ControlaSaldo">Controla Saldo</cf_translate>
				</td>
				<td colspan="2" align="right" nowrap>
				<cfif modoDet EQ "ALTA">
					<input type="submit" name="btnAgregarD" id="btnAgregarD" value="#vAgregar#" onClick="javascript: habilitarValidacion(); ">
					<input type="submit" name="btnBuscar" id="btnBuscar" value="#vBuscar#" onClick="javascript: inhabilitarValidacion(); ">
				<cfelse>
					<input type="submit" name="btnCambiarD" id="btnCambiarD" value="#vCambiar#" onClick="javascript: habilitarValidacion(); ">
					<input type="submit" name="btnEliminarD" id="btnEliminarD" value="#vEliminar#" onClick="javascript: inhabilitarValidacion(); return (confirm('#vSeguroEliminar#'));">
					<input type="submit" name="btnNuevoD" id="btnNuevoD" value="#vNuevo#" onClick="javascript: inhabilitarValidacion(); ">
				</cfif>
				</td>
			  </tr>
			</table>
		  <cf_web_portlet_end>
		</td>
	  </tr>
	 </cfif>
	  <tr>
	  	<td colspan="<cfif modo EQ 'CAMBIO'>7<cfelse>4</cfif>" align="center" nowrap>&nbsp;

		</td>
	  </tr>
  </table>
</form>
<cfif modo EQ "CAMBIO">
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td>
		<cfinvoke
		 component="rh.Componentes.pListas"
		 method="pListaRH"
		 returnvariable="pListaRet">
			<cfinvokeargument name="tabla" value="DIDeducciones a, DatosEmpleado b, EIDeducciones c"/>
			<cfinvokeargument name="columnas" value=" a.DIDid,
													a.EIDlote,
													{fn concat({fn concat({fn concat({ fn concat( b.DEapellido1, ' ') }, b.DEapellido2)}, ' ')}, b.DEnombre) }  as nombrecompleto,
													a.DIDidentificacion as identificacion,
													case a.DIDmetodo 
														when 0 then 'Porcentaje' 
														when 1 then 'Valor' 
														when 2 then 'UMA'
														when 3 then 'UMI'
														when 4 then 'Cuota Fija'
														when 5 then 'FONACOT'
														else 'N/A'
													end as metodo,
													a.DIDvalor as valor,
													a.DIDreferencia as referencia,
													a.DIDfechaini as fechaini,
													a.DIDfechafin as fechafin"/>
			<cfinvokeargument name="desplegar" value="identificacion, nombrecompleto, metodo, referencia, valor, fechaini, fechafin"/>
			<cfinvokeargument name="etiquetas" value="#vIdentificacion#,#vNombreCompleto#, #vMetodo#,#vReferencia#, #vValor#, #vFInicioLista#, #vFFinLista#"/>
			<cfinvokeargument name="formatos" value="V,V,V,V,N,D,D"/>
			<cfinvokeargument name="filtro" value=" a.EIDlote = #Form.EIDlote#
													and a.EIDlote = c.EIDlote
													and c.Ecodigo = #Session.Ecodigo#
													and b.Ecodigo = c.Ecodigo
													#filtro#
													and a.DIDidentificacion = b.DEidentificacion
													order by identificacion, a.DIDfechaini, a.DIDfechafin"/>
			<cfinvokeargument name="align" value="left, left, left, left, left, left, left"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
			<cfinvokeargument name="keys" value="EIDlote, DIDid"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="formName" value="listaDeducciones"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="debug" value="N"/>
		</cfinvoke>
	</td>
  </tr>
</table>
</cfif>
</cfoutput>

<script language="javascript" type="text/javascript">

	function inhabilitarValidacion() {
	<cfif modo EQ "CAMBIO">
		objForm.DEidentificacion.required = false;
		objForm.DIDreferencia.required = false;
		objForm.DIDmetodo.required = false;
		objForm.DIDvalor.required = false;
		objForm.DIDmonto.required = false;
		objForm.DIDfechaini.required = false;
		objForm.DIDfechafin.required = false;
	<cfelse>
		objForm.SNnumero.required = false;
		objForm.TDcodigo.required = false;
	</cfif>
	}

	function habilitarValidacion() {
	<cfif modo EQ "CAMBIO">
		objForm.DEidentificacion.required = true;
		objForm.DIDreferencia.required = true;
		objForm.DIDmetodo.required = true;
		objForm.DIDvalor.required = true;
		objForm.DIDmonto.required = true;
		objForm.DIDfechaini.required = true;
		<!---objForm.DIDfechafin.required = true;--->
	<cfelse>
		objForm.SNnumero.required = true;
		objForm.TDcodigo.required = true;
	</cfif>
	}

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	<cfoutput>
	<cfif modo EQ "CAMBIO">
		objForm.DEidentificacion.required = true;
		objForm.DEidentificacion.description = "#vQEmpleado#";
		objForm.DIDreferencia.required = true;
		objForm.DIDreferencia.description = "#vReferencia#";
		objForm.DIDmetodo.required = true;
		objForm.DIDmetodo.description = "#vMetodo#";
		objForm.DIDvalor.required = true;
		objForm.DIDvalor.description = "#vValor#";
		objForm.DIDmonto.required = true;
		objForm.DIDmonto.description = "#vQMtoPrestamo#";
		objForm.DIDfechaini.required = true;
		objForm.DIDfechaini.description = "#vFInicioLista#";
		<!---objForm.DIDfechafin.required = true;
		objForm.DIDfechafin.description = "#vFFinLista#";--->
	<cfelse>
		objForm.SNnumero.required = true;
		objForm.SNnumero.description = "#vQSocioNegocio#";
		objForm.TDcodigo.required = true;
		objForm.TDcodigo.description = "#vQTipoDeduccion#";
	</cfif>
	</cfoutput>
</script>