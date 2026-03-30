<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Selecci&oacute;n Masiva de Documentos</title>
</head>
<body>

<cfif isdefined("url.btnCerrar")>
	<script language="javascript">
		opener.window.document.form1.F5.value = "F5";
		window.close();
	</script>
	<cfabort>
</cfif>
<cf_templatecss>
<!--- Pinta el Filtro --->
<cfif isdefined('url.SNcodigo') and not isdefined('form.SNCodigo')>
	<cfset form.SNcodigo = url.SNcodigo>
</cfif>
<cfif isdefined('url.CCTcodigo') and not isdefined('form.CCTcodigo')>
	<cfset form.CCTcodigo = url.CCTcodigo>
</cfif>
<cfif isdefined('url.Mcodigo') and not isdefined('form.Mcodigo')>
	<cfset form.Mcodigo = url.Mcodigo>
</cfif>
<cfif isdefined('url.Pcodigo') and not isdefined('form.Pcodigo')>
	<cfset form.Pcodigo = url.Pcodigo>
</cfif>
<cfif isdefined('url.Ddocumento') and not isdefined('form.Ddocumento')>
	<cfset form.Ddocumento = url.Ddocumento>
</cfif>
<cfif isdefined('url.pn_disponible') and not isdefined('form.pn_disponible')>
	<cfset form.pn_disponible = url.pn_disponible>
</cfif>
<cfif isdefined('url.option') and not isdefined('form.option')>
	<cfset form.option = url.option>
</cfif>
<cfif isdefined('url.id_direccion') and not isdefined('form.id_direccion')>
	<cfset form.id_direccion = url.id_direccion>
</cfif>
<cfif isdefined('url.Fdesde')  and not isdefined('form.Fdesde')>
	<cfset form.Fdesde = url.Fdesde>
</cfif>
<cfif isdefined('url.Fhasta')  and not isdefined('form.Fhasta')>
	<cfset form.Fhasta = url.Fhasta>
</cfif>
<cfif isdefined('url.CCTcodigoDcto') and not isdefined('form.CCTcodigoDcto')>
	<cfset form.CCTcodigoDcto = url.CCTcodigoDcto>
</cfif>
<script language="JavaScript" src="../../js/utilesMonto.js"></script>

<cfif isdefined("url.SNcodigo") and len(trim(url.SNcodigo)) and not isdefined("form.SNcodigo")>
	<cfset form.SNcodigo = url.SNcodigo>
</cfif>
<cfif isdefined("url.pn_disponible") and len(trim(url.pn_disponible)) and not isdefined("form.pn_disponible")>
	<cfset form.pn_disponible = url.pn_disponible>
</cfif>
<cfif isdefined("url.Mcodigo") and len(trim(url.Mcodigo)) and not isdefined("form.Mcodigo")>
	<cfset form.Mcodigo = url.Mcodigo>
</cfif>
<cfif isdefined("url.Pcodigo") and len(trim(url.Pcodigo)) and not isdefined("form.Pcodigo")>
	<cfset form.Pcodigo = url.Pcodigo>
</cfif>
<cfif isdefined("url.Ddocumento") and len(trim(url.Ddocumento)) and not isdefined("form.Ddocumento")>
	<cfset form.Pcodigo = url.Ddocumento>
</cfif>
<cfif isdefined("url.CCTcodigo") and len(trim(url.CCTcodigo)) and not isdefined("form.CCTcodigo")>
	<cfset form.CCTcodigo = url.CCTcodigo>
</cfif>
<cfif isdefined('url.FDdocumento')  and not isdefined('form.FDdocumento')>
	<cfset form.FDdocumento = url.FDdocumento>
</cfif>
<!----Datos del socio de negocios---->
<cfquery name="rsSocio" datasource="#session.DSN#">
	select <cf_dbfunction name="concat" args="SNnumero,'-',SNnombre">as SocioNegocio 
	from SNegocios
	where SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
</cfquery>
<!-----Descripcion de la Moneda del pago---->
<cfquery name="rsMoneda" datasource="#session.DSN#">
	select Mnombre from Monedas where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
</cfquery>
<!-----Combo de tipos de transaccion---->
<cfquery name="rsTransacciones" datasource="#session.DSN#">
	select CCTcodigo,CCTdescripcion from CCTransacciones 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and CCTtipo = 'D'
		and not CCTdescripcion like '% desde Tesorer%'
</cfquery>
<cfquery name="rsDirecciones" datasource="#session.DSN#">
	select  distinct coalesce(d.direccion1,d.direccion2) as Direccion, d.id_direccion
	from Pagos a
		inner join SNegocios b
			on a.SNcodigo = b.SNcodigo
			and a.Ecodigo = b.Ecodigo
			
			inner join SNDirecciones c
				on b.SNcodigo = c.SNcodigo
				and b.Ecodigo = c.Ecodigo
	
				inner join DireccionesSIF d
					on c.id_direccion= d.id_direccion
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
</cfquery>
<cfoutput>
	<form name="formFiltro" action="SeleccionMasiva_SQL.cfm" method="post" onsubmit="javascript: return funcValidaMto();">
		<input type="hidden" name="SNcodigo" value="<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>#form.SNcodigo#</cfif>">
		<input type="hidden" name="pn_disponible" value="<cfif isdefined("form.pn_disponible") and len(trim(form.pn_disponible))>#form.pn_disponible#</cfif>">
		<input type="hidden" name="Mcodigo" value="<cfif isdefined("form.Mcodigo") and len(trim(form.Mcodigo))>#form.Mcodigo#</cfif>">
		
		<cfif isdefined("form.Pcodigo") and len(trim(form.Pcodigo))>
			<input type="hidden" name="Pcodigo" value="<cfif isdefined("form.Pcodigo") and len(trim(form.Pcodigo))>#form.Pcodigo#</cfif>">
		<cfelseif isdefined("form.Ddocumento") and len(trim(form.Ddocumento))>
			<input type="hidden" name="Ddocumento" value="<cfif isdefined("form.Ddocumento") and len(trim(form.Ddocumento))>#form.Ddocumento#</cfif>">
		</cfif>
		<input type="hidden" name="CCTcodigo" value="<cfif isdefined("form.CCTcodigo") and len(trim(form.CCTcodigo))>#form.CCTcodigo#</cfif>">
		<table width="100%" cellpadding="2" cellspacing="0" border="0">
			<tr><td>&nbsp;</td></tr>
			<tr bgcolor="CCCCCC"><td align="center" ><font size="2"><strong>Selecci&oacute;n Masiva Detalles</strong></font></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td align="center"><strong>Socio de Negocio:&nbsp;#rsSocio.SocioNegocio#</strong></td></tr>		
			<tr><td align="center"><strong>Moneda:&nbsp;#rsMoneda.Mnombre#</strong></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td align="center">
					<table cellpadding="0" cellspacing="3" border="0" align="center">
						<tr>
							<td align="right"><strong>Monto a Distribuir:&nbsp;</strong></td>
							<td align="left">
								<cfset LvarValue = "0.00">
								<cfif isdefined("form.pn_disponible") and len(trim(form.pn_disponible))>
									<cfset LvarValue = replace(form.pn_disponible,",","","all")>
								</cfif>
								<cf_inputNumber readOnly="true" name="mto_disponible" value="#LvarValue#" DECIMALES="2" ENTEROS="15" form="formFiltro">
							</td>
							<cfparam name="form.option" default="FA">
							<td align="right"><strong>Ordenar por:&nbsp;</strong></td>
							<td  align="left" colspan="3">
								<select name="option" id="option" tabindex="1">
									<cfparam name="form.option" default="FA">
									<option value="FD"
										<cfif isdefined('form.option') and form.option EQ 'FD'>selected</cfif>>
										Fecha Descendente
									</option>
									<option value="FA"
										<cfif isdefined('form.option') and form.option EQ 'FA'>selected</cfif>>
										Fecha Ascendente
									</option>
									<option value="MD"
										<cfif isdefined('form.option') and form.option EQ 'MD'>selected</cfif>>
										Monto Descendente
									</option>
									<option value="MA"
										<cfif isdefined('form.option') and form.option EQ 'MA'>selected</cfif>>
										Monto Ascendente
									</option>
							</td>
						</tr>  
						<tr>
							<td align="right"><strong>Tipo Transacci&oacute;n:&nbsp;</strong></td>
							<td colspan="3" align="left" colspan="3">
								<select name="CCTcodigoDcto" id="CCTcodigoDcto" tabindex="1">
									<option value="">--- Todos ----</option>
									<cfloop query="rsTransacciones"> 
										<option value="#rsTransacciones.CCTcodigo#" 
											<cfif isdefined('form.CCTcodigoDcto') and form.CCTcodigoDcto EQ rsTransacciones.CCTcodigo>selected</cfif>>
												#rsTransacciones.CCTdescripcion#
										</option>
									</cfloop> 
							  </select>
							</td>
						</tr>
						<tr>
							<td align="right"><strong>Solo Direcci&oacute;n:&nbsp;</strong></td>
							
							<td colspan="3" align="left" colspan="3">
								<select name="id_direccion" id="id_direccion" tabindex="1">
									<option value="">--- Todos ----</option>
									<cfloop query="rsDirecciones"> 
										<option value="#rsDirecciones.id_direccion#"
											<cfif isdefined('form.id_direccion') and id_direccion EQ form.id_direccion>selected</cfif>>
											#rsDirecciones.Direccion#
										</option>
									</cfloop> 
							  </select>
							</td>
						</tr>
						<tr>
							<td align="right"><strong>Fecha desde:</strong>&nbsp;</td>
							<td>
								<cfif isdefined('form.Fdesde') and LEN(TRIM(form.Fdesde))>
									<cfset fecha = LSDateFormat(form.Fdesde,'dd/mm/yyyy')>
								<cfelse>
									<cfset fecha = ''>
								</cfif>
								<cf_sifcalendario name="Fdesde" value="#fecha#" tabindex="1" form="formFiltro">
							</td>
							<td><strong>hasta</strong></td>
							<td>
								<cfif isdefined('form.Fhasta') and LEN(TRIM(form.Fhasta))>
									<cfset fecha = LSDateFormat(form.Fhasta,'dd/mm/yyyy')>
								<cfelse>
									<cfset fecha = ''>
								</cfif>
								<cf_sifcalendario name="Fhasta" value="#fecha#" tabindex="1" form="formFiltro">
							</td>
						</tr>
                        <tr>
                        	<td align="right"><strong>Documento:</strong>&nbsp;</td>
                        	<td>
                            	<input name="FDdocumento" id="FDdocumento" value="<cfif isdefined("form.FDdocumento") and len(trim(form.FDdocumento))>#form.FDdocumento#</cfif>" type="text" />
                            </td>
                        </tr>
				  </table>
				</td>
			</tr>
			<tr>
				<td align="center">
					<cf_botones values="Filtrar,Cerrar" tabindex="1" form="formFiltro">
				</td>
			</tr>
		</table>
	</form>	
</cfoutput>

<cfset navegacion="&CCTcodigo=" & form.CCTcodigo & "&Mcodigo=" & form.Mcodigo & "&SNcodigo="&form.SNcodigo & "&pn_disponible=" & form.pn_disponible & "&option="& form.option>
<cfif isdefined('form.CCTcodigoDcto')>
	<cfset navegacion = navegacion & "&CCTcodigoDcto=" & form.CCTcodigoDcto>
<cfelse>
	<cfset form.CCTcodigoDcto = "">
</cfif>
<cfif isdefined('form.id_direccion')>
	<cfset navegacion = navegacion & "&id_direccion=" & form.id_direccion>
<cfelse>
	<cfset form.id_direccion = "">
</cfif>
<cfif isdefined('form.Fdesde')>
	<cfset navegacion = navegacion & "&Fdesde=" & form.Fdesde>
<cfelse>
	<cfset form.Fdesde = "">
</cfif>
<cfif isdefined('form.Fhasta')>
	<cfset navegacion = navegacion & "&Fhasta=" & form.Fhasta>
<cfelse>
	<cfset form.Fhasta = "">
</cfif>
<cfif isdefined('form.Pcodigo') and LEN(TRIM(form.Pcodigo))>
	<cfset navegacion = navegacion & "&Pcodigo=" & form.Pcodigo>
	<cfset dato = form.Pcodigo>
</cfif>
<cfif isdefined('form.Ddocumento') and LEN(TRIM(form.Ddocumento))>
	<cfset navegacion = navegacion & "&Ddocumento=" & form.Ddocumento>
	<cfset dato = form.Ddocumento>
</cfif>
<cfif isdefined('form.FDdocumento') and LEN(TRIM(form.FDdocumento))>
	<cfset navegacion = navegacion & "&FDdocumento=" & form.FDdocumento>
	<cfset dato = form.FDdocumento>
</cfif>

<form name="form1" method="post">
	<cfif isdefined("form.option") and  form.option EQ 'FD'>
		<cfset orden = "Order by Dfecha desc">
	<cfelseif isdefined("form.option") and  form.option EQ 'FA'>
		<cfset orden = "Order by Dfecha asc	">
	<cfelseif isdefined("form.option") and  form.option EQ 'MD'>
		<cfset orden = "Order by DPmontodoc desc">	
	<cfelseif isdefined("form.option") and  form.option EQ 'MA'>
		<cfset orden = "Order by DPmontodoc asc">
	</cfif>	

<cfquery name="rsLista" datasource="#session.DSN#" maxrows="1000">
	select 	a.CCTcodigo as CCTcodigo1,
			a.Ddocumento as Ddocumento1,
			a.Dfecha,
			a.Dsaldo,
			'' as esp
	from Documentos a
		<!----El join es porque el mantenimiento de pagos se filtra por CCTtipo = D----->		
		inner join CCTransacciones b
			on a.CCTcodigo = b.CCTcodigo
			and a.Ecodigo = b.Ecodigo
			and b.CCTtipo = 'D'
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
		and a.Dsaldo > 0
		and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
			<!----No traer los que están siendo insertados pagos  o documento a favor ---->
			and not exists (select 1
							from DPagos z 
							  where z.Doc_CCTcodigo = a.CCTcodigo
								and z.Ddocumento = a.Ddocumento
							)
			and not exists (select 1
							from DFavor z 
							where z.CCTRcodigo = a.CCTcodigo
								and z.DRdocumento = a.Ddocumento
							)
		and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
		and not exists (
								select 1
								from DAgrupador g
								where g.Ecodigo=a.Ecodigo
								and g.CCTcodigo=a.CCTcodigo
								and g.Ddocumento=a.Ddocumento
								and g.DdocumentoId=a.DdocumentoId
							)
		<!--- RANGO DE FECHAS --->
		<cfif isdefined('form.Fdesde') and LEN(TRIM(form.Fdesde)) and isdefined('form.Fhasta') and LEN(TRIM(form.Fhasta))>
			and a.Dfecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.Fdesde)#">
						and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.Fhasta)#">
		<cfelseif isdefined('form.Fdesde') and LEN(TRIM(form.Fdesde))>
			and a.Dfecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.Fdesde)#">
		<cfelseif isdefined('form.Fhasta') and LEN(TRIM(form.Fhasta))>
			and a.Dfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.Fhasta)#">
		</cfif>
		<cfif isdefined("form.CCTcodigoDcto") and len(trim(form.CCTcodigoDcto))>
			and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CCTcodigoDcto#">
		</cfif>
		<cfif isdefined("form.id_direccion") and len(trim(form.id_direccion))>
			and a.id_direccionFact = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccion#">
		</cfif>
        <cfif isdefined("form.FDdocumento") and len(trim(form.FDdocumento))>
			and a.Ddocumento like '%#form.FDdocumento#%'
		</cfif>
		<cfif isdefined("form.option") and  form.option EQ 'FD'>
			Order by Ddocumento asc
		<cfelseif isdefined("form.option") and  form.option EQ 'FA'>
--			Order by Dfecha asc	
		Order by Ddocumento asc
		<cfelseif isdefined("form.option") and  form.option EQ 'MD'>
--			Order by Dsaldo desc	
		Order by Ddocumento asc
		<cfelseif isdefined("form.option") and  form.option EQ 'MA'>
--			Order by Dsaldo asc	
		Order by Ddocumento asc
		</cfif>				
</cfquery>

	<table width="100%" cellpadding="0" cellspacing="0" border="0">
		<tr>
		<tr></tr>
			<td>
				<table cellpadding="0" cellspacing="0"><tr>
						<td class="tituloListas" align="left" width="1%">
								<input 	type="checkbox" name="chkAllItems" value="1"  style="border:none; background-color:inherit;"
										onclick="javascript: funcFiltroChkAll_00(this);"
								>
						<script language="javascript">
						function funcFiltroChkAll_00(c){
							if (document.form1.chk) {
								if (document.form1.chk.value) {
									if (!document.form1.chk.disabled) { 
										document.form1.chk.checked = c.checked;
									}
								} else {
									for (var counter = 0; counter < document.form1.chk.length; counter++) {
										if (!document.form1.chk[counter].disabled) {
											document.form1.chk[counter].checked = c.checked;
										}
									}
								}
							}
						}
						</script>
						</td>
						<td class="tituloListas" ><cf_botones values="Distribuir"></td>
				</tr></table>

				<cfinvoke 
						 component="sif.Componentes.pListas"
						 method="pListaQuery"
						 returnvariable="pListaRet">
					<cfinvokeargument name="query"  				value="#rsLista#"/>

					<cfinvokeargument name="desplegar"  			value="CCTcodigo1, Ddocumento1,Dfecha,Dsaldo,esp"/>
					<cfinvokeargument name="etiquetas"  			value="Transacci&oacute;n,Documento,Fecha,Monto, "/>
					<cfinvokeargument name="formatos"   			value="S,S,D,M,U"/>
					<cfinvokeargument name="align"      			value="left,left,left,right,left"/>
					<cfinvokeargument name="ajustar"    			value="N"/>
					<cfinvokeargument name="irA"        			value="SeleccionMasiva_SQL.cfm"/>
					<cfinvokeargument name="showLink" 				value="false"/>
					<cfinvokeargument name="checkboxes" 	 	 	value="S"/>
					<cfinvokeargument name="checkbox_function" 	 	value="getMontoL"/>
					<cfinvokeargument name="keys_checkbox_function" value="Dsaldo,Ddocumento1"/>
					<cfinvokeargument name="showEmptyListMsg" 		value="true"/>
					<cfinvokeargument name="maxrows" 				value="1000"/>
                    <cfinvokeargument name="maxrowsquery" 			value="1000"/>
					<cfinvokeargument name="keys"             		value="CCTcodigo1,Ddocumento1"/>
					<cfinvokeargument name="mostrar_filtro"			value="false"/>
					<cfinvokeargument name="navegacion"				value="#navegacion#"/>
					<cfinvokeargument name="filtrar_automatico"		value="false"/>
					<cfinvokeargument name="formname"				value="form1"/>
					<cfinvokeargument name="incluyeform"			value="false"/>
				</cfinvoke>
			</td>
		</tr>
		<tr>
			<td align="right">
			<strong>Suma:</strong>  <input id="Suma"name="Suma" type="text" style="text-align: right;" value="0" disabled>
			<input id="txtSuma"name="txtSuma" type="hidden" value="">
			</td>
		</tr>
	</table>

	<cfoutput>
		<input name="SNcodigo" type="hidden" value="#form.SNcodigo#">
		<input name="Mcodigo" type="hidden" value="#form.Mcodigo#">
		<cfif isdefined('form.Pcodigo') and LEN(TRIM(form.Pcodigo))>
			<input name="Pcodigo" type="hidden" value="#form.Pcodigo#">
		<cfelseif isdefined('form.Ddocumento') and LEN(TRIM(form.Ddocumento))>
			<input name="Ddocumento" type="hidden" value="#form.Ddocumento#">
		</cfif>
		<input name="CCTcodigo" type="hidden" value="#form.CCTcodigo#">
		<input name="option" type="hidden" value="#form.option#">
		<input name="CCTcodigoDcto" type="hidden" value="#form.CCTcodigoDcto#">
		<input name="id_direccion" type="hidden" value="#form.id_direccion#">
		<input name="pn_disponible" type="hidden" value="#form.pn_disponible#">
		<input name="Fdesde" type="hidden" value="#form.Fdesde#">
		<input name="Fhasta" type="hidden" value="#form.Fhasta#">
		<input name="FDdocumento" type="hidden" value="<cfif isdefined("form.FDdocumento")>#form.FDdocumento#</cfif>">
		<input type="hidden" name="mto_disponible" value="<cfif isdefined("form.pn_disponible") and len(trim(form.pn_disponible))>#form.pn_disponible#</cfif>">
		<input name="marcado" type="hidden" value="0">
	</cfoutput>
</form>


<script type="text/javascript" language="javascript1.2">
	
	function getMontoL(monto,keyy){
		var num1 = parseFloat(document.getElementById("Suma").value) ;
		var num2 = parseFloat(monto);
		var suma = parseFloat(0);

		var str = document.getElementById("txtSuma").value;
		var res = str.split(",");
		var vall=0;
		var txsuma='';

		for (var i = 0; i < res.length; i++) {
			console.log(res[i]+'=='+keyy);
		  if( res[i] == keyy ) {
		  	vall=1;
		  }
		  else{
		  	txsuma= txsuma+','+res[i];
		  }
		}

		document.getElementById("txtSuma").value=txsuma;
		if (vall==0) {
           suma = num1 + num2;
           txsuma= txsuma+','+keyy;
        }
        else{
        	suma = num1 - num2;
        }

		document.getElementById("txtSuma").value=txsuma;
        document.getElementById("Suma").value=suma;
	}
	
	function funcValidaMto(){		
		if (parseFloat(qf(document.form1.mto_disponible.value)) > 0){
			if(parseFloat(qf(document.form1.mto_disponible.value)) > parseFloat(qf(document.form1.pn_disponible.value))){
				alert("El monto disponible no puede ser mayor a: "+fm(document.form1.pn_disponible.value,2));
				document.form1.mto_disponible.value = document.form1.pn_disponible.value;
				return false;
			}			
		}
		else{
			alert("El monto disponible no puede ser cero");
			document.form1.mto_disponible.value = document.form1.pn_disponible.value;
			return false;
		}
		return true;
	}	
	
	function funcDistribuir(){
		var LvarOK = 0;
		if (document.form1.chk != null) 
		{
			if (document.form1.chk.value != null)
			{
				if (document.form1.chk.checked)
					LvarOK = 1;
			} 
			else 
			{
				for (var i=0; i<document.form1.chk.length; i++)
					if (document.form1.chk[i].checked)
						LvarOK ++;
			}
		}
		
		if (LvarOK >= 0)
			if (LvarOK == 1 || confirm('¿Desea distribuir los documentos seleccionados?'))
			{
				document.form1.action = "SeleccionMasiva_SQL.cfm";
				return ;
			}
			
		alert("Debe seleccionar por lo menos un documento de pago para distribuir. Verifique.");
		return false;
	}
	
	function funcCerrar(){
		window.close();
	}
</script>
</body>
</html>


