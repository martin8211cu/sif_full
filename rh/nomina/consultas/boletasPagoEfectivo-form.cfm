<!---  <script src="/cfmx/jquery/librerias/bootstrap.min.js"></script>--->
<script src="/cfmx/rh/js/letranumeros.js"></script>
<cfsavecontent variable="pageBreak">

	<style>
		@media print
		{
			h1.add_Cut{page-break-inside: auto;}
			h1.add_Cut{page-break-before: always;}
			h1.add_Cut{page-break-after: avoid;}
			h2.ultimo{page-break-after: avoid;}
			h2.add_Cut{page-break-inside: avoid;}
			h2.add_Cut{page-break-before: avoid;}
			mostrar{border: 1px solid #0000FF;}
			table.mostrar td{border:hidden;}
			tr.conMargen{border: 1px solid black;}
			tr.sinMargen{border: 1px solid black;}
		}
		@media screen
		{
			table.oculto{visibility:hidden; display: none;}
			tr.conMargen{border: 1px solid black;}
			tr.conMargen{padding-left: 10px;}
			tr.conMargen{padding-right: 10px;}
		}
	</style>

</cfsavecontent>
<cfhtmlhead  text="#pageBreak#">


<cf_htmlreportsheaders
			title="Boletas de Pago Efectivo"
			filename="BoletasPagoEfectivo#lsdateformat(now(),'yyyymmdd')##LSTimeFormat(now(),'hhmmss')#.xls"
			ira="boletasPagoEfectivo-parametros.cfm"
			method="url">
<!--- <cfsavecontent variable="pageBreak"> --->
<cf_importLibs>

<!--- </cfsavecontent> --->
<cfset prefijo = ''>
<cfif url.tipo eq 'H' >
	<cfset prefijo = 'H'>
	<cfset url.DEidentificacion1 = url.DEidentificacion3>
	<cfset url.DEidentificacion2 = url.DEidentificacion4>
</cfif>

<!--- VERIFICA SI LA EMPRESA ES DE GUATEMALA PARA MOSTRAR OTROS DATOS --->
<cfquery name="rsEmpresa" datasource="#session.dsn#">
	select 1
	from Empresa e
		inner join Direcciones d
		on d.id_direccion = e.id_direccion
		and Ppais = 'GT'
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
</cfquery>

<cfquery name="data_centro" datasource="#session.DSN#" >
	select CFcodigo, CFdescripcion, CFpath
	from CFuncional
	where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFidconta#">
	and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfquery name="data_nomina" datasource="#session.DSN#" >
	select RCDescripcion, RCdesde, RChasta
	from #prefijo#RCalculoNomina
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
	and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!--- Consultas --->
<cfquery name="rsMensaje" datasource="#session.DSN#">
	select Mensaje
	from MensajeBoleta A
	where A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
</cfquery>

<cfsetting enablecfoutputonly="no">
<cfoutput>
<cf_templatecss>

<cfsetting requesttimeout="8600">

<cfif not isdefined('url.corteBoleta') and not isdefined('url.Encabezado')>
<table width="98%" cellpadding="3" cellspacing="0" align="center">
	<tr><td align="center" ><strong>#session.Enombre#</strong></td></tr>
	<tr><td align="center" ><strong><cf_translate key="LB_Resumen_de_Boletas_de_Pago">Resumen de Boletas de Pago</cf_translate></strong></td></tr>
	<tr><td align="center" ><strong><cf_translate key="LB_Nomina">N&oacute;mina</cf_translate>:&nbsp;</strong>#data_nomina.RCDescripcion#</td></tr>
	<tr><td align="center" ><strong><cf_translate key="LB_Del">Del</cf_translate>&nbsp;</strong>#LSDateFormat(data_nomina.RCdesde, 'dd/mm/yyyy')# <strong><cf_translate key="LB_al">al</cf_translate></strong> #LSDateFormat(data_nomina.RChasta, 'dd/mm/yyyy')#</td></tr>
	<tr><td align="center" ><strong><cf_translate key="LB_CentroFuncional" xmlfile="/sif/rh/generales.xml">Centro Funcional</cf_translate>:&nbsp;</strong>#trim(data_centro.CFcodigo)# - #data_centro.CFdescripcion#</td></tr>
</table>
</cfif><!---
<cf_dump var="#url#"> 
<style>    DIV.pageBreak { page-break-before: always; }</style>
--->
</cfoutput>


<cfsavecontent variable="myQuery">
	<cfoutput>
	select	 se.DEid,
			 de.DEidentificacion,
			 de.DEtarjeta,
			 de.DEnombre,
			 de.DEapellido1,
			 de.DEapellido2,
			 lt.RHPid,
			 p.CFidconta,
			 cf.CFcodigo,
			 cf.CFdescripcion,
			 se.SEsalariobruto, <!---, round(coalesce((select coalesce(sum(b.PEmontores) ,0.00) from PagosEmpleado b where se.DEid = b.DEid and rc.RCNid = b.RCNid), 0.00),2) as Componentes--->
			 se.SErenta,
			 se.RCNid
	from #prefijo#RCalculoNomina rc

		inner join #prefijo#SalarioEmpleado se
			on rc.RCNid = se.RCNid

		inner join DatosEmpleado de
			on de.DEid = se.DEid
		inner join (select ic.CIid, ci.CIcodigo, ci.CIdescripcion,
								<cfif isdefined("url.resumido")>sum(case  when ic.ICmontoant=0 and ci.CItipo in (0,1) then
																				ic.ICvalor
																		  when ic.ICmontoant <> 0 and ci.CItipo in (0,1) then
																		  		0
																			else ic.ICvalor
																		  end) as</cfif> ICvalor,
								<cfif isdefined("url.resumido")>sum(ic.ICmontores) as</cfif> ICmontores,ic.DEid
							from #prefijo#IncidenciasCalculo ic
							inner join CIncidentes ci
								on ci.CIid = ic.CIid
								and ci.CItimbrar =1
							where ic.RCNid = #url.RCNid#
							<cfif isdefined("url.resumido")>
							group by ic.CIid, ci.CIcodigo, ci.CIdescripcion,ic.DEid
							</cfif>)inci
			on inci.DEid =de.DEid
			and inci.ICvalor >0
		<cfif isdefined('url.DEidentificacion1') and LEN(TRIM(url.DEidentificacion1)) and not isdefined('url.DEidentificacion1')>
			and <cfif isdefined("session.tagempleados.identificacion") and not session.tagempleados.identificacion>de.DEtarjeta<cfelse>de.DEidentificacion</cfif> >= '#url.DEidentificacion1#'
		<cfelseif isdefined('url.DEidentificacion2') and LEN(TRIM(url.DEidentificacion2)) and not isdefined('url.DEidentificacion1')>
			and <cfif isdefined("session.tagempleados.identificacion") and not session.tagempleados.identificacion>de.DEtarjeta<cfelse>de.DEidentificacion</cfif> <= '#url.DEidentificacion2#'
		<cfelseif isdefined('url.DEidentificacion1') and LEN(TRIM(url.DEidentificacion1)) and
				isdefined('url.DEidentificacion2') and LEN(TRIM(url.DEidentificacion2))>
			and <cfif isdefined("session.tagempleados.identificacion") and not session.tagempleados.identificacion>de.DEtarjeta<cfelse>de.DEidentificacion</cfif> between '#url.DEidentificacion1#' and '#url.DEidentificacion2#'
		</cfif>

		inner join LineaTiempo lt
			on se.DEid = lt.DEid
	   	   and lt.Ecodigo = rc.Ecodigo
		   and lt.LThasta = (	select max(lt2.LThasta)
		   						from LineaTiempo lt2
								where lt.DEid = lt2.DEid
								  and lt2.LTdesde < = rc.RChasta
								  and lt2.LThasta > = rc.RCdesde )


		inner join RHPlazas p
			on lt.RHPid = p.RHPid
		   and lt.Ecodigo = p.Ecodigo

			<cfif not isdefined("url.dependencias") and url.DEid2 LTE 0 and url.DEid2 LTE 0 and isdefined("url.CFidconta")>
			   and p.CFidconta = #url.CFidconta#
		   </cfif>
		inner join CFuncional cf
			on cf.CFid=coalesce(p.CFidconta, p.CFid)			<!--- duda  es CFid o *CFidconta*, si es CFid cambiar la parte de centros dependientes --->
			<cfif isdefined("url.dependencias") and url.DEid2 LTE 0 and url.DEid2 LTE 0>
				and cf.CFpath like '#trim(data_centro.CFpath)#%'
			</cfif>


	where rc.Ecodigo = #session.Ecodigo#
	  and rc.RCNid = #url.RCNid#

	order by <cfif isdefined('url.agrupar')>cf.CFcodigo,</cfif> <cfif isdefined("session.tagempleados.identificacion") and not session.tagempleados.identificacion>de.DEtarjeta<cfelse>de.DEidentificacion</cfif>
	</cfoutput>
</cfsavecontent>





<cftry>
	<cfflush interval="500">
	<cf_jdbcquery_open name="data" datasource="#session.DSN#">
	<cfoutput>#myquery#</cfoutput>
	</cf_jdbcquery_open>

<table width="98%" cellpadding="3" cellspacing="1" align="center">
	<cfset vTSalarioDevengado = 0 >
	<cfset vTDeducciones = 0 >

	<cfset contador = 1 >
	<cfset cortes = 0 >
	<cfoutput query="data" group="CFcodigo">
		<cfif isdefined('url.agrupar')>
		<cfif not isdefined('url.corteBoleta') and not isdefined('url.Encabezado')>
		<tr bgcolor="##CCCCCC">
			<td align="left" colspan="5"><strong><cf_translate key="LB_CentroFuncional" xmlfile="/sif/rh/generales.xml">Centro Funcional</cf_translate>: #trim(CFcodigo)# - #CFdescripcion#</strong></td>
		</tr>
		</cfif>
		</cfif>
		<cfset vSTSalarioDevengado = 0 >
		<cfset vSTDeducciones = 0 >

		<cfoutput group="DEid">
			<cfif isdefined('url.Encabezado')>
				<tr>
				<td colspan="5">
				<table width="98%" cellpadding="3" cellspacing="0" align="center">
					<tr>
						<td width="100%" align="center"  colspan="2">
							<strong>#session.Enombre#</strong><br>
							<strong><cf_translate key="LB_Resumen_de_Boletas_de_Pago">Resumen de Boletas de Pago</cf_translate></strong><br>
							<strong><cf_translate key="LB_Nomina">N&oacute;mina</cf_translate>:&nbsp;</strong>#data_nomina.RCDescripcion#<br>
							<strong><cf_translate key="LB_Del">Del</cf_translate>&nbsp;</strong>#LSDateFormat(data_nomina.RCdesde, 'dd/mm/yyyy')# <strong><cf_translate key="LB_al">al</cf_translate></strong> #LSDateFormat(data_nomina.RChasta, 'dd/mm/yyyy')#<br>
							<strong><cf_translate key="LB_CentroFuncional" xmlfile="/sif/rh/generales.xml">Centro Funcional</cf_translate>:&nbsp;</strong>#trim(CFcodigo)# - #CFdescripcion#
						</td>
					</tr>
					<tr><td align="center" colspan="3"></td></tr>
				</table>
				</td></tr>
				<tr bgcolor="##CCCCCC">
					<td align="left" colspan="5"><strong><cf_translate key="LB_CentroFuncional" xmlfile="/sif/rh/generales.xml">Centro Funcional</cf_translate>: #trim(CFcodigo)# - #CFdescripcion#</strong></td>
				</tr>
			</cfif>
			<cfset vSalarioDevengado = 0 >
			<cfset vDeducciones = 0 >
			<tr >
				<td width="1%">&nbsp;</td>
				<td bgcolor="##e5e5e5" ><strong><!---#contador#---><cf_translate key="LB_Id_de_Tarjeta">Id de Tarjeta</cf_translate></strong></td>
				<td bgcolor="##e5e5e5" ><strong><cf_translate key="LB_Identificacion" xmlfile="/sif/rh/generales.xml">Identificaci&oacute;n</cf_translate></strong></td>
				<td bgcolor="##e5e5e5"  colspan="2"><strong><cf_translate key="LB_Nombre" xmlfile="/sif/rh/generales.xml">Nombre</cf_translate></strong></td>
			</tr>
			<tr >
				<td width="1%">&nbsp;</td>
				<td bg class="listaNon"><!---#DEid#---> #DEtarjeta#</td>
				<td class="listaNon">#DEidentificacion#</td>
				<td class="listaNon" colspan="2">#DEapellido1# #DEapellido2# #DEnombre#</td>
			</tr>

			<tr class="corte">
				<td width="1%">&nbsp;</td>
				<td colspan="4" width="100%" align="center" style="border:1px solid gray;" valign="top">
					<table width="100%" cellpadding="2" cellspacing="0">
						<tr>
							<td class="tituloListas" align="left"><cf_translate key="LB_Concepto">Concepto</cf_translate></td>
							<td class="tituloListas" align="right"><cf_translate key="LB_Cantidad">Cantidad</cf_translate></td>
							<td class="tituloListas" align="right"><cf_translate key="LB_Monto">Monto</cf_translate></td>
						</tr>
						<cfquery name="data_incidencias" datasource="#session.DSN#">
							select ic.CIid, ci.CIcodigo, ci.CIdescripcion,
<!--- LZ 2010-11-25 Cuando se suma las Cantidades para la Boleta de Pago, es importante evitar sumar la informacion generada por Retroactivos, cuando se trata de incidencias de Tipo hora o tipo Dia,
pues sino incrementara la cantidad con sumas que no aplican --->
								<cfif isdefined("url.resumido")>sum(case  when ic.ICmontoant=0 and ci.CItipo in (0,1) then   <!--- Si no es retroactivo ni es tipo hora y dia sume valor--->
																				ic.ICvalor
																		  when ic.ICmontoant <> 0 and ci.CItipo in (0,1) then  <!--- Si es retroactivo ni es tipo hora y dia no sume--->
																		  		0
																			else ic.ICvalor  <!--- Los demas tipos de Incidencia sumelos --->
																		  end) as</cfif> ICvalor,
								<cfif isdefined("url.resumido")>sum(ic.ICmontores) as</cfif> ICmontores
							from #prefijo#IncidenciasCalculo ic

							inner join CIncidentes ci
								on ci.CIid = ic.CIid
								and ci.CItimbrar =1
							where ic.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">   <!--- OJO filtrar por CF (averiguar) --->
							and ic.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
							<cfif isdefined("url.resumido")>
							group by ic.CIid, ci.CIcodigo, ci.CIdescripcion
							</cfif>
							order by ci.CIcodigo, ci.CIdescripcion
						</cfquery>

						<!--- <cfdump var="#data_incidencias#"> --->
						<cfloop query="data_incidencias">
							<tr>
								<td align="left" >#trim(data_incidencias.CIcodigo)# - #trim(data_incidencias.CIdescripcion)#</td>
								<td align="right" >#lsnumberformat(data_incidencias.ICvalor, ',9.00')#</td>
								<td align="right" >#lsnumberformat(data_incidencias.ICmontores, ',9.00')#</td>
							</tr>
							<cfset vSalarioDevengado = vSalarioDevengado + data_incidencias.ICmontores >
						</cfloop>
						<cfset vSTSalarioDevengado = vSTSalarioDevengado + vSalarioDevengado >
						<cfset vTSalarioDevengado = vTSalarioDevengado + vSalarioDevengado >
					</table>
				</td>
				<!--- JARR se comento --->
				<!--- <td colspan="2" width="50%" align="center" style="border:1px solid gray;" valign="top">
					<table width="100%" cellpadding="2" cellspacing="0">
						<tr>
							<td class="tituloListas" align="left"><cf_translate key="LB_Concepto">Concepto</cf_translate></td>
							<td class="tituloListas" align="right"><cf_translate key="LB_Cantidad">Cantidad</cf_translate></td>
							<td class="tituloListas" align="right"><cf_translate key="LB_Monto">Monto</cf_translate></td>
						</tr>

						<cfquery name="data_cargas" datasource="#session.DSN#">
							select cc.DClinea, c.DCcodigo, c.DCdescripcion, cc.CCvaloremp
							from #prefijo#CargasCalculo cc

							inner join DCargas c
							on c.DClinea = cc.DClinea

							where cc.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
							  and cc.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
							  and cc.CCvaloremp != 0
						</cfquery>

						<cfloop query="data_cargas">
							<tr>
								<td align="left" >#trim(data_cargas.DCcodigo)# - #trim(data_cargas.DCdescripcion)#</td>
								<td align="right" ></td>
								<td align="right" >#lsnumberformat(data_cargas.CCvaloremp, ',9.00')#</td>
							</tr>
							<cfset vDeducciones = vDeducciones + data_cargas.CCvaloremp >
							<cfset vSTDeducciones = vSTDeducciones + data_cargas.CCvaloremp >
							<cfset vTDeducciones = vTDeducciones + data_cargas.CCvaloremp >
						</cfloop>
						<cfquery name="data_deducciones" datasource="#session.DSN#">
							select dc.Did, dc.DCvalor, de.Ddescripcion,  de.Dreferencia
							from #prefijo#DeduccionesCalculo dc

							inner join DeduccionesEmpleado de
							on de.Did=dc.Did

							where dc.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RCNid#">
							  and dc.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
						</cfquery>
						<cfloop query="data_deducciones">
							<tr>
								<td align="left" >#trim(data_deducciones.Ddescripcion)# - #trim(data_deducciones.Dreferencia)#</td>
								<td align="right" ></td>
								<td align="right" >#lsnumberformat(data_deducciones.DCvalor, ',9.00')#</td>
							</tr>
							<cfset vDeducciones = vDeducciones + data_deducciones.DCvalor >
							<cfset vSTDeducciones = vSTDeducciones + data_deducciones.DCvalor >
							<cfset vTDeducciones = vTDeducciones + data_deducciones.DCvalor >
						</cfloop>

						<cfif SErenta neq 0>
							<cfset vDeducciones = vDeducciones + SErenta >
							<cfset vSTDeducciones = vSTDeducciones + SErenta >
							<cfset vTDeducciones = vTDeducciones + SErenta  >
							<tr>
								<td align="left" ><cf_translate key="LB_Renta">Renta</cf_translate></td>
								<td align="right" ></td>
								<td align="right" >#lsnumberformat(SErenta, ',9.00')#</td>
							</tr>
						</cfif>
					</table>
				</td> --->
			</tr>

			<!--- <tr>
				<td width="1%">&nbsp;</td>
				<td colspan="2" align="right"><strong><cf_translate key="LB_Salario_devengado">Salario devengado</cf_translate>:</strong> #lsnumberformat(vSalarioDevengado, ',9.00')#</td>
				<td colspan="2" align="right"><strong><cf_translate key="LB_Total_Deducciones">Total Deducciones</cf_translate>:</strong> #lsnumberformat(vDeducciones, ',9.00')#</td>
			</tr>

			<tr>
				<td width="1%">&nbsp;</td>
				<td colspan="2" align="right"></td>
				<td colspan="2" align="right"><strong><cf_translate key="LB_Neto">Neto</cf_translate>:</strong> #lsnumberformat(vSalarioDevengado-vDeducciones, ',9.00')#</td>
			</tr> --->

			<cfif rsMensaje.recordCount gt 0 and len(trim(rsMensaje.mensaje))>
			<tr>
				<td colspan="5" align="center">#rsMensaje.mensaje#</td>
			</tr>
			</cfif>
			<tr>
			<td colspan="3" align="left"><strong><cf_translate key="Subtotal_Neto">RECIBI DE LA EMPRESA: #session.Enombre#</cf_translate></strong>
			</td>
			</tr>
			<tr>
				<td colspan="2" align="left"><strong>LA CANTIDAD  DE  $#lsnumberformat(vSTSalarioDevengado-vSTDeducciones, ',9.00')#</strong></td>
				<td id="txtCantidad#DEidentificacion#" align="left">
				<script>
				document.getElementById('txtCantidad#DEidentificacion#').innerHTML='<p> '+covertirNumLetras("#vSTSalarioDevengado-vSTDeducciones#");+' </p>';
				</script>
				</td>
				<cfset vSTSalarioDevengado=0>
			</tr>
			<tr>
				<td colspan="3" align="left"></td>
				<td  align="center">
				________________________________________
				</td>
			</tr>
			<tr>
				<td colspan="3" align="left"></td>
				<td  align="center">
				<strong>#DEapellido1# #DEapellido2# #DEnombre#</strong>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			<cfset contador = contador + 1 >
			<cfset cortes = cortes + 1 >
			<cfif  rsEmpresa.RecordCount NEQ 0 and isdefined('url.corteBoleta')>
				<tr><td width="1%"><!--- <div class="pageBreak"/> ---></td></tr>
			<cfelse>
				<cfif cortes eq 2>
					<cfset cortes = 0 >
					<tr><td width="1%"><h1 class="add_Cut"></h1></td></tr>
				</cfif>
			</cfif>
		</cfoutput>
			<!--- <h2 class="ultimo"></h2> --->
 		<cfif not isdefined('url.corteBoleta')>
		<!--- <tr>
			<td width="1%">&nbsp;</td>
			<td colspan="2" align="right"><strong><cf_translate key="LB_Subtotal_Salarios_devengados">Subtotal(Salarios devengados)</cf_translate>:</strong> #lsnumberformat(vSTSalarioDevengado, ',9.00')#</td>
			<td colspan="2" align="right"><strong><cf_translate key="LB_Subtotal_Deducciones">Subtotal(Deducciones)</cf_translate>:</strong> #lsnumberformat(vSTDeducciones, ',9.00')#</td>
		</tr> --->

		</cfif>
		<tr><td>&nbsp;</td></tr>
	</cfoutput>

<!--- nuevo --->
<cfcatch type="any">
	<cf_jdbcquery_close>
	<cfthrow object="#cfcatch#">
</cfcatch>
</cftry>
	<cf_jdbcquery_close>
<!--- nuevo --->
