<cfparam name="url.RHCid" default="">

<cfquery datasource="#session.dsn#" name="data">
	select *
	from  RHCursos
	where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHCid#" null="#Len(url.RHCid) Is 0#">
</cfquery>

<cfoutput>
<script  src="/cfmx/rh/js/utilesMonto.js"></script>
<script type="text/javascript">
<!--
	function validar(formulario){
		var error_input;
		var error_msg = '';
		// Validando tabla: RHCursos - RHCursos
		// Columna: RHIAid ID de Institucion Académica numeric
		if (formulario.RHIAid.value == "") {
			error_msg += "\n - El campo Institución Académica es requerido.";
			error_input = formulario.RHIAid;
		}
	
		// Columna: Mcodigo Mcodigo numeric
		if (formulario.Mcodigo.value == "") {
			error_msg += "\n - El campo Materia es requerido.";
			error_input = formulario.Mcodigo;
		}
	
		// Columna: RHTCid RHTCid numeric
		if (formulario.RHTCid.value == "") {
			error_msg += "\n - El campo Tipo de Curso es requerido.";
			error_input = formulario.RHTCid;
		}
	
		// Columna: RHCcodigo RHCcodigo char(15)
		if (formulario.RHCcodigo.value == "") {
			error_msg += "\n - El campo Código de Curso es requerido.";
			error_input = formulario.RHCcodigo;
		}
	
		// Columna: RHCfdesde Fecha desde del Curso datetime
		if (formulario.RHCfdesde.value == "") {
			error_msg += "\n - El campo Fecha desde es requerido.";
			error_input = formulario.RHCfdesde;
		}
	
		// Columna: RHCfhasta Fecha hasta del Curso datetime
		if (formulario.RHCfhasta.value == "") {
			error_msg += "\n - El campo Fecha hasta es requerido.";
			error_input = formulario.RHCfhasta;
		}
	
		// Columna: RHCcupo Cupo int
		if (formulario.RHCcupo.value == "") {
			error_msg += "\n - El campo Cupo es requerido.";
			error_input = formulario.RHCcupo;
		}
	
		// Validacion terminada
		if (error_msg.length != "") {
			alert("Se presentaron los siguientes errores:"+error_msg);
			error_input.focus();
			return false;
		}
		return true;
	}
//-->

	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlisRHMaterias() {
		if (trim(document.form1.RHIAid.value)){
			var params = "?RHIAid="+document.form1.RHIAid.value
			popUpWindow("/cfmx/rh/capacitacion/catalogos/conlisRHMaterias.cfm"+params,250,200,650,400);
		}
		else{
			alert('Debe seleccionar la Institución Académica');
		}
	}

	function limpiar(obj){
		document.form1.Mcodigo.value = '';
		document.form1.Mcodigo.value = '';
		document.form1.Mnombre.value = '';
	}

</script>

<form action="RHCursos-apply.cfm" onsubmit="return validar(this);" method="post" name="form1" id="form1">
	<table width="100%" cellpadding="1" cellspacing="0">
		<tr>
			<td align='right' valign="middle">C&oacute;digo:&nbsp;</td>
			<td valign="middle">
				<input name="RHCcodigo" id="RHCcodigo" type="text" value="#HTMLEditFormat(data.RHCcodigo)#" 
					maxlength="15"
					onfocus="this.select()"  >
			</td>
		</tr>

		<tr>
			<td align='right' valign="middle" width="40%">Instituci&oacute;n Acad&eacute;mica:&nbsp;</td>
			<td valign="middle">
				<cfquery name="instituciones" datasource="#session.DSN#">
					select RHIAid, RHIAcodigo, RHIAnombre 
					from RHInstitucionesA
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					order by RHIAcodigo, RHIAnombre
				</cfquery>
				<select name="RHIAid" id="RHIAid" onChange="javascript:limpiar(this);">
					<option value="">-seleccionar-</option>
					<cfloop query="instituciones">
						<option value="#instituciones.RHIAid#" <cfif data.RHIAid eq instituciones.RHIAid>selected</cfif>>#instituciones.RHIAcodigo# - #instituciones.RHIAnombre#</option>
					</cfloop>
				</select>
			</td>
		</tr>
		
		<tr>
			<td align='right' valign="middle">Materia:&nbsp;</td>
			<td valign="middle">
				<table width="1%" cellpadding="0" cellspacing="0">
					<cfquery datasource="#session.dsn#" name="materia">
						select *
						from  RHMateria
						where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.Mcodigo#" null="#Len(data.Mcodigo) Is 0#">
						order by Mnombre
					</cfquery>
					<tr>
						<td width="1%">
							<input type="hidden" name="Mcodigo" value="#HTMLEditFormat(data.Mcodigo)#" >
						</td>
						<td width="1%">
							<input type="text" name="Mnombre" id="Mnombre" disabled value="#HTMLEditFormat(materia.Mnombre)#" size="50" maxlength="80" tabindex="1">
						</td>
						<TD width="1%"><a href="##" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="Lista de Materias" name="CFimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisRHMaterias();'></a></TD>
					</tr>
				</table>
			</td>
		</tr>
		
		<tr>
			<td align='right' valign="middle">Tipo:&nbsp;</td>
			<td valign="middle">
				<cfquery name="tipos" datasource="#session.DSN#">
					select RHTCid, RHTCdescripcion
					from RHTipoCurso
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					order by RHTCdescripcion
				</cfquery>
				<select name="RHTCid" id="RHTCid">
					<option value="">-seleccionar-</option>
					<cfloop query="tipos">
						<option value="#tipos.RHTCid#" <cfif data.RHTCid eq tipos.RHTCid>selected</cfif>>#tipos.RHTCdescripcion#</option>
					</cfloop>
				</select>
			</td>
		</tr>
		
		<tr>
			<td align='right' valign="middle">Fecha Inicial:&nbsp;</td>
			<td valign="middle">
				<cf_sifcalendario form="form1" name="RHCfdesde" value="#DateFormat(data.RHCfdesde,'dd/mm/yyyy')#">
			</td>
		</tr>
		
		<tr>
			<td align='right' valign="middle">Fecha Final:&nbsp;</td>
			<td valign="middle">
				<cf_sifcalendario form="form1" name="RHCfhasta" value="#DateFormat(data.RHCfhasta,'dd/mm/yyyy')#">
			</td>
		</tr>
		
		<tr>
			<td align='right' valign="middle">Profesor:&nbsp;</td>
			<td valign="middle">
				<input name="RHCprofesor" id="RHCprofesor" type="text" value="#HTMLEditFormat(data.RHCprofesor)#" 
					maxlength="100"
					onfocus="this.select()"  >
			</td>
		</tr>
		
		<tr>
			<td align='right' valign="middle">Cupo:&nbsp;</td>
			<td valign="middle">
				<input type="text" name="RHCcupo" value="#HTMLEditFormat(data.RHCcupo)#" size="5" maxlength="5" style="text-align: right;" onBlur="javascript:fm(this,0); "  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"  >
			</td>
		</tr>
		
		<tr>
			<td></td>
			<td>
				<table width="20%" cellpadding="0" cellspacing="0">
					<tr>
						<td valign="middle">
							<input type="checkbox" name="RHCautomat" <cfif len(trim(data.RHCautomat)) and data.RHCautomat eq 1>checked</cfif> >
						</td>
						<td align='right' valign="middle" nowrap>Permite Automatr&iacute;cula</td>
					</tr>
				</table>
			</td>
		</tr>
	
		<tr>
			<td colspan="2" class="formButtons">
				<cfif data.RecordCount><cf_botones modo='CAMBIO'><cfelse><cf_botones modo='ALTA'></cfif>
			</td>
		</tr>
	</table>
		
	<input type="hidden" name="RHCid" value="#HTMLEditFormat(data.RHCid)#">
	<cfset ts = "">
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
			artimestamp="#data.ts_rversion#" returnvariable="ts">
	</cfinvoke>
	<input type="hidden" name="ts_rversion" value="#ts#">
</form>
</cfoutput>