<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfif isdefined("url.DOlinea") and len(trim(url.DOlinea))>
	<cfset form.DOlinea = url.DOlinea>
</cfif>
<cfparam name="dmodo" default="ALTA">
<cfif isdefined("form.DDlinea") and len(trim(form.DDlinea))>
	<cfset dmodo = "CAMBIO">
</cfif>

<!--- Consultas --->
<cfif (dmodo EQ "CAMBIO")><!----Modo cambio de la linea seleccionada----->
	<!--- Detalle de la Línea --->
	<cfquery name="rsLinea" datasource="#Session.DSN#">
		Select 	Ucodigo, 
				DDlinea, 
				DDIconsecutivo, 
				dd.EDIid, 
				dd.Ecodigo, 
				dd.DOlinea, 
				dd.Icodigo, 
				Idescripcion,
				coalesce(DDIcantidad,0) as DDIcantidad, 
				DDItipo, 
				dd.Cid, 
				dd.Aid,
			 	#LvarOBJ_PrecioU.enSQL_AS("DDIpreciou")#, 
				cantidadrestante,				 
				montorestante, 				
				dd.CFcuenta, 
				DDIafecta, 
				DDIobs, 
				ETidtracking, 
				dd.EPDid, 
				dd.ts_rversion,
				coalesce(dd.DDIporcdesc,0) as DDIporcdesc,
				coalesce(DDItotallinea,0) as DDItotallinea,
				((coalesce(DDIpreciou,0) * coalesce(DDIcantidad,0))*(coalesce(DDIporcdesc,0))) /100 as Mtodesc
		From DDocumentosI dd
			inner join EDocumentosI ed
				on dd.EDIid=ed.EDIid
					and dd.Ecodigo=ed.Ecodigo
			left outer join Impuestos im
				on dd.Icodigo=im.Icodigo
					and dd.Ecodigo=im.Ecodigo
		where dd.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and dd.EDIid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDIid#">
			and dd.DDlinea=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DDlinea#">			
	</cfquery>

	<cfset tsDet = "">	
	<cfinvoke 
		component="sif.Componentes.DButils"
		method="toTimeStamp"
		returnvariable="tsDet">
		<cfinvokeargument name="arTimeStamp" value="#rsLinea.ts_rversion#"/>
	</cfinvoke>
</cfif>

<!--- Viene de una poliza de desalmacenaje --->
<cfif isdefined('form.EPDid_DP') and form.EPDid_DP NEQ ''>
	<cfquery name="rsPolizaImpuestos" datasource="#session.DSN#">
		Select distinct rtrim(di.DIcodigo) as DIcodigo
		FROM DImpuestos di
		where di.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and exists (
						  select 1
						  from DPolizaDesalmacenaje d
						  where d.Ecodigo=di.Ecodigo
								and d.Icodigo=di.Icodigo 
								and d.EPDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EPDid_DP#">
						 )
		union
		Select distinct rtrim(i.Icodigo) as DIcodigo
		FROM Impuestos i
		where i.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and exists (
						  select 1
						  from DPolizaDesalmacenaje d
						  where d.Ecodigo=i.Ecodigo
							and d.Icodigo=i.Icodigo 
							and d.EPDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EPDid_DP#">
						 )


	</cfquery>
</cfif>

<cfquery name="rsConversion" datasource="#session.DSN#">
	select Ucodigo, Ucodigoref, CUfactor 
	from ConversionUnidades 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfquery name="rsConversionArt" datasource="#session.DSN#">
	select distinct b.Aid, b.Adescripcion, b.Ucodigo, c.Ucodigo as Ucodigoref, CUAfactor
	from Articulos b
		inner join ConversionUnidadesArt c
			on b.Aid = c.Aid
	where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif isdefined("rsLinea") and len(trim(rsLinea.Aid)) gt 0>
		and b.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLinea.Aid#">
		<cfelse>
		and b.Aid is null
		</cfif>
	order by b.Aid
</cfquery>

<cfoutput>
	<script language="javascript" type="text/javascript">
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
</cfoutput>


<!---Unidades de Medida--->
<cfquery name="rsUMedida" datasource="#Session.DSN#">
	select Ucodigo,Udescripcion
	from Unidades
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!---Impuestos--->
<cfif dmodo EQ 'ALTA'>
	<cfquery name="rsImpuestos" datasource="#Session.DSN#">
		select Icodigo, Idescripcion 
		from Impuestos 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			<!---and Icodigo not in (
				Select distinct Icodigo
				from DDocumentosI dd
					inner join EDocumentosI ed
						on dd.Ecodigo=ed.Ecodigo
							and dd.EDIid=ed.EDIid
				where dd.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and ed.EDIestado in (0, 10)
					and dd.EDIid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDIid#">
					<cfif dmodo NEQ 'ALTA'>
						and DDlinea <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DDlinea#">
					</cfif>
					and Icodigo is not null
					<cfif isdefined("form.EPDid_DP") and len(trim(form.EPDid_DP)) gt 0>
					and dd.EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EPDid_DP#">
					</cfif>
				)--->
		order by Idescripcion
	</cfquery>
</cfif>

<cfoutput>
	<!---Utilidades de Montos y Números--->
	<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>

	<form name="formDocDet" method="post" action="EDocumentosI-sql.cfm" onSubmit="javascript: return validaDet();">
		<table width="100%" border="0">
          <tr>
            <td width="52%" valign="top">
			<table width="100%"  border="0">
              <tr>
                <td width="39%" align="right"><strong>Afecta:</strong></td>
                <td width="61%">				
					<table><tr><td>
					<cfif dmodo neq 'ALTA'>
						<input name="DDIafecta" type="hidden" value="#rsLinea.DDIafecta#">
						<cfif rsLinea.DDIafecta EQ 1>
							Fletes
						<cfelseif rsLinea.DDIafecta EQ 2>
							Seguros
						<cfelseif rsLinea.DDIafecta EQ 3>
							Costos
						<cfelseif rsLinea.DDIafecta EQ 4>
							Gastos
						<cfelseif rsLinea.DDIafecta EQ 5>
							Impuestos
						</cfif>
					<cfelse>
						<select name="DDIafecta" tabindex="14" id="DDIafecta" onChange="javascript: cambioAfecta(this);">
                                <option value="1" >Fletes</option>
                                <option value="2" >Seguros</option>
                                <option value="4" >Gastos</option>
							<cfif not isdefined('form.EPDid_DP')>
							  	<option value="3" >Costos</option>
							<cfelseif len(trim(rsForm.EDItipo)) and rsForm.EDItipo EQ 'F'>							  							  
							  	<option value="5" >Impuesto</option>
							</cfif>
						</select>
					</cfif>
					</td>	
					</tr></table>
				</td>
              </tr>
              <tr>
                <td align="right">
					<strong>
						<div id="divL-t" style="display: none ;" >
							Línea:			
						</div>
						<div id="divC-t" style="display: none ;" >
							Concepto:
						</div>			
						<div id="divI-t" style="display: none ;" >
							Impuesto:
						</div>									
					</strong>				
				</td>
                <td>
					<div id="divL" style="display: none ;" >
						<cfif dmodo NEQ 'ALTA' and rsLinea.DOlinea NEQ ''>							
							<cfquery datasource="#session.dsn#" name="rsLin"> 
								Select DOlinea, DOdescripcion, EOidorden
								from DOrdenCM
								where DOlinea = <cfqueryparam value="#rsLinea.DOlinea#" cfsqltype="cf_sql_numeric">								
							</cfquery>
						</cfif>
						<input disabled  readonly="" type="text" size="30" name="DOobservaciones" value="<cfif isdefined("rsLin") and len(trim(rsLin.DOdescripcion))>#rsLin.DOdescripcion#</cfif>">						
						<input type="hidden" name="EOidorden"  value="<cfif isdefined("rsLin") and len(trim(rsLin.EOidorden))>#rsLin.EOidorden#</cfif>" >
						<input type="hidden" name="DOlinea" value="<cfif isdefined("rsLin") and len(trim(rsLin.DOlinea))>#rsLin.DOlinea#</cfif>">
						<a href="##"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Ordenes de Compra" name="OCimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisLinea();'></a>						
					</div>
					<div id="divC" style="display: none ;" >
						<cfif dmodo neq 'ALTA' and isdefined("rsLinea") and len(trim(rsLinea.Cid)) gt 0>
							<cfquery datasource="#session.DSN#" name="rsConceptos">
								select Cid, Ccodigo, Cdescripcion as CdescripcionConc 
								from Conceptos
								where Cid =	<cfqueryparam value="#rsLinea.Cid#" cfsqltype="cf_sql_numeric">
							</cfquery>
						</cfif>

						<cfif dmodo eq 'ALTA' or not isdefined("rsConceptos") or rsConceptos.RecordCount eq 0>
							<cf_sifconceptos desc="CdescripcionConc" tabindex="16" form="formDocDet" filtroextra="and Cimportacion = 1">
						<cfelse>
							<cf_sifconceptos desc="CdescripcionConc" tabindex="16" form="formDocDet" filtroextra="and Cimportacion = 1" query="#rsConceptos#">
						</cfif>
					</div>
	
					<div id="divI" style="display: none ;" >
						<cfif dmodo NEQ 'ALTA'>
							<cfif isdefined('rsLinea') and rsLinea.Icodigo NEQ ''>
								<cfquery name="rsImpuestos2" datasource="#Session.DSN#">
									select rtrim(Icodigo) as Icodigo, Idescripcion
									from Impuestos
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
										and Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsLinea.Icodigo#">
								</cfquery>
							</cfif>
							
							<input type="hidden" name="Icodigo" value="<cfif isdefined('rsImpuestos2') and rsImpuestos2.Icodigo NEQ ''>#rsImpuestos2.Icodigo#</cfif>">
							<cfif isdefined('rsImpuestos2') and rsImpuestos2.Idescripcion NEQ ''>#rsImpuestos2.Idescripcion#</cfif>						
						<cfelse>
                        	 <cf_conlis
                                Campos="Icodigo,Idescripcion"
                                tabindex="6"
                                Desplegables="S,S"
                                Modificables="S,N"
                                Size="15,35"
                                Title="Lista de Impuestos"
                                Tabla="Impuestos c"
                                Columnas="Icodigo,Idescripcion"
                                Filtro="Ecodigo = #Session.Ecodigo# and Icompuesto = 0 order by Idescripcion"
                                Desplegar="Icodigo,Idescripcion"
                                Etiquetas="Código,Descripción"
                                filtrar_por="Icodigo,Idescripcion"
                                Formatos="S,S"
                                form="formDocDet"
                                Align="left,left"
                                Asignar="Icodigo,Idescripcion"
                                Asignarformatos="S,S"
                                />
						</cfif>
                        
					</div>											
				</td>
              </tr>              
			  <tr>
				<td>&nbsp;</td>
				<td style="vertical-align:top ">
					<cfif dmodo NEQ 'ALTA' and rsLinea.DDIafecta EQ 3 and rsForm.EDItipo neq 'N'>
						<strong><input onClick="javascript: funcCambiaTracking();" type="checkbox" name="chktracking" value="" <cfif dmodo NEQ 'ALTA' and len(trim(rsLinea.ETidtracking))>checked</cfif>><label for="chktracking">Agregar a tracking existente</label></strong>
					</cfif>
				</td>
			  </tr>
			  <tr id="divT" style="display:<cfif not isdefined('form.EPDid_DP') and (dmodo eq 'ALTA' or (dmodo neq 'ALTA' and (len(trim(rsLinea.ETidtracking)) or rsLinea.DDIafecta eq 1 or rsLinea.DDIafecta eq 2)))>''<cfelse>'none'</cfif>">
				<td align="right" nowrap><strong>Tracking:</strong></td>
				<td nowrap>
					<cfif (dmodo EQ "CAMBIO") and rsLinea.ETidtracking NEQ ''>					
						<cfquery name="rsTracking" datasource="sifpublica">
							select 	ETidtracking,
									ETnumtracking,
									ETconsecutivo
							from ETracking
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							  and ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLinea.ETidtracking#">
						</cfquery>
					</cfif>
					<input type="hidden" name="ETidtracking_move1" value="<cfif isdefined("rsTracking")>#rsTracking.ETidtracking#</cfif>">
					<input type="text" size="10" name="ETconsecutivo_move1" onKeyUp="javascript: this.value = ''; document.formDocDet.ETidtracking_move1.value = ''; document.formDocDet.ETnumtracking_move1.value = '';" value="<cfif isdefined('rsTracking')>#rsTracking.ETconsecutivo#</cfif>">
					<input type="text" size="30" readonly name="ETnumtracking_move1" value="<cfif isdefined('rsTracking')>#rsTracking.ETnumtracking#</cfif>">
					<cfif dmodo EQ "ALTA" or (rsLinea.DDIafecta EQ 3 or rsLinea.DDIafecta EQ 1 or rsLinea.DDIafecta EQ 2)>
						<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Trackins" name="OCimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisTrackings(1);'></a>
					</cfif>
				</td>
			  </tr>				 				 
              <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>
            </table>
			</td>
            <td width="48%" valign="top"><table width="100%" border="0">
              <tr>
                <td width="31%" align="right"><strong>Cantidad:</strong></td>
                <td colspan="2">
					<input name="DDIcantidad" onFocus="javascript:this.select(); ultimoParamCambio='C';" type="text" style="text-align:right" onBlur="javascript:fm(this,2);funcRecalculaMtos('C');" onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13'){this.blur()};}" value="<cfif (dmodo EQ "CAMBIO")>#LSNumberFormat(rsLinea.DDIcantidad,',9.00')#<cfelse>0.00</cfif>" size="18" maxlength="18">
				</td>
              </tr>
              <tr>
                <td align="right" nowrap><strong>Precio Unitario:</strong></td>
                <td width="25%"><input name="DDIpreciou" onFocus="javascript:this.select(); ultimoParamCambio='P';" type="text" style="text-align:right" onBlur="javascript:fm(this,#LvarOBJ_PrecioU.getDecimales()#);funcRecalculaMtos('P');" onKeyUp="if(snumber(this,event,#LvarOBJ_PrecioU.getDecimales()#)){ if(Key(event)=='13') {this.blur();}else{cambioDet(1);}}" value="<cfif (dmodo EQ "CAMBIO")>#LvarOBJ_PrecioU.enCF(rsLinea.DDIpreciou)#<cfelse>#LvarOBJ_PrecioU.enCF(0.00)#</cfif>" size="18" maxlength="18"></td>
                <td width="44%">
					<div id="obs">
						<strong>Observaciones:</strong>
						<a href="javascript:infoDet();">
							<img border="0" src="../../imagenes/iedit.gif" alt="<cfif modo eq 'ALTA'>Definir<cfelse>Ver/Modificar</cfif> Observaciones">
						</a>
					</div>
				</td>
              </tr>
			 <cfif dmodo NEQ 'ALTA' and isdefined('rsLinea') and rsLinea.recordCount GT 0 and rsLinea.DDIafecta EQ 3>
				  <tr id="uMedida">
					<td align="right" nowrap><strong>Unidad de Medida:</strong></td>
					<td>
						<select name="Ucodigo" id="Ucodigo" onChange="javascript: cambiaUnidad(); cambioDet(1);">
							<cfloop query="rsUMedida">
								<option value="#rsUMedida.Ucodigo#" <cfif rsUMedida.Ucodigo EQ rsLinea.Ucodigo> selected</cfif>>#rsUMedida.Udescripcion#</option>
							</cfloop>
						</select>
						<input type="hidden" name="UcodigoAnterior" value="#rsLinea.Ucodigo#">
					</td>
				  </tr>
			  </cfif>
            </table></td>
			<td  width="48%" valign="top">
				<table width="100%" border="0">
					<tr id="divDesc" style="display: 'none'">
						<td nowrap align="right"><strong>% Descuento:</strong></td>
						<td>
							<input size="10" maxlength="10" type="text" onFocus="javascript: this.select(); ultimoParamCambio='PD';" style="text-align:right" name="DDIporcdesc" value="<cfif dmodo NEQ "ALTA">#LSNumberFormat(rsLinea.DDIporcdesc,',9.0000')#<cfelse>0.00</cfif>"  align="right" onBlur="javascript:fm(this,4);funcRecalculaMtos('PD');" onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}">
							<input type="hidden" name="DDIporcdescTMP" value="<cfif dmodo NEQ "ALTA">#rsLinea.DDIporcdesc#</cfif>">
						</td>
					</tr>
					<tr id="divMto" style="display: 'none' ">						
						<td nowrap align="right"><strong>Monto descuento:</strong></td>
						<td><input size="18" maxlength="18" type="text" onFocus="javascript: this.select(); ultimoParamCambio='MD';" style="text-align:right" name="Mtodesc" value="<cfif dmodo NEQ "ALTA">#LSNumberFormat(rsLinea.Mtodesc,',9.0000')#<cfelse>0.00</cfif>" align="right" onBlur="javascript:fm(this,4); funcRecalculaMtos('MD');" onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}"></td>						
					</tr>
					<tr>
						<td align="right" nowrap><strong>Total línea:</strong></td>
						<td colspan="2"><input name="DDItotallinea" type="text" style="text-align:right" value="<cfif dmodo NEQ "ALTA">#LSNumberFormat(rsLinea.DDItotallinea,',9.00')#<cfelse>0.00</cfif>" size="18" maxlength="18" onFocus="javascript:this.select(); ultimoParamCambio='T';" onBlur="javascript:fm(this,2); funcRecalculaMtos('T');"></td> 
					  </tr>
					<tr>
				</table>
			</td>
          </tr>
          <tr>
            <td colspan="3" align="center" valign="baseline">
				<cfif rsForm.EDIestado EQ 0><!---►Digitación--->		
					<cfif dmodo NEQ 'ALTA' >
                        <input type="submit" class="btnGuardar"  name="btnModificarD"  value="Modificar"		tabindex="22">
                        <input type="submit" class="btnNuevo"    name="btnNuevoD"  	   value="Nuevo Detalle" 	tabindex="23" 	onClick="javascript: validarDet=false; return true;">
                        <input type="submit" class="btnEliminar" name="btnBorrarD"     value="Borrar Detalle" 	tabindex="24"   onClick="javascript:if ( confirm('Desea eliminar esta linea de detalle de la factura ?') ){validarDet=false; return true;} return false;" >
                    <cfelse>
                        <input type="submit" class="btnGuardar"  name="btnAgregarD"    value="Agregar" 			tabindex="22" >
                        <input type="reset"  class="btnLimpiar"  name="btnLimpiarD"    value="Limpiar" 			tabindex="23" >					
                    </cfif>	
                </cfif>		
			</td>
          </tr>
        </table>

      <!--- Campos ocultos --->
		<cfif dmodo NEQ 'ALTA'>			
			<input name="DDIconsecutivo" type="hidden" value="#rsLinea.DDIconsecutivo#">
			<input name="ts_rversionDet" type="hidden" value="#tsDet#">
			<input name="DDlinea" type="hidden" value="#rsLinea.DDlinea#">
		</cfif>
		<cfif isdefined('form.EPDid_DP')>
			<input type="hidden" name="EPDid_DP" value="#form.EPDid_DP#">
		</cfif>
		<input type="hidden" name="DDIobs" value="<cfif dmodo neq 'ALTA'>#trim(rsLinea.DDIobs)#</cfif>">
		<input name="Mcodigo" type="hidden" value="#rsForm.Mcodigo#">
		<input name="EOidorden" type="hidden" value="-1">
		<input name="EDIid" type="hidden" value="#form.EDIid#">
		<input name="EDItc" type="hidden" value="#rsForm.EDItc#">		
		<input name="btnAgregar2" type="hidden" value="0">
		<input name="cantidadrestante" type="hidden" value="<cfif dmodo NEQ 'ALTA'>#LSCurrencyFormat(rsLinea.cantidadrestante,'none')#<cfelse>0.00</cfif>">				
		<input name="montorestante" type="hidden" value="<cfif dmodo NEQ 'ALTA'>#LSCurrencyFormat(rsLinea.montorestante,'none')#<cfelse>0.00</cfif>">					
		<input name="DDItipo" type="hidden" value="<cfif dmodo NEQ 'ALTA'>#rsLinea.DDItipo#</cfif>">
		<input name="Aid" type="hidden" value="<cfif dmodo NEQ 'ALTA'>#rsLinea.Aid#</cfif>">		
	</form>
</cfoutput>

<iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>

<!---JavaScript--->
<script language="javascript1.2" type="text/javascript">
	<cfif isdefined('form.EPDid_DP')>
		var div_T = document.getElementById("divT");
		div_T.style.display = 'none';
		document.formDocDet.ETidtracking_move1.value = '';
		document.formDocDet.ETconsecutivo_move1.value = '';
		document.formDocDet.ETnumtracking_move1.value = '';
	</cfif>
	
	function doConlisTrackings(valor) {
		var params ='';
		var tmp = '<cfoutput>#rsForm.EDItipo#</cfoutput>';
		
		params="&validaFacturado=1";
		
		<cfif isdefined('form.EPDid_DP')>
		if (tmp == 'N' && (document.formDocDet.DDIafecta.value == 1 || document.formDocDet.DDIafecta.value == 2)){
			params = params + "&DetalleTransito=1";
		}
		</cfif>
		
		popUpWindow("/cfmx/sif/cm/proveedor/ConlisTrackings.cfm?nameForm=formDocDet&idx="+valor+"&validaPoliza=1"+params,30,100,950,500);		
	}

	function traeTracking(value,index){
	  if (value!=''){	    
	   document.getElementById("fr").src = '/cfmx/sif/cm/proveedor/traerTracking.cfm?ETconsecutivo='+value+'&index='+index+'&nameForm=formDocDet';
	  }else{
	   document.formDocDet.ETidtracking_move1.value = '';
	   document.formDocDet.ETconsecutivo_move1.value = '';
	   document.formDocDet.ETnumtracking_move1.value = '';
	  }
	 }	 
	
	<!---
	function cambioUMedida(objeto){
		<cfif dmodo NEQ 'ALTA'>
			var valAct = '<cfoutput>#rsLinea.Ucodigo#</cfoutput>';		
			var precioUAct = '<cfoutput>#rsLinea.DDIpreciou#</cfoutput>';					
		<cfelse>
			var valAct = -1;
			var precioUAct = 0;
		</cfif>

		if (valAct != -1){
			if(valAct != objeto.value){
				objeto.form.DDIpreciou.value=0;
			}else{
				objeto.form.DDIpreciou.value=precioUAct;
			}
		}
		
		funcRecalculaMtos('C');
	}
	--->
	
	function infoDet(){
		open('EDocumentosI-Det-info.cfm', 'documentos', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width=600,height=420,left=250, top=200,screenX=250,screenY=200');
	}
	
	function cambioDet(opc){
		var div_obs   = document.getElementById("obs");
		
		if(opc == 1){
			<cfif dmodo NEQ 'ALTA'>
				div_obs.style.display = '';		
			</cfif>
		}else{
			div_obs.style.display = 'none';		
		}
	}

	function cambioAfecta(obj){
		var usaPoliza = true;
		var div_C   	= document.getElementById("divC");
		var div_L   	= document.getElementById("divL");
		var div_I   	= document.getElementById("divI");
		//var div_T 		= document.getElementById("divT");
		var div_C_t   	= document.getElementById("divC-t");
		var div_L_t   	= document.getElementById("divL-t");
		var div_I_t   	= document.getElementById("divI-t");
		var div_Mto		= document.getElementById("divMto");
		var div_Desc	= document.getElementById("divDesc");
		<cfif dmodo EQ 'ALTA'>
			document.formDocDet.ETidtracking_move1.value = '';
			document.formDocDet.ETconsecutivo_move1.value = '';
			document.formDocDet.ETnumtracking_move1.value = '';
		</cfif>
		//if (usaPoliza)
			//var div_Poliza = document.getElementById("Poliza");
		switch ( obj.value ) {
		   case '1':	//Fletes
			   div_L.style.display = 'none';
			   div_C.style.display = '';
			   div_I.style.display = 'none';
			   div_L_t.style.display = 'none';
			   div_C_t.style.display = '';
			   div_I_t.style.display = 'none';
			   div_Mto.style.display = '';
			   div_Desc.style.display = '';
			   //div_T.style.display = '';
		   		//if (usaPoliza)
	   			   //div_Poliza.style.display = 'none';
			   <cfif dmodo EQ 'ALTA'>
			   	  document.formDocDet.DDItipo.value="S";
			   </cfif>
			   <cfif dmodo eq 'ALTA' and isdefined('form.EPDid_DP')>
			   document.formDocDet.Icodigo.value = "";
			   </cfif>
			   //document.formDocDet.Cid.value="";
			   //document.formDocDet.DDIcantidad.disabled=false;
			   break;		
		   case '2':	//Seguros
			   div_L.style.display = 'none';
			   div_C.style.display = '';
			   div_I.style.display = 'none';
			   div_L_t.style.display = 'none';
			   div_C_t.style.display = '';
			   div_I_t.style.display = 'none';
			   div_Mto.style.display = '';
			    div_Desc.style.display = '';
			   //div_T.style.display = '';
				//if (usaPoliza)			   
				   //div_Poliza.style.display = 'none';
			   <cfif dmodo EQ 'ALTA'>
			   	  document.formDocDet.DDItipo.value="S";
			   </cfif>
			   <cfif dmodo eq 'ALTA' and isdefined('form.EPDid_DP')>
			   document.formDocDet.Icodigo.value = "";
			   </cfif>
			   //document.formDocDet.Cid.value="";
			   //document.formDocDet.DDIcantidad.disabled=false;
			   break;
		   case '3' :	//Costo
			   div_L.style.display = '';
			   div_C.style.display = 'none';
			   div_I.style.display = 'none';
			   div_L_t.style.display = '';
			   div_C_t.style.display = 'none';
			   div_I_t.style.display = 'none';
			   div_Mto.style.display = '';
			   div_Desc.style.display = '';
			 <!---- <cfif dmodo NEQ 'ALTA'>----->
				  // div_T.style.display = '';
			   <!----<cfelse>---->
					//div_T.style.display = 'none';		
			   <!----</cfif>---->
		   		//if (usaPoliza)   
				   //div_Poliza.style.display = 'none';	      
			   <cfif dmodo EQ 'ALTA'>
			   	  document.formDocDet.DDItipo.value="A";
			   </cfif>
			   <cfif dmodo eq 'ALTA'>
			   document.formDocDet.Cid.value = "";
			   document.formDocDet.Ccodigo.value = "";
			   document.formDocDet.CdescripcionConc.value = "";
			   </cfif>
			   <cfif dmodo eq 'ALTA' and isdefined('form.EPDid_DP')>
			   document.formDocDet.Icodigo.value = "";
			   </cfif>
			   //document.formDocDet.DDIcantidad.disabled=false;
			   break;
		   case '4' :	//Gasto
			   div_L.style.display = 'none' ;
			   div_C.style.display = '' ;
			   div_I.style.display = 'none' ;
			   div_L_t.style.display = 'none';
			   div_C_t.style.display = '';
			   div_I_t.style.display = 'none';
			   div_Mto.style.display = '';
			    div_Desc.style.display = '';
			   //div_T.style.display = 'none';
			   //if (usaPoliza)
				   //div_Poliza.style.display = '';
			   <cfif dmodo EQ 'ALTA'>
			   	  document.formDocDet.DDItipo.value="S";
			   </cfif>
			   <cfif dmodo eq 'ALTA' and isdefined('form.EPDid_DP')>
			   document.formDocDet.Icodigo.value = "";
			   </cfif>
			   //document.formDocDet.DDIcantidad.disabled=true;
			   //document.formDocDet.DDIcantidad.value=1;			   
			   break;
		   case '5' :	//Impuesto
			   div_L.style.display = 'none' ;
			   div_C.style.display = 'none' ;
			   div_I.style.display = '' ;
			   div_L_t.style.display = 'none';
			   div_C_t.style.display = 'none';
			   div_I_t.style.display = '';
			   //div_T.style.display = 'none';		
			   div_Mto.style.display = 'none';	
			    div_Desc.style.display = 'none';		 		  
			   //if (usaPoliza)
				   //div_Poliza.style.display = '';				
			   document.formDocDet.DDItipo.value="S";
			   <cfif dmodo eq 'ALTA'>
			   document.formDocDet.Cid.value = "";
			   document.formDocDet.Ccodigo.value = "";
			   document.formDocDet.CdescripcionConc.value = "";
			   </cfif>
			  //document.formDocDet.DDIcantidad.disabled=true;
			   //document.formDocDet.DDIcantidad.value=1;
			   break;			   
		  default :
			   div_C.style.display = '' ;
			   div_L.style.display = 'none' ;
			   div_I.style.display = 'none' ;
			   div_C_t.style.display = '' ;
			   div_L_t.style.display = 'none' ;
			   div_I_t.style.display = 'none' ;
			   div_Mto.style.display = '';
			    div_Desc.style.display = '';
			   //div_T.style.display = 'none';
		   		//if (usaPoliza)
				   //div_Poliza.style.display = 'none';
			   document.formDocDet.DDItipo.value="S";
			   document.formDocDet.Aid.value="";
   			   //document.formDocDet.DDIcantidad.disabled=true;
   			   document.formDocDet.DDIcantidad.value=1;   
		}		
	}
	
	function preparaMontos(){
		document.formDocDet.DDIcantidad.value = qf(document.formDocDet.DDIcantidad.value);
		document.formDocDet.DDIpreciou.value = qf(document.formDocDet.DDIpreciou.value);
		document.formDocDet.DDIporcdesc.value = qf(document.formDocDet.DDIporcdesc.value);
		document.formDocDet.DDItotallinea.value = qf(document.formDocDet.DDItotallinea.value);
		document.formDocDet.cantidadrestante.value = qf(document.formDocDet.cantidadrestante.value);
		document.formDocDet.montorestante.value = qf(document.formDocDet.montorestante.value);
		document.formDocDet.DDIcantidad.disabled = false;
	}
	
	var validarDet = true;
	function validaDet(){
		if(ultimoParamCambio != "")
			funcRecalculaMtos(ultimoParamCambio);
		if (validarDet){
			var error = false;
			var mensaje = "Se presentaron los siguientes errores:\n";
			// Validacion de Encabezado	
			<cfif dmodo NEQ 'ALTA' and rsLinea.DDIafecta EQ 3>
				if (document.formDocDet.chktracking.checked){
					if (document.formDocDet.ETconsecutivo_move1.value ==''){
						error = true;
						mensaje += " - No ha seleccionado el tracking.\n";
					}
				}
			</cfif>
					
			<cfif dmodo NEQ 'ALTA'>
					if ( trim(document.formDocDet.DDlinea.value) == '' ){
						error = true;
						mensaje += " - No existe el código del detalle de la factura .\n";
					}		
		
					if ( trim(document.formDocDet.DDIconsecutivo.value) == '' ){
						error = true;
						mensaje += " - No existe el Consecutivo del detalle de la factura .\n";
					}			
			</cfif>		
		
			if ( new Number(qf(document.formDocDet.DDItotallinea.value)) == 0){
				error = true;
				alert("El total de la línea no puede ser cero");
			}
		
			if ( trim(document.formDocDet.DDItipo.value) == '' ){
				error = true;
				mensaje += " - El Tipo para el detalle no se cargó.\n";
			}else{
				if(trim(document.formDocDet.DDItipo.value) == 'A'){
					if ( trim(document.formDocDet.Aid.value) == '' ){
						error = true;
						mensaje += " - No existe codigo del articulo en la linea .\n";
					}
				}else{
					if(document.formDocDet.DDItipo.value == 'S'){
						/*if ( trim(document.formDocDet.DDIafecta.value) != 5 && trim(document.formDocDet.DDIafecta.value) != 1 && trim(document.formDocDet.DDIafecta.value) != 2){	//Si no es igual a Impuesto y a Fletes*/
						if ( trim(document.formDocDet.DDIafecta.value) == 1 || trim(document.formDocDet.DDIafecta.value) == 2 || trim(document.formDocDet.DDIafecta.value) == 4){
							if ( trim(document.formDocDet.Cid.value) == '' ){
								error = true;
								mensaje += " - El código del concepto es requerido .\n";
							}
						} 
					}
				}
			}
			
			<cfif not isdefined('form.EPDid_DP')>
				if (document.formDocDet.DDIafecta.value == 5){
					if ( trim(document.formDocDet.EPDid.value) == '' ){
						error = true;
						mensaje += " - El campo Póliza es requerido .\n";
					}
				}
			</cfif>
			
			if ( trim(document.formDocDet.EDIid.value) == '' ){
				error = true;
				mensaje += " - No existe el código del encabezado de la factura .\n";
			}
			
			if (document.formDocDet.DDIafecta.value == 5 && trim(document.formDocDet.Icodigo.value) == '' ){
				error = true;
				mensaje += " - El campo Impuesto es requerido.\n";
			}

			<cfif rsForm.EDItipo eq 'F'>
			if ( new Number(qf(document.formDocDet.DDIcantidad.value)) <= 0 ){	
				error = true;
				mensaje += " - El campo Cantidad es requerido.\n";
			}
			</cfif>

			if ( new Number(qf(document.formDocDet.DDIpreciou.value)) <= 0 ){			
				error = true;
				mensaje += " - El campo Precio Unitario es requerido.\n";
			}

			if ( new Number(qf(document.formDocDet.DDItotallinea.value)) <= 0 ){			
				error = true;
				mensaje += " - El Total de la linea es requerido.\n";
			}

			if ( trim(document.formDocDet.DDIafecta.value) == '' ){
				error = true;
				mensaje += " - El campo Afecta es requerido.\n";
			}


			<!--- Viene de una poliza de desalmacenaje. Validacion solamente para cuando es un impuesto --->
			if(document.formDocDet.DDIafecta.value == '5'){
				<cfif isdefined('form.EPDid_DP') and form.EPDid_DP NEQ ''>
					<cfif isdefined('rsPolizaImpuestos') and rsPolizaImpuestos.recordCount GT 0>
						<cfset listaCodsImpuestos = ValueList(rsPolizaImpuestos.DIcodigo)>
						var existeImp = false;
						var columnas = "<cfoutput>#listaCodsImpuestos#</cfoutput>";
						var arrCodsImp = columnas.split(',');
					
						//PARA CADA UNA OBTENGO EL VALOR CORRESPONDIENTE
						for(var i=0; i < arrCodsImp.length; i++){
							if(arrCodsImp[i] == document.formDocDet.Icodigo.value){
								existeImp = true;
								break;
							}
						}		
						
						if(!existeImp){
							error = true;
							mensaje += " - El impuesto indicado no pertenece a \n ninguno de los códigos aduanales \n de los artículos del detalle de la póliza.";									
						}
					<cfelse>
						error = true;
						mensaje += " - No existen impuestos que pertenezcan a \n ninguno de los códigos aduanales \n de los artículos del detalle de la póliza.";				
					</cfif>			
				</cfif>
			}
			
			if ( error ){
				alert(mensaje);
				return false;
			}else{
				preparaMontos();
				return true;
			}
		}else{
			preparaMontos();
			return true;					
		}
	}
	
	cambioAfecta(document.formDocDet.DDIafecta);
	<cfif dmodo EQ 'ALTA'>
		document.formDocDet.DDIafecta.focus();
		cambioDet(2);//Apagar
	<cfelse>
		if(document.formDocDet.DDIobs.value != ''){
			cambioDet(1);//Prender
		}else{
			cambioDet(2);//Apagar
		}
	</cfif>
	
	var ultimoParamCambio = "";
	//Recalcular valores
	function funcRecalculaMtos(paramCambio){
		//Valores de paramCambio: MD=Monto de descuento
		//						  PD=Porcentaje descuento
		//						  P=Precio		
		//						  T= Total de la linea	
		
		if(parseFloat(qf(document.formDocDet.DDIcantidad.value)) < 0.00)
		{
			alert("La cantidad no puede ser negativa");
			document.formDocDet.DDIcantidad.value = document.formDocDet.DDIcantidad.value * -1;
			fm(document.formDocDet.DDIcantidad,2);
		}
		if(parseFloat(qf(document.formDocDet.DDIpreciou.value)) < 0.00)
		{
			alert("El precio no puede ser negativo");
			document.formDocDet.DDIpreciou.value = document.formDocDet.DDIpreciou.value * -1;
			fm(document.formDocDet.DDIpreciou,<cfoutput>#LvarOBJ_PrecioU.getDecimales()#</cfoutput>);
		}
		if(parseFloat(qf(document.formDocDet.DDIporcdesc.value)) < 0.00)
		{
			alert("El porcentaje de descuento no puede ser negativo");
			document.formDocDet.DDIporcdesc.value = document.formDocDet.DDIporcdesc.value * -1;
			fm(document.formDocDet.DDIporcdesc,4);
			
			if(parseFloat(qf(document.formDocDet.DDIporcdescTMP.value)) < 0.00)
				document.formDocDet.DDIporcdescTMP.value = document.formDocDet.DDIporcdescTMP.value * -1;
		}
		if(parseFloat(qf(document.formDocDet.Mtodesc.value)) < 0.00)
		{
			alert("El monto de descuento no puede ser negativo");
			document.formDocDet.Mtodesc.value = document.formDocDet.Mtodesc.value * -1;
			fm(document.formDocDet.Mtodesc,4);
		}
		if(parseFloat(qf(document.formDocDet.DDItotallinea.value)) < 0.00)
		{
			alert("El total no puede ser negativo");
			document.formDocDet.DDItotallinea.value = document.formDocDet.DDItotallinea.value * -1;
			fm(document.formDocDet.DDItotallinea,2);
		}

		var vnCalculo = 0;		//Variable con el resultado del calculo que se realice según lo que se modificó (Precio,%desc,Mto.desc)
		var voVariable = '';
		var vnCantidad = parseFloat(qf(document.formDocDet.DDIcantidad.value));
		var vnPrecio =  parseFloat(qf(document.formDocDet.DDIpreciou.value));
		var vnTotalLinea = vnCantidad*vnPrecio;

		<cfif rsForm.EDItipo neq 'F'>
		if(vnCantidad == 0)
			vnTotalLinea = vnPrecio;
		</cfif>

		if ((parseFloat(vnTotalLinea) == 0 && paramCambio != 'T') || (parseFloat(document.formDocDet.DDItotallinea.value) == 0 && paramCambio == 'T')){
			//alert("El total de la línea no puede ser cero");
			document.formDocDet.Mtodesc.value = 0;
			document.formDocDet.DDIporcdesc.value = 0;
			document.formDocDet.DDIporcdescTMP.value = 0;
			document.formDocDet.DDItotallinea.value = 0;
			fm(document.formDocDet.Mtodesc,4);
			fm(document.formDocDet.DDIporcdesc,4);
			fm(document.formDocDet.DDItotallinea,2);
			if(parseFloat(document.formDocDet.DDItotallinea.value) == 0 && paramCambio == 'T')
			{
				document.formDocDet.DDIcantidad.value = 0;
				document.formDocDet.DDIpreciou.value = 0;
				fm(document.formDocDet.DDIcantidad,2);
				fm(document.formDocDet.DDIpreciou,<cfoutput>#LvarOBJ_PrecioU.getDecimales()#</cfoutput>);
			}
			return;
		}

		if (paramCambio == 'PD'){ //Calcular el monto desc. con base al % digitado
			voVariable = parseFloat(qf(document.formDocDet.DDIporcdesc.value));
			if(voVariable >= 100)
			{
				alert("El porcentaje de descuento debe ser menor a 100");
				voVariable = 0;
				document.formDocDet.DDIporcdesc.value = 0;
				document.formDocDet.DDIporcdescTMP.value = 0;
				fm(document.formDocDet.DDIporcdesc,4);

			}
			document.formDocDet.DDIporcdescTMP.value = voVariable;
			document.formDocDet.Mtodesc.value =  (vnTotalLinea*voVariable)/100;
			fm(document.formDocDet.Mtodesc,4);
		}
		if (paramCambio == 'MD'){//Calcular el % del descuento con base al mto digitado
			voVariable = parseFloat(qf(document.formDocDet.Mtodesc.value));						
			if(voVariable >= vnTotalLinea)
			{
				alert("El monto de descuento debe ser menor al subtotal");
				voVariable = 0;
				document.formDocDet.Mtodesc.value = 0;
				fm(document.formDocDet.Mtodesc,4);	
			}
			document.formDocDet.DDIporcdesc.value = (100*voVariable)/( ( vnTotalLinea == 0 ) ? 1 : vnTotalLinea );			
			document.formDocDet.DDIporcdescTMP.value = (100*voVariable)/ ( ( vnTotalLinea == 0 ) ? 1 : vnTotalLinea );
			fm(document.formDocDet.DDIporcdesc,4);	
		}	
		if (paramCambio == 'T'){//Recalcular el precio
			var voVariable2 = parseFloat(qf(document.formDocDet.Mtodesc.value));	
			voVariable = parseFloat(qf(document.formDocDet.DDItotallinea.value));
			<cfif rsForm.EDItipo neq 'F'>
			if(vnCantidad == 0)
				vnCalculo = voVariable+voVariable2;
			else
				vnCalculo = (voVariable+voVariable2)/vnCantidad;
			<cfelse>
			if(vnCantidad == 0)
			{
				vnCalculo = voVariable+voVariable2;
				document.formDocDet.DDIcantidad.value = 1;
				fm(document.formDocDet.DDIcantidad,2);
			}
			else
				vnCalculo = (voVariable+voVariable2)/vnCantidad;
			</cfif>
			document.formDocDet.DDIpreciou.value = vnCalculo;
			fm(document.formDocDet.DDIpreciou,<cfoutput>#LvarOBJ_PrecioU.getDecimales()#</cfoutput>);
			fm(document.formDocDet.DDItotallinea,2);
		}
		if (paramCambio == 'C' || paramCambio == 'P'){
			//Recalcular el monto descuento		
			voVariable = parseFloat(qf(document.formDocDet.DDIporcdesc.value));						
			document.formDocDet.Mtodesc.value =  (vnTotalLinea*voVariable)/100 
			fm(document.formDocDet.Mtodesc,4);
			//Recalcular porcentaje
			voVariable = parseFloat(qf(document.formDocDet.Mtodesc.value));			
			document.formDocDet.DDIporcdesc.value = (100*voVariable)/ ( ( vnTotalLinea == 0 ) ? 1 : vnTotalLinea );
			document.formDocDet.DDIporcdescTMP.value = (100*voVariable)/ ( ( vnTotalLinea == 0 ) ? 1 : vnTotalLinea );
			fm(document.formDocDet.DDIporcdesc,4);	
		}		
		//Actualizar el total
		if (paramCambio != 'T'){
			voVariable = parseFloat(qf(document.formDocDet.Mtodesc.value));
			document.formDocDet.DDItotallinea.value = vnTotalLinea - voVariable;
			fm(document.formDocDet.DDItotallinea,2);
		}
		
		ultimoParamCambio = paramCambio;
	}
		 
	function funcCambiaTracking(paramActivo){
		var div_T 		= document.getElementById("divT");
		if (document.formDocDet.chktracking.checked == true){
			div_T.style.display = '';
		}
		else{
			div_T.style.display = 'none';
			document.formDocDet.ETidtracking_move1.value = '';
			document.formDocDet.ETconsecutivo_move1.value = '';
			document.formDocDet.ETnumtracking_move1.value = '';
		}
	} 
	
	function doConlisLinea() {		
		var params = ''
		
		params = params+"&DDIafecta="+ document.formDocDet.DDIafecta.value+"&ETidtracking="+document.formDocDet.ETidtracking_move1.value;
		
		var tmp = '<cfoutput>#rsForm.EDItipo#</cfoutput>';
		if (tmp == 'N' && document.formDocDet.DDIafecta.value == 3){
			params = params+"&pNoVerificaCantidad=1";
		}

		<cfif isdefined("form.EPDid_DP")>
			tmp2 = '<cfoutput>#form.EPDid_DP#</cfoutput>';
		<cfelse>
			tmp2 = '';
		</cfif>
		if (tmp2 != '' || document.formDocDet.DDIafecta.value != 3 || tmp != 'F'){
			params = params + "&validaCantSurtida=1";
		}

		popUpWindow("/cfmx/sif/cm/operacion/ConlisLineaCompraTransaccionesC.cfm?EDIid=<cfoutput>#form.EDIid#</cfoutput>&SNcodigo="+
			document.form1.SNcodigo.value + params, 30,100,950,500);
	}
	
	function cambiaUnidad(){
		var f = document.formDocDet;
		var Aid = f.Aid.value;
		var Ucodigo = trim(f.UcodigoAnterior.value);
		var Ucodigoref = trim(f.Ucodigo.value);
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
				f.DDIcantidad.value = 0;
				fm(f.DDIcantidad, 2);
			}
			else{
				f.DDIcantidad.value = parseFloat(qf(f.DDIcantidad.value)) * factor;
				fm(f.DDIcantidad, 2);
			}
			alert('Debe digitar el nuevo el precio unitario para la factura');
			f.DDIpreciou.value = 0;
			fm(f.DDIpreciou, <cfoutput>#LvarOBJ_PrecioU.getDecimales()#</cfoutput>);
			f.DDIpreciou.focus();
		}
		else
			existe = true;
			
		f.UcodigoAnterior.value = f.Ucodigo.value;		
		funcRecalculaMtos('C');
	}
</script>
