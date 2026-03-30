<cfif isdefined("Form.Pcodigo") and len(trim(form.Pcodigo)) NEQ 0>
	<cfset modo="CAMBIO">
<cfelse>
	<cfset modo="ALTA">
</cfif>

<cfif isDefined("Form.Pcodigo") and len(trim(#Form.Pcodigo#)) NEQ 0>
	<cfquery name="rsParametros" datasource="sifinterfaces" >
    	select Ecodigo,SIScodigo,Sucursal,Criterio,Pcodigo,Pvalor,Pdescripcion
		from SIFLD_Parametros
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        	and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Pcodigo#">
        <cfif isdefined("Form.SIScodigo") and len(trim(form.SIScodigo)) NEQ 0>
        	and SIScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SIScodigo#">
        <cfelse>
        	and SIScodigo = '0'
        </cfif>
		<cfif isdefined("Form.Sucursal") and len(trim(form.Sucursal)) NEQ 0>
        	and Sucursal = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Sucursal#">
        <cfelse>
        	and Sucursal = '0'
        </cfif>
        <cfif isdefined("Form.Criterio") and len(trim(form.Criterio)) NEQ 0>
        	and Criterio = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Criterio#">
        <cfelse>
        	and Criterio = '0'
        </cfif>
	</cfquery>
</cfif>

<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js">//</script>

<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfoutput>
<form action="SQLParametros.cfm" method="post" name="form1" onSubmit="javascript: return true;" >
	<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">	
	<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">	

	<table width="67%" height="75%" align="center" cellpadding="2" cellspacing="0">
 
     	<tr> 
			<td align="right" nowrap>Par&aacute;metro:&nbsp;</td>
			<td>
    	  		<cfif modo neq 'ALTA'>
                	<input name="Pcodigo" type="hidden" value="#rsParametros.Pcodigo#" />
                    #rsParametros.Pcodigo#
                <cfelse>
                	<input name="Pcodigo" tabindex="1" type="text"  value="" size="35"  alt="Parametro" required="true" maxlength="4" onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">
                </cfif>
      		</td>
		</tr>
        
        <tr> 
			<td align="right" nowrap>Sistema:&nbsp;</td>
			<td>
    	  	<cfif modo neq 'ALTA'>
				<cfloop query="SelSistema">
					<cfif modo neq 'ALTA' and trim(SelSistema.SIScodigo) eq trim(rsParametros.SIScodigo)>
						<input name="SIScodigo" type="hidden" value="#SelSistema.SIScodigo#" />
						#SelSistema.SISnombre#
					</cfif>
				</cfloop>
			<cfelse>
				<select name="SIScodigo" tabindex="2">
					<option value="">-Seleccione una opcion-</option>
					<cfloop query="SelSistema">
						<option value="#SelSistema.SIScodigo#" <cfif modo eq 'ALTA' and isdefined("form.SIScodigo") and trim(SelSistema.SIScodigo) eq trim(form.SIScodigo)>selected</cfif>>#SelSistema.SISnombre#</option>
					</cfloop>
				</select>
			</cfif>
      		</td>
		</tr>
        
		<tr> 
			<td align="right" nowrap>Sucursal:&nbsp;</td>
			<td>
		   		<cfif modo neq 'ALTA'>
                	<input name="Sucursal" type="hidden" value="#rsParametros.Sucursal#" />
                    #rsParametros.Sucursal#
                <cfelse>
                	<input name="Sucursal" tabindex="3" type="text"  value="" size="35" maxlength="15"  alt="Sucursal" required="false">
                </cfif>
     		</td>
		</tr>

		<tr> 
			<td align="right" nowrap>Criterio:&nbsp;</td>
			<td>
				<cfif modo neq 'ALTA'>
                	<input name="Criterio" type="hidden" value="#rsParametros.Criterio#" />
                    #rsParametros.Criterio#
                <cfelse>
                	<input name="Criterio" tabindex="4" type="text"  value="" size="35" maxlength="20"  alt="Criterio" required="false">
                </cfif>
			</td>
            <td>&nbsp;</td>
		</tr>

		<tr> 
			<td align="right" nowrap>Valor:&nbsp;</td>
			<td>
				<input name="Pvalor" tabindex="5" type="text"  value="<cfif modo neq "ALTA"><cfoutput>#rsParametros.Pvalor#</cfoutput></cfif>" size="35" maxlength="20"  alt="Valor" required="true">
            </td>
		</tr>

		<tr> 
			<td align="right" nowrap>Descripci&oacute;n:&nbsp;</td>
			<td>
		   		<input name="Pdescripcion" tabindex="6" type="text"  value="<cfif modo neq "ALTA"><cfoutput>#rsParametros.Pdescripcion#</cfoutput></cfif>" size="35" maxlength="100"  alt="Descripcion" required="false">
            </td>
            <td>&nbsp;</td>
		</tr>

		<!--- *************************************************** --->  

		<tr><td colspan="2">&nbsp;</td></tr>

		<tr> 
			<td colspan="2" align="center" nowrap>
				<cfif modo neq "ALTA">
					<cfset masbotones = "">
					<cfset masbotonesv = "">
				<cfelse>
					<cfset masbotones = "">
					<cfset masbotonesv = "">
				</cfif>
				<cf_botones modo="#modo#" tabindex="7">
			</td>
		</tr>
        <tr> 
			<td colspan="2" align="center" nowrap>&nbsp;
				
			</td>
		</tr>
        <tr> 
			<td colspan="2" align="center" nowrap>
				<cf_boton texto="Parametros Default" estilo="4" link="Parametros.cfm?Default=1">
			</td>
		</tr>
	</table>

 </form>
 </cfoutput>

<cf_qforms form="form1" objForm="objForm">
<script language="JavaScript" type="text/JavaScript">
	
	objForm.Pcodigo.required = true;
	objForm.Pcodigo.description="Codigo de Parámetro";
	
	objForm.Pvalor.required = true;
	objForm.Pvalor.description="Valor del Parámetro";
	
	<!---function funcAlta(){
		
		alert(objForm.EQUcodigoOrigen.required);
		return false;
		
	}--->
	
	function funcBaja(){
		
		if (!confirm('¿Desea Eliminar el Registro?') )
		{ return false;}
		else
		{ deshabilitarValidacion(); 
		  return true; }
	}
	
	function deshabilitarValidacion(){
		objForm.Pcodigo.required = false;
		objForm.Pvalor.required = false;		
	}
	
	<cfif modo NEQ "ALTA">
 		document.form.Pcodigo.focus();
	<cfelse>
		document.form.Pcodigo.focus();
 	</cfif> 
</script>
