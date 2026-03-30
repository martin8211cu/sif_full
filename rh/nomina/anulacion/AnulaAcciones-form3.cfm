<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="BTN_Aplicar"
	xmlfile="/rh/generales.xml"	
	Default="Aplicar"
	returnvariable="vAplicar"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="BTN_Anterior"
	xmlfile="/rh/generales.xml"	
	Default="Anterior"
	returnvariable="vAnterior"/>

<cfquery name="rsDatosEmpleado" datasource="#Session.DSN#">
	select {fn concat({fn concat({fn concat({ fn concat( a.DEnombre, ' ') }, a.DEapellido1)}, ' ')}, a.DEapellido2) } as NombreEmp,
		   a.NTIcodigo, 
		   a.DEidentificacion, 
		   b.NTIdescripcion

	from DatosEmpleado a
	
	inner join NTipoIdentificacion b
	on a.NTIcodigo = b.NTIcodigo

	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
</cfquery>

<cfquery name="rsDatosAccion" datasource="#Session.DSN#">
	select RHSPEid, 
		   {fn concat({fn concat( rtrim(b.RHTcodigo), ' - ' )}, b.RHTdesc)} as TipoAccion, 
		   c.DLobs, 
		   a.RHSPEfdesde as Fdesde, 
		   a.RHSPEfhasta as Fhasta,
		   c.DLfvigencia as Fdesde2, 
		   c.DLffin as Fhasta2,
		   a.DLlinea,
		   a.RHSPEdiasreb,
           c.RHJid
	from RHSaldoPagosExceso a
		inner join RHTipoAccion b
			on a.RHTid = b.RHTid and a.Ecodigo = b.Ecodigo
		inner join DLaboralesEmpleado c
			on a.DLlinea = c.DLlinea and a.DEid = c.DEid and a.Ecodigo = c.Ecodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	  and a.RHSPEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHSPEid#">
</cfquery>
<cfquery name="rsDiasJornada" datasource="#Session.DSN#">
	select RHJsun, RHJmon, RHJtue, RHJwed, RHJthu, RHJfri, RHJsat
    from RHJornadas
    where RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosAccion.RHJid#">
</cfquery>

<cfquery name="rsAfectaAccion" datasource="#Session.DSN#">
	select  DLfvigencia as Fdesde, 
	   		DLffin as Fhasta,
	   		DLobs
	from DLaboralesEmpleado
	where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
	  and DLreferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosAccion.DLlinea#">
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by DLlinea
</cfquery>
<script language="javascript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
<cfoutput>
<script language="javascript" type="text/javascript">
	
	var DiasJornada = [#rsDiasJornada.RHJmon#, #rsDiasJornada.RHJtue#, #rsDiasJornada.RHJwed#, #rsDiasJornada.RHJthu#, #rsDiasJornada.RHJfri#, #rsDiasJornada.RHJsat#, #rsDiasJornada.RHJsun#];
	
	function calcDays() {
		fNuevaHasta = document.form1.FNuevohasta.value.split("/");
		fNuevaHasta = new Date(parseInt(fNuevaHasta[2], 10), parseInt(fNuevaHasta[1], 10)-1, parseInt(fNuevaHasta[0], 10));
		fMax = document.form1.FMax.value.split("/");
		fMax = new Date(parseInt(fMax[2], 10), parseInt(fMax[1], 10)-1, parseInt(fMax[0], 10)-1);
		fMin = document.form1.FMin.value.split("/");
		fMin = new Date(parseInt(fMin[2], 10), parseInt(fMin[1], 10)-1, parseInt(fMin[0], 10));
		if(fNuevaHasta.getTime()  > fMax.getTime())
			fNuevaHasta = fMax;
		if(fNuevaHasta.getTime()  < fMin.getTime())
			fNuevaHasta = fMin;
		fIni = fMin;
		diasSusp = 0;
		while(fIni.getTime() <= fNuevaHasta.getTime()){
			if(DiasJornada[fIni.getDay()])
				diasSusp = diasSusp + 1;
			fIni = new Date(parseInt(fIni.valueOf() + 86400000));
		}
		var mes  = fNuevaHasta.getMonth() + 1;
		var mes = ( mes < 10 ) ? '0'+mes : mes;
		var dia = fNuevaHasta.getDate();
		var dia = ( dia < 10 ) ? '0'+dia : dia;
		document.form1.FNuevohasta.value = dia + "/" + mes + "/" + fNuevaHasta.getFullYear().toString();
		document.form1.dias.value = diasSusp;
		document.form1.diasd.value = parseInt(document.form1.RHSPEdiasreb.value,10) - diasSusp;
		
	}
	
	function calcFecha(d) {
		if(d < 1)
			d = 1;
		if(d > parseInt(document.form1.RHSPEdiasreb.value))
			d =  parseInt(document.form1.RHSPEdiasreb.value);
		fNuevaHasta = document.form1.FMin.value.split("/");
		fNuevaHasta = new Date(parseInt(fNuevaHasta[2], 10), parseInt(fNuevaHasta[1], 10)-1, parseInt(fNuevaHasta[0], 10));
		dr = d;
		while(dr > 1){
			if(DiasJornada[fNuevaHasta.getDay()])
				dr = dr - 1;
			fNuevaHasta = new Date(parseInt(fNuevaHasta.valueOf() + 86400000));
		}
		var mes  = fNuevaHasta.getMonth() + 1;
		var mes = ( mes < 10 ) ? '0'+mes : mes;
		var dia = fNuevaHasta.getDate();
		var dia = ( dia < 10 ) ? '0'+dia : dia;
		document.form1.FNuevohasta.value = dia + "/" + mes + "/" + fNuevaHasta.getFullYear().toString();
		document.form1.dias.value = d;
		document.form1.diasd.value = parseInt(document.form1.RHSPEdiasreb.value,10) - d;
	}

	function checkDays() {
		var a = document.form1.Fdesde.value.split("/");
		var ini = new Date(parseInt(a[2], 10), parseInt(a[1], 10)-1, parseInt(a[0], 10));
		var b = document.form1.FNuevohasta.value.split("/");
		var fin = new Date(parseInt(b[2], 10), parseInt(b[1], 10)-1, parseInt(b[0], 10));
		var dif = ((fin-ini)/86400000.0)+1;	// diferencia en días
		if (parseInt(document.form1.dias.value, 10) > parseInt(dif, 10)) {
			alert('La cantidad de días no debe sobrepasar la diferencia de días entre Fecha Rige y Fecha Vence');
			return false;
		}
		if (parseInt(document.form1.dias.value, 10) >= parseInt(document.form1.RHSPEdiasreb.value, 10)) {
			alert('La cantidad de días no debe sobrepasar los días rebajados');
			return false;
		}
		if (parseInt(document.form1.dias.value, 10) <= 0) {
			alert('La cantidad de días debe ser mayor que cero');
			return false;
		}
		return true;
	}

	function goPrevious(f) {
		f.action = 'AnulaAcciones.cfm';
		f.paso.value = "2";
		f.submit();
	}

	function validar(f) {
		if (document.form1.FNuevohasta.value == '') {
			alert('Debe indicar la nueva Fecha Vence');
			return false;
		}
		if (document.form1.dias.value == '') {
			alert('Debe indicar la cantididad de días');
			return false;
		}
		//calcDays();
		if (f.rdAnulacion.value == '1') {
			if (!checkDays()) {
				return false;
			}
		}
		var a = document.form1.FNuevohasta.value.split("/");
		var finNuevo = new Date(parseInt(a[2], 10), parseInt(a[1], 10)-1, parseInt(a[0], 10));
		var b = document.form1.FhastaMax.value.split("/");
		var fin = new Date(parseInt(b[2], 10), parseInt(b[1], 10)-1, parseInt(b[0], 10));
		if (finNuevo <= fin) {
			return true;
		} else {
			alert('La nueva Fecha Vence no puede ser mayor a '+document.form1.FhastaMax.value);
			return false;
		}
	}
	
	function showFechas(t) {
		var a = document.getElementById("trFechas");
		if (a && t) {
			a.style.display = '';
		} else if (a) {
			a.style.display = 'none';
		}
	}

</script>

	<form name="form1" method="post" action="AnulaAcciones-sql.cfm" onSubmit="javascript: return validar(this);">
		<input type="hidden" name="paso" value="2">
		<input type="hidden" name="DEid" value="#Form.DEid#">
		<input type="hidden" name="RHSPEdiasreb" value="#rsDatosAccion.RHSPEdiasreb#">
		<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
		  <tr>
			<td align="center" valign="top">&nbsp;</td>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td align="center" valign="top">
				<table width="95%" border="0" cellspacing="0" cellpadding="2">
				  <tr>
					<td colspan="4" nowrap>
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
						  <tr>
							<td width="1%"><img src="/cfmx/rh/imagenes/num3.gif" width="45" height="45" border="0"></td>
							<td align="left"><strong style="font-family:'Times New Roman', Times, serif; font-size:14pt; font-variant:small-caps; font-weight:bolder; padding-left:20px"><cf_translate key="LB_Anular_Accion" >Anular Acci&oacute;n</cf_translate></strong></td>
						  </tr>
						</table>
					</td>
				  </tr>
				  <tr>
					<td colspan="4" class="tituloListas" nowrap><cf_translate key="LB_Datos_de_Accion_Original">Datos de Acci&oacute;n Original</cf_translate></td>
				  </tr>
				  <tr>
				    <td align="right" nowrap class="fileLabel"><cf_translate key="LB_Empleado" xmlfile="/rh/generales.xml">Empleado</cf_translate>:</td>
				    <td valign="middle" nowrap>#rsDatosEmpleado.NombreEmp#</td>
				    <td align="right" class="fileLabel" nowrap><cf_translate key="LB_Identificacion" xmlfile="/rh/generales.xml">Identificaci&oacute;n</cf_translate>:</td>
				    <td valign="middle" nowrap>#rsDatosEmpleado.DEidentificacion#</td>
			      </tr>
				  <tr>
					<td align="right" nowrap class="fileLabel"><cf_translate key="LB_Accion" xmlfile="/rh/generales.xml">Acci&oacute;n</cf_translate>:</td>
					<td valign="middle" nowrap> 
						<input type="hidden" name="RHSPEid" value="#Form.RHSPEid#">
						#rsDatosAccion.TipoAccion#
					</td>
			        <td align="right" class="fileLabel" nowrap>&nbsp;</td>
			        <td valign="middle" nowrap>&nbsp;</td>
		          </tr>
				  <tr>
			        <td align="right" class="fileLabel" nowrap><cf_translate key="LB_Fecha_Rige">Fecha Rige</cf_translate>:</td>
			        <td valign="middle" nowrap>
						<input type="hidden" name="Fdesde" value="#LSDateFormat(rsDatosAccion.Fdesde,'dd/mm/yyyy')#">
						#LSDateFormat(rsDatosAccion.Fdesde2,'dd/mm/yyyy')#
					</td>
			        <td align="right" class="fileLabel" nowrap><cf_translate key="LB_Fecha_Vence">Fecha Vence</cf_translate>:</td>
			        <td valign="middle" nowrap>
						<input type="hidden" name="Fhasta" value="#LSDateFormat(rsDatosAccion.Fhasta,'dd/mm/yyyy')#">
						#LSDateFormat(rsDatosAccion.Fhasta2,'dd/mm/yyyy')#
					</td>
		          </tr>
				  <tr>
					<td align="right" nowrap class="fileLabel"><cf_translate key="LB_Observacion">Observaci&oacute;n</cf_translate>:</td>
					<td colspan="3" nowrap>
						<input type="hidden" name="Observacion" value="#rsDatosAccion.DLobs#">
						#rsDatosAccion.DLobs#
					</td>
				  </tr>
                  <tr>
					<td align="right" nowrap class="fileLabel"><cf_translate key="LB_DiasDisfrutados">D&iacute;as Disfrutados</cf_translate>:</td>
					<td colspan="3" nowrap>#rsDatosAccion.RHSPEdiasreb#</td>
				  </tr>
				  <cfif rsAfectaAccion.recordCount GT 0>
				  <tr>
					<td colspan="4" class="tituloListas" nowrap><cf_translate key="LB_Movimientos_en_la_Accion_Original">Movimientos en la Acci&oacute;n Original</cf_translate></td>
				  </tr>
				  <tr>
				    <td colspan="4" nowrap>
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
						  <tr>
							<td style="border-bottom: 1px solid black "><strong><cf_translate key="LB_Descripcion" xmlfile="/rh/generales.xml">Descripci&oacute;n</cf_translate></strong></td>
							<td align="center" style="border-bottom: 1px solid black "><strong><cf_translate key="LB_Fecha_Rige">Fecha Rige</cf_translate></strong></td>
							<td align="center" style="border-bottom: 1px solid black "><strong><cf_translate key="LB_Fecha_Vence">Fecha Vence</cf_translate></strong></td>
						  </tr>
						  <cfloop query="rsAfectaAccion">
							  <tr>
								<td style="border-bottom: 1px solid gray ">#rsAfectaAccion.DLobs#</td>
								<td align="center" style="border-bottom: 1px solid gray ">#LSDateFormat(rsAfectaAccion.Fdesde,'dd/mm/yyyy')#</td>
								<td align="center" style="border-bottom: 1px solid gray "><cfif len(trim(rsAfectaAccion.Fhasta))>#LSDateFormat(rsAfectaAccion.Fhasta,'dd/mm/yyyy')#<cfelse>null</cfif></td>
							  </tr>
						  </cfloop>
						</table>
					</td>
			      </tr>
				  </cfif>
				  <tr>
					<td colspan="4" class="tituloListas" nowrap><cf_translate key="LB_Suspension_o_Anulacion_de_Accion">Suspensi&oacute;n o Anulaci&oacute;n de Acci&oacute;n</cf_translate></td>
				  </tr>
				  <tr>
					<td colspan="4" nowrap>
					  <input name="rdAnulacion" type="radio" value="1" onClick="javascript: showFechas(true);" checked>Suspender
					  <input name="rdAnulacion" type="radio" value="2" onClick="javascript: showFechas(false);">Anulaci&oacute;n
					</td>
				  </tr>
				  <tr id="trFechas">
				    <td colspan="4" nowrap>
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
						  <tr>
								<td align="right" nowrap class="fileLabel"><cf_translate key="LB_Fecha_Rige">Fecha Rige</cf_translate>:</td>
								<td nowrap>
									#LSDateFormat(rsDatosAccion.Fdesde,'dd/mm/yyyy')#
								</td>
								<td align="right" nowrap class="fileLabel"><cf_translate key="LB_Fecha_Vence">Fecha Vence</cf_translate>: </td>
								<td nowrap>
									<cf_sifcalendario name="FNuevohasta" value="#LSDateFormat(DateAdd('d',-1,rsDatosAccion.Fhasta),'dd/mm/yyyy')#" onBlur="calcDays()" onChange="calcDays()">
									<input type="hidden" name="FMax" value="#LSDateFormat(rsDatosAccion.Fhasta,'dd/mm/yyyy')#">
                                    <input type="hidden" name="FMin" value="#LSDateFormat(rsDatosAccion.Fdesde,'dd/mm/yyyy')#">
								</td>
								<td align="right" nowrap class="fileLabel">&nbsp;<cf_translate key="LB_Dias_Reales_Disfrutados">D&iacute;as Reales Disfrutados</cf_translate>: </td>
								<td nowrap>
									<input type="text" name="dias" size="10" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,-1); calcFecha(this.value)"  onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="#numberformat(rsDatosAccion.RHSPEdiasreb-1,'9')#">
								</td>
                                <td align="right" nowrap class="fileLabel">&nbsp;<cf_translate key="LB_Dias_Devueltos">D&iacute;as Devueltos</cf_translate>: </td>
                                <td nowrap>
									<input type="text" name="diasd" readonly="readonly" size="10" value="1" style="text-align: right; background-color:##CCC">
								</td>
						  </tr>
						</table>
					</td>
			      </tr>
				  <tr>
					<td colspan="4" nowrap>&nbsp;</td>
				  </tr>
				  <tr>
					<td colspan="4" align="center" nowrap>
						<input type="button" name="Anterior" value="<< #vAnterior#" onClick="javascript: goPrevious(this.form);">
						<input type="submit" name="Aplicar" value="#vAplicar#" >
					</td>
				  </tr>
				</table>
			</td>
			<td width="200" align="center" valign="top" style="padding-right: 10px; padding-left: 10px; ">
				<cfinclude template="frame-Progreso.cfm">
			</td>
		  </tr>
		</table>
	</form>
</cfoutput>

<!---
<script language="javascript" type="text/javascript">
	calcDays();
</script>
--->
