<!---
	Modificado por: Ana Villavicencio
	Fecha: 07 de marzo del 2006
	Motivo: Agregar el parámetro del Titulo del reporte segun el filtro de Clasificación por dirección.
			Se creo un nuevo reporte .cfr para cuando se selecciona por direccion.

	Modificado por Gustavo Fonseca Hernández.
		Fecha: 9-8-2005.
		Motivo: Se da tratamiento para que tome en cuenta los socios de negocios corporativos(Ecodigo is null)
 --->

<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset Tit_AntSaldoClDet = t.Translate('Tit_AntSaldoClDet','Antiguedad de Saldos por Cliente Detallado')>
    <cfset LB_CuentasporCobrar = t.Translate('LB_CuentasporCobrar','Cuentas por Cobrar')>
    <cfset LB_Fecha = t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
	<cfset LB_Totales 	= t.Translate('LB_Totales','Totales')>
	<cfset LB_Total 	= t.Translate('LB_Total','Total','/sif/generales.xml')>
    <cfset LB_Hora = t.Translate('LB_Hora','Hora')>
    <cfset LB_Cobrador = t.Translate('LB_Cobrador','Cobrador')>
    <cfset LB_Moneda = t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
	<cfset LB_Valor = t.Translate('LB_Valor','Valor','/sif/generales.xml')>
    <cfset LB_Codigo = t.Translate('LBR_CODIGO','Código','/sif/generales.xml')>
	<cfset LB_SocioNegocio = t.Translate('LB_SocioNegocio','Socio de Negocios')>
    <cfset LB_Corriente = t.Translate('LB_Corriente','Corriente')>
	<cfset LB_SinVencer = t.Translate('LB_SinVencer','Sin Vencer')>
	<cfset LB_omas = t.Translate('LB_121omas','o Mas')>
	<cfset LB_Morosidad = t.Translate('LB_Morosidad','Morosidad')>
	<cfset LB_Saldo = t.Translate('LB_Saldo','Saldo')>
    <cfset LB_Moneda = t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
	<cfset LB_Criterio = t.Translate('LB_Criterio','Criterios de Selección:')>
	<cfset LB_ClasificacionSA = t.Translate('LB_ClasificacionSA','Clasificación')>
	<cfset LB_ValorClasDesde = t.Translate('LB_ValorClasDesde','Valor Clasificación desde')>
	<cfset LB_ValorClasHasta = t.Translate('LB_ValorClasHasta','Valor Clasificación hasta')>
	<cfset LB_SocioNegocioI = t.Translate('LB_SocioNegocioI','Socio de Negocios Inicial')>
    <cfset LB_SocioNegocioF = t.Translate('LB_SocioNegocioF','Socio de Negocios Final')>
    <cfset LB_OficinaInicial = t.Translate('LB_OficinaInicial','Oficina Inicial')>
    <cfset LB_OficinaFinal = t.Translate('LB_OficinaFinal','Oficina Final')>
	<cfset LB_Hasta = t.Translate('LB_Hasta','a','/sif/generales.xml')>
    <cfset LB_Corte = t.Translate('LB_Corte','Corte')>
    <cfset LB_Venc = t.Translate('LB_Venc','Venc.')>
	<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
    <cfset LB_Aplicado = t.Translate('LB_Aplicado','Aplicado')>
    <cfset LB_FecVenc = t.Translate('LB_FecVenc','Fecha Venc.')>
	<cfset LB_identificacion = t.Translate('LB_identificacion','Identificación')>

<cfinclude template="Estado_Cuenta_funciones.cfm">
<cfset fnObtenerPeriodosAntiguedad(now())>
<cfset fnGeneraParametros()>

<cfif isDefined("formatos")>
    <cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
		select Pvalor as valParam
		from Parametros
		where Pcodigo = 20007
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
    <cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018 and formatos eq 'Excel'>
	  <cfset typeRep = 1>
	 <!---  <cfif formatos EQ "pdf">
		<cfset typeRep = 2>
	  </cfif> --->
	  <cf_js_reports_service_tag queryReport = "#rsReporte#" 
		isLink = False 
		typeReport = #typeRep#
		fileName = "cc.reportes.AntiguedadSaldosxClasDet"/>
	<cfelse>
    <cfreport format="#formatos#" template= "AntiguedadSaldosxClasDet.cfr" query="rsReporte">
        <cfif isdefined("rsSNCEid") and rsSNCEid.recordcount gt 0>
            <cfreportparam name="SNCEdescripcion" value="#rsSNCEid.SNCEdescripcion#">
        </cfif>
        <cfif isdefined("rsSNCDid1") and rsSNCDid1.recordcount gt 0>
            <cfreportparam name="SNCDdescripcion1" value="#rsSNCDid1.SNCDdescripcion#">
        </cfif>

        <cfif isdefined("rsSNCDid2") and rsSNCDid2.recordcount gt 0>
            <cfreportparam name="SNCDdescripcion2" value="#rsSNCDid2.SNCDdescripcion#">
        </cfif>

        <cfif isdefined("rsSNcodigo") and rsSNcodigo.recordcount gt 0>
            <cfreportparam name="SNcodigo" value="#rsSNcodigo.SNnombre#">
        </cfif>
        <cfif isdefined("rsSNcodigob2") and rsSNcodigob2.recordcount gt 0>
            <cfreportparam name="SNcodigob2" value="#rsSNcodigob2.SNnombre#">
        </cfif>

        <cfif isdefined("url.Cobrador") and len(trim(url.Cobrador)) eq 0>
            <cfset url.cobrador = 'Todos'>
        </cfif>
        <cfreportparam name="Cobrador" value="#url.Cobrador#">

        <cfif isdefined("rsOcodigo") and rsOcodigo.recordcount gt 0>
            <cfreportparam name="Ocodigo" value="#rsOcodigo.Odescripcion#">
        </cfif>
        <cfif isdefined("rsOcodigo2") and rsOcodigo2.recordcount gt 0>
            <cfreportparam name="Ocodigo2" value="#rsOcodigo2.Odescripcion#">
        </cfif>
        <cfif isdefined("rsEmpresa") and rsEmpresa.recordcount gt 0>
            <cfreportparam name="Empresa" value="#rsEmpresa.Edescripcion#">
        </cfif>
        <cfif isdefined("LvarAntiguedad1")>
            <cfreportparam name="P1" value="#LvarAntiguedad1#">
        </cfif>
        <cfif isdefined("LvarAntiguedad2")>
            <cfreportparam name="P2" value="#LvarAntiguedad2#">
        </cfif>
        <cfif isdefined("LvarAntiguedad3")>
            <cfreportparam name="P3" value="#LvarAntiguedad3#">
        </cfif>
        <cfif isdefined("LvarAntiguedad4")>
            <cfreportparam name="P4" value="#LvarAntiguedad4#">
        </cfif>
        <cfif isdefined("url.TClasif") and url.TClasif EQ 0>
			<cfset LB_TituloRep = t.Translate('LB_TituloRep','Antigüedad de Saldos por Clasificación: Detallado por Socio')>
            <cfreportparam name="Titulo" value="#LB_TituloRep#">
        <cfelse>
            <cfset LB_TituloRepDet = t.Translate('LB_TituloRepDet','Antigüedad de Saldos por Clasificación: Detallado por Dirección')>
            <cfreportparam name="Titulo" value="#LB_TituloRepDet#">
        </cfif>

        <cfreportparam name="TClasif" value="#url.TClasif#">
    	<cfreportparam name="LB_CuentasporCobrar" value="#LB_CuentasporCobrar#">
    	<cfreportparam name="LB_Cobrador" value="#LB_Cobrador#">
    	<cfreportparam name="LB_Fecha" value="#LB_Fecha#">
    	<cfreportparam name="LB_Hora" value="#LB_Hora#">
    	<cfreportparam name="LB_Moneda" value="#LB_Moneda#">
        <cfreportparam name="LB_ClasificacionSA" value="#LB_ClasificacionSA#">
    	<cfreportparam name="LB_Valor" value="#LB_Valor#">
    	<cfreportparam name="LB_Codigo" value="#LB_Codigo#">
    	<cfreportparam name="LB_identificacion" value="#LB_identificacion#">
    	<cfreportparam name="LB_SocioNegocio" value="#LB_SocioNegocio#">
    	<cfreportparam name="LB_Documento" value="#LB_Documento#">
    	<cfreportparam name="LB_FecVenc" value="#LB_FecVenc#">
    	<cfreportparam name="LB_Corriente" value="#LB_Corriente#">
    	<cfreportparam name="LB_SinVencer" value="#LB_SinVencer#">
    	<cfreportparam name="LB_Hasta" value="#LB_Hasta#">
    	<cfreportparam name="LB_Morosidad" value="#LB_Morosidad#">
    	<cfreportparam name="LB_Saldo" value="#LB_Saldo#">
		<cfreportparam name="LB_Total" 		value="#LB_Total#">
    	<cfreportparam name="LB_Criterio" value="#LB_Criterio#">
    	<cfreportparam name="LB_ValorClasDesde" value="#LB_ValorClasDesde#">
    	<cfreportparam name="LB_ValorClasHasta" value="#LB_ValorClasHasta#">
    	<cfreportparam name="LB_OficinaInicial" value="#LB_OficinaInicial#">
    	<cfreportparam name="LB_OficinaFinal" 	value="#LB_OficinaFinal#">
    	<cfreportparam name="LB_SocioNegocioI" value="#LB_SocioNegocioI#">
    	<cfreportparam name="LB_SocioNegocioF" value="#LB_SocioNegocioF#">
    	<cfreportparam name="LB_omas" value="#LB_omas#">
		<cfreportparam name="LB_Totales" 	value="#LB_Totales#">
    </cfreport>
    </cfif>
</cfif>
	<!--- Salida en formato HTML --->
	<!---
		Corte por:
				Sucursal
				Cliente
				Moneda
	--->
	<!--- <cfset MnombreAnt = "">
	<cfset SNnumeroAnt = "">
	<cfset SNCDidAnt = -1>
	<cf_htmlReportsheaders irA="./AntiguedadSaldosClasificacion.cfm" FileName="AntiguedadSaldos#session.usucodigo#.xls">
	<table cellpadding="0" cellspacing="0" border="0" width="100%" style="font-family: Arial;">
		<tr>
        	<cfoutput>
			<td colspan="10"><h3>#Session.Enombre#</h3></td>
			<td colspan="2" align="right">#LB_Fecha#:</td>
			<td colspan="2" align="left">#dateformat(now(), "DD/MM/YYYY")#</td>
            </cfoutput>
		</tr>
		<tr>
        	<cfoutput>
			<td colspan="10" style="font-size:large"><strong>#Tit_AntSaldoClDet#</strong></td>
			<td colspan="2" align="right">#LB_Hora#:</td>
			<td colspan="2" align="left">#dateformat(now(), "HH:MM:SS")#</td>
            </cfoutput>
		</tr>
		<tr>
			<td colspan="12" align="right"><cfoutput>#LB_Corte#</cfoutput>:</td>
			<td colspan="2" align="left"><cfoutput>#dateformat(Now(), "DD/MM/YYYY")#</cfoutput></td>
		</tr>
		<tr><td colspan="14">&nbsp;</td></td>
        <cfoutput>
            <tr>
                <td><strong>#LB_Documento#</strong></td>
                <td><strong>#LB_Fecha#</strong></td>
                <td><strong>#LB_Venc#</strong></td>
                <td align="right" nowrap="nowrap"><strong>#LB_Total#</strong></td>
                <td align="right" nowrap="nowrap"><strong>#LB_Saldo#</strong></td>
                <td align="right" nowrap="nowrap"><strong>#LB_Aplicado#</strong></td>
                <td align="right" nowrap="nowrap"><strong>#LB_Corriente#</strong></td>
                <td align="right" nowrap="nowrap"><strong>#LB_SinVencer#</strong></td>
                <td align="right" nowrap="nowrap"><strong>1 <!--- #LB_a# ---> #LvarAntiguedad1#</strong></td>
                <td align="right" nowrap="nowrap"><strong>#LvarAntiguedad1+1# <!--- #LB_a# ---> #LvarAntiguedad2#</strong></td>
                <td align="right" nowrap="nowrap"><strong>#LvarAntiguedad2+1# <!--- #LB_a# ---> #LvarAntiguedad3#</strong></td>
                <td align="right" nowrap="nowrap"><strong>#LvarAntiguedad3+1# <!--- #LB_a# ---> #LvarAntiguedad4#</strong></td>
                <td align="right" nowrap="nowrap"><strong>#LvarAntiguedad4+1# #LB_omas#</strong></td>
                <td align="right" nowrap="nowrap"><strong>#LB_Morosidad#</strong></td>
            </tr>
		</cfoutput>
		<cfflush interval="24">
		<cfoutput query="rsReporte">
			<cfset lflagPonerEncabezado = false>
			<cfif SNCDidAnt NEQ SNCDid>
				<cfset MnombreAnt = Mnombre>
				<cfset SNnumeroAnt = SNnumero>
				<cfset SNCDidAnt = SNCDid>

				<tr>
					<td colspan="1"><strong>&nbsp;</strong></td>
				</tr>
				<tr>
					<td colspan="3"><strong>#SNCDdescripcion#</strong></td>
				</tr>
				<tr>
					<td colspan="3"><strong>#Mnombre#</strong></td>
				</tr>
				<tr>
					<td colspan="3"><strong>#SNnumero# #SNnombre#</strong></td>
				</tr>
			<cfelseif MnombreAnt NEQ Mnombre>
				<cfset SNnumeroAnt = SNnumero>
				<cfset MnombreAnt = Mnombre>
				<tr>
					<td colspan="1"><strong>&nbsp;</strong></td>
				</tr>
				<tr>
					<td colspan="3"><strong>#Mnombre#</strong></td>
				</tr>
				<tr>
					<td colspan="3"><strong>#SNnumero# #SNnombre#</strong></td>
				</tr>
			<cfelseif SNnumeroAnt NEQ SNnumero>
				<cfset MnombreAnt = Mnombre>
				<tr>
					<td colspan="1"><strong>&nbsp;</strong></td>
				</tr>
				<tr>
					<td colspan="3"><strong>#SNnumero# #SNnombre#</strong></td>
				</tr>
			</cfif>
			<tr>
				<td nowrap="nowrap">#CCTcodigo#-#Ddocumento#</td>
				<td nowrap="nowrap">#DateFormat(Dfecha, "DD/MM/YYYY")#</td>
				<td nowrap="nowrap"> #DateFormat(Dvencimiento, "DD/MM/YYYY")#</td>
				<td align="right" nowrap="nowrap">#NumberFormat(Total, ",0.00")#</td>
				<td align="right" nowrap="nowrap">#NumberFormat(Saldo, ",0.00")#</td>
				<td align="right" nowrap="nowrap">#NumberFormat(Total - Saldo, ",0.00")#</td>
				<td align="right" nowrap="nowrap">#NumberFormat(Corriente, ",0.00")#</td>
				<td align="right" nowrap="nowrap">#NumberFormat(SinVencer, ",0.00")#</td>
				<td align="right" nowrap="nowrap">#NumberFormat(P1, ",0.00")#</td>
				<td align="right" nowrap="nowrap">#NumberFormat(P2, ",0.00")#</td>
				<td align="right" nowrap="nowrap">#NumberFormat(P3, ",0.00")#</td>
				<td align="right" nowrap="nowrap">#NumberFormat(P4, ",0.00")#</td>
				<td align="right" nowrap="nowrap">#NumberFormat(P5, ",0.00")#</td>
				<td align="right" nowrap="nowrap">#NumberFormat(Morosidad, ",0.00")#</td>
			</tr>
			<cfflush>
		</cfoutput>
	</table>
</cfif> --->

<cffunction name="fnGeneraParametros" output="no" access="private">
	<cfif isdefined('form.SNCEID') and not isdefined('url.SNCEID')>
        <cfset url.SNCEID = form.SNCEID>
    </cfif>
    <cfset form.SNCEID = url.SNCEID>

    <cfif isdefined('form.Formato') and not isdefined('url.Formato')>
        <cfset url.Formato = form.Formato>
    </cfif>
    <cfset form.Formato = url.Formato>

    <!--- puede venir o no --->
    <cfif isdefined('url.TClasif') and not isdefined('form.TClasif')>
        <cfset form.TClasif = url.TClasif>
    <cfelseif isdefined('form.TClasif') and not isdefined('url.TClasif')>
        <cfset url.TClasif = form.TClasif>
    </cfif>

    <cfif isdefined('url.DEidCobrador') and not isdefined('form.DEidCobrador')>
        <cfset form.DEidCobrador = url.DEidCobrador>
    <cfelseif isdefined('form.DEidCobrador') and not isdefined('url.DEidCobrador')>
        <cfset url.DEidCobrador = form.DEidCobrador>
    </cfif>

    <cfif isdefined('url.SNCDvalor1') and not isdefined('form.SNCDvalor1')>
        <cfset form.SNCDvalor1 = url.SNCDvalor1>
    <cfelseif isdefined('form.SNCDvalor1') and not isdefined('url.SNCDvalor1')>
        <cfset url.SNCDvalor1 = form.SNCDvalor1>
    </cfif>

    <cfif isdefined('url.SNCDvalor2') and not isdefined('form.SNCDvalor2')>
        <cfset form.SNCDvalor2 = url.SNCDvalor2>
    <cfelseif isdefined('form.SNCDvalor2') and not isdefined('url.SNCDvalor2')>
        <cfset url.SNCDvalor2 = form.SNCDvalor2>
    </cfif>

    <cfif isdefined('url.SNnumero') and not isdefined('form.SNnumero')>
        <cfset form.SNnumero = url.SNnumero>
    <cfelseif isdefined('form.SNnumero') and not isdefined('url.SNnumero')>
        <cfset url.SNnumero = form.SNnumero>
    </cfif>
    <cfif isdefined('url.SNnumerob2') and not isdefined('form.SNnumerob2')>
        <cfset form.SNnumerob2 = url.SNnumerob2>
    <cfelseif isdefined('form.SNnumerob2') and not isdefined('url.SNnumerob2')>
        <cfset url.SNnumerob2 = form.SNnumerob2>
    </cfif>
    <cfif isdefined('url.Oficodigo') and not isdefined('form.Oficodigo')>
        <cfset form.Oficodigo = url.Oficodigo>
    <cfelseif isdefined('form.Oficodigo') and not isdefined('url.Oficodigo')>
        <cfset url.Oficodigo = form.Oficodigo>
    </cfif>
    <cfif isdefined('url.Oficodigo2') and not isdefined('form.Oficodigo2')>
        <cfset form.Oficodigo2 = url.Oficodigo2>
    <cfelseif isdefined('form.Oficodigo2') and not isdefined('url.Oficodigo2')>
        <cfset url.Oficodigo2 = form.Oficodigo2>
    </cfif>
    <cfif isdefined('url.SNcodigo') and not isdefined('form.SNcodigo')>
        <cfset form.SNcodigo = url.SNcodigo>
    <cfelseif isdefined('form.SNcodigo') and not isdefined('url.SNcodigo')>
        <cfset url.SNcodigo = form.SNcodigo>
    </cfif>

    <cfif isdefined('url.SNcodigob2') and not isdefined('form.SNcodigob2')>
        <cfset form.SNcodigob2 = url.SNcodigob2>
    <cfelseif isdefined('form.SNcodigob2') and not isdefined('url.SNcodigob2')>
        <cfset url.SNcodigob2 = form.SNcodigob2>
    </cfif>
    <cfif isdefined('url.Ocodigo') and not isdefined('form.Ocodigo')>
        <cfset form.Ocodigo = url.Ocodigo>
    <cfelseif isdefined('form.Ocodigo') and not isdefined('url.Ocodigo')>
        <cfset url.Ocodigo = form.Ocodigo>
    </cfif>
    <cfif isdefined('url.Ocodigo2') and not isdefined('form.Ocodigo2')>
        <cfset form.Ocodigo2 = url.Ocodigo2>
    <cfelseif isdefined('form.Ocodigo2') and not isdefined('url.Ocodigo2')>
        <cfset url.Ocodigo2 = form.Ocodigo2>
    </cfif>
    <cfif isdefined('url.Cobrador') and not isdefined('form.Cobrador')>
        <cfset form.Cobrador = url.Cobrador>
    <cfelseif isdefined('form.Cobrador') and not isdefined('url.Cobrador')>
        <cfset url.Cobrador = form.Cobrador>
    </cfif>

    <cfquery name="rsConsultaCorp" datasource="asp">
        select 1
        from CuentaEmpresarial
        where Ecorporativa is not null
          and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#" >
    </cfquery>
    <cfif isdefined('session.Ecodigo') and
          isdefined('session.Ecodigocorp') and
          session.Ecodigo NEQ session.Ecodigocorp and
          rsConsultaCorp.RecordCount GT 0>
          <cfset filtro = " ec.Ecodigo=#session.Ecodigo# ">
    <cfelse>
          <cfset filtro = " ec.Ecodigo is null ">
    </cfif>
 	<cfset LvarFechaIniMes = createdate(year(now()), month(now()), 1)>
	<!--- Se genera una nueva variable para procesar la fecha del día de hoy sin minutos ni segundos --->
    <cfset LvarFechaHoy = createdate(year(now()), month(now()), day(now()))>
    <cfquery name="rsReporte" datasource="#session.DSN#">
		select
			ec.SNCEid,
			ec.SNCEcodigo,
			ec.SNCEdescripcion,
			m.Miso4217 as Miso,
			m.Mnombre,
			dc.SNCDid,
			dc.SNCDvalor,
			dc.SNCDdescripcion,
			s.SNidentificacion,
			<cfif isdefined('url.TClasif') and url.TClasif EQ 1>
				 coalesce(snd.SNnombre,s.SNnombre) as SNnombre,
				 coalesce(snd.SNDcodigo,s.SNnumero) as SNnumero,
			<cfelse>
				 s.SNnombre as SNnombre,
				 s.SNnumero as SNnumero,
			</cfif>
			d.Dfecha,
			d.Dvencimiento,
			d.CCTcodigo,
			d.Ddocumento,
			d.Ocodigo,
			d.Dtotal * case when t.CCTtipo = 'D' then 1.00 else -1.00 end as Total,
			d.Dsaldo * case when t.CCTtipo = 'D' then 1.00 else -1.00 end as Saldo,

			case
				when d.Dvencimiento >= #LvarFechaHoy# and d.Dfecha < #LvarFechaIniMes# then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then 1.00 else -1.00 end
			as SinVencer,

			case
				when d.Dvencimiento >= #LvarFechaHoy# and d.Dfecha >= #LvarFechaIniMes# then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then 1.00 else -1.00 end
			as Corriente,

			case
				when d.Dvencimiento < #LvarFechaHoy# and d.Dvencimiento >= #LvarFechaAntiguedad1# then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then 1.00 else -1.00 end
			as P1,

			case
				when d.Dvencimiento < #LvarFechaAntiguedad1# and d.Dvencimiento >= #LvarFechaAntiguedad2# then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then 1.00 else -1.00 end
			as P2,

			case
				when d.Dvencimiento < #LvarFechaAntiguedad2# and d.Dvencimiento >= #LvarFechaAntiguedad3# then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then 1.00 else -1.00 end
			as P3,

			case
				when d.Dvencimiento < #LvarFechaAntiguedad3# and d.Dvencimiento >= #LvarFechaAntiguedad4# then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then 1.00 else -1.00 end
			as P4,

			case
				when d.Dvencimiento < #LvarFechaAntiguedad4# then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then 1.00 else -1.00 end
			as P5,

			case
				when d.Dvencimiento >= #now()# then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then 1.00 else -1.00 end
			as Morosidad
		from SNClasificacionE ec
			inner join SNClasificacionD dc
			on dc.SNCEid = ec.SNCEid
			<cfif isdefined('url.TClasif') and url.TClasif EQ 0>
				inner join SNClasificacionSN cs
					on cs.SNCDid = dc.SNCDid
				inner join SNegocios s
					on s.SNid = cs.SNid
				<cfif isdefined("url.DEidCobrador") and len(trim(url.DEidCobrador))>and s.DEidCobrador = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEidCobrador#"></cfif>
				inner join Documentos d
					on d.Ecodigo       = s.Ecodigo
					and d.SNcodigo     = s.SNcodigo
			<cfelse>
				inner join SNClasificacionSND cs
				   on cs.SNCDid = dc.SNCDid
				inner join SNDirecciones snd
				   on cs.SNid = snd.SNid
				  and cs.id_direccion = snd.id_direccion
				  <cfif isdefined("url.DEidCobrador") and len(trim(url.DEidCobrador))>and snd.DEidCobrador = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEidCobrador#"></cfif>
				inner join SNegocios s
				   on s.SNid = snd.SNid
				inner join Documentos d
				   on d.Ecodigo          = s.Ecodigo
				  and d.SNcodigo         = s.SNcodigo
				  and d.id_direccionFact = snd.id_direccion
			</cfif>

			inner join Monedas m
			on m.Mcodigo = d.Mcodigo

			inner join CCTransacciones t
			on  t.CCTcodigo = d.CCTcodigo
			and t.Ecodigo   = d.Ecodigo

			inner join Oficinas o
			on  o.Ecodigo   = d.Ecodigo
			and o.Ocodigo   = d.Ocodigo
		where ec.SNCEid = #url.SNCEid#
		and #filtro#
		<!--- Valores de Clasificación --->
		<cfif isdefined("url.SNCDvalor1") and len(trim(url.SNCDvalor1)) and isdefined("url.SNCDvalor2") and len(trim(url.SNCDvalor2))>
			and dc.SNCDvalor between '#url.SNCDvalor1#' and '#url.SNCDvalor2#'
		<cfelseif isdefined("url.SNCDvalor1") and len(trim(url.SNCDvalor1))>
			and dc.SNCDvalor >= '#url.SNCDvalor1#'
		<cfelseif isdefined("url.SNCDvalor2") and len(trim(url.SNCDvalor2))>
			and dc.SNCDvalor <= '#url.SNCDvalor2#'
		</cfif>
		<!--- Socio de negocios --->
		and s.Ecodigo = #session.Ecodigo#
		<cfif isdefined("url.SNnumero") and len(trim(url.SNnumero)) and isdefined("url.SNnumerob2") and len(trim(url.SNnumerob2))>
			and s.SNnumero between '#url.SNnumero#' and '#url.SNnumerob2#'
		<cfelseif isdefined("url.SNnumero") and len(trim(url.SNnumero))>
			and s.SNnumero >= '#url.SNnumero#'
		<cfelseif isdefined("url.SNnumerob2") and len(trim(url.SNnumerob2))>
			and s.SNnumero <= '#url.SNnumerob2#'
		</cfif>
		<!--- Oficina --->
		<cfif isdefined("url.Oficodigo") and len(trim(url.Oficodigo)) and isdefined("url.Oficodigo2") and len(trim(url.Oficodigo2))>
			and o.Oficodigo between '#url.Oficodigo#' and '#url.Oficodigo2#'
		<cfelseif isdefined("url.Oficodigo") and len(trim(url.Oficodigo))>
			and o.Oficodigo >= '#url.Oficodigo#'
		<cfelseif isdefined("url.Oficodigo2") and len(trim(url.Oficodigo2))>
			and o.Oficodigo <= '#url.Oficodigo2#'
		</cfif>
		and d.Dsaldo <> 0.00
		order by
			  dc.SNCDvalor
			, m.Miso4217
			, <cfif isdefined('url.TClasif') and url.TClasif EQ 1>coalesce(snd.SNDcodigo,s.SNnumero)<cfelse>s.SNnumero</cfif>
			, d.Dfecha
			, d.Ddocumento
    </cfquery>
    <cfif isdefined("rsReporte") and rsReporte.recordcount EQ 0>
        <cfquery name="rsReporte" datasource="#session.DSN#">
        SELECT ec.SNCEid,
            ec.SNCEcodigo,
            ec.SNCEdescripcion,
            'S/M' AS Miso,
            'SIN MONEDA' as Mnombre,
            dc.SNCDid,
            dc.SNCDvalor,
            dc.SNCDdescripcion,
            s.SNidentificacion,
            s.SNnombre AS SNnombre,
            s.SNnumero AS SNnumero,
            GETDATE()  as Dfecha,
            GETDATE()    as Dvencimiento,
            'S/N'   as CCTcodigo,
            '---Sin Documentos---' as Ddocumento,
            1   as Ocodigo,
            0.000000    as Saldo,
            0.000000    as Total,
            0.000000    as SinVencer,
            0.000000    as Corriente,
            0.000000    as P1,
            0.000000    as P2,
            0.000000    as P3,
            0.000000    as P4,
            0.000000    as P5,
            0.000000    as Morosidad
        FROM SNClasificacionE ec
        INNER JOIN SNClasificacionD dc ON dc.SNCEid = ec.SNCEid
        INNER JOIN SNClasificacionSN cs ON cs.SNCDid = dc.SNCDid
        INNER JOIN SNegocios s ON s.SNid = cs.SNid
        WHERE  ec.SNCEid = #url.SNCEid#
        and s.Ecodigo = #session.Ecodigo#
        <cfif isdefined("url.SNnumero") and len(trim(url.SNnumero)) and isdefined("url.SNnumerob2") and len(trim(url.SNnumerob2))>
            and s.SNnumero between '#url.SNnumero#' and '#url.SNnumerob2#'
        <cfelseif isdefined("url.SNnumero") and len(trim(url.SNnumero))>
            and s.SNnumero >= '#url.SNnumero#'
        <cfelseif isdefined("url.SNnumerob2") and len(trim(url.SNnumerob2))>
            and s.SNnumero <= '#url.SNnumerob2#'
        </cfif>
        ORDER BY dc.SNCDvalor,
        s.SNnumero
        </cfquery>
    </cfif>
    <!--- Busca descripción del Encabezado de la Clasificación --->
    <cfif isdefined("url.SNCEid") and len(trim(url.SNCEid))>
        <cfquery name="rsSNCEid" datasource="#session.DSN#">
            select SNCEdescripcion
            from SNClasificacionE
            where SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCEid#">
            and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        </cfquery>
    </cfif>

    <!--- Busca descripción del Detalle 1 de la Clasificación --->
    <cfif isdefined("url.SNCDid1") and len(trim(url.SNCDid1))>
        <cfquery name="rsSNCDid1" datasource="#session.DSN#">
            select SNCDdescripcion
            from SNClasificacionD
            where SNCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCDid1#">
        </cfquery>
    </cfif>

    <!--- Busca descripción del Detalle 2 de la Clasificación --->
    <cfif isdefined("url.SNCDid2") and len(trim(url.SNCDid2))>
        <cfquery name="rsSNCDid2" datasource="#session.DSN#">
            select SNCDdescripcion
            from SNClasificacionD
            where SNCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCDid2#">
        </cfquery>
    </cfif>

    <!--- Busca nombre del Socio de Negocios 1 --->
    <cfif isdefined("url.SNcodigo") and len(trim(url.SNcodigo))>
        <cfquery name="rsSNcodigo" datasource="#session.DSN#">
            select SNnombre
            from SNegocios
            where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigo#">
            and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        </cfquery>
    </cfif>

    <!--- Busca nombre del Socio de Negocios 2 --->
    <cfif isdefined("url.SNcodigob2") and len(trim(url.SNcodigob2))>
        <cfquery name="rsSNcodigob2" datasource="#session.DSN#">
            select SNnombre
            from SNegocios
            where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigob2#">
            and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        </cfquery>
    </cfif>

    <!--- Busca nombre de la Oficina 1 --->
    <cfif isdefined("url.Ocodigo") and len(trim(url.Ocodigo))>
        <cfquery name="rsOcodigo" datasource="#session.DSN#">
            select Odescripcion
            from Oficinas
            where Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Ocodigo#">
            and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        </cfquery>
    </cfif>

    <!--- Busca nombre de la Oficina 2 --->
    <cfif isdefined("url.Ocodigo2") and len(trim(url.Ocodigo2))>
        <cfquery name="rsOcodigo2" datasource="#session.DSN#">
            select Odescripcion
            from Oficinas
            where Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Ocodigo2#">
            and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        </cfquery>
    </cfif>

    <!--- Busca nombre de la Empresa --->
    <cfquery name="rsEmpresa" datasource="#session.DSN#">
        select Edescripcion
        from Empresas
        where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    </cfquery>

	<cfif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 1>
		<cfset formatos = "flashpaper">
	<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 2>
		<cfset formatos = "pdf">
	<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 3>
		<cfset formatos = "excel">
	<cfelse>
		<cfset formatos = "excel">
	</cfif>
</cffunction>
