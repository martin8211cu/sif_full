<cfset ComponenteAgenda = CreateObject("Component", "home.Componentes.Agenda")>
<cfset ComponenteHorario = CreateObject("component", "home.Componentes.Horario")>
<cfset CodigoAgenda = ComponenteAgenda.MiAgenda() >

<cfset Info = ComponenteAgenda.InfoAgenda(CodigoAgenda)>
<cfset Horario = ComponenteHorario.Parse(Info.horario_habil).getQuery()>
<cfset tipo_vista = 'R'>
<cfquery name="dataLV" dbtype="query" >
	select inicio, final
	from Horario
	where dia not in ('S','D')
	group by inicio,final
</cfquery>
<cfif dataLV.recordcount gt 1>
	<cfset tipo_vista = 'D'>
</cfif>

<cfif tipo_vista eq 'R'>
	<cfquery name="dataLVDias" dbtype="query" >
		select distinct dia
		from Horario
		where dia not in ('S','D')
	</cfquery>
	<cfif dataLVDias.recordcount neq 5>
		<cfset tipo_vista = 'D'>
	</cfif>
</cfif>

<cfquery name="dataS" dbtype="query" maxrows="1">
	select inicio, final
	from Horario
	where dia = 'S'
</cfquery>
<cfquery name="dataD" dbtype="query" maxrows="1">
	select inicio, final
	from Horario
	where dia = 'D'
</cfquery>

<div class="tituloListas" align="center">Modificar Horario de la Agenda</div>
	<cfoutput>
		<form name="form1" method="post" action="Horario-sql.cfm" onSubmit="return validar(this);" style="margin:0 ">
			<table border="0" cellspacing="2" cellpadding="0" align="center">
				<tr>
					<td width="40%">&nbsp;</td>
					<td width="1%" nowrap ><strong>Tiempo para cada cita:&nbsp;</strong></td>
					<td>
						<cfset miEscala = info.escala>
						<cfset escalas = '10,12,15,20,30,40,60,90,120'>
						<cfif ListFind(escalas,MiEscala) is 0><cfset escalas = ListAppend(escalas,miescala)></cfif>
						<select name="escala" id="escala">
							<cfloop from="1" to="#ListLen(escalas)#" index="i">
								<option value="#ListGetAt(escalas, i)#" <cfif Info.escala is ListGetAt(escalas, i)> selected </cfif> >#ListGetAt(escalas, i)# minutos</option>
							</cfloop>
						</select>
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="right" ><strong>Ver formato:&nbsp;</strong></td>
					<td>
						<select name="tipo" id="tipo" onChange="javascript:formato(this);">
							<option value="R" <cfif tipo_vista eq 'R'>selected</cfif> >Resumido</option>
							<option value="D" <cfif tipo_vista eq 'D'>selected</cfif>>Diario</option>
						</select>
					</td>
				</tr>

				<tr><td colspan="3"><hr size="1" color="##CCCCCC"></td></tr>

				<tr id="horario_resumido" <cfif tipo_vista eq 'R'>style="display:;"<cfelse>style="display:none;"</cfif> >
					<td colspan="3" align="center">
						<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
							<tr>
								<td>&nbsp;</td>
								<td align="right" ><strong>Horario Lunes-Viernes:&nbsp;</strong></td>
								<td>
									<input class="flat" name="iniLV" id="iniLV" onFocus="this.select()" type="text" value="<cfif dataLV.recordCount gt 0><cfif len(trim(dataLV.inicio)) eq 3 >0#Mid(dataLV.inicio,1,1)#:#Mid(dataLV.inicio,2,2)#<cfelse>#Mid(dataLV.inicio,1,2)#:#Mid(dataLV.inicio,3,2)#</cfif></cfif>" onKeyUp="validHour(this)" onBlur="validHour(this)" size="8">
									<input name="finLV" id="finLV" onFocus="this.select()" type="text" value="<cfif dataLV.recordCount gt 0><cfif len(trim(dataLV.final)) eq 3 >0#Mid(dataLV.final,1,1)#:#Mid(dataLV.final,2,2)#<cfelse>#Mid(dataLV.final,1,2)#:#Mid(dataLV.final,3,2)#</cfif></cfif>" onKeyUp="validHour(this)" onBlur="validHour(this)" size="8">
								</td>
							</tr>
				
							<tr>
								<td>&nbsp;</td>
								<td align="right" ><strong>Horario S&aacute;bado:&nbsp;</strong></td>
								<td>
									<input class="flat" name="iniS" id="iniS" onFocus="this.select()" type="text" value="<cfif dataS.recordCount gt 0><cfif len(trim(dataS.inicio)) eq 3 >0#Mid(dataS.inicio,1,1)#:#Mid(dataS.inicio,2,2)#<cfelse>#Mid(dataS.inicio,1,2)#:#Mid(dataS.inicio,3,2)#</cfif></cfif>" onKeyUp="validHour(this)" onBlur="validHour(this)" size="8">
									<input name="finS" id="finS" onFocus="this.select()" type="text" value="<cfif dataS.recordCount gt 0><cfif len(trim(dataS.final)) eq 3 >0#Mid(dataS.final,1,1)#:#Mid(dataS.final,2,2)#<cfelse>#Mid(dataS.final,1,2)#:#Mid(dataS.final,3,2)#</cfif></cfif>" onKeyUp="validHour(this)" onBlur="validHour(this)" size="8">
								</td>
							</tr>
				
							<tr>
								<td>&nbsp;</td>
								<td align="right" ><strong>Horario Domingo:&nbsp;</strong></td>
								<td>
									<input class="flat" name="iniD" id="iniD" onFocus="this.select()" type="text" value="<cfif dataD.recordCount gt 0><cfif len(trim(dataD.inicio)) eq 3 >0#Mid(dataD.inicio,1,1)#:#Mid(dataD.inicio,2,2)#<cfelse>#Mid(dataD.inicio,1,2)#:#Mid(dataD.inicio,3,2)#</cfif></cfif>" onKeyUp="validHour(this)" onBlur="validHour(this)" size="8">
									<input name="finD" id="finD" onFocus="this.select()" type="text" value="<cfif dataD.recordCount gt 0><cfif len(trim(dataD.final)) eq 3 >0#Mid(dataD.final,1,1)#:#Mid(dataD.final,2,2)#<cfelse>#Mid(dataD.final,1,2)#:#Mid(dataD.final,3,2)#</cfif></cfif>" onKeyUp="validHour(this)" onBlur="validHour(this)" size="8">
								</td>
							</tr>
						</table>
					</td>
				</tr>
	
				<tr id="horario_diario" <cfif tipo_vista eq 'D'>style="display:;"<cfelse>style="display:none;"</cfif> >
					<td colspan="3" align="center">
						<table border="0" width="20%" cellspacing="2" cellpadding="0">
							<tr>
								<td><strong>D&iacute;a</strong></td>
								<td><strong>Desde</strong></td>
								<td><strong>Hasta</strong></td>
							</tr>
							
							<cfloop query="Horario">
								<tr>
									<td>
										<select name="sem#CurrentRow#" onChange="semClick (form, #CurrentRow#, this)">
											<option value="">- ninguno -</option>
											<option value="1" <cfif Horario.Dia is 'D'>selected</cfif>>Domingo</option>
											<option value="2" <cfif Horario.Dia is 'L'>selected</cfif>>Lunes</option>
											<option value="3" <cfif Horario.Dia is 'K'>selected</cfif>>Martes</option>
											<option value="4" <cfif Horario.Dia is 'M'>selected</cfif>>Mi&eacute;rcoles</option>
											<option value="5" <cfif Horario.Dia is 'J'>selected</cfif>>Jueves</option>
											<option value="6" <cfif Horario.Dia is 'V'>selected</cfif>>Viernes</option>
											<option value="7" <cfif Horario.Dia is 'S'>selected</cfif>>S&aacute;bado</option>
										</select>
									</td>
									<td><input class="flat" name="ini#CurrentRow#" id="ini#CurrentRow#" onFocus="this.select()" type="text" value="<cfif len(trim(horario.inicio))><cfif len(trim(horario.inicio)) eq 3>0#Mid(Horario.inicio, 1,1)#:#Mid(Horario.inicio, 2,2)#<cfelse>#Mid(Horario.inicio, 1,2)#:#Mid(Horario.inicio, 3,2)#</cfif></cfif>" onKeyUp="validHour(this)" onBlur="validHour(this)" size="8"></td>
									<td><input name="fin#CurrentRow#" id="fin#CurrentRow#" onFocus="this.select()" type="text" value="<cfif len(trim(horario.final))><cfif len(trim(horario.final)) eq 3>0#Mid(Horario.final, 1,1)#:#Mid(Horario.final, 2,2)#<cfelse>#Mid(Horario.final, 1,2)#:#Mid(Horario.final, 3,2)#</cfif></cfif>" onKeyUp="validHour(this)" onBlur="validHour(this)" size="8"></td>
								</tr>
							</cfloop>
							
							<cfloop from="#Horario.RecordCount+1#" to="#Horario.RecordCount+3#" index="CurrentRow">
								<tr>
									<td>
										<select name="sem#CurrentRow#" onChange="semClick (form, #CurrentRow#, this)">
											<option value="" selected>- ninguno -</option>
											<option value="1">Domingo</option>
											<option value="2">Lunes</option>
											<option value="3">Martes</option>
											<option value="4">Mi&eacute;rcoles</option>
											<option value="5">Jueves</option>
											<option value="6">Viernes</option>
											<option value="7">S&aacute;bado</option>
										</select>
									</td>
									<td><input name="ini#CurrentRow#" id="ini#CurrentRow#" disabled onFocus="this.select()" type="text" value="" onKeyUp="validHour(this)" onBlur="validHour(this)" size="8"></td>
									<td><input name="fin#CurrentRow#" id="fin#CurrentRow#" disabled onFocus="this.select()" type="text" value="" onKeyUp="validHour(this)" onBlur="validHour(this)" size="8"></td>
								</tr>
							</cfloop>
						</table>
					</td>
				</tr>
				<tr><td colspan="3" align="center"><input type="submit" name="Guardar" value="Guardar" ></td></tr>
			</table>
		</form>
	</cfoutput>

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

	if( f.tipo.value == 'D' ){
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
	}
	else{
		if ( document.form1.iniLV.value != '' && document.form1.finLV.value != ''){
			if ( document.form1.iniLV.value != '' ){
				if (!validHour(document.form1.iniLV)) {
					alert("Hora de inicio de Lunes a Viernes inválida");
					document.form1.iniLV.focus();
					return false;
				}
			}
			if ( document.form1.finLV.value != '' ){
				if (!validHour(document.form1.finLV)) {
					alert("Hora de final de Lunes a Viernes inválida");
					document.form1.finLV.focus();
					return false;
				}
			}
			numhoras++;
		}	
	
		if ( document.form1.iniS.value != '' && document.form1.finS.value != ''){
			if ( document.form1.iniS.value != '' ){
				if (!validHour(document.form1.iniS)) {
					alert("Hora de inicio de Sábado inválida");
					document.form1.iniS.focus();
					return false;
				}
			}
			if ( document.form1.finS.value != '' ){
				if (!validHour(document.form1.finS)) {
					alert("Hora de final de Sábado inválida");
					document.form1.finS.focus();
					return false;
				}
			}
			numhoras++;
		}
	
		if ( document.form1.iniD.value != '' && document.form1.finD.value != ''){
			if ( document.form1.iniD.value != '' ){
				if (!validHour(document.form1.iniD)) {
					alert("Hora de inicio de Domingo inválida");
					document.form1.iniD.focus();
					return false;
				}
			}
			if ( document.form1.finD.value != '' ){
				if (!validHour(document.form1.finD)) {
					alert("Hora de final de Domingo inválida");
					document.form1.finD.focus();
					return false;
				}
			}
			numhoras++;
		}
	}			

	if (numhoras == 0) {
		alert("Debe especificar un horario");
		if( document.form1.tipo.value == 'D' ){
			f.sem1.focus();
		}	
		return false;
	}
	return true;
}

function formato(obj){
	if ( obj.value == 'R' ){
		document.getElementById("horario_resumido").style.display='';
		document.getElementById("horario_diario").style.display='none';
	}
	else{
		document.getElementById("horario_resumido").style.display='none';
		document.getElementById("horario_diario").style.display='';
	}
}

//--></script>