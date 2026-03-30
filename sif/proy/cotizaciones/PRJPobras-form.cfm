<cfif isdefined("Form.PRJPOid") and Len(Trim(Form.PRJPOid))>	
	<cfset modo="CAMBIO">
<cfelse>  
	<cfset modo="ALTA">
</cfif>

<cfif isdefined("Url.btnatras") and isdefined("Url.PRJPOid") and Len(Trim(Url.PRJPOid)) and Url.btnatras eq 1>
	<cfset modo="CAMBIO">
	<cfset Form.PRJPOid=Url.PRJPOid>
</cfif>	

<cfif modo EQ 'CAMBIO'>
	<cfquery name="rsObras" datasource="#Session.DSN#">
		select a.PRJPOid,    a.PRJPOcodigo, a.PRJPOdescripcion, a.PRJPOcliente, 
		       a.PRJPOlugar, a.PRJPOnumero, a.ts_rversion
		from PRJPobra a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.PRJPOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PRJPOid#">
	</cfquery>	
</cfif>

<script src="/cfmx/sif/js/qForms/qforms.js"></script>

<style type="text/css">
	.color{
		color:#FF0000;
	}
	.topline {
		border-top-width: 1px;
		border-top-style: solid;
		border-right-style: none;
		border-bottom-style: none;
		border-left-style: none;
		border-top-color: #CCCCCC;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
</style>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr><td class="topline" colspan="2">&nbsp;</td></tr>
  <tr class="topline">
  	<td colspan="2" align="center"><strong><font size="2">Mantenimiento de Obras</font><strong></td>
  </tr>
  <tr><td class="topline" colspan="2">&nbsp;</td></tr>
  <tr>
	<td valign="top" width="40%">
	  <cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaRH"
		 returnvariable="pListaRet">
		  <cfinvokeargument name="tabla" value="PRJPobra"/>
		  <cfinvokeargument name="columnas" value="PRJPOid, PRJPOcliente, PRJPOcodigo, PRJPOdescripcion, PRJPOlugar, PRJPOnumero"/>
		  <cfinvokeargument name="desplegar" value="PRJPOcodigo, PRJPOdescripcion, PRJPOcliente"/>
		  <cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n, Cliente"/>
		  <cfinvokeargument name="formatos" value="V, V, V"/>
		  <cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo#
		  										 order by PRJPOcodigo, PRJPOdescripcion"/>
		  <cfinvokeargument name="align" value="left, left, left"/>
		  <cfinvokeargument name="ajustar" value="N"/>
		  <cfinvokeargument name="checkboxes" value="N"/>
		  <cfinvokeargument name="keys" value="PRJPOid"/>
		  <cfinvokeargument name="irA" value="PRJPobras.cfm"/>
	  </cfinvoke>
	</td>
	<td valign="top" width="60%">
		<cfoutput>
		<form method="post" name="form1" action="PRJPobras-sql.cfm">
		  <cfif modo EQ "CAMBIO">
		  	<input type="hidden" name="PRJPOid" value="#Form.PRJPOid#">
		  </cfif>
		  <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
			<tr>
			  <td align="right" nowrap>C&oacute;digo:</td>
			  <td>
			  	 <input name="PRJPOcodigo" type="text" id="PRJPOcodigo" size="20" maxlength="10" value="<cfif modo EQ 'CAMBIO'>#rsObras.PRJPOcodigo#</cfif>">
			  </td>
			</tr>
			<tr>
			  <td align="right" nowrap>Cliente:</td>
			  <td>
				<input name="PRJPOcliente" type="text" id="PRJPOcliente" size="40" maxlength="80" value="<cfif modo EQ 'CAMBIO'>#rsObras.PRJPOcliente#</cfif>">
			  </td>
		    </tr>			
			<tr>
              <td align="right" nowrap>Descripci&oacute;n:</td>
              <td>
			  	<input name="PRJPOdescripcion" type="text" id="PRJPOdescripcion" size="40" maxlength="80" value="<cfif modo EQ 'CAMBIO'>#rsObras.PRJPOdescripcion#</cfif>">
			  </td>
		    </tr>
			<tr>
              <td align="right" nowrap>Lugar:</td>
              <td>
			  	<input name="PRJPOlugar" type="text" id="PRJPOlugar" size="40" maxlength="80" value="<cfif modo EQ 'CAMBIO'>#rsObras.PRJPOlugar#</cfif>">
			  </td>
		    </tr>
			<tr>
              <td align="right" nowrap>N&uacute;mero de Presupuesto:</td>
              <td>
			  	<input name="PRJPOnumero" type="text" id="PRJPOnumero" size="20" maxlength="20" value="<cfif modo EQ 'CAMBIO'>#rsObras.PRJPOnumero#</cfif>">
			  </td>
		    </tr>						
			<tr>
			  <td align="right" nowrap>&nbsp;</td>
			  <td>&nbsp;</td>
		    </tr>
			<tr>
			  <td colspan="2" align="center" nowrap>
				<cfset ts = "">
				<cfif modo NEQ "ALTA">
				  <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" arTimeStamp="#rsObras.ts_rversion#" returnvariable="ts">
				  </cfinvoke>
				</cfif>
				<input type="hidden" name="ts_rversion" value="<cfif modo EQ "CAMBIO"><cfoutput>#ts#</cfoutput></cfif>">
			  	<cfinclude template="/sif/portlets/pBotones.cfm">
				<cfif modo neq 'ALTA'>
					<input type="button" name="detalle" value="Areas" onClick="location.href='PRJPobraArea.cfm?PRJPOid=#HTMLEditFormat(form.PRJPOid)#'">
				</cfif>				
			  </td>
			</tr>
		  </table>
		</form>
		</cfoutput>
	</td>
  </tr>
</table> 

<script language="JavaScript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	
	objForm.PRJPOcodigo.required = true;
	objForm.PRJPOcodigo.description = "Codigo";
	objForm.PRJPOdescripcion.required = true;
	objForm.PRJPOdescripcion.description = "Descripcion";
	objForm.PRJPOcliente.required = true;
	objForm.PRJPOcliente.description = "Cliente";	
	objForm.PRJPOlugar.required = true;
	objForm.PRJPOlugar.description = "Lugar";
	objForm.PRJPOnumero.required = true;
	objForm.PRJPOnumero.description = "Numero";
</script>

