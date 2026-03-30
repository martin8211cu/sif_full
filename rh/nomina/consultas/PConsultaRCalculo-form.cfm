<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_Historico_de_Nominas_Aplicadas" Default="Histórico de Nóminas Aplicadas"	 returnvariable="LB_Historico_de_Nominas_Aplicadas" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Bruto" Default="Bruto"	 returnvariable="LB_Bruto" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Incidencias" Default="Incidencias"	 returnvariable="LB_Incidencias" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Renta" Default="Renta"	 returnvariable="LB_Renta" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Cargas_Empleado" Default="Cargas Empleado"	 returnvariable="LB_Cargas_Empleado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Deducciones" Default="Deducciones"	 returnvariable="LB_Deducciones" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Liquido" Default="Líquido"	 returnvariable="LB_Liquido" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Valor" Default="Valor :"	 returnvariable="LB_Valor" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Monto_Resultante" Default="Monto Resultante :" returnvariable="LB_Monto_Resultante" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Reporte_de_Nomina_en_Proceso" default="Reporte de N&oacute;minas en Proceso" returnvariable="LB_Reporte_de_Nomina_en_Proceso" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_Desde" default="Desde" returnvariable="LB_Desde" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_Hasta" default="Hasta" returnvariable="LB_Hasta" component="sif.Componentes.Translate"  method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<cfif isDefined("Url.RCNid") and not isDefined("Form.RCNid")>
	<cfset Form.RCNid = Url.RCNid>
</cfif>
<cfif isDefined("Url.Tcodigo") and not isDefined("Form.Tcodigo")>
	<cfset Form.Tcodigo = Url.Tcodigo>
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
<cfif isDefined("Url.chkCargas") and not isDefined("Form.chkCargas")>
	<cfset Form.chkCargas = Url.chkCargas>
</cfif>
<cfif isDefined("Url.chkDeducciones") and not isDefined("Form.chkDeducciones")>
	<cfset Form.chkDeducciones = Url.chkDeducciones>
</cfif>

<!--- Consultas --->
<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#Session.DSN#" ecodigo="#session.Ecodigo#" pvalor="785" default="0" returnvariable="UnificaSalarioB"/>
<!--- Detalles de la Nómina --->
<cfquery name="rsDetalle" datasource="#Session.DSN#">
	select 
		a.DEid, 
		a.RCNid,
		b.DEidentificacion, 
		{fn concat({fn concat({fn concat({ fn concat(b.DEapellido1, ' ') },b.DEapellido2)}, ' ')},b.DEnombre) } as Nombre, 
		SEsalariobruto, 
		SEincidencias, 
		SErenta, 
		SEcargasempleado, 
		SEdeducciones, 
		SEliquido
	from SalarioEmpleado a, DatosEmpleado b, RCalculoNomina c
	where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and c.Tcodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Tcodigo#">
			and a.RCNid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
			<cfif isDefined("Form.DEid") and len(trim(Form.DEid)) gt 0>
			and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
			</cfif>
			and a.DEid = b.DEid
			and a.RCNid = c.RCNid
	order by b.DEapellido1, b.DEapellido2, b.DEnombre, b.DEidentificacion 
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
	from SalarioEmpleado
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
  </cfquery>
  <cfquery name="rsHRelacionCalculo" datasource="#Session.DSN#">
	select a.RCNid, 
		   rtrim(a.Tcodigo) as Tcodigo, 
		   a.RCDescripcion, 
		   a.RCdesde, 
		   a.RChasta,
		   (case a.RCestado 
				when 0 then 'Proceso'
				when 1 then 'Cálculo'
				when 2 then 'Terminado'
				when 3 then 'Pagado'
				else ''
		   end) as RCestado,
		   a.Usucodigo, 
		   a.Ulocalizacion, 
		   a.ts_rversion,
		   b.Tdescripcion,
		   b.Mcodigo
		from RCalculoNomina a, TiposNomina b
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetalle.RCNid#">
	and a.Tcodigo = b.Tcodigo
	and a.Ecodigo = b.Ecodigo
  </cfquery>
  <cfquery name="rsHCargas" datasource="#Session.DSN#">
	select 	a.DEid, a.DClinea, CCvaloremp, CCvalorpat, DCdescripcion, ECauto
	from CargasCalculo a, DCargas b, ECargas c
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetalle.RCNid#">
  	  and a.DClinea = b.DClinea
	  and b.ECid = c.ECid
  </cfquery>
  <cfquery name="rsHDeducciones" datasource="#Session.DSN#">	
	select  a.DEid, a.DCvalor, b.Ddescripcion, b.Dvalor, b.Dmetodo
	from DeduccionesCalculo a, DeduccionesEmpleado b
	where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetalle.RCNid#">
	  and a.Did = b.Did
  </cfquery>
  <cfquery name="rsHIncidencias" datasource="#Session.DSN#">
	select a.DEid, ICfecha, ICvalor, ICmontores, b.CIdescripcion
	from IncidenciasCalculo a, CIncidentes b
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDetalle.RCNid#">
	and a.CIid = b.CIid
  </cfquery>
</cfif>
<!--- Datos de la Empresa --->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<cfif rsDetalle.REcordCount gt 0>
<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">
	function showDetail(RCNid, DEid) {
	<cfoutput>
		location.href = '/cfmx/rh/expediente/consultas/PResultadoCalculo.cfm?RCNid='+RCNid+'&Tcodigo=#Form.Tcodigo#&DEid='+DEid+'&fecha=#Form.fecha#&Regresar=/cfmx/rh/nomina/consultas/PConsultaRCalculo.cfm';
	</cfoutput>
	}
</script>



<!--- <cf_sifHTML2Word listTitle="#LB_Historico_de_Nominas_Aplicadas#"> --->

<cf_htmlreportsheaders
			title="#LB_Historico_de_Nominas_Aplicadas#" 
			filename="ReporteNominasAplicadas#lsdateformat(now(),'yyyymmdd')##LSTimeFormat(now(),'hhmmss')#.xls" 
			ira="../../indexReportes.cfm?Tcodigo=#form.Tcodigo#&fecha=#form.Fecha#&RCNid=#form.RCNid#">
  <table width="97%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center">
	<tr>
		<td colspan="8">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr><td colspan="">
					<cf_EncReporte
						Titulo="#LB_Reporte_de_Nomina_en_Proceso#"
						Color="##E3EDEF"
						cols="8"
						filtro1="#rsHRelacionCalculo.Tdescripcion# - #rsHRelacionCalculo.RCDescripcion#"	
						filtro2="#LB_Desde# #LSDateFormat(rsHRelacionCalculo.RCdesde,'dd/mm/yyyy')#  #LB_Hasta# #LSDateFormat(rsHRelacionCalculo.RChasta,'dd/mm/yyyy')#"
					>
				</td></tr>
			</table>	
		</td>
	</tr>

	<!--- Resumen: Totales de RSDetalle --->
	<tr>
	  <cfoutput>
      <td nowrap class="tituloListas"> <div align="left"><cf_translate key="LB_Empleado" XmlFile="/rh/generales.xml">Empleado</cf_translate>&nbsp;</div></td>
      <td nowrap class="tituloListas"> <div align="left">&nbsp;</div></td>
      <td nowrap class="tituloListas"> <div align="right">#LB_Bruto#&nbsp;</div></td>
      <cfif not UnificaSalarioB><td nowrap class="tituloListas"> <div align="right">#LB_Incidencias#&nbsp;</div></td></cfif>
      <td nowrap class="tituloListas"> <div align="right">#LB_Renta#&nbsp;</div></td>
      <td nowrap class="tituloListas"> <div align="right">#LB_Cargas_Empleado#&nbsp;</div></td>
      <td nowrap class="tituloListas"> <div align="right">#LB_Deducciones#&nbsp;</div></td>
      <td nowrap class="tituloListas"> <div align="right">#LB_Liquido#&nbsp;</div></td>
	  </cfoutput> 
    </tr>
	<cfoutput query="rsTDetalle">
	<cfflush interval="512">
	<tr class="listaNon" onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='##FFFFFF';">
      <td align="left" nowrap class="FileLabel"> #rsDetalle.RecordCount#&nbsp;</td>
      <td align="left" nowrap class="FileLabel"> <cf_translate key="LB_Resumen_General">Resumen General</cf_translate>&nbsp;</td>
      <td align="right" nowrap class="FileLabel"> <cfif not UnificaSalarioB>#LSCurrencyFormat(TSEsalariobruto,'none')#<cfelse>#LSCurrencyFormat(TSEsalariobruto+TSEincidencias,'none')#</cfif>&nbsp;</td>
      <cfif not UnificaSalarioB><td align="right" nowrap class="FileLabel"> #LSCurrencyFormat(TSEincidencias,'none')#&nbsp;</td></cfif>
      <td align="right" nowrap class="FileLabel"> #LSCurrencyFormat(TSErenta,'none')#&nbsp;</td>
      <td align="right" nowrap class="FileLabel"> #LSCurrencyFormat(TSEcargasempleado,'none')#&nbsp;</td>
      <td align="right" nowrap class="FileLabel"> #LSCurrencyFormat(TSEdeducciones,'none')#&nbsp;</td>
      <td align="right" nowrap class="FileLabel"> #LSCurrencyFormat(TSEliquido,'none')#&nbsp;</td>
    </tr>
	</cfoutput>
    <tr> 
      <td colspan="8">&nbsp;</td>
    </tr>
    <tr> 
      <td nowrap class="tituloListas"> <cf_translate key="LB_Cedula" XmlFile="/rh/generales.xml">Cedula </cf_translate>&nbsp;</td>
      <td nowrap class="tituloListas"><cf_translate key="LB_Nombre">Nombre </cf_translate>&nbsp;</td>
      <cfoutput> 
	  <td align="right" nowrap class="tituloListas">#LB_Bruto#&nbsp;</td>
      <cfif not UnificaSalarioB><td align="right" nowrap class="tituloListas">#LB_Incidencias#&nbsp;</td></cfif>
      <td align="right" nowrap class="tituloListas">#LB_Renta#&nbsp;</td>
      <td align="right" nowrap class="tituloListas">#LB_Cargas_Empleado#&nbsp;</td>
      <td align="right" nowrap class="tituloListas">#LB_Deducciones#&nbsp;</td>
      <td align="right" nowrap class="tituloListas">#LB_Liquido#&nbsp;</td>
	  </cfoutput> 
    </tr>
    <cfoutput query="rsDetalle"> 
	<cfflush interval="512">
      <tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';style.cursor= 'pointer';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"
	   onClick="javascript: showDetail('#rsDetalle.RCNid#','#rsDetalle.DEid#');"> 
        <td nowrap>#rsDetalle.DEidentificacion#</td>
        <td nowrap>#rsDetalle.Nombre#</td>
        <td align="right" nowrap><cfif not UnificaSalarioB>#LSCurrencyFormat(rsDetalle.SEsalariobruto,'none')#<cfelse>#LSCurrencyFormat(rsDetalle.SEsalariobruto+rsDetalle.SEincidencias,'none')#</cfif></td>
        <cfif not UnificaSalarioB><td align="right" nowrap>#LSCurrencyFormat(rsDetalle.SEincidencias,'none')#</td></cfif>
        <td align="right" nowrap>#LSCurrencyFormat(rsDetalle.SErenta,'none')#</td>
        <td align="right" nowrap>#LSCurrencyFormat(rsDetalle.SEcargasempleado,'none')#</td>
        <td align="right" nowrap>#LSCurrencyFormat(rsDetalle.SEdeducciones,'none')#</td>
        <td align="right" nowrap>#LSCurrencyFormat(rsDetalle.SEliquido,'none')#</td>
      </tr>
      <!--- Incidencias --->
      <cfif isDefined("Form.chkIncidencias")>
        <cfquery name="rsTemp" dbtype="query">
        select * from rsHIncidencias where DEid = '#DEid#' 
        </cfquery>
        <cfoutput> 
		<tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
          <td nowrap>&nbsp;</td>
          <td nowrap colspan="7" ><strong><em>#LB_Incidencias#</em></strong></td>
        </tr>
        <tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
          <td nowrap>&nbsp;</td>
          <td nowrap class="FileLabel"> 
            <div align="left"><cf_translate key="LB_Fecha" XmlFile="/rh/generales.xml">Fecha :</cf_translate>&nbsp;</div></td>
          <td nowrap class="FileLabel" colspan="4"> 
            <div align="left"><cf_translate key="LB_Concepto">Concepto :</cf_translate>&nbsp;</div></td>
          <td nowrap class="FileLabel"> 
            <div align="right">#LB_Valor#&nbsp;</div></td>
          <td nowrap class="FileLabel"> 
            <div align="right">#LB_Monto_Resultante#&nbsp;</div></td>
        </tr>
		</cfoutput> 
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
            <td colspan="8" align="center"><cf_translate key="LB_No_hay_incidencias_asociadas_al_empleado">No hay incidencias asociadas al empleado</cf_translate></td>
          </tr>
        </cfif>
        <tr class=<cfif rsDetalle.CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif rsDetalle.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
          <td colspan="8">&nbsp;</td>
        </tr>
      </cfif>
      <!--- Cargas --->
      <cfif isDefined("Form.chkCargas")>
        <cfquery name="rsTemp" dbtype="query">
        select * from rsHCargas where DEid = '#DEid#' 
        </cfquery>
        <tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
          <td nowrap>&nbsp;</td>
          <td nowrap colspan="7"><strong><em><cf_translate key="LB_Cargas">Cargas</cf_translate></em></strong></td>
        </tr>
        <tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
          <td nowrap>&nbsp;</td>
          <td nowrap class="FileLabel" colspan="5"> 
            <div align="left"><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n :</cf_translate>&nbsp;</div></td>
          <td nowrap class="FileLabel"> 
            <div align="right"><cf_translate key="LB_Monto_Patrono">Monto Patrono :</cf_translate>&nbsp;</div></td>
          <td nowrap class="FileLabel"> 
            <div align="right"><cf_translate key="LB_Monto_Empleado">Monto Empleado :</cf_translate>&nbsp;</div></td>
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
            <td colspan="8" align="center"><cf_translate key="LB_No_hay_cargas_asociadas_al_empleado">No hay cargas asociadas al empleado</cf_translate></td>
          </tr>
        </cfif>
        <tr class=<cfif rsDetalle.CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif rsDetalle.CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
          <td colspan="8">&nbsp;</td>
        </tr>
      </cfif>
      <!--- Deducciones --->
      <cfif isDefined("Form.chkDeducciones")>
        <cfquery name="rsTemp" dbtype="query">
        select * from rsHDeducciones where DEid = '#DEid#' 
        </cfquery>
        <cfoutput> 
		<tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
          <td nowrap>&nbsp;</td>
          <td nowrap colspan="7"><strong><em>#LB_Deducciones#</em></strong></td>
        </tr>
        <tr class=<cfif CurrentRow MOD 2>"listaNon" <cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
          <td nowrap>&nbsp;</td>
          <td nowrap class="FileLabel" colspan="5"> 
            <div align="left"><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n :</cf_translate>&nbsp;</div></td>
          <td nowrap class="FileLabel"> 
            <div align="right">#LB_Valor#&nbsp;</div></td>
          <td nowrap class="FileLabel"> 
            <div align="right">#LB_Monto_Resultante#&nbsp;</div></td>
        </tr>
		</cfoutput> 
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
            <td colspan="8" align="center"><cf_translate key="LB_No_hay_deducciones_asociadas_al_empleado">No hay deducciones asociadas al empleado</cf_translate></td>
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
    <td colspan="8" align="center"> <strong>*** <cf_translate key="LB_Fin_del_Reporte">Fin del Reporte</cf_translate> *** </strong> 
    </td>
    <tr> 
      <td colspan="8">&nbsp;</td>
    </tr>
  </table>
<!--- </cf_sifHTML2Word> --->
<cfelse>
<table width="97%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center">
<tr>
    <tr> 
      <td colspan="8">&nbsp;</td>
    </tr>
	  <td colspan="8" align="center"> <strong>
	  *** <cf_translate key="LB_La_Consulta_No_Genero_Ningun_Resultado">La Consulta No Gener&oacute; Ning&uacute;n Resultado </cf_translate>*** 
	  </strong> </td>
	<tr> 
      <td colspan="8">&nbsp;</td>
    </tr>
</tr>
</table>	
</cfif>