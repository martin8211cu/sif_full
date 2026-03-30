
<cfsetting enablecfoutputonly="yes">

<cfset ComponenteAgenda = CreateObject("Component", "home.Componentes.Agenda")>
<cfset ComponenteHorario = CreateObject("component", "home.Componentes.Horario")>
<cfinvoke component="rh.Componentes.AgendaMedica" method="AgendaMedica" returnvariable="CodigoAgendaMedica">
	<cfinvokeargument name="create" value="yes">
</cfinvoke>

<cfset dias = 'DLKMJVS'>
<cfset horario = ''>

<cfloop from="1" to="100" index="i">
	<cfif IsDefined('form.sem'&i) and 
		IsDefined('form.ini'&i) and 
		IsDefined('form.fin'&i) and
		Len(form['sem'&i]) and Len(form['ini'&i]) and Len(form['fin'&i])>
		
		<cfset linea = Mid(dias,form['sem'&i],1) & Replace(form['ini'&i],':','') & '-' & Replace(form['fin'&i],':','')>
		<cfset horario = ListAppend(horario, linea)>
	</cfif>
</cfloop>

<cfoutput>#horario#<br></cfoutput>

<cfset horario_habil = ComponenteHorario.Parse(horario).getString()>
<cfoutput>#horario_habil#<br></cfoutput>
<cfset ComponenteAgenda.EstablecerHorario ( form.agenda, horario_habil, form.escala )>
<cflocation url="Horario.cfm?ag=#form.agenda#">