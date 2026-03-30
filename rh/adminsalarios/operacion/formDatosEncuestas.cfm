
<cfif isdefined("Form.Mcodigo") and LEN(form.Mcodigo) GT 0>
	<cfquery name="rsEncMcodigo" datasource="sifpublica">
		select 1
		from EncuestaSalarios a, EncuestaPuesto b
		where a.Eid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Eid#">
		  and a.Moneda = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
		  and b.EAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EAid#">
		  and a.EPid = b.EPid
	</cfquery>

	<cfif isdefined("rsEncMcodigo") and rsEncMcodigo.RecordCount EQ 0>
		<cfquery name="rsConsulta" datasource="sifpublica">
			select *
			from EncuestaSalarios
			where Eid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Eid#">
		</cfquery>
		<cfif isdefined("rsConsulta") and rsConsulta.RecordCount Gt 0>
			<cfset Mcodigo = rsConsulta.moneda>
			<cfif not ( isdefined("form.EEid") and len(trim(form.EEid)))>
				<cfset form.EEid = rsConsulta.EEid >
			</cfif>
		</cfif>	
	</cfif>
<cfelse>
	<cfquery name="rsConsulta" datasource="sifpublica">
		select *
		from EncuestaSalarios
		where Eid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Eid#">
	</cfquery>
	<cfif isdefined("rsConsulta") and rsConsulta.RecordCount Gt 0>
		<cfset Mcodigo = rsConsulta.moneda >
		<cfif not ( isdefined("form.ETid") and len(trim(form.ETid)))>
			<cfset form.ETid = rsConsulta.ETid >
		</cfif>
		<cfif not ( isdefined("form.EEid") and len(trim(form.EEid)))>
			<cfset form.EEid = rsConsulta.EEid >
		</cfif>
	</cfif>	
</cfif>

<cfif not isdefined("rsEncMcodigo")>
	<cfset Form.modo = 'ALTA'>
<cfelse>
	<cfset Form.modo = 'CAMBIO'>
</cfif>

<cfquery name="rsEncabezado" datasource="#session.DSN#">
	select Edescripcion, EEnombre, a.EEid
	from Encuesta a inner join EncuestaEmpresa b
            on a.EEid = b.EEid
	where Eid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Eid#">
</cfquery>

<!--- <cfif not ( isdefined("form.ETid") and len(trim(form.ETid)))>
	<cfquery  name="dataOrganizacion" datasource="#session.DSN#" maxrows="1">
		select ETid
		from EmpresaOrganizacion
	</cfquery>
	<cfif len(trim(dataOrganizacion.ETid))>
		<cfset form.ETid = dataOrganizacion.ETid >
	</cfif>
</cfif> --->

<cfquery name="rsOrganizacion" datasource="sifpublica">
	select ETid, ETdescripcion 
	from EmpresaOrganizacion
	<cfif isdefined('rsEncabezado') and rsEncabezado.RecordCount GT 0>
	where EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.EEid#">
	</cfif>

</cfquery>

<cfquery name="rsArea" datasource="sifpublica">
	select EAid, EAdescripcion 
	from EmpresaArea
	where EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncabezado.EEid#">
</cfquery>




<!-----
	select 	*, 
			b.EEnombre, 
			c.Edescripcion, 
			d.ETdescripcion, 
			e.EPcodigo, 
			e.EPdescripcion, 
			f.EAdescripcion

	from EncuestaSalarios a 
	
	left outer join EncuestaEmpresa b
	  on a.EEid = b.EEid 
	  
	left outer join Encuesta c
	  on a.EEid = c.EEid and  
	  	 a.Eid = c.Eid 
		 
	left outer join EmpresaOrganizacion d
	  on a.EEid = b.EEid 
	     and a.ETid = d.ETid 
		 and d.ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETid#">
		 
	left outer join EncuestaPuesto e
      on a.EEid = b.EEid and
		 a.EPid =e.EPid 
		 
	left outer join EmpresaArea f
      on e.EEid = f.EEid and
		 e.EAid =f.EAid 

	where a.Eid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Eid#">
	  and a.Moneda = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mcodigo#">
	  and a.ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETid#">
	order by e.EAid, a.EPid
------>

<cfif isdefined('Form.EAid') and LEN(Form.EAid) GT 0>

	<cfquery name="rsForm" datasource="sifpublica">
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
				and a.Moneda = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mcodigo#">
				and a.ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETid#">
				and e.EAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EAid#">
	
		order by e.EAid, a.EPid
	</cfquery>
</cfif>

<cfquery name="rsMonedas" datasource="#session.DSN#">
	select Mcodigo,Mnombre,Msimbolo
	from Monedas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>

<cf_templatecss>
<script language="JavaScript" src="/cfmx/rh/js/utilesMonto.js"></script>
<script language="JavaScript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<form style="margin:0; " name="form1" action="SQLDatosEncuestas.cfm"  method="post"><!--- onSubmit="return valida(this);"  --->
<input name="Eid" type="hidden" value="<cfoutput>#Form.Eid#</cfoutput>" size="13" maxlength="8">
	<cfoutput>
		<link type="text/css" rel="stylesheet" href="/cfmx/sif/css/asp.css">
		<!--- ENCABEZADO DE LA ENCUESTA --->
		<table width="100%" border="0" align="center">
			<tr>
				<td colspan="2" align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#rsEncabezado.EEnombre#</strong></td>
			</tr>
			<tr>
				<td colspan="2" align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#rsEncabezado.Edescripcion#</strong></td>
			</tr>
			<tr>
				<td colspan="2" >&nbsp;</td>
			</tr>

			<cfif isdefined('Form.Area') and LEN(Form.Area) GT 0>
			<tr>
				<td colspan="2" align="center" class="tituloListas">Tipo de Organizaci&oacute;n - #rsForm.ETdescripcion#</td>
			</tr>
			</cfif>
			<tr>
				<td colspan="2" align="center">
					<table width="20%" align="center" class="areaFiltro">
						<tr>
							<td width="7%" align="left" nowrap><div align="right"><strong>Tipo de Organizaci&oacute;n:&nbsp;</strong></div></td>
							<td width="93%" nowrap>
								<cfoutput>
									<select name="ETid" id="ETid"  style="width:150px; "> 
										<option value="" >-- seleccionar organizacion --</option>
										<cfloop query="rsOrganizacion">
											<option value="#rsOrganizacion.ETid#" <cfif isdefined("Form.ETid") and Form.ETid EQ rsOrganizacion.ETid>selected</cfif>>#rsOrganizacion.ETdescripcion#</option>
										</cfloop>
									</select>
								</cfoutput>						
							</td>
						</tr>
						<tr>
							<td width="7%" align="left" nowrap><div align="right"><strong>&Aacute;rea:&nbsp;</strong></div></td>
							<td width="93%" nowrap>
								<cfoutput>
									<select name="EAid" id="EAid"  style="width:150px; "> 
										<option value="" >-- seleccionar área --</option>
										<cfloop query="rsArea">
											<option value="#rsArea.EAid#" <cfif isdefined("Form.EAid") and Form.EAid EQ rsArea.EAid>selected</cfif>>#rsArea.EAdescripcion#</option>
										</cfloop>
									</select>
								</cfoutput>						
							</td>
						</tr>			
			
						<tr>
							<td width="7%" align="left" nowrap><div align="right"><strong>Moneda:&nbsp;</strong></div></td>
							<td width="93%" nowrap>
			
								<cfoutput>
									<select name="Mcodigo" id="Mcodigo" style="width:150px; " > 
										<option value="" >--seleccionar moneda--</option>
										<cfloop query="rsMonedas">
											<option value="#rsMonedas.Mcodigo#" <cfif isdefined("Form.Mcodigo") and Form.Mcodigo EQ rsMonedas.Mcodigo>selected</cfif>>
												#rsMonedas.Mnombre# - #rsMonedas.Msimbolo#</option>
										</cfloop>
									</select>
								</cfoutput>						
			
							</td>
						</tr>
						<tr>
							<td  colspan="2" align="center" nowrap>
								<input type="submit" name="Ver" value="Ver Datos" onClick="javascript:document.form1.action='';">
							</td>
						</tr>

					</table>
				</td>
			</tr>

			<tr><td colspan="2">&nbsp;</td></tr>
		</table><br>

		<cfif isdefined('Form.EAid')>
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
	
				<cfloop query="rsForm">
					<tr class="<cfif rsForm.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
						<td nowrap>&nbsp;&nbsp;#rsForm.EPcodigo# - #rsForm.EPdescripcion#</td>
						<td >
							<input align="center" name="Obs_#rsForm.ESid#"  style="text-align:right;" onFocus="this.select();"
							value="<cfif isdefined("rsEncMcodigo") and rsEncMcodigo.RecordCount GT 0>#LSNumberFormat(rsForm.EScantobs,',9')#<cfelse>#LSNumberFormat(0,',9')#</cfif>" 
								onkeyup="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" 
								onblur="javascript:fm(this,0);"
								size="13" maxlength="3">
						</td>
						<td >
							<input align="right" name="ESpromedio_#rsForm.ESid#" style="text-align:right;" onFocus="this.select();"
							value="<cfif isdefined("rsEncMcodigo") and rsEncMcodigo.RecordCount GT 0>#LSNumberFormat(rsForm.ESpromedio,',9.00')#<cfelse>#LSNumberFormat(0,',9.00')#</cfif>" 
								  onChange="javascript:fm(this,2);" 
								  onkeyup="javascript: if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
								  onblur="javascript:fm(this,2);"
								  size="13" maxlength="15">
						</td>
						<td align="center" >
							<input align="right" name="ESpromedioanterior_#rsForm.ESid#" style="text-align:right;" onFocus="this.select();" 
								 value="<cfif isdefined("rsEncMcodigo") and rsEncMcodigo.RecordCount GT 0>#LSNumberFormat(rsForm.ESpromedioanterior,',9.00')#<cfelse>#LSNumberFormat(0,',9.00')#</cfif>" 							 
								 onChange="javascript:fm(this,2);" 
								 onkeyup="javascript: if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
								 onblur="javascript:fm(this,2);"
								 size="13" maxlength="15">
						</td>
						<td align="center" >
							<input align="right" name="ESp25_#rsForm.ESid#"  style="text-align:right;" onFocus="this.select();"
								value="<cfif isdefined("rsEncMcodigo") and rsEncMcodigo.RecordCount GT 0>#LSNumberFormat(rsForm.ESp25,',9.00')#<cfelse>#LSNumberFormat(0,',9.00')#</cfif>" 
								onChange="javascript:fm(this,2);" 
								onkeyup="javascript: if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
								onblur="javascript:fm(this,2);"
								size="13" maxlength="15">
					  </td>
						<td align="center" >
							<input align="right" name="ESp50_#rsForm.ESid#"  style="text-align:right;" onFocus="this.select();"
							value="<cfif isdefined("rsEncMcodigo") and rsEncMcodigo.RecordCount GT 0>#LSNumberFormat(rsForm.ESp50,',9.00')#<cfelse>#LSNumberFormat(0,',9.00')#</cfif>" 
								onChange="javascript:fm(this,2);" 
								onkeyup="javascript: if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
								onblur="javascript:fm(this,2);"
								size="13" maxlength="15"></td>
						<td align="center" >
							<input align="right" name="ESp75_#rsForm.ESid#"  style="text-align:right;" onFocus="this.select();"
							value="<cfif isdefined("rsEncMcodigo") and rsEncMcodigo.RecordCount GT 0>#LSNumberFormat(rsForm.ESp75,',9.00')#<cfelse>#LSNumberFormat(0,',9.00')#</cfif>" 
								onChange="javascript:fm(this,2);" 
								onkeyup="javascript: if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
								onblur="javascript:fm(this,2);"
								size="13" maxlength="15"></td>
						<td align="center" >
							<input align="right" name="ESvariacion_#rsForm.ESid#"  style="text-align:right;" onFocus="this.select();"
							value="<cfif isdefined("rsEncMcodigo") and rsEncMcodigo.RecordCount GT 0>#LSNumberFormat(rsForm.ESvariacion,',9.00')#<cfelse>#LSNumberFormat(0,',9.00')#</cfif>" 
								onChange="javascript:fm(this,2);" 
								onkeyup="javascript: if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
								onblur="javascript:fm(this,2);"
								size="13" maxlength="8"></td>
					</tr>
					<input align="right" name="ESid_#rsForm.ESid#" type="hidden" value="#rsForm.ESid#" size="13" maxlength="15" >
					<input align="right" name="EEid_#rsForm.ESid#" type="hidden" value="#rsForm.EEid#" size="13" maxlength="15" >
					<input align="right" name="ETid_#rsForm.ESid#" type="hidden" value="#rsForm.ETid#" size="13" maxlength="15" >
					<input align="right" name="Eid_#rsForm.ESid#" type="hidden" value="#rsForm.Eid#"   size="13" maxlength="15" >
					<input align="right" name="EPid_#rsForm.ESid#" type="hidden" value="#rsForm.EPid#" size="13" maxlength="15" >
					<input align="right" name="EAid_#rsForm.ESid#" type="hidden" value="#rsForm.EAid#" size="13" maxlength="15" >
				</cfloop>
				<tr><td colspan="8">&nbsp;</td></tr>
				<tr>
					<td colspan="8" align="center">
						<cfif isdefined("rsEncMcodigo") and rsEncMcodigo.RecordCount GT 0>
							<input type="submit" name="Cambio" value="Guardar" tabindex="3"
											   onClick="javascript: setBtn(this); " >
						<cfelse>
							<input type="submit" name="Alta" value="Agregar" tabindex="3"
											   onClick="javascript: setBtn(this); " >
						</cfif>
						<input type="submit" name="Baja" value="Eliminar" tabindex="3"
										   onClick="javascript: setBtn(this); return confirm('¿Desea eliminar los datos?');" >
						<input type="button"  name="Regresar" value="Regresar" onClick="javascript: Lista();" tabindex="1">
					</td>
					
				</tr>
	
				<tr><td>&nbsp;</td></tr>
	
			</table>
		</cfif>		
		<table width="60%" align="center" border="0" class="areaFiltro" style="border-collapse:collapse;" cellpadding="2" cellspacing="0">
			<tr>
				<td width="40%" valign="top">			  
				  <strong>OBS</strong><br>
			      Cantida de Observaciones del Puesto <br>
			      <strong>Promedio</strong><br>
			      Promedio de Salarios del Periodo Actual<br>
			      <strong>Promedio Anterior </strong><br>
			      Promedio de Salarios del  Periodo Anterior <br>
				  <strong>P25</strong>
				  Percentil veinticinco
			    </td>
				<td width="20%"></td>
				<td width="40%" valign="top">
					<strong>P50</strong><br>
					Percentil cincuenta<br>
					<strong>P75</strong><br>
					Percentil setenta y cinco <br>
				  <strong>Variación</strong><br>
					Variaci&oacute;n de los Datos <br>
					<br>

			  </td>
			  <td width="16%">&nbsp;</td>
			</tr>
		</table>
	</cfoutput>
</form>

 

<script language="JavaScript1.2">

	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->

	function Lista() {
		location.href = 'listaDatosEncuestas.cfm';
	}
	function CargaDatos(moneda,valor){
		<cfset modo = 'CAMBIO'>
		location.href = 'DatosEncuestas.cfm?Eid=' + valor + '&Mcodigo='+ moneda.value;
	}
	function valida(){
		<cfoutput>
			<cfif isdefined('rsForm')>
				<cfloop query="rsForm">
					document.form1.ESpromedio_#rsForm.ESid#.value = qf(document.form1.ESpromedio_#rsForm.ESid#.value);
					document.form1.ESpromedioanterior_#rsForm.ESid#.value = qf(document.form1.ESpromedioanterior_#rsForm.ESid#.value);
					document.form1.ESp25_#rsForm.ESid#.value = qf(document.form1.ESp25_#rsForm.ESid#.value);				
					document.form1.ESp50_#rsForm.ESid#.value = qf(document.form1.ESp50_#rsForm.ESid#.value);		
					document.form1.ESp75_#rsForm.ESid#.value = qf(document.form1.ESp75_#rsForm.ESid#.value);		
					document.form1.ESvariacion_#rsForm.ESid#.value = qf(document.form1.ESvariacion_#rsForm.ESid#.value);
				</cfloop>
			</cfif>
		</cfoutput>
		return true;
	}
	
	function setBtn(obj) {
		botonActual = obj.name;
	}
		
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.Mcodigo.required = true;
	objForm.Mcodigo.description="Moneda";
	objForm.ETid.required = true;
	objForm.ETid.description="Tipo de Organización";
	objForm.EAid.required = true;
	objForm.EAid.description="Área Profesional";

</script>