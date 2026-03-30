<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<!---------
	Modificado por Gustavo Fonseca H.
		Fecha: 11-7-2006.
		Motivo: Se habilitan o deshabilitan campos según se escoja el Item del detalle.

	Modificado por Gustavo Fonseca H.
		Fecha: 30-1-2006.
		Motivo: Se ordenan los tabs de la pantalla para que tengan una secuencia lógica. Tambien se corrige que valide 
		el campo CFdescripcion y no el CFcodigo, por que se podía digitar el CFcodigo y darle enter al form, lo que hacía
		submit y no permitía al tag traer la información, y hacía que diera error en la pantalla.

	Modificado por: Ana Villavicencio
		Fecha de modificación: 12 de mayo del 2005
		Motivo: corrección en el proceso de calculo de impuesto y actualización del totales del encabezado del
			documento. Ademas de corrección en la estructura de la consulta para que no de problemas en Oracle.
	Modificado por Gustavo Fonseca H.
		Fecha de modificación: 12 de mayo del 2005 12:01 PM
		Motivo: se agrega el campo Fecha de Arribo, para tomarlo en cuenta en el cálculo de los días de vencimiento.
	Modificado por Gustavo Fonseca H.
		Fecha de modificación: 30 Mayo del 2005
		Motivo: Se agrega el botón Orden Compra.
	Modificado por: Rodolfo Jiménez Jara
		Fecha de Modificación: 14 Junio de 2006
		Motivo: Agregar parámetro de verClasificaCP, para no mostrar la columna de clasificación del 
		conlis de Conceptos de servicio
	Modificado por: Ana Villavicencio
		Fecha de modificación: 17 junio del 2005
		Motivo:modificacion en la forma, se agrega un nuevo campo en la captura de datos de los documentos.
			Centro funcional. Se elimina el tag de cuenta contable cuando la cuenta contable del detalle no se
			asigna manualmente.
			Cuenta de la Cuenta por pagar no se escoge manualmente, se toma la cuenta asignada al socio de negocios, 
			solo se visualiza
	Modificado por Gustavo Fonseca H.
		Fecha de modificación: 23-6-2005
		Motivo: se agrega el campo Dirección de Factura.

	Modificado por: Ana Villavicencio R.
		Fecha de modificación: 07 de julio del 2005
		Motivo: Se corrigió error a la hora de seleccionar el Proveedor, 
			no mantenia el dato del documento ni el tipo de transacción.
		Líneas
	
	Modificado por Gustavo Fonseca H.
		Fecha de modificación: 8-7-2005
		Motivo: Se pide la fecha de arribo como obligatoria. Se valida que la fecha de arribo no sea menor que la fecha del documento.

	Modificado por Gustavo Fonseca H.
		Fecha de modificación: 8-7-2005
		Motivo: Se arregla el campo Referencia para que solo muestre el registro que fue grabado en la base de datos (antes mostraba el 
		primer registro de todos los documentos de referencias posibles). Se valida que el rsReferencia solo encuentre un registro.
	
	Modificado por Gustavo Fonseca H.
		Fecha de modificación: 19-7-2005
		Motivo: Atiende boleta de soporte SOIN-018, Se desdocumentó la función referescar.	
	- Modificado por Gustavo Fonseca H.
		Fecha: 4-8-2005
		Motivo: - Se modifica para arreglar la seguridad de CxP en los procesos de facturas y notas de crédito, para que seguridad sepa 
				con cual de los dos procesos está trabajando. Esto porque se estaba trabajando con un archivo para los dos procesos.
				- Se agrega el botón nuevo en el form para que no tenga que salir hasta la lista para hacer uno nuevo (CHAVA).

	Modificado por: Ana Villavicencio
		Fecha: 17 de Agosto del 2005
		Motivo: Validar el parametro de Indicar manualmente la cuenta del documento. en estos momentos no permite modificar la cuenta, 
			esto para la cuenta del proveedor, cuando este parametro indica que puede hacerce manual. Se pone la condicion cuando 
			se hace el pintado de la cuenta si el parametro es 'S' entonces muestra el tag de cuentas con la cuenta sugerida

	Modificado por: Ana Villavicencio
		Fecha: 22 de agosto del 2005
		Motivo: No guarda la cuenta asignada por le sistema para el encabezado.  Se elimina un hidden (Ccuenta).
				
	- Modificado por Gustavo Fonseca Hernández.
		Fecha 23-8-2005.
		Motivo: Se corrige la función del botón de regresar para que llame al archivo correcto de acuerdo al tipo (C o D) y así no
		se pierde la seguridad y el menú de Navegación. Antes si estaba en una factura y le daba regrasar se iba a la lista de
		notas de crédito.

	Modificado por: Ana Villavicencio
		Fecha: 12 de setiembre del 2005
		Motivo: No permitia poner montos menores q 0 para el tipo de cambio en el encabezado. 
			Se modificó la validacion del rango en qforms para ese campo.
	Modificado por: Gustavo FonsecaH.
		Fecha: 26 de setiembre del 2005
		Motivo: Valida que el Tipo de Cambio sea diferente de 0 (cero).
	
	Modificado por Gustavo Fonseca H.
		Fecha: 12-1-2006.
		Motivo: Reacomodo de la pantalla. Se agrega el botón de facturas recurrentes.
	
----------->
<cfif isdefined('url.IDdocumento') and LEN(TRIM(url.IDdocumento))> 
	<cfset Form.IDdocumento = url.IDdocumento>
</cfif>

<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<!--- Limpia los valores para cuando el registro es nuevo. --->
<cfif isDefined("form.btnNuevo")>
	<cfif form.btnNuevo EQ "Nuevo">
 		<cfset form.CPTDescripcion = "">
		<cfset form.EDdocumento = "">
		<cfset form.EDfecha = "">
		<cfset form.EDtotal = "">
		<cfset form.EDusuario = "">
		<cfset form.IDdocumento = "">
		<cfset form.Mnombre = "">
		<cfset form.SNidentificacion = "">
		<cfset form.SNnombre = "">
	</cfif>
</cfif>

<cfset LvarXCantidad = 0> <!--- No maneja cantidad ---->
<cfquery name="rsParam" datasource="#session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo = #Session.Ecodigo#
	  and Pcodigo = 2
</cfquery>
<cfif isdefined("url.datos") and len(trim(url.datos)) and not isdefined("form.datos")>
	<cfset form.datos = url.datos>
</cfif>
<cfif isdefined("form.tipo") and len(trim(form.tipo)) and not isdefined("form.DDtipo")>
	<cfset form.DDtipo = form.tipo>
</cfif>

<cfif not isDefined("Form.NuevoE")>
	<cfif isDefined("Form.datos") and Len(Trim(Form.datos)) NEQ 0 >
		<cfset arreglo = ListToArray(Form.datos,"|")>
		<cfset sizeArreglo = ArrayLen(arreglo)>
		<cfset IDdocumento = Trim(arreglo[1])>
 		<cfif sizeArreglo EQ 2>
			<cfset Linea = Trim(arreglo[2])>
			<cfset modoDet = "CAMBIO">
		</cfif>		
	<cfelse>
		<cfset IDdocumento = Trim(Form.IDdocumento)>
		<cfif isDefined("Form.Linea") and Len(Trim(Form.Linea)) NEQ 0>
			<cfset Linea = Trim(Form.Linea)>
		</cfif>
	</cfif>
</cfif>

<cfquery name="rsTransacciones" datasource="#Session.DSN#">
	select 	a.CPTcodigo, 
			case when coalesce(a.CPTvencim,0) < 0 
				then 
					
					<cf_dbfunction name="sPart"	args="a.CPTdescripcion,1,10"> #_Cat#' (contado)'
				else 
					<cf_dbfunction name="sPart"	args="a.CPTdescripcion,1,20"> 
				end as CPTdescripcion,
			case when coalesce(a.CPTvencim,0) >= 0 then 1 else 2 end as CPTorden,
			a.CPTtipo
	<cfif isdefined("form.CPTcodigo") and (isdefined("form.SNcodigo") and LEN(TRIM(form.SNcodigo)))>
			, case when ctas.CFcuenta is null
				then
					(
						select min(rtrim(CFformato))
						  from CFinanciera
						 where Ccuenta = n.SNcuentacxp
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
						select min(CFdescripcion)
						  from CFinanciera
						 where Ccuenta = n.SNcuentacxp
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
				then n.SNcuentacxp
				else
					(
						select Ccuenta
						  from CFinanciera
						 where CFcuenta = ctas.CFcuenta
					)
				end
			as Ccuenta
	  from CPTransacciones a
	  	 inner join SNegocios n
		 	 on n.Ecodigo 	= #session.Ecodigo#
			and n.SNcodigo 	= #form.SNcodigo#
	  	 left join SNCPTcuentas ctas
		 	 on ctas.Ecodigo 	= #session.Ecodigo#
			and ctas.SNcodigo 	= #form.SNcodigo#
			and ctas.CPTcodigo 	= a.CPTcodigo
	<cfelse>
	  from CPTransacciones a
	</cfif>
	 where a.Ecodigo = #Session.Ecodigo#
	   and a.CPTtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.tipo#"><!--- 'D' --->
	   and coalesce(a.CPTpago,0) != 1
	   and NOT a.CPTdescripcion like '%Tesorer_a%'
	order by case when coalesce(a.CPTvencim,0) >= 0 then 1 else 2 end, a.CPTcodigo
</cfquery>

<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select Mcodigo 
	from Empresas
	where Ecodigo = #Session.Ecodigo#
</cfquery>

<cfquery name="rsOficinas" datasource="#Session.DSN#">
	select Ocodigo, Odescripcion from Oficinas 
	where Ecodigo = #Session.Ecodigo#
	order by Ocodigo                      
</cfquery>

<cfquery name="rsCF" datasource="#session.DSN#">
	select CFid, CFdescripcion 
	from CFuncional
	where Ecodigo = #session.Ecodigo#
	order by CFdescripcion
</cfquery> 

<cfquery name="rsImpuestos" datasource="#Session.DSN#">
	select Icodigo, Idescripcion 
	from Impuestos 
	where Ecodigo = #Session.Ecodigo#
	order by Idescripcion                                 
</cfquery>

<cfquery name="rsRetenciones" datasource="#Session.DSN#">
	select Rcodigo, Rdescripcion 
	from Retenciones 
	where Ecodigo = #Session.Ecodigo#
	order by Rdescripcion
</cfquery>

<cfquery name="rsCuentaActivo" datasource="#Session.DSN#">
	select a.Pvalor
	from Parametros a 
	where a.Ecodigo = #Session.Ecodigo#
	  and a.Pcodigo = 240
</cfquery>
<cfif rsCuentaActivo.recordcount EQ 0 or len(trim(rsCuentaActivo.Pvalor)) EQ 0>
	<cf_errorCode	code = "50342" msg = "La cuenta de Activos en Transito no esta Definida. Proceso Cancelado!">
</cfif>
<cfquery name="rsCuentaActivo" datasource="#Session.DSN#">
	select b.Ccuenta, b.Cformato, b.Cdescripcion 
	from CContables b
	where b.Ecodigo = #Session.Ecodigo#
	  and b.Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentaActivo.Pvalor#">
</cfquery>


<cfquery name="rsFechaHoy" datasource="#Session.DSN#">
	select <cf_dbfunction name='today'> as Fecha 
    from dual
</cfquery>

<cfquery name="TCsug" datasource="#Session.DSN#">
	select tc.Mcodigo, tc.TCcompra, tc.TCventa
	from Htipocambio tc
	where tc.Ecodigo = #Session.Ecodigo#
	  and tc.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechaHoy.Fecha#">
	  and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechaHoy.Fecha#">
</cfquery>

<cfquery name="rscArticulos" datasource="#Session.DSN#">
	select count(1) as cant 
	from Articulos 
	where Ecodigo = #Session.Ecodigo#
</cfquery>

<cfquery name="rscConceptos" datasource="#Session.DSN#">
	select count(1) as cant 
	from Conceptos 
	where Ecodigo = #Session.Ecodigo#
</cfquery>

<cfset LvarSNid = -1>
<cfif (isdefined("form.SNidentificacion") and len(trim(form.SNidentificacion))) or (isdefined("form.SNnumero") and len(trim(form.SNnumero)))>
	<cfquery name="rsSociosN" datasource="#session.DSN#">
		select SNid, SNcodigo, SNnombre, SNidentificacion, DEidVendedor, DEidCobrador, SNcuentacxp, SNvenventas
		from SNegocios a, EstadoSNegocios b
		where a.Ecodigo = #Session.Ecodigo# 
		  and a.ESNid = b.ESNid	
		  <cfif isdefined('Form.SNnumero') and len(trim(Form.SNnumero))>
			and a.SNnumero = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNnumero#"> 
		  </cfif>
		  <cfif isdefined('Form.SNidentificacion') and len(trim(Form.SNidentificacion))>
			and a.SNidentificacion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNidentificacion#"> 
		  </cfif>
	</cfquery> 
	<cfset LvarSNid = rsSociosN.SNid>
</cfif> 
	
<cfif (isdefined('Form.SNnumero') and LEN(trim(Form.SNnumero)) and modo EQ 'ALTA') or (isdefined('Form.SNidentificacion') and LEN(trim(Form.SNidentificacion)) and modo EQ 'ALTA')>

	<cfquery datasource="#session.dsn#" name="direcciones">
		select 
			b.id_direccion, 
		 	<cf_dbfunction name="concat" args="c.direccion1,' / ',c.direccion2"> as texto_direccion
			,case when b.SNDCFcuentaProveedor is null
				then
					(
						select min(rtrim(CFformato))
						  from CFinanciera
						 where Ccuenta = a.SNcuentacxp
					)
				else
					(
						select rtrim(CFformato)
						from CFinanciera
						where Ccuenta = b.SNDCFcuentaProveedor
					)
				end
			as CFformato
			, case when b.SNDCFcuentaProveedor is null
				then
					(
						select min(CFdescripcion)
						  from CFinanciera
						 where Ccuenta = a.SNcuentacxp
					)
				else
					(
						select CFdescripcion
						from CFinanciera
						where Ccuenta = b.SNDCFcuentaProveedor
					)
				end
			as CFdescripcion
			, case when b.SNDCFcuentaProveedor is null
				then
					a.SNcuentacxp
				else
					b.SNDCFcuentaProveedor
				end 
			as Ccuenta
		
		from SNegocios a
			join SNDirecciones b
				on a.SNid = b.SNid
			join DireccionesSIF c
				on c.id_direccion = b.id_direccion
		where a.Ecodigo = #Session.Ecodigo# 
		<cfif isdefined("form.SNnumero") and len(trim(form.SNnumero))>
			and a.SNnumero = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNnumero#"> 
		</cfif>
		<cfif isdefined("form.SNidentificacion") and len(trim(form.SNidentificacion))>
			and a.SNidentificacion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNidentificacion#"> 
		</cfif>
		  and b.SNDfacturacion = 1
	</cfquery>
<cfelse>
	<cfset direcciones = QueryNew('id_direccion,Direccion')>
</cfif>
	
<cfif isdefined("rsSociosN") and rsSociosN.recordcount EQ 1 and rsSociosN.SNcuentacxp EQ ''>
	<cf_errorCode	code = "50183" msg = "La cuenta para el Socio de Negocios debe ser definida.">
</cfif>

<!---Formulado por en parametros generales--->
<cfquery name="rsUsaPlanCuentas" datasource="#Session.DSN#">
	select Pvalor
		from Parametros
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo=2300
</cfquery>
<cfset LvarParametroPlanCom=1> <!---1 equivale a plan de compras en parametros generales--->
 
  <!---Variables para hacer visibles o no los campos cuando esta definido el plan de compras--->
	  <cfif rsUsaPlanCuentas.Pvalor eq LvarParametroPlanCom> 
			<cfset LvarPlanDeCompras=true>
			<cfset LvarPlanDeCompras2="yes">
	  <cfelse>
			<cfset LvarPlanDeCompras=false>
			<cfset LvarPlanDeCompras2="no">
	  </cfif>
	  
<cfif modo NEQ "ALTA">
	<cfquery name="rsAlmacenes" datasource="#Session.DSN#">
		select Aid, Bdescripcion 
		from Almacen 
		where Ecodigo = #Session.Ecodigo#
		order by Bdescripcion                                                                   
	</cfquery>

	<cfquery name="rsDepartamentos" datasource="#Session.DSN#">
		select Dcodigo, Ddescripcion 
		from Departamentos 
		where Ecodigo = #Session.Ecodigo#
		order by Ddescripcion
	</cfquery>

	<cfquery name="rsDocumento" datasource="#Session.DSN#">
		select 	IDdocumento, 
				d.CPTcodigo, TESRPTCid,
				EDdocumento, SNcodigo, 
				Mcodigo, 
				EDtipocambio, Icodigo, EDdescuento, EDporcdescuento, EDimpuesto, EDtotal, EDfecha,
				Ocodigo, Ccuenta, id_direccion, Rcodigo, EDdocref, EDfechaarribo, 
                coalesce(
                    (
                        select sum(DDtotallinea)
                          from DDocumentosCxP
                         where IDdocumento = d.IDdocumento
                    )
                ,0) as Subtotal,
				d.ts_rversion
		from EDocumentosCxP d
		where d.Ecodigo = #Session.Ecodigo#
		  and d.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDdocumento#">
	</cfquery>
	
	<cfquery datasource="#session.dsn#" name="direcciones">
		select 
			b.id_direccion, 
			<cf_dbfunction name="concat" args="c.direccion1,' / ',c.direccion2"> as texto_direccion
		from SNegocios a
			join SNDirecciones b
				on a.SNid = b.SNid
			join DireccionesSIF c
				on c.id_direccion = b.id_direccion
		where a.Ecodigo = #Session.Ecodigo# 
		  and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDocumento.SNcodigo#"> 
	</cfquery>

	<cfquery name="rsReferencia" datasource="#Session.DSN#">
		select a.IDdocumento, a.CPTcodigo, a.Ddocumento
		from EDocumentosCP a left outer join CPTransacciones b
		  on a.CPTcodigo = b.CPTcodigo and
			 a.Ecodigo = b.Ecodigo 
		where a.Ecodigo = #Session.Ecodigo#  
		  and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDocumento.SNcodigo#"> 
		  <cfif isDefined("rsDocumento") and len(trim(rsDocumento.EDdocref))>
		  	and a.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDocumento.EDdocref#">
		  </cfif>
		  and b.CPTtipo = <cfqueryparam cfsqltype="cf_sql_char" value="C">
		  and coalesce(b.CPTpago, 0) != 1
	</cfquery>

	<cfquery name="rsNombreSocio" datasource="#Session.DSN#">
		select SNid, SNcodigo, SNidentificacion, SNnombre, SNcuentacxp,Cdescripcion
		from SNegocios a left outer join CContables b
		  on a.Ecodigo = b.Ecodigo  and 
		     a.SNcuentacxp = b.Ccuenta
		where a.Ecodigo = #Session.Ecodigo#
		  and SNcodigo = #rsDocumento.SNcodigo#
	</cfquery>
	<cfset LvarSNid = rsNombreSocio.SNid>
	<cfquery name="rsNombreTransac" datasource="#Session.DSN#">
		select CPTcodigo, CPTdescripcion 
		  from CPTransacciones 
		 where Ecodigo = #Session.Ecodigo#
		   and CPTcodigo = '#rsDocumento.CPTcodigo#'
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
		from CuentasConceptos a left outer join  CContables b
		  on a.Ecodigo = b.Ecodigo and
		  	 a.Ccuenta = b.Ccuenta
		where a.Ecodigo = #Session.Ecodigo#
	</cfquery>
	
	<cfif modoDet NEQ "ALTA">
		<cfquery name="rsLinea" datasource="#Session.DSN#">
			select 
				a.IDdocumento, 
				a.Linea, 
				a.DOlinea,
				a.Aid,
				a.Cid, 
				coalesce(CFid, 0) as CFid,
				a.DDdescripcion,
				a.DDdescalterna,
				a.DDcantidad,
				#LvarOBJ_PrecioU.enSQL_AS("a.DDpreciou")#,
				a.DDdesclinea,
				a.DDporcdesclin,
				a.DDtotallinea,
				a.DDtipo, 
				a.Ccuenta, a.CFcuenta,
				a.Alm_Aid,
				a.Dcodigo,
				a.OCTtipo,
				a.OCTtransporte,
				a.OCTfechaPartida,
				a.OCTobservaciones,
				a.OCCid,a.OCid,
				a.ts_rversion,
				b.Cformato,
				b.Cdescripcion,
				a.Icodigo,
				a.PCGDid
			from DDocumentosCxP a 
				left outer join CContables b
			  		on a.Ccuenta = b.Ccuenta			  
			where a.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDdocumento#">
			  and a.Linea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Linea#">
		</cfquery>  
		
		<cfif rsLinea.recordcount gt 0 and rsUsaPlanCuentas.Pvalor eq LvarParametroPlanCom and LEN(TRIM(rsLinea.PCGDid))>
			 <cfquery name="rsManejaCantidad" datasource="#session.DSN#">
			   Select PCGDxCantidad from PCGDplanCompras where PCGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLinea.PCGDid#">
			 </cfquery>   					
			 <cfset LvarXCantidad = #rsManejaCantidad.PCGDxCantidad#>				
			<cfif modoDet neq 'ALTA' and  len(trim(rsLinea.PCGDid)) neq 0 and  len(trim(rsLinea.DOlinea)) eq 0 and rsLinea.DDtipo eq 'F'>
				<cfset LvarXCantidad = 1>
			</cfif>					
		</cfif>           
		
		<cfif isdefined("rsLinea") and rsLinea.recordcount eq 1 and len(trim(rsLinea.DOlinea))>
			<cfquery name="rsOrdenCompra" datasource="#session.DSN#">
				select EOnumero, 
					(select DOconsecutivo
						from DOrdenCM
						where DOlinea = #rsLinea.DOlinea#
						) as DOconsecutivo
					
					from EOrdenCM
					where EOidorden = (
									select EOidorden
									from DOrdenCM
									where DOlinea = #rsLinea.DOlinea#
									)
			</cfquery>
			
		</cfif>
		
		<cfquery name="rsCF" datasource="#session.DSN#">
			select CFid, CFcodigo, CFdescripcion
			from CFuncional
			where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLinea.CFid#">
		</cfquery>

	</cfif>
</cfif>

<!--- Hecho por Rodolfo Jiménez Jara --->
<cfquery name="rsverCalsificaCP" datasource="#Session.DSN#">
	select Pvalor as verClasificaCP
	from Parametros
	where Ecodigo = #Session.Ecodigo#  
	  and Pcodigo = 690
</cfquery>

<cfif isdefined("rsverCalsificaCP") and  rsverCalsificaCP.Recordcount NEQ 0> 
	<cfset verClasCP = rsverCalsificaCP.verClasificaCP>
<cfelse>
	<cfset verClasCP = 0>
</cfif>

<script language="JavaScript" src="../../js/calendar.js"></script>
<script language="JavaScript" src="../../js/utilesMonto.js"></script>
<script language="JavaScript" src="../../js/fechas.js"></script>
<script type="text/javascript" src="/cfmx/sif/js/Macromedia/wddx.js"></script>
<script language="JavaScript" type="text/javascript" src="../../js/qForms/qforms.js"></script>
<script language="JavaScript1.2">
var popUpWin=0; 
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin)
	  {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	
	function doConlisReferencias() {
		if (document.form1.SNcodigo.value != "" )
			popUpWindow("ConlisReferencias.cfm?form=form1&docref=EDdocref&ref=Referencia&ref1=Referencia1&SNcodigo="+document.form1.SNcodigo.value,250,200,650,350);
		else
			alert("Debe seleccionar un Proveedor");
	}
	
	function limpiarRef() {
		document.form1.EDdocref.value = "";
		document.form1.Referencia.value = "";
		document.form1.Referencia1.value = "";		
	}

	function doConlisItem() {
		if (document.form1.DDtipo.value == "A")
			popUpWindow("ConlisArticulos.cfm?form=form1&id=Aid&desc=descripcion&Alm="+document.form1.Almacen.value,250,200,650,350);		
		if (document.form1.DDtipo.value == "S")
			popUpWindow("ConlisConceptos.cfm?form=form1&id=Cid&desc=descripcion&depto="+document.form1.Dcodigo.value,250,200,650,350);
	}


	function Lista() {
		var params   = '?pageNum_lista='+document.form1.pageNum_lista.value;
			params += (document.form1.fecha.value != '') ? "&fecha=" + document.form1.fecha.value : '';
			params += (document.form1.transaccion.value != '') ? "&transaccion=" + document.form1.transaccion.value : '';
			params += (document.form1.documento.value != '') ? "&documento=" + document.form1.documento.value : '';			
			params += (document.form1.usuario.value != '') ? "&usuario=" + document.form1.usuario.value : '';
			params += (document.form1.moneda.value != '') ? "&moneda=" + document.form1.moneda.value : '';
			params += (document.form1.registros.value != '') ? "&registros=" + document.form1.registros.value : '';
			params += (document.form1.tipo.value != '') ? "&tipo=" + document.form1.tipo.value : '';

		<cfif isdefined("form.tipo") and len(trim(form.tipo)) and form.tipo eq 'D'> <!--- Notas de Crédito --->
			location.href="RegistroNotasCreditoCP.cfm"+params;
		<cfelseif isdefined("form.tipo") and len(trim(form.tipo)) and form.tipo eq 'C'> <!--- Facturas --->
			location.href="RegistroFacturasCP.cfm"+params;
		</cfif>
	}
	//elimina el formato numerico de una hilera, retorna la hilera
	function qf(Obj)
	{
		var VALOR=""
		var HILERA=""
		var CARACTER=""
		if(Obj.name)
		  VALOR=Obj.value
		else
		  VALOR=Obj
		for (var i=0; i<VALOR.length; i++) {	
			CARACTER =VALOR.substring(i,i+1);
			if (CARACTER=="," || CARACTER==" ") {
				CARACTER=""; //CAMBIA EL CARACTER POR BLANCO
			}  
			HILERA+=CARACTER;
		}
		return HILERA
	}

	//Verifica si un valor es numerico (soporta unn punto para los decimales unicamente)
	function ESNUMERO(aVALOR)
	{
		var NUMEROS="0123456789."
		var CARACTER=""
		var CONT=0
		var PUNTO="."
		var VALOR = aVALOR.toString();
		
		for (var i=0; i<VALOR.length; i++)
			{	
			CARACTER =VALOR.substring(i,i+1);
			if (NUMEROS.indexOf(CARACTER)<0) {
				return false;
				} 
			}
		for (var i=0; i<VALOR.length; i++)
			{	
			CARACTER =VALOR.substring(i,i+1);
			if (PUNTO.indexOf(CARACTER)>-1)
				{CONT=CONT+1;} 
			}
		
		if (CONT>1) {
			return false;
		}
		
		return true;
	}

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
	
	function getTipoCambio(formulario) {
		var frameE = document.getElementById("frameExec");
	
		frameE.src = "obtenerTipocambioDocumentosCP.cfm?form=" + formulario.name + "&EDfecha=" + formulario.EDfecha.value + "&Mcodigo=" + formulario.Mcodigo.value;
	}

	function setTipoCambio(formulario, valor) { 
		formulario.EDtipocambio.value = fm(valor, 4);
	}
	
	function obtenerTC(f) {
		if (f.Mcodigo.value == f.monedalocal.value) { 
			f.EDtipocambio.value = "1.0000";
			f.EDtipocambio.disabled = true;
		} 
		else if (document.form1.haydetalle.value == "NO") { 
			getTipoCambio(f);
			validatc(f);
		}
	}

	function valida() {
		if (!validaE()) 
			return false;
		<cfif modo NEQ "ALTA"> return validaD(); </cfif>
		return true;
	}

	function validaE() {
		document.form1.EDtotal.value = qf(document.form1.EDtotal.value);		
		document.form1.EDdescuento.value = qf(document.form1.EDdescuento.value);		
		document.form1.EDimpuesto.value = qf(document.form1.EDimpuesto.value); 
		if (datediff(document.form1.EDfecha.value, document.form1.EDfechaarribo.value) < 0) 
			{	
				alert ('La fecha de arribo debe ser mayor a la fecha del documento');
				return false;
			} 
		return true;
	}

	function validatc()
	{   	
		document.form1.EDtipocambio.disabled = false;		
		if (document.form1.Mcodigo.value == document.form1.monedalocal.value){						
			document.form1.EDtipocambio.value = "1.0000";
			document.form1.EDtipocambio.disabled = true;          			
		} 
		else{
			<cfwddx action="cfml2js" input="#TCsug#" topLevelVariable="rsTCsug"> 
			//Verificar si existe en el recordset
			var nRows = rsTCsug.getRowCount();
			if (nRows > 0) {
				for (row = 0; row < nRows; ++row) {
					if (rsTCsug.getField(row, "Mcodigo") == document.form1.Mcodigo.value 
						&& rsTCsug.getField(row, "Mcodigo") == document.form1.Mcodigo.value) {
						document.form1.EDtipocambio.value =fm( rsTCsug.getField(row, "TCventa"),4);
						row = nRows;
					}
					else
						document.form1.EDtipocambio.value = "0.00";					
				}									
			}
			else 
				document.form1.EDtipocambio.value = "0.00";			
		}		
	}
	

	function poneItem() {
		if (document.form1.DDtipo.value == "A"){ 
			document.getElementById("labelarticulo").style.display = '';
			document.getElementById("labelconcepto").style.display = 'none';
		}
		if (document.form1.DDtipo.value == "T"){ 
			document.getElementById("labelarticulo").style.display = 'none';
			document.getElementById("labelconcepto").style.display = 'none';
		}		
		
		if (document.form1.DDtipo.value == "S"){ 
			document.getElementById("labelarticulo").style.display = 'none';
			document.getElementById("labelconcepto").style.display = '';
		}

		if (document.form1.DDtipo.value == "F"){ 
			document.getElementById("labelarticulo").style.display = 'none';
			document.getElementById("labelconcepto").style.display = 'none';
		}

	}
	
	function validatcLOAD()
	{                      		  
		  <cfif modo EQ "ALTA">
				if (document.form1.Mcodigo.value==document.form1.monedalocal.value)	{
					document.form1.EDtipocambio.value = "1.00";                                
					document.form1.EDtipocambio.disabled = true;
				}  
				else {
					document.form1.Mcodigo.value=document.form1.monedalocal.value;
					document.form1.EDtipocambio.value = "1.00";
					document.form1.EDtipocambio.disabled = true;                    
				} 
		   <cfelse>
				if (document.form1.Mcodigo.value==document.form1.monedalocal.value)
					document.form1.EDtipocambio.disabled = true;
				else
					document.form1.EDtipocambio.disabled = false;
		   </cfif>   

	}   
	
	function validatcLOAD(f) {
		if (document.form1.haydetalle.value == "SI") {
			document.form1.EDtipocambio.disabled = true
		} else {
			if (document.form1.Mcodigo != null && document.form1.Mcodigo.value == document.form1.monedalocal.value) {
				document.form1.EDtipocambio.value = "1.0000"
				document.form1.EDtipocambio.disabled = true
			}
		}
		document.form1.EDtipocambio.value = fm(document.form1.EDtipocambio.value, 4);
	}

	function initPage(f) {
		validatcLOAD(f);
		<cfif modo NEQ "CAMBIO">
		obtenerTC(f);
		</cfif>
	}


	function suma()
	{               		
		if (document.form1.DDpreciou.value=="" ) document.form1.DDpreciou.value = "<cfoutput>#LvarOBJ_PrecioU.enCF(0)#</cfoutput>";
		if (document.form1.DDdesclinea.value=="")document.form1.DDdesclinea.value = "0.00";
		if (document.form1.DDcantidad.value=="" )document.form1.DDcantidad.value = "0.00";
		
		if (document.form1.DDpreciou.value=="-" ){
			document.form1.DDpreciou.value = "<cfoutput>#LvarOBJ_PrecioU.enCF(0)#</cfoutput>";
			document.form1.DDtotallinea.value = "0.00";
		}    		
		
		if (document.form1.DDdesclinea.value=="-"){    
			document.form1.DDdesclinea.value = "0.00" 
			document.form1.DDtotallinea.value = "0.00"
		}		
		/*
		if (document.form1.DDcantidad.value=="-" ){
			document.form1.DDcantidad.value = "0.00"
			document.form1.DDtotallinea.value = "0.00"
		} */ 
				
		var cantidad = new Number(qf(document.form1.DDcantidad.value))
		if(cantidad == 0)
			cantidad = 1;
			
		var precio = new Number(qf(document.form1.DDpreciou.value))
		var descuento = new Number(qf(document.form1.DDdesclinea.value))		
		var seguir = "si"
		
		if(cantidad < 0){
			document.form1.DDcantidad.value="0.00"
			seguir = "no"
		}  
		
		if(precio < 0){
			document.form1.DDpreciou.value="<cfoutput>#LvarOBJ_PrecioU.enCF(0)#</cfoutput>";
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
			document.form1.DDtotallinea.value = redondear((cantidad * precio) - descuento,2)
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
		if (document.form1.CcuentaD) document.form1.CcuentaD.value = "";
		if (document.form1.CmayorD) 
		{
			document.form1.CmayorD.value = "";
			document.form1.CformatoD.value = "";
			document.form1.CdescripcionD.value = "";
		}
	}
	
	function cambiarDetalle(){	
	
		if(document.form1.DDtipo.value=="T"){
			document.getElementById("trv").style.display = '';
			document.getElementById("trv2").style.display = '';
		
			document.getElementById("labelConceptoT").style.display = 'none';
			document.getElementById("ConceptoT").style.display = 'none';
		
			document.getElementById("CFLabel").style.display = 'none';
			document.getElementById("centrofuncional").style.display = 'none';
			document.getElementById("labelconcepto").style.display 	= 'none';
			document.getElementById('concepto').style.display 		= 'none';
			document.getElementById('OrdenLabel').style.display 	= 'none';
			document.getElementById('OrdenImput').style.display 	= 'none';
			document.getElementById('articuloOD').style.display     = 'none';
			document.getElementById("labelarticulo").style.display = '';
			document.getElementById('articulo').style.display = 'none';


			document.getElementById("AlmacenLabel").style.display 	= '';
			document.getElementById("AlmacenImput").style.display 	= '';
			document.getElementById('articuloT').style.display = '';
			
			document.getElementById('TransporteLabel').style.display = '';
			document.getElementById('TransporteImput').style.display = '';

			document.getElementById("TRCUENTADET").style.display = '';

			if (document.form1.CmayorD) {alert('925');
				document.form1.CmayorD.disabled=true;
				document.form1.CformatoD.disabled=true;
				document.getElementById('hhref_CcuentaD').style.visibility = "hidden";
			}

			

		}
		if(document.form1.DDtipo.value=="O"){
			document.getElementById("TRCUENTADET").style.display = '';
			document.getElementById("trv").style.display = '';
			document.getElementById("trv2").style.display = '';
			
			document.getElementById("labelConceptoT").style.display = '';
			document.getElementById("ConceptoT").style.display = '';

			
			document.getElementById("CFLabel").style.display = 'none';
			document.getElementById("centrofuncional").style.display = 'none';
			document.getElementById("AlmacenImput").style.display 	= 'none';
			document.getElementById("AlmacenLabel").style.display 	= "none";
			document.getElementById("labelconcepto").style.display 	= 'none';
			document.getElementById('concepto').style.display 		= 'none';
			document.getElementById('articulo').style.display = 'none';
			document.getElementById('articuloT').style.display = 'none';


			document.getElementById("labelarticulo").style.display = '';
			document.getElementById('articuloOD').style.display     = '';
			document.getElementById('TransporteLabel').style.display = '';
			document.getElementById('TransporteImput').style.display = '';
			document.getElementById('OrdenLabel').style.display 	= '';
			document.getElementById('OrdenImput').style.display 	= '';
			
			if (document.form1.CmayorD) {alert('960');
				document.form1.CmayorD.disabled=true;
				document.form1.CformatoD.disabled=true;
				document.getElementById('hhref_CcuentaD').style.visibility = "hidden";
			}
			
			
		}
		if(document.form1.DDtipo.value=="A"){
			document.getElementById("trv").style.display = '';
			document.getElementById("trv2").style.display = 'none';
			document.getElementById("TRCUENTADET").style.display = '';
			
			document.getElementById("labelConceptoT").style.display = 'none';
			document.getElementById("ConceptoT").style.display = 'none';

			document.getElementById('TransporteLabel').style.display 	= 'none';
			document.getElementById('TransporteImput').style.display 	= 'none';
			document.getElementById('OrdenLabel').style.display 		= 'none';
			document.getElementById('OrdenImput').style.display 		= 'none';
			document.getElementById("CFLabel").style.display 			= 'none';
			document.getElementById("centrofuncional").style.display 	= 'none';
			document.getElementById("labelconcepto").style.display 		= 'none';
			document.getElementById('concepto').style.display 			= 'none';
			document.getElementById('articuloT').style.display = 'none';
			

			
			document.getElementById("AlmacenLabel").style.display 	= '';
			document.getElementById("AlmacenImput").style.display 	= '';
			document.getElementById("labelarticulo").style.display = '';
			document.getElementById('articulo').style.display = '';
			document.getElementById('articuloOD').style.display         = 'none';

			if (document.form1.CmayorD) {alert('994');
				document.form1.CmayorD.disabled=true;
				document.form1.CformatoD.disabled=true;
				document.getElementById('hhref_CcuentaD').style.visibility = "hidden";
			}
		} 

		if(document.form1.DDtipo.value=="S"){
			document.getElementById("trv").style.display = '';
			document.getElementById("trv2").style.display = 'none';
			document.getElementById("TRCUENTADET").style.display = '';
			
			document.getElementById("labelConceptoT").style.display = 'none';
			document.getElementById("ConceptoT").style.display = 'none';

			document.getElementById('TransporteLabel').style.display 	= 'none';
			document.getElementById('TransporteImput').style.display 	= 'none';
			document.getElementById('OrdenLabel').style.display 		= 'none';
			document.getElementById('OrdenImput').style.display 		= 'none';
			document.getElementById("labelarticulo").style.display 		= 'none';
			document.getElementById('articulo').style.display 			= 'none';
			document.getElementById("labelarticulo").style.display 		= 'none';
			document.getElementById('articuloOD').style.display         = 'none';
			document.getElementById("AlmacenImput").style.display 		= 'none';
			document.getElementById("AlmacenLabel").style.display 		= 'none';
			document.getElementById('articuloT').style.display = 'none';
			

			document.getElementById("CFLabel").style.display = '';
			document.getElementById("centrofuncional").style.display = '';
			document.getElementById("labelconcepto").style.display = '';
			document.getElementById('concepto').style.display = '';
			document.getElementById("labelconcepto").style.display = '';
			<cfif ucase(rsParam.Pvalor) EQ 'N'>
			if (document.form1.CmayorD ) {alert('1028 visible');
				document.form1.CmayorD.disabled=false;
				document.form1.CformatoD.disabled=false;
				document.getElementById('hhref_CcuentaD').style.visibility = "visible";
			}
		</cfif>
	
		}   
		if(document.form1.DDtipo.value=="P"){
			document.getElementById("trv").style.display = 'none';
			document.getElementById("trv2").style.display = 'none';
			document.getElementById("TRCUENTADET").style.display = '';
			
			document.getElementById("labelConceptoT").style.display = 'none';
			document.getElementById("ConceptoT").style.display = 'none';

			document.getElementById('TransporteLabel').style.display 	= '';
			document.getElementById('TransporteImput').style.display 	= '';
			document.getElementById('OrdenLabel').style.display 		= '';
			document.getElementById('OrdenImput').style.display 		= '';
			document.getElementById("labelarticulo").style.display 		= 'none';
			document.getElementById('articulo').style.display 			= 'none';
			document.getElementById("labelarticulo").style.display 		= 'none';
			document.getElementById('articuloOD').style.display         = 'none';
			document.getElementById("AlmacenImput").style.display 		= 'none';
			document.getElementById("AlmacenLabel").style.display 		= 'none';
			document.getElementById('articuloT').style.display = 'none';
			

			document.getElementById("CFLabel").style.display = '';
			document.getElementById("centrofuncional").style.display = '';
			document.getElementById("labelconcepto").style.display = '';
			document.getElementById('concepto').style.display = 'none';
			document.getElementById("labelconcepto").style.display = 'none';
			if (document.form1.CmayorD) {alert('1062 visible');
				document.form1.CmayorD.disabled=false;
				document.form1.CformatoD.disabled=false;
				document.getElementById('hhref_CcuentaD').style.visibility = "visible";
			}

		}                  
	  
	    if(document.form1.DDtipo.value=="F") {
			document.getElementById("trv").style.display = 'none';
			document.getElementById("trv2").style.display = 'none';
			document.getElementById("TRCUENTADET").style.display = '';
			document.getElementById('articuloT').style.display = 'none';
			document.getElementById('TransporteLabel').style.display = 'none';
			document.getElementById('TransporteImput').style.display = 'none';
			document.getElementById('OrdenLabel').style.display 	= 'none';
			document.getElementById('OrdenImput').style.display 	= 'none';
			document.getElementById("CFLabel").style.display = 'none';
			document.getElementById("centrofuncional").style.display = 'none';
			document.getElementById("labelarticulo").style.display = 'none';
			document.getElementById("labelconcepto").style.display = 'none';
			document.getElementById('articulo').style.display = 'none';
			document.getElementById('concepto').style.display = 'none';
			document.getElementById('articuloOD').style.display         = 'none';
			document.form1.Aid.value="";
			document.form1.Cid.value="";
			document.getElementById("AlmacenImput").style.display 		= 'none';
			document.getElementById("AlmacenLabel").style.display 		= 'none';
			 
		if(document.form1.LvarPlanDeCompras == false){
				    if (document.form1.CcuentaD){document.form1.CcuentaD.value = "<cfoutput>#rsCuentaActivo.Ccuenta#</cfoutput>";
				document.form1.CdescripcionD.value = "<cfoutput>#rsCuentaActivo.Cdescripcion#</cfoutput>";}
	
				<cfif len(rsCuentaActivo.Cformato) GTE 5>
					if (document.form1.CmayorD) {document.form1.CmayorD.value = "<cfoutput>#mid(rsCuentaActivo.Cformato,1,4)#</cfoutput>";
					document.form1.CformatoD.value = "<cfoutput>#trim(mid(rsCuentaActivo.Cformato,6,len(rsCuentaActivo.Cformato)))#</cfoutput>";}
				<cfelse>
					if (document.form1.CmayorD) {document.form1.CmayorD.value = "<cfoutput>#rsCuentaActivo.Cformato#</cfoutput>";
					document.form1.CformatoD.value = "";}
				</cfif>
	}			
		
			if (document.form1.CmayorD) {document.form1.CmayorD.disabled=true; alert('1106 hidden');
			document.form1.CformatoD.disabled=true;
			document.getElementById('hhref_CcuentaD').style.visibility = "hidden";
			}
		}
	}   
	
	function Verifica(){
		if (document.form1.DDtipo.value == 'S'){alert('1116 visible');
			document.form1.CFcodigo.disabled = false;
			document.form1.Ecodigo_CcuentaD.disabled = false;
			document.getElementById("imagenCxP").style.visibility = "visible";
			document.getElementById('hhref_CcuentaD').style.visibility = "visible";
					}
		else{
			document.form1.CFcodigo.disabled = true; alert('1118 hidden');
			document.getElementById('hhref_CcuentaD').style.visibility = "hidden";
			document.form1.Ecodigo_CcuentaD.disabled = true;
			document.getElementById("imagenCxP").style.visibility = "hidden";

		}
	}   

	function limpiarAxCombo(){   
	   document.form1.Aid.value =""
	   //document.form1.descripcion.value=""
	   document.form1.Aid.value=""
	   document.form1.Acodigo.value=""
	   document.form1.Adescripcion.value=""
	   document.form1.DDdescripcion.value=document.form1.Adescripcion.value
	   
		if (document.form1.CcuentaD)document.form1.CcuentaD.value = '';
		if (document.form1.CmayorD) {document.form1.CmayorD.value = '';
		document.form1.CformatoD.value = '';
		document.form1.CdescripcionD.value = '';}
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
			if (document.form1.CFid.value == ""){
				alert ("Debe digitar el Centro Funcional")            
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
						 										 
			document.form1.DDporcdesclin.value =  porcdesc																																	 
			document.form1.DDporcdesclin.value = qf(document.form1.DDporcdesclin.value)
			document.form1.DDcantidad.value =  qf(document.form1.DDcantidad.value)	
			document.form1.DDpreciou.value =  qf(document.form1.DDpreciou.value)	
 		 	document.form1.DDdesclinea.value =  qf(document.form1.DDdesclinea.value)	
			document.form1.DDtotallinea.value =  qf(document.form1.DDtotallinea.value)
			document.form1.DDtipo.disabled = false;
			document.form1.Icodigo.disabled = false;
		
		objForm.OC_SNid.required = false;
		objForm.OCid.required = false;
		objForm.OCTtransporte.required = false;
		objForm.OCTid.required = false;

		objForm.Aid.required = false;
		objForm.AidT.required = false;
		objForm.AidOD.required = false;
		
		if (document.form1.DDtipo.value=="T" || document.form1.DDtipo.value=="O"){
			objForm.CcuentaD.required = true;
			if (document.form1.DDtipo.value=="T"){
				objForm.OCTtransporte.required = true;
 				objForm.AidT.required = true; 
			}
			if (document.form1.DDtipo.value=="O"){
				objForm.OCid.required = true;
				objForm.OCTid.required = true;
				objForm.AidOD.required = true;
				objForm.OC_SNid.required = true;
				
				if (document.form1.OCCid.options[document.form1.OCCid.selectedIndex].text.substring(0,2) == "00" &&
					document.form1.OC_SNid.value != "<cfoutput>#LvarSNid#</cfoutput>")
				{
					alert("Cuando el Concepto de Compra es '00-PRODUCTO TRANSITO', la Orden Comercial debe pertenecer al Proveedor");
					return false;
				}
				else if (document.form1.OCCid.options[document.form1.OCCid.selectedIndex].text.substring(0,3) != "00-" && 
						 qf(document.form1.DDcantidad.value) != "0.00")
				{
					alert("No se puede indicar cantidad cuando el Concepto de Compra no es '00-PRODUCTO TRANSITO'");
					return false;
				}
			}
		}
		return true;	
	}

	function AsignarHiddensEncab() {
		document.form1._EDfecha.value = document.form1.EDfecha.value;		
		document.form1._EDfechaarribo.value = document.form1.EDfechaarribo.value;				
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
		document.form1._EDdocref.value = document.form1.EDdocref.value;
		document.form1._TESRPTCid.value = document.form1.TESRPTCid.value;
		document.form1._id_direccion.value = document.form1.id_direccion.value;				
	}

	function Postear(){
		if (confirm('¿Desea aplicar este documento?')) {
			document.form1.EDtipocambio.disabled = false;
			return true;
		} 
		else return false; 	
	}

//Formatea como float un valor de un campo
//Recibe como parametro el campo y la cantidad de decimales a mostrar
function fm(campo,ndec) {
   var s = "";
   if (campo.name)
     s=campo.value
   else
     s=campo

   if(s=='' && ndec>0) 
		s='0'

   var nc=""
   var s1=""
   var s2=""
   if (s != '') {
      str = new String("")
      str_temp = new String(s)
      t1 = str_temp.length
      cero_izq=true
      if (t1 > 0) {
         for(i=0;i<t1;i++) {
            c=str_temp.charAt(i)
            if ((c!="0") || (c=="0" && ((i<t1-1 && str_temp.charAt(i+1)==".")) || i==t1-1) || (c=="0" && cero_izq==false)) {
               cero_izq=false
               str+=c
            }
         }
      }
      t1 = str.length
      p1 = str.indexOf(".")
      p2 = str.lastIndexOf(".")
      if ((p1 == p2) && t1 > 0) {
         if (p1>0)
            str+="00000000"
         else
            str+=".0000000"
         p1 = str.indexOf(".")
         s1=str.substring(0,p1)
         s2=str.substring(p1+1,p1+1+ndec)
         t1 = s1.length
         n=0
         for(i=t1-1;i>=0;i--) {
             c=s1.charAt(i)
             if (c == ".") {flag=0;nc="."+nc;n=0}
             if (c>="0" && c<="9") {
                if (n < 2) {
                   nc=c+nc
                   n++
                }
                else {
                   n=0
                   nc=c+nc
                   if (i > 0)
                      nc=","+nc
                }
             }
         }
         if (nc != "" && ndec > 0)
            nc+="."+s2
      }
      else {ok=1}
   }
   
   if(campo.name) {
	   if(ndec>0) {
		 campo.value=nc
	   } else {
		 campo.value=qf(nc)
		}
   } else {
     return nc
   }
}	 
function funcRefrescar(){
		document.form1.action = 'RegistroNotasCreditoCP.cfm?modo=Cambio&tipo=' + document.form1.tipo.value;
		document.form1.submit();
	}

<cfif isdefined("form.tipo") and len(trim(form.tipo)) and form.tipo eq 'D'> <!--- Notas de Crédito --->
	function funcSNnumero(){ 
			document.form1.action = 'RegistroNotasCreditoCP.cfm?tipo=' + document.form1.tipo.value;
			document.form1.submit();
		}

<cfelseif isdefined("form.tipo") and len(trim(form.tipo)) and form.tipo eq 'C'> <!--- Facturas --->
	function funcSNnumero(){ 
			document.form1.action = 'RegistroFacturasCP.cfm?tipo=' + document.form1.tipo.value;
			document.form1.submit();
		}
</cfif>
</script>
<iframe id="frameExec" width="1" height="1" frameborder="0">&nbsp;</iframe>
<cfflush interval="128">
<form name="form1" action="SQLRegistroDocumentosCP.cfm" method="post">
	<input name="haydetalle" type="hidden" id="haydetalle" value="<cfif isdefined("rsLineas") and rsLineas.recordCount GT 0><cfoutput>SI</cfoutput><cfelse><cfoutput>NO</cfoutput></cfif>">
	<input name="LvarRecurrente" value="0"  type="hidden">
	<input name="LvarPlanDeCompras" value="<cfoutput>#LvarPlanDeCompras#</cfoutput>"  type="hidden">
	
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td colspan="5" class="tituloAlterno"><div align="center">Encabezado del Documento</div></td>
          </tr>
          <tr>
            <td width="13%"><div align="right">Documento:&nbsp;</div></td>
            <td width="39%"><cfoutput>
                <input name="EDdocumento" <cfif modo NEQ "ALTA"> class="cajasinborde" readonly tabindex="-1" <cfelse> 
				tabindex="1"</cfif> type="text" value="<cfif modo NEQ "ALTA">#rsDocumento.EDdocumento#<cfelseif isdefined('Form.EDDocumento')>#form.EDDocumento#</cfif>" 
				size="20" maxlength="20" />
            </cfoutput> </td>
            <td width="10%" nowrap="nowrap"><div align="right">Transacción&nbsp;(
                  <cfif form.tipo EQ "C">
                    CR
                      <cfelse>
                    DB
                  </cfif>
              ):&nbsp;</div></td>
            <td width="37%"><cfif modo NEQ "ALTA">
                <cfoutput>
                  <input type="hidden" name="CPTcodigo" tabindex="-1" value="#rsDocumento.CPTcodigo#" />
                  <input type="text"   name="CPTdescripcion"	
							value="#rsNombreTransac.CPTcodigo# - #rsNombreTransac.CPTdescripcion#"
							class="cajasinborde" readonly tabindex="-1" 
							size="35" maxlength="80" />
                </cfoutput>
                <cfelse>
                <select name="CPTcodigo" tabindex="1"  onchange="sbCPTcodigoOnChange(this.value);">
                  <cfoutput query="rsTransacciones">
                    <option value="#rsTransacciones.CPTcodigo#" 
								<cfif modo NEQ "ALTA" and rsTransacciones.CPTcodigo EQ rsDocumento.CPTcodigo>selected
								<cfelseif modo EQ 'ALTA' and isdefined('form.CPTcodigo') and rsTransacciones.CPTcodigo EQ form.CPTcodigo>
									selected
								</cfif>> #rsTransacciones.CPTcodigo# - #rsTransacciones.CPTdescripcion# </option>
                  </cfoutput>
                </select>
              </cfif>
            </td>
          </tr>
          <tr >
            <td><div align="right">&nbsp;Proveedor:&nbsp;</div></td>
            <td  align="left"  colspan="1">
                <cfif modo NEQ "ALTA">
                  <input name="SNnombre" type="text" readonly class="cajasinborde" tabindex="-1" 
						value="<cfoutput>#rsNombreSocio.SNnombre#</cfoutput>" size="40" maxlength="255" />
                  <input type="hidden" name="SNcodigo" value="<cfoutput>#rsDocumento.SNcodigo#</cfoutput>" />
                  <cfelse>
                  <cfif isdefined('form.SNnumero') and LEN(trim(form.SNnumero))>
                    <cf_sifsociosnegocios2 tabindex="1" SNtiposocio="P"  size="55" idquery="#rsSociosN.SNcodigo#">
                    <cfelse>
                    <cf_sifsociosnegocios2 tabindex="1" SNtiposocio="P" size="55" frame="frame1">
                  </cfif>
                </cfif>
            </td>
            <cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo)) and LvarRecurrente EQ 0 and form.tipo NEQ "D">
              <td align="left"  colspan="3"><input type="button" tabindex="1" name="FactRecurrente" value="Facturas Recurrentes" onclick="funcFactRecurrente(<cfoutput>#form.SNcodigo#</cfoutput>)" />
              </td>
              <cfelse>
              <td width="1%" colspan="2">&nbsp;</td>
            </cfif>
          </tr>
          <tr >
            <td><div align="right">&nbsp;Cuenta:&nbsp;</div></td>
            <td  colspan="2"><cfoutput>
                <cfif isdefined("rsParam") and rsParam.Pvalor EQ 'N'>
                  <input 	type="hidden" 	name="Ccuenta" 	id="Ccuenta"  	value="<cfif modo NEQ "ALTA">#rsCtaDocumento.Ccuenta#</cfif>" />
                  <input	type="text"		name="SNCta" 	id="SNCta" 		value="<cfif modo NEQ "ALTA">#TRIM(rsCtaDocumento.CFformato)#  -  #trim(rsCtaDocumento.CFdescripcion)#</cfif>" 
						size="70" style="border:none;" readonly="yes" tabindex="1" />
                  <cfelse>
                  <cfif modo NEQ "ALTA">
                    <cf_cuentas tabindex="1" Conexion="#Session.DSN#" Conlis="S" query="#rsDocumento#" auxiliares="N" movimiento="S" 
									ccuenta="Ccuenta" cdescripcion="Cfdescripcion" cformato="Cformato" igualTabFormato="S">
                    <cfelse>
                    <cf_cuentas tabindex="1" Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" 
									ccuenta="Ccuenta" cdescripcion="Cfdescripcion" cformato="Cformato" igualTabFormato="S">
                  </cfif>
                </cfif>
            </cfoutput>
			<td><cfif modo NEQ "ALTA"> <input type="button" tabindex="1" name="Garantias" value="Garantias" onclick="funcGarantias(<cfoutput>#IDdocumento#</cfoutput>)" /></cfif></td></td>
          </tr>
          <tr>
            <td><div align="right">Fecha&nbsp;Arribo:&nbsp;</div></td>
            <td><cfif modo NEQ 'ALTA'>
                <cf_sifcalendario name="EDfechaarribo" value="#LSDateFormat(rsDocumento.EDfechaarribo,'dd/mm/yyyy')#" tabindex="1">
                <cfelseif isdefined("form.EDfechaarribo")>
                <cf_sifcalendario name="EDfechaarribo" value="#LSDateFormat(form.EDfechaarribo,'dd/mm/yyyy')#" tabindex="1">
                <cfelse>
                <cf_sifcalendario name="EDfechaarribo" value="#LSDateFormat(rsFechaHoy.Fecha,'dd/mm/yyyy')#" tabindex="1">
              </cfif>
            </td>
            <td><div align="right">Fecha&nbsp;Factura:&nbsp;</div></td>
            <td><cfif modo NEQ 'ALTA'>
                <cf_sifcalendario name="EDfecha" value="#DateFormat(rsDocumento.EDfecha,'dd/mm/yyyy')#" tabindex="1" onBlur="obtenerTC(this.form);">
                <cfelseif isdefined("form.EDfecha") and len(trim(form.EDfecha))>
                <cf_sifcalendario name="EDfecha" value="#LSDateFormat(form.EDfecha,'dd/mm/yyyy')#" tabindex="1" onBlur="obtenerTC(this.form);">
                <cfelse>
                <cf_sifcalendario name="EDfecha" value="#LSDateFormat(rsFechaHoy.Fecha,'dd/mm/yyyy')#" tabindex="1" onBlur="obtenerTC(this.form);">
              </cfif>
            </td>
          </tr>
          <tr>
            <td><div align="right">Moneda:&nbsp;</div></td>
            <td><cfif modo NEQ "ALTA">
					<cfquery name="rsQuitar" datasource="#session.DSN#">
						select Mcodigo
						from Monedas
						where Ecodigo = #Session.Ecodigo#
						and Mcodigo <>  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDocumento.Mcodigo#">
					</cfquery>
					<cfset LvarQuitar = ValueList(rsQuitar.Mcodigo, ",")>
                <cf_sifmonedas query="#rsDocumento#" frame="frame2" valueTC="#rsDocumento.EDtipocambio#" quitar="#LvarQuitar#"
						onChange="obtenerTC(this.form);" tabindex="1">
                <cfelse>
                <cf_sifmonedas frame="frame2" onChange="obtenerTC(this.form);" tabindex="1">
              </cfif>
            </td>
            <td ><div align="right">Tipo Cambio:&nbsp;</div></td><!--- onchange="javascript: fm(this,4);"  --->
            <td><input name="EDtipocambio" type="text" tabindex="1" 
					
					onChange="javascript:validatcLOAD(this.form);"
					onkeyup="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}"
					onfocus="javascript:if(!document.form1.EDtipocambio.disabled) document.form1.EDtipocambio.select();" 
					style="text-align:right" 
					value="<cfif modo NEQ "ALTA"><cfoutput>#rsDocumento.EDtipocambio#</cfoutput>#LSCurrencyFormat('0','none')#<cfelse><cfoutput>0.00</cfoutput></cfif>" size="10" maxlength="10" />
            </td>
          </tr>
          <tr>
            <td><div align="right">Oficina:&nbsp;</div></td>
            <td><select name="Ocodigo" tabindex="1">
                <cfoutput query="rsOficinas">
                  <option value="#rsOficinas.Ocodigo#" 
							<cfif modo NEQ "ALTA" and rsOficinas.Ocodigo EQ rsDocumento.Ocodigo>selected
							<cfelseif modo EQ 'ALTA' and isdefined('form.Ocodigo') and rsOficinas.Ocodigo EQ form.Ocodigo>selected</cfif>> #rsOficinas.Odescripcion# </option>
                </cfoutput>
              </select>
            </td>
            <td  nowrap="nowrap"  align="right">Retenci&oacute;n al Pagar:&nbsp;</td>
            <td>
                <select name="Rcodigo" tabindex="1">
                  <option value="-1" >-- Sin Retención --</option>
                  <cfoutput query="rsRetenciones">
                    <option value="#rsRetenciones.Rcodigo#" 
							<cfif modo NEQ "ALTA" and rsRetenciones.Rcodigo EQ rsDocumento.Rcodigo>selected
							<cfelseif modo NEQ 'ALTA' and isdefined('form.Rcodigo') and rsRetenciones.Rcodigo EQ form.Rcodigo>selected</cfif>> #rsRetenciones.Rdescripcion# </option>
                  </cfoutput>
                </select>
            </td>
          </tr>
          <tr>
            <td  align="right"> Pagos a terceros:&nbsp; </td>
            <td  colspan="2">
                <cfif modo NEQ "ALTA">
                  <cf_cboTESRPTCid query="#rsDocumento#" tabindex="1" SNid="#rsNombreSocio.SNid#">
                  <cfelse>
                  <cfset form.TESRPTCid = "">
                  <cf_cboTESRPTCid tabindex="1" SNid="#LvarSNid#">
                </cfif>
            </td>
			
			<cfif modo NEQ "ALTA">
		  	<td align="left">
				<cfquery name="rsRetencion" datasource="#session.dsn#">
					select 	coalesce(r.Rporcentaje,0) / 100.0 *
							coalesce(
							(
								select sum(DDtotallinea)
								  from DDocumentosCxP d
								 inner join Impuestos i
									 on i.Ecodigo = d.Ecodigo
									and i.Icodigo = d.Icodigo
								 where d.IDdocumento = e.IDdocumento
								   and i.InoRetencion = 0
								 
							) 
						,0.00) as Monto
					from EDocumentosCxP e
						left join Retenciones r
						 on r.Ecodigo = e.Ecodigo
						and r.Rcodigo = e.Rcodigo
					where e.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">
				</cfquery>
				<cfoutput>
				#numberFormat(rsRetencion.Monto,",9.99")#
				</cfoutput>
			</td>
			</cfif>
          </tr>
          <tr>
            <td align="right"   nowrap="nowrap" valign="top">Direcci&oacute;n facturaci&oacute;n:&nbsp;
                <p>
                  <cfif form.tipo NEQ "C">
                    Referencia:&nbsp;
                  </cfif>
                </p></td>
            <td valign="top"><select style="width:470px" tabindex="1" name="id_direccion" id="id_direccion" <cfif modo EQ "ALTA"> 
				onchange="javascript: sbid_direccionOnChange(this.value);"</cfif>>
                <option value="">- Ninguna -</option>
                <cfoutput query="direcciones">
                  <option value="#id_direccion#" 
						<cfif modo NEQ "ALTA" AND id_direccion eq rsDocumento.id_direccion>selected</cfif>
						<cfif isdefined('form.id_direccion') AND id_direccion eq form.id_direccion>selected</cfif>>#HTMLEditFormat(texto_direccion)#</option>
                </cfoutput>
              </select>
                <input name="Referencia" tabindex="-1" readonly type="text" size="4" maxlength="4" 
					value="<cfif modo NEQ "ALTA" and isdefined("rsReferencia") and rsReferencia.recordcount EQ 1><cfoutput>#rsReferencia.CPTcodigo#</cfoutput></cfif>" />
                <input type="text" name="Referencia1" tabindex="-1" readonly size="20" maxlength="20" 
					value="<cfif modo NEQ "ALTA" and isdefined("rsReferencia") and rsReferencia.recordcount EQ 1><cfoutput>#trim(rsReferencia.Ddocumento)#</cfoutput></cfif>" />
                <script language="JavaScript1.2">
					if ("C" == "<cfoutput>#form.tipo#</cfoutput>")
					{
						document.form1.Referencia.style.visibility="hidden";
						document.form1.Referencia1.style.visibility="hidden";
					}
					else
					{
						document.form1.Referencia.style.visibility="visible";
						document.form1.Referencia1.style.visibility="visible";
					}
				</script>
                <cfif form.tipo NEQ "C">
                  <a href="#" tabindex="-1"> <img src="../../imagenes/Description.gif" alt="Lista de Documentos de Referencia" 
						name="refimagen" width="18" height="14" border="0" align="absmiddle" onclick="javascript:doConlisReferencias();" /> </a> <a href="#" tabindex="-1"> <img src="../../imagenes/delete.small.png" alt="Limpiar Referencia" name="imagenLimpiar" width="16" height="16" 
						border="0" align="absmiddle" onclick="javascript:limpiarRef();" /> </a>
                </cfif>
            </td>
            <td colspan="2" align="right"><table cellpadding="0" cellspacing="0" border="0" align="right">
                <tr>
                  <td width="127"><div align="right">Subtotal:&nbsp;</div></td>
                  <td align="right"><input name="subtotal" type="text" style="text-align:right" onchange="javascript: fm(this,2);" 
						class="cajasinborde" readonly tabindex="-1"  size="15" maxlength="15"
						value="<cfif modo NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsDocumento.subtotal,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>" />
                  </td>
                </tr>
                <tr>
                  <td width="127"><div align="right">Descuento:&nbsp;</div></td>
                  <td align="right"><input name="EDdescuento" tabindex="1" type="text" style="text-align:right" 
							onfocus="javascript:document.form1.EDdescuento.select();" onchange="javascript:fm(this,2);" 
							value="<cfif modo NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsDocumento.EDdescuento,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>" size="15" maxlength="12" />
                  </td>
                </tr>
                <tr>
                  <td><div align="right">Impuesto:&nbsp;</div></td>
                  <td align="right"><input name="EDimpuesto" type="text" onblur="javascript: fm(this,2);" tabindex="1" style="text-align:right" 
						onfocus="javascript:this.select();" onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
						value="<cfif modo NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsDocumento.EDimpuesto,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>" size="15" maxlength="12" />
                  </td>
                </tr>
                <tr>
                  <td><div align="right">Total:&nbsp;</div></td>
                  <td align="right"><input name="EDtotal" type="text" style="text-align:right" onchange="javascript: fm(this,2);" 
						class="cajasinborde" readonly tabindex="-1"  size="15" maxlength="15"
						value="<cfif modo NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsDocumento.EDtotal,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>" />
                  </td>
                </tr>
            </table></td>
          </tr>
          <tr>
            <td><input type="hidden" name="tipo" value="<cfoutput>#form.tipo#</cfoutput>" />
				<cfif modo NEQ "ALTA">
					<input type="hidden" name="SNid" value="<cfoutput>#rsNombreSocio.SNid#</cfoutput>" />
				</cfif>
                <input type="hidden" name="monedalocal" value="<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>" />
                <input type="hidden" name="EDporcdescuento" 
				value="<cfif modo NEQ "ALTA"><cfoutput>#rsDocumento.EDporcdescuento#</cfoutput></cfif>" />
                <input type="hidden" name="IDdocumento" 
				value="<cfif modo NEQ "ALTA"><cfoutput>#rsDocumento.IDdocumento#</cfoutput></cfif>" />
                <input type="hidden" name="EDdocref" 
				value="<cfif modo NEQ "ALTA"><cfoutput>#rsDocumento.EDdocref#</cfoutput></cfif>" />
                <cfset tsE = "">
                <cfif modo NEQ "ALTA">
                  <cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" 
					artimestamp="#rsDocumento.ts_rversion#" returnvariable="tsE"> </cfinvoke>
                </cfif>
                <input type="hidden" name="timestampE" value="<cfif modo NEQ "ALTA"><cfoutput>#tsE#</cfoutput></cfif>" />
                <input type="hidden" name="_EDfecha" value="" />
                <input type="hidden" name="_EDfechaarribo" value="" />
                <input type="hidden" name="_Mcodigo" value="" />
                <input type="hidden" name="_EDtipocambio" value="" />
                <input type="hidden" name="_Ocodigo" value="" />
                <input type="hidden" name="_Rcodigo" value="" />
                <input type="hidden" name="_EDdescuento" value="" />
                <input type="hidden" name="_Ccuenta" value="" />
                <input type="hidden" name="_EDimpuesto" value="" />
                <input type="hidden" name="_EDtotal" value="" />
                <input type="hidden" name="_EDdocref" value="" />
                <input type="hidden" name="_TESRPTCid" value="" />
                <input type="hidden" name="_id_direccion" value="" />
            </td>
          </tr>
          <tr>
            <td colspan="6"><div align="center"></div>
                <cfif modo EQ "ALTA">
                  <div align="center">
                    <input name="AgregarE" class="btnGuardar"  tabindex="1" type="submit" value="Agregar" 
						onclick="javascript: var estado = document.form1.EDtipocambio.disabled; document.form1.EDtipocambio.disabled = false; if (validaE()) return true; else {document.form1.EDtipocambio.disabled = estado; return false;}" />
                    <input type="button"   class="btnAnterior" tabindex="1" name="Regresar" value="Regresar" onclick="javascript:Lista();" />
                  </div>
                </cfif>
            </td>
          </tr>
        </table>
		<cfif modo NEQ "ALTA">
		<input name="SNnumero" type="hidden" value="<cfif isdefined("form.SNnumero") and len(trim(form.SNnumero))><cfoutput>#form.SNnumero#</cfoutput></cfif>">
		<table style="width:100%" border="0" cellpadding="1" cellspacing="0">
          <tr>
            <td style="width:100%" colspan="9" class="tituloAlterno"><div align="center">Detalle del Documento</div></td>
          </tr>
		  <tr>
            <td >Item:&nbsp;</td>
			<td style="width:100%" colspan="8" >
				<select id="DDtipo" name="DDtipo" <cfif LvarPlanDeCompras> disabled="disabled"</cfif> onChange="javascript:limpiarDetalle();cambiarDetalle();Verifica();" 
							<cfif modoDet neq 'ALTA'>disabled</cfif> tabindex="1">
					<cfif rscArticulos.cant GT 0>
					  <option value="A" <cfif modoDet NEQ "ALTA" and rsLinea.DDtipo EQ "A">selected</cfif>>A-Artículo de Inventario</option>
					</cfif>
					<cfif rscConceptos.cant GT 0>
					  <option value="S" <cfif modoDet NEQ "ALTA" and rsLinea.DDtipo EQ "S">selected</cfif>>S-Concepto Servicio o Gasto</option>
					</cfif>
					   <option value="P" <cfif modoDet NEQ "ALTA" and rsLinea.DDtipo EQ "P">selected</cfif>>P-Obras de Construccion</option>
					<cfif form.tipo NEQ "D">
					  <option value="F" <cfif modoDet NEQ "ALTA" and rsLinea.DDtipo EQ "F">selected</cfif>>F-Activo Fijo</option>
					</cfif>
					<option value="T" <cfif modoDet NEQ "ALTA" and rsLinea.DDtipo EQ "T">selected</cfif>>T-Producto en Tránsito</option>
					<option value="O" <cfif modoDet NEQ "ALTA" and rsLinea.DDtipo EQ "O">selected</cfif>>O-Orden Comercial en Tránsito</option>
			  </select>
			</td>
          </tr>
		  <tr id="trv">
			<td  align="left" colspan="9" >
				<fieldset>
				<table  align="left" border="0">
					<tr>

						<!--- ORDEN COMERCIAL --->
						<td align="right"  id="OrdenLabel"  >
							&Oacute;rden Comercial:						
						</td>
						<td id="OrdenImput">
							<cfset ArrayOC=ArrayNew(1)>
							<cfif modoDet neq 'ALTA' and rsLinea.DDtipo EQ "O">
								<cfquery name="rsORdenComercial" datasource="#session.DSN#">
									select OCid, SNid, OCcontrato
									from OCordenComercial where 
									Ecodigo =	#Session.Ecodigo#
									and OCid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLinea.OCid#">
								</cfquery>
								<cfset ArrayAppend(ArrayOC,rsORdenComercial.OCid)>
								<cfset ArrayAppend(ArrayOC,rsORdenComercial.OCcontrato)>
								<cfset ArrayAppend(ArrayOC,rsORdenComercial.SNid)>
							</cfif>
						
							<cf_conlis
							Campos="OCid,OCcontrato,OC_SNid"
							Desplegables="N,S,N"
							Modificables="N,S,N"
							Size="0,20"
							tabindex="1"
							ValuesArray="#ArrayOC#"
							Title="Órdenes Comerciales de Compra Abiertas"
							Tabla="OCordenComercial oc inner join SNegocios sn on sn.SNid = oc.SNid"
							Columnas="oc.OCid,oc.OCcontrato,oc.OCfecha, sn.SNnombre, sn.SNid as OC_SNid"
							Filtro=" oc.Ecodigo = #Session.Ecodigo# and oc.OCestado = 'A' and oc.OCtipoOD = 'O' and oc.OCtipoIC = 'C'  order by oc.OCfecha"
							Desplegar="OCcontrato,OCfecha,SNnombre"
							Etiquetas="Contrato,Fecha,Socio Comercial"
							filtrar_por="OCcontrato,Fecha,SNnombre"
							Formatos="S,D,S"
							Align="left,left,left"
							Asignar="OCid,OCcontrato,OC_SNid"
							Asignarformatos="S,S"/>

					  </td>
						<!--- TRANSPORTE --->
						<td align="right" id="TransporteLabel">
							Transporte:&nbsp;						
						</td>
						<td  nowrap="nowrap" id="TransporteImput">
							<select id="OCTtipo" name="OCTtipo" >
								<option value="">(Tipo Transporte)</option>
								<option value="B" <cfif modoDet NEQ "ALTA" and isdefined("rsLinea.OCTtipo") and rsLinea.OCTtipo EQ "B">selected</cfif>>Barco</option>
								<option value="A" <cfif modoDet NEQ "ALTA" and isdefined("rsLinea.OCTtipo") and rsLinea.OCTtipo EQ "A">selected</cfif>>Aéreo</option>
								<option value="T" <cfif modoDet NEQ "ALTA" and isdefined("rsLinea.OCTtipo") and rsLinea.OCTtipo EQ "T">selected</cfif>>Terrestre</option>
								<option value="F" <cfif modoDet NEQ "ALTA" and isdefined("rsLinea.OCTtipo") and rsLinea.OCTtipo EQ "F">selected</cfif>>Ferrocarril</option>
								<option value="O" <cfif modoDet NEQ "ALTA" and isdefined("rsLinea.OCTtipo") and rsLinea.OCTtipo EQ "O">selected</cfif>>Otro</option>
							</select>
							<cfif modoDet NEQ "ALTA" and isdefined("rsLinea.OCTtransporte") and len(trim(rsLinea.OCTtransporte))>
								<cfquery name="rsOCtransporte" datasource="#session.DSN#">
									select OCTid from OCtransporte           
									where  OCTtransporte  =  <cfqueryparam cfsqltype="cf_sql_char" value="#rsLinea.OCTtransporte#">
									and Ecodigo   =  #Session.Ecodigo# 
								</cfquery>
							</cfif>
							<cfoutput>
							<input 
								type="text" 
								name="OCTtransporte"
								value="<cfif modoDet NEQ "ALTA" and isdefined("rsLinea.OCTtransporte") and len(trim(rsLinea.OCTtransporte))>#rsLinea.OCTtransporte#</cfif>" 
								size="15" maxlength="20"
								autocomplete="off"
								alt="Transporte"
								tabindex="1"
								title="Transporte"
								onblur  = "javascript: validaTransporte();">
						  </cfoutput>
							<a href="javascript:doConlisTransporte();" id="imgCcuenta">
								<img src="/cfmx/sif/imagenes/Description.gif"
								alt="Lista de transportes"
								name="imagentransporte"
								width="18" height="14"
								border="0" align="absmiddle">
							</a>	
							<input type="hidden" name="OCTid" tabindex="-1" value="<cfif modoDet NEQ "ALTA" and isdefined("rsOCtransporte") ><cfoutput>#rsOCtransporte.OCTid#</cfoutput></cfif>" />
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
									where Ecodigo = #Session.Ecodigo#
									and Cid =
									<cfif rsLinea.DDtipo eq 'S'>
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLinea.Cid#">
									<cfelse>
										0
									</cfif>
									order by Ccodigo
								</cfquery>
								<cf_sifconceptos query=#rsConcepto# size="22" verclasificacion=#verClasCP# readonly="#LvarPlanDeCompras#">
							<cfelse>
								<cf_sifconceptos size="22" verclasificacion=#verClasCP# tabindex="1">
							</cfif>
					  </td>
						<!--- ALMACEN --->
						<td align="right"  id="AlmacenLabel">
							Almac&eacute;n:&nbsp;						
						</td>
						<td id="AlmacenImput">
							<cfif modoDet neq 'ALTA'>
								<cf_sifalmacen id="#rsLinea.Alm_Aid#"  size="14" aid="Almacen" tabindex="1" readOnly="#LvarPlanDeCompras2#" >
							<cfelse>
								<cf_sifalmacen size="15" aid="Almacen" tabindex="1" readOnly="#LvarPlanDeCompras2#">
					 	  </cfif>
					  </td>					  
						<!--- ARTICULO --->
						<td align="right"  id="labelarticulo">
							Art&iacute;culo:&nbsp;						
						</td>
						<td id="articulo">
							<cfif modoDet neq 'ALTA'>
								<cfquery name="rsArticulo" datasource="#session.DSN#">
									select Aid, Acodigo, Adescripcion 
									from Articulos where 
									Ecodigo =	#Session.Ecodigo#
									and Aid = 
										<cfif rsLinea.DDtipo eq 'A'>
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLinea.Aid#">
										<cfelse>
											0
										</cfif>
								</cfquery>
								<cf_sifarticulos query=#rsArticulo# almacen="Almacen" size="15" tabindex="1" readOnly="#LvarPlanDeCompras2#">
							<cfelse>
								<cf_sifarticulos almacen="Almacen" size="15" tabindex="1" readOnly="#LvarPlanDeCompras2#">
							</cfif>						
					    </td>
						<!--- ARTICULO T--->
						<td id="articuloT">
							<cfif modoDet neq 'ALTA' and rsLinea.DDtipo neq 'P'>
								<cfquery name="rsArticulo" datasource="#session.DSN#">
									select Aid as AidT, Acodigo as AcodigoT, Adescripcion as AdescripcionT
									from Articulos where 
									Ecodigo =	#Session.Ecodigo#
									and Aid = 
										<cfif rsLinea.DDtipo eq 'T'>
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLinea.Aid#">
										<cfelse>
											0
										</cfif>
								</cfquery>
								<cf_sifarticulos query=#rsArticulo# 
									id = "AidT" name ="AcodigoT" desc="AdescripcionT"
									almacen="Almacen" size="15" tabindex="1" IACcampo ="IACtransito" >
							<cfelse>
								<cf_sifarticulos 
								id = "AidT" name ="AcodigoT" desc="AdescripcionT"
								almacen="Almacen" size="15" tabindex="1" IACcampo ="IACtransito" >
							</cfif>						
					    </td>						
						
						
						<!--- ARTICULO --->
						<td id="articuloOD">
							<cfset ArrayAid=ArrayNew(1)>
							<cfif modoDet neq 'ALTA' and isdefined("rsLinea.Aid") and len(trim(rsLinea.Aid))>
								<cfquery name="rsArticuloOD" datasource="#session.DSN#">
									select Aid as AidOD, Acodigo as AcodigoOD, Adescripcion  as AdescripcionOD
									from Articulos where 
									Ecodigo =	#Session.Ecodigo#
									and Aid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLinea.Aid#">
								</cfquery>
								<cfset ArrayAppend(ArrayAid,rsArticuloOD.AidOD)>
								<cfset ArrayAppend(ArrayAid,rsArticuloOD.AcodigoOD)>
								<cfset ArrayAppend(ArrayAid,rsArticuloOD.AdescripcionOD)>
							</cfif>

							<cf_conlis
							Campos="AidOD,AcodigoOD,AdescripcionOD"
							Desplegables="N,S,S"
							ValuesArray="#ArrayAid#" 
							Modificables="N,S,N"
							Size="0,15,20"
							tabindex="1"
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
						
						<!--- Centro funcional --->
						<td  align="right" id="CFLabel">
							Centro Funcional:&nbsp;						
						</td>
						<td id="centrofuncional">
							<cfif modoDet neq 'ALTA'>
								<cfif len(trim(rsLinea.DOlinea))>
									<cfoutput>
									#trim(rsCF.CFcodigo)# - #trim(rsCF.CFdescripcion)#
									<input type="hidden" name="CFid" value="#rsCF.CFid#" tabindex="-1">
									<input type="hidden" name="CFcodigo" value="#rsCF.CFcodigo#" tabindex="-1">
									<input type="hidden" name="imagenCxP" id="imagenCxP" value="" tabindex="-1">
									</cfoutput>
								<cfelse>		
									<cf_rhcfuncionalCxP Ccuenta="CcuentaD" form="form1" size="23" id="CFid" name="CFcodigo" desc="CFdescripcion" query="#rsCF#" tabindex="1" readOnly="#LvarPlanDeCompras2#">
								</cfif>
							<cfelse>
								<cf_rhcfuncionalCxP Ccuenta="CcuentaD" form="form1" size="23" id="CFid" name="CFcodigo" desc="CFdescripcion" tabindex="1">
							</cfif>
					  </td>	
					</tr>
					<tr id="trv2">
						<td  nowrap="nowrap" align="right">Fecha Embarque:&nbsp;</td>
						<td>
							<cfif modoDet NEQ 'ALTA'>
								<cf_sifcalendario name="OCTfechaPartida" value="#LSDateFormat(rsLinea.OCTfechaPartida,'dd/mm/yyyy')#" tabindex="1">
							<cfelse>
								<cf_sifcalendario name="OCTfechaPartida" value="#LSDateFormat(rsFechaHoy.Fecha,'dd/mm/yyyy')#" tabindex="1">
							</cfif>
						</td>
						<td align="right">Obs.:&nbsp;</td>
						<td >
							<input type="text" tabindex="1" size="40" maxlength="255" name="OCTobservaciones" 
							value="<cfif modoDet neq 'ALTA'><cfoutput>#rsLinea.OCTobservaciones#</cfoutput></cfif>">
						</td>	
						
						<td align="right"  id="labelConceptoT">Conc.Compra:&nbsp;</td>
						<td id="ConceptoT">
							<cfquery name="rsOCconceptoCompra" datasource="#session.DSN#">
								select OCCid,OCCcodigo,OCCdescripcion 
								from OCconceptoCompra
								where Ecodigo = #Session.Ecodigo#
								order by OCCcodigo
							</cfquery>
							<cfoutput>
							<select id="OCCid" name="OCCid"
								tabindex="1"
								onchange="GvarOCobtieneCFcuenta=false;"
								onblur="if (! GvarOCobtieneCFcuenta) fnOCobtieneCFcuenta();"
							 >
								<cfloop query="rsOCconceptoCompra">
									<option value="#rsOCconceptoCompra.OCCid#" 
									<cfif modoDet NEQ "ALTA" and isdefined("rsLinea.OCCid") and rsLinea.OCCid EQ rsOCconceptoCompra.OCCid>selected</cfif>>#trim(rsOCconceptoCompra.OCCcodigo)#-#rsOCconceptoCompra.OCCdescripcion#</option>
								</cfloop>
							</select>
							</cfoutput>		
						</td>					
					</tr> 
				</table>
				</fieldset>
			</td>
		  </tr>
	  
          <tr>
            <td  align="right">Descripci&oacute;n:&nbsp;</td>
            <td colspan="3">
              <input name="DDdescripcion" tabindex="1" onFocus="javascript:this.select();" type="text" <cfif LvarPlanDeCompras> disabled="disabled"</cfif>
					value="<cfif modoDet NEQ "ALTA"><cfoutput>#HTMLeditFormat(rsLinea.DDdescripcion)#</cfoutput></cfif>" size="60" maxlength="255">
            </td>
            <td align="right" nowrap="nowrap">Desc. Alterna:&nbsp;</td>
            <td colspan="4">
              <input name="DDdescalterna" tabindex="1" onFocus="javascript:this.select();" type="text" <cfif LvarPlanDeCompras> disabled="disabled"</cfif>
					value="<cfif modoDet NEQ "ALTA"><cfoutput>#rsLinea.DDdescalterna#</cfoutput></cfif>" size="40" maxlength="255">
            </td>

		</tr>
		<tr id="TRCUENTADET">
			<cfif isdefined('rsParam') and rsParam.RecordCount GT 0 and rsParam.Pvalor EQ 'N'>
              <td>&nbsp;</td>
              <td id="hhref_CcuentaD" colspan="3">&nbsp;</td>
  			  <input name="CcuentaD" 			type="hidden" value="-1" />
			  <input name="Ecodigo_CcuentaD" 	type="hidden" value="-1" />
			  <input name="CdescripcionD" 		type="hidden" value="-1" />
            <cfelse>
				<td align="right">Cuenta:&nbsp;</td>
				<td colspan="8">
					<script language="javascript" type="text/javascript">
						function LimpiarCF(){
							document.form1.CFid.value   = "";
							document.form1.CFcodigo.value = "";
							document.form1.CFdescripcion.value = "";
						}
					</script>
					<cfif modoDet NEQ "ALTA">
						<cf_cuentas onchangeIntercompany="LimpiarCF()" Intercompany="yes" conexion="#Session.DSN#" conlis="S" query="#rsLinea#" auxiliares="N" movimiento="S" 
								ccuenta="CcuentaD" cfcuenta="CFcuentaD" cdescripcion="CdescripcionD"  cmayor="CmayorD"  cformato="CformatoD" 
                                readOnly="#LvarPlanDeCompras#"
								tabindex="1" igualTabFormato="S">
						<cfif len(trim(rsLinea.DOlinea))>do
							<script type="text/javascript" language="javascript1.2">				  						
								if(document.getElementById('hhref_CcuentaD'))
									document.getElementById('hhref_CcuentaD').style.display = 'none';
								document.form1.Ecodigo_CcuentaD.disabled = true;
							</script>
						</cfif>
					<cfelse>
						<cf_cuentas onchangeIntercompany="LimpiarCF()" Intercompany="yes" conexion="#Session.DSN#" conlis="S" auxiliares="N" movimiento="S" 
								ccuenta="CcuentaD" cfcuenta="CFcuentaD" cdescripcion="CdescripcionD"  cmayor="CmayorD" cformato="CformatoD" 
								tabindex="1" igualTabFormato="S">
					</cfif>
				</td>
				<!--- <td id="hhref_CcuentaD">&nbsp;</td> --->
			</cfif>
		</tr>
		  
		<tr>
			<td  align="right" valign="top">Impuesto:&nbsp;</td>
			<td colspan="4" valign="top">
				<select name="Icodigo" tabindex="1" <cfif LvarPlanDeCompras> disabled="disabled"</cfif>>
				<cfoutput query="rsImpuestos">
				<option value="#rsImpuestos.Icodigo#" 
					<cfif modoDet NEQ 'ALTA' and rsImpuestos.Icodigo EQ rsLinea.Icodigo>selected</cfif>> #rsImpuestos.Icodigo# - #rsImpuestos.Idescripcion# </option>
				</cfoutput>
				</select>
			</td>	
            <td colspan="4"  valign="top" align="right">
					<table border="0" align="right">
						<tr>
							<td><div align="right">Cantidad:&nbsp;</div></td>
							<td align="right">
							  <input name="DDcantidad" onFocus="javascript:this.value = qf(this.value); this.select();" type="text" tabindex="1" 
									style="text-align:right" onBlur="javascript:fm(this,2);suma();" size="12" maxlength="12"
									value="<cfif modoDet NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsLinea.DDcantidad,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>"
									<cfif modoDet NEQ "ALTA" and LvarXCantidad eq 0 > readonly="true"</cfif>
								>
							</td>
						</tr>
						<tr>
							<td >
							  <div align="right">Precio Unitario:&nbsp;</div></td>
							<td align="right">
								<cfoutput>
								<cfparam name="rsLinea.DDpreciou" default="0">
								<!---#LvarOBJ_PrecioU.inputNumber("CAMPO", VALOR, "tabIndex", readOnly, "class", "style", "onBlur();", "onChange();")#--->
								<cfif modoDet NEQ "ALTA" and LvarXCantidad eq 0 >
								   #LvarOBJ_PrecioU.inputNumber("DDpreciou", rsLinea.DDpreciou, "1", false, "", "", "suma();")# 
								<cfelseif modoDet neq 'ALTA' and  len(trim(rsLinea.PCGDid)) neq 0 and  len(trim(rsLinea.DOlinea)) eq 0 and rsLinea.DDtipo eq 'F'>
								   #LvarOBJ_PrecioU.inputNumber("DDpreciou", rsLinea.DDpreciou, "1", false, "", "", "suma();")# 
								<cfelseif modoDet EQ "ALTA" and LvarXCantidad eq 0 >
								  #LvarOBJ_PrecioU.inputNumber("DDpreciou", rsLinea.DDpreciou, "1", false, "", "", "suma();")#     
								<cfelse>
								   #LvarOBJ_PrecioU.inputNumber("DDpreciou", rsLinea.DDpreciou, "1", true, "", "", "suma();")#    
								</cfif>
								</cfoutput>
							</td>
						</tr>
						<tr>
							<td><div align="right">Descuento:&nbsp;</div></td>
							<td align="right"> <cfoutput>
								<input name="DDdesclinea" onFocus="javascript:this.value = qf(this.value); this.select();" 
									type="text" tabindex="1" size="12" maxlength="12"
									style="text-align:right" onBlur="javascript:fm(this,2);suma();" 
									value="<cfif modoDet NEQ "ALTA">#LSCurrencyFormat(rsLinea.DDdesclinea,'none')#<cfelse>0.00</cfif>">
							</cfoutput> </td>
						</tr>
						</tr>
							<td><div align="right">Subtotal:&nbsp;</div></td>
							<td align="right"> <cfoutput>
								<input name="DDtotallinea" type="text" class="cajasinborde" style="text-align:right" 
									onChange="javascript:fm(this,2);" tabindex="-1" size="15" readonly
									value="<cfif modoDet NEQ "ALTA">#LSCurrencyFormat(rsLinea.DDtotallinea,'none')#<cfelse>0.00</cfif>" >
								<input name="Linea" type="hidden" value="<cfif modoDet NEQ "ALTA">#rsLinea.Linea#</cfif>">
								<input name="DDporcdesclin" type="hidden" 
									value="<cfif modoDet NEQ "ALTA">#rsLinea.DDporcdesclin#<cfelse>0.00</cfif>">
								<cfset tsD = "">
								<cfif modoDet NEQ "ALTA">
								  <cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" 
										artimestamp="#rsLinea.ts_rversion#" returnvariable="tsD">
								  </cfinvoke>
								</cfif>
								<input name="timestampD" type="hidden" value="<cfif modoDet NEQ "ALTA">#tsD#</cfif>">
							</cfoutput> 
						</td>
					</tr>
				</table>
			</td>
			
          </tr>
		  <cfif isdefined("rsOrdenCompra")>
			<cfoutput>
			<tr>
				<td align="right">Orden:&nbsp;</td>
				<td align="left" colspan="8">#rsOrdenCompra.EOnumero#
					&nbsp; &nbsp; &nbsp;L&iacute;nea:&nbsp; #rsOrdenCompra.DOconsecutivo#</td>
				</td>
			</tr>
			</cfoutput>
		  </cfif>

		  
          <tr>
            <td colspan="11"><div align="center">
                <cfif modoDet EQ "ALTA">
					<input name="AgregarD" class="btnGuardar" tabindex="1" type="submit" value="Agregar" 
						onClick="javascript: var estado = document.form1.EDtipocambio.disabled; document.form1.EDtipocambio.disabled = false; if (valida()) return true; else {document.form1.EDtipocambio.disabled = estado; return false;}">
					<input name="Cambiar"  class="btnGuardar" tabindex="1" type="submit" value="Cambiar Documento" 
						onclick="javascript: var estado = document.form1.EDtipocambio.disabled; document.form1.EDtipocambio.disabled = false; fnNoValidar(); if (validaE()) return true; else {document.form1.EDtipocambio.disabled = estado; return false;}" />
                  <cfelse>
                  <input name="CambiarD" class="btnGuardar" tabindex="1" type="submit" value="Cambiar" 
						onClick="javascript: var estado = document.form1.EDtipocambio.disabled; document.form1.EDtipocambio.disabled = false; if (valida()) return true; else {document.form1.EDtipocambio.disabled = estado; return false;}">
                  <input name="NuevoD" 	 class="btnNuevo" tabindex="1" type="submit" value="Nueva Linea" onClick="javascript: fnNoValidar();">
                </cfif>
                <input name="BorrarE" class="btnEliminar" tabindex="1" type="submit" value="Borrar Documento" 
					onClick="javascript:  fnNoValidar(); if (confirm('¿Desea borrar este documento?')) return true; else return false;">
                <input type="submit" class="btnAplicar" tabindex="1" name="btnAplicar"  value="Aplicar" 	 onClick="javascript: fnNoValidar(); return Postear();">
                <input type="submit" class="btnNormal"  tabindex="1" name="Calcular"    value="Ver" 		 onClick="javascript: fnNoValidar();return true;">
                
				<cfif #form.tipo# eq 'D'>
				  <input type="button" class="btnNormal"  tabindex="1" name="Facturas" value="Lineas de Factura"  onClick="javascript:ShowFacturas();" >
				  
				<cfelse>  
				   <input type="button" class="btnNormal"  tabindex="1" name="OrdenCompra" value="Orden Compra" onClick="javascript:NuevaVentana(<cfoutput>#rsNombreSocio.SNcodigo#,#rsDocumento.IDdocumento#</cfoutput>);">		    
					<cfif rsUsaPlanCuentas.Pvalor eq LvarParametroPlanCom> 
					    <input type="button" class="btnNormal"  tabindex="1" name="PlanDeCompras" value="Plan de Compras"  onClick="javascript:PlanCompras();" >
					</cfif>
				</cfif>
			    <input  type="button" class="btnNormal" tabindex="1"  name="btnVerOC"  value="Ver Ordenes de Compra" onclick="javascript: fnVerOC()" />
				<input type="submit" class="btnNuevo"   tabindex="1" name="btnNuevo"    value="Nuevo" 		 onClick="javascript: fnNoValidar();">
                <input type="button" class="btnAnterior"tabindex="1" name="ListaE"      value="Regresar"      onClick="javascript:Lista();">
            </div></td>
          </tr>
        </table>
		<script language="JavaScript1.2">
		alert('2110 hidden');document.getElementById('hhref_CcuentaD').style.visibility = "hidden";
			function TraerCuentaConcepto(concepto,depto) {
			//alert("-"+concepto+"-"+depto+"-");			
				<cfloop query="rsCuentaConcepto">
					if (depto == "<cfoutput>#rsCuentaConcepto.Dcodigo#</cfoutput>" 
					&& concepto == "<cfoutput>#rsCuentaConcepto.Cid#</cfoutput>" ) {
						if (document.form1.CcuentaD){document.form1.CcuentaD.value="<cfoutput>#rsCuentaConcepto.Ccuenta#</cfoutput>"; 
						document.form1.CdescripcionD.disabled = false;
						document.form1.CdescripcionD.value="<cfoutput>#JSStringFormat(rsCuentaConcepto.Cdescripcion)#</cfoutput>";
						document.form1.CdescripcionD.disabled = true;}
						<cfif len(rsCuentaConcepto.Cformato) GTE 5>
							if (document.form1.CmayorD) {document.form1.CmayorD.value="<cfoutput>#Trim(JSStringFormat(mid(rsCuentaConcepto.Cformato,1,4)))#</cfoutput>";
							document.form1.CformatoD.value="<cfoutput>#Trim(JSStringFormat(mid(rsCuentaConcepto.Cformato,5,len(rsCuentaConcepto.Cformato))))#</cfoutput>";}
						<cfelse>
							if (document.form1.CmayorD) {document.form1.CmayorD.value="<cfoutput>#JSStringFormat(rsCuentaConcepto.Cformato)#</cfoutput>";
							document.form1.CformatoD.value="";}
						</cfif>
					}
				</cfloop>			
			}
		</script>
	
	</cfif>  

	<!--- ======================================================================= --->
	<!--- NAVEGACION --->
	<!--- ======================================================================= --->
	<cfoutput>
	<input type="hidden" name="fecha" value="<cfif isdefined('form.fecha') and len(trim(form.fecha)) >#form.fecha#</cfif>" />
	<input type="hidden" name="transaccion" value="<cfif isdefined('form.transaccion') and len(trim(form.transaccion))>#form.transaccion#</cfif>" />
	<input type="hidden" name="documento" value="<cfif isdefined('form.documento') and len(trim(form.documento))>#form.documento#</cfif>" />
	<input type="hidden" name="usuario" value="<cfif isdefined('form.usuario') and len(trim(form.usuario))>#form.usuario#</cfif>" />
	<input type="hidden" name="moneda" value="<cfif isdefined('form.moneda') and len(trim(form.moneda))>#form.moneda#</cfif>" />
	<input type="hidden" name="pageNum_lista" value="<cfif isdefined('form.pageNum_lista') >#form.pageNum_lista#</cfif>" />
	<input type="hidden" name="registros" value="<cfif isdefined('form.registros')>#form.registros#</cfif>" />
	</cfoutput>
	<!--- ======================================================================= --->
	<!--- ======================================================================= --->
	<iframe id="FRAMETRANSPORTE" name="FRAMETRANSPORTE" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" src="" style="visibility:hidden"></iframe>

</form>
<script language="JavaScript1.2" type="text/javascript">
// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	<cfif isdefined("Modo") and Modo eq 'CAMBIO'>
		if (document.form1.DDtipo.value == 'S'){
				document.form1.CFcodigo.disabled = false;
				document.form1.Ecodigo_CcuentaD.disabled = false;
				document.getElementById("imagenCxP").style.visibility = "visible";
			}
			else{
				document.form1.CFcodigo.disabled = true;
				document.form1.Ecodigo_CcuentaD.disabled = true;
				document.getElementById("imagenCxP").style.visibility = "hidden";
			}
	</cfif>
	
		
	function check(obj){
		
		document.getElementById("idCheck").style.visibility = (obj.checked && document.form1.DDtipo.value != 'F' ) ? "visible" : "hidden";
		document.getElementById("lidCheck").style.visibility = (obj.checked && document.form1.DDtipo.value != 'F' ) ? "visible" : "hidden";

		document.getElementById("idFecha").style.visibility = (obj.checked && document.form1.DDtipo.value != 'F' ) ? "visible" : "hidden";
		document.getElementById("lidFecha").style.visibility = (obj.checked && document.form1.DDtipo.value != 'F' ) ? "visible" : "hidden";

		document.getElementById("idObs").style.visibility = (obj.checked && document.form1.DDtipo.value != 'F' ) ? "visible" : "hidden";
		document.getElementById("lidObs").style.visibility = (obj.checked && document.form1.DDtipo.value != 'F' ) ? "visible" : "hidden";
	}
	
	
	var popUpWin=0;
	//Levanta el Conlis
	function popUpWindow(URLStr, left, top, width, height)
	{
		if(popUpWin)
		{
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
	//Llama el conlis
	function NuevaVentana(SNcodigo, IDdocumento) {
		var params ="";
		
		params = "&form=form"+
		
		popUpWindow("/cfmx/sif/cp/operacion/OrdenCompra.cfm?SNcodigo="+SNcodigo+"&IDdocumento="+IDdocumento+params,50,50,900,750);
	}
	function funcGarantias(IDdocumento) {
			popUpWindow("/cfmx/sif/cp/operacion/ReporteGarantias.cfm?Documento="+IDdocumento,50,50,900,750);
	}
	//llama el pop up y le pasa por url los parametros
	function ShowFacturas()
	{
	     var LvarReferencia = document.form1.Referencia.value;
		 var LvarReferencia1 = document.form1.Referencia1.value;
		 if(LvarReferencia =='' ||LvarReferencia1 =='')
		 {		  
		   alert("No se ha seleccionado ninguna factura de referencia"); 
		   return false;
		 }
		 else
		 {
		 var LvarIdDocumento = document.form1.IDdocumento.value;
		  window.open('NotasCreditoFacturas.cfm?tipo='+LvarReferencia+'&Ddocumento='+LvarReferencia1+'&IdDocumento='+LvarIdDocumento,'popup','width=1000,height=500,left=200,top=50,scrollbars=yes');
		 }
	}

	function funcFactRecurrente(SNcodigo){
		 
		var paramss ="";
		var LvarDdocumento = document.form1.EDdocumento.value;
		var LvarTESRPTCid1 = document.form1.TESRPTCid.value;
		if (LvarDdocumento == "" ){
			alert('El campo Documento es requerido.');
				return false;
		}
		if (LvarTESRPTCid1 == "" ){
			alert('El campo Pagos a terceros es requerido.');
				return false;
		}
		paramss = "&form=form"+
		popUpWindow("/cfmx/sif/cp/operacion/ListaDocumentosRecurrentesCP.cfm?SNcodigo="+SNcodigo+"&EDdocumento="+LvarDdocumento+"&TESRPTCid="+LvarTESRPTCid1+paramss,25,50,1024,750);
	
	}
	


	/* aquí asigna el hidden creado por el tag de monedas al objeto que realmente se va a usar como el tipo de cambio */
 	<cfif modo NEQ "ALTA">
		if (document.form1.Mcodigo.value == "<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>") {		
			//formatCurrency(document.form1.TC,2);
			document.form1.EDtipocambio.disabled = true;			
		}				
		var estado = document.form1.EDtipocambio.disabled;
		document.form1.EDtipocambio.disabled = false;
		document.form1.EDtipocambio.value = document.form1.TC.value;
		document.form1.EDtipocambio.disabled = estado;

		function obtener_formato(mayor, formato){
			
		}

		function funcAcodigoT(){
		    document.form1.DDdescripcion.value = document.form1.AdescripcionT.value;
 		    document.form1.DDdescalterna.value = document.form1.AdescripcionT.value;
			if (document.form1.CcuentaD)document.form1.CcuentaD.value = document.form1.cuenta_AcodigoT.value;
			if (document.form1.CmayorD) {document.form1.CmayorD.value = document.form1.cuentamayor_AcodigoT.value;
			document.form1.CformatoD.value =  document.form1.cuentaformato_AcodigoT.value;
			document.form1.CdescripcionD.value = document.form1.cuentadesc_AcodigoT.value;}
		}

		function funcAcodigo(){
		    document.form1.DDdescripcion.value = document.form1.Adescripcion.value;
 		    document.form1.DDdescalterna.value = document.form1.Adescripcion.value;
			if (document.form1.CcuentaD)document.form1.CcuentaD.value = document.form1.cuenta_Acodigo.value;
			if (document.form1.CmayorD) {document.form1.CmayorD.value = document.form1.cuentamayor_Acodigo.value;
			document.form1.CformatoD.value =  document.form1.cuentaformato_Acodigo.value;
			document.form1.CdescripcionD.value = document.form1.cuentadesc_Acodigo.value;}
		}

		function funcExtraAcodigo(){
			<cfif isdefined("rsParam") and rsParam.Pvalor EQ 'S'>
			document.form1.CcuentaD.value = document.form1.cuenta_Acodigo.value='';
			</cfif>
			if (document.form1.CmayorD) {document.form1.CmayorD.value = document.form1.cuentamayor_Acodigo.value = '';
			document.form1.CformatoD.value =  document.form1.cuentaformato_Acodigo.value='';
			document.form1.CdescripcionD.value =  document.form1.cuentadesc_Acodigo.value='';}
		}

 	</cfif>

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	validatcLOAD();	
	AsignarHiddensEncab();
	<cfif modo NEQ "ALTA">
		if (document.form1.DDtipo.value != "S")		
			//document.form1.imagen[1].style.visibility = "hidden";
		poneItem();
		cambiarDetalle();
		
	<cfelse>
		document.form1.EDdocumento.focus();
	</cfif>
	
	function funcAlmcodigoAntes(){
		limpiarAxCombo();
	}
	
		/*-------------------------*/
	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	_allowSubmitOnError = false;
	
	function _Field_isRango(low, high)
	{
		if (_allowSubmitOnError!=true)
		{
			var low=_param(arguments[0], 0.00, "number");
			var high=_param(arguments[1], 9999999.99, "number");
			var iValue=parseFloat(qf(this.value));
			if(isNaN(iValue))iValue=0;
			if((low>iValue)||(high<iValue))
			{
				this.error="El campo "+this.description+" debe contener un valor entre "+low+" y "+high+".";
			}
		}
	}
	_addValidator("isRango", _Field_isRango);
	
	function _ValidarSNid_CCO_00(low, high)
	{
		if (_allowSubmitOnError!=true)
		{
			var low=_param(arguments[0], 0.00, "number");
			var high=_param(arguments[1], 9999999.99, "number");
			var iValue=parseFloat(qf(this.value));
			if(isNaN(iValue))iValue=0;
			if((low>iValue)||(high<iValue))
			{
				this.error="El campo "+this.description+" debe contener un valor entre "+low+" y "+high+".";
			}
		}
	}
	_addValidator("isValidaSNid", _ValidarSNid_CCO_00);

	<cfif modo NEQ "ALTA">
		objForm.OCid.description = "Órden Comercial";
		objForm.OC_SNid.description = "Socio Nocio de la Orden Comercial";

		objForm.OCTtransporte.description 	= "Transporte Transito";
		objForm.OCTid.description 			= "Transporte Orden Comercial";

		objForm.Aid.description		= "Artículo";
		objForm.AidT.description	= "Artículo Tránsito";
		objForm.AidOD.description	= "Artículo Órden Comercial";
	</cfif>

	objForm.EDdocumento.required = true;
	objForm.EDdocumento.description = "Código de Documento";
	objForm.CPTcodigo.required = true;
	objForm.CPTcodigo.description = "Tipo de Transaccion";
	objForm.SNcodigo.required = true;
	objForm.SNcodigo.description = "Cliente";

	objForm.EDfechaarribo.required = true;
	objForm.EDfechaarribo.description = "Fecha de arribo";
	
	objForm.EDfecha.required = true;
	objForm.EDfecha.description = "Fecha";
	objForm.Mcodigo.required = true;
	objForm.Mcodigo.description = "Moneda";
	objForm.Ocodigo.required = true;
	objForm.Ocodigo.description = "Oficina";
	objForm.Rcodigo.required = true;
	objForm.Rcodigo.description = "Retención";
	objForm.Ccuenta.required = true;
	objForm.Ccuenta.description = "Cuenta de Proveedor";
	objForm.TESRPTCid.required = true;
	objForm.TESRPTCid.description = "Pagos a terceros";

	
	objForm.EDtipocambio.required = true;
	objForm.EDtipocambio.description = "Tipo de Cambio";
	objForm.EDtipocambio.validateRango('0.0001','999999999999.9999');
	
	objForm.EDdescuento.description = "Descuento";
	objForm.EDdescuento.validateRango('0.00','999999999999.99');

	<cfif modo NEQ "ALTA">

	if(document.form1.Almacen.style.visibility == "visible"){
		objForm.Almacen.required = true;
		objForm.Almacen.description = "Almacén";
	}

	if(document.form1.LvarPlanDeCompras == false){
	
	objForm.DDdescripcion.required = true;
	objForm.DDdescripcion.description = "Descripción del Detalle";
	if (document.form1.CcuentaD){
	objForm.CcuentaD.required = true;
	objForm.CcuentaD.description = "Cuenta del Detalle";}
	}


	objForm.DDpreciou.required = true;
	objForm.DDpreciou.description = "Precio Unitario";	
	objForm.DDpreciou.validateRango('0.01','999999999999.99');
	
	objForm.DDcantidad.required = true;
	objForm.DDcantidad.description = "Cantidad";	
	objForm.DDcantidad.validateRango('0.00','999999999999.99');
	
	objForm.DDdesclinea.required = true;
	objForm.DDdesclinea.description = "Descuento de Línea";
	objForm.DDdesclinea.validateRango('0.00','999999999999.99');
	
	objForm.DDtotallinea.required = true;
	objForm.DDtotallinea.description = "Total de Línea";
	objForm.DDtotallinea.validateRango('0.01','999999999999.99');
	</cfif>
	

	

	function fnNoValidar() {

		objForm.Aid.required = false;
		objForm.AidT.required = false;
		objForm.AidOD.required = false;
		objForm.Cid.required = false;

		objForm.DDdescripcion.required = false;
		if(document.form1.Almacen.style.visibility == "visible"){
			objForm.Almacen.required = false;
			}
		objForm.Ccuenta.required = false;
		if (document.form1.CcuentaD) objForm.CcuentaD.required = false;
		objForm.DDpreciou.validate = false;
		objForm.DDpreciou.required = false;
		objForm.DDcantidad.required = false;
		objForm.DDdesclinea.required = false;
		objForm.DDtotallinea.required = false;
		objForm.CFdescripcion.required = false;
		objForm.TESRPTCid.required = false;

		_allowSubmitOnError = true;
	}
// PROCEDIMIENTO PARA CAMBIAR LA CUENTA SEGUN LA TRANSACCION
	var LvarArrCcuenta   = new Array();
	var LvarArrCFformato = new Array();
	var LvarArrCFdescripcion = new Array();

<cfoutput query="rsTransacciones"> 
	<cfif isdefined("rsTransacciones.CFformato")>
		/* def*/
		LvarArrCcuenta  ["#CPTcodigo#"] = "#rsTransacciones.Ccuenta#";
		LvarArrCFformato["#CPTcodigo#"] = "#rsTransacciones.CFformato#";
		LvarArrCFdescripcion["#CPTcodigo#"] = "#rsTransacciones.CFdescripcion#";
	<cfelse>
		/* no  def*/
		LvarArrCcuenta  ["#CPTcodigo#"] = "";
		LvarArrCFformato["#CPTcodigo#"] = "";
		LvarArrCFdescripcion["#CPTcodigo#"] = "";
	</cfif>
	
</cfoutput>
	function sbCPTcodigoOnChange (CPTcodigo)
	{
		document.getElementById("Ccuenta").value 	= LvarArrCcuenta  [CPTcodigo];
	<cfif isdefined("rsParam") and rsParam.Pvalor EQ 'N'>
		document.getElementById("SNCta").value 		= LvarArrCFformato[CPTcodigo] + ': ' + LvarArrCFdescripcion[CPTcodigo];
	<cfelse>
		var LvarCFformato = LvarArrCFformato[CPTcodigo];
		document.getElementById("Cmayor").value 		= LvarCFformato.substring(0,4);
		document.getElementById("Cformato").value 		= LvarCFformato.substring(5,100);
		document.getElementById("Cfdescripcion").value 	= LvarArrCFdescripcion[CPTcodigo];
	</cfif>
	}
// PROCEDIMIENTO PARA CAMBIAR LA CUENTA SEGUN LA TRANSACCION
	var LvarArrCcuentaD   = new Array();
	var LvarArrCFformatoD = new Array();
	var LvarArrCFdescripcionD = new Array();

<cfoutput query="direcciones"> 
	<cfif isdefined("direcciones.CFformato")>
		/* def*/
		LvarArrCcuentaD  ["#id_direccion#"] = "#direcciones.Ccuenta#";
		LvarArrCFformatoD["#id_direccion#"] = "#direcciones.CFformato#";
		LvarArrCFdescripcionD["#id_direccion#"] = "#direcciones.CFdescripcion#";
	<cfelse>
		/* no def*/
		LvarArrCcuentaD  ["#id_direccion#"] = "";
		LvarArrCFformatoD["#id_direccion#"] = "";
		LvarArrCFdescripcionD["#id_direccion#"] = "";
	</cfif>
</cfoutput>
	function sbid_direccionOnChange (id_direccion)
	{
		document.getElementById("Ccuenta").value 	= LvarArrCcuentaD  [id_direccion];
	<cfif isdefined("rsParam") and rsParam.Pvalor EQ 'N'>
		document.getElementById("SNCta").value 		= LvarArrCFformatoD[id_direccion] + ': ' + LvarArrCFdescripcionD[id_direccion];
	<cfelse>
		var LvarCFformatoD = LvarArrCFformatoD[id_direccion];
		document.getElementById("Cmayor").value 		= LvarCFformatoD.substring(0,4);
		document.getElementById("Cformato").value 		= LvarCFformatoD.substring(5,100);
		document.getElementById("Cfdescripcion").value 	= LvarArrCFdescripcionD[id_direccion];
	</cfif>
	}

	<cfoutput>
		<cfif isdefined("rsTransacciones.CFformato")>
		sbCPTcodigoOnChange ("#form.CPTcodigo#");	
		</cfif>
		<cfif not isdefined("form.modo") and modo eq 'ALTA'>
			if (document.form1.EDdocumento.value.length > 0){
				document.form1.EDfechaarribo.focus();
			}
		</cfif>
		 <cfif isdefined("modo") and modo neq 'ALTA'and  modoDet EQ "ALTA">
			document.form1.DDtipo.focus();
		</cfif>
	</cfoutput>
	if(document.getElementById('hhref_CcuentaD'))
	{alert('2520 hidden');
		if(document.form1.DDtipo.value != "S"){document.getElementById('hhref_CcuentaD').style.visibility = "hidden";}
	}	
	function doConlisTransporte() {
		var DDtipo = document.form1.DDtipo.value;
		var OCid = document.form1.OCid.value;
		var OCTtipo = document.form1.OCTtipo.value;
		var PARAM  = "ConlisTransporte.cfm?OCTtipo="+ OCTtipo + "&DDtipo="+DDtipo ;
		if (DDtipo == 'O'){
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
	function fnOCobtieneCFcuenta() {
		var PARAM = "?tipo=TR";
		PARAM = PARAM + "&OCid=" + document.form1.OCid.value;
		PARAM = PARAM + "&Aid="  + document.form1.AidOD.value;
		PARAM = PARAM + "&SNid=" + document.form1.SNid.value;
		PARAM = PARAM + "&OCCid=" + document.form1.OCCid.value;
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
	function PlanCompras()
	{
     IDdocumento = document.form1.IDdocumento.value;			
     window.open('planComprasFactura.cfm?documento='+IDdocumento,'popup','width=1200,height=700,left=100,top=50,scrollbars=yes');
		
	}
	function  fnVerOC()
	{  
	   IDdocumento = document.form1.IDdocumento.value;			
       window.open('OrdenesFacturadas.cfm?documento='+IDdocumento,'popup','width=1100,height=350,left=200,top=150,scrollbars=yes');
	}
</script>
<script language="javascript" type="text/javascript">
	initPage(document.form1);
</script>


