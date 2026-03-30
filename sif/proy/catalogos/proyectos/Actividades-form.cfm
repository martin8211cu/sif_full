<cfparam name="url.PRJid" default="">
<cfif len(url.PRJid) is 0><cflocation url="Proyectos.cfm"></cfif>
<cfparam name="url.PRJAid" default="">

<cfquery datasource="#session.dsn#" name="moneda">
	select m.Miso4217
	from Monedas m join PRJproyecto p
		on p.Mcodigo = m.Mcodigo
	where p.PRJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PRJid#" null="#Len(url.PRJid) is 0#">
</cfquery>


<cfquery datasource="#session.dsn#" name="q_proyecto">
	select
		c.PCElongitud, p.PCEcatidActividad, p.PRJcodigo, p.Cmayor
	from PRJproyecto p
		left join PCECatalogo c
			on c.PCEcatid = p.PCEcatidActividad
	where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and p.PRJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PRJid#">
</cfquery>
<cfif q_proyecto.PCElongitud EQ "">
	<cfset q_proyecto.PCElongitud = 10>
</cfif>
<cfquery datasource="#session.dsn#" name="data">
	select *, 
		(
			select sum(ar.PRJARcantidadModificada * coalesce (pr.PRJPRcostoUnitModificado, 0))
			  from PRJActividadRecurso ar
				left outer join PRJProyectoRecurso pr
				   on pr.PRJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PRJid#" null="#Len(url.PRJid) is 0#">
				  and pr.PRJRid = ar.PRJRid
			 where ar.PRJAid = PRJActividad.PRJAid
		) as PRJAcostoEstimado
	from PRJActividad 
	<cfif Len(url.PRJAid)>
	where PRJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PRJid#" null="#Len(url.PRJid) is 0#">
	  and PRJAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PRJAid#" null="#Len(url.PRJAid) is 0#">
	<cfelse>
	where 0=1
	</cfif>
</cfquery>
<cfquery datasource="#session.dsn#" name="socionegocio">
	select * from SNegocios
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#data.SNcodigo#" null="#Len(data.SNcodigo) is 0#">
</cfquery>
<cfquery datasource="#session.dsn#" name="recursos">
	select r.PRJtipoRecurso, r.PRJRid, r.PRJRcodigo, r.PRJRdescripcion,
		case when PRJtipoRecurso = '1' then '%' else u.Ucodigo end as Ucodigo,
		a.PRJRAid,
		a.PRJARcantidadModificada,
		a.PRJARcantidadReal, a.PRJARcostoReal,
		coalesce (Acosto, x.PRJPRcostoUnitModificado, 0) as costo_unit,
		upper(r.PRJRdescripcion) as MY_SORTORDER
	from PRJRecurso r
		left outer join Articulos ar
			on ar.Aid = r.Aid
		left outer join Unidades u
			on u.Ucodigo = r.Ucodigo
		   and u.Ecodigo = r.Ecodigo
		left outer join PRJProyectoRecurso x
		   on x.PRJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PRJid#" null="#Len(url.PRJid) is 0#">
		  and x.PRJRid = r.PRJRid
		left outer join PRJActividadRecurso a
		   on a.PRJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PRJid#" null="#Len(url.PRJid) is 0#">
		  and a.PRJAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PRJAid#" null="#Len(url.PRJAid) is 0#">
		  and a.PRJRid = r.PRJRid
	where r.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by r.PRJtipoRecurso desc, MY_SORTORDER
</cfquery>
<cfquery datasource="#session.dsn#" name="rsActRec">
	select count(1) as cantidad
	from PRJActividadRecurso
	where PRJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PRJid#" null="#Len(url.PRJid) is 0#">
	  and PRJAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.PRJAid#" null="#Len(url.PRJAid) is 0#">
</cfquery>
<cfquery datasource="#session.dsn#" name="rsOficinas">
	select * from Oficinas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif rsActRec.Cantidad GT 0>
	and Ocodigo = #data.Ocodigo#
	</cfif>
</cfquery>
<link rel="stylesheet" href="../../../css/sif.css">

<style type="text/css">
.numerico {
	text-align:right;
}
.numerico, .flat, .flattd input {
	border:1px solid navy;
	height:19px;
}
</style>

<script type="text/javascript" src="/cfmx/sif/js/utilesMonto.js">//</script>
<script type="text/javascript">
<!--
function updatesubt(n) {
	var cant = form1['cant_'+n]; var cost = form1['cost_'+n];
	formatCurrency(cant, 2 );
	formatCurrency(cost, 2 );
	cant = parseFloat(qf(cant.value));
	cost = parseFloat(qf(cost.value));
	var subt = form1['subt_'+n];
	subt.value = (isNaN(cant) || isNaN(cost)) ? '0.00' : (cant * cost);
	formatCurrency(subt, 2 );
}
function ajustar_largo(tx,longitud){
	window.status='longitud:'+longitud;
	if (tx.value.length > longitud) {
		tx.value = tx.value.substring(0,longitud);
	} else if (tx.value.length != longitud) {
		tx.value = '000000000000000000000'.substring(0,longitud-tx.value.length) + tx.value;
	}
}
function validar(f){
	if (f.PRJAcodigo.value.match(/^\s*$/)){
		alert("Digite el codigo de la actividad");
		f.PRJAcodigo.focus();
		return false;
	}
	if (f.PRJAdescripcion.value.match(/^\s*$/)){
		alert("Digite la descripción de la actividad");
		f.PRJAdescripcion.focus();
		return false;
	}
	if (f.PRJAduracion.value.match(/^\s*$/) || isNaN(parseFloat(f.PRJAduracion.value))){
		alert("Digite la duración de la actividad, es requerida, aunque puede ser cero.");
		f.PRJAduracion.focus();
		return false;
	}
	if (f.PRJAporcentajeAvance.value.match(/^\s*$/) || isNaN(parseFloat(f.PRJAporcentajeAvance.value)) || parseFloat(f.PRJAporcentajeAvance.value) == 0){
		f.PRJAporcentajeAvance.value = '0';
	}
}
//-->
</script>

<form action="Actividades-sql.cfm" method="post" enctype="application/x-www-form-urlencoded" name="form1" id="form1" onSubmit="return validar(this);">
<table cellpadding="2" cellspacing="0" width="100%">
    <tr>
      <td>&nbsp;</td>
      <td colspan="2" class="subTitulo">Detalle de actividad </td>
      <td class="subTitulo">Asignaci&oacute;n de recursos </td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td><cfoutput><input type="hidden" name="PRJAid" id="PRJAid" value="#HTMLEditFormat(data.PRJAid)#">
	  <input type="hidden" name="PRJid" id="PRJid" value="#HTMLEditFormat(url.PRJid)#">
	  <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" arTimeStamp="#data.ts_rversion#" returnvariable="ts">
	  </cfinvoke>
	  <input type="hidden" name="ts_rversion" id="ts_rversion" value="#ts#">
	  <input type="hidden" name="last_PRJAidPadre" id="last_PRJAidPadre" value="#HTMLEditFormat(last_PRJAidPadre)#">
	  <input type="hidden" name="last_PRJAorden" id="last_PRJAorden" value="#HTMLEditFormat(last_PRJAorden)#">
	  <input type="hidden" name="PRJAcodigo_ant" id="PRJAcodigo_ant" value="#HTMLEditFormat(data.PRJAcodigo)#">
</cfoutput>
	  </td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>C&oacute;digo</td>
      <td><cfoutput><input class="flat" tabindex="1" name="PRJAcodigo" type="text" id="PRJAcodigo" value="#HTMLEditFormat(Trim(data.PRJAcodigo))#" size="#q_proyecto.PCElongitud#" maxlength="#q_proyecto.PCElongitud#" onFocus="this.select()" onBlur="ajustar_largo(this,#q_proyecto.PCElongitud#)"></cfoutput></td>
      <td colspan="4" rowspan="8" valign="top"><table width="100%" border="0" cellpadding="3" cellspacing="1" bordercolor="#999999" bgcolor="#000000">
            <tr>
              <td rowspan="2" valign="bottom" bgcolor="#CCCCCC">Recurso</td>
              <td colspan="4" align="center" valign="bottom" bgcolor="#CCCCCC">Estimado</td>
              <td colspan="2" align="center" valign="bottom" bgcolor="#CCCCCC">Real</td>
              <td rowspan="2" align="center" valign="bottom" bgcolor="#CCCCCC">&nbsp;</td>
            </tr>
            <tr>
              <td align="center" valign="bottom" bgcolor="#CCCCCC">Costo unitario </td>
              <td colspan="2" align="center" valign="bottom" bgcolor="#CCCCCC">Cantidad</td>
              <td align="center" valign="bottom" bgcolor="#CCCCCC">Costo</td>
              <td align="center" valign="bottom" bgcolor="#CCCCCC">Cantidad</td>
              <td align="center" valign="bottom" bgcolor="#CCCCCC">Costo</td>
            </tr>
			<tr valign="bottom">
              <td align="left" valign="middle" bgcolor="#FFFFFF">
			  <select name="PRJRid" id="PRJRid" style="width:200px;" onChange="window.status=this.options[this.selectedIndex].text;form.cost_0.value=this.options[this.selectedIndex].costo_unit;document.getElementById('Ucodigo').innerHTML=this.options[this.selectedIndex].Ucodigo" onMouseOver="window.status=this.options[this.selectedIndex].text" onBlur="window.status=''" onMouseOut="window.status=''">
			  <option value="" costo_unit="0.00" Ucodigo="&nbsp;&nbsp;&nbsp;">- Haga clic para agregar recurso -</option>
			  <cfoutput  query="recursos" group="PRJtipoRecurso">
			  <optgroup label="#ListGetAt('Mano de Obra,Materiales,Servicios',PRJtipoRecurso)#">
			  <cfoutput>
			  <cfif Len(recursos.PRJRAid) is 0>
			  <option costo_unit="#HTMLEditFormat(NumberFormat(recursos.costo_unit,',0.00'))#"  Ucodigo="#HTMLEditFormat(recursos.Ucodigo)#" value="#HTMLEditFormat(recursos.PRJRid)#">#HTMLEditFormat(recursos.PRJRdescripcion)#</option>
			  </cfif>
			  </cfoutput></optgroup></cfoutput>
			  </select>
				</td>
              <td align="right" valign="middle" bgcolor="#FFFFFF"><input name="cost_0" type="text" id="cost_0" value="0.00" size="10" maxlength="11" onFocus="this.select()" class="numerico" onChange="updatesubt(0)"></td>
              <td align="right" valign="middle" bgcolor="#FFFFFF"><input name="cant_0" type="text" id="cant_0" value="0.00" size="6" maxlength="11" onFocus="this.select()" class="numerico" onChange="updatesubt(0)"></td>
              <td align="right" valign="middle" bgcolor="#FFFFFF"><span id="Ucodigo">&nbsp;&nbsp;&nbsp;</span></td>
              <td align="right" valign="middle" nowrap bgcolor="#FFFFFF"><cfoutput>#moneda.Miso4217# </cfoutput><input readonly="" tabindex="-1" name="subt_0" type="text" id="subt_0" value="0.00" size="10" maxlength="11" onFocus="this.select()" class="numerico"> </td>
              <td align="right" valign="middle" bgcolor="#FFFFFF">0.00</td>
              <td align="right" valign="middle" bgcolor="#FFFFFF" nowrap><cfoutput>#moneda.Miso4217# 0.00</cfoutput></td>
              <td align="right" valign="middle" bgcolor="#FFFFFF">&nbsp;</td>
            </tr>
			<cfset rownum = 0>
			<cfoutput query="recursos">
			  <cfif Len(recursos.PRJRAid) neq 0>
			  <cfset rownum = rownum+1>
			<cfif rownum mod 2 is 0>
			<cfset bgcolor='##edffed'>
			<cfelse>
			<cfset bgcolor='##c0edc0'>
			</cfif>
			
            <tr valign="bottom"  bgcolor="#bgcolor#">
              <td align="left" valign="middle"><input type="hidden" name="PRJRAid" value="#HTMLEditFormat(recursos.PRJRAid)#">
			  #HTMLEditFormat(recursos.PRJRcodigo)#<br>
				#HTMLEditFormat(recursos.PRJRdescripcion)#</td>
              <td align="right" valign="middle"><input name="cost_#recursos.PRJRAid#" type="text" id="cost_#recursos.PRJRAid#" value="#HTMLEditFormat(NumberFormat(recursos.costo_unit,',0.00'))#" size="10" maxlength="11" onFocus="this.select()" class="numerico" onChange="updatesubt(#recursos.PRJRAid#)"></td>
              <td align="right" valign="middle"><input name="cant_#recursos.PRJRAid#" type="text" id="cant_#recursos.PRJRAid#" value="#HTMLEditFormat(NumberFormat(recursos.PRJARcantidadModificada,',0.00'))#" size="6" maxlength="11" onFocus="this.select()" class="numerico" onChange="updatesubt(#recursos.PRJRAid#)"></td>
              <td align="right" valign="middle">#HTMLEditFormat(recursos.Ucodigo)#</td>
              <td align="right" valign="middle" nowrap>#moneda.Miso4217#           <input name="subt_#recursos.PRJRAid#" tabindex="-1" type="text" readonly="" id="subt_#recursos.PRJRAid#" value="#HTMLEditFormat(NumberFormat(recursos.PRJARcantidadModificada*recursos.costo_unit,',0.00'))#" size="10" maxlength="11" onFocus="this.select()" class="numerico"></td>
              <td align="right" valign="middle">#HTMLEditFormat(NumberFormat(recursos.PRJARcantidadReal,',0.00'))#</td>
              <td align="right" valign="middle" nowrap>#moneda.Miso4217# #HTMLEditFormat(NumberFormat(recursos.PRJARcostoReal,',0.00'))#</td>
              <td align="right" valign="middle"><a tabindex="-1" href="Actividades-quitar-recurso.cfm?PRJRAid=#recursos.PRJRAid#&amp;PRJAid=#url.PRJAid#&amp;PRJid=#url.PRJid#"><img alt="Quitar recurso" src="delete.small.gif" width="16" height="16" border="0"></a></td>
            </tr>
			  </cfif>
			  </cfoutput>
            
            <tr valign="bottom">
              <td colspan="4" align="left" valign="middle" bgcolor="#FFFFFF"><strong>Costo total de la actividad </strong></td>
              <td align="right" valign="middle" bgcolor="#FFFFFF" nowrap><cfoutput><strong>#moneda.Miso4217#  #HTMLEditFormat(NumberFormat(data.PRJAcostoEstimado,',0.00'))#</strong></cfoutput></td>
              <td align="right" valign="middle" bgcolor="#FFFFFF">&nbsp;</td>
              <td align="right" valign="middle" bgcolor="#FFFFFF" nowrap><cfoutput><strong>#moneda.Miso4217#  #HTMLEditFormat(NumberFormat(data.PRJAcostoActual,',0.00'))#</strong></cfoutput></td>
              <td align="right" valign="middle" bgcolor="#FFFFFF">&nbsp;</td>
            </tr>
        </table></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>Actividad</td>
      <td><cfoutput><input  class="flat" tabindex="2" name="PRJAdescripcion" type="text" id="PRJAdescripcion" value="#HTMLEditFormat(data.PRJAdescripcion)#" size="50" maxlength="80" onFocus="this.select()"> </cfoutput></td>
      </tr>
    <tr>
      <td>&nbsp;</td>
      <td>Duraci&oacute;n</td>
      <td> <cfoutput><input name="PRJAduracion" tabindex="3" type="text" class="numerico" id="PRJAduracion" onFocus="this.select()" value="#data.PRJAduracion#" size="10" maxlength="4" onBlur="formatCurrency(this,2)">
        <select name="PRJAunidadTiempo" tabindex="4" id="PRJAunidadTiempo">
          <option value="m" <cfif data.PRJAunidadTiempo is 'm'>selected</cfif>>meses</option>
          <option value="w" <cfif data.PRJAunidadTiempo is 'w'>selected</cfif>>semanas</option>
          <option value="d" <cfif data.PRJAunidadTiempo is 'd' or Len(data.PRJAunidadTiempo) is 0>selected</cfif>>d&iacute;as</option>
          <option value="h" <cfif data.PRJAunidadTiempo is 'h'>selected</cfif>>horas</option>
        </select></cfoutput></td>
      </tr>
    <tr>
      <td>&nbsp;</td>
      <td>Inicio</td>
      <td class="flattd"><cf_sifcalendario  tabindex="5" form="form1" name="PRJAfechaInicio" value="#LSDateFormat(data.PRJAfechaInicio,'DD/MM/YYYY')#">
	  </td>
      </tr>
    <tr>
      <td>&nbsp;</td>
      <td>Final</td>
      <td class="flattd"><cf_sifcalendario  tabindex="6" form="form1" name="PRJAfechaFinal" value="#LSDateFormat(data.PRJAfechaFinal,'DD/MM/YYYY')#"></td>
      </tr>
    <tr>
      <td>&nbsp;</td>
      <td>Avance</td>
      <td><cfoutput><input name="PRJAporcentajeAvance" tabindex="7"  type="text" class="numerico" id="PRJAporcentajeAvance" value="#HTMLEditFormat(data.PRJAporcentajeAvance)#" size="10" maxlength="6" onFocus="this.select()" onBlur="formatCurrency(this,2)">
        %</cfoutput></td>
      </tr>
    <tr>
      <td>&nbsp;</td>
      <td>Socio </td>
      <td class="flattd"><cf_sifsociosnegociosFA query="#socionegocio#"  tabindex="8" >
	  </td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>Oficina</td>
      <td class="flattd">
		<select name="Ocodigo">
			<cfoutput query="rsOficinas"> 
				<option value="#rsOficinas.Ocodigo#" <cfif rsOficinas.Ocodigo EQ data.Ocodigo>selected</cfif>>#rsOficinas.Odescripcion#</option>
			</cfoutput>
		</select>
      </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td colspan="2">
	  <cfoutput>
	  <cfif Len(data.PRJid) is 0>
	  <input name="alta" type="submit" id="alta" value="Agregar">
	  <cfelse>
        <input name="cambio" type="submit" id="cambio" value="Guardar">
        <input name="baja" type="submit" id="baja" value="Eliminar">
        <input name="nuevo" type="button" id="nuevo" value="Nuevo" onClick="location.href='Actividades.cfm?PRJid=#URLEncodedFormat(url.PRJid)#'">
	</cfif>
	</cfoutput>
	</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
</table>
</form>
  
  <script type="text/javascript" language="javascript1.2">
  	document.form1.PRJAcodigo.focus();
  </script>
