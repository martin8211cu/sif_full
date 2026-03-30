<cfinvoke  key="BTN_Regresar" default="Regresar" component="sif.Componentes.Translate" method="Translate"
returnvariable="BTN_Regresar" xmlfile="/sif/generales.xml"/>
<cfinvoke  key="BTN_Filtrar" default="Filtrar" component="sif.Componentes.Translate" method="Translate"
returnvariable="BTN_Filtrar" xmlfile="/sif/generales.xml"/>
<cfinvoke  key="BTN_Limpiar" default="Limpiar" component="sif.Componentes.Translate" method="Translate"
returnvariable="BTN_Limpiar" xmlfile="/sif/generales.xml"/>
<cfinvoke  key="LB_Titulo" default="Lista de Documentos de Interfaz" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Titulo" xmlfile="ConsultaI10.xml"/>
<cfinvoke  key="LB_Descripcion" default="Descripci&oacute;n" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Descripcion" xmlfile="ConsultaI10.xml"/>
<cfinvoke  key="LB_Fecha" default="Fecha" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Fecha" xmlfile="ConsultaI10.xml"/>
<cfinvoke  key="LB_Periodo" default="Periodo" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Periodo" xmlfile="ConsultaI10.xml"/>
<cfinvoke  key="LB_Moneda" default="Moneda" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Moneda" xmlfile="ConsultaI10.xml"/>
<cfinvoke  key="LB_Mes" default="Mes" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Mes" xmlfile="ConsultaI10.xml"/>
<cfinvoke  key="LB_Origen" default="Origen" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Origen" xmlfile="ConsultaI10.xml"/>
<cfinvoke  key="LB_Usuario" default="Usuario" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Usuario" xmlfile="ConsultaI10.xml"/>
<cfinvoke  key="LB_Lote" default="Lote" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Lote" xmlfile="ConsultaI10.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_EstaSeguro" Default="¿Está seguro de que desea aplicar los documentos seleccionadas?"	 returnvariable="LB_EstaSeguro"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_NoEstaMes1" Default="No se encuentra en el primer mes contable para utilizar este proceso"	 returnvariable="MSG_NoEstaMes1"/>


<cfset navegacion ="a=1">
<cfif isdefined("form.origen") and form.origen NEQ "-1">
	<cfset navegacion = navegacion & "&origen=#form.origen#">
</cfif>
<cfif isdefined("form.documento") and form.documento NEQ "">
	<cfset navegacion = navegacion & "&documento=#form.documento#">
</cfif>
<cfif isdefined("form.Timbre") and form.Timbre NEQ "">
	<cfset navegacion = navegacion & "&Timbre=#form.Timbre#">
</cfif>
<cfif isdefined("form.Mcodigo") and form.Mcodigo NEQ "-1">
	<cfset navegacion = navegacion & "&Mcodigo=#form.Mcodigo#">
</cfif>
<cfif isdefined("form.mtoTotal") and form.mtoTotal NEQ "" and form.mtoTotal GT 0>
	<cfset navegacion = navegacion & "&mtoTotal=#LSParseNumber(form.mtoTotal)#">
</cfif>
<cfif isdefined("form.estado") and form.estado NEQ "" and form.estado GT 0>
	<cfset navegacion = navegacion & "&estado=#form.estado#">
</cfif>
<cfif isDefined("form.fechaIni") AND #form.fechaIni# NEQ "">
	<cfset navegacion = navegacion & "&fechaIni=#form.fechaIni#">
</cfif>
<cfif isDefined("form.fechaFin") AND #form.fechaFin# NEQ "">
	<cfset navegacion = navegacion & "&fechaFin=#form.fechaFin#">
</cfif>
<cfif isdefined("form.comprobante")  AND form.comprobante NEQ "-1">
	<cfset navegacion = navegacion & "&comprobante=#form.comprobante#">
</cfif>

<cfquery name="rsEstatus" datasource="sifinterfaces">
	SELECT DISTINCT ibp.StatusProceso,
		case ibp.StatusProceso
			when 0 then 'Inactivo'
			when 1 then 'Pendiente'
			when 2 then 'Finalizado Exitosamente'
			when 3 then 'Error en Proceso'
			when 4 then 'Pendiente proceso Contable'
			when 5 then 'Pendiente Proceso Auxiliar'
			when 6 then 'Error en Proceso Contable'
			when 10 then 'Proceso en Ejecucion'
			when 11 then 'Proceso en Ejecucion Complementario'
			when 12 then 'Proceso en Ejecucion Auxliar'
			when 13 then 'Proceso en Ejecucion Auxiliar Complementario'
			when 92 then 'Registro Listo para cargarse a Interfaz sin Proceso Pendiente'
			when 94 then 'Registro Listo para cargarse a Interfaz con proceso Pendiente'
			when 95 then 'Registro Listo para cargarse a Interfaz con proceso Pendiente'
			when 99 then 'Proceso en Cola'
			when 100 then 'Proceso Complementario en Cola'
			else ''
		end DescStatus
	FROM IE10 i10
	inner join ID10 id10
		on i10.ID = id10.ID
	inner join InterfazBitacoraProcesos ibp
		on i10.ID = ibp.IdProceso
	order by 1
</cfquery>


<!---
	PINTADO DEL FORM
--->
<script language="javascript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<script language="JavaScript1.2" type="text/javascript" src="../../../js/sinbotones.js"></script>
<cf_templateheader title="#LB_Titulo#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo=#LB_Titulo#>
		<cfinclude template="../../../portlets/pNavegacion.cfm">
		<cfform action="" method="post" name="formPrepara" style="margin:0;" onSubmit="return sinbotones()">
		</cfform>

		<cfoutput>

<!--- navegacion -params  --->
<cfset navegacion = "">
<cfif isdefined("url.origen") and len(trim(url.origen)) and not isdefined("form.origen")>
	<cfset form.origen = url.origen >
</cfif>
<cfif isdefined("form.origen") and form.origen NEQ "-1">
	<cfset navegacion = navegacion & "&origen=#form.origen#">
</cfif>
<cfif isdefined("url.documento") and len(trim(url.documento)) and not isdefined("form.documento")>
	<cfset form.documento = url.documento >
</cfif>
<cfif isdefined("form.documento") and form.documento NEQ "">
	<cfset navegacion = navegacion & "&documento=#form.documento#">
</cfif>
<cfif isdefined("url.Timbre") and len(trim(url.Timbre)) and not isdefined("form.Timbre")>
	<cfset form.Timbre = url.Timbre >
</cfif>
<cfif isdefined("form.Timbre") and form.Timbre NEQ "">
	<cfset navegacion = navegacion & "&Timbre=#form.Timbre#">
</cfif>
<cfif isdefined("url.Mcodigo") and len(trim(url.Mcodigo)) and not isdefined("form.Mcodigo")>
	<cfset form.Mcodigo = url.Mcodigo >
</cfif>
<cfif isdefined("form.Mcodigo") and form.Mcodigo NEQ "-1">
	<cfset navegacion = navegacion & "&Mcodigo=#form.Mcodigo#">
</cfif>
<cfif isdefined("url.mtoTotal") and len(trim(url.mtoTotal)) and not isdefined("form.mtoTotal")>
	<cfset form.mtoTotal = url.mtoTotal >
</cfif>
<cfif isdefined("form.mtoTotal") and form.mtoTotal NEQ "" and form.mtoTotal GT 0>
	<cfset navegacion = navegacion & "&mtoTotal=#form.mtoTotal#">
</cfif>
<cfif isdefined("url.estado") and len(trim(url.estado)) and not isdefined("form.estado")>
	<cfset form.estado = url.estado >
</cfif>
<cfif isdefined("form.estado") and form.estado NEQ "" and form.estado GT 0>
	<cfset navegacion = navegacion & "&estado=#form.estado#">
</cfif>
<cfif isdefined("url.fechaIni") and len(trim(url.fechaIni)) and not isdefined("form.fechaIni")>
	<cfset form.fechaIni = url.fechaIni >
</cfif>
<cfif isDefined("form.fechaIni") AND #form.fechaIni# NEQ "">
	<cfset navegacion = navegacion & "&fechaIni=#form.fechaIni#">
</cfif>
<cfif isdefined("url.fechaFin") and len(trim(url.fechaFin)) and not isdefined("form.fechaFin")>
	<cfset form.fechaFin = url.fechaFin >
</cfif>
<cfif isDefined("form.fechaFin") AND #form.fechaFin# NEQ "">
	<cfset navegacion = navegacion & "&fechaFin=#form.fechaFin#">
</cfif>
<cfif isdefined("url.comprobante") and len(trim(url.comprobante)) and not isdefined("form.comprobante")>
	<cfset form.comprobante = url.comprobante >
</cfif>
<cfif isdefined("form.comprobante")  AND form.comprobante NEQ "-1">
	<cfset navegacion = navegacion & "&comprobante=#form.comprobante#">
</cfif>

		<cfform action="ConsultaI10.cfm" method="post" name="formfiltro" style="margin:0;">
			<table width="100%"  border="0" cellspacing="1" cellpadding="1" class="AreaFiltro" style="margin:0;">
				<tr>
                	<td><b>Auxiliar</b></td>
					<td width="3%"><b><cf_translate key=LB_Documento>Documento</cf_translate></b></td>
				    <td width="5%"><b><cf_translate key=LB_Referencia>Timbre</cf_translate> </b></td>
                    <td><b>Monto</b></td>
				</tr>
				<tr>
                	<td >
                    	<select name="origen" id="origen">
                            <option value="-1"><cf_translate key=LB_Todos>Todos</cf_translate></option>
                            <option value="CC" <cfif isdefined("form.origen") and form.origen eq 'CC'>selected</cfif> >Cuentas por Cobrar</option>
                            <option value="CP" <cfif isdefined("form.origen") and form.origen eq 'CP'>selected</cfif>>Cuentas por Pagar</option>
                        </select>
                    </td>
					<td>
						<input type="text" name="Documento" id = "Documento" size="23" maxlength="100" value="<cfif isdefined('form.Documento')>#form.Documento#</cfif>">
					</td>
					<td>
						<input type="text" name="Timbre" id = "Timbre" size="23" maxlength="36" value="<cfif isdefined('form.Timbre')>#form.Timbre#</cfif>">
					</td>
					<td>
					<cfset LvarValue = "0.00">
					<cfif isdefined("form.mtoTotal") and isnumeric(LSParseNumber(form.mtoTotal)) and LSParseNumber(form.mtoTotal) GT 0>
						<cfset LvarValue = "#LSParseNumber(form.mtoTotal)#">
					</cfif>
					<cf_inputNumber name="mtoTotal" value="#LvarValue#" DECIMALES="2" ENTEROS="15">
				</td>
					<td align="center">
	                    <input type="hidden" name="hdFiltrar" id="hdFiltrar" value="1" />
	                    <input type="button" name="bFiltrar" id="bFiltrar" onClick="filtrar()" value="#BTN_Filtrar#" class="btnFiltrar">
						<input name="btnLimpiar"  type="button" id="btnLimpiar"  value="#BTN_Limpiar#" onClick="javascript:Limpiar(this.form);"  class="btnLimpiar">
					</td>
		       </tr>
			   <tr>
				   	<td><b>Estado</b></td>
					<td><b>#LB_Fecha# Registro Inicial</b></td>
				    <td><b>#LB_Fecha# Registro Final</b></td>
					<td><b>#LB_Moneda#</b></td>
					<td><b>Comprobante</b></td>
                    <td></td>
			 </tr>
			 <tr>
				<td >
                	<select name="estado" id="estado">
                        <option value="-1"><cf_translate key=LB_Todos>Todos</cf_translate></option>
						<cfloop query="rsEstatus">
                        	<option value="#StatusProceso#" <cfif isdefined("form.estado") and form.estado eq '#rsEstatus.StatusProceso#'>selected</cfif> >#DescStatus#</option>
                        </cfloop>
                    </select>
                </td>
			    <td>
					<cfset fechaIni = ''>
					<cfif isdefined("form.fechaIni") and len(trim(form.fechaIni))>
						<cfset fechaIni = form.fechaIni>
					</cfif>
					<cf_sifcalendario name="fechaIni" value="#fechaIni#" form="formfiltro">
				</td>
				<td>
					<cfset fechaFin = ''>
					<cfif isdefined("form.fechaFin") and len(trim(form.fechaFin))>
						<cfset fechaFin = form.fechaFin>
					</cfif>
					<cf_sifcalendario name="fechaFin" value="#fechaFin#" form="formfiltro">
				</td>
				<td>
					<cfset vMcodigo = "-1">
					<cfif isdefined("form.Mcodigo") and len(trim(form.Mcodigo))>
						<cfset vMcodigo = form.Mcodigo>
					</cfif>
					<cf_sifmonedas value="#vMcodigo#" tabindex="1" Todas="S" onchange="funcChMoneda(this.value)">
				</td>
				<td >
                	<select name="comprobante" id="comprobante">
                        <option value="-1"><cf_translate key=LB_Todos>Todos</cf_translate></option>
                        <option value="CC" <cfif isdefined("form.comprobante") and form.comprobante eq 'CC'>selected</cfif> >Con Comprobante</option>
                        <option value="SC" <cfif isdefined("form.comprobante") and form.comprobante eq 'SC'>selected</cfif>>Sin Comprobante</option>
                    </select>
                </td>
			</tr>
		</table>
		</cfform>
		</cfoutput>

		<cfoutput>
		<form name="form1" method="post" action="ConsultaI10-SQL.cfm" style="margin:0;">
			<input name="PageNum_lista" type="hidden" value="<cfif isdefined("form.PageNum_lista") and len(trim(form.PageNum_lista))>#form.PageNum_lista#</cfif>" tabindex="-1">
            <cfif isdefined("form.origen") and form.origen NEQ "-1">
				<input name="origen" type="hidden" value="<cfif isdefined("form.origen") and len(trim(form.origen)) >#form.origen#</cfif>" tabindex="-1">
			</cfif>
			<cfif isdefined("form.documento") and form.documento NEQ "">
				<input name="Documento" type="hidden" value="<cfif isdefined("form.Documento") and len(trim(form.Documento)) >#form.Documento#</cfif>" tabindex="-1">
			</cfif>
			<cfif isdefined("form.Timbre") and form.Timbre NEQ "">
				<input name="Timbre" type="hidden" value="<cfif isdefined("form.Timbre") and len(trim(form.Timbre)) >#form.Timbre#</cfif>" tabindex="-1">
			</cfif>
			<cfif isdefined("form.Mcodigo") and form.Mcodigo NEQ "-1">
				<input name="Mcodigo" type="hidden" value="<cfif isdefined("form.Mcodigo") and len(trim(form.Mcodigo)) >#form.Mcodigo#</cfif>" tabindex="-1">
			</cfif>
			<cfif isdefined("form.mtoTotal") and form.mtoTotal NEQ "" and form.mtoTotal GT 0>
				<input name="mtoTotal" type="hidden" value="<cfif isdefined("form.mtoTotal") and len(trim(form.mtoTotal)) >#form.mtoTotal#</cfif>" tabindex="-1">
			</cfif>
			<cfif isdefined("form.estado") and form.estado NEQ "" and form.estado GT 0>
				<input name="estado" type="hidden" value="<cfif isdefined("form.estado") and len(trim(form.estado)) >#form.estado#</cfif>" tabindex="-1">
			</cfif>
			<cfif isDefined("form.fechaIni") AND #form.fechaIni# NEQ "">
				<input name="fechaIni" type="hidden" value="<cfif isdefined("form.fechaIni") and len(trim(form.fechaIni)) >#form.fechaIni#</cfif>" tabindex="-1">
			</cfif>
			<cfif isDefined("form.fechaFin") AND #form.fechaFin# NEQ "">
				<input name="fechaFin" type="hidden" value="<cfif isdefined("form.fechaFin") and len(trim(form.fechaFin)) >#form.fechaFin#</cfif>" tabindex="-1">
			</cfif>
			<cfif isdefined("form.comprobante")  AND form.comprobante NEQ "-1">
				<input name="comprobante" type="hidden" value="<cfif isdefined("form.comprobante") and len(trim(form.comprobante)) >#form.comprobante#</cfif>" tabindex="-1">
			</cfif>
		<!--- <cfif (isdefined("form.hdfiltrar") and form.hdfiltrar eq 1) or (isdefined("form.hdInit") and form.hdInit eq 1)> --->
			<cfset form.ver = 15 >
			<cfset vMon = "">
			<cfquery name="rsmoneda" datasource="#Session.DSN#">
				SELECT Miso4217  FROM Monedas
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					<cfif isdefined("form.Mcodigo")>
					and Mcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Mcodigo#">
					<cfelse>
						and 1=2 <!--- para que no traiga registros --->
					</cfif>
			</cfquery>
			<cfif rsMoneda.recordCount GT 0>
				<cfset vMon = rsMoneda.Miso4217>
			</cfif>
			<cfquery name="rsLista" datasource="sifinterfaces">
				SELECT i10.ID, i10.EcodigoSDC, Modulo,
					Documento,TimbreFiscal,ibp.StatusProceso,
					CONVERT(VARCHAR(10),FechaDocumento,126) FechaDocumento, CONVERT(VARCHAR(10),ibp.FechaInclusion,126) FechaInclusion, i10.CodigoMoneda, sum(id10.CantidadTotal) Monto,
					case ibp.StatusProceso
						when 0 then 'Inactivo'
						when 1 then 'Pendiente'
						when 2 then 'Finalizado Exitosamente'
						when 3 then 'Error en Proceso'
						when 4 then 'Pendiente proceso Contable'
						when 5 then 'Pendiente Proceso Auxiliar'
						when 6 then 'Error en Proceso Contable'
						when 10 then 'Proceso en Ejecucion'
						when 11 then 'Proceso en Ejecucion Complementario'
						when 12 then 'Proceso en Ejecucion Auxliar'
						when 13 then 'Proceso en Ejecucion Auxiliar Complementario'
						when 92 then 'Registro Listo para cargarse a Interfaz sin Proceso Pendiente'
						when 94 then 'Registro Listo para cargarse a Interfaz con proceso Pendiente'
						when 95 then 'Registro Listo para cargarse a Interfaz con proceso Pendiente'
						when 99 then 'Proceso en Cola'
						when 100 then 'Proceso Complementario en Cola'
						else ''
					end DescStatus
				FROM IE10 i10
				inner join ID10 id10
					on i10.ID = id10.ID
				inner join InterfazBitacoraProcesos ibp
					on i10.ID = ibp.IdProceso
				group by i10.ID, i10.EcodigoSDC, Modulo,Documento,TimbreFiscal,ibp.StatusProceso,
					FechaDocumento, ibp.FechaInclusion, i10.CodigoMoneda
				HAVING i10.EcodigoSDC = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.EcodigoSDC#">
				<cfif isdefined("form.origen") and form.origen NEQ "-1">
					and i10.Modulo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.origen#">
				</cfif>
				<cfif isdefined("form.documento") and form.documento NEQ "">
					and upper(i10.Documento) like upper('%#form.documento#%')
				</cfif>
				<cfif isdefined("form.Timbre") and form.Timbre NEQ "">
					and upper(i10.TimbreFiscal) like upper('%#form.Timbre#%')
				</cfif>
				<cfif vMon NEQ "">
					and i10.CodigoMoneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vMon#">
				</cfif>
				<cfif isdefined("form.mtoTotal") and form.mtoTotal NEQ "" and form.mtoTotal GT 0>
					and sum(id10.CantidadTotal) = <cfqueryparam cfsqltype="cf_sql_money" value="#LSParseNumber(form.mtoTotal)#">
				</cfif>
				<cfif isdefined("form.estado") and form.estado NEQ "" and form.estado GT 0>
					and ibp.StatusProceso = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.estado#">
				</cfif>
				<cfif isDefined("form.fechaIni") AND #form.fechaIni# NEQ "">
					and <cf_dbfunction name="to_date00" args="FechaDocumento"> >= #LSParseDateTime(listgetat(form.fechaIni, 1))#
					<!--- DATEDIFF(dd, FechaDocumento, <cfqueryparam value="#form.fechaIni#" cfsqltype="cf_sql_date">) = 0 --->
				</cfif>
				<cfif isDefined("form.fechaFin") AND #form.fechaFin# NEQ "">
					and <cf_dbfunction name="to_date00" args="FechaDocumento"> <= #LSParseDateTime(listgetat(form.fechaFin, 1))#
					<!--- DATEDIFF(dd, ibp.FechaInclusion, <cfqueryparam value="#form.fechaFin#" cfsqltype="cf_sql_date">) = 0 --->
				</cfif>
				<cfif isdefined("form.comprobante") AND form.comprobante NEQ "-1">
					<cfif form.comprobante EQ "CC">
						and TimbreFiscal is not null and ltrim(rtrim(TimbreFiscal)) <> ''
					<cfelseif form.comprobante EQ "SC">
						and (TimbreFiscal is null or ltrim(rtrim(TimbreFiscal)) = '')
					</cfif>
				</cfif>
				order by FechaDocumento Desc
			</cfquery>
		<!--- </cfif> --->
		<cfset LvarBotones = 'Imprimir'>
		<cfset LvarDesplegar = 'Modulo,Documento,TimbreFiscal,DescStatus,FechaDocumento,FechaInclusion, CodigoMoneda, Monto'>
		<cfset LvarEtiquetas = 'Origen,Documento,Timbre,Estado,Fecha Registro,Fecha Inserci&oacute;n,Moneda, Monto'>
		<cfset LvaFormato = 'S,S,S,S,D,D,S,M'>
		<cfset LvarAlign = 'left, left, left, left, left, left, center, right'>

		<!--- <cfif (isdefined("form.hdfiltrar") and form.hdfiltrar eq 1) or (isdefined("form.hdInit") and form.hdInit eq 1)> --->
			<input type="hidden" name="hdInit" id="hdInit" value="1" />
			<cfinvoke
             component="sif.Componentes.pListas"
             method="pListaQuery"
             returnvariable="pListaRet">
				<cfinvokeargument name="Conexion" 			value="sifinterfaces">
                <cfinvokeargument name="query" 				value="#rsLista#"/>
                <cfinvokeargument name="desplegar" 			value="#LvarDesplegar#"/>
                <cfinvokeargument name="etiquetas" 			value="#LvarEtiquetas#"/>
                <cfinvokeargument name="formatos" 			value="#LvaFormato#"/>
                <cfinvokeargument name="align" 				value="#LvarAlign#"/>
                <cfinvokeargument name="ajustar" 			value="S"/>
                <cfinvokeargument name="irA" 				value="ConsultaI10.cfm"/>
                <cfinvokeargument name="keys" 				value="ID"/>
                <cfinvokeargument name="incluyeform"		value="false"/>
                <cfinvokeargument name="formname" 			value="form1"/>
                <!--- <cfinvokeargument name="botones" 			value="#LvarBotones#"/> --->
                <cfinvokeargument name="maxrows" 			value="#form.ver#"/>
				<cfinvokeargument name="MaxRowsQuery" 		value="500"/>
                <cfinvokeargument name="navegacion" 		value="#navegacion#"/>
                <cfinvokeargument name="showEmptyListMsg" 	value="true"/>
                <cfinvokeargument name="showLink" 			value="false"/>
            </cfinvoke>
        <!--- </cfif> --->
		</form>
		</cfoutput>
	<table border="0" width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td align="center">
				<cfif isdefined('rsLista') and #rsLista.recordcount# GT 0>
					<input type="button" class="btnImprimir" onClick="doPrint()" value="Imprimir">
					<cfelse>
						&nbsp;
				</cfif>
			</td>
		</tr>
	</table>
	<cf_web_portlet_end>
<cf_templatefooter>
<cfoutput>
<script language="javascript" type="text/javascript">
<cfif isDefined("varUsaAJAX")>
	filtrar();
</cfif>
	function filtrar(){
	  //document.formfiltro.action = 'ConsultaI10.cfm';
	  document.formfiltro.submit();
	}

	function Limpiar(valor){
	  var forigen = document.getElementById("origen");
	  if (forigen) forigen.value = "-1";
	  var fdoc = document.getElementById("Documento");
	  if (fdoc) fdoc.value = "";
	  var ftimbre = document.getElementById("Timbre");
	  if (ftimbre) ftimbre.value = "";
	  var fmonto = document.getElementById("mtoTotal");
	  if (fmonto) fmonto.value = "0.00";
	  var festado = document.getElementById("estado");
	  if (festado) festado.value = "-1";
	  var ffechI = document.getElementById("fechaIni");
	  if (ffechI) ffechI.value = "";
	  var ffechF = document.getElementById("fechaFin");
	  if (ffechF) ffechF.value = "";
	  var fmcodigo = document.getElementById("Mcodigo");
	  if (fmcodigo) fmcodigo.value = "-1";
	  var fcomp = document.getElementById("comprobante");
	  if (fcomp) fcomp.value = "-1";
	}

	function doPrint(){
	  //document.formfiltro.action = 'ConsultaI10.cfm';
	  document.form1.submit();
	}
</script>
</cfoutput>