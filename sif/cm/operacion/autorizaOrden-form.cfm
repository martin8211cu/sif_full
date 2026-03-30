<cfparam name="lvarProvCorp" default="false">
<cfparam name="form.Ecodigo_f" default="#session.ecodigo#">
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">

<cfquery name="rsLista" datasource="#session.DSN#">
	select a.CMAid,
		   a.CMAestado,
		   a.Nivel, 		
		   b.EOidorden, 
		   b.EOnumero,
		   b.EOfecha,
		   b.Observaciones, 
		   b.SNcodigo, 
		   b.CMCid,
		   d.CMCnombre, 
		   b.Mcodigo,
		   e.Mnombre, 
		   b.EOtc,
		   b.CMTOcodigo #_Cat# ' - ' #_Cat# c.CMTOdescripcion as CMTOdescripcion, 
		   b.EOtotal, 
    	   b.EOestado
	from CMAutorizaOrdenes a
	
	inner join EOrdenCM b
		on a.EOidorden=b.EOidorden
	 	and b.EOestado in (-7,-8,-9)
	 	<cfif isdefined("form.fEOnumero") and len(trim(form.fEOnumero))>
	 		and b.EOnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fEOnumero#">
		</cfif>
		 <cfif isdefined("form.fecha") and len(trim(form.fecha))>
			and b.EOfecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fecha)#"> and EOfecha < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',1,LSParseDateTime(form.fecha))#">
		 </cfif>

	inner join CMCompradores d
	on b.CMCid = d.CMCid --and b.Ecodigo=d.Ecodigo
	
	inner join CMTipoOrden c
	on b.CMTOcodigo=c.CMTOcodigo
	and b.Ecodigo=c.Ecodigo
<!--- *1* --->	
	inner join Monedas e
	on b.Mcodigo=e.Mcodigo
	and b.Ecodigo=e.Ecodigo
	
	where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo_f#">
	  and a.CMCid = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#session.compras.comprador#">
	  
	  and a.CMAestadoproceso not in (10,15)			-- no muestra rechazadas ni aprobadas(por todos)
	  
	  <cfif isdefined("form.CMAestado") and len(trim(form.CMAestado))>
	  	<cfif form.CMAestado eq 1>
			and a.CMAestadoproceso = 5
		<cfelse>
			and a.CMAestadoproceso < 10
		</cfif>
	  </cfif>

	order by b.CMTOcodigo, b.EOnumero
</cfquery>
<cfoutput>
<br>

<cfset registros = 0 >

<script type="text/javascript" language="javascript1.2" src="../../js/utilesMonto.js"></script>
<form name="filtro" method="post" action="" style="margin:0;">
<table width="99%" align="center" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td width="1%" nowrap><strong>No. Orden:&nbsp;</strong></td>
		<td><input type="text" name="fEOnumero" size="10" maxlength="10" value="<cfif isdefined("form.fEOnumero") and len(trim(form.fEOnumero))>#form.fEOnumero#</cfif>" onFocus="javascript:this.select();" style="text-align:right" onBlur="javascript:fm(this,0);" onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"></td>
		<td width="1%"><strong>Fecha:&nbsp;</strong></td>
		<td>
			 <cfset fecha = '' >
			 <cfif isdefined("form.fecha") and len(trim(form.fecha))>
				<cfset fecha = form.fecha >
			 </cfif>
			 <cf_sifcalendario form="filtro" value="#fecha#">
			
		</td>
		<td width="1%"><strong>Estado:&nbsp;</strong></td>
		<td>
			<select name="CMAestado">
				<option value="">Todos</option>
				<option value="0" <cfif isdefined("form.CMAestado") and form.CMAestado eq 0>selected</cfif>>Pendientes</option>
				<option value="1" <cfif isdefined("form.CMAestado") and form.CMAestado eq 1>selected</cfif>>Rechazados</option>
			</select>
		</td>
        <cfif lvarProvCorp>
        <td align="right" nowrap><strong>Empresa: </strong></td>
        <td colspan="3">
            <select name="Ecodigo_f">
                <cfloop query="rsDProvCorp">
                    <option value="<cfoutput>#rsDProvCorp.Ecodigo#</cfoutput>" <cfif (isdefined('form.Ecodigo_f') and form.Ecodigo_f eq rsDProvCorp.Ecodigo) or (not isdefined('form.Ecodigo_f') and rsDProvCorp.Ecodigo EQ Session.Ecodigo)> selected</cfif>><cfoutput>#rsDProvCorp.Edescripcion#</cfoutput></option>		
                </cfloop>	
            </select>
        </td>
      	</cfif>
		<td><input type="submit" class="btnFiltrar" name="btnFiltrar" value="Filtrar"></td>
	</tr>
</table>
</form>

<br>
<table width="900" border="0" align="center" cellpadding="0" cellspacing="0">
	<cfloop query="rsLista">
		<form name="form1" method="post" action="autorizaOrden-sql.cfm">
			<input type="hidden" name="CMAid" 		value="#rsLista.CMAid#">
			<input type="hidden" name="EOidorden" 	value="#rsLista.EOidorden#">
			<input type="hidden" name="Nivel" 		value="#rsLista.Nivel#">
			<cfif rsLista.nivel gt 0 >
				<cfquery name="rsValida" datasource="#session.DSN#">
					select CMAestado
					from CMAutorizaOrdenes
					where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLista.EOidorden#">
					  and CMAestado = 2
					  and Nivel = #rsLista.Nivel#-1
				</cfquery>
			</cfif>
			
				<cfquery name="rsDSLinea" datasource="#session.dsn#">
				   select distinct(b.CMPid) 
                   	from DOrdenCM a
					 inner join CMLineasProceso b
						 on a.DSlinea = b.DSlinea 
					where a.Ecodigo = #Session.Ecodigo# 
					 and a.EOidorden =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLista.EOidorden#">
				</cfquery>
				<cfif rsDSLinea.recordcount gt 0>
					<cfquery name="rsCodigoProceso" datasource="#session.dsn#" maxrows="1">
					 Select CMPcodigoProceso from CMProcesoCompra where Ecodigo = 	#Session.Ecodigo# and 
					 CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDSLinea.CMPid#">
					</cfquery>			
				</cfif>	
			
			<cfif ( rsLista.nivel eq 0 ) or (isdefined("rsValida") and rsValida.recordCount gt 0 and rsLista.CMAestado eq 0 ) >
				<tr class="<cfif rsLista.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>" >
					<td width="1%" nowrap ><strong></strong></td>
					<td width="1%" nowrap >&nbsp;</td>
					<td><strong></strong></td>
					<td>&nbsp;</td>
				</tr>
				<tr class="<cfif rsLista.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>" >
				    <td colspan="4">				  
				    <table width="100%" cellpadding="1" cellspacing="0">
							<tr>
							  <td colspan="4" nowrap><strong><font size="2">No. Orden: #rsLista.EOnumero#  #mid(rsLista.Observaciones,1,50)# <a href="javascript:verOrden('#rsLista.EOidorden#')" title="Consultar detalle de Orden de Compra"><img src="../../imagenes/findsmall.gif" border="0"></a></font></strong></td>
							  <td class="<cfif rsLista.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>"><!--- nivel mayor que cero --->
								<table border="0" cellpadding="0" cellspacing="0">
									<tr>										
										<td width="1%" nowrap colspan="2"><a href="javascript:funcProceso('#rsLista.EOidorden#')" title="Ver proceso">&nbsp;Ver Proceso</a></td>
										<td width="1%" nowrap colspan="2"><a href="javascript:seguimiento('#rsLista.EOidorden#')" title="Mostrar seguimiento seg&uacute;n la jerarqu&iacute;a">&nbsp;Ver Seguimiento</a></td>
									</tr>
									<tr><td colspan="4">&nbsp;</td></tr>
									<tr>
										<cfif rsLista.Nivel gt 0 >
											<td><input type="submit" name="btnAprobar" class="btnAplicar" value="Aprobar"></td>
											<td><input type="submit" name="btnRechazar" class="btnNormal" value="Rechazar" onclick="javascript:return EnviarNotificacion(this, '#rsLista.CMAid#');"></td>
											<input type="hidden" name="notificar" id="notificar" />
										<!--- nivel igual a cero --->
										<cfelse>
											<cfquery name="rsReiniciar" datasource="#session.DSN#">
												select 1 
												from CMAutorizaOrdenes 
												where Ecodigo =	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
												and EOidorden =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLista.EOidorden#">
												and CMAestadoproceso not in (10,15) and Nivel > 0 and CMAestado=1
											</cfquery>
											<td width="30%"><cfif rsReiniciar.recordCount gte 1 ><input type="submit" name="btnReiniciar" value="Reiniciar" onClick="return confirm('¿Esta seguro de que desea reiniciar el proceso?')" ></cfif></td>
											<td width="1%">&nbsp;</td>
										</cfif>
									</tr>
								</table>
                              </td>							  
					  </tr>
					        <cfif rsDSLinea.recordcount gt 0>
                           	 	<tr>
									<td nowrap="nowrap"><strong>Código del Proceso:</strong></td>
                                    <td><cfoutput> #rsCodigoProceso.CMPcodigoProceso#</cfoutput></td> 
								</tr> 
                            </cfif>
							<tr>
								<td width="8%" nowrap><strong>Estado:&nbsp;</strong></td>
								<td width="27%">
									<cfquery name="rsEstado" datasource="#session.DSN#">
										select CMAestado
										from CMAutorizaOrdenes
										where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLista.EOidorden#">
										  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
										  and CMAestadoproceso not in (10)
										  and Nivel = (select max(Nivel) from CMAutorizaOrdenes where CMAestadoproceso not in (10) and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLista.EOidorden#">)
								  	</cfquery>

									<cfif rsEstado.CMAestado eq 0>
										Pendiente
									<cfelseif rsEstado.CMAestado eq 1>
										Rechazado
									<cfelse>
										Aprobado
									</cfif>
								</td>
								<td width="11%" nowrap><strong>Moneda:&nbsp;</strong></td>
								<td width="25%">#rsLista.Mnombre#</td>
							    <td width="29%"><strong>Justificaci&oacute;n:</strong></td>
							</tr>	
							
							<tr>
								<td width="8%" nowrap><strong>Fecha:&nbsp;</strong></td>
								<td width="27%">#LSDateFormat(rsLista.EOfecha,'dd/mm/yyyy')#</td>
								<td width="11%" nowrap><strong>Tipo de Cambio:&nbsp;</strong></td>
								<td>#LSNumberFormat(rsLista.EOtc,',9.00')#</td>
							    <td rowspan="3"><textarea name="justificacion" id="justificacion_#rsLista.CMAid#" style="font-family:Arial, Helvetica, sans-serif;font-size:10px" rows="2" cols="60" wrap="soft"></textarea></td>
							</tr>	
							<tr>
								<td width="8%" nowrap><strong>Comprador:&nbsp;</strong></td>
								<td width="27%">#rsLista.CMCnombre#</td>
								<td width="11%" nowrap><strong>Monto:&nbsp;</strong></td>
							<td>#LSNumberFormat(rsLista.EOtotal,',9.00')#							    </tr>
							<tr>
							  <td nowrap>&nbsp;</td>
							  <td>&nbsp;</td>
							  <td nowrap>&nbsp;</td>
							  <td>                            
					  </tr>	
						</table>
					</td>
				</tr>
				<tr><td colspan="4"><hr size="1" color="##CCCCCC"></td></tr>
				<cfset registros = registros + 1 >
			</cfif>	
		</form>
	</cfloop>
	
	<cfif registros eq 0 >
		<tr><td>&nbsp;</td>
		  <td>&nbsp;</td>
		</tr>
		<tr><td align="center"><strong>-- No se encontraron registros --</strong></td>
		  <td align="center">&nbsp;</td>
		</tr>
		<tr><td>&nbsp;</td>
		  <td>&nbsp;</td>
		</tr>
	</cfif>
	 
	<tr><td align="center" colspan="4"><input type="button" name="Regresar" class="btnAnterior" value="Regresar" onClick="javascript:location.href='../MenuCM.cfm'" ></td></tr>

</table>
<form name="formProceso" action="autorizaOrden-listacotizaciones.cfm" method="post">
	<input type="hidden" name="EOidorden" value="">
</form>

</cfoutput>

<script language="javascript1.2" type="text/javascript">
	function seguimiento(id){
		window.open('autorizaSeguimiento.cfm?EOidorden='+id, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=600,height=300,left=300,top=225,screenX=150,screenY=150');
	}
	
	function funcProceso(parIDorden){
		document.formProceso.EOidorden.value = parIDorden;		
		document.formProceso.submit();
	}

	function verOrden(id){
		window.open('/cfmx/sif/cm/consultas/OrdenesCompra-vista.cfm?EOidorden='+id, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=900,height=650,left=130,top=50,screenX=150,screenY=150');
	}
	function EnviarNotificacion(btn, CMAid)
	{
		if(trim(document.getElementById('justificacion_'+CMAid).value) == ''){
			alert('La justificación es requerida para el rechazo')
			return false;	
		}
		
	 if(confirm("Desea enviar una notificación al comprador responsable?"))
		 document.getElementById('notificar').value=1;		 		 
	else
	     document.getElementById('notificar').value =0;	 				    
	    return true;
	}
</script>