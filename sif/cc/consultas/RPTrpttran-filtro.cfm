

<style type="text/css">
	.fileLabelSub {
		font-family: Verdana, Arial, Helvetica, sans-serif;
		font-style: normal;
		font-weight: bold;
		padding-right: 10px;
		border-color: black black #CCCCCC; 
		border-style: inset; 
		border-top-width: 0px; 
		border-right-width: 0px; 
		border-bottom-width: 1px; 
		border-left-width: 0px
	}
</style>

<cfquery name="rsPer" datasource="#Session.DSN#">
	select distinct Speriodo as Eperiodo
	from CGPeriodosProcesados
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by Speriodo desc
</cfquery>
<cfquery name="rsMeses" datasource="sifControl">
	select <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl"> as VSvalor, b.VSdesc 
	from Idiomas a, VSidioma b 
	where a.Icodigo = '#Session.Idioma#'
		and a.Iid = b.Iid
		and b.VSgrupo = 1
	order by <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl">
</cfquery>

<cfquery datasource="#Session.DSN#" name="rsget_val">
	select ltrim(rtrim(Pvalor)) as Pvalor 
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and Pcodigo = 30
</cfquery>
<cfset periodo="#rsget_val.Pvalor#">

<cfquery datasource="#Session.DSN#" name="rsget_val">
	select ltrim(rtrim(Pvalor)) as Pvalor 
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and Pcodigo = 40
</cfquery>
<cfset mes="#rsget_val.Pvalor#">

<form action="RPTrpttran-report.cfm" method="post" name="form1" style="margin:0;">
	<table width="100%" cellpadding="2" cellspacing="0" align="center">
		<tr>
			<td valign="top">
			<fieldset><legend>Datos del Reporte</legend>
				<table  width="100%" cellpadding="2" cellspacing="0" border="0">
					<tr>
						<td colspan="6">&nbsp;</td>
					</tr>
					<tr>
						<td width="4%">&nbsp;</td>
						<td width="16%" align="left" nowrap><strong>Per&iacute;odo&nbsp;</strong></td>
						<td width="16%" align="left" nowrap ><strong>Mes&nbsp;</strong></td>
						<td nowrap align="left" ><strong>Moneda&nbsp;</strong></td>
						<td width="46%" colspan="2">&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						
						
						
						<td>
                          <select name="Speriodo" tabindex="1">
                            <cfoutput query="rsPer">
                              <option value="#Eperiodo#" <cfif isdefined("periodo") and periodo eq Eperiodo>selected</cfif>>#Eperiodo#</option>
                            </cfoutput>
                          </select>
                        </td>
						<td>
                          <select name="Smes" tabindex="1">
                           <cfoutput query="rsMeses">
                              <option value="#VSvalor#"<cfif  isdefined("mes") and  mes eq VSvalor>selected</cfif>>#VSdesc#</option>
                            </cfoutput>
                          </select>
                        </td>
						
						<td><cf_sifmonedas tabindex="1"></td>
						<td colspan="2">&nbsp;</td>
					</tr>
					<tr><td colspan="5">&nbsp;</td></tr>
					<tr>
						<td>&nbsp;</td>
						<td colspan="3">
							<input name="Clasif" id="Clasif1" type="radio" value="0" checked tabindex="1">
							<label for="Clasif1" style="font-style:normal; font-variant:normal;">Clasificaci&oacute;n General</label>
						</td>
						<td>&nbsp;</td>
					</tr>
					<tr><td colspan="5">&nbsp;</td></tr>
					<tr>
						<td>&nbsp;</td>
						<td nowrap colspan="2" align="left"><strong>Clasificaci&oacute;n&nbsp;</strong></td>
						<td colspan="3">&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td align="left" colspan="2" nowrap><cf_sifSNClasificacion form="form1" tabindex="1"></td>
						<td colspan="3">&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td colspan="2"><strong>Valor&nbsp;Clasificaci&oacute;n&nbsp;desde&nbsp;</strong></td>
						<td width="18%"><strong>Valor&nbsp;Clasificaci&oacute;n&nbsp;hasta&nbsp;</strong></td>
						<td colspan="2">&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td colspan="2" nowrap><cf_sifSNClasfValores SNCEid ="1" form="form1" id="SNCDid1" name="SNCDvalor1" desc="SNCDdescripcion1" tabindex="1"></td>
	
						<td width="18%" nowrap><cf_sifSNClasfValores SNCEid ="1" form="form1" id="SNCDid2" name="SNCDvalor2" desc="SNCDdescripcion2" tabindex="1"></td>
						<td colspan="2">&nbsp;</td>
					</tr>
					<tr><td colspan="6">&nbsp;</td></tr>
					<tr>
						<td colspan="6">
						<cf_botones values="Generar" names="Generar" tabindex="1">
						</td>
					</tr>
			</table>
			  </fieldset>
			</td>	
		</tr>
	</table>

</form>
<cf_qforms>
<script language="javascript" type="text/javascript">
	<!--//
	objForm.Speriodo.description = "Periodo";
	objForm.Smes.description = "Mes";
	objForm.Mcodigo.description = "Moneda";
	objForm.SNCEid.description = "Clasificacion";
	objForm.SNCDid1.description = "Valor Inicial";
	objForm.SNCDid2.description = "Valor Final";
	
	
		objForm.Speriodo.required = true;
		objForm.Smes.required = true;
		objForm.Mcodigo.required = true;
		if (objForm.SNCEid.getValue()!=''){
			objForm.SNCDid1.required = true;
			objForm.SNCDid2.required = true;
		} else {
			objForm.SNCDid1.required = false;
			objForm.SNCDid2.required = false;
		}
	function funcGenerar(){}
	
	
	document.form1.Speriodo.focus();
	//-->
</script>

<!--- 
/*function funcChangeSperiodo(v){
		var c = objForm.Smes.obj;
		var n = 0;
		c.length=0;
		<cfoutput query="rSperiodos">
			if (v==#rSperiodos.Speriodo#){
				c.length=n+1;
				c.options[n].value='#rSperiodos.Smes#';
				c.options[n].text='#rSperiodos.Smes#';
				n++;
			}
		</cfoutput>
	}*/
	funcChangeSperiodo(objForm.Speriodo.obj.value)
 --->
