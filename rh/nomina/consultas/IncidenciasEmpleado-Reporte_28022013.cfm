<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_IncidenciasEmpleado" Default="Incidencias por Empleado" returnvariable="LB_IncidenciasEmpleado" component="sif.Componentes.Translate" method="Translate"/>
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
<cfif isdefined ('url.horasextras')>
<cfquery name="rsReporte" datasource="#session.DSN#">
		select a.DEid,DEidentificacion,
			{fn concat(b.DEapellido1,{fn concat(' ',{fn concat(b.DEapellido2,{fn concat(' ',b.DEnombre)})})})} as Nombre, CIcodigo,CIdescripcion, ICvalor as valor, 
				ICfecha as Fecha,case when CPtipo = 1 then 1 else 0 end as Especial
		from HIncidenciasCalculo a
		inner join DatosEmpleado b
			on b.DEid = a.DEid
		inner join CIncidentes c
			on c.CIid = a.CIid
			and c.Ecodigo = b.Ecodigo
		inner join CalendarioPagos d
			on d.CPid = a.RCNid
			and d.Ecodigo = b.Ecodigo
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		<cfif isdefined('url.DEid') and url.DEid GT 0>
		  and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
		</cfif>
		  and a.CIid in ((select CIid from CIncidentes where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> and CIcodigo = '04'), (select CIid from CIncidentes where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> and CIcodigo ='03E'),(select CIid from CIncidentes where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> and CIcodigo ='03G'))
		  and <cf_dbfunction name="to_datechar" args="ICfecha"> between  <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.Fdesde)#"> and  <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.Fhasta)#">
		  and c.CIcodigo <> 'RND' <!--- INCIDENCIA DE REDONDEO --->
		  and c.CIcarreracp = 0
		 order by DEidentificacion,ICfecha,CIdescripcion
	</cfquery>
<cfelse>
<cfif isdefined('url.historico')>
	<cfquery name="rsReporte" datasource="#session.DSN#">
		
		select a.DEid,DEidentificacion,
			{fn concat(b.DEapellido1,{fn concat(' ',{fn concat(b.DEapellido2,{fn concat(' ',b.DEnombre)})})})} as Nombre, CIcodigo,CIdescripcion, ICvalor as valor, 
				ICfecha as Fecha,case when CPtipo = 1 then 1 else 0 end as Especial
		from HIncidenciasCalculo a
		inner join DatosEmpleado b
			on b.DEid = a.DEid
		inner join CIncidentes c
			on c.CIid = a.CIid
			and c.Ecodigo = b.Ecodigo
		inner join CalendarioPagos d
			on d.CPid = a.RCNid
			and d.Ecodigo = b.Ecodigo
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		<cfif isdefined('url.DEid') and url.DEid GT 0>
		  and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
		</cfif>
		  <cfif isdefined('url.Ciid') and url.CIid GT 0>
		  and a.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CIid#">
		  </cfif>
		  and <cf_dbfunction name="to_datechar" args="ICfecha"> between  <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.Fdesde)#"> and  <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.Fhasta)#">
		  and c.CIcodigo <> 'RND' <!--- INCIDENCIA DE REDONDEO --->
		  and c.CIcarreracp = 0
		 order by DEidentificacion,ICfecha
	</cfquery>
<cfelse>
	<cfquery name="rsReporte" datasource="#session.DSN#">
		select a.DEid,DEidentificacion,
			{fn concat(b.DEapellido1,{fn concat(' ',{fn concat(b.DEapellido2,{fn concat(' ',b.DEnombre)})})})} as Nombre, 
			CIcodigo,CIdescripcion, Ivalor as Valor, Icpespecial as Especial,Ifecha as Fecha
		from Incidencias a
		inner join DatosEmpleado b
			on b.DEid = a.DEid
		inner join CIncidentes c
			on c.CIid = a.CIid
			and c.Ecodigo = b.Ecodigo
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		<cfif isdefined('url.DEid') and url.DEid GT 0>
		  and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
		</cfif>
		  <cfif isdefined('url.Ciid') and url.CIid GT 0>
		  and a.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CIid#">
		  </cfif>
		  and <cf_dbfunction name="to_datechar" args="Ifecha"> between  <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.Fdesde)#"> and  <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(url.Fhasta)#">
		  order by DEidentificacion,Ifecha
	</cfquery>
</cfif>
</cfif>


<!--- CONSULTAS ADICIONALES --->
     <!--- Busca el nombre de la Empresa --->
    <cfquery name="rsEmpresa" datasource="#session.DSN#">
        select Edescripcion
        from Empresas
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    </cfquery>
<!--- FIN CONSULTAS ADICIONALES --->

<!--- PINTADO DEL REPORTE --->
	<cfset Lvar_Titulo = ''>
	<cfif isdefined('url.DEid')><cfset Lvar_Titulo = '#rsReporte.Deidentificacion# - #rsReporte.Nombre#'></cfif>
	<table width="85%" border="0" cellpadding="2" cellspacing="0" align="center" style="border-color:CCCCCC">
        <tr>
			<td align="center">
						<cf_EncReporte
							Titulo="#LB_IncidenciasEmpleado#"
							Color="##E3EDEF"
							Cols="5"
							filtro1="#LB_FechaInicio#:#LSDateFormat(url.Fdesde,'dd/mm/yyyy')#  #LB_FechaFin#:#LSDateFormat(url.Fhasta,'dd/mm/yyyy')#"
							Filtro2="#Lvar_Titulo#">
			</td>
		</tr>
        <tr>
        	<td width="100%">
            	<table width="100%" cellpadding="0" cellspacing="0" align="center">
					<cfoutput query="rsReporte" group="DEid">
						<cfif not isdefined('url.DEid')>
						<tr><td colspan="5" class="tituloEncab">#rsReporte.Deidentificacion# - #rsReporte.Nombre#</td></tr>
						</cfif>
                        <tr class="listaCorte3" >
                        	<td>&nbsp;<cf_translate key="LB_Codigo">C&oacute;digo</cf_translate></td>
                            <td>&nbsp;<cf_translate key="LB_Nombre">Descripci&oacute;n</cf_translate></td>
                          	<td align="right">&nbsp;<cf_translate key="LB_MontoCantidad">Cantidad/Monto</cf_translate>&nbsp;</td>
							<td align="center">&nbsp;<cf_translate key="LB_Fecha">Fecha</cf_translate>&nbsp;</td>
							<td align="center">&nbsp;<cf_translate key="LB_Especial">N&oacute;mina Especial</cf_translate>&nbsp;</td>
                        </tr>
                        <tr><td height="1" bgcolor="000000" colspan="5"></td>
	                	<cfoutput>
							<tr>
                                <td class="detalle">&nbsp;#CIcodigo#</td>
                                <td class="detalle">&nbsp;#CIdescripcion#</td>
                                <td class="detaller">#LSCurrencyFormat(Valor,'none')#&nbsp;</td>
                                <td class="detallec">&nbsp;#LSDateFormat(Fecha,'dd/mm/yyyy')#</td>
								<td class="detallec">&nbsp;<cfif Especial>si<cfelse>no</cfif></td>
                            </tr>
						</cfoutput>
                        <tr><td colspan="5">&nbsp;</td></tr>
				</cfoutput>
            	</table>
            </td>
        </tr>
	</table>
<!--- FIN PINTADO DEL REPORTE --->