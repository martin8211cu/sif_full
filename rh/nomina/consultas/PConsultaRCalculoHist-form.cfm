<cfif isDefined("Url.RCNid") and not isDefined("Form.RCNid")>
	<cfset Form.RCNid = Url.RCNid>
</cfif>
<cfif isDefined("Url.Tcodigo") and not isDefined("Form.Tcodigo")>
	<cfset Form.Tcodigo = Url.Tcodigo>
</cfif>
<cfif not isdefined("form.Tcodigo")>
	<cfquery name="rs_tcodigo" datasource="#session.DSN#">
		select Tcodigo
		from HRCalculoNomina
		where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
	</cfquery>
	<cfset form.Tcodigo = rs_tcodigo.Tcodigo >
</cfif>

<cfif isDefined("Url.fecha") and not isDefined("Form.fecha")>
	<cfset Form.fecha = Url.fecha>
</cfif>
<cfif isDefined("Url.DEid") and not isDefined("Form.DEid")>
	<cfset Form.DEid = Url.DEid>
</cfif>
<cfif isDefined("Url.chkIncidencias") and not isDefined("Form.chkIncidencias")>
	<cfset Form.chkIncidencias = Url.chkIncidencias>
</cfif>
<cfif isDefined("Url.chkCargas") and not isDefined("Form.chkCargas")> <!--- *** --->
	<cfset Form.chkCargas = Url.chkCargas>
</cfif>
<cfif isDefined("Url.chkDeducciones") and not isDefined("Form.chkDeducciones")>
	<cfset Form.chkDeducciones = Url.chkDeducciones>
</cfif>

<!--- Consultas --->
<!--- Detalles de la Nómina --->
<cfquery name="rsDetalle" datasource="#Session.DSN#">
	select 
		a.DEid as DEid, 
		a.RCNid as RCNid,
		b.DEidentificacion, 
		{fn concat({fn concat({fn concat({fn concat(b.DEapellido1 , ' ' )}, b.DEapellido2 )}, ' ' )}, b.DEnombre )} as Nombre, 
		SEsalariobruto, 
		SEincidencias, 
		SErenta, 
		SEcargasempleado, 
		SEdeducciones, 
		SEliquido
	from HSalarioEmpleado a, DatosEmpleado b, HRCalculoNomina c
	where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and c.Tcodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Tcodigo#">
			and a.RCNid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
			<cfif isDefined("Form.DEid") and len(trim(Form.DEid)) gt 0>
			and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
			</cfif>
			and a.DEid = b.DEid
			and a.RCNid = c.RCNid
	order by b.DEapellido1, b.DEapellido2, b.DEnombre
</cfquery>

<!--- Consulta Relación de Cálculo --->
<cfif rsDetalle.RecordCount gt 0>
  <!--- Consulta Totales --->
  <cfquery name="rsTDetalle" datasource="#Session.DSN#">
  	select 	sum(SEsalariobruto) as TSEsalariobruto, 
			sum(SEincidencias) as TSEincidencias, 
			sum(SErenta) as TSErenta, 
			sum(SEcargasempleado) as TSEcargasempleado, 
			sum(SEdeducciones) as TSEdeducciones, 
			sum(SEliquido) as TSEliquido
	from HSalarioEmpleado
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
  </cfquery>
  <cfquery name="rsHRelacionCalculo" datasource="#Session.DSN#">
	select a.RCNid as RCNid, 
		   rtrim(a.Tcodigo) as Tcodigo, 
		   a.RCDescripcion, 
		   a.RCdesde as RCdesde, 
   		   a.RCdesde as fecha, 
		   a.RChasta as RChasta,
		   (case a.RCestado 
				when 0 then '<cf_translate  key="LB_Proceso">Proceso</cf_translate>'
				when 1 then '<cf_translate  key="LB_Calculo">Cálculo</cf_translate>'
				when 2 then '<cf_translate  key="LB_Terminado">Terminado</cf_translate>'
				when 3 then '<cf_translate  key="LB_Pagado">Pagado</cf_translate>'
				else ''
		   end) as RCestado,
		   a.Usucodigo as Usucodigo, 
		   a.Ulocalizacion, 
		   a.ts_rversion,
		   b.Tdescripcion,
		   b.Mcodigo
		from HRCalculoNomina a, TiposNomina b
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetalle.RCNid#">
	and a.Tcodigo = b.Tcodigo
	and a.Ecodigo = b.Ecodigo	
  </cfquery>
  <cfquery name="rsHCargas" datasource="#Session.DSN#">
	select 	a.DEid as DEid, 
	a.DClinea as DClinea, 
	CCvaloremp, 
	CCvalorpat, 
	DCdescripcion, 
	ECauto
	from HCargasCalculo a, DCargas b, ECargas c
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetalle.RCNid#">
  	  and a.DClinea = b.DClinea
	  and b.ECid = c.ECid
  </cfquery>
  <cfquery name="rsHDeducciones" datasource="#Session.DSN#">	
	select  a.DEid as DEid, a.DCvalor, 
	b.Ddescripcion, 
	b.Dvalor, 
	b.Dmetodo
	from HDeduccionesCalculo a, DeduccionesEmpleado b
	where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetalle.RCNid#">
	  and a.Did = b.Did
  </cfquery>
  <cfquery name="rsHIncidencias" datasource="#Session.DSN#">
	select a.DEid as DEid, ICfecha, 
	ICvalor, ICmontores, b.CIdescripcion
	from HIncidenciasCalculo a, CIncidentes b
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetalle.RCNid#">
	and a.CIid = b.CIid
  </cfquery>
  <cfquery name="rsCalendarioPagos" datasource="#session.DSN#">
	select CPcodigo 
	from CalendarioPagos 
	Where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetalle.RCNid#">
  </cfquery>
</cfif>
<!--- Datos de la Empresa --->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<!--- Encabezado del Reporte --->
<cfif rsDetalle.REcordCount gt 0>
<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_HistoricoDeNominasAplicadas"
Default="Histórico de Nóminas Aplicadas"
returnvariable="LB_HistoricoDeNominasAplicadas"/> 
<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#Session.DSN#" ecodigo="#session.Ecodigo#" pvalor="785" default="0" returnvariable="UnificaSalarioB"/>

<cf_sifHTML2Word listTitle="#LB_HistoricoDeNominasAplicadas#">
  <table width="97%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center">

	<tr>
		<td colspan="8" align="center">
			<table width="100%" cellpadding="0" cellspacing="0">
				<cfinvoke key="LB_ReporteHistoricoDeNominas" default="Reporte Hist&oacute;rico de N&oacute;minas" returnvariable="LB_ReporteHistoricoDeNominas" component="sif.Componentes.Translate"  method="Translate"/>
				<tr><td>
					<cfset filtro2 = ''>
					<cfinvoke key="LB_CodigoDeCalendario" default="<b>C&oacute;digo de Calendario</b>" returnvariable="LB_CodigoDeCalendario" component="sif.Componentes.Translate"  method="Translate"/>
					<cfinvoke key="LB_Desde" default="<b>Desde</b>" returnvariable="LB_Desde" component="sif.Componentes.Translate"  method="Translate"/>
					<cfinvoke key="LB_Hasta" default="<b>Hasta</b>" returnvariable="LB_Hasta" component="sif.Componentes.Translate"  method="Translate"/>
					<cfset filtro2= LB_CodigoDeCalendario&': '& rsCalendarioPagos.CPcodigo&' '&LB_Desde&' '&LSDATEFORMAT(rsHRelacionCalculo.RCdesde,"DD/MM/YYYY")&' '&LB_Hasta&' '&#LSDateformat(rsHRelacionCalculo.RChasta,"DD/MM/YYYY")#>				
					<cf_EncReporte
						Titulo="#LB_ReporteHistoricoDeNominas#"
						Color="##E3EDEF"
						cols="8"
						filtro1="<b>#rsHRelacionCalculo.Tdescripcion# - #rsHRelacionCalculo.RCDescripcion#</b>"
						filtro2="#filtro2#"
					>
				</td></tr>
			</table>
		</td>
	</tr>
    <tr> 
      <td colspan="8">&nbsp;</td>
    </tr>
	<!--- Resumen: Totales de RSDetalle --->
	<tr> 
      <td nowrap class="tituloListas"> <div align="left"><cf_translate  key="LB_Empleados">Empleados</cf_translate> :&nbsp;</div></td>
      <td nowrap class="tituloListas"> <div align="left">&nbsp;</div></td>
      <td nowrap class="tituloListas"> <div align="right"><cf_translate  key="LB_Bruto">Bruto</cf_translate> :&nbsp;</div></td>
       <cfif not UnificaSalarioB><td nowrap class="tituloListas"> <div align="right"><cf_translate  key="LB_Incidencias">Incidencias</cf_translate> :&nbsp;</div></td></cfif>
      <td nowrap class="tituloListas"> <div align="right"><cf_translate  key="LB_Renta">Renta</cf_translate> :&nbsp;</div></td>
      <td nowrap class="tituloListas"> <div align="right"><cf_translate  key="LB_CargasEmpleado">Cargas Empleado</cf_translate> :&nbsp;</div></td>
      <td nowrap class="tituloListas"> <div align="right"><cf_translate  key="LB_Deducciones">Deducciones</cf_translate> :&nbsp;</div></td>
      <td nowrap class="tituloListas"> <div align="right"><cf_translate  key="LB_Liquido">Líquido</cf_translate> :&nbsp;</div></td>
    </tr>
	<cfoutput query="rsTDetalle">
	<cfflush interval="512">
	<tr class="listaNon" onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='##FFFFFF';">
      <td nowrap class="FileLabel" align="left">#rsDetalle.RecordCount#&nbsp;</td>
      <td nowrap class="FileLabel" align="left"> <div>Resumen General&nbsp;</td>
      <td nowrap class="FileLabel" valign="bottom" nowrap align="right"><cfif not UnificaSalarioB>#LSCurrencyFormat(TSEsalariobruto,'none')#<cfelse>#LSCurrencyFormat(TSEsalariobruto+TSEincidencias,'none')#</cfif>&nbsp;</td>
       <cfif not UnificaSalarioB><td nowrap class="FileLabel" align="right">#LSCurrencyFormat(TSEincidencias,'none')#&nbsp;</td></cfif>
      <td nowrap class="FileLabel" align="right">#LSCurrencyFormat(TSErenta,'none')#&nbsp;</td>
      <td nowrap class="FileLabel" align="right">#LSCurrencyFormat(TSEcargasempleado,'none')#&nbsp;</td>
      <td nowrap class="FileLabel" align="right">#LSCurrencyFormat(TSEdeducciones,'none')#&nbsp;</td>
      <td nowrap class="FileLabel" align="right">#LSCurrencyFormat(TSEliquido,'none')#&nbsp;</td>
    </tr>
	</cfoutput>
    <tr> 
      <td colspan="8">&nbsp;</td>
    </tr>
    <tr> 
      <td nowrap class="tituloListas"> <div align="left"><cf_translate  key="LB_Cedula">Cedula</cf_translate> :&nbsp;</div></td>
      <td nowrap class="tituloListas"> <div align="left"><cf_translate  key="LB_Nombre">Nombre</cf_translate> :&nbsp;</div></td>
      <td nowrap class="tituloListas"> <div align="right"><cf_translate  key="LB_Bruto">Bruto</cf_translate> :&nbsp;</div></td>
      <cfif not UnificaSalarioB><td nowrap class="tituloListas"> <div align="right"><cf_translate  key="LB_Incidencias">Incidencias</cf_translate> :&nbsp;</div></td></cfif>
      <td nowrap class="tituloListas"> <div align="right"><cf_translate  key="LB_Renta">Renta</cf_translate> :&nbsp;</div></td>
      <td nowrap class="tituloListas"> <div align="right"><cf_translate  key="LB_CargasEmpleado">Cargas Empleado</cf_translate> :&nbsp;</div></td>
      <td nowrap class="tituloListas"> <div align="right"><cf_translate  key="LB_Deducciones">Deducciones</cf_translate> :&nbsp;</div></td>
      <td nowrap class="tituloListas"> <div align="right"><cf_translate  key="LB_Liquido">Líquido</cf_translate> :&nbsp;</div></td>
    </tr>
    <cfoutput query="rsDetalle"> 
	<cfflush interval="512">
      <tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3'; style.cursor='pointer';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"
	   onClick="location.href='/cfmx/rh/nomina/consultas/HPResultadoCalculo.cfm?RCNid=#rsDetalle.RCNid#&Tcodigo=#Form.Tcodigo#&DEid=#rsDetalle.DEid#&fecha=#rsHRelacionCalculo.fecha#&Regresar=/cfmx/rh/nomina/consultas/PConsultaRCalculoHist.cfm'"> 
        <td nowrap> 
          #rsDetalle.DEidentificacion#</td>
        <td nowrap>#rsDetalle.Nombre#</td>
        <td nowrap align="right"><cfif not UnificaSalarioB>#LSCurrencyFormat(rsDetalle.SEsalariobruto,'none')#<cfelse>#LSCurrencyFormat(rsDetalle.SEsalariobruto+rsDetalle.SEincidencias,'none')#</cfif></td>
        <cfif not UnificaSalarioB><td nowrap align="right">#LSCurrencyFormat(rsDetalle.SEincidencias,'none')#</td></cfif>
        <td nowrap align="right">#LSCurrencyFormat(rsDetalle.SErenta,'none')#</td>
        <td nowrap align="right">#LSCurrencyFormat(rsDetalle.SEcargasempleado,'none')#</td>
        <td nowrap align="right">#LSCurrencyFormat(rsDetalle.SEdeducciones,'none')#</td>
        <td nowrap align="right">#LSCurrencyFormat(rsDetalle.SEliquido,'none')#</td>

      <!--- Incidencias --->
      <cfif isDefined("Form.chkIncidencias")>
      </tr>
        <cfquery name="rsTemp" dbtype="query">
        select * from rsHIncidencias where DEid = '#DEid#' <!--- *** --->
        </cfquery>
        <tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
          <td nowrap>&nbsp;</td>
          <td nowrap colspan="7" ><strong><em><cf_translate  key="LB_Incidencias">Incidencias</cf_translate></em></strong></td>
        </tr>
        <tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
          <td nowrap>&nbsp;</td>
          <td nowrap class="FileLabel"> 
            <div align="left"><cf_translate  key="LB_Fecha">Fecha</cf_translate> :&nbsp;</div></td>
          <td nowrap class="FileLabel" colspan="4"> 
            <div align="left"><cf_translate  key="LB_Concepto">Concepto</cf_translate> :&nbsp;</div></td>
          <td nowrap class="FileLabel"> 
            <div align="right"><cf_translate  key="LB_Valor">Valor</cf_translate> :&nbsp;</div></td>
          <td nowrap class="FileLabel"> 
            <div align="right"><cf_translate  key="LB_MontoResultante">Monto Resultante</cf_translate> :&nbsp;</div></td>
        </tr>
        <cfif rsTemp.RecordCount gt 0>
          <cfloop query="rsTemp">
            <tr class=<cfif rsDetalle.CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif rsDetalle.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
              <td nowrap>&nbsp;</td>
              <td nowrap> 
                #LSDateFormat(rsTemp.ICfecha,'dd/mm/yyyy')#</td>
              <td nowrap colspan="4"> 
                #rsTemp.CIdescripcion#</td>
              <td nowrap> 
                <div align="right"> #rsTemp.ICvalor# </div></td>
              <td nowrap> 
                <div align="right"> #LSCurrencyFormat(rsTemp.ICmontores,'none')# </div></td>
            </tr>
          </cfloop>
          <cfelse>
          <tr class=<cfif rsDetalle.CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif rsDetalle.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
            <td colspan="8" align="center"><cf_translate  key="LB_NoHayIncidenciasAsociadasAlEmpleado">No hay incidencias asociadas al empleado</cf_translate></td>
          </tr>
        </cfif>
        <tr class=<cfif rsDetalle.CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif rsDetalle.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
          <td colspan="8">&nbsp;</td>
        </tr>
      </cfif>
      <!--- Cargas --->
      <cfif isDefined("Form.chkCargas")>
	    <cfquery name="rsTemp" dbtype="query">
        select * from rsHCargas where DEid = '#DEid#' <!--- *** --->
        </cfquery>
        <tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
          <td nowrap>&nbsp;</td>
          <td nowrap colspan="7"><strong><em><cf_translate  key="LB_Cargas">Cargas</cf_translate></em></strong></td>
        </tr>
        <tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
          <td nowrap>&nbsp;</td>
          <td nowrap class="FileLabel" colspan="5"> 
            <div align="left"><cf_translate  key="LB_Descripcion">Descripci&oacute;n</cf_translate> :&nbsp;</div></td>
          <td nowrap class="FileLabel"> 
            <div align="right"><cf_translate  key="LB_MontoPatrono">Monto Patrono</cf_translate> :&nbsp;</div></td>
          <td nowrap class="FileLabel"> 
            <div align="right"><cf_translate  key="LB_MontoEmpleado">Monto Empleado</cf_translate> :&nbsp;</div></td>
        </tr>
        <cfif rsTemp.RecordCount gt 0>
          <cfloop query="rsTemp">
            <tr class=<cfif rsDetalle.CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif rsDetalle.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
              <td nowrap>&nbsp;</td>
              <td nowrap colspan="5"> 
                #rsTemp.DCdescripcion#</td>
              <td nowrap> 
                <div align="right"> #LSCurrencyFormat(rsTemp.CCvalorpat,'none')# </div></td>
              <td nowrap> 
                <div align="right"> #LSCurrencyFormat(rsTemp.CCvaloremp,'none')# </div></td>
            </tr>
          </cfloop>
          <cfelse>
          <tr class=<cfif rsDetalle.CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif rsDetalle.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
            <td colspan="8" align="center"><cf_translate  key="LB_NoHayCargasAsociadasAlEmpleado">No hay cargas asociadas al empleado</cf_translate></td>
          </tr>
        </cfif>
        <tr class=<cfif rsDetalle.CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif rsDetalle.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
          <td colspan="8">&nbsp;</td>
        </tr>
      </cfif>
      <!--- Deducciones --->
      <cfif isDefined("Form.chkDeducciones")>
        <cfquery name="rsTemp" dbtype="query">
        select * from rsHDeducciones where DEid = '#DEid#' <!--- *** --->
        </cfquery>
        <tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
          <td nowrap>&nbsp;</td>
          <td nowrap colspan="7"><strong><em><cf_translate  key="LB_Deducciones">Deducciones</cf_translate></em></strong></td>
        </tr>
        <tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
          <td nowrap>&nbsp;</td>
          <td nowrap class="FileLabel" colspan="5"> 
            <div align="left"><cf_translate  key="LB_Descripcion">Descripci&oacute;n</cf_translate> :&nbsp;</div></td>
          <td nowrap class="FileLabel"> 
            <div align="right"><cf_translate  key="LB_Valor">Valor</cf_translate> :&nbsp;</div></td>
          <td nowrap class="FileLabel"> 
            <div align="right"><cf_translate  key="LB_MontoResultante">Monto Resultante</cf_translate> :&nbsp;</div></td>
        </tr>
        <cfif rsTemp.RecordCount gt 0>
          <cfloop query="rsTemp">
            <tr class=<cfif rsDetalle.CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif rsDetalle.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
              <td nowrap>&nbsp;</td>
              <td nowrap colspan="5"> 
                #rsTemp.Ddescripcion#</td>
              <td nowrap> 
                <div align="right"> 
                  <cfif Dmetodo neq 0>
                    #LSCurrencyFormat(Dvalor,'none')# 
                    <cfelse>
                    #LSCurrencyFormat(Dvalor,'none')# % 
                  </cfif>
                </div></td>
              <td nowrap> <div align="right"> #LSCurrencyFormat(rsTemp.DCvalor,'none')# </div></td>
            </tr>
          </cfloop>
          <cfelse>
          <tr class=<cfif rsDetalle.CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif rsDetalle.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
            <td colspan="8" align="center"><cf_translate  key="LB_NoHayDeduccionesAsociadasAlEmpleado">No hay deducciones asociadas al empleado</cf_translate></td>
          </tr>
        </cfif>
        <tr class=<cfif rsDetalle.CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif rsDetalle.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
          <td colspan="8">&nbsp;</td>
        </tr>
      </cfif>
    </cfoutput> 
    <tr> 
      <td colspan="8">&nbsp;</td>
    </tr>
    <td colspan="8" align="center"> <strong>*** <cf_translate  key="LB_FinDelReporte">Fin del Reporte</cf_translate> *** </strong> 
    </td>
    <tr> 
      <td colspan="8">&nbsp;</td>
    </tr>
  </table>
</cf_sifHTML2Word>
<cfelse>
<table width="97%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center">
<tr>
    <tr> 
      <td colspan="8">&nbsp;</td>
    </tr>
	  <td colspan="8" align="center"> <strong>*** <cf_translate  key="LB_LaConsultaNoGeneroNingunResultado">La Consulta No Gener&oacute; Ning&uacute;n Resultado</cf_translate> *** </strong> </td>
	<tr> 
      <td colspan="8">&nbsp;</td>
    </tr>
</tr>
</table>	
</cfif>