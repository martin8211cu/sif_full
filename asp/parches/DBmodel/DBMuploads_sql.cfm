<cfset LvarObj = createObject("component","asp.parches.DBmodel.Componentes.DBModel")>
<cfif isdefined("url.op")>
	<cfif url.op EQ 0>
		<!--- REINICIAR EL PROCESO DE XML_toUpload --->
		<cftransaction>
			<cfquery datasource="asp">
				delete from DBMkeyU
				 where 
					(
						select count(1) from DBMtabU t
						 where t.IDtab = DBMkeyU.IDtab
						   and t.IDupl = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
					)	> 0
			</cfquery>
			<cfquery datasource="asp">
				delete from DBMcolU
				 where 
					(
						select count(1) from DBMtabU t
						 where t.IDtab = DBMcolU.IDtab
						   and t.IDupl = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
					)	> 0
			</cfquery>
			<cfquery datasource="asp">
				delete from DBMtabU
				 where IDupl = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
			</cfquery>
		</cftransaction>	
		<cfset LvarPath = getTempDirectory()>
		<cfset LvarPath = LvarPath & "DBM" & numberFormat(url.id, "0000000000")>
		<cfdirectory action="list" directory="#LvarPath#" name="rsDir">
		<cfset LvarObj = createObject("component","asp.parches.DBmodel.Componentes.DBModel")>
		<cfset LvarOBJ.XML_toUpload(rsDir.Directory & "/" & rsDir.name, url.id)>
		<cflocation url="DBMuploads.cfm?chk=0">
	<cfelseif url.op EQ 1>
		<!--- Eliminar un Upload --->
		<cftransaction>
			<cfquery datasource="asp">
				delete from DBMkeyU
				 where 
					(
						select count(1) from DBMtabU t
						 where t.IDtab = DBMkeyU.IDtab
						   and t.IDupl = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
					)	> 0
			</cfquery>
			<cfquery datasource="asp">
				delete from DBMcolU
				 where 
					(
						select count(1) from DBMtabU t
						 where t.IDtab = DBMcolU.IDtab
						   and t.IDupl = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
					)	> 0
			</cfquery>
			<cfquery datasource="asp">
				delete from DBMtabU
				 where IDupl = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
			</cfquery>
			<cfquery datasource="asp">
				delete from DBMuploads
				 where IDupl = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
			</cfquery>
		</cftransaction>	
	<cfelseif url.op EQ 10>
		<!--- Consultar Resultado de Verificacion un Upload --->
		<cflocation url="DBMuploads.cfm?html=#url.id#">
	<cfelseif url.op EQ 11>
		<!--- Aceptar Cambios de un Upload --->
		<cfquery name="rsSQL" datasource="asp">
			update DBMuploads
			   set sts = 2, 
				   stsP = 0,
			       msg=null
			 where  IDupl = #url.id#
		</cfquery>
	<cfelseif url.op EQ 40>
		<!--- Download de Script --->
		<cfset LvarFile = "U" & numberFormat(url.id,"0000000000") & ".sql">
		<cfset GvarScript = expandPath("/asp/parches/DBmodel/scripts/") & LvarFile>
		<cfheader name="Content-Disposition"	value="attachment;filename=#LvarFile#">
		<cfcontent type="text/plain" reset="yes" file="#GvarScript#" deletefile="no">
	<cfelseif url.op EQ 41>
		<!--- Download de Errores del Script --->
		<cfset LvarFile = "U" & numberFormat(url.id,"0000000000") & "_err.txt">
		<cfset GvarScript = expandPath("/asp/parches/DBmodel/scripts/") & LvarFile>
		<cfheader name="Content-Disposition"	value="attachment;filename=#LvarFile#">
		<cfcontent type="text/plain" reset="yes" file="#GvarScript#" deletefile="no">
	<cfelseif url.op EQ 42>
		<!--- Download de Resultados de la Ejecución del Script --->
		<cfset LvarFile = "U" & numberFormat(url.id,"0000000000") & "_exe.txt">
		<cfset GvarScript = expandPath("/asp/parches/DBmodel/scripts/") & LvarFile>
		<cfheader name="Content-Disposition"	value="attachment;filename=#LvarFile#">
		<cfcontent type="text/plain" reset="yes" file="#GvarScript#" deletefile="no">

	<cfelseif url.op EQ 2>
		<!--- Verificar un Upload --->
		<cfthread name="DBM_UPLOAD">
			<cfset LvarObj = createObject("component","asp.parches.DBmodel.Componentes.DBModel")>
			<cfset LvarOBJ.upload_verificar(url.id)>
		</cfthread>
		<cfthread action="sleep" duration="2000"></cfthread>
	<cfelseif url.op EQ 4>
		<!--- Generar Version a partir de un Upload --->
		<cfthread name="DBM_UPLOAD">
			<cfset LvarObj = createObject("component","asp.parches.DBmodel.Componentes.DBModel")>
			<cfset LvarIDver = LvarObj.UPLOAD_toVersion (url.id)>
		</cfthread>
		<cfthread action="sleep" duration="2000"></cfthread>
	<cfelseif url.op EQ 21>
		<!--- Verificar y Generar Modificaciones en Desarrollo --->
		<cfthread name="DBM_UPLOAD">
			<cfset LvarObj = createObject("component","asp.parches.DBmodel.Componentes.DBModel")>
			<cfset LvarOBJ.upload_verificar(url.id)>
			<cfset LvarObj.UPLOAD_toDesarrollo (url.id)>
		</cfthread>
		<cfthread action="sleep" duration="2000"></cfthread>
	<cfelseif url.op EQ 22>
		<!--- Generar Modificaciones en Desarrollo --->
		<cfthread name="DBM_UPLOAD">
			<cfset LvarObj = createObject("component","asp.parches.DBmodel.Componentes.DBModel")>
			<cfset LvarObj.UPLOAD_toDesarrollo (url.id)>
		</cfthread>
		<cfthread action="sleep" duration="2000"></cfthread>


	<cfelseif url.op EQ 50>
		<!--- Download Script BASE CERO IDmod --->
		<cfquery name="rsSQL" datasource="asp">
			select u.des, u.IDver, u.fec as fecha, m.IDmod, m.modelo, s.IDsch, s.sch
			  from DBMuploads u
				inner join DBMmodelos m
					on m.IDmod = u.IDmod
				inner join DBMsch s
					on s.IDsch = m.IDsch
			 where u.IDupl = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
		</cfquery>

		<cfset LvarObj = createObject("component","asp.parches.DBmodel.Componentes.DBModel")>
		<cfset LvarDes = replace(rsSQL.des," ","_","ALL")>
		<cfset LvarScript = "SCRIPT_#LvarDes#.sql">
		<cfset LvarOBJ.script_BASECERO(LvarScript, rsSQL.IDmod, rsSQL.IDver)>

		<cfset LvarFile = replace(LvarScript,".sql",".zip")>
		<cfheader name="Content-Disposition"	value="attachment;filename=#LvarFile#">
		<cfcontent type="zip" reset="yes" file="#expandPath("/asp/parches/DBmodel/scripts/") & LvarFile#" deletefile="yes">
		<cfabort>
	<cfelseif url.op EQ 51>
		<!--- Download XML Version del Parche: IDupl --->
		<cfquery name="rsSQL" datasource="asp">
			select u.des, u.IDver, u.fec as fecha, m.IDmod, m.modelo, s.IDsch, s.sch
			  from DBMuploads u
				inner join DBMmodelos m
					on m.IDmod = u.IDmod
				inner join DBMsch s
					on s.IDsch = m.IDsch
			 where u.IDupl = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
		</cfquery>
		<cfset LvarDes = replace(rsSQL.des," ","_","ALL")>
		<cfset LvarObj = createObject("component","asp.parches.DBmodel.Componentes.DBModel")>
		<cfset LvarXML = expandPath("/asp/parches/DBmodel/scripts/") & "V_#LvarDes#.xml">
		<cfquery name="rsTabs" datasource="asp">
			select *
			  from DBMtab t
			 where (
			 		select count(1)
					  from DBMtabV tv
					 inner join DBMversiones v
					 	on v.IDver	= tv.IDver
					 where tv.IDtab	= t.IDtab
					   and tv.IDver	= #rsSQL.IDver#
					) > 0
			   and IDmodORI IS NOT NULL
		</cfquery>
		
		<cfinvoke 	component="asp.parches.DBmodel.Componentes.DBModel" 
					method		= "toXML"
					
					rsOBJECTS	= "#rsTabs#"
					archivo		= "#LvarXML#"
					fec			= "#rsSQL.fecha#"
					version		= "DBM #rsSQL.IDver#: #rsSQL.Des#"
					parche		= "UPGRADE al #dateFormat(rsSQL.fecha,'DD/MM/YYYY')#"
					IDmod		= "#rsSQL.IDmod#"
					modelo		= "#rsSQL.modelo#"
					IDsch		= "#rsSQL.IDsch#"
					sch			= "#rsSQL.sch#"
		>
		<cfheader name="Content-Disposition"	value="attachment;filename=V_#LvarDes#.xml">
		<cfcontent type="text/plain" reset="yes" file="#LvarXML#" deletefile="yes">
		<cfabort>
	</cfif>
</cfif>
<cflocation url="DBMuploads.cfm">