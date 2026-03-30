<cfinclude template="../../Utiles/sifConcat.cfm">

<!--- Function recalculaMontos --->
<cffunction name="recalculaMontos">
	<cfargument name="id" type="numeric" required="yes">

	<cfquery datasource="#session.DSN#">
		update DSolicitudCompraCM
		set DStotallinest = round(DScant * DSmontoest,2)
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.id#">
	</cfquery>

</cffunction>

<cfif isdefined("Form.chk") and Len(Trim(Form.chk))>
	<cfset Form.ESidsolicitud = Form.chk>
</cfif>

<!--- Verificaciones de la Solicitud de Orden de Compra Directa --->

<!--- Recalcula el campo DSlinmontoest para todas las lineas--->
<cfset recalculaMontos(form.ESidsolicitud) >

<cfquery name="dataSolicitud" datasource="#session.DSN#">
	select a.EStotalest, a.Mcodigo, a.EStipocambio, a.SNcodigo, b.CMTScompradirecta
	from ESolicitudCompraCM	a, CMTiposSolicitud b
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESidsolicitud#">
		and a.Ecodigo = b.Ecodigo
		and a.CMTScodigo = b.CMTScodigo
</cfquery>
<!--- Valida que si el tipo de solicitud es de compra directa, debe solicitarse el proveedor --->
<cfif dataSolicitud.CMTScompradirecta EQ 1 and Len(Trim(dataSolicitud.SNcodigo)) EQ 0>
	<cf_errorCode	code = "50301" msg = "El tipo de solicitud es de compra directa y requiere de proveedor!">
</cfif>

<!--- Valida que el monto de la solicitud de compra sea mayor a cero --->
<cfif dataSolicitud.EStotalest lte 0>
	<cf_errorCode	code = "50302" msg = "El monto de la solicitud debe ser mayor que cero!">
</cfif>

<!--- Inicializacion de Componente de Aplicacion de Solicitudes --->
<cfinvoke component="sif.Componentes.CM_AplicaSolicitud" method="init" returnvariable="aplica">

<!--- Valida que el monto de la solicitud no sea mayor al monto maximo definido para --->
<!--- el tipo de solicitud  escogido --->
<cfset tipo = aplica.obtenerTipoSolicitud( form.ESidsolicitud, session.Ecodigo ) >

<!--- Consulta de los Centros Funcionales presentes en la solicitud y los cuales hay que chequear el monto máximo --->
<cfquery name="rsCentrosFuncionales" datasource="#Session.DSN#">
	select a.CFid, b.CFdescripcion,
	sum(case when (a.DStipo = 'S' or a.DStipo = 'A') and (COALESCE(e.afectaIVA,0) = 1 or COALESCE(f.afectaIVA,0) = 1) THEN
	   coalesce(round(round(DScant*DSmontoest,2) * c.Iporcentaje/100,2) +
	   round(DScant*DSmontoest,2)+ round(ROUND(DScant*DSmontoest,2)* COALESCE(d.ValorCalculo/100,0),2),0)
	else
	   coalesce(round((round(DScant*DSmontoest,2)+ round(ROUND(DScant*DSmontoest,2)* COALESCE(d.ValorCalculo/100,0),2)) * c.Iporcentaje/100,2) +
	   round(DScant*DSmontoest,2)+ round(ROUND(DScant*DSmontoest,2)* COALESCE(d.ValorCalculo/100,0),2),0)
	 end) as total
	 from DSolicitudCompraCM a
		inner join CFuncional b
		ON a.CFid = b.CFid
		INNER JOIN Impuestos c
		on a.Icodigo = c.Icodigo
		and a.Ecodigo = c.Ecodigo
		left join Impuestos d
		on a.codIEPS = d.Icodigo
		and a.Ecodigo=d.Ecodigo
		left join Conceptos e
		on e.Cid = a.Cid
		left join Articulos f
		on f.Aid= a.Aid
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	    and a.ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESidsolicitud#">
	group by a.CFid, b.CFdescripcion
</cfquery>

<!---
			<cfif rsPreTotales.recordcount gt 0>
					<cfquery name="rsTotales" dbtype="query">
						select sum(MotoIEPS) as TotalIEPS, sum(baseIVA) as TbaseIVA, sum(IVA) as impuesto,
						sum(MontoT) as STMontoT, sum(subtotal) as subtotal
						from rsPreTotales
					</cfquery>
			</cfif>
 --->

<cfloop query="rsCentrosFuncionales">
	<!--- Obtiene moneda y monto maximo del Tipo de Solicitud--->
	<cfquery name="rsValidaMonto" datasource="#session.DSN#">
		select Mcodigo, CMTSmontomax
		from CMTSolicitudCF
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and CMTScodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#tipo.CMTScodigo#">
			and CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCentrosFuncionales.CFid#">
	</cfquery>


	<cfif rsValidaMonto.recordCount lte 0>
		<cfquery name="infoCfuncional" datasource="#session.DSN#">
			select CFcodigo, CFdescripcion
			from CFuncional
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCentrosFuncionales.CFid#">
		</cfquery>

		<cf_errorCode	code = "50303"
						msg  = "El centro funcional @errorDat_1@-@errorDat_2@, no esta permitido para el tipo de solicitud @errorDat_3@."
						errorDat_1="#trim(infoCfuncional.CFcodigo)#"
						errorDat_2="#infoCfuncional.CFdescripcion#"
						errorDat_3="#trim(tipo.CMTScodigo)#"
		>
		<cfabort>
	</cfif>

	<!--- Si monto es cero ==> el monto de compra es ilimitado --->
	<!--- monto mayor que cero --->
	<cfif rsValidaMonto.CMTSmontomax gt 0>
		<cfset errorMonto = false >

		<!--- Caso 1: moneda de la solicitud es igual a moneda del tipo de Solicitud --->
		<cfif dataSolicitud.Mcodigo eq rsValidaMonto.Mcodigo >
			<cfif rsCentrosFuncionales.total gt rsValidaMonto.CMTSmontomax >
				<cfset errorMonto = true >
			</cfif>

		<!--- Caso 2 monedas diferentes. Se compara en moneda local --->
		<cfelse>
			<cfquery name="rsMonedaLocal" datasource="#session.DSN#">
				select Mcodigo
				from Empresas
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>

			<!--- Calculo del monto de la solicitud en moneda local--->
			<!--- Si es moneda local, el TC es uno --->
			<cfset montoLocalSolicitud = rsCentrosFuncionales.total * dataSolicitud.EStipocambio >

			<!--- Calculo del monto maximo del tipo de solicitud en moneda local--->
			<!--- Se hace con base al tipo de cambio definido en Contabilidad  --->
			<cfset tipoCambioMaximo = 1 >
			<cfif rsMonedaLocal.Mcodigo neq rsValidaMonto.Mcodigo >
				<cfquery name="rsMontoMaximoTS" datasource="#session.DSN#">
					select tc.Mcodigo, tc.TCcompra, tc.TCventa
					from Htipocambio tc
					where tc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and tc.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsValidaMonto.Mcodigo#">
						and tc.Hfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
						and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				</cfquery>

				<cfif rsMontoMaximoTS.recordCount gt 0 and len(trim(rsMontoMaximoTS.TCventa)) >
					<cfset tipoCambioMaximo = rsMontoMaximoTS.TCventa >
				<cfelse>
					<cfquery name="dataMoneda" datasource="#session.DSN#">
						select Mnombre
						from Monedas
						where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsValidaMonto.Mcodigo#">
					</cfquery>
					<cf_errorCode	code = "50304"
									msg  = "Debe definir el tipo de cambio actual para la moneda @errorDat_1@!"
									errorDat_1="#dataMoneda.Mnombre#"
					>
				</cfif>
			</cfif>

			<cfset montoLocalMaximo = rsValidaMonto.CMTSmontomax * tipoCambioMaximo>

			<cfif montoLocalMaximo lt montoLocalSolicitud >
				<cfset errorMonto = true >
			</cfif>
		</cfif>

		<cfif errorMonto>
			<cf_errorCode	code = "50305"
							msg  = "El monto de la solicitud ha excedido el monto máximo definido en el tipo de Solicitud para el centro funcional @errorDat_1@"
							errorDat_1="#rsCentrosFuncionales.CFdescripcion#"
			>
			<cfabort>
		</cfif>
	</cfif>
	<!--- monto mayor que cero --->
</cfloop>

<cfif aplica.puedeAplicar(form.ESidsolicitud, session.Ecodigo)>
<cfelse>
	<cf_errorCode	code = "50306" msg = "Error al aplicar la Solicitud de Compra.<br> - La Solicitud de Compra no tiene líneas de detalle.<br> - Hay líneas con montos ó cantidades en cero.">
</cfif>

<!--- Si el parametro Validar para compras directas bienes en contratos esta activado,
      valida que no se incluyan bienes contenidos en contratos vigentes --->

<!--- Obtiene el estado del parametro --->
<cfquery name="rsParametroValidarCDC" datasource="#Session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value=710>
</cfquery>

<!--- Si el parametro esta activado procede a hacer la validacion --->
<cfif rsParametroValidarCDC.RecordCount gt 0 and rsParametroValidarCDC.Pvalor EQ 1>

	<!--- Obtiene los articulos de la lista de detalles de la solicitud --->
	<cfquery name="rsBienesDetalleSC" datasource="#Session.DSN#">
		select a.Aid, a.Cid, a.ACcodigo
		from DSolicitudCompraCM a
		where a.ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESidsolicitud#">
		order by a.DSlinea
	</cfquery>

	<!--- Verifica cada bien, ya sea articulo, concepto o categoria --->
	<cfset lineas = "">
	<cfloop query="rsBienesDetalleSC">
		<!--- Si el bien es un articulo --->
		<cfif Len(Trim(rsBienesDetalleSC.Aid))>
			<cfquery name="rsArticuloContratos" datasource="#Session.DSN#">
				select distinct b.ECid
				from DContratosCM a
					inner join EContratosCM b
					on b.ECid = a.ECid
				where a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBienesDetalleSC.Aid#">
					and b.ECfechaini <= <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
					and b.ECfechafin >= <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
				order by b.ECid
			</cfquery>
			<cfif rsArticuloContratos.RecordCount gt 0>
				<cfif lineas EQ "">
					<cfset lineas = lineas & "#rsBienesDetalleSC.CurrentRow#">
				<cfelse>
					<cfset lineas = lineas & ",#rsBienesDetalleSC.CurrentRow#">
				</cfif>
			</cfif>
		<!--- Si el bien es un concepto --->
		<cfelseif Len(Trim(rsBienesDetalleSC.Cid))>
			<cfquery name="rsConceptoContratos" datasource="#Session.DSN#">
				select distinct b.ECid
				from DContratosCM a
					inner join EContratosCM b
					on b.ECid = a.ECid
				where a.Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBienesDetalleSC.Cid#">
					and b.ECfechaini <= <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
					and b.ECfechafin >= <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
				order by b.ECid
			</cfquery>

			<cfif rsConceptoContratos.RecordCount gt 0>
				<cfif lineas EQ "">
					<cfset lineas = lineas & "#rsBienesDetalleSC.CurrentRow#">
				<cfelse>
					<cfset lineas = lineas & ",#rsBienesDetalleSC.CurrentRow#">
				</cfif>
			</cfif>
		<!--- Si el bien es una categoria --->
		<cfelseif Len(Trim(rsBienesDetalleSC.ACcodigo))>
			<cfquery name="rsCategoriaContratos" datasource="#Session.DSN#">
				select distinct b.ECid
				from DContratosCM a
					inner join EContratosCM b
					on b.ECid = a.ECid
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and a.ACcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBienesDetalleSC.ACcodigo#">
					and b.ECfechaini <= <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
					and b.ECfechafin >= <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
				order by b.ECid
			</cfquery>
			<cfif rsCategoriaContratos.RecordCount gt 0>
				<cfif lineas EQ "">
					<cfset lineas = lineas & "#rsBienesDetalleSC.CurrentRow#">
				<cfelse>
					<cfset lineas = lineas & ",#rsBienesDetalleSC.CurrentRow#">
				</cfif>
			</cfif>
		</cfif>
	</cfloop>

	<cfif lineas NEQ "">
		<cf_errorCode	code = "50307"
						msg  = "La Solicitud de compra es directa y posee bienes en contratos en las líneas {@errorDat_1@} y no se podrá aplicar. Elimine las líneas mencionadas e inclúyalas en otra solicitud."
						errorDat_1="#lineas#"
		>
	</cfif>
</cfif>

<!--- Fin de Verificaciones de la Solicitud de Orden de Compra Directa --->

<!--- Querys para construir combos --->
<cfquery name="rsTipoOrden" datasource="#Session.DSN#">
	select rtrim(CMTOcodigo) as CMTOcodigo, CMTOdescripcion
	from CMTipoOrden
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by CMTOcodigo
</cfquery>

<cfquery name="rsRetenciones" datasource="#Session.DSN#">
	select rtrim(Rcodigo) as Rcodigo, Rdescripcion
	from Retenciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by Rcodigo
</cfquery>

<!--- Formas de Pago --->
<cfquery name="rsCMFormasPago" datasource="#session.dsn#">
	select CMFPid, CMFPcodigo, CMFPdescripcion, CMFPplazo
	from CMFormasPago
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by CMFPcodigo
</cfquery>

<!--- Formas de pago por defecto del socio de negocio ----->
<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
	<cfquery name="rsFormaPagoSocio" datasource="#Session.DSN#">
		select b.CMFPid
		from SNegocios a
			left outer join CMFormasPago b
				on a.SNplazocredito = b.CMFPplazo
				and a.Ecodigo = b.Ecodigo
		where a.SNcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
</cfif>

<cfif isdefined("form.ESidsolicitud") and len(trim(form.ESidsolicitud))>
	<cfquery name="rsFormaPagoContrato" datasource="#Session.DSN#">
		select a.CMFPid
		from EContratosCM a
			inner join DContratosCM b
				on a.ECid = b.ECid
				and a.Ecodigo = b.Ecodigo

		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and b.Aid in(select Aid
							from DSolicitudCompraCM
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				 			and ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESidsolicitud#">
							)
				or b.Cid in(select Aid
							from DSolicitudCompraCM
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							and ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESidsolicitud#">
							)
	</cfquery>
</cfif>


<cfquery name="rsSolicitud" datasource="#Session.DSN#">
	select  c.SNnombre,
			b.DSconsecutivo,
			b.DScant,
			b.DSlinea,
			d.Mnombre,
			b.DStipo,
			b.Aid,
			b.Cid,
			b.ACcodigo,
			b.ACid,
			case b.DStipo when 'A' then Adescripcion
			when 'S' then Cdescripcion
			when 'F' then g.ACdescripcion#_Cat#'/'#_Cat#h.ACdescripcion end as Descripcion,
			a.Mcodigo,
			a.SNcodigo,
			a.EStipocambio,
			b.Ucodigo,
			i.Idescripcion,
			u.Udescripcion
	from ESolicitudCompraCM a

	inner join DSolicitudCompraCM b
		on a.Ecodigo = b.Ecodigo
		and a.ESidsolicitud = b.ESidsolicitud

	inner join SNegocios c
		on a.Ecodigo = c.Ecodigo
		and a.SNcodigo = c.SNcodigo

	inner join Monedas d
		on a.Ecodigo = d.Ecodigo
		and a.Mcodigo = d.Mcodigo

	inner join Impuestos i
		on b.Ecodigo = i.Ecodigo
		and b.Icodigo = i.Icodigo

	inner join Unidades u
		on b.Ecodigo = u.Ecodigo
		and b.Ucodigo = u.Ucodigo

	left outer join Articulos e
		on b.Aid = e.Aid

	left outer join Conceptos f
		on b.Cid = f.Cid

	left outer join ACategoria g
		on b.Ecodigo = g.Ecodigo
		and b.ACcodigo = g.ACcodigo

	left outer join AClasificacion h
		on b.Ecodigo = h.Ecodigo
		and b.ACcodigo = h.ACcodigo
		and b.ACid = h.ACid

	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and a.ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ESidsolicitud#">

</cfquery>

<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/javascript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	<!--- Objectos para el manejo de plazos de crédito según la forma de pago --->
	var fp = new Object();
	<cfoutput query="rsCMFormasPago">
		fp['#CMFPid#'] = #CMFPplazo#;
	</cfoutput>

	function getPlazo(displayCtl, id) {
		if (fp[id] != null) {
			displayCtl.value = fp[id];
		}
	}

</script>
<cfoutput>
	<form name="form1" method="post" action="solicitudes-sql.cfm">
		<cfloop collection="#Form#" item="key">
			<input type="hidden" name="#key#" value="#StructFind(Form, key)#">
		</cfloop>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td class="tituloListas"><strong>Por favor llene el siguiente formulario para generar la orden de compra</strong></td>
		  </tr>
		  <tr>
			<td>
			  <table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
				<tr>
				  <td>
					<table width="100%"  border="0" cellspacing="0" cellpadding="2">
					  <tr>
						<td align="right" nowrap class="fileLabel">Proveedor:</td>
						<td nowrap> #rsSolicitud.SNnombre# </td>
						<td align="right" nowrap class="fileLabel">Moneda:</td>
						<td nowrap>#rsSolicitud.Mnombre#</td>
						<td class="fileLabel" align="right" nowrap>Tipo Cambio:</td>
						<td>
                          <input name="EOtc" type="text" size="10" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);" onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="#LsNumberFormat(rsSolicitud.EStipocambio, ',9.00')#">
                        </td>
					  </tr>
					  <tr>
						<td class="fileLabel" align="right" nowrap>Tipo Orden Compra:</td>
						<td>
						  <select name="CMTOcodigo" class="required">
                          	<cfoutput><option value="">(Seleccionar)</option></cfoutput>
							<cfloop query="rsTipoOrden">
							  <option value="#rsTipoOrden.CMTOcodigo#">#rsTipoOrden.CMTOdescripcion#</option>
							</cfloop>
						  </select>
						</td>
						<td class="fileLabel" align="right" nowrap>Retenci&oacute;n:</td>
						<td>
						  <select name="Rcodigo">
							<option value="">(Ninguna)</option>
							<cfloop query="rsRetenciones">
							  <option value="#rsRetenciones.Rcodigo#">#rsRetenciones.Rdescripcion#</option>
							</cfloop>
						  </select>
						</td>
						<td class="fileLabel" align="right" nowrap>Forma de Pago:</td>
						<td>
							<select name="CMFPid" onChange="javascript: getPlazo(this.form.EOplazo, this.value);">
								<cfloop query="rsCMFormasPago">
									<option value="#CMFPid#" <cfif isdefined("rsFormaPagoSocio") and len(trim(rsFormaPagoSocio.CMFPID)) and rsCMFormasPago.CMFPid eq rsFormaPagoSocio.CMFPid> selected<cfelseif isdefined("rsFormaPagoContrato") and len(trim(rsFormaPagoContrato.CMFPID)) and rsCMFormasPago.CMFPid eq rsFormaPagoContrato.CMFPid>selected</cfif>><!----#CMFPcodigo# - ----->#CMFPdescripcion#</option>
								</cfloop>
							</select>
						</td>
					  </tr>
					  <tr>
						<td class="fileLabel" align="right" nowrap>Plazo Cr&eacute;dito:</td>
						<td>
						  <input name="EOplazo" type="text" size="10" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,0);" onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="0">
						</td>
						<td class="fileLabel" align="right" nowrap>% Anticipo:</td>
						<td>
						  <input name="EOporcanticipo" type="text" size="10" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);" onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="0.00">
						</td>
						<td class="fileLabel" align="right" nowrap>Observaciones:</td>
						<td>
						  <input type="text" name="Observaciones" size="40" maxlength="255" value="">
						</td>
					  </tr>
				  </table></td>
				</tr>
			</table></td>
		  </tr>
		  <tr>
			<td><strong>Detalle de Orden de Compra</strong></td>
		  </tr>
		  <tr>
			<td>
			  <table border="0" cellpadding="2" cellspacing="0" align="center" width="90%">
				<tr>
				  <td align="right" style="padding-right: 10px;" nowrap><strong>Linea Solicitud</strong></td>
				  <td style="padding-right: 10px;" nowrap><strong>Item</strong></td>
				  <td align="right" style="padding-right: 10px;" nowrap><strong>Cantidad</strong></td>
				  <td style="padding-right: 10px;" nowrap><strong>Unidad</strong></td>
				  <td style="padding-right: 10px;" nowrap><strong>Impuesto</strong></td>
				</tr>
				<cfloop query="rsSolicitud">
				  <tr>
					<td align="right" style="padding-right: 10px;" nowrap> #rsSolicitud.DSconsecutivo# </td>
					<td style="padding-right: 10px;" nowrap> #rsSolicitud.Descripcion# </td>
					<td style="padding-right: 10px;" align="right" nowrap> #LSNumberFormat(rsSolicitud.DScant, ',9.00')# </td>
					<td nowrap>
						#rsSolicitud.Udescripcion#
					</td>
					<td nowrap>
						#rsSolicitud.Idescripcion#
					</td>
				  </tr>
				</cfloop>
				<tr>
				  <td colspan="5" align="center" nowrap>
						<input type="submit" name="btnAplicar"  value="Aplicar" onClick="javascript:if( confirm('Desea proceder a aplicar la solicitud y generar la orden de compra?') ){ validar=false; return true;} return false;" tabindex="1">
				  </td>
				</tr>
				<tr>
				  <td colspan="5" align="center" nowrap>&nbsp;</td>
				</tr>
			</table></td>
		  </tr>
		</table>
	</form>
</cfoutput>
<script language="javascript" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.CMFPid.required = true;
	objForm.CMFPid.description = "Forma de pago";
	objForm.EOplazo.required = true;
	objForm.EOplazo.description = "Plazo de Crédito";
	objForm.Observaciones.required = true;
	objForm.Observaciones.description = "Observaciones";
	objForm.EOtc.required = true;
	objForm.EOtc.description = "Tipo Cambio";
	objForm.EOporcanticipo.required = true;
	objForm.EOporcanticipo.description = "Porcentaje Anticipo";
	objForm.CMTOcodigo.required = true;
	objForm.CMTOcodigo.description = "Tipo Orden Compra";

	getPlazo(document.form1.EOplazo, document.form1.CMFPid.value);

</script>


