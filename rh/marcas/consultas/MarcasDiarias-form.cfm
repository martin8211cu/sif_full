<cfsetting requesttimeout="3600">
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	XmlFile="/rh/generales.xml"
	Key="BTN_Regresar"
	Default="Regresar"
	returnvariable="BTN_Regresar"/>		

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Centro_Funcional"
	Default="Centro Funcional"	
	returnvariable="LB_Centro_Funcional"/>						

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_DiarioMarcasDetallado"
	Default="Reporte Diario de marcas (Detallado)"
	returnvariable="titulo1"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_DiarioMarcasResumido"
	Default="Reporte Diario de marcas (Resumido)"
	returnvariable="titulo2"/>


<cfif not isdefined("form.resumido") >
	<cfset titulo = titulo1>
<cfelse>
	<cfset titulo = titulo2>
</cfif>
				
<style>
	.LetraHora{
		font-size:9px
	}
	.LetraTitulo{
		font-size:10px;
		font-weight:bold;
	}
	.LetraEmpleado{
		font-size:10px;
	}
</style>

<cffunction name="getCentrosFuncionalesDependientes" returntype="query">
	<cfargument name="cfid" required="yes" type="numeric">
	<cfset nivel = 1>
	<cfquery name="rs1" datasource="#session.dsn#">
		select CFid, #nivel# as nivel, 0 as CFidresp
		from CFuncional
		where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.cfid#">
	</cfquery>
	<cfquery name="rs2" datasource="#session.dsn#">
		select CFid, CFidresp
		from CFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfloop condition="1 eq 1">
		<cfquery name="rs3" dbtype="query">
			select rs2.CFid, #nivel# + 1 as nivel, rs2.CFidresp
			from rs1, rs2
			where rs1.nivel = #nivel#
			   and rs2.CFidresp = rs1.cfid
		</cfquery>
		<cfif rs3.RecordCount gt 0>
			<cfset nivel = nivel + 1>
			<cfquery name="rs0" dbtype="query">
				select CFid, nivel, CFidresp from rs1
				union
				select CFid, nivel, CFidresp from rs3
			</cfquery>
			<cfquery name="rs1" dbtype="query">
				select * from rs0
			</cfquery>
		<cfelse>
			<cfbreak>
		</cfif>
	</cfloop>
	<cfreturn rs1>
</cffunction>
<!--- ************************************************************* --->
	<cfif isdefined("url.CFid") and len(trim(url.CFid))>
		<cfset form.CFid = url.CFid>
	</cfif>	
	
	<cfif isdefined("form.CFid") and len(trim(form.CFid)) >
		<cfif isdefined("form.dependencias") >
			<cfset cf = getCentrosFuncionalesDependientes(form.CFid) >
			<cfset cf_lista = valuelist(cf.CFid) >
		<cfelse>
			<cfset cf_lista = form.CFid >
		</cfif>
	</cfif>

	<cfif isdefined("url.DEid") and len(trim(url.DEid))>
		<cfset form.DEid = url.DEid>
	</cfif>	


	<cfif isdefined("url.fdesde") and len(trim(url.fdesde))>
		<cfset form.fdesde = url.fdesde>
	</cfif>
	
	<cfif isdefined("url.fHasta") and len(trim(url.fHasta))>
		<cfset form.fHasta = url.fHasta>
	</cfif>
	
	
	<cfquery name="rsMarcas" datasource="#session.DSN#" >
			select 
			c.CFid,	
			a.DEid,
			d.CFcodigo,
			d.CFdescripcion, 
			{fn concat(e.DEapellido1,{fn concat(' ',{fn concat(e.DEapellido2,{fn concat(' ',e.DEnombre)})})})}	as Empleado,
			<cfif not isdefined("form.resumido") >
				a.CAMfdesde,
			</cfif>
			<cfif not isdefined("form.resumido") >
				a.CAMtotminutos,
				a.CAMociominutos,
				a.CAMtotminlab,
				case a.CAMestado when 'A' then '<cf_translate key="LB_Aplicado">Aplicado</cf_translate>' else '<cf_translate key="LB_Pendiente">Pendiente</cf_translate>' end as Estado 
			<cfelse>
				sum(a.CAMtotminutos) as CAMtotminutos,
				sum(a.CAMociominutos) as CAMociominutos,
				sum(a.CAMtotminlab) as CAMtotminlab
			</cfif>
			from RHCMCalculoAcumMarcas a 
			inner join LineaTiempo b
				on  a.Ecodigo  = b.Ecodigo
				and a.DEid     = b.DEid  
				and 	((({fn YEAR(a.CAMfdesde)} * 100 + {fn MONTH(a.CAMfdesde)} ) * 100 ) + {fn DAYOFMONTH(a.CAMfdesde)})  
				>=     ((({fn YEAR(b.LTdesde)} * 100   + {fn MONTH(b.LTdesde)}   ) * 100 ) + {fn DAYOFMONTH(b.LTdesde)})    
				
				and 	((({fn YEAR(a.CAMfdesde)} * 100 + {fn MONTH(a.CAMfdesde)} ) * 100 ) + {fn DAYOFMONTH(a.CAMfdesde)})  
				<=     ((({fn YEAR(b.LThasta)} * 100   + {fn MONTH(b.LThasta)}   ) * 100 ) + {fn DAYOFMONTH(b.LThasta)})  
				 
			inner join RHPlazas c
				on b.RHPid = c.RHPid
			inner join CFuncional d
				on  c.Ecodigo  = d.Ecodigo
				and c.CFid = d.CFid
			inner join DatosEmpleado e
				on a.Ecodigo = e.Ecodigo
				and a.DEid = e.DEid
			where a.Ecodigo = <cfqueryparam  cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			<cfif isdefined("cf_lista") and len(trim(cf_lista))>
				and c.CFid in (#cf_lista#)
		    </cfif>				
			<cfif isdefined("form.DEid") and len(trim(form.DEid))>
				and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			</cfif>	
			<cfif isdefined("form.fHasta") and len(trim(form.fHasta)) and isdefined("form.fdesde") and len(trim(form.fdesde))>
				and a.CAMfdesde  between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fdesde)#">  
				and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fHasta)#">
			</cfif>
		
			<cfif not isdefined("form.resumido") >
				order by c.CFid,a.DEid,a.CAMfdesde asc 	
			<cfelse>
				group by	
					c.CFid,	
					a.DEid,
					d.CFcodigo,
					d.CFdescripcion, 
					{fn concat(e.DEapellido1,{fn concat(' ',{fn concat(e.DEapellido2,{fn concat(' ',e.DEnombre)})})})}
				order by c.CFid,a.DEid

			</cfif>
	</cfquery>

	<cfif rsMarcas.RecordCount gt 0 and rsMarcas.RecordCount lt 10000 >
			<cfset LvarFileName = "MarcasDiarias_#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
			<cf_htmlReportsHeaders 
				title="#titulo#" 
				filename="#LvarFileName#"
				irA="MarcasDiarias.cfm" 
				>
			<cfif not isdefined("form.btnDownload")>
				<cf_templatecss>
			</cfif>	
	</cfif>	
	
	<table width="100%" cellpadding="2" cellspacing="0" align="center" border="0">
		<cfif rsMarcas.RecordCount GT 10000>
			<tr><td align="center"><strong><cf_translate key="LB_LaCantidadDeRegistrosSobrepasaElLimite">La cantidad de registros sobrepasa el l&iacute;mite, por favor utilice mas filtros o cambie los seleccionados</cf_translate></strong></td></tr>
		<cfelse>
			<cfoutput>	
			<tr> 
				<td colspan="<cfif not isdefined("form.resumido") >6<cfelse>4</cfif>">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 5px;" align="center" class="areaFiltro">
					<tr> 
						<td colspan="<cfif not isdefined("form.resumido") >6<cfelse>4</cfif>" nowrap align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#Session.Enombre#</strong></td>
					</tr>
					<tr><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px"> 
						<td nowrap colspan="<cfif not isdefined("form.resumido") >6<cfelse>4</cfif>" align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:13pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#titulo#</strong></td>		</strong>
					</tr>	
					<tr>
						<td colspan="<cfif not isdefined("form.resumido") >6<cfelse>4</cfif>" class="LetraTitulo" align="center">
							<cf_translate key="LB_Desde">Desde</cf_translate>
							:&nbsp;
							#Form.fdesde# 
							<cf_translate key="LB_Hasta">Hasta</cf_translate>
							:&nbsp;
							#Form.fHasta# 
						</td>
					</tr>	
					</table>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
			</cfoutput>

			<cfif isdefined("rsMarcas") and rsMarcas.RecordCount NEQ 0>
				<cfset diastrab     = 0>
				<cfset HorasTotales = 0>
				<cfset TiempoOcio   = 0>
				<cfset TiempoReal   = 0>

				<cfoutput query="rsMarcas" group="CFid">
					<tr>
						<td colspan="<cfif not isdefined("form.resumido") >6<cfelse>4</cfif>" style=" border-bottom:1px solid black;"><strong>#LB_Centro_Funcional#&nbsp;:&nbsp;#rsMarcas.CFcodigo#&nbsp;#rsMarcas.CFdescripcion#</strong></td></tr>
					</tr>			
					<tr>
						<td nowrap align="left"   valign="bottom" width="30%" class="areaFiltro"><cf_translate key="LB_Nombre">Nombre</cf_translate></td>				
						<cfif not isdefined("form.resumido") >
							<td nowrap align="center" valign="bottom" width="5%" class="areaFiltro"><cf_translate key="LB_Fecha">Fecha</cf_translate></td>	
						</cfif>
						<td nowrap align="right"  valign="bottom" width="10%" class="areaFiltro"><cf_translate key="LB_HorasTotales">Horas Totales</cf_translate></td>
						<td nowrap align="right"  valign="bottom" width="10%" class="areaFiltro"><cf_translate key="LB_TiempoOcio">Tiempo Ocio</cf_translate></td>
						<td nowrap align="right"  valign="bottom" width="10%" class="areaFiltro"><cf_translate key="LB_TiempoReal">Tiempo Real</cf_translate></td>
						<cfif not isdefined("form.resumido") >
							<td width="5%" class="areaFiltro" align="right"><cf_translate key="LB_Estado">Estado</cf_translate></td>
						</cfif>
					</tr>
					<cfif not isdefined("form.resumido") >
						<cfoutput group="DEid">
							<cfoutput>
								<tr>
									<td align="left"   style="border-bottom:1px solid black; border-right:1px solid black; border-left:1px solid black;">#rsMarcas.Empleado#</td>
									<td align="center" class="LetraHora" style="border-bottom:1px solid black; border-right:1px solid black; border-left:1px solid black;">#LSDateFormat(rsMarcas.CAMfdesde,'dd/mm/yyyy')#</td>
									<td align="right"  class="LetraHora" style="padding-right:1px solid black; border-bottom:1px solid black; border-right:1px solid black;">#LSNumberFormat((rsMarcas.CAMtotminutos/ 60), ',.99')#</td>
									<td align="right"  class="LetraHora" style="padding-right:1px solid black; border-bottom:1px solid black; border-right:1px solid black;">#LSNumberFormat((rsMarcas.CAMociominutos/ 60), ',.99')#</td>
									<td align="right"  class="LetraHora" style="padding-right:1px solid black; border-bottom:1px solid black; border-right:1px solid black;">#LSNumberFormat((rsMarcas.CAMtotminlab/ 60), ',.99')#</td>
									<td align="right"  class="LetraHora" style="padding-right:1px solid black; border-bottom:1px solid black; border-right:1px solid black;">#rsMarcas.Estado#</td>
								</tr>
								<cfset diastrab     = diastrab + 1>
								<cfset HorasTotales = HorasTotales + rsMarcas.CAMtotminutos >
								<cfset TiempoOcio   = TiempoOcio   + rsMarcas.CAMociominutos >
								<cfset TiempoReal   = TiempoReal   + rsMarcas.CAMtotminlab  >
							</cfoutput>
							
							<tr>
								<td nowrap align="left"   valign="bottom"  class="areaFiltro"><cf_translate key="LB_Total">Total</cf_translate></td>
								<td nowrap align="left" valign="bottom"  class="areaFiltro"><cf_translate key="LB_DiasTrab">D&iacute;as Trab.</cf_translate>#LSNumberFormat(diastrab, ',.99')#</td>	
								<td nowrap align="right"  valign="bottom"  class="areaFiltro">#LSNumberFormat((HorasTotales/60), ',.99')#</td>
								<td nowrap align="right"  valign="bottom"  class="areaFiltro">#LSNumberFormat((TiempoOcio/60), ',.99')#</td>
								<td nowrap align="right"  valign="bottom"  class="areaFiltro">#LSNumberFormat((TiempoReal/60), ',.99')#</td>
								<td width="5%" class="areaFiltro" align="right">&nbsp;</td>
							</tr>
								<cfset diastrab     = 0>
								<cfset HorasTotales = 0>
								<cfset TiempoOcio   = 0>
								<cfset TiempoReal   = 0>
						</cfoutput>
					<cfelse>
						<cfoutput>
							<tr>
								<td align="left"   style="border-bottom:1px solid black; border-right:1px solid black; border-left:1px solid black;">#rsMarcas.Empleado#</td>
								<td align="right"  class="LetraHora" style="padding-right:1px solid black; border-bottom:1px solid black; border-right:1px solid black;">#LSNumberFormat((rsMarcas.CAMtotminutos/ 60), ',.99')#</td>
								<td align="right"  class="LetraHora" style="padding-right:1px solid black; border-bottom:1px solid black; border-right:1px solid black;">#LSNumberFormat((rsMarcas.CAMociominutos/ 60), ',.99')#</td>
								<td align="right"  class="LetraHora" style="padding-right:1px solid black; border-bottom:1px solid black; border-right:1px solid black;">#LSNumberFormat((rsMarcas.CAMtotminlab/ 60), ',.99')#</td>
							</tr>
							<cfset HorasTotales = HorasTotales + rsMarcas.CAMtotminutos >
							<cfset TiempoOcio   = TiempoOcio   + rsMarcas.CAMociominutos >
							<cfset TiempoReal   = TiempoReal   + rsMarcas.CAMtotminlab  >
						</cfoutput>
						
						<tr>
							<td nowrap align="left"   valign="bottom"  class="areaFiltro"><cf_translate key="LB_Total">Total</cf_translate></td>
							<td nowrap align="right"  valign="bottom"  class="areaFiltro">#LSNumberFormat((HorasTotales/60), ',.99')#</td>
							<td nowrap align="right"  valign="bottom"  class="areaFiltro">#LSNumberFormat((TiempoOcio/60), ',.99')#</td>
							<td nowrap align="right"  valign="bottom"  class="areaFiltro">#LSNumberFormat((TiempoReal/60), ',.99')#</td>
						</tr>
						<cfset HorasTotales = 0>
						<cfset TiempoOcio   = 0>
						<cfset TiempoReal   = 0>
					</cfif>
				</cfoutput>
				<tr>
					<td colspan="<cfif not isdefined("form.resumido") >6<cfelse>4</cfif>" align="center"><strong>------ <cf_translate key="LB_Ultimalinea">&Uacute;ltima l&iacute;nea</cf_translate> ------</strong></td>
				</tr>
			<cfelse>
				<tr>
					<td colspan="<cfif not isdefined("form.resumido") >6<cfelse>4</cfif>" align="center"><strong>------ <cf_translate key="LB_NoSeEncontraronRegistros">No se encontraron registros</cf_translate> ------</strong></td>
				</tr>
			</cfif>
		</cfif>
		<tr><td>&nbsp;</td></tr>
	</table>