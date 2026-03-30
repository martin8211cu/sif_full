<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset MSG_MontoNum = t.Translate('MSG_MontoNum','El monto digitado debe ser numérico.')>
<cfset MSG_SelProv = t.Translate('MSG_SelProv','Debe seleccionar un Proveedor')>
<cfset MSG_FecArr = t.Translate('MSG_FecArr','La fecha de arribo debe ser mayor a la fecha del documento')>
<cfset MSG_DigAlm = t.Translate('MSG_DigAlm','Debe digitar el Almacen')>
<cfset MSG_DigArt = t.Translate('MSG_DigArt','Debe digitar el artículo')>
<cfset MSG_DigConc = t.Translate('MSG_DigConc','Debe digitar el concepto')>
<cfset MSG_DigCC = t.Translate('MSG_DigCC','Debe digitar el Centro Funcional')>
<cfset MSG_DigTT = t.Translate('MSG_DigTT','Debe seleccionar un tipo de Transacción')>
<cfset MSG_ConcComp = t.Translate('MSG_DigTT','Cuando el Concepto de Compra es 00-PRODUCTO TRANSITO, la Orden Comercial debe pertenecer al Proveedor')>
<cfset MSG_AplDoc = t.Translate('MSG_AplDoc','¿Desea aplicar este documento?')>
<cfset Lbl_ArtInv	= t.Translate('Lbl_ArtInv','A-Artículo de Inventario')>
<cfset Lbl_ConSer	= t.Translate('Lbl_ConSer','S-Concepto Servicio o Gasto')>
<cfset Lbl_ProdTr	= t.Translate('Lbl_ProdTr','T-Producto en Tránsito')>
<cfset Lbl_ActFjo	= t.Translate('Lbl_ActFjo','F-Activo Fijo')>
<cfset Lbl_OrdCm	= t.Translate('Lbl_OrdCm','O-Orden Comercial en Tránsito')>
<cfset Lbl_ImpVar	= t.Translate('Lbl_ImpVar','I-Impuesto Variable')>
<cfset Lbl_OrdCom	= t.Translate('Lbl_OrdCom','Órden Comercial')>
<cfset Lbl_OrdCmCmpr	= t.Translate('Lbl_OrdCmCmpr','Órdenes Comerciales de Compra Abiertas')>
<cfset LB_Fecha 	= t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset Lbl_Contr	= t.Translate('Lbl_Contr','Contrato')>
<cfset Lbl_SocCom	= t.Translate('Lbl_SocCom','Socio Comercial')>
<cfset Lbl_Trans	= t.Translate('Lbl_Trans','Transporte')>
<cfset Lbl_TpoTrsp	= t.Translate('Lbl_TpoTrsp','(Tipo Transporte)')>
<cfset Lbl_Barco	= t.Translate('Lbl_Barco','Barco')>
<cfset Lbl_Aereo	= t.Translate('Lbl_Aereo','Aéreo')>
<cfset Lbl_Terrest	= t.Translate('Lbl_Terrest','Terrestre')>
<cfset Lbl_Ferro	= t.Translate('Lbl_Ferro','Ferrocarril')>
<cfset Lbl_Otro		= t.Translate('Lbl_Otro','Otro')>
<cfset Lbl_LstTrans	= t.Translate('Lbl_LstTrans','Lista de transportes')>
<cfset LB_Concepto 	= t.Translate('LB_Concepto','Concepto','/sif/generales.xml')>
<cfset Lbl_Almac	= t.Translate('Lbl_Almac','Almacén')>
<cfset Lbl_Art		= t.Translate('Lbl_Art','Artículo')>
<cfset Lbl_ArtOrdC	= t.Translate('Lbl_ArtOrdC','Artículos de la orden comercial')>
<cfset LBR_CODIGO 	= t.Translate('LBR_CODIGO','Código','/sif/generales.xml')>
<cfset Lbl_CodAlt 	= t.Translate('Lbl_CodAlt','Cód. Alterno')>
<cfset MSG_Descripcion 	= t.Translate('MSG_Descripcion','Descripción','/sif/generales.xml')>
<cfset LB_CentroFuncional 	= t.Translate('LB_CentroFuncional','Centro Funcional','/sif/generales.xml')>
<cfset Lbl_EspCta	= t.Translate('Lbl_EspCta','Especifica Cuenta')>
<cfset Lbl_FecEmb	= t.Translate('Lbl_FecEmb','Fecha Embarque')>
<cfset Lbl_Obs	= t.Translate('Lbl_Obs','Obs')>
<cfset Lbl_DescImpVar	= t.Translate('Lbl_DescImpVar','Descripción')>
<cfset Lbl_DescImpVarAlt	= t.Translate('Lbl_DescImpVarAlt','Descripción Alterna')>
<cfset Lbl_ConsCpr	= t.Translate('Lbl_ConsCpr','Conc.Compra')>
<cfset Lbl_DescAlt 	= t.Translate('Lbl_DescAlt','Desc. Alterna')>
<cfset Lbl_cantidad	= t.Translate('Lbl_Cantidad','Cantidad','RegistroNotasCreditoCP.xml')>
<cfset Lbl_PrecioU	= t.Translate('Lbl_PrecioU','Precio Unitario')>
<cfset Lbl_ActEmpr	= t.Translate('Lbl_ActEmpr','Actividad Empresarial')>
<cfset LB_Orden 	= t.Translate('LB_Orden','Orden','/sif/generales.xml')>
<cfset LB_SNOrdenC 	= t.Translate('LB_SNOrdenC','Socio de la Orden Comercial')>
<cfset LB_TranTr 	= t.Translate('LB_TranTr','Transporte Transito')>
<cfset LB_TranOC 	= t.Translate('LB_TranOC','Transporte Orden Comercial')>
<cfset Lbl_ArtOrdenC	= t.Translate('Lbl_ArtOrdenC','Artículo Órden Comercial')>
<cfset Lbl_CodDocto 	= t.Translate('Lbl_CodDocto','Código de Documento')>
<cfset Lbl_TpoTrans 	= t.Translate('Lbl_TpoTrans','Tipo de Transaccion')>
<cfset LB_CLIENTE 	= t.Translate('LB_CLIENTE','Cliente','/sif/generales.xml')>
<cfset Lbl_CtaProv 	= t.Translate('Lbl_CtaProv','Cuenta de Proveedor')>
<cfset Lbl_DescDet 	= t.Translate('Lbl_CtaProv','Descripción del Detalle')>
<cfset Lbl_CtaDet 	= t.Translate('Lbl_CtaDet','Cuenta del Detalle')>
<cfset Lbl_DescLin 	= t.Translate('Lbl_DescLin','Descuento de Línea')>
<cfset Lbl_TotLin 	= t.Translate('Lbl_TotLin','Total de Línea')>
<cfset MSG_DocInclu = t.Translate('MSG_DocInclu','El documento tiene Documentos de Inclusion Relacionados no se puede Borrar')>


<cfparam name="LVarRemision" default="0">
<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init(false,2)>
<cfif isdefined('url.IDdocumento') and LEN(TRIM(url.IDdocumento))>
	<cfset Form.IDdocumento = url.IDdocumento>
</cfif>

<cfif isdefined("url.Ecodigo_f")><cfset lvarFiltroEcodigo = trim(#url.Ecodigo_f#)></cfif>

<cfif not isdefined('lvarFiltroEcodigo') or len(trim(#lvarFiltroEcodigo#)) eq 0 >
  <cfset lvarFiltroEcodigo = #session.Ecodigo#>
</cfif>

<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<!--- Limpia los valores para cuando el registro es nuevo. --->
<cfif isDefined("form.btnNuevo")>
	<cfif form.btnNuevo EQ "Nuevo">
 		<cfset form.CPTDescripcion   = "">
		<cfset form.EDdocumento	     = "">
		<cfset form.EDfecha 	     = "">
		<cfset form.EDtotal 		 = "">
		<cfset form.EDusuario 		 = "">
		<cfset form.IDdocumento 	 = "">
		<cfset form.Mnombre 		 = "">
		<cfset form.SNidentificacion = "">
		<cfset form.SNnombre 		 = "">
	</cfif>
</cfif>

<cfset LvarXCantidad = 0> <!--- No maneja cantidad ---->

<!---►►Forma de Construcción de Cuentas S=Normal, N=Por Origen Contable◄◄--->
<cfquery name="rsParam" datasource="#session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo = #Session.Ecodigo#
	  and Pcodigo = 2
</cfquery>
<cfset LvarComplementoXorigen = rsParam.Pvalor EQ "N">

<cfquery name="rsParam50" datasource="#session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo = #Session.Ecodigo#
	  and Pcodigo = 50
</cfquery>
<cfquery name="rsParam60" datasource="#session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo = #Session.Ecodigo#
	  and Pcodigo = 60
</cfquery>
<cfset LvarAnoAux = rsParam50.Pvalor>
<cfset LvarMesAux = rsParam60.Pvalor>
 <!---►►Parametro 5200: Indicar Cuentas Contables Manualmente◄◄--->
<cfquery name="rsParam" datasource="#session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo = #Session.Ecodigo#
	  and Pcodigo = 5200
</cfquery>
<cfset LvarIndicarCuentaManual = rsParam.Pvalor EQ "S">
<cfif isdefined("url.tipo") and not isdefined("form.tipo")>
	<cfset form.tipo = url.tipo>
</cfif>


<cfif isdefined("form.tipo") and len(trim(form.tipo)) and not isdefined("form.DDtipo")>
	<cfset form.DDtipo = form.tipo>
</cfif>

<cfset datosIDdocumento = #IDdocumento#>
<cfif not isDefined("Form.NuevoE") and NOT isdefined("Form.Nuevo")>
	<cfif isDefined("Form.datos") and Len(Trim(Form.datos)) NEQ 0 >
		<cfset arreglo = ListToArray(Form.datos,"|")>
		<cfset sizeArreglo = ArrayLen(arreglo)>
		<cfset IDdocumento = Trim(arreglo[1])>
 		<cfif sizeArreglo EQ 2>
			<cfset Linea = Trim(arreglo[2])>
		</cfif>
	<cfelse>
		<cfset IDdocumento = Trim(Form.IDdocumento)>
		<cfif isDefined("Form.Linea") and Len(Trim(Form.Linea)) NEQ 0>
			<cfset Linea = Trim(Form.Linea)>
		</cfif>
	</cfif>
</cfif>
<cfif isdefined('linea') and LEN(TRIM(Linea))>
	<cfset modoDet = "CAMBIO">
<cfelse>
	<cfset modoDet = "ALTA">
</cfif>

<cfif isdefined('datosIDdocumento') and LEN(TRIM(datosIDdocumento)) and IDdocumento eq "">
	<cfset IDdocumento = datosIDdocumento>
</cfif>

<!--- Se obtiene valor de parámetro, para determinar si se omite la validación (Eduardo González 27.02.2018) --->
<cfset lVarValidaFechaArribo = true>
<cfquery name="rsGetParamValue" datasource="#Session.DSN#">
	SELECT Pvalor
	FROM Parametros
	WHERE Ecodigo = #Session.Ecodigo#
	AND Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="00190401">
</cfquery>

<cfif isdefined("rsGetParamValue") AND #rsGetParamValue.recordcount# GT 0 AND #rsGetParamValue.Pvalor# EQ 1>
	<cfset lVarValidaFechaArribo = false>
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
			,case when ctas.CFcuenta is null
				then
					(
						select min(rtrim(CFformato))
						from CFinanciera
                        where CFcuenta =
                            case when n.CFcuentaCxP is null
                                then (select min(CFcuenta) from CFinanciera where Ccuenta = n.SNcuentacxp)
                            else n.CFcuentaCxP
                            end
					)
				else
					(
						select rtrim(CFformato)
						  from CFinanciera
						 where CFcuenta = ctas.CFcuenta
					)
				end
			as CFformato
            ,(select v.CPVformatoF
	  		  from CtasMayor m
		  	  inner join CPVigencia v
		  	    on v.Ecodigo = m.Ecodigo
				and v.Cmayor  = m.Cmayor
				and <cfqueryparam cfsqltype="cf_sql_numeric" value="#dateformat(Now(),'YYYYMM')#">
				between CPVdesdeAnoMes and coalesce(CPVhastaAnoMes,600000)
	          where m.Ecodigo=#session.Ecodigo#
	   		  and m.Cmayor = (select case when ctas.CFcuenta is null
							  then
							  (
                              	select min(rtrim(Cmayor))
						  		from CFinanciera
						 		where CFcuenta =
                                	case when n.CFcuentaCxP is null
										then (select min(CFcuenta) from CFinanciera where Ccuenta = n.SNcuentacxp)
									else n.CFcuentaCxP
									end
							  )
							  else
							  (
								select rtrim(Cmayor)
						  		from CFinanciera
								where CFcuenta = ctas.CFcuenta
							  )
						      end))
			as Cmascara
			, case when ctas.CFcuenta is null
				then
					(
						select min(CFdescripcion)
						from CFinanciera
                        where CFcuenta =
                            case when n.CFcuentaCxP is null
                                then (select min(CFcuenta) from CFinanciera where Ccuenta = n.SNcuentacxp)
                            else n.CFcuentaCxP
                            end
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
	   and a.CPTtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#LvarTipoMov#">
	   and coalesce(a.CPTpago,0) != 1 and coalesce(a.CPTanticipo,0) != 1
	   and NOT a.CPTdescripcion like '%Tesorer_a%'
		 and NOT a.CPTcodigo = 'RM' and NOT a.CPTcodigo = 'DR'
		order by  3,1
</cfquery>

<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select Mcodigo
	from Empresas
	where Ecodigo = #Session.Ecodigo#
</cfquery>

<cfquery name="rsOficinas" datasource="#Session.DSN#">
	select Ocodigo, Odescripcion from Oficinas
	where Ecodigo = #Session.Ecodigo#
	order by Odescripcion
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
	where  ieps <>1
	or ieps is null
	and Ecodigo = #Session.Ecodigo#
	GROUP BY Icodigo,Idescripcion
	order by Idescripcion
</cfquery>

<!--- consulta de impuesto ieps con los conceptos de servicio --->
<cfquery name="rsCieps" datasource="#session.dsn#">
   select Icodigo,Ccodigo,Idescripcion,a.ValorCalculo
	from Impuestos a
	inner join Conceptos b
	on b.codIEPS = a.Icodigo
	where a.Ecodigo = #session.Ecodigo#
</cfquery>

<!--- consulta de impuesto ieps con los conceptos de Articulos --->
<cfquery name="rsCieps2" datasource ="#session.dsn#">
	select a.Icodigo,b.Acodigo,Idescripcion,a.ValorCalculo
	FROM Impuestos a
	inner join Articulos b
	on b.codIEPS = a.Icodigo
	where a.Ecodigo =#session.Ecodigo#
</cfquery>


<cfquery name="rsImpuestosIeps" datasource="#Session.DSN#">
	select ltrim(rtrim(Icodigo)) as Icodigo, Idescripcion, ValorCalculo
	from Impuestos
	where Ecodigo = #Session.Ecodigo#
	and ieps = 1
 union
	select '-' as Icodigo,' --- Sin IEPS ---' as Idescripcion,0 as ValorCalculo
	order by Idescripcion
</cfquery>

<cfquery name="rsRetenciones" datasource="#Session.DSN#">
	select 	Rcodigo, Rdescripcion,
		isVariable = ((select count(1) from RetencionesComp where Rcodigo = r.Rcodigo)) + coalesce(r.isVariable,0)
	from Retenciones r
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
	<cfset MSG_CtaAct = t.Translate('MSG_CtaAct','La cuenta de Activos en Transito no esta Definida. Proceso Cancelado!')>
	<cf_errorCode	code = "50342" msg = "#MSG_CtaAct#">
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

<cfset LvarSNid 	    = -1>
<cfset LvarSNvencompras = 0>
<cfif (isdefined("form.SNidentificacion") and len(trim(form.SNidentificacion))) or (isdefined("form.SNnumero") and len(trim(form.SNnumero)))>
	<cfquery name="rsSociosN" datasource="#session.DSN#">
		select SNid, SNcodigo, SNnombre, SNidentificacion, DEidVendedor, DEidCobrador, SNcuentacxp, SNvenventas, SNvencompras
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
	<cfset LvarSNid 		= rsSociosN.SNid>
    <cfset LvarSNvencompras = rsSociosN.SNvencompras>
	<cfset LvarSNcodigo = rsSociosN.SNcodigo>
	<cfset LvarSNidentificacion = rsSociosN.SNidentificacion>
    <!---<cfset LvarRemision = rsSociosN.remisionProveedor>--->
</cfif>
<cfset LvarSNid = 0>

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
	<cfset MSG_CtaSoc = t.Translate('MSG_CtaSoc','La cuenta para el Socio de Negocios debe ser definida.')>
	<cf_errorCode	code = "50183" msg = "#MSG_CtaSoc#">
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

<cfset LvarItemReadonly = false>
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
				month(EDfecha) as monthFecha,year(EDfecha) as yearFecha,
				Ocodigo, Ccuenta, id_direccion, Rcodigo, EDdocref, EDfechaarribo, EDretencionVariable,
                coalesce(
                    (
                        select sum(DDtotallinea)
                          from DDocumentosCxP
                         where IDdocumento = d.IDdocumento
                         and DDtipo != 'I'<!---Excluye impuesto variable--->
                    )
                ,0) as Subtotal,
				coalesce(
                    (
                        select isVariable = ((select count(1) from RetencionesComp where Rcodigo = r.Rcodigo)) + coalesce(r.isVariable,0)
                          from Retenciones r
                         where r.Ecodigo = d.Ecodigo
                         and r.Rcodigo = d.Rcodigo<!---Excluye impuesto variable--->
                    )
                ,0) as retVariable,
				d.ts_rversion,
				folio,
                d.EDvencimiento,
                d.EDAdquirir,
				d.EDexterno,
                d.TimbreFiscal,
                d.EDTiEPS,
				d.FolioReferencia,
				d.BMUsucodigo
		from EDocumentosCxP d
		where d.IDdocumento = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#IDdocumento#">
	</cfquery>

	<cfquery name="rsTieneRemision" datasource="#session.dsn#">
		select count(*) as totalRemisiones from EDocumentosCxP e
			inner join DDocumentosCxP d
			on e.IDdocumento = d.IDdocumento
			left outer join DDocumentosCPR dcpr
			on dcpr.DFacturalinea = d.Linea
			where dcpr.DFacturalinea is not null
			and e.IDdocumento = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#IDdocumento#">
			and e.Ecodigo = #Session.Ecodigo#;
	</cfquery>
	<cfquery name="rsTieneInclusion" datasource="#session.dsn#">
		select count(*) as registros
			from EDocumentosCxP ecp
			inner join CRDocumentoResponsabilidad dr
			on ecp.Ecodigo=dr.Ecodigo
			and ecp.IDdocumento=dr.CRDR_TipoReg
			where ecp.IDdocumento=<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#IDdocumento#">
			and ecp.Ecodigo = #Session.Ecodigo#;
	</cfquery>
  <cfquery name="rsTieneLineas" datasource="#session.dsn#">
		select count(*) as totalLineas from EDocumentosCxP e
			inner join DDocumentosCxP d
			on e.IDdocumento = d.IDdocumento
			and e.IDdocumento = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#IDdocumento#">
			and e.Ecodigo = #Session.Ecodigo#;
	</cfquery>

	<cfif rsTieneRemision.totalRemisiones NEQ 0>
	    <cfset rsTieneLineas.totalLineas = 0>
	</cfif>

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
 <!---Se inserta el UUID si no se inserto  --->
 <cfif isDefined("rsDocumento") and len(trim(rsDocumento.TimbreFiscal))>
 	<cfquery name="rsTimbre" datasource="#session.dsn#">
        select * from CERepoTMP
        where Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
        and Origen = 'CPFC'
        and ID_Documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDdocumento#">
        and TimbreFiscal ='#rsDocumento.TimbreFiscal#'
    </cfquery>
    <cfif isDefined("rsTimbre") and rsTimbre.recordcount EQ 0>
    	<cfquery datasource="#session.dsn#">
    	insert into CERepoTMP(Ecodigo,TimbreFiscal,ID_Documento,Documento,Origen,
								TotalCFDI,BMUsucodigo,Miso4217,Mcodigo,TipoCambio)
    	values(#Session.Ecodigo#,'#rsDocumento.TimbreFiscal#',#IDdocumento#,'#rsDocumento.EDdocumento#','CPFC',
    		0.0,#Session.Usucodigo#,(select Miso4217 from Monedas where Ecodigo = #Session.Ecodigo# and Mcodigo=#rsDocumento.Mcodigo#),#rsDocumento.Mcodigo#,#rsDocumento.EDtipocambio#)
    	</cfquery>
    <cfelseif rsTimbre.Documento EQ ''>
    	<cfquery datasource="#session.dsn#">
	    	update CERepoTMP
	    		set Documento = '#rsDocumento.EDdocumento#'
	        where Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	        and Origen = 'CPFC'
	        and ID_Documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDdocumento#">
        </cfquery>
    <cfelse> 
    </cfif>
 </cfif>
 <cfif isDefined("rsDocumento") and len(trim(rsDocumento.EDdocref))>
	<cfquery name="rsReferencia" datasource="#Session.DSN#">
		select a.IDdocumento, a.CPTcodigo, a.Ddocumento
		from EDocumentosCP a left outer join CPTransacciones b
		  on a.CPTcodigo = b.CPTcodigo and
			 a.Ecodigo = b.Ecodigo
		where a.Ecodigo = #Session.Ecodigo#
		  and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDocumento.SNcodigo#">

		  	and a.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDocumento.EDdocref#">

		  and b.CPTtipo = <cfqueryparam cfsqltype="cf_sql_char" value="C">
		  and coalesce(b.CPTpago, 0) != 1 and coalesce(b.CPTanticipo, 0) != 1
	</cfquery>
  </cfif>
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
				a.PCGDid,
                a.DSespecificacuenta,
                a.FPAEid,
                a.CFComplemento,
				a.CTDContid,
                coalesce(a.CambioCF,0) as CambioCF,
				rtrim(ltrim(a.codIEPS)) as codIEPS,
				a.DDMontoIeps,
                case when (a.DDtipo = 'S' or a.DDtipo = 'A') and (e.afectaIVA = 1 or f.afectaIVA = 1) THEN
			    	round(DDtotallinea * c.Iporcentaje/100,2)
			    when di.IEscalonado = 0 then
			    	round(DDtotallinea * c.Iporcentaje/100,2)
			    else
			    round((DDtotallinea+ round(DDtotallinea * COALESCE(di.ValorCalculo/100,0),2)) * c.Iporcentaje/100,2)
			   end as IVA
			from DDocumentosCxP a
				left outer join CContables b
			  		on a.Ccuenta = b.Ccuenta
				inner join Impuestos c
					on a.Ecodigo=c.Ecodigo
					and a.Icodigo=c.Icodigo
				left join Impuestos di
					on a.Ecodigo=di.Ecodigo
					and a.codIEPS=di.Icodigo
				left join Conceptos e
					on e.Cid = a.Cid
				left join Articulos f
					on f.Aid= a.Aid
			where a.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDdocumento#">
			  and a.Linea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Linea#">
		</cfquery>

         <cfif (isdefined("rsLinea.DOlinea") and rsLinea.DOlinea gt 0) and (isdefined("rsLinea.CTDContid") and rsLinea.CTDContid gt 0)>
                <cfquery name="rsLineaAgrup" datasource="#Session.DSN#">
                    select distinct
                        a.DOlinea,
                        a.CTDContid
                    from DDocumentosCxP a
                        left outer join CContables b
                            on a.Ccuenta = b.Ccuenta
                         inner join DOrdenCM c
                         	on a.DOlinea = c.DOlinea
                         inner join CTDetContrato d
                          	on a.CTDContid = d.CTDCont
                         inner join CTDetContratoAgr e
                         	on d.CTDCont = e.IdAgrSuf
                    where a.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDdocumento#">
                      and a.Linea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLinea.Linea#">
           		</cfquery>
         </cfif>
		<cfset LvarItemReadonly = rsLinea.DOlinea NEQ "">

		<!---Verificar por medio del parametro si se puede modificar el detalle--->
       <!--- <cfset rsModDet.Pvalor = 0>--->
        	<cfquery name="rsModDet" datasource="#Session.DSN#">
                select 0 as Pvalor
            </cfquery>
        <cfif isdefined("rsLinea.DOlinea") and rsLinea.DOlinea gt 0>
            <cfquery name="rsModDet" datasource="#Session.DSN#">
                select Pvalor
                from Parametros
                where Pcodigo = 15650
                and Ecodigo = #session.Ecodigo#
            </cfquery>
            <cfset LvarItemReadonly	= rsModDet.Pvalor eq 0>
        </cfif>

		<cfif rsLinea.recordcount gt 0 and rsUsaPlanCuentas.Pvalor eq LvarParametroPlanCom and LEN(TRIM(rsLinea.PCGDid))>
			 <cfquery name="rsManejaCantidad" datasource="#session.DSN#">
			   Select PCGDxCantidad from PCGDplanCompras where PCGDid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsLinea.PCGDid#">
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
			where CFid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsLinea.CFid#">
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
	<cfoutput>
	function doConlisReferencias() {
		if (document.form1.SNcodigo.value != "" )
			popUpWindow("ConlisReferencias.cfm?form=form1&docref=EDdocref&ref=Referencia&ref1=Referencia1&SNcodigo="+document.form1.SNcodigo.value,250,200,650,350);
		else
			alert("#MSG_SelProv#");
	}
	</cfoutput>




	function limpiarRef() {
		document.form1.EDdocref.value = "";
		document.form1.Referencia.value = "";
		document.form1.Referencia1.value = "";
	}


	function funcImprimir(){

		var indice =document.form1.indice.value;

		window.open('facturaTramite.cfm?lista='+indice, 'mywindow','location=1, align= absmiddle,status=1,scrollbars=1, top=100, left=100 width=500,height=500');

	}

	function funcImprimirFactura(){
		popUpWindow('ImprimeFactura.cfm?id=<cfoutput>#IDdocumento#</cfoutput>',100,100,700,600);

	}
	//FUNCION PARA DEPLEGAR EL POP-UP DE ARTICULOS DE IVENTARIO Y CONCEPTOS DE SERVICIO
	function doConlisItem() {
		if (document.form1.DDtipo.value == "A")
			popUpWindow("ConlisArticulos.cfm?form=form1&id=Aid&desc=descripcion&Alm="+document.form1.Almacen.value,250,200,650,350);
		if (document.form1.DDtipo.value == "S")
			popUpWindow("ConlisConceptos.cfm?form=form1&id=Cid&desc=descripcion&depto="+document.form1.Dcodigo.value,250,200,650,350);
	}
	//FUNCION PARA REGRESAR A LA LISTA
	function Lista() {
		var params  = '?pageNum_lista='+document.form1.pageNum_lista.value;
			params += (document.form1.fecha.value != '') ? 			"&fecha="       + document.form1.fecha.value : '';
			params += (document.form1.transaccion.value != '') ? 	"&transaccion=" + document.form1.transaccion.value : '';
			params += (document.form1.documento.value != '') ? 		"&documento="   + document.form1.documento.value : '';
			params += (document.form1.usuario.value != '') ?   		"&usuario="     + document.form1.usuario.value : '';
			params += (document.form1.moneda.value != '') ?    		"&moneda="      + document.form1.moneda.value : '';
			params += (document.form1.registros.value != '') ? 		"&registros="   + document.form1.registros.value : '';
			params += (document.form1.tipo.value != '') ? 			"&tipo=" 	    + document.form1.tipo.value : '';
			location.href="<cfoutput>#URLira#</cfoutput>"+params;
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
	<cfoutput>
	function validaNumero(dato) {
		if (dato.length > 0) {
			if (ESNUMERO(dato)) {
				return true;
			}
			else {
				alert('#MSG_MontoNum#');
				return false;
			}
		}
		else {
			alert('#MSG_MontoNum#');
			return false;
		}
	}
	</cfoutput>
	//FUNCION PARA OBTENER EL TIPO DE CAMBIO
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
	<cfoutput>
	function validaE() {
		document.form1.EDtotal.value = qf(document.form1.EDtotal.value);
		document.form1.EDdescuento.value = qf(document.form1.EDdescuento.value);
		document.form1.EDimpuesto.value = qf(document.form1.EDimpuesto.value);
		<cfif #lVarValidaFechaArribo# EQ true>
			if (datediff(document.form1.EDfecha.value, document.form1.EDfechaarribo.value) < 0)
				{
					alert ('#MSG_FecArr#');
					return false;
				}
		</cfif>
		return true;
	}
	</cfoutput>
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
		if (document.form1.DDtipo.value == "I"){
			document.getElementById("labelarticulo").style.display = '';
			document.getElementById("labelconcepto").style.display = '';
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

		if(document.form1.DDtotallinea.value>0){

	}
		calculaieps();
	}

	function fnValidarMontos(){
		if (document.form1.DDpreciou.value=="" )
			document.form1.DDpreciou.value = "<cfoutput>#LvarOBJ_PrecioU.enCF(0)#</cfoutput>";
		if (document.form1.DDdesclinea.value=="")
			document.form1.DDdesclinea.value = "0.00";
		if (document.form1.DDcantidad.value=="" )
			document.form1.DDcantidad.value = "0.00";
		if (document.form1.DDpreciou.value=="-" ){
			document.form1.DDpreciou.value = "<cfoutput>#LvarOBJ_PrecioU.enCF(0)#</cfoutput>";
			document.form1.DDtotallinea.value = "0.00";
		}
		if (document.form1.DDdesclinea.value=="-"){
			document.form1.DDdesclinea.value = "0.00"
			document.form1.DDtotallinea.value = "0.00"
		}
		var cantidad = new Number(qf(document.form1.DDcantidad.value))
		if(cantidad < 1){
			cantidad = 1;
			document.form1.DDcantidad.value = "1.00";
		}
		var precio = new Number(qf(document.form1.DDpreciou.value))
		var descuento = new Number(qf(document.form1.DDdesclinea.value))
		var seguir = "si";

		if(precio < 0){
			document.form1.DDpreciou.value="<cfoutput>#LvarOBJ_PrecioU.enCF(0)#</cfoutput>";
			seguir = "no"
		}

		if(descuento < 0){
			document.form1.DDdesclinea.value="0.00";
			seguir = "no"
		}
		var subtotal = new Number(qf(document.form1.DDtotallinea.value));
		if(cantidad > 0){
			document.form1.DDpreciou.value = fm(redondear((subtotal - descuento) / cantidad,4),4,true,false,'');
		}else{
			document.form1.DDpreciou.value = fm(0,4,true,false,'');
			fm(document.form1.DDtotallinea,4,true,false,'');
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
		<cfif isdefined("rsModDet.Pvalor") and rsModDet.Pvalor Neq 1>
			document.form1.DDdescalterna.value="";
			document.form1.DDdescripcion.value="";
		</cfif>
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
			document.getElementById("trv3").style.display = 'none';
			document.getElementById("trv4").style.display = 'none';
			//document.form1.DDcantidad.value = "0.00"
			document.form1.DDcantidad.readOnly = false;

			document.getElementById("labelConceptoT").style.display = 'none';
			document.getElementById("ConceptoT").style.display = 'none';

			document.getElementById("EspecificaCuentaLabel").style.display = 'none';
			document.getElementById("EspecificaCuenta").style.display = 'none';
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

			document.getElementById("labelDDdesclinea").style.display = '';
			document.getElementById("DDdesclinea").style.display = '';

			document.getElementById("TRCUENTADET").style.display = '';
			<cfif modoDet neq 'ALTA' and rsModDet.Pvalor eq 1>
				CcuentaD_disabled(false);
			<cfelse>
				CcuentaD_disabled(true);
			</cfif>
		}
		if(document.form1.DDtipo.value=="O"){
			document.getElementById("TRCUENTADET").style.display = '';
			document.getElementById("trv").style.display = '';
			document.getElementById("trv2").style.display = '';
			document.getElementById("trv3").style.display = 'none';
			document.getElementById("trv4").style.display = 'none';
			//document.form1.DDcantidad.value = "0.00"
			document.form1.DDcantidad.readOnly = false;

			document.getElementById("labelConceptoT").style.display = '';
			document.getElementById("ConceptoT").style.display = '';


			document.getElementById("EspecificaCuentaLabel").style.display = 'none';
			document.getElementById("EspecificaCuenta").style.display = 'none';
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
			document.getElementById("labelDDdesclinea").style.display = '';
			document.getElementById("DDdesclinea").style.display = '';

			<cfif modoDet neq 'ALTA' and rsModDet.Pvalor eq 1>
				CcuentaD_disabled(false);
			<cfelse>
				CcuentaD_disabled(true);
			</cfif>
		}
		if(document.form1.DDtipo.value=="A"){
			document.getElementById("trv").style.display = '';
			document.getElementById("trv2").style.display = 'none';
			document.getElementById("trv3").style.display = 'none';
			document.getElementById("trv4").style.display = 'none';
			//document.form1.DDcantidad.value = "0.00"
			document.form1.DDcantidad.readOnly = false;
			document.getElementById("TRCUENTADET").style.display = '';

			document.getElementById("labelConceptoT").style.display = 'none';
			document.getElementById("ConceptoT").style.display = 'none';

			document.getElementById('TransporteLabel').style.display 	= 'none';
			document.getElementById('TransporteImput').style.display 	= 'none';
			document.getElementById('OrdenLabel').style.display 		= 'none';
			document.getElementById('OrdenImput').style.display 		= 'none';
			document.getElementById("EspecificaCuentaLabel").style.display = 'none';
			document.getElementById("EspecificaCuenta").style.display = 'none';
			<!---ERBG 21/06/2013 Inicia--->
			document.getElementById("CFLabel").style.display 				= '';
			document.getElementById("centrofuncional").style.display 		= '';
			<!---ERBG 21/06/2013 Termina--->
			document.getElementById("labelconcepto").style.display 		= 'none';
			document.getElementById('concepto').style.display 			= 'none';
			document.getElementById('articuloT').style.display = 'none';



			document.getElementById("AlmacenLabel").style.display 	= '';
			document.getElementById("AlmacenImput").style.display 	= '';
			document.getElementById("labelarticulo").style.display = '';
			document.getElementById('articulo').style.display = '';
			document.getElementById('articuloOD').style.display         = 'none';
			document.getElementById("labelDDdesclinea").style.display = '';
			document.getElementById("DDdesclinea").style.display = '';

			<cfif modoDet neq 'ALTA' and rsModDet.Pvalor eq 1>
				CcuentaD_disabled(false);
			<cfelse>
				CcuentaD_disabled(true);
			</cfif>
		}
		if(document.form1.DDtipo.value=="S"){
			document.getElementById("trv").style.display = '';
			document.getElementById("trv2").style.display = 'none';
			document.getElementById("trv3").style.display = 'none';
			document.getElementById("trv4").style.display = 'none';
			//document.form1.DDcantidad.value = "0.00"
			document.form1.DDcantidad.readOnly = false;
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


			document.getElementById("EspecificaCuentaLabel").style.display = '';
			document.getElementById("EspecificaCuenta").style.display = '';
			document.getElementById("CFLabel").style.display = '';
			document.getElementById("centrofuncional").style.display = '';
			document.getElementById("labelconcepto").style.display = '';
			document.getElementById('concepto').style.display = '';
			document.getElementById("labelconcepto").style.display = '';
			document.getElementById("labelDDdesclinea").style.display = '';
			document.getElementById("DDdesclinea").style.display = '';
			<cfif LvarComplementoXorigen>
			CcuentaD_disabled(true);
			<cfelse>
			CcuentaD_disabled(!document.form1.chkEspecificarcuenta.checked);
			</cfif>

		}
		if(document.form1.DDtipo.value=="P"){
			document.getElementById("trv").style.display = 'none';
			document.getElementById("trv2").style.display = 'none';
			document.getElementById("trv3").style.display = 'none';
			document.getElementById("trv4").style.display = 'none';
			//document.form1.DDcantidad.value = "0.00"
			document.form1.DDcantidad.readOnly = false;
			document.getElementById("TRCUENTADET").style.display = '';

			document.getElementById("labelConceptoT").style.display = 'none';
			document.getElementById("ConceptoT").style.display = 'none';

			document.getElementById('TransporteLabel').style.display 	= '';
			document.getElementById('TransporteImput').style.display 	= '';
			document.getElementById('OrdenLabel').style.display 		= '';
			document.getElementById('OrdenImput').style.display 		= '';
			document.getElementById("labelDDdesclinea").style.display = '';
			document.getElementById("DDdesclinea").style.display = '';
			document.getElementById("labelarticulo").style.display 		= 'none';
			document.getElementById('articulo').style.display 			= 'none';
			document.getElementById("labelarticulo").style.display 		= 'none';
			document.getElementById('articuloOD').style.display         = 'none';
			document.getElementById("AlmacenImput").style.display 		= 'none';
			document.getElementById("AlmacenLabel").style.display 		= 'none';
			document.getElementById('articuloT').style.display = 'none';


			document.getElementById("EspecificaCuentaLabel").style.display = 'none';
			document.getElementById("EspecificaCuenta").style.display = 'none';
			document.getElementById("CFLabel").style.display = '';
			document.getElementById("centrofuncional").style.display = '';
			document.getElementById("labelconcepto").style.display = '';
			document.getElementById('concepto').style.display = 'none';
			document.getElementById("labelconcepto").style.display = 'none';
			CcuentaD_disabled(false);
		}

	    if(document.form1.DDtipo.value=="F") {
	    	document.getElementById("labelDDdesclinea").style.display = '';
			document.getElementById("DDdesclinea").style.display = '';
			//document.form1.DDcantidad.value = "0.00"
			document.form1.DDcantidad.readOnly = false;
			document.getElementById("trv").style.display = 'none';
			document.getElementById("trv2").style.display = 'none';
			document.getElementById("trv3").style.display = 'none';
			document.getElementById("trv4").style.display = 'none';
			document.getElementById("TRCUENTADET").style.display = '';
			document.getElementById('articuloT').style.display = 'none';
			document.getElementById('TransporteLabel').style.display = 'none';
			document.getElementById('TransporteImput').style.display = 'none';
			document.getElementById('OrdenLabel').style.display 	= 'none';
			document.getElementById('OrdenImput').style.display 	= 'none';
			document.getElementById("EspecificaCuentaLabel").style.display = 'none';
			document.getElementById("EspecificaCuenta").style.display = 'none';
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


			<cfif mododet EQ "ALTA">

				if(document.form1.LvarPlanDeCompras.value != "true")
				{
					if (document.form1.CcuentaD)
					{
						document.form1.CFcuentaD.value = "";
						document.form1.CcuentaD.value = "<cfoutput>#rsCuentaActivo.Ccuenta#</cfoutput>";
						document.form1.CdescripcionD.value = "<cfoutput>#rsCuentaActivo.Cdescripcion#</cfoutput>";
					}
					<cfif len(rsCuentaActivo.Cformato) GTE 5>
						if (document.form1.CmayorD)
						{
							document.form1.CmayorD.value = "<cfoutput>#mid(rsCuentaActivo.Cformato,1,4)#</cfoutput>";
							document.form1.CformatoD.value = "<cfoutput>#trim(mid(rsCuentaActivo.Cformato,6,len(rsCuentaActivo.Cformato)))#</cfoutput>";
						}
					<cfelse>
						if (document.form1.CmayorD)
						{
							document.form1.CmayorD.value = "<cfoutput>#rsCuentaActivo.Cformato#</cfoutput>";
							document.form1.CformatoD.value = "";
						}
					</cfif>
				}
			</cfif>

			<cfif modoDet neq 'ALTA' and rsModDet.Pvalor eq 1>
				CcuentaD_disabled(false);
			<cfelse>
				CcuentaD_disabled(true);
			</cfif>
		}

		//Función del Impuesto Variable
		if(document.form1.DDtipo.value=="I"){

			var idxV = -1;
			var slt = document.form1.Icodigo;
		    if(slt){
		       var x = slt.options.length;
		       for(i = 0; i < x; i++) {
		        if(trim(slt.options[i].value) == 'IEXE'){
				slt.options[i].disabled = true;
				slt.value = slt.options[1].value;
			}
		       }
		    }

			document.getElementById("trv").style.display = '';
			document.getElementById("TRCUENTADET").style.display = '';
			document.getElementById("trv2").style.display = 'none';
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
			document.getElementById('articuloT').style.display 			= 'none';
			document.getElementById("EspecificaCuentaLabel").style.display = 'none';
			document.getElementById("EspecificaCuenta").style.display = 'none';
			document.getElementById("labelDDdesclinea").style.display = 'none';
			document.getElementById("DDdesclinea").style.display = 'none';
			//document.form1.DDcantidad.value = "1.00"
			document.form1.DDcantidad.readOnly = true;
			document.getElementById("CFLabel").style.display = '';
			document.getElementById("centrofuncional").style.display = '';


			fnCambioCuentaImpuesto();

		}else{
			var idxV = -1;
			var slt = document.form1.Icodigo;
		    if(slt){
		       var x = slt.options.length;
		       for(i = 0; i < x; i++) {
		        if(trim(slt.options[i].value) == 'IEXE')slt.options[i].disabled = false;
		       }
		    }
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
		if (document.form1.CmayorD)
		{
			document.form1.CmayorD.value = '';
			document.form1.CformatoD.value = '';
			document.form1.CdescripcionD.value = '';
		}
	}

	function validaD() {
		<cfoutput>
		if (document.form1.DDtipo.value=="A")
		{

			if (document.form1.Almacen.value == "")  {
				alert ("#MSG_DigAlm#")
				return false;
			}
			if (document.form1.Aid.value == "")  {
				alert ("#MSG_DigArt#")
				return false;
			}
			<!--- ERBG 21/06/2013 Inicia --->
			if (document.form1.CFid.value == ""){
				alert ("Debe digitar el Centro Funcional")
				return false;
			}
			<!--- ERBG 21/06/2013 Termina --->
		}

		if (document.form1.DDtipo.value=="T")
		{

			if (document.form1.Almacen.value == "")  {
				alert ("#MSG_DigAlm#")
				return false;
			}
		}

		if (document.form1.DDtipo.value=="S")
		{
		   	if (document.form1.Cid.value == "")  {
				alert ("#MSG_DigConc#")
				return false;
			}
			if (document.form1.CFid.value == ""){
				alert ("#MSG_DigCC#")
				return false;
			}

		}
		if (document.form1.CPTcodigo.value=="--")
		{
				alert ("#MSG_DigTT#")
				return false;
		}
		</cfoutput>
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

		if (document.form1.DDtipo.value=="I"){
			objForm.DDdescripcion.required = true;
			objForm.DDdescripcion.description = "<cfoutput>#Lbl_DescImpVar#</cfoutput>";
		}


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
					<cfoutput>
					alert("#MSG_ConcComp#");
					</cfoutput>
					return false;
				}
				else if (document.form1.OCCid.options[document.form1.OCCid.selectedIndex].text.substring(0,3) != "00-" &&
						 qf(document.form1.DDcantidad.value) != "0.00")
				{
					<cfoutput>
					alert("#MSG_ConcComp#");
					</cfoutput>
					return false;
				}
			}
		}
		return true;
	}

	function AsignarHiddensEncab() {
		var estado = document.form1.EDtipocambio.disabled;
		document.form1._EDfecha.value 		 = document.form1.EDfecha.value;
		document.form1._EDvencimiento.value  = document.form1.EDvencimiento.value;
		document.form1._EDfechaarribo.value  = document.form1.EDfechaarribo.value;
		document.form1._Mcodigo.value		 = document.form1.Mcodigo.value;
		document.form1.EDtipocambio.disabled = false;
		document.form1._EDtipocambio.value 	 = document.form1.EDtipocambio.value;
		document.form1.EDtipocambio.disabled = estado;
		document.form1._Ocodigo.value 		 = document.form1.Ocodigo.value;
		document.form1._Rcodigo.value 		 = document.form1.Rcodigo.value;
		document.form1._EDretencionVariable.value 	= document.form1.EDretencionVariable.value;
		document.form1._EDdescuento.value 	 = document.form1.EDdescuento.value;
		document.form1._EDdocumento.value 	 = document.form1._EDdocumento.value;
		document.form1._Ccuenta.value 		 = document.form1.Ccuenta.value;
		document.form1._EDimpuesto.value 	 = document.form1.EDimpuesto.value;
		document.form1._EDtotal.value 		 = document.form1.EDtotal.value;
		document.form1._EDdocref.value 		 = document.form1.EDdocref.value;
		document.form1._TESRPTCid.value 	 = document.form1.TESRPTCid.value;
		document.form1._id_direccion.value 	 = document.form1.id_direccion.value;
	}
	<cfoutput>
	function Postear(){
		if (fnAplicar_TESOPFP) return fnAplicar_TESOPFP();
		if (confirm('#MSG_AplDoc#')) {
			document.form1.EDtipocambio.disabled = false;
			return true;
		}
		else return false;
	}
	</cfoutput>
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
 //FUNCION PARA REFRESCAR
function funcRefrescar(){
		document.form1.action = '<cfoutput>#URLira#</cfoutput>?modo=Cambio&tipo=' + document.form1.tipo.value;
		document.form1.submit();
	}
function funcRefrescarTimbre(valT){
		////alert("funref2"+valT);
		document.form1.chkChgTimbre.value= 1; 
		if (typeof valT !== 'undefined') { // devuelve true
   			document.form1.Timbre.value= valT;
		}
		else{
			document.form1.Timbre.value= '';
		}
		document.form1.submit();
	}
function funcSNnumero(){
		document.form1.action = '<cfoutput>#URLira#</cfoutput>?tipo=' + document.form1.tipo.value;
		document.form1.submit();
	}


	function CcuentaD_disabled(x)
	{
		if (document.form1.CmayorD)
		{
			document.form1.Ecodigo_CcuentaD.disabled	= x;
			document.form1.CmayorD.disabled				= x;
			document.form1.CformatoD.disabled			= x;
			if (document.getElementById("hhref_CcuentaD"))
			document.getElementById("hhref_CcuentaD").style.visibility = x?"hidden":"visible";
		}
	}

	function EspeciCuenta()
	{
		if (document.form1.chkEspecificarcuenta.checked)
		{
			CcuentaD_disabled(false);
		}
		else
		{
			document.getElementById("Ecodigo_CcuentaD").options.selectedIndex = 0;

			CcuentaD_disabled(true);
			fnCambioCuenta();
		}
	}
	function EspeciCF()
	{
		document.form1.action = "RegistroFacturasCP.cfm";
		document.getElementById("Datos").value = document.form1.IDdocumento.value +'|'+document.form1.Linea.value;
		document.form1.submit();

	}
	function funcCFcodigo()
	{
		if (document.form1.chkEspecificarcuenta.checked)
			return;
		if(document.form1.DDtipo.value == "I"){
			fnCambioCuentaImpuesto();
		}else{
			fnCambioCuenta();
		}

	}
	function funcCcodigo()
	{
		if (document.form1.chkEspecificarcuenta.checked)
			return;

		llenar();
		fnCambioCuenta();
	}

	function trim(str, chars) {
    return ltrim(rtrim(str, chars), chars);
	}

	//ltrim quita los espacios o caracteres indicados al inicio de la cadena
	function ltrim(str, chars) {
		chars = chars || "\\s";
		return str.replace(new RegExp("^[" + chars + "]+", "g"), "");
	}
	//rtrim quita los espacios o caracteres indicados al final de la cadena
	function rtrim(str, chars) {
		chars = chars || "\\s";
		return str.replace(new RegExp("[" + chars + "]+$", "g"), "");
	}

	function calculaieps(){
	   	var i = document.form1.codIEPS.selectedIndex;
	   	var valor = document.form1.codIEPS.options[i].value;
	   	var subt = new Number(qf(document.form1.DDtotallinea.value));
	   	document.form1.DDMieps.value = "0.00";
	   <cfoutput query = "rsImpuestosIeps">
	   	   if ('#Trim(rsImpuestosIeps.Icodigo)#' == trim(valor)){
	   	   var valcal = '#rsImpuestosIeps.ValorCalculo#';
				document.form1.DDMieps.value = fm(subt * (valcal/100),2);
			  };
	   </cfoutput>
	}


	function llenar(){
		var id = document.form1.Ccodigo.value;
		id= trim(id," ");
		document.form1.codIEPS[0].selected="1";


		var opieps = document.form1.codIEPS.length;
		<cfif isdefined('rsCieps')>
			<cfoutput query = "rsCieps">
			if ('#Trim(rsCieps.Ccodigo)#' == id){
					for(i=0; i<opieps; i++){

						if('#rsCieps.Icodigo#' == document.form1.codIEPS.options[i].value){
							document.form1.codIEPS[i].selected="1";
						}
					}
			  };
			</cfoutput>
		</cfif>
		calculaieps();
	}

	function llenar2(){
		var id = document.form1.Acodigo.value;
		id= trim(id," ");
		document.form1.codIEPS[0].selected="1";


		var opieps = document.form1.codIEPS.length;
		<cfif isdefined('rsCieps2')>
			<cfoutput query = "rsCieps2">
			if ('#Trim(rsCieps2.Acodigo)#' == id){
					for(i=0; i<opieps; i++){

						if('#rsCieps2.Icodigo#' == document.form1.codIEPS.options[i].value){
							document.form1.codIEPS[i].selected="1";
						}
					}
			  };
			</cfoutput>
		</cfif>
		calculaieps();
	}


	function funcCFComplemento(){
		if (document.form1.chkEspecificarcuenta.checked)
			return;

		fnCambioCuenta();
	}

	function fnCambioCuenta()
	{
		if(document.form1.DDtipo.value=="A")
		{return;}
		else
		{
		fnSetCuenta("","","","");
		if (document.form1.Cid.value != '' & document.form1.CFcodigo.value != '')
		{

		<cfoutput>
			//Esto porque cuando es intercompañia cambia el ecodigo entonces para pasarlo al aplicar mascara
			if (document.form1.Ecodigo_CcuentaD.value !=-1)
			{
				var Ecodigo =document.form1.Ecodigo_CcuentaD.value;
				document.form1.Ecodigo_CcuentaD.disabled=false;
			}
			else{
				var Ecodigo =#session.Ecodigo#;
			}
		CFComplemento = "";
		if(document.form1.CFComplemento)
			CFComplemento = document.form1.CFComplemento.value;
		     document.getElementById("ifrGenCuenta").src= "SQLRegistroDocumentosCP.cfm?OP=GENCF&tipoItem=S&Cid=" + document.form1.Cid.value + "&SNid=#LvarSNid#&CFid=" + document.form1.CFid.value + "&Ecodigo=" + Ecodigo +"&CFComplemento=" + CFComplemento+"&TipDoc=<cfoutput>#LvarTipDoc#</cfoutput>";
		</cfoutput>
			}
		}
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
</script>
<iframe id="ifrGenCuenta" style="display:none"></iframe>

<cfset LB_EncDocto 	= t.Translate('LB_EncDocto','Encabezado del Documento')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento','Anticipo.xml')>
<cfset LB_Transaccion = t.Translate('LB_Transaccion','Transacción','/sif/generales.xml')>
<cfset LB_Proveedor = t.Translate('LB_Proveedor','Proveedor','/sif/generales.xml')>
<cfset LB_Folio_Referencia= t.Translate('LB_Folio_Referencia','Folio Referencia','/sif/generales.xml')>
<cfset LB_Cuenta 	= t.Translate('LB_Cuenta','Cuenta','/sif/generales.xml')>
<cfset LB_FecArr 	= t.Translate('LB_FecArr','Fecha Arribo')>
<cfset LB_Moneda 	= t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_FecFact 	= t.Translate('LB_FecFact','Fecha Factura')>
<cfset LB_Tipo_de_Cambio 	= t.Translate('LB_Tipo_de_Cambio','Tipo Cambio','/sif/generales.xml')>
<cfset LB_FecVenc 	= t.Translate('LB_FecVenc','Fecha Vencimiento')>
<cfset LB_Oficina 	= t.Translate('LB_Oficina','Oficina','/sif/generales.xml')>
<cfset LB_PagTerc 	= t.Translate('LB_PagTerc','Pagos a terceros')>
<cfset LB_RetPag 	= t.Translate('LB_RetPag','Retenci&oacute;n al Pagar')>
<cfset LB_SinRet 	= t.Translate('LB_SinRet','Sin Retención')>
<cfset LB_DirFact 	= t.Translate('LB_DirFact','Direcci&oacute;n facturaci&oacute;n')>
<cfset LB_Ninguna 	= t.Translate('LB_Ninguna','Ninguna')>
<cfset LB_TimbreFiscal 	= t.Translate('LB_TimbreFiscal','Timbre Fiscal UUID')>
<cfset LB_ArchivoCFDI=t.Translate('LB_ArchivoCFDI','Archivo CFDI xml')>
<cfset LB_Refer 	= t.Translate('LB_Refer','Referencia')>
<cfset LB_LstRefer 	= t.Translate('LB_LstRefer','Lista de Documentos de Referencia')>
<cfset LB_Subtotal = t.Translate('LB_Subtotal','Subtotal','/sif/generales.xml')>
<cfset LB_Descuento = t.Translate('LB_Descuento','Descuento')>
<cfset LB_Impuesto 	= t.Translate('LB_Impuesto','Impuesto')>
<cfset LB_IEPS 	= t.Translate('LB_IEPS','IEPS')>
<cfset LB_Total = t.Translate('LB_Total','Total','/sif/generales.xml')>
<cfset LB_DetDocto 	= t.Translate('LB_DetDocto','Detalle del Documento')>
<cfset LB_ArtTran 	= t.Translate('LB_ArtTran','Artículo Tránsito')>
<cfset LB_Retenc 	= t.Translate('LB_Retenc','Retención')>
<cfset LB_Garantias	= t.Translate('LB_Garantias','Garantias')>

<cfset Lbl_CamDoct	= t.Translate('Lbl_CamDoct','Cambiar Documento')>
<cfset Lbl_CamLine	= t.Translate('Lbl_CamLine','Cambiar Linea')>
<cfset BTN_Agregar 	= t.Translate('BTN_Agregar','Agregar','/sif/generales.xml')>
<cfset Lbl_BorrDoc	= t.Translate('Lbl_BorrDoc','Borrar Documento')>
<cfset BTN_Aplicar 	= t.Translate('BTN_Aplicar','Aplicar','/sif/generales.xml')>
<cfset Lbl_EnvApl	= t.Translate('Lbl_EnvApl','Enviar a Aplicar')>
<cfset BTN_Anular 	= t.Translate('BTN_Anular','Anular','/sif/generales.xml')>
<cfset Lbl_OrdC	= t.Translate('Lbl_OrdC','Orden Compra')>
<cfset Lbl_Remision = t.Translate('Lbl_Remision','Remisiones')>
<cfset Lbl_Contrato	= t.Translate('Lbl_Contrato','Contrato')>
<cfset Lbl_NuevaL	= t.Translate('Lbl_NuevaL','Nueva Linea')>
<cfset Lbl_LinFact	= t.Translate('Lbl_LinFact','Lineas de Factura')>
<cfset Lbl_PlanCmpr	= t.Translate('Lbl_PlanCmpr','Plan de Compras')>
<cfset BTN_Nuevo 	= t.Translate('BTN_Nuevo','Nuevo','/sif/generales.xml')>
<cfset BTN_ImprTr 	= t.Translate('BTN_ImprTr','Imprimir trámite')>
<cfset BTN_ImprFac 	= t.Translate('BTN_ImprFac','Imprimir Factura')>
<cfset BTN_EnvMail 	= t.Translate('BTN_EnvMail','Enviar Email')>
<cfset BTN_Ver 	= t.Translate('BTN_Ver','Ver')>
<cfset BTN_VerOC 	= t.Translate('BTN_VerOC','Ver Ordenes de Compra')>
<cfset BTN_Regresar 	= t.Translate('BTN_Regresar','Regresar','/sif/generales.xml')>
<cfset Lbl_Folio	= t.Translate('Lbl_Folio','Folio')>


<iframe id="frameExec" width="1" height="1" frameborder="0">&nbsp;</iframe>

<form name="form1" id="form1" action="SQLRegistroDocumentosCP.cfm" method="post" enctype="multipart/form-data">
	<input name="haydetalle" 		id="haydetalle" 		type="hidden" value="<cfif isdefined("rsLineas") and rsLineas.recordCount GT 0><cfoutput>SI</cfoutput><cfelse><cfoutput>NO</cfoutput></cfif>">
	<input name="LvarRecurrente" 	id="LvarRecurrente"  	type="hidden" value="0">
	<input name="LvarPlanDeCompras" id="LvarPlanDeCompras"  type="hidden" value="<cfoutput>#LvarPlanDeCompras#</cfoutput>">
    <input name="SNvencompras" 		id="SNvencompras"  		type="hidden" value="<cfoutput>#LvarSNvencompras#</cfoutput>">
    <input name="TipDoc"			id="TipDoc" 			type="hidden" value="<cfoutput>#LvarTipDoc#</cfoutput>">
    <input name="URLira"			id="URLira" 			type="hidden" value="<cfoutput>#URLira#</cfoutput>">
    <input type="hidden" name="param5060" id="param5060"	value="<cfoutput>#(LvarAnoAux*100)+LvarMesAux#</cfoutput>">
	<input type="hidden" name="chkChgTimbre" id="chkChgTimbre" value="">
    <input type="hidden" name="Datos" id="Datos"	value="">

		<table width="100%" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td colspan="5" class="tituloAlterno"><div align="center"><cfoutput>#LB_EncDocto#</cfoutput></div></td>
          </tr>
          <tr>
            <td width="13%"><div align="right"><cfoutput>#LB_Documento#:&nbsp;</cfoutput></div></td>
            <td width="39%"><cfoutput>
                <input name="EDdocumento" <cfif modo NEQ "ALTA"> class="cajasinborde" tabindex="-1" <cfelse>
				tabindex="1"</cfif> type="text" value="<cfif modo NEQ "ALTA">#rsDocumento.EDdocumento#<cfelseif isdefined('Form.EDDocumento')>#form.EDDocumento#</cfif>"
				size="20" maxlength="20" />
				#Lbl_Folio#:&nbsp;
                <cfset LvarModifica = 'true'>
                <cfset LvarValue = ''>
                <cfif isdefined('Form.Folio')>
                	<cfset LvarValue = form.Folio>
                </cfif>
                <cfif isdefined('url.Folio')>
                	<cfset LvarValue = url.Folio>
                </cfif>

                <cfif modo NEQ "ALTA">
					<cfset LvarModifica = 'false'>
                	<cfset LvarValue = rsDocumento.folio>
                </cfif>
                <cf_inputNumber name="Folio" value="#LvarValue#" comas="no" modificable="#LvarModifica#" size="20" enteros="20" tabIndex= "-1">
            </cfoutput> </td>
            <cfoutput>
            <td width="10%" nowrap="nowrap"><div align="right">#LB_Transaccion#(
                  <cfif form.tipo EQ "C">
                    CR
                      <cfelse>
                    DB
                  </cfif>
              ):&nbsp;</div></td></cfoutput>
            <td width="37%">
            <cfif modo NEQ "ALTA">
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
									<cfif modo NEQ "ALTA" and rsTransacciones.CPTcodigo EQ rsDocumento.CPTcodigo or isdefined("form.CPTcodigo") and modo EQ "ALTA" and rsTransacciones.CPTcodigo eq form.CPTcodigo>selected
									<cfelseif modo EQ 'ALTA' and isdefined('form.CPTcodigo') and rsTransacciones.CPTcodigo EQ "--">
										selected
									</cfif>> #rsTransacciones.CPTcodigo# - #rsTransacciones.CPTdescripcion# </option>
	                  </cfoutput>
	                </select>
              </cfif>
            </td>
          </tr>
		<tr>
			<cfoutput>
			<td align="right">#LB_FOLIO_REFERENCIA#:</td>
			<td><input name="FolioReferencia" id="FolioReferencia" type="text" maxlength="13" value="<cfif modo NEQ "ALTA">#rsDocumento.FolioReferencia#<cfelseif isdefined('Form.FolioReferencia')>#form.FolioReferencia# </cfif>" /></td>
			<cfif isdefined('Form.FolioReferencia')>
                	<cfset FolioReferencia = form.FolioReferencia>
            </cfif>
			</cfoutput>

		</tr>
          <tr>
          	<!---►►Proveedor◄◄--->
            <cfoutput>
            <td><div align="right">&nbsp;#LB_Proveedor#:&nbsp;</div></td>
            </cfoutput>
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
          <cfif MODO NEQ "ALTA">
          	<tr>
            	<cf_cboFormaPago TESOPFPtipoId="4" TESOPFPid="#IDdocumento#">
            </tr>
          </cfif>

          <tr>
          	<!---►►Cuenta◄◄--->
            <cfoutput>
            <td><div align="right">&nbsp;#LB_Cuenta#:&nbsp;</div></td>
            </cfoutput>
            <td  colspan="2">
			<cfoutput>
                <cfif LvarComplementoXorigen>
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
				<td><cfif modo NEQ "ALTA"> <input type="button" tabindex="1" name="Garantias" value="#LB_Garantias#" onclick="funcGarantias(#IDdocumento#)" /></cfif>
	            </td>
            </cfoutput>
            </td>
          </tr>
          <tr>
          	<!---►►Fecha de Arribo◄◄--->
            <td><div align="right"><cfoutput>#LB_FecArr#:&nbsp;</cfoutput></div></td>
            <td>
				<cfif lVarValidaFechaArribo EQ true>
					<cfif modo NEQ 'ALTA'>
	                	<cf_sifcalendario name="EDfechaarribo" value="#LSDateFormat(rsDocumento.EDfechaarribo,'dd/mm/yyyy')#" tabindex="1">
	                <cfelseif isdefined("form.EDfechaarribo")>
	                	<cf_sifcalendario name="EDfechaarribo" value="#LSDateFormat(form.EDfechaarribo,'dd/mm/yyyy')#"        tabindex="1">
	                <cfelse>
	                	<cf_sifcalendario name="EDfechaarribo" value="#LSDateFormat(rsFechaHoy.Fecha,'dd/mm/yyyy')#"          tabindex="1">
	              	</cfif>
				<cfelse>
					<cfif modo NEQ 'ALTA'>
	                	<cf_sifcalendario name="EDfechaarribo" value="#LSDateFormat(rsDocumento.EDfechaarribo,'dd/mm/yyyy')#" tabindex="1" 		Function="CalculaFechaVen();">
	                <cfelseif isdefined("form.EDfechaarribo")>
	                	<cf_sifcalendario name="EDfechaarribo" value="#LSDateFormat(form.EDfechaarribo,'dd/mm/yyyy')#"        tabindex="1" 		Function="CalculaFechaVen();">
	                <cfelse>
	                	<cf_sifcalendario name="EDfechaarribo" value="#LSDateFormat(rsFechaHoy.Fecha,'dd/mm/yyyy')#"          tabindex="1" 		Function="CalculaFechaVen();">
	              	</cfif>
				</cfif>
            </td>
            <!---►►Moneda◄◄--->
            <td><div align="right"><cfoutput>#LB_Moneda#:&nbsp;</cfoutput></div></td>
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
          </tr>
          <tr>
          <!---►►Fecha Factura◄◄--->
          	<td><div align="right"><cfoutput>#LB_FecFact#:&nbsp;</cfoutput></div></td>
            <td>
				<cfif lVarValidaFechaArribo EQ true>
					<cfif modo NEQ 'ALTA'>
						<cf_sifcalendario name="EDfecha" value="#DateFormat(rsDocumento.EDfecha,'dd/mm/yyyy')#" tabindex="1" Function="obtenerTC(document.getElementById('form1'));CalculaFechaVen();">
		            <cfelseif isdefined("form.EDfecha") and len(trim(form.EDfecha))>
		                <cf_sifcalendario name="EDfecha" value="#LSDateFormat(form.EDfecha,'dd/mm/yyyy')#" tabindex="1" Function="obtenerTC(document.getElementById('form1')); CalculaFechaVen();">
		            <cfelse>
		                <cf_sifcalendario name="EDfecha" value="#LSDateFormat(rsFechaHoy.Fecha,'dd/mm/yyyy')#" tabindex="1" Function="obtenerTC(document.getElementById('form1')); CalculaFechaVen();">
					</cfif>
				<cfelse>
					<cfif modo NEQ 'ALTA'>
						<cf_sifcalendario name="EDfecha" value="#DateFormat(rsDocumento.EDfecha,'dd/mm/yyyy')#" tabindex="1" Function="obtenerTC(document.getElementById('form1'));">
		            <cfelseif isdefined("form.EDfecha") and len(trim(form.EDfecha))>
		                <cf_sifcalendario name="EDfecha" value="#LSDateFormat(form.EDfecha,'dd/mm/yyyy')#" tabindex="1" Function="obtenerTC(document.getElementById('form1'));">
		            <cfelse>
		                <cf_sifcalendario name="EDfecha" value="#LSDateFormat(rsFechaHoy.Fecha,'dd/mm/yyyy')#" tabindex="1" Function="obtenerTC(document.getElementById('form1'));">
					</cfif>
				</cfif>

            </td>
           <!---►►Tipo de Cambio◄◄--->
            <td><div align="right"><cfoutput>#LB_Tipo_de_Cambio#:&nbsp;</cfoutput></div></td>
            <td><input name="EDtipocambio" type="text" tabindex="1"

					onChange="javascript:validatcLOAD(this.form);"
					onkeyup="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}"
					onfocus="javascript:if(!document.form1.EDtipocambio.disabled) document.form1.EDtipocambio.select();"
					style="text-align:right"
					value="<cfif modo NEQ "ALTA"><cfoutput>#rsDocumento.EDtipocambio##LSCurrencyFormat('0','none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>" size="10" maxlength="10" />
            </td>
          </tr>
          <tr>
          <!---►►Fecha de vencimiento◄◄--->
          	<td><div align="right"><cfoutput>#LB_FecVenc#:&nbsp;</cfoutput></div></td>
            <td>
				<cfif modo NEQ 'ALTA' and LEN(TRIM(rsDocumento.EDvencimiento))>
                	<cf_sifcalendario name="EDvencimiento" value="#DateFormat(rsDocumento.EDvencimiento,'dd/mm/yyyy')#" tabindex="1">
                <cfelse>
                	<cf_sifcalendario name="EDvencimiento" value="" tabindex="1">
              </cfif>
            </td>
            <!---►►Oficina◄◄--->
            <td><div align="right"><cfoutput>#LB_Oficina#:&nbsp;</cfoutput></div></td>
            <td><select name="Ocodigo" tabindex="1">
                <cfoutput query="rsOficinas">
                  <option value="#rsOficinas.Ocodigo#"
							<cfif modo NEQ "ALTA" and rsOficinas.Ocodigo EQ rsDocumento.Ocodigo>selected
							<cfelseif modo EQ 'ALTA' and isdefined('form.Ocodigo') and rsOficinas.Ocodigo EQ form.Ocodigo>selected</cfif>> #rsOficinas.Odescripcion# </option>
                </cfoutput>
              </select>
            </td>
          </tr>
          <tr>
          <!---►►Pagos a Terceros◄◄--->
            <td  align="right"><cfoutput> #LB_PagTerc#:&nbsp; </cfoutput></td>
            <td >
                <cfif modo NEQ "ALTA">
                  <cf_cboTESRPTCid query="#rsDocumento#" tabindex="1" SNid="#rsNombreSocio.SNid#">
                  <cfelse>
                  <cfset form.TESRPTCid = "">
                  <cf_cboTESRPTCid tabindex="1" SNid="#LvarSNid#">
                </cfif>
            </td>
            <!---►►Retencion◄◄--->
			<td  nowrap="nowrap"  align="right"><cfoutput>#LB_RetPag#:&nbsp;</cfoutput></td>
            <td>
                <select name="Rcodigo" id="Rcodigo" tabindex="1" onchange="mostrar_retVar()">
                  <option value="-1" ><cfoutput>-- #LB_SinRet# --</cfoutput></option>
                  <cfoutput query="rsRetenciones">
                    <option value="#rsRetenciones.Rcodigo#|#rsRetenciones.isVariable#"
							<cfif modo NEQ "ALTA" and rsRetenciones.Rcodigo EQ rsDocumento.Rcodigo>selected
							<cfelseif modo NEQ 'ALTA' and isdefined('form.Rcodigo') and rsRetenciones.Rcodigo EQ form.Rcodigo>selected</cfif>> #rsRetenciones.Rdescripcion# </option>
                  </cfoutput>
                </select>
            </td>
          </tr>
          <tr>
          	<!---►►Direccion Facturacion◄◄--->
            <td align="right"   nowrap="nowrap" valign="top"><cfoutput>#LB_DirFact#:&nbsp;</cfoutput></td>
            <td valign="top"><select style="width:470px" tabindex="1" name="id_direccion" id="id_direccion" <cfif modo EQ "ALTA">
				onchange="javascript: sbid_direccionOnChange(this.value);"</cfif>>
                <cfoutput><option value="">- #LB_Ninguna# -</option></cfoutput>
                <cfoutput query="direcciones">
                  <option value="#id_direccion#"
						<cfif modo NEQ "ALTA" AND id_direccion eq rsDocumento.id_direccion>selected</cfif>
						<cfif isdefined('form.id_direccion') AND id_direccion eq form.id_direccion>selected</cfif>>#HTMLEditFormat(texto_direccion)#</option>
                </cfoutput>
              </select>
            </td>
            <!---Monto de retencion--->

            <td align="right">
				<label id="lblEDretencionVariable"
					style="display:<cfif modo NEQ "ALTA" and rsDocumento.retVariable gt 0 and rsDocumento.EDretencionVariable neq ''> <cfelse>none</cfif>">
					Monto retenci&oacute;n:&nbsp;
				</label>
			</td>
		  	<td align="left" valign="top">
				<input id="EDretencionVariable" name="EDretencionVariable"
					style="display:<cfif modo NEQ "ALTA" and rsDocumento.retVariable gt 0 and rsDocumento.EDretencionVariable neq ''> <cfelse>none</cfif>" tabindex="1" type="text" style="text-align:right"
					onfocus="javascript:document.form1.EDretencionVariable.select();" onchange="javascript:fm(this,2);"
					value="<cfif modo NEQ "ALTA" and rsDocumento.retVariable gt 0 and rsDocumento.EDretencionVariable neq ''><cfoutput>#LSCurrencyFormat(rsDocumento.EDretencionVariable,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>" size="15" maxlength="12"
				/>
				<cfif modo NEQ "ALTA">
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
							,0.00) + coalesce(e.EDretencionVariable,0) as Monto
					from EDocumentosCxP e
						left join Retenciones r
						 on r.Ecodigo = e.Ecodigo
						and r.Rcodigo = e.Rcodigo
					where e.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDdocumento#">
				</cfquery>
				<cfoutput>
					<label id="lblMonto">
				#numberFormat(rsRetencion.Monto,",9.99")#
					</label>
				</cfoutput>
				</cfif>
			</td>
            </tr>
             <!---Timbre Fiscal UUID--->
			<!--- <cfif modo NEQ "ALTA"> --->
                <cfquery name="validaCE" datasource="#session.dsn#">
                    select ERepositorio from Empresa where Ereferencia=#session.Ecodigo#
                </cfquery>
                <cfif isdefined('validaCE') and validaCE.ERepositorio EQ 1 and modo neq "alta">
                    <tr><cfif isdefined('Form.EDDocumento')><cfset Documento=Form.EDdocumento></cfif>
                      <td align="right"   nowrap="nowrap" valign="top"><cfoutput>#LB_TimbreFiscal#:&nbsp;</cfoutput></td>
                      <td >
						<cfif modo NEQ "ALTA">
							<cf_sifComprobanteFiscal Origen="CPFC" IDdocumento="#IDdocumento#" Documento="#Documento#" click="Cambiar" nombre="Timbre" form="form1">
						<cfelse>
								<cfif isdefined('LvarSNidentificacion')>
								  <cf_sifComprobanteFiscal Origen="CPFC" nombre="Timbre" modo="alta" form="form1" SNidentificacion="#LvarSNidentificacion#">
								<cfelse>
								  <cf_sifComprobanteFiscal Origen="CPFC" nombre="Timbre" form="form1" modo="alta">
								</cfif>
						</cfif>
						</td>
                    </tr>
                </cfif>
			<!--- </cfif> --->

             <!---►►Referencia◄◄--->
           	 <td valign="top" align="right"> <cfif form.tipo NEQ "C"><cfoutput> #LB_Refer#:&nbsp;</cfoutput></cfif>
             </td>
             <td valign="top" align="left">

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
                  <a href="#" tabindex="-1"> <img src="../../imagenes/Description.gif" alt="#LB_LstRefer#"
						name="refimagen" width="18" height="14" border="0" align="absmiddle" onclick="javascript:doConlisReferencias();" /> </a> <a href="#" tabindex="-1"> <img src="../../imagenes/delete.small.png" alt="Limpiar Referencia" name="imagenLimpiar" width="16" height="16"
						border="0" align="absmiddle" onclick="javascript:limpiarRef();" /> </a>
                </cfif>
            </td>
            <td colspan="2" rowspan="4" align="right"><table cellpadding="0" cellspacing="0" border="0" align="right">
                <tr>
                  <td width="127"><div align="right"><cfoutput>#LB_Subtotal#:&nbsp;</cfoutput></div></td>
                  <td align="right"><input name="subtotal" type="text" style="text-align:right" onchange="javascript: fm(this,2);"
						class="cajasinborde" readonly tabindex="-1"  size="15" maxlength="15"
						value="<cfif modo NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsDocumento.subtotal,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>" />
                  </td>
                </tr>
                <tr>
                  <td width="127"><div align="right"><cfoutput>#LB_Descuento#:&nbsp;</cfoutput></div></td>
                  <td align="right"><input name="EDdescuento" tabindex="1" type="text" style="text-align:right"
							onfocus="javascript:document.form1.EDdescuento.select();" onchange="javascript:fm(this,2);"
							value="<cfif modo NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsDocumento.EDdescuento,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>" size="15" maxlength="12" />
                  </td>
                </tr>

                <tr>
                  <td width="127"><div align="right"><cfoutput>#LB_IEPS#:&nbsp;</cfoutput></div></td>
                  <td align="right"><input name="EDTiEPS" tabindex="1" type="text" style="text-align:right"
							onfocus="javascript:document.form1.EDTiEPS.select();" onchange="javascript:fm(this,2);"
							value="<cfif modo NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsDocumento.EDTiEPS,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>" size="15" maxlength="12" />
                  </td>
                </tr>

                <tr>
                  <td><div align="right"><cfoutput>#LB_Impuesto#:&nbsp;</cfoutput></div></td>
                  <td align="right"><input name="EDimpuesto" type="text" onblur="javascript: fm(this,2);" tabindex="1" style="text-align:right"
						onfocus="javascript:this.select();" onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
						value="<cfif modo NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsDocumento.EDimpuesto,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>" size="15" maxlength="12" />
                  </td>
                </tr>
                <tr>
                  <td><div align="right"><cfoutput>#LB_Total#:&nbsp;</cfoutput></div></td>
                  <td align="right"><input name="EDtotal" type="text" style="text-align:right" onchange="javascript: fm(this,2);"
						class="cajasinborde" readonly tabindex="-1"  size="15" maxlength="15"
						value="<cfif modo NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsDocumento.EDtotal,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>" />
                  </td>
                </tr>
            </table></td>
          </tr>
          <tr>
            <td>
                <input type="hidden" name="tipo" value="<cfoutput>#form.tipo#</cfoutput>" />
				<cfif modo NEQ "ALTA">
				    <input type="hidden" name="indice" value="<cfoutput>#Form.IDdocumento#</cfoutput>" />
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
                <input type="hidden" name="timestampE" 		value="<cfif modo NEQ "ALTA"><cfoutput>#tsE#</cfoutput></cfif>" />
                <input type="hidden" name="_EDvencimiento" 	value="" />
                <input type="hidden" name="_EDfecha" 		value="" />
                <input type="hidden" name="_EDfechaarribo" 	value="" />
                <input type="hidden" name="_Mcodigo" 		value="" />
                <input type="hidden" name="_EDtipocambio" 	value="" />
                <input type="hidden" name="_Ocodigo" 		value="" />
                <input type="hidden" name="_Rcodigo" 		value="" />
				<input type="hidden" name="_EDretencionVariable" 		value="" />
                <input type="hidden" name="_EDdescuento" 	value="" />
                <input type="hidden" name="_EDdocumento" 	value="" />
                <input type="hidden" name="_Ccuenta" 		value="" />
                <input type="hidden" name="_EDimpuesto" 	value="" />
                <input type="hidden" name="_EDtotal" 		value="" />
                <input type="hidden" name="_EDdocref"		value="" />
                <input type="hidden" name="_TESRPTCid" 		value="" />
                <input type="hidden" name="_id_direccion" 	value="" />
            </td>
          </tr>
          <tr>
            <td colspan="6"><div align="center"></div>
                <cfif modo EQ "ALTA">
                <cfoutput>
                  <div align="center">
                    <input name="AgregarE" class="btnGuardar"  tabindex="1" type="submit" value="#BTN_Agregar#"
						onclick="javascript: var estado = document.form1.EDtipocambio.disabled; document.form1.EDtipocambio.disabled = false; if (validaE()) return true; else {document.form1.EDtipocambio.disabled = estado; return false;}" />
                    <input type="button"   class="btnAnterior" tabindex="1" name="Regresar" value="#BTN_Regresar#" onclick="javascript:Lista();" />
                  </div>
                </cfoutput>
                </cfif>
            </td>
          </tr>
          <cfif isdefined('rsDocumento.EDexterno') and rsDocumento.EDexterno>
			<cfset MSG_DocExt	= t.Translate('MSG_DocExt','El documentos provienen de un sistema o módulo externo, por lo que no puede ser modificado o eliminado.')>
          	  <tr>
              	 <td colspan="6"><font color="##FF0000"><cfoutput>#MSG_DocExt#</cfoutput></font></td>
          	  </tr>
          </cfif>
        </table>
		<cfif modo NEQ "ALTA">
			<input name="SNnumero" type="hidden" value="<cfif isdefined("form.SNnumero") and len(trim(form.SNnumero))><cfoutput>#form.SNnumero#</cfoutput></cfif>">
		<table style="width:100%" border="0" cellpadding="1" cellspacing="0">
          <tr>
            <td style="width:100%" colspan="9" class="tituloAlterno"><div align="center"><cfoutput>#LB_DetDocto#</cfoutput></div></td>
          </tr>

		  <!---Variables para hacer visibles o no los campos cuando esta definido el plan de compras--->
		  <cfif rsUsaPlanCuentas.Pvalor eq LvarParametroPlanCom>
		  		<cfset LvarPlanDeCompras=true>
				<cfset LvarPlanDeCompras2="yes">
		  <cfelse>
		  		<cfset LvarPlanDeCompras=false>
				<cfset LvarPlanDeCompras2="no">
		  </cfif>

          <cfif modoDet neq 'ALTA'>
              <input type="hidden" name="rsModDet" value="#rsModDet.Pvalor#"/>
              <input type="hidden" name="ModTipo" value="#rsLinea.DDtipo#"/>
              <input type="hidden" name="ModCuenta" value="#rsLinea.CFcuenta#"/>
          </cfif>

      <cfif rsTieneRemision.totalRemisiones EQ 0>
		  <tr>
            <td align="right">Item:&nbsp;</td>
			<td style="width:100%" colspan="8" >
            <cfoutput>
				<select id="DDtipo" name="DDtipo" <cfif LvarPlanDeCompras AND modoDet NEQ 'ALTA'> disabled="disabled"</cfif> onChange="javascript:limpiarDetalle();cambiarDetalle();habilitaCheck();habilitaPlantilla();"
					<cfif modoDet neq 'ALTA' and rsModDet.Pvalor eq 0>disabled</cfif> tabindex="1">
					<cfif rscArticulos.cant GT 0 >
					  <option value="A" <cfif modoDet NEQ "ALTA" and rsLinea.DDtipo EQ "A">selected</cfif>>#Lbl_ArtInv#</option>
					</cfif>
					<cfif rscConceptos.cant GT 0>
					  <option value="S" <cfif modoDet NEQ "ALTA" and rsLinea.DDtipo EQ "S">selected</cfif>>#Lbl_ConSer#</option>
					</cfif>
						<option value="T" <cfif modoDet NEQ "ALTA" and rsLinea.DDtipo EQ "T">selected</cfif>>#Lbl_ProdTr#</option>
						<option value="F" <cfif modoDet NEQ "ALTA" and rsLinea.DDtipo EQ "F">selected</cfif>>#Lbl_ActFjo#</option>
<!---					    <option value="P" <cfif modoDet NEQ "ALTA" and rsLinea.DDtipo EQ "P">selected</cfif>>P-Obras de Construccion</option>
--->
						<option value="O" <cfif modoDet NEQ "ALTA" and rsLinea.DDtipo EQ "O">selected</cfif>>#Lbl_OrdCm#</option>
			  </select>
            </cfoutput>
			</td>
          </tr>
		  <tr id="trv">
			<td  align="left" colspan="9" >
				<fieldset>
				<table  align="left" border="0">
					<tr id="trv3" style="display:none">
			        	<td align="right"><cfoutput>#Lbl_DescImpVar#:&nbsp;</cfoutput></td>
						<td ><input type="text" tabindex="1" size="40" maxlength="255" name="ImpVarDescripcion" value=""></td>
			        </tr>
			        <tr id="trv4" style="display:none">
			        	<td align="right"><cfoutput>#Lbl_DescImpVarAlt#:&nbsp;</cfoutput></td>
						<td ><input type="text" tabindex="1" size="40" maxlength="255" name="ImpVarAltDescripcion" value=""></td>
			        </tr>

					<tr>
						<!--- ORDEN COMERCIAL --->
						<td align="right"  id="OrdenLabel"  >
							<cfoutput>#Lbl_OrdCom#:</cfoutput>
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
							Title="#Lbl_OrdCmCmpr#"
							Tabla="OCordenComercial oc inner join SNegocios sn on sn.SNid = oc.SNid"
							Columnas="oc.OCid,oc.OCcontrato,oc.OCfecha, sn.SNnombre, sn.SNid as OC_SNid"
							Filtro=" oc.Ecodigo = #Session.Ecodigo# and oc.OCestado = 'A' and oc.OCtipoOD = 'O' and oc.OCtipoIC = 'C'  order by oc.OCfecha"
							Desplegar="OCcontrato,OCfecha,SNnombre"
							Etiquetas="#Lbl_Contr#,#LB_Fecha#,#Lbl_SocCom#"
							filtrar_por="OCcontrato,Fecha,SNnombre"
							Formatos="S,D,S"
							Align="left,left,left"
							Asignar="OCid,OCcontrato,OC_SNid"
							Asignarformatos="S,S"/>

					  </td>

						<!--- TRANSPORTE --->
						<td align="right" id="TransporteLabel">
							 <cfoutput>#Lbl_Trans#:&nbsp;</cfoutput>
						</td>
						<td  nowrap="nowrap" id="TransporteImput">
                        	<cfoutput>
							<select id="OCTtipo" name="OCTtipo" >
								<option value="">#Lbl_TpoTrsp#</option>
								<option value="B" <cfif modoDet NEQ "ALTA" and isdefined("rsLinea.OCTtipo") and rsLinea.OCTtipo EQ "B">selected</cfif>>#Lbl_Barco#</option>
								<option value="A" <cfif modoDet NEQ "ALTA" and isdefined("rsLinea.OCTtipo") and rsLinea.OCTtipo EQ "A">selected</cfif>>#Lbl_Aereo#</option>
								<option value="T" <cfif modoDet NEQ "ALTA" and isdefined("rsLinea.OCTtipo") and rsLinea.OCTtipo EQ "T">selected</cfif>>#Lbl_Terrest#</option>
								<option value="F" <cfif modoDet NEQ "ALTA" and isdefined("rsLinea.OCTtipo") and rsLinea.OCTtipo EQ "F">selected</cfif>>#Lbl_Ferro#</option>
								<option value="O" <cfif modoDet NEQ "ALTA" and isdefined("rsLinea.OCTtipo") and rsLinea.OCTtipo EQ "O">selected</cfif>>#Lbl_Otro#</option>
							</select>
                            </cfoutput>
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
								title="#Lbl_Trans#"
								onblur  = "javascript: validaTransporte();">
							<a href="javascript:doConlisTransporte();" id="imgCcuenta">
								<img src="/cfmx/sif/imagenes/Description.gif"
								alt="#Lbl_LstTrans#"
								name="imagentransporte"
								width="18" height="14"
								border="0" align="absmiddle">
							</a>
						   	</cfoutput>
							<input type="hidden" name="OCTid" tabindex="-1" value="<cfif modoDet NEQ "ALTA" and isdefined("rsOCtransporte") ><cfoutput>#rsOCtransporte.OCTid#</cfoutput></cfif>" />
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
									where Ecodigo = #Session.Ecodigo#
									and Cid =
									<cfif rsLinea.DDtipo eq 'S' and isdefined('rsLinea.Cid') and LEN(TRIM(rsLinea.Cid))>
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLinea.Cid#">
									<cfelse>
										0
									</cfif>
									order by Ccodigo
								</cfquery>
       							<cfif LvarItemReadonly>
									<cfoutput>
                                        #trim(rsConcepto.Ccodigo)# - #trim(rsConcepto.Cdescripcion)#
                                <input type="hidden" name="Cid" 			value="#rsConcepto.Cid#">
                                        <input type="hidden" name="Ccodigo" 		value="#rsConcepto.Ccodigo#">
                                        <input type="hidden" name="Cdescripcion" 	value="#rsConcepto.Cdescripcion#">
                                    </cfoutput>
                            	<cfelse>
									<cf_sifconceptos query=#rsConcepto# size="22" verclasificacion=#verClasCP# readonly="#LvarPlanDeCompras#" tabindex="1">
                                </cfif>
							<cfelse>
								<cf_sifconceptos size="22" verclasificacion=#verClasCP# tabindex="1">
							</cfif>
					  </td>
						<!--- ALMACEN --->
						<td align="right"  id="AlmacenLabel">
							<cfoutput>#Lbl_Almac#:&nbsp;</cfoutput>
						</td>
						<td id="AlmacenImput">
							<cfif modoDet neq 'ALTA'>
       							<cfif LvarItemReadonly and len(trim(#rsLinea.Alm_Aid#))>
                                    <cfquery name="rsAlmacen" datasource="#session.DSN#">
                                        select Aid, Almcodigo, Bdescripcion
                                        from Almacen
                                        where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
                                        and Aid=#rsLinea.Alm_Aid#
                                        order by Almcodigo
                                    </cfquery>
									<cfoutput>
                                        #trim(rsAlmacen.Almcodigo)# - #trim(rsAlmacen.Bdescripcion)#
                                <input type="hidden" name="Almacen" 		value="#rsAlmacen.Aid#">
                                        <input type="hidden" name="Almcodigo" 		value="#rsAlmacen.Almcodigo#">
                                        <input type="hidden" name="Bdescripcion" 	value="#rsAlmacen.Bdescripcion#">
                                    </cfoutput>
                            	<cfelse>
									<cf_sifalmacen id="#rsLinea.Alm_Aid#"  size="14" aid="Almacen" tabindex="1" readOnly="#LvarPlanDeCompras2#" >
                                </cfif>
							<cfelse>
								<cf_sifalmacen size="15" aid="Almacen" tabindex="1" readOnly="#LvarPlanDeCompras2#">
					 	  </cfif>
					  </td>
						<!--- ARTICULO
						<td align="right"  id="labelarticulo">
							<cfoutput>#Lbl_Art#:&nbsp;</cfoutput>
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
       							<cfif LvarItemReadonly and isdefined("rsArticulo")>
									<cfoutput>
                                        #trim(rsArticulo.Acodigo)# - #trim(rsArticulo.Adescripcion)#
                                <input type="hidden" name="Aid" 			value="#rsArticulo.Aid#">
                                        <input type="hidden" name="Acodigo" 		value="#rsArticulo.Acodigo#">
                                        <input type="hidden" name="Adescripcion" 	value="#rsArticulo.Adescripcion#">
                                    </cfoutput>
                            	<cfelse>
									<cf_sifarticulos query=#rsArticulo# almacen="Almacen" size="15" tabindex="1" readOnly="#LvarPlanDeCompras2#">
                                </cfif>
							<cfelse>
								<cf_sifarticulos almacen="Almacen" size="15" tabindex="1" readOnly="#LvarPlanDeCompras2#">
							</cfif>
					    </td>--->
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
       							<cfif LvarItemReadonly and modoDet neq 'ALTA' and rsLinea.DDtipo neq 'P'>
									<cfoutput>
                                        #trim(rsArticulo.AcodigoT)# - #trim(rsArticulo.AdescripcionT)#
                                <input type="hidden" name="AidT" 			value="#rsArticulo.AidT#">
                                        <input type="hidden" name="AcodigoT" 		value="#rsArticulo.AcodigoT#">
                                        <input type="hidden" name="AdescripcionT" 	value="#rsArticulo.AdescripcionT#">
                                    </cfoutput>
                            	<cfelse>
									<cf_sifarticulos query=#rsArticulo#
										id = "AidT" name ="AcodigoT" desc="AdescripcionT"
										almacen="Almacen" size="15" tabindex="1" IACcampo ="IACtransito">
                                </cfif>
							<cfelse>
								<cf_sifarticulos
								id = "AidT" name ="AcodigoT" desc="AdescripcionT"
								almacen="Almacen" size="15" tabindex="1" IACcampo ="IACtransito">
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

							<cfif LvarItemReadonly and isdefined("rsArticuloOD")>
								<cfoutput>
                                #trim(rsArticuloOD.AcodigoOD)# - #trim(rsArticuloOD.AdescripcionOD)#
                                <input type="hidden" name="AidOD" 			value="#rsArticuloOD.AidOD#">
                                <input type="hidden" name="AcodigoOD" 		value="#rsArticuloOD.AcodigoOD#">
                                <input type="hidden" name="AdescripcionOD" 	value="#rsArticuloOD.AdescripcionOD#">
                                </cfoutput>
                            <cfelse>
                                <cf_conlis
                                Campos="AidOD,AcodigoOD,AdescripcionOD"
                                Desplegables="N,S,S"
                                ValuesArray="#ArrayAid#"
                                Modificables="N,S,N"
                                Size="0,15,20"
                                tabindex="1"
                                Title="#Lbl_ArtOrdC#"
                                Tabla=" OCordenProducto a
                                        inner join Articulos  b
                                            on a.Aid = b.Aid
                                            and a.Ecodigo = b.Ecodigo"
                                Columnas="a.Aid as AidOD,b.Acodigo as  AcodigoOD,b.Acodalterno as AcodalternoOD,b.Adescripcion as AdescripcionOD"
                                Filtro=" a.Ecodigo = #Session.Ecodigo# and a.OCid = $OCid,numeric$ "
                                Desplegar="AcodigoOD,AcodalternoOD,AdescripcionOD"
                                Etiquetas="#LBR_CODIGO#,#Lbl_CodAlt#,#MSG_Descripcion#"
                                filtrar_por="b.Acodigo,b.Acodalterno,b.Adescripcion"
                                Formatos="S,S,S"
                                Align="left,left,left"
                                Asignar="AidOD,AcodigoOD,AdescripcionOD"
                                funcion="fnOCobtieneCFcuenta()"
                                Asignarformatos="S,S,S"/>
							</cfif>
					    </td>
					    <cfif modoDet NEQ "ALTA" >
                        	<cfset checked  = "<img border=0 src=/cfmx/sif/imagenes/checked.gif>" >
	                        <tr>
	                        	<td  align="right" id="EspecificaCFLabel">
	                            	<cfoutput>Especificar Otro CF:&nbsp;</cfoutput>
		                        </td>
	    	                    <td id="EspecificaCF">
		                             <cfif rsLinea.CambioCF NEQ 1>
		            	                    <input type="checkbox" name="chkEspecificarCF" id="chkEspecificarCF" onclick="EspeciCF();"
						  					<cfif isdefined("form.chkEspecificarCF") or rsLinea.CambioCF EQ 1> checked="checked" </cfif>>
		            				 <cfelse>
		                            		<cfoutput>#checked#</cfoutput>
		                            </cfif>
								</td>
	                	    </tr>
                        </cfif>
						<!--- Centro funcional --->
						<tr>
						<td  align="right" id="CFLabel">
							<cfoutput>#LB_CentroFuncional#:&nbsp;</cfoutput>
						</td>
                       <!---<cfif not isdefined("form.chkEspecificarCF") >--->
						<td id="centrofuncional">
							<cfif modoDet neq 'ALTA'>

								<cfif LvarItemReadonly or (not isdefined("form.chkEspecificarCF") or form.chkEspecificarCF EQ 0)
								and (rsLinea.CambioCF EQ 1 or rsLinea.CambioCF EQ 0)>
									<cfoutput>
									#trim(rsCF.CFcodigo)# - #trim(rsCF.CFdescripcion)#
									<input type="hidden" name="CFid" 		value="#rsCF.CFid#">
									<input type="hidden" name="CFcodigo" 	value="#rsCF.CFcodigo#">
									<input type="hidden" name="imagenCxP" 	id="imagenCxP" value="">
									</cfoutput>
								<cfelse>
									<cf_rhcfuncionalCxP Ccuenta="CcuentaD" form="form1" size="23" id="CFid" name="CFcodigo" desc="CFdescripcion" query="#rsCF#" tabindex="1" readOnly="#LvarPlanDeCompras2#">
								</cfif>
							<cfelse>
								<cf_rhcfuncionalCxP Ccuenta="CcuentaD" form="form1" size="23" id="CFid" name="CFcodigo" desc="CFdescripcion" tabindex="1">
							</cfif>
					  	</td>


<!---JMRV. Inicio del Cambio. 30/04/2014--->

	<!---Obtiene la lista de distribuciones disponibles--->
	<cfquery name="rsDistribuciones" datasource="#session.DSN#">
		select CPDCid, <cf_dbfunction name="concat" args="rtrim(CPDCcodigo),' - ',CPDCdescripcion"> as Descripcion
	  	from CPDistribucionCostos
		where Ecodigo=#session.Ecodigo#
	   	and CPDCactivo=1
	   	and Validada = 1
	</cfquery>

	<!---Obtiene la distribucion aplicada en la linea de la solicitud de compra--->
	<cfif isdefined("rsLinea.IDdocumento") and isdefined("rsLinea.Linea")>
		<cfquery name="rsDistribucionElegida" datasource="#session.DSN#">
			select CPDCid
	  		from DDocumentosCxP
			where Ecodigo =  #session.Ecodigo#
		 	and IDdocumento = <cfqueryparam value="#rsLinea.IDdocumento#" cfsqltype="cf_sql_numeric">
		  	and Linea = <cfqueryparam value="#rsLinea.Linea#" cfsqltype="cf_sql_numeric">
		</cfquery>
	</cfif>

	<!---Obtiene la descripcion de la distribucion aplicada en la orden de compra--->
	<cfif isdefined("rsDistribucionElegida.CPDCid") and len(trim(rsDistribucionElegida.CPDCid))>
		<cfquery name="rsDescripcionDistribucionElegida" datasource="#session.DSN#">
			select <cf_dbfunction name="concat" args="rtrim(CPDCcodigo),' - ',CPDCdescripcion"> as Descripcion
	  		from CPDistribucionCostos
			where CPDCid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDistribucionElegida.CPDCid#">
		</cfquery>
	</cfif>

	<!---Sirve para saber si viene de una solicitud de compra--->
	<cfif isdefined("rsLinea.IDdocumento") and isdefined("rsLinea.Linea")>
		<cfquery name="valLinea" datasource="#session.DSN#">
			select isnull(DOlinea, CTDContid) as DOlinea
	  		from DDocumentosCxP
			where Ecodigo =  #session.Ecodigo#
		 	and IDdocumento = <cfqueryparam value="#rsLinea.IDdocumento#" cfsqltype="cf_sql_numeric">
		  	and Linea = <cfqueryparam value="#rsLinea.Linea#" cfsqltype="cf_sql_numeric">
		</cfquery>
	</cfif>

	</tr>
	<tr>
	<td align="right" nowrap id="EtiquetaDistribucion"
		<cfif modoDet EQ "CAMBIO"><cfif (rsLinea.DDtipo EQ "A" or rsLinea.DDtipo EQ "S")>style="display:"<cfelse>style="display:none"</cfif></cfif>>
		<cfoutput>Distribucion del monto:</cfoutput></td>
	<td><cfoutput><input type="checkbox" name="CheckDistribucion" id="CheckDistribucion" onclick="javascript:habilitaPlantilla();cambioDeEstado();"
			<cfif modoDet EQ "CAMBIO" and isdefined("rsDistribucionElegida.CPDCid") and rsDistribucionElegida.CPDCid NEQ 0>checked<cfelse>unchecked</cfif>
			<cfif isdefined("valLinea.DOlinea") and valLinea.DOlinea gt 0>disabled<cfelse>enabled</cfif>
			<cfif modoDet EQ "CAMBIO"><cfif (rsLinea.DDtipo EQ "A" or rsLinea.DDtipo EQ "S")>style="display:"<cfelse>style="display:none"</cfif></cfif>></cfoutput></td>
	<input type="hidden" id="CheckDistribucionHidden" name="CheckDistribucionHidden"
			<cfif modoDet EQ "CAMBIO" and isdefined("rsDistribucionElegida.CPDCid") and rsDistribucionElegida.CPDCid NEQ 0>value="1"<cfelse>value="0"</cfif>>

	</tr>
	<tr>
	<td align="right" nowrap id="EtiquetaPlantilla"
		<cfif (modoDet EQ "CAMBIO" and isdefined("rsDistribucionElegida.CPDCid") and rsDistribucionElegida.CPDCid NEQ 0 and rsDistribucionElegida.CPDCid NEQ "")>style="display:"<cfelse>style="display:none"</cfif>>
		<cfoutput>Distribucion:</cfoutput></td>
	<td>
	<cfoutput><select name="PlantillaDistribucion" id="PlantillaDistribucion"
			<cfif (modoDet EQ "CAMBIO" and isdefined("rsDistribucionElegida.CPDCid") and rsDistribucionElegida.CPDCid NEQ 0 and rsDistribucionElegida.CPDCid NEQ "")>style="display:"<cfelse>style="display:none"</cfif>
			<!--- <cfif isdefined("valLinea.DOlinea") and valLinea.DOlinea gt 0>disabled<cfelse>enabled</cfif> --->>

		<cfif modoDet NEQ 'CAMBIO'>
			<option value="-1" selected>Elija una opcion...</option>
		<cfelseif modoDet EQ 'CAMBIO' and isdefined("rsDistribucionElegida.CPDCid") and rsDistribucionElegida.CPDCid EQ 0>
			<option value="-1" selected>Elija una opcion...</option>
		</cfif>

		<cfloop query="rsDistribuciones">
			<cfif (modoDet EQ 'CAMBIO' and rsDistribucionElegida.CPDCid NEQ 0)>
			<option value="#rsDistribuciones.CPDCid#" <cfif rsDistribuciones.CPDCid eq rsDistribucionElegida.CPDCid>selected</cfif>>#rsDistribuciones.Descripcion#</option>
			<cfelse>
			<option value="#rsDistribuciones.CPDCid#" >#rsDistribuciones.Descripcion#</option>
			</cfif>
		</cfloop>
	</select></cfoutput>
	</td>
	</tr>

	<SCRIPT LANGUAGE="JavaScript">
		function traeValor(elemento){
			var posicion=document.getElementById(elemento).options.selectedIndex; //posicion
			var valor=document.getElementById(elemento).options[posicion].text; //valor
			return valor;
			}
		function cambioDeEstado(){
			if(document.getElementById('CheckDistribucion').checked){
				if(document.getElementById('CheckDistribucionHidden').value == 1){
				document.getElementById('CheckDistribucionHidden').value = 0;}
				else{document.getElementById('CheckDistribucionHidden').value = 1;}}
			else{
				if(document.getElementById('CheckDistribucionHidden').value == 1){
				document.getElementById('CheckDistribucionHidden').value = 0;}
				else{document.getElementById('CheckDistribucionHidden').value = 1;}}
			}
		function habilitaCheck(){
			var valor = traeValor('DDtipo');
			if(valor == "A-Artículo de Inventario" || valor == "S-Concepto Servicio o Gasto"){
				document.getElementById('CheckDistribucion').style.display = "";
				document.getElementById('EtiquetaDistribucion').style.display = "";}
			else{
				document.getElementById('CheckDistribucion').style.display = "none";
				document.getElementById('EtiquetaDistribucion').style.display = "none";}
			}
		function habilitaPlantilla(){
			var valor = traeValor('DDtipo');
			var checkActivo = (document.getElementById('CheckDistribucion').checked);
			if((valor == "A-Artículo de Inventario" || valor == "S-Concepto Servicio o Gasto") && checkActivo){
				document.getElementById('EtiquetaPlantilla').style.display = "";
				document.getElementById('PlantillaDistribucion').style.display = "";}
			else{
				document.getElementById('EtiquetaPlantilla').style.display = "none";
				document.getElementById('PlantillaDistribucion').style.display = "none";}
			}
	</SCRIPT>
<!---JMRV. Fin del Cambio. 30/04/2014 --->

						<tr>
						<!--- ARTICULO --->
                        <cfoutput>
						<td align="right"  id="labelarticulo">
							#Lbl_Art#:&nbsp;
						</td>
                        </cfoutput>
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
       							<cfif LvarItemReadonly and isdefined("rsArticulo")>
									<cfoutput>
                                        #trim(rsArticulo.Acodigo)# - #trim(rsArticulo.Adescripcion)#
                                		<input type="hidden" name="Aid" 			value="#rsArticulo.Aid#">
                                        <input type="hidden" name="Acodigo" 		value="#rsArticulo.Acodigo#">
                                        <input type="hidden" name="Adescripcion" 	value="#rsArticulo.Adescripcion#">
                                    </cfoutput>
                            	<cfelse>
									<cf_sifarticulos query=#rsArticulo# almacen="Almacen" size="15" tabindex="1" readOnly="#LvarPlanDeCompras2#">
                                </cfif>
							<cfelse>
								<cf_sifarticulos almacen="Almacen" size="15" tabindex="1" readOnly="#LvarPlanDeCompras2#">
							</cfif>
					    </td>
                     	<!--- Especifica cuenta--->
						<cfif NOT LvarIndicarCuentaManual OR LvarItemReadonly>
                        <td  align="right" id="EspecificaCuentaLabel">&nbsp;

                        </td>
                        <td id="EspecificaCuenta">
                              <input type="hidden" name="chkEspecificarcuenta" id="chkEspecificarcuenta" >
                        </td>
						<cfelse>
                        <td  align="right" id="EspecificaCuentaLabel">
                            <cfoutput>#Lbl_EspCta#:&nbsp;</cfoutput>
                        </td>
                        <td id="EspecificaCuenta">
                              <input type="checkbox" name="chkEspecificarcuenta" id="chkEspecificarcuenta" onclick="EspeciCuenta();" tabindex="1"
                               <cfif modoDet neq 'ALTA' and rsLinea.DSespecificacuenta eq 1> checked="checked" </cfif> >
						</td>
						</cfif>
					</tr>
					<tr id="trv2">
						<td  nowrap="nowrap" align="right"><cfoutput>#Lbl_FecEmb#:&nbsp;</cfoutput></td>
						<td>
							<cfif modoDet NEQ 'ALTA'>
								<cf_sifcalendario name="OCTfechaPartida" value="#LSDateFormat(rsLinea.OCTfechaPartida,'dd/mm/yyyy')#" tabindex="1">
							<cfelse>
								<cf_sifcalendario name="OCTfechaPartida" value="#LSDateFormat(rsFechaHoy.Fecha,'dd/mm/yyyy')#" tabindex="1">
							</cfif>
						</td>
						<td align="right"><cfoutput>#Lbl_Obs#:&nbsp;</cfoutput></td>
						<td >
							<input type="text" tabindex="1" size="40" maxlength="255" name="OCTobservaciones"
							value="<cfif modoDet neq 'ALTA'><cfoutput>#rsLinea.OCTobservaciones#</cfoutput></cfif>">
						</td>

						<td align="right"  id="labelConceptoT"><cfoutput>#Lbl_ConsCpr#:&nbsp;</cfoutput></td>
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
				<!---Cuenta--->
					<tr id="TRCUENTADET">
						<cfif LvarComplementoXorigen>
						  <td>
							  &nbsp;
							  <input name="CcuentaD" 			type="hidden" value="-1" />
							  <input name="Ecodigo_CcuentaD" 	type="hidden" value="-1" />
							  <input name="CdescripcionD" 		type="hidden" value="-1" />
						  </td>
						<cfelse>
							<td align="right"><cfoutput>#LB_Cuenta#:&nbsp;</cfoutput></td>
							<td colspan="9">
								<script language="javascript" type="text/javascript">
									function LimpiarCF(){
										document.form1.CFid.value   = "";
										document.form1.CFcodigo.value = "";
										document.form1.CFdescripcion.value = "";
									}
								</script>
								<cfif modoDet NEQ "ALTA">
									<cf_cuentas onchangeIntercompany="LimpiarCF()" Intercompany="yes" conexion="#Session.DSN#" conlis="S" query="#rsLinea#" auxiliares="N" movimiento="S"
											ccuenta="CcuentaD" cfcuenta="CFcuentaD" cdescripcion="CdescripcionD"  cmayor="CmayorD"  cformato="CformatoD" readOnly="false"
											tabindex="1" igualTabFormato="S"
											descwidth="60">
								<cfelse>
									<cf_cuentas onchangeIntercompany="LimpiarCF()" Intercompany="yes" conexion="#Session.DSN#" conlis="S" auxiliares="N" movimiento="S"
											ccuenta="CcuentaD" cfcuenta="CFcuentaD" cdescripcion="CdescripcionD"  cmayor="CmayorD" cformato="CformatoD" readOnly="false"
											tabindex="1" igualTabFormato="S"
											descwidth="60">
								</cfif>
							</td>
						</cfif>
					</tr>
				</table>
				</fieldset>
			</td>
		  </tr>

          <tr>
            <td  align="right"><cfoutput>#MSG_Descripcion#:&nbsp;</cfoutput></td>
            <td colspan="3">
              <input name="DDdescripcion" tabindex="1" onFocus="javascript:this.select();" type="text" <cfif LvarPlanDeCompras AND modoDet NEQ 'ALTA'> disabled="disabled"</cfif>
					value="<cfif modoDet NEQ "ALTA"><cfoutput>#HTMLeditFormat(rsLinea.DDdescripcion)#</cfoutput></cfif>" size="60" maxlength="255">
            </td>
		</tr>
		<tr>
			<td align="right" nowrap="nowrap"><cfoutput>#Lbl_DescAlt#:&nbsp;</cfoutput></td>
            <td colspan="4">
              <input name="DDdescalterna" tabindex="1" onFocus="javascript:this.select();" type="text" <cfif LvarPlanDeCompras AND modoDet NEQ 'ALTA'> disabled="disabled"</cfif>
					value="<cfif modoDet NEQ "ALTA"><cfoutput>#rsLinea.DDdescalterna#</cfoutput></cfif>" size="60" maxlength="255">
            </td>
		</tr>
		<!---►►Actividad Empresarial (N-No se usa AE, S-Se usa Actividad Empresarial)◄◄--->
        <cfquery name="rsActividad" datasource="#session.DSN#">
          Select Coalesce(Pvalor,'0') as Pvalor
           from Parametros
           where Pcodigo = 2200
             and Mcodigo = 'CG'
             and Ecodigo = #session.Ecodigo#
        </cfquery>
		<tr>
			<td  align="right" valign="top"><cfoutput>#LB_Impuesto#:&nbsp;</cfoutput></td>
			<td colspan="3" valign="top">
				<select name="Icodigo" tabindex="1" <cfif LvarPlanDeCompras AND modoDet NEQ 'ALTA' > disabled="disabled"</cfif>>
				<cfoutput query="rsImpuestos">
				<option value="#rsImpuestos.Icodigo#"
					<cfif modoDet NEQ 'ALTA' and rsImpuestos.Icodigo EQ rsLinea.Icodigo>selected</cfif>> #rsImpuestos.Icodigo# - #rsImpuestos.Idescripcion# </option>
				</cfoutput>
				</select>
			</td>

			<td  align="right" valign="top"><cfoutput>#LB_IEPS#:&nbsp;</cfoutput></td>
			<td colspan="3" valign="top">
				<select name="codIEPS" tabindex="1" onchange="calculaieps();" <cfif LvarPlanDeCompras AND modoDet NEQ 'ALTA' > disabled="disabled"</cfif>>
				<cfoutput query="rsImpuestosIeps">

				<option value="#rsImpuestosIeps.Icodigo#"
					<cfif modoDet NEQ 'ALTA' and rsImpuestosIeps.Icodigo EQ rsLinea.codIEPS>selected</cfif>>
					#rsImpuestosIeps.Icodigo# - #rsImpuestosIeps.Idescripcion# </option>
				</cfoutput>
				</select>
			</td>
            <td colspan="4"  valign="top" align="right" <cfif rsActividad.Pvalor eq 'S'>rowspan="2"</cfif>>
					<table border="0" align="right">
						<tr>
							<td><div align="right"><cfoutput>#Lbl_cantidad#:&nbsp;</cfoutput></div></td>
							<td align="right">
							  <input name="DDcantidad" onFocus="javascript:this.value = qf(this.value); this.select();" type="text" tabindex="1"
									style="text-align:right" onBlur="javascript:fm(this,2);suma();" size="12" maxlength="12"
									value="<cfif modoDet NEQ "ALTA"><cfoutput>#LSCurrencyFormat(rsLinea.DDcantidad,'none')#</cfoutput><cfelse><cfoutput>0.00</cfoutput></cfif>"
								>
							</td>
						</tr>
						<tr>
							<td >
							  <div align="right"><cfoutput>#Lbl_PrecioU#:&nbsp;</cfoutput></div></td>
							<td align="right">
								<cfoutput>
								<cfparam name="rsLinea.DDpreciou" default="0">
								<!---#LvarOBJ_PrecioU.inputNumber("CAMPO", VALOR, "tabIndex", readOnly, "class", "style", "onBlur();", "onChange();")#--->
								<cfif modoDet NEQ "ALTA" and LvarXCantidad eq 0 >
								   #LvarOBJ_PrecioU.inputNumber("DDpreciou", rsLinea.DDpreciou, "1", false, "", "", "suma();")#
								<cfelseif modoDet neq 'ALTA' and  len(trim(rsLinea.PCGDid)) neq 0 and  (len(trim(rsLinea.DOlinea)) eq 0 or len(trim(rsLinea.DOlinea)) EQ "") and (rsLinea.DDtipo eq 'F' or rsLinea.DDtipo eq 'A')>
								   #LvarOBJ_PrecioU.inputNumber("DDpreciou", rsLinea.DDpreciou, "1", false, "", "", "suma();")#
								<cfelseif modoDet EQ "ALTA" and LvarXCantidad eq 0 >
								  #LvarOBJ_PrecioU.inputNumber("DDpreciou", rsLinea.DDpreciou, "1", false, "", "", "suma();")#
								<cfelse>
								   #LvarOBJ_PrecioU.inputNumber("DDpreciou", rsLinea.DDpreciou, "1", false, "", "", "suma();")#
								</cfif>
								</cfoutput>
							</td>
						</tr>
						<tr>
							<td><div align="right" id="labelDDdesclinea"><cfoutput>#LB_Descuento#:&nbsp;</cfoutput></div></td>
							<td align="right"> <cfoutput>
								<input name="DDdesclinea" id="DDdesclinea" onFocus="javascript:this.value = qf(this.value); this.select();"
									type="text" tabindex="1" size="12" maxlength="12"
									style="text-align:right" onBlur="javascript:fm(this,2);suma();"
									value="<cfif modoDet NEQ "ALTA">#LSCurrencyFormat(rsLinea.DDdesclinea,'none')#<cfelse>0.00</cfif>">
							</cfoutput> </td>
						</tr>
						</tr>
							<td><div align="right"><cfoutput>#LB_Subtotal#:&nbsp;</cfoutput></div></td>
							<td align="right">
                            	<cfset lvarValor = 0>
                                <cfif modoDet NEQ "ALTA">
                                	<cfset lvarValor = rsLinea.DDtotallinea>
                              	</cfif>
                            	<cf_monto name="DDtotallinea" value="#lvarValor#" onChange="fnValidarMontos()">
							<cfoutput>
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

						<tr>
							<td><div align="right"><cfoutput>#LB_IEPS#:&nbsp;</cfoutput></div></td>
							<td align="right"> <cfoutput>
								<input name="DDMieps" onFocus="javascript:this.value = qf(this.value); this.select();"
									type="text" tabindex="1" size="12" maxlength="12"
									style="text-align:right" readonly onBlur="javascript:fm(this,2);calculaieps();"
									value="<cfif modoDet NEQ "ALTA">#LSCurrencyFormat(rsLinea.DDMontoIeps,'none')#<cfelse>0.00</cfif>">
							</cfoutput> </td>
						</tr>
						<tr>
							<td><div align="right"><cfoutput>#LB_Impuesto#:&nbsp;</cfoutput></div></td>
							<td align="right"> <cfoutput>
								<input name="IVA" onFocus="javascript:this.value = qf(this.value); this.select();"
									type="text" tabindex="1" size="12" maxlength="12"
									style="text-align:right" readonly onBlur="javascript:fm(this,2);"
									value="<cfif modoDet NEQ "ALTA">#LSCurrencyFormat(rsLinea.IVA,'none')#<cfelse>0.00</cfif>">
							</cfoutput> </td>
						</tr>
				</table>
			</td>

      </tr>
				

          <cfif rsActividad.Pvalor eq 'S'>
          <tr>
          	<td valign="top">#Lbl_ActEmpr#</td>
            <cfset idActividad = "">
			<cfset valores = "">
            <cfset lvarReadonly = LvarPlanDeCompras2>
            <cfif modoDet NEQ "ALTA">
            	<cfset idActividad = rsLinea.FPAEid>
                <cfset valores = rsLinea.CFComplemento>
                <cfset lvarReadonly = LvarItemReadonly>
            </cfif>
            <td valign="top" colspan="4"><cf_ActividadEmpresa etiqueta="" idActividad="#idActividad#" valores="#valores#" name="CFComplemento" nameId="FPAEid" formname="form1" readonly="#lvarReadonly#"></td>
          </tr>
          </cfif>
		  <cfif isdefined("rsOrdenCompra")>
			<cfoutput>
			<tr>
				<td align="right">#LB_Orden#:&nbsp;</td>
				<td align="left" colspan="8">#rsOrdenCompra.EOnumero#
        &nbsp; &nbsp; &nbsp;L&iacute;nea:&nbsp; #rsOrdenCompra.DOconsecutivo#</td>
				</td>
			</tr>
			</cfoutput>
		  </cfif>
			</cfif><!--- Fin de validacion factura tiene remision --->

		 <cfoutput>
          <tr>
            <td colspan="11"><div align="center">
				<cfif NOT rsDocumento.EDexterno and PermisoModificar>
                   <input name="Cambiar"  class="btnGuardar" tabindex="1" type="submit" value="#Lbl_CamDoct#" onclick="javascript: var estado = document.form1.EDtipocambio.disabled; document.form1.EDtipocambio.disabled = false; fnNoValidar(); if (validaE()) return true; else {document.form1.EDtipocambio.disabled = estado; return false;}" />
                </cfif>
                <cfif NOT rsDocumento.EDexterno and PermisoModificar and modoDet NEQ "ALTA">
                    <input name="CambiarD" class="btnGuardar" tabindex="1" type="submit" value="#Lbl_CamLine#" onClick="javascript: var estado = document.form1.EDtipocambio.disabled; document.form1.EDtipocambio.disabled = false; if (valida()) return true; else {document.form1.EDtipocambio.disabled = estado; return false;}">
                </cfif>
                <cfif NOT rsDocumento.EDexterno and PermisoAgregar and modoDet EQ "ALTA">
                    <input name="AgregarD" class="btnGuardar" tabindex="1" type="submit" value="#BTN_Agregar#" onClick="javascript:   var estado = document.form1.EDtipocambio.disabled; document.form1.EDtipocambio.disabled = false;if (valida()) return true; else {document.form1.EDtipocambio.disabled = estado; return false;}">
                </cfif>
                <cfif NOT rsDocumento.EDexterno and PermisoBorrar>
                <cfset MSG_Borrar = t.Translate('MSG_Borrar','¿Desea borrar este documento?')>
                	<cfif isdefined("rsTieneInclusion") >
                    <input name="BorrarE" class="btnEliminar" tabindex="1" type="submit" value="#Lbl_BorrDoc#" onClick="javascript: <cfif rsTieneInclusion.registros gt 0>alert('El documento tiene Documentos de Inclusion Relacionados no se puede Borrar');return false;<cfelse>fnNoValidar(); if (confirm('#MSG_Borrar#')) return true; else return false;</cfif>">
                   	<cfelse>
                    <input name="BorrarE" class="btnEliminar" tabindex="1" type="submit" value="#Lbl_BorrDoc#" onClick="javascript:  fnNoValidar(); if (confirm('#MSG_Borrar#')) return true; else return false;">
                    </cfif>
                </cfif>
                <cfif PermisoAplicar>
                	<cfset MSG_valAplica = t.Translate('MSG_valAplica','¿Desea aprobar un documento con fecha anterior a los Auxiliares?')>
                    <input type="submit" class="btnAplicar"  tabindex="1" name="btnAplicar"  			value="#BTN_Aplicar#" 	       onClick="javascript: fnNoValidar(); 
									<cfif ((rsDocumento.yearFecha*100)+rsDocumento.monthFecha) lt  ((LvarAnoAux*100)+LvarMesAux)>
										if (confirm('#MSG_valAplica#')) return true; else return false;
									</cfif>  return Postear(); " >
                <cfelse>
                    <input type="submit" class="btnAplicar"  tabindex="1" name="btnEnviar_a_Aplicar"    value="#Lbl_EnvApl#"   onClick="javascript: fnNoValidar();return true;">
                </cfif>
                <cfif PermisoAnular>
                    <input type="submit" class="btnNormal"   tabindex="1" name="btnAnular"  id="btnAnular"   			value="#BTN_Anular#" 		        onClick="javascript:return fnAnular(); fnNoValidar();return true;">
                </cfif>
                <cfif NOT rsDocumento.EDexterno and PermisoAgregar and LvarTipoMov EQ 'C' and rsTieneRemision.totalRemisiones EQ 0>
                	<input type="button" class="btnNormal"  tabindex="1" name="OrdenCompra" value="#Lbl_OrdC#" onClick="javascript:NuevaVentana(<cfoutput>#rsNombreSocio.SNcodigo#,#rsDocumento.IDdocumento#,#rsDocumento.Mcodigo#</cfoutput>);">
                </cfif>
								<!--- Agregar remisiones a facturas, siempre y cuando solo sean de remisones --->
							  <cfif NOT rsDocumento.EDexterno and PermisoAgregar and LvarTipoMov EQ 'C' and rsTieneLineas.totalLineas EQ 0>
                	<input type="button" class="btnNormal"  tabindex="1" name="Remisiones" value="#Lbl_Remision#" onClick="javascript:NuevaVentanaRemision(<cfoutput>#rsNombreSocio.SNcodigo#,#rsDocumento.IDdocumento#,#rsDocumento.Mcodigo#</cfoutput>);">
                </cfif>
				<cfif NOT rsDocumento.EDexterno and PermisoAgregar and LvarTipoMov EQ 'C' and rsTieneRemision.totalRemisiones EQ 0>
					<input type="button" class="btnNormal"  tabindex="1" name="Contrato" value="#Lbl_Contrato#" onClick="javascript:VentanaContrato(<cfoutput><cfif isdefined('rsDocumento.IDdocumento') and len(trim(#rsDocumento.IDdocumento#))>#rsDocumento.IDdocumento#</cfif></cfoutput>);">
                </cfif>
                <cfif NOT rsDocumento.EDexterno and PermisoAgregar and modoDet NEQ "ALTA">
                     <input name="NuevoD"   class="btnNuevo"   tabindex="1" type="submit" value="#Lbl_NuevaL#" onClick="javascript: fnNoValidar();">
                </cfif>
				<cfif NOT rsDocumento.EDexterno and form.tipo eq 'D' and PermisoAgregar>
				  	<input type="button" class="btnNormal"  tabindex="1" name="Facturas" value="#Lbl_LinFact#"  onClick="javascript:ShowFacturas();" >
				</cfif>
                <cfif NOT rsDocumento.EDexterno and (form.tipo eq 'C' or form.tipo eq '') and PermisoAgregar and rsUsaPlanCuentas.Pvalor eq LvarParametroPlanCom>
					<input type="button" class="btnNormal"  tabindex="1" name="PlanDeCompras" value="#Lbl_PlanCmpr#"  onClick="javascript:PlanCompras();" >
				</cfif>
                <cfif PermisoAgregar>
                	<input type="submit" class="btnNuevo"   tabindex="1" name="btnNuevo"    value="#BTN_Nuevo#" 		 onClick="javascript: fnNoValidar();">
                </cfif>
                    <input type="button" class="btnImprimir"tabindex="1" name="Imprimir"      value="#BTN_ImprTr#"      onClick="javascript:funcImprimir();">
                    <input type="button" class="btnImprimir"tabindex="1" name="ImprimirFactura"      value="#BTN_ImprFac#"      onClick="javascript:funcImprimirFactura();">
                    <input type="submit" class="btnNormal"  tabindex="1" name="btnEnviarEmail"    value="#BTN_EnvMail#" 		 onClick="javascript: fnNoValidar();return true;">
                    <input type="submit" class="btnNormal"  tabindex="1" name="Calcular"    value="#BTN_Ver#" 		 onClick="javascript: fnNoValidar();return true;">
                    <cfif rsTieneRemision.totalRemisiones EQ 0>
										    <input type="button" class="btnNormal" tabindex="1"  name="btnVerOC"  value="#BTN_VerOC#" onclick="javascript: fnVerOC()" />
                	  </cfif>
									<cfif LvarRemision EQ 1>
                    <input type="button" class="btnNormal"  tabindex="1" name="Remision" value="#Lbl_Remision#" onClick="javascript:NuevaVentanaRemision(<cfoutput>#rsNombreSocio.SNcodigo#,#rsDocumento.IDdocumento#,#rsDocumento.Mcodigo#</cfoutput>);">
                    </cfif>
                	<input type="button" class="btnAnterior"tabindex="1" name="ListaE"      value="#BTN_Regresar#"      onClick="javascript:Lista();">

            </div></td>
          </tr>
		</cfoutput>
        </table>
		<script language="JavaScript1.2">
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
							if (document.form1.CmayorD)
							{
								document.form1.CmayorD.value="<cfoutput>#Trim(JSStringFormat(mid(rsCuentaConcepto.Cformato,1,4)))#</cfoutput>";
								document.form1.CformatoD.value="<cfoutput>#Trim(JSStringFormat(mid(rsCuentaConcepto.Cformato,5,len(rsCuentaConcepto.Cformato))))#</cfoutput>";
							}
						<cfelse>
							if (document.form1.CmayorD)
							{
								document.form1.CmayorD.value="<cfoutput>#JSStringFormat(rsCuentaConcepto.Cformato)#</cfoutput>";
								document.form1.CformatoD.value="";
							}
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
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	validatcLOAD();
	AsignarHiddensEncab();
	<cfif modo NEQ "ALTA">
	  <cfif rsTieneRemision.totalRemisiones EQ 0>
			if (document.form1.DDtipo.value != "S")
				//document.form1.imagen[1].style.visibility = "hidden";
			poneItem();
			window.setTimeout("cambiarDetalle()",1);
		</cfif>

	<cfelse>
		document.form1.EDdocumento.focus();
	</cfif>
	<cfif modo NEQ "ALTA">
	function valFechaPosteo(){
		<cfif ((rsDocumento.yearFecha*100)+rsDocumento.monthFecha) lt  ((LvarAnoAux*100)+LvarMesAux)>
			confirm("Desea aprobar un documento con fecha anterior a los Auxiliares");
		</cfif>
		return false;
	}
	</cfif>
	<!---►► muestra u oculta el monto de retencion variable ◄◄--->
	function mostrar_retVar()
	{
		var mostrar = false;
		var varRet = document.form1.Rcodigo.options[document.form1.Rcodigo.selectedIndex].value;
		if(varRet != '-1'){
			var res = varRet.split("|");
			if(res[1] == '1')
				mostrar = true;
		}
		var varlblEDretencionVariable = document.getElementById('lblEDretencionVariable');
		var varEDretencionVariable = document.getElementById('EDretencionVariable');
		var varlblMonto = document.getElementById('lblMonto');
		if(varlblEDretencionVariable) varlblEDretencionVariable.style.display = (mostrar)?"":"none";
		if(varEDretencionVariable) varEDretencionVariable.style.display = (mostrar)?"":"none";
		//document.getElementById("EDretencionVariable").value = 0;
		//document.getElementById("lblMonto").style.display = (mostrar)?"none":"";
		//alert(mostrar);
	}
	function CalculaFechaVen(){
		var lvarFechaCalculo = 'EDfecha';
		<cfif lVarValidaFechaArribo EQ false>
			lvarFechaCalculo = 'EDfechaarribo';
		</cfif>

		if(document.getElementById(lvarFechaCalculo).value !=''){
			fechaVencimiento = fndateadd(document.getElementById(lvarFechaCalculo).value,document.getElementById('SNvencompras').value);
			document.getElementById('EDvencimiento').value = fndateformat(fechaVencimiento);
		}
		else
			document.getElementById('EDvencimiento').value ='';
	}
	<!---►►Funcion que suma Dias a un string con formato fecha◄◄--->
	function fndateadd(fecha, dias){
		f = fecha.split('/');
		stringFecha = new Date(f[2],f[1]-1,f[0]);
		return new Date(stringFecha.getTime() + dias * 86400000); //Cantidad de milesegundos en un Dia
	}
	<!---►►Funcion que convierte una fecha a un string de tipo DD/MM/YYYY◄◄--->
	function fndateformat(fecha){
		var dd   = fecha.getDate();
		var mm   = fecha.getMonth()+1;//Enero is 0
		var yyyy = fecha.getFullYear();
		if(dd<10){dd='0'+dd;}
		if(mm<10){mm='0'+mm;}
		return dd+'/'+mm+'/'+yyyy;;
	}
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
	var popUpWin1=0;
	//Levanta el Conlis
	function popUpWindow1(URLStr, left, top, width, height)
	{
		if(popUpWin1)
		{
			if(!popUpWin1.closed) popUpWin1.close();
		}
		popUpWin1 = open(URLStr, 'popUpWin1', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
	//Llama el conlis
	function NuevaVentana(SNcodigo, IDdocumento,Mcodigo) {
		var params ="";

		params = "&form=form"+

		popUpWindow("/cfmx/sif/cp/operacion/OrdenCompra.cfm?SNcodigo="+SNcodigo+"&IDdocumento="+IDdocumento+"&Mcodigo="+Mcodigo+params,50,50,900,750);
	}

	function VentanaContrato(IDdocumento) {
		var params ="";

		params = "&form=form"+

		popUpWindow1("/cfmx/sif/cp/operacion/popUp-contrato.cfm?IDdocumento="+IDdocumento+"&Ecodigo="+<cfoutput>#lvarFiltroEcodigo#</cfoutput>+params,window.screen.width*0.05 ,window.screen.height*0.05,window.screen.width*0.90 ,window.screen.height*0.90);
	}


	function NuevaVentanaRemision(SNcodigo, IDdocumento,Mcodigo) {
		var params ="";
		var statusRemision = 1;//Facturas, solo remisiones aplicadas
		<cfoutput>
		    <cfif form.tipo eq 'D'>
				    statusRemision = 2;<!--- Notas de credito, solo remisiones canceladas --->
				</cfif>
		</cfoutput>
		params = "&form=form"+

		popUpWindow("/cfmx/sif/cp/operacion/remisiones/Remisiones.cfm?SNcodigo="+SNcodigo+"&IDdocumento="+IDdocumento+"&Mcodigo="+Mcodigo+"&statusRM="+statusRemision+params,50,50,900,750);
	}
	function funcGarantias(IDdocumento) {
			popUpWindow("/cfmx/sif/cp/operacion/ReporteGarantias.cfm?Documento="+IDdocumento,50,50,900,750);
	}
	//llama el pop up y le pasa por url los parametros
	function ShowFacturas()
	{
	     var LvarReferencia = document.form1.Referencia.value;
		 var LvarReferencia1 = document.form1.Referencia1.value;
		 var LvarSNcodigo = document.form1.SNcodigo.value;
		 if(LvarReferencia =='' ||LvarReferencia1 =='')
		 {
			<cfset MSG_SelFact = t.Translate('MSG_SelFact','No se ha seleccionado ninguna factura de referencia')>
		   <cfoutput>alert("#MSG_SelFact#");</cfoutput>
		   return false;
		 }
		 else
		 {
		 var LvarIdDocumento = document.form1.IDdocumento.value;
		  window.open('NotasCreditoFacturas.cfm?tipo='+LvarReferencia+'&Ddocumento='+LvarReferencia1+'&IdDocumento='+LvarIdDocumento+'&SNcodigo='+LvarSNcodigo,'popup','width=1000,height=500,left=200,top=50,scrollbars=yes');
		 }
	}

	function funcFactRecurrente(SNcodigo){

		var paramss ="";
		var LvarDdocumento = document.form1.EDdocumento.value;
		var LvarTESRPTCid1 = document.form1.TESRPTCid.value;
		if (LvarDdocumento == "" ){
			<cfset MSG_DocReq = t.Translate('MSG_DocReq','El campo Documento es requerido.')>
			<cfoutput>alert('#MSG_DocReq#');</cfoutput>
				return false;
		}
		if (LvarTESRPTCid1 == "" ){
			<cfset MSG_PgoTerReq = t.Translate('MSG_PgoTerReq','El campo Pagos a terceros es requerido.')>
			<cfoutput>alert('#MSG_PgoTerReq#');</cfoutput>
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
		    document.form1.DDdescripcion.value = document.form1.Adescripcion.value + ' ' + document.form1.cuentamayor_Acodigo.value;
 		    document.form1.DDdescalterna.value = document.form1.Adescripcion.value;
 		  	document.form1.CdescripcionD.value = document.form1.cuentadesc_Acodigo.value;

			if (document.form1.CcuentaD) document.form1.CcuentaD.value = document.form1.cuenta_Acodigo.value;
			if (document.form1.CmayorD) {document.form1.CmayorD.value = document.form1.cuentamayor_Acodigo.value;
			document.form1.CformatoD.value =  document.form1.cuentaformato_Acodigo.value;
			document.form1.CdescripcionD.value = document.form1.cuentadesc_Acodigo.value;}

			llenar2();

			<!--- if (document.form1.chkEspecificarcuenta.checked){
			return;
			}

			fnCambioCuenta(); --->

		}

		function funcExtraAcodigo(){
			<cfif NOT LvarComplementoXorigen>
			document.form1.CcuentaD.value = document.form1.cuenta_Acodigo.value='';
			</cfif>
			if (document.form1.CmayorD) {document.form1.CmayorD.value = document.form1.cuentamayor_Acodigo.value = '';
			document.form1.CformatoD.value =  document.form1.cuentaformato_Acodigo.value='';
			document.form1.CdescripcionD.value =  document.form1.cuentadesc_Acodigo.value='';}
		}

 	</cfif>

	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	_allowSubmitOnError = false;

	function funcAlmcodigoAntes(){
		limpiarAxCombo();
	}

		/*-------------------------*/
	<cfset MSG_ElCmpo = t.Translate('MSG_ElCmpo','El campo ')>
	<cfset MSG_DebeCont = t.Translate('MSG_DebeCont',' debe contener un valor entre ')>
	<cfset MSG_and = t.Translate('MSG_and',' y ')>
	function _Field_isRango(low, high)
	{
		if (_allowSubmitOnError!=true)
		{
			var low=_param(arguments[0], 0.0000000, "number");
			var high=_param(arguments[1], 9999999.99, "number");
			var iValue=parseFloat(qf(this.value));
			if(isNaN(iValue))iValue=0;
			if((low>iValue)||(high<iValue))
			{
				<cfoutput>this.error="#MSG_ElCmpo#"+' '+this.description+' '+"#MSG_DebeCont#"+' '+low+' '+"#MSG_and#"+' '+high+".";</cfoutput>
			}
		}
	}
	_addValidator("isRango", _Field_isRango);

	function _ValidarSNid_CCO_00(low, high)
	{
		if (_allowSubmitOnError!=true)
		{
			var low=_param(arguments[0], 0.0000000, "number");
			var high=_param(arguments[1], 9999999.99, "number");
			var iValue=parseFloat(qf(this.value));
			if(isNaN(iValue))iValue=0;
			if((low>iValue)||(high<iValue))
			{
				<cfoutput>this.error="#MSG_ElCmpo#"+' '+this.description+' '+"#MSG_DebeCont#"+' '+low+' '+"#MSG_and#"+' '+high+".";</cfoutput>
			}
		}
	}
	_addValidator("isValidaSNid", _ValidarSNid_CCO_00);

	<cfif modo NEQ "ALTA">
	  <cfif rsTieneRemision.totalRemisiones EQ 0>
		<cfoutput>
		objForm.OCid.description = "#Lbl_OrdCom#";
		objForm.OC_SNid.description = "#LB_SNOrdenC#";

		objForm.OCTtransporte.description 	= "#LB_TranTr#";
		objForm.OCTid.description 			= "#LB_TranOC#";

		objForm.Aid.description		= "#Lbl_Art#";
		objForm.AidT.description	= "#LB_ArtTran#";
		objForm.AidOD.description	= "#Lbl_ArtOrdenC#";
		</cfoutput>
		</cfif>
	</cfif>
	<cfoutput>
	objForm.EDdocumento.required = true;
	objForm.EDdocumento.description = "#Lbl_CodDocto#";
	objForm.CPTcodigo.required = true;
	objForm.CPTcodigo.description = "#Lbl_TpoTrans#";
	objForm.SNcodigo.required = true;
	objForm.SNcodigo.description = "#LB_CLIENTE#";

	objForm.EDfechaarribo.required 	  = true;
	objForm.EDfechaarribo.description = "#LB_FecArr#";
	objForm.EDfecha.required		  = true;
	objForm.EDfecha.description 	  = "#LB_FecFact#";
	objForm.EDvencimiento.required 	  = true;
	objForm.EDvencimiento.description = "#LB_FecVenc#";

	objForm.Mcodigo.required = true;
	objForm.Mcodigo.description = "#LB_Moneda#";
	objForm.Ocodigo.required = true;
	objForm.Ocodigo.description = "#LB_Oficina#";
	objForm.Rcodigo.required = true;
	objForm.Rcodigo.description = "#LB_Retenc#";
	objForm.Ccuenta.required = true;
	objForm.Ccuenta.description = "#Lbl_CtaProv#";
	objForm.TESRPTCid.required = true;
	objForm.TESRPTCid.description = "#LB_PagTerc#";

	<cfif modoDet NEQ "ALTA" and rsLinea.DDtipo EQ "I" >
		objForm.DDdescripcion.required = true;
		objForm.DDdescripcion.description = "#Lbl_DescImpVar#";
	</cfif>


	objForm.EDtipocambio.required = true;
	objForm.EDtipocambio.description = "#LB_Tipo_de_Cambio#";
	objForm.EDtipocambio.validateRango('0.0001','999999999999.9999');

	objForm.EDdescuento.description = "#LB_Descuento#";
	objForm.EDdescuento.validateRango('0.00','999999999999.99');
	</cfoutput>
	<cfif modo NEQ "ALTA">
  <cfif rsTieneRemision.totalRemisiones EQ 0>
	if(document.form1.Almacen.style.visibility == "visible"){
		objForm.Almacen.required = true;
		<cfoutput>objForm.Almacen.description = "#Lbl_Almac#";</cfoutput>
	}

	if(document.form1.LvarPlanDeCompras == false){
		objForm.DDdescripcion.required = true;
		<cfoutput>objForm.DDdescripcion.description = "#Lbl_DescDet#";</cfoutput>
	if (document.form1.CcuentaD){
	<cfoutput>
	objForm.CcuentaD.required = true;
	objForm.CcuentaD.description = "#Lbl_CtaDet#";</cfoutput>}
	}

    <cfoutput>
	objForm.DDpreciou.required = true;
	objForm.DDpreciou.description = "#Lbl_PrecioU#";
	objForm.DDpreciou.validateRango('0.000001','999999999999.99');

	objForm.DDcantidad.required = true;
	objForm.DDcantidad.description = "#Lbl_cantidad#";
	objForm.DDcantidad.validateRango('0.00','999999999999.99');

	objForm.DDdesclinea.required = true;
	objForm.DDdesclinea.description = "#Lbl_DescLin#";
	objForm.DDdesclinea.validateRango('0.00','999999999999.99');

	objForm.DDtotallinea.required = true;
	objForm.DDtotallinea.description = "#Lbl_TotLin#";
	objForm.DDtotallinea.validateRango('0.000001','999999999999.99');
	</cfoutput>
	</cfif>
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
	var LvarArrMascara = new Array();

<cfoutput query="rsTransacciones">
	<cfif isdefined("rsTransacciones.CFformato")>
		/* def*/
		LvarArrCcuenta  ["#CPTcodigo#"] = "#rsTransacciones.Ccuenta#";
		LvarArrCFformato["#CPTcodigo#"] = "#rsTransacciones.CFformato#";
		LvarArrCFdescripcion["#CPTcodigo#"] = "#rsTransacciones.CFdescripcion#";
		LvarArrMascara["#CPTcodigo#"] = "#rsTransacciones.Cmascara#";
	<cfelse>
		/* no  def*/
		LvarArrCcuenta  ["#CPTcodigo#"] = "";
		LvarArrCFformato["#CPTcodigo#"] = "";
		LvarArrCFdescripcion["#CPTcodigo#"] = "";
		LvarArrMascara["#CPTcodigo#"] = "";
	</cfif>

</cfoutput>
	function sbCPTcodigoOnChange (CPTcodigo)
	{
		document.getElementById("Ccuenta").value 	= LvarArrCcuenta  [CPTcodigo];
	<cfif LvarComplementoXorigen>
		document.getElementById("SNCta").value 		= LvarArrCFformato[CPTcodigo] + ': ' + LvarArrCFdescripcion[CPTcodigo];
	<cfelse>
		var LvarCFformato = LvarArrCFformato[CPTcodigo];
		document.getElementById("Cmayor").value 		= LvarCFformato.substring(0,4);
		document.getElementById("Cformato").value 		= LvarCFformato.substring(5,100);
		document.getElementById("Cfdescripcion").value 	= LvarArrCFdescripcion[CPTcodigo];
		document.getElementById("Cmayor_mask").value 	= LvarArrMascara[CPTcodigo];
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
	<cfif LvarComplementoXorigen>
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
		 <cfif isdefined("modo") and modo neq 'ALTA'and  modoDet EQ "ALTA" and rsTieneRemision.totalRemisiones EQ 0>
			document.form1.DDtipo.focus();
		</cfif>
	</cfoutput>
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
				<cfoutput>
				<cfset MSG_SelOC = t.Translate('MSG_SelOC','Tiene que seleccionar una orden comercial')>
				alert('#MSG_SelOC#');
				</cfoutput>
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
					<cfoutput>
					<cfset MSG_SelOC = t.Translate('MSG_SelOC','Tiene que seleccionar una orden comercial')>
					alert('#MSG_SelOC#');
					</cfoutput>
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
		document.form1.CFcuentaD.value	= pCFcuenta;
		document.form1.CcuentaD.value			= pCcuenta;
		document.form1.CmayorD.value			= pCFformato.substring(0,4);
		document.form1.CformatoD.value			= pCFformato.substring(5);
		document.form1.CdescripcionD.value		= pCFdescripcion;
	}
	function PlanCompras()
	{
     IDdocumento = document.form1.IDdocumento.value;
	 LvarfechaFactura=document.form1.EDfecha.value;
     window.open('planComprasFactura.cfm?documento='+IDdocumento+'&fechaFactura='+LvarfechaFactura,'popup','width=1200,height=700,left=100,top=50,scrollbars=yes');

	}
	function  fnVerOC()
	{
	   IDdocumento = document.form1.IDdocumento.value;
       window.open('OrdenesFacturadas.cfm?documento='+IDdocumento,'popup','width=1100,height=350,left=200,top=150,scrollbars=yes');
	}
	function fnAnular(){
		<cfoutput>
		<cfset MSG_AnDocto = t.Translate('MSG_AnDocto','Esta seguro que desea Anular el Documento?')>
		return confirm('#MSG_AnDocto#');
		</cfoutput>
	}
</script>
<script language="javascript" type="text/javascript">
	initPage(document.form1);
	<!---►►Cuando es Modo Alta, o es cambio pero no se guardo la fecha de vencimiento, la misma se segerira◄◄--->
	<cfif modo EQ "ALTA" OR NOT LEN(TRIM(rsDocumento.EDvencimiento))>
		CalculaFechaVen();
	</cfif>
	<cfif modoDet NEQ "ALTA" and rsLinea.DDtipo EQ "I" >
			//ESTA LINEA NO NOS INTERESA
			document.getElementById("trv2").style.display = 'none';
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
			document.getElementById('articuloT').style.display 			= 'none';
			document.getElementById("EspecificaCuentaLabel").style.display = 'none';
			document.getElementById("EspecificaCuenta").style.display = 'none';

			document.getElementById("labelconcepto").style.display = 'none';
			document.getElementById("concepto").style.display = 'none';
			document.getElementById("EspecificaCFLabel").style.display = 'none';
			document.getElementById("EspecificaCF").style.display = 'none';
			document.getElementById("chkEspecificarCF").style.display = 'none';
			document.getElementById("labelDDdesclinea").style.display = 'none';
			document.getElementById("DDdesclinea").style.display = 'none';
			document.form1.DDcantidad.value = "1.00"
			document.form1.DDcantidad.readOnly = true;

	</cfif>


</script>