<cfif isdefined("Form.PRJPACid") and Len(Trim(Form.PRJPACid))>
	<cfset modo="CAMBIO">
<cfelse>  
	<cfset modo="ALTA">
</cfif>

<cfif isdefined("Url.btnatras") 
  and isdefined("Url.PRJPAid") 
  and Len(Trim(Url.PRJPAid)) 
  and isdefined("Url.PRJPACid") 
  and Len(Trim(Url.PRJPACid))   
  and isdefined("Url.PRJPOid") 
  and Len(Trim(Url.PRJPOid))
  and Url.btnatras eq 1>
	<cfset modo="CAMBIO">
	<cfset Form.PRJPAid=Url.PRJPAid>
	<cfset Form.PRJPOid=Url.PRJPOid>
	<cfset Form.PRJPACid=Url.PRJPACid>
</cfif>	

<cfif modo EQ 'CAMBIO'>

	<cfquery name="rsObras" datasource="#Session.DSN#">
		select a.PRJPAid,    	    b.PRJPACid, a.PRJPAcodigo, a.PRJPAdescripcion, 
			   b.PRJPACcodigo,      b.PRJPACdescripcion, b.ts_rversion
		from PRJPobraArea a, PRJPobraActividad b
		where a.PRJPAid = b.PRJPAid
		  and a.Ecodigo = b.Ecodigo
		  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and a.PRJPAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PRJPAid#">
		  and b.PRJPACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PRJPACid#">
	</cfquery>

</cfif>

<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script type="text/javascript">
function validar(f){
		
	if (f.PRJPACcodigo.value.match(/^\s*$/))
	{
		alert("Digite el codigo de la actividad");
		f.PRJPACcodigo.focus();
		return false;
	}
	if (f.PRJPACdescripcion.value.match(/^\s*$/))
	{
		alert("Digite la descripcion de la Actividad");
		f.PRJPACdescripcion.focus();
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
  	<td colspan="2" align="center"><strong><font size="2">Mantenimiento de Actividades</font><strong></td>
  </tr>
  <tr><td class="topline" colspan="2">&nbsp;</td></tr>
  <tr>
	<td valign="top" width="40%">
	  <cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaRH"
		 returnvariable="pListaRet">
		  <cfinvokeargument name="tabla" value="PRJPobraArea a, PRJPobraActividad b"/>
		  <cfinvokeargument name="columnas" value="a.PRJPOid, b.PRJPACid, b.PRJPACcodigo, b.PRJPACdescripcion"/>
		  <cfinvokeargument name="desplegar" value="PRJPACcodigo, PRJPACdescripcion"/>
		  <cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n"/>
		  <cfinvokeargument name="formatos" value="V, V"/>
		  <cfinvokeargument name="filtro" value="a.PRJPAid = b.PRJPAid
 									   		     and a.Ecodigo = b.Ecodigo
		                                         and a.Ecodigo = #Session.Ecodigo#
												 and a.PRJPAid = #Form.PRJPAid#
		  										 order by PRJPACcodigo, PRJPACdescripcion"/>
		  <cfinvokeargument name="align" value="left, left"/>
		  <cfinvokeargument name="ajustar" value="N"/>
		  <cfinvokeargument name="checkboxes" value="N"/>
		  <cfinvokeargument name="keys" value="PRJPACid"/>
		  <cfinvokeargument name="irA" value="PRJPobraActividad.cfm?PRJPOid=#Form.PRJPOid#&PRJPAid=#Form.PRJPAid#"/>
	  </cfinvoke>
	</td>
	<td valign="top" width="60%">
		<cfoutput>
		<form method="post" action="PRJPobraActividad-sql.cfm" name="form1" id="form1" onSubmit="return validar(this);">
		  <input type="hidden" name="PRJPOid" value="#Form.PRJPOid#">
			<input type="hidden" name="PRJPAid" value="#Form.PRJPAid#">		  
		  <cfif modo EQ "CAMBIO">		  	
			<input type="hidden" name="PRJPACid" value="#Form.PRJPACid#">
		  </cfif>
		  <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
			<tr>
			  <td align="right" nowrap>C&oacute;digo:</td>
			  <td>
			  	 <input name="PRJPACcodigo" type="text" id="PRJPACcodigo" size="20" maxlength="10" value="<cfif modo EQ 'CAMBIO'>#rsObras.PRJPACcodigo#</cfif>">
			  </td>
			</tr>
			<tr>
              <td align="right" nowrap>Descripci&oacute;n:</td>
              <td>
			  	<input name="PRJPACdescripcion" type="text" id="PRJPACdescripcion" size="40" maxlength="80" value="<cfif modo EQ 'CAMBIO'>#rsObras.PRJPACdescripcion#</cfif>">
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
					<input type="button" name="detalle" value="Productos por Actividad" onClick="location.href='PRJPobraProducto.cfm?PRJPAid=#HTMLEditFormat(form.PRJPAid)#&PRJPOid=#HTMLEditFormat(form.PRJPOid)#&PRJPACid=#HTMLEditFormat(form.PRJPACid)#'">
				</cfif>				
			  </td>
			</tr>
		  </table>
		</form>
		</cfoutput>
	</td>
  </tr>
</table> 
