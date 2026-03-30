<cfquery name="rsTransforma" datasource="#Session.DSN#">
	select ETid from ETransformacion 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and ETfechaProc is null
</cfquery>

<cfif isdefined("rsTransforma") and len(trim(rsTransforma.ETid)) NEQ 0 and not isdefined("form.ETid")> 
	<cfset form.ETid = rsTransforma.ETid>
</cfif>
	<cfif isdefined("url.ETid") and not isdefined("form.ETid")>
		<cfset form.ETid = url.ETid>
	</cfif>
	
		<cf_templatecss>
		<cfquery datasource="#Session.DSN#" name="rsConceptos">
			select c.Cid,
			c.Ecodigo, 
			c.Ccodigo, 
			c.Cdescripcion, 
			c.Ctipo, 
			gp.GPid , 
			gp.ETid  , 
			gp.Cid, 
			coalesce(gp.GPmonto,0) as GPmonto,
			gp.GPtipocambio, 
			gp.Mcodigo
			from Conceptos c 
				left join CPGastosProduccion gp
				on c.Cid = gp.Cid
			where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
			  and gp.ETid = <cfqueryparam value="#form.ETid#" cfsqltype="cf_sql_numeric">
			  and Ctipo = 'G'
		</cfquery>
		
		<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
		<script language="javascript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
		<script language="JavaScript1.2" type="text/javascript">
			<!--//
			// specify the path where the "/qforms/" subfolder is located
			qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
			// loads all default libraries
			qFormAPI.include("*");
			//-->
		</script>
		<form action="GastosProduccion-SQL.cfm" method="post" name="form1" onSubmit="javascript: qfthis();">
			<table width="1%" align="center"  border="0" cellspacing="0" cellpadding="0" >
				<cfoutput query="rsConceptos"> 
					<tr> 
						<td>&nbsp;</td>
					  <td valign="top" nowrap> 
							#rsConceptos.Cdescripcion#
						</td>
					  <td nowrap>&nbsp;&nbsp;&nbsp;</td>
					  <td valign="top">
							<input size="15"  
								maxlength="20" 
								type="text" 
								name="campo_#rsConceptos.Cid#" 
								id="campo_#rsConceptos.Cid#" 
								value="<cfif len(trim(rsConceptos.GPmonto)) NEQ 0>#LSCurrencyFormat(rsConceptos.GPmonto, 'none')#</cfif>"  
								style="text-align: right"  
								onfocus="this.value=qf(this); this.select();" 
								onblur="javascript: fm(this,2);"  
								onkeyup="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}">
						</td>
					</tr>
				</cfoutput>
				<tr>
					<td colspan="4" align="center">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="4" align="center">
						<input type="button" name="Anterior" value="<< Anterior" onClick="javascript: goPrevious(this.form);">
						<input  type="submit" name="btnGrabar" tabindex="5" value="Grabar"> 
						<input  type="submit" name="btnConsultar" value="Consultar">
						<input  type="button" name="Siguiente" value="Siguiente >>" onClick="javascript: goNext(this.form);">
						<input name="ETid" type="hidden" value="<cfif isdefined("form.ETid")><cfoutput>#form.ETid#</cfoutput></cfif>">
					</td>
				</tr>	
			</table>
		</form>
		<script language="JavaScript1.2" type="text/javascript">
			<!--//
			qFormAPI.errorColor = "#FFFFCC";
			objFormR = new qForm("form1");
			function _Field_isRango(low, high){var low=_param(arguments[0], 0, "number");
			var high=_param(arguments[1], 9999999, "number");
			var iValue=parseInt(qf(this.value));
			if(isNaN(iValue))iValue=0;
			if((low>iValue)||(high<iValue)){this.error="El campo "+this.description+" debe contener un valor entre "+low+" y "+high+".";
			}}
			_addValidator("isRango", _Field_isRango);
			<cfoutput query="rsConceptos">
			//validacion de campo numerico
			objFormR.campo_#rsConceptos.Cid#.description="#rsConceptos.Cdescripcion#";
			objFormR.campo_#rsConceptos.Cid#.validateRango('0','999999999');
			</cfoutput>
			function qfthis(){
			<cfoutput query="rsConceptos">
				objFormR.campo_#rsConceptos.Cid#.obj.value = qf(objFormR.campo_#rsConceptos.Cid#.getValue());
			</cfoutput>
			}
			//-->
		</script>