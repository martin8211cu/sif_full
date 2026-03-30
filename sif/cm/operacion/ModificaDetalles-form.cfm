<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_NoDetalle" default="No existen Detalles para la Orden de Compra" returnvariable="MSG_NoDetalle" xmlfile="ModificaDetalles-form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Linea" default="Linea" returnvariable="LB_Linea" xmlfile="ModificaDetalles-form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Tipo" default="Tipo" returnvariable="LB_Tipo" xmlfile="ModificaDetalles-form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Codigo" default="Codigo" returnvariable="LB_Codigo" xmlfile="ModificaDetalles-form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Descripcion" default="Descripcion" returnvariable="LB_Descripcion" xmlfile="ModificaDetalles-form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Unidad" default="Unidad de Medida" returnvariable="LB_Unidad" xmlfile="ModificaDetalles-form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Cantidad" default="Cantidad" returnvariable="LB_Cantidad" xmlfile="ModificaDetalles-form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_PrecioU" default="Precio Unitario" returnvariable="LB_PrecioU" xmlfile="ModificaDetalles-form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Descuento" default="Descuento" returnvariable="LB_Descuento" xmlfile="ModificaDetalles-form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Impuesto" default="Impuesto" returnvariable="LB_Impuesto" xmlfile="ModificaDetalles-form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Titulo" default="Modificar Detalles de Orden de compra" returnvariable="LB_Titulo" xmlfile="ModificaDetalles-form.xml"/>


<!---Javascript Incial--->
<script language="JavaScript" src="/cfmx/sif/js/utilesMonto.js" type="text/javascript"></script>

<cf_templateheader title="#LB_Titulo#">
	<cfinclude template="../../portlets/pNavegacionCM.cfm">
    <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>
    
        <cfif not isdefined("form.EOidorden")>
            <cfabort showerror="No se ha indicado la Orden de Compra">
        </cfif>
            <cfquery name="rsLinea" datasource="#Session.DSN#">
                select a.DOlinea,a.EOidorden,a.EOnumero,a.DOconsecutivo,
                    a.CMtipo,a.Cid,a.Aid,a.Alm_Aid,a.ACcodigo,			<!---Id de la linea de Orden de Compra --->
                    a.ACid,a.CFid,a.Icodigo,a.Ucodigo,					<!---Id de la linea de Orden de Compra --->
                    a.DOdescripcion,a.DOobservaciones, b.Idescripcion,	<!---Descripciones y Observaciones --->
                    a.DOcantidad, a.DOcantsurtida, a.DOpreciou,			<!--- Montos y Cantidades--->
                    DOmontodesc, DOporcdesc 							<!--- Montos y Cantidades--->
                    ,f.Acodigo,f.Adescripcion 						 	<!---Campos de Artículos--------->
                    ,g.Ccodigo,g.Cdescripcion 						 	<!---Campos de Conceptos--------->
                    ,c.CFcodigo,c.CFdescripcion 					 	<!---Campos de CentroFuncional---> 
                    ,case a.CMtipo 
                    when 'S' then convert(varchar,g.Ccodigo)
                    when 'A' then convert(varchar,f.Acodigo)
                    when 'F' then convert(varchar,a.ACcodigo)
                    else 'N/A' end as CMCodigoD
                from DOrdenCM a
                    left outer join EOrdenCM eo
                        on eo.Ecodigo = a.Ecodigo and eo.EOidorden = a.EOidorden
                    left outer join Impuestos b
                        on b.Ecodigo = a.Ecodigo and b.Icodigo = a.Icodigo
                    left outer join CFuncional c
                        on c.Ecodigo = a.Ecodigo and c.CFid = a.CFid
                    left outer join Unidades d
                        on d.Ecodigo = a.Ecodigo and d.Ucodigo = a.Ucodigo
                    left outer join Almacen e
                        on e.Aid = a.Alm_Aid
                    left outer join Articulos f
                        on f.Aid = a.Aid
                    left outer join Conceptos g
                        on g.Cid = a.Cid
                where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                  and a.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
            </cfquery>
        <form name="FDetalles" action="ordenCompra.cfm">
        	<cfoutput>
        	<input type="hidden" name="EOidorden" id="EOidorden" value="#form.EOidorden#">
            </cfoutput>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr class="subTitulo" bgcolor="#F2F2F2">
                    <td align="left" width="5%">
                        <strong><cfoutput>#LB_Linea#</cfoutput></strong>
                    </td>
                    <td align="left" width="10%">
                        <strong><cfoutput>#LB_Tipo#</cfoutput></strong>
                    </td>
                    <td align="left" width="15%">
                        <strong><cfoutput>#LB_Codigo#</cfoutput></strong>
                    </td>
                    <td align="left" width="20%">
                        <strong><cfoutput>#LB_Descripcion#</cfoutput></strong>
                    </td>
                    <td align="right" width="10%">
                        <strong><cfoutput>#LB_Unidad#</cfoutput></strong>
                    </td>
                    <td align="right" width="15%">
                        <strong><cfoutput>#LB_Cantidad#</cfoutput></strong>
                    </td>
                    <td align="right" width="15%">
                        <strong><cfoutput>#LB_PrecioU#</cfoutput></strong>
                    </td>
                    <td align="right" width="10%">
                        <strong><cfoutput>#LB_Descuento#</cfoutput></strong>
                    </td>
                    <td align="right" width="10%">
                        <strong><cfoutput>#LB_Impuesto#</cfoutput></strong>
                    </td>
                </tr>
                <cfif rsLinea.recordcount GT 0>
                    <cfoutput query="rsLinea">
                    	<input type="hidden" name="Linea" id="Linea" value="#DOlinea#">
                        <tr>
                            <td align="left" width="5%">
                                <label>#DOconsecutivo#</label>
                            </td>
                            <td align="left" width="10%">
                                 <label>#CMtipo#</label>
                            </td>
                            <td align="left" width="15%">
                                <label>#CMcodigoD#</label>
                            </td>
                            <td align="left" width="20%">
                                <label>#DOdescripcion#</label>
                            </td>
                            <td align="right" width="10%">
                                <label>#Ucodigo#</label>
                            </td>
                            <td align="right" width="15%">
                            	<input name="Cantidad" onFocus="javascript:this.select();" type="text" style="text-align:right" onBlur="javascript:fm(this,2,0);" onKeyUp="if(snumber(this,event,2,true,0)){ if(Key(event)=='13') {this.blur();}}" value="#DOcantidad#" size="18" maxlength="18">
                            </td>
                            <td align="right" width="15%">
                                <input name="PrecioU" onFocus="javascript:this.select();" type="text" style="text-align:right" onBlur="javascript:fm(this,2,0);" onKeyUp="if(snumber(this,event,2,true,0)){ if(Key(event)=='13') {this.blur();}}" value="#DOprecioU#" size="18" maxlength="18">
                            </td>
                            <td align="right" width="15%">
                                <input name="Descuento" id="Descuento" onFocus="javascript:this.select();" type="text" style="text-align:right" onBlur="javascript:fm(this,4,0);" onKeyUp="if(snumber(this,event,2,true,0)){ if(Key(event)=='13') {this.blur();}}" value="#DOmontodesc#" size="18" maxlength="18">
                            </td>
                            <cfquery name="rsImpuesto" datasource="#session.dsn#">
                            	select Icodigo, Idescripcion
                                from Impuestos 
                                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                            </cfquery>
                            <td align="right" width="10%">
                                <select name="Impuesto">
                                	<cfloop query="rsImpuesto">
                                    	<option value="#trim(rsImpuesto.Icodigo)#" <cfif rsLinea.Icodigo EQ rsImpuesto.Icodigo>selected</cfif>>#rsImpuesto.Idescripcion#</option>
                                    </cfloop>
                                </select>
                            </td>
                        </tr>
                    </cfoutput>
                    <tr>
                        <td colspan="9" align="center">&nbsp;
                            
                        </td>
                    </tr>
                    <tr>
                    	<td colspan="9" align="center">
                            <input type="submit" name="btnGuardar" value="Guardar" onClick="javascript:FDetalles.action='ModificaDetalles-sql.cfm';submit();">
                            <input type="submit" name="btnRegresar" value="Regresar" onClick="javascript:FDetalles.action='ordenCompra.cfm';submit();">
                        </td>
                    </tr>
                <cfelse>   
                    <cfoutput>
                        <tr>
                            <td colspan="9" align="center">
                                <strong>-- #MSG_NoDetalle# --</strong>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="9" align="center">&nbsp;
                                
                            </td>
                        </tr>
                        <tr>
                            <td colspan="9" align="center">
                                <input type="submit" name="btnRegresar" value="Regresar">
                            </td>
                        </tr>
                    </cfoutput>
                </cfif>
            </table>
        </form>
	<cf_web_portlet_end>
<cf_templatefooter>
<script language="javascript" type="text/javascript">
function Guardar () {
	alert(document.getElementById("Descuento").value);
}
</script>