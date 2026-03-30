<cfparam name="url.RHECid" default="">

<cfquery datasource="#session.dsn#" name="data">
	select *
	from  RHEmpleadoCurso
	where RHECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHECid#" null="#Len(url.RHECid) Is 0#">
</cfquery>


<script language="javascript1.2" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>

<cfoutput>
	<script type="text/javascript">
		function validar(formulario)
		{
			var error_input;
			var error_msg = '';
			// Validando tabla: RHEmpleadoCurso - RHEmpleadoCurso
			
			// Columna: RHCid id de Curso numeric
			if (formulario.Mcodigo.value == "") {
				error_msg += "\n - #MSG_CampoCursoRequerido#.";
				error_input = formulario.Mcodigo;
			}
				
			/*
			if (formulario.RHECfdesde.value == "") {
				error_msg += "\n - El campo Fecha Inicio es requerido.";
				error_input = formulario.RHECfdesde;
			}

			if (formulario.RHECfhasta.value == "") {
				error_msg += "\n - El campo Fecha Final es requerido.";
				error_input = formulario.RHECfhasta;
			}
			*/

			// Columna: RHEMnotamin Nota Mínima numeric(5,2)
			if (formulario.RHEMnotamin.value == "") {
				error_msg += "\n - #MSG_CampoNotaMinimaRequerido#.";
				error_input = formulario.RHEMnotamin;
			}
		
			// Validacion terminada
			if (error_msg.length != "") {
				alert("#MSG_SePresentaronLosSiguientesErrores#:"+error_msg);
				error_input.focus();
				return false;
			}
			return true;
		}
	</script>

	<form action="convalidar-apply.cfm" onsubmit="return validar(this);" method="post" name="formec" id="form1">
		<table width="100%" cellpadding="1" cellspacing="0">
			<tr>
				<td valign="top" align="right">#LB_Curso#:&nbsp;</td><td valign="top">
					<cfif len(trim(data.Mcodigo))>
						<cf_materias form="formec" idquery="#data.Mcodigo#" >
					<cfelse>	
						<cf_materias form="formec" >
					</cfif>
				</td>
			</tr>
			<tr>
				<td valign="top" align="right">#LB_Fecha_Inicio#:&nbsp;</td><td valign="top">
					<cfset fechai = '' >
					<cfif len(trim(data.RHECfdesde))><cfset fechai = LSDateFormat(data.RHECfdesde,'dd/mm/yyyy')></cfif>
					<cf_sifcalendario form="formec" name="RHECfdesde" value="#htmleditformat(fechai)#" >
				</td>
			</tr>
			<tr>
				<td valign="top" align="right">#LB_Fecha_Final#:&nbsp;</td><td valign="top">
					<cfset fechaf = '' >
					<cfif len(trim(data.RHECfhasta))><cfset fechaf = LSDateFormat(data.RHECfhasta,'dd/mm/yyyy')></cfif>
					<cf_sifcalendario form="formec" name="RHECfhasta"  value="#htmleditformat(fechaf)#">
				</td>
			</tr>
			<tr>
				<td valign="top" align="right">#LB_NotaMinima#:&nbsp;</td>
				<td valign="top">
					<input name="RHEMnotamin" id="RHEMnotamin" type="text" value="#HTMLEditFormat(data.RHEMnotamin)#" 
						maxlength="6" size="6" style=" text-align:right "
						onBlur="javascript:fm(this,2)" onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" >
				</td>
			</tr>
			<tr>
				<td valign="top" align="right">#LB_Horas#:&nbsp;</td>
				<td valign="top">
					<input name="RHEMhoras" id="RHEMhoras" type="text" value="#HTMLEditFormat(data.RHEMhoras)#" 
						maxlength="6" size="6" style=" text-align:right "
						onBlur="javascript:fm(this,2)" onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" >
				</td>
			</tr>
			<tr>
				<td valign="top" align="right">#LB_NotaObtenida#:&nbsp;</td>
				<td valign="top">
					<input name="RHEMnota" id="RHEMnota" type="text" value="#HTMLEditFormat(data.RHEMnota)#" 
						maxlength="6" size="6" style=" text-align:right "
						onBlur="javascript:fm(this,2)" onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" >
				</td>
			</tr>
			
			<!---
			<tr>
				<td valign="top" align="right">Costo Empresa:</td>
				<td valign="top">
					<input name="RHECtotempresa" id="RHECtotempresa" type="text" value="<cfif len(trim(data.RHECtotempleado))>#LSNumberFormat(data.RHECtotempresa,',9.00')#</cfif>" 
						maxlength="10" size="10" style=" text-align:right "
						onBlur="javascript:fm(this,2)" onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" >
				</td>
			</tr>
			
			<tr>
				<td valign="top" align="right">Costo Empleado:&nbsp;</td>
				<td valign="top">		
					<input name="RHECtotempleado" id="RHECtotempleado" type="text" value="<cfif len(trim(data.RHECtotempleado))>#LSNumberFormat(data.RHECtotempleado,',9.00')#</cfif>" 
						maxlength="10" size="10" style=" text-align:right "
						onBlur="javascript:fm(this,2)" onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"  >
				</td>
			</tr>
			--->		
			
			<!---
			<tr>
				<td valign="top" align="right">Moneda:&nbsp;</td>
				<td valign="top"><cf_sifmonedas form="formec" Mcodigo="idmoneda" value="#htmleditformat(data.idmoneda)#"></td>
			</tr>
			--->		
			
			<!---
			<tr>
				<td valign="top"></td>
				<td valign="top">
					<input name="RHECcobrar" id="RHECcobrar" type="checkbox" value="1" <cfif Len(data.RHECcobrar) And data.RHECcobrar>checked</cfif> >
					<label for="RHECcobrar">Cobrar si reprueba</label>
				</td>
			</tr>
			--->
			
			<!---
			<tr>
				<td valign="top" align="right">Estado:&nbsp;</td>
				<td valign="top">
					<select name="RHEMestado" id="RHEMestado">
						<option value="0" <cfif data.RHEMestado is '0'>selected</cfif> >En progreso</option>
						<option value="10" <cfif data.RHEMestado is '10'>selected</cfif> >Aprobado</option>
						<option value="15" <cfif data.RHEMestado is '15'>selected</cfif> >Convalidado</option>
						<option value="20" <cfif data.RHEMestado is '20'>selected</cfif> >Perdido</option>
						<option value="30" <cfif data.RHEMestado is '30'>selected</cfif> >Abandonado</option>
						<option value="40" <cfif data.RHEMestado is '40'>selected</cfif> >Retirado</option>
					</select>
				</td>
			</tr>
			--->		
		
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="2" class="formButtons">
				<cfif data.RecordCount>
					<cf_botones modo='CAMBIO'>
				<cfelse>
					<cf_botones modo='ALTA'>
				</cfif>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
		</table>
		
		<cfset ts = "">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
			artimestamp="#data.ts_rversion#" returnvariable="ts">
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
		
		<input type="hidden" name="RHECid" value="#data.RHECid#">
		<input type="hidden" name="DEid" value="#form.DEid#">
		<input type="hidden" name="tab" value="10">
		<input type="hidden" name="RHEMestado" value="15">
		<input type="hidden" name="RHECtotempresa" value="0">
		<input type="hidden" name="RHECtotempleado" value="0">
	</form>
</cfoutput>


