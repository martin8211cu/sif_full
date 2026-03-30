<cfif isdefined("Form.PRJPPid") and Len(Trim(Form.PRJPPid))>
	<cfset modo="CAMBIO">
<cfelse>  
	<cfset modo="ALTA">
</cfif>

<cfif modo EQ 'CAMBIO'>

	<cfquery name="rsProductos" datasource="#Session.DSN#">
		<!--- 
		select a.PRJPAid,    	    b.PRJPACid, a.PRJPACcodigo, a.PRJPACdescripcion, 
			   b.PRJPPcantidad,     b.PRJPPid as PRJPPid1,      b.ts_rversion
		from PRJPobraActividad a, PRJPobraProducto b
		where a.PRJPACid = b.PRJPACid
		  and a.Ecodigo = b.Ecodigo
		  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and a.PRJPACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PRJPACid#">
  		  and b.PRJPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PRJPPid#"> --->

		select a.PRJPAid,    	    b.PRJPACid, a.PRJPACcodigo, a.PRJPACdescripcion, 
			   b.PRJPPcantidad,     b.PRJPPid as PRJPPid1,      b.ts_rversion,
			   c.PRJPPcodigo, 		c.PRJPPdescripcion, 	    b.PRJPPcantidad,
			   (c.PRJPPcostoDirecto * (c.PRJPPporcentajeIndirecto/100)) as Cindirecto,
			   ((c.PRJPPcostoDirecto * (c.PRJPPporcentajeIndirecto/100)) + c.PRJPPcostoDirecto) as Punit,
			   (((c.PRJPPcostoDirecto * (c.PRJPPporcentajeIndirecto/100)) + c.PRJPPcostoDirecto) * b.PRJPPcantidad) as Importe			   
		from PRJPobraActividad a, PRJPobraProducto b, PRJPproducto c
		 where a.PRJPACid = b.PRJPACid
	     and a.Ecodigo = b.Ecodigo
		 and b.PRJPPid = c.PRJPPid
		 and b.Ecodigo = c.Ecodigo
         and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		 and b.PRJPACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PRJPACid#">
		 and b.PRJPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PRJPPid#">
		 order by c.PRJPPcodigo, c.PRJPPdescripcion
	</cfquery>

</cfif>

<!--- <script src="/cfmx/sif/js/qForms/qforms.js"></script> --->
<script type="text/javascript" src="/cfmx/sif/js/utilesMonto.js">//</script>
<script type="text/javascript">
function validar(f)
{
	if (f.PRJPPid1.value.match(/^\s*$/) || isNaN(parseFloat(f.PRJPPid1.value)))
	{
		alert("Es necesario seleccionar un producto");		
		return false;
	}
	if (f.PRJPPcantidad.value.match(/^\s*$/) || isNaN(parseFloat(f.PRJPPcantidad.value)) || f.PRJPPcantidad.value < 1)
	{
		alert("Digite una cantidad valida");
		f.PRJPPcantidad.focus();	
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
  	<td colspan="2" align="center"><strong><font size="2">Mantenimiento de Productos</font><strong></td>
  </tr>
  <tr><td class="topline" colspan="2">&nbsp;</td></tr>
  <tr>
	<td valign="top" width="40%">		
	  <cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaRH"
		 returnvariable="pListaRet">
		  <cfinvokeargument name="tabla" value="PRJPobraActividad a, PRJPobraProducto b, PRJPproducto c"/>
		  <cfinvokeargument name="columnas" value="a.PRJPAid, b.PRJPACid, b.PRJPPid, b.PRJPPcantidad, c.PRJPPcodigo, c.PRJPPdescripcion,
										  	    (c.PRJPPcostoDirecto * (c.PRJPPporcentajeIndirecto/100)) as Cindirecto,
											    ((c.PRJPPcostoDirecto * (c.PRJPPporcentajeIndirecto/100)) + c.PRJPPcostoDirecto) as Punit,
											    (((c.PRJPPcostoDirecto * (c.PRJPPporcentajeIndirecto/100)) + c.PRJPPcostoDirecto) * b.PRJPPcantidad) as Importe"/>
		  <cfinvokeargument name="desplegar" value="PRJPPcodigo, PRJPPdescripcion, PRJPPcantidad, Punit, Importe"/>
		  <cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n, Cantidad, P. Unitario, Importe"/>
		  <cfinvokeargument name="formatos" value="V, V, V, M, M"/>
		  <cfinvokeargument name="filtro" value="a.PRJPACid = b.PRJPACid
										  	     and a.Ecodigo = b.Ecodigo
												 and b.PRJPPid = c.PRJPPid
												 and b.Ecodigo = c.Ecodigo
		                                         and a.Ecodigo = #Session.Ecodigo#
												 and a.PRJPACid = #Form.PRJPACid#
		  										 order by c.PRJPPcodigo, c.PRJPPdescripcion"/>
		  <cfinvokeargument name="align" value="left, left, rigth, rigth, rigth"/>
		  <cfinvokeargument name="ajustar" value="N"/>
		  <cfinvokeargument name="checkboxes" value="N"/>
		  <cfinvokeargument name="keys" value="PRJPPid"/>
		  <cfinvokeargument name="irA" value="PRJPobraProducto.cfm?PRJPOid=#Form.PRJPOid#&PRJPAid=#Form.PRJPAid#&PRJPACid=#Form.PRJPACid#"/>	  
	  </cfinvoke>

	</td>
	<td valign="top" width="60%">
		<cfoutput>
		  <form method="post" action="PRJPobraProducto-sql.cfm" name="form1" id="form1" onSubmit="javascript:validar(this);">
		  <input type="hidden" name="PRJPOid" value="#Form.PRJPOid#">
  		  <input type="hidden" name="PRJPAid" value="#Form.PRJPAid#">		  
		  <input type="hidden" name="PRJPACid" value="#Form.PRJPACid#">		  
		  <cfif modo EQ "CAMBIO">		  	
			<input type="hidden" name="PRJPPid" value="#Form.PRJPPid#">
		  </cfif>
		  <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
			<tr>
			  <td align="right" nowrap>Producto:</td>
			  <td>
					<cfif (modo neq 'ALTA')>
						<cf_sifproductos form="form1" id="PRJPPid1" query="#rsProductos#" tabindex="2">
					<cfelse>
						<cf_sifproductos form="form1" id="PRJPPid1" tabindex="2">
					</cfif>			
			  </td>
			</tr>
			<tr>
              <td align="right" nowrap>Cantidad:</td>
              <td>
			  	<input name="PRJPPcantidad" tabindex="3" type="text" class="numerico" id="PRJPPcantidad" onFocus="this.select()" value="<cfif modo EQ 'CAMBIO'>#rsProductos.PRJPPcantidad#<cfelse>0</cfif>" size="10" maxlength="4" onBlur="formatCurrency(this,2);" onkeyup="javascript:if(snumber(this,event,5)){ if(Key(event)=='13') {this.blur();}}" tabindex="2">
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
				  <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" arTimeStamp="#rsProductos.ts_rversion#" returnvariable="ts">
				  </cfinvoke>
				</cfif>
				<input type="hidden" name="ts_rversion" value="<cfif modo EQ "CAMBIO"><cfoutput>#ts#</cfoutput></cfif>">
			  	<cfinclude template="/sif/portlets/pBotones.cfm">
			  </td>
			</tr>
		  </table>
		</form>
		</cfoutput>
	</td>
  </tr>
</table> 
