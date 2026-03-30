<cfparam name="vIrA" default="ConsultaIncidenciasProceso-Filtro.cfm">

<!---iguala variables de los filtros en caso de que el reporte se consulte desde otra pantalla--->
<cfinclude template="ConsultaIncidenciasProceso-ReporteExterno.cfm">

<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_ConsultaIncidenciasProceso" Default="Reporte de Estado de Incidencias" returnvariable="LB_ConsultaIncidenciasProceso" component="sif.Componentes.Translate" method="Translate"/>
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

<!---DEfinicion de variables--->
<cfinclude template="ConsultaIncidenciasProceso-Variables.cfm">

<!--- REPORTE --->
	<cfquery name="rsReporte" datasource="#session.DSN#">
		select  distinct x.DEid,x.DEidentificacion,x.Nombre, 
			x.CIcodigo,x.CIdescripcion, x.Valor, x.Monto,x.Especial,x.Fecha,
			x.estado_jefe, x.estado_admin, x.Jefe, x.Admin, x.justificacion,
			x.CFid,x.CFcodigo,x.CFdescripcion, x.Centro, x.Iid
			
		from( 	
		  	select a.Iid,a.DEid,b.DEidentificacion,
			{fn concat(b.DEapellido1,{fn concat(' ',{fn concat(b.DEapellido2,{fn concat(' ',b.DEnombre)})})})} as Nombre, 
			CIcodigo,CIdescripcion, Ivalor as Valor, Imonto as Monto, Icpespecial as Especial,Ifecha as Fecha,
			
			cf.CFid,cf.CFcodigo,CFdescripcion,
			
			case when a.CFid is null then 
				(select {fn concat(cf2.CFcodigo,{fn concat(' ',cf2.CFdescripcion)})} <!---cf2.CFdescripcion--->
				from LineaTiempo lt
				inner join RHPlazas pl
				on lt.RHPid = pl.RHPid
				inner join CFuncional cf2
				on pl.CFid =cf2.CFid
				where getDate() between lt.LTdesde and  lt.LThasta <!---<cf_dbfunction name="today"> --->
				and lt.DEid = a.DEid) 
			else
				cf.CFdescripcion
			end as	Centro,
			
			case 
			 when a.Iestadoaprobacion = 0  then ''
			 when a.Iestadoaprobacion = 1 then '' 
			 when a.Iestadoaprobacion = 2 then 'Aprobada'
			 when a.Iestadoaprobacion = 3 then 'Rechazada'
			else 'No aplica' end as estado_jefe,
			
			case when a.NAP is null then 'Rechazada'
				 when a.NAP is not null then 'Aprobada'
			else 'No aplica' end as estado_admin,
			
			case when a.Iestadoaprobacion in (2,3)   
				then  (
						select {fn concat({fn concat({fn concat({ fn concat( { fn concat( n.Pid, ' ') },n.Pnombre, ' ') }, n.Papellido1)}, ' ')}, n.Papellido2) } 
						from Usuario u 
						inner join DatosPersonales n
							on n.datos_personales = u.datos_personales
						where u.Usucodigo = coalesce(a.usuCF,a.BMUsucodigo))
				else '' end as Jefe,
				
				case when a.Iestado in(0,1,2)  then  
					(	select {fn concat({fn concat({fn concat({ fn concat( { fn concat( n.Pid, ' ') },n.Pnombre, ' ') }, n.Papellido1)}, ' ')}, n.Papellido2) } 
						from Usuario u 
						inner join DatosPersonales n
							on n.datos_personales = u.datos_personales
						where u.Usucodigo = coalesce(a.Iusuaprobacion,a.BMUsucodigo)) 
				else '' end as Admin,
				
			a.Ijustificacion as justificacion
			
		from HIncidencias a
		inner join CIncidentes c
			on c.CIid = a.CIid
		inner join DatosEmpleado b
			on b.DEid = a.DEid
			and c.Ecodigo = b.Ecodigo
		left outer join CFuncional cf
			on cf.CFid = a.CFid
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  
		 <!--- filtro fecha inicio--->
		  <cfif isdefined("form.Fdesde") and len(trim(form.Fdesde))>
			and a.Ifecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.Fdesde)#">
		  </cfif>
		  <!--- filtro fecha fin--->
		  <cfif isdefined("form.Fhasta") and len(trim(form.Fhasta))>
			and a.Ifecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.Fhasta)#">
		  </cfif>
		 <!---Centro Funcional--->
		  <cfif isdefined('form.CFid') and form.CFid GT 0>
		  	and a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
		  </cfif>
		  <!---Empleado--->
		  <cfif isdefined('form.DEid') and form.DEid GT 0>
		  	and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		  </cfif>
		  <!---Concepto Incidente--->
		  <cfif isdefined('form.CIid') and form.CIid GT 0>
		  	and a.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
		  </cfif>
		  <!--- TIPO: importe, horas, dias, todas --->
		  <cfif isdefined('form.CItipo') and form.CItipo GT 0>
		 	 and c.CItipo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CItipo#">
		  </cfif>
		  <!---Estado--->
		  <cfif isdefined('form.estado') and form.estado GT 0>
		  	<cfif form.estado EQ 0> 	 <!---Ingresadas--->
		 	 	and a.Iestadoaprobacion =  0
			 <cfelseif form.estado EQ 1> <!---Pendientes--->
			 	and a.Iestadoaprobacion =  1
			 <cfelseif form.estado EQ 2> <!---Aprobadas--->
			 	and (a.Iestadoaprobacion =  2	<!---jefe--->
				or a.Iestado = 1)				<!---Admin--->
			<cfelseif form.estado EQ 3> <!---Rechazadas--->
			 	and (a.Iestadoaprobacion =  3	<!---jefe--->
				or a.Iestado = 2)				<!---Admin---> 
			 </cfif>
		  </cfif>
		  <cfif rol EQ 0>
		  	and a.Iingresadopor = 0
		  </cfif>
		  <cfif rol EQ 1 >
		  	and a.Iingresadopor in (0,1)
		  </cfif>
		
		UNION
		
		select a.Iid,a.DEid,DEidentificacion,
			{fn concat(b.DEapellido1,{fn concat(' ',{fn concat(b.DEapellido2,{fn concat(' ',b.DEnombre)})})})} as Nombre, 
			CIcodigo,CIdescripcion, Ivalor as Valor, Imonto as Monto, Icpespecial as Especial,Ifecha as Fecha,
			cf.CFid,cf.CFcodigo, cf.CFdescripcion,
			case when a.CFid is null then 
				(select {fn concat(cf2.CFcodigo,{fn concat(' ',cf2.CFdescripcion)})} <!---cf2.CFdescripcion--->
				from LineaTiempo lt
				inner join RHPlazas pl
				on lt.RHPid = pl.RHPid
				inner join CFuncional cf2
				on pl.CFid =cf2.CFid
				where getDate() between lt.LTdesde and  lt.LThasta <!---<cf_dbfunction name="today"> --->
				and lt.DEid = a.DEid) 
			else
				cf.CFdescripcion
			end as	Centro,
			
			case 
				when a.Iestadoaprobacion = 0 and a.Iestado not in (1,2) then 'Ingresada'
				when a.Iestadoaprobacion = 1 then 'Pendiente'
				when a.Iestadoaprobacion = 2 then 'Aprobada'
				when a.Iestadoaprobacion = 3 then 'Rechazada'
			else 'No aplica' end as estado_jefe,
			
			case when a.Iestado = 0 and a.Iestadoaprobacion not in (0,1,3) then 'Pendiente'
			 when a.Iestado = 1 then 'Aprobada'
			 when a.Iestado = 2 then 'Rechazada'
			else 'No aplica' end as estado_admin,
				
				case when a.Iestadoaprobacion in (2,3)   
				then  (
						select {fn concat({fn concat({fn concat({ fn concat( { fn concat( n.Pid, ' ') },n.Pnombre, ' ') }, n.Papellido1)}, ' ')}, n.Papellido2) } 
						from Usuario u 
						inner join DatosPersonales n
							on n.datos_personales = u.datos_personales
						where u.Usucodigo = coalesce(a.usuCF,a.BMUsucodigo) )
				else '' end as Jefe,
				
				case when a.Iestado in(0,1,2)  then  
					(	select {fn concat({fn concat({fn concat({ fn concat( { fn concat( n.Pid, ' ') },n.Pnombre, ' ') }, n.Papellido1)}, ' ')}, n.Papellido2) } 
						from Usuario u 
						inner join DatosPersonales n
							on n.datos_personales = u.datos_personales
						where u.Usucodigo = coalesce(a.Iusuaprobacion,a.BMUsucodigo)) 
						
				else '' end as Admin,
				
			a.Ijustificacion as justificacion
			
		from Incidencias a
		inner join CIncidentes c
			on c.CIid = a.CIid
		
		inner join DatosEmpleado b
			on b.DEid = a.DEid
			and c.Ecodigo = b.Ecodigo
			
		left outer join CFuncional cf
			on cf.CFid = a.CFid
		where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		
		<!--- filtro fecha inicio--->
		  <cfif isdefined("form.Fdesde") and len(trim(form.Fdesde))>
			and a.Ifecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.Fdesde)#">
		  </cfif>
		  <!--- filtro fecha fin--->
		  <cfif isdefined("form.Fhasta") and len(trim(form.Fhasta))>
			and a.Ifecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.Fhasta)#">
		  </cfif>
		 
		 <!---Centro Funcional--->
		  <cfif isdefined('form.CFid') and form.CFid GT 0>
		  	and a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
		  </cfif>
		 <!---Empleado--->
		  <cfif isdefined('form.DEid') and form.DEid GT 0>
		  	and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		  </cfif>
		  <!---Concepto Incidente--->
		  <cfif isdefined('form.CIid') and form.CIid GT 0>
		  	and a.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
		  </cfif>
		  <!--- TIPO: importe, horas, dias, todas --->
		  <cfif isdefined('form.CItipo') and form.CItipo GT 0>
		 	 and c.CItipo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CItipo#">
		  </cfif>
		  <!---Estado--->
		  <cfif isdefined('form.estado') and form.estado GT 0>
		  	<cfif form.estado EQ 0> 	 <!---Ingresadas--->
		 	 	and a.Iestadoaprobacion =  0
			 <cfelseif form.estado EQ 1> <!---Pendientes--->
			 	and a.Iestadoaprobacion =  1
			 <cfelseif form.estado EQ 2> <!---Aprobadas--->
			 	and (a.Iestadoaprobacion =  2	<!---jefe--->
				or a.Iestado = 1)				<!---Admin--->
			<cfelseif form.estado EQ 3> <!---Rechazadas--->
			 	and (a.Iestadoaprobacion =  3	<!---jefe--->
				or a.Iestado = 2)				<!---Admin---> 
			 </cfif>
		  </cfif>
		  <cfif rol EQ 0>
		  	and a.Iingresadopor = 0
		  </cfif>
		  <cfif rol EQ 1 >
		  	and a.Iingresadopor in (0,1)
		  </cfif>
		  
		  ) x
		  <cfif rol EQ 0 >
		  	where  x.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#UserDEid#">
		  </cfif>
		  <cfif rol EQ 1>	<!--- Solo los empleados subalternos--->
			where  x.DEid in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#valueList(rsSubalternos.DEid)#">)
		  </cfif>
		  <cfif isdefined("form.group_by") and form.group_by EQ 1>	
		  	  group by 
				x.CFcodigo,x.DEidentificacion,x.CIcodigo
			  order by 
				x.CFcodigo,x.DEidentificacion,x.CIcodigo
		  <cfelse>
			  group by 
				x.DEidentificacion,x.CFcodigo,x.CIcodigo
			  order by 
				x.DEidentificacion,x.CFcodigo,x.CIcodigo
		  </cfif>
	</cfquery>
		
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
	<cfif isdefined('form.DEid')  and len(trim(form.DEid)) ><cfset Lvar_Titulo = '#rsReporte.Deidentificacion# - #rsReporte.Nombre#'></cfif>
	<cfsavecontent variable="Reporte">
		<table width="85%" border="0" cellpadding="2" cellspacing="0" align="center" style="border-color:CCCCCC">
			<tr>
				<td align="center">
							<cfset filtroFech = "#LB_FechaInicio#:#LSDateFormat(form.Fdesde,'dd/mm/yyyy')#">
							<cfif isdefined("form.Fhasta") and len(trim(form.Fhasta))>
								<cfset filtroFech = filtroFech & "  #LB_FechaFin#:#LSDateFormat(form.Fhasta,'dd/mm/yyyy')#">
							</cfif>
							<cf_EncReporte
								Titulo="#LB_ConsultaIncidenciasProceso#"
								Color="##E3EDEF"
								Cols="5"
								filtro1="#filtroFech#"
								Filtro2="#Lvar_Titulo#">
				</td>
			</tr>
			<tr>
				<td width="100%">
					<table width="100%" cellpadding="2" cellspacing="2" align="center" border="0">
						<cfset groupBy = "DEid">
						<cfif isdefined("form.group_by") and form.group_by EQ 1>
							<cfset groupBy = "CFid">
						</cfif>
						
						<cfoutput query="rsReporte" group="#groupBy#">
							<!---<cfif not isdefined('form.DEid')>--->
							<!---<tr><td colspan="10"><hr /></td></tr>--->
							<cfif isdefined("form.group_by") and form.group_by EQ 1>	
								<tr><td colspan="5" class="tituloEncab">#rsReporte.CFcodigo# - #rsReporte.CFdescripcion#</td></tr>
							<cfelse>
								<tr><td colspan="5" class="tituloEncab">#rsReporte.Deidentificacion# - #rsReporte.Nombre#</td></tr>
							</cfif>
							<!---</cfif>--->
							  <tr class="listaCorte3" >
								<cfif isdefined("form.group_by") and form.group_by EQ 1>	
									<td valign="bottom">&nbsp;<cf_translate key="LB_Empleado">Empleado</cf_translate></td>
								<cfelse>
									<td valign="bottom">&nbsp;<cf_translate key="LB_CF">Centro Funcional</cf_translate></td>
								</cfif>
								<td valign="bottom"><cf_translate key="LB_Concepto">Concepto</cf_translate></td>
								<td align="center" valign="bottom"><cf_translate key="LB_Cantidad">Cantidad</cf_translate></td>
								<td align="center" valign="bottom"><cf_translate key="LB_Monto">Monto</cf_translate></td>
								<td align="center" valign="bottom"><cf_translate key="LB_Fecha">Fecha</cf_translate></td>
								<td align="center" valign="bottom"><cf_translate key="LB_JefeAP">Aprobaci&oacute;n Jefe</cf_translate></td>
								<td align="center" valign="bottom"><cf_translate key="LB_Jefe">Jefe</cf_translate></td>
								<td align="center" valign="bottom"><cf_translate key="LB_AdminAP">Aprobaci&oacute;n Administrador</cf_translate></td>
								<td align="center" valign="bottom"><cf_translate key="LB_Admin">Administrador</cf_translate></td>
								<td align="center" valign="bottom"><cf_translate key="LB_Justificacion">Justificaci&oacute;n</cf_translate></td>
								<td align="center" valign="bottom"><cf_translate key="LB_Especial">N&oacute;mina Especial</cf_translate></td>
							</tr>
							
							<cfoutput>
								<tr>
									<cfif isdefined("form.group_by") and form.group_by EQ 1>	
										<td class="detalle" nowrap="nowrap">#rsReporte.Deidentificacion# - #rsReporte.Nombre#</td>
									<cfelse>
										<td class="detalle" nowrap="nowrap"><cfif len(trim(rsReporte.CFcodigo))>#rsReporte.CFcodigo# #rsReporte.CFdescripcion#<cfelse>#rsReporte.Centro#</cfif></td>
									</cfif>
									<td class="detalle" nowrap="nowrap">#CIcodigo# #CIdescripcion#</td>
									<td class="detaller" nowrap="nowrap">#LSCurrencyFormat(Valor,'none')#</td>
									<td class="detaller" nowrap="nowrap"><cfif Monto GT 0>#LSCurrencyFormat(Monto,'none')#</cfif></td>
									<td class="detallec" nowrap="nowrap">#LSDateFormat(Fecha,'dd/mm/yyyy')#</td>
									<td class="detalle" nowrap="nowrap"><center>#estado_jefe#</center></td>
									<td class="detalle" nowrap="nowrap"><center>#jefe#</center></td>
									<td class="detalle" nowrap="nowrap"><center>#estado_admin#</center></td>
									<td class="detalle" nowrap="nowrap"><center>#admin#</center></td>
									<td class="detalle" nowrap="nowrap"><center>#justificacion#</center></td>
									<td class="detallec" nowrap="nowrap"><cfif Especial>si<cfelse>no</cfif></td>
								</tr>
							</cfoutput>
							<tr><td colspan="5">&nbsp;</td></tr>
					</cfoutput>
					</table>
				</td>
			</tr>
		</table>
	</cfsavecontent>	
<cfoutput>
	<cf_htmlReportsHeaders
						irA="#vIrA#"
						FileName="EstadoIncidencias.xls"
						title="Historico">
	#Reporte#	
	<cfset tempfile = GetTempDirectory()>
	<cfset session.tempfile_xls = #tempfile# & "EstadoIncidencias#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
	<cffile action="write" file="#session.tempfile_xls#" output="#Reporte#" nameconflict="overwrite">
</cfoutput>	
<iframe id="FRAME_EXCEL" name="FRAME_EXCEL" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" src="" style="visibility:hidden"></iframe>
	

	
<!--- FIN PINTADO DEL REPORTE --->