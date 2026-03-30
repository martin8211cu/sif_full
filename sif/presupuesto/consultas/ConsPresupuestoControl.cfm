<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cfquery name="rsPresupuestoControl" datasource="#Session.DSN#">
	select 	a.CPPid, 
				case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
					#_Cat# ' de ' #_Cat# 
					case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
					#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}">
					#_Cat# ' a ' #_Cat# 
					case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
					#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}">
			as Pdescripcion,
			a.CPCano, 
			a.CPCmes, 
			case 
				a.CPCmes when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end 
			as Mdescripcion,
			a.CPcuenta, c.CPformato,
			(select CPCPcalculoControl from CPCuentaPeriodo where Ecodigo=#session.Ecodigo# and CPPid=#session.CPPid# and CPcuenta=c.CPcuenta) 
			as CPCPcalculoControl,
			coalesce(case (select CPCPcalculoControl from CPCuentaPeriodo where Ecodigo=#session.Ecodigo# and CPPid=#session.CPPid# and CPcuenta=c.CPcuenta)
				when 1 then 'MENSUAL' 
				when 2 then 'ACUMULADO'
				else 'TOTAL'
			end, 'N/A')	as CalculoControl,
			coalesce(case (select CPCPtipoControl from CPCuentaPeriodo where Ecodigo=#session.Ecodigo# and CPPid=#session.CPPid# and CPcuenta=c.CPcuenta)
				when 0 then 'ABIERTO' 
				when 1 then 'RESTRINGIDO'
				else 'RESTRICTIVO'
			end, 'N/A')	as TipoControl,
			a.Ocodigo, o.Odescripcion,
			e.Mcodigo, m.Mnombre
	  from CPresupuestoControl a, CPresupuestoPeriodo p, CPresupuesto c, Oficinas o, Empresas e, Monedas m
	 where a.Ecodigo	= #session.Ecodigo#
	   and a.CPPid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CPPid#">
	   and a.CPCano 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CPCano#">
	   and a.CPCmes 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CPCmes#">
	   and a.CPcuenta 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPcuenta#">
	   and a.Ocodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ocodigo#">
	   and p.Ecodigo	= a.Ecodigo
	   and p.CPPid 		= a.CPPid
	   and o.Ecodigo	= a.Ecodigo
	   and o.Ocodigo	= a.Ocodigo
	   and e.Ecodigo 	= a.Ecodigo
	   and m.Ecodigo 	= e.Ecodigo
	   and m.Mcodigo 	= e.Mcodigo
	   and c.CPcuenta 	= a.CPcuenta
</cfquery>
<cfquery name="rsPresupuestoControlMes" datasource="#Session.DSN#">
	select 
		   a.CPCpresupuestado, 
		   a.CPCmodificado,
		   a.CPCmodificacion_Excesos, 
		   a.CPCvariacion, 
		   a.CPCtrasladado, 
		   a.CPCtrasladadoE, 
		   a.CPCmodificacion_Excesos, 

		   a.CPCreservado_Anterior, 
		   a.CPCcomprometido_Anterior, 
		   a.CPCreservado_Presupuesto, 
		   a.CPCreservado, 
		   a.CPCcomprometido, 

		   a.CPCejecutado, a.CPCejecutadoNC,
		   (a.CPCejecutado + a.CPCejecutadoNC) - case when a.CPCejercido <> 0 then a.CPCejercido else a.CPCpagado end as CPCdevengado,
		   case when a.CPCejercido <> 0 then a.CPCejercido-a.CPCpagado else 0 end as CPCejercido,
		   a.CPCpagado as CPCpagado,

		   a.CPCnrpsPendientes,

		   a.CPCpresupuestado			+
		   a.CPCmodificado				+ 
		   a.CPCmodificacion_Excesos +
		   a.CPCvariacion				+
		   a.CPCtrasladado				+
		   a.CPCtrasladadoE				as PresupuestoAutorizado, 
		   a.CPCreservado_Anterior 		+
		   a.CPCcomprometido_Anterior 	+
		   a.CPCreservado_Presupuesto 	+
		   a.CPCreservado		+ 
		   a.CPCcomprometido	+ 
		   a.CPCejecutado + a.CPCejecutadoNC
		   								as PresupuestoConsumido,
		   a.CPCpresupuestado			+
		   a.CPCmodificado 				+
		   a.CPCmodificacion_Excesos +
		   a.CPCvariacion 				+
		   a.CPCtrasladado				+
		   a.CPCtrasladadoE				-
		   a.CPCreservado_Anterior 		-
		   a.CPCcomprometido_Anterior 	-
		   a.CPCreservado_Presupuesto 	-
		   a.CPCreservado		- 
		   a.CPCcomprometido	- 
		   a.CPCejecutado - a.CPCejecutadoNC
		   								as PresupuestoDisponible
	  from CPresupuestoControl a
	 where a.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CPPid#">
	   and a.CPCano = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CPCano#">
	   and a.CPCmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CPCmes#">
	   and a.CPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPcuenta#">
	   and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ocodigo#">
</cfquery>
<cfquery name="rsPresupuestoControlAcumulado" datasource="#Session.DSN#">
	select 
		   sum(	a.CPCpresupuestado			) as CPCpresupuestado, 
		   sum(	a.CPCmodificado				) as CPCmodificado, 
		   sum(	a.CPCmodificacion_Excesos) as CPCmodificacion_Excesos, 
		   sum(	a.CPCvariacion				) as CPCvariacion, 
		   sum(	a.CPCtrasladado				) as CPCtrasladado, 
		   sum(	a.CPCtrasladadoE			) as CPCtrasladadoE, 

		   sum(	a.CPCreservado_Anterior		) as CPCreservado_Anterior, 
		   sum(	a.CPCcomprometido_Anterior	) as CPCcomprometido_Anterior, 
		   sum(	a.CPCreservado_Presupuesto	) as CPCreservado_Presupuesto, 
		   sum(	a.CPCreservado				) as CPCreservado, 
		   sum(	a.CPCcomprometido			) as CPCcomprometido, 

		   sum(a.CPCejecutado) as CPCejecutado, sum(a.CPCejecutadoNC) as CPCejecutadoNC,
		    
		   sum(	(a.CPCejecutado+a.CPCejecutadoNC) - case when a.CPCejercido <> 0 then a.CPCejercido else a.CPCpagado end ) as CPCdevengado,
		   sum(	case when a.CPCejercido <> 0 then a.CPCejercido-a.CPCpagado else 0 end ) as CPCejercido,
		   sum(	a.CPCpagado					) as CPCpagado,

		   sum(	a.CPCnrpsPendientes			) as CPCnrpsPendientes,

		   sum(	a.CPCpresupuestado			+
				a.CPCmodificado				+
				a.CPCmodificacion_Excesos +
				a.CPCvariacion				+
				a.CPCtrasladado				+
				a.CPCtrasladadoE 			) as PresupuestoAutorizado, 
		   sum(	a.CPCreservado_Anterior 	+
				a.CPCcomprometido_Anterior 	+
				a.CPCreservado_Presupuesto 	+
				a.CPCreservado				+ 
				a.CPCcomprometido			+ 
				a.CPCejecutado + a.CPCejecutadoNC
											) as PresupuestoConsumido,
		   sum(	a.CPCpresupuestado			+
				a.CPCmodificado				+
				a.CPCmodificacion_Excesos	+
				a.CPCvariacion				+
				a.CPCtrasladado				+
				a.CPCtrasladadoE 			-
				a.CPCreservado_Anterior 	-
				a.CPCcomprometido_Anterior 	-
				a.CPCreservado_Presupuesto 	-
				a.CPCreservado				-
				a.CPCcomprometido			-
				a.CPCejecutado - a.CPCejecutadoNC
											) as PresupuestoDisponible
	from CPresupuestoControl a
	where a.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CPPid#">
	<cfif rsPresupuestoControl.CPCPcalculoControl EQ 1>
	and a.CPCano = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CPCano#">
	and a.CPCmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CPCmes#">
	<cfelseif rsPresupuestoControl.CPCPcalculoControl EQ 2>
	and 
		(a.CPCano < <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CPCano#">
	  OR a.CPCano = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CPCano#">
	 and a.CPCmes <= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CPCmes#">
		)
	</cfif>
	and a.CPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPcuenta#">
	and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ocodigo#">
</cfquery>

<cfoutput>
<style type="text/css">
<!--
.vidFrame { 
             display: none;
             background-color: ##CCCCCC;
             border: 4px ridge ##dddddd;
             cursor: move;
			 text-align:center;
			 font-weight:bolder;
			 font-size:16px;
          }
-->
</style>

<script language="JavaScript" type="text/javascript">
<!--
   function playVid(vidId) {
      if (vidPaneID.style.display=='block') {
         vidPaneID.style.display='none';
      } else {
         vidPaneID.style.display='block';
      }
   }

   function moveHandler(e){
      if (e == null) { e = window.event } 
      if (e.button<=1&&dragOK){
         savedTarget.style.left=e.clientX-dragXoffset+'px';
         savedTarget.style.top=e.clientY-dragYoffset+'px';
         return false;
      }
   }

   function dropHandler(e) {
      document.onmousemove=null;
      document.onmouseup=null;
      savedTarget.style.cursor=orgCursor;
      dragOK=false;
      setTmpLocCookie ('vidPane_left',savedTarget.style.left);
      setTmpLocCookie ('vidPane_top',savedTarget.style.top);
   }

   function dragHandler(e)
   {
      var htype='-moz-grabbing';
      if (e == null) { e = window.event; htype='move';} 
      var target = e.target != null ? e.target : e.srcElement;
      orgCursor=target.style.cursor;
      if (target.className=="vidFrame") 
	  {
         savedTarget=target;       
         target.style.cursor=htype;
         dragOK=true;
         dragXoffset=e.clientX-parseInt(vidPaneID.style.left);
         dragYoffset=e.clientY-parseInt(vidPaneID.style.top);
         document.onmousemove=moveHandler;
         document.onmouseup=dropHandler;
		 
         return false;
	  }
	}

	function setTmpLocCookie(name,value) 
	{
		 //var others = "; expires="+date.toGMTString()"; path=/";
		 document.cookie = name+"="+value;
	}
	
	function getTmpLocCookie(name) 
	{
		var nameEQ = name + "=";
		var ca = document.cookie.split(';');
		var resultValue = ''
		for(var i=0;i < ca.length;i++) 
		{
		  var c = ca[i];
		  while (c.charAt(0)==' ')
			c = c.substring(1,c.length);
		  if (c.indexOf(nameEQ) == 0) 
			resultValue =  c.substring(nameEQ.length,c.length);
		}
		return resultValue;
	}
	
	function delTmpLocCookie(name) 
	{
		createCookie(name,"",-1);
		document.cookie = name+"=;"+value+"; expires="+(new Date(0)).toGMTString();
	}

//-->
</script>
<!--- Despliegue de Datos de Presupuesto --->
<div id='vidPane' class='vidFrame'>
<div id="divPrincipal" style=" border:3px outset ##CCCCCC; position:static; float:left; left=0px; cursor:pointer; font-size:10px; text-align:center;" onmousedown="this.style.borderStyle='inset';" onclick="document.getElementById('vidPane').style.display='none';">&nbsp;X&nbsp;</div>
<div style=" border:3px outset ##CCCCCC; position:static; float:left; left=0px; cursor:pointer; font-size:10px; text-align:center;" onmousedown="this.style.borderStyle='inset';" onmouseout="this.style.borderStyle='outset';" onclick="chgPosition();" id="vidArrow"> v </div>
Control de Presupuesto
<div style="background-color: ##FFFFFF; cursor:auto">
<table width="10%" border="0" cellspacing="0" cellpadding="1" style="border-top: 1px solid black;">
  <tr>
	<td class="fileLabel" align="right" nowrap width="50%">Período Presupuestario:&nbsp;</td>
	<td colspan="2" nowrap>#rsPresupuestoControl.Pdescripcion#</td>
	<td align="right" nowrap width="10%">&nbsp;</td>
  </tr>
  <tr>
	<td class="fileLabel" align="right" nowrap>Mes Presupuestario:&nbsp;</td>
	<td colspan="2" nowrap>#rsPresupuestoControl.CPCano#-#rsPresupuestoControl.Mdescripcion#</td>
	<td align="right" nowrap>&nbsp;</td>
  </tr>
  <tr>
	<td class="fileLabel" align="right" nowrap>Cuenta de Presupuesto:&nbsp;</td>
	<td colspan="2" nowrap>#rsPresupuestoControl.CPformato#</td>
	<td align="right" nowrap>&nbsp;</td>
  </tr>
  <tr>
	<td class="fileLabel" align="right" nowrap>Oficina:&nbsp;</td>
	<td colspan="2" nowrap>#rsPresupuestoControl.Odescripcion#</td>
	<td align="right" nowrap>&nbsp;</td>
  </tr>
  <tr>
	<td class="fileLabel" align="right" nowrap>Montos en Moneda Local:&nbsp;</td>
	<td colspan="2" nowrap>#rsPresupuestoControl.Mnombre#</td>
	<td align="right" nowrap>&nbsp;</td>
  </tr>
  <tr>
	<td class="fileLabel" align="right" nowrap>Tipo Control: #rsPresupuestoControl.TipoControl#&nbsp;</td>
	<td class="fileLabel" colspan="2" nowrap>Método Control: #rsPresupuestoControl.CalculoControl#</td>
	<td align="right" nowrap>&nbsp;</td>
  </tr>
  <tr>
	<td colspan="4" align="center">
		<form name="frmDetalle" method="post" action="" style="margin:0">
			<input type="hidden" name="CPPid" value="#session.CPPid#">
			<input type="hidden" name="CPCano" value="#Form.CPCano#">
			<input type="hidden" name="CPCmes" value="#Form.CPCmes#">
			<input type="hidden" name="Ocodigo" value="#Form.Ocodigo#">
			<input type="hidden" name="CPcuenta" value="#Form.CPcuenta#">
			<cfif not isdefined("LvarSinDetalles")>
			<input type="submit" value="Detalle de NAPs" onClick="javascript: this.form.action = 'ConsPresupuesto-detallesNAP.cfm'">
			<input type="submit" value="Detalle de NRPs" onClick="javascript: this.form.action = 'ConsPresupuesto-detallesNRP.cfm'">
			</cfif>
		</form>
	</td>
  </tr>
  <tr bgcolor="##CCCCCC">
	<td align="right" nowrap class="fileLabel" style="font-weight:bold; border-top: 1px solid black;border-bottom: 1px solid black;">PARTIDA</td>
	<td align="right" nowrap style="font-weight:bold; border-top: 1px solid black;border-bottom: 1px solid black;">&nbsp;&nbsp;ASIGNADO AL MES</td>
	<td align="right" nowrap style="font-weight:bold; border-top: 1px solid black;border-bottom: 1px solid black;">&nbsp;&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>#rsPresupuestoControl.CalculoControl#</cfif></td>
	<td align="right" nowrap style="font-weight:bold; border-top: 1px solid black;border-bottom: 1px solid black;">&nbsp;</td>
  </tr>
  <tr>
	<td align="right" nowrap class="fileLabel">Presupuesto Ordinario: </td>
	<td align="right" nowrap>#LSNumberFormat(rsPresupuestoControlMes.CPCpresupuestado, ',9.00')#</td>
	<td align="right" nowrap>&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>#LSNumberFormat(rsPresupuestoControlAcumulado.CPCpresupuestado, ',9.00')#</cfif></td>
	<td align="right" nowrap>&nbsp;</td>
  </tr>
  <tr>
	<td align="right" nowrap class="fileLabel">Presupuesto Extraordinario: </td>
	<td align="right" nowrap>#LSNumberFormat(rsPresupuestoControlMes.CPCmodificado, ',9.00')#</td>
	<td align="right" nowrap>&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>#LSNumberFormat(rsPresupuestoControlAcumulado.CPCmodificado, ',9.00')#</cfif></td>
	<td align="right" nowrap>&nbsp;</td>
  </tr>
  <tr>
	<td align="right" nowrap class="fileLabel">Excesos Autorizados:</td>
	<td align="right" nowrap>#LSNumberFormat(rsPresupuestoControlMes.CPCmodificacion_Excesos, ',9.00')#</td>
	<td align="right" nowrap>&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>#LSNumberFormat(rsPresupuestoControlAcumulado.CPCmodificacion_Excesos, ',9.00')#</cfif></td>
	<td align="right" nowrap>&nbsp;</td>
  </tr>
  <tr>
	<td align="right" nowrap class="fileLabel">Monto por Variacion Cambiaria: </td>
	<td align="right" nowrap>#LSNumberFormat(rsPresupuestoControlMes.CPCvariacion, ',9.00')#</td>
	<td align="right" nowrap>&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>#LSNumberFormat(rsPresupuestoControlAcumulado.CPCvariacion, ',9.00')#</cfif></td>
	<td align="right" nowrap>&nbsp;</td>
  </tr>
  <tr>
	<td align="right" nowrap class="fileLabel">Monto Trasladado: </td>
	<td align="right" nowrap>#LSNumberFormat(rsPresupuestoControlMes.CPCtrasladado, ',9.00')#</td>
	<td align="right" nowrap>&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>#LSNumberFormat(rsPresupuestoControlAcumulado.CPCtrasladado, ',9.00')#</cfif></td>
	<td align="right" nowrap>&nbsp;</td>
  </tr>
  <tr>
	<td align="right" nowrap class="fileLabel">Traslados con Autorización Externa: </td>
	<td align="right" nowrap>#LSNumberFormat(rsPresupuestoControlMes.CPCtrasladadoE, ',9.00')#</td>
	<td align="right" nowrap>&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>#LSNumberFormat(rsPresupuestoControlAcumulado.CPCtrasladadoE, ',9.00')#</cfif></td>
	<td align="right" nowrap>&nbsp;</td>
  </tr>
  <tr bgcolor="##CCCCCC">
	<td align="right" nowrap class="fileLabel" style="border-top: 1px solid black;border-bottom: 1px solid black;">TOTAL PRESUPUESTO AUTORIZADO: </td>
	<td align="right" nowrap style="border-top: 1px solid black;border-bottom: 1px solid black;">(+)&nbsp;#LSNumberFormat(rsPresupuestoControlMes.PresupuestoAutorizado, ',9.00')#</td>
	<td align="right" nowrap style="border-top: 1px solid black;border-bottom: 1px solid black;">&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>(+)&nbsp;#LSNumberFormat(rsPresupuestoControlAcumulado.PresupuestoAutorizado, ',9.00')#</cfif></td>
	<td align="right" nowrap style="border-top: 1px solid black;border-bottom: 1px solid black;">&nbsp;</td>
  </tr>
  <tr>
	<td align="right" nowrap class="fileLabel">Reservado Período Anterior: </td>
	<td align="right" nowrap>#LSNumberFormat(rsPresupuestoControlMes.CPCreservado_Anterior, ',9.00')#</td>
	<td align="right" nowrap>&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>#LSNumberFormat(rsPresupuestoControlAcumulado.CPCreservado_Anterior, ',9.00')#</cfif></td>
	<td align="right" nowrap>&nbsp;</td>
  </tr>
  <tr>
	<td align="right" nowrap class="fileLabel">Comprometido Período Anterior: </td>
	<td align="right" nowrap>#LSNumberFormat(rsPresupuestoControlMes.CPCcomprometido_Anterior, ',9.00')#</td>
	<td align="right" nowrap>&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>#LSNumberFormat(rsPresupuestoControlAcumulado.CPCcomprometido_Anterior, ',9.00')#</cfif></td>
	<td align="right" nowrap>&nbsp;</td>
  </tr>
  <tr>
	<td align="right" nowrap class="fileLabel">Provisión Presupuestaria: </td>
	<td align="right" nowrap>#LSNumberFormat(rsPresupuestoControlMes.CPCreservado_Presupuesto, ',9.00')#</td>
	<td align="right" nowrap>&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>#LSNumberFormat(rsPresupuestoControlAcumulado.CPCreservado_Presupuesto, ',9.00')#</cfif></td>
	<td align="right" nowrap>&nbsp;</td>
  </tr>
  <tr>
	<td align="right" nowrap class="fileLabel">Reservado: </td>
	<td align="right" nowrap>#LSNumberFormat(rsPresupuestoControlMes.CPCreservado, ',9.00')#</td>
	<td align="right" nowrap>&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>#LSNumberFormat(rsPresupuestoControlAcumulado.CPCreservado, ',9.00')#</cfif></td>
	<td align="right" nowrap>&nbsp;</td>
  </tr>
  <tr>
	<td align="right" nowrap class="fileLabel">Comprometido: </td>
	<td align="right" nowrap>#LSNumberFormat(rsPresupuestoControlMes.CPCcomprometido, ',9.00')#</td>
	<td align="right" nowrap>&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>#LSNumberFormat(rsPresupuestoControlAcumulado.CPCcomprometido, ',9.00')#</cfif></td>
	<td align="right" nowrap>&nbsp;</td>
  </tr>
  <tr>
	<td align="right" nowrap class="fileLabel">Monto Ejecutado Contable: </td>
	<td align="right" nowrap>#LSNumberFormat(rsPresupuestoControlMes.CPCejecutado, ',9.00')#</td>
	<td align="right" nowrap>&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>#LSNumberFormat(rsPresupuestoControlAcumulado.CPCejecutado, ',9.00')#</cfif></td>
	<td align="right" nowrap>&nbsp;</td>
  </tr>
  <tr>
	<td align="right" nowrap class="fileLabel">Monto Ejecutado No Contable: </td>
	<td align="right" nowrap>#LSNumberFormat(rsPresupuestoControlMes.CPCejecutadoNC, ',9.00')#</td>
	<td align="right" nowrap>&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>#LSNumberFormat(rsPresupuestoControlAcumulado.CPCejecutadoNC, ',9.00')#</cfif></td>
	<td align="right" nowrap>&nbsp;</td>
  </tr>
  <tr bgcolor="##CCCCCC">
	<td align="right" nowrap class="fileLabel" style="border-bottom: 1px solid black;border-top: 1px solid black;">TOTAL PRESUPUESTO CONSUMIDO: </td>
	<td align="right" nowrap style="border-bottom: 1px solid black;border-top: 1px solid black;">(-)&nbsp;#LSNumberFormat(rsPresupuestoControlMes.PresupuestoConsumido, ',9.00')#</td>
	<td align="right" nowrap style="border-bottom: 1px solid black;border-top: 1px solid black;">&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>(-)&nbsp;#LSNumberFormat(rsPresupuestoControlAcumulado.PresupuestoConsumido, ',9.00')#</cfif></td>
	<td align="right" nowrap style="border-bottom: 1px solid black;border-top: 1px solid black;">&nbsp;</td>
  </tr>
  <tr>
	<td colspan="4">&nbsp;</td>
  </tr>
  <tr bgcolor="##CCCCCC">
	<td align="right" nowrap class="fileLabel" style="border-top: 1px solid black;border-bottom: 1px solid black;">PRESUPUESTO DISPONIBLE ACTUAL: </td>
	<td align="right" nowrap style="border-top: 1px solid black;border-bottom: 1px solid black; font-weight:bold">#LSNumberFormat(rsPresupuestoControlMes.PresupuestoDisponible, ',9.00')#</td>
	<td align="right" nowrap style="border-top: 1px solid black;border-bottom: 1px solid black; font-weight:bold">&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>#LSNumberFormat(rsPresupuestoControlAcumulado.PresupuestoDisponible, ',9.00')#</cfif></td>
	<td align="right" nowrap style="border-top: 1px solid black;border-bottom: 1px solid black;">&nbsp;</td>
  </tr>
  <tr>
	<td colspan="4">&nbsp;</td>
  </tr>
  <tr>
	<td colspan="4">&nbsp;</td>
  </tr>
  <tr bgcolor="##EEEEEE">
	<td align="right" nowrap class="fileLabel" style="border-top: 1px solid black;border-bottom: 1px solid black;font-weight:bold;">EJECUTADO TOTAL: </td>
	<td align="right" nowrap style="border-top: 1px solid black;border-bottom: 1px solid black; font-weight:bold">#LSNumberFormat(rsPresupuestoControlMes.CPCejecutado+rsPresupuestoControlMes.CPCejecutadoNC, ',9.00')#</td>
	<td align="right" nowrap style="border-top: 1px solid black;border-bottom: 1px solid black; font-weight:bold">&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>#LSNumberFormat(rsPresupuestoControlAcumulado.CPCejecutado+rsPresupuestoControlAcumulado.CPCejecutadoNC, ',9.00')#</cfif></td>
	<td align="right" nowrap style="border-top: 1px solid black;border-bottom: 1px solid black;">&nbsp;</td>
  </tr>
  <tr bgcolor="##EEEEEE">
	<td align="right" nowrap class="fileLabel" style="">DEVENGADO: </td>
	<td align="right" nowrap style="font-weight:bold">#LSNumberFormat(rsPresupuestoControlMes.CPCdevengado, ',9.00')#</td>
	<td align="right" nowrap style="font-weight:bold">&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>#LSNumberFormat(rsPresupuestoControlAcumulado.CPCdevengado, ',9.00')#</cfif></td>
	<td align="right" nowrap style="">&nbsp;</td>
  </tr>
  <cfif rsPresupuestoControlMes.CPCejercido NEQ 0>
  <tr bgcolor="##EEEEEE">
	<td align="right" nowrap class="fileLabel" style="">EJERCIDO: </td>
	<td align="right" nowrap style="font-weight:bold">#LSNumberFormat(rsPresupuestoControlMes.CPCejercido, ',9.00')#</td>
	<td align="right" nowrap style="font-weight:bold">&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>#LSNumberFormat(rsPresupuestoControlAcumulado.CPCejercido, ',9.00')#</cfif></td>
	<td align="right" nowrap style="">&nbsp;</td>
  </tr>
  </cfif>
  <tr bgcolor="##EEEEEE">
	<td align="right" nowrap class="fileLabel" style=";border-bottom: 1px solid black;">PAGADO: </td>
	<td align="right" nowrap style="border-bottom: 1px solid black; font-weight:bold">#LSNumberFormat(rsPresupuestoControlMes.CPCpagado, ',9.00')#</td>
	<td align="right" nowrap style="border-bottom: 1px solid black; font-weight:bold">&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>#LSNumberFormat(rsPresupuestoControlAcumulado.CPCpagado, ',9.00')#</cfif></td>
	<td align="right" nowrap style="border-bottom: 1px solid black;">&nbsp;</td>
  </tr>
  <tr>
	<td colspan="4">&nbsp;</td>
  </tr>
  <cfif rsPresupuestoControlMes.CPCnrpsPendientes NEQ 0 OR rsPresupuestoControl.CPCPcalculoControl NEQ 1 AND rsPresupuestoControlAcumulado.CPCnrpsPendientes NEQ 0>
	  <cfset LvarDisponibleNetoMes 			= rsPresupuestoControlMes.PresupuestoDisponible			+ rsPresupuestoControlMes.CPCnrpsPendientes>
	  <cfset LvarDisponibleNetoAcumulado 	= rsPresupuestoControlAcumulado.PresupuestoDisponible	+ rsPresupuestoControlAcumulado.CPCnrpsPendientes>
	  <tr bgcolor="##CCCCCC">
		<td align="right" nowrap class="fileLabel" style="border-bottom: 1px solid black;border-top: 1px solid black;">NRPs Aprobados Pendientes de Aplicar: </td>
		<td align="right" nowrap style="border-bottom: 1px solid black;border-top: 1px solid black;">#LSNumberFormat(rsPresupuestoControlMes.CPCnrpsPendientes, ',9.00')#</td>
		<td align="right" nowrap style="border-bottom: 1px solid black;border-top: 1px solid black;">&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>(+)&nbsp;#LSNumberFormat(rsPresupuestoControlAcumulado.CPCnrpsPendientes, ',9.00')#</cfif></td>
		<td align="right" nowrap style="border-bottom: 1px solid black;border-top: 1px solid black;">&nbsp;</td>
	  </tr>
	  <tr>
		<td colspan="4">&nbsp;</td>
	  </tr>
	  <tr bgcolor="##CCCCCC">
		<td align="right" nowrap class="fileLabel" style="border-top: 1px solid black;border-bottom: 1px solid black;">DISPONIBLE NETO ACTUAL: </td>
		<td align="right" nowrap style="<cfif LvarDisponibleNetoMes LT 0>color:##FF0000;</cfif>border-top: 1px solid black;border-bottom: 1px solid black; font-weight:bold">#LSNumberFormat(LvarDisponibleNetoMes, ',9.00')#</td>
		<td align="right" nowrap style="<cfif LvarDisponibleNetoAcumulado LT 0>color:##FF0000;</cfif>border-top: 1px solid black;border-bottom: 1px solid black; font-weight:bold">&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>#LSNumberFormat(LvarDisponibleNetoAcumulado, ',9.00')#</cfif></td>
		<td align="right" nowrap style="border-top: 1px solid black;border-bottom: 1px solid black;">&nbsp;</td>
	  </tr>
  </cfif>
  <cfif isdefined("form.CVPcuenta")>
		<cfquery name="rsTotalModificacionMes" datasource="#session.dsn#">
			select 
				coalesce(CVFTmontoAplicar,0) as colonesModificar
			  from CVFormulacionTotales a
			 where a.Ecodigo = #session.ecodigo#
			   and a.CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cvid#">
			   and a.CPCano = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cpcano#">
			   and a.CPCmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cpcmes#">
			   and a.CVPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cvpcuenta#">
			   and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ocodigo#">
		</cfquery>

		<cfset LvarModificaMes = rsTotalModificacionMes.colonesModificar>
		<cfif LvarModificaMes EQ "">
			<cfset LvarModificaMes = 0>
		</cfif>

		<cfset LvarDisponibleMes = rsPresupuestoControlMes.PresupuestoDisponible + rsPresupuestoControlMes.CPCnrpsPendientes + LvarModificaMes>
		<cfquery name="rsTotalModificacionAcum" datasource="#session.dsn#">
			select 
				coalesce(sum(CVFTmontoAplicar),0) as colonesModificar
			  from CVFormulacionTotales a
			 where a.Ecodigo = #session.ecodigo#
			   and a.CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cvid#">
			<cfif rsPresupuestoControl.CPCPcalculoControl EQ 1>
			   and a.CPCano = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CPCano#">
			   and a.CPCmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CPCmes#">
			<cfelseif rsPresupuestoControl.CPCPcalculoControl EQ 2>
			   and 
				   (a.CPCano < <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CPCano#">
			     OR a.CPCano = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CPCano#">
			    and a.CPCmes <= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CPCmes#">
				   )
			</cfif>
			   and a.CVPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cvpcuenta#">
			   and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ocodigo#">
		</cfquery>
		<cfset LvarModificaAcum = rsTotalModificacionAcum.colonesModificar>
		<cfset LvarDisponibleAcum = rsPresupuestoControlAcumulado.PresupuestoDisponible + rsPresupuestoControlAcumulado.CPCnrpsPendientes + LvarModificaAcum>
  <tr>
	<td colspan="4">&nbsp;</td>
  </tr>
  <tr bgcolor="##CCCCCC">
	<td align="right" nowrap class="fileLabel" style="color:<cfif LvarModificaAcum LT 0>##FF0000;<cfelse>##3333CC;</cfif>border-top: 1px solid black;">Total Modificación Solicitada: </td>
	<td align="right" nowrap style="color:<cfif LvarModificaMes LT 0>##FF0000;<cfelse>##3333CC;</cfif>border-top: 1px solid black;">#LSNumberFormat(LvarModificaMes, ',9.00')#</td>
	<td align="right" nowrap style="color:<cfif LvarModificaAcum LT 0>##FF0000;<cfelse>##3333CC;</cfif>border-top: 1px solid black;">&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>(*)#LSNumberFormat(LvarModificaAcum, ',9.00')#</cfif></td>
	<td align="right" nowrap style="border-top: 1px solid black;">&nbsp;</td>
  </tr>
  <tr bgcolor="##CCCCCC">
	<td align="right" nowrap class="fileLabel" style="color:<cfif LvarDisponibleAcum LT 0>##FF0000;<cfelse>##3333CC;</cfif>border-top: 1px solid black;border-bottom: 1px solid black;">(**) Total <cfif LvarDisponibleAcum GTE 0>Disponible<cfelse>Exceso</cfif> Tentativo: </td>
	<td align="right" nowrap style="color:<cfif LvarDisponibleMes LT 0>##FF0000;<cfelse>##3333CC;</cfif>border-top: 1px solid black;border-bottom: 1px solid black;">#LSNumberFormat(LvarDisponibleMes, ',9.00')#</td>
	<td align="right" nowrap style="color:<cfif LvarDisponibleAcum LT 0>##FF0000;<cfelse>##3333CC;</cfif>border-top: 1px solid black;border-bottom: 1px solid black;">&nbsp;<cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>(*)#LSNumberFormat(LvarDisponibleAcum, ',9.00')#</cfif></td>
	<td align="right" nowrap style="border-top: 1px solid black;border-bottom: 1px solid black;">&nbsp;</td>
  </tr>
  <cfif rsPresupuestoControl.CPCPcalculoControl NEQ 1>
  <tr>
	<td colspan="4" style="">
		&nbsp;&nbsp;&nbsp;(*)&nbsp;&nbsp; Incluye solicitudes en otros meses<BR>
		&nbsp;&nbsp;&nbsp;(**) El monto disponible/exceso no es un valor fijo, cambia en linea<BR>
	</td>
  </tr>
  </cfif>
 </cfif>
</table>
<!--- Fin Despliegue de Datos de Presupuesto --->
</div>
</div>
<script language="JavaScript" type="text/javascript">
<!--
	var savedTarget=null; // The target layer (effectively vidPane)
	var orgCursor=null;   // The original Cursor (mouse) Style so we can restore it
	var dragOK=false;     // True if we're allowed to move the element under mouse
	var dragXoffset=0;    // How much we've moved the element on the horozontal
	var dragYoffset=0;    // How much we've moved the element on the verticle
	vidPaneID = document.getElementById('vidPane'); // Our movable layer

	var LvarLeft = getTmpLocCookie ('vidPane_left');
	var LvarTop = getTmpLocCookie ('vidPane_top');
	if (LvarLeft == "")
		LvarLeft='350px';
	else if (parseInt(LvarLeft) < 0 || parseInt(LvarLeft) > screen.width-200)
		LvarLeft='350px';
	if (LvarTop == "")
		LvarTop='250px';
	else if (parseInt(LvarTop) < 0 || parseInt(LvarTop) > screen.height-200)
		LvarTop='250px';
		
	vidPaneID.style.top=LvarTop;                     // Starting location horozontal
	vidPaneID.style.left=LvarLeft;                    // Starting location verticle
	document.onmousedown=dragHandler;

	var GvarPosition = getTmpLocCookie('Position');
	function chgPosition()
	{
		var vidPaneElement;
		var vidArrowElement;
		vidPaneElement = document.getElementById('vidPane');
		vidArrowElement = document.getElementById('vidArrow');
		if (GvarPosition == 1)
		{
			GvarPosition = 0;
			vidPaneElement.style.position='static';
			vidArrowElement.innerHTML='&nbsp;v&nbsp;';
		}
		else
		{
			GvarPosition = 1;
			vidPaneElement.style.position='absolute';
			vidArrowElement.innerHTML='&nbsp;^&nbsp;';
		}
		vidArrowElement.style.borderStyle='outset';
		setTmpLocCookie('Position',GvarPosition)
		vidPaneID.style.display='block';
	}

	if (GvarPosition == '')	GvarPosition = 0;
	if (GvarPosition == 0)
		GvarPosition = 1;
	else
		GvarPosition = 0;
	window.setTimeout("chgPosition()",1);

//-->
</script>

</cfoutput>
