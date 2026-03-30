<!---/-------------------------------------------------------------------------------------
-------------------------FORMULARIO DE CAPTURA DE LIQUIDACION------------------------------
--------------------------------------------------------------------------------------/--->
<cfsilent>
	<!---/-------------------------------------------------------------------------------------
	------------------------------OBTIENE LAS TRADUCCIONES DE LAS------------------------------
	------------------------------ETIQUETAS Y MENSAJES UTILIZADOS------------------------------
	--------------------------------------------------------------------------------------/--->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="MSG_ERROR_DEID"
		default="Error. No se encontr&oacute; el Empleado Asociado con su Usuario!"
		returnvariable="MSG_ERROR_DEID"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="MSGJS_ERROR_DEID"
		default="El usuario que accesó la aplicación no esta registrado como empleado de la empresa en la cual ingresó."
		returnvariable="MSGJS_ERROR_DEID"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="MSG_ERROR_DEID"
		default="No hay vigencias de renta para aplicar."
		returnvariable="MSG_ERROR_EIRid"/>
	<!---Error. No se encontr&oacute; Vigencias de Renta Sin Aplicar!--->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="MSGJS_ERROR_DEID"
		default="Error. No se encontró Vigencias de Renta Sin Aplicar!"
		returnvariable="MSGJS_ERROR_EIRid"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Vigencias_de_Renta_sin_Liquidar"
		default="Vigencias de Renta sin Liquidar"
		returnvariable="LB_Vigencias_de_Renta_sin_Liquidar"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Pago"
		default="Pago"
		returnvariable="LB_Pago"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LBJS_Pago"
		default="Pago"
		returnvariable="LBJS_Pago"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Retencion"
		default="Retenci&oacute;n"
		returnvariable="LB_Retencion"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LBJS_Retencion"
		default="Retención"
		returnvariable="LBJS_Retencion"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Pagos"
		default="Pagos"
		returnvariable="LB_Pagos"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Retenciones"
		default="Retenciones"
		returnvariable="LB_Retenciones"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Empresa"
		default="Empresa"
		returnvariable="LB_Empresa"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Otros"
		default="Otros"
		returnvariable="LB_Otros"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Total"
		default="Total"
		returnvariable="LB_Total"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Anno"
		default="A&ntilde;o"
		returnvariable="LB_Anno"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="LB_Mes"
		default="Mes"
		returnvariable="LB_Mes"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="MSGJS_El_valor_de_"
		default="El valor de "
		returnvariable="MSGJS_El_valor_de_"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="MSGJS_debe_ser_mayor_que_cerop"
		default="debe ser mayor que cero."
		returnvariable="MSGJS_debe_ser_mayor_que_cerop"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		key="MSGJS__Confirma_que_desea_aplicar_este_liquidacion_de_Renta_"
		default="¿Confirma que desea aplicar este liquidación de Renta?"
		returnvariable="MSGJS__Confirma_que_desea_aplicar_este_liquidacion_de_Renta_"/>
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
	<cfquery name="rsIRc" datasource="#session.dsn#">
		select Pvalor as IRcodigo
		from RHParametros 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#"> 
		and Pcodigo = 30
	</cfquery>
	<cfquery name="rsEIRidsaplicados" datasource="#session.dsn#">
		select EIRid 
	  	from RHLiquidacionRenta
	  	where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarDEid#">
	  	and Estado = 10
	</cfquery>
	<cfquery name="rsIRs" datasource="sifcontrol">
		select a.EIRid, 
			<cf_dbfunction name="date_part" args="mm,a.EIRdesde"> as mesDesde,
			<!--- datepart(mm,a.EIRdesde) as mesDesde, --->
			<cf_dbfunction name="date_part" args="yy,a.EIRdesde"> as periodoDesde,
			<!--- datepart(yy,a.EIRdesde) as periodoDesde,  --->
			<cf_dbfunction name="date_part" args="mm,a.EIRhasta"> as mesHasta,
			<!--- datepart(mm,a.EIRhasta) as mesHasta,  --->
			<cf_dbfunction name="date_part" args="yy,a.EIRhasta"> as periodoHasta,
			<!--- datepart(yy,a.EIRhasta) as periodoHasta,  --->
			b.IRcodigo, 
			b.IRdescripcion, a.EIRdesde, a.EIRhasta
		from EImpuestoRenta a
			inner join ImpuestoRenta b
			on a.IRcodigo = b.IRcodigo
		where a.IRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsIRc.IRcodigo#">
		  and not <cf_whereInList Column="a.EIRid" ValueList="#ValueList(rsEIRidsaplicados.EIRid)#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfif rsIRs.recordcount eq 0>
		<cf_throw message="#MSG_ERROR_EIRid#" errorcode="5060">
	</cfif>
	<cfif (isdefined("Url.EIRid") and len(trim(Url.EIRid)) gt 0 and Url.EIRid gt 0)>
		<cfset Form.EIRid = Url.EIRid>
	</cfif>
	<cfif not (isdefined("Form.EIRid") and len(trim(Form.EIRid)) gt 0 and Form.EIRid gt 0)>
		<cfset Form.EIRid = rsIRs.EIRid>
	</cfif>
	<!---/-------------------------------------------------------------------------------------
	-------------------------OBTIENE LA TABLA DE RENTA SELECCIONADA----------------------------
	--------------------------------------------------------------------------------------/--->
	<cfquery name="rsIR" datasource="sifcontrol">
		select a.EIRid, 
			
			<cf_dbfunction name="date_part" args="mm,a.EIRdesde"> as mesDesde, 
			<!--- datepart(mm,a.EIRdesde) as mesDesde,  --->
			<cf_dbfunction name="date_part" args="yyyy,a.EIRdesde"> as periodoDesde, 
			<!--- datepart(yy,a.EIRdesde) as periodoDesde,  --->
			<cf_dbfunction name="date_part" args="mm,a.EIRdesde">-1 as mesHasta,
			<!--- datepart(mm,a.EIRdesde)-1 as mesHasta,  --->
			<cf_dbfunction name="date_part" args="yyyy,a.EIRdesde">+1 as periodoHasta,
			<!--- datepart(yy,a.EIRdesde)+1 as periodoHasta,  --->
			b.IRcodigo, 
			b.IRdescripcion
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
		select CPperiodo, CPmes, SEsalariobruto, SEincidencias, SEinorenta, SErenta
		from CalendarioPagos a
			inner join HSalarioEmpleado b
			on b.RCNid = a.CPid
			and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarDEid#">
		where a.CPperiodo between <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarPeriodoDesde#">
				and <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarPeriodoHasta#">
	</cfquery>
	<cfquery name="rsPagos2"  datasource="#session.dsn#">
		select Periodo, Mes, montopagoempresa, montootrospagos, montoretencion, montootrasret
		from RHLiquidacionRenta
		where EIRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarEIRid#">
			and DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarDEid#">
			and Periodo between <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarPeriodoDesde#">
				and <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarPeriodoHasta#">
	</cfquery>
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
		<table width="100%" align="left" border="0" cellpadding="0" cellspacing="0">
			<form name="form1" action="liquidacionRentaSql.cfm" method="post" style="margin:0;">
				<input type="hidden" id="EIRid" name="EIRid" value="#lvarEIRid#">
				<input type="hidden" id="DEid" name="DEid" value="#lvarDEid#">
				<tr>
					<!--- Pagos --->
					<td class="tituloListas">&nbsp;</td>
					<td class="tituloListas">&nbsp;</td>
					<td colspan="3" align="center" class="tituloListas" style="padding: 2px; border-right-width: 2px; border-right-style: solid; border-right-color: ##000000;border-bottom-width: 2px; border-bottom-style: solid; border-bottom-color: ##000000;">#LB_Pagos#</td>
					<!--- Retenciones --->
					<td colspan="3" align="center" class="tituloListas" style="border-bottom-width: 2px; border-bottom-style: solid; border-bottom-color: ##000000;">#LB_Retenciones#</td>
				</tr>
				<tr>
					<!--- Pagos --->
					<td class="tituloListas">#LB_Anno#</td>
					<td class="tituloListas">#LB_Mes#</td>
					<td align="right" class="tituloListas">#LB_Empresa#</td>
					<td align="right" class="tituloListas">#LB_Otros#</td>
					<td align="right" class="tituloListas" style="padding: 2px; border-right-width: 2px; border-right-style: solid; border-right-color: ##000000;">#LB_Total#</td>
					<!--- Retenciones --->
					<td align="right" class="tituloListas">#LB_Empresa#</td>
					<td align="right" class="tituloListas">#LB_Otros#</td>
					<td align="right" class="tituloListas">#LB_Total#</td>
				</tr>
				<cffunction name="pintarLinea" access="private">
					<cfargument name="periodo" type="numeric" required="true">
					<cfargument name="mes" type="numeric" required="true">
					<cfargument name="pagoEmpresa" type="numeric" required="true">
					<cfargument name="pagoOtros" type="numeric" required="true">
					<cfargument name="pagoTotal" type="numeric" required="true">
					<cfargument name="retencionEmpresa" type="numeric" required="true">
					<cfargument name="retencionOtros" type="numeric" required="true">
					<cfargument name="retencionTotal" type="numeric" required="true">
					<cfset LvarListaNon = (mes MOD 2)>
					<cfset LvarClassName = IIf(LvarListaNon, DE('listaNon'), DE('listaPar'))>
					<tr class="#LvarClassName#">
						<!--- Pagos --->
						<td>#arguments.periodo#</td>
						<td>#getMonthName(arguments.mes)#</td>
						<td align="right"><cf_inputNumber name="pagoEmpresa#arguments.periodo##arguments.mes#" value="#arguments.pagoEmpresa#" decimales="2" modificable="false" style="border: 0; background-color: transparent;"></td>
						<td align="right"><cf_inputNumber tabindex="1" name="pagoOtros#arguments.periodo##arguments.mes#" value="#arguments.pagoOtros#" decimales="2"></td>
						<td align="right" style="padding: 2px; border-right-width: 2px; border-right-style: solid; border-right-color: ##000000;">
										  <cf_inputNumber name="pagoTotal#arguments.periodo##arguments.mes#" value="#arguments.pagoTotal#" decimales="2" modificable="false" style="border: 0; background-color: transparent;"></td>
						<!--- Retenciones --->
						<td align="right"><cf_inputNumber name="retencionEmpresa#arguments.periodo##arguments.mes#" value="#arguments.retencionEmpresa#" decimales="2" modificable="false" style="border: 0; background-color: transparent;"></td>
						<td align="right"><cf_inputNumber tabindex="2" name="retencionOtros#arguments.periodo##arguments.mes#" value="#arguments.retencionOtros#" decimales="2"></td>
						<td align="right"><cf_inputNumber name="retencionTotal#arguments.periodo##arguments.mes#" value="#arguments.retencionTotal#" decimales="2" modificable="false" style="border: 0; background-color: transparent;"></td>
					</tr>
				</cffunction>
				<cfset Lvar_PagoEmpresaAcum = 0.00>
				<cfset Lvar_PagoOtrosAcum = 0.00>
				<cfset Lvar_RetencionEmpresaAcum = 0.00>
				<cfset Lvar_RetencionOtrosAcum = 0.00>
				<cfloop from="#lvarPeriodoDesde#" to="#lvarPeriodoHasta#" index="lthisperiodo">
					<cfif lthisperiodo eq lvarPeriodoDesde and lthisperiodo lt lvarPeriodoHasta>
						<cfloop from="#lvarMesDesde#" to="12" index="lthismes">
							<cfset lthispagoempresa=getPagoEmpresa(lthisperiodo,lthismes)>
							<cfset lthispagootros=getPagoOtros(lthisperiodo,lthismes)>
							<cfset lthisretencionempresa=getRetencionEmpresa(lthisperiodo,lthismes)>
							<cfset lthisretencionotros=getRetencionOtros(lthisperiodo,lthismes)>
							#pintarLinea(lthisperiodo,lthismes,lthispagoempresa,lthispagootros,lthispagoempresa+lthispagootros,lthisretencionempresa,lthisretencionotros,lthisretencionempresa+lthisretencionotros)#
						</cfloop>
					<cfelseif lthisperiodo gt lvarPeriodoDesde and lthisperiodo lt lvarPeriodoHasta>
						<cfloop from="1" to="12" index="lthismes">
							<cfset lthispagoempresa=getPagoEmpresa(lthisperiodo,lthismes)>
							<cfset lthispagootros=getPagoOtros(lthisperiodo,lthismes)>
							<cfset lthisretencionempresa=getRetencionEmpresa(lthisperiodo,lthismes)>
							<cfset lthisretencionotros=getRetencionOtros(lthisperiodo,lthismes)>
							#pintarLinea(lthisperiodo,lthismes,lthispagoempresa,lthispagootros,lthispagoempresa+lthispagootros,lthisretencionempresa,lthisretencionotros,lthisretencionempresa+lthisretencionotros)#
						</cfloop>
					<cfelseif lthisperiodo gt lvarPeriodoDesde and lthisperiodo eq lvarPeriodoHasta>
						<cfloop from="1" to="#lvarMesHasta#" index="lthismes">
							<cfset lthispagoempresa=getPagoEmpresa(lthisperiodo,lthismes)>
							<cfset lthispagootros=getPagoOtros(lthisperiodo,lthismes)>
							<cfset lthisretencionempresa=getRetencionEmpresa(lthisperiodo,lthismes)>
							<cfset lthisretencionotros=getRetencionOtros(lthisperiodo,lthismes)>
							#pintarLinea(lthisperiodo,lthismes,lthispagoempresa,lthispagootros,lthispagoempresa+lthispagootros,lthisretencionempresa,lthisretencionotros,lthisretencionempresa+lthisretencionotros)#
						</cfloop>
					</cfif>
				</cfloop>
				<tr class="#LvarClassName#">
					<!--- Pagos --->
					<td class="tituloListas"><strong>#LB_Total#</strong></td>
					<td class="tituloListas"></td><strong>&nbsp;</strong></td>
					<td align="right" class="tituloListas" style="border-top-width: 2px; border-top-style: solid; border-top-color: ##000000;"><strong>#LSCurrencyFormat(Lvar_pagoEmpresaAcum,'none')#</strong></td>
					<td align="right" class="tituloListas" style="border-top-width: 2px; border-top-style: solid; border-top-color: ##000000;"><strong>#LSCurrencyFormat(Lvar_pagoOtrosAcum,'none')#</strong></td>
					<td align="right" class="tituloListas" style="border-top-width: 2px; border-top-style: solid; border-top-color: ##000000; padding: 2px; border-right-width: 2px; border-right-style: solid; border-right-color: ##000000;">
									  <strong>#LSCurrencyFormat(Lvar_pagoEmpresaAcum+Lvar_pagoOtrosAcum,'none')#</strong></td>
					<!--- Retenciones --->
					<td align="right" class="tituloListas" style="border-top-width: 2px; border-top-style: solid; border-top-color: ##000000;"><strong>#LSCurrencyFormat(Lvar_retencionEmpresaAcum,'none')#</strong></td>
					<td align="right" class="tituloListas" style="border-top-width: 2px; border-top-style: solid; border-top-color: ##000000;"><strong>#LSCurrencyFormat(Lvar_retencionOtrosAcum,'none')#</strong></td>
					<td align="right" class="tituloListas" style="border-top-width: 2px; border-top-style: solid; border-top-color: ##000000;"><strong>#LSCurrencyFormat(Lvar_retencionEmpresaAcum+Lvar_retencionOtrosAcum,'none')#</strong></td>
				</tr>
				<tr><td colspan="8"><cf_botones values="Guardar,Aplicar" tabindex="3"></td></tr>					
			</form>
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
			return confirm("#MSGJS__Confirma_que_desea_aplicar_este_liquidacion_de_Renta_#");
		}
		/*funcion que valida que los campos sean positivos*/
		function esPositivo(){
			if (!objForm._allowSubmitOnError){
				if (parseFloat(qf(this.value))<0.00){
					this.error = '#MSGJS_El_valor_de_#' + this.description + '#MSGJS_debe_ser_mayor_que_cerop#';
				}
			}
		}
		/*funcion que actualiza*/
		function funcActualizaPago(){
			var pagoEmpresa_value = 0.00;
			var pagoOtros_value = 0.00;
			var pagoTotal_value = 0.00;
			<!--- var pagoEmpresaAcum_value = parseFloat(qf(document.form1.pagoEmpresaAcum.value)); --->
			var pagoOtrosAcum_value = 0.00;
			var pagoTotalAcum_value = 0.00;			
			function fnActualizaRet(x,y){
				/*calculos*/
				pagoEmpresa_value = parseFloat(qf(eval('document.form1.pagoEmpresa'+x+y+'.value')));
				pagoOtros_value = parseFloat(qf(eval('document.form1.pagoOtros'+x+y+'.value')));
				pagoTotal_value = pagoEmpresa_value + pagoOtros_value;
				pagoOtrosAcum_value = pagoOtrosAcum_value + pagoOtros_value;
				/*asignaciones*/
				eval('document.form1.pagoTotal'+x+y+'.value="'+fm(pagoTotal_value,2)+'"');
			}			
			for (var i=#lvarPeriodoDesde#;i<=#lvarPeriodoHasta#;i++) {
				if (i == #lvarPeriodoDesde# && i < #lvarPeriodoHasta#){
					for (var j=#lvarMesDesde#;j<=12;j++) {
						fnActualizaRet(i,j);
					}
				} else if (i > #lvarPeriodoDesde# && i < #lvarPeriodoHasta#){
					for (var j=1;j<=12;j++) {
						fnActualizaRet(i,j)
					}
				} else if (i > #lvarPeriodoDesde# && i == #lvarPeriodoHasta#){
					for (var j=1;j<=#lvarMesHasta#;j++) {
						fnActualizaRet(i,j);
					}
				}
			}
			/*calculos*/
			<!--- pagoTotalAcum_value = pagoEmpresaAcum_value + pagoOtrosAcum_value; --->
			/*asignaciones*/
			<!--- document.form1.pagoOtrosAcum.value=fm(pagoOtrosAcum_value,2);
			document.form1.pagoTotalAcum.value=fm(pagoTotalAcum_value,2); --->
		}
		function funcActualizaRetencion(){
			var retencionEmpresa_value = 0.00;
			var retencionOtros_value = 0.00;
			var retencionTotal_value = 0.00;
			<!--- var retencionEmpresaAcum_value = parseFloat(qf(document.form1.retencionEmpresaAcum.value)); --->
			var retencionOtrosAcum_value = 0.00;
			var retencionTotalAcum_value = 0.00;			
			function fnActualizaRet(x,y){
				/*calculos*/
				retencionEmpresa_value = parseFloat(qf(eval('document.form1.retencionEmpresa'+x+y+'.value')));
				retencionOtros_value = parseFloat(qf(eval('document.form1.retencionOtros'+x+y+'.value')));
				retencionTotal_value = retencionEmpresa_value + retencionOtros_value;
				retencionOtrosAcum_value = retencionOtrosAcum_value + retencionOtros_value;
				/*asignaciones*/
				eval('document.form1.retencionTotal'+x+y+'.value="'+fm(retencionTotal_value,2)+'"');
			}			
			for (var i=#lvarPeriodoDesde#;i<=#lvarPeriodoHasta#;i++) {
				if (i == #lvarPeriodoDesde# && i < #lvarPeriodoHasta#){
					for (var j=#lvarMesDesde#;j<=12;j++) {
						fnActualizaRet(i,j);
					}
				} else if (i > #lvarPeriodoDesde# && i < #lvarPeriodoHasta#){
					for (var j=1;j<=12;j++) {
						fnActualizaRet(i,j)
					}
				} else if (i > #lvarPeriodoDesde# && i == #lvarPeriodoHasta#){
					for (var j=1;j<=#lvarMesHasta#;j++) {
						fnActualizaRet(i,j);
					}
				}
			}
			/*calculos*/
			<!--- retencionTotalAcum_value = retencionEmpresaAcum_value + retencionOtrosAcum_value; --->
			/*asignaciones*/
			<!--- document.form1.retencionOtrosAcum.value=fm(retencionOtrosAcum_value,2);
			document.form1.retencionTotalAcum.value=fm(retencionTotalAcum_value,2); --->
		}
		/*funciones individuales*/
		<cfloop from="#lvarPeriodoDesde#" to="#lvarPeriodoHasta#" index="lthisperiodo">
			<cfif lthisperiodo eq lvarPeriodoDesde and lthisperiodo lt lvarPeriodoHasta>
				<cfloop from="#lvarMesDesde#" to="12" index="lthismes">
					function funcpagoOtros#lthisperiodo##lthismes#(){funcActualizaPago()}
					function funcretencionOtros#lthisperiodo##lthismes#(){funcActualizaRetencion()}
				</cfloop>
			<cfelseif lthisperiodo gt lvarPeriodoDesde and lthisperiodo lt lvarPeriodoHasta>
				<cfloop from="1" to="12" index="lthismes">
					function funcpagoOtros#lthisperiodo##lthismes#(){funcActualizaPago()}
					function funcretencionOtros#lthisperiodo##lthismes#(){funcActualizaRetencion()}
				</cfloop>
			<cfelseif lthisperiodo gt lvarPeriodoDesde and lthisperiodo eq lvarPeriodoHasta>
				<cfloop from="1" to="#lvarMesHasta#" index="lthismes">
					function funcpagoOtros#lthisperiodo##lthismes#(){funcActualizaPago()}
					function funcretencionOtros#lthisperiodo##lthismes#(){funcActualizaRetencion()}
				</cfloop>
			</cfif>
		</cfloop>
		/*define foco inicial*/
		document.form1.pagoOtros#lvarPeriodoDesde##lvarMesDesde#.focus();
	</script>
	<!---/-------------------------------------------------------------------------------------
	-------------------------VALIDACIONES DE QFORMS--------------------------------------------
	--------------------------------------------------------------------------------------/--->
	<cf_qforms>
		<cfloop from="#lvarPeriodoDesde#" to="#lvarPeriodoHasta#" index="lthisperiodo">
			<cfif lthisperiodo eq lvarPeriodoDesde and lthisperiodo lt lvarPeriodoHasta>
				<cfloop from="#lvarMesDesde#" to="12" index="lthismes">
					<cf_qformsrequiredfield args="pagoOtros#lthisperiodo##lthismes#,#LBJS_Pago# #lthisperiodo# #getMonthName(lthismes)# ,esPositivo,false"/>
					<cf_qformsrequiredfield args="retencionOtros#lthisperiodo##lthismes#,#LBJS_Retencion# #lthisperiodo# #getMonthName(lthismes)# ,esPositivo,false"/>
				</cfloop>
			<cfelseif lthisperiodo gt lvarPeriodoDesde and lthisperiodo lt lvarPeriodoHasta>
				<cfloop from="1" to="12" index="lthismes">
					<cf_qformsrequiredfield args="pagoOtros#lthisperiodo##lthismes#,#LBJS_Pago# #lthisperiodo# #getMonthName(lthismes)# ,esPositivo,false"/>
					<cf_qformsrequiredfield args="retencionOtros#lthisperiodo##lthismes#,#LBJS_Retencion# #lthisperiodo# #getMonthName(lthismes)# ,esPositivo,false"/>
				</cfloop>
			<cfelseif lthisperiodo gt lvarPeriodoDesde and lthisperiodo eq lvarPeriodoHasta>
				<cfloop from="1" to="#lvarMesHasta#" index="lthismes">
					<cf_qformsrequiredfield args="pagoOtros#lthisperiodo##lthismes#,#LBJS_Pago# #lthisperiodo# #getMonthName(lthismes)# ,esPositivo,false"/>
					<cf_qformsrequiredfield args="retencionOtros#lthisperiodo##lthismes#,#LBJS_Retencion# #lthisperiodo# #getMonthName(lthismes)# ,esPositivo,false"/>
				</cfloop>
			</cfif>
		</cfloop>
	</cf_qforms>
	
<cf_web_portlet_end></cfoutput>