<!---Inserta un nuevo Feriado--->
<cfif modo eq 'ALTA'>
	<cfinvoke component="commons.Componentes.Agenda" method="AltaAgenda" returnvariable="CAAid">   
		<cfinvokeargument name="repite" 		value="#url.repite#">
        <cfinvokeargument name="fecha"			value="#url.fecha#">
        <cfinvokeargument name="descripcion" 	value="#url.descripcion#">
        <cfinvokeargument name="CAAgrupado" 	value="Rvac">
	</cfinvoke>
    <cfoutput>#CAAid#</cfoutput>    
<!--- Actualiza los Feriados--->        
<cfelseif modo eq 'CAMBIO'>
	<cfinvoke component="commons.Componentes.Agenda" method="CambioAgenda">   
		<cfinvokeargument name="repite" 		value="#url.repite#">
        <cfinvokeargument name="fecha" 			value="#url.fecha#">
        <cfinvokeargument name="descripcion" 	value="#url.descripcion#">
        <cfinvokeargument name="CAAid" 			value="#url.CAAid#">
       	<cfinvokeargument name="CAAgrupado" 	value="Rvac">
	</cfinvoke>	
<!--- Actualiza los Feriado cambiado la fecha fin--->        
<cfelseif modo eq 'CAMBIOFechaFin'>
	<cfinvoke component="commons.Componentes.Agenda" method="CambioAgendaFechaFin">   
        <cfinvokeargument name="fecha" value="#url.fecha#">
        <cfinvokeargument name="CAAid" value="#url.CAAid#">
	</cfinvoke>	
  
<!---Elimina Feriados--->        
<cfelseif modo eq 'BAJA'>
	<cfinvoke component="commons.Componentes.Agenda" method="BajaAgenda">   
        <cfinvokeargument name="CAAid" value="#url.CAAid#">
	</cfinvoke>	
<cfelseif modo eq 'MES'>
<!---Pinta Mes Feriados sin repetir--->	
    <cfinvoke component="commons.Componentes.Agenda" method="GetAgendaM" returnvariable="rsSQL">
		<cfinvokeargument name="CAAgrupado" value="Rvac">
	     <cfinvokeargument name="Mes" 		value="#url.mes#">
        <cfinvokeargument name="Year" 		value="#url.years#">
	</cfinvoke> 
    <cfset strin ="/">
    <cfloop query="rsSQL">
		<cfoutput>#rsSQL.CADescripcion##strin#</cfoutput>
        <cfoutput>#LsDateFormat(rsSQL.CAFechaIni,"yyyy-mm-dd")##strin#</cfoutput>
        <cfoutput>#rsSQL.CARepite##strin#</cfoutput>
        <cfoutput>#rsSQL.CAAid##strin#</cfoutput>
   </cfloop>
<!---Pinta Mes Feriados Repetidos--->	
    <cfinvoke component="commons.Componentes.Agenda" method="GetAgendaMRepetidos" returnvariable="rsSQLR">
		<cfinvokeargument name="CAAgrupado" value="Rvac">
	     <cfinvokeargument name="Mes" 		value="#url.mes#">
        <cfinvokeargument name="Year" 		value="#url.years#">
	</cfinvoke> 
    <cfset strin ="/">
    <cfloop query="rsSQLR">
		<cfoutput>#rsSQLR.CADescripcion##strin#</cfoutput>
        <cfset variable="">
        <cfset dia= DateFormat(rsSQLR.CAFechaIni,"DD")>
         <cfset variable = #url.years#&"-"&#url.mes#&"-"&#dia#>
        <cfoutput>#variable##strin#</cfoutput>
        <cfoutput>#rsSQLR.CARepite##strin#</cfoutput>
        <cfoutput>#rsSQLR.CAAid##strin#</cfoutput>
   </cfloop>
</cfif>  