<cfquery datasource="#Session.DSN#" name="rsForm">
	Select case TTtipo
			when 1 then 'Matricula' 
			when 2 then 'Curso'
			when 3 then 'Otros'
	  	end as TTtipo
		, TTtipo as tipo
		, TTnombre
		, isnull(PTmontoFijo,0) as PTmontoFijo
		, isnull(PTmontoUnidad,0) as PTmontoUnidad
	from PeriodoTarifas pt
		, TarifasTipo tt
	where PTcodigo=<cfqueryparam value="#Form.PTcodigo#" cfsqltype="cf_sql_numeric">
		and pt.TTcodigo=tt.TTcodigo
</cfquery>

<script language="JavaScript" src="/cfmx/educ/js/qForms/qforms.js">//</script>
<script language="JavaScript" type="text/javascript" src="/cfmx/educ/js/utilesMonto.js">//</script>
<form name="formPerTarifas" method="post" action="periodoTarifas_SQL.cfm" onSubmit="javascript: return valida(this);">
	<cfoutput>
		<input type="hidden" name="PTcodigo" id="PTcodigo" value="#form.PTcodigo#">
		<input type="hidden" name="TTtipo" id="TTtipo" value="#rsForm.tipo#">		
		<cfif isdefined("Form.nivel") and Len(Trim(Form.nivel)) NEQ 0>
			<input type="hidden" name="nivel" value="#Form.nivel#">
		</cfif>
		<cfif isdefined("Form.PEcodigo") and Len(Trim(Form.PEcodigo)) NEQ 0>
			<input type="hidden" name="PEcodigo" value="#Form.PEcodigo#">
		</cfif>
		<cfif isdefined("Form.PLcodigo") and Len(Trim(Form.PLcodigo)) NEQ 0>
			<input type="hidden" name="PLcodigo" value="#Form.PLcodigo#">
		</cfif>
		<cfif isdefined("Form.CILcodigo") and Len(Trim(Form.CILcodigo)) NEQ 0>
			<input type="hidden" name="CILcodigo" value="#Form.CILcodigo#">
		</cfif>
		<cfif isdefined("Form.CIEsemanas") and Len(Trim(Form.CIEsemanas)) NEQ 0>
			<input type="hidden" name="CIEsemanas" value="#Form.CIEsemanas#">
		</cfif>
		<cfif isdefined("Form.CILtipoCicloDuracion") and Len(Trim(Form.CILtipoCicloDuracion)) NEQ 0>
			<input type="hidden" name="CILtipoCicloDuracion" value="#Form.CILtipoCicloDuracion#">
		</cfif>
		<cfif isdefined("Form.PMsecuencia") and Len(Trim(Form.PMsecuencia)) NEQ 0>
			<input type="hidden" name="PMsecuencia" value="#Form.PMsecuencia#">
		</cfif>	
		<table width="100%" border="0" cellspacing="1" cellpadding="1">
		  <tr>
			<td colspan="3" align="center" class="tituloMantenimiento"> <font size="3"> Actualizar
				Tarifa del Período </font> </td>
		  </tr>
		  <tr>
			<td width="49%" align="right">&nbsp;</td>
			<td width="1%" align="center">&nbsp;</td>
			<td width="50%" align="left">&nbsp;</td>
		  </tr>
		  <tr>
			<td colspan="3" align="center" class="areaFiltro">
				<strong>#rsForm.TTnombre# (#rsForm.TTtipo#)</strong>
			</td>
		  </tr>	  
		  <tr>
			<td width="49%" align="right">&nbsp;</td>
			<td width="1%" align="center">&nbsp;</td>
			<td width="50%" align="left">&nbsp;</td>
		  </tr>	  
		  <tr>
			<td align="right"><strong>Monto Fijo</strong>:</td>
			<td align="center">&nbsp;</td>
			<td align="left">
				<input name="PTmontoFijo" type="text" id="PTmontoFijo" value="<cfif modo neq 'ALTA'>#LSCurrencyFormat(rsForm.PTmontoFijo,'none')#</cfif>" size="10" maxlength="10" 
						style="text-align: right;"
						onfocus="javascript:this.value=qf(this); this.select();" 
						onblur="javascript:fm(this,2);"
						onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
			</td>
		  </tr>
		  <cfif isdefined('rsForm') and rsForm.tipo EQ 2>
			  <tr>
				<td align="right"><strong>Monto Cr&eacute;dito</strong>:</td>
				<td align="center">&nbsp;</td>
				<td align="left">
					<input name="PTmontoUnidad" type="text" id="PTmontoUnidad" value="<cfif modo neq 'ALTA'>#LSCurrencyFormat(rsForm.PTmontoUnidad,'none')#</cfif>" size="10" maxlength="10" 
							style="text-align: right;"
							onfocus="javascript:this.value=qf(this); this.select();" 
							onblur="javascript:fm(this,2);"  
							onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
				</td>
			  </tr>
		  </cfif>
		  <tr>
			<td align="right">&nbsp;</td>
			<td align="center">&nbsp;</td>
			<td align="left">&nbsp;</td>
		  </tr>
		  <tr>
			<td colspan="3" align="center"> 
				<input name="Cambio" type="submit" value="Modificar">
			</td>
		  </tr>
		  <tr>
			<td colspan="3" align="center">&nbsp;</td>
		  </tr>
		</table>
	</cfoutput>		
</form>

<script language="JavaScript">
	function valida(f) {
		f.obj.PTmontoFijo.value = qf(f.obj.PTmontoFijo.value);
		f.obj.PTmontoUnidad.value = qf(f.obj.PTmontoUnidad.value);
		return true;
	}

//---------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/educ/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
//---------------------------------------------------------------------------------------
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formPerTarifas");
//---------------------------------------------------------------------------------------
	objForm.PTmontoFijo.required = true;
	objForm.PTmontoFijo.description = "Monto Fijo";
	<cfif isdefined('rsForm') and rsForm.tipo EQ 2>	
		objForm.PTmontoUnidad.required = true;
		objForm.PTmontoUnidad.description = "Monto crédito";
	</cfif>
</script>