<cf_templateheader title="Consola de Administración de Procesos de Interfaz">
<cf_web_portlet_start titulo="Configuración de la Generación de Modelos de Base de Datos">
<cf_templatecss>
	<cfparam name="url.IDmod" default="">
	<cf_dbfunction name="OP_Concat" returnvariable="CAT" datasource="asp">

	<cfinvoke component="asp.parches.DBmodel.Componentes.DSNs" method="init">

	<cfquery name="rsDSNs" datasource="asp">
		select 	m.IDsch, m.IDmod, d.IDdsn, d.activo, s.sch, m.modelo, d.dsn
		  from DBMmodelos m
		  	inner join DBMsch s
			 on s.IDsch = m.IDsch
		  	left join DBMdsn d
			 on d.IDmod = m.IDmod
	</cfquery>
<script language="javascript">
	var dis = false;
	function sbOP (op, IDmod, dsn)
	{
		if (dis) 
		{
			return false;
		}
		if (op == 1)
		{
			dis = true;
			location.href = "DBMdsn_sql.cfm?OP=1&IDmod=" + IDmod;
		}
		else if (op == 2)
		{
			dis = true;
			location.href = "DBMdsn_sql.cfm?OP=2&IDmod=" + IDmod + '&dsn=' + escape(dsn);
		}
		else if (op == 3)
		{
			dis = true;
			if (confirm('Este proceso actualiza las DSNs definidas en el Administrador de Coldfusion (cuando se crea un nuevo DSN o cuando se ha levantado una base de datos que estaba caída).  Pero puede tardar mucho tiempo cuando hay errores de timeout (si siguen bases de datos caídas). ¿Desea continuar?'))
				location.href = "DBMdsn_sql.cfm?OP=3&IDmod=" + IDmod;
		}
	}
</script>
<table>
<tr>
<td width="50%" valign="top">
	<table>
		<tr>
			<td><strong>SCHEMA&nbsp;&nbsp;&nbsp;</strong></td>
			<td width="120"><strong>MODELO</strong></td>
			<td><strong>OP</strong></td>
			<td><strong>Datasource</strong></td>
		</tr>
	<cfoutput query="rsDSNs" group="IDsch">
		<tr>
			<cfset LvarSch = sch>
		</tr>
		<cfoutput group="IDmod">
		<tr>
			<td>#LvarSch#&nbsp;&nbsp;&nbsp;</td>
			<cfset LvarSch = "">
			<cfset LvarMod = replace(modelo,".pdm","")>
			<cfif IDmod EQ url.IDmod>
				<td><strong>#LvarMod#</strong></td>
				<td><img src="/cfmx/asp/parches/images/iedit.gif"></td>
				<td><strong>--------></strong>&nbsp;
			<cfelse>
				<td>#LvarMod#</td>
				<td><img src="/cfmx/asp/parches/images/iindex.gif" style="cursor:pointer" onclick="return sbOP(1,#IDmod#);" alt="Configurar nuevos DSNs para generar '#LvarMod#'"></td>
				<td>
			</cfif>
			<cfif dsn EQ "">
				<font color="##FF0000"><strong>FALTA ESPECIFICAR DSNs</strong></font>
			</cfif>
				</td>
		</tr>
			<cfoutput>
				<cfif dsn NEQ "">
				<tr>
					
					<td colspan="2"></td>
						<cfset LvarERR = "">
						<cfif NOT isdefined("application.dsinfo.#dsn#")>
							<cfset LvarERR = "&nbsp;&nbsp;<font color='##FF0000'>(Falta definirlo en Coldfusion)</font>">
						<cfelseif application.dsinfo[dsn].schemaError NEQ "">
							<cfset LvarERR = "&nbsp;&nbsp;<font color='##FF0000'>(#application.dsinfo[dsn].schemaError#)</font>">
						<cfelseif isdefined("application.dsinfo.#dsn#.aspServer") AND NOT application.dsinfo[dsn].aspServer>
							<cfset LvarERR = "&nbsp;&nbsp;<font color='##FF0000'>(No pertenece al mismo Servidor de ASP)</font>">
						</cfif>
						<td>
							<input type="checkbox" 
								<cfif LvarErr NEQ "">
									disabled
								<cfelseif listfind("asp,aspmonitor,sifcontrol",lcase(dsn))>
									checked disabled
								<cfelseif activo EQ 1>
									checked
								</cfif>
								onclick="return sbOP (2, #IDmod#, '#lcase(JSStringFormat(dsn))#');"
							>
						</td>
						<td>#lcase(dsn)# #LvarErr#</td>
				</tr>
				</cfif>
			</cfoutput>
				<tr style="border-bottom:solid ##CCCCCC 1px;">
					<td colspan="4" style="border-bottom:solid ##CCCCCC 1px; height:1px; font-size:1px">&nbsp;
					</td>
				</tr>
		</cfoutput>
	</cfoutput>
	</table>
</td>
<td>&nbsp;&nbsp;&nbsp;</td>
<cfif url.IDmod NEQ "">
	<cfquery name="rsSQL" dbtype="query">
		select sch,modelo,IDsch,IDmod
		  from rsDSNs
		 where IDmod = #url.IDmod#
	</cfquery>
	<cfset LvarSch = rsSQL.sch>
	<cfset LvarMod = rsSQL.modelo>
	<cfset LvarIDsch = rsSQL.IDsch>
	<cfset LvarIDmod = rsSQL.IDmod>
	<td width="50%" valign="top">
		<table cellpadding="0" cellspacing="0">
			<tr>
				<td colspan="5">
					<strong>ESPECIFICACION DE DATASOURCES DE COLDFUSION</strong>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<strong>SCHEMA</strong>
				</td>
				<td colspan="5">
					<strong><cfoutput>#LvarSch#</cfoutput></strong>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<strong>MODELO</strong>
				</td>
				<td colspan="5">
					<strong><cfoutput>#LvarMod#</cfoutput></strong>
				</td>
			</tr>
			<tr>
				<td colspan="5">&nbsp;
					
				</td>
			</tr>
			<tr>
				<td colspan="5">
					<strong>DATASOURCES DE COLDFUSION</strong>&nbsp;&nbsp;
					<input value="Refrescar" type="button" onclick="return sbOP(3,<cfoutput>#url.IDmod#</cfoutput>);">
				</td>
			</tr>
			<cfoutput>
			<cfloop index="LvarPASO" from="1" to="2">
			<cfloop collection="#application.dsinfo#" item="LvarDSN">
				<cfquery name="rsSQL" dbtype="query">
					select IDmod, IDsch, activo
					  from rsDSNs
					 where dsn = '#trim(lcase(application.dsinfo[LvarDSN].name))#'
				</cfquery>
				<cfset LvarPintar = NOT(rsSQL.IDsch NEQ "" AND rsSQL.IDsch NEQ LvarIDsch)>
				<cfset LvarPintar = LvarPintar AND (LvarPaso EQ 1 AND application.dsinfo[LvarDSN].schemaError EQ "" OR LvarPaso EQ 2 AND application.dsinfo[LvarDSN].schemaError NEQ "")>
				<cfif LvarPintar>
				<tr style="border-bottom:solid ##CCCCCC 1px;">
					<td style="border-bottom:solid ##CCCCCC 1px;">
						<input type="checkbox" 
						<cfif application.dsinfo[LvarDSN].schemaError NEQ "">
							disabled
						<cfelseif isdefined("application.dsinfo.#LvarDSN#.aspServer") AND NOT application.dsinfo[LvarDSN].aspServer>
							disabled
						<cfelseif rsSQL.IDsch NEQ "" AND rsSQL.IDsch NEQ LvarIDsch>
							disabled
						<cfelseif listFind(valueList(rsSQL.IDmod), LvarIDmod)>
							<cfquery name="rsSQL" dbtype="query">
								select activo
								  from rsDSNs
								 where IDmod = #LvarIDmod#
								   and dsn = '#trim(lcase(application.dsinfo[LvarDSN].name))#'
							</cfquery>
							<cfif rsSQL.activo EQ "1">
								checked
							</cfif>
						</cfif>
							onclick="return sbOP (2, #LvarIDmod#, '#lcase(JSStringFormat(application.dsinfo[LvarDSN].name))#');"
						>
					</td>
					<td style="border-bottom:solid ##CCCCCC 1px;">
						#application.dsinfo[LvarDSN].name#&nbsp;&nbsp;
					</td>
					<td style="border-bottom:solid ##CCCCCC 1px;">
						#replace(application.dsinfo[LvarDSN].url,";","; ","ALL")#<BR/>
						<cfif application.dsinfo[LvarDSN].schemaError NEQ "">
						<font color="##FF0000">#application.dsinfo[LvarDSN].schemaError#</font><BR>
						</cfif>
						<cfif isdefined("application.dsinfo.#LvarDSN#.aspServer") AND NOT application.dsinfo[LvarDSN].aspServer>
						<font color="##FF0000">No pertenece al mismo servidor de ASP</font>
						</cfif>
					</td>
				</tr>
				</cfif>
			</cfloop>
			</cfloop>
			</cfoutput>
		</table>
	</td>
</cfif>
</tr>
</table>
<cf_web_portlet_end>
<cf_templatefooter>
