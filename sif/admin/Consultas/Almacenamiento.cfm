<cf_templateheader title="Consulta de Base de Datos"> 
	<cfinclude template="/sif/portlets/pNavegacionAdmin.cfm">
	<cfset LvarDBtype = Application.dsinfo[session.dsn].type>
	<cfif ListFind('sybase', LvarDBtype)>		  
			<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Estad&iacute;sticas de Almacenamiento: Database Datos'>
				<cfset rs=ObtieneEstadisticas(session.dsn)>
				<cfset PresentaPortlet(rs)>			
			<cf_web_portlet_end>
			<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Estad&iacute;sticas de Almacenamiento: Database Interfaces'>
				<cfset rs=ObtieneEstadisticas("sifinterfaces")>
				<cfset PresentaPortlet(rs)>			
			<cf_web_portlet_end>
			<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Estad&iacute;sticas de Almacenamiento: Database Administracion'>
				<cfset rs=ObtieneEstadisticas("asp")>
				<cfset PresentaPortlet(rs)>			
			<cf_web_portlet_end>
			<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Estad&iacute;sticas de Almacenamiento: Database Monitoreo'>
				<cfset rs=ObtieneEstadisticas("aspmonitor")>
				<cfset PresentaPortlet(rs)>			
			<cf_web_portlet_end>
			<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Estad&iacute;sticas de Almacenamiento: FileSystem Coldfusion'>
				<cfset LvarCFMX = expandPath("/")>
				<cfset rs=ObtieneEstadisticasFS(LvarCFMX)>
				<cfoutput>
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="10%" nowrap>&nbsp;</td>
						<td width="20%" nowrap>&nbsp;</td>
						<td width="90%" nowrap>&nbsp;</td>
					</tr>
					<tr>
						<td nowrap>Directorio raiz:&nbsp;&nbsp;</td>
						<td nowrap>#LvarCFMX#</td>
					</tr>
					<tr>
						<td nowrap>Volume:</td>
						<td nowrap>#LvarVolume.Volume#</td>
					</tr>
				</table>
				</cfoutput>
				<cfset PresentaPortlet(rs)>		
		<cfelse>
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Estadísticas de Database Datos'>
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td align="center"><strong><br /><br />Esta Consulta no esta Implementada para <cfoutput>#LvarDBtype#</cfoutput><br /><br /></strong> </td>
					</tr>
	  </table>
	</cfif>	
	<cf_web_portlet_end>
<cf_templatefooter><!-- InstanceEnd -->

<cffunction name="ObtieneEstadisticas" output="no" returntype="query">
	<cfargument name="Conexion" type="string" required="yes">

	<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
		select 
			sum(size * a.low / 1024) / 1024 as total, 
			sum((curunreservedpgs(db_id(), u.lstart, u.unreservedpgs) * a.low / 1024)) / 1024 as libre,
			(sum(size * a.low / 1024) / 1024) - (sum((curunreservedpgs(db_id(), u.lstart, u.unreservedpgs) * a.low / 1024)) / 1024) as utilizado
		from master.dbo.sysdatabases d,
		  master..sysusages u,
		  master.dbo.sysdevices v,
		  master.dbo.spt_values a
		 where d.dbid = db_id()
		   and u.dbid = d.dbid
		   and u.segmap != 4
		   and v.low <= u.size + vstart
		   and v.high >= u.size + vstart - 1
		   and v.status & 2 = 2 
		   and d.name = db_name()
		   and a.type = 'E'
		   and a.number = 1
	</cfquery>
	
	<cfset LvarTotal = rsSQL.total>
	<cfset LvarUsed = rsSQL.utilizado>
	<cfset LvarFree = rsSQL.libre>
	
	<cfset rs = QueryNew("datos, valores")>
	
	<cfloop query="rsSQL">
		<cfset QueryAddRow(rs)>
		<cfset QuerySetCell(rs,"datos","utilizado")>
		<cfset QuerySetCell(rs,"valores",(LvarTotal - LvarFree))>
		<cfset QueryAddRow(rs)>
		<cfset QuerySetCell(rs,"datos","libre")>
		<cfset QuerySetCell(rs,"valores",LvarFree)>
	</cfloop>
	<cfreturn rs>
</cffunction>

<cffunction name="ObtieneEstadisticasFS" output="no" returntype="query">
	<cfargument name="Path" type="string" required="yes">

	<cfinvoke component="sif.Componentes.fileSystem" method="getVolumeSpace" returnvariable="LvarVolume" path="#Arguments.Path#">
	<cfset LvarVolume.total = int(LvarVolume.total/1000)>
	<cfset LvarVolume.used = int(LvarVolume.used/1000)>
	<cfset LvarVolume.Available = int(LvarVolume.Available/1000)>
	<cfset LvarTotal = LvarVolume.Total>
	<cfset LvarUsed = LvarVolume.Used>
	
	<cfset rs = QueryNew("datos, valores")>
	<cfset QueryAddRow(rs)>
	<cfset QuerySetCell(rs,"datos","utilizado")>
	<cfset QuerySetCell(rs,"valores",LvarVolume.Used)>
	<cfset QueryAddRow(rs)>
	<cfset QuerySetCell(rs,"datos","libre")>
	<cfset QuerySetCell(rs,"valores",LvarVolume.Available)>

	<cfreturn rs>
</cffunction>

<cffunction name="PresentaPortlet" access="private" output="yes">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td width="20%" nowrap>&nbsp;</td>
			<td width="40%" nowrap>&nbsp;</td>
			<td width="20%" nowrap>&nbsp;</td>
			<td width="20%">&nbsp;</td>
		</tr>
		<tr>
			<td align="center" valign="top" nowrap>
				<table>
					<tr>
						<td><strong>Concepto</strong></td>
						<td align="right">&nbsp;<strong>Espacio</strong></td>
						<td></td>
						<td align="right"><strong>%&nbsp;</strong></td>
					</tr>
				<cfloop query="rs">
					<tr>
						<td>#datos#</td>
						<td align="right">#NumberFormat(valores,',9.99')#</td>
						<td>MB</td>
						<td align="right">#NumberFormat(valores*100/LvarTotal,"99999")#</td>
					</tr>
				</cfloop>
					<tr>
						<td><strong>TOTAL</strong></td>
						<td align="right"><strong>#NumberFormat(LvarTotal,',9.99')#</strong></td>
						<td><strong>MB</strong></td>
						<td align="right">&nbsp;<strong>100</strong></td>
					</tr>
				</table>
			</td>

			<td align="center" valign="top" nowrap>
				<cfset colores ="Blue,">
				<cfif (LvarUsed*100/LvarTotal) gt 90> 
					<cfset colores =colores & "Red">
				<cfelse>
					<cfset colores =colores & "Aqua">
				</cfif>
				<cfchart 
					format="flash"
					chartwidth="300" 
					chartheight="200" 
					showlegend="yes"
					showmarkers="yes"
					showborder="no"
					pieslicestyle="solid"
					show3d="yes"
					scalefrom=0 
					scaleto=10 
					gridlines=3 
					labelformat="number"
					xaxistitle="Concepto"
					yaxistitle="Utilización en bytes"
					rotated="yes"
				> 
					<cfchartseries 
						type="PIE" 
						query="rs" 
						itemcolumn="datos"
						valuecolumn="valores"
						colorlist=#colores#/>
				</cfchart>				  
			</td>

			<td>
				<cfchart 
					format="flash"
					chartwidth="300" 
					chartheight="200" 
					showlegend="yes"
					showmarkers="yes"
					showborder="no"
					pieslicestyle="solid"
					show3d="yes"
					scalefrom=1 
					scaleto=#LvarTotal# 
					gridlines=2
					labelformat="number"
					rotated="yes">
				<cfchartseries 
						type="BAR"
						query="rs" 
						itemcolumn="datos"
						valuecolumn="valores"
						colorlist="#colores#"
				>
				</cfchart>
			</td>

		<td align="center" valign="top" nowrap>&nbsp;</td>
		</tr>
		<tr>
			<td nowrap>&nbsp;</td>
			<td nowrap>&nbsp;</td>
			<td nowrap>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
	</table>
</cffunction>