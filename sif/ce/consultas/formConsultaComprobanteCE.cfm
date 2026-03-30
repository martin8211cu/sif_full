<cfinvoke key="LB_UUID" default="UUID" returnvariable="LB_UUID" component="sif.Componentes.Translate" method="Translate" xmlfile="formConsultaComprobanteCE.xml"/>
<cfinvoke key="LB_Documento" default="Documento" returnvariable="LB_Documento" component="sif.Componentes.Translate" method="Translate" xmlfile="formConsultaComprobanteCE.xml"/>
<cfinvoke key="LB_RFC" default="RFC" returnvariable="LB_RFC" component="sif.Componentes.Translate" method="Translate" xmlfile="formConsultaComprobanteCE.xml"/>
<cfinvoke key="LB_Origen" default="Origen" returnvariable="LB_Origen" component="sif.Componentes.Translate" method="Translate" xmlfile="formConsultaComprobanteCE.xml"/>
<cfinvoke key="LB_Lote" default="Lote" returnvariable="LB_Lote" component="sif.Componentes.Translate" method="Translate" xmlfile="formConsultaComprobanteCE.xml"/>
<cfinvoke key="LB_Poliza" default="Poliza" returnvariable="LB_Poliza" component="sif.Componentes.Translate" method="Translate" xmlfile="formConsultaComprobanteCE.xml"/>
<cfinvoke key="LB_filtrar" default="Filtrar" returnvariable="LB_filtrar" component="sif.Componentes.Translate" method="Translate" xmlfile="formConsultaComprobanteCE.xml"/>
<cfinvoke key="LB_CuentasPagar" default="Cuentas por Pagar" returnvariable="LB_CuentasPagar" component="sif.Componentes.Translate" method="Translate" xmlfile="formConsultaComprobanteCE.xml"/>
<cfinvoke key="LB_CuentasCobrar" default="Cuentas por Cobrar" returnvariable="LB_CuentasCobrar" component="sif.Componentes.Translate" method="Translate" xmlfile="formConsultaComprobanteCE.xml"/>
<cfinvoke key="LB_PagosCuentasPagar" default="Pagos de Cuentas por Pagar" returnvariable="LB_PagosCuentasPagar" component="sif.Componentes.Translate" method="Translate" xmlfile="formConsultaComprobanteCE.xml"/>
<cfinvoke key="LB_CobrosCuentasCobrar" default="Cobros de Cuentas por Cobrar" returnvariable="LB_CobrosCuentasCobrar" component="sif.Componentes.Translate" method="Translate" xmlfile="formConsultaComprobanteCE.xml"/>
<cfinvoke key="LB_PagosTesoreria" default="Pagos desde Tesoreria" returnvariable="LB_PagosTesoreria" component="sif.Componentes.Translate" method="Translate" xmlfile="formConsultaComprobanteCE.xml"/>
<cfinvoke key="LB_GastosEmpleado" default="Gasto de Empleado" returnvariable="LB_GastosEmpleado" component="sif.Componentes.Translate" method="Translate" xmlfile="formConsultaComprobanteCE.xml"/>


<cfset navegacion = "">
<cfif isdefined("url.selectLote") and len(trim(url.selectLote)) and not isdefined("form.selectLote")>
	<cfset form.selectLote = url.selectLote >
</cfif>
<cfif isdefined("form.selectLote") and form.selectLote NEQ "-1">
	<cfset navegacion = navegacion & "&selectLote=#form.selectLote#">
</cfif>
<cfif isdefined("url.Poliza") and len(trim(url.Poliza)) and not isdefined("form.Poliza")>
	<cfset form.Poliza = url.Poliza >
</cfif>
<cfif isdefined("form.Poliza") and form.Poliza NEQ "">
	<cfset navegacion = navegacion & "&Poliza=#form.Poliza#">
</cfif>
<cfif isdefined("url.periodo") and len(trim(url.periodo)) and not isdefined("form.periodo")>
	<cfset form.periodo = url.periodo >
</cfif>
<cfif isdefined("form.periodo") and form.periodo NEQ "-1">
	<cfset navegacion = navegacion & "&periodo=#form.periodo#">
</cfif>
<cfif isdefined("url.mes") and len(trim(url.mes)) and not isdefined("form.mes")>
	<cfset form.mes = url.mes >
</cfif>
<cfif isdefined("form.mes") and form.mes NEQ "-1">
	<cfset navegacion = navegacion & "&mes=#form.mes#">
</cfif>
<cfif isdefined("url.UUID") and len(trim(url.UUID)) and not isdefined("form.UUID")>
	<cfset form.UUID = url.UUID >
</cfif>
<cfif isdefined("form.UUID") and form.UUID NEQ "">
	<cfset navegacion = navegacion & "&UUID=#form.UUID#">
</cfif>
<cfif isdefined("url.RFC") and len(trim(url.RFC)) and not isdefined("form.RFC")>
	<cfset form.RFC = url.RFC >
</cfif>
<cfif isdefined("form.RFC") and form.RFC NEQ "" and form.RFC GT 0>
	<cfset navegacion = navegacion & "&RFC=#form.RFC#">
</cfif>
<cfif isdefined("url.Documento") and len(trim(url.Documento)) and not isdefined("form.Documento")>
	<cfset form.Documento = url.Documento >
</cfif>
<cfif isdefined("form.Documento") and form.Documento NEQ "" and form.Documento GT 0>
	<cfset navegacion = navegacion & "&Documento=#form.Documento#">
</cfif>
<cfif isdefined("url.selectOrigen") and len(trim(url.selectOrigen)) and not isdefined("form.selectOrigen")>
	<cfset form.selectOrigen = url.selectOrigen >
</cfif>
<cfif isdefined("form.selectOrigen")  AND form.selectOrigen NEQ "-1">
	<cfset navegacion = navegacion & "&selectOrigen=#form.selectOrigen#">
</cfif>


<cfquery name="rsPer" datasource="#Session.DSN#" cachedwithin="#createtimespan(0,0,5,0)#">
	select distinct Speriodo as Eperiodo
	from CGPeriodosProcesados
	where Ecodigo = #session.Ecodigo#
	order by Eperiodo desc
</cfquery>

<cfquery name="rsMeses" datasource="sifControl" cachedwithin="#createtimespan(0,1,0,0)#">
	select <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl"> as VSvalor, b.VSdesc
	from Idiomas a, VSidioma b
	where a.Icodigo = '#Session.Idioma#'
		and a.Iid = b.Iid
		and b.VSgrupo = 1
	order by <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl">
</cfquery>

<cfquery name="rsLotes" datasource="#Session.DSN#" cachedwithin="#createtimespan(0,0,5,0)#">
	SELECT  cc.Cconcepto,cc.Cdescripcion FROM ConceptoContableE cc
	inner join (select distinct Cconcepto,Ecodigo from HEContables) hc
		on cc.Ecodigo = hc.Ecodigo and cc.Cconcepto = hc.Cconcepto
	where cc.Ecodigo = #Session.Ecodigo#
</cfquery>

<cfquery name="rsOrigenes" datasource="#Session.DSN#">
	select distinct origen,
	case origen
				when 'CPFC' then 'Cuentas por Pagar'
				when 'CCFC' then 'Cuentas por Cobrar'
				when 'CPRE' then 'Pago de Cuentas por Pagar'
				when 'CCRE' then 'Cobro de Cuentas por Cobrar'
				when 'TES'  then 'Pagos Tesoreria'
				when 'TSGS' then 'Viaticos'
				when 'CPND' then 'Neteo de Documentos'
				when 'CCND' then 'Neteo de Documentos'
				when 'CPAP' then 'Aplicacion de Documentos a Favor'
				when 'CCAP' then 'Aplicacion de Documentos a Favor'
				when 'CPPA' then 'Aplicacion de Documentos a Favor'
				when 'CCPA' then 'Aplicacion de Documentos a Favor'
				else 'Desconocido'
			end as descOrigen
		from  CERepositorio
		where Ecodigo = #Session.Ecodigo#
		and origen is not null
	order by descOrigen
</cfquery>

<cfquery name="rsCERepositorio" datasource="#Session.DSN#">
	select hc.Edocumento,hc.Eperiodo,hc.Emes,
		rep.IdRep, rep.IdContable, rep.linea, rep.timbre as UUID,
		rep.numDocumento as Documento,
		rep.rfc,
		rep.origen,
		case rep.origen
			when 'CPFC' then 'Cuentas por Pagar'
			when 'CCFC' then 'Cuentas por Cobrar'
			when 'CPRE' then 'Pago de Cuentas por Pagar'
			when 'CCRE' then 'Cobro de Cuentas por Cobrar'
			when 'TES'  then 'Pagos Tesoreria'
			when 'TSGS' then 'Viaticos'
			when 'CPND' then 'Neteo de Documentos'
			when 'CCND' then 'Neteo de Documentos'
			when 'CPAP' then 'Aplicacion de Documentos a Favor'
			when 'CCAP' then 'Aplicacion de Documentos a Favor'
			when 'CPPA' then 'Aplicacion de Documentos a Favor'
			when 'CCPA' then 'Aplicacion de Documentos a Favor'
			else 'Desconocido'
		end as descOrigen,
		hc.Cconcepto,
		cc.Cdescripcion,
		'<img border=''0'' src=''/cfmx/sif/imagenes/Description.gif'' style=''cursor:pointer'' alt=''Consultar Comprobante'' onclick=''funcMostrarComprobante('+cast(rep.IdContable as varchar)+','+ cast(rep.linea as varchar)+','+ cast(rep.IdRep as varchar)+');''> &nbsp;
		<img border=''0'' src=''/cfmx/sif/imagenes/findsmall.gif'' style=''cursor:pointer'' alt=''Imprimir'' onclick=''funcMostrarPoliza('+ cast(rep.IdContable as varchar)+','+ cast(hc.Eperiodo as varchar)+','+ cast(hc.Emes as varchar)+','+ cast(rep.linea as varchar)+');''>' Botones
	from CERepositorio rep
	inner join HEContables hc
		on rep.IdContable = hc.IDcontable
		and rep.Ecodigo = hc.Ecodigo
	inner join ConceptoContableE cc
		on hc.Cconcepto = cc.Cconcepto
		and hc.Ecodigo = cc.Ecodigo
	where rep.Ecodigo = #Session.Ecodigo#
		and rep.origen is not null
	<cfif isdefined("form.selectLote") and form.selectLote NEQ -1>
		and cc.Cconcepto = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.selectLote#">
	</cfif>
	<cfif isdefined("form.Poliza") and form.Poliza NEQ "">
		and hc.Edocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Poliza#">
	</cfif>
	<cfif isdefined("form.UUID") and form.UUID NEQ "">
		and upper(rep.timbre) like upper('%#form.UUID#%')
	</cfif>
	<cfif isdefined("form.Documento") and form.Documento NEQ "">
		and upper(rep.numDocumento) like upper('%#form.Documento#%')
	</cfif>
	<cfif isdefined("form.RFC") and form.RFC NEQ "">
		and replace(upper(rep.rfc),'-','') like replace(upper('%#form.RFC#%'),'-','')
	</cfif>
	<cfif isdefined("form.selectOrigen") and form.selectOrigen NEQ "-1">
		and rep.origen = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.selectOrigen#">
	</cfif>
	<cfif isdefined("form.periodo") and form.periodo NEQ "-1">
		and hc.Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.periodo#">
	</cfif>
	<cfif isdefined("form.mes") and form.mes NEQ "-1">
		and hc.Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.mes#">
	</cfif>
	order by hc.Eperiodo desc, hc.Emes desc, hc.Edocumento desc, rep.linea
</cfquery>

<cfoutput>
	<form action="ConsultaComprobanteCE.cfm" method="post" name="form1" id="form1">
		<div style="background-color:rgb(232,232,232); width:100%">
			<table align="center" cellpadding="0" cellspacing="2" border="0" width="85%">
				<tr>
					<td nowrap align="right"><strong>#LB_Lote#:</strong></td>
					<td><select type"text" name="selectLote" id="selectLote">
							<option value="-1">-- Seleccione uno --</option>
						<cfloop query="rsLotes">
							<option value="#Cconcepto#" <cfif isdefined('form.selectLote') and form.selectLote EQ #Cconcepto#>selected</cfif>>#Cconcepto#-#Cdescripcion#</option>
						</cfloop>
						</select>
					</td>
					<td nowrap align="right"><strong>#LB_Poliza#:</strong></td>
					<td><input type="text" name="Poliza" id="Poliza" size="20" value="<cfif isdefined("form.Poliza") and form.Poliza NEQ "">#form.Poliza#</cfif>">
					</td>
				</tr>
				<tr>
					<td nowrap align="right"><strong>Periodo:</strong></td>
					<td>
						<select name="periodo" id="periodo">
							<option value="-1"><cf_translate key=LB_Todos>Todos</cf_translate></option>
							<cfloop query="rsPer">
								<option value="#Eperiodo#"
									<cfif isdefined("form.periodo") and form.periodo eq Eperiodo>selected</cfif>
								>
									#Eperiodo#
								</option>
							</cfloop>
						</select>
					</td>
					<td nowrap align="right"><strong>Mes:</strong></td>
					<td>
						<select name="mes" id= "mes">
							<option value="-1"><cf_translate key=LB_Todos>Todos</cf_translate></option>
							<cfloop query="rsMeses">
								<option value="#VSvalor#"
									<cfif isdefined("form.mes") and form.mes eq VSvalor>selected</cfif>
								>
									#VSdesc#
								</option>
							</cfloop>
						</select>
					</td>
				</tr>
				<tr>
					<td nowrap align="right"><strong>#LB_UUID#:</strong></td>
					<td><input type="text" name="UUID" id="UUID" size="20" value="<cfif isdefined("form.UUID") and form.UUID NEQ "">#form.UUID#</cfif>"></td>
					<td nowrap align="right"><strong>#LB_Documento#:</strong>
					<td><input type="text" name="Documento" id="Documento" size="20" value="<cfif isdefined("form.Documento") and form.Documento NEQ "">#form.Documento#</cfif>"></td>
				    </td>
			     <tr valign="baseline">
				     <td nowrap align="right"><strong>#LB_RFC#:</strong></td>
					 <td><input type="text" name="RFC" id="RFC" size="20" value="<cfif isdefined("form.RFC") and form.RFC NEQ "">#form.RFC#</cfif>"></br>
						<font color="red" size="-1">*personas físicas RFC Ej. AASS810823FGD</font></br>
					     <font color="red" size="-1">*personas morales RFC Ej. ASS810802FGD</font></br>
					</td>
					<td nowrap align="right"><strong>#LB_Origen#:</strong></td>
				    <td><select type"text" name="selectOrigen" id="selectOrigen" >
							<option value="-1">-- Seleccione uno --</option>
						<cfloop query="rsOrigenes">
							<option value="#rsOrigenes.origen#" <cfif isdefined('form.selectOrigen') and #form.selectOrigen# eq '#rsOrigenes.origen#'>selected</cfif>>#rsOrigenes.descOrigen#</option>
						</cfloop>
						</select>
					</td>
				<tr>
					<td align="center" colspan="4">
					    <input type="submit" value="#LB_filtrar#" id="btnFriltrar" name="btnFriltrar" class="btnFiltrar" onclick="return funcFiltrar()">
					    <input type="button" value="Limpiar" id="btnLimpiar" name="btnLimpiar" class="btnLimpiar" onclick="funcLimpiar()">
				    </td>
				</tr>

		  </table>
		</div>

		<table align="center" cellpadding="0" cellspacing="2" width="100%" >
			<tr>
				<td colspan="3">
					<cfinvoke
							component="sif.Componentes.pListas"
							method="pListaQuery"
							returnvariable="pListaRet">
								<cfinvokeargument name="query" value="#rsCERepositorio#"/>
								<cfinvokeargument name="desplegar" value="Eperiodo,Emes,Edocumento,linea,UUID, rfc, Documento, descOrigen, Botones"/>
								<cfinvokeargument name="etiquetas" value="Periodo,Mes,Poliza,Linea,#LB_UUID#, #LB_RFC#, #LB_Documento#, #LB_Origen#,"/>
								<cfinvokeargument name="formatos" value="S,S,S,S,S, S, S, S, S"/>
                                <cfinvokeargument name="align" value="left,left,left,left,left, left, left, left, center"/>
								<cfinvokeargument name="ajustar" value="N,N,N,N,N, N, N, N, N"/>
								<cfinvokeargument name="irA" value="ConsultaComprobante.cfm"/>
								<cfinvokeargument name="keys" value="IdRep"/>
								<cfinvokeargument name="showlink" value="false"/>
								<cfinvokeargument name="includeForm" value="false"/>
								<cfinvokeargument name="formName" value="form1"/>
								<cfinvokeargument name="showemptylistmsg" value="true"/>
                                <cfinvokeargument name="MaxRows" value="20"/>
								<cfinvokeargument name="MaxRowsQuery" value = "100">
								<cfinvokeargument name="navegacion" 		value="#navegacion#"/>
						</cfinvoke>
				</td>
			</tr>
		</table>
	</form>
	<table border="0" width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td align="center">
				<cfif isdefined('rsCERepositorio') and #rsCERepositorio.recordcount# GT 0>
					<input type="button" class="btnImprimir" onClick="doPrint()" value="Imprimir">
					<cfelse>
						&nbsp;
				</cfif>
			</td>
		</tr>
	</table>
</cfoutput>

<script language="javascript" type="text/javascript">
	function doPrint(){
	  document.form1.action = 'SQLConsultaComprobanteCE.cfm';
	  document.form1.submit();
	}

	function funcFiltrar(){

		var res;
			 res = true;
		return res;

	}

	var popUpWinIns = 0;
	function popUpWindowIns(URLStr, left, top, width, height){
		if(popUpWinIns){
			if(!popUpWinIns.closed) popUpWinIns.close();
		}
		popUpWinIns = window.open(URLStr, 'popUpWinIns', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,scrolling=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function funcMostrarComprobante(IDContable,Dlinea,IdRep){
		var left = 110;//(window.screen.availWidth - window.screen.width*0.6) /2;
		var top = 50;//(window.screen.availHeight - window.screen.height*0.75) /2;
		popUpWindowIns("/cfmx/sif/ce/consultas/popUp-CEInfoCFDI.cfm?info=1&IDContable=" + IDContable + "&Dlinea=" + Dlinea + "&IdRep=" + IdRep, left+'px', top+'px', window.screen.width*0.6+'px', window.screen.height*0.75+'px');
	}

	function funcMostrarPoliza(idcontable,periodo,mes,linea){
		var left = 110;//(window.screen.availWidth - window.screen.width*0.6) /2;
		var top = 50;//(window.screen.availHeight - window.screen.height*0.75) /2;
		popUpWindowIns("/cfmx/sif/ce/consultas/popUp-CEPoliza.cfm?IDContable=" + idcontable + "&Periodo=" + periodo + "&Mes=" + mes + "&linea=" + linea, left+'px', top+'px', window.screen.width*0.8+'px', window.screen.height*0.75+'px');
	}

	function funcLimpiar(){
	  var selectLote = document.getElementById("selectLote");
	  if (selectLote) selectLote.value = "-1";
	  var Poliza = document.getElementById("Poliza");
	  if (Poliza) Poliza.value = "";
	  var periodo = document.getElementById("periodo");
	  if (periodo) periodo.value = "-1";
	  var mes = document.getElementById("mes");
	  if (mes) mes.value = "-1";
	  var UUID = document.getElementById("UUID");
	  if (UUID) UUID.value = "";
	  var Documento = document.getElementById("Documento");
	  if (Documento) Documento.value = "";
	  var RFC = document.getElementById("RFC");
	  if (RFC) RFC.value = "";
	  var selectOrigen = document.getElementById("selectOrigen");
	  if (selectOrigen) selectOrigen.value = "-1";
	}
</script>

