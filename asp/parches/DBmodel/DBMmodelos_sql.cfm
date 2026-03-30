<cfif isdefined("url.op")>
	<cfif url.op EQ 1>
		<!--- Download Script BASE CERO IDmod --->
		<cfquery name="rsSQL" datasource="asp">
			select s.IDsch, s.sch, m.IDmod, m.modelo
			  from DBMmodelos m
				inner join DBMsch s
					on s.IDsch = m.IDsch
			 where IDmod = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.IDmod#">
		</cfquery>

		<cfset LvarObj = createObject("component","asp.parches.DBmodel.Componentes.DBModel")>
		<cfset LvarScript = "BASE CERO_#replace(rsSQL.modelo,'.pdm','')#.sql">
		<cfset LvarScript = replace(LvarScript,' ','_',"ALL")>
		<cfset LvarOBJ.script_BASECERO(LvarScript, url.IDmod)>

		<cfset LvarFile = replace(LvarScript,".sql",".zip")>
		<cfheader name="Content-Disposition"	value="attachment;filename=#LvarFile#">
		<cfcontent type="zip" reset="yes" file="#expandPath("/asp/parches/DBmodel/scripts/") & LvarFile#" deletefile="yes">
		<cfabort>
	<cfelseif url.op EQ 2>
		<!--- Download XML Ultima Version: IDmod --->
		<cfquery name="rsSQL" datasource="asp">
			select s.IDsch, s.sch, m.IDmod, m.modelo,
					(
						select max(fec)
						  from DBMversiones v
						 where IDmod = m.IDmod
					) as fecha,
					(
						select max(IDver)
						  from DBMversiones v
						 where IDmod = m.IDmod
					) as IDver
			  from DBMmodelos m
				inner join DBMsch s
					on s.IDsch = m.IDsch
			 where IDmod = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.IDmod#">
		</cfquery>
		<cfset LvarObj = createObject("component","asp.parches.DBmodel.Componentes.DBModel")>
		<cfset LvarXML = expandPath("/asp/parches/DBmodel/scripts/") & "V_#rsSQL.modelo#.xml">
		<cfquery name="rsTabs" datasource="asp">
			select *
			  from DBMtab t
			 where (
			 		select count(1)
					  from DBMtabV tv
					 inner join DBMversiones v
					 	on v.IDver	= tv.IDver
					 where tv.IDtab	= t.IDtab
					   and v.IDmod	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.IDmod#">
					) > 0
			   and IDmodORI IS NOT NULL
		</cfquery>
		
		<cfinvoke 	component="asp.parches.DBmodel.Componentes.DBModel" 
					method		= "toXML"
					
					rsOBJECTS	= "#rsTabs#"
					archivo		= "#LvarXML#"
					fec			= "#rsSQL.fecha#"
					version		= "Version #rsSQL.IDver#: Actualizar hasta #dateFormat(rsSQL.fecha,'DD/MM/YYYY')#"
					parche		= "ACTUALIZACION COMPLETA #rsSQL.modelo#"
					IDmod		= "#rsSQL.IDmod#"
					modelo		= "#rsSQL.modelo#"
					IDsch		= "#rsSQL.IDsch#"
					sch			= "#rsSQL.sch#"
		>
		<cfset LvarFile = replace("V_#rsSQL.modelo#.xml",' ','_',"ALL")>
		<cfset LvarFile = replace(LvarFile,'.pdm','',"ALL")>
		<cfheader name="Content-Disposition"	value="attachment;filename=#LvarFile#">
		<cfcontent type="text/plain" reset="yes" file="#LvarXML#" deletefile="yes">
		<cfabort>
	<cfelseif url.op EQ 3>
		<!--- Eliminar modelo powerdesigner: modelo --->
		<cfquery name="rsSQL" datasource="asp">
			delete from DBMmodelos
			 where IDmod = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.IDmod#">
		</cfquery>
	<cfelseif url.op EQ 4>
		<!--- Crear Nuevo modelo powerdesigner: IDsch, modelo --->
		<cfquery name="rsSQL" datasource="asp">
			select max(IDmod)+1 as nextVal
			  from DBMmodelos
		</cfquery>
		<cfquery datasource="asp">
			insert into DBMmodelos
				(IDmod,modelo, IDsch, uidSVN, BMUsucodigo)
			values(
				 #rsSQL.nextVal#
				,<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.modelo#">
				,<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.IDsch#">
				,'pso'
				,#session.Usucodigo#
				)
		</cfquery>
	</cfif>
</cfif>
<cflocation url="DBMmodelos.cfm?x=#getTickCount()#">
