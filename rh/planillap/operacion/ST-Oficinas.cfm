<cfif isdefined("url.RHEid") and len(trim(url.RHEid))>
	<cfset form.RHEid = url.RHEid>
</cfif>
<cf_templatecss>
<script type="text/javascript" language="javascript1.2">
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function funcPopUpImportar(){
		var params ="?RHEid="+window.parent.document.form1.RHEid.value+"&RHEfdesde="+window.parent.document.form1.RHEfdesde.value+"&RHEfhasta="+window.parent.document.form1.RHEfhasta.value;
		popUpWindow("/cfmx/rh/planillap/operacion/PopUp-importar.cfm"+params,260,200,500,400);		
	}	
</script>
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfif isdefined("form.RHEid") and len(trim(form.RHEid))>
	<cfquery name="rsTablas" datasource="#session.DSN#">
		select 	a.RHEid,
				a.RHETEid,
				a.RHETEdescripcion,
				b.RHTTcodigo #LvarCNCT#' - '#LvarCNCT#b.RHTTdescripcion as TipoTabla				
		from RHETablasEscenario a
			inner join RHTTablaSalarial b
				on a.Ecodigo = b.Ecodigo
				and a.RHTTid = b.RHTTid
		where a.Ecodigo =	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.RHEid = 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
	</cfquery>
</cfif>
<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">  
  <tr><td class="tituloListas" colspan="2">&nbsp;</td></tr>
  <tr>
	<td width="90%" class="tituloListas" >
		<strong style="color:#003366; font-family:'Times New Roman', Times, serif; font-size:13pt; font-variant:small-caps; font-weight:bolder;">Seleccione la Tabla Salarial</strong>	</td>
		<td width="10%" class="tituloListas"><input type="button" name="btn_importar" value="Importar" onclick="javascript: funcPopUpImportar();"></td>
  </tr>
  <tr>
	<td class="tituloListas">&nbsp;</td>
	<td class="tituloListas">&nbsp;</td>
  </tr>
  <tr>
	<td valign="top" colspan="2">
		<fieldset>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr class="titulocorte">
				<td width="1%">&nbsp;</td>
				<td width="20%" nowrap="nowrap"><strong>Tipo Tabla&nbsp;</strong></td>
				<td width="30%" nowrap><strong>Descripci&oacute;n&nbsp;</strong></td>
			</tr>
			<cfif  isdefined("rsTablas") and  rsTablas.RecordCount NEQ 0>
				<cfoutput query="rsTablas">
					<tr style="cursor:pointer;" onclick="javascript:window.parent.funcMuestraCategoria(#rsTablas.RHETEid#);">
						<td width="1%">&nbsp;</td>
						<td>#rsTablas.TipoTabla#</td>
						<td>#rsTablas.RHETEdescripcion#</td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr><td colspan="3" align="center"><strong>------  No hay tablas salariales asignadas al escenario ------</strong></td></tr>							
			</cfif>				
		</table>	
		</fieldset>	
	</td>
  </tr>
  <tr><td>&nbsp;</td></tr>
</table>
