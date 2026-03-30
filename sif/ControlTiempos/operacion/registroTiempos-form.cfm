<cfif isdefined("url.fecha") and not isdefined("form.fecha")>
	<cfset form.fecha = url.fecha >
</cfif>

<cfif isdefined("form.fecha") and len(trim(form.fecha))>
	<cfset fecha = LSParseDateTime(form.fecha) >
<cfelse>
	<cfset fecha = LSParseDateTime(LSdateformat(now(),'dd/mm/yyyy')) >
	<cfset form.fecha = LSdateFormat(fecha,'dd/mm/yyyy') >
</cfif>

<!---<cfset fecha = LSParseDateTime('03/02/2005') >--->
<cfset fecha_inicio = dateadd('d', 1-DayOfWeek(fecha),fecha) >
<cfset fecha_final  = dateadd('d',7-DayOfWeek(fecha),fecha) >

<cffunction name="pintarcombo" returntype="string">
	<cfargument name="rs" required="yes" >
	<cfargument name="index" required="yes" >
	<cfargument name="seleccion" required="yes" >

	<cfsavecontent variable="combo">
		<select name="<cfoutput>proyecto_#index#</cfoutput>" id="<cfoutput>proyecto_#index#</cfoutput>" tabindex="<cfoutput>#index#</cfoutput>" >
			<option value="" >- seleccione proyecto -</option>
			<cfoutput  query="rs" group="SNcodigo">
				<optgroup label="#rs.SNnombre#">
				<cfoutput>
						<option value="#HTMLEditFormat(rs.SNcodigo)#/#HTMLEditFormat(rs.CTPcodigo)#" <cfif seleccion eq rs.grupo>selected</cfif> >#HTMLEditFormat(rs.CTPdescripcion)#</option>
				</cfoutput>
				</optgroup>
			</cfoutput>
		</select>
	</cfsavecontent>
	<cfreturn #combo# >
</cffunction>

<cfquery name="proyectos" datasource="#session.DSN#">
	select b.SNcodigo, a.SNnumero, a.SNnombre, b.CTPcodigo, b.CTPdescripcion, convert(varchar,b.SNcodigo)||'/'||convert(varchar,CTPcodigo) as grupo
	from SNegocios a
	
	inner join CTProyectos b
	on a.SNcodigo=b.SNcodigo
	and a.Ecodigo=b.Ecodigo
	
	where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by grupo
</cfquery>

<cfquery name="actividad" datasource="#session.DSN#">
	select CTAcodigo, CTAdescripcion
	from CTActividades
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by CTAdescripcion
</cfquery>

<cfquery name="data" datasource="#session.DSN#">
	select CTTcodigo, CTAcodigo, CTPcodigo, CTThorasR, Ecodigo, SNcodigo, CTTobservacion, CTTfacturable, CTTfecha, convert(varchar,SNcodigo)||'/'||convert(varchar,CTPcodigo) as grupo
	from CTTiempos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and CTTfecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha_inicio#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha_final#">
	order by SNcodigo, CTPcodigo, CTAcodigo, CTTfecha
</cfquery>

<script language="javascript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script>

<style type="text/css">
.flat, .flattd input {
	border:1px solid gray;
	height:19px;
}
.checkBox1 {height:auto; line-height:normal;}
</style>

<cfoutput>
<table width="99%" cellpadding="0" cellspacing="0" align="center">
	<tr><td>&nbsp;</td></tr>
	<tr><td align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">Registro de Tiempos</strong></td></tr>
	<tr><td align="center"><strong><font size="2">Semana del #LSDateFormat(fecha_inicio,'dd/mm/yyyy')# al #LSDateFormat(fecha_final,'dd/mm/yyyy')#</font></strong></td></tr>

	<cfset queryfecha = QueryNew('fecha') >
	<cfif isdefined('form.fecha') and len(trim(form.fecha))>
		<cfset QueryAddRow(queryfecha, 1)>
		<cfset QuerySetCell(queryfecha, "fecha", form.fecha )>
	</cfif>
	<form name="calendario" style="margin:0;" method="post">
		<tr><td align="center">
			<table width="20%" align="center">
				<tr>
					<td nowrap align="right"><strong><font size="2">Fecha:</font></strong>&nbsp;</td>
					<td><cf_sifcalendario form="calendario" value="#form.fecha#" ></td>
					<td><input type="submit" name="Filtrar" value="Ver Datos" style="width:75px; "></td>
				</tr>
			</table>
		</td></tr>
	</form>
	<tr><td>&nbsp;</td></tr>
</table>
</cfoutput>

<form name="form1" action="registroTiempos-sql.cfm" method="post" style="margin:0; ">
	<cfoutput>
	<input type="hidden" name="fecha" value="#form.fecha#">
	<input type="hidden" name="fecha_inicio" value="#LSDateFormat(fecha_inicio,'dd/mm/yyyy')#">
	<input type="hidden" name="fecha_final"  value="#LSDateFormat(fecha_final,'dd/mm/yyyy')#">
	</cfoutput>

	<table width="99%" align="center" cellpadding="2" cellspacing="0">
		<tr>
			<td class="tituloListas"><strong>Cliente</strong></td>
			<td class="tituloListas"><strong>Actividad</strong></td>
			<td class="tituloListas" colspan="3"><strong>Domingo</strong></td>
			<td class="tituloListas" colspan="3"><strong>Lunes</strong></td>
			<td class="tituloListas" colspan="3"><strong>Martes</strong></td>
			<td class="tituloListas" colspan="3"><strong>Mi&eacute;rcoles</strong></td>
			<td class="tituloListas" colspan="3"><strong>Jueves</strong></td>
			<td class="tituloListas" colspan="3"><strong>Viernes</strong></td>
			<td class="tituloListas" colspan="3"><strong>S&aacute;bado</strong></td>
		</tr>
		
			<cfset i = 0 >
			<cfoutput query="data" group="grupo">
				<cfoutput group="CTAcodigo">
					<cfset i = i + 1>
					<cfset act = data.CTAcodigo >
					<cfset cgrupo = data.grupo >
					<tr>
						<td>#pintarcombo(proyectos, i, cgrupo)#</td>
						<td>	
							<select name="CTAcodigo_#i#" id="CTAcodigo_#i#" tabindex="#i#"  >
								<option value="" >- seleccione actividad -</option>
								<cfloop  query="actividad">
									<option value="#HTMLEditFormat(actividad.CTAcodigo)#" <cfif actividad.CTAcodigo eq act >selected</cfif>  >#HTMLEditFormat(actividad.CTAdescripcion)#</option>
								</cfloop>
							</select>
						</td>
	
						<cfset fecha_iterar = fecha_inicio >
						<cfoutput>
							<cfloop condition=" fecha_iterar lt data.CTTfecha ">
								<td bgcolor="<cfif DayOfWeek(fecha_iterar) mod 2>E6E6E6</cfif>" ><input class="flat" type="text" name="CTThorasR_#DayOfWeek(fecha_iterar)#_#i#" size="5" maxlength="5" style="text-align:right;" value="" tabindex="#i#" onBlur="javascript:fm(this,2); limpiar(this);" onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" ></td>
								<td bgcolor="<cfif DayOfWeek(fecha_iterar) mod 2>E6E6E6</cfif>" width="1%"><input <cfif DayOfWeek(fecha_iterar) mod 2>style="background-color:E6E6E6;"</cfif> type="checkbox" class="checkBox1" name="CTTfacturable_#DayOfWeek(fecha_iterar)#_#i#"></td>
								<td bgcolor="<cfif DayOfWeek(fecha_iterar) mod 2>E6E6E6</cfif>" width='1%'><a href="javascript:observaciones('#DayOfWeek(fecha_iterar)#_#i#')"><img border="0" id="imagen_#DayOfWeek(fecha_iterar)#_#i#" src="noedit.gif"></a><input type="hidden" name="CTTobs_#DayOfWeek(fecha_iterar)#_#i#"></td>
								<cfset fecha_iterar = dateadd('d',1,fecha_iterar) >
							</cfloop>
							<cfif datecompare(fecha_iterar, data.CTTfecha) eq 0 >
								<td bgcolor="<cfif DayOfWeek(fecha_iterar) mod 2>E6E6E6</cfif>"><input type="text" class="flat" name="CTThorasR_#DayOfWeek(fecha_iterar)#_#i#" size="5" maxlength="5" style="text-align:right;" value="#LSNumberFormat(data.CTThorasR,',9.00')#" tabindex="#i#" onBlur="javascript:fm(this,2);" onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" ></td>
								<td bgcolor="<cfif DayOfWeek(fecha_iterar) mod 2>E6E6E6</cfif>" width="1%"><input type="checkbox" <cfif DayOfWeek(fecha_iterar) mod 2>style="background-color:E6E6E6;"</cfif> class="checkBox1" <cfif data.CTTfacturable eq 1>checked</cfif> name="CTTfacturable_#DayOfWeek(fecha_iterar)#_#i#"></td>
								<td bgcolor="<cfif DayOfWeek(fecha_iterar) mod 2>E6E6E6</cfif>" width='1%'><a href="javascript:observaciones('#DayOfWeek(fecha_iterar)#_#i#')"><img border="0" id="imagen_#DayOfWeek(fecha_iterar)#_#i#" src="<cfif len(trim(data.CTTobservacion))>iedit.gif<cfelse>noedit.gif</cfif>"></a><input type="hidden" name="CTTobs_#DayOfWeek(fecha_iterar)#_#i#" value="#data.CTTobservacion#"></td>
								<input type="hidden" name="CTTcodigo_#DayOfWeek(fecha_iterar)#_#i#" value="#data.CTTcodigo#">
								<cfset fecha_iterar = dateadd('d',1,data.CTTfecha) >
							</cfif>
						</cfoutput>
					
						<cfloop condition=" fecha_iterar lte fecha_final">
							<td bgcolor="<cfif DayOfWeek(fecha_iterar) mod 2>E6E6E6</cfif>"><input type="text" class="flat" name="CTThorasR_#DayOfWeek(fecha_iterar)#_#i#" size="5" maxlength="5" style="text-align:right;" value="" tabindex="#i#" onBlur="javascript:fm(this,2);  limpiar(this);" onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" ></td>
							<td bgcolor="<cfif DayOfWeek(fecha_iterar) mod 2>E6E6E6</cfif>" width="1%"><input <cfif DayOfWeek(fecha_iterar) mod 2>style="background-color:E6E6E6;"</cfif> type="checkbox" class="checkBox1"  name="CTTfacturable_#DayOfWeek(fecha_iterar)#_#i#"></td>
							<td bgcolor="<cfif DayOfWeek(fecha_iterar) mod 2>E6E6E6</cfif>" width='1%'><a href="javascript:observaciones('#DayOfWeek(fecha_iterar)#_#i#')"><img border="0" id="imagen_#DayOfWeek(fecha_iterar)#_#i#" src="noedit.gif"></a><input type="hidden" name="CTTobs_#DayOfWeek(fecha_iterar)#_#i#"></td>
							<cfset fecha_iterar = dateadd('d',1,fecha_iterar) >
						</cfloop>
					</tr>
				</cfoutput>
			</cfoutput>
			
			<cfset desde=i+1 >
			<cfloop from="#desde#" to="10" index="j">
				<tr>
					<td>
						<cfoutput><select name="proyecto_#j#" id="proyecto_#j#" tabindex="#j#" ></cfoutput>
							<option value="" >- seleccione proyecto -</option>
							<cfoutput  query="proyectos" group="SNcodigo">
								<optgroup label="#proyectos.SNnombre#">
								<cfoutput>
										<option value="#HTMLEditFormat(proyectos.SNcodigo)#/#HTMLEditFormat(proyectos.CTPcodigo)#">#HTMLEditFormat(proyectos.CTPdescripcion)#</option>
								</cfoutput>
								</optgroup>
							</cfoutput>
						</select>
					</td>
					<cfoutput>
					<td>	
						<select name="CTAcodigo_#j#" id="CTAcodigo_#j#" tabindex="#j#"  >
							<option value="" >- seleccione actividad -</option>
							<cfloop  query="actividad">
								<option value="#HTMLEditFormat(actividad.CTAcodigo)#">#HTMLEditFormat(actividad.CTAdescripcion)#</option>
							</cfloop>
						</select>
					</td>

					<cfloop from="1" to="7" index="k">
						<td bgcolor="<cfif k mod 2>E6E6E6</cfif>"><input type="text" class="flat" name="CTThorasR_#k#_#j#" size="5" maxlength="5" style="text-align:right;" value="" tabindex="#j#" onBlur="javascript:fm(this,2);  limpiar(this);" onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" ></td>
						<td bgcolor="<cfif k mod 2>E6E6E6</cfif>" width="1%"><input <cfif k mod 2>style="background-color:E6E6E6;"</cfif> type="checkbox" class="checkBox1" name="CTTfacturable_#k#_#j#"></td>
						<td bgcolor="<cfif k mod 2>E6E6E6</cfif>" width='1%'><a href="javascript:observaciones('#k#_#j#')"><img id="imagen_#k#_#j#" border="0" src="noedit.gif"></a><input type="hidden" name="CTTobs_#k#_#j#"></td>
					</cfloop>
					</cfoutput>
				</tr>
			</cfloop>
	
		<tr><td>&nbsp;</td></tr>
		<tr><td align="center" colspan="23"><input type="submit" name="Guardar" value="Guardar"></td></tr>
		<tr><td>&nbsp;</td></tr>
	</table>
</form>

<script type="text/javascript" language="javascript1.2">
	document.calendario.fecha.className = 'flat';
	function limpiar(obj){
		var valor = parseFloat(obj.value);
		if (valor <= 0){
			obj.value = '';
		}
	}
	
	function observaciones(cual){
		//popUpWindow("Solicitudes-info.cfm" ,250,200,600,400);
		open('observaciones-info.cfm?cual='+cual, 'observaciones', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width=600,height=420,left=250, top=200,screenX=250,screenY=200');
	}
</script>