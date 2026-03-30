<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DebeDigitarUnPesoEntre0Y100"
	Default="Debe Digitar un peso entre 0 y 100"
	returnvariable="MSG_DebeDigitarUnPesoEntre0Y100"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Valores"
	Default="Valores"
	returnvariable="LB_Valores"/>


<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfif isDefined("session.Ecodigo") and isDefined("Form.RHEAid") and len(trim(#Form.RHEAid#)) NEQ 0>
	<cf_translatedata name="get" tabla="RHEAreasEvaluacion" col="RHEAdescripcion" returnvariable="LvarRHEAdescripcion">
	<cfquery name="rsRHEAreasEvaluacion" datasource="#Session.DSN#" >
		Select RHEAid, <cf_dbfunction name="spart" args="#LvarRHEAdescripcion#°1°55" delimiters="°"> as RHEAdescripcion 	
			, Usucodigo, RHEAcodigo, RHEApeso,ts_rversion
        from RHEAreasEvaluacion
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and RHEAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHEAid#">
		  and RHGcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHGcodigo#" >		  
		order by RHEAdescripcion asc
	</cfquery>
</cfif>
<cf_translatedata name="get" tabla="RHGruposAreasEval" col="RHGdescripcion" returnvariable="LvarRHGdescripcion">
<cfquery datasource="#session.DSN#" name="rsRHGruposAreasEval">
	select distinct RHGcodigo, <cf_dbfunction name="spart" args="#LvarRHGdescripcion#°1°45" delimiters="°"> as RHGdescripcion
	from RHGruposAreasEval
	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >
	order by RHGdescripcion, RHGcodigo

</cfquery>	
<!--- Javascript --->
<script language="JavaScript" src="/cfmx/rh/js/utilesMonto.js"></script> 
<SCRIPT SRC="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//qFormAPI.include("validation");
	//qFormAPI.include("functions", null, "12");
	//-->
</SCRIPT>
<script language="JavaScript" type="text/JavaScript">
<!--
	function funcValores() {
		if (document.form.RHEAid.value !="") {
			deshabilitar();
			document.form.action='AreasEvaluacionDetalle.cfm?RHEAid='+document.form.RHEAid.value + '&usucodigo='+document.form.Usucodigo.value;
			document.form.submit();
		}
		return false;
	}


//-->
</script>


<form action="AreasEvaluacion-SQL.cfm" method="post" name="form" >
	<cfoutput>
	<table width="67%" height="75%" align="center" cellpadding="0" cellspacing="0">
		<tr><td colspan="5">&nbsp;</td></tr>
		<tr>
			<td width="13%" align="right" nowrap>&nbsp;</td> 
			<td width="16%" align="right" nowrap><strong>#LB_Codigo#:&nbsp;</strong></td>
			<td width="16%">
				<input name="RHEAcodigo" type="text"  onFocus="this.select();" 
				value="<cfif modo neq "ALTA" ><cfoutput>#rsRHEAreasEvaluacion.RHEAcodigo#</cfoutput></cfif>" 
				size="10" maxlength="5">
			</td>
			<td width="15%" align="right" nowrap>&nbsp;</td>
			<td width="40%">&nbsp;</td>
		</tr>
		<tr>
			<td align="right" nowrap>&nbsp;</td>
			<td align="right" nowrap><strong>#LB_Descripcion#:&nbsp;</strong></td>
			<td colspan="3">
				<input name="RHEAdescripcion" type="text"  
				value="<cfif modo neq "ALTA"><cfoutput>#rsRHEAreasEvaluacion.RHEAdescripcion#</cfoutput></cfif>" 
				size="60" maxlength="80" onFocus="this.select();">
			</td>
		</tr>
		<tr>
			<td align="right" nowrap>&nbsp;</td>
			<td align="right" nowrap><strong>#LB_Grupos#:&nbsp;</strong></td>	</cfoutput>

			<td colspan="3" align="left"><span class="subTitulo">
				<select name="RHGcodigo" >
					<cfoutput query="rsRHGruposAreasEval">
					<option value="#rsRHGruposAreasEval.RHGcodigo#" 
						<cfif modo neq "ALTA" and isdefined("form.RHGcodigo") and form.RHGcodigo EQ rsRHGruposAreasEval.RHGcodigo >
							selected
						</cfif> >#rsRHGruposAreasEval.RHGdescripcion#
					</option>
					</cfoutput>
				</select>
			</span></td>
		</tr>
		<tr><cfoutput>
			<td align="right" nowrap>&nbsp;</td> 
			<td align="right" nowrap><strong>&nbsp; &nbsp;#LB_Peso#:&nbsp;</strong></td>
			<td align="left">
			<input name="RHEApeso" 
				type="text"  style="text-align:right" 
				onchange="javascript:fm(this,2);"  
				onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}};"
				value="<cfif modo neq "ALTA">#rsRHEAreasEvaluacion.RHEApeso#</cfif>" 
				size="8" maxlength="6" onfocus="this.select();" />
				</td>
			<td align="right" nowrap></td>
			<td align="left"></td></cfoutput>
		</tr>
		<tr><td colspan="5" align="center" nowrap>&nbsp;</td></tr>
		<tr> 
			<cfif modo NEQ "ALTA">
				<td colspan="4" align="center" nowrap>	
					<cf_botones modo=#modo#  regresarMenu = "true">	
				</td>
				<td align="left" nowrap>	
					<input type="submit" name="Valores" class="btnNormal" value="<cfoutput>#LB_Valores#</cfoutput>" onclick="javascript: this.form.botonSel.value = this.name; if (window.funcValores) return funcValores();" tabindex="0">	 
				</td>	
			<cfelse>
				<td colspan="5" align="center" nowrap>	
					<cf_botones modo=#modo# regresarMenu = "true">	
				</td>
			</cfif> 
		</tr>
	</table>
	<cfset ts = "">
	<cfif modo NEQ "ALTA">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsRHEAreasEvaluacion.ts_rversion#"/>
		</cfinvoke>
	</cfif>  
	<cfoutput>
	<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>" size="32">
	<input type="hidden" name="RHEAid"value="<cfif modo neq "ALTA">#rsRHEAreasEvaluacion.RHEAid#</cfif>" size="32">
	<input type="hidden" name="Usucodigo"value="<cfif modo neq "ALTA">#rsRHEAreasEvaluacion.Usucodigo#</cfif>" size="32">
	</cfoutput>
</form>

<script language="JavaScript1.2" type="text/javascript">
<cfoutput>
	function __isPeso() {
		if (objForm.RHEApeso.value < 0 || objForm.RHEApeso.value > 100 ){
				this.error = "#MSG_DebeDigitarUnPesoEntre0Y100#"
			}
		}	
	 _addValidator("isPeso", __isPeso);
	</cfoutput>	 
	
	function deshabilitar(){
		objForm.RHEAcodigo.required = false;
		objForm.RHEAdescripcion.required= false;
		objForm.RHEApeso.required= false;		

	}
	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form");
		
	<cfif modo EQ "ALTA">
		<cfoutput>
		objForm.RHEAcodigo.required = true;
		objForm.RHEAcodigo.description="#LB_Codigo#";		
		objForm.RHEAdescripcion.required= true;
		objForm.RHEAdescripcion.description="#LB_Descripcion#";		
		objForm.RHEApeso.required= true;
		objForm.RHEApeso.description="#LB_Peso#";
		</cfoutput>
	</cfif>
	objForm.RHEApeso.validatePeso();				
</script>
