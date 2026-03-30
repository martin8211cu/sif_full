<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfinclude template="../../Utiles/sifConcat.cfm">
<style type="text/css">
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
</style>

<cfquery name="rsUnidades" datasource="#session.DSN#">
	select Ucodigo, Udescripcion 
	from Unidades 
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by Ucodigo
</cfquery>

<cfquery name="rsConversion" datasource="#session.DSN#">
	select Ucodigo, Ucodigoref, CUfactor 
	from ConversionUnidades 
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfquery name="rsConversionArt" datasource="#session.DSN#">
	select distinct a.Aid, b.Adescripcion, b.Ucodigo, c.Ucodigo as Ucodigoref, CUAfactor
	from DDocumentosRecepcion a
	
	inner join Articulos b
	on a.Aid=b.Aid
	
	inner join ConversionUnidadesArt c
	on b.Aid=c.Aid
	
	where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and EDRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.EDRid#">
	
	order by a.Aid
</cfquery>

<cfquery name="dataLineas" datasource="#session.DSN#">
	select 	b.EOidorden, 
			c.EOnumero, 
			c.Observaciones, 
			a.DDRlinea, 
			a.DOlinea, 
			case when a.DDRtipoitem = 'A' then rtrim(d.Acodigo)#_Cat#' - '#_Cat#b.DOdescripcion
			 	 when a.DDRtipoitem = 'S' then rtrim(e.Ccodigo)#_Cat#' - '#_Cat#b.DOdescripcion
			 	 else b.DOdescripcion
			end DOdescripcion, 
			a.DDRtipoitem, 
			a.Aid, 
			a.Cid, 
			a.DDRcantorigen, 
			a.DDRcantrec, 
	       	#LvarOBJ_PrecioU.enSQL_AS("a.DDRpreciou")#, 
			a.DDRtotallin, 
			#LvarOBJ_PrecioU.enSQL_AS("a.DDRprecioorig")#, 
			a.DDRdesclinea, 
			a.DDRobsreclamo, 
			a.DDRgenreclamo,
		   	b.DOcantidad, 
			b.DOcantsurtida, 
			coalesce(a.Ucodigo, b.Ucodigo) as Ucodigo, 
			b.Ucodigo as UcodigoOC
	from DDocumentosRecepcion a
	
		inner join DOrdenCM b
			on a.DOlinea=b.DOlinea
			and a.Ecodigo=b.Ecodigo
	
		inner join EOrdenCM c
			on b.EOidorden=c.EOidorden
	
		left outer join Articulos d
			on a.Ecodigo = d.Ecodigo 
			and a.Aid = d.Aid
		
		left outer join Conceptos e
			on a.Ecodigo = e.Ecodigo
			and a.Cid = e.Cid
	
	where EDRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.EDRid#">
	and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by b.EOidorden, DDRtipoitem 
</cfquery>

<cfoutput>

<script language="javascript1.2" type="text/javascript">
	var conversion    = new Object();
	var conversion_art = new Object();

	// objeto con datos de tabla de conversiones 
	<cfloop query="rsConversion">
		if ( !conversion["#trim(rsConversion.Ucodigo)#"] ){
		conversion["#trim(rsConversion.Ucodigo)#"] = new Object();
		}
		conversion["#trim(rsConversion.Ucodigo)#"]["#trim(rsConversion.Ucodigoref)#"] = "#rsConversion.CUfactor#";
	</cfloop>
	
	// objeto con datos de tabla de conversiones por articulo
	<cfloop query="rsConversionArt">
		if ( !conversion_art["#rsConversionArt.Aid#"] ){
			conversion_art["#rsConversionArt.Aid#"] = new Object();
		}

		if ( !conversion_art["#rsConversionArt.Aid#"]["#trim(rsConversionArt.Ucodigo)#"] ){ 
			conversion_art["#rsConversionArt.Aid#"]["#trim(rsConversionArt.Ucodigo)#"] = new Object();
		}

		conversion_art["#rsConversionArt.Aid#"]["#trim(rsConversionArt.Ucodigo)#"]["#trim(rsConversionArt.Ucodigoref)#"] = "#rsConversionArt.CUAfactor#";
	</cfloop>

</script>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr><td>&nbsp;</td></tr>

	<tr><td colspan="12" class="bottomline" ><strong><font size="2">Agregar Nuevo Detalle</font></strong></td></tr>
	<tr>
		<td colspan="12">
			<table width="100%" border="0" cellpadding="4" cellspacing="0" bgcolor="##F5F5F5">
				<tr>
					<td align="right" nowrap><strong>L&iacute;nea de Orden de Compra:&nbsp;</strong></td>
					<td width="1%">
						<input name="DOlinea" value="" type="hidden">
						<input name="DOdescripcion" value="" type="text" size="60" readonly>
					</td>
					<td width="1%">
						<cfif modo neq 'ALTA'><a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Ordenes de Compra" name="OCimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisLinea();'></a></cfif>
					</td>
					<td width="5%">&nbsp;</td>
					<td width="92%"><input type="submit" name="btnAgregarLinea" value="Agregar L&iacute;nea" onClick="validar=false; if( document.form1.DOlinea.value != ''){return true;}else{ alert('Se presentaron los siguinest errore:\n - Debe seleccionar una Línea de Orden de Compra.') } return false;"></td>
				</tr>
			</table>
		</td>
	</tr>
	
	<!----<tr><td colspan="11" >&nbsp;</td></tr>--->
	<!---<tr><td colspan="11" class="bottomline" ><strong><font size="2">Trabajar con detalles</font></strong></td></tr>--->

	<cfset corte = ''>
	<cfset corte_orden = ''>
	<cfset nombreItem =''>
	<cfset index = 1 >
	<cfloop query="dataLineas">
		<cfset vUcodigo = dataLineas.Ucodigo>

		<cfif corte_orden neq dataLineas.EOidorden >
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="12" class="bottomline" bgcolor="##F5F5F5"><font size="2"><strong>#dataLineas.EOnumero# - #dataLineas.Observaciones#</strong></font></td></tr>
		</cfif>

		<!--- Recupera por cada linea, la cantidad acumulada segun los documentos de 
		      recepcion/devolucion registrados para cada linea 
		--->
		<cfquery name="dataCantidad" datasource="#session.DSN#">
			select coalesce(sum(a.DDRcantorigen),0) as DDRcantidadacum
			from DDocumentosRecepcion a
			
			inner join EDocumentosRecepcion b
			on a.EDRid=b.EDRid
			and EDRestado=10
			
			inner join TipoDocumentoR c
			on b.TDRcodigo=c.TDRcodigo
			and a.Ecodigo=c.Ecodigo
			and c.TDRtipo=<cfqueryparam cfsqltype="cf_sql_char" value="#form.tipo#">
			
			where a.DOlinea=<cfqueryparam cfsqltype="cf_sql_numeric" value="#dataLineas.DOlinea#">
			  and DDRgenreclamo=1
		</cfquery>

		<input type="hidden" name="DOlinea_#dataLineas.CurrentRow#" value="#dataLineas.DOlinea#">
		<input type="hidden" name="DDRlinea_#dataLineas.CurrentRow#" value="#dataLineas.DDRlinea#">

		<!--- Cantidad total recibida para una linea, en todos los documentos de recepcion aplicados y que generaron reclamo --->

		<cfset DDRcantidadcalculo = dataLineas.DOcantsurtida - abs(dataCantidad.DDRcantidadacum) >
<!---
		<input type="hidden" name="DDRcantidadacum_#dataLineas.CurrentRow#" value="#DDRcantidadcalculo#">

		<!--- Saldo respecto a la orden de compra --->
		<cfset DDRcantidadsaldo = dataLineas.DOcantidad - dataCantidad.DDRcantidadacum >
		<input type="hidden" name="DOcantidadsaldo_#dataLineas.CurrentRow#" value="#DDRcantidadsaldo#">
		
		<input tabindex="1" type="hidden" name="DDRcantidadsaldo_#dataLineas.CurrentRow#" id="DDRcantidadsaldo_#dataLineas.CurrentRow#"  style="text-align:right; border-width:0; <cfif not index mod 2 >background-color:##FFFFFF;</cfif>" size="15" maxlength="10" 
			   value="<cfif len(trim(DDRcantidadsaldo)) >#LSNumberFormat(DDRcantidadsaldo,',9.00')#<cfelse>0.00</cfif>" readonly > 

--->
		<cfif corte neq dataLineas.DDRtipoitem >
			<cfif dataLineas.DDRtipoitem eq 'A'>
				<cfset nombreItem = 'Artículos' >
			<cfelseif dataLineas.DDRtipoitem eq 'F'>
				<cfset nombreItem = 'Activos Fijos' >
			<cfelse>
				<cfset nombreItem = 'Servicios' >
			</cfif>
			
			<cfset index = 1>
			
			<tr><td>&nbsp;</td></tr>

			<tr><td colspan="12" class="bottomline" ><strong><font size="1">#nombreItem#</font></strong></td></tr>	
			<tr class="titulolistas">
				<td width="25%"><strong>Item</strong></td>
				<td width="10%" align="right"><strong>Cant. OC</strong></td>
				<td nowrap><strong>Unidad OC</strong></td>
				<td width="10%" align="right"><strong>Cant. Surtida</strong></td>
				<td ><strong>Unidad</strong></td>
				<td width="10%" align="right"><strong>Cantidad</strong></td>
				<td width="10%" align="right"><strong>Precio OC</strong></td>
				<td width="10%" align="right"><strong>Precio</strong></td>
				<td width="10%" align="right"><strong>Total</strong></td>
				<td width="1%" align="center"><strong>Reclamo</strong></td>
				<td width="1%" align="center"><strong>Obs</strong></td>
				<td width="1%" align="center"><strong>Eliminar</strong></td>
			</tr>
		</cfif>
		<tr class="<cfif index mod 2 >listaPar<cfelse>listaNon</cfif>" >
			<td title="#dataLineas.DOdescripcion#">#Mid(dataLineas.DOdescripcion,1,35)#<cfif len(dataLineas.DOdescripcion) gt 35>...</cfif></td>
			
			<td align="right" nowrap>
				<input name="Aid_#dataLineas.CurrentRow#" value="#dataLineas.Aid#" type="hidden">
				<input tabindex="1" type="text" name="DOcantidad_#dataLineas.CurrentRow#" id="DOcantidad_#dataLineas.CurrentRow#"   style="text-align:right; border-width:0; <cfif not index mod 2 >background-color:##FFFFFF;</cfif>" size="15" maxlength="10"
					   value="<cfif len(trim(dataLineas.DOcantidad)) >#LSNumberFormat(dataLineas.DOcantidad,',9.00')#<cfelse>0.00</cfif>" > 
			</td>
			
			<td>
				<input name="DDRfactor_#dataLineas.CurrentRow#" value="1" type="hidden">
				<input type="text" size="5" readonly name="UcodigoOC_#dataLineas.CurrentRow#" value="#dataLineas.UcodigoOC#" style="text-align:left; border-width:0; <cfif not index mod 2 >background-color:##FFFFFF;</cfif>">
			</td>
			
			<td align="right">
				<!---<input tabindex="1" type="text" name="DDRcantsurtida_#dataLineas.CurrentRow#" id="DDRcantsurtida_#dataLineas.CurrentRow#" style="text-align:right; border-width:0; <cfif not index mod 2 >background-color:##FFFFFF;</cfif>" size="15" maxlength="10"
					   value="<cfif len(trim(dataLineas.DOcantsurtida)) >#LSNumberFormat(dataLineas.DOcantsurtida,',9.00')#<cfelse>0.00</cfif>" > --->
				<input tabindex="1" type="text" name="DDRcantsurtida_#dataLineas.CurrentRow#" id="DDRcantsurtida_#dataLineas.CurrentRow#" style="text-align:right; border-width:0; <cfif not index mod 2 >background-color:##FFFFFF;</cfif>" size="15" maxlength="10"
					   value="<cfif len(trim(DDRcantidadcalculo)) >#LSNumberFormat(DDRcantidadcalculo,',9.00')#<cfelse>0.00</cfif>" >					   
			</td>

			<td>
				<select name="Ucodigo_#dataLineas.CurrentRow#" onChange="cambiaUnidad(#dataLineas.CurrentRow#, this.value)">
					<cfloop query="rsUnidades">
						<option value="#rsUnidades.Ucodigo#" <cfif trim(vUcodigo) eq trim(rsUnidades.Ucodigo) >selected</cfif> >#rsUnidades.Ucodigo#</option>
					</cfloop>
				</select>
			</td>

			<td align="right" nowrap>
				<input tabindex="1" type="text" name="DDRcantorigen_#dataLineas.CurrentRow#" id="DDRcantorigen_#dataLineas.CurrentRow#"  style="text-align:right" size="15" maxlength="10" 
					   onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
					   onFocus="javascript:this.select();" 
					   onChange="javascript: fm(this,2);"
					   value="<cfif len(trim(dataLineas.DDRcantorigen)) >#LSNumberFormat(dataLineas.DDRcantorigen,',9.00')#<cfelse>0.00</cfif>"
					   onblur="valida_cantidad(#dataLineas.CurrentRow#); total(#dataLineas.CurrentRow#);" > 
			</td>

			<td align="right" nowrap>
				<input type="hidden" name="DDRprecioorig_#dataLineas.CurrentRow#" id="DDRprecioorig_#dataLineas.CurrentRow#" value="#dataLineas.DDRprecioorig#">
				#LvarOBJ_PrecioU.enCF(dataLineas.DDRprecioorig)#
			</td>
			
			<td align="right">
				<cfif len(trim(dataLineas.DDRpreciou)) and dataLineas.DDRpreciou neq 0 >
					<cfset LvarPrecio = dataLineas.DDRpreciou>
				<cfelse>
					<cfset LvarPrecio = dataLineas.DDRprecioorig>
				</cfif>" 
				<!---#LvarOBJ_PrecioU.inputNumber("CAMPO", VALOR, "tabIndex", readOnly, "class", "style", "onBlur();", "onChange();")#--->
				#LvarOBJ_PrecioU.inputNumber("DDRpreciou_#dataLineas.CurrentRow#", LvarPrecio, "1", false, "", "", "total(#dataLineas.CurrentRow#);", "")#
			</td>
			
			<td align="right" nowrap>
				<input tabindex="1" type="text" name="DDRtotallin_#dataLineas.CurrentRow#" id="DDRtotallin_#dataLineas.CurrentRow#"  style="text-align:right; border-width:0; <cfif not index mod 2 >background-color:##FFFFFF;</cfif>" size="15" maxlength="10" 
					   value="<cfif len(trim(dataLineas.DDRtotallin)) >#LSNumberFormat(dataLineas.DDRtotallin,',9.00')#<cfelse>0.00</cfif>" readonly > 
			</td>

			<td align="center">
				<input type="checkbox" name="DDRgenreclamo_#dataLineas.CurrentRow#" id="DDRgenreclamo_#dataLineas.CurrentRow#" <cfif dataLineas.DDRgenreclamo eq 1>checked</cfif>  >	
			</td>
			
			<td align="center">
				<input type="hidden" name="DDRobsreclamo_#dataLineas.CurrentRow#" id="DDRobsreclamo_#dataLineas.CurrentRow#" value="#dataLineas.DDRobsreclamo#">
				<a href="javascript:info_detalle(#dataLineas.CurrentRow#);"><img border="0" src="../../imagenes/iedit.gif" alt="<cfif modo eq 'ALTA'>Definir<cfelse>Ver/Modificar</cfif> Observaciones"></a>
			</td>
			
			<td align="center">
				<a href="javascript:eliminar(#dataLineas.DDRlinea#);"><img border="0" src="../../imagenes/Borrar01_S.gif" alt="Eliminar línea del documento"></a>
			</td>

		</tr>

		<cfset corte = dataLineas.DDRtipoitem>
		<cfset corte_orden = dataLineas.EOidorden>

		<cfset index = index + 1>
	</cfloop>
</table>

<!--- Ocultos --->
<input type="hidden" name="cantidad" value="#dataLineas.Recordcount#">

<!--- para borrar desde la lista --->
<input type="hidden" name="_delete" value="">
<input type="hidden" name="IDdelete" value="">


</cfoutput>

<script language="javascript1.2" type="text/javascript">
	function info_detalle(value){
		var obj = document.getElementById("DDRgenreclamo_"+value);
		if ( !obj.disabled && obj.checked ){
			open('documentos-detalleinfo.cfm?index='+value, 'documentos', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width=600,height=420,left=250, top=200,screenX=250,screenY=200');
		}
	}
	
	function total(i){
		var value1 = parseFloat(qf(document.getElementById("DDRcantorigen_"+i).value));
		var value2 = parseFloat(qf(document.getElementById("DDRpreciou_"+i).value));
		
		document.getElementById("DDRtotallin_"+i).value = value1*value2;
		document.getElementById("DDRtotallin_"+i).value = fm(document.getElementById("DDRtotallin_"+i).value,2)
	}
	
/*
	function valida_cantidad(i){
		var value1 = parseFloat(qf(document.getElementById("DDRcantorigen_"+i).value));
		var value2 = parseFloat(qf(document.getElementById("DDRcantsurtida_"+i).value)) ;

		if ( value1 > value2 ){
			alert('La cantidad del Documento es mayor a la cantidad surtida en la Orden de Compra.')
			document.getElementById("DDRcantorigen_"+i).focus();
		}
	}
	*/
	
	function valida_cantidad(i){
		var factor = parseFloat(obtenerFactor(i));
		var value1 = parseFloat(qf(document.getElementById("DDRcantorigen_"+i).value));
		var value2 = parseFloat(qf(document.getElementById("DDRcantsurtida_"+i).value)) ;
		
		if ( value1 > (value2*factor) ){
			if (factor > 0 ){
				alert('La cantidad del Documento es mayor a la cantidad surtida en la Orden de Compra.')
				document.getElementById("DDRfactor_"+i).value = 1;
				document.getElementById("DDRcantorigen_"+i).value = parseFloat(value2*factor);
				fm(document.getElementById("DDRcantorigen_"+i),2);
				document.getElementById("DDRcantorigen_"+i).focus();
			}
			else{
				alert("No de encontro el factor de conversión de la unidad " +  trim(document.getElementById("UcodigoOC_"+i).value) + " a la unidad " + trim(document.getElementById("Ucodigo_"+i).value)+ ".");
				document.getElementById("DDRfactor_"+i).value = 0;
				document.getElementById("DDRcantorigen_"+i).value = 0;
				document.getElementById("DDRcantorigen_"+i).focus();
			}
		}
	}

	function eliminar(id){
		if ( confirm('Desea eliminar el registro?') ){
			document.form1._delete.value = id;
			document.form1.IDdelete.value = id;
			document.form1.submit();
		}
	}
	
	function doConlisLinea() {
		popUpWindow("/cfmx/sif/cm/operacion/ConlisLineaCompra.cfm?EDRid=<cfoutput>#form.EDRid#</cfoutput>&SNcodigo="+
			document.form1.SNcodigo.value + "&McodigoE=" + 
			document.form1.Mcodigo.value + "&TC_E=" + 
			qf(document.form1.EDRtc.value),50,50,1060,600);
	}
	
	function cambiaUnidad(indice, value){
		var f = document.form1;

		var Aid = f['Aid_'+indice].value;
		var Ucodigo = trim(f['UcodigoOC_'+indice].value);
		var Ucodigoref = trim(f['Ucodigo_'+indice].value);
		var existe = false;		
		var factor = 1;

		// solo hace este procesamiento si los codigos de unidad son diferentes 
		if ( Ucodigo != Ucodigoref ){ // codigos de unidad
			// valida primero en conversion
			if ( conversion[Ucodigo] && conversion[Ucodigo][Ucodigoref]){
				existe = true;
				factor = conversion[Ucodigo][Ucodigoref];
			}
			
			// si no hay dato en conversion, busca en conversiones por articulo
			if (!existe && conversion_art[Aid] && conversion_art[Aid][Ucodigo] && conversion_art[Aid][Ucodigo][Ucodigoref] ){
				existe = true;
				factor = conversion_art[Aid][Ucodigo][Ucodigoref];
			}
			
			if ( !existe ){
				f['DDRfactor_'+indice].value = 0;
				f['DDRcantorigen_'+indice].value = 0;
				fm(f['DDRcantorigen_'+indice], 2);
			}
			else{
				f['DDRfactor_'+indice].value = factor;
				f['DDRcantorigen_'+indice].value = parseFloat(qf(f['DDRcantsurtida_'+indice].value))*factor;
				fm(f['DDRcantorigen_'+indice], 2);
			}
		}
		else{
			f['DDRfactor_'+indice].value = 1;
			f['DDRcantorigen_'+indice].value = f['DDRcantsurtida_'+indice].value;
			fm(f['DDRcantorigen_'+indice],2);
			existe = true; 
		}

		f['DDRcantorigen_'+indice].focus();
	}
	
	function obtenerFactor(indice){
		var f = document.form1;

		var Aid = f['Aid_'+indice].value;
		var Ucodigo = trim(f['UcodigoOC_'+indice].value);
		var Ucodigoref = trim(f['Ucodigo_'+indice].value);

		// solo hace este procesamiento si los codigos de unidad son diferentes 
		if ( Ucodigo != Ucodigoref ){ // codigos de unidad
			// valida primero en conversion
			if ( conversion[Ucodigo] && conversion[Ucodigo][Ucodigoref]){
				return conversion[Ucodigo][Ucodigoref];
			}
			// si no hay dato en conversion, busca en conversiones por articulo
			if (conversion_art[Aid] && conversion_art[Aid][Ucodigo] && conversion_art[Aid][Ucodigo][Ucodigoref] ){
				return conversion_art[Aid][Ucodigo][Ucodigoref];
			}
		}
		else{
			return 1
		}
		
		return 0;
	}
	
</script>