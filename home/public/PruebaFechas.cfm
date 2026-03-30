<cfif isdefined("form.ALTA")>
	<cfdump var="#form#">
    <cfdump var="#url#">
	<cfdump var="#LSParseDateTime(form.FechaVencimiento)#">
    <cfabort>
</cfif>

<cfset form.tipo = 'D'>
<cfset session.Ecodigo = 1> <!--- 162 en producción SOIN --->
<cfset session.dsn = 'minisif'>  <!--- dsn en producción SOIN --->
<cfset modo = 'ALTA'>
<cfset mododet = 'ALTA'>

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

<cfquery name="rsTransacciones" datasource="#Session.DSN#">
	select 	a.CCTcodigo, 
			case when coalesce(a.CCTvencim,0) < 0 then <cf_dbfunction name="sPart" args="a.CCTdescripcion,1,10"> #_Cat# ' (contado)' else <cf_dbfunction name="sPart" args="a.CCTdescripcion,1,20"> end as CCTdescripcion,
									
			case when coalesce(a.CCTvencim,0) >= 0 then 1 else 2 end as CCTorden,
			a.CCTtipo
	<cfif isdefined("form.CCTcodigo") and (isdefined("form.SNcodigo") and len(trim(form.SNcodigo)))>
			, case when ctas.CFcuenta is null
				then
					(
						select min(rtrim(CFformato))
						  from CFinanciera
						 where Ccuenta = n.SNcuentacxc
					)
				else
					(
						select rtrim(CFformato)
						  from CFinanciera
						 where CFcuenta = ctas.CFcuenta
					)
				end
			as CFformato
			, case when ctas.CFcuenta is null
				then
					(
						select CFdescripcion
						  from CFinanciera
						 where Ccuenta = n.SNcuentacxc
					)
				else
					(
						select CFdescripcion
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
	   and coalesce(a.CCTpago,0) != 1
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
	<cf_errorCode	code = "50182" msg = "La Cuenta de Caja CxC no esta definida, debe ser definida en Cuentas Contables de Operación">
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

<cfquery name="rsPintaCuentaParametro" datasource="#session.DSN#">
	select Pcodigo, Pvalor, Pdescripcion
	from  Parametros
	where Ecodigo =  #Session.Ecodigo# 
	and Pcodigo =2
</cfquery>

<cfset LvarSNid = -1>
<cfif isdefined('Form.SNidentificacion') and len(trim(Form.SNidentificacion))
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
		  and a.SNidentificacion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNidentificacion#"> 
	</cfquery>
	<cfset LvarSNid = rsSociosN.SNid>
<cfelseif isdefined('Form.SNidentificacion') and len(trim(Form.SNidentificacion))>
	<cfquery name="rsSociosN" datasource="#session.DSN#">
		select SNcodigo, SNid, SNnombre, SNidentificacion, SNnumero, DEidVendedor, DEidCobrador, SNcuentacxc, SNvenventas
		from SNegocios a, EstadoSNegocios b
		where a.Ecodigo =  #Session.Ecodigo#  
		  and a.ESNid = b.ESNid	
		  and a.SNidentificacion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNidentificacion#"> 
	</cfquery> 
	<cfset LvarSNid = rsSociosN.SNid>
</cfif>

<cfif isdefined('Form.SNidentificacion') and LEN(trim(Form.SNidentificacion)) >

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
		  and a.SNidentificacion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNidentificacion#"> 
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
	order by Ocodigo                      
</cfquery>

<cfif isdefined("rsSociosN") and rsSociosN.recordcount EQ 1 and rsSociosN.SNcuentacxc EQ ''>
	<cf_errorCode	code = "50183" msg = "La cuenta para el Socio de Negocios debe ser definida.">
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

<cfquery name="rsImpuestos" datasource="#Session.DSN#">
	select Icodigo, Idescripcion from Impuestos 
	where Ecodigo =  #Session.Ecodigo# 
	order by Idescripcion                                 
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
				DEordenCompra, DEnumReclamo, DEobservacion, ts_rversion, id_direccionFact, id_direccionEnvio,TESRPTCid
		from EDocumentosCxC d
		where Ecodigo =  #Session.Ecodigo# 
		  and EDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EDid#">
	</cfquery>
	<cfif rsDocumento.recordCount EQ 0>
		<cf_errorCode	code = "50184" msg = "El documento no existe">
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
			select a.EDid,a.DDlinea,
				a.Aid,null, a.Cid, 
				a.DDdescripcion, a.DDdescalterna, a.DDcantidad, a.DDpreciou, a.DDdesclinea, a.DDporcdesclin, a.DDtotallinea, 
				case 
					when a.DDtipo = 'O' and oc.OCtipoIC='V' then 'OV' else a.DDtipo
				end as DDtipo, 
				a.DDtipo as DDtipo_OC,
				a.Ccuenta, a.Alm_Aid, a.Dcodigo, a.ts_rversion, a.Icodigo,
				b.Cformato, b.Cdescripcion, a.CFid, CFcodigo as CFcodigoresp, CFdescripcion as CFdescripcionresp,
				a.OCid,a.OCTid, a.OCIid
			from DDocumentosCxC a 
				left outer join CContables b
					on a.Ccuenta = b.Ccuenta
				left outer join CFuncional c
					on a.CFid = c.CFid
					and a.Ecodigo = c.Ecodigo
				left outer join OCordenComercial oc
					on oc.OCid = a.CFid
			
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


<script language="JavaScript" src="../../sif/js/calendar.js"></script> 
<script language="JavaScript" src="../../sif/js/utilesMonto.js"></script> 
<script language="JavaScript" src="../../sif/js/fechas.js"></script> 
<script type="text/javascript" src="/cfmx/sif/js/Macromedia/wddx.js"></script>

<script language="JavaScript1.2">
	function validaNumero(dato) {
		if (dato.length > 0) {
			if (ESNUMERO(dato)) {
				return true;
			}		
			else {
				alert('El monto digitado debe ser numérico.');			
				return false;
			}
		}
		else {
			alert('El monto digitado debe ser numérico.');
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
				if (!confirm('El tipo de cambio ha sido cambiado. ¿Desea obtener el tipo de cambio histórico?'))
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

	function suma()
	{               		
		if (document.form1.DDpreciou.value=="" ) document.form1.DDpreciou.value = "0.00"
		if (document.form1.DDdesclinea.value=="")document.form1.DDdesclinea.value = "0.00"		
		if (document.form1.DDcantidad.value=="" )document.form1.DDcantidad.value = "0.00"
		
		if (document.form1.DDpreciou.value=="-" ){
			document.form1.DDpreciou.value = "0.00"
			document.form1.DDtotallinea.value = "0.00"
		}    		
		
		if (document.form1.DDdesclinea.value=="-"){    
			document.form1.DDdesclinea.value = "0.00" 
			document.form1.DDtotallinea.value = "0.00"
		}		
		
		if (document.form1.DDcantidad.value=="-" ){
			document.form1.DDcantidad.value = "0.00"
			document.form1.DDtotallinea.value = "0.00"
		}    
				
		var cantidad = new Number(qf(document.form1.DDcantidad.value))
		var precio = new Number(qf(document.form1.DDpreciou.value))
		var descuento = new Number(qf(document.form1.DDdesclinea.value))		
		var seguir = "si"
		
		if(cantidad < 0){
			document.form1.DDcantidad.value="0.00"
			seguir = "no"
		}  
		
		if(precio < 0){
			document.form1.DDpreciou.value="0.00"
			seguir = "no"
		} 
		
		if(descuento < 0){
			document.form1.DDdesclinea.value="0.00"
			seguir = "no"
		}
		
		if(descuento > cantidad*precio){        
			document.form1.DDdesclinea.value="0.00"
			document.form1.DDtotallinea.value = cantidad * precio
		}
		else {        
			document.form1.DDtotallinea.value = redondear((cantidad * precio) - descuento,2);
			document.form1.DDtotallinea.value = fm(document.form1.DDtotallinea.value,2)			
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

	function cambiarDetalle(){		
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
				alert ("Debe digitar el artículo")            
				return false;
			}
		}
		if (document.form1.DDtipo.value=="S")
		{			   
		   	if (document.form1.Cid.value == "")  { 
				alert ("Debe digitar el concepto")            
				return false;
			}
		   	if (document.form1.DDdescripcion.value == "" || document.form1.DDdescripcion.value == " ") { 
				alert ("Debe digitar la descripción")
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
			msg='¿Desea aplicar este documento?';
		}else if (tipo==2){
			msg='¿Desea aplicar y relacionar este documento?';
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
	
</script>

<form name="form1" action="PruebaFechas.cfm" method="post">
	<cfif isdefined('rsDocumento') and not isdefined("form.SNidentificacion")>
	<input type="hidden" name="SNcodigo" value="<cfoutput>#rsDocumento.SNcodigo#</cfoutput>">
	</cfif>
	<table width="100%" border="0" cellpadding="0" cellspacing="3">

		<tr>
			<td align="right">Documento:&nbsp;</td>
			<td>
				<cfoutput>
				<input name="EDdocumento" <cfif modo NEQ "ALTA"> class="cajasinborde" readonly tabindex="-1" <cfelse> 
				tabindex="1"</cfif> type="text" 
				value="<cfif modo NEQ "ALTA">#rsDocumento.EDdocumento#<cfelseif isdefined('Form.EDDocumento')>#form.EDDocumento#</cfif>" 
				size="28" maxlength="20">
				</cfoutput> 
			</td>
			<td> <div align="right">Transacción (<cfif form.tipo EQ "C">CR<cfelse>DB</cfif>):&nbsp;</div></td>
			<td> 
				<cfif modo NEQ "ALTA">
					<input type="text" name="CCTdescripcion" 
							value="<cfoutput>#rsNombreTransac.CCTcodigo# - #rsNombreTransac.CCTdescripcion#</cfoutput>"
							class="cajasinborde" readonly tabindex="-1" 
							size="30" maxlength="80">
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
								>
									#rsTransacciones.CCTcodigo# - #rsTransacciones.CCTdescripcion#
							</option>
						</cfoutput> 
					</select>
				</cfif> 
			</td>
		</tr>
		<tr>
			<td> <div align="right">Cliente:&nbsp;</div></td>
			<td colspan="3">
				<cfif modo NEQ "ALTA" and not isdefined("form.SNidentificacion")>
					<input name="SNnumero" type="text" readonly class="cajasinborde" tabindex="-1"  
					  value="<cfoutput>#rsNombreSocio.SNnumero#</cfoutput>" size="10" maxlength="10">	
					<input name="SNnombre" type="text" readonly class="cajasinborde" tabindex="-1" 
					   value="<cfoutput>#rsNombreSocio.SNnombre#</cfoutput>" size="40" maxlength="255">	
				   	<input name="SNidentificacion" type="hidden" 
					  value="<cfoutput>#rsNombreSocio.SNidentificacion#</cfoutput>">	
				<cfelse>
					<cfif isdefined('form.SNidentificacion') and LEN(trim(form.SNidentificacion))>
						<cf_sifSNFactCxC SNtiposocio="C" SNidentificacion ="SNidentificacion" size="50" query="#rsSociosN#" tabindex="1">
					<cfelse>
						<cf_sifSNFactCxC SNtiposocio="C" SNidentificacion ="SNidentificacion" size="50" tabindex="1">
					</cfif>
				</cfif>	
			</td>
		</tr>
		<tr>	
			<td><div align="right">Cuenta:&nbsp;</div></td>
			<td colspan="3">
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
		</tr>
		<tr>
			<cfif form.tipo NEQ "D">
				<td align="right"> Oficina:&nbsp;</td>
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
				<td align="right" nowrap><cfif form.tipo EQ "D">D&iacute;as Vencimiento:&nbsp;</cfif></td>
				<td><cfif form.tipo EQ "D">
					<cfoutput>
					<input name="DEdiasVencimiento" type="text" align="right" size="10" tabindex="1"
					onChange="javascript: FuncVenc(this);"
					value="<cfif modo NEQ "ALTA">#rsDocumento.DEdiasVencimiento#<cfelseif isdefined('rsSociosN') and rsSociosN.SNvenventas GT 0>#rsSociosN.SNvenventas#<cfelse><cfoutput>0</cfoutput></cfif>">
					</cfoutput></cfif>
				</td>
			</cfif>
			<td><div align="right">Moneda:&nbsp;</div></td>
			<td>
				<cfif modo NEQ "ALTA">
					<cf_sifmonedas query="#rsDocumento#" frame="frame2" valueTC="#rsDocumento.EDtipocambio#" 
						onChange="validatc(true);" tabindex="1">
				<cfelse>
					<cf_sifmonedas frame="frame2" onChange="validatc(true);" tabindex="1">
				</cfif>
			</td>
			
		</tr>
		<tr nowrap="nowrap">
			<td align="right">Fecha:&nbsp;</td>
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
							<cfif form.tipo EQ "D">Vencimiento:&nbsp;</cfif>
							<cfif form.tipo EQ "D">
								<cfoutput>
									<cfif isdefined('rsDocumento') and rsDocumento.RecordCount GT 0 and rsDocumento.DEdiasVencimiento GT 0>
										<cfset FechaV = DateAdd('d',#rsDocumento.DEdiasVencimiento#,#LSParseDateTime(rsDocumento.EDfecha)#)>
									<cfelseif isdefined('rsSociosN') and isdefined('form.SNidentificacion') 
											  and modo EQ 'ALTA' and rsSociosN.SNvenventas GTE 0>
										<cfif isdefined('form.EDfecha') and form.EDfecha NEQ ''>
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
			<td nowrap align="right" <cfif form.tipo NEQ "D">valign="top" </cfif>>Tipo de Cambio:&nbsp;</td>
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
			<cfif form.tipo EQ "D">
				<cfif rsVerificaExistenciaVend.Cantidad GT 0>
					<td><div align="right">Vendedor:&nbsp;</div></td>
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
			<td><div align="right">Referencia:&nbsp;</div></td>
			<td>

				<cfif modo NEQ "ALTA">
			  		<cf_sifDocsReferenciaCxC query="#rsDocRef#" form="form1" tabindex="2"> <!--- query="#rsDetalle#" --->
				<cfelse>
					<cf_sifDocsReferenciaCxC form="form1" tabindex="1">
				</cfif>
			</td>
		</cfif>
			<cfif form.tipo NEQ "D">
				<td>&nbsp;</td>
				<td nowrap>&nbsp;</td>
		  	<cfelse>
				<td align="right" nowrap><cfif form.tipo EQ "D">Orden de Compra:&nbsp;</cfif></td>
				<td><cfif form.tipo EQ "D"><cfoutput>
					<input name="DEordenCompra" type="text" align="right" size="20" tabindex="1"
					value="<cfif modo NEQ "ALTA">#rsDocumento.DEordenCompra#<cfelseif modo EQ 'ALTA' and isdefined('Form.DEordenCompra') and LEN(Form.DEordenCompra) GT 0>#form.DEordenCompra#<cfelse></cfif>"></cfoutput></cfif>
				</td>
			</cfif>
		</tr>
		<tr><cfif form.tipo EQ "D">
			<td align="right">Oficina:&nbsp;</td>
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
				<td align="right" nowrap valign="top">Observaciones:&nbsp;</td>
				<td colspan="3" rowspan="1" valign="top"><textarea name="DEobservacion" id="DEobservacion" rows="2" tabindex="1"  cols="30" ><cfif modo NEQ 'ALTA'><cfoutput>#rsDocumento.DEobservacion#</cfoutput></cfif></textarea>				
				</td>
				
			</cfif>
			<cfif form.tipo EQ "D">
				<td align="right">N&uacute;mero de Reclamo:&nbsp;</td>
				<td><cfoutput>
					<input name="DEnumReclamo" type="text" align="right" size="20" tabindex="1"
					value="<cfif modo NEQ "ALTA">#rsDocumento.DEnumReclamo#<cfelseif modo EQ 'ALTA' and isdefined('Form.DEnumReclamo')>#form.DEnumReclamo#<cfelse></cfif>"></cfoutput>
				</td>
			</cfif>

		</tr>
	<cfif form.tipo EQ "D">
		<tr>
			<td  align="right">Concepto cobros terceros:&nbsp;</td>
            <td  colspan="2">
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
			<td align="right">Direcci&oacute;n Env&iacute;o:&nbsp;</td>
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
			<td colspan="2" rowspan="4"  align="left">
				<table style="width:100%" align="left"  border="0" cellpadding="0" cellspacing="1">
				<tr>
					<td nowrap="nowrap" width="37%" style="vertical-align:top"><div align="right">Retenci&oacute;n al Pagar:&nbsp;</div></td>
					<td align="left" style="vertical-align:top">
						<select name="Rcodigo" tabindex="1">
							<option value="-1" >-- Sin Retención --</option>
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
					<tr>
						<td><div align="right">Descuento:&nbsp;</div></td>
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
						<td valign="top"><div align="right">Impuesto:&nbsp;</div></td>
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
			<td align="right" nowrap>Direcci&oacute;n Facturaci&oacute;n:&nbsp;</td>
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
			<td align="right" nowrap valign="top"><cfif form.tipo EQ "D">Observaciones:&nbsp;</cfif></td>
			<td  rowspan="2">
				<cfif form.tipo EQ "D">
					<textarea name="DEobservacion" id="DEobservacion" rows="2"  tabindex="1" style="width: 100%;"><cfif modo NEQ 'ALTA'><cfoutput>#rsDocumento.DEobservacion#</cfoutput></cfif></textarea>				
				</cfif>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	</table>


	<cfif modo NEQ "ALTA">
		<cfquery name="rsOC" datasource="#session.DSN#">
			select count(1) as cant 
			from Parametros 
			where Ecodigo = #session.Ecodigo#
			and Pcodigo = 442
		</cfquery>
		<table style="width:100%" border="0" cellpadding="0" cellspacing="3">
			<tr><td colspan="7" class="tituloAlterno">Detalle</td></tr>
			<tr> 
				<td colspan="7">
					Item:&nbsp;
					<!---<cfset form.DDtipo=rsLinea.DDtipo>--->
					<select name="DDtipo" onChange="javascript:limpiarDetalle();cambiarDetalle();FuncValidaItem();" 
						tabindex="1" <cfif modoDet neq 'ALTA'>disabled</cfif> >
						<cfif rscArticulos.cant GT 0>
							<option value="A" <cfif modoDet EQ "CAMBIO" and trim(rsLinea.DDtipo) EQ "A">selected disabled</cfif>>A-Artículo de Inventario</option>
						</cfif>
						<cfif rscConceptos.cant GT 0>
							<option value="S" <cfif modoDet EQ "CAMBIO" and trim(rsLinea.DDtipo) EQ 'S'>selected disabled</cfif>>S-Concepto Servicio o Gasto</option>
						</cfif>
						<cfif rsOC.cant gt 0>
							<option value="O" <cfif modoDet NEQ "ALTA" and trim(rsLinea.DDtipo) EQ "O">selected disabled</cfif>>O-Orden Comercial en Tránsito</option>				
							<option value="OV" <cfif modoDet NEQ "ALTA" and trim(rsLinea.DDtipo) EQ "OV">selected disabled</cfif>>OV-Orden Comercial Venta de Almacén</option>				
						</cfif>
					</select>
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
								&Oacute;rden Comercial:&nbsp;					
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
								
								<input name="OAA" value="" type="hidden">
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
											Title="Órdenes Comerciales de Venta Abiertas"
											Tabla="OCordenComercial"
											Columnas="OCid,OCcontrato,OCfecha"
											Filtro=" Ecodigo = #Session.Ecodigo# 
													and OCestado = 'A' 
													and OCtipoOD = 'D'
													and OCtipoIC = $OAA,char$
													
													order by OCfecha"
											Desplegar="OCcontrato,OCfecha"
											Etiquetas="Contrato,Fecha"
											filtrar_por="OCcontrato,Fecha"
											Formatos="S,D"
											Align="left,left"
											Asignar="OCid,OCcontrato"
											Asignarformatos="S,S"/>
								
						 	</td>
							<!--- TRANSPORTE --->
							<td align="right" id="TransporteLabel">
								Transporte:&nbsp;						
							</td>
							<td id="TransporteImput" nowrap="nowrap">
								<select id="OCTtipo" name="OCTtipo" >
									<option value="">(Tipo Transporte)</option>
									<option value="B" <cfif modoDet NEQ "ALTA" and isdefined("rsLinea.OCTtipo") and rsLinea.OCTtipo EQ "B">selected</cfif>>Barco</option>
									<option value="A" <cfif modoDet NEQ "ALTA" and isdefined("rsLinea.OCTtipo") and rsLinea.OCTtipo EQ "A">selected</cfif>>Aéreo</option>
									<option value="T" <cfif modoDet NEQ "ALTA" and isdefined("rsLinea.OCTtipo") and rsLinea.OCTtipo EQ "T">selected</cfif>>Terrestre</option>
									<option value="F" <cfif modoDet NEQ "ALTA" and isdefined("rsLinea.OCTtipo") and rsLinea.OCTtipo EQ "F">selected</cfif>>Ferrocarril</option>
									<option value="O" <cfif modoDet NEQ "ALTA" and isdefined("rsLinea.OCTtipo") and rsLinea.OCTtipo EQ "O">selected</cfif>>Otro</option>
								</select>
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
									alt="Transporte"
									tabindex="2"
									title="Transporte"
									onblur  = "javascript: validaTransporte()">
									</cfoutput>
								<a href="javascript:doConlisTransporte();" id="imgCcuenta">
									<img src="/cfmx/sif/imagenes/Description.gif"
									alt="Lista de transportes"
									name="imagentransporte"
									width="18" height="14"
									border="0" align="absmiddle">
								</a>	
								<input type="hidden" name="OCTid" tabindex="-1" value="<cfif modoDet NEQ "ALTA" and isdefined("rsLinea.OCTid") and len(trim(rsLinea.OCTid))><cfoutput>#rsLinea.OCTid#</cfoutput></cfif>" />
						  </td>		
							<!--- CONCEPTO --->
							<td align="right" id="labelconcepto">
								Concepto:&nbsp;						
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
								Almac&eacute;n:&nbsp;						
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
							<td align="right"  id="labelarticulo">
								Art&iacute;culo:&nbsp;						
							</td>
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
								Title="Artículos de la orden comercial"
								Tabla=" OCordenProducto a 
										inner join Articulos  b
											on a.Aid = b.Aid
											and a.Ecodigo = b.Ecodigo"
								Columnas="a.Aid as AidOD,b.Acodigo as  AcodigoOD,b.Acodalterno as AcodalternoOD,b.Adescripcion as AdescripcionOD"
								Filtro=" a.Ecodigo = #Session.Ecodigo# and a.OCid = $OCid,numeric$ "
								Desplegar="AcodigoOD,AcodalternoOD,AdescripcionOD"
								Etiquetas="Código,Cód. Alterno,Descripción"
								filtrar_por="b.Acodigo,b.Acodalterno,b.Adescripcion"
								Formatos="S,S,S"
								Align="left,left,left"
								Asignar="AidOD,AcodigoOD,AdescripcionOD"
								funcion="fnOCobtieneCFcuenta()"
								Asignarformatos="S,S,S"/>
							</td>
						<td id="ConceptoOCI" colspan="2">
							Concepto Ingreso:&nbsp;
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
				<td><div align="right">&nbsp;Descripci&oacute;n:&nbsp;</div></td>
				<td colspan="4">
					<input name="DDdescripcion" tabindex="2" onFocus="javascript:document.form1.DDdescripcion.select();" type="text" 
						   value="<cfif modoDet NEQ "ALTA"><cfoutput>#rsLinea.DDdescripcion#</cfoutput></cfif>" size="90" 
						   maxlength="255">
				</td>
				
				
				<td><div align="right">Cantidad:&nbsp;</div></td>
				<td><cfoutput>
					<input name="DDcantidad" onFocus="javascript:this.value = qf(this.value); this.select();" type="text" tabindex="2" 
						   style="text-align:right" onChange="javascript:fm(this,2);suma();" 
						   onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
						   value="<cfif modoDet NEQ "ALTA">#LSCurrencyFormat(rsLinea.DDcantidad,'none')#<cfelse>0.00</cfif>" 
						   size="12" maxlength="12"></cfoutput>
				</td>
			</tr>
			<tr> 
				<td align="right">Desc. Alterna:&nbsp;</td>
				<td colspan="4">
					<input name="DDdescalterna" tabindex="2" onFocus="javascript:document.form1.DDdescalterna.select();" type="text" 
						   value="<cfif modoDet NEQ "ALTA"><cfoutput>#rsLinea.DDdescalterna#</cfoutput></cfif>" size="90" maxlength="255">
				<div align="right"></div></td>
				<td nowrap> <div align="right">Precio Unitario:&nbsp;</div></td>
				<td><cfoutput>
					<input name="DDpreciou" onFocus="javascript:this.value = qf(this.value); this.select();" type="text" tabindex="2"
						   style="text-align:right" onblur="javascript:fm(this,2);suma();" 
						   onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
						   value="<cfif modoDet NEQ "ALTA">#LSCurrencyFormat(rsLinea.DDpreciou,'none')#<cfelse>0.00</cfif>" 
						   size="12" maxlength="15"></cfoutput>
				</td>
				
			</tr>
			<tr>
				<td>
					<cfif isdefined("rsPintaCuentaParametro") and rsPintaCuentaParametro.Pvalor EQ 'N'>
					<div align="right" id="conlisCuentasLabel">Impuesto:&nbsp;</div>
					<cfelseif isdefined("rsPintaCuentaParametro") and rsPintaCuentaParametro.Pvalor NEQ 'N'>
						<div align="right" id="conlisCuentasLabel">Cuenta:&nbsp;</div>
					</cfif>
				</td>
				<td colspan="4">
					<div id="conlisCuentas">
						<cfif isdefined("rsPintaCuentaParametro") and rsPintaCuentaParametro.Pvalor EQ 'N'>
						
							<select name="Icodigo" tabindex="2">
								<cfoutput query="rsImpuestos"> 
									<option value="#rsImpuestos.Icodigo#" 
										<cfif modoDet NEQ 'ALTA' and rsImpuestos.Icodigo EQ rsLinea.Icodigo>selected</cfif>>
										#rsImpuestos.Icodigo# - #rsImpuestos.Idescripcion#
									</option>
								</cfoutput>
							</select> 
							
							<input name="CcuentaD" type="hidden" value="">
							<input name="CmayorD" type="hidden" value="">
							<input name="CformatoD" type="hidden" value="">
							<input name="CdescripcionD" type="hidden" value="">
						
						<cfelseif isdefined("rsPintaCuentaParametro") and rsPintaCuentaParametro.Pvalor NEQ 'N'>
							<cfif modoDet NEQ "ALTA">
								<cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#rsLinea#" auxiliares="N" movimiento="S" descwidth="20"
											ccuenta="CcuentaD" cdescripcion="CdescripcionD"  cmayor="CmayorD" cformato="CformatoD" 
											tabindex="2"> 
							<cfelse>
								<cf_cuentas Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" descwidth="20"
											ccuenta="CcuentaD" cdescripcion="CdescripcionD"  cmayor="CmayorD" cformato="CformatoD" 
											tabindex="2"> 
							</cfif>
						</cfif>
					</div> 
				</td>
				 <td><div align="right">Descuento:&nbsp;</div></td>
				<td><cfoutput>
					<input name="DDdesclinea" onFocus="javascript:this.value = qf(this.value); this.select();" type="text" tabindex="3" 
						   style="text-align:right" 
						   onblur="javascript:fm(this,2);suma();" 
						   onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
						   value="<cfif modoDet NEQ "ALTA">#LSCurrencyFormat(rsLinea.DDdesclinea,'none')#<cfelse>0.00</cfif>" 
						   size="12" maxlength="12"></cfoutput>
				</td>
				
			</tr>
			<tr>
				<td align="right"><label id="CFcodigoLabel" style="font-style:normal; font-variant:normal; font-weight:normal">Centro&nbsp;Funcional:&nbsp;</label></td>
				<td colspan="4">  
				  <cfif modoDet neq 'ALTA'>
					<cf_rhcfuncional size="22" name="CFcodigoresp" desc="CFdescripcionresp" titulo="Seleccione el Centro Funcional Responsable" 
						query="#rsLinea#" tabindex="3">
				  <cfelse>
					<cf_rhcfuncional size="22"  name="CFcodigoresp" desc="CFdescripcionresp" titulo="Seleccione el Centro Funcional Responsable" 
						excluir="-1" tabindex="3">
				  </cfif>
					<div align="right"> </div></div>
				</td>
				
				<td align="right">Total:</td>
				<td><cfoutput>
					<input name="DDtotallinea" type="text" class="cajasinborde" style="text-align:right" 
						   onchange="javascript:fm(this,2);" tabindex="-1" }
						   value="<cfif modoDet NEQ "ALTA">#LSCurrencyFormat(rsLinea.DDtotallinea,'none')#<cfelse>0.00</cfif>" 
						   size="10" maxlength="12" readonly> 
					<input name="DDlinea" type="hidden" value="<cfif modoDet NEQ "ALTA">#rsLinea.DDlinea#</cfif>"> 
					<input name="DDporcdesclin" type="hidden" 
					value="<cfif modoDet NEQ "ALTA" and isdefined('rsLinea.DDpordesclin')>#rsLinea.DDporcdesclin#<cfelse>0.00</cfif>"> 					
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
			<tr><cfif isdefined("rsPintaCuentaParametro") and rsPintaCuentaParametro.Pvalor NEQ 'N'>
				<td align="right">Impuesto:&nbsp;</td>
				<td colspan="6">
					<select name="Icodigo" tabindex="3">
						<cfoutput query="rsImpuestos"> 
							<option value="#rsImpuestos.Icodigo#" 
								<cfif modoDet NEQ 'ALTA' and rsImpuestos.Icodigo EQ rsLinea.Icodigo>selected</cfif>>
								#rsImpuestos.Icodigo# - #rsImpuestos.Idescripcion#
							</option>
						</cfoutput>
					</select> 
				</td>
				<cfelseif isdefined("rsPintaCuentaParametro") and rsPintaCuentaParametro.Pvalor EQ 'N'>
					<td align="right" class="6">&nbsp;</td>
				</cfif>
			</tr>
		</table>
		
		<script language="JavaScript1.2">
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
	<cfif modo NEQ 'ALTA'>
		<cfif form.tipo EQ "C">
			<cfset masbotones = "Calcular, Aplicar,AplicarRel">
			<cfset masbotonesv = "Ver cálculo, Aplicar,Aplicar y Relacionar">
		<cfelse>
			<cfset masbotones = "Calcular, Aplicar">
			<cfset masbotonesv = "Ver cálculo, Aplicar">
		</cfif>
	</cfif>
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
<script language="JavaScript1.2">

	
	
	
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
	
	function _Field_isRango(low, high){
	if (_allowSubmitOnError!=true){
	var low=_param(arguments[0], 0, "number");
	var high=_param(arguments[1], 9999999, "number");
	var iValue=parseFloat(qf(this.value));
	if(isNaN(iValue))iValue=0;
	if((low>iValue)||(high<iValue)){this.error="El campo "+this.description+" debe ser mayor o igual que "+low+".";
	}}}
	_addValidator("isRango", _Field_isRango);
	
	
	<cfif modo NEQ "ALTA">
		objForm.OCid.description = "Órden Comercial";
		objForm.OCTid.description = "Transporte";
		objForm.AidOD.description = "Artículo Órden Comercial ";
	</cfif>	

	objForm.EDdocumento.description = "Código de Documento";
	objForm.CCTcodigo.description = "Tipo de Transaccion";
	objForm.SNcodigo.description = "Cliente";
	objForm.EDfecha.description = "Fecha";
	objForm.Mcodigo.description = "Moneda";
	objForm.Ocodigo.description = "Oficina";
	objForm.Rcodigo.description = "Retención";
	objForm.Ccuenta.description = "Cuenta";
	objForm.id_direccionEnvio.description = "Dirección de Envío";
	objForm.id_direccionFact.description = "Dirección de Facturación";
	objForm.EDtipocambio.description = "Tipo de Cambio";
	objForm.EDdescuento.description = "Descuento";
	<cfif form.tipo EQ "D">
	objForm.TESRPTCid.required = true;
	objForm.TESRPTCid.description = "Pagos a terceros";
	</cfif>
	<cfif form.tipo EQ "D" and rsVerificaExistenciaVend.Cantidad>
	objForm.DEid.description = "Vendedor";
	</cfif>
	<cfif modo NEQ "ALTA">
		objForm.Aid.description = "Artículo";
		objForm.Cid.description = "Concepto";
		objForm.CFid.description = "Centro Funcional";
		objForm.Almacen.description = "Almacén";
		objForm.DDdescripcion.description = "Descripción";		
		<cfif isdefined("rsPintaCuentaParametro") and rsPintaCuentaParametro.Pvalor NEQ 'N'>
		objForm.CcuentaD.description = "Cuenta del Detalle";
		</cfif>
		objForm.DDpreciou.description = "Precio Unitario";	
		objForm.DDcantidad.description = "Cantidad";	
		objForm.DDdesclinea.description = "Descuento de Línea";

		objForm.DDtotallinea.description = "Total de Línea";
	</cfif>
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
	
	function FuncVenc(){
		if (document.form1.tipo.value == 'D'){
			if (document.form1.EDfecha.value != ''){
			document.form1.FechaVencimiento.value = dateadd(document.form1.DEdiasVencimiento.value,document.form1.EDfecha.value);
			}else{
				alert('Debe de digitar una la fecha del Documento.');
				document.form1.EDfecha.focus();
				return false;
			}
		}
	}

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
			document.form1.Ccodigo.focus();
		}
		if (document.form1.DDtipo.value=="S"){
			document.form1.OCcontrato.focus();
		}
	<cfelseif modo EQ 'ALTA' and isdefined('form.SNcodigo')>
		document.form1.EDfecha.focus();
	</cfif>
	

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
				alert('Tiene que seleccionar una orden comercial');			
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
					alert('Tiene que seleccionar una orden comercial');			
				}
			}
			else{
				var frame  = document.getElementById("FRAMETRANSPORTE");
				frame.src 	= "validaTransporte.cfm" + PARAM;
			}
		}
	}

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
</script>



