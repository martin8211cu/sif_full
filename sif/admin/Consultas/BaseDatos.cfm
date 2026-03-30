<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
<cf_templateheader title="Consulta de Base de Datos"> 
	<cfinclude template="/sif/portlets/pNavegacionAdmin.cfm">		  
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Estad&iacute;sticas de Almacenamiento: Datos'>
		<cfset rs=ObtieneEstadisticas(session.dsn)>
		<cfset PresentaPortlet(rs)>			
	<cf_web_portlet_end>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Estad&iacute;sticas de Almacenamiento: Interfaces'>
		<cfset rs=ObtieneEstadisticas("sifinterfaces")>
		<cfset PresentaPortlet(rs)>			
	<cf_web_portlet_end>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Estad&iacute;sticas de Almacenamiento: Administracion'>
		<cfset rs=ObtieneEstadisticas("asp")>
		<cfset PresentaPortlet(rs)>			
	<cf_web_portlet_end>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Estad&iacute;sticas de Almacenamiento: Monitoreo'>
		<cfset rs=ObtieneEstadisticas("aspmonitor")>
		<cfset PresentaPortlet(rs)>			
	<cf_web_portlet_end>
<cf_templatefooter><!-- InstanceEnd -->

<cffunction name="ObtieneEstadisticas" output="no" returntype="query">
	<cfargument name="Conexion" type="string" required="yes">

	<cfquery name="rsBD" datasource="#Arguments.Conexion#">
		select 
			sum(size * a.low / 1024) / 1024 as size, 
			sum((curunreservedpgs(db_id(), u.lstart, u.unreservedpgs) * a.low / 1024)) / 1024 as free,
			(sum(size * a.low / 1024) / 1024) - (sum((curunreservedpgs(db_id(), u.lstart, u.unreservedpgs) * a.low / 1024)) / 1024) as used
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
	
	<cfset LvarTotal = rsbd.size>
	
	<cfset rs = QueryNew("datos, valores")>
	
	<cfloop query="rsBD">
		<cfset QueryAddRow(rs)>
		<cfset QuerySetCell(rs,"datos","utilizado")>
		<cfset QuerySetCell(rs,"valores",(rsbd.size - rsbd.free))>
		<cfset QueryAddRow(rs)>
		<cfset QuerySetCell(rs,"datos","libre")>
		<cfset QuerySetCell(rs,"valores",rsbd.free)>
	</cfloop>
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
				<cftable border="no" query="rs" colheaders="yes" htmltable="yes" colspacing="2">
					<cfcol align="left" header="<font size='1'>Concepto</font>" text="#datos#">
					<cfcol align="right" header="<div align='right'><font size='1'>Utilización</font></div>" text="#NumberFormat(valores,'999,999,999,999,999.99')#">
					<cfcol align="left" header="" text="Mb">
					<cfcol align="right" header="%" text="#NumberFormat(valores*100/LvarTotal,"99999")#">
				</cftable>
			</td>

			<td align="center" valign="top" nowrap>
			<cfchart 
				format="flash"
				chartwidth="300" 
				chartheight="100" 
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
			
			<cfset colores ="Blue,">
			<cfif (rsBD.used*100/rsbd.size) gt 90> 
				<cfset colores =colores & "Red">
			<cfelse>
				<cfset colores =colores & "Aqua">
			</cfif>
			
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
				chartheight="100" 
				showlegend="yes"
				showmarkers="yes"
				showborder="no"
				pieslicestyle="solid"
				show3d="yes"
				scalefrom=1 
				scaleto=#rsBD.size# 
				gridlines=2
				labelformat="number"
				rotated="yes">
			<cfchartseries 
					type="BAR"
					query="rs" 
					itemcolumn="datos"
					valuecolumn="valores"
					colorlist="Blue, Teal, Lime"
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