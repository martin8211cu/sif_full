<cfset LbanderaGenerarConsulta = true>
<cfif FileExists(expandpath('./EstadoResultados_#session.CEcodigo#_#session.ecodigo#.cfm'))>
	<cfset Undelivr = ExpandPath('/sif/cg/')>
	<cfdirectory action="list" directory="#Undelivr#" name="lista" filter="EstadoResultados_#session.CEcodigo#_#session.ecodigo#*.cfm">
		<cfset LvarG = DateDiff('n', '#lista.DateLastModified#', dateformat(NOW(),'dd/mm/yy')& ' ' & timeFormat(now(),"hh:mm:ss tt "))>
		<cfif LvarG lte 60>
			<cfset LbanderaGenerarConsulta = false>
		</cfif>
</cfif>
<cfif LbanderaGenerarConsulta>
	<cfinclude template="MenuConsulta.cfm">
</cfif>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Titulo" default=" Contabilidad General"
    returnvariable="LB_Titulo" xmlfile="MenuCG.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Titulo1" default="Men&uacute; Principal de Contabilidad General"
    returnvariable="LB_Titulo1" xmlfile="MenuCG.xml"/>
<cf_templateheader title="SIF - #LB_Titulo#">
	<cfinclude template="../portlets/pNavegacion.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_titulo1#">
        <table width="100%"  border="0" cellspacing="0" cellpadding="0">
             <tr>
                <td  rowspan="2" valign="top"  width="20%" >
                    <cf_menu sscodigo="SIF" smcodigo="CG">
                </td>
                <td  valign="top" width="80%" height="50%">
				<cfif isdefined("session.cenombre") AND FindNoCase("PROVEEDORES DE LA CONSTRUCCION",UCase(session.cenombre)) EQ 1>
					<!--- SE COMENTA UNICAMENTE PARA PROCONSA --->
					<!--- <cfinclude template="./EstadoResultados_#session.CEcodigo#_#session.ecodigo#.cfm"> ---> &nbsp;
				<cfelse>
					<cfinclude template="./EstadoResultados_#session.CEcodigo#_#session.ecodigo#.cfm">
				</cfif>
                </td>
             </tr>
        </table>
	<cf_web_portlet_end>
<cf_templatefooter>