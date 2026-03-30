<!--- 
	Reporte Resumido de Familiares por Rangos de Edades.
	Este reporte se desarrollo de la siguiente manera:
	1-Se crea una tabla temporal para guardar los resultados.
	2-Se insertan los familiares entre 0 y 1 años de edad
	3-Se insertan los familiares entre 1 y 2 años de edad
	4-Se insertan los familiares entre 2 y N años de edad en 
		M Intervalos, N = form.EdadHasta y M = form.EdadRangos.
--->

<cf_dbtemp name="ENCRHIRES" returnvariable="ENCRHIRES" datasource="#Session.Dsn#">
	<cf_dbtempcol name="rango"   type="char(5)"      mandatory="yes">
	<cf_dbtempcol name="sexo"   type="char(1)"      mandatory="yes">
	<cf_dbtempcol name="cantidad"   type="int"      mandatory="yes">
</cf_dbtemp>
<cf_dbfunction name="dateaddx" args="yy,-1, '#form.FechaHasta#'" returnvariable="Lvar_FEfnac">
<cf_dbfunction name="dateaddx" args="yy,-2, '#form.FechaHasta#'" returnvariable="Lvar_FEfnac2">

<cfquery datasource="#session.DSN#">
	insert into #ENCRHIRES#
	select '0-1' as Rango, fe.FEsexo as Sexo, count(1) as Cantidad
	from FEmpleado fe
		inner join LineaTiempo lt
		on lt.DEid = fe.DEid
		and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaHasta)#"> between LTdesde and LThasta
	where fe.FEfnac > #preservesinglequotes(Lvar_FEfnac)#
	and fe.Pid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Pid#">
	group by fe.FEsexo
</cfquery>

<cfquery datasource="#session.DSN#">
	insert into #ENCRHIRES#
	select '1-2' as Rango, FEsexo as Sexo, count(1) as Cantidad
	from FEmpleado fe
		inner join LineaTiempo lt
		on lt.DEid = fe.DEid
		and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaHasta)#"> between LTdesde and LThasta
	where fe.FEfnac < #preservesinglequotes(Lvar_FEfnac)#
	and fe.FEfnac > #preservesinglequotes(Lvar_FEfnac2)#
	and fe.Pid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Pid#">
	group by fe.FEsexo
</cfquery>
<cfloop from = "2"
			to = "#form.EdadHasta#"
			index = "current_value"
			step = "#form.EdadRangos#">
	<cfset Lvar_From = current_value>
	<cfset Lvar_To = current_value+form.EdadRangos>
	<cfif Lvar_To + form.EdadRangos gt form.EdadHasta>
		<cfset Lvar_To = form.EdadHasta>
	</cfif>
	<cfif (Lvar_From eq Lvar_To) or ((Lvar_To - form.EdadRangos) lt Lvar_From)>
		<cfbreak>
	</cfif>
	<cf_dbfunction name="dateaddx" args="yy,-#Lvar_From#, '#form.FechaHasta#'" returnvariable="Lvar_DAddFrom">
	<cf_dbfunction name="dateaddx" args="yy,-#Lvar_To#, '#form.FechaHasta#'" returnvariable="Lvar_DAddto">

	<cfquery datasource="#session.DSN#">
		insert into #ENCRHIRES#
		select '#Lvar_From#-#Lvar_To#' as Rango, FEsexo as Sexo, count(1) as Cantidad
		from FEmpleado fe
			inner join LineaTiempo lt
			on lt.DEid = fe.DEid
			and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaHasta)#"> between LTdesde and LThasta
		where fe.FEfnac < #preservesinglequotes(Lvar_DAddFrom)#
		and fe.FEfnac > #preservesinglequotes(Lvar_DAddto)#
		and fe.Pid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Pid#">
		group by FEsexo
	</cfquery>
</cfloop>

<cfquery name="rsReporte" datasource="#session.dsn#">
	select * from #ENCRHIRES#
</cfquery>

<cfif rsReporte.recordcount GT 0>
	<cfquery name="rsParentesco" datasource="#session.dsn#">
		select Pdescripcion
		from RHParentesco
		where Pid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Pid#">
	</cfquery>
	<cfset Lvar_FileName = "ParientesReporteRes" & Session.Usucodigo & "-" & DateFormat(Now(),'yyyymmdd') & "-" & TimeFormat(Now(),'hhmmss') & ".xls">
	<table width="800" align="center" border="0" cellspacing="0" cellpadding="0">
	<tr>
	<td align="right">
		<cf_htmlreportsheaders
			title="ParientesReporteRes" 
			filename="#Lvar_FileName#" 
			ira="hijosEmpleadosRes.cfm">
	</td>
	</tr>
	</table>
	<cfoutput>
	<table width="800" align="center" border="0" cellspacing="0" cellpadding="0" bgcolor="##E3EDEF">
	  <tr>
		<td width="200" align="left" valign="top">&nbsp;</td>
		<td width="600" align="center" style="color:##6188A5; font-size:18px; font-family:Arial, Helvetica, sans-serif; " valign="top">#session.Enombre#</td>
		<td width="200" align="left" rowspan="2" valign="top">
			<table>
				<tr>
					<td width="200" align="right" style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  "><cf_translate  key="LB_Usuario">Usuario:</cf_translate></td>
					<td width="200" align="right" style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  ">#Session.Usuario#</td>
				</tr>
				<tr>
					<td width="200" align="right" style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  "><cf_translate  key="LB_Fecha">Fecha:</cf_translate></td>
					<td width="200" align="right" style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  ">#LSDateFormat(Now(),'dd/mm/yyyy')#</td>
				</tr>
				<tr>
					<td width="200" align="right" style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  ">&nbsp;</td>
					<td width="200" align="right" style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  ">1/1</td>
				</tr>
			</table>
		</td>
	  </tr>
	  <tr>
		<td width="200" align="left" valign="top">&nbsp;</td>
		<td width="600" align="center" style="font-size:18px; font-family:Arial, Helvetica, sans-serif; " valign="top"><cf_translate  key="LB_titulo">Resumen de Parientes por Rango de Edades</cf_translate></td>
	  </tr>
	</table>
	<table width="800" align="center" border="0" cellspacing="0" cellpadding="0"  bgcolor="##E3EDEF">
	  <tr>
	  	<td width="150" align="right" style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  "><cf_translate  key="LB_Fecha_de_Corte_al">Fecha de Corte al:</cf_translate></td>
		<td width="50" align="right" style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  ">#DateFormat(form.FechaHasta, "dd/mm/yyyy")#</td>
		<td width="150" align="right" style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  "><cf_translate  key="LB_Con_Corte_Hasta">Con corte hasta:</cf_translate></td>
		<td width="50" align="right" style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  ">#form.EdadHasta#</td>
		<td width="50" align="right" style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  "><cf_translate  key="LB_Annos">A&ntilde;os</cf_translate></td>
		<td width="150" align="right" style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  "><cf_translate  key="LB_Parentesco">Parentesco:</cf_translate></td>
		<td width="50" align="right" style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  ">#rsParentesco.Pdescripcion#</td>
		<td width="350" align="left" valign="top">&nbsp;</td>
		
	  </tr>
	</table>
	<table width="800" align="center" border="0" cellspacing="0" cellpadding="0">
	  <tr bgcolor="##E3EDEF">
	  		<td style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  "><strong><cf_translate  key="LB_Sexo">Sexo</cf_translate></strong></td>
			<td align="right" style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  "><strong>0-1</strong></td>
			<td align="right" style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  "><strong>1-2</strong></td>
			<cfloop from = "2"
						to = "#form.EdadHasta#"
						index = "current_value"
						step = "#form.EdadRangos#">
				<cfset Lvar_From = current_value>
				<cfset Lvar_To = current_value+form.EdadRangos>
				<cfif Lvar_To + form.EdadRangos gt form.EdadHasta>
					<cfset Lvar_To = form.EdadHasta>
				</cfif>
				<cfif (Lvar_From eq Lvar_To) or ((Lvar_To - form.EdadRangos) lt Lvar_From)>
					<cfbreak>
				</cfif>
				<td align="right" style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  "><strong>#Lvar_From#-#Lvar_To#</strong></td>
			</cfloop>
			<td align="right" style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  "><strong><cf_translate  key="LB_Total">Total</cf_translate></strong></td>
	  </tr>
	  <tr>
	  		<td style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  "><cf_translate  key="LB_Masculino">Masculino</cf_translate></td>
			<td align="right" style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  ">
				<cfquery name="rs" dbtype="query">
					select Cantidad
					from rsReporte
					where Rango = '0-1'
					and Sexo = 'M'
				</cfquery>
				<cfif rs.recordcount gt 0>#rs.Cantidad#<cfelse>0</cfif>
			</td>
			<td align="right" style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  ">
				<cfquery name="rs" dbtype="query">
					select Cantidad
					from rsReporte
					where Rango = '1-2'
					and Sexo = 'M'
				</cfquery>
				<cfif rs.recordcount gt 0>#rs.Cantidad#<cfelse>0</cfif>
			</td>
			<cfloop from = "2"
						to = "#form.EdadHasta#"
						index = "current_value"
						step = "#form.EdadRangos#">
				<cfset Lvar_From = current_value>
				<cfset Lvar_To = current_value+form.EdadRangos>
				<cfif Lvar_To + form.EdadRangos gt form.EdadHasta>
					<cfset Lvar_To = form.EdadHasta>
				</cfif>
				<cfif (Lvar_From eq Lvar_To) or ((Lvar_To - form.EdadRangos) lt Lvar_From)>
					<cfbreak>
				</cfif>
				<td align="right" style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  ">
					<cfquery name="rs" dbtype="query">
						select Cantidad
						from rsReporte
						where Rango = '#Lvar_From#-#Lvar_To#'
						and Sexo = 'M'
					</cfquery>
					<cfif rs.recordcount gt 0>#rs.Cantidad#<cfelse>0</cfif>
				</td>
			</cfloop>
			<td align="right" style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  ">
				<cfquery name="rs" dbtype="query">
					select sum(Cantidad) as Cantidad
					from rsReporte
					where Sexo = 'M'
				</cfquery>
				<cfif rs.recordcount gt 0>#rs.Cantidad#<cfelse>0</cfif>
			</td>
		</tr>
		<tr>
	  		<td style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  "><cf_translate  key="LB_Femenino">Femenino</cf_translate></td>
			<td align="right" style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  ">
				<cfquery name="rs" dbtype="query">
					select Cantidad
					from rsReporte
					where Rango = '0-1'
					and Sexo = 'F'
				</cfquery>
				<cfif rs.recordcount gt 0>#rs.Cantidad#<cfelse>0</cfif>
			</td>
			<td align="right" style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  ">
				<cfquery name="rs" dbtype="query">
					select Cantidad
					from rsReporte
					where Rango = '1-2'
					and Sexo = 'F'
				</cfquery>
				<cfif rs.recordcount gt 0>#rs.Cantidad#<cfelse>0</cfif>
			</td>
			<cfloop from = "2"
						to = "#form.EdadHasta#"
						index = "current_value"
						step = "#form.EdadRangos#">
				<cfset Lvar_From = current_value>
				<cfset Lvar_To = current_value+form.EdadRangos>
				<cfif Lvar_To + form.EdadRangos gt form.EdadHasta>
					<cfset Lvar_To = form.EdadHasta>
				</cfif>
				<cfif (Lvar_From eq Lvar_To) or ((Lvar_To - form.EdadRangos) lt Lvar_From)>
					<cfbreak>
				</cfif>
				<td align="right" style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  ">
					<cfquery name="rs" dbtype="query">
						select Cantidad
						from rsReporte
						where Rango = '#Lvar_From#-#Lvar_To#'
						and Sexo = 'F'
					</cfquery>
					<cfif rs.recordcount gt 0>#rs.Cantidad#<cfelse>0</cfif>
				</td>
			</cfloop>
			<td align="right" style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  ">
				<cfquery name="rs" dbtype="query">
					select sum(Cantidad) as Cantidad
					from rsReporte
					where Sexo = 'F'
				</cfquery>
				<cfif rs.recordcount gt 0>#rs.Cantidad#<cfelse>0</cfif>
			</td>
	  </tr>
	  <tr>
	  		<td style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  "><strong><cf_translate  key="LB_Total">Total</cf_translate></strong></td>
			<td align="right" style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  ">
				<cfquery name="rs" dbtype="query">
					select Sum(Cantidad) as Cantidad
					from rsReporte
					where Rango = '0-1'
				</cfquery>
				<strong><cfif rs.recordcount gt 0>#rs.Cantidad#<cfelse>0</cfif></strong>
			</td>
			<td align="right" style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  ">
				<cfquery name="rs" dbtype="query">
					select Sum(Cantidad) as Cantidad
					from rsReporte
					where Rango = '1-2'
				</cfquery>
				<strong><cfif rs.recordcount gt 0>#rs.Cantidad#<cfelse>0</cfif></strong>
			</td>
			<cfloop from = "2"
						to = "#form.EdadHasta#"
						index = "current_value"
						step = "#form.EdadRangos#">
				<cfset Lvar_From = current_value>
				<cfset Lvar_To = current_value+form.EdadRangos>
				<cfif Lvar_To + form.EdadRangos gt form.EdadHasta>
					<cfset Lvar_To = form.EdadHasta>
				</cfif>
				<cfif (Lvar_From eq Lvar_To) or ((Lvar_To - form.EdadRangos) lt Lvar_From)>
					<cfbreak>
				</cfif>
				<td align="right" style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  ">
					<cfquery name="rs" dbtype="query">
						select Sum(Cantidad) as Cantidad
						from rsReporte
						where Rango = '#Lvar_From#-#Lvar_To#'
					</cfquery>
					<strong><cfif rs.recordcount gt 0>#rs.Cantidad#<cfelse>0</cfif></strong>
				</td>
			</cfloop>
			<td align="right" style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  ">
				<cfquery name="rs" dbtype="query">
					select sum(Cantidad) as Cantidad
					from rsReporte
				</cfquery>
				<strong><cfif rs.recordcount gt 0>#rs.Cantidad#<cfelse>0</cfif></strong>
			</td>
	  </tr>
	</table>
	<br />
	<table width="800" align="center" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td width="200" align="left" valign="top">&nbsp;</td>
		<td width="600" align="left" valign="top">&nbsp;</td>
		<td width="200" align="left" rowspan="2" valign="top">
			<table>
				<tr>
					<td width="200" align="right" style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  ">&nbsp;</td>
					<td width="200" align="right" style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  ">&nbsp;</td>
				</tr>
				<tr>
					<td width="200" align="right" style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  ">&nbsp;</td>
					<td width="200" align="right" style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  ">&nbsp;</td>
				</tr>
				<tr>
					<td width="200" align="right" style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  ">&nbsp;</td>
					<td width="200" align="right" style="font-size:12px; font-family:Arial, Helvetica, sans-serif;  ">1/1</td>
				</tr>
			</table>
		</td>
	  </tr>
	  </table>
  
	</cfoutput>
<cfelseif rsReporte.recordcount EQ 0>
	<br>
	<br>
	<cf_translate  key="LB_NoSeGeneroUnReporteSegunLosFiltrosDados">No se gener&oacute; un reporte seg&uacute;n los filtros dados. Intente de nuevo!</cf_translate>
	<br>
	<br>
</cfif>