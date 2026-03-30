
<!---/-------------------------------------------------------------------------------------
-------------------------FORMULARIO DE CAPTURA DE LIQUIDACION------------------------------
--------------------------------------------------------------------------------------/--->
<cfsilent>
	<!---/-------------------------------------------------------------------------------------
	------------------------------OBTIENE LAS TRADUCCIONES DE LAS------------------------------
	------------------------------ETIQUETAS Y MENSAJES UTILIZADOS------------------------------
	--------------------------------------------------------------------------------------/--->
<cfinvoke key="MSG_ERROR_DEID" default="El usuario que accesó la aplicación no esta registrado como empleado de la empresa en la cual ingresó." returnvariable="MSG_ERROR_DEID" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSGJS_ERROR_DEID" default="Error. No se encontró el Empleado Asociado con su Usuario!" returnvariable="MSGJS_ERROR_DEID" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_ERROR_VIGENCIAS" default="Error. No se encontr&oacute; Vigencias de Renta Sin Aplicar!" returnvariable="MSG_ERROR_EIRid" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSGJS_ERROR_VIGENCIAS" default="Error. No se encontró Vigencias de Renta Sin Aplicar!" returnvariable="MSGJS_ERROR_EIRid" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Vigencias_de_Renta_sin_Liquidar" default="Vigencias de Renta sin Liquidar" returnvariable="LB_Vigencias_de_Renta_sin_Liquidar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Pago" default="Pago" returnvariable="LB_Pago" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LBJS_Pago" default="Pago" returnvariable="LBJS_Pago" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Retencion" default="Retenci&oacute;n" returnvariable="LB_Retencion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LBJS_Retencion" default="Retención" returnvariable="LBJS_Retencion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Pagos" default="Pagos" returnvariable="LB_Pagos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Retenciones" default="Retenciones" returnvariable="LB_Retenciones" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Empresa" default="Empresa" returnvariable="LB_Empresa" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Otros" default="Otros" returnvariable="LB_Otros" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Total" default="Total" returnvariable="LB_Total" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Anno" default="A&ntilde;o" returnvariable="LB_Anno" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Mes" default="Mes" returnvariable="LB_Mes" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSGJS_El_valor_de_" default="El valor de " returnvariable="MSGJS_El_valor_de_" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSGJS_debe_ser_mayor_que_cerop" default="debe ser mayor que cero." returnvariable="MSGJS_debe_ser_mayor_que_cerop" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSGJS__Confirma_que_desea_aplicar_la_liquidacion_de_Renta_" default="¿Confirma que desea aplicar la liquidación de Renta?" returnvariable="MSGJS__Confirma_que_desea_aplicar_la_liquidacion_de_Renta_" component="sif.Componentes.Translate" method="Translate"/>
		
	<!--- VERIFICA SI LA EMPRESA ES DE GUATEMALA PARA MOSTRAR OTROS DATOS --->
	<cfquery name="rsEmpresa" datasource="#session.dsn#">
		select 1
		from Empresa e
			inner join Direcciones d
			on d.id_direccion = e.id_direccion
			and Ppais = 'GT'
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
	</cfquery>

	<!---/-------------------------------------------------------------------------------------
	------------------------------OBTIENE LOS DATOS DEL EMEPLEADO LOGEADO----------------------
	--------------------------------------------------------------------------------------/--->
	<cfquery name="rsDatosEmpleado" datasource="#session.dsn#">
		select llave
		from UsuarioReferencia ur
		inner join Empresa em 
					on em.Ecodigo = ur.Ecodigo
					and em.Ereferencia = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
					and em.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.cecodigo#">
		where ur.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		and ur.STabla = 'DatosEmpleado'
	</cfquery>
	<cfif rsDatosEmpleado.recordcount and len(trim(rsDatosEmpleado.llave))>
		<cfset form.DEid = rsDatosEmpleado.llave>
		<cfset lvarDEid = rsDatosEmpleado.llave>
	<cfelse>
		<cf_throw message="#MSG_ERROR_DEID#" errorcode="5045">
	</cfif>

	<!---/-------------------------------------------------------------------------------------
	------------------------------OBTIENE LAS TABLAS DE RENTA VIGENTES-------------------------
	--------------------------------------------------------------------------------------/--->
	<!--- OBTIENE EL CODIGO DE LA TABLA DE RENTA DE PARAMETROS --->
	<cfquery name="rsIRc" datasource="#session.dsn#">
		select rtrim(Pvalor) as IRcodigo
		from RHParametros 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#"> 
		and Pcodigo = 30
	</cfquery>
	<!--- OBTIENE LOS DATOS DE LIQUIDACION DE RENTA DEL EMMPLEADO Y QUE NO SE HAYA APLICADO --->
	<cfquery name="rsEIRidsaplicados" datasource="#session.dsn#">
		select rtrim(EIRid) as EIRid
	  	from RHLiquidacionRenta
	  	where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarDEid#">
	  	and Estado = 10
	</cfquery>
	<cfset Lvar_ListaAplicados = 0>
	<cfif rsEIRidsaplicados.RecordCount>
		<cfset Lvar_ListaAplicados = ValueList(rsEIRidsaplicados.EIRid)>
	</cfif>
	<cfdump var="#rsIRc#">
	<cfquery name="rsIRs" datasource="sifcontrol">
		select a.EIRid, 
			<cf_dbfunction name="date_part"   args="mm, a.EIRdesde"> as mesDesde,
			<cf_dbfunction name="date_part"   args="yy, a.EIRdesde"> as periodoDesde,
			<cf_dbfunction name="date_part"   args="mm, a.EIRhasta"> as mesHasta,
			<cf_dbfunction name="date_part"   args="yy, a.EIRhasta"> as periodoHasta,
			b.IRcodigo, 
			b.IRdescripcion, a.EIRdesde, a.EIRhasta
		from EImpuestoRenta a
			inner join ImpuestoRenta b
			on a.IRcodigo = b.IRcodigo
		where a.IRcodigo = '#rsIRc.IRcodigo#'
		  and not (<cf_whereInList Column="a.EIRid" ValueList="#ValueList(rsEIRidsaplicados.EIRid)#" cfsqltype="cf_sql_numeric">)
	</cfquery>

	<cfif (isdefined("Url.EIRid") and len(trim(Url.EIRid)) gt 0 and Url.EIRid gt 0)>
		<cfset Form.EIRid = Url.EIRid>
	</cfif>
	<cfif not (isdefined("Form.EIRid") and len(trim(Form.EIRid)) gt 0 and Form.EIRid gt 0)>
		<cfset Form.EIRid = rsIRs.EIRid>
	</cfif>
	<cfif isdefined('form.EIRid') and form.EIRid GT 0>
		<!---/-------------------------------------------------------------------------------------
		-------------------------OBTIENE LA TABLA DE RENTA SELECCIONADA----------------------------
		--------------------------------------------------------------------------------------/--->
		<cfquery name="rsIR" datasource="sifcontrol">
			select a.EIRid, 
				<cf_dbfunction name="date_part"   args="mm, a.EIRdesde"> as mesDesde,
				<!--- datepart(mm,a.EIRdesde) as mesDesde,  --->
				<cf_dbfunction name="date_part"   args="yyyy, a.EIRdesde"> as periodoDesde,
				<!--- datepart(yy,a.EIRdesde) as periodoDesde,  --->
				<cf_dbfunction name="date_part"   args="mm, a.EIRhasta"> -1 as mesHasta,
				<!--- datepart(mm,a.EIRhasta)-1 as mesHasta,  --->
				<cf_dbfunction name="date_part"   args="yyyy, a.EIRhasta"> +1 as periodoHasta,
				<!--- datepart(yy,a.EIRhasta)+1 as periodoHasta,  --->
				b.IRcodigo, 
				b.IRdescripcion,a.EIRdesde, a.EIRhasta
			from EImpuestoRenta a
				inner join ImpuestoRenta b
				on a.IRcodigo = b.IRcodigo
			where a.EIRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIRid#">
		</cfquery>
	
		<cfset lvarEIRid = rsIR.EIRid>
		<cfset lvarPeriodoDesde = rsIR.periodoDesde>
		<cfset lvarPeriodoHasta = rsIR.periodoHasta>
		<cfset lvarMesDesde = rsIR.mesDesde>
		<cfset lvarMesHasta = rsIR.mesHasta>
		<cfset lvarEIRdesde = rsIR.EIRdesde>
		<cfset lvarEIRhasta = rsIR.EIRhasta>
		<!---/-------------------------------------------------------------------------------------
		-------------------------OBTIENE LAS DESCRIPCIONES DE LOS MESES----------------------------
		--------------------------------------------------------------------------------------/--->
		<cfquery name="rsMeses"  datasource="#session.dsn#">
			select <cf_dbfunction name="to_number" args="b.VSvalor"> as MesNumber, VSdesc as Mes
			from Idiomas a
				inner join VSidioma b
				on b.Iid = a.Iid
				and b.VSgrupo = 1
			where Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.idioma#">
			order by <cf_dbfunction name="to_number" args="b.VSvalor">
		</cfquery>
		<!--- FUNCION QUE OBTIENE EL MES --->
		<cffunction name="getMonthName" access="private" returntype="string">
			<cfargument name="mes" type="numeric" required="true">
			<cfquery name="rsMes" dbtype="query">
				select Mes
				from rsMeses
				where MesNumber = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Mes#">
			</cfquery>
			<cfif rsMes.recordcount eq 1 and len(trim(rsMes.Mes)) gt 0>
				<cfreturn rsMes.Mes>
			<cfelse>
				<cfreturn arguments.Mes>
			</cfif>
		</cffunction>
		<!---/-------------------------------------------------------------------------------------
		-------------------------OBTIENE LOS PAGOS REALIZADOS AL EMPLEADO--------------------------
		--------------------------------------------------------------------------------------/--->
		<cfquery name="rsPagos1"  datasource="#session.dsn#">
			select CPid,CPperiodo, CPmes, SEsalariobruto, SEincidencias, SEinorenta, SErenta, DEid
			from CalendarioPagos a
				inner join HSalarioEmpleado b
				on b.RCNid = a.CPid
				and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarDEid#">
			where a.CPperiodo between <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarPeriodoDesde#">
					and <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarPeriodoHasta#">
		</cfquery>
		<cfset Lvar_Calendarios = ValueList(rsPagos1.CPid)>
	
		<!--- OBTIENE EL TOTAL DE RENTA PAGADO EN EL PERIODO --->
		<cfquery name="rsPagoRenta" dbtype="query">
			select sum(SErenta) as TotalRenta
			from rsPagos1
		</cfquery>
		<cfif isdefined('rsPagoRenta') and rsPagoRenta.RecordCount>
			<cfset Lvar_TotalRenta = rsPagoRenta.TotalRenta>
		<cfelse>
			<cfset Lvar_TotalRenta = 0.00>
		</cfif>
		<!--- OBTIENE LOS DATOS DE LIQUIDACION DE RENTA PARA LOS PERIODOS --->
		<cfquery name="rsPagos2"  datasource="#session.dsn#">
			select Periodo, Mes, montopagoempresa, montootrospagos, montoretencion, montootrasret
			from RHLiquidacionRenta
			where EIRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarEIRid#">
				and DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarDEid#">
				and Periodo between <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarPeriodoDesde#">
					and <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarPeriodoHasta#">
		</cfquery>
		<cfquery name="rsDetallesSumas" datasource="#session.DSN#">
			select sum(DLRingresos) as DLRingresos, 
					sum(DLRigss) as DLRigss, 
					sum(DLRotrosGastos) as DLRotrosGastos,
					sum(DLRretenciones) as DLRretenciones
			from RHDLiquidacionRenta
			where EIRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarEIRid#">
			  and DEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarDEid#">
			  and Periodo between <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarPeriodoDesde#">
					and <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarPeriodoHasta#">
		</cfquery>
		<cfquery name="rsDetalles" datasource="#session.DSN#">
			select DLRdeduccionPersonal, 
					DLRseguroVida, 
					DLRgastosMedicos, 
					DLRpensiones, 
					DLRporcentajeBase, 
					DLRdeduccionBase, 
					DLRimpuestoFijo, 
					DLRcreditoIva
			from RHDLiquidacionRenta
			where EIRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarEIRid#">
			  and DEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarDEid#">
			  and Periodo between <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarPeriodoDesde#">
					and <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarPeriodoHasta#">
			group by DLRdeduccionPersonal, 
					DLRseguroVida, 
					DLRgastosMedicos, 
					DLRpensiones, 
					DLRporcentajeBase, 
					DLRdeduccionBase, 
					DLRimpuestoFijo, 
					DLRretenciones, 
					DLRcreditoIva
		</cfquery>
		<!--- SI NO SE HAN REGISTRADO LOS DATOS DE LA TABLA DE RENTA SE BUSCAN Y SE MUESTRAN EN PANTALLA --->
		<cfset Lvar_ValidaDatosRenta = 'NO'>
		<cfif isdefined('rsDetalles') and rsDetalles.RecordCount and rsDetalles.DLRporcentajeBase EQ 0>
			<cfset Lvar_ValidaDatosRenta = rsDetalles.DLRporcentajeBase EQ 0>
			<cfset Lvar_TotalIngresos = rsDetallesSumas.DLRingresos>
			<cfset Lvar_TotalDeduc	  = rsDetalles.DLRdeduccionPersonal + rsDetallesSumas.DLRigss+rsDetalles.DLRseguroVida+rsDetalles.DLRgastosMedicos+rsDetalles.DLRpensiones+rsDetallesSumas.DLRotrosGastos>
			<cfset Lvar_RentImponible  = Lvar_TotalIngresos - Lvar_TotalDeduc>
			<cfquery name="rsDatosRenta" datasource="#session.DSN#">
				select DIRporcentaje, DIRmontofijo, DIRinf
				from  EImpuestoRenta a
				inner join DImpuestoRenta b
					  on b.EIRid = a.EIRid
				where a.EIRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarEIRid#">
				  and <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_RentImponible#"> between DIRinf and DIRSup 
			</cfquery>
		</cfif>
	</cfif>
	<!--- FUNCION QUE OPTIENE EL PAGO DE LA EMPRESA PARA UN MES Y PERIODO ESPECIFICO --->
	<cffunction name="getPagoEmpresa" access="private" returntype="numeric">
		<cfargument name="lthisperiodo" type="numeric" required="true">
		<cfargument name="lthismes" type="numeric" required="true">
		<cfset var result=0.00>
		<cfquery name="rsPago" dbtype="query">
			select montopagoempresa as pagoEmpresa
			from rsPagos2
			where Periodo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.lthisperiodo#">
			and Mes=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.lthismes#">
		</cfquery>
		<cfif not (rsPago.recordcount gt 0 and len(trim(rsPago.pagoEmpresa)) gt 0)>
			<cfquery name="rsPago" dbtype="query">
				select sum( SEsalariobruto + SEincidencias - SEinorenta ) as pagoEmpresa
				from rsPagos1
				where CPperiodo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.lthisperiodo#">
				and CPmes=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.lthismes#">
			</cfquery>
		</cfif>
		<cfif rsPago.recordcount gt 0 and len(trim(rsPago.pagoEmpresa)) gt 0>
			<cfset result=rsPago.pagoEmpresa>
		</cfif>
		<cfset Lvar_PagoEmpresaAcum=Lvar_PagoEmpresaAcum+result>
		<cfreturn result>
	</cffunction>
	<!--- FUNCION QUE OBTIENE EL PAGO DE OTROS PARA UN MES Y PERIODO ESPECIFICO --->
	<cffunction name="getPagoOtros" access="private" returntype="numeric">
		<cfargument name="lthisperiodo" type="numeric" required="true">
		<cfargument name="lthismes" type="numeric" required="true">
		<cfset var result=0.00>
		<cfquery name="rsPago" dbtype="query">
			select montootrospagos as pagoOtros
			from rsPagos2
			where Periodo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.lthisperiodo#">
			and Mes=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.lthismes#">
		</cfquery>
		<cfif rsPago.recordcount gt 0 and len(trim(rsPago.pagoOtros)) gt 0>
			<cfset result=rsPago.pagoOtros>
		</cfif>
		<cfset Lvar_PagoOtrosAcum=Lvar_PagoOtrosAcum+result>
		<cfreturn result>
	</cffunction>
	<!--- FUNCION QUE OBTIENE EL PAGO DE RETENCIONES PARA UN MES Y PERIODO ESPECIFICO --->
	<cffunction name="getRetencionEmpresa" access="private" returntype="numeric">
		<cfargument name="lthisperiodo" type="numeric" required="true">
		<cfargument name="lthismes" type="numeric" required="true">
		<cfset var result=0.00>
		<cfquery name="rsPago" dbtype="query">
			select montoretencion as retencionEmpresa
			from rsPagos2
			where Periodo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.lthisperiodo#">
			and Mes=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.lthismes#">
		</cfquery>
		<cfif not (rsPago.recordcount gt 0 and len(trim(rsPago.retencionEmpresa)) gt 0)>
			<cfquery name="rsPago" dbtype="query">
				select sum( SErenta ) as retencionEmpresa
				from rsPagos1
				where CPperiodo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.lthisperiodo#">
				and CPmes=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.lthismes#">
			</cfquery>
		</cfif>
		<cfif rsPago.recordcount gt 0 and len(trim(rsPago.retencionEmpresa)) gt 0>
			<cfset result=rsPago.retencionEmpresa>
		</cfif>
		<cfset Lvar_RetencionEmpresaAcum=Lvar_RetencionEmpresaAcum+result>
		<cfreturn result>
	</cffunction>
	<!--- FUNCION QUE OBTIENE EL MONTO DE OTRAS RETENCIONES PARA UN MES Y PERIODO ESPECIFICO --->
	<cffunction name="getRetencionOtros" access="private" returntype="numeric">
		<cfargument name="lthisperiodo" type="numeric" required="true">
		<cfargument name="lthismes" type="numeric" required="true">
		<cfset var result=0.00>
		<cfquery name="rsPago" dbtype="query">
			select montootrasret as RetencionOtros
			from rsPagos2
			where Periodo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.lthisperiodo#">
			and Mes=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.lthismes#">
		</cfquery>
		<cfif rsPago.recordcount gt 0 and len(trim(rsPago.RetencionOtros)) gt 0>
			<cfset result=rsPago.RetencionOtros>
		</cfif>
		<cfset Lvar_RetencionOtrosAcum=Lvar_RetencionOtrosAcum+result>
		<cfreturn result>
	</cffunction>
</cfsilent>
<!---/-------------------------------------------------------------------------------------
-------------------------PORTLET DE EMPLEADO (REQUIERE EL FORM.DEID)-----------------------
--------------------------------------------------------------------------------------/--->
<cfinclude template="/rh/portlets/pEmpleado.cfm">
<!---/-------------------------------------------------------------------------------------
-------------------------PORTLET DE DEL FORMULARIO-----------------------------------------
--------------------------------------------------------------------------------------/--->
<cf_web_portlet_start><cfoutput>

	<cfif isdefined('form.EIRid') and LEN(TRIM(form.EIRid))>
	<!---/-------------------------------------------------------------------------------------
	-------------------------FILTRO DE TABLAS VIGENTES-----------------------------------------
	--------------------------------------------------------------------------------------/--->
	<table width="100%" align="left" border="0" cellpadding="0" cellspacing="0">
	<tr>
	<td>
		<table width="100%" align="left" border="0" cellpadding="0" cellspacing="0">	
			<form name="filtro1" action="liquidacionRenta.cfm" method="post" style="margin:0;">
				<tr>
					<td class="tituloListas" width="20%" align="left" nowrap><strong>#LB_Vigencias_de_Renta_sin_Liquidar# :</strong>&nbsp;</td>
					<td class="tituloListas" width="80%" align="left">
						<select name="EIRid" onchange="javascript:this.form.submit();">
							<cfloop query="rsIRs">
								<option value="#rsIRs.EIRid#" <cfif isdefined("form.EIRid") and form.EIRid eq rsIRs.EIRid>selected</cfif>>#rsIRs.IRcodigo#-#rsIRs.IRdescripcion# (#LSDateFormat(rsIRs.EIRdesde,'dd/mm/yyyy')#-#LSDateFormat(rsIRs.EIRhasta,'dd/mm/yyyy')#)</option>
							</cfloop>
						</select>
					</td>
				</tr>
			</form>
		</table>
	</td>
	</tr>
	<tr>
	<td>
			<!---/-------------------------------------------------------------------------------------
			-------------------------FORMULARIO DE CAPTURA DE LIQUIDACION------------------------------
			--------------------------------------------------------------------------------------/--->
			<table width="600" align="center" border="0" cellpadding="1" cellspacing="0">
				<form name="form1" action="liquidacionRentaDSql.cfm" method="post" style="margin:0;">
						<input type="hidden" id="EIRid" name="EIRid" value="#lvarEIRid#">
						<input type="hidden" id="DEid" name="DEid" value="#lvarDEid#">
					<cfif isdefined('rsDetalles') and rsDetalles.RecordCount>
						<tr>
							<td width="50%"><cf_translate key="LB_Ingresos">Ingresos</cf_translate></td>
							<td width="25%" align="right">&nbsp;</td>
							<td width="25%" align="right">
								<cfif isdefined('rsDetallesSumas') and rsDetallesSumas.RecordCount and rsDetallesSumas.DLRingresos GT 0>
									<cfset Lvar_TotalIngresos = rsDetallesSumas.DLRingresos>
								<cfelseif isdefined('rsTotalIngresos')>
									<cfset Lvar_TotalIngresos = rsTotalIngresos.Total>
								<cfelse>
									<cfset Lvar_TotalIngresos = 0.00>
								</cfif>
								<cf_monto name="DLRingresos" tabindex="-1" size="15" readonly="true"
									value="#Lvar_TotalIngresos#">
							</td>
						</tr>
						<tr>
							<td><cf_translate key="LB_DeduccionPersonal">Deducci&oacute;n Personal</cf_translate></td>
							<td align="right">
								<cfif isdefined('rsDetalles') and rsDetalles.RecordCount and rsDetalles.DLRdeduccionPersonal GT 0>
									<cfset Lvar_TotalRenta = rsDetalles.DLRdeduccionPersonal>
								</cfif>
								<cf_monto name="DeducPersonal" tabindex="-1" size="15" readonly="true"
									value="#Lvar_TotalRenta#">
								<!--- Este dato es el monto exento de acuerdo a la ley se toma del sistema de la tabla de renta --->
							</td>
							<td align="right">&nbsp;</td>
						</tr>
						<tr>
							<td><cf_translate key="LB_CargasSociales">IGSS</cf_translate></td>
							<td align="right">
								<cf_monto name="DLRigss" tabindex="-1" size="15" readonly="true"
									value="#rsDetallesSumas.DLRigss#">
							</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td><cf_translate key="LB_PrimaDeSegurosDeVida">Prima de Seguros de Vida</cf_translate></td>
							<td align="right">
								<cfif isdefined('rsDetalles')>
									<cfset Lvar_SeguroVida=rsDetalles.DLRseguroVida>
								<cfelse>
									<cfset Lvar_SeguroVida=0.00>
								</cfif>
								<cf_monto name="montoSeguro" tabindex="1" size="15" value="#Lvar_SeguroVida#" onchange="calcular()">
								<!--- <input name="montoSeguro" type="text" tabindex="1" value="" style="text-align:right" size="15" 
									onchange="javascript: calcular()"> --->
							</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td><cf_translate key="LB_GastosMedicos">Gastos M&eacute;dicos</cf_translate></td>
							<td align="right">
								<cfif isdefined('rsDetalles')>
									<cfset Lvar_GastosMed = rsDetalles.DLRgastosMedicos>
								</cfif>
								<cf_monto name="montoGastosMedicos" tabindex="1" size="15" value="#Lvar_GastosMed#" onchange="calcular()">
							</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td><cf_translate key="LB_PensionesAlimenticiasFondoDePensiones">Pensiones Alimenticias, Fondo de Pensiones</cf_translate></td>
							<td align="right">
								<cfif isdefined('rsDetalles')>
									<cfset Lvar_Pensiones = rsDetalles.DLRpensiones>
								</cfif>
								<cf_monto name="montoPensiones" tabindex="1" size="15" value="#Lvar_Pensiones#" onchange="calcular()">
							</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td><cf_translate key="LB_OtrosGastos">Otros Gastos:B-14,Agui.,Colegiatura,Donacion</cf_translate></td>
							<td align="right">
								<cf_monto name="DLRotrosGastos" tabindex="-1" size="15" readonly="true" onchange="calcular()"
									value="#rsDetallesSumas.DLRotrosGastos#">
								<!--- Es la suma de lo ganado por el Empleado en Bono 14 y Aguinaldo para el periodo de calculo de la liquidacion de esa renta --->
							</td>
							<td>&nbsp;</td>
						</tr>
						<tr><td></td><td height="1" bgcolor="000000" colspan="2"></td>
						<cfset Lvar_Deducciones = Lvar_TotalIngresos - (Lvar_TotalRenta + Lvar_SeguroVida + Lvar_GastosMed + rsDetallesSumas.DLRigss + rsDetallesSumas.DLRotrosGastos + Lvar_Pensiones)>
						<tr>
							<td align="right"><strong><cf_translate key="LB_TotalDeDeducciones">Total de Deducciones</cf_translate></strong></td>
							<td>&nbsp;</td>
							<td align="right">
								<cf_monto name="totalDeduc" tabindex="-1" size="15" readonly="true"
									value="#Lvar_Deducciones#">
							</td>
						</tr>
						<tr>
							<td align="right"><strong><cf_translate key="LB_RentaImponibleOPerdidaFiscal">Renta Imponible o P&eacute;dida Fiscal</cf_translate></strong></td>
							<td>&nbsp;</td>
							<td align="right">
								<cf_monto name="rentaImponible" tabindex="-1" size="15" readonly="true"
									value="0.00">
							</td>
						</tr>
						<tr><td colspan="3">&nbsp;</td></tr>
						<tr>
							<td><cf_translate key="LB_Base">%Base</cf_translate></td>
							<td align="right">
								<cfif isdefined('rsDetalles') and rsDetalles.DLRporcentajeBase NEQ 0>
									<cfset Lvar_porcBase = rsDetalles.DLRporcentajeBase>
								<cfelse>
									<cfset Lvar_porcBase = rsDatosRenta.DIRporcentaje>
								</cfif>
								<cf_monto name="porcBase" tabindex="1" size="15" value="#Lvar_porcBase#" readonly="true">	
							</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td><cf_translate key="LB_DeduccionDeLaBase">Deducci&oacute;n de la Base</cf_translate></td>
							<td align="right">
								<cfset Lvar_DeducBase = 0>
								<cfif isdefined('rsDetalles') and rsDetalles.RecordCount and rsDetalles.DLRporcentajeBase GT 0>
									<cfset Lvar_DeducBase = rsDetalles.DLRdeduccionBase>
								<cfelse>
									<cfset Lvar_DeducBase = rsDatosRenta.DIRinf>
								</cfif>
								<cf_monto name="DeducBase" tabindex="-1" size="15" readonly="true"
									value="#Lvar_DeducBase#">
							</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td><cf_translate key="LB_ImpuestoFijo">Impuesto Fijo</cf_translate></td>
							<td align="right">
								<cfset Lvar_ImpuestoFijo = 0>
								<cfif isdefined('rsDetalles') and rsDetalles.RecordCount and rsDetalles.DLRporcentajeBase GT 0>
									<cfset Lvar_ImpuestoFijo = rsDetalles.DLRimpuestoFijo>
								<cfelse>
									<cfset Lvar_ImpuestoFijo = rsDatosRenta.DIRmontofijo>
								</cfif>
								<cf_monto name="ImpuestoFijo" tabindex="-1" size="15" readonly="true"
									value="#Lvar_ImpuestoFijo#">
							</td>
							<td>&nbsp;</td>
						</tr>
						<tr><td></td><td height="1" bgcolor="000000" colspan="2"></td>
						<tr>
							<td align="right"><strong><cf_translate key="LB_TotalImpuesto">Total Impuesto</cf_translate></strong></td>
							<td>&nbsp;</td>
							<td align="right">
								<cfif isdefined('rsDetalles') and rsDetalles.RecordCount>
									<cfset Lvar_TotalImpuesto = 0.00>
								<cfelse>
									<cfset Lvar_TotalImpuesto = 0.00>
								</cfif>
								<cf_monto name="totalImpuesto" tabindex="-1" size="15" readonly="true"
									value="0.00">
							</td>
						</tr>
						<tr>
							<td><cf_translate key="LB_Retenciones">Retenciones</cf_translate></td>
							<td>&nbsp;</td>
							<td align="right">
								<cfset Lvar_Retenciones = 0>
								<cfif isdefined('rsDetallesSumas') and rsDetallesSumas.RecordCount and rsDetallesSumas.DLRretenciones GT 0>
									<cfset Lvar_Retenciones = rsDetallesSumas.DLRretenciones>
								</cfif>
								<cf_monto name="Retenciones" tabindex="-1" size="15" readonly="true"
									value="#Lvar_Retenciones#">
							</td>
						</tr>
						<tr>
							<td><cf_translate key="LB_CreditoPorIva">Cr&eacute;dito por Iva</cf_translate></td>
							<td>&nbsp;</td>
							<td align="right">
								<cfif isdefined('rsDetalles')>
									<cfset Lvar_CreditoIva=rsDetalles.DLRcreditoIva>
								<cfelse>
									<cfset Lvar_CreditoIva = 0.00>
								</cfif>
								<cf_monto name="CreditoIva" tabindex="1" size="15" value="#Lvar_CreditoIva#" onchange="calcular()">
							</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td align="right">
								<cf_monto name="calculoTotal" tabindex="-1" size="15" readonly="true"
									value="0.00">
							</td>
						</tr>
						<tr>
							<td align="right"><strong><cf_translate key="LB_ImpuestoARetener">Impuesto a Retener</cf_translate></strong></td>
							<td>&nbsp;</td>
							<td align="right">
								<cf_monto name="ImpuestoRet" tabindex="-1" size="15" readonly="true"
									value="0.00">
							</td>
						</tr>
						<tr>
							<td align="right"><strong><cf_translate key="LB_ORetenidoEnExceso">O Retenido en Exceso</cf_translate></strong></td>
							<td>&nbsp;</td>
							<td align="right">
								<cf_monto name="Exceso" tabindex="-1" size="15" readonly="true"
									value="0.00">
							</td>
						</tr>
						<tr><td colspan="3">&nbsp;</td></tr>
						<tr>
							<td colspan="3">
								<cfset Lista_Botones = 'Guardar'>
								<cfif not Lvar_ValidaDatosRenta><cfset Lista_Botones = 'Guardar,Aplicar'></cfif>
								<cf_botones values="#Lista_Botones#" tabindex="1">
								
							</td>
						</tr>
					<cfelse>
						<tr><td colspan="3" align="center"><cf_botones values="Generar" tabindex="3"></td></tr>
					</cfif>
				</form>
			</table>
		</table>
	</td>
	</tr>
	</table>
	<!---/-------------------------------------------------------------------------------------
	-------------------------FUNCIONES GENERALES DE JAVASCRIPT---------------------------------
	--------------------------------------------------------------------------------------/--->
	<script language="javascript" type="text/javascript">
		/*funcion aplicar*/
		function funcAplicar(){
			return confirm("#MSGJS__Confirma_que_desea_aplicar_la_liquidacion_de_Renta_#");
		}
		/*funcion que valida que los campos sean positivos*/
		function esPositivo(){
			if (!objForm._allowSubmitOnError){
				if (parseFloat(qf(this.value))<0.00){
					this.error = '#MSGJS_El_valor_de_#' + this.description + '#MSGJS_debe_ser_mayor_que_cerop#';
				}
			}
		}
		/*FUNCION QUE CALCULA LA LIQUIDACION CUANDO SE HACE ALGUN CAMBIO EN ALGUNO DE LOS RUBROS QUE SE PUEDEN  MODIFICAR.*/


		function calcular(){
			var f = document.form1;
			var porcB = parseFloat(qf(f.porcBase.value));
			var rentaI = parseFloat(qf(f.rentaImponible.value));
			var deducB = parseFloat(qf(f.DeducBase.value));
			var ImpFijo = parseFloat(qf(f.ImpuestoFijo.value));
			var retencion = parseFloat(qf(f.Retenciones.value));
			var creditoIva = parseFloat(qf(f.CreditoIva.value));
			var totalImp,monto,p; 
			f.totalDeduc.value = fm((parseFloat(qf(f.DeducPersonal.value))+parseFloat(qf(f.DLRigss.value))+parseFloat(qf(f.montoSeguro.value))+parseFloat(qf(f.montoGastosMedicos.value))+parseFloat(qf(f.montoPensiones.value))+parseFloat(qf(f.DLRotrosGastos.value))),2); 
			f.rentaImponible.value = fm(parseFloat(qf(f.DLRingresos.value)) - parseFloat(qf(f.totalDeduc.value)),2);
			rentaI = parseFloat(qf(f.rentaImponible.value));
			totalImp= redondear((rentaI * (porcB/100.00)) + ImpFijo - deducB,2);
			f.totalImpuesto.value = fm(totalImp,2);
			<!--- EL MONTO DEL CRÉDITO IVA POR DEFECTO ES IGUAL AL TOTAL DEL IMPUESTO PERO SI EL MONTO PRESENTADO ES MENOR ENTONCES SE TOMA EN CUENTA EL PRESENTADO. --->
			if (f.CreditoIva.value > f.totalImpuesto.value){
			creditoIva = parseFloat(qf(f.totalImpuesto.value));
			f.CreditoIva.value = f.totalImpuesto.value;
			}
			monto = totalImp - (retencion + creditoIva);
			f.calculoTotal.value = fm(monto,2);
			if(monto >= 0){
				f.ImpuestoRet.value = fm(monto,2);
				f.Exceso.value = 0.00;
			}else{
				f.ImpuestoRet.value = 0.00;
				f.Exceso.value = fm(Math.abs(monto),2);
			}
		}
		<cfif isdefined('rsDetalles') and rsDetalles.RecordCount>
		calcular();
		document.form1.montoSeguro.focus();
		</cfif>
	</script>
	<cf_qforms>
	</cf_qforms>
	<cfelse>
		<table width="100%" align="center" border="0" cellpadding="0" cellspacing="0">
			<tr><td>&nbsp;</td></tr>
			<tr><td align="center"><cfoutput>#MSG_ERROR_EIRid#</cfoutput></td></tr>
			<tr><td>&nbsp;</td></tr>
		</table>
	</cfif>
	<!---/-------------------------------------------------------------------------------------
	-------------------------VALIDACIONES DE QFORMS--------------------------------------------
	--------------------------------------------------------------------------------------/--->
	
<cf_web_portlet_end></cfoutput>