<!---
	Modificado por Gustavo Fonseca H.
	Fecha: 17-2-2006.
	Motivo: Se corrige la funcion de regresar por que si se daba el caso: nuevo movimiento, y click en
	regresar, daba error.
	Modificado por Gustavo Fonseca H.
	Fecha: 26-1-2006.
	Motivo: se valida que no se pueda registar documentos con fechas mayores a la fecha actual.
	ULTIMA ACTUALIZACION 13/10/2005
	13 de Octubre, Actualización de Cuenta Bancaria para que utilice mejor y aproveche nuevos features del TAG de Conlices.
	10 de Agosto de 2005, Actualización para utiliar nueva versión de fuentes.
	Actualizado por Dorian A.G.
	Utiliza Tags de Montos, Qforms, BOTONES y Nuevos Tags creados a la fecha.
	--->
<!--- ==================================================================================== --->
<!--- MANTENER LOS FILTROS DE LA LISTA --->
<!--- ==================================================================================== --->
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_EncabezadoMovimiento" default="Encabezado del Movimiento" returnvariable="LB_EncabezadoMovimiento" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Documento" default="Documento" returnvariable="LB_Documento" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Descripcion" default="Descripción" returnvariable="LB_Descripcion" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Fecha" default="Fecha" returnvariable="LB_Fecha" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TransaccionBanco" default="Transacción Bco" returnvariable="LB_TransaccionBanco" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_SeleccioneTransaccion" default="Seleccione una Transacci&oacute;n " returnvariable="LB_SeleccioneTransaccion" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Banco" default="Banco" returnvariable="LB_Banco" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_SeleccioneBanco" default="Seleccione un Banco" returnvariable="LB_SeleccioneBanco" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_CuentaBancaria" default="Cuenta Bancaria" returnvariable="LB_CuentaBancaria" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TarjetaCredito" default="Tarjeta de Cr&eacute;dito" returnvariable="LB_TarjetaCredito" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Moneda" default="Moneda" returnvariable="LB_Moneda" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TipoCambio" default="Tipo de Cambio" returnvariable="LB_TipoCambio" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Tipo" default="Tipo" returnvariable="LB_Tipo" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Bancos" default="Bancos" returnvariable="LB_Bancos" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Cliente" default="Cliente" returnvariable="LB_Cliente" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Proveedor" default="Proveedor" returnvariable="LB_Proveedor" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Referencia" default="Referencia" returnvariable="LB_Referencia" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Total" default="Total" returnvariable="LB_Total" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_SocioNegocio" default="Socio de Negocio" returnvariable="LB_SocioNegocio" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Direccion" default="Direcci&oacute;n" returnvariable="LB_Direccion" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ClientePOS" default="Cliente POS" returnvariable="LB_ClientePOS" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TransaccionDestino" default="Transacci&oacute;n Destino" returnvariable="LB_TransaccionDestino" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ListaSocioNegocio" default="Lista de Socios de Negocio" returnvariable="LB_ListaSocioNegocio" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Codigo" default="C&oacute;digo" returnvariable="LB_Codigo" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Identificacion" default="Identificaci&oacute;n" returnvariable="LB_Identificacion" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Nombre" default="Nombre" returnvariable="LB_Nombre" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TransaccionesCliente" default="Lista de tipos de transacciones cliente" returnvariable="LB_TransaccionesCliente" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ListasCuentasBancarias" default="Lista de Cuentas Bancarias" returnvariable="LB_ListasCuentasBancarias" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ListasTransaccionesProveedor" default="Lista de tipos de transacciones Proveedor" returnvariable="LB_ListasTransaccionesProveedor" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ListaDocumentos" default="Lista de Documentos" returnvariable="LB_ListaDocumentos" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Saldo" default="Saldo" returnvariable="LB_Saldo" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ListaTarjetasCredito" default="Lista de Tarjetas de Cr&eacute;dito" returnvariable="LB_ListaTarjetasCredito" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Apellido1" default="Apellido 1" returnvariable="LB_Apellido1" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Apellido2" default="Apellido 2" returnvariable="LB_Apellido2" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_NoHayTarjetas" default="No hay tarjetas" returnvariable="MSG_NoHayTarjetas" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_CentroFuncional" default="Centro Funcional" returnvariable="LB_CentroFuncional" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_CuentaContable" default="Cuenta Contable" returnvariable="LB_CuentaContable" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Monto" default="Monto" returnvariable="LB_Monto" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_DetalleMovimientos" default="Detalle del Movimiento" returnvariable="LB_DetalleMovimientos" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_NoHayDatosParaReportar" default="No se encontraron Registros" returnvariable="MSG_NoHayDatosParaReportar" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="OBJ_DescDetalle" default="Descripción del Detalle" returnvariable="OBJ_DescDetalle" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="OBJ_CFDetalle" default="Centro Funcional del Detalle" returnvariable="OBJ_CFDetalle" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="OBJ_CContableDetalle" default="Cuenta Contable del Detalle" returnvariable="OBJ_CContableDetalle" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="OBJ_MontoDetalle" default="Monto del Detalle" returnvariable="OBJ_MontoDetalle" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="OBJ_TipoTransaccion" default="Tipo de Transacción" returnvariable="OBJ_TipoTransaccion" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_QuitarDetalle" default="Para quitar los detalles del movimiento es necesario presionar el boton modificar el movimiento" returnvariable="MSG_QuitarDetalle" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_AgregaLinea" default="Para poder agregar líneas es necesario presionar el boton modificar el movimiento" returnvariable="MSG_AgregaLinea" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_MontoNoCero" default="El valor de Monto ser diferente de 0" returnvariable="MSG_MontoNoCero" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_MontoDetNoCero" default="El valor de Monto del Detalle debe ser diferente de 0" returnvariable="MSG_MontoDetNoCero" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_FechaMenor" default="La Fecha debe ser menor o igual a" returnvariable="MSG_FechaMenor" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_Refrescar" default="Aqui tiene que refrescar las direcciones" returnvariable="MSG_Refrescar" xmlfile="formMovimientos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Impuesto" default="Impuesto" returnvariable="LB_Impuesto" xmlfile="formMovimientos.xml"/>

<cfif isdefined('LvarTCE') and len(trim(#LvarTCE#)) gt 0>
	<!---  varTCE  indica si es un reporte para TCE--->
	<cfset _Pagina = 'TCEMovimientos.cfm'>
	<cfset _PaginaLista = 'TCEListaMovimientos.cfm'>
	<cfset _PaginaSQL = 'TCESQLMovimientos.cfm'>
<cfelse>
	<cfset _Pagina = 'Movimientos.cfm'>
	<cfset _PaginaLista = 'listaMovimientos.cfm'>
	<cfset _PaginaSQL = 'SQLMovimientos.cfm'>
</cfif>
<cfif isdefined("url.pagenum_lista")	and not isdefined("form.pagenum_lista")>
	<cfset form.pagenum_lista = url.pagenum_lista >
</cfif>
<cfif isdefined("url.EMusuario") and not isdefined("form.EMusuario")>
	<cfset form.EMusuario = url.EMusuario>
</cfif>
<cfif isdefined("url.filtro_EMdocumento")	and not isdefined("form.filtro_EMdocumento")>
	<cfset form.filtro_EMdocumento = url.filtro_EMdocumento >
</cfif>
<cfif isdefined("url.filtro_CBid")	and not isdefined("form.filtro_CBid")>
	<cfset form.filtro_CBid = url.filtro_CBid >
</cfif>
<cfif isdefined("url.filtro_BTid")	and not isdefined("form.filtro_BTid")>
	<cfset form.filtro_BTid = url.filtro_BTid >
</cfif>
<cfif isdefined("url.filtro_EMdescripcion")	and not isdefined("form.filtro_EMdescripcion")>
	<cfset form.filtro_EMdescripcion = url.filtro_EMdescripcion >
</cfif>
<cfif isdefined("url.filtro_EMfecha")	and not isdefined("form.filtro_EMfecha")>
	<cfset form.filtro_EMfecha = url.filtro_EMfecha >
</cfif>
<cfif isdefined("url.filtro_usuario")	and not isdefined("form.filtro_usuario")>
	<cfset form.filtro_usuario = url.filtro_usuario >
</cfif>
<cfif isdefined("url.filtro_DMdescripcion") and not isdefined("form.filtro_DMdescripcion") >
	<cfset form.filtro_DMdescripcion = url.filtro_DMdescripcion >
</cfif>
<cfif isdefined("url.filtro_Cdescripcion") and not isdefined("form.filtro_Cdescripcion") >
	<cfset form.filtro_Cdescripcion = url.filtro_Cdescripcion >
</cfif>
<!--- ==================================================================================== --->
<!--- ==================================================================================== --->
<!--- 	DEFINICION DEL MODO --->
<cfset modo="ALTA">
<cfif isdefined("Form.EMid") and len(trim(form.EMid))>
	<cfset modo="CAMBIO">
</cfif>
<!--- 	CONSULTAS --->
<!--- =============================================================== --->
<!--- Recupera los datos del ultimo movimiento, para sugerirlos 	  --->
<!--- =============================================================== --->
<cfquery name="sugerir" datasource="#session.DSN#">
			select a.EMdescripcion,
					a.EMfecha,
					a.BTid,
					a.Ocodigo,
					b.Bid,
					b.Mcodigo,
					a.EMtipocambio,
					a.EMreferencia,
					b.Mcodigo,
					b.CBid,
					b.CBcodigo,
					b.CBdescripcion,
					m.Mnombre,
					b.CVirtual
			from EMovimientos a

			inner join CuentasBancos b
			on b.CBid=a.CBid
			and b.Ecodigo=a.Ecodigo

			inner join Monedas m
			on b.Mcodigo=m.Mcodigo
			and b.Ecodigo=m.Ecodigo

			where a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
            and b.CBesTCE  = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
			and EMid = ( select max(b.EMid) from EMovimientos b where b.Ecodigo=a.Ecodigo and b.Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" > <cfif isdefined("form.EMusuario2") and len(trim(#form.EMusuario2#))> and b.EMusuario = <cfqueryparam value="#form.EMusuario2#" cfsqltype="cf_sql_varchar" ></cfif>)
			<!--- si es el boton nuevo de la lista, no sugiere  --->
			<cfif isdefined("form.btnNuevo") and isdefined("form.modo")>
				and 1 = 2
			</cfif>
		</cfquery>
<!--- =============================================================== --->
<!--- =============================================================== --->
<!--- 	CONSULTA DE ENCABEZADO --->
<cfset Aplicar = "">
<cfif modo neq "ALTA">
	<cfset varCBesTCE=0>
	<cfif isdefined('LvarTCE')>
		<!---  varTCE  indica si el query es para TCE o bancos--->
		<cfset varCBesTCE=1>
	</cfif>
	<cfquery datasource="#Session.DSN#" name="rsForm">
		select
			a.EMid,
			a.ts_rversion,
			a.EMdocumento,
			a.EMusuario,
			a.EMdescripcion,
			a.EMfecha,
			a.BTid,
			b.Bid,
			b.Ocodigo,
			b.CBid,
			b.CBcodigo,
			b.CBdescripcion,
			c.Mcodigo,
			c.Mnombre,
			a.EMtipocambio,
			a.EMreferencia,
			a.EMtotal,
			a.SNid,
			a.SNcodigo,
			a.id_direccion,
			coalesce(a.TpoSocio,0) as TpoSocio,
			a.TpoTransaccion,
			a.Documento,
			d.BTtipo,
			a.CDCcodigo,
			a.EMdescripcionOD,
			a.EMBancoIdOD,
			a.EMNombreBenefic,
			a.EMRfcBenefic,
			a.Tipo,
			b.CVirtual,
			a.CodTipoPago
		from EMovimientos a
			inner join CuentasBancos b
				on b.Ecodigo	=	a.Ecodigo
				and b.CBid		=	a.CBid
			inner join  Monedas c
				on c.Ecodigo 	= 	b.Ecodigo
				and c.Mcodigo 	=	b.Mcodigo
			inner join  BTransacciones d
				on a.Ecodigo 	= 	d.Ecodigo
				and a.BTid   	=	d.BTid
		where a.EMid 			= 	<cfqueryparam value="#Form.EMid#" cfsqltype="cf_sql_numeric">
        and b.CBesTCE           =   <cfqueryparam value="#varCBesTCE#" cfsqltype="cf_sql_bit">
		and a.Ecodigo			=	<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
	</cfquery>
	<!--- 	CONSULTA SI EL MOVIMIENTO TIENE LINEAS PARA PERMITIR APLICAR --->
	<cfquery datasource="#Session.DSN#" name="rsFormLineas">
		select 1 as lineas
		from DMovimientos
		  where EMid = <cfqueryparam value="#Form.EMid#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfif rsFormLineas.recordcount GT 0>
		<cfset Aplicar = ", Aplicar">
	</cfif>
</cfif>
<!--- 	TRANSACCIONES BANCARIAS --->
<cfset varCBesTCE=0>
<!---  varTCE  indica si es para para TCE o bancos--->
<cfif isdefined('LvarTCE')>
	<cfset varCBesTCE=1>
</cfif>
<cfquery datasource="#Session.DSN#" name="rsBTransacciones">
	select BTid, BTtipo,
			case
				when BTtipo = 'C' then '-CR: ' else '+DB: '
			end
			<cf_dbfunction name="OP_concat">
			BTdescripcion
			as BTdescripcion
	from BTransacciones
	where Ecodigo	=	<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
	and BTtce=<cfqueryparam value="#varCBesTCE#" cfsqltype="cf_sql_bit" >
	order by 2 desc
</cfquery>
<!--- 	BANCOS --->

<cfquery datasource="#Session.DSN#" name="rsBancos">
	select Bid, Bdescripcion
	from Bancos
	where Ecodigo	=	<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
	order by 2
</cfquery>
<!---IMPUESTOS--->
<cfquery name="rsImpuestos" datasource="#session.dsn#">
	select Icodigo, Idescripcion, c.CFcuenta, rtrim(c.CFformato) as CFformato
	from Impuestos i
		inner join CFinanciera c
			on c.Ecodigo = i.Ecodigo
	where i.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and i.Icompuesto		= 0
	  and i.Icreditofiscal	= 1
	  <!--- Solo Impuestos Simples porque SP manual no maneja detalle de impuestos al generar contabilidad --->
	  and Icompuesto = 0
	  and c.CFcuenta = (select min(CFcuenta) from CFinanciera cf where cf.Ccuenta = coalesce(i.CcuentaCxPAcred,i.Ccuenta))
</cfquery>
<!--- 	CONSULTA DEL DETALLE --->
<cfif modo neq "ALTA" and rsForm.TpoSocio eq 0>
	<cfset dmodo="ALTA">
	<cfif isdefined("Form.DMlinea") and len(trim(form.DMlinea))>
		<cfset dmodo="CAMBIO">
	</cfif>
	<cfif dmodo neq "ALTA">
		<cfquery datasource="#Session.DSN#" name="rsDForm">
			select a.EMid, a.DMlinea, a.ts_rversion,
				a.DMdescripcion, a.Ccuenta,a.CFcuenta, a.DMmonto,
				b.Cformato, b.Cdescripcion,
				c.CFid, c.CFcodigo, c.CFdescripcion
				,cpt.TESRPTCid, cpt.SNid, cpt.TESBid, cpt.CDCcodigo, a.Icodigo
			from DMovimientos a
				inner join CContables b
					on b.Ccuenta = a.Ccuenta
				left outer join CFuncional c
					on c.CFid = a.CFid
				left join TESRPTcontables cpt
					 on cpt.EMid	= a.EMid
					and cpt.Dlinea	= a.DMlinea
			where a.EMid    			= <cfqueryparam value="#Form.EMid#" cfsqltype="cf_sql_numeric">
				and a.DMlinea 			= <cfqueryparam value="#Form.DMlinea#" cfsqltype="cf_sql_numeric">
				and a.Ecodigo			= <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
		</cfquery>
	</cfif>
</cfif>
<!--- 	CONTABILIZACION MANUAL O AUTOMÁTICA
	CONTABILIZAR AUTOMATICAMENTE (Pvalor = N) IMPLICA REQUERIR EL CF Y NO LA CUENTA Y VICEVERSA
	--->
<cfquery name="rsIndicador" datasource="#session.DSN#">
	select Pvalor from Parametros
	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >
		and Pcodigo = 2
</cfquery>
<cfset ContabilizaAutomatico = false>
<cfif rsIndicador.recordcount gt 0 and rsIndicador.Pvalor eq "N">
	<cfset ContabilizaAutomatico = true>
</cfif>

<!--- 	OBTENER METODO DE PAGO    --->

<cfquery name="rsTipoPagoFA" datasource="#session.dsn#">
		select  nombre_TipoPago as Concepto,TipoPagoSAT as Clave from FATipoPago
	where Ecodigo is null or Ecodigo = #Session.Ecodigo# and TipoPagoSAT <> '99'
	ORDER BY TipoPagoSAT ASC
</cfquery>

<script language="JavaScript" src="../../js/fechas.js"></script>
<script language="javascript" type="text/javascript">
<!--
//Browser Support Code
function ajaxFunction_Direccion(){
	var ajaxRequest;  // The variable that makes Ajax possible!
	var vSNid ='';
	vSNid = document.form1.SNid.value;
	try{
		// Opera 8.0+, Firefox, Safari
		ajaxRequest = new XMLHttpRequest();
	} catch (e){
		// Internet Explorer Browsers
		try{
			ajaxRequest = new ActiveXObject("Msxml2.XMLHTTP");
		} catch (e) {
			try{
				ajaxRequest = new ActiveXObject("Microsoft.XMLHTTP");
			} catch (e){
				// Something went wrong
				alert("Your browser broke!");
				return false;
			}
		}
	}

	ajaxRequest.open("GET", '/cfmx/sif/Utiles/SNDireccion_Combo.cfm?SNid='+vSNid, false);
	ajaxRequest.send(null);
	document.getElementById("contenedor_direccion").innerHTML = ajaxRequest.responseText;
}
//-->
</script>
<!--- alert(document.getElementById('id_direccion').options[0].text); --->
<cfoutput>

	<script language="JavaScript" src="../../js/utilesMonto.js"></script>
<!---	<script language="JavaScript">
		var LvarImpuestosCFcuenta	= new Array(0,#ValueList(rsImpuestos.CFcuenta)#);
		var LvarImpuestosCFformato	= new Array('',#QuotedValueList(rsImpuestos.CFformato)#);
	</script>--->

	<form action="#_PaginaSQL#" method="post" name="form1" style="border:0px;" onsubmit="return funcValidaForm();">
		<input name="LvarHoy" value="#LsDateFormat(now(),'DD/MM/YYYY')#" type="hidden">
		<cfif modo neq "ALTA">
			<input type="hidden" name="EMid" id="EMid" value="#rsForm.EMid#">
			<input type="hidden" name="EMusuario" value="#rsForm.EMusuario#">
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="ts" artimestamp="#rsForm.ts_rversion#"/>
			<input type="hidden" name="timestamp" value="#ts#">
		</cfif>
		<cfif isdefined("form.pagina")>
			<input type="hidden" name="pagina" value="#form.pagina#">
		</cfif>
		<table width="98%" align="center"  border="0" cellspacing="0" cellpadding="1" style="border:0px;">
			<tr>
				<td class="subTitulo" align="center" bgcolor="##f5f5f5">
					#LB_EncabezadoMovimiento#
				</td>
			</tr>
		</table>
		<!--- TABLA PARA ALTA --->

		<table width="98%"  border="0" cellspacing="1" cellpadding="1" align="center" style="border:0px;">
			<tr>
				<td nowrap>
					<strong>
						#LB_Documento#:
					</strong>
				</td>
				<td>
					<input type="text" name="EMdocumento" tabindex="1" maxlength="20" onchange="ValVac(this);"
					<cfif modo neq "ALTA">
						value="#rsForm.EMdocumento#"
					</cfif>
					>
				</td>
				<td nowrap>
					<strong>
						#LB_Descripcion#:
					</strong>
				</td>
				<td colspan="3">
					<input type="text" tabindex="2" name="EMdescripcion" maxlength="120" size="40" onchange="ValVac(this);"
					<cfif modo neq "ALTA">
						value="#rsForm.EMdescripcion#"
					<cfelseif modo eq 'ALTA' and isdefined("sugerir")>
						value="#sugerir.EMdescripcion#"
					</cfif>
					>
				<cfif isDefined("rsForm.CVirtual") and rsForm.CVirtual eq 1 >
					<input type="hidden" name="Virtual" value="#rsForm.CVirtual#">
				</cfif>
				</td>
			</tr>
			<tr>
				<td nowrap>
					<strong>
						#LB_Fecha#:
					</strong>
				</td>
				<td>
					<cfif modo neq "ALTA">
						<cfset fecha =  LSDateFormat(rsForm.EMfecha,'dd/mm/yyyy')>
					<cfelseif modo eq 'ALTA' and isdefined("sugerir") and len(trim(sugerir.EMfecha)) >
						<cfset fecha = LSDateFormat(sugerir.EMfecha,'dd/mm/yyyy')>
					<cfelse>
						<cfset fecha = LSDateFormat(Now(),'dd/mm/yyyy')>
					</cfif>
					<cf_sifcalendario name="EMfecha" value="#fecha#" tabindex="3">
				</td>
				<td nowrap>
					<strong>
						#LB_TransaccionBanco#:
					</strong>
				</td>
				<td colspan="3">
					<cfset LvarBTtipoSugerir = "">
					<select name="BTid" id="BTid" tabindex="4" onchange="if(selectedIndex != 0) asignatipo(options[selectedIndex].title);">
						<option value="">
							-- #LB_SeleccioneTransaccion# --
						</option>
						<cfloop query="rsBTransacciones">
							<option title="#rsBTransacciones.BTtipo#" value="#rsBTransacciones.BTid#"
							<cfif modo neq "ALTA" and rsForm.BTid eq rsBTransacciones.BTid>
								selected
							<cfelseif modo eq 'ALTA' and isdefined("sugerir") and sugerir.BTid eq rsBTransacciones.BTid >
								selected
								<cfset LvarBTtipoSugerir = rsBTransacciones.BTtipo>
							</cfif>
							>#rsBTransacciones.BTdescripcion#</option>
						</cfloop>
					</select>
					<input type="hidden" name="BTtipo" value="<cfif modo neq 'ALTA'>
					#rsForm.BTtipo#
				<cfelseif isdefined('sugerir') and trim(LvarBTtipoSugerir) NEQ ''>
					#LvarBTtipoSugerir#<cfelse>-1</cfif>">
				</td>
			</tr>
			<tr>
				<cfif not isdefined('LvarTCE')>
					<!---  varTCE  indica si es para para TCE o bancos--->
					<td nowrap>
						<strong>
							#LB_Banco#:
						</strong>
					</td>
					<td>
						<select name="Bid" tabindex="5" onchange="javascript:limpiarCuenta();">
							<option value="">
								-- #LB_SeleccioneBanco# --
							</option>
							<cfloop query="rsBancos">
								<option value="#rsBancos.Bid#"
								<cfif modo neq "ALTA" and rsForm.Bid eq rsBancos.Bid>
									selected
								<cfelseif modo eq 'ALTA' and isdefined("sugerir") and sugerir.Bid eq rsBancos.Bid >
									selected
								</cfif>
								>#rsBancos.Bdescripcion#</option>
							</cfloop>
						</select>
					</td>
					<td align="left" nowrap><b><cf_translate key="LB_tipoPagoFA">Tipo de Pago</cf_translate></b>:&nbsp;</td>
					<td>
						<select name="tipoPagoFA" id="tipoPagoFA" tabindex="1">
							<option value="">---<cf_translate key="CMB_SeleccioneUno" XmlFile="/sif/generales.xml">Seleccione Uno</cf_translate>---</option>
							<cfloop query="rsTipoPagoFA">
							<option value="#rsTipoPagoFA.Clave#"
									<cfif modo neq "ALTA" and rsForm.CodTipoPago eq trim(rsTipoPagoFA.Clave)>selected</cfif>
										>#rsTipoPagoFA.Clave# #rsTipoPagoFA.Concepto#</option>
							</cfloop>
						</select>
					</td>
			</tr>
			<tr> <td nowrap><strong>#LB_CuentaBancaria#: </strong></td> <td> <cfset varCBesTCE=0> <cfif isdefined('LvarTCE')> <cfset varCBesTCE=1> </cfif> <cfset valuesArray = ArrayNew(1)> <cfif modo neq "ALTA"> <cfset ArrayAppend(valuesArray, rsForm.CBid)> <cfset ArrayAppend(valuesArray, rsForm.CBcodigo)> <cfset ArrayAppend(valuesArray, rsForm.CBdescripcion)> <cfset ArrayAppend(valuesArray, rsForm.Mcodigo)> <cfelseif modo eq 'ALTA' and isdefined("sugerir")> <cfset ArrayAppend(valuesArray, sugerir.CBid)> <cfset ArrayAppend(valuesArray, sugerir.CBcodigo)> <cfset ArrayAppend(valuesArray, sugerir.CBdescripcion)> <cfset ArrayAppend(valuesArray, sugerir.Mcodigo)> </cfif> <cf_conlis title="#LB_ListasCuentasBancarias#"
				campos = "CBid, CBcodigo, CBdescripcion, Mcodigo"
				desplegables = "N,S,S,N"
				modificables = "N,S,N,N"
				size = "0,0,40,0"
				valuesArray="#valuesArray#"
				tabla="CuentasBancos cb
				inner join Monedas m
				on cb.Mcodigo = m.Mcodigo
				inner join Empresas e
				on e.Ecodigo = cb.Ecodigo
				left outer join Htipocambio tc
				on 	tc.Ecodigo = cb.Ecodigo
				and tc.Mcodigo = cb.Mcodigo
				and tc.Hfecha  <= $EMfecha,date$
				and tc.Hfechah >  $EMfecha,date$ "
				columnas="cb.CBid, cb.CBcodigo, cb.CBdescripcion, cb.Mcodigo,
				m.Mnombre,
				round(
				coalesce(
				(	case
				when cb.Mcodigo = e.Mcodigo then 1.00
				else tc.TCcompra
				end
				)
				, 1.0000)
				,4) as EMtipocambio"
				filtro="cb.Ecodigo = #Session.Ecodigo# and cb.CBesTCE = #varCBesTCE# and cb.Bid = $Bid,numeric$ order by Mnombre, Hfecha"
				desplegar="CBcodigo, CBdescripcion"
				etiquetas="#LB_Codigo#,#LB_Descripcion#"
				formatos="S,S"
				align="left,left"
				asignar="CBid, CBcodigo, CBdescripcion, Mcodigo, Mnombre, EMtipocambio"
				asignarformatos="S,S,S,S,S,F"
				showEmptyListMsg="true"
				EmptyListMsg = "#MSG_NoHayDatosParaReportar#"
				debug="false"
				tabindex="6"> </td> <cfelse> <td> <strong>#LB_TarjetaCredito#:</strong> </td> <td> <cfset valuesArrayTCE = ArrayNew(1)> <cfif modo NEQ 'ALTA'> <cfquery datasource="#Session.DSN#" name="rsTCE">
				select cb.CBcodigo as codigoTar ,cb.CBcodigo, cb.CBdescripcion, tj.CBTCDescripcion,  de.DEnombre,de.DEapellido1,de.DEapellido2, mo.Miso4217,cb.CBTCid
				from CuentasBancos cb
                                   inner join Monedas mo
                                        on cb.Mcodigo=mo.Mcodigo
                                   inner join CBTarjetaCredito tj
                                        on cb.CBTCid = tj.CBTCid
                                   inner join DatosEmpleado de
                                        on tj.DEid=de.DEid
			                       inner join EMovimientos em
										on  em.Ecodigo=cb.Ecodigo
				where em.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and cb.CBesTCE = 1
					and em.EMid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EMid#">
					and cb.CBid =(select  CBid
								from EMovimientos
								where EMid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EMid#">)
			</cfquery> <cfset ArrayAppend(valuesArrayTCE, rsTCE.codigoTar)> <cfset ArrayAppend(valuesArrayTCE, rsTCE.CBTCDescripcion)> <cfset ArrayAppend(valuesArrayTCE, rsTCE.Miso4217)> </cfif> <div id="CMPTarjCred"> <cf_conlis
				campos = "codigoTar,CBTCDescripcion,Miso4217"
				valuesArray="#valuesArrayTCE#"
				desplegables = "S,S,S"
				modificables = "N,N,N"
				size = "25,15,10"
				title="#LB_ListaTarjetasCredito#"
				tabla="CuentasBancos cb
				inner join Monedas mo
				on cb.Mcodigo=mo.Mcodigo
				inner join CBTarjetaCredito tj
				on cb.CBTCid = tj.CBTCid
				inner join CBStatusTarjetaCredito stj
				on tj.CBSTid = stj.CBSTid
				inner join DatosEmpleado de
				on tj.DEid=de.DEid
				inner join Empresas e
				on e.Ecodigo = cb.Ecodigo
				left outer join Htipocambio tc
				on 	tc.Ecodigo = cb.Ecodigo
				and tc.Mcodigo = cb.Mcodigo
				and tc.Hfecha  <= $EMfecha,date$
				and tc.Hfechah >  $EMfecha,date$ "
				columnas="cb.CBcodigo as codigoTar,
				cb.CBcodigo,
				cb.CBdescripcion,tj.CBTCDescripcion,
				de.DEnombre,de.DEapellido1,de.DEapellido2,
				mo.Miso4217,mo.Mnombre,cb.CBTCid,
				round(coalesce((case when cb.Mcodigo = e.Mcodigo then 1.00 else tc.TCcompra end), 1.0000),4) as EMtipocambio"
				filtro="cb.Ecodigo=#session.Ecodigo# and cb.CBesTCE = 1 and stj.CBSTActiva = 1"
				desplegar="CBcodigo,CBdescripcion, DEnombre,DEapellido1,DEapellido2,Miso4217"
				etiquetas="#LB_Codigo#,#LB_Descripcion#,#LB_Nombre#, #LB_Apellido1#, #LB_Apellido2#,#LB_Moneda#"
				formatos="S,S,S,S,S,S"
				align="left,left,left,left,left,left"
				asignar="codigoTar,CBdescripcion,CBTCDescripcion,DEnombre,DEapellido1,DEapellido2,Miso4217,Mnombre,EMtipocambio"
				showEmptyListMsg="true"
				EmptyListMsg="-- #MSG_NoHayTarjetas# --"
				tabindex="7"
				top="100"
				left="200"
				width="950"
				height="600"
				asignarformatos="S,S,S,S,S,S,S"
				form="form1"  > </div> </td> </cfif> <td nowrap><strong>#LB_Moneda#:</strong></td> <td colspan="3"> <input type="text" name="Mnombre" <cfif modo neq "ALTA">value="#rsForm.Mnombre#"<cfelseif modo eq 'ALTA' and isdefined("sugerir")>value="#sugerir.Mnombre#"</cfif> readonly tabindex="-1"> </td> </tr>
			<tr>
				<td >
					<strong>
						#LB_TipoCambio#:
					</strong>
				</td>
				<td>
					<cfif isdefined('LvarTCE') AND LEN(TRIM(#LvarTCE#)) GT 0>
						<!--- CON TARJETAS DE CREDITO--->
						<cfif modo NEQ 'ALTA'>
							<cfquery name="rsTipoCambioTCE" datasource="#session.dsn#">
					 select round(coalesce((case when cb.Mcodigo = e.Mcodigo then 1.00 else tc.TCcompra end), 1.0000),4) as EMtipocambio
					from CuentasBancos cb
							inner join Monedas mo
								on cb.Mcodigo=mo.Mcodigo
						  inner join CBTarjetaCredito tj
								on cb.CBTCid = tj.CBTCid
						 inner join DatosEmpleado de

								on tj.DEid=de.DEid
						 inner join Empresas e
								on e.Ecodigo = cb.Ecodigo
						left outer join Htipocambio tc
								on 	tc.Ecodigo = cb.Ecodigo
						and tc.Mcodigo = cb.Mcodigo
						and tc.Hfecha  <= <cfqueryparam value="#rsForm.EMfecha#" cfsqltype="cf_sql_date">
						and tc.Hfechah >  <cfqueryparam value="#rsForm.EMfecha#" cfsqltype="cf_sql_date">
					 where cb.Ecodigo=#session.Ecodigo#
							and cb.CBesTCE = 1
							and cb.CBid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CBid#">
				</cfquery>
							<cf_monto name="EMtipocambio" value="#rsTipoCambioTCE.EMtipocambio#" modificable="false" tabindex="-1" decimales="4" >
						<cfelse>
							<cf_monto name="EMtipocambio" modificable="false" tabindex="-1" decimales="4">
						</cfif>
					<cfelse>
						<!--- CON CUENTAS BANCARIAS--->
						<cfif modo neq "ALTA">
							<cf_monto name="EMtipocambio" value="#rsForm.EMtipocambio#" modificable="false" tabindex="-1" decimales="4" >
						<cfelseif modo eq 'ALTA' and isdefined("sugerir") and len(trim(sugerir.EMtipocambio)) >
							<cf_monto name="EMtipocambio" value="#sugerir.EMtipocambio#" modificable="false" tabindex="-1" decimales="4" >
						<cfelse>
							<cf_monto name="EMtipocambio" modificable="false" tabindex="-1" decimales="4">
						</cfif>
					</cfif>
				</td>
				<td nowrap>
					<strong>
						#LB_Tipo#:
					</strong>
				</td>
				<td colspan="3">
					<cfif modo eq "ALTA">
						<select name="TpoSocio" tabindex="1" onchange="javascript: verTR(); LimpiarCampos();">
							<option value="0">
								#LB_Bancos#
							</option>
							<option value="1">
								#LB_Cliente#
							</option>
							<option value="2">
								#LB_Proveedor#
							</option>
							<!--- <option value="3">Mov. Documentos Cliente</option>
								<option value="4">Mov. Documentos Proveedor</option> --->
						</select>
					<cfelse>
						<cfif len(trim(Aplicar))>
							<cfswitch expression="#rsForm.TpoSocio#">
								<cfcase value="0">
									#LB_Bancos#
								</cfcase>
								<cfcase value="1">
									#LB_Cliente#
								</cfcase>
								<cfcase value="2">
									#LB_Proveedor#
								</cfcase>
								<cfcase value="3">
									Mov. Documentos Proveedor
								</cfcase>
								<cfcase value="4">
									Mov. Documentos Proveedor
								</cfcase>
							</cfswitch>
							<input type="hidden" name="TpoSocio" value="#rsForm.TpoSocio#"/>
						<cfelse>
							<select name="TpoSocio" tabindex="1" onchange="javascript: verTR(); LimpiarCampos();">

								<cfif rsForm.TpoSocio eq 0>
									<option value="0" selected>#LB_Bancos#</option>
								</cfif>

								<cfif rsForm.TpoSocio eq 1>
									<option value="1" selected>#LB_Cliente#</option>
								</cfif>

								<cfif rsForm.TpoSocio eq 2>
									<option value="2" selected>#LB_Proveedor#</option>
								</cfif>

								<!--- <option value="3" <cfif rsForm.TpoSocio eq 3>selected</cfif>>Mov. Documentos Cliente</option>
									<option value="4" <cfif rsForm.TpoSocio eq 4>selected</cfif>>Mov. Documentos Proveedor</option> --->
							</select>
						</cfif>
					</cfif>
				</td>
			</tr>
			<tr>
				<td nowrap>
					<strong>
						#LB_Referencia#:
					</strong>
				</td>
				<td>
					<input type="text" tabindex="1" name="EMreferencia" maxlength="25"
					<cfif modo neq "ALTA">
						value="#rsForm.EMreferencia#"
					<cfelseif modo eq 'ALTA' and isdefined("sugerir")>
						value="#sugerir.EMreferencia#"
					</cfif>
					>
				</td>
				<td nowrap>
					<strong>
						#LB_Total#:
					</strong>
				</td>
				<td colspan="3">
					<cfif modo neq "ALTA">
						<cf_monto name="EMtotal" value="#rsForm.EMtotal#" modificable="false">
					<cfelse>
						<cf_monto name="EMtotal" modificable="false">
					</cfif>
				</td>
			</tr>
			<tr id="trBancos">
				<td colspan="4">
					<br>
					<fieldset>
						<legend>
							<strong>
								<div id="divInfoAdicional">
									Informaci&oacute;n Bancaria Origen
								</div>
							</strong>
						</legend>
						<table width="100%" border="0" cellspacing="1" cellpadding="1" align="center">
							<tr>
								<td>
									<strong>
										#LB_Banco#:
									</strong>
								</td>
								<td>
									<select name="bcoIdInfo" tabindex="5">
										<option value="-1">
											-- Ninguno --
										</option>
										<cfloop query="rsBancos">
											<option value="#rsBancos.Bid#"
											<cfif modo neq "ALTA" and rsForm.EMBancoIdOD eq rsBancos.Bid>
												selected
											</cfif>
											>#rsBancos.Bdescripcion#</option>
										</cfloop>
									</select>
								</td>
							</tr>
							<tr>
								<td>
									<strong>
										#LB_CuentaBancaria#:
									</strong>
								</td>
								<td>
									<input type="text" name="ctaBancariaInfo" id="ctaBancariaInfo" maxlength="120" tabindex="1" size="40"
									<cfif modo neq "ALTA">
										value="#rsForm.EMdescripcionOD#"
									</cfif>
									>
								</td>
							</tr>
							<tr id="trNameBen"
							<cfif isdefined("rsForm.Tipo") and #rsForm.Tipo# EQ 'C'>
								<!--- style="display:inline" --->
							<cfelse>
								style="display:none"
							</cfif>
							>
								<td>
									<strong>
										Nombre Beneficiario:
									</strong>
								</td>
								<td>
									<input type="text" name="nameBenefic" id="nameBenefic" maxlength="120" tabindex="1" size="40"
									<cfif modo neq "ALTA">
										value="#rsForm.EMNombreBenefic#"
									</cfif>
									>
								</td>
							</tr>
							<tr id="trRFCBen"
							<cfif isdefined("rsForm.Tipo") and #rsForm.Tipo# EQ 'C'>
								<!--- style="display:inline" --->
							<cfelse>
								style="display:none"
							</cfif>
							>
								<td>
									<strong>
										RFC Beneficiario:
									</strong>
								</td>
								<td>
									<input type="text" name="rfcBenefic" id="rfcBenefic" maxlength="13" tabindex="1" size="40"
									<cfif modo neq "ALTA">
										value="#rsForm.EMRfcBenefic#"
									</cfif>
									>
								</td>
							</tr>
						</table>
					</fieldset>
				</td>
			</tr>
			<tr id="trInfoCliente">
				<td colspan="4">
					<br>
					<fieldset>
						<legend>
							<strong>
								<div id="divInfoAdicional">
									Informaci&oacute;n del Socio
								</div>
							</strong>
						</legend>
					</fieldset>
				</td>
			</tr>
			<tr id="TR_TIPO">
				<td nowrap>
					<strong>
						#LB_SocioNegocio#:
					</strong>
				</td>
				<td>
					<cfset valuesArraySN = ArrayNew(1)>
					<cfif modo neq "ALTA" and rsForm.TpoSocio neq 0>
						<cfquery datasource="#Session.DSN#" name="rsSN">
				select SNid,SNcodigo,SNidentificacion,SNnumero,SNnombre
				from SNegocios
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and  SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsForm.SNcodigo#">
			</cfquery>
						<cfset ArrayAppend(valuesArraySN, rsSN.SNid)>
						<cfset ArrayAppend(valuesArraySN, rsSN.SNcodigo)>
						<cfset ArrayAppend(valuesArraySN, rsSN.SNidentificacion)>
						<cfset ArrayAppend(valuesArraySN, rsSN.SNnumero)>
						<cfset ArrayAppend(valuesArraySN, rsSN.SNnombre)>
					</cfif>
					<cf_conlis
						Campos="SNid,SNcodigo,SNidentificacion,SNnumero,SNnombre"
						valuesArray="#valuesArraySN#"
						Desplegables="N,N,N,S,S"
						Modificables="N,N,N,S,N"
						Size="0,0,0,10,30"
						tabindex="10"
						Title="#LB_ListaSocioNegocio#"
						Tabla="SNegocios"
						Columnas="SNid,SNcodigo,SNidentificacion,SNnumero,SNnombre"
						Filtro=" Ecodigo = #Session.Ecodigo#  and SNtiposocio != $SNtiposocio,char$ order by SNnumero, SNnombre "
						Desplegar="SNnumero,SNidentificacion,SNnombre"
						Etiquetas="#LB_Codigo#,#LB_Identificacion#,#LB_Nombre#"
						filtrar_por="SNnumero,SNidentificacion,SNnombre"
						Formatos="S,S,S"
						Align="left,left,left"
						form="form1"
						Asignar="SNid,SNcodigo,SNnumero,SNnombre"
						Asignarformatos="S,S,S,S"
						Funcion="ajaxFunction_Direccion()"/>
				</td>
				<td>
					<strong>
						#LB_Direccion#:
					</strong>
				</td>
				<td colspan="3">
					<cfquery datasource="#Session.DSN#" name="rsSN">
			select id_direccion, SNnombre as nombre, SNDtelefono
			from SNDirecciones
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			<cfif modo neq "ALTA" and len(trim(rsForm.SNid))>
				and  SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.SNid#">
		<cfelse>
				and 1 = 2
			</cfif>
			order by SNnombre
		</cfquery>
					<span id="contenedor_direccion">
						<select name="id_direccion" id="id_direccion" tabindex="1">
							<cfloop query="rsSN">
								<option value="#id_direccion#"
								<cfif id_direccion eq rsform.id_direccion>
									selected="selected"
								</cfif>
								>#nombre#</option>
							</cfloop>
						</select>
					</span>
				</td>
			</tr>
			<!--- tipo 1 --->
			<tr id="TR_TIPO2">
				<td nowrap>
					<strong>
						#LB_TransaccionDestino#:
					</strong>
				</td>
				<td>
					<cfset valuesArrayCCT = ArrayNew(1)>
					<cfif modo neq "ALTA" and rsForm.TpoSocio eq 1>
						<cfquery datasource="#Session.DSN#" name="rsCCT">
				select CCTcodigo,CCTdescripcion
				from CCTransacciones
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and  CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsForm.TpoTransaccion#">
			</cfquery>
						<cfset ArrayAppend(valuesArrayCCT, rsCCT.CCTcodigo)>
						<cfset ArrayAppend(valuesArrayCCT, rsCCT.CCTdescripcion)>
					</cfif>
					<cf_conlis
						Campos="CCTcodigo,CCTdescripcion"
						Desplegables="S,S"
						valuesArray="#valuesArrayCCT#"
						Modificables="S,N"
						Size="2,43"
						tabindex="11"
						Title="#LB_TransaccionesCliente#"
						Tabla="CCTransacciones "
						Columnas="CCTcodigo,CCTdescripcion"
						Filtro=" Ecodigo = #Session.Ecodigo#  and  CCTtipo != $BTtipo,char$"
						Desplegar="CCTcodigo,CCTdescripcion"
						Etiquetas="#LB_Codigo#,#LB_Descripcion#"
						filtrar_por="CCTcodigo,CCTdescripcion"
						Formatos="S,S"
						Align="left,left"
						form="form1"
						Asignar="CCTcodigo,CCTdescripcion"
						Asignarformatos="S,S"/>
				</td>
				<td align="left">
					<strong>
						<!--- #LB_ClientePOS#: --->&nbsp;
					</strong>
				</td>
				<td colspan="3" align="left">
					<!--- <cfif isdefined('rsForm') and len(trim(rsForm.CDCcodigo))>
						<cf_sifClienteDetCorp CDCcodigo="CDCcodigo" form='form1' idquery="#rsForm.CDCcodigo#" size="20">
					<cfelse>
						<cf_sifClienteDetCorp CDCcodigo="CDCcodigo" form='form1' size="20">
					</cfif> --->
					&nbsp;
				</td>
				<!--- <td colspan="4">&nbsp;</td> --->
			</tr>
			<!--- tipo 2 --->
			<tr id="TR_TIPO3">
				<td nowrap>
					<strong>
						#LB_TransaccionDestino#:
					</strong>
				</td>
				<td>
					<cfset valuesArrayCPT = ArrayNew(1)>
					<cfif modo neq "ALTA" and rsForm.TpoSocio eq 2>
						<cfquery datasource="#Session.DSN#" name="rsCPT">
				select CPTcodigo,CPTdescripcion
				from CPTransacciones
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and  CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsForm.TpoTransaccion#">
			</cfquery>
						<cfset ArrayAppend(valuesArrayCPT, rsCPT.CPTcodigo)>
						<cfset ArrayAppend(valuesArrayCPT, rsCPT.CPTdescripcion)>
					</cfif>
					<cf_conlis
						Campos="CPTcodigo,CPTdescripcion"
						Desplegables="S,S"
						Modificables="S,N"
						valuesArray="#valuesArrayCPT#"
						Size="2,43"
						tabindex="12"
						Title="#LB_ListasTransaccionesProveedor#"
						Tabla="CPTransacciones "
						Columnas="CPTcodigo,CPTdescripcion"
						Filtro=" Ecodigo = #Session.Ecodigo# and  CPTtipo != $BTtipo,char$"
						Desplegar="CPTcodigo,CPTdescripcion"
						Etiquetas="#LB_Codigo#,#LB_Descripcion#"
						filtrar_por="CPTcodigo,CPTdescripcion"
						Formatos="S,S"
						Align="left,left"
						form="form1"
						Asignar="CPTcodigo,CPTdescripcion"
						Asignarformatos="S,S"/>
				</td>
				<td colspan="4">&nbsp;

				</td>
			</tr>
			<!--- tipo 3 --->
			<tr id="TR_TIPO4">
				<td nowrap>
					<strong>
						#LB_TransaccionDestino#:
					</strong>
				</td>
				<td>
					<cfset valuesArrayCCTD = ArrayNew(1)>
					<cfif modo neq "ALTA" and rsForm.TpoSocio eq 3>
						<cfquery datasource="#Session.DSN#" name="rsCCT">
				select CCTcodigo,CCTdescripcion
				from CCTransacciones
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and  CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsForm.TpoTransaccion#">
			</cfquery>
						<cfset ArrayAppend(valuesArrayCCTD, rsCCT.CCTcodigo)>
						<cfset ArrayAppend(valuesArrayCCTD, rsCCT.CCTdescripcion)>
					</cfif>
					<cf_conlis
						Campos="CCTcodigoD,CCTdescripcionD"
						Desplegables="S,S"
						valuesArray="#valuesArrayCCTD#"
						Modificables="S,N"
						Size="2,43"
						tabindex="13"
						Title="#LB_TransaccionesCliente#"
						Tabla="CCTransacciones "
						Columnas="CCTcodigo as CCTcodigoD,CCTdescripcion as CCTdescripcionD"
						Filtro=" Ecodigo = #Session.Ecodigo#  and  CCTtipo = $BTtipo,char$"
						Desplegar="CCTcodigoD,CCTdescripcionD"
						Etiquetas="#LB_Codigo#,#LB_Descripcion#"
						filtrar_por="CCTcodigo,CCTdescripcion"
						Formatos="S,S"
						Align="left,left"
						form="form1"
						Asignar="CCTcodigoD,CCTdescripcionD"
						Asignarformatos="S,S"/>
				</td>
				<td>
					<strong>
						#LB_Documento#:
					</strong>
				</td>
				<td colspan="3">
					<cfset valuesArrayDC = ArrayNew(1)>
					<cfif modo neq "ALTA" and rsForm.Documento neq "">
						<cfquery datasource="#Session.DSN#" name="rsDC">
				select Ddocumento as DocumentoC,Dsaldo as Dsaldo
				from Documentos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and  CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsForm.TpoTransaccion#">
				and  Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.Mcodigo#">
				and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.SNcodigo#">
				and Dsaldo >=  <cfqueryparam cfsqltype="cf_sql_float" value="#rsForm.EMtotal#">
			</cfquery>
						<cfset ArrayAppend(valuesArrayDC, rsDC.DocumentoC)>
						<cfset ArrayAppend(valuesArrayDC, rsDC.Dsaldo)>
					</cfif>
					<cf_conlis
						Campos="DocumentoC,DsaldoC"
						Desplegables="S,S"
						valuesArray="#valuesArrayDC#"
						Modificables="S,N"
						Size="25,25"
						tabindex="14"
						Title="#LB_ListaDocumentos#"
						Tabla="Documentos "
						Columnas="Ddocumento as DocumentoC,Dsaldo as DsaldoC"
						Filtro=" Ecodigo = #Session.Ecodigo#  and  CCTcodigo = $CCTcodigoD,char$ and SNcodigo = $SNcodigo,numeric$ and Mcodigo = $Mcodigo,numeric$ and Dsaldo >= $EMtotal,money$"
						Desplegar="DocumentoC,DsaldoC"
						Etiquetas="#LB_Documento#,Salado"
						filtrar_por="Ddocumento,Dsaldo"
						Formatos="S,M"
						Align="left,left"
						form="form1"
						Asignar="DocumentoC,DsaldoC"
						Asignarformatos="S,M"/>
				</td>
			</tr>
			<!--- tipo 4 --->
			<tr id="TR_TIPO5">
				<td nowrap>
					<strong>
						#LB_TransaccionDestino#:
					</strong>
				</td>
				<td>
					<cfset valuesArrayCPTD = ArrayNew(1)>
					<cfif modo neq "ALTA" and rsForm.TpoSocio eq 4>
						<cfquery datasource="#Session.DSN#" name="rsCPT">
				select CPTcodigo,CPTdescripcion
				from CPTransacciones
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and  CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsForm.TpoTransaccion#">
			</cfquery>
						<cfset ArrayAppend(valuesArrayCPTD, rsCPT.CPTcodigo)>
						<cfset ArrayAppend(valuesArrayCPTD, rsCPT.CPTdescripcion)>
					</cfif>
					<cf_conlis
						Campos="CPTcodigoD,CPTdescripcionD"
						Desplegables="S,S"
						Modificables="S,N"
						valuesArray="#valuesArrayCPTD#"
						Size="2,43"
						tabindex="15"
						Title="#LB_ListasTransaccionesProveedor#"
						Tabla="CPTransacciones "
						Columnas="CPTcodigo as CPTcodigoD ,CPTdescripcion as CPTdescripcionD"
						Filtro=" Ecodigo = #Session.Ecodigo# and  CPTtipo = $BTtipo,char$"
						Desplegar="CPTcodigoD,CPTdescripcionD"
						Etiquetas="#LB_Codigo#,#LB_Descripcion#"
						filtrar_por="CPTcodigo,CPTdescripcion"
						Formatos="S,S"
						Align="left,left"
						form="form1"
						Asignar="CPTcodigoD,CPTdescripcionD"
						Asignarformatos="S,S"/>
				</td>
				<td>
					<strong>
						#LB_Documento#:
					</strong>
				</td>
				<td colspan="3">
					<cfset valuesArrayDP = ArrayNew(1)>
					<cfif modo neq "ALTA" and rsForm.Documento neq "">
						<cfquery datasource="#Session.DSN#" name="rsDC">
				select Ddocumento as DocumentoP,EDsaldo as DsaldoP
				from EDocumentosCP
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and  CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsForm.TpoTransaccion#">
				and  Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.Mcodigo#">
				and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.SNcodigo#">
				and EDsaldo >=  <cfqueryparam cfsqltype="cf_sql_float" value="#rsForm.EMtotal#">
			</cfquery>
						<cfset ArrayAppend(valuesArrayDP, rsDC.DocumentoP)>
						<cfset ArrayAppend(valuesArrayDP, rsDC.DsaldoP)>
					</cfif>
					<cf_conlis
						Campos="DocumentoP,DsaldoP"
						Desplegables="S,S"
						Modificables="S,N"
						Size="25,25"
						valuesArray="#valuesArrayDP#"
						tabindex="8"
						Title="#LB_ListaDocumentos#"
						Tabla="EDocumentosCP "
						Columnas="Ddocumento as DocumentoP,EDsaldo as DsaldoP"
						Filtro=" Ecodigo = #Session.Ecodigo#  and  CPTcodigo = $CPTcodigoD,char$ and SNcodigo = $SNcodigo,numeric$ and Mcodigo = $Mcodigo,numeric$ and EDsaldo >= $EMtotal,money$"
						Desplegar="DocumentoP,DsaldoP"
						Etiquetas="#LB_Documento#,#LB_Saldo#"
						filtrar_por="Ddocumento,EDsaldo"
						Formatos="S,M"
						Align="left,left"
						form="form1"
						Asignar="DocumentoP,DsaldoP"
						Asignarformatos="S,M"/>
				</td>
			</tr>
		</table>
		<input type="hidden" name="SNtiposocio" value=""/>
		<br>
		<cfif modo neq "ALTA" and rsForm.TpoSocio eq 0>
			<cfif dmodo neq "ALTA">
				<input type="hidden" name="DMlinea" value="#rsDForm.DMlinea#">
				<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="tsd" artimestamp="#rsDForm.ts_rversion#"/>
				<input type="hidden" name="timestampdet" value="#tsd#">
			</cfif>
			<table width="98%" align="center" border="0" cellspacing="0" cellpadding="1"  style="border:0px;">
				<tr>
					<td class="subTitulo" align="center" bgcolor="##f5f5f5">
						#LB_DetalleMovimientos#
					</td>
				</tr>
			</table>
			<table width="98%" align="center" cellspacing="2" cellpadding="0"  style="border:0px;">
				<tr>
					<td>
						<strong>
							#LB_Descripcion#:
						</strong>
					</td>
					<td>
						<input type="text" name="DMdescripcion" maxlength="120" tabindex="1" size="40"
						<cfif dmodo neq "ALTA">
							value="#rsDForm.DMdescripcion#"
						</cfif>
						>
					</td>
					<td>
						<strong>
							#LB_CentroFuncional#:
						</strong>
					</td>
					<td>
						<cfif dmodo neq "ALTA" and len(rsDForm.CFid)>
							<cf_rhcfuncional size="30" tabindex="16" titulo="Seleccione el Centro Funcional" query="#rsDForm#">
						<cfelse>
							<cf_rhcfuncional size="30" tabindex="17" titulo="Seleccione el Centro Funcional">
						</cfif>
					</td>
				</tr>
				<tr>
					<td nowrap>
						<cfif ContabilizaAutomatico>
							&nbsp;
						<cfelse>
							<strong>
								#LB_Impuesto#:
							</strong>
						</cfif>
					</td>
					<td nowrap>
						<select name="Icodigo" tabindex="1"  <!---<cfif LvarEsSuficiencia>disabled="disabled"</cfif> --->onChange="traeCuenta(this)">
							<option value="" >- <cf_translate key=LB_NoImpCreditoFiscal>No es Impuesto Credito Fiscal</cf_translate> -</option>
							<cfloop query="rsImpuestos">
								<option value="#rsImpuestos.Icodigo#" <cfif dmodo NEQ 'ALTA' and rsDForm.Icodigo eq rsImpuestos.Icodigo >selected <cfset LvarTESDPdescripcion = #trim(rsImpuestos.Idescripcion)#></cfif>>#HTMLEditFormat(rsImpuestos.Idescripcion)#</option>
							</cfloop>
						</select>
					</td>
					<!---<cfset LvarIcodigoTab = "1">
					<cfset LvarIcodigoReadonly = "false">
                	<cfif isdefined("rsDForm.Icodigo") and rsDForm.Icodigo NEQ "">
                    	<cfset LvarIcodigoTab = "-1">
                    	<cfset LvarIcodigoReadonly = "true">
                	</cfif>--->
					<td nowrap>
						<strong>
							#LB_Monto#:
						</strong>
					</td>
					<td>
						<cfif dmodo neq "ALTA">
							<cf_monto name="DMmonto" value="#rsDForm.DMmonto#" tabindex="20" negativos="true">
						<cfelse>
							<cf_monto name="DMmonto" tabindex="21"  negativos="true" >
						</cfif>
					</td>
				</tr>
					<tr>

					<td nowrap>
						<cfif ContabilizaAutomatico>
							&nbsp;
						<cfelse>
							<strong>
								#LB_CuentaContable#:
							</strong>
						</cfif>
					</td>
					<cfif ContabilizaAutomatico>
						<td style="display:none">
							<cf_cuentas tabindex="19" cf_conceptoPago="TESRPTCid" >
						</td>
					<cfelse>
						<td>
							<cfif dmodo NEQ "ALTA">
								<cf_cuentas query="#rsDForm#" cf_conceptoPago="TESRPTCid">
							<cfelse>
								<cf_cuentas tabindex="19" cf_conceptoPago="TESRPTCid">
							</cfif>
						</td>
					</cfif>
					</tr>
					<!---<cfif ContabilizaAutomatico>
						<td style="display:none">
							<cf_cuentas tabindex="19" cf_conceptoPago="TESRPTCid" >
						</td>
					<cfelse>
						<td>
							<cfif dmodo NEQ "ALTA">
								<cf_cuentas query="#rsDForm#" tabindex="18" cf_conceptoPago="TESRPTCid">
							<cfelse>
								<cf_cuentas tabindex="19" cf_conceptoPago="TESRPTCid">
							</cfif>
						</td>
					</cfif>
					<td nowrap>
						<strong>
							#LB_Monto#:
						</strong>
					</td>
					<td>
						<cfif dmodo neq "ALTA">
							<cf_monto name="DMmonto" value="#rsDForm.DMmonto#" tabindex="20" negativos="true">
						<cfelse>
							<cf_monto name="DMmonto" tabindex="21"  negativos="true" >
						</cfif>
					</td>--->

				</tr>


				<tr>
					<td>
					</td>
					<td colspan="3">
						<cfif dmodo neq "ALTA">
							<cf_conceptoPago 	name="TESRPTCid" 	value="#rsDForm.TESRPTCid#"
								SNid="#rsDForm.SNid#" TESBid="#rsDForm.TESBid#" CDCcodigo="#rsDForm.CDCcodigo#"
								Bid="" CFcuenta="#rsDForm.CFcuenta#">
						<cfelse>
							<cf_conceptoPago name="TESRPTCid" value="" SNid="" TESBid="" CDCcodigo="" Bid="" CFcuenta="">
						</cfif>
					</td>
				</tr>
			</table>
			<br>
		</cfif>
		<cfif modo neq "ALTA" and rsForm.TpoSocio eq 0>
			<!--- <cf_botones tabindex="22" modo="#modo#" mododet="#dmodo#" include="Regresar#Aplicar#,Importar" Genero="M" nameEnc="Movimiento"> --->
			<cf_botones tabindex="22" modo="#modo#" mododet="#dmodo#" include="Regresar,Importar" Genero="M" nameEnc="Movimiento">
		<cfelseif modo neq "ALTA" and rsForm.TpoSocio neq 0>
			<!--- <cfset Aplicar = ", Aplicar"> --->
			<!--- <cf_botones tabindex="23" modo="#modo#" include="Regresar#Aplicar#" Genero="M" nameEnc="Movimiento"> --->
			<cf_botones tabindex="23" modo="#modo#" include="Regresar" Genero="M" nameEnc="Movimiento">
		<cfelseif modo eq "ALTA" >
			<cf_botones tabindex="24" modo="#modo#" include="Regresar" Genero="M" nameEnc="Movimiento">
		</cfif>
		<cfif modo neq "ALTA" and rsForm.TpoSocio eq 0>
			<!--- ==================================================================================== --->
			<!--- MANTENER LOS FILTROS DE LA LISTA --->
			<!--- ==================================================================================== --->
			<input type="hidden" name="pagenum_lista" value="<cfif isdefined("form.pagenum_lista") >
			#form.pagenum_lista#
		<cfelse>
			1
		</cfif>
		" />
		<cfif isdefined("form.pagenum_lista2") >
			<input type="hidden" name="pagenum_lista2" value="#form.pagenum_lista2#" />
		</cfif>
		<cfif not isdefined('LvarTCE')>
			<cfif isdefined("form.filtro_DMdescripcion") >
				<input type="hidden" name="filtro_DMdescripcion" value="#form.filtro_DMdescripcion#" />
			</cfif>
		</cfif>
		<cfif isdefined("form.filtro_Cdescripcion") >
			<input type="hidden" name="filtro_Cdescripcion" value="#form.filtro_Cdescripcion#" />
		</cfif>
		<cfif isdefined("form.filtro_EMdocumento") >
			<input type="hidden" name="filtro_EMdocumento" value="#trim(form.filtro_EMdocumento)#" />
		</cfif>
		<cfif isdefined("form.filtro_CBid") >
			<input type="hidden" name="filtro_CBid" value="#form.filtro_CBid#" />
		</cfif>
		<cfif isdefined("form.filtro_BTid") >
			<input type="hidden" name="filtro_BTid" value="#form.filtro_BTid#" />
		</cfif>
		<cfif isdefined("form.filtro_EMdescripcion") >
			<input type="hidden" name="filtro_EMdescripcion" value="#trim(form.filtro_EMdescripcion)#" />
		</cfif>
		<cfif isdefined("form.filtro_EMfecha") >
			<input type="hidden" name="filtro_EMfecha" value="#trim(form.filtro_EMfecha)#" />
		</cfif>
		<cfif isdefined("form.filtro_usuario") >
			<input type="hidden" name="filtro_usuario" value="#form.filtro_usuario#" />
		</cfif>
		<!--- ==================================================================================== --->
		<!--- ==================================================================================== --->
		</cfif>
	</form>
	<!--- ==================================================================================== --->
	<!--- MANTENER LOS FILTROS DE LA LISTA --->
	<!--- ==================================================================================== --->
	<cfset navegacionDetalle = '' >
	<form action="#_PaginaLista#" method="post" name="form2" style="border:0px;">
		<cfif modo neq "ALTA" and rsForm.TpoSocio eq 0>
			<input type="hidden" name="pagenum_lista" value="<cfif isdefined("form.pagenum_lista") >
			#form.pagenum_lista#
		<cfelse>
			1
		</cfif>
		" />
		<cfif isdefined("form.pagenum_lista") >
			<cfset navegacionDetalle = '&pagenum_lista=#form.pagenum_lista#' >
		<cfelse>
			<cfset navegacionDetalle = '&pagenum_lista=1' >
		</cfif>
		<input type="hidden" name="btnNuevo" value="" />
		<cfif isdefined("form.filtro_EMdocumento") >
			<input type="hidden" name="filtro_EMdocumento" value="#trim(form.filtro_EMdocumento)#" />
			<cfset navegacionDetalle = navegacionDetalle & '&filtro_EMdocumento=#form.filtro_EMdocumento#' >
		</cfif>
		<cfif isdefined("form.filtro_CBid") >
			<input type="hidden" name="filtro_CBid" value="#form.filtro_CBid#" />
			<cfset navegacionDetalle = navegacionDetalle & '&filtro_CBid=#form.filtro_CBid#' >
		</cfif>
		<cfif isdefined("form.EMusuario") >
			<cfset navegacionDetalle = navegacionDetalle & '&EMusuario=#form.EMusuario#' >
		</cfif>
		<cfif isdefined("form.filtro_BTid") >
			<input type="hidden" name="filtro_BTid" value="#form.filtro_BTid#" />
			<cfset navegacionDetalle = navegacionDetalle & '&filtro_BTid=#form.filtro_BTid#' >
		</cfif>
		<cfif isdefined("form.filtro_EMdescripcion") >
			<input type="hidden" name="filtro_EMdescripcion" value="#trim(form.filtro_EMdescripcion)#" />
			<cfset navegacionDetalle = navegacionDetalle & '&filtro_EMdescripcion=#form.filtro_EMdescripcion#' >
		</cfif>
		<cfif isdefined("form.filtro_EMfecha") >
			<input type="hidden" name="filtro_EMfecha" value="#trim(form.filtro_EMfecha)#" />
			<cfset navegacionDetalle = navegacionDetalle & '&filtro_EMfecha=#form.filtro_EMfecha#' >
		</cfif>
		<cfif isdefined("form.filtro_usuario") >
			<input type="hidden" name="filtro_usuario" value="#form.filtro_usuario#" />
			<cfset navegacionDetalle = navegacionDetalle & '&filtro_usuario=#form.filtro_usuario#' >
		</cfif>
		<cfif isdefined("form.EMusuario") >
			<input type="hidden" name="EMusuario2" value="#form.EMusuario#" />
			<cfset navegacionDetalle = navegacionDetalle & '&EMusuario2=#form.EMusuario#' >
		</cfif>
		</cfif>
	</form>
	<!--- ==================================================================================== --->
	<!--- ==================================================================================== --->

	<cf_qforms form='form1'>
	<script>window.jQuery || document.write('<script src="/cfmx/jquery/librerias/jquery-1.8.2.min.js"><\/script>')</script>
	<script language="javascript" type="text/javascript">

	function ValVac(texto){
		 // Funcion para quitar los espacios vacio
		texto.value  = texto.value.trim();

	}

	function traeCuenta(imp){
		if (imp.value != ''){
			var vValue = imp.value
			$.ajax({
				type: "POST",
				url: "SQLMovimientos.cfm?getImpCta=1&Icodigo="+vValue,
				data: {
					Icodigo : vValue
				},
				success: function(data) {
					var jsonData = JSON.parse(data);
					document.form1.Cmayor.value  = jsonData.CMAYOR;
					document.form1.Cformato.value  = jsonData.CFORMATO;
					document.form1.Cdescripcion.value  = jsonData.CDESCRIPCION;
					document.form1.CFcuenta.value  = jsonData.CFCUENTA;
					document.form1.Ccuenta.value  = jsonData.CCUENTA;
				}
			})
		}else{
			document.form1.Cmayor.value  = '';
			document.form1.Cformato.value  = '';
			document.form1.Cdescripcion.value  = '';
			document.form1.CFcuenta.value  = '';
			document.form1.Ccuenta.value  = '';
		}
	}

	var monto = -1;
		verTR();
		<cfif modo eq "ALTA" >
			try {
				var sl = document.getElementById("BTid");
				var tmpIdx = 0;
				var currIndx = sl.selectedIndex;
				sl.selectedIndex = tmpIdx;
			} catch(err) { }
		</cfif>


	   <cfif isdefined('LvarTCE')>
			objForm.CBTCDescripcion.description = "#JSStringFormat('Tarjeta de Cr\u00e9dito')#";
			objForm.CBTCDescripcion.required = true;

	<cfelse>
			objForm.Bid.description = "#JSStringFormat('Banco')#";
			objForm.Bid.required = true;
			objForm.CBdescripcion.description = "#JSStringFormat('Cuenta Bancaria')#";
			objForm.CBdescripcion.required = true;

 		</cfif>

		objForm.BTid.required=true;

	objForm.EMdocumento.description = "#JSStringFormat(LB_Documento)#";
	objForm.EMdocumento.required = true;
	objForm.EMdescripcion.description = "#JSStringFormat(LB_Descripcion)#";
	objForm.EMdescripcion.required = true;
	objForm.EMfecha.description = "#JSStringFormat(LB_Fecha)#";
	objForm.BTid.description = "#JSStringFormat(LB_TransaccionBanco)#";
	objForm.EMreferencia.description = "#JSStringFormat(LB_Referencia)#";
	objForm.EMreferencia.required = true;


<cfif modo neq "ALTA" and rsForm.TpoSocio eq 0>
	objForm.DMdescripcion.description = "#JSStringFormat(OBJ_DescDetalle)#";
	objForm.CFcodigo.description = "#JSStringFormat(OBJ_CFDetalle)#";
	objForm.Ccuenta.description = "#JSStringFormat(OBJ_CContableDetalle)#";
	objForm.DMmonto.description = "#JSStringFormat(OBJ_MontoDetalle)#";

</cfif>

<!---	<cfif modo NEQ "BAJA"><!--- en la caso de eliminar no necesita validar estos campos como en blanco--->
	objForm.DMdescripcion.description = "#JSStringFormat('Descripci\u00f3n del Movimiento')#";
	objForm.DMdescripcion.required = true;
	objForm.Cdescripcion.description = "#JSStringFormat('Cuenta Contable')#";
	objForm.Cdescripcion.required = true;
	</cfif>--->

	objForm.Mnombre.description = "#JSStringFormat(LB_Moneda)#";
	objForm.BTtipo.description = "#JSStringFormat(LB_TransaccionBanco)#";
	objForm.SNid.description = "#JSStringFormat(LB_SocioNegocio)#";
	objForm.SNcodigo.description = "#JSStringFormat(LB_SocioNegocio)#";
	objForm.id_direccion.description = "#JSStringFormat(LB_Direccion)#";
	objForm.DocumentoP.description = "#JSStringFormat('P ' & LB_Documento)#";
	objForm.DocumentoC.description = "#JSStringFormat('C ' & LB_Documento)#";


	<!--- objForm.CDCidentificacion.description =  "#JSStringFormat(LB_Cliente)#"; --->
	objForm.EMtotal.required = true;
	_addValidator("isCantidad", Cantidad_valida);
	objForm.EMtotal.validateCantidad();

	objForm.BTtipo.required = true;


	if(document.form1.CCTcodigo)
		objForm.CCTcodigo.description = "#JSStringFormat(OBJ_TipoTransaccion)#";
	if(document.form1.CCTcodigoD)
		objForm.CCTcodigoD.description = "#JSStringFormat(OBJ_TipoTransaccion)#";
	if(document.form1.CPTcodigo)
	objForm.CPTcodigo.description = "#JSStringFormat(OBJ_TipoTransaccion)#";
	if(document.form1.CPTcodigoD)
	objForm.CPTcodigoD.description = "#JSStringFormat(OBJ_TipoTransaccion)#";
	objForm.EMtotal.description = "#JSStringFormat(LB_Total)#";

<!---	<cfif modo neq "ALTA" and rsForm.TpoSocio eq 0>

		objForm.DMdescripcion.description = "#JSStringFormat('Descripción del Detalle')#";

		<cfif ContabilizaAutomatico>
			objForm.CFdescripcion.description = "#JSStringFormat('Centro Funcional del Detalle')#";
	<cfelse>
			objForm.Ccuenta.description = "#JSStringFormat('Cuenta Contable del Detalle')#";
		</cfif>
		objForm.DMmonto.description = "#JSStringFormat('Monto del Detalle')#";
	</cfif>--->


	function verTR() {
		var tr = document.getElementById("TR_TIPO");
		var trInfoCliente = document.getElementById("trInfoCliente");
		var tr2 = document.getElementById("TR_TIPO2");
		var tr3 = document.getElementById("TR_TIPO3");
		var tr4 = document.getElementById("TR_TIPO4");
		var tr5 = document.getElementById("TR_TIPO5");
		var trBancos = document.getElementById("trBancos");
		var tabla  = document.getElementById("tabla");

		if (document.form1.TpoSocio.value != '0'){
			tr.style.display = "";
			document.form1.EMtotal.readOnly  = false;
			objForm.SNcodigo.required = true;
			<!--- objForm.id_direccion.required = true; --->
			if (tabla){
			tabla.style.display =  "none";
			}
			<cfif modo neq "ALTA" and rsForm.TpoSocio eq 0>
				alert(MSG_QuitarDetalle);
			</cfif>
		}
		else{
			tr.style.display =  "none";
			trInfoCliente.style.display =  "none";
			tr2.style.display =  "none";
			tr3.style.display =  "none";
			tr4.style.display =  "none";
			tr5.style.display =  "none";
			trBancos.style.display =  "";
			document.form1.EMtotal.readOnly  = true;
			objForm.SNcodigo.required = false;
			objForm.CCTcodigo.required = false;
			objForm.CPTcodigo.required = false;
			objForm.CCTcodigoD.required = false;
			objForm.CPTcodigoD.required = false;
			objForm.id_direccion.required = false;
			<cfif modo neq "ALTA" and rsForm.TpoSocio neq 0>
				alert(MSG_AgregaLinea);
			</cfif>

		}
		document.form1.SNtiposocio.value = '';
		if (document.form1.TpoSocio.value == '1') {
			document.form1.SNtiposocio.value = 'P';
			tr2.style.display = "";
			tr3.style.display =  "none";
			tr4.style.display =  "none";
			tr5.style.display =  "none";
			trBancos.style.display =  "";
			trInfoCliente.style.display =  "";
			objForm.CCTcodigo.required = true;
			objForm.CPTcodigo.required = false;
			objForm.CCTcodigoD.required = false;
			objForm.CPTcodigoD.required = false;

		}
		else if(document.form1.TpoSocio.value == '2'){
			document.form1.SNtiposocio.value = 'C';
			tr3.style.display = "";
			tr2.style.display =  "none";
			tr4.style.display =  "none";
			tr5.style.display =  "none";
			trBancos.style.display =  "none";
			objForm.CCTcodigo.required = false;
			objForm.CPTcodigo.required = true;
			objForm.CCTcodigoD.required = false;
			objForm.CPTcodigoD.required = false;

		}
		else if(document.form1.TpoSocio.value == '3'){
			document.form1.SNtiposocio.value = 'P';
			tr2.style.display = "none";
			tr3.style.display =  "none";
			tr4.style.display =  "";
			tr5.style.display =  "none";
			objForm.CCTcodigo.required = false;
			objForm.CPTcodigo.required = false;
			objForm.CCTcodigoD.required = true;
			objForm.CPTcodigoD.required = false;
			objForm.DocumentoC.required = true;
			objForm.DocumentoP.required = false;

		}
		else if(document.form1.TpoSocio.value == '4'){
			document.form1.SNtiposocio.value = 'C';
			tr3.style.display = "none";
			tr2.style.display =  "none";
			tr4.style.display =  "none";
			tr5.style.display =  "";
			objForm.CCTcodigo.required = false;
			objForm.CPTcodigo.required = false;
			objForm.CCTcodigoD.required = false;
			objForm.CPTcodigoD.required = true;
			objForm.DocumentoP.required = true;
			objForm.DocumentoC.required = false;

		}
	}

	function Cantidad_valida(){
		var TpoSocio = new Number(document.form1.TpoSocio.value)
		var monto = new Number(this.value)
		if ( TpoSocio != 0){
			if (monto <= 0)
				this.error = MSG_MontoNoCero;
		}
	}

	function LimpiarCampos() {
		document.form1.SNcodigo.value = "";
		document.form1.SNidentificacion.value = "";
		document.form1.SNnombre.value = "";
		document.form1.DocumentoP.value = "";
		document.form1.DocumentoC.value = "";
		document.form1.CCTcodigo.value = "";
		document.form1.CCTdescripcion.value = "";
		document.form1.CPTcodigo.value = "";
		document.form1.CPTdescripcion.value = "";
		document.form1.CCTcodigoD.value = "";
		document.form1.CCTdescripcionD.value = "";
		document.form1.CPTcodigoD.value = "";
		document.form1.CPTdescripcionD.value = "";
	}

	function asignatipo(BTtipo) {
		document.form1.BTtipo.value = BTtipo;
		var vtrNameBen = document.getElementById('trNameBen');
		var vtrRFCBen = document.getElementById('trRFCBen');
		var vnameBenefic = document.getElementById('nameBenefic');
		var vrfcBenefic = document.getElementById('rfcBenefic');
		if(vtrNameBen) vtrNameBen.style.display = '';
		if(vtrRFCBen) vtrRFCBen.style.display = '';
		if(BTtipo == 'C'){
			<!--- if(vtrNameBen) vnameBenefic.required = true;
			if(vrfcBenefic) vrfcBenefic.required = true; --->
		}
		else {
			if(vtrNameBen) vnameBenefic.required = false;
			if(vrfcBenefic) vrfcBenefic.required = false;
		}

	}


	function habilitarValidacion() {


		<cfif isdefined('LvarTCE')>
			objForm.CBTCDescripcion.required = true;
	<cfelse>
			objForm.Bid.required = true;
			objForm.CBdescripcion.required = true;
 		</cfif>

		<cfif modo neq "ALTA" and rsForm.TpoSocio eq 0>
		objForm.DMdescripcion.required = true;
		objForm.CFcodigo.required = true;
		objForm.Ccuenta.required = true;
		</cfif>

		objForm.EMdocumento.required = true;
		objForm.EMdescripcion.required = true;
		objForm.EMfecha.required = true;

		objForm.BTid.required = true;


		objForm.Mnombre.required = true;
		objForm.EMtipocambio.required = true;
		objForm.EMreferencia.required = true;
		if (!btnSelected("Cambio", document.form1)){
		<cfif modo neq "ALTA" and rsForm.TpoSocio eq 0>
			objForm.allowSubmitOnError = false;
			<cfif not isdefined('LvarTCE')>
			objForm.DMdescripcion.required = true;
			</cfif>
			<cfif ContabilizaAutomatico>
				objForm.CFcodigo.required = true;
		<cfelse>
				 <cfif not isdefined('LvarTCE')>
				objForm.Ccuenta.required = true;
				</cfif>
			</cfif>
			objForm.DMmonto.required = true;
			objForm.DMmonto.validateExp("!objForm.allowSubmitOnError&&parseFloat(qf(this.getValue()))==0.00",MSG_MontoDetNoCero);
		</cfif>
		}else{
		<cfif modo neq "ALTA" and rsForm.TpoSocio eq 0>
			objForm.allowSubmitOnError = true;
			<cfif not isdefined('LvarTCE')>
			objForm.DMdescripcion.required = false;

			</cfif>

			<cfif ContabilizaAutomatico>
				objForm.CFcodigo.required = false;
		<cfelse>
			 <cfif not isdefined('LvarTCE')>
				objForm.Ccuenta.required = false;
				</cfif>
			</cfif>
			objForm.DMmonto.required = false;
		</cfif>
		}
		if (document.form1.TpoSocio.value != '0'){
			if(document.getElementById('id_direccion').selectedIndex > -1){
				objForm.id_direccion.required = false;
			}
			<!--- else{
				objForm.id_direccion.required = true;
			}		 --->
		}<!--- if (document.form1.TpoSocio.value == '1')
				objForm.CDCidentificacion.required = true;
			else
				objForm.CDCidentificacion.required = false; --->
	}
	function deshabilitarValidacion() {


		<cfif isdefined('LvarTCE')>
			objForm.CBTCDescripcion.required = false;
	<cfelse>
			objForm.Bid.required = false;
			objForm.CBdescripcion.required = false;
 		</cfif>

		objForm.DMdescripcion.required = false;


		objForm.BTid.required = false;
		objForm.CFcodigo.required = false;
		objForm.Ccuenta.required = false;

		objForm.EMdocumento.required = false;
		objForm.EMdescripcion.required = false;
		objForm.EMfecha.required = false;
		objForm.BTid.required = false;

		objForm.Mnombre.required = false;
		objForm.EMtipocambio.required = false;
		objForm.EMreferencia.required = false;


		<cfif modo neq "ALTA" and rsForm.TpoSocio eq 0>
			<cfif not isdefined('LvarTCE')>
			objForm.DMdescripcion.required = false;
			</cfif>
			<cfif ContabilizaAutomatico>
				objForm.CFcodigo.required = false;
		<cfelse>
				<cfif not isdefined('LvarTCE')>
				objForm.Ccuenta.required = false;
				</cfif>
			</cfif>
			objForm.DMmonto.required = false;
		</cfif>
	}
	function limpiarCuenta(){
		objForm.CBid.obj.value="";
		objForm.CBcodigo.obj.value="";
		objForm.Mcodigo.obj.value="";
		objForm.Mnombre.obj.value="";
		objForm.EMtipocambio.obj.value="";

	}
	function funcAlta(){
		var lvarReturn = true;
		var lvarCtaBancaria = document.form1.ctaBancariaInfo.value;
		var lvartipoPagoFA = document.getElementById("tipoPagoFA").value;
		var lvarDireccion = document.getElementById("EMid");
		var lVarMetPago = ["02", "03", "04", "05"];
		if (lvartipoPagoFA != "") {
			if(lVarMetPago.indexOf(lvartipoPagoFA) != -1){
				/*lvartipoPagoFA*/
				if(lvarCtaBancaria != ""){
				lvarReturn = this.validaExpresion(lvarCtaBancaria, lvartipoPagoFA);
				}
			}
		} else {
			lvarReturn = false;
			alert('Favor de seleccionar un Tipo de Pago!')
		}
		return lvarReturn;
	}


	function funcCambio(){
		var lvarReturn = true;
		var lvarCtaBancaria = document.form1.ctaBancariaInfo.value;
		var lvartipoPagoFA = document.getElementById("tipoPagoFA").value;
		var lvarDireccion = document.getElementById("EMid");
		var lVarMetPago = ["02", "03", "04", "05"];
		if (lvartipoPagoFA != "") {
			if(lVarMetPago.indexOf(lvartipoPagoFA) != -1){
				/*lvartipoPagoFA*/
				if(lvarCtaBancaria != ""){
				lvarReturn = this.validaExpresion(lvarCtaBancaria, lvartipoPagoFA);
				}
			}
		} else {
			lvarReturn = false;
			alert('Favor de seleccionar un Tipo de Pago!')
		}
		return lvarReturn;
	}


	function validaExpresion(texto, tipoMedioPago) {
		var ok = true;
	    var letras = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	    var numeros = "0123456789"
	    var combinacion1 = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_"
	    var letra;
	    if(tipoMedioPago === "02"){
			/*[0-9]{11}|[0-9]{18} (Solo numeros, longitud de 11 o 18)*/
			for (var i = 0; i < texto.length; i++) {
		        letra = texto.charAt(i);
		        if (numeros.indexOf(letra) == -1) {
		            ok = false;
		        };
		    }
		    if(ok){
		        if(texto.length != 11 && texto.length != 18){
		        	alert("La cuenta bancaria debe de ser de 11 o 18 caracteres!")
		        	ok = false;
		        }
		    } else {
		       	alert("La cuenta bancaria debe de ser num\u00E9rica!")
		    }
	    }else if(tipoMedioPago === "03"){
			/*[0-9]{10}|[0-9]{16}|[0-9]{18} (Solo numeros, longitud de 10, 16 o 18)*/
			for (var i = 0; i < texto.length; i++) {
		        letra = texto.charAt(i);
		        if (numeros.indexOf(letra) == -1) {
		            ok = false;
		        };
		    }
		    if(ok){
		        if(texto.length != 10 && texto.length != 16 && texto.length != 18){
		        	alert("La cuenta bancaria debe de ser de 10, 16 o 18 caracteres!")
		        	ok = false;
		        }
		    } else {
		       	alert("La cuenta bancaria debe de ser num\u00E9rica!")
		    }
	    }else if(tipoMedioPago === "04"){
			/*[0-9]{16} (Solo numeros, longitud de 16)*/
			for (var i = 0; i < texto.length; i++) {
		        letra = texto.charAt(i);
		        if (numeros.indexOf(letra) == -1) {
		            ok = false;
		        };
		    }
		    if(ok){
		        if(texto.length != 16){
		        	alert("La cuenta bancaria debe de ser de 16 caracteres!")
		        	ok = false;
		        }
		    } else {
		       	alert("La cuenta bancaria debe de ser num\u00E9rica!")
		    }
	    }else if(tipoMedioPago === "05"){
			/*[0-9]{10,11}|[0-9]{15,16}|[0-9]{18}|[A-Z0-9_]{10,50} (Solo Letras Mayusculas, Numeros y _, longitud de 10,11,15,16,18, 10 - 50)*/
			for (var i = 0; i < texto.length; i++) {
		        letra = texto.charAt(i);
		        if (numeros.indexOf(letra) == -1) {
		            ok = false;
		        };
		    }
		    if(ok){
		    	/*NUMERICO*/
		        if(texto.length != 10 && texto.length != 11
		        && texto.length != 15 && texto.length != 16
		        && texto.length != 18){
		        	alert("La cuenta bancaria debe de ser de 10, 11, 15, 16 o 18 caracteres!")
		        	ok = false;
		        }
		    } else {
		       	/*ALFANUMERICA*/
		       	ok = true;
		       	for (var i = 0; i < texto.length; i++) {
			        letra = texto.charAt(i);
			        if (combinacion1.indexOf(letra) == -1) {
			            ok = false;
			        };
			    }
			    if(ok){
					if(texto.length < 10 || texto.length > 50){
			        	alert("La cuenta bancaria debe de tener una longitud entre 10 y 50 caracteres!")
			        	ok = false;
			        }
			    } else {
			    	alert("La cuenta bancaria solo puede contener: \nLetras en Mayusculas (A-Z) \nNumeros (0-9) \nY guion bajo (_)")
			    }
		    }
	    }
	    return ok;
	}

	function funcValidaForm(){
		if (!objForm.EMdocumento.required)
			return true;
		if ((toFecha(document.form1.EMfecha.value) > toFecha(document.form1.LvarHoy.value))){
			alert(MSG_FechaMenor + " " + document.form1.LvarHoy.value);
			return false;
		}
		if (cf_conceptoPagoTESRPTCid_verif)
		{
			var TipoMov = (document.form1.BTtipo.value == "D") ? "C" : "D";
			return cf_conceptoPagoTESRPTCid_verif(TipoMov);
		}
		return true;
	}

	function funcRegresar(){
		document.form2.submit();
		return false;
	}

	function funcNuevo(){
		document.form1.action = "<cfoutput>#_Pagina#</cfoutput>";
		var vEMid = document.getElementById("EMid");
		if(vEMid != null)
		 vEMid.value = '';
		//document.form1.EMID.value='';
		//alert(document.form1.EMID.value);
		//return false;
	}
	function FuncCambiarDireccion(){
		alert(MSG_Refrescar);
		return false;
	}

	verTR();
	<cfif modo neq "ALTA" and rsForm.TpoSocio eq 0>
		<cfif not isdefined('LvarTCE')>
		objForm.DMdescripcion.obj.focus();
		</cfif>
<cfelse>
		objForm.EMdocumento.obj.focus();
	</cfif>


</script>
</cfoutput>
