<cfset modo = "ALTA">
<cfif isdefined("form.HYTAptshab") and len(trim(form.HYTAptshab))>
	<cfset modo = "CAMBIO">
</cfif>
<cfif modo neq 'ALTA'>
	<cfquery name="data" datasource="sifcontrol">
		select HYTAptshab, HYTAporcentaje, HYTApts , HYTASrestrict
		from HYTASolucionProblemas
		where HYTAptshab = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.HYTAptshab#">
		  and HYTAporcentaje = <cfqueryparam cfsqltype="cf_sql_float" value="#form.HYTAporcentaje#">
	</cfquery>
</cfif>

<script language="JavaScript1.2" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>


<cfoutput>
<form style="margin:0;" name="form1" action="AuxSolucionProblemasHAY-SQL.cfm" method="post">
	<table align="center" width="100%" cellpadding="2" cellspacing="0" border="0" >
		<tr>
		  <td colspan="2" align="right" nowrap><div align="center"><strong>Cuadro Auxiliar de Soluci&oacute;n de Problemas :</strong></div></td>
	  </tr>
		<tr>
			<td nowrap align="right"><strong>Puntos Habilidad : &nbsp;</strong></td>
			<td width="74%" nowrap><input name="HYTAptshab" readonly="true" type="text" value="<cfif modo neq 'ALTA'>#Trim(data.HYTAptshab)#</cfif>"  size="5" maxlength="5" onFocus="javascript:this.select();" style="text-transform:uppercase; border:none;"></td>
		</tr>
		<tr>
			<td nowrap align="right"><strong>Porcentaje: &nbsp;</strong></td>
			<td width="74%" nowrap><input name="HYTAporcentaje" readonly="true" type="text" value="<cfif modo neq 'ALTA'>#Trim(data.HYTAporcentaje)#</cfif>"  size="5" maxlength="5" onFocus="javascript:this.select();" style="text-transform:uppercase; border:none;"></td>
		</tr>
		<tr>
          <td nowrap align="right"><strong>Valor: &nbsp;</strong></td>
          <td nowrap><input name="HYTApts" readonly="true" type="text" value="<cfif modo neq 'ALTA'>#Trim(data.HYTApts)#</cfif>"  size="5" maxlength="5" onFocus="javascript:this.select();" style="text-transform:uppercase; border:none;"></td>
	  </tr>
		<tr>
			<td nowrap align="right"><strong>Restringido: &nbsp;</strong></td>
			<td nowrap>
				<select id="HYTASrestrict" name="HYTASrestrict" >
					<option value="1" <cfif isdefined("data") and data.HYTASrestrict EQ 1 >selected</cfif>>Habilitar</option>
					<option value="0" <cfif isdefined("data") and data.HYTASrestrict EQ 0 >selected</cfif>>Restringir</option>
				</select>
				<cfif isdefined("Form.PageNum") and Len(Trim(Form.PageNum))>
					<input name="PageNum" type="hidden" value="#Form.PageNum#">
				</cfif>
			</td>
		</tr>	
		
		<!--- Portles de Botones --->
		<tr>
			<td nowrap colspan="2" align="center">
				<cf_botones modo=#modo# exclude= "Baja,Nuevo,Alta,Limpiar">	
			</td>
		</tr>
	</table>
</form>
</cfoutput>

<script language="JavaScript1.2" type="text/javascript">	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	
	<cfif modo EQ 'ALTA'>
		objForm.HYTAptshab.required = true;
		objForm.HYTAptshab.description="Código";
	</cfif>

	

	function deshabilitarValidacion(){
		objForm.HYTAptshab.required = false;
	}

</script>
