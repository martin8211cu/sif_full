<cfif isdefined('url.OTcodigo') and not isdefined("form.OTcodigo") >
	<cfset form.OTcodigo = url.OTcodigo>
</cfif> 
  
<cfif isdefined("form.OTcodigo") >
	<cfquery name="rsCuentas_por_Cobrar" datasource="#Session.DSN#">
        select p.OTcodigo,PTcantidad,PTPrecioUnit,a.Aid,a.Adescripcion,a.Ucodigo from Prod_Producto p
         inner join Articulos a on a.Ecodigo= p.Ecodigo and a.Aid=p.Artid 
        where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
        
		   and p.OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OTcodigo#">
           
    </cfquery>
</cfif> 

<cfquery name="rsCCTransacciones" datasource="#Session.DSN#">
	 select CCTcodigo, CCTdescripcion 
	 from CCTransacciones 
	 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
 		and CCTtipo = 'D'
		and CCTpago = 0
</cfquery>

<cfset Titulo = "Cuentas por Cobrar">
<cf_templateheader title="Cuentas_por_Cobrar">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#Titulo#">
<cfinclude template="../../../sif/portlets/pNavegacionAD.cfm">
<cfoutput>

	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
            <td width="19%"><cfinclude template="formCuentas_por_Cobrar.cfm"></td>
        </tr>
        <cfif isdefined("form.OTcodigo") and Len(Trim(Form.OTcodigo)) GT 0 >
        <tr height="50" valign="middle">
        	<td align="left"><b>Conceptos</b></td>
        <tr/>
        <tr>
        	<td>
            <form action="solicitudCuentaXCobrar-SQL.cfm" method="post" name="form2" >
            <input name="OTcodigo" type="hidden" value="#form.OTcodigo#"/>
            <input name="NumArt" type="hidden" value="#rsCuentas_por_Cobrar.recordCount#"/>
        	<table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td align="left"><b>Concepto:&nbsp;</b></td>
                    <td colspan="7">#rsProdOTDatos.OTdescripcion#</td>
                <tr/>
                <cfloop query="rsCuentas_por_Cobrar">
                 	<tr>
                        <td align="left"><p><b>Articulo:&nbsp;</b></p>
                        <input name="idArticulo#CurrentRow#" type="hidden" value="#rsCuentas_por_Cobrar.Aid#"/>
                        <input name="descArticulo#CurrentRow#" type="hidden" value="#rsCuentas_por_Cobrar.Adescripcion#"/>
                        </td>
                        <td align="left">#rsCuentas_por_Cobrar.Adescripcion# </td>
                        <td align="right"><b>Cantidad:&nbsp;</b> </td>
                        <td align="right">
                        <input name="PTcantidad#CurrentRow#" type="text" value="0" size="4" maxlength="5" 
                        onblur="javascript: return sumar();">
                        </td>
                        <td align="right"><b>Unidad de medida:</b>&nbsp;</td>     	
                        <td align="right">#rsCuentas_por_Cobrar.Ucodigo#</td>
                        <td align="right"><b>Precio unitario:</b>&nbsp;
                        <input  name="Precio#CurrentRow#" type="hidden" value="#rsCuentas_por_Cobrar.PTPrecioUnit#" />
                        </td>
                        <td align="right">#rsCuentas_por_Cobrar.PTPrecioUnit#</td>
                    </tr>
                    <cfset OTcod =#rsCuentas_por_Cobrar.OTcodigo#>
				</cfloop>   
                 
                <tr height="50">
                    <td colspan="6"></td>
                    <td align="right"><b>Importe Total:&nbsp;</b></td>
                    <td align="right" ><div id="Totalentrada">0.00</div></td>
				</tr>
          		<tr>
					<td align="left"><b>Fecha:&nbsp;</b></td>
					<cfset fecha = "01/01/#datepart('yyyy', Now())#">
                    <td><cf_sifcalendario name="fechaIni" value="#fecha#" tabindex="1" form="form2"></td>
                    <td colspan="2" align="right" nowrap><b>Tipo de Transacción :</b>&nbsp;</td>
                    <td colspan="4">
						<select name="CCTcodigo" tabindex="1">
						<option value="">Todos</option>
						<cfloop query="rsCCTransacciones">
							<option value="#Trim(CCTcodigo)#" <cfif isdefined('form.CCTcodigo') and rsCCTransacciones.CCTcodigo EQ TRIM(form.CCTcodigo)>selected</cfif>>#CCTdescripcion#</option>
						</cfloop>
						</select>
					</td>
        		</tr>
                <tr height="50">
                     <td align="left"><b>Observaciones</b></td>
                     <td colspan="8">#rsProdOTDatos.OTobservacion#</td>
                </tr>
                <tr>  
                	<td align="center" colspan="7"><input type="submit" name="Generar" value="Generar" onclick="javascript: return valida();"/></td>
                </tr>
            </table>
            </form>
        	</td>        
		</tr>
        </cfif>
	</table>	

        
<cfif isdefined("form.OTcodigo") and #rsCuentas_por_Cobrar.recordCount# GT 0>
	<script type="text/javascript">
    function sumar() {
   		var total = 0;
		<cfloop query="rsCuentas_por_Cobrar">
        	total += parseInt(document.getElementById('PTcantidad#CurrentRow#').value)* parseFloat(document.getElementById('Precio#CurrentRow#').value)
		</cfloop>
		document.getElementById('Totalentrada').innerHTML = total;
    }
	function valida() {
		var error = false;
		if ( document.getElementById('Totalentrada').innerHTML == 0.00 ){
			error = true;
			mensaje = " El Importe Total debe se mayor a cero";
		}
		if ( error ){
			alert(mensaje);
			return false;
		}else{
			return true;
		}
	}
    </script>
</cfif>


</cfoutput>
<cf_web_portlet_end>
<cf_templatefooter>
