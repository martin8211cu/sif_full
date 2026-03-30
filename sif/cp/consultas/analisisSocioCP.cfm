<!---
	Modificado por: Ana Villavicencio
	Fecha: 27 de febrero del 2006
	Motivo: se agregaron instrucciones para tomar variables del URL que vienen desde el catalogo de Socios.
			se agrega el boton REGRESAR para el caso de la consulta desde el catalogo de socios.
 --->
<cfquery name="rsOficinas" datasource="#session.DSN#">
	Select Ocodigo, Oficodigo, Odescripcion
	from Oficinas
	where Ecodigo = #Session.Ecodigo#
	order by Odescripcion
</cfquery>
<cfif isdefined('form.Ocodigo_F') and form.Ocodigo_F gt -1>
	<cfquery name="rsOficina" datasource="#session.DSN#">
		select Ocodigo, Odescripcion
		from Oficinas
		where Ecodigo=#session.Ecodigo#
		  and Ocodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo_F#">
	</cfquery>
</cfif>

<cfset navegacion = "">

<cfif isdefined('url.CatSoc') and not isdefined('form.CatSoc')>
	<cfset form.CatSoc = url.CatSoc>
</cfif>
<cfif isDefined("Url.SNcodigo") and not isDefined("form.SNcodigo")>
	<cfset form.SNcodigo = Url.SNcodigo>
</cfif>
<cfif isDefined("Url.SNnumero") and not isDefined("form.SNnumero")>
	<cfset form.SNnumero = Url.SNnumero>
</cfif>
<cfif isDefined("Url.Ocodigo_F") and not isDefined("form.Ocodigo_F")>
	<cfset form.Ocodigo_F = Url.Ocodigo_F>
</cfif>
<cfif isDefined("Url.id_direccion") and not isDefined("form.id_direccion")>
	<cfset form.id_direccion = Url.id_direccion>
</cfif>

<script language="javascript" type="text/javascript">
	function funcDatos(){
		if (document.form2.SNcodigo.value != '') {
			document.form2.action = "../../ad/catalogos/DatosGSocio.cfm";
			document.form2.submit();}
		else {
				alert('Debe digitar el Socio de Negocios');
				return false;
			}
	}

	function funcImprimir(){
		if (document.form2.SNcodigo.value != '') {
			document.form2.action = "ImpresionSaldoProveedorCP.cfm";
			document.form2.method = "get";
			document.form2.submit();}
		else {
				alert('Debe digitar el Socio de Negocios');
				return false;
			}
	}
</script>

<cf_templateheader title="SIF - Cuentas por Pagar">
   <cf_web_portlet_start titulo='An&aacute;lisis del Saldo Actual de Socio'>
	<cfinclude template="../../portlets/pNavegacion.cfm">
	<form name="form1" method="post" action="analisisSocioCP.cfm" style="margin:0;">
		<cfif isdefined('form.CatSoc') and form.CatSoc EQ 1>
			<input name="CatSoc"  type="hidden" value="<cfoutput>#form.CatSoc#</cfoutput>">
		</cfif>
		<table align="center" width="100%" border="0" cellspacing="0" cellpadding="3" class="AreaFiltro">
		  <tr nowrap>
			<td>&nbsp;</td>
			<td align="right" nowrap class="FileLabel"><strong>Socio:</strong></td>
			<td>
				<cfif isdefined('form.SNcodigo') and form.SNcodigo NEQ ''>
					<cf_sifsociosnegocios2 Proveedores="SI" SNtiposocio="P" SNcodigo="SNcodigo" SNnombre="SNnombre" SNnumero="SNnumero" idquery="#form.SNcodigo#" tabindex="1">
				<cfelse>
					<cf_sifsociosnegocios2 Proveedores="SI" SNtiposocio="P" SNcodigo="SNcodigo" SNnombre="SNnombre" SNnumero="SNnumero" tabindex="1">
				</cfif>
			</td>
			<td nowrap class="FileLabel" align="right"><strong>Oficina de Empresa </strong>:
			</td>
			<td>
            <select name="Ocodigo_F" id="Ocodigo_F" tabindex="1">
				<cfif isdefined('rsOficinas') and rsOficinas.recordCount GT 0>
                    <option value="-1">-- Todas --</option>
                    <cfoutput query="rsOficinas">
                        <option value="#rsOficinas.Ocodigo#"<cfif isdefined('form.Ocodigo_F') and len(trim(form.Ocodigo_F)) and form.Ocodigo_F EQ rsOficinas.Ocodigo> selected</cfif>>#rsOficinas.Odescripcion#</option>
                    </cfoutput>
                </cfif>
			</select>					</td>
			<td nowrap align="center" valign="middle">
				<cfif isdefined('form.CatSoc') and form.CatSoc EQ 1>
					<cfset regresa = '../../ad/catalogos/Socios.cfm?SNcodigo=#form.SNcodigo#'>
				</cfif>
			</td>
		  </tr>
		  <tr>
		  <td colspan="6">
				<table border="0" cellspacing="0" cellpadding="0" width="50%" align="center">
					<tr>
						<td align="center">
							<input type="hidden" name="botonSel" value="">
							<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb" tabindex="-1" style="visibility:hidden;">
						</td>
						<td align="center">
							<input type="submit" name="Consultar" class="btnNormal" value="Consultar" onclick="javascript: this.form.botonSel.value = this.name; if (window.funcConsultar) return funcConsultar();" tabindex="1">
						</td>
	</form>

						<cfif isdefined("form.SNcodigo")>
							<form name="form2" method="post" action="" style="margin:0;">
								<input name="CxP" value="1" type="hidden">
								<input name="SNcodigo"  type="hidden" value="<cfoutput>#form.SNcodigo#</cfoutput>">
								<input name="Ocodigo_F"  type="hidden" value="<cfif isdefined("form.Ocodigo_F") and len(trim(form.Ocodigo_F))><cfoutput>#form.Ocodigo_F#</cfoutput><cfelse>-1</cfif>">
								<cfif isdefined('form.CatSoc') and form.CatSoc EQ 1>
									<input name="CatSoc"  type="hidden" value="<cfoutput>#form.CatSoc#</cfoutput>">
								</cfif>
								<td align="center"><input type="submit" name="Datos" class="btnNormal" value="Datos Generales Socio" onclick="javascript: if (window.funcDatos) return funcDatos();" tabindex="1" /></td>
								<td align="center">
									<input type="submit" name="Imprimir" class="btnNormal" value="Imprimir Saldo" onclick="javascript: if (window.funcImprimir) return funcImprimir();" tabindex="1">
								</td>
							</form>
						</cfif>

						<cfif isdefined('form.CatSoc') and form.CatSoc EQ 1>
							<cfset regresa = '../../ad/catalogos/Socios.cfm?SNcodigo=#form.SNcodigo#'>
							<td align="center">
								<input type="button" name="Regresar" class="btnAnterior" value="Regresar" onclick="javascript:location.href='<cfoutput>#regresa#</cfoutput>'" tabindex="1">
							</td>
						</cfif>
					</tr>
				</table>
		  </td>
		  </tr>
	  </table>
	<br/>

	<cfif isdefined('form.SNcodigo') and form.SNcodigo NEQ ''>
			<cfquery name="rsSocio" datasource="#session.DSN#">
				select SNcodigo, SNnombre
				from SNegocios
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and SNcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
			</cfquery>
			<!--- Esta sección se muestra solo cuando está definido el socio... --->
			<table width="100%"  border="0" cellspacing="0" cellpadding="2" align="center">
			  <tr><td colspan="2" align="center" class="subTitulo">Socio: <cfoutput>#rsSocio.SNcodigo#-#rsSocio.SNnombre#</cfoutput></td></tr>

				<tr><td colspan="2" align="center" class="subTitulo">Oficina: <cfif isdefined("rsOficina")><cfoutput>#rsOficina.Ocodigo#-#rsOficina.Odescripcion#</cfoutput><cfelse>Todas</cfif></td></tr>

			  <tr><td colspan="2" align="center" >&nbsp;</td></tr>
			  <tr>
				<td>
					<cfset LvarAnalisis = 1>
					<cfinclude template="../MenuCP-barGraph-v2.cfm">
				</td>
				<td>
					<cfif isdefined('rsGraficoBar') and rsGraficoBar.recordCount GT 0>
						<cfinclude template="../MenuCP-pieGraph.cfm">
					<cfelse>
						&nbsp;
					</cfif>
				</td>
			  </tr>
			  <tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			  </tr>
			  <tr>
				<td colspan="2" class="subTitulo">Vencimiento por Direcci&oacute;n</td>
			  </tr>
			  <tr>
				<td colspan="2">
					<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
						<cfset navegacion = navegacion & "&SNcodigo=" & form.SNcodigo>
					</cfif>
					<cfif isdefined("form.Ocodigo_F") and len(trim(form.Ocodigo_F))>
						<cfset navegacion = navegacion & "&Ocodigo_F=" & form.Ocodigo_F>
					</cfif>
					<cfif isdefined("form.id_direccion") and len(trim(form.id_direccion))>
						<cfset navegacion = navegacion & "&id_direccion=" & form.id_direccion>
					</cfif>
					<cfinvoke
						component="sif.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pLista"
						query="#rsGraficoBar#"
						formname="listaVencOfi"
						incluyeform="true"
						desplegar="direccion, Corriente, SinVencer, P1, P2, P3, P4, P5, Dsaldo"
						etiquetas="Direccion, Corriente, Sin Vencer, #venc1#, #venc2#, #venc3#, #venc4#, #venc4#+, Saldo"
						formatos="V, M, M, M, M, M, M, M, M"
						totales="Corriente,SinVencer,P1,P2,P3,P4,P5,Dsaldo"
						align="left, right, right, right, right, right, right, right, right"
						navegacion="#navegacion#"
						maxrows="15"
						keys="id_direccion"
						pageindex="1"
						ira="analisisSocioCP.cfm"/>
				</td>
			  </tr>
			  <tr>
				<td colspan="2">&nbsp;</td>
			  </tr>
			  <cfif isdefined('rsDocumentos') and rsDocumentos.recordCount GT 0 and isdefined("form.id_direccion") and form.id_direccion NEQ ''>
				  <tr>
					<td colspan="2" class="subTitulo">Documentos de <cfoutput>#rsDocumentos.direccion#</cfoutput></td>
				  </tr>
				  <tr>
					<td colspan="2">
						<cfinvoke
							component="sif.Componentes.pListas"
							method="pListaQuery"
							returnvariable="pLista"
							query="#rsDocumentos#"
							formname="listaDocum"
							incluyeform="true"
							desplegar="Tipo, Documento, Fecha, Vencimiento, Oficina, Monto, Saldo"
							etiquetas="Tipo, Documento, Fecha, Vencimiento, Oficina, Monto, Saldo"
							totales="Monto,Saldo"
							totalgenerales="Monto,Saldo"
							formatos="S, S, D, D, S, M, M"
							align="left, left, center, center, center, right, right"
							navegacion="#navegacion#"
							showlink="false"
							maxrows="15"
							pageindex="2"
							ira="analisisSocioCP.cfm"/>
					</td>
				  </tr>
			  </cfif><!--- si está definida la consulta de documentos --->
			</table>
		</cfif><!--- si está definido el socio ??? --->
	<cf_web_portlet_end>
<cf_templatefooter>

<script language="javascript" type="text/javascript">
	document.form1.SNnumero.focus();
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWinSN) {
			if(!popUpWinSN.closed) popUpWinSN.close();
		}
		popUpWinSN = open(URLStr, 'popUpWinSN', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
		window.onfocus = closePopUp;
	}
	function closePopUp(){
		if(popUpWinSN) {
			if(!popUpWinSN.closed) popUpWinSN.close();
			popUpWinSN=null;
		}
	}
</script>
