<cfif isdefined("Form.OTcodigo") AND Len(Trim(Form.OTcodigo)) GT 0>

<!--- Establecimiento del modo --->
	<cfif isdefined("Form.Alta")>
        <cfset modoArt="ALTA">
    <cfelse>
        <cfif not isdefined("Form.modoArt")>
            <cfset modoArt="ALTA">
        <cfelseif Form.modoArt EQ "CAMBIO">
            <cfset modoArt="CAMBIO">
        <cfelse>
            <cfset modoArt="ALTA">
        </cfif>
    </cfif>
    
	<cfset img_checked = "<img border=''0'' src=''/cfmx/sif/imagenes/checked.gif''>">
    <cfset img_unchecked = "<img border=''0'' src=''/cfmx/sif/imagenes/unchecked.gif''>">

    <cfquery name="rsProdMateriaPrima" datasource="#session.DSN#">
        select p.OTseq, p.Artid,a.Aid as lista_Aid,a.Adescripcion as lista_Adescripcion,a.Acodigo as lista_Acodigo, p.UCodigo as lista_UCodigo, p.MPcantidad, p.MPprecioUnit, p.MPseguimiento,case p.MPseguimiento when 1 then '#img_checked#' else '#img_unchecked#' end as imagen_Seg, p.ts_rversion 
        from Prod_Insumo p
        	inner join Articulos a on p.Ecodigo=a.Ecodigo and a.Aid=p.Artid
        where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            and OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OTcodigo#">
        order by OTseq, p.Artid
    </cfquery>
    
    <cfquery datasource="#session.DSN#" name="rsUnidades">
        select Ucodigo, Udescripcion 
        from Unidades 
        where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >
            and Utipo in (0,2)
        order by Udescripcion
    </cfquery>
    
    
	<cfset modoArt='ALTA'>    

	<cfif isdefined("form.OTseq") and len(trim(form.OTseq)) GT 0 and isdefined("form.lista_Aid") and len(trim(form.lista_Aid)) GT 0>
        <cfset modoArt = 'CAMBIO'>
    </cfif>
    
	<cfif modoArt neq 'ALTA'>
        <cfquery name="rsProdArtOrden" datasource="#session.DSN#">
            select p.OTseq, p.Artid, p.UCodigo, p.MPcantidad, p.MPprecioUnit, p.MPseguimiento, p.ts_rversion 
            from Prod_Insumo p
            where p.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                and p.OTcodigo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OTcodigo#">
                and p.OTseq 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.OTseq#">
                and p.Artid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.lista_Aid#">
            order by OTseq, Artid
        </cfquery>
    </cfif>
    
<cfoutput>
<form method="post" name="form2" action="SQLOrdenTr1.cfm" <cfif isdefined("form.OTcodigo")> onSubmit="javascript: return validaMP(this)" </cfif>>
   <input type="hidden" name="OTCodigo" value= "#Form.OTcodigo#" />
   <input name="tab" type="hidden" value="prod">
   <table>
    <tr> 
        <td class="tituloListas" colspan="6" align="center">Materia Prima</td>
    </tr>
    <tr> 
        <td class="tituloListas" align="center">Paso</td>
        <td class="tituloListas" align="center">Art&iacute;culo</td>
        <td class="tituloListas" align="center">Precio Unitario</td>
        <td class="tituloListas" align="center">Cantidad</td>
        <td class="tituloListas" align="center">U/M</td>
        <td class="tituloListas" align="center">Art&iacute;culo de Seguimiento</td>
    </tr>
    <tr>
        <td align="left" width="1%" nowrap>
            <input type="text" name= "OrdenSeq" size="3" maxlength="2"  value="<cfif modoArt neq 'ALTA'>#rsProdArtOrden.OTseq#</cfif>"  
            <cfif modoArt neq 'ALTA'>readonly="readonly"</cfif> onfocus="javascript:this.select();">
        </td>
        <td align="left" width="1%" nowrap>
			<cfif modoArt neq 'ALTA'>
                <cfquery name="rsArticulo" datasource="#session.DSN#">
                    select Aid, Acodigo, Adescripcion
                    from Articulos
                    where Ecodigo= #Session.Ecodigo# 
                    and Aid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsProdArtOrden.Artid#">
                </cfquery>
                <cf_sifarticulos query=#rsArticulo# form="form2">
            <cfelse>
            	<cf_sifarticulos form="form2">
            </cfif>
        </td>
        <td align="left" width="1%" nowrap>
            <input type="text" name= "PrecioU" size="18" maxlength="20" value= "<cfif modoArt neq 'ALTA'>#rsProdArtOrden.MPprecioUnit#</cfif>" onfocus="javascript:this.select();">
        </td>
        <td align="left" width="1%" nowrap>
            <input type="text" name= "Cantidad" size="5" maxlength="6" value= "<cfif modoArt neq 'ALTA'>#rsProdArtOrden.MPcantidad#</cfif>" onfocus="javascript:this.select();">
        </td>
        <td align="left" width="1%" nowrap>
            <select name="UnidadM" tabindex="1">
                <cfloop query="rsUnidades">
                	<option value="#rsUnidades.Ucodigo#" <cfif modoArt NEQ 'ALTA' and trim(Form.lista_UCodigo) EQ trim(rsUnidades.Ucodigo)>selected</cfif>>#rsUnidades.Udescripcion#</option>
                </cfloop>						
            </select>
        </td>
        <td align="center">
            <input type="checkbox" name="chkseguimiento" <cfif 	modoArt neq 'ALTA' and rsProdArtOrden.MPseguimiento eq 1>checked</cfif>>
        </td>
    </tr>
    <tr>
        <td colspan="6" align="right">
            <cfif modoArt neq 'ALTA'>
                <input type="submit" name="Modificar_Art" value="Modificar" <!---onClick="javascript: return validaMP(this);"--->>
                <input type="submit" name="Eliminar_Art" value="Eliminar">
            <cfelse>
            	<input type="submit" name="Aceptar_Art" value="Agregar" <!---onClick="javascript: return validaMP(this);"--->>
            </cfif>
        </td>
    </tr>
    <tr>
        <cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
            <cfinvokeargument name="query" 		value="#rsProdMateriaPrima#"/>
            <cfinvokeargument name="desplegar" 	value="OTseq, lista_Acodigo,lista_Adescripcion, MPprecioUnit, MPcantidad, lista_UCodigo, imagen_Seg"/>
            <cfinvokeargument name="etiquetas" 	value="Paso,Art&iacute;culo,Descripci&oacute;n,Precio Unitario,Cantidad,U/M,Art&iacute;culo de Seguimiento"/>
            <cfinvokeargument name="formatos" 	value="I,V,V,N,N,V,I"/>
            <cfinvokeargument name="align" 		value="center, center,left, center, center, center, center"/>
            <cfinvokeargument name="ajustar" 	value="N"/>
            <cfinvokeargument name="checkboxes" value="N"/>
            <cfinvokeargument name="irA" 		value="RegOrdenTr.cfm"/>
            <cfinvokeargument name="showEmptyListMsg" 	value="true"/>
            <cfinvokeargument name="maxRows" 			value="#form.MaxRows#"/> 
            <cfinvokeargument name="formName" 			value="form2"/> 
			<cfinvokeargument name="incluyeForm" 	value="false"/>              
        </cfinvoke>
    </tr></table>
</form>
</cfoutput>    

<!--- ************************************************************* --->
<script language="JavaScript1.2" type="text/javascript">
	function validaMP(formulario){
		var error = false;
		var mensaje = "Se presentaron los siguientes errores:\n";
		if (formulario.OrdenSeq.value == "" ){
			error = true;
			mensaje += "El campo Paso es requerido.\n";
		}
		
		if (formulario.Aid.value == "" ){
			error = true;
			mensaje += "El campo artículo es requerido.\n";
		}
		else {
			error = true;
			for (i=1;i<=<cfoutput>#NumprodArea#</cfoutput>;i++){
				if (formulario.OrdenSeq.value ==	document.formArea['Orden'+i].value) {
					error = false;
				}
			};
			if ( error ){
				mensaje += "El paso no está definido.\n";
			}
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