<!--- Variables de Traducción --->
<cfinvoke Key="LB_ReporteDescuentosAplicados"  Default="Reporte de Descuentos Aplicados"  returnvariable="LB_ReporteDescuentosAplicados" component="sif.Componentes.Translate"  method="Translate" />
<cfinvoke Key="LB_NoHayDatosRelacionados" Default="No hay datos relacionados" returnvariable="LB_NoHayDatosRelacionados" component="sif.Componentes.Translate" method="Translate"/>
<!---  FIN DE VARIABLES DE TRADUCCION  --->
    <style>
	h1.corte {
		PAGE-BREAK-AFTER: always;}
	.tituloAlterno {
		font-size:20px;
		font-weight:bold;
		text-align:center;}
	.tituloEncab {
		font-size:14px;
		font-weight:bold;
		text-align:left;}
	.titulo_empresa2 {
		font-size:16px;
		font-weight:bold;
		text-align:center;}
	.titulo_reporte {
		font-size:16px;
		font-style:italic;
		text-align:center;}
	.titulo_filtro {
		font-size:14px;
		font-style:italic;
		text-align:center;}
	.titulolistas {
		font-size:14px;
		font-weight:bold;
		background-color:#CCCCCC;
		}
	.titulo_columnar {
		font-size:14px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:right;}
	.listaCorte {
		font-size:12px;
		font-weight:bold;
		background-color: #F4F4F4;
		text-align:left;}
	.listaCorte3 {
		font-size:12px;
		font-weight:bold;
		background-color:  #E8E8E8;
		text-align:left;}
	.listaCorte2 {
		font-size:12px;
		font-weight:bold;
		background-color: #D8D8D8;
		text-align:left;}
	.listaCorte1 {
		font-size:12px;
		font-weight:bold;
		background-color:#CCCCCC;
		text-align:left;}
	.total {
		font-size:14px;
		font-weight:bold;
		background-color:#C5C5C5;
		text-align:right;}

	.detalle {
		font-size:11px;
		text-align:left;}
	.detaller {
		font-size:11px;
		text-align:right;}
	.detallec {
		font-size:11px;
		text-align:center;}	
		
	.mensaje {
		font-size:14px;
		text-align:center;}
	.paginacion {
		font-size:14px;
		text-align:center;}
</style>



<!--- Consultas para pintar el Encabezado --->
<cfquery name="rsTipoNomina" datasource="#Session.DSN#">
	select
		Tcodigo as Tcodigo,
		Tdescripcion as Tdescripcion, 
		{fn concat({fn concat(rtrim(Tcodigo),' - ')},Tdescripcion)} as Descripcion
	from TiposNomina
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Tcodigo#">
</cfquery>

<cfquery name="rsCalendarioPagos" datasource="#Session.DSN#">
	select 
		CPdesde,  
		CPhasta,
		CPcodigo,
		CPdescripcion,
		{fn concat({fn concat(rtrim(CPcodigo),' - ')},CPdescripcion)} as Descripcion 
	from CalendarioPagos 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPid#"> 
		and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Tcodigo#">
</cfquery>

<cfquery name="rsReporte" datasource="#Session.DSN#">
	select
          a.RCNid, 
          a.RCDescripcion,
          sum(c.DCvalor) as monto,
          d.DEid, 
            d.DEidentificacion,
            {fn concat(d.DEapellido1,{fn concat(' ',{fn concat(d.DEapellido2,{fn concat(' ',d.DEnombre)})})})} as DEnombre, 
          f.TDcodigo,
          f.TDdescripcion,
          f.TDid
      from HRCalculoNomina a
         	inner join HSalarioEmpleado b
              on b.RCNid = a.RCNid
          	inner join HDeduccionesCalculo c
				on c.RCNid = b.RCNid
            	and c.DEid = b.DEid
          	inner join DatosEmpleado d
            	on d.DEid = b.DEid
          	inner join DeduccionesEmpleado e
	             on e.Did = c.Did
                 <cfif isdefined('url.TDid')>
				 and e.TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TDid#">
				 </cfif>
			inner join TDeduccion f
				on f.TDid = e.TDid
      where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPid#">
        and c.DCvalor > 0
      group by d.DEid, f.TDid,
      a.RCNid, 
          a.RCDescripcion,
            d.DEidentificacion,
            {fn concat(d.DEapellido1,{fn concat(' ',{fn concat(d.DEapellido2,{fn concat(' ',d.DEnombre)})})})}, 
          f.TDcodigo,
          f.TDdescripcion          
      order by f.TDid,f.TDcodigo,f.TDdescripcion,d.DEidentificacion
</cfquery>


<cfif rsReporte.REcordCount>
<table width="90%" cellpadding="1" cellspacing="0" align="center">	
	<tr><td colspan="3">&nbsp;</td></tr>
	<cfoutput>
	<tr>
		<td colspan="3" align="center">
			<table width="85%" cellpadding="0" cellspacing="0" align="center">
				<tr><td>
					<cfinvoke key="LB_TipoNomina" default="Tipo N&oacute;mina" returnvariable="LB_TipoNomina" component="sif.Componentes.Translate"  method="Translate"/>
					<cfinvoke key="LB_FechaRige" default="Fecha Rige" returnvariable="LB_FechaRige" component="sif.Componentes.Translate"  method="Translate"/>
					<cfinvoke key="LB_FechaHasta" default="Fecha Hasta" returnvariable="LB_FechaHasta" component="sif.Componentes.Translate"  method="Translate"/>
					<cf_EncReporte
						Titulo="#LB_ReporteDescuentosAplicados#"
						Color="##E3EDEF"
						filtro1="#LB_TipoNomina#: #rsTipoNomina.Descripcion#"	
						filtro2="#LB_FechaRige#: #LSDateFormat(rsCalendarioPagos.CPdesde,'dd/mm/yyyy')#   #LB_FechaHasta#:#LSDateFormat(rsCalendarioPagos.CPhasta,'dd/mm/yyyy')#"
						filtro3="#rsCalendarioPagos.CPdescripcion#"
					>
				</td></tr>
			</table>
		</td>
	</tr>
	<!---======================== ENCABEZADO ANTERIOR ========================
	<tr><td colspan="3" align="center"><strong>#Trim(Session.Enombre)#</strong></td></tr>
	<tr><td colspan="3" align="center"><strong>#LB_ReporteDescuentosAplicados#</strong></td></tr>
	<tr><td colspan="3" align="center"><strong>Tipo N&oacute;mina: #rsTipoNomina.Descripcion#</strong></td></tr>
	<tr><td colspan="3" align="center"><strong>Fecha Rige: #LSDateFormat(rsCalendarioPagos.CPdesde,'dd/mm/yyyy')# Fecha Hasta: #LSDateFormat(rsCalendarioPagos.CPhasta,'dd/mm/yyyy')#</strong></td></tr>
	<tr><td colspan="3" align="center"><strong>#rsCalendarioPagos.CPdescripcion#</strong></td></tr>
	<tr><td>&nbsp;</td></tr>
	------>
	</cfoutput>
	<tr>
        <td>
            <table width="85%" cellpadding="0" cellspacing="0" align="center">
            	<cfset Lvar_TotalGralDesc = 0>
                <cfoutput query="rsReporte" group="TDid">
                    <tr><td height="1" bgcolor="000000" colspan="3"></td>
                    <tr class="listaCorte1"><td colspan="3">&nbsp;#TDcodigo#&nbsp;-&nbsp;#TDdescripcion#</td></tr>
                    <tr><td height="1" bgcolor="000000" colspan="3"></td>
                    <tr class="listaCorte3" >
                        <td width="37%">&nbsp;<cf_translate key="LB_Codigo">C&oacute;digo</cf_translate></td>
                        <td width="51%">&nbsp;<cf_translate key="LB_Nombre">Nombre</cf_translate></td>
                        <td width="12%" align="right">&nbsp;<cf_translate key="LB_Monto">Monto</cf_translate>&nbsp;</td>
                    </tr>
                    <tr><td height="1" bgcolor="000000" colspan="3"></td>
                    <cfset Lvar_TotalDesc = 0>
                    <cfoutput>
                        <tr>
                            <td class="detalle">&nbsp;#DEidentificacion#</td>
                            <td class="detalle">&nbsp;#DEnombre#</td>
                            <td class="detaller">#LSCurrencyFormat(Monto,'none')#&nbsp;</td>
                        </tr>
                        <cfset Lvar_TotalDesc = Lvar_TotalDesc + Monto>
                    </cfoutput>
                    <tr><td height="1" bgcolor="000000" colspan="3"></td>
                    <tr>
                      <td colspan="2" class="detaller"><strong><cf_translate key="LB_Total">Total</cf_translate>&nbsp;#TDcodigo#&nbsp;-&nbsp;#TDdescripcion#</strong></td>
                        <td class="detaller"><strong>#LSCurrencyFormat(Lvar_TotalDesc,'none')#</strong>&nbsp;</td>
                    </tr>
                    <tr><td colspan="3">&nbsp;</td></tr>
                    <cfset Lvar_TotalGralDesc = Lvar_TotalGralDesc + Lvar_TotalDesc>
                </cfoutput>
                <cfoutput>
                <tr>
                	<td colspan="2" class="detaller"><strong><cf_translate key="LB_TotalGeneral">Total General</cf_translate>&nbsp;</strong></td>
                    <td class="detaller"><strong>#LSCurrencyFormat(Lvar_TotalGralDesc,'none')#</strong>&nbsp;</td>
                </tr>
                </cfoutput>
                <tr><td colspan="3">&nbsp;</td></tr>
            </table>
        </td>
    </tr>
</table>
<cfelse>
<table width="90%" cellpadding="1" cellspacing="0" align="center">
	<tr><td align="center" class="titulo_empresa2"><cfoutput>#LB_NoHayDatosRelacionados#</cfoutput></td>
	</tr>
</table>
</cfif>


