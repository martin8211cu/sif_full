<!--- <cfif IsDefined("form.Cambio")> --->
<cfquery name="rsGOT" datasource="#session.dsn#">
	select GOTid
	  from AnexoGOficina
	 where GOid = <cfqueryparam value="#Form.GOid#" cfsqltype="cf_sql_numeric">
</cfquery>

<cftransaction>
		<cfquery datasource="#session.dsn#" name="idquery">
			delete from AnexoGOficinaDet
			where GOid = <cfqueryparam value="#Form.GOid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfif IsDefined("form.oficinasCB")>
			<cfloop list="#form.oficinasCB#" index="i">	
				<cfif rsGOT.GOTid NEQ "">
					<cfquery name="rsSQL" datasource="#session.dsn#">
						select t.GOTcodigo, t.GOTnombre, o.Oficodigo, o.Odescripcion, g.GOcodigo, g.GOnombre
						  from AnexoGOficinaDet d
							inner join AnexoGOficina g
								 on g.GOid = d.GOid
							inner join AnexoGOTipo t
								 on t.GOTid = g.GOTid
							inner join Oficinas o
								 on o.Ecodigo = d.Ecodigo
								and o.Ocodigo = d.Ocodigo
						 where d.Ecodigo	= #session.Ecodigo#
						   and d.Ocodigo	= #i#
						   and g.GOTid		= #rsGOT.GOTid#
					</cfquery>
					<cfif rsSQL.recordCount GT 0>
						<cfthrow message="Verificación de Tipo de Grupo '#rsSQL.GOTcodigo#-#rsSQL.GOTnombre#': La Oficina '#rsSQL.Oficodigo#-#rsSQL.Odescripcion#' ya fue asignada al Grupo '#rsSQL.GOcodigo#-#rsSQL.GOnombre#'">
					</cfif>
				</cfif>
				<cfquery datasource="#session.dsn#" name="idquery">
					insert into AnexoGOficinaDet( Ecodigo, GOid, Ocodigo,BMfecha,BMUsucodigo)
					values(	
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.GOid#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value = "#i#">,
						<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						 #session.Usucodigo# )
				</cfquery>
			</cfloop>
		</cfif>
	</cftransaction>	

	<!--- redirecciona al form en el tab 2--->
	<cfset path = "gruposOficinas-tabs.cfm?tab=2">
<form action="<cfoutput>#path#</cfoutput>" method="post" name="sql">
	<cfoutput>
		<input name="GOid" type="hidden" value="#form.GOid#"> 
		
		<cfif isdefined('form.Codigo_F') and len(trim(form.Codigo_F))>
			<input type="hidden" name="Codigo_F" value="#form.Codigo_F#">	
		</cfif>
		<cfif isdefined('form.Descripcion_F') and len(trim(form.Descripcion_F))>
			<input type="hidden" name="Descripcion_F" value="#form.Descripcion_F#">	
		</cfif>
		
	</cfoutput>
</form>

<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>

	<body>
		<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
</html>
