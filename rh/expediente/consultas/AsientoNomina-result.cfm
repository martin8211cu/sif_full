<!---<cfdump var="#form#">
<cfdump var="#form.formato#">
<cfdump var="#form.filtro#">--->

<cfif form.formato eq 1>
	<cfquery name="rsDetalles" datasource="#session.dsn#">
		select case a.tiporeg 
				when 10 then 'Salarios '
				when 11 then ' Auxiliar Salarios '				
				when 20 then 'Incidencias '
				when 21 then ' Auxiliar Incidencias '				
				when 30 then 'Cargas Patronales (Gasto) '
				when 40 then 'Cargas Patronales (CxC) '
				when 31 then 'Auxiliar Cargas Patronales '				
				when 50 then 'Cargas Empleado '
				when 51 then 'Cargas Empleado '				
				when 52 then 'Auxiliar Cargas Empleado '								
				when 55 then 'Cargas Patronales '
				when 56 then 'Cargas Patronales '
				when 57 then 'Auxiliar Cargas Patronales '
				when 60 then 'Deducciones '
				when 70 then 'Renta'
				when 80 then 'Salarios Liquidos '
				when 85 then 'Salarios Liquidos '
				else ''
			end as descripcion,
			a.tiporeg  as tiporeg, sum(montores) as monto, 
			a.Periodo,
			a.Mes, tipo
		from RCuentasTipo a
			inner join CalendarioPagos b
				on b.CPid  = a.RCNid
		Where a.Ecodigo = #session.Ecodigo#
			<cfif isdefined("form.CPid") and len(trim(form.CPid))>
				and b.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
			</cfif>
			<cfif isdefined("form.Tcodigo") and len(trim(form.Tcodigo))>
				and b.Tcodigo = '#form.Tcodigo#'
			</cfif>
			<cfif isdefined("form.CPcodigo") and len(trim(form.CPcodigo))>
				and b.CPcodigo = '#form.CPcodigo#'
			</cfif>
			<!---Por Rango de Fechas, si no por Periodo-Mes--->
			<cfif isdefined("form.porRango") and form.porRango EQ 1>
				<cfif isdefined("form.Fdesde") and len(trim(form.Fdesde))>
					and b.CPdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(form.Fdesde,'yyyy/mm/dd')#">
				</cfif>
				<cfif isdefined("form.Fhasta") and len(trim(form.Fhasta))>
					and b.CPhasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(form.Fhasta,'yyyy/mm/dd')#">
				</cfif>
			<cfelse>
				and b.CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.mes#">
				and b.CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.periodo#">
			</cfif>
			group by a.tiporeg,a.Periodo,a.Mes, tipo
			order by a.tiporeg,a.tipo, a.Periodo, a.Mes
	</cfquery>
	<cfset colspan = 11>
<cfelseif form.formato eq 2 and form.filtro eq 1>
	<cfquery name="rsDetalles" datasource="#session.dsn#">
		select  case a.tiporeg 
					when 10 then 'Salarios '
					when 11 then ' Auxiliar Salarios '				
					when 20 then 'Incidencias '
					when 21 then ' Auxiliar Incidencias '				
					when 30 then 'Cargas Patronales (Gasto) '
					when 40 then 'Cargas Patronales (CxC) '
					when 31 then 'Auxiliar Cargas Patronales '				
					when 50 then 'Cargas Empleado '
					when 51 then 'Cargas Empleado '				
					when 52 then 'Auxiliar Cargas Empleado '								
					when 55 then 'Cargas Patronales '
					when 56 then 'Cargas Patronales '
					when 57 then 'Auxiliar Cargas Patronales '
					when 60 then 'Deducciones '
					when 70 then 'Renta'
					when 80 then 'Salarios Liquidos '
					when 85 then 'Salarios Liquidos '
				else ''
			    end as descripcion,
			    a.Cformato, 
			    b.CFcodigo,	 
			    b.CFdescripcion,
				a.tiporeg  as tiporeg,
			    sum(montores) as monto, 
				a.Periodo,
				a.Mes, 
				a.tipo
		from RCuentasTipo a
			inner join CFuncional b
				on b.CFid = a.CFid
			inner join CalendarioPagos c
				on c.CPid = a.RCNid 
		Where a.Ecodigo = #session.Ecodigo#
			<cfif isdefined("form.CPid") and len(trim(form.CPid))>
				and c.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
			</cfif>
			<cfif isdefined("form.Tcodigo") and len(trim(form.Tcodigo))>
				and c.Tcodigo = '#form.Tcodigo#'
			</cfif>
			<cfif isdefined("form.CPcodigo") and len(trim(form.CPcodigo))>
				and c.CPcodigo = '#form.CPcodigo#'
			</cfif>
			<!---Por Rango de Fechas, si no por Periodo-Mes--->
			<cfif isdefined("form.porRango") and form.porRango EQ 1>
				<cfif isdefined("form.Fdesde") and len(trim(form.Fdesde))>
					and c.CPdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(form.Fdesde,'yyyy/mm/dd')#">
				</cfif>
				<cfif isdefined("form.Fhasta") and len(trim(form.Fhasta))>
					and c.CPhasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(form.Fhasta,'yyyy/mm/dd')#">
				</cfif>
			<cfelse>
				and c.CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.mes#">
				and c.CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.periodo#">
			</cfif>
			
			and a.tiporeg in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.tregistro#" list="yes">)
		group by a.tiporeg, a.Cformato,  b.CFcodigo, b.CFdescripcion, a.Periodo,a.Mes, a.tipo
		order by a.tiporeg, b.CFcodigo, b.CFdescripcion, a.tipo, a.Periodo, a.Mes	
	</cfquery>
	<cfset colspan = 17>
<cfelse>
	<cfquery name="rsDetalles" datasource="#session.dsn#">
		Select  case a.tiporeg 
				when 10 then 'Salarios '
				when 11 then ' Auxiliar Salarios '				
				when 20 then 'Incidencias '
				when 21 then ' Auxiliar Incidencias '				
				when 30 then 'Cargas Patronales (Gasto) '
				when 40 then 'Cargas Patronales (CxC) '
				when 31 then 'Auxiliar Cargas Patronales '				
				when 50 then 'Cargas Empleado '
				when 51 then 'Cargas Empleado '				
				when 52 then 'Auxiliar Cargas Empleado '								
				when 55 then 'Cargas Patronales '
				when 56 then 'Cargas Patronales '
				when 57 then 'Auxiliar Cargas Patronales '
				when 60 then 'Deducciones '
				when 70 then 'Renta'
				when 80 then 'Salarios Liquidos '
				when 85 then 'Salarios Liquidos '
				else ''
			   	end as descripcion,
				a.Cformato, 
				b.CFcodigo,	 
				b.CFdescripcion, 	
				c.DEidentificacion, 
				c.DEnombre, 	
				c.DEapellido1,  
				c.DEapellido2, 
				a.tiporeg as tiporeg,
				sum(montores) as monto,
				a.Periodo,
				a.Mes, a.tipo
		from RCuentasTipo a 
			inner join CFuncional b
				on b.CFid = a.CFid
			inner join DatosEmpleado c
				on c.DEid = a.DEid
			inner join CalendarioPagos d
				on d.CPid = a.RCNid
		Where a.Ecodigo = #session.Ecodigo#
			<cfif isdefined("form.CPid") and len(trim(form.CPid))>
				and d.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
			</cfif>
			<cfif isdefined("form.Tcodigo") and len(trim(form.Tcodigo))>
				and d.Tcodigo = '#form.Tcodigo#'
			</cfif>
			<cfif isdefined("form.CPcodigo") and len(trim(form.CPcodigo))>
				and d.CPcodigo = '#form.CPcodigo#'
			</cfif>
			<!---Por Rango de Fechas, si no por Periodo-Mes--->
			<cfif isdefined("form.porRango") and form.porRango EQ 1>
				<cfif isdefined("form.Fdesde") and len(trim(form.Fdesde))>
					and d.CPdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(form.Fdesde,'yyyy/mm/dd')#">
				</cfif>
				<cfif isdefined("form.Fhasta") and len(trim(form.Fhasta))>
					and d.CPhasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(form.Fhasta,'yyyy/mm/dd')#">
				</cfif>
			<cfelse>
				and d.CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.mes#">
				and d.CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.periodo#">
			</cfif>
			
			and a.tiporeg in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.tregistro#" list="yes">)
		group by a.tiporeg, a.Cformato, b.CFcodigo, b.CFdescripcion, c.DEidentificacion, c.DEapellido1, c.DEapellido2, c.DEnombre,a.Periodo,a.Mes, a.tipo
		order by a.tiporeg, c.DEnombre, c.DEapellido1, c.DEapellido2, b.CFcodigo, b.CFdescripcion, a.Cformato, a.tipo, a.Periodo, a.Mes
	</cfquery>
	<cfset colspan = 25>
</cfif>

<!---<cf_dump var="#rsDetalles#">--->

<cf_templatecss>
<style type="text/css">
	.stitulo{
		font-weight:bold;
		font-size:14px;
		text-transform:uppercase;
	}
	.subrayados{
		border-bottom:ridge;
	}
</style>
<cfoutput>
<cf_htmlReportsHeaders 
	title="Asiento de Nomina" 
	filename="Asiento_Nomina_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.xls"
	irA="/cfmx/rh/expediente/consultas/AsientoNomina.cfm" 
	>
	
<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				
				<cfif form.formato eq 1>
					<cfif isdefined("form.porRango") and form.porRango EQ 1>
						<cfset filtro = "Fecha inicial: #form.Fdesde# &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Fecha final: #form.Fhasta# <br>">
					<cfelse>
					 	<cfset filtro = "Período: #form.periodo#  Mes: #form.mes# <br>">
					</cfif>
					
				<cfelse>
					
					<cfif isdefined("form.porRango") and form.porRango EQ 1>
						<cfset filtro = "Fecha inicial: #form.Fdesde# &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Fecha final: #form.Fhasta# <br>">
					<cfelse>
						<cfset filtro = "Período: #form.periodo#  Mes: #form.mes# <br>">
					</cfif>
					
					<cfif form.filtro eq 1>
						<cfset filtro = filtro & "Por Centro Funcional">
					<cfelse>
						<cfset filtro = filtro & "Por Empleado">
					</cfif>
					<cfset filtro = filtro & "<br>Tipo de Registro:">
					<cfset entro = false>
					<cfif ListFind(form.tregistro,10)>
						<cfif entro>
							<cfset filtro = filtro & ", ">
						</cfif>
						<cfset entro = true>
						<cfset filtro = filtro & "Salarios ">
					</cfif>
					<cfif ListFind(form.tregistro,20)>
						<cfif entro>
							<cfset filtro = filtro & ", ">
						</cfif>
						<cfset entro = true>
						<cfset filtro = filtro & "Incidencias ">
					</cfif>
					<cfif ListFind(form.tregistro,30)>
						<cfif entro>
							<cfset filtro = filtro & ", ">
						</cfif>
						<cfset entro = true>
						<cfset filtro = filtro & "Cargas Patronales ">
					</cfif>
					<cfif ListFind(form.tregistro,50)>
						<cfif entro>
							<cfset filtro = filtro & ", ">
						</cfif>
						<cfset entro = true>
						<cfset filtro = filtro & "Cargas Empleado ">
					</cfif>
					<cfif ListFind(form.tregistro,55)>
						<cfif entro>
							<cfset filtro = filtro & ", ">
						</cfif>
						<cfset entro = true>
						<cfset filtro = filtro & "Cargas Patronales ">
					</cfif>
					<cfif ListFind(form.tregistro,60)>
						<cfif entro>
							<cfset filtro = filtro & ", ">
						</cfif>
						<cfset entro = true>
						<cfset filtro = filtro & "Deducciones ">
					</cfif>
					<cfif ListFind(form.tregistro,70)>
						<cfif entro>
							<cfset filtro = filtro & ", ">
						</cfif>
						<cfset entro = true>
						<cfset filtro = filtro & "Renta">
					</cfif>
					<cfif ListFind(form.tregistro,80) or ListFind(form.tregistro,85)>
						<cfif entro>
							<cfset filtro = filtro & ", ">
						</cfif>
						<cfset entro = true>
						<cfset filtro = filtro & "Salarios Liquidos ">
					</cfif>
				</cfif>
				<cf_EncReporte
					Titulo="Asiento de Nómina"
					Color="##E3EDEF"
					filtro1="#filtro#"
				>
			</td>
		</tr>
				
				
		<tr><td><table border="0" width="100%" cellpadding="0" cellspacing="0">
			<tr class="stitulo">
						<td align="center" class="subrayados" nowrap>Tipo Reg.</td>
						<td class="subrayados">&nbsp;&nbsp;</td>
						<td class="subrayados" nowrap>Descr. Reg.</td>
						<td class="subrayados">&nbsp;&nbsp;</td>
						<td align="center" class="subrayados" nowrap>Tipo</td>
						<td class="subrayados">&nbsp;&nbsp;</td>				
					<cfif form.formato eq 2>
						<td class="subrayados" nowrap>Cod. CF</td>
						<td class="subrayados">&nbsp;&nbsp;</td>
						<td class="subrayados" nowrap>Desc. CF</td>
						<td class="subrayados">&nbsp;&nbsp;</td>
						<td align="right" class="subrayados" nowrap>Cuenta Contable</td>
						<td class="subrayados">&nbsp;&nbsp;</td>
					</cfif>
					<cfif form.formato eq 2 and form.filtro eq 2>
						<td align="right" class="subrayados" nowrap>Ident. Funcionario</td>
						<td class="subrayados">&nbsp;&nbsp;</td>
						<td class="subrayados" nowrap>1° Apellido</td>
						<td class="subrayados">&nbsp;&nbsp;</td>
						<td class="subrayados" nowrap>2° Apellido</td>
						<td class="subrayados">&nbsp;&nbsp;</td>
						<td class="subrayados" nowrap>Nombre</td>
						<td class="subrayados">&nbsp;&nbsp;</td>
					</cfif>
						<td align="right" class="subrayados" nowrap>Monto</td>
						<td class="subrayados">&nbsp;&nbsp;</td>
						<td align="center" class="subrayados" nowrap>Periodo</td>
						<td class="subrayados">&nbsp;&nbsp;</td>
						<td align="center" class="subrayados" nowrap>Mes</td>
				</tr>
				<cfset Lvarcontador = 0>
				<cfloop query="rsDetalles">	
					<tr class="<cfif Lvarcontador mod 2>listaPar<cfelse>listaNon</cfif>">
						<td align="center" nowrap>#rsDetalles.tiporeg#</td>
						<td>&nbsp;&nbsp;</td>
						<td nowrap>#rsDetalles.descripcion#</td>
						<td>&nbsp;&nbsp;</td>
						<td align="center" nowrap>#rsDetalles.tipo#</td>
						<td>&nbsp;&nbsp;</td>
					<cfif form.formato eq 2>
						<td nowrap>#rsDetalles.CFcodigo#</td>
						<td>&nbsp;&nbsp;</td>
						<td nowrap>#rsDetalles.CFdescripcion#</td>
						<td>&nbsp;&nbsp;</td>
						<td align="right" nowrap>#rsDetalles.Cformato#</td>
						<td>&nbsp;&nbsp;</td>
					</cfif>
					<cfif form.formato eq 2 and form.filtro eq 2>
						<td align="right" nowrap>#rsDetalles.DEidentificacion#</td>
						<td>&nbsp;&nbsp;</td>
						<td nowrap>#rsDetalles.DEapellido1#</td>
						<td>&nbsp;&nbsp;</td>
						<td nowrap>#rsDetalles.DEapellido2#</td>
						<td>&nbsp;&nbsp;</td>
						<td nowrap>#rsDetalles.DEnombre#</td>
						<td>&nbsp;&nbsp;</td>
					</cfif>
						<td align="right" nowrap>#fnFormatMoney(rsDetalles.monto)#</td>
						<td>&nbsp;&nbsp;</td>
						<td align="center" nowrap>#rsDetalles.Periodo#</td>
						<td>&nbsp;&nbsp;</td>
						<td align="center" nowrap>#rsDetalles.Mes#</td>
					</tr>
					<cfset Lvarcontador = Lvarcontador + 1>
				</cfloop>
				<cfif rsDetalles.recordcount eq 0>
					<tr><td colspan="#colspan#">&nbsp;</td></tr>
					<tr><td colspan="#colspan#" align="center" class="stitulo">No existen registros con los filtros suministrados</td></tr>
				</cfif>
				
		</table></td></tr>
	</table>
</cfoutput>

<cffunction name="fnFormatMoney" access="private" returntype="string">
	<cfargument name="Monto" type="numeric">
	<cfargument name="Decimales" type="numeric" default="2">

	<cfreturn LsCurrencyFormat(fnRedondear(Arguments.Monto,Arguments.Decimales),'none')>
</cffunction>

<cffunction name="fnRedondear" access="private" returntype="string">
	<cfargument name="Monto" type="numeric">
	<cfargument name="Decimales" type="numeric" default="2">
	
	<cfreturn NumberFormat(Arguments.Monto,".#RepeatString('9', Arguments.Decimales)#")>
</cffunction>