<cfset modo = "ALTA">
<cfif isdefined("form.HYTHid") and len(trim(form.HYTHid))>
	<cfset modo = "CAMBIO">
</cfif>
<cfif modo neq 'ALTA'>
	<cfquery name="data" datasource="sifcontrol">
		select HYTHid, HYHEcodigo, HYHGcodigo, HYIHgrado, HYTHpuntos, HYTHrestrict
		from HYTHabilidades 
		where HYTHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.HYTHid#">
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
<form style="margin:0;" name="form1" action="HabilidadesHAY-SQL.cfm" method="post">
	<table align="center" width="100%" cellpadding="2" cellspacing="0" border="0" >
		<tr>
			<td nowrap align="right"><strong>C&oacute;digo: &nbsp;</strong></td>
			<td width="74%" nowrap><input name="HYHEcodigo"  readonly="true" type="text" value="<cfif modo neq 'ALTA'>#Trim(data.HYHEcodigo)#</cfif>"  size="3" maxlength="1" onFocus="javascript:this.select();" style="text-transform:uppercase;  border:none;"></td>
		</tr>
		<tr>
			<td nowrap align="right"><strong>C&oacute;digo Grupo: &nbsp;</strong></td>
			<td width="74%" nowrap><input name="HYHGcodigo" readonly="true" type="text" value="<cfif modo neq 'ALTA'>#Trim(data.HYHGcodigo)#</cfif>"  size="5" maxlength="3" onFocus="javascript:this.select();" style="text-transform:uppercase;  border:none;"></td>
		</tr>
		<tr>
			<td nowrap align="right"><strong>Grados: &nbsp;</strong></td>
			<td width="74%" nowrap><input name="HYIHgrado" readonly="true" type="text" value="<cfif modo neq 'ALTA'>#Trim(data.HYIHgrado)#</cfif>"  size="5" maxlength="5" onFocus="javascript:this.select();" style="text-transform:uppercase;  border:none;"></td>
		</tr>
		<tr>
			<td nowrap align="right"><strong>Puntos: &nbsp;</strong></td>
			<td width="74%" nowrap><input name="HYTHpuntos" readonly="true" type="text" value="<cfif modo neq 'ALTA'>#Trim(data.HYTHpuntos)#</cfif>"  size="5" maxlength="5" onFocus="javascript:this.select();" style="text-transform:uppercase;  border:none;"></td>
		</tr>
		<tr>
			<td nowrap align="right"><strong>Restringido: &nbsp;</strong></td>
			<td nowrap>
				<select id="HYTHrestrict" name="HYTHrestrict" >
					<option value="1" <cfif isdefined("data") and data.HYTHrestrict EQ 1 >selected</cfif>>Habilitar</option>
					<option value="0" <cfif isdefined("data") and data.HYTHrestrict EQ 0 >selected</cfif>>Restringir</option>
				</select>
				<input name="HYTHid" type="hidden" value="<cfif isdefined("data")>#data.HYTHid#</cfif>">
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
		objForm.HYTHid.required = true;
		objForm.HYTHid.description="Código";
	</cfif>

	

	function deshabilitarValidacion(){
		objForm.HYTHid.required = false;
	}

</script>
