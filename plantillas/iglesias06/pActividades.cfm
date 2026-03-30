<cfparam name="session.dsn_iglesias" default="#session.dsn#">

<cfquery name="rsActividades" datasource="#Session.dsn_iglesias#">
	select (case datepart(dw, a.MEVfecha) 
			when 1 then 'Domingo'
			when 2 then 'Lunes'
			when 3 then 'Martes'
			when 4 then 'Miércoles'
			when 5 then 'Jueves'
			when 6 then 'Viernes'
			when 7 then 'Sábado'
			else ''
			end) || '&nbsp;' || convert(varchar, datepart(dd, a.MEVfecha)) as Dia,
			datepart(dd, a.MEVfecha) as Fecha,
			a.MEVevento,
			(case when datepart(hh, a.MEVinicio) = 0 then 12 
				 when datepart(hh, a.MEVinicio) > 12 then datepart(hh, a.MEVinicio)-12
				 else datepart(hh, a.MEVinicio)
			end) as HoraIComun,
			datepart(mi, a.MEVinicio) as MinIComun, 
			(case when datepart(hh, a.MEVinicio) < 12 then 'AM'
				 else 'PM'
			end) as SufHoraI,
			(case when datepart(hh, a.MEVfin) = 0 then 12 
				 when datepart(hh, a.MEVfin) > 12 then datepart(hh, a.MEVfin)-12
				 else datepart(hh, a.MEVfin)
			end) as HoraFComun,
			datepart(mi, a.MEVfin) as MinFComun, 
			(case when datepart(hh, a.MEVfin) < 12 then 'AM'
				 else 'PM'
			end) as SufHoraF
	from MEEvento a
	where datepart(mm, MEVfecha) = datepart(mm, getDate())
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by Fecha, SufHoraI, HoraIComun, MinIComun, SufHoraF, HoraFComun, MinFComun
</cfquery>


<cfset meses = "Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre">
<cfoutput>
	<p>&nbsp;</p>
	<h2 class="style3">Actividades Especiales de #ListGetAt(meses, DatePart('m', Now()), ',')#</h2>
	<cfif rsActividades.recordCount GT 0>
		<cfset corte = "">
		<table cellspacing="0" cellpadding="2">
		<cfloop query="rsActividades">
			<cfif corte NEQ rsActividades.Dia>
				<cfset corte = rsActividades.Dia>
				<tr bgcolor="##CC9900">
				  <td colspan="3" align="middle" class="style1 ver11"><strong class="style1">#corte# </strong></td>
				</tr>
			</cfif>
			<tr>
			  <td width="55" align="right" class="ver11">#rsActividades.HoraIComun#:#Iif(Len(rsActividades.MinIComun) EQ 1, DE("0" & rsActividades.MinIComun), DE(rsActividades.MinIComun))# #rsActividades.SufHoraI#</td>
			  <td>&nbsp;</td>
			  <td width="162" class="ver11">#rsActividades.MEVevento#</td>
			</tr>
		</cfloop>
		</table>
	</cfif>
</cfoutput>