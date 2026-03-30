<cfif isdefined("Form.OTcodigo") AND Len(Trim(Form.OTcodigo)) GT 0>
<!--- Establecimiento del modo --->
	<cfif isdefined("Form.Alta")>
        <cfset modoPT="ALTA">
    <cfelse>
        <cfif not isdefined("Form.modoPT")>
            <cfset modoPT="ALTA">
        <cfelseif Form.modoArt EQ "CAMBIO">
            <cfset modoPT="CAMBIO">
        <cfelse>
            <cfset modoPT="ALTA">
        </cfif>
    </cfif>

    <cfquery name="rsProdProducto" datasource="#session.DSN#">
        select p.Artid as listaProdTer_Artid,a.Aid as listaProdTer_Aid,a.Adescripcion as listaProdTer_Adescripcion,a.Acodigo as listaProdTer_Acodigo, 
        	a.UCodigo as listaProdTer_UCodigo, p.PTcantidad as listaProdTer_PTcantidad, p.PTprecioUnit as listaProdTer_PTprecioUnit, 
            p.ts_rversion as listaProdTer_ts_rversion
        from Prod_Producto p
        	inner join Articulos a on p.Ecodigo=a.Ecodigo and a.Aid=p.Artid
        where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            and OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OTcodigo#">
        order by p.Artid
    </cfquery>

    <cfset modoPT='ALTA'>    
	<cfif isdefined("form.listaProdTer_Acodigo") and len(trim(form.listaProdTer_Acodigo)) GT 0 and 
	isdefined("form.listaProdTer_Aid") and len(trim(form.listaProdTer_Aid)) GT 0>
        <cfset modoPT = 'CAMBIO'>
    </cfif>
    
	<cfif modoPT neq 'ALTA'>
        <cfquery name="rsProductoSel" datasource="#session.DSN#">
            select p.Artid, p.PTprecioUnit, p.PTcantidad, a.UCodigo, u.Udescripcion, p.ts_rversion 
            from Prod_Producto p
            inner join Articulos a on p.Ecodigo=a.Ecodigo and a.Aid=p.Artid
            inner join Unidades u on u.Ecodigo=a.Ecodigo and u.UCodigo=a.UCodigo
            where p.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                and p.OTcodigo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OTcodigo#">
                and p.Artid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.listaProdTer_Aid#">
            order by Artid
        </cfquery>
    </cfif>
    
<cfoutput>  
<form method="post" name="form3" action="SQLOrdenTr1.cfm" <cfif isdefined("form.OTcodigo")> onSubmit="javascript: return validaPT(this)" </cfif>>
   <input type="hidden" name="OTCodigo" value= "#Form.OTcodigo#" />
   <input name="tab" type="hidden" value="pt">
<table>	<tr> 
        <td class="tituloListas" colspan="6" align="center">Producto Terminado</td>
    </tr>
    <tr> 
        <td class="tituloListas" align="center">Art&iacute;culo</td>
        <td class="tituloListas" align="center">Precio Unitario</td>
        <td class="tituloListas" align="center">Cantidad</td>
        <td class="tituloListas" align="center">U/M</td>
    </tr>
    <tr>
        <td align="left" width="1%" nowrap>
			<cfif modoPT neq 'ALTA'>
                <cfquery name="rsArticulo" datasource="#session.DSN#">
                    select Aid as ProdTer_Aid, Acodigo as ProdTer_Acodigo, Adescripcion as ProdTer_Adescripcion
                    from Articulos
                    where Ecodigo= #Session.Ecodigo# 
                    and Aid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsProductoSel.Artid#">
                </cfquery>
                <cf_sifarticulos query=#rsArticulo# name="ProdTer_Acodigo" id="ProdTer_Aid" desc="ProdTer_Adescripcion" form="form3">
            <cfelse>
            	<cf_sifarticulos name="ProdTer_Acodigo" id="ProdTer_Aid" desc="ProdTer_Adescripcion" form="form3">
            </cfif>
        </td>
        <td align="left" width="1%" nowrap>
            <input type="text" name= "PT_PrecioU" size="18" maxlength="20" value= "<cfif modoPT neq 'ALTA'>#rsProductoSel.PTprecioUnit#</cfif>" onfocus="javascript:this.select();">
        </td>
        <td align="center" width="1%" nowrap>
            <input type="text" name= "PT_Cantidad" size="5" maxlength="6" value= "<cfif modoPT neq 'ALTA'>#rsProductoSel.PTcantidad#</cfif>" onfocus="javascript:this.select();">
        </td>
        <td align="center" width="1%" nowrap>
        	<cfif modoPT neq 'ALTA'>
        		#trim(rsProductoSel.Udescripcion)#
            </cfif>
<!---            <select name="PT_UnidadM" tabindex="1">
                <cfloop query="rsUnidades">
                	<option value="#rsUnidades.Ucodigo#" <cfif modoPT NEQ 'ALTA' and trim(rsProductoSel.UCodigo) EQ trim(rsUnidades.Ucodigo)>selected</cfif>>#rsUnidades.Udescripcion#</option>
                </cfloop>						
            </select>
--->        
		</td>
    </tr>
    <tr>
        <td colspan="5" align="right">
            <cfif modoPT neq 'ALTA'>
                <input type="submit" name="Modificar_Prod" value="Modificar" <!---onClick="javascript: return validaMP(this);"---> >
                <input type="submit" name="Eliminar_Prod" value="Eliminar">
            <cfelse>
            	<input type="submit" name="Aceptar_Prod" value="Agregar" <!--- onClick="javascript: return validaMP(this);"---> >
            </cfif>
        </td>
    </tr>
    <tr>
    	<td colspan="5">
        <cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
            <cfinvokeargument name="query" 		value="#rsProdProducto#"/>
            <cfinvokeargument name="desplegar" 	value="listaProdTer_Acodigo,listaProdTer_Adescripcion, listaProdTer_PTprecioUnit, 
            										   listaProdTer_PTcantidad, listaProdTer_UCodigo"/>
            <cfinvokeargument name="etiquetas" 	value="Art&iacute;culo,Descripci&oacute;n,Precio Unitario,Cantidad,U/M"/>
            <cfinvokeargument name="formatos" 	value="V,V,N,N,V"/>
            <cfinvokeargument name="align" 		value="center,left, center, center, center"/>
            <cfinvokeargument name="ajustar" 	value="N"/>
            <cfinvokeargument name="checkboxes" value="N"/>
            <cfinvokeargument name="irA" 		value="RegOrdenTr.cfm"/>
            <cfinvokeargument name="showEmptyListMsg" 	value="true"/>
            <cfinvokeargument name="maxRows" 			value="#form.MaxRows#"/> 
            <cfinvokeargument name="formName" 		value="form3"> 
            <cfinvokeargument name="incluyeForm" 	value="false">               
        </cfinvoke>
        </td>
    </tr></table>
</form>
</cfoutput>     
</cfif>
<!--- ************************************************************* --->
<script language="JavaScript1.2" type="text/javascript">
	function validaPT(formulario){
		var error = false;
		var mensaje = "Se presentaron los siguientes errores:\n";
		if (formulario.ProdTer_Aid.value== "" ){
			error = true;
			mensaje += "El campo artículo es requerido.\n";
		}
		if ( error ){
			alert(mensaje);
			return false;
		}else{
			return true;
		}
	}
</script>
