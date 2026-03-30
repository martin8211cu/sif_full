<cfset dayNames='D,L,M,M,J,V,S'>
<cfset instrucciones = 'Mientras mueve el puntero presione las teclas Ctrl o Shift para habilitar e inhabilitar un horario.'>

<cfparam name="data" type="struct"><!--- data = Políticas del portal  para la cuenta empresarial--->

<cfquery datasource="asp" name="AccesoRemotoList">
	select acceso, ARnombre
	from AccesoRemoto
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.progreso.CEcodigo#">
</cfquery>

<cfparam name="url.acceso" default="0">

<cfif (url.acceso is 0) And Len(AccesoRemotoList.acceso)>
	<!--- si el usuario no ha seleccionado un perfil de acceso, mostrar el primero --->
	<cfset url.acceso = AccesoRemotoList.acceso>
</cfif>

<cfif Len(url.acceso) And Not ListFind(ValueList(AccesoRemotoList.acceso), url.acceso)>
	<cfset url.acceso = ''>
</cfif>
<cfquery datasource="asp" name="AccesoRemoto">
	select ARnombre
	from AccesoRemoto
	where acceso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.acceso#" null="#Len(url.acceso) is 0#">
</cfquery>
<cfif data.auth.validar.horario is 1>
	<cfquery datasource="asp" name="AccesoHorario">
		select dia,desde,hasta
		from AccesoHorario
		where acceso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.acceso#" null="#Len(url.acceso) is 0#">
	</cfquery>
	
	<cfset coloresOn = '##0000cc,##0000dd,##000080'>
	<cfset coloresOff = '##cccccc,##dddddd,##808080'>
	
	<cffunction name="marca" output="false" returntype="numeric">
		<cfargument name="dy" type="numeric">
		<cfargument name="hr" type="numeric">
		<cfargument name="half" type="numeric">
		
		<cfset formateado = NumberFormat(hr,'00') & NumberFormat(half*30,'00')>
		
		<cfloop query="AccesoHorario">
			<cfif AccesoHorario.dia is dy And
				AccesoHorario.desde LE formateado And
				formateado LT AccesoHorario.hasta>
				<cfreturn 1>
			</cfif>
		</cfloop>
		<cfreturn 0>
	</cffunction>
	
	<cffunction name="cellcolor" output="false" returntype="string">
		<cfargument name="dy" type="numeric">
		<cfargument name="hr" type="numeric">
		<cfargument name="half" type="numeric">
		
		<cfset var colorIndex = 1>
		<!--- colorIndex: 1 = Habil, 2 = Fin semana, 3 = Noche --->
		
		<cfif ListFind('1,7', dy )>
			<cfset colorIndex = 2>
		<cfelseif ((hr GT 7) and (hr LT 17))>
			<cfset colorIndex = 3>
		</cfif>
		<cfif marca(dy,hr,half)>
			<cfreturn ListGetAt(coloresOn,colorIndex)>
		<cfelse>
			<cfreturn ListGetAt(coloresOff,colorIndex)>
		</cfif>
	</cffunction>
	<cfset cellwidth = 9>
	
</cfif>
<cfif data.auth.validar.ip is 1>
	<cfquery datasource="asp" name="AccesoIP">
		select ipdesde,iphasta
		from AccesoIP
		where acceso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.acceso#" null="#Len(url.acceso) is 0#">
	</cfquery>
	<!--- agrega tres líneas en blanco para que llenen --->
	<cfset QueryAddRow(AccesoIP,3)>
</cfif>
<cfquery datasource="asp" name="Roles">
	select distinct r.SScodigo, s.SSdescripcion, r.SRcodigo, r.SRdescripcion, ar.acceso as existe
	from ModulosCuentaE a
		join SRoles r
			on a.SScodigo = r.SScodigo
			and r.SRinterno = 0
		join SSistemas s
			on s.SScodigo = r.SScodigo
		left join AccesoRol ar
			on ar.SScodigo = r.SScodigo
			and ar.SRcodigo = r.SRcodigo
			and ar.acceso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.acceso#" null="#Len(url.acceso) is 0#">
	where a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.progreso.CEcodigo#">
	order by s.SSdescripcion, r.SRdescripcion
</cfquery>

<!--- Modulos por Cuenta Empresarial --->
<cfquery name="rsSistemas" datasource="asp">
	select distinct a.SScodigo, b.SSdescripcion
	from ModulosCuentaE a, SSistemas b
	where a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.progreso.CEcodigo#">
   	  and a.SScodigo=b.SScodigo
	  and exists (select 1 from SRoles c
		where c.SScodigo = b.SScodigo
		  and c.SRinterno = 0)
	order by SSdescripcion
</cfquery>

<input type="hidden" name="horario" value="">
<table width="500" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>Perfil de acceso </td>
    <td><select name="acceso" onchange="location.href=&quot;?tab=acceso&amp;acceso=&quot;+this.value;">
	<cfoutput query="AccesoRemotoList">
	<option value="#AccesoRemotoList.acceso#" <cfif AccesoRemotoList.acceso is url.acceso>selected</cfif>>#HTMLEditFormat(AccesoRemotoList.ARnombre)#</option>
	</cfoutput>
	<option value="">-Crear perfil nuevo-</option>
    </select>    </td>
    </tr>
  <tr>
    <td>Nombre del perfil </td>
    <td><cfoutput><input type="text" name="ARnombre" maxlength="30" size="40" value="#HTMLEditFormat( AccesoRemoto.ARnombre) #" onfocus="this.select()">    </cfoutput></td>
    </tr>
	<!--- Horarios --->
	<cfif data.auth.validar.horario is 1>
  <tr>
    <td colspan="2" class="subTitulo">Horario</td>
    </tr>
  <tr>
    <td colspan="2">
	<cfoutput><table width="#cellwidth*2*25+6#" border="0" cellspacing="0" cellpadding="0" onclick="alert(&quot;# JSStringFormat( instrucciones ) #&quot;)">
	<tr><td width="#cellwidth*2#">&nbsp;</td><cfloop from="0" to="23" index="hr">
		<cfif hr mod 4 is 0>
			<td width="1"><img src="blank.gif" width="1" height="1" border="0"></td>
		</cfif>
	<td style="width:#cellwidth*2#px;overflow:hidden;text-align:center" align="center" colspan="2" width="#cellwidth*2#">#hr#</td>
</cfloop></tr>
	<cfloop from="1" to="7" index="dy">
      <tr>
	  <td>#ListGetAt(dayNames, dy)#</td>
		<cfloop from="0" to="23" index="hr">
		<cfloop from="0" to="1" index="half">
		<cfif half is 0 and hr mod 4 is 0>
			<td width="1"><img src="blank.gif" width="1" height="1" border="0"></td>
		</cfif>
        <td onmousemove="omm(event,this,#dy#,#hr#,#half#)" style="background-color:#cellcolor(dy,hr,half)#;" title="#ListGetAt(dayNames, dy)# #NumberFormat(hr,'00')#:#NumberFormat(half*30,'00')#-#NumberFormat(hr+half,'00')#:#NumberFormat(30-half*30,'00')#">
		<img src="blank.gif" width="#cellwidth#" height="1" border="0"></td></cfloop></cfloop>
      </tr>
	  </cfloop>
    </table></cfoutput></td>
    </tr>
	<tr><td colspan="2">(*) <cfoutput> # HTMLEditFormat( instrucciones ) #</cfoutput></td>
	</tr>
    <tr>
      <td colspan="2">&nbsp;</td>
    </tr>
	</cfif>
	
	<!--- Direcciones IP --->
	<cfif data.auth.validar.ip is 1>
    <tr>
    <td colspan="2" class="subTitulo">Direcciones IP autorizadas </td>
    </tr>
  
  <tr>
    <td colspan="2"><table width="400" border="0" cellspacing="0" cellpadding="2">
	<cfoutput query="AccesoIP">
      <tr>
        <td>Desde</td>
        <td><input type="text" name="ipdesde#CurrentRow#" value="#HTMLEditFormat(ipdesde)#" onfocus="this.select()" onblur="blurip(this)"></td>
        <td>Hasta</td>
        <td><input type="text" name="iphasta#CurrentRow#" value="#HTMLEditFormat(iphasta)#" onfocus="this.select()" onblur="blurip(this)"></td>
      </tr></cfoutput>
    </table></td>
  </tr>
  <tr>
    <td colspan="2">&nbsp;</td>
  </tr></cfif>
  
  <tr>
    <td colspan="2">
        <input name="submit-acceso" type="submit" id="submit-acceso" value="Aplicar" class="btnGuardar" onclick="funcGuardar()" />
        <input type="reset" name="Reset" value="Cancelar" class="btnLimpiar" />
        <cfif Len(url.acceso)>
          <input name="eliminar-acceso" type="submit" id="eliminar-acceso" value="Eliminar" class="btnEliminar" onclick="funcEliminar()" />
        </cfif>    </td>
  </tr>
  
  <!--- Roles relacionados / autorizados --->
  <tr>
    <td colspan="2" class="subTitulo">Roles autorizados </td>
  </tr>
  <tr>
    <td colspan="2">
	<table border="0" cellpadding="0" cellspacing="0">
	<cfoutput query="Roles" group="SScodigo">
		<cfset all_checked = true>
		<cfoutput><cfif Not Len(existe)><cfset all_checked=false></cfif></cfoutput>
		<tr><td colspan="2">
		<input type="checkbox" id="sis#HTMLEditFormat(Trim(SScodigo))#" name="sis" 
			value="# HTMLEditFormat( Trim(SScodigo) )#" onchange="set_all(this)" <cfif all_checked>checked</cfif>>
		<label for="sis#HTMLEditFormat(Trim(SScodigo))#"><strong># HTMLEditFormat( Trim(SSdescripcion) )#</strong>		</label></td></tr>
		
		<cfoutput>
		<tr><td width="20">&nbsp;</td><td title="# HTMLEditFormat( Trim(SScodigo) )#.# HTMLEditFormat( Trim(SRcodigo)) #">
		<input type="checkbox" id="rol#CurrentRow#" name="rol" 
			value="# HTMLEditFormat( Trim(SScodigo) )#.# HTMLEditFormat( Trim(SRcodigo))#"
			onchange="chk_all(this)" <cfif Len(existe)>checked</cfif>>
		<label for="rol#CurrentRow#"># HTMLEditFormat( Trim(SRdescripcion) )#</label> </td></tr>
	  </cfoutput>	</cfoutput></table>	</td>
  </tr>
  <tr>
    <td colspan="2">
		<input name="submit-acceso" type="submit" id="submit-acceso" value="Aplicar" class="btnGuardar" onclick="funcGuardar()">
		<input type="reset" name="Reset" value="Cancelar" class="btnLimpiar">      
		<cfif Len(url.acceso)>
		<input name="eliminar-acceso" type="submit" id="eliminar-acceso" value="Eliminar" class="btnEliminar" onclick="funcEliminar()">
		</cfif>	</td>
  </tr>
</table>
<script type="text/javascript">
<cfif data.auth.validar.horario>
function omm(e,td,dy,hr,half){
	if (!e) e = window.event;
	if(e.ctrlKey) {
		marcas[dy-1][hr][half] = 1;
		td.style.backgroundColor=cellcolor(dy,hr,half);
	} else if (e.shiftKey) {
		marcas[dy-1][hr][half] = 0;
		td.style.backgroundColor=cellcolor(dy,hr,half);
	}
}
function cellcolor(dy,hr,half){
	var colorIndex = 1;
		
	if (dy==1 || dy==7){
		colorIndex = 2;
	} else if (hr > 7 && hr < 17) {
		colorIndex = 3;
	}
	return (marcas[dy-1][hr][half] ? coloresOn : coloresOff)[colorIndex-1];
}
</cfif>
<cfif data.auth.validar.ip>
function blurip(input){
	if (input.value.indexOf('.') != -1){
		var arr = input.value.split('.');
		if (arr.length != 4) {
			input.value = '';
		} else {
			for (i=0; i<4;i++)
				if (isNaN(arr[i]) || arr[i] < 0 || arr[i] > 255)
					arr[i] = 0;
			input.value = arr.join('.');
		}
	} else if (input.value.indexOf(':') != -1){
		var arr = input.value.split(':');
		if (arr.length != 8) {
			input.value = '';
		} else {
			for (i=0; i<8;i++)
				if (!arr[i].match(/^[0-9a-fA-F]{1,4}$/))
					arr[i] = 0;
			input.value = arr.join(':');
		}
	}
}
</cfif>
function set_all(sischk){
	var arr = sischk.form.elements;
	var prefix = sischk.value + '.';
	for(i=0; i < arr.length; i++){
		if ((arr[i].type == 'checkbox') &&
			(arr[i].value.indexOf(prefix) == 0) &&
			(arr[i].checked != sischk.checked)) {
			arr[i].checked = sischk.checked;
		}
	}
}
function chk_all(rolchk){
	var arr = rolchk.form.elements;
	var sis = rolchk.value.split('.')[0];
	var prefix = sis + '.';
	var all_true = true;
	for(i=0; i < arr.length; i++){
		if ((arr[i].type == 'checkbox') &&
			(arr[i].value.indexOf(prefix) == 0) &&
			(! arr[i].checked)) {
			all_true = false;
		}
	}
	arr['sis'+sis].checked = all_true;
}
function funcEliminar(){
	if(confirm('¿Desea eliminar este perfil de acceso?\nEsta operación es irreversible.')){
		document.estoy_borrando = true;
		return true;
	}
	return false;
}
function funcGuardar(){
	document.estoy_borrando = false;
	return true;
}
function funcvalidar(){
	if (document.estoy_borrando) return true;
	var f = document.form1;
	var error_input;
	var error_msg = '';
	if (f.ARnombre.value == '') {
		error_msg += "\n - Debe especificar el nombre del perfil.";
		error_input = f.ARnombre;
	}
<cfif data.auth.validar.horario>
	f.horario.value = calcularHorario();
	if (f.horario.value == '') {
		error_msg += "\n - Debe especificar el horario válido.";
	}
</cfif>
	// Validacion terminada
	if (error_msg.length != "") {
		alert("Por favor revise los siguiente datos:"+error_msg);
		if (error_input && error_input.focus) error_input.focus();
		return false;
	}
	return true;
}
<cfif data.auth.validar.horario>
function calcularHorario(){
	var horario = new Array();
	var encendido = 0;
	var inicio = '0000';
	var final = '2300';
	
	for (var dy = 1; dy <= 7; dy++) {
		encendido = false;
		inicio = null;
		for (var hr=0,half=0; hr <= 23; hr+=half, half = 1-half){
			if (!encendido && (marcas[dy-1][hr][half]==1)) {
				// encender
				inicio = (hr < 10 ? '0' : '') + hr + (half ? '30' : '00');
				encendido = true;
			} else if (encendido && (marcas[dy-1][hr][half]==0)) {
				// apagar
				final = (hr < 10 ? '0' : '') + hr + (half ? '30' : '00');
				horario.push(dy + ',' + inicio + ',' + final);
				inicio = null;
				encendido = false;
			}
		}
		if (inicio != null) {
			horario.push(dy + ',' + inicio + ',2400');
		}
	}
	
	return horario.join(';');
}
	<cfoutput>
	var coloresOn = '# JSStringFormat( coloresOn ) #'.split(',');
	var coloresOff = '# JSStringFormat( coloresOff ) #'.split(',');
	var marcas = Array(
	<cfloop from="1" to="7" index="dy">
	//#ListGetAt(dayNames, dy)#
		Array(#''
			#<cfloop from="0" to="23" index="hr">#''
			#Array(#''
				#<cfloop from="0" to="1" index="half">#''
					##marca(dy,hr,half)#<cfif half neq 1>,</cfif>#''
				#</cfloop>)<cfif hr neq 23>,</cfif>#''
			#</cfloop>)<cfif dy neq 7>,</cfif>
	</cfloop>)
	</cfoutput>
	</cfif>
document.form1.ARnombre.focus();
</script>