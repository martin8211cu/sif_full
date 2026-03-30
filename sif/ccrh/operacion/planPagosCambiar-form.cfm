<cfoutput>
	<cfif not isdefined("form.btnRecalcular")>
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Modificar Plan de Pago">
			<cfquery name="dataPlan" datasource="#session.DSN#">
				select 	a.TDid,
						d.TDcodigo,
						d.TDdescripcion,
						a.Dreferencia, 
						a.Ddescripcion, 
						a.SNcodigo,
						e.SNnumero,
						e.SNnombre,
						a.Dmonto, 
						a.Dtasa, 
						a.Dfechaini, 
						a.Dobservacion,
						( select distinct PPtasamora 
						  from DeduccionesEmpleadoPlan b 
						  where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and b.Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
							and b.PPpagado = 0 
							and a.Did = b.Did 
							and a.Ecodigo=b.Ecodigo ) as Dtasamora,
						( select coalesce(count(1),0)
						  from DeduccionesEmpleadoPlan c
						  where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
							and c.Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
							and c.PPpagado = 0 
							and a.Did = c.Did
							and a.Ecodigo = c.Ecodigo ) as Dnumcuotas
				from DeduccionesEmpleado a
				
				inner join TDeduccion d
				on a.TDid=d.TDid
				and a.Ecodigo=d.Ecodigo 
			
				left outer join SNegocios e
				on a.SNcodigo=e.SNcodigo
				and a.Ecodigo=e.SNcodigo
				
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
				and a.Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
				
			</cfquery>
	
			<cfquery name="dataSaldo" datasource="#session.DSN#">
				select Dfechadoc as PPfecha_doc, Dfechaini as PPfecha_vence, coalesce(Dsaldo, 0) as PPsaldoactual
				from DeduccionesEmpleado
				where Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#"> 
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 	
			</cfquery>
			
			<cfquery name="rsTipoNomina" datasource="#session.DSN#">
				select Tcodigo 
				from LineaTiempo 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
				and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between LTdesde and LThasta 
			</cfquery>
			<!--- Si el empleado está cesado, buscar la ultima nomina en la cual estaba --->
			<cfif rsTipoNomina.recordCount EQ 0>
				<cfquery name="rsTipoNomina" datasource="#session.DSN#">
					select a.Tcodigo 
					from LineaTiempo a
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
					and a.LThasta = (
						select max(x.LThasta)
						from LineaTiempo x
						where x.DEid = a.DEid
						and x.Ecodigo = a.Ecodigo
					)
				</cfquery>
			</cfif>

			<cfquery name="rsPeriodicidad" datasource="#session.DSN#">
				select Ttipopago 
				from TiposNomina 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsTipoNomina.Tcodigo)#">
			</cfquery>
	
			<script type="text/javascript" language="javascript1.2" src="../../js/utilesMonto.js"></script> 
			<form name="form1"  method="post" style="margin:0; ">
				<table width="100%" cellpadding="2" cellspacing="0">
					<tr><td width="1%" nowrap style="padding-left:10px; "><strong>Tipo de Deducci&oacute;n:&nbsp;</strong></td><td>#dataPlan.TDcodigo# - #dataPlan.TDdescripcion#</td></tr>
					<tr><td style="padding-left:10px; "><strong>Referencia:&nbsp;</strong></td><td>#dataPlan.Dreferencia#</td></tr>
					<tr><td style="padding-left:10px; "><strong>Descripci&oacute;n:&nbsp;</strong></td><td>#dataPlan.Ddescripcion#</td></tr>
					<tr><td style="padding-left:10px; "><strong>Socio:&nbsp;</strong></td><td>#dataPlan.SNnumero# - #dataPlan.SNnombre#</td></tr>
					<tr><td style="padding-left:10px; "><strong>Monto:&nbsp;</strong></td><td>#LSNumberFormat(dataPlan.Dmonto,',9.00')#</td></tr>
					<tr><td style="padding-left:10px; "><strong>Saldo actual:&nbsp;</strong></td><td>#LSNumberFormat(dataSaldo.PPsaldoactual,',9.00')#<input type="hidden" name="Dmonto" value="<cfif len(trim(dataSaldo.PPsaldoactual)) >#dataSaldo.PPsaldoactual#<cfelse>0</cfif>"></td></tr>
					<tr><td nowrap style="padding-left:10px; "><strong>Fecha Documento:&nbsp;</strong></td><td><cfif Len(Trim(dataSaldo.PPfecha_doc))>#LSdateFormat(dataSaldo.PPfecha_doc,'dd/mm/yyyy')#<input type="hidden" name="PPfecha_doc" value="#LSDateFormat(dataSaldo.PPfecha_doc,'dd/mm/yyyy')#"></cfif></td></tr>
					<tr>
						<td nowrap style="padding-left:10px; "><strong>Fecha Inicial:&nbsp;</strong></td>
						<td>
							#LSdateFormat(dataSaldo.PPfecha_vence,'dd/mm/yyyy')#
							<cfquery name="rsProximoPago" datasource="#Session.DSN#">
								select min(PPfecha_vence) as PPfecha_vence
								from DeduccionesEmpleadoPlan
								where Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Did#">
								and PPpagado = 0
							</cfquery>
							<input type="hidden" name="PPfecha_vence" value="<cfif rsProximoPago.recordCount GT 0 and Len(Trim(rsProximoPago.PPfecha_vence))>#LSDateFormat(rsProximoPago.PPfecha_vence,'dd/mm/yyyy')#</cfif>">
						</td>
					</tr>
					<tr><td style="padding-left:10px; "><strong>Inter&eacute;s:&nbsp;</strong></td><td><input name="Dtasa" tabindex="1" type="text" value="<cfif isdefined("dataPlan.Dtasa")>#LSNumberFormat(dataPlan.Dtasa,',9.00')#<cfelse>0.00</cfif>" size="10" maxlength="8" style="text-align: right;" onblur="javascript: fm(this,2); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" >%</td></tr>
					<tr><td nowrap style="padding-left:10px; "><strong>Inter&eacute;s Moratorio:&nbsp;</strong></td><td><input name="Dtasainteresmora" tabindex="1" type="text" value="<cfif isdefined("dataPlan.Dtasamora")>#LSNumberFormat(dataPlan.Dtasamora,',9.00')#<cfelse>0.00</cfif>" size="10" maxlength="8" style="text-align: right;" onblur="javascript: fm(this,2); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" >%</td></tr>
					<tr><td nowrap style="padding-left:10px; "><strong>N&uacute;mero de Cuotas restantes:&nbsp;</strong></td><td><input name="Dnumcuotas" tabindex="1" type="text"  value="<cfif isdefined("dataPlan.Dnumcuotas")>#LSNumberFormat(dataPlan.Dnumcuotas,',9.00')#<cfelse>0.00</cfif>" size="20" maxlength="14" style="text-align: right;" onblur="javascript: fm(this,2); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" ></td></tr>
					<tr><td valign="top" style="padding-left:10px; "><strong>Observaciones:&nbsp;</strong></td><td><cfif len(trim(dataPlan.Dobservacion))>#dataPlan.Dobservacion#<cfelse>-</cfif></td></tr>
					<tr><td colspan="2" align="center">
						<input type="submit" value="<< Regresar" name="btnRegresar2" onclick="document.form1.action='listaPlanPagos.cfm';">
						<input type="submit" value="Recalcular Cuotas" name="btnRecalcular">
					</td></tr>
					<tr><td colspan="2" align="center">&nbsp;</td></tr>
				</table>
	
				<!--- empleado y deduccion actuales --->
				<input type="hidden" name="DEid" value="#form.DEid#">
				<input type="hidden" name="Did" value="#form.Did#">
				<input type="hidden" name="TDid2" value="#form.TDid2#">
				<input type="hidden" name="Dperiodicidad" value="#rsPeriodicidad.Ttipopago#">
			</form>
		<cf_web_portlet_end>

		<cfif isdefined("Form.DEid") and Len(Trim(Form.DEid)) and isdefined("Form.Did") and Len(Trim(Form.Did))
		  and isdefined("Form.TDid2") and Len(Trim(Form.TDid2)) and isdefined("Form.PPnumero") and Len(Trim(Form.PPnumero))>
			<br>
			
			<cfquery name="rsTipoNomina" datasource="#session.DSN#">
				select Tcodigo 
				from LineaTiempo 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
				and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between LTdesde and LThasta 
			</cfquery>
			<!--- Si el empleado está cesado, buscar la ultima nomina en la cual estaba --->
			<cfif rsTipoNomina.recordCount EQ 0>
				<cfquery name="rsTipoNomina" datasource="#session.DSN#">
					select a.Tcodigo 
					from LineaTiempo a
					where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
					and a.LThasta = (
						select max(x.LThasta)
						from LineaTiempo x
						where x.DEid = a.DEid
						and x.Ecodigo = a.Ecodigo
					)
				</cfquery>
			</cfif>
	
			<script language="javascript" type="text/javascript">
				var popUpWin=0;
				function popUpWindow(URLStr, left, top, width, height)
				{
				  if(popUpWin)
				  {
			
					if(!popUpWin.closed) popUpWin.close();
				  }
				  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
				}

				function doConlisFecha() {
					popUpWindow("conlisFechas.cfm?Tcodigo=#Trim(rsTipoNomina.Tcodigo)#&ffecha=FechaCorte&fform=form2",250,200,400,360);
				}
			</script>
			
			<cfquery name="rsDatosPago" datasource="#Session.DSN#">
				select Did, PPnumero, Ecodigo, PPfecha_vence, PPsaldoant, PPprincipal, PPinteres, PPpagoprincipal, PPpagointeres, PPpagomora, PPfecha_pago, Mcodigo, PPtasa, PPtasamora, PPpagado, PPdocumento, IDcontable, BMUsucodigo, DEPextraordinario,
						case when PPfecha_pago is not null then PPpagoprincipal else PPprincipal end as MontoPrincipal,
						case when PPfecha_pago is not null then PPpagointeres else PPinteres end as MontoInteres,
						case when PPfecha_pago is not null then PPpagointeres+PPpagomora+PPpagoprincipal else PPprincipal+PPinteres end as Cuota,
						case when PPfecha_pago is not null then PPsaldoant-PPpagoprincipal else PPsaldoant-PPprincipal end as Saldo
				from DeduccionesEmpleadoPlan
				where Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Did#">
				and PPnumero = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.PPnumero#">
			</cfquery>
			
			<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Modificar Detalle de Pago">
				<form name="form2" method="post" style="margin:0; " action="planPagosCambiar-sql.cfm">
				
				<table width="100%" border="0" cellspacing="0" cellpadding="2">
				  <tr>
				    <td width="30%" style="padding-left:10px; "><strong>N&uacute;mero:</strong></td>
				    <td>#rsDatosPago.PPnumero#</td>
			      </tr>
				  <tr>
					<td style="padding-left:10px; "><strong>Fecha:</strong></td>
					<td>
						<input type="text" tabindex="1" size="10" maxlength="10" name="FechaCorte" readonly value="#LSDateFormat(rsDatosPago.PPfecha_vence, 'dd/mm/yyyy')#">
						<a href="javascript:doConlisFecha()"><img src="../../imagenes/DATE_D.gif" border="0"></a>
					</td>
				  </tr>
				  <tr>
				    <td style="padding-left:10px; "><strong>Principal:</strong></td>
				    <td>#LSNumberFormat(rsDatosPago.MontoPrincipal, ',9.00')#</td>
			      </tr>
				  <tr>
				    <td style="padding-left:10px; "><strong>Intereses:</strong></td>
				    <td>#LSNumberFormat(rsDatosPago.MontoInteres, ',9.00')#</td>
			      </tr>
				  <tr>
				    <td style="padding-left:10px; "><strong>Cuota:</strong></td>
				    <td>#LSNumberFormat(rsDatosPago.Cuota, ',9.00')#</td>
			      </tr>
				  <tr>
				    <td style="padding-left:10px; "><strong>Saldo:</strong></td>
				    <td>#LSNumberFormat(rsDatosPago.Saldo, ',9.00')#</td>
			      </tr>
				  <tr>
				    <td colspan="2" align="center">
						<input type="submit" value="Modificar" name="btnModificar">
					</td>
			      </tr>
				  <tr>
				    <td colspan="2">&nbsp;</td>
			      </tr>
				</table>
				<!--- empleado y deduccion actuales --->
				<input type="hidden" name="DEid" value="#form.DEid#">
				<input type="hidden" name="Did" value="#form.Did#">
				<input type="hidden" name="TDid2" value="#form.TDid2#">
				<input type="hidden" name="PPnumero" value="#Form.PPnumero#">
				<input type="hidden" name="Dperiodicidad" value="#rsPeriodicidad.Ttipopago#">

				<input type="hidden" name="Dmonto" value="<cfif len(trim(dataSaldo.PPsaldoactual)) >#dataSaldo.PPsaldoactual#<cfelse>0</cfif>">
				<input type="hidden" name="Dnumcuotas" value="<cfif isdefined("dataPlan.Dnumcuotas")>#LSNumberFormat(dataPlan.Dnumcuotas,',9.00')#<cfelse>0.00</cfif>">
				<input type="hidden" name="Dtasa" value="<cfif isdefined("dataPlan.Dtasa")>#LSNumberFormat(dataPlan.Dtasa,',9.00')#<cfelse>0.00</cfif>">
				<input type="hidden" name="Dtasainteresmora" value="<cfif isdefined("dataPlan.Dtasamora")>#LSNumberFormat(dataPlan.Dtasamora,',9.00')#<cfelse>0.00</cfif>">
				<input type="hidden" name="PPfecha_vence" value="#LSDateFormat(dataSaldo.PPfecha_vence,'dd/mm/yyyy')#">
				</form>
			<cf_web_portlet_end>
		</cfif>

	<cfelse>

		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Nuevo Plan de Pago">
			<cfinclude template="plan-financiamiento.cfm">

			<!--- muestar lista con nuevo financiamiento --->
			<form name="form1" method="post" style="margin:0; ">
				<table width="100%" cellpadding="2" cellspacing="0">
					<tr>
						<td>
							<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
								query="#calculo#"
								desplegar="PPnumero,img,fecha,principal,intereses,total,saldofinal"
								etiquetas="N&uacute;m,&nbsp;,Fecha,Principal,Intereses,Cuota,Saldo"
								formatos="S,S,D,M,M,M,M"
								align="right,left,left,right,right,right,right"
								checkboxes="N"
								checkedcol="pagado"
								funcion="void(0)"
								MaxRows="0"
								totales="total" keys="PPnumero"
								incluyeForm="false"	>
							</cfinvoke>				
						</td>
					</tr>
					<tr>
						<td colspan="2" align="center">
							<input type="submit" value="<< Regresar" name="btnRegresar">
							<input type="submit" value="Aceptar Plan de Pagos" name="btnRecalcular" onClick="javascript:return aceptar_plan();">
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
				</table>

				<input type="hidden" name="DEid" value="#form.DEid#">
				<input type="hidden" name="Did" value="#form.Did#">
				<input type="hidden" name="Dmonto" value="#form.Dmonto#">
				<input type="hidden" name="Dnumcuotas" value="#form.Dnumcuotas#">
				<input type="hidden" name="Dperiodicidad" value="#form.Dperiodicidad#">
				<input type="hidden" name="Dtasa" value="#form.Dtasa#">
				<input type="hidden" name="Dtasainteresmora" value="#form.Dtasainteresmora#">
				<input type="hidden" name="PPfecha_vence" value="#form.PPfecha_vence#">
				<input type="hidden" name="TDid2" value="#form.TDid2#">
			</form>
			
			<script type="text/javascript" language="javascript1.2">
				function aceptar_plan(){
					if ( confirm('Desea modificar el Plan de Pagos?') ) {
						document.form1.action = 'planPagosCambiar-sql.cfm';
						return true;
					}
					return false;
				}
			</script> 
			
		<cf_web_portlet_end>
	</cfif>
</cfoutput>
