
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_ReporteDeDepositosElectronicos" default="Reporte de Dep&oacute;sitos Electr&oacute;nicos" returnvariable="LB_ReporteDeDepositosElectronicos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_ReporteDeDepositosCheques" default="Reporte de Dep&oacute;sitos Cheques" returnvariable="LB_ReporteDeDepositosCheques" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<cfif isdefined('url.CPid') and LEN(TRIM(url.CPid))>
	<cfset CPid = url.CPid>
	<cfset CPcodigo = url.CPcodigo>
	<cfset Tcodigo = url.Tcodigo>
</cfif>

<cfif isdefined('url.chq')>
	<cfset titulo = LB_ReporteDeDepositosCheques>
<cfelse>
	<cfset titulo = LB_ReporteDeDepositosElectronicos>
</cfif>
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfquery name="rsReporte" datasource="#session.DSN#">
	select distinct a.DEid, 
        DEnombre #LvarCNCT# ' '#LvarCNCT# DEapellido1 #LvarCNCT#' '#LvarCNCT#DEapellido2 as nombre,
		DEinfo1,
		a.DEdato2, 
		b.SEliquido, 
		a.CBcc,
		DEidentificacion,
		a.DEidentificacion as ID,
		a.CBcc as CuentaTxt,		
		DEnombre #LvarCNCT# ' '#LvarCNCT# DEapellido1 #LvarCNCT#' '#LvarCNCT#DEapellido2 as nombreTxt,
		EVfantig,
        coalesce(a.Bid,-1) as Bid,
        coalesce(Bdescripcion,'Sin definir') as Bdescripcion,
		SubString(RCDescripcion,1,25) as Descripcion
	from DatosEmpleado a
	inner join HSalarioEmpleado b
		on a.DEid = b.DEid
		and b.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPid#">
	inner join HRCalculoNomina c
		on c.Ecodigo = a.Ecodigo
		and c.RCNid = b.RCNid
	inner join LineaTiempo lt
		on lt.DEid = a.DEid
		and ((lt.LThasta >= c.RCdesde and lt.LTdesde <= c.RChasta) 
		  or (lt.LTdesde <= c.RCdesde and lt.LThasta >= c.RChasta))
	inner join RHPlazas p
		on p.RHPid = lt.RHPid
	inner join EVacacionesEmpleado ve
		on ve.DEid = a.DEid
	left outer join Bancos bc
    	on a.Bid = bc.Bid
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and b.SEliquido > 0
    	<cfif isdefined('url.chq') or isdefined('form.chq')>
	      and coalesce(a.Bid,0) = 0
       	<cfelse>
      	  and a.Bid <> 0
      </cfif>
	order by Bid,DEidentificacion
</cfquery>

<!--- Busca el nombre de la Empresa --->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!--- Datos de la nomina --->
<cfquery name="rsNomina" datasource="#session.DSN#">
	select CPhasta, CPdesde, CPfpago,CPdescripcion,CPperiodo,CPmes,
	case when CPtipo = 0 then 'Normal'
		 when CPtipo = 2 then 'Anticipo' end as TipoCalendario, Tdescripcion,
		 RCDescripcion as Descripcion
	from CalendarioPagos a
		inner join TiposNomina b
			on b.Ecodigo = a.Ecodigo 
			and b.Tcodigo = a.Tcodigo
	inner join HRCalculoNomina c
		on c.Ecodigo = a.Ecodigo
		and c.RCNid = a.CPid
	where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CPid#">
</cfquery>


<style>
	h1.corte {
		PAGE-BREAK-AFTER: always;}
	.tituloAlterno {
		font-size:16px;
		font-weight:bold;
		text-align:center;}
	.titulo_empresa2 {
		font-size:13px;
		font-weight:bold;
		text-align:center;}
	.titulo_reporte {
		font-size:12px;
		font-style:italic;
		text-align:center;}
	.titulo_filtro {
		font-size:10px;
		font-style:italic;
		text-align:center;}
	.titulolistas {
		font-size:10px;
		font-weight:bold;
		background-color:#CCCCCC;
		}
	.titulo_columnar {
		font-size:10px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:right;}
	.listaCorte {
		font-size:10px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:left;}
	.total {
		font-size:10px;
		font-weight:bold;
		background-color:#C5C5C5;
		text-align:right;}

	.detalle {
		font-size:10px;
		text-align:left;}
	.detaller {
		font-size:10px;
		text-align:right;}
	.detallec {
		font-size:10px;
		text-align:center;}	
		
	.mensaje {
		font-size:10px;
		text-align:center;}
	.paginacion {
		font-size:10px;
		text-align:center;}
</style>
<cfif isdefined('url.chkTxt')>
	<cfset resultado = '' >
	<cfset archivo = "DepositosElectronicos_#hour(now())##minute(now())##second(now())#">
	<cfset txtfile = GetTempFile(getTempDirectory(), 'Depositos')>
	<cfdump var="#rsReporte#">
	<cfoutput query="rsReporte">
		<cfset Lvar_ID = ID>
		<cfif LEN(ID) LTE 8>
			<cfset cant = 10 - LEN(ID)>
			<cfset Lvar_Blancos = RepeatString(chr(160),cant)>
			<cfset Lvar_ID = ID & Lvar_Blancos>
		</cfif>
		<cfset Lvar_Nombre = nombreTxt>
		<cfif LEN(nombreTxt) LTE 30>
			<cfset cant = 32 - LEN(nombreTxt)>
			<cfset Lvar_Blancos = RepeatString(chr(160),cant)>
			<cfset Lvar_Nombre = NombreTxt & Lvar_Blancos>
		</cfif>
		<cfset Lvar_Cuenta = CuentaTxt>
		<cfif LEN(CuentaTxt) LTE 10>
			<cfset cant = 12 - LEN(CuentaTxt)>
			<cfset Lvar_Blancos = RepeatString(chr(160),cant)>
			<cfset Lvar_Cuenta = CuentaTxt & Lvar_Blancos>
		</cfif>
		<cfset Lvar_Monto = SELiquido>
		<cfif LEN(SELiquido) LT 21>
			<cfset cant = 21 - LEN(SELiquido)>
			<cfset Lvar_Blancos = RepeatString(chr(160),cant)>
			<cfset Lvar_Monto =  Lvar_Blancos & SELiquido>
			<cfset Lvar_Blancos = RepeatString(chr(160),2)>
			<cfset Lvar_Monto =  Lvar_Monto & Lvar_Blancos>
		</cfif>
	
		<cfset Lvar_DescN = Descripcion>
		<cfif LEN(SELiquido) LTE 25>
			<cfset cant = 25 - LEN(Descripcion)>
			<cfset Lvar_Blancos = RepeatString(chr(160),cant)>
			<cfset Lvar_DescN = Descripcion & Lvar_Blancos>
		</cfif>
		<cfdump var="#Lvar_ID#">
		<cfdump var="#Lvar_Nombre#">
		<cfdump var="#Lvar_Cuenta#">
		<cfdump var="#Lvar_Monto#">
		<cfdump var="#Lvar_DescN#"><br />
		<cfset resultado = resultado & '#Lvar_ID##Lvar_Nombre##Lvar_Cuenta##Lvar_Monto##Lvar_DescN##chr(13)##chr(10)#'>
	</cfoutput>
	<cffile action="write" nameconflict="overwrite" file="#txtfile#" output="#resultado#" charset="utf-8" >
			<cfheader name="Content-Disposition" value="attachment;filename=DepositosElectronicos.txt">
			<cfcontent file="#txtfile#" type="text/plain" deletefile="yes">
</cfif>		
<table width="700" align="center" border="0" cellspacing="2" cellpadding="0">
    <cfoutput>
    <tr><td align="center" colspan="4" class="titulo_empresa2"><strong>#rsEmpresa.Edescripcion#</strong></td></tr>
    <tr><td align="center" colspan="4" class="titulo_empresa2"><strong>#titulo#</strong></td></tr>
    <tr><td colspan="4">&nbsp;</td></tr>
    <tr>
        <td align="center" colspan="4">
            <table width="550" align="center" border="0" cellspacing="2" cellpadding="0">
                <tr><td class="detalle" colspan="2"><strong>#rsNomina.Descripcion#</strong></td></tr>
                <tr>
                    <td class="detalle"><strong><cf_translate key="LB_TipoDeNomina">Tipo de N&oacute;mina</cf_translate>: #rsNomina.Tdescripcion#</strong></td>
                    <td class="detalle"><strong><cf_translate key="LB_FechaRige">Fecha Rige</cf_translate>: #LSDateFormat(rsNomina.CPdesde,'dd/mm/yyyy')# <cf_translate key="LB_FechaHasta">Fecha Hasta</cf_translate>: #LSDateFormat(rsNomina.CPhasta,'dd/mm/yyyy')# </strong></td>
                </tr>
                <tr>
                     <td class="detalle"><strong><cf_translate key="LB_Periodo">Per&iacute;odo</cf_translate>: #rsNomina.CPperiodo# - #rsNomina.CPmes#</strong></td>
                    <td class="detalle"><strong><cf_translate key="LB_TipoDeCalendario">Tipo de Calendario</cf_translate>: #rsNomina.TipoCalendario#</strong></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td colspan="4">&nbsp;</td></tr>
    </cfoutput>
    <cfset TotalAPagar = 0.00>
    <cfset TotalGralAPagarBanco = 0.00>
    <cfset TotalGralAPagar = 0.00>
    <cfoutput query="rsReporte" group="Bid">
        <tr><td colspan="4" class="listaCorte">#Bdescripcion#</td></tr>        
        <tr class="titulo_columnar">
            <td align="center" width="30"><cf_translate key="LB_Codigo">C&oacute;digo</cf_translate></td>
            <td align="center" width="250"><cf_translate key="LB_Nombre">Nombre</cf_translate></td>
            <!---<td align="center" width="150"><cf_translate key="LB_Banco">Banco</cf_translate></td>--->
            <td align="center" width="150"><cf_translate key="LB_Cuenta">Cuenta</cf_translate></td>
            <td align="right" width="100"><cf_translate key="LB_TotalAPagar">Total a Pagar</cf_translate>&nbsp;</td>
        </tr>
        <cfoutput>
            <tr>
                <td class="detalle">#DEidentificacion#</td>
                <td class="detalle">#nombre#</td>
                <!---<td class="detalle">#Bdescripcion#</td>--->
                <td class="detallec">#CBcc#</td>
                <td class="detaller">#LSNumberFormat(rsReporte.SEliquido, ',9.00')#</td>
            </tr>
            <cfset TotalGralAPagarBanco = TotalGralAPagarBanco + SEliquido>
            <cfset TotalGralAPagar = TotalGralAPagar + SEliquido>
        </cfoutput>
        <tr>
            <td class="total" colspan="3">
              <cf_translate key="LB_TotalBanco">Total Banco</cf_translate>&nbsp;</td><td class="total">#LSNumberFormat(TotalGralAPagarBanco, ',9.00')#</td>
        </tr>
        <tr><td colspan="4">&nbsp;</td></tr>
        <cfset TotalGralAPagarBanco = 0>
    </cfoutput>
    <tr>
        <td class="total" colspan="3"><cf_translate key="LB_TotalGeneral">Total General</cf_translate>&nbsp;</td>
        <td class="total"><cfoutput>#LSNumberFormat(TotalGralAPagar, ',9.00')# </cfoutput></td>
    </tr>
</table>



