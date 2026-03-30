<!--- Verificaiones de Registro de Pago de Nómina --->
<!--- Biblioteca de posibles errores --->
<!--- Código de los errores --->
<cfset erroresbiblio = "cuentaCliente|
						importesCero|
						noDetalles">
<!--- Descripción de los errores --->
<cfset descripciones = "La Cuenta Cliente de la empresa no existe.|
						Hay Salarios menores a cero.|
						No hay Detalles para esta Transacción.">
<!--- Manejo de la navegación --->
<cfset _mostrarLista = isDefined("Form._Filtrar") or isDefined ("Form.mostraLista")>
<cfif isDefined('Url.ERNid') and not isDefined('Form.ERNid')>
	<cfset Form.ERNid = Url.ERNid>
	<cfset _mostrarLista = true>
</cfif>
<cfif not isDefined('Form.ERNid')>
	<cflocation url="listaVNomina.cfm">
</cfif>
<cfset navegacion = "ERNid=" & Form.ERNid>
<cfset filtro = "">
<!--- Funciones de Javascript --->
<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/javascript">
 	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	// funciones del form
	function mostrarLista() {
		var div_Lista = document.getElementById("div_Lista");
		var div_Mostrar = document.getElementById("div_Mostrar");
		var div_Ocultar = document.getElementById("div_Ocultar");
		div_Lista.style.display = '';
		div_Mostrar.style.display = 'none';
		div_Ocultar.style.display = '';
	}
	function ocultarLista() {
		var div_Lista = document.getElementById("div_Lista");
		var div_Mostrar = document.getElementById("div_Mostrar");
		var div_Ocultar = document.getElementById("div_Ocultar");
		div_Lista.style.display = 'none';
		div_Mostrar.style.display = '';
		div_Ocultar.style.display = 'none';
	}
</script>
<!--- Consultas --->
<!--- Encabezado de Registro de Nómina --->
<cfquery name="rsERNomina" datasource="#Session.DSN#">
<!--- 	select ERN.ERNid,
		ERN.ERNcapturado,
		<cf_dbfunction name="to_char" args="ERNfcarga"> as ERNfcarga,
		Tdescripcion,
		<cf_dbfunction name="to_char" args="coalesce(CB.CBcc,ERN.CBcc)"> as CBcc,
		CBdescripcion, Mnombre, Msimbolo, Miso4217,
		<cf_dbfunction name="to_char" args="ERNfdeposito"> as ERNfdeposito,
		<cf_dbfunction name="to_char" args="ERNfinicio"> as ERNfinicio,
		<cf_dbfunction name="to_char" args="ERNffin"> as ERNffin,
		<cf_dbfunction name="to_char" args="ERNfechapago"> as ERNfechapago,
		ERNdescripcion,
		CP.CPcodigo,
		(select coalesce(sum (DRNliquido), 0)
		 FROM DRNomina c
		 WHERE c.ERNid = ERN.ERNid) as Importe
	from ERNomina ERN, TiposNomina T, Monedas M, CuentasBancos CB, CalendarioPagos CP
	where ERN.Ecodigo = T.Ecodigo
		and CB.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
		and ERN.Tcodigo = T.Tcodigo
		and ERN.Mcodigo = M.Mcodigo
		and ERN.CBcc *= CB.CBcc
		and ERN.Ecodigo *= CP.Ecodigo
		and ERN.RCNid *= CP.CPid
		and ERN.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and ERN.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERNid#">
		and ERNestado = 2 --->
		select ERN.ERNid,
			ERN.ERNcapturado,
			<cf_dbfunction name="to_char" args="ERNfcarga"> as ERNfcarga,
			Tdescripcion,
			<cf_dbfunction name="to_char" args="coalesce(CB.CBcc,ERN.CBcc)"> as CBcc,
			CBdescripcion, Mnombre, Msimbolo, Miso4217,
			<cf_dbfunction name="to_char" args="ERNfdeposito"> as ERNfdeposito,
			<cf_dbfunction name="to_char" args="ERNfinicio"> as ERNfinicio,
			<cf_dbfunction name="to_char" args="ERNffin"> as ERNffin,
			<cf_dbfunction name="to_char" args="ERNfechapago"> as ERNfechapago,
			ERNfinicio as ERNfinicioD,
			ERNffin as ERNffinD,
			ERNdescripcion,
			CP.CPcodigo,
			(select coalesce(sum (DRNliquido), 0)
			 FROM DRNomina c
			 WHERE c.ERNid = ERN.ERNid) as Importe
		from
			ERNomina ERN
		inner join TiposNomina T
			on ( ERN.Ecodigo = T.Ecodigo and
			   ERN.Tcodigo = T.Tcodigo and
			   ERN.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> and
			   ERN.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERNid#"> )
		inner join  Monedas M
		on (ERN.Mcodigo = M.Mcodigo ) left outer join CuentasBancos CB
		on (ERN.CBcc = CB.CBcc ) left outer join CalendarioPagos CP
		on (ERN.Ecodigo = CP.Ecodigo  and
			 ERN.RCNid = CP.CPid )
		where ERNestado = 2
        and coalesce(CB.CBesTCE,0) = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
</cfquery>

<cfquery name="rsMontoEmptransferencia" datasource="#session.dsn#">
	select coalesce(sum (coalesce(DRNliquido,0)), 0) ImporteT
	FROM DRNomina c
	inner join DatosEmpleado de
		on de.DEid = c.DEid
		and de.DEtipoPago = 0 <!--- Todos pago por transferencia --->
	WHERE c.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERNid#">
</cfquery>

<cfquery name="rsExentaLiquido" datasource="#session.dsn#">
	select
		sum(coalesce(ic.ICmontores,0)) ICmontores
	from ERNomina e
	inner join IncidenciasCalculo ic
		on e.RCNid = ic.RCNid
		and e.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERNid#">
	inner join DatosEmpleado de
		on de.DEid = ic.DEid
	inner join CIncidentes ci
	on ci.CIid = ic.CIid
	where ci.CIExcluyePagoLiquido = 1
	and de.DEtipoPago = 0 <!--- Todos pago por transferencia --->
</cfquery>
<cfset varMontoExentaLiquido =  Trim(rsExentaLiquido.ICmontores) eq '' ? 0 : rsExentaLiquido.ICmontores>

<cfset varFecIni = rsERNomina.ERNfinicioD>
<cfset varFecFin = rsERNomina.ERNffinD>

<!--- Integridad: Protege integridad de datos en caso de pantalla cargada con cache. --->
<cfif rsERNomina.RecordCount lte 0>
	<cflocation url="listaVNomina.cfm">
</cfif>
<!--- Cuenta Cliente --->
<cfquery name="rsCuentasCliente" datasource="#Session.DSN#">
	select
		Ltrim(Rtrim(CBcc)) as CBcc,
		CBdescripcion
	from
		CuentasBancos
	where
		Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    and CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
	<!--- and CBid not in
		(
			Select
				c.CBid
			from
				ECuentaBancaria d,
				Bancos e,
				CuentasBancos c
			where
				e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and c.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
			and d.Bid = e.Bid
			and d.CBid = c.CBid
			and d.ECaplicado =  <cfqueryparam cfsqltype="cf_sql_char" value="N">
			and d.EChistorico = <cfqueryparam cfsqltype="cf_sql_char" value="N">
			<!--- OPARRALES 2018-11-06 Filtros de Calendario de pago vs Estado de cuenta --->
			and <cfqueryparam cfsqltype="cf_sql_date" value="#varFecIni#"> between d.ECdesde and d.EChasta
			and <cfqueryparam cfsqltype="cf_sql_date" value="#varFecFin#"> between d.ECdesde and d.EChasta
		) --->
	order by CBcodigo, CBdescripcion
</cfquery>

<!--- ===================================================================================================================================
 														Inicio de Validaciones
 =================================================================================================================================== 	 --->
<!--- *** Estas validaciones se estan usando en formLVNomina.cfm, si cambian aqui actualizar tambien el archivo mencionado(formLVNomina) --->
<!--- ============================================================================================================================== 	 --->

<cfset errores = "">
<cfset aux = "">
<!--- Validación 1: Valida la Cuenta Cliente del Encabezado--->
<cfquery name="rsVerificacion" dbtype="query">
	select 1
	from rsCuentasCliente, rsERNomina
	where rsCuentasCliente.CBcc = rsERNomina.CBcc
</cfquery>
<cfif rsVerificacion.RecordCount eq 0>
	<cfset errores = errores & aux & "cuentaCliente">
	<cfset aux = "|">
</cfif>
<!--- Validación 2: Valida que no hayan salarios menores a 0 --->
<cfquery name="rsVerificacion" datasource="#Session.DSN#">
	select count(1) as cont
	from DRNomina
	where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERNid#">
		and DRNliquido < 0.00
</cfquery>
<cfif rsVerificacion.cont neq 0>
	<cfset errores = errores & aux & "importesCero">
	<cfset aux = "|">
</cfif>
<!--- Validación 3: Valida que hayan Detalles. --->
<cfquery name="rsVerificacion" datasource="#Session.DSN#">
	select 1
	from DRNomina
	where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERNid#">
</cfquery>
<cfif rsVerificacion.RecordCount eq 0>
	<cfset errores = errores & aux & "noDetalles">
	<cfset aux = "|">
</cfif>
<cfset bibarry = ListtoArray(erroresbiblio,"|")>
<cfset desarry = ListtoArray(descripciones,"|")>
<cfset errarry = ListtoArray(errores,"|")>
<!--- ===================================================================================================================================
 														Fin de Validaciones
 =================================================================================================================================== --->

<table width="75%" border="0" cellspacing="3" cellpadding="0" align="center" <!--- style="margin-left: 10px; margin-right: 10px;" --->>
  <tr>
		<td nowrap colspan="4">&nbsp;</td>
	</tr>
	<tr>
		<td nowrap colspan="4" align="center" bgcolor="#E2E2E2" class="subTitulo">ENCABEZADO DEL REGISTRO DE LA NOMINA</td>
	</tr>
<cfoutput>
	<tr>
		<td nowrap colspan="1" class="fileLabel"><cfif len(trim(rsERNomina.CPcodigo)) gt 0>Calendario Pagos:<cfelse>N&uacute;mero:</cfif> </td>
		<td nowrap>&nbsp;<cfif len(trim(rsERNomina.CPcodigo)) gt 0>#rsERNomina.CPcodigo#<cfelse>#rsERNomina.ERNid#</cfif></td>
		<td nowrap colspan="1" class="fileLabel">Descripci&oacute;n:</td>
		<td nowrap>&nbsp;#rsERNomina.ERNdescripcion#</td>
	</tr>
	<tr>
		<td nowrap class="fileLabel">Tipo N&oacute;mina:</td>
		<td nowrap>&nbsp;#rsERNomina.Tdescripcion#</td>
		<td nowrap class="fileLabel">Cuenta Cliente:</td>
		<td nowrap>&nbsp;(#rsERNomina.CBcc#) #rsERNomina.CBdescripcion#</td>
	</tr>
	<tr>
		<td nowrap class="fileLabel">Fecha Creaci&oacute;n:</td>
		<td nowrap>&nbsp;#rsERNomina.ERNfcarga#</td>
		<td nowrap class="fileLabel">Fecha Dep&oacute;sito:</td>
		<td nowrap>&nbsp;#rsERNomina.ERNfdeposito#</td>
	</tr>
	<tr>
		<td nowrap class="fileLabel">Fecha Inicio Pago:</td>
		<td nowrap>&nbsp;#rsERNomina.ERNfinicio#</td>
		<td nowrap class="fileLabel">Fecha Final Pago:</td>
		<td nowrap>&nbsp;#rsERNomina.ERNffin#</td>

	</tr>
	<tr>
		<td nowrap class="fileLabel">Importe Total:</td>
		<td nowrap>&nbsp;#rsERNomina.Msimbolo# #LsCurrencyFormat(rsERNomina.Importe,"none")# (#rsERNomina.Miso4217#)</td>
		<td nowrap class="fileLabel">Moneda:</td>
		<td nowrap>&nbsp;#rsERNomina.Mnombre#</td>
	</tr>
	<tr>
		<td nowrap class="fileLabel">Importe Efectivo:</td>
		<td nowrap>&nbsp;#rsERNomina.Msimbolo# #LsCurrencyFormat(rsMontoEmptransferencia.ImporteT-varMontoExentaLiquido,"none")# (#rsERNomina.Miso4217#)</td>
		<td nowrap class="fileLabel">Moneda:</td>
		<td nowrap>&nbsp;#rsERNomina.Mnombre#</td>
	</tr>
</cfoutput>
	<tr>
		<td nowrap colspan="4">&nbsp;</td>
	</tr>
	<tr>
		<td nowrap align="center" bgcolor="#E2E2E2" class="subTitulo" colspan="4">
			<div id="div_Mostrar" style="display:;">
				<a href="javascript: mostrarLista();">
					Mostrar Detalle&nbsp;&nbsp;&nbsp;
					<img src="/cfmx/rh/imagenes/abajo.gif" border="0" alt="Mostrar Lista del detalle del Registro de la Nómina">
					&nbsp;&nbsp;&nbsp;
					LISTA DEL DETALLE DEL REGISTRO DE LA NOMINA
					&nbsp;&nbsp;&nbsp;
					<img src="/cfmx/rh/imagenes/abajo.gif" border="0" alt="Mostrar Lista del detalle del Registro de la Nómina">
					&nbsp;&nbsp;&nbsp;Ver Detalle
				</a>
			</div>
			<div id="div_Ocultar" style="display:none;">
				<a href="javascript: ocultarLista();">
					Ocultar Detalle&nbsp;&nbsp;&nbsp;
					<img src="/cfmx/rh/imagenes/arriba.gif" border="0" alt="Ocultar Lista del detalle del Registro de la Nómina">
					&nbsp;&nbsp;&nbsp;
					LISTA DEL DETALLE DEL REGISTRO DE LA NOMINA
					&nbsp;&nbsp;&nbsp;
					<img src="/cfmx/rh/imagenes/arriba.gif" border="0" alt="Ocultar Lista del detalle del Registro de la Nómina">
					&nbsp;&nbsp;&nbsp;Ocultar Detalle
				</a>
			</div>
		</td>
	</tr>
	<tr>
		<td nowrap colspan="4">
			<div id="div_Lista" style="display:none;">
			<cfinclude template="filtroDNomina.cfm">
			<cfinclude template="listaDNomina.cfm">
			</div>
			<cfif _mostrarLista>
				<script language="JavaScript" type="text/javascript">
					mostrarLista();
				</script>
			</cfif>
		</td>
	</tr>
	<tr>
		<td nowrap colspan="4">&nbsp;</td>
	</tr>
	<tr>
		<td nowrap colspan="4" align="center">
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_VerificarRNomina"
			Default="Marcar como Verificada"
			returnvariable="LB_VerificarRNomina"/>

			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="ModificarRNomina"
			Default="Marcar para Modificar"
			returnvariable="ModificarRNomina"/>

			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="RHModificarRNomina"
			Default="Devolver a Sistema de N&oacute;mina"
			returnvariable="RHModificarRNomina"/>

			<form action="SQLVNomina.cfm" method="post" name="form">
			<cfoutput>
				<input name="ERNid" type="hidden" value="#Form.ERNid#">
				<cfif ArrayLen(errarry) eq 0>
					<input type="submit" name="Verificar" value="#LB_VerificarRNomina#" alt="Pasa la Relación de Pago al Proceso de Autorización." onClick="javascript: return confirm('¿Desea verificar la relación de pago?');">
				</cfif>
				<cfif rsERNomina.ERNcapturado eq 1>
					<input type="submit" name="Modificar" value="#ModificarRNomina#" alt="Pasa la Relación de Pago al Proceso de Modificación." onClick="javascript: return confirm('¿Desea devolver la relación de pago al proceso de modificación?');">
				<cfelseif (Session.RHParams.RHPARAM7 EQ Session.RHParams.RH_sin_Banco_Virtual) or (Session.RHParams.RHPARAM7 EQ Session.RHParams.RH_con_Banco_Virtual)>
					<input type="submit" name="RHModificar" value="#RHModificarRNomina#" alt="Pasa la Relación de Pago al Sistema de Nómina." onClick="javascript: return confirm('¿Desea devolver la relación de pago al sistema de nómina?');">
				</cfif>
			</cfoutput>
			</form>
		</td>
	</tr>
	<tr>
		<td nowrap colspan="4">&nbsp;</td>
	</tr>
	<tr>
		<td nowrap colspan="4">
			<table width="100%" border="0" align="center" cellpadding="2" cellspacing="2" class="ayuda">
				<cfif ArrayLen(errarry) neq 0>
				<tr valign="middle">
					<td width="7%" nowrap class="fileLabel"><img src="/cfmx/rh/imagenes/Alto.gif" width="48" height="48"></td>
				    <td width="93%" nowrap class="fileLabel"><div align="left">&nbsp;No se puede Verificar la Relación
			      de Pago porque se presentaron los siguientes errores: </div></td>
				</tr>
				<tr>
					<td nowrap>&nbsp;</td>
				    <td nowrap>
                      <ol>
                        <cfloop from="1" to="#ArrayLen(errarry)#" index="erridx">
                          <cfloop from="1" to="#ArrayLen(bibarry)#" index="bibidx">
                            <cfif ucase(trim(errarry[erridx])) eq ucase(trim(bibarry[bibidx]))>
                              <li> <cfoutput>#desarry[bibidx]#</cfoutput> </li>
                            </cfif>
                          </cfloop>
                        </cfloop>
                      </ol>
			      </td>
				</tr>
				<cfelse>
				<tr>
					<td nowrap><img src="/cfmx/rh/imagenes/Check01_T.gif" width="24" height="24"></td>
					<td nowrap class="fileLabel">&nbsp;La Relación de Pago está correcta. Puede proceder a Verificarla.</strong></td>
				</tr>
				</cfif>
			</table>
		</td>
	</tr>
	<tr>
		<td nowrap colspan="4">&nbsp;</td>
	</tr>
</table>