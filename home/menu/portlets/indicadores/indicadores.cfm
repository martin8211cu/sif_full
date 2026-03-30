<cfset indicadores_cfm_start = GetTickCount()>
<cfset fecha_indicadores = Now()>

<cfquery datasource="asp" name="mis_indicadores">
	select i.indicador, i.nombre_indicador, coalesce (i.filtro_tiempo, 0) as filtro_tiempo
	from IndicadorUsuario iu
		join Indicador i
			on iu.indicador = i.indicador
	where iu.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	and iu.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
	order by i.nombre_indicador, iu.posicion
</cfquery>

<cfif mis_indicadores.RecordCount is 0>
	<cfquery datasource="asp" name="mis_indicadores">
		select i.indicador, i.nombre_indicador, coalesce (i.filtro_tiempo, 0) as filtro_tiempo
		from Indicador i
		where i.es_default = 1
		  and i.publicado = 1
		order by i.nombre_indicador, i.posicion
	</cfquery>
</cfif>

<cfinvoke component="home.Componentes.IndicadorBase" method="indicador_tiempos" returnvariable="indicador_tiempos"></cfinvoke>

<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="translate"></cfinvoke>

<script type="text/javascript">
<!--
	ind_cur_sel = 0;
	ind_cur_stop = 0;
	function ind_obj(x){return document.all?document.all[x]:document.getElementById(x)};
	function ind_row_out(n){
		if (ind_cur_sel==n) {
			ind_obj('tdindic_L_' +ind_cur_sel).style.borderColor=
			ind_obj('tdindic_M1_'+ind_cur_sel).style.borderColor=
			ind_obj('tdindic_M2_'+ind_cur_sel).style.borderColor=
			ind_obj('tdindic_M3_'+ind_cur_sel).style.borderColor=
			ind_obj('tdindic_M4_'+ind_cur_sel).style.borderColor=
			ind_obj('tdindic_R_' +ind_cur_sel).style.borderColor='white';
			ind_cur_sel = 0;
		}
	}
	function ind_row_over(n){
		ind_obj('tdindic_L_' +n).style.borderColor='black white black black';
		ind_obj('tdindic_M1_'+n).style.borderColor=
		ind_obj('tdindic_M2_'+n).style.borderColor=
		ind_obj('tdindic_M3_'+n).style.borderColor=
		ind_obj('tdindic_M4_'+n).style.borderColor='black white black white';
		ind_obj('tdindic_R_' +n).style.borderColor='black black black white';
		ind_cur_sel = n;
	}
	function ind_row_clk(n,indicador){
		ind_obj('tdindic_L_' +n).style.fontWeight=
		ind_obj('tdindic_M1_'+n).style.fontWeight=
		ind_obj('tdindic_M2_'+n).style.fontWeight=
		ind_obj('tdindic_M3_'+n).style.fontWeight=
		ind_obj('tdindic_M4_'+n).style.fontWeight=
		ind_obj('tdindic_R_' +n).style.fontWeight='bold';
		ind_obj('tdindic_L_' +n).style.backgroundColor=
		ind_obj('tdindic_M1_'+n).style.backgroundColor=
		ind_obj('tdindic_M2_'+n).style.backgroundColor=
		ind_obj('tdindic_M3_'+n).style.backgroundColor=
		ind_obj('tdindic_M4_'+n).style.backgroundColor=
		ind_obj('tdindic_R_' +n).style.backgroundColor=
		ind_obj('tdindic_L_' +n).style.borderColor=
		ind_obj('tdindic_M1_'+n).style.borderColor=
		ind_obj('tdindic_M2_'+n).style.borderColor=
		ind_obj('tdindic_M3_'+n).style.borderColor=
		ind_obj('tdindic_M4_'+n).style.borderColor=
		ind_obj('tdindic_R_' +n).style.borderColor='#e0e0e0';
		ind_row_out = ind_row_over = ind_row_clk = new Function();
		document.location.href = '/cfmx/home/menu/portlets/indicadores/detalle.cfm?indicador='+escape(indicador);
	}
//-->
</script>

<table width="<cfif isdefined("portlets.w_portlet")><cfoutput>#portlets.w_portlet-12#px</cfoutput>631px</cfif>" border="0" cellpadding="3" cellspacing="0">
  <tr>
    <td nowrap bgcolor="#CCCCCC">&nbsp;</td>
    <td align="right" nowrap bgcolor="#CCCCCC"><strong>
		<cfif ListValueCount( ValueList(mis_indicadores.filtro_tiempo), 0) Neq mis_indicadores.RecordCount>
		Periodo
		</cfif></strong></td>
    <td align="right" nowrap bgcolor="#CCCCCC"><strong>Valor Actual </strong></td>
    <td align="right" nowrap bgcolor="#CCCCCC"><strong>Anterior</strong></td>
    <td align="right" nowrap bgcolor="#CCCCCC"><strong>Dif.</strong></td>
    <td nowrap bgcolor="#CCCCCC">&nbsp;</td>
  </tr>
  <cfoutput query="mis_indicadores">

		<cfquery dbtype="query" name="nombre_periodo">
			select nombre from indicador_tiempos where codigo = #mis_indicadores.filtro_tiempo#
		</cfquery>
		<cfinvoke component="home.Componentes.IndicadorCalc" method="calcular_indicador" returnvariable="calculo"
			indicador="#mis_indicadores.indicador#"
			filtro_tiempo="#mis_indicadores.filtro_tiempo#"
			fecha="#fecha_indicadores#"/>

  <tr onMouseOver="ind_row_over(#CurrentRow#)" onMouseOut="ind_row_out(#CurrentRow#)" onClick="ind_row_clk(#CurrentRow#,'#JSStringFormat(Trim(indicador))#')">
    <td nowrap id="tdindic_L_#CurrentRow#" style="border:1px solid white;cursor:pointer ">#HTMLEditFormat(nombre_indicador)#</td>
    <td align="right" nowrap id="tdindic_M1_#CurrentRow#" style="border:1px solid white;cursor:pointer ">
			#nombre_periodo.nombre#&nbsp;
			<cfset title_act = "de #LSDateFormat(calculo.desde_act)# a #LSDateFormat(calculo.hasta_act)#. Valor: #NumberFormat(calculo.valor_actual  )#, Total: #NumberFormat(calculo.total_actual  )#, Cociente: #(calculo.actual)#">
			<cfset title_ant = "de #LSDateFormat(calculo.desde_ant)# a #LSDateFormat(calculo.hasta_ant)#. Valor: #NumberFormat(calculo.valor_anterior)#, Total: #NumberFormat(calculo.total_anterior)#, Cociente: #(calculo.anterior)#">
	</td>
    <td align="right" nowrap id="tdindic_M2_#CurrentRow#" style="border:1px solid white;cursor:pointer " title="#title_act#">#  HTMLEditFormat( calculo.fmt_actual    ) #</td>
    <td align="right" nowrap id="tdindic_M3_#CurrentRow#" style="border:1px solid white;cursor:pointer " title="#title_ant#">#  HTMLEditFormat( calculo.fmt_anterior  ) #</td>
    <td align="right" nowrap id="tdindic_M4_#CurrentRow#" style="border:1px solid white;cursor:pointer "># NumberFormat ( calculo.incremento,     '+0.0' ) # %</td>
    <td align="right" nowrap id="tdindic_R_#CurrentRow#"  style="border:1px solid white;cursor:pointer ">&nbsp;</td>
  </tr>
</cfoutput>

<cfoutput>
  <tr>
    <td colspan="6" align="right"><form action="/cfmx/home/menu/portlets/indicadores/personalizar.cfm" style="margin:0 "><input type="submit" value="#translate.Translate('personalizar','Personalizar')#..."></form></td>
  </tr>
</cfoutput>  
  </table>

<cfset indicadores_cfm_finish = GetTickCount()>
<!--
	Tiempo indicadores: <cfoutput># indicadores_cfm_finish - indicadores_cfm_start #</cfoutput> millis
-->
