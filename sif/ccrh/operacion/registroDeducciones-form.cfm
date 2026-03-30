 <!---  <cfdump  label="U" var="#url#">
<cfdump  label="F" var="#form#">  --->
<cfif isdefined("Url.RHIDid") and not isdefined("Form.RHIDid")>
	<cfset Form.RHIDid = Url.RHIDid>
</cfif>

<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
	<cfset Form.DEid = Url.DEid>
</cfif>

<cfif isdefined("Form.RHIDid") and len(trim(#Form.RHIDid#))NEQ 0>

	<cfset modo= "CAMBIO">
	
	<cfquery name="rsDeduccion" datasource="#session.DSN#">
		select * from RHInclusionDeducciones 
		where RHIDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHIDid#"> 
	</cfquery>
	
	<cfset form.DEid = #rsDeduccion.DEid#>
	
<cfelse>
	
	<cfset modo= "ALTA">

</cfif>

<cfif isdefined("Form.DEid") and len(trim(#Form.DEid#)) NEQ 0 >
	<cfquery name="rsTipoNomina" datasource="#session.DSN#">
		select Tcodigo 
		from LineaTiempo 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
		and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between LTdesde and LThasta 
	</cfquery>
	
	<!--- Si el empleado está cesado, buscar la ultima nomina en la cual estaba --->
	<cfif rsTipoNomina.recordCount EQ 0>
		<cfquery name="rsTipoNomina" datasource="#session.DSN#">
			select a.Tcodigo 
			from LineaTiempo a
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
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
	
	<cfquery name="rsFechasValidas" datasource="#session.DSN#">
		select * 
		from CalendarioPagos 
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Tcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsTipoNomina.Tcodigo)#">
		  and CPfcalculo is null
		order by CPfcalculo
	</cfquery>
		
</cfif>	
 
<script language="JavaScript" type="text/javascript" src="../../js/calendar.js">//</script>
<script language="JavaScript" type="text/javascript" src="../../js/utilesMonto.js">//</script>
<script language="JavaScript" src="../../js/qForms/qforms.js">//</script>

<script language="JavaScript1.2" type="text/javascript">

	function funcDEid() {
		document.form1.action = '<cfoutput>#GetFileFromPath(GetTemplatePath())#</cfoutput>';
		document.form1.submit();
	}

function validar(){
	var error = false;
	var mensaje   = "Se presentaron los siguientes errores:\n";
	var f = document.form1;
	
	if(document.form1.bandera.value != "N")
	{
		if ( f.TDcodigo.value == '' ){
			error = true;
			mensaje += " - El campo Tipo de Deducción es requerido.\n";
		}
	
		if ( f.RHIDreferencia.value == '' ){
			error = true;
			mensaje += " - El campo Referencia es requerido.\n";
		}
	
		if ( f.RHIDdesc.value == '' ){
			error = true;
			mensaje += " - El campo Descripcion es requerido.\n";
		}
	
		if ( f.SNcodigo.value == '' ){
			error = true;
			mensaje += " - El campo Socio de Negocios es requerido.\n";
		}
	
		if ( (f.RHIDmonto.value == '') ||(f.RHIDmonto.value == 0.00)){
			error = true;
			mensaje += " - El campo Monto es requerido.\n";
		}
	
		if ( f.RHIDtasa.value == '' ){
			error = true;
			mensaje += " - El campo Tasa de Interés es requerido.\n";
		}
	
		if ( f.RHIDfechadesde.value == '' ){
			error = true;
			mensaje += " - El campo Fecha Inicial es requerido.\n";
		}
	
		if (( f.RHIDcuotas.value == '' )||(f.RHIDcuotas.value == 0.00)){
			error = true;
			mensaje += " - El campo Número de Cuotas es requerido.\n";
		}
		
		if ( error ){
			alert(mensaje);
			return false;
		}
		else{
			document.form1.RHIDtasa.value    = qf(document.form1.RHIDtasa.value);
			document.form1.RHIDmonto.value    = qf(document.form1.RHIDmonto.value);
			document.form1.RHIDcuotas.value    = qf(document.form1.RHIDcuotas.value);
			return true;
		}
	}
}

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
		<!--- popUpWindow("conlisFechas.cfm?Tcodigo=<cfoutput>#trim(rsTipoNomina.Tcodigo)#</cfoutput>",250,200,400,360); --->
		popUpWindow("conlisFechas.cfm?Tcodigo="+document.form1.Tcodigo.value,250,200,400,360);
	}
</script>

<cfoutput>
<form method="post" name="form1" action="registroDeduccionesInclusion-sql.cfm" onSubmit="javascript:return validar();" >
	
	<input type="hidden" name="bandera" value=""> 
	
	<cfif isdefined("Form.RHIDid") and Len(Trim(form.RHIDid)) NEQ 0>
		<input type="hidden" name="RHIDid" value="#Trim(form.RHIDid)#"> 
	</cfif>
	<input type="hidden" name="Tcodigo" value="<cfif isdefined("rsTipoNomina")>#trim(rsTipoNomina.Tcodigo)#</cfif>"> 
	<input type="hidden" name="Dperiodicidad" value="<cfif isdefined("rsPeriodicidad")>#rsPeriodicidad.Ttipopago#</cfif>"> 
	<table width="80%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>
			
		<tr>
			<td colspan="3">
				<font color="azul">
					<!--- mensaje de reciente modificacion --->
					<cfif isdefined("url.modifica")>
						<cfoutput><br>Se ha modificado con exito la deducción número: #form.RHIDid#</cfoutput>
					</cfif>
				</font>
			</td>
		</tr>
		<tr>
			<td colspan="2"  class="fileLabel">Empleado</td>
		</tr>
		<tr> 
			<td colspan="2">
				<cfif isdefined("Form.DEid") and len(trim(#Form.DEid#)) NEQ 0>		
					<cf_rhempleado tabindex="1" size = "50" idempleado="#Form.DEid#">
					
					<cfif #rsTipoNomina.recordCount# EQ 0 or #rsPeriodicidad.recordCount# EQ 0 or #rsFechasValidas.recordCount# EQ 0 >
						<cfoutput> A este empleado no se le pueden aplicar deducciones 
								  debido a que no se le ha asignado un calendario de pago.</cfoutput>
								 
					</cfif>
				<cfelse>
					<cf_rhempleado tabindex="1" size = "50">
				</cfif>
			</td>
			<td align="right"> 
				<!--- debe esxistri esta estructura en session --->
				<cfif isdefined("Form.DEid") and len(trim(#Form.DEid#)) NEQ 0>					
					<cfif not isdefined("session.deduccion_empleado")and isdefined("Form.RHIDid") and Len(Trim(Form.RHIDid)) and #rsTipoNomina.recordCount# NEQ 0 and #rsPeriodicidad.recordCount# NEQ 0 and #rsFechasValidas.recordCount# NEQ 0>
                      <input  type="submit"  name="btnPlanPagos"   value="Ver plan de pagos"onClick="javascript: return verPlanPagos();">
</cfif>		
				</cfif>
			</td>
		</tr>	
		
		<tr>
			<td colspan="2"  class="fileLabel">Tipo de Deducción</td>
			<td class="fileLabel">Referencia</td>
		</tr>
		
		<tr> 
			<td colspan="2">
				<cfif modo EQ 'CAMBIO' and isdefined("rsDeduccion.TDid")>
					<cfquery name="dataTDeduccion" datasource="#session.DSN#" >
						select TDid, TDcodigo, TDdescripcion
						from TDeduccion
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDeduccion.TDid#">
					</cfquery>
					<cf_rhtipodeduccion size="60" validate="1" financiada="1" tabindex="1" query="#dataTDeduccion#">
				<cfelse>
					<cf_rhtipodeduccion size="60" validate="1" financiada="1" tabindex="1">
				</cfif>
			</td>
			<td><input name="RHIDreferencia" tabindex="1" type="text" id="RHIDreferencia" onFocus="this.select();" value="<cfif modo EQ 'CAMBIO' and  isdefined("rsDeduccion.RHIDreferencia")>#rsDeduccion.RHIDreferencia#</cfif>" size="30" maxlength="20"></td>
		</tr>
		
		<tr>
			<td colspan="2" class="fileLabel">Descripci&oacute;n</td>
			<td class="fileLabel">Socio</td>
		</tr>
		
		<tr>
			<td colspan="2" ><input name="RHIDdesc" tabindex="1" type="text" id="RHIDdesc" onFocus="this.select();" value="<cfif modo EQ 'CAMBIO' and isdefined("rsDeduccion.RHIDdesc")>#rsDeduccion.RHIDdesc#</cfif>" size="74" maxlength="80"></td>
			<td>
				<cfset id = '' >
				<cfif modo EQ 'CAMBIO' and isdefined("rsDeduccion.SNcodigo")>
					<cfset id = rsDeduccion.SNcodigo >
				</cfif>
				<cf_sifsociosnegocios2 tabindex="1" idquery="#id#">
			</td>
		</tr>

		<tr> 
			<td colspan="2" class="fileLabel">Monto</td>
			<td rowspan="2">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td class="fileLabel">Inter&eacute;s</td>
						<td class="fileLabel">Inter&eacute;s moratorio</td>
					</tr>
					<tr>
						<td width="1%" nowrap><input name="RHIDtasa" tabindex="1" type="text" value="<cfif modo EQ 'CAMBIO' and isdefined("rsDeduccion.RHIDtasa")>#LSNumberFormat(rsDeduccion.RHIDtasa,',_.__')#<cfelse>0.00</cfif>" size="10" maxlength="8" style="text-align: right;" onblur="javascript: fm(this,2); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" >%&nbsp;</td>
						<td><input name="RHIDtasamora" tabindex="1" type="text" value="<cfif modo EQ 'CAMBIO' and isdefined("rsDeduccion.RHIDtasamora")>#LSNumberFormat(rsDeduccion.RHIDtasamora,',_.__')#<cfelse>0.00</cfif>" size="10" maxlength="8" style="text-align: right;" onblur="javascript: fm(this,2); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" >%</td>
					</tr>
				</table>
			</td>
		</tr>
		
		<tr> 
			<td colspan="2"><input name="RHIDmonto" tabindex="1" type="text" value="<cfif modo EQ 'CAMBIO' and isdefined("rsDeduccion.RHIDmonto")>#LSNumberFormat(rsDeduccion.RHIDmonto,',_.__')#<cfelse>0.00</cfif>" size="30" maxlength="14" style="text-align: right;" onblur="javascript: fm(this,2);"  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" ></td>
		</tr>

		<tr>
			<td class="fileLabel">Fecha Documento</td>
			<td class="fileLabel">Fecha Inicial</td>
			<td class="fileLabel">N&uacute;mero de Cuotas</td>
		</tr>
		
		<tr>
			<td>
				<cfif modo NEQ 'CAMBIO'> 
						<cfset value="#LSDateFormat(Now(), 'DD/MM/YYYY')#">
				<cfelse>	
						<cfset value="#LSDateFormat(rsDeduccion.RHIDfechadoc, 'dd/mm/yyyy')#">
						<!--- <cfset value="#rsDeduccion.RHIDfechadoc#"> --->
				</cfif> 
				<cf_sifcalendario form="form1" name="RHIDfechadoc" value="#value#">
			</td>
			<td>
				<cfif modo NEQ 'CAMBIO'> 
						<cfset value="">
				<cfelse>	
						<cfset value="#LSDateFormat(rsDeduccion.RHIDfechadesde, 'DD/MM/YYYY')#">
				</cfif> 
				<input type="text" tabindex="1" size="10" maxlength="10" name="RHIDfechadesde" readonly value="#value#">
				<cfif isdefined("Form.DEid") and len(trim(#Form.DEid#)) NEQ 0>				
					<cfif #rsTipoNomina.recordCount# NEQ 0 and #rsPeriodicidad.recordCount# NEQ 0 and #rsFechasValidas.recordCount# NEQ 0 >	
						<a href="javascript:doConlisFecha()"><img src="../../imagenes/DATE_D.gif" border="0"></a>
					</cfif>
				</cfif>	
			</td>	
			
			<td><input name="RHIDcuotas" tabindex="1" type="text"  value="<cfif modo EQ 'CAMBIO' and isdefined("rsDeduccion.RHIDcuotas")>#LSNumberFormat(rsDeduccion.RHIDcuotas,',9.00')#<cfelse>0.00</cfif>" size="20" maxlength="14" style="text-align: right;" onblur="javascript: fm(this,2); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" ></td>					
		</tr>	

		<tr>
			<td colspan="2" class="fileLabel">Observaciones</td>
		</tr>
		<tr>
			<td colspan="3"><textarea tabindex="1" name="RHIDObs" rows="3" cols="70"><cfif modo EQ 'CAMBIO' and isdefined("rsDeduccion.RHIDobs")>#rsDeduccion.RHIDobs#</cfif></textarea></td>
		</tr>
		
		<tr><td colspan="2">&nbsp;</td></tr>
		
		<tr>
			<td colspan="3">
				<cfif isdefined("Form.DEid") and len(trim(#Form.DEid#)) NEQ 0>		
					<cfif #rsTipoNomina.recordCount# NEQ 0 and #rsPeriodicidad.recordCount# NEQ 0 and #rsFechasValidas.recordCount# NEQ 0 >
						<cfif modo neq "ALTA">
							<cf_botones modo="CAMBIO" values="Modificar,Eliminar,Nuevo,Aplicar">
							<cfelse>						  
							<cf_botones modo="ALTA">
						</cfif>
					</cfif>
				</cfif>	
				
			</td>
			<!--- <td colspan="3" align="center"><input type="submit" name="Aceptar" value="Calcular"></td> --->
		</tr>

	</table>
	<!--- deducciones--->
</form>
</cfoutput>
<script language="javascript" type="text/javascript">
	function verPlanPagos(){
		document.form1.RHIDmonto.value = qf(document.form1.RHIDmonto.value);
		document.form1.action='registroDeducciones-sql.cfm?RHIDid=#form.RHIDid#';
		document.form1.submit();
		return false;
	}
	
	function funcEliminar() {
		if (confirm('Esta seguro de que desea eliminar la deduccion?')) {
			document.form1.bandera.value="N";
			return true;
		} else {
			return false;
		}
	}
	
	function funcNuevo(){
		document.form1.bandera.value="N";
	}
	
	function funcAplicar() {
		if (confirm('Esta seguro de que desea Aplicar la deduccion?')) {
			document.form1.bandera.value="N";
			return true;
		} else {
			return false;
		}
	}
</script>