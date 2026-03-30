
<cfinvoke component="rh.Componentes.AgendaMedica" method="AgendaMedica" returnvariable="CodigoAgendaMedica">
	<cfinvokeargument name="create" value="yes">
</cfinvoke>
<cfset ComponenteAgenda = CreateObject("Component", "home.Componentes.Agenda")>
<cfset ComponenteHorario = CreateObject("component", "home.Componentes.Horario")>

<cfset Info = ComponenteAgenda.InfoAgenda(url.ag)>
<cfset Horario = ComponenteHorario.Parse(Info.horario_habil).getQuery()>

<cf_template>
<cf_templatearea name="body">

<cf_web_portlet_start titulo="Agenda M&eacute;dica - Opciones">
<cfinclude template="/home/menu/pNavegacion.cfm">
<div class="tituloListas">Opciones de la agenda</div>
<form name="form1" method="post" action="Horario-sql.cfm" onSubmit="return validar(this);" style="margin:0 ">
	<input type="hidden"  value="<cfoutput>#url.ag#</cfoutput>" name="agenda" >
  <table  border="0" cellspacing="2" cellpadding="0">
    <tr>
      <td>&nbsp;</td>
      <td colspan="2" class="tituloListas"><em>Tiempo para cada cita </em></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td colspan="2">
	  <cfset miEscala = info.escala>
	  <cfset escalas = '10,12,15,20,30,40,60,90,120'>
	  <cfif ListFind(escalas,MiEscala) is 0><cfset escalas = ListAppend(escalas,miescala)></cfif>
	  <select name="escala" id="escala">
	  <cfloop from="1" to="#ListLen(escalas)#" index="i">
	  	<cfoutput>
        <option value="#ListGetAt(escalas, i)#" <cfif Info.escala is ListGetAt(escalas, i)> selected </cfif> >#ListGetAt(escalas, i)# minutos</option></cfoutput>
	  </cfloop>
      </select></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td colspan="2" class="tituloListas"><em>Horario de atenci&oacute;n</em></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td colspan="2"><table  border="0" cellspacing="2" cellpadding="0">
          <tr>
            <td>Dia</td>
            <td>Desde</td>
            <td>Hasta</td>
          </tr>
		  <cfoutput query="Horario">
		  <tr>
            <td><select name="sem#CurrentRow#" onChange="semClick (form, #CurrentRow#, this)">
				<option value="">- ninguno -</option>
              <option value="1" <cfif Horario.Dia is 'D'>selected</cfif>>Domingo</option>
              <option value="2" <cfif Horario.Dia is 'L'>selected</cfif>>Lunes</option>
              <option value="3" <cfif Horario.Dia is 'K'>selected</cfif>>Martes</option>
              <option value="4" <cfif Horario.Dia is 'M'>selected</cfif>>Mi&eacute;rcoles</option>
              <option value="5" <cfif Horario.Dia is 'J'>selected</cfif>>Jueves</option>
              <option value="6" <cfif Horario.Dia is 'V'>selected</cfif>>Viernes</option>
              <option value="7" <cfif Horario.Dia is 'S'>selected</cfif>>S&aacute;bado</option>
            </select></td>
            <td><input class="flat" name="ini#CurrentRow#" id="ini#CurrentRow#" onFocus="this.select()" type="text" value="#Mid(Horario.inicio,1,2)#:#Mid(Horario.inicio,3,2)#" onKeyUp="validHour(this)" onBlur="validHour(this)" size="8"></td>
            <td><input name="fin#CurrentRow#" id="fin#CurrentRow#" onFocus="this.select()" type="text" value="#Mid(Horario.final, 1,2)#:#Mid(Horario.final, 3,2)#" onKeyUp="validHour(this)" onBlur="validHour(this)" size="8"></td>
          </tr></cfoutput><cfloop from="#Horario.RecordCount+1#" to="#Horario.RecordCount+3#" index="CurrentRow"><cfoutput>
		  <tr>
            <td><select name="sem#CurrentRow#" onChange="semClick (form, #CurrentRow#, this)">
				<option value="" selected>- ninguno -</option>
              <option value="1">Domingo</option>
              <option value="2">Lunes</option>
              <option value="3">Martes</option>
              <option value="4">Mi&eacute;rcoles</option>
              <option value="5">Jueves</option>
              <option value="6">Viernes</option>
              <option value="7">S&aacute;bado</option>
            </select></td>
            <td><input name="ini#CurrentRow#" id="ini#CurrentRow#" disabled onFocus="this.select()" type="text" value="" onKeyUp="validHour(this)" onBlur="validHour(this)" size="8"></td>
            <td><input name="fin#CurrentRow#" id="fin#CurrentRow#" disabled onFocus="this.select()" type="text" value="" onKeyUp="validHour(this)" onBlur="validHour(this)" size="8"></td>
            </tr></cfoutput></cfloop>
        </table></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>
	  <cf_boton texto="&nbsp;&nbsp;&lt;&lt;&nbsp;Regresar&nbsp;&nbsp;" index="1" 
					estilo="2" funcion="location.href='Consultorio.cfm';">
	  
      <td> <cf_boton texto="&nbsp;&nbsp;Guardar&nbsp;&nbsp;" index="2" 
					estilo="2" funcion="form1.submit();"> </td>
    </tr>
  </table>
</form>

<script type="text/javascript">
<!--

function validHour(ctl){
	var sp = ctl.value.split(":");
	if (sp.length != 2) {
		if (ctl.value.length == 4) {
			sp = new Array(ctl.value.substring(0,2),ctl.value.substring(2,4));
		} else {
			ctl.style.color = 'red';
			return false;
		}
	}
	var hr = parseInt(sp[0], 10),
		mi = parseInt(sp[1], 10);
	if ( isNaN(hr) || hr < 0 || hr > 23 ) {
		ctl.style.color = 'red';
		return false;
	}
	if ( isNaN(mi) || mi < 0 || mi > 59 ) {
		ctl.style.color = 'red';
		return false;
	}
	if (hr < 10) hr = '0' + hr;
	if (mi < 10) mi = '0' + mi;
	var newvalue = '' + hr + ':' + mi;
	if (ctl.value != newvalue) {
		ctl.value = newvalue;
	}
	ctl.style.color = 'black';
	return true;
}

function semClick(f,i,sem){
	var ini = f['ini' + i];
	var fin = f['fin' + i];
	if (sem.value == '') {
		if (!ini.disabled) ini.disabled = true;
		if (!fin.disabled) fin.disabled = true;
	} else {
		if (ini.disabled) ini.disabled = false;
		if (fin.disabled) fin.disabled = false;
	}
}

function validar(f) {
	var numhoras = 0;
	for (var i=1;i<100;i++){
		var sem = f['sem' + i];
		if (!sem) break;
		var ini = f['ini' + i];
		var fin = f['fin' + i];
		if (sem.value != '' && ini.value != '' && fin.value != '') {
			if (!validHour(ini)) {
				alert("Hora de inicio inválida");
				ini.focus();
				return false;
			}
			if (!validHour(fin)) {
				alert("Hora de final inválida");
				fin.focus();
				return false;
			}
			numhoras++;
		} else if (sem.value != '' || ini.value != '' || fin.value != '') {
			sem.value = '';
			ini.value = '';
			fin.value = '';
		}
	}
	if (numhoras == 0) {
		alert("Debe especificar un horario");
		f.sem1.focus();
		return false;
	}
	return true;
}
//--></script>

<cf_web_portlet_end>

</cf_templatearea>
</cf_template>