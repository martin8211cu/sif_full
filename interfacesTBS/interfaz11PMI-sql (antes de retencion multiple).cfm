<cfsetting enablecfoutputonly="yes">
<cfsetting requesttimeout="900">

<cfset vFechaI = createdate(right(form.FechaI,4),mid(form.FechaI,4,2),left(form.FechaI,2))>
<cfset vFechaF = createdatetime(right(form.FechaF,4),mid(form.FechaF,4,2),left(form.FechaF,2),23,59,59)>

<cfsetting enablecfoutputonly="yes">

<cfparam name="FechaI" default="">
<cfparam name="FechaF" default="">

<cfquery name="rsEmpresaSeleccionada" datasource="sifinterfaces">
	select 
		Ecodigo,
		CodICTS,
		EcodigoSDCSoin
	from int_ICTS_SOIN
	where Ecodigo = #session.Ecodigo#
</cfquery>


<cfif rsEmpresaSeleccionada.RecordCount is 0>
	<cfthrow message="No se encuentra la empresa #session.Ecodigo# en int_ICTS_SOIN">
</cfif>

		<!--- obtener datasource --->
		
		<cfquery datasource="asp" name="empresa">
			select b.Ccache, a.Ereferencia
			from Empresa a
				join Caches b
					on a.Cid = b.Cid
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpresaSeleccionada.EcodigoSDCSoin#">
		</cfquery>
		<cfif empresa.RecordCount is 0>
			<cfthrow message="No se encuentra la información para la empresa #rsEmpresaSeleccionada.EcodigoSDCSoin#">
		</cfif>
		<cfset Ccache = empresa.Ccache>
		<cfset dsinfo = Application.dsinfo>
		Application.dsinfo keys: #StructKeyList(application.dsinfo)#;
		Ccache: #Ccache#
		<cfset dsinfo = Application.dsinfo[Ccache]>
		<cfset mydb = dsinfo.schema>

<cf_htmlreportsheaders
	title="Importacion de Cobros y Pagos" 
	filename="ImportaCobrosPagos-#Session.Usucodigo#.xls" 
	ira="ConsCobrosPagosParam.cfm">
<cf_templatecss>

<cfoutput>
<cfset LvarTipo = ''>
<cfif isdefined("form.Cobros") and len(trim(form.Cobros))>
	<cfset LvarTipo = 'C'>
</cfif>
<cfif isdefined("form.Pagos") and len(trim(form.Pagos))>
	<cfset LvarTipo = 'P'>
</cfif>
<cfif isdefined("form.Cobros") and len(trim(form.Cobros)) and isdefined("form.Pagos") and len(trim(form.Pagos))>
	<cfset LvarTipo = 'Ambos'>
</cfif>


<cfset LvarSocioN = ''>
<cfif isdefined("form.SocioN") and len(trim(form.SocioN)) >
	<cfset LvarSocioN = form.SocioN >
<cfelse>
	<cfset LvarSocioN = 'nada' >
</cfif>

<cfif isdefined("form.SocioN") and len(trim(form.SocioN)) >
	<cfif  (isdefined("form.Cobros") and len(trim(form.Cobros))) or (isdefined("form.Pagos") and len(trim(form.Pagos))) >
	<cfelse>
	<cfthrow message="Debe seleccionar el check de cobros o pagos">
	</cfif>
</cfif>

<table width="100%" border="1">
	<tr><td colspan="2" align="center"><strong>Reporte de Proceso</strong></td>
	<tr><td colspan="2" align="center"><strong>Proceso de Carga de Compra de Producto</strong></td>
	<tr><td colspan="2" align="center"><strong>Fechas:  #LsDateFormat(vFechaI,'dd/mm/yyyy')# - #LsDateFormat(vFechaF,'dd/mm/yyyy')#</strong></td>
	<tr><td colspan="2">&nbsp;</td></tr>
</cfoutput>
<cfflush interval="40">



<!--- 1.Seleccionar los registros a procesar. Tienen codigo de Empresa Anterior y deben generar encabezado / Detalle --->
<cfquery name="rsRegistrosProcesar" datasource="sifinterfaces">
	select 
		EcodigoSDC,   
		TipoCobroPago,
		CodigoBanco,  
		CuentaBancaria, 
		FechaTransaccion, 
		TipoPago,         
		NumeroDocumento,
		NumeroSocio,      
		CodigoMonedaPago, 
		TipoCambio,
		sum(MontoPago) as MontoPago,
		count(1) as CantidadDetalles
	from IE11 a
	where a.EcodigoSDC = #rsEmpresaSeleccionada.CodICTS#
	  and a.Procesado = 'N'
	 	  <cfif isdefined("LvarTipo") and LvarTipo NEQ 'Ambos'>
		  and a.TipoCobroPago = '#LvarTipo#'
	 	  </cfif>
	 	  <cfif isdefined("LvarSocioN") and LvarSocioN NEQ 'nada'>
		  and a.NumeroSocio = '#LvarSocioN#'
	 	  </cfif>
	  <cfif isdefined("form.Moneda") and len(trim(form.Moneda)) gt 0>
		  and CodigoMonedaPago = '#form.Moneda#'
	  </cfif>
	  and a.FechaTransaccion between #vFechaI# and #vFechaF#
	  group by 	
		EcodigoSDC,   
		TipoCobroPago,
		CodigoBanco,  
		CuentaBancaria, 
		FechaTransaccion, 
		TipoPago,         
		NumeroDocumento,  
		NumeroSocio,      
		CodigoMonedaPago,
		TipoCambio

</cfquery>

<!--- Ciclo de Procesamiento de los Registros --->
		<cftransaction> 
<cfoutput query="rsRegistrosProcesar">
	<tr><td colspan="2" align="left">Procesando Documento: #CuentaBancaria# / #NumeroDocumento# Fecha: #LsDateFormat(FechaTransaccion,'dd/mm/yyyy')#. #NumberFormat(CantidadDetalles, ",9.00")# Registros </td>
	<cfquery datasource="sifinterfaces">
		update IdProceso
		set Consecutivo = Consecutivo + 1			
	</cfquery>

	<cfquery name="rsObtieneSigId" datasource="sifinterfaces">
		select Consecutivo
		from IdProceso
	</cfquery>

	<cfset LvarID = rsObtieneSigId.consecutivo>
	<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;</td><td colspan="1" align="left">ID: #LvarID#
	
	<cfset registro_ok = true><!--- indica si el proceso del IE11 procede o no --->

	<cfquery datasource="sifinterfaces">
		insert into IE11(
			ID,
			EcodigoSDC,
			TipoCobroPago,
			CodigoBanco,
			CuentaBancaria,
			FechaTransaccion,
			TipoPago,
			NumeroDocumento,
			NumeroSocio,    
			NumeroSocioDocumento,
			MontoPago,
			TipoCambio,           
			CodigoMonedaPago,   
			StatusProceso,
			ConDetalle,
			TransaccionOrigen
		)
		values (
			#LvarID#,
			#rsEmpresaSeleccionada.EcodigoSDCSoin#,
			'#rsRegistrosProcesar.TipoCobroPago#',
			'#rsRegistrosProcesar.CodigoBanco#',  
			'#rsRegistrosProcesar.CuentaBancaria#', 
			<cfqueryparam cfsqltype="cf_sql_date" value="#rsRegistrosProcesar.FechaTransaccion#">, 
			'#rsRegistrosProcesar.TipoPago#',         
			'#rsRegistrosProcesar.NumeroDocumento#',  
			'#rsRegistrosProcesar.NumeroSocio#',      
			'#rsRegistrosProcesar.NumeroSocio#',      
			#rsRegistrosProcesar.MontoPago#,
			#rsRegistrosProcesar.TipoCambio#,
			'#rsRegistrosProcesar.CodigoMonedaPago#', 
			1,
			1,
			'-1'
			)
	</cfquery>

	<!--- 2. Insertar en IE11 con EcodigoSDC = rsEmpresaSeleccionada.EcodigoSDC --->
	<!--- Copiar los detalles de IE11 a ID11 con el ID nuevo encontrado --->
	<cfquery datasource="sifinterfaces" name="detalle">
		select 
			MontoPago,
			CodigoTransaccion,
			Documento,
			MontoPagoDocumento,
			CodigoMonedaDoc,
			BMUsucodigo,
			NumeroDocumento,<!--- se lee para evitar errores al acceder variables del loop de afuera --->
			Case when CodigoTransaccion='AN' then 1 else 0 end as Anticipo
		from IE11 a
		where EcodigoSDC       =  #rsRegistrosProcesar.EcodigoSDC#
		  and TipoCobroPago    =  '#rsRegistrosProcesar.TipoCobroPago#'
		  and CodigoBanco      =  '#rsRegistrosProcesar.CodigoBanco#'
		  and CuentaBancaria   =  '#rsRegistrosProcesar.CuentaBancaria#'
		  and FechaTransaccion = <cfqueryparam cfsqltype="cf_sql_date" value="#rsRegistrosProcesar.FechaTransaccion#">
		  and TipoPago         =  '#rsRegistrosProcesar.TipoPago#'
		  and NumeroDocumento  =  '#rsRegistrosProcesar.NumeroDocumento#'
		  and NumeroSocio      =  '#rsRegistrosProcesar.NumeroSocio#'
		  and CodigoMonedaPago =  '#rsRegistrosProcesar.CodigoMonedaPago#'
		  and Procesado    =  'N'
	</cfquery>
	
	<!--- Buscar el socio --->	
	<cfquery datasource="sifinterfaces" name="Socio">
		select SNcodigo, SNcodigoext
		from #mydb#..SNegocios
		where SNcodigoext = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsRegistrosProcesar.NumeroSocio#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#empresa.Ereferencia#">
	</cfquery>
	
	<cfif Socio.RecordCount is 0>
		<br /><strong>No se encontró el socio con código externo #rsRegistrosProcesar.NumeroSocio#</strong>
		<br />El pago no se procesará hasta que este socio aparezca en el sistema.
		<cfset registro_ok = false>
	<cfelseif Socio.RecordCount gt 1>
		<br /><strong>Hay más de un socio con código externo #rsRegistrosProcesar.NumeroSocio#</strong>
		<br />El pago no se procesará hasta que este socio aparezca en el sistema.
		<cfset registro_ok = false>
	</cfif>
			
			
	<!--- <cfdump var="#detalle#"> --->
	<!--- 2. Insertar en IE11 con EcodigoSDC = rsEmpresaSeleccionada.EcodigoSDC --->
	<!--- Copiar los detalles de IE11 a ID11 con el ID nuevo encontrado --->
	<cfif registro_ok>
		<cfloop query="detalle">
		
			<!--- calcular la retención --->
			<!--- Buscar el documento usando el siguiente criterio:
				1.- Llave completa de EDocumentosCP:  Ecodigo,Ddocumento,CPTcodigo,SNcodigo
				2.- Llave parcial:                    Ecodigo,Ddocumento,CPTcodigo
				3.- Número solamente:                 Ecodigo,Ddocumento
			--->
			
			<cfloop from="1" to="3" index="intento">
				<cfquery datasource="sifinterfaces" name="retencion" maxrows="1">
					select b.Rcodigo, c.Rporcentaje, b.Dtotal
						<!--- b.CPTcodigo, b.Ddocumento, b.Dtotal,
						b.Rcodigo, c.Rdescripcion ---> 
					from #mydb#..EDocumentosCP b 	
						left join #mydb#..Retenciones c
							on b.Rcodigo = c.Rcodigo
								and c.Ecodigo = b.Ecodigo
					where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#empresa.Ereferencia#">
					<cfif intento LE 1>
						and b.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Socio.SNcodigo#">
					</cfif>
					<cfif intento LE 2>
						and b.CPTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#detalle.CodigoTransaccion#">
					</cfif>
					<cfif intento LE 3>
						and b.Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#detalle.Documento#">
					</cfif>
				</cfquery>
				<cfquery datasource="sifinterfaces" name="subtotal" maxrows="1">
					select coalesce (sum(DDtotallin), 0) as TotalLineas
					from #mydb#..DDocumentosCP b
					where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#empresa.Ereferencia#">
					<cfif intento LE 1>
						and b.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Socio.SNcodigo#">
					</cfif>
					<cfif intento LE 2>
						and b.CPTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#detalle.CodigoTransaccion#">
					</cfif>
					<cfif intento LE 3>
						and b.Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#detalle.Documento#">
					</cfif>
				</cfquery>
				<cfif retencion.RecordCount GT 0>
					<cfbreak>
				</cfif>
			</cfloop>
			, Docum:#detalle.Documento#
			<cfif retencion.RecordCount is 0>
				<br /><strong>No se encuentra el documento #detalle.Documento#, SNcodigo #Socio.SNcodigo# (SNcodigoext: #Socio.SNcodigoext#), CPTcodigo #detalle.CodigoTransaccion#, Ecodigo #empresa.Ereferencia#
				</strong><br />El pago no se procesará hasta que el documento se haya cargado.
				<cfset registro_ok = false>
				<cfbreak><!--- detener ciclo de detalles --->
				
			<cfelseif Len(retencion.Rcodigo) is 0>
				<cfset MontoRetencion = 0 >
				<!---
				sin retencion: #MontoRetencion#
				--->
			<cfelse>
				<cfset MontoRetencion = ( subtotal.TotalLineas * retencion.Rporcentaje ) / 100 >
				<cfif MontoRetencion GT (retencion.Dtotal - detalle.MontoPagoDocumento - 0.03)>
					<cfset MontoRetencion = retencion.Dtotal - detalle.MontoPagoDocumento>
					<!--{ajuste:!#MontoRetencion - retencion.Dtotal + detalle.MontoPagoDocumento#}-->
				</cfif>
				
				<cfset factor = detalle.MontoPagoDocumento / (retencion.Dtotal - MontoRetencion)>
				<cfset MontoRetencion = Int (MontoRetencion * factor * 100) / 100>
				
				(retencion: #MontoRetencion#)
			</cfif> 
			<cfquery datasource="sifinterfaces">
				insert into ID11 (
					ID,
					MontoPago,
					CodigoTransaccion,
					Documento,
					MontoPagoDocumento,
					CodigoMonedaDoc,
					BMUsucodigo,
					Anticipo,
					MontoRetencion)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarID#">,
					#detalle.MontoPago#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#detalle.CodigoTransaccion#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#detalle.Documento#">,
					#detalle.MontoPagoDocumento#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#detalle.CodigoMonedaDoc#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#detalle.BMUsucodigo#" null="#Len(detalle.BMUsucodigo) is 0#">,
					<cfqueryparam cfsqltype="cf_sql_bit"     value="#detalle.Anticipo#">,
					round (#MontoRetencion#, 2) )
			</cfquery>
		</cfloop>
	</cfif>
	
<!--- Inclusión de movimiento en cola de proceso --->
	<!---ok:#registro_ok#--->
	<cfif registro_ok>
		<cfquery name="rsIE11" datasource="sifinterfaces">
			select ID, EcodigoSDC
			from IE11
			where EcodigoSDC= #rsEmpresaSeleccionada.EcodigoSDCSoin#
			  and ID not in (select IdProceso from InterfazBitacoraProcesos where EcodigoSDC= #rsEmpresaSeleccionada.EcodigoSDCSoin# and NumeroInterfaz=11) 
			  and ID not in (select IdProceso from InterfazColaProcesos where EcodigoSDC= #rsEmpresaSeleccionada.EcodigoSDCSoin# and NumeroInterfaz=11)
		</cfquery>
		<cfloop query="rsIE11"> 
			<cfquery name="rsColaProcesos" datasource="sifinterfaces">
				insert InterfazColaProcesos
				(CEcodigo, NumeroInterfaz, IdProceso, SecReproceso, EcodigoSDC, OrigenInterfaz, TipoProcesamiento,
				 StatusProceso, FechaInclusion, UsucodigoInclusion, Cancelar)
				values (
				  <cfqueryparam cfsqltype="cf_sql_numeric" value=2>,
				  <cfqueryparam cfsqltype="cf_sql_integer" value=11>,
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIE11.ID#">,
				  <cfqueryparam cfsqltype="cf_sql_integer" value=0>,
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIE11.EcodigoSDC#">,
				  <cfqueryparam cfsqltype="cf_sql_char" value="E">,
				  <cfqueryparam cfsqltype="cf_sql_char" value="A">,
				  <cfqueryparam cfsqltype="cf_sql_integer" value=1>,
				  <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
				  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
				  <cfqueryparam cfsqltype="cf_sql_bit" value=0>)
			</cfquery>
		</cfloop>

		<!--- Marcar los Registros como procesados --->
		<cfquery datasource="sifinterfaces" name="rc">
			update IE11
			set StatusProceso = 10,Procesado='S'
			where EcodigoSDC       =  #rsRegistrosProcesar.EcodigoSDC#
			and TipoCobroPago    =  '#rsRegistrosProcesar.TipoCobroPago#'
			and CodigoBanco      =  '#rsRegistrosProcesar.CodigoBanco#'
			and CuentaBancaria   =  '#rsRegistrosProcesar.CuentaBancaria#'
			and FechaTransaccion =   <cfqueryparam cfsqltype="cf_sql_date" value="#rsRegistrosProcesar.FechaTransaccion#">
			and TipoPago         =  '#rsRegistrosProcesar.TipoPago#'
			and NumeroDocumento  =  '#rsRegistrosProcesar.NumeroDocumento#'
			and NumeroSocio      =  '#rsRegistrosProcesar.NumeroSocio#'
			and CodigoMonedaPago =  '#rsRegistrosProcesar.CodigoMonedaPago#'
			and Procesado        =  'N'
			select @@rowcount as rc
		</cfquery>
		<!---rows:#rc.rc#--->
		<cfquery datasource="sifinterfaces">
			update IE11
			set StatusProceso = 10, Procesado='S'
			where EcodigoSDC  =  #rsEmpresaSeleccionada.EcodigoSDCSoin#
			and Procesado     =  'N'
			and ID            = #LvarID#
		</cfquery>
	<cfelse>
		<!--- Borrar el procesamiento realizado --->
		<cfquery datasource="sifinterfaces">
			delete ID11 where ID = #LvarID#<!--- Borrar detalles previos procesados --->
			delete IE11 where ID = #LvarID#<!--- Borrar encabezado previos procesados --->
		</cfquery>
	</cfif>
	</td>
</cfoutput>
		
	<tr><td colspan="2">Final...</td></tr>
	</table>

<!---
	ABORTANDO.....
	<cfabort> 
--->		
		
</cftransaction>		
<cfoutput>
	<tr><td colspan="9">&nbsp;</td></tr>
	<tr><td colspan="9" align="center"><strong>Fin</strong></td></tr>
</cfoutput>
</table>
<cfabort>

