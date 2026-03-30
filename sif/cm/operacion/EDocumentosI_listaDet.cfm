<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="rsTotFact" datasource="#session.DSN#">
	Select sum(DDItotallinea) as totFactura
	From EDocumentosI ed
		inner join DDocumentosI dd
			on ed.EDIid=dd.EDIid
				and ed.Ecodigo=dd.Ecodigo
	where ed.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and ed.EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDIid#">
</cfquery>

<!---Lista de Items--->
<cfquery name="rsListaItems" datasource="#session.dsn#">
	select Ddocumento
		<cfif isdefined("Form.EPDid_DP") and Len(Trim(Form.EPDid_DP)) NEQ 0>
			, #form.EPDid_DP# as EPDid_DP
		</cfif>	
		, ed.EDItipo
		, DDlinea		
		, dd.EDIid
		, dd.DOlinea
		, do.EOidorden
		, case when <cf_dbfunction name="length" args="Observaciones"> > 25 then <cf_dbfunction name="sPart" args="Observaciones, 1,25"> #_Cat# '...' else Observaciones end as Observaciones
		, coalesce(DDIcantidad,0) as DDIcantidad
		, DDIconsecutivo 
		, eo.EOnumero
		, do.DOconsecutivo
		, case DDIafecta
			when 1 then 'Fletes'
			when 2 then 'Seguros'
			when 3 then 'Costos'
			when 4 then 'Gastos'
			when 5 then 'Impuestos'
		  end as DDIafecta
		, case DDItipo
			when 'A' then 'Articulo'
			when 'S' then 'Servicio'
			when 'F' then 'Activo'
		  end as DDItipo
		, #LvarOBJ_PrecioU.enSQL_AS("coalesce(DDIpreciou,0)", "DDIpreciou")#
		,coalesce(DDItotallinea,0) as DDItotallinea
		,round(((coalesce(DDIpreciou,0) * coalesce(DDIcantidad,0))*(coalesce(DDIporcdesc,0))) / 100,2) as Mtodesc
		, case 
			when do.Aid is not null then case when <cf_dbfunction name="length" args="art.Adescripcion">  > 25 then <cf_dbfunction name="sPart" args="art.Adescripcion, 1,25"> #_Cat# '...' else art.Adescripcion end
			when dd.Cid is not null then case when <cf_dbfunction name="length" args="conf.Cdescripcion"> > 25 then <cf_dbfunction name="sPart" args="conf.Cdescripcion, 1,25"> #_Cat# '...' else conf.Cdescripcion end
			when dd.Icodigo is not null then dd.Icodigo
			else case when <cf_dbfunction name="length" args="do.DOdescripcion"> > 25 then <cf_dbfunction name="sPart" args="do.DOdescripcion, 1,25"> #_Cat# '...' else do.DOdescripcion end
		  end as itemDescripcion,
		  dd.DDIporcdesc
	from DDocumentosI dd
		inner join EDocumentosI ed
			on dd.EDIid   = ed.EDIid
                
		left outer join DOrdenCM do
			on dd.DOlinea = do.DOlinea
            
        left outer join Articulos art
			on art.Aid = do.Aid
                
		left outer join Conceptos conf
			on conf.Cid = dd.Cid
            
		left outer join EOrdenCM eo
			on do.EOidorden = eo.EOidorden
            
	where dd.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and dd.EDIid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDIid#">
	order by eo.EOnumero, do.DOconsecutivo
</cfquery>
<table align="center" width="99%"  border="0" cellspacing="0" cellpadding="0">
  <tr><td class="subTitulo"><font size="2">Lista de Detalles</font></td> </tr>
</table>

<form name="ListaDetalle" action="EDocumentosI.cfm" method="post">
	<cfoutput>
	<input  type="hidden" name="btnBorrarD" value="">
	<input type="hidden" name="DDlinea" value="">
	<input type="hidden" name="EDIid" value="#form.EDIid#">
	<cfif isdefined("form.EPDid_DP") and len(trim(form.EPDid_DP))>
		<input type="hidden" name="EPDid_DP" value="#form.EPDid_DP#">
	</cfif>
	</cfoutput>
	<table align="center" width="99%"  border="0" cellspacing="0" cellpadding="2">
		<tr class="tituloListas">
			<td align="center" nowrap>Consecutivo</td>
			<td align="center" nowrap>N° Compra</td>
			<td align="center" nowrap>Línea de OC</td>
			<td align="center" nowrap>Descripción</td>
			<td align="center" nowrap>Tipo</td>
			<td align="center" nowrap>Afecta a</td>
			<td align="center" nowrap>Cantidad</td>
			<td align="center" nowrap>Precio Unitario</td> 
			<td align="center" nowrap>Mto.Descuento</td> 
			<td align="center" nowrap>Total</td>
			<td align="center">&nbsp;</td>
		</tr>
		<cfoutput query="rsListaItems">
			<tr class="<cfif rsListaItems.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>" style="cursor: hand;">
				<td onClick="javascript:funcCargar(#rsListaItems.DDlinea#);" >#DDIconsecutivo#</td>
				<td onClick="javascript:funcCargar(#rsListaItems.DDlinea#);" >#EOnumero#</td>
				<td onClick="javascript:funcCargar(#rsListaItems.DDlinea#);" >#DOconsecutivo#</td>
				<td onClick="javascript:funcCargar(#rsListaItems.DDlinea#);" >#itemDescripcion#</td>
				<td onClick="javascript:funcCargar(#rsListaItems.DDlinea#);" >#DDItipo#</td>
				<td onClick="javascript:funcCargar(#rsListaItems.DDlinea#);" >#DDIafecta#</td>
				<td>
					<input tabindex="1" type="text" style="text-align:right" name="DDIcantidad_#rsListaItems.DDlinea#" 
						value="#LSNumberFormat(rsListaItems.DDIcantidad,',9.0000')#" size="18" maxlength="18" align="right" 
						onClick="javascript:document.ListaDetalle.nosubmit=true;" 
						onFocus="javascript:this.select()" 
						onBlur="javascript:fm(this,4);totalLinConDesc(#rsListaItems.DDlinea#);" 
						onKeyUp="if(snumber(this,event,4)){if(Key(event)==13) {this.blur()}};totalLinConDesc(#rsListaItems.DDlinea#);">
				</td>
				<td>
					<!---#LvarOBJ_PrecioU.inputNumber("CAMPO", VALOR, "tabIndex", readOnly, "class", "style", "onBlur();", "onChange();")#--->
					#LvarOBJ_PrecioU.inputNumber("DDIpreciou_#rsListaItems.DDlinea#", rsListaItems.DDIpreciou, "1", false, "", "", "totalLinConDesc(#rsListaItems.DDlinea#);", "")#
				</td>
				<td>
					<input tabindex="1" type="text" style="text-align:right" 
						name="Mtodesc_#rsListaItems.DDlinea#" 
						value="#LSNumberFormat(rsListaItems.Mtodesc,',9.0000')#" size="18" 
						maxlength="18" align="right" 
 						onClick="javascript:document.ListaDetalle.nosubmit=true;" 
						onFocus="javascript:this.select();" 
						onBlur="javascript:fm(this,4);" 
						onKeyUp="if(snumber(this,event,4)){if(Key(event)==13) {this.blur()}};totalLinConDesc(#rsListaItems.DDlinea#);">
					</td>
				<td>
	                <input type="hidden" name="DDItotallinea_#rsListaItems.DDlinea#" value="<cfif len(trim(rsListaItems.DDItotallinea)) and rsListaItems.DDItotallinea neq 0>#LSNumberFormat(rsListaItems.DDItotallinea,',9.0000')#<cfelse>0.00</cfif>">				
					<input tabindex="-1" type="text" style="text-align:right" 
						name="DDItotallineaCD_#rsListaItems.DDlinea#" 
						value="#LSNumberFormat(rsListaItems.DDItotallinea,',9.00')#" 
						size="18" maxlength="18" align="right" 
						class="cajasinbordeb"	
						readonly="true">
				</td>
				<td>
                	<cfif rsForm.EDIestado EQ 0><!---►Digitación--->
                    	<img border="0" onClick="javascript: funcEliminar(#rsListaItems.DDlinea#,#rsListaItems.EDIid#);" src="/cfmx/sif/imagenes/Borrar01_S.gif">
                	</cfif>
                </td>
			</tr>
			<input type="hidden" name="Lineas" value="#rsListaItems.DDlinea#">
		</cfoutput>
	</table>

	 <table width="100%" border="0">
	  <tr>
		<td style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
	  </tr>
	  <tr>
		<td align="right">
			<strong>
				Total de la Factura:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<cfif modo NEQ 'ALTA' and isdefined('rsTotFact') and rsTotFact.recordCount GT 0 and rsTotFact.totFactura GT 0>
					<cfoutput>#LSNumberFormat(rsTotFact.totFactura,',9.00')#</cfoutput>
				<cfelse>
					0.00
				</cfif>
			</strong>
		</td>
	  </tr>
	  <tr>
	  		<td align="center">
            	<cfif rsForm.EDIestado EQ 0><!---►Digitación--->		
	  				<input type="button" class="btnGuardar" name="btnAgregaDetalles" value="Modificar detalles" onClick="javascript: if(validaDetalles()) funcAgregaDetalles(<cfoutput>#form.EDIid#</cfoutput>)">
				</cfif>
            </td>
		</tr>
	</table>
</form>

<script type="text/javascript" language="javascript1.2">
	function funcEliminar(paramLinea,paramDcto){
		if ( confirm('Desea eliminar el registro?') ){ 
			document.ListaDetalle.DDlinea.value = paramLinea;
			document.ListaDetalle.EDIid.value = paramDcto;
			document.ListaDetalle.action = 'EDocumentosI-sql.cfm'; 
			document.ListaDetalle.submit();
		}
	}
		
	function funcAgregaDetalles(paramIDdocumento){	
		document.ListaDetalle.action = 'EDocumentosI-GuardarDetalles.cfm' 
		document.ListaDetalle.submit();
	}
	
	//Cargar los datos en la pantalla en modo cambio
	function funcCargar(paramLinea){
		document.ListaDetalle.DDlinea.value = paramLinea;
		document.ListaDetalle.action = 'EDocumentosI.cfm';
		document.ListaDetalle.submit();
	}

	function totalLinConDesc(paramLinea){
		var value1 = parseFloat(qf(document.ListaDetalle['DDIcantidad_'+paramLinea].value));
		var value2 = parseFloat(qf(document.ListaDetalle['DDIpreciou_'+paramLinea].value));	
		var totalPagar = value1*value2;
		
		<cfif rsForm.EDItipo EQ 'N'>
			//Para la Nota de Credito
			if(value1 == 0 && value2 > 0){
				totalPagar	= value2;
			}
		</cfif>
		
		document.ListaDetalle['DDItotallinea_'+paramLinea].value = totalPagar;
		document.ListaDetalle['DDItotallineaCD_'+paramLinea].value = redondear(totalPagar - qf(document.ListaDetalle['Mtodesc_'+paramLinea].value),2);
		fm(document.ListaDetalle['DDItotallineaCD_'+paramLinea],2);
	}
	function validaDetalles(){
		var monto = 0;
		<cfoutput query="rsListaItems">
			monto = parseFloat(qf(document.ListaDetalle.DDItotallineaCD_#rsListaItems.DDlinea#.value));
			if(monto <= 0){
				alert("Los totales de línea deben ser mayores a 0");
				return false;
			}else{
				totalLinConDesc('#rsListaItems.DDlinea#');
			}
			<cfif rsListaItems.EDItipo EQ 'F'>
				monto = parseFloat(qf(document.ListaDetalle.DDIcantidad_#rsListaItems.DDlinea#.value));			
				if(monto <= 0){
					alert("La cantidad de las líneas deben ser mayores a 0");
					return false;
				}			
			</cfif>
		</cfoutput>
		return true;
	}		
</script>