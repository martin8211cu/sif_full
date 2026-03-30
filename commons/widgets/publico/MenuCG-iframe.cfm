<cfset LbanderaGenerarConsulta = true>
<cfif FileExists(expandpath('EstadoResultados_#session.CEcodigo#_#session.ecodigo#.cfm'))>
	<cfset Undelivr = ExpandPath('/sif/cg/')>
	<cfdirectory action="list" directory="#Undelivr#" name="lista" filter="EstadoResultados_#session.CEcodigo#_#session.ecodigo#*.cfm">
		<cfif lista.DateLastModified neq "">
			<cfset LvarG = DateDiff('n', '#lista.DateLastModified#', dateformat(NOW(),'dd/mm/yy')& ' ' & timeFormat(now(),"hh:mm:ss tt "))>
			<cfif LvarG lte 60>
				<cfset LbanderaGenerarConsulta = false>
			</cfif>
		</cfif>
</cfif>
<cfif LbanderaGenerarConsulta>
	<cfinclude template="MenuConsultaCG.cfm">
</cfif>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Titulo" default=" Contabilidad General"
    returnvariable="LB_Titulo" xmlfile="MenuCG.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Titulo1" default="Men&uacute; Principal de Contabilidad General"
    returnvariable="LB_Titulo1" xmlfile="MenuCG.xml"/>

<table width="100%"  border="0" cellspacing="0" cellpadding="0">
     <tr>
        <td  valign="top" width="80%" height="50%">
        <cfinclude template="EstadoResultados_#session.CEcodigo#_#session.ecodigo#.cfm">
        </td>
     </tr>
</table>