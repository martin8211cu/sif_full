<cfset modo = "ALTA">
<cfif isdefined("form.HYMRcodigo") and len(trim(form.HYMRcodigo))>
	<cfset modo = "CAMBIO">
</cfif>
<cfif modo neq 'ALTA'>
	<cfquery name="data" datasource="sifcontrol">
		select b.HYCPdescripcion, substring(b.HYCPdescalterna,1,55) as HYCPdescalterna, a.HYCPgrado, 
		a.HYMRcodigo, a.HYTSPporcentaje, c.HYMRdescripcion, c.HYMRdesclaterna , a.HYTSrestrict
		from HYTSolucionProblemas a, HYComplejidadPensamiento b, HYMarcoReferencia c
		where a.HYCPgrado=b.HYCPgrado
		  and a.HYMRcodigo=c.HYMRcodigo
		  and a.HYMRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.HYMRcodigo#">
		  and a.HYCPgrado = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.HYCPgrado#">
		  and a.HYTSPporcentaje = <cfqueryparam cfsqltype="cf_sql_float" value="#form.HYTSPporcentaje#">
		order by a.HYMRcodigo, a.HYCPgrado
		
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
<form style="margin:0;" name="form1" action="SolucionProblemasHAY-SQL.cfm" method="post">
	<table align="center" width="100%" cellpadding="2" cellspacing="0" border="0" >
		<tr>
		  <td colspan="2" align="right" nowrap><div align="center"><strong>El Pensamiento esta Guiado o circunscrito por :</strong></div></td>
	  </tr>
		<tr>
			<td colspan="2" align="right" nowrap><div align="center"><strong>&nbsp;</strong>
			    <input name="HYMRdescripcion"   align="middle" readonly="true"  type="text" value="<cfif modo neq 'ALTA'>#Trim(data.HYMRdescripcion)#</cfif>"    size="50" maxlength="50" onFocus="javascript:this.select();" style="text-transform:uppercase; border:none; text-align:center">
		    </div></td>
		</tr>
		<tr>
		  <td nowrap align="right"><strong>Descripci&oacute;n:</strong></td>
		  <td nowrap><input name="HYCPdescripcion" readonly="true" type="text" value="<cfif modo neq 'ALTA'>#Trim(data.HYCPdescripcion)#</cfif>"  size="35" maxlength="35" onFocus="javascript:this.select();" style="text-transform:uppercase; border:none;"></td>
	  </tr>
		<tr>
			<td nowrap align="right"><strong>Grado: &nbsp;</strong></td>
			<td width="74%" nowrap><input name="HYCPgrado" readonly="true" type="text" value="<cfif modo neq 'ALTA'>#Trim(data.HYCPgrado)#</cfif>"  size="5" maxlength="3" onFocus="javascript:this.select();" style="text-transform:uppercase; border:none;"></td>
		</tr>
		<tr>
			<td nowrap align="right"><strong>C&oacute;digo: &nbsp;</strong></td>
			<td width="74%" nowrap><input name="HYMRcodigo" readonly="true" type="text" value="<cfif modo neq 'ALTA'>#Trim(data.HYMRcodigo)#</cfif>"  size="5" maxlength="5" onFocus="javascript:this.select();" style="text-transform:uppercase; border:none;"></td>
		</tr>
		<tr>
			<td nowrap align="right"><strong>Porcentaje: &nbsp;</strong></td>
			<td width="74%" nowrap><input name="HYTSPporcentaje" readonly="true" type="text" value="<cfif modo neq 'ALTA'>#Trim(data.HYTSPporcentaje)#</cfif>"  size="5" maxlength="5" onFocus="javascript:this.select();" style="text-transform:uppercase; border:none;"></td>
		</tr>
		<tr>
			<td nowrap align="right"><strong>Restringido: &nbsp;</strong></td>
			<td nowrap>
				<select id="HYTSrestrict" name="HYTSrestrict" >
					<option value="1" <cfif isdefined("data") and data.HYTSrestrict EQ 1 >selected</cfif>>Habilitar</option>
					<option value="0" <cfif isdefined("data") and data.HYTSrestrict EQ 0 >selected</cfif>>Restringir</option>
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
		objForm.HYMRcodigo.required = true;
		objForm.HYMRcodigo.description="Código";
	</cfif>

	

	function deshabilitarValidacion(){
		objForm.HYMRcodigo.required = false;
	}

</script>
