<cfparam name="LvarReporteFinal" default="false">
<cfparam name="consultar_Ecodigo" default="#session.Ecodigo#">
<cfset session.CPformTipo = "registro">
<cfset control = 0>
	<cfquery name="rsTraslado" datasource="#session.dsn#">
		select 	
			case a.CPDEtipoAsignacion 
				when '0' then 'Asignaci&oacute;n de Cuenta a Cuenta' 
				when '1' then 'Distribuci&oacute;n equitativa'
				when '2' then 'Asignaci&oacute;n manual de montos'
				when '4' then 'Distribuci&oacute;n por pesos' 
			end as CPDEtipoAsignacion,
			a.CPDEid
			,tt.CPTTcodigo
			,<cf_dbfunction name="concat" args="' ',case CPTTtipo when 'I' then ' (Interno)' when 'E' then ' (Externa)' end"> as CPTTdescripcion
			,a.CPPid
			,a.CPDEfecha 
			,a.CPDEfechaDocumento 
			,CPDEnumeroDocumento
			,a.CPDEtipoDocumento 
			,a.CPDEdescripcion
			,a.CPDEmsgRechazo 
			,a.Usucodigo
			,a.CPCano
			,a.CPCmes 
			,a.CPTTid, a.CPDAEid, a.CPDEjustificacion
			,tt.CPTTtipoCta
			,CPPtipoPeriodo
			,CPPfechaDesde
			,CPPfechaHasta
			,a.ts_rversion
			,c.CFid as CFidOrigen
			,c.CFcodigo as CFcodigoOrigen
			,c.CFdescripcion as CFdescripcionOrigen
			,d.Ocodigo as OcodigoOrigen
			,d.Odescripcion as Oficina1
			,e.CFid as CFidDestino
			,e.CFcodigo as CFcodigoDestino
			,e.CFdescripcion as CFdescripcionDestino
			,f.Ocodigo as OcodigoDestino
			,f.Odescripcion as Oficina2
			from CPDocumentoE a
					inner join CPresupuestoPeriodo b
						on b.CPPid = a.CPPid
					
					inner join CFuncional c
						on c.CFid = a.CFidOrigen
					
					inner join Oficinas d
						on  d.Ecodigo = c.Ecodigo
						and d.Ocodigo = c.Ocodigo
	
					inner join CFuncional e
						on e.CFid = a.CFidDestino 
	
					inner join Oficinas f
						on  f.Ecodigo = e.Ecodigo
						and f.Ocodigo = e.Ocodigo
	
					inner join CPtipoTraslado tt
						on a.CPTTid = tt.CPTTid
			where a.Ecodigo = #Session.Ecodigo#
			and a.CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPDEid#">
			and a.CPDEtipoDocumento in ('T','E')
			and b.Ecodigo = a.Ecodigo
			and c.Ecodigo = a.Ecodigo
			and e.Ecodigo = a.Ecodigo
	</cfquery>

	<cfset MaxElements = 10>
	<cfparam name="LvarTrasladoExterno" default="false">

	<cfquery name="rsPartidasOrigen" datasource="#Session.DSN#">
		select a.CPDEid, 
			   a.CPDDlinea, 
			   a.CPDDtipo, 
			   a.CPCano, 
			   a.CPCmes, 
			   a.CPcuenta, 
			   a.CPDDmonto, 
			   coalesce(a.CPDDpeso, 0) as CPDDpeso,
			   b.CPformato,
			   coalesce(b.CPdescripcionF,b.CPdescripcion) as CPdescripcion,
			   a.CPPid, 
			   a.ts_rversion
		from CPDocumentoD a
        	inner join CPresupuesto b
            on b.CPcuenta = a.CPcuenta
		where a.CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPDEid#">
		  and a.CPDDtipo = -1
		  and b.Ecodigo = #Session.Ecodigo#
		order by a.CPDDlinea desc
	</cfquery>
	<cfset MaxOrigen = rsPartidasOrigen.recordCount>
	<cfset MaxElements = Max((MaxOrigen+5), MaxElements)>
	
	<cfquery name="rsPartidasDestino" datasource="#Session.DSN#">
		select a.CPDEid, 
			   a.CPDDlinea, 
			   a.CPDDtipo, 
			   a.CPCano, 
			   a.CPCmes, 
			   a.CPcuenta, 
			   a.CPDDmonto, 
			   coalesce(a.CPDDpeso, 0) as CPDDpeso,
			   b.CPformato,
			   coalesce(b.CPdescripcionF,b.CPdescripcion) as CPdescripcion,
			   a.ts_rversion
		from CPDocumentoD a
        	inner join CPresupuesto b
            on b.CPcuenta = a.CPcuenta
		where a.CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPDEid#">
		  and a.CPDDtipo = 1
		  and b.Ecodigo = #Session.Ecodigo#
		order by a.CPDDlinea asc
	</cfquery>
	<cfset MaxDestino = rsPartidasDestino.recordCount>
	<cfset MaxElements = Max((MaxDestino+5), MaxElements)>	
	
	
	<cf_dbfunction name="OP_concat" returnvariable="_CAT">
	<cf_dbfunction name="to_char" args="CPDDid" isnumber="no" returnvariable="LvarCPDDid">
	
	<cfquery name="rsDocs" datasource="#Session.DSN#">
		select 
				'<img src="/cfmx/sif/imagenes/OP/page-down.gif" 	alt="Download"				style="cursor:pointer"	onclick="sbOP(2,'	#_CAT# #preserveSingleQuotes(LvarCPDDid)# #_CAT# ')">' 
				as OP,
				CPDDid, CPDDdescripcion, CPDDarchivo
		  from CPDocumentoEDocs
		 where CPDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPDEid#">
	</cfquery>

	<cfset meses = "Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre">
	<cfset DescripcionPeriodo = 'Presupuesto '>
	<cfset fecha = DateFormat(rsTraslado.CPDEfechaDocumento, 'dd/mm/yyyy')>
     
    <cfswitch expression="#rsTraslado.CPPtipoPeriodo#">
        <cfcase value="1"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Mensual'></cfcase>
        <cfcase value="2"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Bimestral'></cfcase>
        <cfcase value="3"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Trimestral'></cfcase>
        <cfcase value="4"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Cuatrimestral'></cfcase>
        <cfcase value="6"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Semestral'></cfcase>
        <cfcase value="12"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Anual'></cfcase>
        <cfdefaultcase><cfset DescripcionPeriodo = DescripcionPeriodo & ''></cfdefaultcase>
    </cfswitch>
    
    <cfset DescripcionPeriodo = DescripcionPeriodo & ' de '>
     
    <cfswitch expression="#Month(rsTraslado.CPPfechaDesde)#">
        <cfcase value="1"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Enero'></cfcase>
        <cfcase value="2"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Febrero'></cfcase>
        <cfcase value="3"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Marzo'></cfcase>
        <cfcase value="4"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Abril'></cfcase>
        <cfcase value="5"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Mayo'></cfcase>
        <cfcase value="6"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Junio'></cfcase>
        <cfcase value="7"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Julio'></cfcase>
        <cfcase value="8"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Agosto'></cfcase>
        <cfcase value="9"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Setiembre'></cfcase>
        <cfcase value="10"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Octubre'></cfcase>
        <cfcase value="11"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Noviembre'></cfcase>
        <cfcase value="12"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Diciembre'></cfcase>
        <cfdefaultcase><cfset DescripcionPeriodo = DescripcionPeriodo & ''></cfdefaultcase>
    </cfswitch>
    <cfset DescripcionPeriodo = DescripcionPeriodo & ' #Year(rsTraslado.CPPfechaDesde)# a '>
    
    <cfswitch expression="#Month(rsTraslado.CPPfechaHasta)#">
        <cfcase value="1"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Enero'></cfcase>
        <cfcase value="2"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Febrero'></cfcase>
        <cfcase value="3"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Marzo'></cfcase>
        <cfcase value="4"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Abril'></cfcase>
        <cfcase value="5"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Mayo'></cfcase>
        <cfcase value="6"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Junio'></cfcase>
        <cfcase value="7"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Julio'></cfcase>
        <cfcase value="8"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Agosto'></cfcase>
        <cfcase value="9"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Setiembre'></cfcase>
        <cfcase value="10"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Octubre'></cfcase>
        <cfcase value="11"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Noviembre'></cfcase>
        <cfcase value="12"><cfset DescripcionPeriodo = DescripcionPeriodo & 'Diciembre'></cfcase>
        <cfdefaultcase><cfset DescripcionPeriodo = DescripcionPeriodo & ''></cfdefaultcase>
    </cfswitch>    
    <cfset DescripcionPeriodo = DescripcionPeriodo & ' #Year(rsTraslado.CPPfechaHasta)#'>


<cfoutput query="rsTraslado" group="CPDEid"> 
<cfinclude template="AREA_HEADER.cfm"><br>
<table width="99%" align="center"  border="0" cellspacing="0" cellpadding="2">
  <tr>
		<td colspan="5" class="tituloListas"><strong><cf_translate key="LB_DatosDeLTraslado">Datos del Traslado de Presupuesto</cf_translate></strong></td>
  </tr>
  <tr>
		<td colspan="4"><strong>#CPDEdescripcion#</strong></td>
  </tr>
  <tr>
		<td valign="top"><strong><cf_translate key="LB_NumeroDeDocumento">Periodo</cf_translate>&nbsp;:&nbsp;</strong></td>
		<td valign="top">#DescripcionPeriodo#</td>
		<td valign="top"><strong><cf_translate key="LB_Comprador">Fecha Doc</cf_translate>&nbsp;:&nbsp;</strong></td>
		<td valign="top">#fecha#</td>
  </tr>
  <tr>
		<td valign="top"><strong><cf_translate key="LB_NumeroDeDocumento">Año</cf_translate>&nbsp;:&nbsp;</strong></td>
		<td valign="top">#CPCano#</td>
		<td valign="top"><strong><cf_translate key="LB_Comprador">Mes</cf_translate>&nbsp;:&nbsp;</strong></td>
		<td valign="top">#ListGetAt(meses, CPCmes, ',')#</td>
  </tr>  
  <tr>
		<td valign="top"><strong><cf_translate key="LB_NumeroDeDocumento">N&uacute;mero de Documento</cf_translate>&nbsp;:&nbsp;</strong></td>
		<td valign="top">#CPDEnumeroDocumento#</td>
		<td valign="top"><strong><cf_translate key="LB_Comprador">Base Traslado</cf_translate>&nbsp;:&nbsp;</strong></td>
		<td valign="top">#CPDEtipoAsignacion#</td>
  </tr>
 	<tr>
		<td valign="top"><strong><cf_translate key="LB_Observaciones">C. F. Origen</cf_translate>&nbsp;:&nbsp;</strong></td>
		<td valign="top">#CFcodigoOrigen# - #CFdescripcionOrigen#</td>
  </tr>
 	<tr>
		<td valign="top"><strong><cf_translate key="LB_CentroFuncional">C. F. Destino</cf_translate>&nbsp;:&nbsp;</strong></td>
		<td valign="top">#CFcodigoDestino# - #CFdescripcionDestino#</td>
		<td valign="top"><strong><cf_translate key="LB_TipoDeCambio">Motivo Rechazo:</cf_translate>&nbsp;</strong></td>
		<td valign="top">#CPDEmsgRechazo#</td>
  </tr>
  <tr>
		<td valign="top"><strong><cf_translate key="LB_FechaDeLaSolicitud">Tipo de Traslado</cf_translate>:&nbsp;</strong></td>
		<td valign="top">#CPTTcodigo#-#CPTTdescripcion#</td>
  </tr>	<tr>
		<td colspan="4">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="4" class="tituloListas" style="border-bottom: 1px solid black;" >
			<strong><cf_translate key="LB_DetallesDeLineasDeLTramite">Detalles</cf_translate></strong>
		</td>
	</tr>
</table>
	
<cfparam name="form.tab" default="0">
	<input type="hidden" name="tab" id="tab" value="<cfoutput>#form.tab#</cfoutput>">
	<cf_tabs width="99%" onclick="tabChange">
		<cf_tab text="Cuentas" selected="#form.tab EQ 0#" id="0">
		<table border="0">
			<tr>
				<td>
					<table cellspacing="2" cellpadding="2" border="0" style="border:solid 1px ##000000">
						<tr>
							<td align="center" valign="top" colspan="2"style="border-bottom:solid 1px ##000000">
								<strong><cf_translate key="LB_NumeroDeDocumento">Partidas Origen</cf_translate></strong>
							</td>
						</tr>
						<tr>
							<td valign="top"><strong><cf_translate key="LB_NumeroDeDocumento">Cuentas de Presupuesto</cf_translate>&nbsp;</strong></td>
							<td valign="top" width="25px" align="right">&nbsp;&nbsp;&nbsp;&nbsp;<strong>Monto</strong></td>
						</tr>
						<cfloop query="rsPartidasOrigen">
							<tr>
								<td valign="top">#rsPartidasOrigen.CPformato# #rsPartidasOrigen.CPdescripcion#</td>
								<td valign="top" align="right">#LSNumberFormat(rsPartidasOrigen.CPDDmonto, ',9.00')#</td>
							</tr>
							<cfif control eq 1>
								<cfset control = 0>
							<cfelse>
								<cfset control = 1>
							</cfif>
						</cfloop>
					</table>
				</td>	
				<td>
					<table>
						<tr>
							<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
							<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
							<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
							<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						</tr>
					</table>
				</td>	
				<td>
					<table cellspacing="2" cellpadding="2" border="0" style="border:solid 1px ##000000">
						<tr>
							<td align="center" valign="top" colspan="2"style="border-bottom:solid 1px ##000000">
								<strong><cf_translate key="LB_Comprador">Partidas Destino</cf_translate></strong>
							</td>
						</tr>
						<tr>
							<td valign="top"><strong><cf_translate key="LB_NumeroDeDocumento">Cuentas de Presupuesto</cf_translate>&nbsp;</strong></td>
							<td valign="top" align="right">&nbsp;&nbsp;&nbsp;<strong>Monto</strong></td>
						</tr>
						<cfloop query="rsPartidasDestino">
							<tr>
								<td valign="top">#rsPartidasDestino.CPformato# #rsPartidasDestino.CPdescripcion#</td>
								<td valign="top" align="right">#LSNumberFormat(rsPartidasDestino.CPDDmonto, ',9.00')#</td>
							</tr>
							<cfif control eq 1>
								<cfset control = 0>
							<cfelse>
								<cfset control = 1>
							</cfif>
						</cfloop>
					</table>
				</td>				
			</tr>
		</table>
		
		<script language="javascript">
			function tabChange(t)
			{
				 document.getElementById("tab").value=t;
				 tab_set_current(t);
			}
	
			function sbOP(op,id)
			{
				document.form1.nosubmit=true;
				
				<cfoutput>
				if (op == 2)
				{
					document.getElementById("ifrDoc").src = '/cfmx/sif/presupuesto/operacion/traslado-sql.cfm?DocOP='+op+'&id='+id+'&CPDEid='+#url.CPDEid#+'&CPformTipo='+'#session.CPformTipo#';
				}
				else
				{
				<cfif LvarTrasladoExterno>
					location.href = '/cfmx/sif/presupuesto/operacion/traslado-sql.cfm?TE&DocOP='+op+'&id='+id+'&CPDEid='+#url.CPDEid#+'&CPformTipo='+'#session.CPformTipo#';
				<cfelse>
					location.href = '/cfmx/sif/presupuesto/operacion/traslado-sql.cfm?DocOP='+op+'&id='+id+'&CPDEid='+#url.CPDEid#+'&CPformTipo='+'#session.CPformTipo#';
				</cfif>
			}	
				</cfoutput>
			}
		</script>
		<iframe id="ifrDoc" style="display:none"></iframe>
	</cf_tab>
	
	<cfif trim(rsTraslado.CPDEjustificacion) NEQ "">
		<cf_tab text="Justificación" selected="#form.tab EQ 1#" id="1">
			<cfoutput>
				<textarea name="CPDEjustificacion" cols="100" rows="20">#trim(rsTraslado.CPDEjustificacion)#</textarea>
			</cfoutput>
		</cf_tab>
	</cfif>
	<cfif rsDocs.recordCount GT 0>
		<cf_tab text="Documentación" selected="#form.tab EQ 2#" id="2">
			<cfif LvarReporteFinal eq 'true'>
				<cfinvoke 
				 component="sif.Componentes.pListas"
				 method="pListaQuery"
				 returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsDocs#"/>
					<cfinvokeargument name="desplegar" value="CPDDarchivo, CPDDdescripcion"/>
					<cfinvokeargument name="etiquetas" value="Archivo, Descripcion"/>
					<cfinvokeargument name="formatos" value="S,S"/>
					<cfinvokeargument name="align" value="left,left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value=""/>
					<cfinvokeargument name="keys" value="CPDDid">
					<cfinvokeargument name="MaxRows" value="20"/>
					<cfinvokeargument name="navegacion" value=""/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="showLink" value="false"/>
					<cfinvokeargument name="PageIndex" value="5"/>		
				</cfinvoke>	
			<cfelse>
				<cfinvoke 
				 component="sif.Componentes.pListas"
				 method="pListaQuery"
				 returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsDocs#"/>
					<cfinvokeargument name="desplegar" value="OP, CPDDarchivo, CPDDdescripcion"/>
					<cfinvokeargument name="etiquetas" value="OP, Archivo, Descripcion"/>
					<cfinvokeargument name="formatos" value="S,S,S"/>
					<cfinvokeargument name="align" value="left,left,left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value=""/>
					<cfinvokeargument name="keys" value="CPDDid">
					<cfinvokeargument name="MaxRows" value="20"/>
					<cfinvokeargument name="navegacion" value=""/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="showLink" value="false"/>
					<cfinvokeargument name="PageIndex" value="5"/>		
				</cfinvoke>	
			</cfif>
		</cf_tab>
	</cfif>
	</cf_tabs>
	<BR>
</cfoutput>


<cfif not isdefined("url.imprimir")>
<!---<script type="text/javascript" language="javascript1.2" >
	function info(index){
		open('../consultas/Solicitudes-info.cfm?index='+index, 'Solicitudes','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width=500,height=410,left=250, top=200,screenX=250,screenY=200');	
		//open('Solicitudes-info.cfm?observaciones=DOobservaciones&descalterna=DOalterna&titulo=Ordenes de Compra&index='+index, 'ordenes', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width=600,height=420,left=250, top=200,screenX=250,screenY=200');
	}
</script>--->
</cfif>