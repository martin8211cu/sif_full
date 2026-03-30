<style>
	#layer1 {
	position: absolute;
	visibility: hidden;
	width: 400px;
	height: 90px;
	left: 20px;
	top: 300px;
	background-color: #ccc;
	border: 1px solid #000;
	padding: 10px;
}
#close {
	float: right;
}
</style>

<cfparam name="Request.jsMask" default="false">

<cfif Request.jsMask EQ false>
	<cfset Request.jsMask = true>
	<script language="JavaScript" src="/cfmx/sif/js/calendar.js"></script>
	<script src="/cfmx/sif/js/MaskApi/masks.js"></script>
	<cfif NOT isdefined("request.scriptOnEnterKeyDefinition")><cf_onEnterKey></cfif>
</cfif>

	<cfquery name="rsOficinas" datasource="#session.dsn#">
		select 
			Ocodigo,
			Oficodigo,
			Odescripcion 
		from  Oficinas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		order by Oficodigo
	</cfquery>
	
	<cfquery datasource="#Session.DSN#" name="rsBancos">
		select Bid as BancoId, Bdescripcion as bancoDescripcion
		from Bancos 
		where Ecodigo	=	<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
		order by Bdescripcion
	</cfquery>
	
	<cfquery name="rsTipoRenta" datasource="#session.dsn#">
		select 
			Rcodigo,    
			Rdescripcion		
		from  Retenciones
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		order by Rcodigo
	</cfquery>
		
	<!---Periodos--->
	<cfquery name="rsPeriodo" datasource="#Session.DSN#">
		select distinct Speriodo as Periodo
			from CGPeriodosProcesados
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	</cfquery>

	<cfquery name="rsPeriodoActual" datasource="#Session.DSN#">
		select Pvalor as PeriodoActual
		from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
		and Pcodigo=50
	</cfquery>

		<!---Meses--->
	<cfquery name="rsMeses" datasource="sifControl">
		select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as Pvalor, b.VSdesc as Pdescripcion
		from Idiomas a, VSidioma b 
		where a.Icodigo = '#Session.Idioma#'
		and b.VSgrupo = 1
		and a.Iid = b.Iid
		order by <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">
	</cfquery>
	
	<cfquery name="rsMoneda" datasource="#session.DSN#">
		select Miso4217 as value
		  from Empresas a 
		  inner join Monedas b 
		  	on a.Mcodigo = b.Mcodigo
		where a.Ecodigo =  #session.Ecodigo# 
	</cfquery>
	
<cfif modo EQ 'CAMBIO'>
	<cfquery name="DPR" datasource="#session.dsn#">
		select 
			a.TESAPnumero,
			a.DROrigen,
			cb.CBcodigo, cb.CBdescripcion,
			ba.Bdescripcion as bancoDescripcion,
			enc.CFid,
			cf.CFdescripcion, cf.CFcodigo,
			enc.ts_rversion,
			enc.BTid,
			enc.DRNumConfirmacion,
			'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' as espacio,
			a.Dtipocambio,
			a.CPTRcodigo,
			ba.Bid as Bid,
			cb.CBcodigo,
			cb.CBid,
			cb.CBdescripcion,
			enc.Ocodigo,
			case enc.DREstado when 1 then 'Generado' when 2 then 'Aplicado' end as estado, 
			case enc.DRMes when 1 then 'Enero' when 2 then 'Febrero' 
			when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio'
			when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre'
			end as mes, 
			enc.DRPeriodo as periodo,
			a.Ecodigo,
			a.Pfecha, 
			sn.SNnombre,
			a.DRdocumento as documento,
			a.MTotal,
			coalesce(a.MontoR,0) as MontoRetencion,
			coalesce((a.MontoR * a.Dtipocambio),0) as montolocal,
			coalesce((a.MTotal * a.Dtipocambio),0) as totallocal,
			m.Miso4217 as Moneda,
			m.Mcodigo,
			a.CPTcodigo,
			a.Ddocumento as Orden_Pago,
			rt.Rcodigo, a.Rcodigo,
			Rdescripcion as Tipo_Retencion

		from EDRetenciones enc
			left outer join CuentasBancos cb 
			inner join Bancos ba
					on cb.Bid = ba.Bid 
					and cb.Ecodigo = ba.Ecodigo 
				on cb.CBid = enc.CBid 	
			left outer join CFuncional cf
			   on cf.CFid=enc.CFid				
			inner join DDRetenciones a
				on enc.DRid = a.DRid
			inner join Retenciones rt
				on rt.Rcodigo = a.Rcodigo
				and rt.Ecodigo = a.Ecodigo
			inner join Monedas m
				on  a.Ecodigo 	= m.Ecodigo
				and a.Mcodigo 	= m.Mcodigo
			inner join SNegocios  sn
				on  a.Ecodigo 	= sn.Ecodigo
				and a.SNcodigo = sn.SNcodigo
	  where   
	   enc.DRid = #form.DRid#
       	and coalesce(cb.CBesTCE,0) = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
		and a.Ecodigo =  #session.Ecodigo#
		and a.MontoR>0
	</cfquery>
	
	
	<cfquery name="rsSuma" dbtype="query">
		select sum(montolocal) as total
		from DPR
	</cfquery>
	
	<cfset Bid=DPR.Bid>
	<cfset CBid=DPR.CBid>
	<cfset CBcodigo=replace(DPR.CBcodigo,',',' ')>
	<cfset CBdescripcion=replace(DPR.CBdescripcion,',',' ')>
	<cfset Mcodigo=DPR.Mcodigo>
	<cfset fecha=Dateformat(DPR.Pfecha,'dd/mm/yyyy')>
	<cfset CFid=DPR.CFid>
	<cfset CFdescripcion=DPR.CFdescripcion>
	<cfset CFcodigo=DPR.CFcodigo>
<cfelse>
	<cfset Bid="">
	<cfset CBid="">
	<cfset CBcodigo="">
	<cfset CBdescripcion="">
	<cfset Mcodigo="">
	<cfset fecha=Dateformat(now(),'dd/mm/yyyy')>
	<cfset CFid="">
	<cfset CFdescripcion="">
	<cfset CFcodigo="">
</cfif>

<table border="0" width="100%">
		<tr>
			<td colspan="2" align="center">
			<cfoutput>
			<form name="form1" action="DPagoRenta-sql.cfm" method="post">
				<table>
					<tr>
						<td><input type="hidden" name="MostrarValoreLista" value="<cfoutput>#MostrarValoreLista#</cfoutput>">	</td>
						<cfif modo EQ 'CAMBIO'>
							<td><input type="hidden" name="DRid" value="<cfoutput>#form.DRid#</cfoutput>"></td>
							<td><input type="hidden" name="BTid" value="<cfoutput>#DPR.BTid#</cfoutput>">	</td>
							<td>						 
								<cfif #DPR.estado# eq 'Aplicado'>
									<input type="hidden" name="CBid" value="<cfoutput>#DPR.CBid#</cfoutput>">	
								</cfif>
							</td>
							
							<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#DPR.ts_rversion#" returnvariable="ts">
							</cfinvoke>
							<td><input type="hidden" name="ts_rversion" value="<cfoutput>#ts#</cfoutput>"></td>
						</cfif>
					</tr>
				
					<tr>
						<td align="right"><strong>Oficina:</strong></td>
						<td>
							<cfif modo NEQ "ALTA">
								<cfquery name="rsOficinas2" datasource="#session.dsn#">
									select 
										Odescripcion 
									from  Oficinas
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
									and Ocodigo = #DPR.Ocodigo#
								</cfquery>
								#rsOficinas2.Odescripcion#
							<cfelse>
								<select name="Oficina" tabindex="1">
									<cfloop query="rsOficinas">
										<option value="#Ocodigo#">#Oficodigo#-#Odescripcion#</option>
									</cfloop>
								</select>
							</cfif>
						</td>
					</tr>
					
					<tr>
						<td align="right"><strong>Periodo:</strong></td>
						<td>
						<cfif modo NEQ "ALTA">
							#DPR.periodo#
						<cfelse>
						<cfif rsPeriodo.recordcount gt 0>
							<select name="periodo">
								<cfloop query="rsPeriodo">
									<option value="#Periodo#" 
									<cfif isdefined("periodo") and len(trim(periodo))>
										<cfif (periodo eq rsPeriodo.Periodo)>
										selected
										</cfif>
									<cfelse>
										<cfif (isdefined("rsPeriodoActual") and rsPeriodoActual.PeriodoActual eq rsPeriodo.Periodo)>
										selected
										</cfif>
									</cfif>
									>
									#Periodo#
									</option>
								</cfloop>
							</select>
							<cfelse>
							<select name="periodo">
								<cfloop query="rsPeriodoActual"> <!---Periodo Auxiliar --->
									<option value="#PeriodoActual#" 
									<cfif isdefined("PeriodoActual") and len(trim(PeriodoActual))>
										<cfif (PeriodoActual eq rsPeriodoActual.PeriodoActual)>
										selected
										</cfif>
									</cfif>
									>
									#PeriodoActual#
									</option>
								</cfloop>
							</select>
							</cfif>
						</cfif>
						</td>
						<td>&nbsp;&nbsp;&nbsp;</td>
					</tr>
					
					<tr>
						<td align="right"><strong>Mes:</strong></td>
						<td>
						 <cfif modo NEQ "ALTA">
						 #DPR.mes#
						 <cfelse>
							<select name="mes">
								<cfloop query="rsMeses">
									<option value="#Pvalor#">#Pdescripcion#</option>
								</cfloop>
							</select>
						</cfif>						
						</td>
						<td width="2%">&nbsp;</td>
					</tr>
					<tr>
						<td align="right"><strong>Tipo Renta:</strong></td>
						<td>
						 <cfif modo NEQ "ALTA">
						 #rsTipoRenta.Rcodigo#
						 <cfelse>
							<select name="Rcodigo">
								<option value="" >---Seleccionar---</option>
								<cfloop query="rsTipoRenta">
									<option value="#Rcodigo#">#Rdescripcion#</option>
								</cfloop>
							</select>
						</cfif>						
						</td>
						<td width="2%">&nbsp;</td>
					</tr>
					
					<cfif modo eq 'CAMBIO'>
						<tr>
							<td align="right"><strong>Total:</strong></td>
							<td>#LSNumberFormat(rsSuma.total, ',9.00')# #rsMoneda.value#</td>
						</tr>
						
						<tr>
							<td align="right"><strong>Banco:</strong></td>
							<td>
							<cfif #DPR.estado# neq 'Aplicado'>
								<cfset selected="selected">
								<select name="Bid" tabindex="1" onchange="javascript:limpiarCuenta();">
								<option value="">-- Seleccione un Banco --</option>
								<cfloop query="rsBancos">
								<option value="#BancoId#" <cfif Bid eq BancoId> selected="selected"</cfif>>#BancoDescripcion#</option>
								</cfloop>						
								</select>
							<cfelse>
								#DPR.BancoDescripcion#
							</cfif>
							</td>
						</tr>
						
						<tr>
							<td></td>
							<td>
								<input type="hidden" name="fecha" value="<cfoutput>#fecha#</cfoutput>">
							</td>
						</tr>					
						
						<tr>
							<td align="right"><strong>Cuenta Bancaria: </strong></td>
							<td>
						 <cfif #DPR.estado# neq 'Aplicado'>
								<cf_conlis title="Lista de Cuentas Bancarias"
								campos = "CBid, CBcodigo, CBdescripcion, Mcodigo" 
								values="#CBid#,#CBcodigo#,#CBdescripcion#,#Mcodigo#"
								desplegables = "N,S,S,N" 
								modificables = "N,S,N,N" 
								size = "0,0,40,0"
								tabla="CuentasBancos cb
								inner join Monedas m 
								on cb.Mcodigo = m.Mcodigo
								inner join Empresas e
								on e.Ecodigo = cb.Ecodigo
								left outer join Htipocambio tc
								on 	tc.Ecodigo = cb.Ecodigo
								and tc.Mcodigo = cb.Mcodigo
								and tc.Hfecha  <= $fecha,date$
								and tc.Hfechah >  $fecha,date$ "
								columnas="cb.CBid, cb.CBcodigo, cb.CBdescripcion, cb.Mcodigo, 
								m.Mnombre,
								round(
								coalesce(
								(	case 
								when cb.Mcodigo = e.Mcodigo then 1.00 
								else tc.TCcompra 
								end
								)
								, 1.00)
								,2) as EMtipocambio"
								filtro="cb.Ecodigo = #Session.Ecodigo# and cb.CBesTCE = 0 and cb.Bid = $Bid,numeric$ order by Mnombre, Hfecha"
								desplegar="CBcodigo, CBdescripcion"
								etiquetas="C&oacute;digo, Descripci&oacute;n"
								formatos="S,S"
								align="right,right"
								asignar="CBid, CBcodigo, CBdescripcion, Mcodigo, Mnombre, EMtipocambio"
								asignarformatos="S,S,S,S,S,M"
								showEmptyListMsg="true"
								debug="false"
								tabindex="1">
							<br />
						<cfelse>
							#DPR.CBcodigo# - #DPR.CBdescripcion#
						</cfif>
							</td>
						</tr>
						
						<tr>
							<td align="right"><strong>Confirmación de Pago: </strong></td>
							<td>
							<cfif #DPR.estado# neq 'Aplicado'>
								<input type="text" name="DRNumConfirmacion" maxlength="201" size="20" id="DRNumConfirmacion" tabindex="0" style="border-spacing:inherit" value="#DPR.DRNumConfirmacion#" />
							<cfelse>
								#DPR.DRNumConfirmacion#
							</cfif>
							</td>
						</tr>
						
						<tr>
							<td nowrap align="right"><strong>Centro funcional:</strong></td>
								<td>
							<cfif #DPR.estado# neq 'Aplicado'>
								<cf_conlis
									Campos="CFid,CFcodigo,CFdescripcion"
									tabindex="6"
									values="#CFid#,#CFcodigo#,#CFdescripcion#,"
									Desplegables="N,S,S"
									Modificables="N,S,N"
									Size="0,15,35"
									Title="Lista de Centros Funcionales"
									Tabla="CFuncional cf"
									Columnas="CFid,CFcodigo,CFdescripcion"
									Filtro="Ecodigo = #Session.Ecodigo# order by CFcodigo,CFdescripcion"
									Desplegar="CFcodigo,CFdescripcion"
									Etiquetas="C&oacute;digo,Descripci&oacute;n"
									filtrar_por="CFcodigo,CFdescripcion"
									Formatos="S,S"
									Align="left,left"
									Asignar="CFid,CFcodigo,CFdescripcion"
									Asignarformatos="I,S,S"
									funcion="resetPeaje"/>
								<cfelse>
									#DPR.CFcodigo# - #DPR.CFdescripcion#
								</cfif>
							</td>
						</tr>
					</cfif>
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td colspan="2">
							<cfif modo eq 'CAMBIO'>
								<cfif #DPR.estado# eq 'Aplicado'>
									<cf_botones modo="#modo#" exclude="Aplicar,baja,Cambio" include="Regresar"> 
								<cfelse>
									<cf_botones modo="#modo#" include="Aplicar,Regresar"> 
								</cfif>
							<cfelse>
								<cf_botones names="Generar" values="Generar" tabindex="1">
							</cfif>
						</td>
					<tr>
					<tr><td>&nbsp;</td></tr>
				</table>
			</form>
			</cfoutput>	
			<cfif modo eq 'CAMBIO' and #DPR.estado# neq 'Aplicado'> 
				<cf_qforms objForm="objForm1" form="form1">
					<cf_qformsRequiredField name="Bid" 	 		description="Banco">
					<cf_qformsRequiredField name="CBcodigo" 	description="Cuenta Bancaria">
					<cf_qformsRequiredField name="DRNumConfirmacion" 	description="Confirmación de Pago">
					<cf_qformsRequiredField name="CFcodigo" 	description="Centro Funcional">
				</cf_qforms>
			</cfif>
			</td>
		</tr>
	<cfif modo EQ 'CAMBIO'>
		<tr>
			<td width="50%" class="tituloListas">
				<fieldset>
				<legend><strong>Detalle -(Lista de Facturas)</strong> (<a href="##" onClick="javascript:doConlis();">Imprimir</a> <a href="##" onClick="javascript:doConlis();"><img src="/cfmx/sif/imagenes/impresora.gif" border="0"></a>)</legend>
				<table>
					<form name="form3" action="DPagoRenta-sql.cfm" method="post">
						<td><cfif modo EQ 'CAMBIO'><input type="hidden" name="DRid" value="<cfoutput>#form.DRid#</cfoutput>"></cfif></td>
						<td>
							<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" >
								<cfinvokeargument name="query" 				value="#DPR#"/>
								<cfinvokeargument name="desplegar" 			value="DROrigen,espacio,documento,espacio, SNnombre,espacio, totallocal,espacio, Moneda,espacio,MontoRetencion,espacio,montolocal,espacio,Orden_Pago,espacio,Pfecha,espacio,Tipo_Retencion,espacio,TESAPnumero"/>
								<cfinvokeargument name="etiquetas" 			value="Origen, ,Factura, ,Proveedor, ,Total, ,Moneda, ,Monto Renta, ,Mto RMLocal, ,Orden Pago, ,Fecha Pago, ,Tipo Retención, ,Acuerdo Pago"/>
								<cfinvokeargument name="formatos" 			value="S,S,S,S,S,S,M,S,S,S,M,S,M,S,S,S,D,S,S,S,S"/>
								<cfinvokeargument name="align" 				value="left,left,left,left,left,left,right,left,left,left,right,left,right,left,left,left,left,left,left,left,left"/>
								<cfinvokeargument name="formName" 			value="form3"/>
								<cfinvokeargument name="checkboxes" 		value="N"/>
								<cfinvokeargument name="keys" 				value="Ecodigo, CPTcodigo, documento, CPTRcodigo, Orden_Pago, Pfecha"/>
								<cfinvokeargument name="ira" 					value="DPagoRenta.cfm"/>
								<cfinvokeargument name="MaxRows" 			value="50"/>
								<cfinvokeargument name="showLink" 			value="false"/>
								<cfinvokeargument name="PageIndex" 			value="3"/>
								<cfinvokeargument name="conexion" 			value="#session.dsn#"/>
								<cfinvokeargument name="usaAJAX" 			value="yes"/>
							</cfinvoke>	
						</td>
					</form>	
				</table>
				</fieldset>
			</td>
		 </tr>	
	</cfif>
	</table>

<script language="javascript" type="text/javascript">
		function funcCambio(){
			objForm1.Bid.description = "Banco";
			objForm1.CBcodigo.description = "Cuenta Bancaria";
			objForm1.DRNumConfirmacion.description = "Confirmación de Pago";
			objForm1.CFcodigo.description = "Centro Funcional";
	 	} 

		function limpiarCuenta(){
			objForm1.CBid.obj.value="";
			objForm1.CBcodigo.obj.value="";
			objForm1.CBdescripcion.obj.value="";
			objForm1.CFcodigo.obj.value="";
		}
		
		function funcRegresar(){
			location.href = 'DPagoRenta.cfm';
			return false;
		}
		
	
		var popUpWinSN=0;
		function popUpWindow(URLStr, left, top, width, height){
			if(popUpWinSN) {
				if(!popUpWinSN.closed) popUpWinSN.close();
			}
			popUpWinSN = open(URLStr, 'popUpWinSN', 'toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
			window.onfocus = closePopUp;
		}
		
		function doConlis(DRid,oficina,periodo,mes){
			<cfoutput>
			popUpWindow("/cfmx/sif/cp/operacion/PagoRenta-rpt.cfm<cfif modo NEQ "ALTA">?DRid=+#form.DRid#+&oficina=+#DPR.Ocodigo#+&periodo=+#DPR.periodo#+&mes=+#DPR.mes#</cfif>",150,150,800,500);
			</cfoutput>
		}

		
		function closePopUp(){
			if(popUpWinSN) {
				if(!popUpWinSN.closed) popUpWinSN.close();
				popUpWinSN=null;
			}
		}
</script>

	
