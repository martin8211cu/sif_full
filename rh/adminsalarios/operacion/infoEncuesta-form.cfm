<cfif isdefined('form.Eid') and len(trim(form.Eid))>
	<cfquery name="rsEmpresaE" datasource="sifpublica">
		select distinct e.EEid
		from Encuesta e
			inner join EncuestaSalarios es
				on es.EEid=e.EEid
					and es.Eid=e.Eid
		where e.Eid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Eid#">
	</cfquery>
	<cfif isdefined('rsEmpresaE') and rsEmpresaE.recordCount GT 0>
		<cfquery name="rsArea" datasource="sifpublica">
			select EAid, EAdescripcion 
			from EmpresaArea
			where EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpresaE.EEid#">
		</cfquery>
	</cfif>

	<cfif isdefined('form.Ver')>
		<cfquery name="rsFormES" datasource="sifpublica">
				select 	a.Eid,
						e.EAid,				
						a.ESid,
						a.EEid,
						a.ETid,
						a.EPid,			
						d.ETdescripcion, 
						e.EPcodigo, 
						e.EPdescripcion 
						,f.EAdescripcion
						,a.EScantobs
						,a.ESpromedio
						,a.ESp25
						,a.ESp50
						,a.ESp75
						,a.ESpromedioanterior
						,a.ESvariacion
		
				from EncuestaSalarios a 
			
					inner join 	EmpresaOrganizacion d
						on a.EEid = d.EEid 
						and a.ETid = d.ETid 
						
					left outer join EncuestaPuesto e
						on a.EEid = e.EEid and
						a.EPid =e.EPid 		
					 
					inner join EmpresaArea f
						on e.EEid = f.EEid and
						e.EAid =f.EAid 
		
				where a.Eid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Eid#">
					<cfif isdefined('form.Mcodigo_F') and form.Mcodigo_F NEQ '' and form.Mcodigo_F NEQ '-1'>
						and a.Moneda = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo_F#">				
					</cfif>
					<cfif isdefined('form.EAid_F') and form.EAid_F NEQ '' and form.EAid_F NEQ '-1'>
						and e.EAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EAid_F#">
					</cfif>
			order by Moneda, e.EAid, a.EPid
		</cfquery>
	</cfif>
</cfif>

<script language="JavaScript" src="/cfmx/rh/js/utilesMonto.js"></script>
<form style="margin:0; " name="form1" action="datosEncuestas-proceso.cfm"  method="post" onSubmit="javascript: return validaInfoEnc();">
	<cfoutput>
		<input type="hidden" name="Paso" value="2">
		<input type="hidden" name="Eid" value="#form.Eid#">	
		
		<table width="20%" align="center" class="areaFiltro">
			<tr>
				<td width="7%" align="left" nowrap><div align="right"><strong>&Aacute;rea:&nbsp;</strong></div></td>
				<td width="93%" nowrap>
					<select name="EAid_F" id="EAid_F"  style="width:150px; "> 
						<option value="-1">-- Todas --</option>
						<cfif isdefined('rsArea') and rsArea.recordCount GT 0>
							<cfloop query="rsArea">
								<option value="#rsArea.EAid#" <cfif isdefined("Form.EAid_F") and Form.EAid_F EQ rsArea.EAid>selected</cfif>>#rsArea.EAdescripcion#</option>
							</cfloop>
						</cfif>
					</select>
				</td>
			</tr>			
			<tr>
				<td width="7%" align="left" nowrap><div align="right"><strong>Moneda:&nbsp;</strong></div></td>
				<td width="93%" nowrap>
						<cfif isdefined('form.Mcodigo_F') and len(trim(form.Mcodigo_F))>
							<cfif form.Mcodigo_F NEQ '-1'>
								<cfquery name="rsMoneda" datasource="#session.DSN#">
									select Mcodigo, Mnombre
									from Monedas
									where Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo_F#">
									and Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								</cfquery>
								
								<cf_sifmonedas form="form1" Todas='S' Mcodigo="Mcodigo_F" query="#rsMoneda#" FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#"> 										
							<cfelse>
								<cf_sifmonedas form="form1" Todas='S' Mcodigo="Mcodigo_F" value="-1" FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#"> 																	
							</cfif>
							 
						 <cfelse>
							 <cf_sifmonedas form="form1" Todas='S' Mcodigo="Mcodigo_F" FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#">
					</cfif>		
				</td>
			</tr>
			<tr>
				<td  colspan="2" align="center" nowrap>
					<input type="submit" name="Ver" value="Ver Datos">
				</td>
			</tr>			
		</table>
		<br>		
		<cfif isdefined('rsFormES') and rsFormES.recordCount GT 0>	
			<table width="100%" align="center" border="0" style="border-collapse:collapse;" cellpadding="0" cellspacing="0">
				<tr>
					<td align="center" class="tituloListas" width="31%" title="Puesto por Área"><b>Puesto</b></td>
					<td align="center" class="tituloListas" width="10%" title="Cantidad de Observaciones"><b>Obs</b></td>
					<td align="center" class="tituloListas" width="9%"  title="Promedio periodo actual"><b>Promedio</b></td>
					<td align="center" class="tituloListas" width="9%"  title="Promedio periodo anterior" nowrap><b>Promedio Anterior</b></td>
					<td align="center" class="tituloListas" width="8%"  title="Percentil 25"><b>P25</b></td>
					<td align="center" class="tituloListas" width="8%"  title="Percentil 50"><b>P50</b></td>
					<td align="center" class="tituloListas" width="8%"  title="Percentil 75"><b>P75</b></td>
					<td align="center" class="tituloListas" width="9%"  title="Variación"><b>Variacion</b></td>
				</tr>
	
				<cfloop query="rsFormES">
					<tr class="<cfif rsFormES.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
						<td nowrap>&nbsp;&nbsp;#rsFormES.EPcodigo# - #rsFormES.EPdescripcion#</td>
						<td >
							<input align="center" name="Obs_#rsFormES.ESid#"  style="text-align:right;" onFocus="this.select();"
							value="<cfif rsFormES.EScantobs GT 0>#LSNumberFormat(rsFormES.EScantobs,',9')#<cfelse>#LSNumberFormat(0,',9')#</cfif>" 
								onkeyup="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" 
								onblur="javascript:fm(this,0);"
								size="13" maxlength="3">
						</td>
						<td >
							<input align="right" name="ESpromedio_#rsFormES.ESid#" style="text-align:right;" onFocus="this.select();"
							value="<cfif rsFormES.ESpromedio GT 0>#LSNumberFormat(rsFormES.ESpromedio,',9.00')#<cfelse>#LSNumberFormat(0,',9.00')#</cfif>" 
								  onChange="javascript:fm(this,2);" 
								  onkeyup="javascript: if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
								  onblur="javascript:fm(this,2);"
								  size="13" maxlength="15">
						</td>
						<td align="center" >
							<input align="right" name="ESpromedioanterior_#rsFormES.ESid#" style="text-align:right;" onFocus="this.select();" 
								 value="<cfif rsFormES.ESpromedioanterior GT 0>#LSNumberFormat(rsFormES.ESpromedioanterior,',9.00')#<cfelse>#LSNumberFormat(0,',9.00')#</cfif>" 							 
								 onChange="javascript:fm(this,2);" 
								 onkeyup="javascript: if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
								 onblur="javascript:fm(this,2);"
								 size="13" maxlength="15">
						</td>
						<td align="center" >
							<input align="right" name="ESp25_#rsFormES.ESid#"  style="text-align:right;" onFocus="this.select();"
								value="<cfif rsFormES.ESp25 GT 0>#LSNumberFormat(rsFormES.ESp25,',9.00')#<cfelse>#LSNumberFormat(0,',9.00')#</cfif>" 
								onChange="javascript:fm(this,2);" 
								onkeyup="javascript: if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
								onblur="javascript:fm(this,2);"
								size="13" maxlength="15">
					  </td>
						<td align="center" >
							<input align="right" name="ESp50_#rsFormES.ESid#"  style="text-align:right;" onFocus="this.select();"
							value="<cfif rsFormES.ESp50 GT 0>#LSNumberFormat(rsFormES.ESp50,',9.00')#<cfelse>#LSNumberFormat(0,',9.00')#</cfif>" 
								onChange="javascript:fm(this,2);" 
								onkeyup="javascript: if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
								onblur="javascript:fm(this,2);"
								size="13" maxlength="15"></td>
						<td align="center" >
							<input align="right" name="ESp75_#rsFormES.ESid#"  style="text-align:right;" onFocus="this.select();"
							value="<cfif rsFormES.ESp75 GT 0>#LSNumberFormat(rsFormES.ESp75,',9.00')#<cfelse>#LSNumberFormat(0,',9.00')#</cfif>" 
								onChange="javascript:fm(this,2);" 
								onkeyup="javascript: if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
								onblur="javascript:fm(this,2);"
								size="13" maxlength="15"></td>
						<td align="center" >
							<input align="right" name="ESvariacion_#rsFormES.ESid#"  style="text-align:right;" onFocus="this.select();"
							value="<cfif rsFormES.ESvariacion GT 0>#LSNumberFormat(rsFormES.ESvariacion,',9.00')#<cfelse>#LSNumberFormat(0,',9.00')#</cfif>" 
								onChange="javascript:fm(this,2);" 
								onkeyup="javascript: if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
								onblur="javascript:fm(this,2);"
								size="13" maxlength="8"></td>
					</tr>
					<input align="right" name="ESid_#rsFormES.ESid#" type="hidden" value="#rsFormES.ESid#" size="13" maxlength="15" >
					<input align="right" name="EEid_#rsFormES.ESid#" type="hidden" value="#rsFormES.EEid#" size="13" maxlength="15" >
					<input align="right" name="ETid_#rsFormES.ESid#" type="hidden" value="#rsFormES.ETid#" size="13" maxlength="15" >
					<input align="right" name="Eid_#rsFormES.ESid#" type="hidden" value="#rsFormES.Eid#"   size="13" maxlength="15" >
					<input align="right" name="EPid_#rsFormES.ESid#" type="hidden" value="#rsFormES.EPid#" size="13" maxlength="15" >
					<input align="right" name="EAid_#rsFormES.ESid#" type="hidden" value="#rsFormES.EAid#" size="13" maxlength="15" >
				</cfloop>
				<tr><td colspan="8">&nbsp;</td></tr>
				<tr>
					<td colspan="8" align="center">
						<input type="submit" name="CambioInfoEnc" value="Guardar" tabindex="3"
											   onClick="javascript: setBtn(this); cambioInfo();" >
<!--- 						<input type="submit" name="Baja" value="Eliminar" tabindex="3"
										   onClick="javascript: setBtn(this); return confirm('¿Desea eliminar los datos?');" > --->
						<input type="button"  name="Regresar" value="Regresar" onClick="javascript: goPage('1');" tabindex="1">
					</td>
				</tr>
				<tr><td colspan="8">&nbsp;</td></tr>
			</table>
		
		</cfif>
	</cfoutput>	
</form>

<script language="javascript" type="text/javascript">
	function validaInfoEnc(){
		<cfoutput>
			<cfif isdefined('rsFormES') and rsFormES.recordCount GT 0>
				<cfloop query="rsFormES">
					document.form1.ESpromedio_#rsFormES.ESid#.value = qf(document.form1.ESpromedio_#rsFormES.ESid#.value);
					document.form1.ESpromedioanterior_#rsFormES.ESid#.value = qf(document.form1.ESpromedioanterior_#rsFormES.ESid#.value);
					document.form1.ESp25_#rsFormES.ESid#.value = qf(document.form1.ESp25_#rsFormES.ESid#.value);				
					document.form1.ESp50_#rsFormES.ESid#.value = qf(document.form1.ESp50_#rsFormES.ESid#.value);		
					document.form1.ESp75_#rsFormES.ESid#.value = qf(document.form1.ESp75_#rsFormES.ESid#.value);		
					document.form1.ESvariacion_#rsFormES.ESid#.value = qf(document.form1.ESvariacion_#rsFormES.ESid#.value);
				</cfloop>
			</cfif>
		</cfoutput>
		return true;
	}
	
	function cambioInfo(){
		document.form1.action = 'Encuesta-sql.cfm';
	}
	
	function setBtn(obj) {
		botonActual = obj.name;
	}	
</script>