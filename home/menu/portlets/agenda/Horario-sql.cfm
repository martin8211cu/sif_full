<cfsetting enablecfoutputonly="yes">

<cfset ComponenteAgenda = CreateObject("Component", "home.Componentes.Agenda")>
<cfset CodigoAgenda = ComponenteAgenda.MiAgenda()>
<cfset ComponenteHorario = CreateObject("component", "home.Componentes.Horario")>

<cfset dias = 'DLKMJVS'>
<cfset horario = ''>

<cfif form.tipo eq 'R'>
	<cfif isdefined("form.iniLV") and isdefined("form.finLV") and len(trim(form.iniLV)) and len(trim(form.finLV))>
		<cfset horario = horario & 'L-V'&trim(form.iniLV)&'-'&trim(form.finLV)>
	</cfif>
	<cfif isdefined("form.iniS") and isdefined("form.finS") and len(trim(form.iniS)) and len(trim(form.finS))>
		<cfif len(trim(horario))>
			<cfset horario = horario & ','>
		</cfif>
		<cfset horario = horario & 'S'&trim(form.iniS)&'-'&trim(form.finS)>
	</cfif>
	<cfif isdefined("form.iniD") and isdefined("form.finD") and len(trim(form.iniD)) and len(trim(form.finD))>
		<cfif len(trim(horario))>
			<cfset horario = horario & ','>
		</cfif>
		<cfset horario = horario & 'D'&trim(form.iniD)&'-'&trim(form.finD)>
	</cfif>
	<cfset horario = replace(horario,':','','all') >

<cfelse>
	<cfloop from="1" to="100" index="i">
		<cfif IsDefined('form.sem'&i) and 
			IsDefined('form.ini'&i) and 
			IsDefined('form.fin'&i) and
			Len(form['sem'&i]) and Len(form['ini'&i]) and Len(form['fin'&i])>
			
			<cfset linea = Mid(dias,form['sem'&i],1) & Replace(form['ini'&i],':','') & '-' & Replace(form['fin'&i],':','')>
			<cfset horario = ListAppend(horario, linea)>
		</cfif>
	</cfloop>
</cfif>

<cfset horario_habil = ComponenteHorario.Parse(horario).getString() >
<cfset ComponenteAgenda.EstablecerHorario(CodigoAgenda, horario_habil, form.escala) >
<cflocation url="Horario.cfm">