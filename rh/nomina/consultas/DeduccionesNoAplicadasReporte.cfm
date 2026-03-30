<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_DescuentosNoAplicados" Default="Descuentos no Aplicados" returnvariable="LB_DescuentosNoAplicados" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_CalendarioDePago" Default="Calendario de Pago" returnvariable="LB_CalendarioDePago" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_TipoDeNomina" Default="Tipo de N&oacute;mina" returnvariable="LB_TipoDeNomina" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_FechaInicio" Default="Fecha Inicio" returnvariable="LB_FechaInicio" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_FechaFin" Default="Fecha Fin" returnvariable="LB_FechaFin" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->

<!--- CLASES --->
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
<!--- FIN CLASES --->

<!--- REPORTE --->
<cfquery name="rsReporte" datasource="#session.DSN#">
	select
          a.RCNid, 
          a.RCDescripcion,
          c.DCvalor,
          d.DEid, 
            d.DEidentificacion,
            {fn concat(d.DEapellido1,{fn concat(' ',{fn concat(d.DEapellido2,{fn concat(' ',d.DEnombre)})})})} as DEnombre, 
          f.TDcodigo,
          f.TDdescripcion,
          f.TDid,
          Dmonto
      from RCalculoNomina a
         	inner join SalarioEmpleado b
              on b.RCNid = a.RCNid
          	inner join DeduccionesCalculo c
				on c.RCNid = b.RCNid
            	and c.DEid = b.DEid
          	inner join DatosEmpleado d
            	on d.DEid = b.DEid
          	inner join DeduccionesEmpleado e
	             on e.Did = c.Did
			inner join TDeduccion f
				on f.TDid = e.TDid
      where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPid#">
        and c.DCvalor = 0
      order by f.TDid,f.TDcodigo,f.TDdescripcion, d.DEidentificacion
</cfquery>

<!--- CONSULTAS ADICIONALES --->
<!--- DATOS DE LOS CALENDARIOS DE PAGO DEL RANGO --->
    <cfquery name="rsCalendarioD" datasource="#session.DSN#">
    	select CPcodigo, CPdescripcion, Tdescripcion, CPdesde, CPhasta
        from CalendarioPagos a
        inner join TiposNomina b
        	on b.Tcodigo = a.Tcodigo
        where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CPid#">
    </cfquery>
     <!--- Busca el nombre de la Empresa --->
    <cfquery name="rsEmpresa" datasource="#session.DSN#">
        select Edescripcion
        from Empresas
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    </cfquery>
<!--- FIN CONSULTAS ADICIONALES --->

<!--- PINTADO DEL REPORTE --->
	<table width="100%" border="0" cellpadding="2" cellspacing="0" align="center" style="border-color:CCCCCC">
        <tr>
			<td align="center">
				<table width="85%" cellpadding="0" cellspacing="0" align="center">
					<tr><td>
						<cf_EncReporte
							Titulo="#LB_DescuentosNoAplicados#"
							Color="##E3EDEF"
							filtro1="#LB_CalendarioDePago#: #rsCalendarioD.CPcodigo#"	
							filtro2="#LB_TipoDeNomina#: #rsCalendarioD.TDescripcion#"
							filtro3="#rsCalendarioD.CPdescripcion# #LB_FechaInicio#:#LSDateFormat(rsCalendarioD.CPdesde,'dd/mm/yyyy')#  #LB_FechaFin#:#LSDateFormat(rsCalendarioD.CPhasta,'dd/mm/yyyy')#"
						>
					</td></tr>
				</table>
			</td>
		</tr>
		<!----======================== ENCABEZADO ANTERIOR ========================
		<tr>
        	<td align="center">
            	<table width="60%" cellpadding="0" cellspacing="0" border="0">
          			<cfoutput>
                    <tr><td class="titulo_empresa2" colspan="2"><strong>#rsEmpresa.Edescripcion#</strong></td></tr>
                    <tr><td class="titulo_empresa2" colspan="2"><strong>#LB_DescuentosNoAplicados#</strong></td></tr>
                    <tr><td colspan="2">&nbsp;</td></tr>
                    <tr class="tituloEncab">
                        <td><strong>#LB_CalendarioDePago#: #rsCalendarioD.CPcodigo#</strong></td>
                        <td><strong>#LB_TipoDeNomina#: #rsCalendarioD.TDescripcion#</strong></td>
                    </tr>
                    <tr class="tituloEncab"><td colspan="2"><strong>#rsCalendarioD.CPdescripcion#</strong></td></tr>
                    <tr class="tituloEncab">
                        <td><strong>#LB_FechaInicio#:#LSDateFormat(rsCalendarioD.CPdesde,'dd/mm/yyyy')#</strong></td>
                        <td><strong>#LB_FechaFin#:#LSDateFormat(rsCalendarioD.CPhasta,'dd/mm/yyyy')#</strong></td></tr>
                    <tr><td colspan="2">&nbsp;</td></tr>
                    </cfoutput>
                </table>
            </td>
        </tr>
		----->
        <tr>
        	<td>
            	<table width="85%" cellpadding="0" cellspacing="0" align="center">
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
                        	<cfif DCvalor GT 0><cfset Lvar_Monto = DCvalor><cfelse><cfset Lvar_Monto = Dmonto></cfif>
							<tr>
                                <td class="detalle">&nbsp;#DEidentificacion#</td>
                                <td class="detalle">&nbsp;#DEnombre#</td>
                                <td class="detaller">#LSCurrencyFormat(Lvar_Monto,'none')#&nbsp;</td>
                            </tr>
                            <cfset Lvar_TotalDesc = Lvar_TotalDesc + Lvar_Monto>
						</cfoutput>
                        <tr><td height="1" bgcolor="000000" colspan="3"></td>
                        <tr>
                          <td colspan="2" class="detaller"><strong><cf_translate key="LB_Total">Total</cf_translate></strong></td>
                            <td class="detaller"><strong>#LSCurrencyFormat(Lvar_TotalDesc,'none')#</strong>&nbsp;</td>
                        </tr>
                        <tr><td colspan="3">&nbsp;</td></tr>
                    </cfoutput>
            	</table>
            </td>
        </tr>
		
	</table>
<!--- FIN PINTADO DEL REPORTE --->