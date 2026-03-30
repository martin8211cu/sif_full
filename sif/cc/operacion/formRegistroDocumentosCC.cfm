<!---
	Modificado por: Ana Villavicencio
	Fecha: 02 de marzo del 2006
	Motivo: Se agregó un nuevo botón para realizar el proceso de aplicar y relacionar documentos a la nota de crédito.
			Este botón hace q se aplique la nota de crédito y crea un nuevo documento a Favor. Lo lleva a la
			pantalla de proceso de Aplicacion de Documentos a Favor.

	Modificado por: Ana Villavicencio
	Fecha: 22 de febrero del 2006
	Motivo: Corrección en la navegacion dentro de la pantalla de trabajo.

	Modificado por: Ana Villavicencio
	Fecha: 10 de octubre del 2005
	Motivo: Cambiar el tamaño de dos campos para acomodar la forma.
	Linea: 1094, 1108

	Modificado por: Gustavo Fonseca H.
		Fecha: 30 de Septiembre del 2005
		Motivo: Se agrega la condición CCTranneteo = 0 en el query que llena la lista de transacciones por que
		mostraba la transacción de Neteo de Documentos y no era correcto. También se modifica la función validatc() para que pinte el
		tipo de cambio correcto usando el navegador de Mozilla.

	Modificado por: Gustavo Fonseca H.
		Fecha: 28 de Septiembre del 2005
		Motivo: Arregla que a la hora de traer la cuenta del Socio, le agregue la cantidad correcta de días, antes le agregaba un día extra.

	Modificado por: Ana Villavicencio R.
	Fecha: 29 de  Agosto del 2005
	Motivo: Se producia un error cuando hacia la busqueda de la cuenta de socio de negocio en el browser Mozilla. Error de javascrip,
			Cmayor en lugar de cmayor

	- Modificado por Gustavo Fonseca Hernández.
		Fecha 23-8-2005.
		Motivo: Se corrige la función del botón de regresar para que llame al archivo correcto de acuerdo al tipo (C o D) y así no
		se pierde la seguridad y el menú de Navegación. Antes si estaba en una nota de crédito y le daba regrasar se iba a la lista de
		facturas.

	Modificado por: Ana Villavicencio
	Fecha: 22 de agosto del 2005
	Motivo: No guarda la cuenta asignada por le sistema para el encabezado.  Se elimina un hidden (Ccuenta).

	Modificado por: Ana Villavicencio
	Fecha: 17 de Agosto del 2005
	Motivo: Validar el parametro de Indicar manualmente la cuenta del documento. en estos momentos no permite modificar la cuenta,
			esto para la cuenta del proveedor, cuando este parametro indica que puede hacerce manual. Se hace los cambio para
			q permita hacerlo cuando el parametro lo indica.

	Modificado por: Rodolfo Jiménez Jara
	Fecha de Modificación: 14 Junio de 2006
	Motivo: Agregar parámetro de verClasificaCP, para no mostrar la columna de clasificación del
	conlis de Conceptos de servicio
	- Modificado por Gustavo Fonseca H.
		Fecha: 17-6-2004
		Motivo: Se quita el combo de cuenta del socio, se pone solo etiqueta. Se quita el Departamento (en el detalle) y en su lugar
		se incluye el Centro Funcional. En el detalle se condiciona el pintado de la cuenta segun el Parámetro con el Pcodigo = 2.
	- Modificado por Gustavo Fonseca H.
		Fecha: 4-8-2005
		Motivo: - Se modifica para arreglar la seguridad de CxC en los procesos de facturas y notas de crédito, para que seguridad sepa
				con cual de los dos procesos está trabajando. Esto porque se estaba trabajando con un archivo para los dos procesos.
				- Se agrega el botón nuevo en el form para que no tenga que salir hasta la lista para hacer uno nuevo (CHAVA).

--->
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfquery name="rsVerificaExistenciaVend" datasource="#session.dsn#">
	select count(1) as Cantidad
	from RolEmpleadoSNegocios
	where Ecodigo = #Session.Ecodigo#
	  and RESNtipoRol = 2
</cfquery>
<cfset regresa = 'listaDocumentosCC.cfm?'>
<cfif isdefined('form.tipo')>
	<cfset regresa = regresa & 'tipo=#form.tipo#'>
</cfif>
<cfif isdefined('form.Filtro_CCTdescripcion')>
	<cfset regresa = regresa & '&Filtro_CCTdescripcion=#form.Filtro_CCTdescripcion#'>
</cfif>
<cfif isdefined('form.Filtro_EDdocumento')>
	<cfset regresa = regresa & '&Filtro_EDdocumento=#form.Filtro_EDdocumento#'>
</cfif>
<cfif isdefined('form.Filtro_EDFecha')>
	<cfset regresa = regresa & '&Filtro_EDFecha=#form.Filtro_EDFecha#'>
</cfif>
<cfif isdefined('form.Filtro_EDUsuario')>
	<cfset regresa = regresa & '&Filtro_EDUsuario=#form.Filtro_EDUsuario#'>
</cfif>
<cfif isdefined('form.Filtro_Mnombre')>
	<cfset regresa = regresa & '&Filtro_Mnombre=#form.Filtro_Mnombre#'>
</cfif>
<cfif isdefined('form.Filtro_CCTdescripcion')>
	<cfset regresa = regresa & '&hFiltro_CCTdescripcion=#form.Filtro_CCTdescripcion#'>
</cfif>
<cfif isdefined('form.Filtro_EDdocumento')>
	<cfset regresa = regresa & '&hFiltro_EDdocumento=#form.Filtro_EDdocumento#'>
</cfif>
<cfif isdefined('form.Filtro_EDFecha')>
	<cfset regresa = regresa & '&hFiltro_EDFecha=#form.Filtro_EDFecha#'>
</cfif>
<cfif isdefined('form.Filtro_EDUsuario')>
	<cfset regresa = regresa & '&hFiltro_EDUsuario=#form.Filtro_EDUsuario#'>
</cfif>
<cfif isdefined('form.Filtro_Mnombre')>
	<cfset regresa = regresa & '&hFiltro_Mnombre=#form.Filtro_Mnombre#'>
</cfif>
<cfif isdefined('form.Filtro_FechasMayores')>
	<cfset regresa = regresa & '&Filtro_FechasMayores=#form.Filtro_FechasMayores#'>
</cfif>
<cfif isdefined('form.Pagina')>
	<cfset regresa = regresa & '&Pagina=#form.Pagina#'>
</cfif>

<cfparam name="varTipoIEPS" default= 0>
<cfparam name="varIEscalonado" default= 0>
<cfparam name="varIEPSValCal" default= 0>

<cfquery name="rsTransacciones" datasource="#Session.DSN#">
	select 	a.CCTcodigo,
			case when coalesce(a.CCTvencim,0) < 0 then <cf_dbfunction name="sPart" args="a.CCTdescripcion,1,10"> #_Cat# ' (contado)' else <cf_dbfunction name="sPart" args="a.CCTdescripcion,1,20"> end as CCTdescripcion,

			case when coalesce(a.CCTvencim,0) >= 0 then 1 else 2 end as CCTorden,
			a.CCTtipo
	<cfif isdefined("form.CCTcodigo") and (isdefined("form.SNcodigo") and len(trim(form.SNcodigo)))>
			, case when ctas.CFcuenta is null
				then
					(
						select rtrim(CFformato)
						  from CFinanciera
						 where CFcuenta = n.CFcuentaCxC
					)
				else
					(
						select min(rtrim(CFformato))
						  from CFinanciera
						 where CFcuenta = ctas.CFcuenta
					)
				end
			as CFformato
			, case when ctas.CFcuenta is null
				then
					(
						select min(CFdescripcion)
						  from CFinanciera
						 where CFcuenta = n.CFcuentaCxC
					)
				else
					(
						select min(CFdescripcion)
						  from CFinanciera
						 where CFcuenta = ctas.CFcuenta
					)
				end
			as CFdescripcion
			, case when ctas.CFcuenta is null
				then n.SNcuentacxc
				else
					(
						select Ccuenta
						  from CFinanciera
						 where CFcuenta = ctas.CFcuenta
					)
				end
			as Ccuenta
	  from CCTransacciones a
	  	 inner join SNegocios n
		 	 on n.Ecodigo 	= #session.Ecodigo#
			and n.SNcodigo 	= #form.SNcodigo#
	  	 left join SNCCTcuentas ctas
		 	 on ctas.Ecodigo 	= #session.Ecodigo#
			and ctas.SNcodigo 	= #form.SNcodigo#
			and ctas.CCTcodigo 	= a.CCTcodigo
	<cfelse>
	  from CCTransacciones a
	</cfif>
	 where a.Ecodigo =  #Session.Ecodigo#
	   and a.CCTtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.tipo#"><!--- 'D' --->
	   and coalesce(a.CCTpago,0) != 1 and coalesce(a.CCTanticipo,0) != 1
	   and NOT a.CCTdescripcion like '%Tesorer_a%'
	   and CCTtranneteo = 0
	order by case when coalesce(a.CCTvencim,0) >= 0 then 1 else 2 end, a.CCTcodigo
</cfquery>
<cfquery name="rsCuentaCaja" datasource="#Session.DSN#">
	select Pvalor as Ccuenta
	  from Parametros
 	 where Ecodigo = #session.Ecodigo#
	   and Pcodigo = 350
</cfquery>
<cfif rsCuentaCaja.recordcount EQ 0>
	<cfset MSG_CtaCajaCxC = t.Translate('MSG_CtaCajaCxC','La Cuenta de Caja CxC no esta definida, debe ser definida en Cuentas Contables de Operación')>
	<cf_errorCode	code = "50182" msg = "#MSG_CtaCajaCxC#">
</cfif>
<cfquery name="rsCuentaCaja" datasource="#Session.DSN#">
	select Ccuenta, rtrim(CFformato) as CFformato, CFdescripcion
	  from CFinanciera
	 where CFcuenta =
	 	(
			select min(CFcuenta)
			  from CFinanciera
			 where Ccuenta = #rsCuentaCaja.Ccuenta#
		)
</cfquery>
<cfquery name="rsaIVAC" datasource="#session.dsn#">
	select afectaIVA From Conceptos where Ecodigo = #session.Ecodigo#
</cfquery>



<cfquery name="rsPintaCuentaParametro" datasource="#session.DSN#">
	select Pcodigo, Pvalor, Pdescripcion
	from  Parametros
	where Ecodigo =  #Session.Ecodigo#
	and Pcodigo =2
</cfquery>

<cfset LvarSNid = -1>
<cfif isdefined('Form.SNnumero') and len(trim(Form.SNnumero))
	and isdefined('form.id_direccionFact') and LEN(TRIM(form.id_direccionFact))>
	<cfquery name="rsSociosN"	 datasource="#session.DSN#">
		select a.SNcodigo, a.SNid, a.SNnombre, a.SNidentificacion, a.SNnumero, a.DEidVendedor, a.DEidCobrador, a.SNcuentacxc, a.SNvenventas,
				SNDCFcuentaCliente
		from SNegocios a
			inner join EstadoSNegocios b
			   on a.ESNid = b.ESNid
			left join SNDirecciones c
			   on c.SNid = a.SNid
			  and c.id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccionFact#">
		where a.Ecodigo =  #Session.Ecodigo#
		  and a.SNnumero = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNnumero#">
	</cfquery>
	<cfset LvarSNid = rsSociosN.SNid>
<cfelseif isdefined('Form.SNnumero') and len(trim(Form.SNnumero))>
	<cfquery name="rsSociosN" datasource="#session.DSN#">
		select SNcodigo, SNid, SNnombre, SNidentificacion, SNnumero, DEidVendedor, DEidCobrador, SNcuentacxc, SNvenventas
		from SNegocios a, EstadoSNegocios b
		where a.Ecodigo =  #Session.Ecodigo#
		  and a.ESNid = b.ESNid
		  and a.SNnumero = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNnumero#">
	</cfquery>
	<cfset LvarSNid = rsSociosN.SNid>
</cfif>

<cfif isdefined('Form.SNnumero') and LEN(trim(Form.SNnumero)) >

	<cfquery datasource="#session.dsn#" name="direcciones">
		select b.id_direccion, <cf_dbfunction name="concat" args="c.direccion1,'/',c.direccion2 "> as texto_direccion
			,case when b.SNDCFcuentaCliente is null
				then
					(
						select min(rtrim(Cformato))
						  from CContables
						 where Ccuenta = a.SNcuentacxc
					)
				else
					(
						select rtrim(Cformato)
						from CContables
						where Ccuenta = b.SNDCFcuentaCliente
					)
				end
			as CFformato
			, case when b.SNDCFcuentaCliente is null
				then
					(
						select Cdescripcion
						  from CContables
						 where Ccuenta = a.SNcuentacxc
					)
				else
					(
						select Cdescripcion
						from CContables
						where Ccuenta = b.SNDCFcuentaCliente
					)
				end
			as CFdescripcion
			, case when b.SNDCFcuentaCliente is null
				then
					a.SNcuentacxc
				else
					b.SNDCFcuentaCliente
				end
			as Ccuenta

		from SNegocios a
			join SNDirecciones b
				on a.SNid = b.SNid
			join DireccionesSIF c
				on c.id_direccion = b.id_direccion
		where a.Ecodigo =  #Session.Ecodigo#
		  and a.SNnumero = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNnumero#">
	</cfquery>
<cfelse>
	<cfset direcciones = QueryNew('id_direccion,Direccion')>
</cfif>

<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select Mcodigo from Empresas
	where Ecodigo =  #Session.Ecodigo#
</cfquery>

<cfquery name="rsOficinas" datasource="#Session.DSN#">
	select Ocodigo, Odescripcion from Oficinas
	where Ecodigo =  #Session.Ecodigo#
	order by case when Ocodigo = '0' then concat(Ocodigo,Odescripcion) else Odescripcion end
</cfquery>

<cfif isdefined("rsSociosN") and rsSociosN.recordcount EQ 1 and rsSociosN.SNcuentacxc EQ ''>
	<cfset MSG_CtaSN = t.Translate('MSG_CtaSN','La cuenta para el Socio de Negocios debe ser definida')>
	<cf_errorCode	code = "50183" msg = "#MSG_CtaSN#.">
</cfif>

<cfquery name="rsCuentas" datasource="#Session.DSN#">
	select Ccuenta, <cf_dbfunction name="concat" args="ltrim(rtrim(Cformato)),' ',Cdescripcion"> as Cdescripcion
	from CContables
	where Ecodigo =  #Session.Ecodigo#
	  and Cmovimiento = 'S'
	  and Mcodigo = 2
	  <cfif isdefined("rsSociosN") and rsSociosN.recordcount EQ 1 and rsSociosN.SNcuentacxc GT 0>
		  and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSociosN.SNcuentacxc#">
	  </cfif>
	order by Ccuenta
</cfquery>
<!----------------------- IMPUESTOS ------------------------------->
<cfquery name="rsImpuestos" datasource="#Session.DSN#">
	select 	Icodigo, Idescripcion, ieps, TipoCalculo, IEscalonado, ValorCalculo
	from 	Impuestos
	where Ecodigo =  #Session.Ecodigo#
	order by Idescripcion
</cfquery>

<!---<cfquery name="rsRetenciones1" datasource="#Session.DSN#">
	select * from Retenciones
	where Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>--->

<cfquery name="rsRetenciones1" datasource="#Session.DSN#">
	select Icodigo as Rcodigo, IDescripcion as RDescripcion from Impuestos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and IRetencion = 1
</cfquery>

<cfquery name="rsRetenciones" datasource="#Session.DSN#">
	select Rcodigo, Rdescripcion from Retenciones
	where Ecodigo =  #Session.Ecodigo#
	order by Rdescripcion
</cfquery>

<!---<cfquery name="rsFechaHoy" datasource="#Session.DSN#">
	select getdate() as Fecha
</cfquery>
--->
<cfquery name="rscArticulos" datasource="#Session.DSN#">
	select count(1) as cant from Articulos where Ecodigo = #Session.Ecodigo#
</cfquery>
<cfquery name="rscConceptos" datasource="#Session.DSN#">
	select count(1) as cant from Conceptos where Ecodigo = #Session.Ecodigo#
</cfquery>

<cfif modo EQ "ALTA">
	<cfset TCsug = structNew()>
	<cfset TCsug.TCcompra = 1>
<cfelse>
	<cfquery name="rsAlmacenes" datasource="#Session.DSN#">
		select Aid, Bdescripcion from Almacen
		where Ecodigo =  #Session.Ecodigo#
		order by Bdescripcion
	</cfquery>

	<cfquery name="rsDepartamentos" datasource="#Session.DSN#">
		select Dcodigo, Ddescripcion from Departamentos
		where Ecodigo =  #Session.Ecodigo#
		order by Ddescripcion
	</cfquery>

	<cfquery name="rsDocumento" datasource="#Session.DSN#">
		select 	EDid, CCTcodigo, EDdocumento, SNcodigo, Mcodigo,
				EDtipocambio, Icodigo, EDdescuento, EDporcdesc, EDimpuesto, EDtotal, EDfecha,
				Ocodigo, Ccuenta, Rcodigo, EDtref, EDdocref, DEidVendedor, DEidCobrador, DEdiasVencimiento,
				DEordenCompra, DEnumReclamo, DEobservacion, ts_rversion,
				id_direccionFact, id_direccionEnvio,TESRPTCid, EDieps, EDMRetencion,
				EDfechaContrarecibo
		from EDocumentosCxC d
		where Ecodigo =  #Session.Ecodigo#
		  and EDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EDid#">
	</cfquery>
	<cfif rsDocumento.recordCount EQ 0>
		<cfset MSG_DoctoNoExiste = t.Translate('MSG_DoctoNoExiste','El documento no existe')>
		<cf_errorCode	code = "50184" msg = "#MSG_DoctoNoExiste#">
	</cfif>

	<cfquery name="TCsug" datasource="#Session.DSN#">
		select tc.Mcodigo, tc.TCcompra
		from Htipocambio tc
		where tc.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		  and tc.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDocumento.Mcodigo#">
		  and tc.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsDocumento.EDfecha#">
		  and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_date" value="#rsDocumento.EDfecha#">
	</cfquery>

	<cfquery name="rsNombreSocio" datasource="#Session.DSN#">
		select SNnombre, SNidentificacion, SNnumero, DEidVendedor, DEidCobrador, SNcuentacxc, SNid
		from SNegocios
		where Ecodigo =  #Session.Ecodigo#
		  and SNcodigo = #rsDocumento.SNcodigo#
	</cfquery>

	<cfquery name="rsNombreTransac" datasource="#Session.DSN#">
		select CCTdescripcion, CCTcodigo
		from CCTransacciones
		where Ecodigo =  #Session.Ecodigo#
		  and CCTcodigo = '#rsDocumento.CCTcodigo#'
	</cfquery>

	<cfquery name="rsCtaDocumento" datasource="#Session.DSN#">
		select Ccuenta, rtrim(CFformato) as CFformato, CFdescripcion
		  from CFinanciera
		 where Ccuenta = #rsDocumento.Ccuenta#
		 order by Ccuenta
	</cfquery>

	<cfquery name="rsCuentaConcepto" datasource="#Session.DSN#">
		select a.Cid, a.Dcodigo,
			a.Ccuenta, b.Cdescripcion, b.Cformato
		from CuentasConceptos a, CContables b
		where a.Ecodigo =  #Session.Ecodigo#
		  and a.Ecodigo = b.Ecodigo
		  and a.Ccuenta = b.Ccuenta
	</cfquery>
	<cf_dbfunction name="concat" args="rtrim(b.CCTcodigo+'-'+rtrim(a.Ddocumento)+'-'+c.Mnombre)" delimiters= "+"  returnvariable="DTM">
	<cfquery name="rsDocRef" datasource="#session.DSN#">
		select a.CCTcodigo as CCTcodigoConlis,a.Ddocumento as EDdocref, a.SNcodigo,
			   #PreserveSingleQuotes(DTM)# as DTM
		from Documentos a, CCTransacciones b, Monedas c
		where a.Ecodigo =  #Session.Ecodigo#
		  and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDocumento.SNcodigo#">
		  and upper(ltrim(rtrim(a.Ddocumento))) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Ucase(trim(rsDocumento.EDdocref))#">
		  and a.Ecodigo = b.Ecodigo
		  and a.CCTcodigo = b.CCTcodigo
		  and a.Ecodigo = c.Ecodigo
		  and a.Mcodigo = c.Mcodigo
	</cfquery>
	<cfif modoDet NEQ "ALTA">
		<cfquery name="rsLinea" datasource="#Session.DSN#">
			select a.EDid,a.DDlinea, t.OCTtipo, oc.OCtipoIC,
				a.Aid,null, a.Cid,
				a.DDdescripcion, a.DDdescalterna, a.DDcantidad, a.DDpreciou,
				a.DDdesclinea, a.DDporcdesclin, isnull(a.DDtotallinea,0) DDtotallinea,
				case
					when a.DDtipo = 'O' and oc.OCtipoIC='V' then 'OV' else a.DDtipo
				end as DDtipo,
				a.DDtipo as DDtipo_OC,
				a.Ccuenta, a.Alm_Aid, a.Dcodigo, a.ts_rversion, a.Icodigo,
				b.Cformato, b.Cdescripcion, a.CFid, CFcodigo as CFcodigoresp, CFdescripcion as CFdescripcionresp,
				a.OCid,a.OCTid, a.OCIid, CodIEPS, isnull(DDMontoIEPS,0) DDMontoIEPS, CodIEPS, afectaIVA, Rcodigo
			from DDocumentosCxC a
				left outer join CContables b
					on a.Ccuenta = b.Ccuenta
				left outer join CFuncional c
					on a.CFid = c.CFid
					and a.Ecodigo = c.Ecodigo
				left outer join OCordenComercial oc
					on oc.OCid = a.CFid
				left outer join OCtransporte t
					on t.OCTid = a.OCTid
			where a.EDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EDid#">
			  and a.DDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DDlinea#">
		</cfquery>

	</cfif>
</cfif>

<cfquery name="rsverCalsificaCC" datasource="#Session.DSN#">
	select Pvalor as verClasificaCC
	from Parametros
	where Ecodigo =  #Session.Ecodigo#
	  and Pcodigo = 680
</cfquery>

<cfif isdefined("rsverCalsificaCC") and  rsverCalsificaCC.Recordcount NEQ 0>
	<cfset verClasCC = rsverCalsificaCC.verClasificaCC>
<cfelse>
	<cfset verClasCC = 0>
</cfif>

<cfquery name="rsCuentaManualCxC" datasource="#Session.DSN#">
    select Pvalor
    from Parametros
    where Ecodigo =  #Session.Ecodigo#
      and Pcodigo = 5400
</cfquery>

<script language="JavaScript" src="../../js/calendar.js"></script>
<script language="JavaScript" src="../../js/utilesMonto.js"></script>
<script language="JavaScript" src="../../js/fechas.js"></script>
<script type="text/javascript" src="/cfmx/sif/js/Macromedia/wddx.js"></script>

<cfset MSG_MontoDig = t.Translate('MSG_MontoDig','El monto digitado debe ser numérico')>
<cfset MSG_TipodeCambio = t.Translate('MSG_TipodeCambio','El tipo de cambio ha sido cambiado. ¿Desea obtener el tipo de cambio histórico?')>
<cfset MSG_DigArt = t.Translate('MSG_DigArt','Debe digitar el artículo')>
<cfset MSG_DigConc = t.Translate('MSG_DigConc','Debe digitar el concepto')>
<cfset MSG_DigDesc = t.Translate('MSG_DigDesc',' Debe digitar la descripción')>
<cfset MSG_AplicDoc = t.Translate('MSG_AplicDoc','Desea aplicar este documento')>
<cfset MSG_AplicRel = t.Translate('MSG_AplicRel',' Desea aplicar y relacionar este documento')>
<cfset LB_Centro_Funcional = t.Translate('LB_Centro_Funcional','Centro Funcional','/sif/generales.xml')>
<cfset LB_CodDocto = t.Translate('LB_CodDocto','Código de Documento')>
<cfset LB_DirEnvio = t.Translate('LB_DirEnvio','Dirección de Envío')>
<cfset LB_DirFact = t.Translate('LB_DirFact','Dirección de Facturación')>
<cfset LB_PagoTerc = t.Translate('LB_PagoTerc','Pagos a terceros')>
<cfset LB_Articulo = t.Translate('LB_Articulo','Artículo')>
<cfset MSG_Descripcion = t.Translate('MSG_Descripcion','Descripción','/sif/generales.xml')>
<cfset LB_CtaDet = t.Translate('LB_CtaDet','Cuenta del Detalle')>
<cfset LB_DescLin = t.Translate('LB_DescLin','Descuento de Línea')>
<cfset MSG_DigFecDocto = t.Translate('MSG_DigFecDocto','Debe de digitar una la fecha del Documento.')>
<cfset MSG_SelOrdCom = t.Translate('MSG_SelOrdCom','Tiene que seleccionar una orden comercial')>
<cfset LB_Barco = t.Translate('LB_Barco','Barco')>
<cfset LB_aereo = t.Translate('LB_aereo','Aéreo')>
<cfset LB_Terrestre = t.Translate('LB_Terrestre','Terrestre')>
<cfset LB_Ferrocarril = t.Translate('LB_Ferrocarril','Ferrocarril')>
<cfset LB_Otro = t.Translate('LB_Otro','Otro')>
<cfset LB_ListaTrans = t.Translate('LB_ListaTrans','Lista de transportes')>
<cfset LB_Concepto = t.Translate('LB_Concepto','Concepto','/sif/generales.xml')>
<cfset LB_Almacen = t.Translate('LB_Almacen','Almac&eacute;n')>
<cfset LB_Articulo = t.Translate('LB_Articulo','Art&iacute;culo')>
<cfset LB_ArtOrCom = t.Translate('LB_ArtOrCom','Artículos de la orden comercial')>
<cfset LB_Codigo = t.Translate('LBR_CODIGO','Código','/sif/generales.xml')>
<cfset LB_CodAlt = t.Translate('LB_CodAlt','Cód. Alterno')>
<cfset LB_Decripcion = t.Translate('LB_Descripcion','Descripci&oacute;n','/sif/generales.xml')>
<cfset LB_ConcIngr = t.Translate('LB_ConcIngr','Concepto Ingreso')>
<cfset LB_Cantidad = t.Translate('LB_Cantidad','Cantidad','RegistroFacturas.xml')>
<cfset LB_DescAlt = t.Translate('LB_DescAlt','Desc. Alterna')>
<cfset LB_PrecioU = t.Translate('LB_PrecioU','Precio Unitario')>
<cfset LB_OrdenCom = t.Translate('LB_OrdenCom','Artículos orden comercial')>
<cfset LB_TpoTrans = t.Translate('LB_TpoTrans','Tipo de Transaccion')>
<cfset LB_TotLin = t.Translate('LB_TotLin','Total de Línea')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_Transaccion = t.Translate('LB_Transaccion','Transacci&oacute;n','/sif/generales.xml')>
<cfset LB_CLIENTE = t.Translate('LB_CLIENTE','Cliente','/sif/generales.xml')>
<cfset LB_Cuenta = t.Translate('LB_Cuenta','Cuenta','/sif/generales.xml')>
<cfset Oficina 		= t.Translate('Oficina','Oficina','/sif/generales.xml')>
<cfset LB_DiasVenc = t.Translate('LB_DiasVenc','D&iacute;as Vencimiento')>
<cfset LB_Moneda = t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset LB_Vencimiento = t.Translate('LB_Vencimiento','Vencimiento')>
<cfset LB_Fecha_Contrarecibo = t.Translate('LB_Fecha_Contrarecibo','Fecha Contrarecibo')>
<cfset LB_Tipo_de_Cambio = t.Translate('LB_Tipo_de_Cambio','Tipo de Cambio','/sif/generales.xml')>
<cfset LB_Vendedor = t.Translate('LB_Vendedor','Vendedor')>
<cfset LB_Referencia = t.Translate('LB_Referencia','Referencia')>
<cfset LB_OrdenCompra = t.Translate('LB_OrdenCompra','Orden de Compra')>
<cfset LB_Observaciones = t.Translate('LB_Observaciones','Observaciones')>
<cfset LB_TimbreFiscal 	= t.Translate('LB_TimbreFiscal','Timbre Fiscal UUID')>
<cfset LB_NoReclamo = t.Translate('LB_NoReclamo','N&uacute;mero de Reclamo')>
<cfset LB_CtoCobroTer = t.Translate('LB_CtoCobroTer','Concepto cobros terceros')>
<cfset LB_DirEnv = t.Translate('LB_DirEnv','Direcci&oacute;n Env&iacute;o')>
<cfset LB_RetPagar = t.Translate('LB_RetPagar','Retenci&oacute;n al Pagar')>
<cfset LB_SinRet = t.Translate('LB_SinRet','Sin Retención')>
<cfset LB_Desc = t.Translate('LB_Desc','Descuento')>
<cfset LB_Impuesto = t.Translate('LB_Impuesto','Impuesto')>
<cfset LB_IVA = t.Translate('LB_IVA','IVA')>
<cfset LB_IEPS = t.Translate('LB_IEPS','IEPS')>
<cfset LB_Detalle = t.Translate('LB_Detalle','Detalle')>
<cfset LB_Retencion = t.Translate('LB_Retencion','Retención')>
<cfset LB_DDtipoA = t.Translate('LB_DDtipoA','A-Artículo de Inventario')>
<cfset LB_DDtipoI = t.Translate('LB_DDtipoI','I-Impuesto Variable')>
<cfset LB_DDtipoIDesc = t.Translate('LB_DDtipoIDesc','Impuesto Variable')>
<cfset LB_DDtipoS = t.Translate('LB_DDtipoS','S-Concepto Servicio o Gasto')>
<cfset LB_DDtipoO = t.Translate('LB_DDtipoO','O-Orden Comercial en Tránsito')>
<cfset LB_DDtipoOV = t.Translate('LB_DDtipoOV','OV-Orden Comercial Venta de Almacén')>
<cfset LB_OrderCom = t.Translate('LB_OrderCom','&Oacute;rden Comercial')>
<cfset LB_Contrato = t.Translate('LB_Contrato','Contrato')>
<cfset LB_Transporte = t.Translate('LB_Transporte','Transporte')>
<cfset LB_OrdernesCom = t.Translate('LB_OrdernesCom','Órdenes Comerciales de Venta Abiertas')>
<cfset LB_Almacen = t.Translate('LB_Almacen','Almacén')>
<cfset BTN_VerCalc = t.Translate('BTN_VerCalc','Ver cálculo')>
<cfset BTN_Aplicar = t.Translate('BTN_Aplicar','Aplicar','/sif/generales.xml')>
<cfset BTN_AplicarRel = t.Translate('BTN_AplicarRel','Aplicar y Relacionar')>
<cfset LB_ElCampo = t.Translate('LB_ElCampo','El campo')>
<cfset LB_DebeSer = t.Translate('LB_DebeSer','debe ser mayor o igual que')>
<cfset LB_Rets = t.Translate('LB_Rets','Retenci&oacute;n')>
<cfset LB_Retenciones = t.Translate('LB_Retenciones','Retenciones')>
<script language="JavaScript1.2">
<cfoutput>
	function validaNumero(dato) {
		if (dato.length > 0) {
			if (ESNUMERO(dato)) {
				return true;
			}
			else {
				alert('#MSG_MontoDig#.');
				return false;
			}
		}
		else {
			alert('#MSG_MontoDig#.');
			return false;
		}
	}

	function validatc(CambioMoneda)
	{
		document.form1.EDtipocambio.disabled = false;
		if (document.form1.Mcodigo.value == document.form1.monedalocal.value)
		{
			document.form1.EDtipocambio.value = "1.0000";
			document.form1.EDtipocambio.disabled = true;
		}
		else
		{
			if (! CambioMoneda && document.form1.EDtipocambio.value != document.form1.TCsug.value)
			{
				if (!confirm('#MSG_TipodeCambio#'))
					return;
			}
			document.form1.EDtipocambio.value = "";
			document.getElementById('ifrTC').src = "SQLRegistroDocumentosCC.cfm?TCsug&EDfecha=" + escape(document.form1.EDfecha.value) + "&Mcodigo=" + document.form1.Mcodigo.value;
		}
<!---
		{
			document.form1.EDtipocambio.value = "";
			<cfwddx action="cfml2js" input="#TCsug#" topLevelVariable="rsTCsug">
			//Verificar si existe en el recordset
			var nRows = rsTCsug.getRowCount();
			if (nRows > 0) {
				for (row = 0; row < nRows; ++row) {
					if (parseInt(rsTCsug.getField(row, "Mcodigo")) == parseInt(document.form1.Mcodigo.value)
						&& parseInt(rsTCsug.getField(row, "Mcodigo")) == parseInt(document.form1.Mcodigo.value)) {
						document.form1.EDtipocambio.value = rsTCsug.getField(row, "TCcompra");
						document.form1.EDtipocambio.value = fm(document.form1.EDtipocambio.value, 4)
						row = nRows;
					}
					else
						document.form1.EDtipocambio.value = "0.0000";
				}
			}
			else
				document.form1.EDtipocambio.value = "0.0000";
		}
--->
	}

	function poneItem() {
		if (document.form1.DDtipo.value == "A"){
			document.getElementById("labelarticulo").style.display = '';
			document.getElementById("labelconcepto").style.display = 'none';
		}

		if (document.form1.DDtipo.value == "S"){
			document.getElementById("labelarticulo").style.display = 'none';
			document.getElementById("labelconcepto").style.display = '';
		}
	}

	function validatcLOAD()
	{
		  <cfif modo EQ "ALTA">
				if (document.form1.Mcodigo.value==document.form1.monedalocal.value)	{
					document.form1.EDtipocambio.value = "1.0000";
					document.form1.EDtipocambio.disabled = true;
				}
				else {
					document.form1.Mcodigo.value=document.form1.monedalocal.value;
					document.form1.EDtipocambio.value = "1.0000";
					document.form1.EDtipocambio.disabled = true;
				}
		   <cfelse>
				if (document.form1.Mcodigo.value==document.form1.monedalocal.value)
					document.form1.EDtipocambio.disabled = true;
				else
					document.form1.EDtipocambio.disabled = false;
		   </cfif>
	}


/////////////////////////////////////////////////////////////////////////////////////////////

var varTipoIEPS =0;
var varIEscalonado =0;
var varIEPSValCal=0;

function ieps(){
  var iI = document.form1.Iieps.value;
  <cfwddx action="cfml2js" input="#rsImpuestos#" topLevelVariable="rsjImpuestos">
  var nRows = rsjImpuestos.getRowCount();
  if (nRows > 0) {
    for (row = 0; row < nRows; ++row) {
      if (rsjImpuestos.getField(row, "Icodigo") == iI){
        varTipoIEPS = rsjImpuestos.getField(row, "TipoCalculo");
        if (rsjImpuestos.getField(row, "IEscalonado") == 1){
        	varIEscalonado = 0;
        }else{
        	varIEscalonado = 1;
	}
        varIEPSValCal = rsjImpuestos.getField(row, "ValorCalculo");
      }
    }
  }
}

//////////////////////////////////////////////////////////////////////////////////////////

	function suma()
	{
		if (document.form1.DDpreciou.value=="" ) document.form1.DDpreciou.value = "0.00";
		if (document.form1.DDdesclinea.value=="")document.form1.DDdesclinea.value = "0.00";
		if (document.form1.DDcantidad.value=="" )document.form1.DDcantidad.value = "0.00";
		if (!document.form1.DDIeps.value)document.form1.DDIeps.value = "0.00";

		if (document.form1.DDpreciou.value=="-" ){
			document.form1.DDpreciou.value = "0.00";
			document.form1.DDtotallinea.value = "0.00";
		}

		if (document.form1.DDdesclinea.value=="-"){
			document.form1.DDdesclinea.value = "0.00";
			document.form1.DDtotallinea.value = "0.00";
		}

		if (document.form1.DDcantidad.value=="-" ){
			document.form1.DDcantidad.value = "0.00";
			document.form1.DDtotallinea.value = "0.00";
		}

		var cantidad = new Number(qf(document.form1.DDcantidad.value));
		var precio = new Number(qf(document.form1.DDpreciou.value));
		var descuento = new Number(qf(document.form1.DDdesclinea.value));
		//var ieps = new Number(qf(document.form1.DDIeps.value));
		var seguir = "si";

		if(cantidad < 0){
			document.form1.DDcantidad.value="0.00";
			seguir = "no";
		}

		if(precio < 0){
			document.form1.DDpreciou.value="0.00";
			seguir = "no";
		}

		if(descuento < 0){
			document.form1.DDdesclinea.value="0.00";
			seguir = "no";
		}

		if(descuento > cantidad*precio){
			ieps();
			document.form1.DDdesclinea.value="0.00";
			if(varTipoIEPS == 1 && varIEPSValCal > 0){
				document.form1.DDtotallinea.value = (cantidad * precio) * (varIEPSValCal/100);
			}else if(varTipoIEPS == 2 && varIEPSValCal > 0){
				document.form1.DDtotallinea.value = (cantidad * precio) + (varIEPSValCal);
			}else{
				document.form1.DDtotallinea.value = cantidad * precio;
		}
		}
		else {
			varTipoIEPS =0;
			varIEscalonado =0;
			varIEPSValCal=0;

			ieps();
			if(varTipoIEPS == 1 && varIEPSValCal > 0){
				document.form1.DDtotallinea.value = redondear((((cantidad * precio) - descuento) * (1+(varIEPSValCal/100))) ,2);
				document.form1.DDtotallinea.value = fm(document.form1.DDtotallinea.value,2);
			}else if(varTipoIEPS == 2 && varIEPSValCal > 0){
				document.form1.DDtotallinea.value = redondear(((cantidad * precio) - descuento) + (varIEPSValCal),2);
				document.form1.DDtotallinea.value = fm(document.form1.DDtotallinea.value,2);
			}else{
				document.form1.DDtotallinea.value = redondear(((cantidad * precio) - descuento),2);
				document.form1.DDtotallinea.value = fm(document.form1.DDtotallinea.value,2);
		}
	}
	}

	function limpiarDetalle() {
		document.form1.OCTid.value="";
		document.form1.OCTtransporte.value="";
		document.form1.OCid.value="";
		document.form1.OCcontrato.value="";
		document.form1.Acodigo.value="";
		document.form1.Adescripcion.value="";
		document.form1.Ccodigo.value="";
		document.form1.Cdescripcion.value="";
		document.form1.DDdescalterna.value="";
		document.form1.DDdescripcion.value="";
		document.form1.Aid.value="";
		document.form1.Cid.value="";
		document.form1.CcuentaD.value = "";
		document.form1.CdescripcionD.value = "";
	}

	var selectTool = (function() {
		var frag = document.createDocumentFragment();
		return {
	    hideOpt: function (selectId, optIndex) {
	      var sel = document.getElementById(selectId);
	      var opt = sel && sel[optIndex];
	      console.log(opt);
	      if (opt) {
	        frag.appendChild(opt);
	      }
	    },
	    showOpt: function (selectId) {
	      var sel = document.getElementById(selectId);
	      var opt = frag.firstChild;
	      if (sel && opt) {
	        sel.appendChild(opt);
	      }
	    }
	  }
	}());
	function cambiarDetalle(){
		var idxV = -1;
		var vDDcantidad = document.getElementById("DDcantidad");
		if(document.form1.DDtipo.value=="I"){
			var slt = document.getElementById('Icodigo');
			if(slt){
			    var x = slt.options.length;
			    for(i = 0; i < x; i++) {
			    	if(trim(slt.options[i].value) == 'IEXE')slt.options[i].disabled = true;
			    }
			}
			//if(idxV > -1) selectTool.hideOpt('Icodigo',idxV);
			document.getElementById('trv').style.display = "none";
			if(vDDcantidad){
				vDDcantidad.value = "1.00";
				vDDcantidad.readOnly = true;
			}
			if (document.form1.CmayorD) {
				document.form1.CmayorD.disabled=true;
				document.form1.CformatoD.disabled=true;
				if(document.getElementById('img_CcuentaD'))
					document.getElementById('img_CcuentaD').style.visibility = "hidden";
			}
			if(document.getElementById('labelDDdesclinea'))
				document.getElementById('labelDDdesclinea').style.visibility = "hidden";
			if(document.getElementById('DDdesclinea'))
				document.getElementById('DDdesclinea').style.visibility = "hidden";
			if(document.getElementById('DDdescripcion'))
				if(document.getElementById('DDdescripcion').value=="")
					<cfoutput> document.getElementById('DDdescripcion').value="#LB_DDtipoIDesc#";</cfoutput>
		}
		else{
			var slt = document.getElementById('Icodigo');
			if(slt){
			    var x = slt.options.length;
			    for(i = 0; i < x; i++) {
			    	if(trim(slt.options[i].value) == 'IEXE')slt.options[i].disabled = false;
			    }
			}
			document.getElementById('trv').style.display = "";
			if(vDDcantidad) vDDcantidad.readOnly = false;
			if(document.getElementById('conlisCuentas'))
				document.getElementById('conlisCuentas').style.visibility = "";
			if(document.getElementById('conlisCuentas'))
				document.getElementById('conlisCuentas').style.visibility = "";
			if (document.form1.CmayorD) {
				document.form1.CmayorD.disabled=false;
				document.form1.CformatoD.disabled=false;
				if(document.getElementById('img_CcuentaD'))
					document.getElementById('img_CcuentaD').style.visibility = "";
			}
			if(document.getElementById('conlisCuentasLabel')){
				document.getElementById('conlisCuentasLabel').style.visibility = "";
			}
			if(document.getElementById('labelDDdesclinea'))
				document.getElementById('labelDDdesclinea').style.visibility = "";
			if(document.getElementById('DDdesclinea'))
				document.getElementById('DDdesclinea').style.visibility = "";
		}
		if(document.form1.DDtipo.value=="A"){
			document.getElementById("AlmacenImput").style.display 	= '';
			document.getElementById("AlmacenLabel").style.display 	= "";
			document.getElementById('articulo').style.display       = '';
			document.getElementById("labelarticulo").style.display  = '';
			if(document.getElementById('conlisCuentasLabel'))
				document.getElementById('conlisCuentasLabel').style.display  = '';
			if(document.getElementById('conlisCuentasLabel'))
				document.getElementById('conlisCuentas').style.display       = '';
			document.getElementById("labelconcepto").style.display 	= 'none';
			document.getElementById('concepto').style.display 		= 'none';
			document.getElementById('articuloOC').style.display     = 'none';
			document.getElementById('ConceptoOCI').style.display     = 'none';
			document.getElementById('TransporteLabel').style.display = 'none';
			document.getElementById('TransporteImput').style.display = 'none';
			document.getElementById('OrdenLabel').style.display 	= 'none';
			document.getElementById('OrdenImput').style.display 	= 'none';
			if (document.form1.CmayorD) {
				document.form1.CmayorD.disabled=true;
				document.form1.CformatoD.disabled=true;
				document.getElementById('img_CcuentaD').style.visibility = "hidden";
			}


			//document.form1.Almacen.focus();
		}
		if(document.form1.DDtipo.value=="S"){
			document.getElementById("labelconcepto").style.display 	= '';
			document.getElementById('concepto').style.display 		= '';
			document.getElementById("AlmacenImput").style.display 	= 'none';
			document.getElementById("AlmacenLabel").style.display 	= 'none';
			document.getElementById('articulo').style.display       = 'none';
			document.getElementById("labelarticulo").style.display  = 'none';
			document.getElementById('articuloOC').style.display     = 'none';
			document.getElementById('ConceptoOCI').style.display     = 'none';
			document.getElementById('TransporteLabel').style.display = 'none';
			document.getElementById('TransporteImput').style.display = 'none';
			document.getElementById('OrdenLabel').style.display 	= 'none';
			document.getElementById('OrdenImput').style.display 	= 'none';
			if(document.getElementById('conlisCuentasLabel'))
				document.getElementById('conlisCuentasLabel').style.display  = '';
			if(document.getElementById('conlisCuentasLabel'))
				document.getElementById('conlisCuentas').style.display       = '';

			if (document.form1.CmayorD) {
				document.form1.CmayorD.disabled=false;
				document.form1.CformatoD.disabled=false;
				document.getElementById('img_CcuentaD').style.visibility = "visible";
			}

			//document.form1.Ccodigo.focus();
		}
		if(document.form1.DDtipo.value=="O"){
			document.getElementById("AlmacenImput").style.display 	= 'none';
			document.getElementById("AlmacenLabel").style.display 	= "none";
			document.getElementById("labelconcepto").style.display 	= 'none';
			document.getElementById('concepto').style.display 		= 'none';
			document.getElementById('articulo').style.display       = 'none';
			document.getElementById("labelarticulo").style.display = '';
			document.getElementById('articuloOC').style.display     = '';
			document.getElementById('ConceptoOCI').style.display     = '';
			document.getElementById('TransporteLabel').style.display = '';
			document.getElementById('TransporteImput').style.display = '';
			document.getElementById('OrdenLabel').style.display 	= '';
			document.getElementById('OrdenImput').style.display 	= '';

			if (document.form1.CmayorD) {
				document.form1.CmayorD.disabled=true;
				document.form1.CformatoD.disabled=true;
				document.getElementById('img_CcuentaD').style.visibility = "hidden";
			}
		}


		if(document.form1.DDtipo.value=="OV"){
			document.getElementById("AlmacenImput").style.display 	= '';
			document.getElementById("AlmacenLabel").style.display 	= "";
			document.getElementById("labelconcepto").style.display 	= 'none';
			document.getElementById('concepto').style.display 		= 'none';
			document.getElementById('articulo').style.display       = 'none';
			document.getElementById("labelarticulo").style.display = '';
			document.getElementById('articuloOC').style.display     = '';
			document.getElementById('ConceptoOCI').style.display     = '';
			document.getElementById('TransporteLabel').style.display = '';
			document.getElementById('TransporteImput').style.display = '';
			document.getElementById('OrdenLabel').style.display 	= '';
			document.getElementById('OrdenImput').style.display 	= '';

			if (document.form1.CmayorD) {
				document.form1.CmayorD.disabled=true;
				document.form1.CformatoD.disabled=true;
				document.getElementById('img_CcuentaD').style.visibility = "hidden";
			}
		}
	}

	function limpiarAxCombo()
	{
	   document.form1.Aid.value =""
	   document.form1.Aid.value=""
	   document.form1.Acodigo.value=""
	   document.form1.Adescripcion.value=""
	   document.form1.DDdescripcion.value=document.form1.Adescripcion.value

	   document.form1.CcuentaD.value = '';
	   document.form1.CmayorD.value = '';
	   document.form1.CformatoD.value = '';
	   document.form1.CdescripcionD.value = '';
	}

	function validaD() {

		if (document.form1.DDtipo.value=="A")
		{
			if (document.form1.Aid.value == "")  {
				alert ("#MSG_DigArt#")
				return false;
			}
		}
		if (document.form1.DDtipo.value=="S")
		{
		   	if (document.form1.Cid.value == "")  {
				alert ("#MSG_DigConc#")
				return false;
			}
		   	if (document.form1.DDdescripcion.value == "" || document.form1.DDdescripcion.value == " ") {
				alert ("#MSG_DigDesc#")
				document.form1.DDdescripcion.focus()
				return false;
		   	}
		}

		var a  = new Number(qf(document.form1.DDtotallinea.value))
			 var b  = new Number(qf(document.form1.DDdesclinea.value))
			 var c  = a + b
			 var porcdesc  = b * 100

			 if(b!=0)
				porcdesc  = porcdesc/c
			 else
				porcdesc = 0

			document.form1.DDporcdesclin.value =  porcdesc;
			document.form1.DDporcdesclin.value = qf(document.form1.DDporcdesclin.value)
			document.form1.DDcantidad.value =  qf(document.form1.DDcantidad.value)
			document.form1.DDpreciou.value =  qf(document.form1.DDpreciou.value)
			document.form1.DDdesclinea.value =  qf(document.form1.DDdesclinea.value)
			document.form1.DDtotallinea.value =  qf(document.form1.DDtotallinea.value)
		document.form1.DDtipo.disabled = false;
		return true;
	}

	function AsignarHiddensEncab() {
		document.form1._EDfecha.value = document.form1.EDfecha.value;
		document.form1._Mcodigo.value = document.form1.Mcodigo.value;
		var estado = document.form1.EDtipocambio.disabled;
		document.form1.EDtipocambio.disabled = false;
		document.form1._EDtipocambio.value = document.form1.EDtipocambio.value;
		document.form1.EDtipocambio.disabled = estado;
		document.form1._Ocodigo.value = document.form1.Ocodigo.value;
		document.form1._Rcodigo.value = document.form1.Rcodigo.value;
		document.form1._EDdescuento.value = document.form1.EDdescuento.value;
		document.form1._Ccuenta.value = document.form1.Ccuenta.value;
		document.form1._EDimpuesto.value = document.form1.EDimpuesto.value;
		document.form1._EDtotal.value = document.form1.EDtotal.value;
	}

	function Postear(tipo){
		var msg;
		if (tipo == 1){
			msg='¿#MSG_AplicDoc#?';
		}else if (tipo==2){
			msg='¿#MSG_AplicRel#?';
		}
		if (confirm(msg)) {
			document.form1.EDtipocambio.disabled = false;
			return true;
		}
		else return false;
	}


	function funcSNcodigo(){
		<cfif isdefined("form.tipo") and len(trim(form.tipo)) and form.tipo eq 'C'> <!--- Notas de Crédito --->
			document.form1.action = 'RegistroNotasCredito.cfm';
		<cfelseif isdefined("form.tipo") and len(trim(form.tipo)) and form.tipo eq 'D'> <!--- Facturas --->
			document.form1.action = 'RegistroFacturas.cfm';
		</cfif>
		document.form1.submit();
	}
</cfoutput>
</script>

<form name="form1" action="SQLRegistroDocumentosCC.cfm" method="post" onSubmit="enableIEPS();">
	<cfif isdefined('rsDocumento') and not isdefined("form.SNnumero")>
	<input type="hidden" name="SNcodigo" value="<cfoutput>#rsDocumento.SNcodigo#</cfoutput>">
	<input type="hidden" name="codIEPSC" value="">
	</cfif>
	<!--- <cfif isdefined("form.SNnumero")>
		<input name="SNnumero" type="hidden" value="#form.SNnumero#">
	</cfif> --->
	<table width="100%" border="0" cellpadding="0" cellspacing="3">
		<tr>
			<td align="right"><cfoutput>#LB_Documento#:&nbsp;</cfoutput></td>
			<td>
				<cfoutput>
				<input name="EDdocumento" <cfif modo NEQ "ALTA"> class="cajasinborde" readonly tabindex="-1" <cfelse>
				tabindex="1"</cfif> type="text"
				value="<cfif modo NEQ "ALTA">#rsDocumento.EDdocumento#<cfelseif isdefined('Form.EDDocumento')>#form.EDDocumento#</cfif>"
				size="28" maxlength="20">
				</cfoutput>
			</td>
			<td> <div align="right"><cfoutput>#LB_Transaccion#</cfoutput> (<cfif form.tipo EQ "C">CR<cfelse>DB</cfif>):&nbsp;</div></td>
			<td style="width: 100px">
				<cfif modo NEQ "ALTA">
					<input type="text" name="CCTdescripcion"
							value="<cfoutput>#rsNombreTransac.CCTcodigo# - #rsNombreTransac.CCTdescripcion#</cfoutput>"
							class="cajasinborde" readonly tabindex="-1"
							size="25" maxlength="80">
					<input name="CCTcodigo" type="hidden" value="<cfoutput>#rsDocumento.CCTcodigo#</cfoutput>" size="20" maxlength="20">
				<cfelse>
					<cfset LvarCCTtipo = "">
					<select name="CCTcodigo" tabindex="1" onChange="sbCCTcodigoOnChange(this.value);">
						<cfoutput query="rsTransacciones">
							<option value="#rsTransacciones.CCTcodigo#"
								<cfif modo NEQ "ALTA" and rsTransacciones.CCTcodigo EQ rsDocumento.CCTcodigo>
									<cfset LvarCCTtipo = rsTransacciones.CCTcodigo>
									selected
								<cfelseif modo EQ 'ALTA' and isdefined('form.CCTcodigo') and rsTransacciones.CCTcodigo EQ form.CCTcodigo>
									<cfset LvarCCTtipo = rsTransacciones.CCTcodigo>
									selected
								<cfelseif LvarCCTtipo EQ "" and rsTransacciones.CCTtipo EQ form.tipo>
									<cfset LvarCCTtipo = rsTransacciones.CCTcodigo>
									selected
								</cfif>
								>#rsTransacciones.CCTcodigo# - #rsTransacciones.CCTdescripcion#
							</option>
						</cfoutput>
					</select>
				</cfif>
			</td>
		</tr>
		<tr>
			<td> <div align="right"><cfoutput>#LB_CLIENTE#:&nbsp;</cfoutput></div></td>
			<td colspan="1">
				<cfif modo NEQ "ALTA" and not isdefined("form.SNidentificacion")>
					<input name="SNnumero" type="text" readonly class="cajasinborde" tabindex="-1"
					  value="<cfoutput>#rsNombreSocio.SNnumero#</cfoutput>" size="10" maxlength="10">
					<input name="SNnombre" type="text" readonly class="cajasinborde" tabindex="-1"
					   value="<cfoutput>#rsNombreSocio.SNnombre#</cfoutput>" size="40" maxlength="255">
				   	<input name="SNidentificacion" type="hidden"
					  value="<cfoutput>#rsNombreSocio.SNidentificacion#</cfoutput>">
				<cfelse>
					<cfif isdefined('form.SNnumero') and LEN(trim(form.SNnumero))>
						<cf_sifSNFactCxC SNtiposocio="C" SNidentificacion ="SNidentificacion" size="50" query="#rsSociosN#" tabindex="1">
					<cfelse>
						<cf_sifSNFactCxC SNtiposocio="C" SNidentificacion ="SNidentificacion" size="50" tabindex="1">
					</cfif>
				</cfif>
			</td>
			<td><div align="right"><cfoutput>#LB_Moneda#:&nbsp;</cfoutput></div></td>
			<td>
				<cfif modo NEQ "ALTA">
					<cf_sifmonedas query="#rsDocumento#" frame="frame2" valueTC="#rsDocumento.EDtipocambio#" onChange="validatc(true);" tabindex="1">
				<cfelse>
					<cf_sifmonedas frame="frame2" onChange="validatc(true);" tabindex="1">
				</cfif>
			</td>
		</tr>
		<tr>
			<td><div align="right"><cfoutput>#LB_Cuenta#:&nbsp;</cfoutput></div></td>
			<td colspan="1">
				<cfoutput>
				<cfif isdefined("rsPintaCuentaParametro") and rsPintaCuentaParametro.Pvalor EQ 'N'>
				<input 	type="hidden" 	name="Ccuenta" 	id="Ccuenta"  	VALUE="<cfif modo NEQ "ALTA">#rsCtaDocumento.Ccuenta#</cfif>">
				<input	type="text"		name="SNCta" 	id="SNCta" 		VALUE="<cfif modo NEQ "ALTA">#TRIM(rsCtaDocumento.CFformato)#  -  #trim(rsCtaDocumento.CFdescripcion)#</cfif>"
						size="70" style="border:none;" readonly="yes" tabindex="1">
				<cfelse>
                	<cfif modo NEQ "ALTA">
						<cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#rsDocumento#" auxiliares="N" movimiento="S" tabindex="1"
									cmayor="cmayor" ccuenta="Ccuenta" cdescripcion="Cfdescripcion" cformato="Cformato">
					<cfelse>
						<cf_cuentas Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" tabindex="1"
									cmayor="cmayor" ccuenta="Ccuenta" cdescripcion="Cfdescripcion" cformato="Cformato">
					</cfif>
				</cfif>
				</cfoutput>
			</td>
			<td nowrap align="right" <cfif form.tipo NEQ "D">valign="top" </cfif>><cfoutput>#LB_Tipo_de_Cambio#:&nbsp;</cfoutput></td>
			<td>
				<cfoutput>
					<input type="hidden" name="TCsug" id="TCsug" value="#numberFormat(TCsug.TCcompra,',9.0000')#">
					<input name="EDtipocambio" type="text" tabindex="<cfif modo NEQ 'ALTA'>-1<cfelse>2</cfif>"
				    onChange="javascript:fm(this,4);"
					onBlur="javascript: fm(this,4);"
					onkeyup="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}"
					onFocus="javascript:if(!document.form1.EDtipocambio.disabled) document.form1.EDtipocambio.select();"
					style="text-align:right"
					value="<cfif modo NEQ "ALTA">#LSCurrencyFormat(rsDocumento.EDtipocambio,'none')#<cfelseif modo EQ 'ALTA' and isdefined('Form.EDtipocambio')>#form.EDtipocambio#<cfelse>0.00</cfif>"
					size="15" maxlength="10">
				</cfoutput>
			</td>
		</tr>
		<tr>
			<cfif form.tipo NEQ "D">
				<td align="right"><cfoutput>#Oficina#:&nbsp;</cfoutput></td>
				<td>
					<select name="Ocodigo" tabindex="1">
						<cfoutput query="rsOficinas">
							<option value="#rsOficinas.Ocodigo#"
								<cfif modo NEQ "ALTA" and rsOficinas.Ocodigo EQ rsDocumento.Ocodigo>
									selected
								<cfelseif modo EQ 'ALTA' and isdefined('Form.Ocodigo') and rsOficinas.Ocodigo EQ Form.Ocodigo>
									selected</cfif>>
								#rsOficinas.Odescripcion#
							</option>
						</cfoutput>
					</select>
				</td>
			<cfelse>
				<td align="right" nowrap><cfif form.tipo EQ "D"><cfoutput>#LB_DiasVenc#:&nbsp;</cfoutput></cfif></td>
				<td><cfif form.tipo EQ "D">
					<cfoutput>
					<input name="DEdiasVencimiento" type="text" align="right" size="10" tabindex="1"
					onChange="javascript: FuncVenc(this);"
					value="<cfif modo NEQ "ALTA">#rsDocumento.DEdiasVencimiento#<cfelseif isdefined('rsSociosN') and rsSociosN.SNvenventas GT 0>#rsSociosN.SNvenventas#<cfelse><cfoutput>0</cfoutput></cfif>">
					</cfoutput></cfif>
				</td>
				<cfif form.tipo NEQ "D">
					<td>&nbsp;</td>
					<td nowrap>&nbsp;</td>
				<cfelse>
					<td align="right" nowrap><cfif form.tipo EQ "D"><cfoutput>#LB_OrdenCompra#:&nbsp;</cfoutput></cfif></td>
					<td><cfif form.tipo EQ "D"><cfoutput>
						<input name="DEordenCompra" type="text" align="right" size="20" tabindex="1"
						value="<cfif modo NEQ "ALTA">#rsDocumento.DEordenCompra#<cfelseif modo EQ 'ALTA' and isdefined('Form.DEordenCompra') and LEN(Form.DEordenCompra) GT 0>#form.DEordenCompra#<cfelse></cfif>"></cfoutput></cfif>
					</td>
				</cfif>
			</cfif>
		</tr>
		<tr nowrap="nowrap">
			<td align="right"><cfoutput>#LB_Fecha#:&nbsp;</cfoutput></td>
			<td nowrap>
				<table border="0">
					<tr>
						<td>
							<cfif modo NEQ 'ALTA'>
								<cf_sifcalendario name="EDfecha" value="#DateFormat(rsDocumento.EDfecha,'dd/mm/yyyy')#"
									tabindex="1" onChange="FuncVenc(this);validatc(false);" onBlur="FuncVenc(this);">
							<cfelse>

								<cf_sifcalendario name="EDfecha" value="#DateFormat(Now(),'dd/mm/yyyy')#"
									onChange="FuncVenc(this);validatc(false);" onBlur="FuncVenc(this);" tabindex="1">
							</cfif>
						</td>
						<td>
							&nbsp;
							<cfif form.tipo EQ "D"><cfoutput>#LB_Vencimiento#:&nbsp;</cfoutput></cfif>
							<cfif form.tipo EQ "D">
								<cfoutput>
									<cfif isdefined('rsDocumento') and rsDocumento.RecordCount GT 0 and rsDocumento.DEdiasVencimiento GT 0>
										<cfset FechaV = DateAdd('d',#rsDocumento.DEdiasVencimiento#,#LSParseDateTime(rsDocumento.EDfecha)#)>
										<cfif len(rsDocumento.EDfechaContrarecibo)>
										  <cfset FechaV = DateAdd('d',#rsDocumento.DEdiasVencimiento#,#LSParseDateTime(rsDocumento.EDfechaContrarecibo)#)>
										</cfif>
									<cfelseif isdefined('rsSociosN') and isdefined('form.SNnumero')
											  and modo EQ 'ALTA' and rsSociosN.SNvenventas GTE 0>
									  <cfif isdefined('form.fechaContrarecibo') and form.fechaContrarecibo NEQ ''>
											<cfset FechaV = DateAdd('d',#rsSociosN.SNvenventas#,#LSParseDateTime(form.fechaContrarecibo)#)>
										<cfelseif isdefined('form.EDfecha') and form.EDfecha NEQ ''>
											<cfset FechaV = DateAdd('d',#rsSociosN.SNvenventas#,#LSParseDateTime(form.EDfecha)#)>
										<cfelse>
											<cfset FechaV = DateAdd('d',#rsSociosN.SNvenventas#+1,#Now()#)>
										</cfif>
									<cfelse>
										<cfset FechaV = Now()>
									</cfif>
									<input name="FechaVencimiento" type="text" readonly  size="10" tabindex="-1"
										value="<cfif isdefined('FechaV')>#LSDateFormat(FechaV,'dd/mm/yyyy')#<cfelse></cfif>">
								</cfoutput>
							</cfif>
						</td>
					</tr>
				</table>
			</td>
			<cfif form.tipo EQ "D">
				<td align="right"><cfoutput>#LB_NoReclamo#:&nbsp;</cfoutput></td>
				<td><cfoutput>
					<input name="DEnumReclamo" type="text" align="right" size="20" tabindex="1"
					value="<cfif modo NEQ "ALTA">#rsDocumento.DEnumReclamo#<cfelseif modo EQ 'ALTA' and isdefined('Form.DEnumReclamo')>#form.DEnumReclamo#<cfelse></cfif>"></cfoutput>
			</td>
			</cfif>
		</tr>
		<cfif form.tipo EQ "D">
			<tr nowrap="nowrap">
				<td align="right"><cfoutput>#LB_Fecha_Contrarecibo#:&nbsp;</cfoutput></td>
				<td nowrap>
				    <cfif isdefined('rsDocumento') and rsDocumento.RecordCount GT 0 and rsDocumento.DEdiasVencimiento GT 0>
							<cf_sifcalendario name="fechaContrarecibo" value="#LSDateFormat(rsDocumento.EDfechaContrarecibo,'dd/mm/yyyy')#"
							  onChange="FuncVenc(this);validatc(false);" onBlur="FuncVenc(this);" tabindex="1">
						<cfelse>
						  <cf_sifcalendario name="fechaContrarecibo" value=""
							  onChange="FuncVenc(this);validatc(false);" onBlur="FuncVenc(this);" tabindex="1">
						</cfif>
				</td>
			</tr>
		</cfif>
		<tr>
			<cfif form.tipo EQ "D">
				<cfif rsVerificaExistenciaVend.Cantidad GT 0>
					<td><div align="right"><cfoutput>#LB_Vendedor#:&nbsp;</cfoutput></div></td>
					<td>
						<cfif modo neq 'ALTA' and LEN(rsDocumento.DEidVendedor) GT 0>
							<cfquery name="rsEmpleado" datasource="#session.DSN#">
								select a.DEid, a.NTIcodigo, a.DEidentificacion,
									<cf_dbfunction name="concat" args="a.DEapellido1,' ',a.DEapellido2,a.DEnombre"> as NombreEmp
								from DatosEmpleado a, RolEmpleadoSNegocios b
								where a.Ecodigo =  #Session.Ecodigo#
								  and a.DEid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDocumento.DEidVendedor#">
								  and a.DEid 	= b.DEid
								  and a.Ecodigo = b.Ecodigo
							</cfquery>
							<cf_rhempleadoCxC rol=2 index=0 query=#rsEmpleado# size=33 tabindex="1">
						<cfelse>
							<cfif isdefined('Form.SNidentificacion') and LEN(SNidentificacion) GT 0
								and modo EQ 'ALTA' and LEN(rsSociosN.DEidVendedor) GT 0>
								<cfquery name="rsEmpleado" datasource="#session.DSN#">
									select a.DEid, a.NTIcodigo, a.DEidentificacion,
										<cf_dbfunction name="concat" args="a.DEapellido1+' , '+a.DEapellido2+a.DEnombre" delimiters="+"> as NombreEmp
									from DatosEmpleado a, RolEmpleadoSNegocios b
									where a.Ecodigo =  #Session.Ecodigo#
									  and a.DEid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSociosN.DEidVendedor#">
									  and a.DEid 	= b.DEid
									  and a.Ecodigo = b.Ecodigo
								</cfquery>
								<cf_rhempleadoCxC rol=2 index=0 size=33 query="#rsEmpleado#" tabindex="1">
							<cfelse>
								<cf_rhempleadoCxC rol=2 index=0 size=33 tabindex="1">
							</cfif>
						</cfif>
					</td>
				<cfelse>
					<td>&nbsp;</td><td>&nbsp;</td>
				</cfif>
			<cfelse>
			<td><div align="right"><cfoutput>#LB_Referencia#:&nbsp;</cfoutput></div></td>
			<td>
				<cfif modo NEQ "ALTA">
			  		<cf_sifDocsReferenciaCxC query="#rsDocRef#" form="form1" tabindex="2"> <!--- query="#rsDetalle#" --->
				<cfelse>
					<cf_sifDocsReferenciaCxC form="form1" tabindex="1">
				</cfif>
			</td>
		</cfif>
		<td nowrap="nowrap" style="vertical-align:top"><div align="right"><cfoutput>#LB_RetPagar#:&nbsp;</cfoutput></div></td>
					<td align="left" style="vertical-align:top">
						<select name="Rcodigo" tabindex="1">
							<option value="-1" ><cfoutput>-- #LB_SinRet# --</cfoutput></option>
							<cfoutput query="rsRetenciones">
								<option value="#rsRetenciones.Rcodigo#"
									<cfif modo NEQ "ALTA" and rsRetenciones.Rcodigo EQ rsDocumento.Rcodigo>selected
									<cfelseif modo EQ 'ALTA' and isdefined('Form.Rcodigo') and rsRetenciones.Rcodigo EQ Form.Rcodigo> selected
									</cfif>>
									#rsRetenciones.Rdescripcion#
								</option>
							</cfoutput>
						</select>
				</td>

		</tr>
		<tr><cfif form.tipo EQ "D">
			<td align="right"><cfoutput>#Oficina#:&nbsp;</cfoutput></td>
			<td>
				<select name="Ocodigo" tabindex="1">
					<cfoutput query="rsOficinas">
						<option value="#rsOficinas.Ocodigo#"
							<cfif modo NEQ "ALTA" and rsOficinas.Ocodigo EQ rsDocumento.Ocodigo>
								selected
							<cfelseif modo EQ 'ALTA' and isdefined('Form.Ocodigo') and rsOficinas.Ocodigo EQ Form.Ocodigo>
								selected</cfif>>
							#rsOficinas.Odescripcion#
						</option>
					</cfoutput>
				</select>
			</td>
			<cfelse>
				<td align="right" nowrap valign="top"><cfoutput>#LB_Observaciones#:&nbsp;</cfoutput></td>
				<td colspan="3" rowspan="1" valign="top"><textarea name="DEobservacion" id="DEobservacion" maxlength="100"
				    rows="2" tabindex="1"  cols="30" ><cfif modo NEQ 'ALTA'><cfoutput>#rsDocumento.DEobservacion#</cfoutput></cfif></textarea>
				</td>
			</cfif>


		</tr>
	<cfif form.tipo EQ "D">
		<tr>
			<td  align="right"><cfoutput>#LB_CtoCobroTer#:&nbsp;</cfoutput></td>
            <td  colspan="1">
              <cfif modo NEQ "ALTA">
                  <cf_cboTESRPTCid query="#rsDocumento#" tabindex="1" SNid="#rsNombreSocio.SNid#" CxP="no" CxC="yes">
              <cfelse>
                  <cfset form.TESRPTCid = "">
                  <cf_cboTESRPTCid tabindex="1" SNid="#LvarSNid#" CxP="no" CxC="yes">
              </cfif>
            </td>
		</tr>
	</cfif>
		<tr>
			<td align="right"><cfoutput>#LB_DirEnv#:&nbsp;</cfoutput></td>
			<td>
				<select style="width:347px" name="id_direccionEnvio" id="id_direccionEnvio" tabindex="-1">
					<cfoutput query="direcciones">
						<option value="#id_direccion#"
							<cfif modo NEQ 'ALTA' and id_direccion eq rsDocumento.id_direccionEnvio>
							selected
							</cfif>
							<cfif isdefined('form.id_direccionEnvio') and id_direccion eq form.id_direccionEnvio>
							selected
							</cfif>>
							#HTMLEditFormat(texto_direccion)#
						</option>
					</cfoutput>
				</select>
			</td>
			<td colspan="2" rowspan="4">
				<table style="width:70%" align="right" cellpadding="0" cellspacing="1" frame="box">
				<tr>
						<td><div align="right"><cfoutput>#LB_Desc#:&nbsp;</cfoutput></div></td>
						<td align="right"><cfoutput>
							<input name="EDdescuento" tabindex="1" type="text" style="text-align:right"
								   onFocus="javascript:document.form1.EDdescuento.select();"
								   onChange="javascript:fm(this,2);"
								   onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
								   value="<cfif modo NEQ "ALTA">#LSCurrencyFormat(rsDocumento.EDdescuento,'none')#<cfelseif modo EQ 'ALTA' and isdefined('form.EDdescuento')>#form.EDdescuento#<cfelse>0.00</cfif>"
								   size="17" maxlength="15"></cfoutput>
						</td>
					</tr>
					<tr>
						<td valign="top"><div align="right"><cfoutput>#LB_IEPS#:&nbsp;</cfoutput></div></td>
						<td align="right" valign="top">
							<input name="EDieps" type="text" style="text-align:right" onChange="javascript: fm(this,2);"
								class="cajasinborde" readonly tabindex="-1"
								value="<cfif modo NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsDocumento.EDieps,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>"
								size="15" maxlength="15">
						</td>
					</tr>
					<tr>
						<td align="right"><cfoutput>#LB_Rets#:&nbsp;</cfoutput></td>
						<td align="right" valign="top">
							<input name="EDMRetencion" type="text" style="text-align:right" onChange="javascript: fm(this,2);"
								class="cajasinborde" readonly tabindex="-1"
								value="<cfif modo NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsDocumento.EDMRetencion,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>"
								size="15" maxlength="15">
						</td>
					</tr>
					<tr>
						<td valign="top"><div align="right"><cfoutput>#LB_IVA#:&nbsp;</cfoutput></div></td>
						<td align="right" valign="top">
							<input name="EDimpuesto" type="text" style="text-align:right" onChange="javascript: fm(this,2);"
								class="cajasinborde" readonly tabindex="-1"
								value="<cfif modo NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsDocumento.EDimpuesto,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>"
								size="15" maxlength="15">
						</td>
					</tr>
					<tr>
						<td><div align="right">Total:&nbsp;</div></td>
						<td align="right"> <cfoutput>
							<input name="EDtotal" type="text" style="text-align:right" onChange="javascript: fm(this,2);"
								class="cajasinborde" readonly tabindex="-1"
								value="<cfif modo NEQ "ALTA">#LSCurrencyFormat(rsDocumento.EDtotal,'none')#<cfelse>0.00</cfif>"
								size="15" maxlength="15">
							<input type="hidden" name="tipo" value="#form.tipo#">
							<input type="hidden" name="monedalocal" value="#rsMonedaLocal.Mcodigo#">
							<input type="hidden" name="EDporcdesc" value="<cfif modo NEQ "ALTA">#rsDocumento.EDporcdesc#</cfif>">
							<input type="hidden" name="EDid" value="<cfif modo NEQ "ALTA">#rsDocumento.EDid#</cfif>">

							<cfset tsE = "">
							<cfif modo NEQ "ALTA">
								<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp"
									arTimeStamp="#rsDocumento.ts_rversion#" returnvariable="tsE">
								</cfinvoke>
							</cfif>
							<input type="hidden" name="timestampE" value="<cfif modo NEQ "ALTA">#tsE#</cfif>">
							<input type="hidden" name="_EDfecha" value="">
							<input type="hidden" name="_Mcodigo" value="">
							<input type="hidden" name="_EDtipocambio" value="">
							<input type="hidden" name="_Ocodigo" value="">
							<input type="hidden" name="_Rcodigo" value="">
							<input type="hidden" name="_EDdescuento" value="">
							<input type="hidden" name="_Ccuenta" value="">
							<input type="hidden" name="_Icodigo" value="">
							<input type="hidden" name="_EDimpuesto" value="">
							<input type="hidden" name="_EDtotal" value="">
							<input type="hidden" name="_EDdocref" value="">
							<input type="hidden" name="_EDtref" value="">
							<input type="hidden" name="_DEdiasVencimiento" value="">
							<input type="hidden" name="_DEidVendedor" value="">
							<input type="hidden" name="_DEidComprador" value="">
							<input type="hidden" name="_DEordenCompra" value="">
							<input type="hidden" name="_DEnumReclamo" value="">
							<input type="hidden" name="_DEobservacion" value=""></cfoutput>
						</td>
					</tr>
			  </table>
			</td>
		</tr>
		<tr>
			<td align="right" nowrap> <cfoutput>#LB_DirFact#:&nbsp;</cfoutput></td>
			<td colspan="1">
				<select style="width:347px" name="id_direccionFact" id="id_direccionFact" tabindex="1" onChange="sbid_direccionFactOnChange(this.value);">
						<cfoutput query="direcciones">
							<option value="#id_direccion#"
								<cfif modo NEQ "ALTA" and id_direccion EQ rsDocumento.id_direccionFact>
									selected
								<cfelseif modo EQ 'ALTA' and isdefined('Form.id_direccionFact') and id_direccion EQ Form.id_direccionFact>
									selected</cfif>>
							#HTMLEditFormat(texto_direccion)#
							</option>
						</cfoutput>
					</select>
			</td>
		</tr>
		<tr>
			<td align="right" nowrap valign="top"><cfif form.tipo EQ "D"><cfoutput>#LB_Observaciones#:&nbsp;</cfoutput></cfif></td>
			<td  rowspan="2">
				<cfif form.tipo EQ "D">
					<textarea name="DEobservacion" id="DEobservacion" rows="2" maxlength="100"
					    tabindex="1" style="width: 100%;"><cfif modo NEQ 'ALTA'><cfoutput>#rsDocumento.DEobservacion#</cfoutput></cfif></textarea>
				</cfif>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
        <!---Timbre Fiscal UUID--->
			<!--- <cfif modo NEQ "ALTA"> --->
            <cfquery name="validaCE" datasource="#session.dsn#">
               select ERepositorio from Empresa where Ereferencia=#session.Ecodigo#
            </cfquery>
            <cfif isdefined('validaCE') and validaCE.ERepositorio EQ 1>
                <tr>
					<cfif isdefined('Form.EDdocumento')>
						<cfset Documento=Form.EDdocumento>
					<cfelse>
						<cfset Documento="">
					</cfif>
					<td align="right"   nowrap="nowrap" valign="top">
						<cfoutput>
							#LB_TimbreFiscal#:&nbsp;
						</cfoutput>
					</td>
					<td >
						<cfif modo NEQ "ALTA">
							<cf_sifComprobanteFiscal Origen="CCFC" IDdocumento="#Form.EDid#"  Documento="#Documento#" nombre="Timbre" irA="RegistroFacturas.cfm" Form="form1" size="40">
						<cfelse>
							<cf_sifComprobanteFiscal Origen="CCFC" form="form1" nombre="Timbre" modo="alta" size="40">
						</cfif>
                  </td>
                </tr>
                </cfif>
			<!--- </cfif> --->
	</table>


	<cfif modo NEQ "ALTA">
		<cfquery name="rsOC" datasource="#session.DSN#">
			select count(1) as cant
			from Parametros
			where Ecodigo = #session.Ecodigo#
			and Pcodigo = 442
		</cfquery>

		<table style="width:100%" border="0" cellpadding="0" cellspacing="3">
			<tr><td colspan="7" class="tituloAlterno"><cfoutput>#LB_Detalle#</cfoutput></td></tr>
			<tr>
				<td colspan="7">
					Item:&nbsp;
					<!---<cfset form.DDtipo=rsLinea.DDtipo>--->
                    <cfoutput>
					<select name="DDtipo" onChange="javascript:limpiarDetalle();cambiarDetalle();FuncValidaItem();"
						tabindex="1" <cfif modoDet neq 'ALTA'>disabled</cfif> >
						<cfif rscArticulos.cant GT 0>
							<option value="A" <cfif modoDet EQ "CAMBIO" and trim(rsLinea.DDtipo) EQ "A">selected disabled</cfif>>#LB_DDtipoA#</option>
						</cfif>
						<cfif rscConceptos.cant GT 0>
							<option value="S" <cfif modoDet EQ "CAMBIO" and trim(rsLinea.DDtipo) EQ 'S'>selected disabled</cfif>>#LB_DDtipoS#</option>
						</cfif>
						<cfif rsOC.cant gt 0>
							<option value="O" <cfif modoDet NEQ "ALTA" and trim(rsLinea.DDtipo) EQ "O">selected disabled</cfif>>#LB_DDtipoO#</option>
							<option value="OV" <cfif modoDet NEQ "ALTA" and trim(rsLinea.DDtipo) EQ "OV">selected disabled</cfif>>#LB_DDtipoOV#</option>
						</cfif>
					</select>
                    </cfoutput>
					<cfif modoDet neq 'ALTA'>
						<input type="hidden" name="DDtipo_hiden" value="<cfoutput>#trim(rsLinea.DDtipo)#</cfoutput>"/>
					</cfif>
				</td>
			</tr>
			<tr id="trv">
				<td   align="left" colspan="7">
					<fieldset>
					<table  align="left" border="0">
						<tr>
						 	<td>
								<img src=""
								width="0" height="25"
								border="0" align="absmiddle">
							</td>
							<!--- ORDEN COMERCIAL --->
							<td align="right"  id="OrdenLabel"  >
								<cfoutput>#LB_OrderCom#:&nbsp;</cfoutput>
							</td>

							<td id="OrdenImput">
								<cfset ArrayOC=ArrayNew(1)>
								<cfif modoDet neq 'ALTA' and rsLinea.DDtipo_OC EQ "O" and len(trim(rsLinea.OCid))>
									<cfquery name="rsORdenComercial" datasource="#session.DSN#">
										select OCid,OCcontrato
										from OCordenComercial where
										Ecodigo =	 #Session.Ecodigo#
										and OCid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLinea.OCid#">

									</cfquery>
									<cfset ArrayAppend(ArrayOC,rsORdenComercial.OCid)>
									<cfset ArrayAppend(ArrayOC,rsORdenComercial.OCcontrato)>
								</cfif>
									<input name="OAA" value="-1" type="hidden">
								<script language="javascript" type="text/javascript">
									function FuncValidaItem (){
										if (document.form1.DDtipo.selectedIndex==3){
											document.form1.OAA.value = 'V';<!--- OV --->
											}
										else{
												if (document.form1.DDtipo.selectedIndex==2){
												document.form1.OAA.value = 'C';<!--- O --->
												}
											}
									}
								</script>
								<cf_conlis
											Campos="OCid,OCcontrato"
											Desplegables="N,S"
											Modificables="N,S"
											Size="0,20"
											tabindex="2"
											ValuesArray="#ArrayOC#"
											Title="#LB_OrdernesCom#"
											Tabla="OCordenComercial"
											Columnas="OCid,OCcontrato,OCfecha"
											Filtro=" Ecodigo = #Session.Ecodigo#
													and OCestado = 'A'
													and OCtipoOD = 'D'
													and OCtipoIC = $OAA,char$

													order by OCfecha"
											Desplegar="OCcontrato,OCfecha"
											Etiquetas="#LB_Contrato#,#LB_Fecha#"
											filtrar_por="OCcontrato,OCfecha"
											Formatos="S,D"
											Align="left,left"
											Asignar="OCid,OCcontrato"
											Asignarformatos="S,S"/>

						 	</td>
							<!--- TRANSPORTE --->
							<td align="right" id="TransporteLabel">
								<cfoutput>#LB_Transporte#:&nbsp;</cfoutput>
							</td>

							<td id="TransporteImput" nowrap="nowrap">
                            	<cfoutput>
								<select id="OCTtipo" name="OCTtipo" >
									<option value="">(Tipo Transporte)</option>
									<option value="B" <cfif modoDet NEQ "ALTA" and isdefined("rsLinea.OCTtipo") and rsLinea.OCTtipo EQ "B">selected</cfif>>#LB_Barco#</option>
									<option value="A" <cfif modoDet NEQ "ALTA" and isdefined("rsLinea.OCTtipo") and rsLinea.OCTtipo EQ "A">selected</cfif>>#LB_aereo#</option>
									<option value="T" <cfif modoDet NEQ "ALTA" and isdefined("rsLinea.OCTtipo") and rsLinea.OCTtipo EQ "T">selected</cfif>>#LB_Terrestre#</option>
									<option value="F" <cfif modoDet NEQ "ALTA" and isdefined("rsLinea.OCTtipo") and rsLinea.OCTtipo EQ "F">selected</cfif>>#LB_Ferrocarril#</option>
									<option value="O" <cfif modoDet NEQ "ALTA" and isdefined("rsLinea.OCTtipo") and rsLinea.OCTtipo EQ "O">selected</cfif>>#LB_Otro#</option>
								</select>
                                </cfoutput>
								<cfif modoDet NEQ "ALTA" and isdefined("rsLinea.OCTid") and len(trim(rsLinea.OCTid))>
									<cfquery name="rsOCtransporte" datasource="#session.DSN#">
										select OCTtransporte from OCtransporte
										where  OCTid  =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLinea.OCTid#">
										and Ecodigo   =   #Session.Ecodigo#
									</cfquery>
								</cfif>
								<cfoutput>
								<input
									type="text"
									name="OCTtransporte"
									value="<cfif modoDet NEQ "ALTA" and isdefined("rsOCtransporte") ><cfoutput>#rsOCtransporte.OCTtransporte#</cfoutput></cfif>"
									size="15" maxlength="20"
									autocomplete="off"
									alt="#LB_Transporte#"
									tabindex="2"
									title="#LB_Transporte#"
									onblur  = "javascript: validaTransporte()">
									</cfoutput>
								<a href="javascript:doConlisTransporte();" id="imgCcuenta">
									<img src="/cfmx/sif/imagenes/Description.gif"
									alt="#LB_ListaTrans#"
									name="imagentransporte"
									width="18" height="14"
									border="0" align="absmiddle">
								</a>
								<input type="hidden" name="OCTid" tabindex="-1" value="<cfif modoDet NEQ "ALTA" and isdefined("rsLinea.OCTid") and len(trim(rsLinea.OCTid))><cfoutput>#rsLinea.OCTid#</cfoutput></cfif>" />
						  </td>
							<!--- CONCEPTO --->
							<td align="right" id="labelconcepto">
								<cfoutput>#LB_Concepto#:&nbsp;</cfoutput>
							</td>
							<td id="concepto">
								<cfif modoDet neq 'ALTA'>
									<cfquery name="rsConcepto" datasource="#session.DSN#">
										select Cid, Ccodigo, Cdescripcion
										from Conceptos
										where Ecodigo= #Session.Ecodigo#
										and Cid=<cfif trim(rsLinea.DDtipo) eq 'S' and len(trim(rsLinea.Cid))>
													<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLinea.Cid#">
												<cfelse>0</cfif>
									</cfquery>
									<cf_sifconceptos query="#rsConcepto#" size="22" verClasificacion="#verClasCC#" tabindex="2">
								<cfelse>
									<cf_sifconceptos size="22" verClasificacion="#verClasCC#" tabindex="2">
								</cfif>
								<input name="afectaIVAC" id="afectaIVAC" type="hidden" value="">
						  </td>
						 </tr>
						<!--- ALMACEN --->
						<tr>
						 	<td>
								<img src=""
								width="0" height="25"
								border="0" align="absmiddle">
							</td>
							<td align="right"  id="AlmacenLabel">
								<cfoutput>#LB_Almacen#:&nbsp;</cfoutput>
							</td>
							<td id="AlmacenImput" colspan="2">
								<cfif modoDet neq 'ALTA'>
									<cf_sifalmacen id="#rsLinea.Alm_Aid#"  size="14" aid="Almacen" tabindex="2" Acodigo="Acodigo">
								<cfelse>
									<cf_sifalmacen size="15" aid="Almacen" tabindex="2" Acodigo="Acodigo">
							    </cfif>
							</td>
						</tr>
						 <tr>
						 	<td>
								<img src=""
								width="0" height="25"
								border="0" align="absmiddle">
							</td>
							<!--- ARTICULO --->
							<cfoutput><td align="right"  id="labelarticulo">
								#LB_Articulo#:&nbsp;
							</td></cfoutput>
							<td id="articulo">
								<cfif modoDet neq 'ALTA'>
									<cfquery name="rsArticulo" datasource="#session.DSN#">
										select Aid, Acodigo, Adescripcion
										from Articulos
										where Ecodigo= #Session.Ecodigo#
										and Aid=<cfif rsLinea.DDtipo eq 'A'>
													<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLinea.Aid#">
												<cfelse>0</cfif>
									</cfquery>
									<cf_sifarticulos query=#rsArticulo# validarExistencia="1" almacen="Almacen" size="22" tabindex="2" IACcampo="CformatoIngresos" SNid="#rsNombreSocio.SNid#">
								<cfelse>
									<cf_sifarticulos validarExistencia="1" almacen="Almacen" size="22" tabindex="2" IACcampo="CformatoIngresos" SNid="#rsNombreSocio.SNid#">
								</cfif>
							</td>
							<!--- ARTICULO ORDEN COMERCIAL --->
							<td id="articuloOC">
								<cfset ArrayAid=ArrayNew(1)>
								<cfif modoDet neq 'ALTA' and rsLinea.DDtipo_OC EQ "O" and len(trim(rsLinea.Aid))>
									<cfquery name="rsarticuloOC" datasource="#session.DSN#">
										select Aid as AidOD, Acodigo as AcodigoOD, Adescripcion  as AdescripcionOD
										  from Articulos
										 where Ecodigo 	=  #Session.Ecodigo#
										   and Aid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLinea.Aid#">
									</cfquery>
									<cfset ArrayAppend(ArrayAid,rsarticuloOC.AidOD)>
									<cfset ArrayAppend(ArrayAid,rsarticuloOC.AcodigoOD)>
									<cfset ArrayAppend(ArrayAid,rsarticuloOC.AdescripcionOD)>
								</cfif>

								<cf_conlis
								Campos="AidOD,AcodigoOD,AdescripcionOD"
								Desplegables="N,S,S"
								ValuesArray="#ArrayAid#"
								Modificables="N,S,N"
								Size="0,15,25"
								tabindex="2"
								Title="#LB_ArtOrCom#"
								Tabla=" OCordenProducto a
										inner join Articulos  b
											on a.Aid = b.Aid
											and a.Ecodigo = b.Ecodigo"
								Columnas="a.Aid as AidOD,b.Acodigo as  AcodigoOD,b.Acodalterno as AcodalternoOD,b.Adescripcion as AdescripcionOD"
								Filtro=" a.Ecodigo = #Session.Ecodigo# and a.OCid = $OCid,numeric$ "
								Desplegar="AcodigoOD,AcodalternoOD,AdescripcionOD"
								Etiquetas="#LB_Codigo#,#LB_CodAlt#,#LB_Decripcion#"
								filtrar_por="b.Acodigo,b.Acodalterno,b.Adescripcion"
								Formatos="S,S,S"
								Align="left,left,left"
								Asignar="AidOD,AcodigoOD,AdescripcionOD"
								funcion="fnOCobtieneCFcuenta()"
								Asignarformatos="S,S,S"/>
							</td>
						<td id="ConceptoOCI" colspan="2">
							<cfoutput>#LB_ConcIngr#:&nbsp;</cfoutput>
							<cfquery name="rsOCconceptoIngreso" datasource="#session.DSN#">
								select OCIid,OCIcodigo,OCIdescripcion
								from OCconceptoIngreso
								where Ecodigo =  #Session.Ecodigo#
								order by OCIcodigo
							</cfquery>
							<cfoutput>
							<select id="OCIid" name="OCIid"
								tabindex="2"
								onchange="GvarOCobtieneCFcuenta=false;"
								onblur="if (! GvarOCobtieneCFcuenta) fnOCobtieneCFcuenta();"
							 >
								<cfloop query="rsOCconceptoIngreso">
									<option value="#rsOCconceptoIngreso.OCIid#"
									<cfif modoDet NEQ "ALTA" and isdefined("rsLinea.OCIid") and rsLinea.OCIid EQ rsOCconceptoIngreso.OCIid>selected</cfif>>#trim(rsOCconceptoIngreso.OCIcodigo)#-#rsOCconceptoIngreso.OCIdescripcion#</option>
								</cfloop>
							</select>
							</cfoutput>
						</td>
						</tr>
					</table>
					</fieldset>
				</td>
			</tr>
				<script>
					 cambiarDetalle();
				</script>
			<tr>
				<td><div align="right"><cfoutput>&nbsp;#LB_Decripcion#:&nbsp;</cfoutput></div></td>
				<td colspan="4">
					<input name="DDdescripcion" tabindex="2" onFocus="javascript:document.form1.DDdescripcion.select();" type="text"
						   value="<cfif modoDet NEQ "ALTA"><cfoutput>#rsLinea.DDdescripcion#</cfoutput></cfif>" size="90"
						   maxlength="90">
				</td>
				<td rowspan="5">
					<table width="100%" frame="box">
						<tr>
				<td><div align="right"><cfoutput>#LB_Cantidad#:&nbsp;</cfoutput></div></td>
							<td style="text-align: right"><cfoutput>
					<input id="DDcantidad" name="DDcantidad" onFocus="javascript:this.value = qf(this.value); this.select();" type="text" tabindex="2"
								   style="text-align:right" onChange="javascript:fm(this,2);suma();calculaIEPS();"
						   onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
						   value="<cfif modoDet NEQ "ALTA">#LSCurrencyFormat(rsLinea.DDcantidad,'none')#<cfelse>0.00</cfif>"
						   size="12" maxlength="12"></cfoutput>
				</td>
			</tr>
				<td nowrap> <div align="right"><cfoutput>#LB_PrecioU#:&nbsp;</cfoutput></div></td>
							<td style="text-align: right"><cfoutput>
					<input name="DDpreciou" onFocus="javascript:this.value = qf(this.value); this.select();" type="text" tabindex="2"
								   style="text-align:right" onChange="javascript:fm(this,2);suma();calculaIEPS();"
						   onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
						   value="<cfif modoDet NEQ "ALTA">#LSCurrencyFormat(rsLinea.DDpreciou,'none')#<cfelse>0.00</cfif>"
						   size="12" maxlength="15"></cfoutput>
				</td>
						<tr>
							<td><div align="right"><cfoutput>#LB_Desc#:&nbsp;</cfoutput></div></td>
							<td style="text-align: right"><cfoutput>
								<input name="DDdesclinea" onFocus="javascript:this.value = qf(this.value); this.select();" type="text" tabindex="2"
								   style="text-align:right"
								   onChange="javascript:fm(this,2);suma();calculaIEPS();"
								   onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
								   value="<cfif modoDet NEQ "ALTA">#LSCurrencyFormat(rsLinea.DDdesclinea,'none')#<cfelse>0.00</cfif>"
								   size="12" maxlength="12"></cfoutput>
							</td>
						</tr>
						<tr>
							<td><div align="right"><cfoutput>#LB_IEPS#:&nbsp;</cfoutput></div></td>
							<td style="text-align: right"><cfoutput>
								<input name="DDIeps" class="cajasinborde" onFocus="javascript:this.value=qf(this.value);this.select();" type="text" tabindex="-1"
								   style="text-align:right; font-weight:normal" onChange="javascript:fm(this,2);suma();"
								   value="<cfif modoDet NEQ "ALTA">#LSCurrencyFormat(rsLinea.DDMontoIEPS,'none')#<cfelse>0.00</cfif>"
								   size="13" maxlength="12" readonly></cfoutput>
							</td>

			</tr>
			<tr>
							<td align="right"><strong>Total:</strong></td>
							<td style="text-align: right"><cfoutput>
								<input name="DDtotallinea" type="text" class="cajasinborde" style="text-align:right"
								   onchange="javascript:fm(this,2);" tabindex="-1" } value="<cfif modoDet NEQ "ALTA">#LSCurrencyFormat(rsLinea.DDtotallinea + rslinea.DDMontoIEPS,'none')#<cfelse>0.00</cfif>"
								   size="11" maxlength="12" readonly>
								<input name="DDlinea" type="hidden" value="<cfif modoDet NEQ "ALTA">#rsLinea.DDlinea#</cfif>">

								<input name="DDporcdesclin" type="hidden" value="<cfif modoDet NEQ "ALTA" and isdefined('rsLinea.DDpordesclin')>#rsLinea.DDporcdesclin	#<	cfelse>0.00</cfif>">
								<cfset tsD = "">
								<cfif modoDet NEQ "ALTA">
									<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsLinea.ts_rversion#"
										returnvariable="tsD">
									</cfinvoke>
								</cfif>
								<input name="timestampD" type="hidden" value="<cfif modoDet NEQ "ALTA">#tsD#</cfif>">
								</cfoutput>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td align="right"><cfoutput>#LB_DescAlt#:&nbsp;</cfoutput></td>
				<td colspan="4">
					<input name="DDdescalterna" tabindex="2" onFocus="javascript:document.form1.DDdescalterna.select();" type="text"
						   value="<cfif modoDet NEQ "ALTA"><cfoutput>#rsLinea.DDdescalterna#</cfoutput></cfif>" size="90" maxlength="80">
				<div align="right"></div></td>
			</tr>
			<tr>
				<td align="right"><label id="CFcodigoLabel" style="font-style:normal; font-variant:normal; font-weight:normal"><cfoutput>#LB_Centro_Funcional#:&nbsp;</cfoutput></label></td>
				<td colspan="4">
				  <cfif modoDet neq 'ALTA'>
					<cf_rhcfuncionalCxP Ccuenta="CcuentaD" form="form1" size="22" id="CFid" name="CFcodigoresp" desc="CFdescripcionresp" query="#rsLinea#" tabindex="2">
				  <cfelse>
					<cf_rhcfuncionalCxP Ccuenta="CcuentaD" form="form1" size="22" id="CFid" name="CFcodigoresp" desc="CFdescripcionresp" tabindex="2">
				  </cfif>
					<div align="right"> </div></div>
				</td>
			</tr>
			<tr>
				<td>
					<cfif isdefined("rsPintaCuentaParametro") and rsPintaCuentaParametro.Pvalor EQ 'N'>
					<div align="right" id="conlisCuentasLabel"><cfoutput>#LB_IVA#:&nbsp;</cfoutput></div>
					<cfelseif isdefined("rsPintaCuentaParametro") and rsPintaCuentaParametro.Pvalor NEQ 'N'>
						<div align="right" id="conlisCuentasLabel"><cfoutput>#LB_Cuenta#:&nbsp;</cfoutput></div>
					</cfif>
				</td>
				<td colspan="4">
					<div id="conlisCuentas">
						<cfif isdefined("rsPintaCuentaParametro") and rsPintaCuentaParametro.Pvalor EQ 'N'>
							<select name="Icodigo" tabindex="2">
								<cfoutput query="rsImpuestos">
								<cfif #rsImpuestos.ieps# NEQ 1>
									<option value="#rsImpuestos.Icodigo#"
										<cfif modoDet NEQ 'ALTA' and rsImpuestos.Icodigo EQ rsLinea.Icodigo>selected</cfif>>
										#rsImpuestos.Icodigo# - #rsImpuestos.Idescripcion#
									</option>
									</cfif>
								</cfoutput>
							</select>
							<input name="CcuentaD" type="hidden" value="">
							<input name="CmayorD" type="hidden" value="">
							<input name="CformatoD" type="hidden" value="">
							<input name="CdescripcionD" type="hidden" value="">
						<cfelseif isdefined("rsPintaCuentaParametro") and rsPintaCuentaParametro.Pvalor NEQ 'N'>
							<cfset readonly = false>
                            <cfif isdefined("rsCuentaManualCxC") and rsCuentaManualCxC.Pvalor eq 'N'>
                                <cfset readonly = true>
                            </cfif>

							<cfif modoDet NEQ "ALTA">
								<cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#rsLinea#" auxiliares="N" movimiento="S" descwidth="20"
											ccuenta="CcuentaD" cfcuenta="CFcuentaD" cdescripcion="CdescripcionD"  cmayor="CmayorD" cformato="CformatoD"
											tabindex="2" readOnly="#readonly#">
							<cfelse>
								<cf_cuentas Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" descwidth="20"
											ccuenta="CcuentaD" cfcuenta="CFcuentaD" cdescripcion="CdescripcionD"  cmayor="CmayorD" cformato="CformatoD"
											tabindex="2" readOnly="#readonly#">
							</cfif>
						</cfif>
					</div>
				</td>
			</tr>
			<tr><cfif isdefined("rsPintaCuentaParametro") and rsPintaCuentaParametro.Pvalor NEQ 'N'>
				<td align="right"><cfoutput>#LB_IVA#:&nbsp;</cfoutput></td>
				<td colspan="4">
					<select name="Icodigo" tabindex="3">
						<cfoutput query="rsImpuestos">
							<cfif #rsImpuestos.ieps# NEQ 1>
							<option value="#rsImpuestos.Icodigo#"
								<cfif modoDet NEQ 'ALTA' and rsImpuestos.Icodigo EQ rsLinea.Icodigo>selected</cfif>>
								#rsImpuestos.Icodigo# - #rsImpuestos.Idescripcion#
							</option>
							</cfif>
						</cfoutput>
					</select>
				</td>
				<cfelseif isdefined("rsPintaCuentaParametro") and rsPintaCuentaParametro.Pvalor EQ 'N'>
					<td align="right" class="6">&nbsp;</td>
				</cfif>
			</tr>
			<tr>
				<td align="right"><cfoutput>#LB_IEPS#:&nbsp;</cfoutput></td>
				<td colspan="4">
					<select name="Iieps" id="Iieps" tabindex="3" onchange="suma(); calculaIEPS(); asignaAfectaIVA();">
						<option value=-1>--Sin IEPS--</option>
						<cfoutput query="rsImpuestos">
							<cfif #rsImpuestos.ieps# EQ 1>
							<option value="#rsImpuestos.Icodigo#" <cfif modoDet NEQ 'ALTA' and rsImpuestos.Icodigo EQ rsLinea.CodIEPS>selected</cfif>>
								#rsImpuestos.Icodigo# - #rsImpuestos.Idescripcion#
							</option>
							</cfif>
						</cfoutput>
					</select>
					<cfoutput><input name="IEscalonado" id="IEscalonado" type="hidden" value="<cfif modoDet NEQ 'ALTA' and rsLinea.afectaIVA NEQ ''>#rsLinea.afectaIVA#<cfelse>0</cfif>"></cfoutput>
				</td>
			</tr>
			<tr><cfoutput>
				<td align="right"><cfoutput>#LB_Retencion#:&nbsp;</cfoutput></td>
				<td colspan="4">
					<select name="RcodigoD" id="RcodigoD" tabindex="23" style="width: 146px" onchange="suma(); calculaIEPS(); asignaAfectaIVA();">
						<option value=-1>--Sin Retencion--</option>
						<cfloop query="rsRetenciones1">
							<!---<cfif #rsRetenciones1.Rcodigo# NEQ 1 >--->
								<option value="#rsRetenciones1.Rcodigo#" <cfif modoDet NEQ 'ALTA' and rsRetenciones1.Rcodigo EQ rsLinea.Rcodigo>selected</cfif>>#rsRetenciones1.Rcodigo# - #rsRetenciones1.Rdescripcion#</option>
							<!---</cfif>---> 
						</cfloop>
					</select>
					<!--- <input type="hidden" name="Icodigo" value="<cfif modoDet NEQ 'Alta'>#rsFormDet.Icodigo#</cfif>"> 
					<input type="hidden" name="RporcenD" value="<cfif modoDet NEQ 'ALTA' and isdefined('rsRetenciones') and rsRetenciones.recordCount GT 0>#rsRetenciones.Rporcentaje#</cfif>">--->
				</td></cfoutput>
			</tr>
		</table>

		<script type="text/javascript">
			var LvarSemaforo = false;
			function funcCcodigo()
			{
				funcCFcodigoresp();
				funcCcodigo2();
			}
			function funcCFcodigoresp()
			{
				//fnSetCuenta("","","","");
				if (LvarSemaforo)
				{
					LvarSemaforo = false;
					return;
				}
				if(document.form1.DDtipo.value=="I"){
					if (document.form1.CFcodigoresp.value != ''){
						<cfoutput>
						var Ecodigo =#session.Ecodigo#;
					    document.getElementById("FRAMETRANSPORTE").src= "SQLRegistroDocumentosCC.cfm?IMPV=" + document.form1.Icodigo.value + "&OP=GENCF&tipoItem=S&Cid=" + document.form1.Cid.value + "&SNid=#LvarSNid#&CFid=" + document.form1.CFid.value + "&Ecodigo=" + Ecodigo;
						</cfoutput>
					}
				}
				else if (document.form1.Cid.value != '' & document.form1.CFcodigoresp.value != '')
				{
				<cfoutput>
				var Ecodigo =#session.Ecodigo#;
			    document.getElementById("FRAMETRANSPORTE").src= "SQLRegistroDocumentosCC.cfm?OP=GENCF&tipoItem=S&Cid=" + document.form1.Cid.value + "&SNid=#LvarSNid#&CFid=" + document.form1.CFid.value + "&Ecodigo=" + Ecodigo;
				</cfoutput>
				}
			}

			function fnSetCuentaError(d)
			{
				LvarSemaforo = true;
				fnSetCuenta("","","","")
				alert (d);
			}

			function fnSetCuenta(cf,c,f,d)
			{
				document.form1.CcuentaD.value=c;

				if (document.form1.CmayorD)
				{
					document.form1.CFcuentaD.value=cf;
					document.form1.CmayorD.value=f.substr(0,4);
					document.form1.CformatoD.value= f.substr(5);
					document.form1.CdescripcionD.value=d;
				}
				LvarEcodigo_CcuentaD = <cfoutput>#session.Ecodigo#</cfoutput>;

			}

			function TraerCuentaConcepto(concepto,depto) {
				<cfloop query="rsCuentaConcepto">
					if (depto == "<cfoutput>#rsCuentaConcepto.Dcodigo#</cfoutput>"
					&& concepto == "<cfoutput>#rsCuentaConcepto.Cid#</cfoutput>" ) {
						document.form1.CcuentaD.value="<cfoutput>#rsCuentaConcepto.Ccuenta#</cfoutput>";
						document.form1.CdescripcionD.disabled = false;
						document.form1.CdescripcionD.value="<cfoutput>#JSStringFormat(rsCuentaConcepto.Cdescripcion)#</cfoutput>";
						document.form1.CdescripcionD.disabled = true;
						<cfif len(rsCuentaConcepto.Cformato) GTE 5>
							document.form1.CmayorD.value="<cfoutput>#Trim(JSStringFormat(mid(rsCuentaConcepto.Cformato,1,4)))#</cfoutput>";
							document.form1.CformatoD.value="<cfoutput>#Trim(JSStringFormat(mid(rsCuentaConcepto.Cformato,6,len(rsCuentaConcepto.Cformato))))#</cfoutput>";
						<cfelse>
							document.form1.CmayorD.value="<cfoutput>#JSStringFormat(rsCuentaConcepto.Cformato)#</cfoutput>";
							document.form1.CformatoD.value="";
						</cfif>
					}
				</cfloop>
			}
		</script>
	</cfif>
	<cfset masbotones = ''>
	<cfset masbotonesv = ''>

    <cfoutput>
	<cfif modo NEQ 'ALTA'>
		<cfif form.tipo EQ "C">
			<cfset masbotones = "Calcular, Aplicar, AplicarRel">
			<cfset masbotonesv = "#BTN_VerCalc#, #BTN_Aplicar# ,#BTN_AplicarRel#">
		<cfelse>
			<cfset masbotones = "Calcular, Aplicar">
			<cfset masbotonesv = "#BTN_VerCalc#, #BTN_Aplicar#">
		</cfif>
	</cfif>
    </cfoutput>
	<BR>
	<cf_botones modo="#modo#" modoDet="#modoDet#" nameEnc="Doc." include="#masbotones#" includevalues="#masbotonesv#" tabindex="3" Regresar="#regresa#">


	<!--- ======================================================================= --->
	<!--- NAVEGACION --->
	<!--- ======================================================================= --->
	<cfoutput>
		<cfif modo NEQ "ALTA">
			<input type="hidden" name="SNid" value="<cfoutput>#rsNombreSocio.SNid#</cfoutput>" />
		</cfif>


		<input type="hidden" name="Filtro_CCTdescripcion" value="<cfif isdefined('form.Filtro_CCTdescripcion') and len(trim(form.Filtro_CCTdescripcion)) >#form.Filtro_CCTdescripcion#</cfif>" />
		<input type="hidden" name="Filtro_EDdocumento" value="<cfif isdefined('form.Filtro_EDdocumento') and len(trim(form.Filtro_EDdocumento))>#form.Filtro_EDdocumento#</cfif>" />
		<input type="hidden" name="Filtro_EDfecha" value="<cfif isdefined('form.Filtro_EDfecha') and len(trim(form.Filtro_EDfecha))>#form.Filtro_EDfecha#</cfif>" />
		<input type="hidden" name="Filtro_EDusuario" value="<cfif isdefined('form.Filtro_EDusuario') and len(trim(form.Filtro_EDusuario))>#form.Filtro_EDusuario#</cfif>" />
		<input type="hidden" name="Filtro_Mnombre" value="<cfif isdefined('form.Filtro_Mnombre') and len(trim(form.Filtro_Mnombre))>#form.Filtro_Mnombre#</cfif>" />
		<cfif isdefined('form.Filtro_FechasMayores') and len(trim(form.Filtro_FechasMayores))>
		<input type="hidden" name="Filtro_FechasMayores" value="#form.Filtro_FechasMayores#" />
		</cfif>
		<input type="hidden" name="Pagina" value="<cfif isdefined('form.Pagina') >#form.Pagina#</cfif>" />
		<input type="hidden" name="maxrows" value="<cfif isdefined('form.maxrows')>#form.maxrows#</cfif>" />
	</cfoutput>
	<!--- ======================================================================= --->
	<!--- ======================================================================= --->
	<iframe 	id="FRAMETRANSPORTE" name="FRAMETRANSPORTE"
		 		frameborder="0" height="00" width="000" src="">
	</iframe>
	<iframe name="ifrTC" id="ifrTC" style="display:none;">
	</iframe>
</form>
<cf_qforms>

<script type="text/javascript" src="/jquery/librerias/jquery-1.11.1.min.js"></script>
<script type="text/javascript">
	/* aquí asigna el hidden creado por el tag de monedas al objeto que realmente se va a usar como el tipo de cambio */
 	<cfif modo NEQ "ALTA">
		if (document.form1.Mcodigo.value == "<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>") {
			formatCurrency(document.form1.TC,2);
			document.form1.EDtipocambio.disabled = true;
		}
		var estado = document.form1.EDtipocambio.disabled;
		document.form1.EDtipocambio.disabled = false;
		document.form1.EDtipocambio.value = document.form1.TC.value;
		document.form1.EDtipocambio.disabled = estado;

		function funcAcodigo(){
			document.form1.DDdescripcion.value = document.form1.Adescripcion.value;
			document.form1.DDdescalterna.value = document.form1.Adescripcion.value;

			document.form1.CcuentaD.value = document.form1.cuenta_Acodigo.value;
			document.form1.CmayorD.value = document.form1.cuentamayor_Acodigo.value;
			document.form1.CformatoD.value = document.form1.cuentaformato_Acodigo.value;
			document.form1.CdescripcionD.value = document.form1.cuentadesc_Acodigo.value;
		}

		function funcExtraAcodigo(){
			document.form1.CcuentaD.value = document.form1.cuenta_Acodigo.value='';
			document.form1.CmayorD.value = document.form1.cuentamayor_Acodigo.value = '';
			document.form1.CformatoD.value =  document.form1.cuentaformato_Acodigo.value='';
			document.form1.CdescripcionD.value =  document.form1.cuentadesc_Acodigo.value='';
		}

 	</cfif>

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	validatcLOAD();
	AsignarHiddensEncab();
	<cfif modo NEQ "ALTA">
		if (document.form1.DDtipo.value != "S")
		poneItem();
		cambiarDetalle();
		<cfif modoDet NEQ "ALTA">
			if (document.form1.DDtipo.value != "S")
				document.form1.CformatoD.disabled = true;
		</cfif>
	<cfelse>
		document.form1.EDdocumento.focus();
	</cfif>
	function TCambio(){
		var estado = document.form1.EDtipocambio.disabled;
		document.form1.EDtipocambio.disabled = false;
		//if (valida()) return true;
		//else {document.form1.EDtipocambio.disabled = estado; return false;}
	}
	function funcAlta(){
		TCambio();
		habilitarValidacion();
	}
	function funcCambio(){
		TCambio();
		habilitarValidacion();
	}

	function funcCambioDet(){
		TCambio();
		document.form1.DDtipo.disabled = false;
		habilitarValidacion();
	}

	function funcNuevo(){
		deshabilitarValidacion();
	}
	function funcAplicar(){
		deshabilitarValidacion();
	}
	/*-------------------------*/

	_allowSubmitOnError = false;
	<cfoutput>
	function _Field_isRango(low, high){
	if (_allowSubmitOnError!=true){
	var low=_param(arguments[0], 0, "number");
	var high=_param(arguments[1], 9999999, "number");
	var iValue=parseFloat(qf(this.value));
	if(isNaN(iValue))iValue=0;
	if((low>iValue)||(high<iValue)){this.error="#LB_ElCampo# "+this.description+" #LB_DebeSer# "+low+".";
	}}}
	_addValidator("isRango", _Field_isRango);

	<cfif modo NEQ "ALTA">
		objForm.OCid.description = "#LB_OrderCom#";
		objForm.OCTid.description = "#LB_Transporte#";
		objForm.AidOD.description = "#LB_OrdenCom# ";
	</cfif>

	objForm.EDdocumento.description = "#LB_CodDocto#";
	objForm.CCTcodigo.description = "#LB_TpoTrans#";
	objForm.SNcodigo.description = "#LB_CLIENTE#";
	objForm.EDfecha.description = "#LB_Fecha#";

	objForm.Mcodigo.description = "#LB_Moneda#";
	objForm.Ocodigo.description = "#Oficina#";
	objForm.Rcodigo.description = "#LB_Retencion#";
	objForm.Ccuenta.description = "#LB_Cuenta#";
	objForm.id_direccionEnvio.description = "#LB_DirEnvio#";
	objForm.id_direccionFact.description = "#LB_DirFact#";
	objForm.EDtipocambio.description = "#LB_Tipo_de_Cambio#";
	objForm.EDdescuento.description = "#LB_Desc#";
	<cfif form.tipo EQ "D">
	objForm.TESRPTCid.required = true;
	objForm.TESRPTCid.description = "#LB_PagoTerc#";
	</cfif>
	<cfif form.tipo EQ "D" and rsVerificaExistenciaVend.Cantidad>
	objForm.DEid.description = "#LB_Vendedor#";
	</cfif>
	<cfif modo NEQ "ALTA">
		objForm.Aid.description = "#LB_Articulo#";
		objForm.Cid.description = "#LB_Concepto#";
		objForm.CFid.description = "#LB_Centro_Funcional#";
		objForm.Almacen.description = "#LB_Almacen#";
		objForm.DDdescripcion.description = "#MSG_Descripcion#";
		<cfif isdefined("rsPintaCuentaParametro") and rsPintaCuentaParametro.Pvalor NEQ 'N'>
		objForm.CcuentaD.description = "#LB_CtaDet#";
		</cfif>
		objForm.DDpreciou.description = "#LB_PrecioU#";
		objForm.DDcantidad.description = "#LB_Cantidad#";
		objForm.DDdesclinea.description = "#LB_DescLin#";

		objForm.DDtotallinea.description = "#LB_TotLin#";
	</cfif>
	</cfoutput>
	function habilitarValidacion() {



		objForm.EDdocumento.required = true;
		objForm.CCTcodigo.required = true;
		objForm.SNcodigo.required = true;
		objForm.EDfecha.required = true;
		objForm.Mcodigo.required = true;
		objForm.Ocodigo.required = true;
		objForm.Rcodigo.required = true;
		objForm.Ccuenta.required = true;
		objForm.id_direccionEnvio.required = true;
		objForm.id_direccionFact.required = true;
		objForm.EDtipocambio.required = true;
		objForm.EDtipocambio.validateRango('0.0001','999999999999.9999');
		objForm.EDdescuento.required = true;
		objForm.EDdescuento.validateRango('0.00','999999999999.99');
		<cfif form.tipo EQ "D" and rsVerificaExistenciaVend.Cantidad GT 0>
			objForm.DEid.required = true;
		</cfif>
		if (!btnSelected("Cambio", document.form1)){
			<cfif modo NEQ "ALTA">
				_allowSubmitOnError = false;
				objForm.DDdescripcion.required = true;

				<cfif isdefined("rsPintaCuentaParametro") and rsPintaCuentaParametro.Pvalor NEQ 'N'>
					objForm.CcuentaD.required = true;
				</cfif>

				if (document.form1.DDtipo.value == 'A'){
					objForm.Almacen.required = true;
					objForm.Aid.required = true;
					objForm.Cid.required = false;
					objForm.OCid.required = false;
					objForm.OCTid.required = false;
					objForm.AidOD.required = false;
					objForm.CcuentaD.required = true;
				}
				if (document.form1.DDtipo.value == 'S'){
					objForm.Almacen.required = false;
					objForm.Aid.required = false;
					objForm.Cid.required = true;
					objForm.OCid.required = false;
					objForm.OCTid.required = false;
					objForm.AidOD.required = false;
					objForm.CcuentaD.required = true;
				}
				if (document.form1.DDtipo.value == 'O'){
					objForm.Almacen.required = false;
					objForm.Aid.required = false;
					objForm.Cid.required = false;
					objForm.OCid.required = true;
					objForm.OCTid.required = true;
					objForm.AidOD.required = true;
					objForm.CcuentaD.required = true;
				}
				if (document.form1.DDtipo.value == 'OV'){
					objForm.Almacen.required = true;
					objForm.Aid.required = false;
					objForm.Cid.required = false;
					objForm.OCid.required = true;
					objForm.OCTid.required = true;
					objForm.AidOD.required = true;
					objForm.CcuentaD.required = true;
				}

				objForm.CFid.required = true;
				objForm.DDpreciou.required = true;
				objForm.DDpreciou.validateRango('0.01','999999999999.99');
				objForm.DDcantidad.required = true;
				objForm.DDcantidad.validateRango('0.01','999999999999.99');
				objForm.DDdesclinea.required = true;
				objForm.DDdesclinea.validateRango('0.00','999999999999.99');
				objForm.DDtotallinea.required = true;
				objForm.DDtotallinea.validateRango('0.01','999999999999.99');
			</cfif>
		}else{
			<cfif modo NEQ "ALTA">
				_allowSubmitOnError = true;
				objForm.CFid.required = false;

				objForm.Almacen.required = false;
				objForm.Aid.required = false;
				objForm.Cid.required = false;
				objForm.OCid.required = false;
				objForm.OCTid.required = false;
				objForm.AidOD.required = false;


				<cfif isdefined("rsPintaCuentaParametro") and rsPintaCuentaParametro.Pvalor NEQ 'N'>
				objForm.CcuentaD.required = false;
				</cfif>
				objForm.Aid.required = false;
				objForm.Cid.required = false;
				objForm.DDdescripcion.required = false;
				objForm.DDpreciou.required = false;
				objForm.DDcantidad.required = false;
				objForm.DDdesclinea.required = false;
				objForm.DDtotallinea.required = false;
			</cfif>

		}

	}
	function deshabilitarValidacion() {
		_allowSubmitOnError = true;
		objForm.EDdocumento.required = false;
		objForm.CCTcodigo.required = false;
		objForm.SNcodigo.required = false;
		objForm.EDfecha.required = false;
		objForm.Mcodigo.required = false;
		objForm.Ocodigo.required = false;
		objForm.Rcodigo.required = false;
		objForm.Ccuenta.required = false;
		objForm.id_direccionEnvio.required = false;
		objForm.id_direccionFact.required = false;
		objForm.EDtipocambio.required = false;
		objForm.EDdescuento.required = false;
		objForm.OCid.required = false;
		objForm.OCTid.required = false;
		objForm.AidOD.required = false;
		<cfif form.tipo EQ "D" and rsVerificaExistenciaVend.Cantidad GT 0>
			objForm.DEid.required = false;
		</cfif>
		<cfif modo NEQ "ALTA">
			objForm.DDdescripcion.required = false;
			if(document.form1.Almacen.style.visibility == "visible"){
				objForm.Almacen.required = false;
			}
			objForm.Aid.required = false;
			objForm.Cid.required = false;
			objForm.CcuentaD.required = false;
			objForm.DDpreciou.validate = false;
			objForm.DDpreciou.required = false;
			objForm.DDcantidad.required = false;
			objForm.DDdesclinea.required = false;
			objForm.DDtotallinea.required = false;
			objForm.CFid.required = false;
			objForm.id_direccionEnvio.required = false;
			objForm.id_direccionFact.required = false;
		</cfif>
	}
	<cfoutput>
	function FuncVenc(){
		if (document.form1.tipo.value == 'D'){
			if (document.form1.fechaContrarecibo.value != ''){
			document.form1.FechaVencimiento.value = dateadd(document.form1.DEdiasVencimiento.value,document.form1.fechaContrarecibo.value);
			}
			else if (document.form1.EDfecha.value != ''){
			document.form1.FechaVencimiento.value = dateadd(document.form1.DEdiasVencimiento.value,document.form1.EDfecha.value);
			}else{
				alert('#MSG_DigFecDocto#');
				document.form1.EDfecha.focus();
				return false;
			}
		}
	}
	</cfoutput>
// PROCEDIMIENTO PARA CAMBIAR LA CUENTA SEGUN LA TRANSACCION
	var LvarArrCcuenta   = new Array();
	var LvarArrCFformato = new Array();
	var LvarArrCFdescripcion = new Array();
	<cfoutput query="rsTransacciones">
		<cfif isdefined("rsTransacciones.CFformato")>
			<cfif rsTransacciones.CCTorden eq 2>
			LvarArrCcuenta  ["#CCTcodigo#"] = "#rsCuentaCaja.Ccuenta#";
			LvarArrCFformato["#CCTcodigo#"] = "#rsCuentaCaja.CFformato#";
			LvarArrCFdescripcion["#CCTcodigo#"] = "#rsCuentaCaja.CFdescripcion#";
			<cfelse>
			LvarArrCcuenta  ["#CCTcodigo#"] = "#rsTransacciones.Ccuenta#";
			LvarArrCFformato["#CCTcodigo#"] = "#rsTransacciones.CFformato#";
			LvarArrCFdescripcion["#CCTcodigo#"] = "#rsTransacciones.CFdescripcion#";
			</cfif>
		<cfelse>
			LvarArrCcuenta  ["#CCTcodigo#"] = "";
			LvarArrCFformato["#CCTcodigo#"] = "";
			LvarArrCFdescripcion["#CCTcodigo#"] = "";
		</cfif>
	</cfoutput>
	function sbCCTcodigoOnChange (CCTcodigo)
	{
		document.getElementById("Ccuenta").value 	= LvarArrCcuenta  [CCTcodigo];
	<cfif isdefined("rsPintaCuentaParametro") and rsPintaCuentaParametro.Pvalor EQ 'N'>
		document.getElementById("SNCta").value 		= LvarArrCFformato[CCTcodigo] + ': ' + LvarArrCFdescripcion[CCTcodigo];
	<cfelse>
		var LvarCFformato = LvarArrCFformato[CCTcodigo];
		document.getElementById("cmayor").value 		= LvarCFformato.substring(0,4);
		document.getElementById("Cformato").value 		= LvarCFformato.substring(5,100);
		document.getElementById("Cfdescripcion").value 	= LvarArrCFdescripcion[CCTcodigo];
	</cfif>
	}
// PROCEDIMIENTO PARA CAMBIAR LA CUENTA SEGUN LA DIRECCION
	var LvarArrCcuentaD   = new Array();
	var LvarArrCFformatoD = new Array();
	var LvarArrCFdescripcionD = new Array();
	<cfoutput query="direcciones">
		<cfif isdefined("direcciones.CFformato")>
			LvarArrCcuentaD  ["#id_direccion#"] = "#direcciones.Ccuenta#";
			LvarArrCFformatoD["#id_direccion#"] = "#direcciones.CFformato#";
			LvarArrCFdescripcionD["#id_direccion#"] = "#direcciones.CFdescripcion#";
		<cfelse>
			LvarArrCcuentaD  ["#id_direccion#"] = "";
			LvarArrCFformatoD["#id_direccion#"] = "";
			LvarArrCFdescripcionD["#id_direccion#"] = "";
		</cfif>
	</cfoutput>
	function sbid_direccionFactOnChange (id_direccionFact)
	{
		if (id_direccionFact) {
		document.getElementById("Ccuenta").value 	= LvarArrCcuentaD  [id_direccionFact];
	<cfif isdefined("rsPintaCuentaParametro") and rsPintaCuentaParametro.Pvalor EQ 'N'>
		document.getElementById("SNCta").value 		= LvarArrCFformatoD[id_direccionFact] + ': ' + LvarArrCFdescripcionD[id_direccionFact];
	<cfelse>
		var LvarCFformatoD = LvarArrCFformatoD[id_direccionFact];
		document.getElementById("cmayor").value 		= LvarCFformatoD.substring(0,4);
		document.getElementById("Cformato").value 		= LvarCFformatoD.substring(5,100);
		document.getElementById("Cfdescripcion").value 	= LvarArrCFdescripcionD[id_direccionFact];
	</cfif>
	}
	}


	<cfoutput>
		<cfif isdefined("rsTransacciones.CFformato")>
		sbCCTcodigoOnChange ("#form.CCTcodigo#");
		</cfif>
	</cfoutput>
	<cfif modo EQ 'CAMBIO' and modoDet EQ 'ALTA'>
		document.form1.DDtipo.focus();
	<cfelseif modo EQ 'CAMBIO' and modoDet EQ 'CAMBIO'>
		if (document.form1.DDtipo.value=="A"){
			document.form1.Almacen.focus();
		}
		if (document.form1.DDtipo.value=="S"){
			//document.form1.Ccodigo.focus();
		}
		if (document.form1.DDtipo.value=="S"){
			document.form1.OCcontrato.focus();
		}
	<cfelseif modo EQ 'ALTA' and isdefined('form.SNcodigo')>
		document.form1.EDfecha.focus();
	</cfif>

	<cfoutput>
	function doConlisTransporte() {
		var DDtipo = document.form1.DDtipo.value;
		var OCid = document.form1.OCid.value;
		var OCTtipo = document.form1.OCTtipo.value;
		var PARAM  = "ConlisTransporte.cfm?OCTtipo="+ OCTtipo + "&DDtipo="+DDtipo ;
		if (DDtipo == 'O' || DDtipo == 'OV'){
			if ( OCid != "" ){
				var PARAM  = PARAM + "&OCid="+ OCid;
				open(PARAM,'V1','left=110,top=100,scrollbars=yes,resizable=yes,width=900,height=650')
			}
			else {
				alert('#MSG_SelOrdCom#');
			}
		}
		else{
			open(PARAM,'V1','left=110,top=100,scrollbars=yes,resizable=yes,width=900,height=650')
		}
	}
	function validaTransporte() {
		var DDtipo		 	= document.form1.DDtipo.value;
		var OCid 			= document.form1.OCid.value;
		var OCTtipo 		= document.form1.OCTtipo.value;
		var OCTtransporte 	= document.form1.OCTtransporte.value;

		if(OCTtransporte != "") {
			var PARAM = "?OCTtransporte="+OCTtransporte+"&OCTtipo="+OCTtipo+"&DDtipo="+DDtipo;

			if (DDtipo == 'O'){
				if ( OCid != "" ){
					var PARAM  = PARAM + "&OCid="+ OCid;
					var frame  = document.getElementById("FRAMETRANSPORTE");
					frame.src 	= "validaTransporte.cfm" + PARAM;
				}
				else {
					alert('#MSG_SelOrdCom#');
				}
			}
			else{
				var frame  = document.getElementById("FRAMETRANSPORTE");
				frame.src 	= "validaTransporte.cfm" + PARAM;
			}
		}
	}
	</cfoutput>
	var GvarOCobtieneCFcuenta = false;
	function fnOCobtieneCFcuenta()
	{
		var PARAM = "?tipo=IN";
		PARAM = PARAM + "&OCid=" + document.form1.OCid.value;
		PARAM = PARAM + "&Aid="  + document.form1.AidOD.value;
		PARAM = PARAM + "&SNid=" + document.form1.SNid.value;
		PARAM = PARAM + "&OCIid=" + document.form1.OCIid.value;
		var frame  = document.getElementById("FRAMETRANSPORTE");
		frame.src 	= "/cfmx/sif/Utiles/OC_CFcuenta.cfm" + PARAM;
		GvarOCobtieneCFcuenta = true;
	}

	function fnOCobtieneCFcuenta_Asignar(pCFcuenta,pCcuenta,pCFformato,pCFdescripcion)
	{
		document.form1.CFcuenta_CcuentaD.value	= pCFcuenta;
		document.form1.CcuentaD.value			= pCcuenta;
		document.form1.CmayorD.value			= pCFformato.substring(0,4);
		document.form1.CformatoD.value			= pCFformato.substring(5);
		document.form1.CdescripcionD.value		= pCFdescripcion;
	}
	var popUpWin=0;



<cfoutput>
var codIEPSC = '';
<cfif isDefined('rslinea.codIEPS')>
	//document.form1.codIEPSC.value = '#rslinea.codIEPS#';
	codIEPSC = '#rslinea.codIEPS#';
</cfif>
</cfoutput>
function funcCcodigo2(){
	if (codIEPSC != ''){
		document.form1.Iieps.value = codIEPSC;
		if (codIEPSC != ''){
			document.form1.Iieps.disabled = true;
		}
		calculaIEPS();
		suma();
		if (document.getElementById('afectaIVAC').value != ''){
			document.form1.IEscalonado.value = document.getElementById('afectaIVAC').value;
		}
	}else{
		document.form1.Iieps.value = -1;
		document.form1.Iieps.disabled = false;
		calculaIEPS();
		suma();
	}
}
function funcAcodigo(){
	if (document.form1.codIEPSA.value != ''){
		document.form1.Iieps.value = document.form1.codIEPSA.value;
		document.form1.Iieps.disabled = true;
	}else{
		document.form1.Iieps.value = -1;
		document.form1.Iieps.disabled = false;
	}
}
function enableIEPS() {
	if (document.getElementById('Iieps') != null){
    	document.getElementById('Iieps').disabled= false;
	}
}
function asignaAfectaIVA(){
	ieps();
	document.form1.IEscalonado.value = varIEscalonado;
}
// no modifica el afectaIVA
function calculaIEPS(){
	var cantidad = new Number(qf(document.form1.DDcantidad.value));
	var precio = new Number(qf(document.form1.DDpreciou.value));
	var descuento = new Number(qf(document.form1.DDdesclinea.value));
	if (document.form1.Iieps.value == -1){
		document.form1.DDIeps.value = 0;
	}else{
		ieps();
		if (varTipoIEPS == 1){
			document.form1.DDIeps.value = Math.round(((cantidad * precio - descuento) * (varIEPSValCal/100))*100)/100;
		}else if(varTipoIEPS == 2){
			document.form1.DDIeps.value = varIEPSValCal;
		}
	}
}
</script>