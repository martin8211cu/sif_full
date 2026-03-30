<cfparam name="url.PRJid">
<cfparam name="url.PRJAid" default="">

<cfquery datasource="#session.dsn#" name="act">
	select
		a.PRJAid, a.PRJAcodigo, a.PRJAnivel, a.PRJAdescripcion, a.PRJAduracion,
		a.PRJAunidadTiempo, a.PRJAfechaInicio, a.PRJAfechaFinal, a.PRJAporcentajeAvance,
		a.PRJAcostoActual, a.PRJAidPadre, a.PRJAorden,
		(select count(1) from PRJActividadRecurso r
			where r.PRJAid = a.PRJAid) as cant_recursos, 
		(select count(1) from PRJActividad h
			where h.PRJAidPadre = a.PRJAid) as cant_hijos
	from PRJActividad a
	where a.PRJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PRJid#">
	group by a.PRJAid, a.PRJAcodigo, a.PRJAnivel, a.PRJAdescripcion, a.PRJAduracion,
		a.PRJAunidadTiempo, a.PRJAfechaInicio, a.PRJAfechaFinal, a.PRJAporcentajeAvance,
		a.PRJAcostoActual
	order by a.PRJApath
</cfquery>

<script type="text/javascript">
<!--
	window.drag_actividad = window.drag_linea = window.drag_codigo = null;
	window.drop_actividad = window.drop_linea = window.drop_codigo = null;
	function dragStart(actividad, codigo, linea){
		window.drag_actividad = actividad;
		window.drag_codigo = codigo;
		window.drag_linea = linea;
	}
	function dragEnter(td, actividad, codigo, linea){
		if (window.drag_actividad != actividad){
			td.style.borderBottom='solid 2px black';
			window.drop_actividad = actividad;
			window.drop_codigo = codigo;
			window.drop_linea = linea;
		}
	}
	function dragLeave(td){
		td.style.borderBottom='none 0px black';
	}
	function dragEnd(){
		if (window.drop_linea != null){
			if (confirm('Desea mover la actividad num ' + window.drag_codigo + ' después de la actividad ' + window.drop_codigo)) {
				<cfoutput>
				location.href='Actividades-mover.cfm?PRJid=#JSStringFormat(url.PRJid)#&from='+escape(window.drag_actividad)
					+'&to='+escape(window.drop_actividad);
				</cfoutput>
				window.status = 'moved';
			}
		}
	}
//-->
</script>

<table width="100%" cellpadding="1" cellspacing="0">
  <tr>
    <td class="tituloListas">&nbsp;</td>
    <td class="tituloListas">&nbsp;</td>
    <td class="tituloListas">&nbsp;</td>
    <td align="left" class="tituloListas" ondragenter="dragEnter(this, 0, '', 0)" ondragleave="dragLeave(this)" ><strong>Actividad</strong></td>
    <td align="right" class="tituloListas"><strong>Duraci&oacute;n</strong></td>
    <td align="center" class="tituloListas"><strong>Inicio</strong></td>
    <td align="center" class="tituloListas"><strong>Fin</strong></td>
    <td align="right" class="tituloListas"><strong>Avance</strong></td>
    <td align="right" class="tituloListas"><strong>Costo actual</strong></td>
    <td align="center" class="tituloListas"><strong>Recursos</strong></td>
    <td class="tituloListas">&nbsp;</td>
  </tr>
  <cfset previo = ''>
  <cfset last_PRJAidPadre = ''>
  <cfset last_PRJAorden   = ''>
  <cfoutput query="act">
  <cfset last_PRJAidPadre = act.PRJAidPadre>
  <cfset last_PRJAorden   = act.PRJAorden>
  <tr
  	onClick="location.href='Actividades.cfm?PRJid=#HTMLEditFormat(url.PRJid)#&amp;PRJAid=#HTMLEditFormat(act.PRJAid)#'" 
	<cfif act.PRJAid neq url.PRJAid>
		onMouseOver="this.style.backgroundColor = '##edffed';"
  		onMouseOut="this.style.backgroundColor = '';"
	</cfif>
		style="text-indent:0;cursor:pointer;<cfif act.PRJAid is url.PRJAid>background-color:##c0ffc0;</cfif>"
		class="<cfif act.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
      <td>
	  <cfif act.PRJAnivel>
	  <a href="Actividades-indent.cfm?PRJid=#HTMLEditFormat(url.PRJid)#&amp;PRJAid=#HTMLEditFormat(act.PRJAid)#&amp;i=-1"><img src="outdent.gif" width="10" height="11" border="0"></a>
	  <cfelse>
	  <img src="outdent_dis.gif" width="10" height="11" border="0">
	  </cfif>
	  
	  </td>
      <td><cfif Len(previo) and previo neq act.PRJAidPadre>
        <a href="Actividades-indent.cfm?PRJid=#HTMLEditFormat(url.PRJid)#&amp;PRJAid=#HTMLEditFormat(act.PRJAid)#&amp;i=1&amp;previo=#HTMLEditFormat(previo)#"><img src="indent.gif" width="10" height="11" border="0"></a>
	  <cfelse>
	  <img src="indent_dis.gif" width="10" height="11" border="0">
      </cfif></td><cfset previo = act.PRJAid>
      <td align="center">
	  </td>
      <td align="left" nowrap ondragenter="dragEnter(this,#act.PRJAid#,'#JSStringFormat(Trim(act.PRJAcodigo))#',#act.CurrentRow#)" ondragleave="dragLeave(this)" >
	  #RepeatString('&nbsp;',act.PRJAnivel*2+1)# <img src="file.png" width="16" height="16" border="0" onDragStart="dragStart(#act.PRJAid#,'#JSStringFormat(Trim(act.PRJAcodigo))#',#act.CurrentRow#)" onDragEnd='dragEnd()' >  #act.PRJAcodigo# - #act.PRJAdescripcion#</td>
      <td align="right">#act.PRJAduracion# #act.PRJAunidadTiempo#</td>
      <td align="center">#DateFormat(act.PRJAfechaInicio,'dd/mm/yy')#</td>
      <td align="center">#DateFormat(act.PRJAfechaFinal,'dd/mm/yy')#</td>
      <td align="right" nowrap>#NumberFormat(act.PRJAporcentajeAvance,',0.00')#&nbsp;% </td>
      <td align="right">#NumberFormat(act.PRJAcostoActual,',0.00')#</td>
      <td align="center">#NumberFormat(act.cant_recursos,',0')#</td>
      <td>&nbsp;</td>
    </tr>
  </cfoutput>
</table>
