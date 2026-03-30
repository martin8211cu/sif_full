<cfif isdefined("Form.PRJPAid") and Len(Trim(Form.PRJPAid))>
	<cfset modo="CAMBIO">
<cfelse>  
	<cfset modo="ALTA">
</cfif>

<cfif isdefined("Url.btnatras") 
  and isdefined("Url.PRJPAid") 
  and Len(Trim(Url.PRJPAid)) 
  and isdefined("Url.PRJPOid") 
  and Len(Trim(Url.PRJPOid))
  and Url.btnatras eq 1>
	<cfset modo="CAMBIO">
	<cfset Form.PRJPAid=Url.PRJPAid>
	<cfset Form.PRJPOid=Url.PRJPOid>
</cfif>	

<cfif modo EQ 'CAMBIO'>
	<cfquery name="rsObras" datasource="#Session.DSN#">
		select a.PRJPOid,    a.PRJPOcodigo, a.PRJPOdescripcion, a.PRJPOcliente, 
		       a.PRJPOlugar, a.PRJPOnumero, b.PRJPAcodigo,      b.PRJPAdescripcion,
			   b.ts_rversion
		from PRJPobra a, PRJPobraArea b
		where a.PRJPOid = b.PRJPOid
		  and a.Ecodigo = b.Ecodigo
		  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and a.PRJPOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PRJPOid#">
		  and b.PRJPAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PRJPAid#">
	</cfquery>
</cfif>

<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script type="text/javascript">
function validar(f){
		
	if (f.PRJPAcodigo.value.match(/^\s*$/))
	{
		alert("Digite el codigo del area");
		f.PRJPAcodigo.focus();
		return false;
	}
	if (f.PRJPAdescripcion.value.match(/^\s*$/))
	{
		alert("Digite la descripcion del Area");
		f.PRJPAdescripcion.focus();
		return false;
	}

}
</script>
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
  <tr><td colspan="2">&nbsp;</td></tr>
  <tr class="topline">
  	<td colspan="2" align="center"><strong><font size="2">Mantenimiento de Areas</font><strong></td>
  </tr>
  <tr><td class="topline" colspan="2">&nbsp;</td></tr>
  <tr>
	<td valign="top" width="40%">
	  <cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaRH"
		 returnvariable="pListaRet">
		  <cfinvokeargument name="tabla" value="PRJPobraArea a , PRJPobra b"/>
		  <cfinvokeargument name="columnas" value="a.PRJPOid, a.PRJPAid, a.PRJPAcodigo, a.PRJPAdescripcion"/>
		  <cfinvokeargument name="desplegar" value="PRJPAcodigo, PRJPAdescripcion"/>
		  <cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n"/>
		  <cfinvokeargument name="formatos" value="V, V"/>
		  <cfinvokeargument name="filtro" value="a.PRJPOid = b.PRJPOid
 									   		     and a.Ecodigo = b.Ecodigo
		                                         and a.Ecodigo = #Session.Ecodigo#
												 and a.PRJPOid = #Form.PRJPOid#
		  										 order by PRJPAcodigo, PRJPAdescripcion"/>
		  <cfinvokeargument name="align" value="left, left"/>
		  <cfinvokeargument name="ajustar" value="N"/>
		  <cfinvokeargument name="checkboxes" value="N"/>
		  <cfinvokeargument name="keys" value="PRJPAid"/>
		  <cfinvokeargument name="irA" value="PRJPobraArea.cfm?PRJPOid=#Form.PRJPOid#"/>
	  </cfinvoke>
	</td>
	<td valign="top" width="60%">
		<cfoutput>
		<form method="post" action="PRJPobraArea-sql.cfm" name="form1" id="form1" onSubmit="return validar(this);">
		  <input type="hidden" name="PRJPOid" value="#Form.PRJPOid#">
		  <cfif modo EQ "CAMBIO">		  	
			<input type="hidden" name="PRJPAid" value="#Form.PRJPAid#">
		  </cfif>
		  <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
			<tr>
			  <td align="right" nowrap>C&oacute;digo:</td>
			  <td>
			  	 <input name="PRJPAcodigo" type="text" id="PRJPAcodigo" size="20" maxlength="10" value="<cfif modo EQ 'CAMBIO'>#rsObras.PRJPAcodigo#</cfif>">
			  </td>
			</tr>
			<tr>
              <td align="right" nowrap>Descripci&oacute;n:</td>
              <td>
			  	<input name="PRJPAdescripcion" type="text" id="PRJPAdescripcion" size="40" maxlength="80" value="<cfif modo EQ 'CAMBIO'>#rsObras.PRJPAdescripcion#</cfif>">
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
					<input type="button" name="detalle" value="Actividades" onClick="location.href='PRJPobraActividad.cfm?PRJPAid=#HTMLEditFormat(form.PRJPAid)#&PRJPOid=#HTMLEditFormat(form.PRJPOid)#'">
				</cfif>				
			  </td>
			</tr>
		  </table>
		</form>
		</cfoutput>
	</td>
  </tr>
</table> 
