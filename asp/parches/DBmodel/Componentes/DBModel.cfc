<cfcomponent output="no">
	<cfsetting enablecfoutputonly="yes" requesttimeout="36000">
	<cfset vbCrLf	= chr(13) & chr(10)>
	<cfset GvarScript = "">
	<cfset GvarScriptTit = "">
	<cfset GvarUpdateTabsP = "">
	<cfset GvarUpdateTabsT0 = getTickCount()>
	<cfset GvarUpdateTabsT1 = getTickCount()>
	<cfset GvarUpdateTabsT2 = getTickCount()>
	<cfif not directoryExists(expandPath("/asp/parches/DBmodel/scripts"))>
		<cfdirectory action="create" directory="#expandPath("/asp/parches/DBmodel/scripts")#">
	</cfif>
	
	<cffunction name="creaTablas" access="public" output="no">
		<cfargument name="conexion" required="yes">
		<cfargument name="tipo" 	default="">
	
		<cfset LvarTempV = "5">
		<cfset LvarNULL	= "">
		
		<!--- Crea tabAnt y colAnt --->
		<cftry>
			<cfquery name="rsSQL" datasource="asp">
				select count(1) as X 
				  from DBMtab
				 where IDtab = 0
				   and tabAnt is null
			</cfquery>
		<cfcatch type="any">
			<cftry>
				<cfif Application.dsinfo["asp"].type EQ "db2">
					<cfquery name="rsSQL" datasource="sifjdbc">
						CALL SYSPROC.ADMIN_CMD ('REORG TABLE #Application.dsinfo["asp"].Schema#.DBMtab')
					</cfquery>
				</cfif>
				<cfquery name="rsSQL" datasource="asp">
					ALTER TABLE DBMtab ADD tabAnt varchar(30) #LvarNULL#
				</cfquery>
			<cfcatch type="any">
			</cfcatch>
			</cftry>
		</cfcatch>
		</cftry>

		<cftry>
			<cfquery name="rsSQL" datasource="asp">
				select count(1) as X 
				  from DBMcol
				 where IDtab = 0
				   and colAnt is null
			</cfquery>
		<cfcatch type="any">
			<cftry>
				<cfif Application.dsinfo["asp"].type EQ "db2">
					<cfquery name="rsSQL" datasource="sifjdbc">
						CALL SYSPROC.ADMIN_CMD ('REORG TABLE #Application.dsinfo["asp"].Schema#.DBMcol')
					</cfquery>
				</cfif>
				<cfquery name="rsSQL" datasource="asp">
					ALTER TABLE DBMcol ADD colAnt varchar(30) #LvarNULL#
				</cfquery>
			<cfcatch type="any">
			</cfcatch>
			</cftry>
		</cfcatch>
		</cftry>

		<cfif Arguments.tipo NEQ "BASECERO">
			<cfset LvarObjDB.CrearObjetosEspeciales(Arguments.Conexion)>
		</cfif>
		
		<cf_dbfunction name="OP_CONCAT" returnvariable="CONCAT" datasource="#Arguments.conexion#">
		<cf_dbtemp name="tabPD_V#LvarTempV#" returnvariable="tabPD" datasource="#Arguments.conexion#">
			<cf_dbtempcol name="IDtab"		    	type="numeric"		mandatory="yes" identity>
			<cf_dbtempcol name="tab"		    	type="varchar(30)"	mandatory="yes">
			<cf_dbtempcol name="des"		    	type="varchar(255)"	mandatory="yes">
			<cf_dbtempcol name="suf13"		    	type="int"			mandatory="yes">
			<cf_dbtempcol name="suf25"		    	type="int"			mandatory="yes">
			<cf_dbtempcol name="gen"		    	type="bit"			mandatory="yes">
			<cf_dbtempcol name="genVer"		    	type="bit"			mandatory="yes">
			<cf_dbtempcol name="del"		    	type="bit"			mandatory="yes">
			<cf_dbtempcol name="rul"		    	type="varchar(900)"	mandatory="no">
			<cf_dbtempcol name="OP"		    		type="integer"		mandatory="yes" default="0">
			<cf_dbtempcol name="tabAnt"		    	type="varchar(30)"	mandatory="no">
			<cf_dbtempcol name="newFKs"		    	type="bit"			mandatory="yes" default="0">
		
			<cf_dbtempkey cols="tab">
		</cf_dbtemp>
		
		<cf_dbtemp name="colPD_V#LvarTempV#" returnvariable="colPD" datasource="#Arguments.conexion#">
			<cf_dbtempcol name="tab"		    	type="varchar(30)"	mandatory="yes">
			<cf_dbtempcol name="col"		    	type="varchar(30)"	mandatory="yes">
			<cf_dbtempcol name="sec"		    	type="int"			mandatory="yes">
			<cf_dbtempcol name="des"		    	type="varchar(255)"	mandatory="no">
			<cf_dbtempcol name="tip"		    	type="varchar(2)"		mandatory="yes">
			<cf_dbtempcol name="lon"		    	type="int"			mandatory="no">
			<cf_dbtempcol name="dec"		    	type="int"			mandatory="no">
			<cf_dbtempcol name="ide"		    	type="bit"			mandatory="yes">
			<cf_dbtempcol name="obl"		    	type="bit"			mandatory="yes">
			<cf_dbtempcol name="dfl"		    	type="varchar(255)"	mandatory="no">
			<cf_dbtempcol name="ini"		    	type="varchar(255)"	mandatory="no">
			<cf_dbtempcol name="minVal"		    	type="varchar(255)"	mandatory="no">
			<cf_dbtempcol name="maxVal"		    	type="varchar(255)"	mandatory="no">
			<cf_dbtempcol name="lov"		    	type="varchar(900)"	mandatory="no">
			<cf_dbtempcol name="rul"		    	type="varchar(900)"	mandatory="no">
			<cf_dbtempcol name="genVer"		    	type="bit"			mandatory="yes">
			<cf_dbtempcol name="del"		    	type="bit"			mandatory="yes">
			<cf_dbtempcol name="FK"			    	type="bit"			mandatory="yes" default="0">
			<cf_dbtempcol name="OP"		    		type="integer"		mandatory="yes" default="0">
			<cf_dbtempcol name="colAnt"		    	type="varchar(30)"	mandatory="no">
		
			<cf_dbtempkey cols="tab,col">
		</cf_dbtemp>
	
		<cf_dbtemp name="keyPD_V#LvarTempV#" returnvariable="keyPD" datasource="#Arguments.conexion#">
			<cf_dbtempcol name="tab"		    	type="varchar(30)"	mandatory="yes">
			<cf_dbtempcol name="cols"		    	type="varchar(255)"	mandatory="yes">
			<cf_dbtempcol name="tip"		    	type="char(1)"		mandatory="yes">
			<cf_dbtempcol name="ref"		    	type="varchar(30)"	mandatory="yes">
			<cf_dbtempcol name="colsR"		    	type="varchar(255)"	mandatory="yes">
			<cf_dbtempcol name="sec"		    	type="int"			mandatory="yes">
			<cf_dbtempcol name="clu"		    	type="bit"			mandatory="yes">
			<cf_dbtempcol name="idxTip"		    	type="char(1)"		mandatory="yes">
			<cf_dbtempcol name="idx"		    	type="varchar(50)"	mandatory="no">
			<cf_dbtempcol name="gen"		    	type="bit"			mandatory="yes">
			<cf_dbtempcol name="genVer"		    	type="bit"			mandatory="yes">
			<cf_dbtempcol name="del"		    	type="bit"			mandatory="yes">
			<cf_dbtempcol name="ant"		    	type="bit"			mandatory="yes" default="0">
			<cf_dbtempcol name="keyO"		    	type="integer"		mandatory="yes">
			<cf_dbtempcol name="OP"		    		type="integer"		mandatory="yes" default="0">
		
			<cf_dbtempkey cols="tab,cols,tip,ref,colsR">
		</cf_dbtemp>

		<cf_dbtemp name="colsRPD_V#LvarTempV#" returnvariable="colsRPD" datasource="#Arguments.conexion#">
			<cf_dbtempcol name="tab"		    	type="varchar(30)"	mandatory="yes">
			<cf_dbtempcol name="cols"		    	type="varchar(255)"	mandatory="yes">
			<cf_dbtempcol name="ref"		    	type="varchar(30)"	mandatory="yes">
			<cf_dbtempcol name="colsR"		    	type="varchar(255)"	mandatory="yes">

			<cf_dbtempcol name="IDtab"		    	type="numeric"		mandatory="yes">

			<cf_dbtempcol name="niv"		    	type="int"			mandatory="yes">
			<cf_dbtempcol name="iniT"		    	type="int"			mandatory="yes">
			<cf_dbtempcol name="sigT"		    	type="int"			mandatory="yes">
			<cf_dbtempcol name="iniR"		    	type="int"			mandatory="yes">
			<cf_dbtempcol name="sigR"		    	type="int"			mandatory="yes">
		</cf_dbtemp>

		<cf_dbtemp name="colRPD_V#LvarTempV#" returnvariable="colRPD" datasource="#Arguments.conexion#">
			<cf_dbtempcol name="tab"		    	type="varchar(30)"	mandatory="yes">
			<cf_dbtempcol name="col"		    	type="varchar(255)"	mandatory="yes">
			<cf_dbtempcol name="ref"		    	type="varchar(30)"	mandatory="yes">
			<cf_dbtempcol name="colR"		    	type="varchar(255)"	mandatory="yes">

			<cf_dbtempcol name="tip"		    	type="varchar(2)"		mandatory="yes">
			<cf_dbtempcol name="lon"		    	type="int"			mandatory="yes">
			<cf_dbtempcol name="dec"		    	type="int"			mandatory="yes">
			<cf_dbtempcol name="tipN"		    	type="varchar(2)"		mandatory="yes">
			<cf_dbtempcol name="lonN"		    	type="int"			mandatory="yes">
			<cf_dbtempcol name="decN"		    	type="int"			mandatory="yes">

			<cf_dbtempcol name="OP"		    		type="integer"		mandatory="yes" default="-1">
			<cf_dbtempcol name="obl"		    	type="bit"			mandatory="yes" default="0">
			<cf_dbtempcol name="lov"		    	type="varchar(255)"	mandatory="no">
			<cf_dbtempcol name="minVal"		    	type="varchar(255)"	mandatory="no">
			<cf_dbtempcol name="maxVal"		    	type="varchar(255)"	mandatory="no">

			<cf_dbtempkey cols="tab,col,ref,colR">
		</cf_dbtemp>

		<cf_dbcreate name="DBMexternalFKs" datasource="#Arguments.conexion#">
			<cf_dbcreatecol name="tab"		    	type="varchar(30)"	mandatory="yes">
			<cf_dbcreatecol name="cols"		    	type="varchar(255)"	mandatory="yes">
			<cf_dbcreatecol name="ref"		    	type="varchar(30)"	mandatory="yes">
			<cf_dbcreatecol name="colsR"	    	type="varchar(255)"	mandatory="yes">
			<cf_dbcreatecol name="keyN"		    	type="varchar(255)"	mandatory="yes">
		
			<cf_dbcreatekey cols="tab,cols,ref,colsR">
		</cf_dbcreate>

		<cfset session.dbm.tabPD = tabPD>
		<cfset session.dbm.colPD = colPD>
		<cfset session.dbm.keyPD = keyPD>
		<cfset session.dbm.colRPD = colRPD>
	
		<cfset LvarObjDB.creaTablas(Arguments.Conexion,Arguments.Tipo)>
		<cfset tabDB	= session.dbm.tabDB>
		<cfset colDB	= session.dbm.colDB>
		<cfset keyDB	= session.dbm.keyDB>
		<cfset chkDB	= session.dbm.chkDB>
	</cffunction>
	
	<cffunction name="UPLOAD_verificar" access="public" output="no">
		<cfargument name="IDupl" required="yes">
	
		<cftry>
			<cfquery name="rsSQL" datasource="asp">
				select m.IDsch, case when m.IDsch = 1 then 'minisif' else s.sch end as sch
					, sts
					, stsP
					, tabsP
					, tabs
					, msg 
					
					, u.IDupl, u.des, s.sch as schemaN, m.modelo
					  from DBMuploads u 
					inner join DBMmodelos m on m.IDmod=u.IDmod 
					inner join DBMsch s on s.IDsch=m.IDsch
				 where u.IDupl = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDupl#">
			</cfquery>
			<cfif NOT ((rsSQL.sts EQ 1 OR rsSQL.sts EQ 2 OR rsSQL.sts EQ 3) AND (rsSQL.stsP EQ 0 OR rsSQL.stsP EQ 10 OR rsSQL.stsP EQ 11 OR rsSQL.stsP EQ 23))>
				<cfreturn>
			</cfif>
			<cfset LvarConexion = rsSQL.sch>
			<cfset LvarIDsch = rsSQL.IDsch>
	
			<cfset LvarTit =
						"SCRIPT DE BASE DE DATOS #ucase('asp')# PARA:#vbCrLf#" &
						"	SCHEMA:  #rsSQL.schemaN##vbCrLf#" &
						"	MODELO:  #rsSQL.modelo##vbCrLf#" &
						"	UPLOAD:  #rsSQL.IDupl# - #rsSQL.des##vbCrLf##vbCrLf#" &
						"GENERAR UNICAMENTE EN:#vbCrLf#" &
						"	SERVER:  http://#cgi.http_host##vbCrLf#" &
						"	DSN:     #LvarConexion##vbCrLf#" &
						"	FECHA:   #dateFormat(now(),"DD/MM/YYYY")# #timeFormat(now(),"HH:mm:ss")#"
			>
	
			<cfset LvarObjDB = createObject("component", "DBModel_#Application.dsinfo[LvarConexion].type#").init(this,LvarConexion)>
			<cfset PDs_fromUpload (LvarConexion, Arguments.IDupl)>
	
			<cfquery name="rsSQL" datasource="#LvarConexion#">
				select distinct tab, tabAnt from #tabPD#
				 where gen = 1
			</cfquery>
			<cfset DBs_fromDatabase(LvarConexion, rsSQL, "UPLOAD", Arguments.IDupl, LvarIDsch)>
	
			<cfset PDsDBs_Comparation(LvarConexion, "UPLOAD", Arguments.IDupl)>
	
			<cfset LvarRES = sbPrint_Comparation(LvarConexion,"UPLOAD")>
	
			<cfset LvarDenegar	= LvarRes.Denegar>
			<cfset LvarCambios	= LvarRes.Cambios>
			<cfset LvarHTML		= LvarRes.HTML>
	
			<cfset GvarScript = expandPath("/asp/parches/DBmodel/scripts/") & "U" & numberFormat(Arguments.IDupl,"0000000000") & ".sql">
			<cfset toScriptDB(LvarConexion, "UPLOAD", Arguments.IDupl, LvarTit)>
	
			<cfif LvarDenegar>
				<cfquery datasource="asp">
					update DBMuploads
					   set 	msg		= 'Existen objetos que deben ser definidos en PowerDesigner o borrados de desarrollo',
							stsP	= 10,		<!--- Upload Denegado --->
							tabsP 	= 0,
							html	= <cfqueryparam cfsqltype="cf_sql_clob" value="#LvarHTML#">
					 where IDupl = #Arguments.IDupl#
				</cfquery>
			<cfelseif LvarCambios>
				<cfquery datasource="asp">
					update DBMuploads
					   set 	stsP	= 11,		<!--- Cambios Encontrados a Revisar --->
							tabsP 	= tabs,
							msg		= 'Existen objetos que deben verificarse',
							html	= <cfqueryparam cfsqltype="cf_sql_clob" value="#LvarHTML#">
					 where IDupl = #Arguments.IDupl#
				</cfquery>
			<cfelse>
				<cfquery datasource="asp">
					update DBMuploads
					   set 	sts  = 3,		<!--- BASE DE DATOS ACTUALIZADA --->
							stsP = 0,
							tabsP 	= tabs,
							msg		= null
					 where IDupl = #Arguments.IDupl#
				</cfquery>
			</cfif>
		<cfcatch type="any">
			<cfset sbUPLOAD_error (cfcatch, Arguments.IDupl, "UPLOAD_verificar")>
		</cfcatch>
		</cftry>
		<CF_dbTemp_deletes>
		<!---<cfset ejecutaScript(LvarConexion)>--->
	</cffunction>
	
	<cffunction name="UPGRADE" access="public" output="no">
		<cfargument name="IDgen" required="yes" type="numeric">
		<cfargument name="tipo"  required="yes">

		<cftry>
			<cfset GvarScript = expandPath("/asp/parches/DBmodel/scripts/") & "G" & numberFormat(Arguments.IDgen,"0000000000") & ".sql">
	
			<cfquery name="rsSQL" datasource="asp">
				select g.sts, p.stsP, d.dsn, s.IDsch, s.sch as schemaN, g.IDmod, g.IDverIni, g.IDverFin, m.modelo
				  from DBMgen g
					inner join DBMgenP p
						on p.IDgen = g.IDgen
					inner join DBMdsn d
						on d.IDdsn = g.IDdsn
					inner join DBMmodelos m
						on m.IDmod = g.IDmod
					inner join DBMsch s
						on s.IDsch = m.IDsch
				 where g.IDgen = #Arguments.IDgen#
			</cfquery>

			<cfset LvarIDsch = rsSQL.IDsch>
	
			<cfif NOT (rsSQL.stsP EQ 0 OR rsSQL.stsP EQ 23)>
				<cfreturn>
			</cfif>
			<cfset LvarConexion = rsSQL.dsn>
	
			<cfif Arguments.tipo EQ "SCRIPT">
				<cfif fileExists(GvarScript)>
					<cffile action="delete" file="#GvarScript#">
				</cfif>
				<cfset GvarScriptExe = replace(GvarScript,".sql","_exe.txt")>
				<cfif fileExists(GvarScriptExe)>
					<cffile action="delete" file="#GvarScriptExe#">
				</cfif>
				<cfset GvarScriptErr = replace(GvarScript,".sql","_err.txt")>
				<cfif fileExists(GvarScriptErr)>
					<cffile action="delete" file="#GvarScriptErr#">
				</cfif>
			</cfif>
	
			<cfif not fileexists(GvarScript)>
				<cfquery datasource="asp">
					update DBMgen 
					   set sts = 1		<!--- Generacion de Script --->
					 where IDgen = #Arguments.IDgen#
				</cfquery>
				<cfquery datasource="asp">
					update DBMgenP
					   set stsP = 0
						 , msg = null
						 , tabs = 0
					 where IDgen = #Arguments.IDgen#
				</cfquery>
		
				<cfquery name="rsVers" datasource="asp">
					select IDver, des, parche
					  from DBMversiones
					 where IDver between #rsSQL.IDverIni# and #rsSQL.IDverFin#
					   and IDmod = #rsSQL.IDmod#
				</cfquery>
	
				<cfset LvarTit =
							"SCRIPT DE BASE DE DATOS #ucase('asp')# PARA:#vbCrLf#" &
							"	SCHEMA:  #rsSQL.schemaN##vbCrLf#" &
							"	MODELO:  #rsSQL.modelo##vbCrLf#" &
							"	VERSION: #rsVers.IDver# - #rsVers.des##vbCrLf##vbCrLf#" &
							"	         PARCHE:  #rsVers.parche##vbCrLf##vbCrLf#" &
							"GENERAR UNICAMENTE EN:#vbCrLf#" &
							"	SERVER:  http://#cgi.http_host##vbCrLf#" &
							"	DSN:     #LvarConexion##vbCrLf#" &
							"	FECHA:   #dateFormat(now(),"DD/MM/YYYY")# #timeFormat(now(),"HH:mm:ss")#"
				>
		
				<cfset LvarObjDB = createObject("component", "DBModel_#Application.dsinfo[LvarConexion].type#").init(this,LvarConexion)>

				<cfset PDs_fromVersions (LvarConexion, "UPGRADE", Arguments.IDgen)>

		
				<cfquery name="rsSQL" datasource="#LvarConexion#">
					select distinct tab, tabAnt from #tabPD#
					 where gen = 1
				</cfquery>
				<cfset DBs_fromDatabase(LvarConexion, rsSQL, "UPGRADE", Arguments.IDgen, LvarIDsch)>
		
				<cfset PDsDBs_Comparation(LvarConexion, "UPGRADE", Arguments.IDgen)>
				
				<cfquery datasource="#LvarConexion#">
					delete from DBMexternalFKs
					 where (
					 		select count(1)
							  from #keyDB#
							 where tab 	 = DBMexternalFKs.tab
							   and cols  = DBMexternalFKs.cols
							   and ref	 = DBMexternalFKs.ref
							   and colsR = DBMexternalFKs.colsR
							   and tip in ('F','D')
							   and OP <> 3
							) > 0
				</cfquery>
				<cfquery datasource="#LvarConexion#">
					insert into DBMexternalFKs (tab,cols,ref,colsR,keyN)
					select tab,cols,ref,colsR,keyN
					  from #keyDB# k
					 where tip = 'D'
					   and OP = 3
					   and (
					 		select count(1)
							  from DBMexternalFKs fk
							 where fk.tab	= k.tab
							   and fk.cols	= k.cols
							   and fk.ref	= k.ref
							   and fk.colsR	= k.colsR
							) = 0
				</cfquery>
		
				<cfset LvarRES = sbPrint_Comparation(LvarConexion,"UPGRADE")>
		
				<cfif NOT LvarRES.Cambios>
					<cfset sbUPGRADE_ACTUALIZADO(LvarConexion, Arguments.IDgen)>
					<cfreturn>
				</cfif>
				
				<cfset GvarHTML = replace(GvarScript,".sql",".htm")>
				<cffile file="#GvarHTML#" output="#LvarRes.HTML#" action="write">
		
				<cfset toScriptDB(LvarConexion, "UPGRADE", Arguments.IDgen, LvarTit)>
	
				<cfquery datasource="asp">
					update DBMgen 
					   set sts = 2					<!--- Script Generado --->
					 where IDgen = #Arguments.IDgen#
				</cfquery>
				<cfquery datasource="asp">
					update DBMgenP
					   set stsP = 0
						 , tabsP = tabs
					 where IDgen = #Arguments.IDgen#
				</cfquery>
			</cfif>
			<cfif Arguments.tipo EQ "UPGRADE">
				<cfset LvarOK = toDatabase(LvarConexion, "UPGRADE", Arguments.IDgen)>
			</cfif>
		<cfcatch type="any">
			<cfset LvarError = fnFuenteLinea(cfcatch)>
			<cfset LvarFile = replace(GvarScript,".sql",".err")>
			<cffile file="#LvarFile#" action="write" output="ERROR EN UPGRADE: #cfcatch.Message#: #cfcatch.Detail# #LvarError#">
			<cf_jdbcquery_open update="yes" datasource="asp">
				<cfoutput>
				update DBMgenP
				   set msg = #fnSQLstring("#cfcatch.Message#: #cfcatch.Detail# #LvarError#",500)#
					 , stsP = 0
					 , tabsP = 0
				 where IDgen = #Arguments.IDgen#
				</cfoutput>
			</cf_jdbcquery_open>
		</cfcatch>
		</cftry>
		<CF_dbTemp_deletes>
		<!---<cfset ejecutaScript(LvarConexion)>--->
	</cffunction>
	
	<cffunction name="UPDATEtablas" access="public" output="yes">
		<cfargument name="conexion" required="yes">
		<cfargument name="IDsch" 	required="yes">
		<cfargument name="tablas" 	required="yes">
		<cfargument name="gen" 		required="yes" type="numeric">
	
		<cfset LvarConexion = Arguments.conexion>
	
		<cfset GvarScript = expandPath("/asp/parches/DBmodel/scripts/") & "UPDATE.sql">
		<cfif Arguments.gen EQ 2>
			<cfset LvarOK = toDatabase(LvarConexion, "XML", 0)>
			<CF_dbTemp_deletes>
			<cfabort>
		</cfif>
	
		<cfset LvarTit =
					"SCRIPT DE BASE DE DATOS #ucase(Application.dsinfo[LvarConexion].type)# PARA:#vbCrLf#" &
					"GENERAR UNICAMENTE EN:#vbCrLf#" &
					"	SERVER:  http://#cgi.http_host##vbCrLf#" &
					"	DSN:     #LvarConexion##vbCrLf#" &
					"	FECHA:   #dateFormat(now(),"DD/MM/YYYY")# #timeFormat(now(),"HH:mm:ss")#"
		>
	
		<cfset LvarObjDB = createObject("component", "DBModel_#Application.dsinfo[LvarConexion].type#").init(this,LvarConexion)>
		<cfset PDs_fromVersions (LvarConexion, "UPDATE", Arguments.IDsch, 0, Arguments.tablas)>
	
		<cfquery name="rsSQL" datasource="#LvarConexion#">
			select distinct tab, tabAnt from #tabPD#
			 where gen = 1
		</cfquery>
		<cfset DBs_fromDatabase(LvarConexion, rsSQL, "XML","0",Arguments.IDsch)>
		<cfif Arguments.gen EQ -1>
			<cfquery name="rsSQL" datasource="#LvarConexion#">
				select * from #tabPD#
			</cfquery>
			<cfdump var="#rsSQL#">
			<cfquery name="rsSQL" datasource="#LvarConexion#">
				select distinct * from #keyPD#
			</cfquery>
			<cfdump var="#rsSQL#">
			<cfquery name="rsSQL" datasource="#LvarConexion#">
				select distinct * from #keyDB#
			</cfquery>
			<cfdump var="#rsSQL#">
			<cfquery name="rsSQL" datasource="asp">
				select distinct * from DBMkey c 
				where (select count(1) from DBMtab where IDtab=c.IDtab and tab in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.tablas#" list="yes">) )>0
			</cfquery>
			<cf_dump var="#rsSQL#">
		</cfif>
		
		<cfset PDsDBs_Comparation(LvarConexion, "XML", "0")>
	
		<cfset LvarRES = sbPrint_Comparation(LvarConexion,"XML")>
	
		<cfset GvarHTML = replace(GvarScript,".sql",".htm")>
		<cffile file="#GvarHTML#" output="#LvarRes.HTML#" action="write">
		<cfset LvarDenegar	= LvarRes.Denegar>
		<cfset LvarCambios	= LvarRes.Cambios>
		<cfset LvarHTML		= LvarRes.HTML>
	
		<cfset toScriptDB(LvarConexion, "XML", "0", LvarTit)>
	
		<cfif Arguments.gen EQ 1>
			<cfset LvarOK = toDatabase(LvarConexion, "XML", 0)>
		</cfif>
		<CF_dbTemp_deletes>
	</cffunction>

	<cffunction name="sbPrint_Comparation" access="private" output="no" returntype="struct">
		<cfargument name="Conexion" required="yes">
		<cfargument name="TIPO" required="yes">
	
		<cfset LvarTabsP = fnUpdateTabsP(Arguments.tipo, 0, "-1", false, "sbPrint_Comparation")>
		<cfset LvarConexion = Arguments.Conexion>
		<cfset LvarDenegar = false>
		<cfset LvarCambios = false>
		<cfset LvarHTMLidx = "">
		<cfset LvarHTML = "">
	
		<cfif Arguments.tipo EQ "UPLOAD">
			<!---
				VISTAS
				colsIgn OP = 10
				colsLst OP = 10
				keysLst OP = 10
				keysDel OP = 5
				colsChg OP = 3 AND (pd.rul='' OR pd.dfl='')
				ChksDel OP = 4
			--->
				
			<!--- TABLAS QUE DEBEN SER INCLUIDAS EN EL UPLOAD --->
			<cfquery name="rsSQL" datasource="#LvarConexion#">
				select tab, rul
				  from #tabPD# p
				 where newFKs = 1
				order by 1
			</cfquery>
			<cfif rsSQL.recordCount GT 0>
				<cfset LvarDenegar = true>
				<cfset LvarHTMLidx	&= "- <A href='##TABs_INC'><font color=""##FF0000"">Tablas que deben incluirse en el UPLOAD</font></A><BR>">
				<cfset LvarHTML &= fnPrintTABs(rsSQL,"<A name='TABs_INC'><font color=""##FF0000"">TABLAS QUE TABLAS QUE DEBEN INCLUIRSE EN EL UPLOAD PORQUE HACEN REFERENCIA A UN PK O AK QUE FUE MODIFICADO</font></A>")>
			</cfif>
	
			<!--- VISTAS EN DESARROLLO DEFINIDAS COMO TABLAS EN POWERDESIGNER --->
			<cfquery name="rsSQL" datasource="#LvarConexion#">
				select tab, rul
				  from #tabPD# t
					inner join sysobjects o
					 on t.tab = o.name
				 where o.type <> 'U'
				   and t.gen = 1
				order by 1
			</cfquery>
			<cfif rsSQL.recordCount GT 0>
				<cfset LvarDenegar = true>
				<cfset LvarHTMLidx	&= "- <A href='##VISTAS'><font color=""##FF0000"">Vistas definidas como tablas en PowerDesigner</font></A><BR>">
				<cfset LvarHTML		&= fnPrintTABs(rsSQL,"<A name='VISTAS'><font color=""##FF0000"">VISTAS EN DESARROLLO QUE ESTAN DEFINIDAS COMO TABLAS EN POWER DESIGNER. Deben ser incluidas en Power Designer o borradas de Desarrollo.</font></A>")>
			</cfif>
			
			<!--- COLs PERDIDAS EN POWER DESIGNER --->
			<cfset rsSQL = fnGetCOLsLst(LvarConexion,"")>
			<cfif rsSQL.recordCount GT 0>
				<cfset LvarDenegar = true>
				<cfset LvarHTMLidx	&= "- <A href='##COLs_LST'><font color=""##FF0000"">Columnas eliminadas en PowerDesigner</font></A><BR>">
				<cfset LvarHTML &= fnPrintCOLs(rsSQL,"<A name='COLs_LST'><font color=""##FF0000"">COLUMNAS DBM QUE FUERON ELIMINADAS EN POWER DESIGNER PERO YA FUERON GENERADAS EN UNA VERSION. Debe volveralas a incluir en PowerDesigner y si desea definir 'DBM:DROP'.</font></A>")>
			</cfif>		
	
			<!--- COLs NO EXISTENTES EN POWER DESIGNER --->
			<cfset rsSQL = fnGetColsIgn(LvarConexion,"")>
			<cfif rsSQL.recordCount GT 0>
				<cfset LvarDenegar = true>
				<cfset LvarHTMLidx	&= "- <A href='##COLs_ND'><font color=""##FF0000"">Columnas no definidas en PowerDesigner</font></A><BR>">
				<cfset LvarHTML &= fnPrintCOLs(rsSQL,"<A name='COLs_ND'><font color=""##FF0000"">COLUMNAS EN DESARROLLO QUE NO ESTAN DEFINIDAS EN POWER DESIGNER. Deben ser incluidas en Power Designer o borradas de Desarrollo.</font></A>")>
			</cfif>		
	
			<!--- KEYs PERDIDAS EN POWER DESIGNER --->
			<cfset rsSQL = fnGetKeysLst(LvarConexion, "")>
			<cfif rsSQL.recordCount GT 0>
				<cfset LvarDenegar = true>
				<cfset LvarHTMLidx	&= "- <A href='##KEYs_LST'><font color=""##FF0000"">Llaves eliminadas en PowerDesigner</font></A><BR>">
				<cfset LvarHTML &= fnPrintKEYs(rsSQL,"<A name='KEYs_LST'><font color=""##FF0000"">LLAVES DBM QUE FUERON ELIMINADAS EN POWER DESIGNER PERO YA FUERON GENERADAS EN UNA VERSION. Debe volveralas a incluir en PowerDesigner y si desea definir 'DBM:DROP'.</font></A>")>
			</cfif>
	
			<!--- KEYs NO EXISTENTES EN POWER DESIGNER --->
			<cfset rsSQL = fnGetKeysDelChg(LvarConexion, "", "Y")>
			<cfif rsSQL.recordCount GT 0>
				<cfset LvarDenegar = true>
				<cfset LvarHTMLidx	&= "- <A href='##KEYs_ND'><font color=""##FF0000"">Llaves no definidas en PowerDesigner</font></A><BR>">
				<cfset LvarHTML &= fnPrintKEYs(rsSQL,"<A name='KEYs_ND'><font color=""##FF0000"">LLAVES EN DESARROLLO QUE NO ESTAN DEFINIDAS EN POWER DESIGNER. Deben ser incluidas en Power Designer o borradas de Desarrollo.</font></A>")>
			</cfif>
	
			<!--- COLs CON DEFAULT O REGLA NO EXISTENTES EN POWER DESIGNER --->
			<cfset rsSQL = fnGetColsChg(LvarConexion,"","Y")>
			<cfif rsSQL.recordCount GT 0>
				<cfset LvarDenegar = true>
				<cfset LvarHTMLidx	&= "- <A href='##COLs_CHG_D'><font color=""##FF0000"">Columnas modificadas (sin default o regla)</font></A><BR>">
				<cfset LvarHTML &= fnPrintCOLs2(rsSQL,arguments.TIPO,"<A name='COLs_CHG_D'><font color=""##FF0000"">COLUMNAS EN DESARROLLO CON DEFAULT O REGLA NO DEFINIDOS EN POWER DESIGNER. Deben ser incluidas en Power Designer o borradas de Desarrollo.</font></A>")>
			</cfif>
		
			<!--- REGLAS A NIVEL DE TABLA NO EXISTENTES EN POWER DESIGNER --->
			<cfset rsSQL = fnGetChksDel(LvarConexion, "")>
			<cfif rsSQL.recordCount GT 0>
				<cfset LvarDenegar = true>
				<cfset LvarHTMLidx	&= "- <A href='##CHKs_DEL'><font color=""##FF0000"">Reglas no definidas en PowerDesigner</font></A><BR>">
				<cfset LvarHTML &= fnPrintCHKs(rsSQL,"<A name='CHKs_DEL'><font color=""##FF0000"">REGLAS A NIVEL DE TABLA MODIFICADAS EN POWER DESIGNER. Deben ser incluidas en Power Designer o borradas de Desarrollo.</font></A>")>
			</cfif>
		</cfif>
	
		<!---
			colsChg
			
			tabsDel
			chksDel
			colsDel
			keysDel
			
			tabsAdd
			chksAdd
			colsAdd
			keysAdd
			
			idxFKs
			Renames
		--->
	
		<!--- COLs MODIFICADAS EN POWER DESIGNER --->
		<cfif Arguments.tipo EQ "UPLOAD">
			<cfset rsSQL = fnGetColsChg(LvarConexion,"", "N")>
		<cfelse>
			<cfset rsSQL = fnGetColsChg(LvarConexion,"")>
		</cfif>
		<cfif rsSQL.recordCount GT 0>
			<cfset LvarCambios = true>
			<cfset LvarHTMLidx	&= "- <A href='##COLs_CHG'>Columnas a modificarse</A><BR>">
			<cfset LvarHTML &= fnPrintCOLs2(rsSQL,arguments.TIPO,"<A name='COLs_CHG'>COLUMNAS QUE VAN A SER ALTERADAS EN LA BASE DE DATOS PORQUE TIENEN CARACTERISTICAS MODIFICADAS EN EL MODELO DBM</A>")>
		</cfif>
	
		<!--- COLs NUEVAS DE POWER DESIGNER --->
		<cfset rsSQL = fnGetColsAdd(LvarConexion,"")>
		<cfif rsSQL.recordCount GT 0>
			<cfset LvarCambios = true>
			<cfset LvarHTMLidx	&= "- <A href='##COLs_ADD'>Columnas nuevas</A><BR>">
			<cfset LvarHTML &= fnPrintCOLs(rsSQL,"<A name='COLs_ADD'>COLUMNAS NUEVAS EN EL MODELO DBM QUE SE VAN A CREAR EN LA BASE DE DATOS</A>")>
		</cfif>
	
		<cfif Arguments.tipo EQ "UPLOAD">
			<!--- TABs NO GENERAR VERSION --->
			<cfquery name="rsSQL" datasource="#LvarConexion#">
				select tab, rul
				  from #tabPD# p
				 where genVer = 0
				order by 1
			</cfquery>
			<cfif rsSQL.recordCount GT 0>
				<cfset LvarCambios = true>
				<cfset LvarHTMLidx	&= "- <A href='##TABs_DESA'>Tablas para Desarrollo que no se incluirán en la Versión</A><BR>">
				<cfset LvarHTML &= fnPrintTABs(rsSQL,"<A name='TABs_DESA'>TABLAS DEFINIDAS COMO 'DBM:DESARROLLO' EN POWER DESIGNER (Se van a generar en Desarrollo pero No se van a incluir en la Version)</A>")>
			</cfif>
		
			<!--- COLs NO GENERAR VERSION --->
			<cfquery name="rsSQL" datasource="#LvarConexion#">
				select p.tab, p.sec, p.col, p.tip, p.lon, p.dec, p.obl, p.dfl, p.rul, p.ide
				  from #colPD# p
					inner join #tabPD# t 
						 on t.tab 	 = p.tab 
						and t.genVer = 1
				 where p.genVer = 0
				order by 1,2
			</cfquery>
			<cfif rsSQL.recordCount GT 0>
				<cfset LvarCambios = true>
				<cfset LvarHTMLidx	&= "- <A href='##COLs_DESA'>Columnas para Desarrollo que no se incluirán en la Versión</A><BR>">
				<cfset LvarHTML &= fnPrintCOLs(rsSQL,"<A name='COLs_DESA'>COLUMNAS DEFINIDAS COMO 'DBM:DESARROLLO' EN POWER DESIGNER (Se van a generar en Desarrollo pero No se van a incluir en la Version)</A>")>
			</cfif>
		
			<!--- KEYs NO GENERAR EN VERSION --->
			<cfquery name="rsSQL" datasource="#LvarConexion#">
				select 	k.tab,		k.keyO,	k.OP, 
						k.tip,		k.cols,	k.ref, 		k.colsR, 
						k.sec,		k.clu,	k.idxTip,
						t.suf13,	t.suf25
				  from #keyPD# k
					inner join #tabPD# t 
						 on t.tab 	 = k.tab 
						and t.genVer = 1
				 where k.genVer = 0
				order by 1,2
			</cfquery>
			<cfif rsSQL.recordCount GT 0>
				<cfset LvarCambios = true>
				<cfset LvarHTMLidx	&= "- <A href='##KEYs_DESA'>Llaves para Desarrollo que no se incluirán en la Versión</A><BR>">
				<cfset LvarHTML &= fnPrintKEYs(rsSQL,"<A name='KEYs_DESA'>LLAVES DEFINIDAS COMO 'DBM:DESARROLLO' EN POWER DESIGNER (Se van a generar en Desarrollo pero No se van a incluir en la Version)</A>")>
			</cfif>
		</cfif>
	
		<!--------------------------------------------------------------------->
		
		<!--- TABs A BORRAR --->
		<cfquery name="rsSQL" datasource="#LvarConexion#">
			select tab, rul
			  from #tabPD# p
			 where OP = 4
			   AND newFKs = 0
			order by 1
		</cfquery>
		<cfif rsSQL.recordCount GT 0>
			<cfset LvarCambios = true>
			<cfset LvarHTMLidx	&= "- <A href='##TABs_DEL'>Tablas a eliminarse</A><BR>">
			<cfset LvarHTML &= fnPrintTABs(rsSQL,"<A name='TABs_DEL'>TABLAS QUE VAN A SER ELIMINADAS EN LA BASE DE DATOS PORQUE YA NO SE REQUIEREN EN EL MODELO DBM</A>")>
		</cfif>
	
		<cfif Arguments.tipo NEQ "UPLOAD">
			<!--- REGLAS A NIVEL DE TABLA NO EXISTENTES EN POWER DESIGNER --->
			<cfset rsSQL = fnGetChksDel(LvarConexion, "")>
			<cfif rsSQL.recordCount GT 0>
				<cfset LvarCambios = true>
				<cfset LvarHTMLidx	&= "- <A href='##CHKs_DEL'>Reglas a eliminarse</A><BR>">
				<cfset LvarHTML &= fnPrintCHKs(rsSQL,"<A name='CHKs_DEL'>REGLAS A NIVEL DE TABLA QUE VAN A SER ELIMINADAS EN LA BASE DE DATOS PORQUE NO ESTAN DEFINIDAS EN EL MODELO DBM</A>")>
			</cfif>
		</cfif>
	
		<!--- COLUMNAS DEFINIDAS COMO BORRAR EN POWER DESIGNER --->
		<cfset rsSQL = fnGetColsDel(LvarConexion,"")>
		<cfif rsSQL.recordCount GT 0>
			<cfset LvarCambios = true>
			<cfset LvarHTMLidx	&= "- <A href='##COLs_DEL'>Columnas a eliminarse</A><BR>">
			<cfset LvarHTML &= fnPrintCOLs(rsSQL,"<A name='COLs_DEL'>COLUMNAS QUE VAN A SER ELIMINADAS EN LA BASE DE DATOS PORQUE YA NO SE REQUIEREN EN EL MODELO DBM</A>")>
		</cfif>		
	
		<!--- KEYs A ELIMINAR --->
		<cfif Arguments.TIPO EQ "UPLOAD">
			<cfset rsSQL = fnGetKeysDelChg(LvarConexion, "", "N")>
		<cfelse>
			<cfset rsSQL = fnGetKeysDelChg(LvarConexion, "")>
		</cfif>
		<cfif rsSQL.recordCount GT 0>
			<cfset LvarCambios = true>
			<cfset LvarHTMLidx	&= "- <A href='##KEYs_DEL'>Llaves a eliminarse</A><BR>">
			<cfset LvarHTML &= fnPrintKEYs(rsSQL,"<A name='KEYs_DEL'>LLAVES QUE SE VAN A ELIMINAR</A>")>
		</cfif>
	
		<!--------------------------------------------------------------------->
	
		<!--- TABs NUEVAS DE POWER DESIGNER --->
		<cfquery name="rsSQL" datasource="#LvarConexion#">
			select tab, rul
			  from #tabPD# p
			 where OP = 1
			order by 1
		</cfquery>
		<cfif rsSQL.recordCount GT 0>
			<cfset LvarCambios = true>
			<cfset LvarHTMLidx	&= "- <A href='##TABs_ADD'>Tablas nuevas</A><BR>">
			<cfset LvarHTML &= fnPrintTABs(rsSQL,"<A name='TABs_ADD'>TABLAS NUEVAS EN EL MODELO DBM QUE SE VAN A CREAR EN LA BASE DE DATOS</A>")>
		</cfif>
	
		<!--- REGLAS A NIVEL DE TABLA NUEVAS EN POWER DESIGNER --->
		<cfset rsSQL = fnGetChksAdd(LvarConexion, "")>
		<cfif rsSQL.recordCount GT 0>
			<cfset LvarCambio = true>
			<cfset LvarHTMLidx	&= "- <A href='##CHKs_ADD'>Reglas nuevas</A><BR>">
			<cfset LvarHTML &= fnPrintCHKs(rsSQL,"<A name='CHKs_ADD'>REGLAS A NIVEL DE TABLA NUEVAS EN POWER DESIGNER.</font></A>")>
		</cfif>
	
		<!--- KEYs NUEVAS EN POWER DESIGNER --->
		<cfset rsSQL = fnGetKeysAddChg(LvarConexion,"")>
		<cfif rsSQL.recordCount GT 0>
			<cfset LvarCambios = true>
			<cfset LvarHTMLidx	&= "- <A href='##KEYs_ADD'>Llaves nuevas o a regenerarse</A><BR>">
			<cfset LvarHTML &= fnPrintKEYs(rsSQL,"<A name='COLs_ADD'>LLAVES QUE SE VAN A CREAR.</font></A>")>
		</cfif>
	
		<!--- DEPENDENCIAS EXTERNAS --->
		<cfquery name="rsSQL" datasource="#LvarConexion#">
			select e.*, '' as idx, 0 as sec, 1 as ext, 'F' as tip, -1 as OP
			  from DBMexternalFKs e
		</cfquery>
		<cfif rsSQL.recordCount GT 0>
			<cfset LvarCambios = true>
			<cfset LvarHTMLidx	&= "- <A href='##COLs_ADD'>Referencias Externas que deben agregarse manualmente</A><BR>">
			<cfset LvarHTML &= fnPrintKEYs(rsSQL,"<A name='COLs_ADD'>REFERENCIAS EXTERNAS AL MODELO DBM ELIMINADAS DE LA BASE DE DATOS Y QUE DEBEN CREARSE MANUALMENTE</A>")>
		</cfif>

		<!--------------------------------------------------------------------->
	
		<!--- INDICES PARA FKs --->
		<cfset rsSQL = fnGetKeysAddChg(LvarConexion,"" , true)>
		<cfif rsSQL.recordCount GT 0>
			<cfset LvarCambios = true>
			<cfset LvarHTMLidx	&= "- <A href='##KEYs_FI'>Indices para llaves foráneas</A><BR>">
			<cfset LvarHTML &= fnPrintKEYs(rsSQL,"<A name='KEYs_FI'>INDICES QUE SE VAN A CREAR EN LA BASE DE DATOS PARA SOPORTAR LLAVES FORANEAS</A>",true)>
		</cfif>
	
		<!--- OBJETOS A RENOMBRAR --->
		<cfset rsSQL = fnGetRenames(LvarConexion,"")>
		<cfif rsSQL.recordCount GT 0>
			<cfset LvarCambios = true>
			<cfset LvarHTMLidx	&= "- <A href='##RENAMES'>Objetos a Renombrase</A><BR>">
			<cfset LvarHTML &= fnPrintRenames(rsSQL,"<A name='RENAMES'>OBJETOS QUE SE VAN A RENOMBRAR EN LA BASE DE DATOS PORQUE SU NOMENCLATURA NO SIGUE LOS STANDARES DBM</A>")>
		</cfif>		
	
		<!--------------------------------------------------------------------->
	
		<cfset LvarRes = structNew()>
		<cfset LvarRes.Denegar	= LvarDenegar>
		<cfset LvarRes.Cambios	= LvarCambios>
		<cfif NOT (LvarDenegar OR LvarCambios)>
			<cfset LvarRes.HTML		= "No se encontraron cambios en la base de datos">
		<cfelse>
			<cfset LvarRes.HTML		= "<strong>INDICE:</strong><BR>#LvarHTMLidx#<BR><BR>#LvarHTML#">
		</cfif>
		
		<cfreturn LvarRes>
	</cffunction>
	
	<!--- Reglas a Nivel de Tabla a eliminar (tablas existentes) --->
	<cffunction name="fnGetChksDel" output="no" access="private" returntype="query">
		<cfargument name="conexion" required="yes">
		<cfargument name="tabla"	default="">
	
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select tab, chk, rul, OP
			  from #chkDB#
			 where OP = 4
			<cfif Arguments.tabla NEQ "">
			   and tab = <cfqueryparam  cfsqltype="cf_sql_varchar" value="#Arguments.tabla#">
			</cfif>
			order by tab, chk
		</cfquery>
	
		<cfreturn rsSQL>
	</cffunction>

	<!--- Reglas a Nivel de Tabla a agregar (tablas existentes) --->
	<cffunction name="fnGetChksAdd" output="no" access="private" returntype="query">
		<cfargument name="conexion" required="yes">
		<cfargument name="tabla"	default="">
	
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select tab, chk, rul, OP
			  from #chkDB#
			 where OP = 2
			<cfif Arguments.tabla NEQ "">
			   and tab = <cfqueryparam  cfsqltype="cf_sql_varchar" value="#Arguments.tabla#">
			</cfif>
			order by tab, chk
		</cfquery>
	
		<cfreturn rsSQL>
	</cffunction>
	
	<!--- Columnas a agregar (tablas existentes) --->
	<cffunction name="fnGetColsAdd" output="no" access="private" returntype="query">
		<cfargument name="conexion" required="yes">
		<cfargument name="tabla"	default="">
		
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select 	
				<cfif Arguments.tabla EQ "">
					case when sec<1000 then 1 else 2 end as orden, 
				</cfif>
					tab, sec, col, des, tip, lon, dec, ide, obl, dfl, rul, lov, OP
			  from #colPD# p
			 where OP = 2
			   and del=0
			<cfif Arguments.tabla NEQ "">
			   and p.tab = <cfqueryparam  cfsqltype="cf_sql_varchar" value="#Arguments.tabla#">
			</cfif>
			order by 1,2
		</cfquery>
	
		<cfreturn rsSQL>
	</cffunction>
	
	<!--- Columnas a modificar (tablas existentes) --->

	<cffunction name="fnGetColsChg" output="no" access="private" returntype="query">
		<cfargument name="conexion" required="yes">
		<cfargument name="tabla"	default="">
		<cfargument name="denegado"	default="">		<!--- Y=UPLOAD DENEGADO, N=UPLOAD NO DENEGADO --->
	
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select p.tab, p.col, p.des, d.OP
				 , p.tip as tipP, p.lon as lonP, p.dec as decP, p.obl as oblP, p.dfl as dflP, p.ide as ideP, p.rul as rulP, p.lov as lovP, p.sec as secP
				 , d.tip as tipD, d.lon as lonD, d.dec as decD, d.obl as oblD, d.dfl as dflD, d.dflN as dflND, d.ide as ideD, d.rul as rulD, d.chk as chkD
				 , d.colAnt
			<cfif Application.dsinfo[Arguments.Conexion].type EQ "db2">
				 ,d.ideT
			<cfelse>
				,'*' as ideT
			</cfif>
			  from #colPD# p
				inner join #colDB# d
					on d.tab = p.tab
				   and d.col = p.col
			<cfif Application.dsinfo[Arguments.Conexion].type EQ "db2">
				   and (d.OP = 3 OR d.ideT = 'D')
			<cfelse>
				   and d.OP = 3
			</cfif>
			<cfif Arguments.tabla NEQ "">
				   and p.tab = <cfqueryparam  cfsqltype="cf_sql_varchar" value="#Arguments.tabla#">
			   order by p.ide, p.sec
			<cfelse>
				<cfif Arguments.Denegado EQ "Y">
					<!--- (SE ELIMINA UN dfl o UNA rul)--->
					   and (d.dfl IS NOT NULL AND p.dfl IS NULL OR d.rul IS NOT NULL AND p.rul IS NULL and p.tip <> 'L')
				<cfelseif Arguments.Denegado EQ "N">
					<!--- (CAMBIOS SIN QUE SE ELIMINE UN dfl o UNA rul)--->
					   and NOT (d.dfl IS NOT NULL AND p.dfl IS NULL OR d.rul IS NOT NULL AND p.rul IS NULL)
				</cfif>
			   order by p.tab, p.sec
			</cfif>
		</cfquery>
	
		<cfreturn rsSQL>
	</cffunction>
	
	<!--- Tablas a borrar (tablas existentes) --->
	<cffunction name="fnGetTabsDel" output="no" access="private" returntype="query">
		<cfargument name="conexion" required="yes">
	
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			select t.tab, chk.rul, t.OP
			  from #tabDB# t
				left join #chkDB# chk
					 on chk.tab = t.tab
					and chk.OP = 0
			 where t.OP = 4
			order by 1
		</cfquery>
	
		<cfreturn rsSQL>
	</cffunction>
	
	
	<!--- Columnas a borrar (tablas existentes) --->
	<cffunction name="fnGetColsDel" output="no" access="private" returntype="query">
		<cfargument name="conexion" required="yes">
		<cfargument name="tabla"	default="">
	
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			select d.tab, d.col, p.des, d.tip, d.lon, d.dec, d.obl, d.dfl, d.ide, d.rul, d.chk, d.OP, d.dflN
			  from #colDB# d
				left join #colPD# p
					 on p.tab = d.tab
					and p.col = d.col
			 where d.OP = 4
			<cfif Arguments.tabla NEQ "">
			   and d.tab = <cfqueryparam  cfsqltype="cf_sql_varchar" value="#Arguments.tabla#">
			</cfif>
			order by 1,2
		</cfquery>
	
		<cfreturn rsSQL>
	</cffunction>
	
	<!--- Columnas a Ignorar Deben definirse en POWER DESIGNER (tablas existentes) --->
	<cffunction name="fnGetCOLsIgn" output="no" access="private" returntype="query">
		<cfargument name="conexion" required="yes">
		<cfargument name="tabla"	default="">
	
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			select tab, col, tip, lon, dec, obl, dfl, ide, rul, OP
			  from #colDB#
			 where OP = 10
			   and coalesce ((select newFKs from #tabPD# where tab=#colDB#.tab),0)=0
			<cfif Arguments.tabla NEQ "">
			   and tab = <cfqueryparam  cfsqltype="cf_sql_varchar" value="#Arguments.tabla#">
			</cfif>
			order by 1,2
		</cfquery>
	
		<cfreturn rsSQL>
	</cffunction>
	
	<!--- Columnas PERDIDAS que fueron generadas en version y no estan definidas en PowerDesigner --->
	<cffunction name="fnGetCOLsLst" output="no" access="private" returntype="query">
		<cfargument name="conexion" required="yes">
		<cfargument name="tabla"	default="">
	
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			select tab, col, tip, lon, dec, obl, dfl, ide, rul, OP
			  from #colPD#
			 where OP = 10
			   and coalesce ((select newFKs from #tabPD# where tab=#colPD#.tab),0)=0
			<cfif Arguments.tabla NEQ "">
			   and tab = <cfqueryparam  cfsqltype="cf_sql_varchar" value="#Arguments.tabla#">
			</cfif>
			order by 1,2
		</cfquery>
	
		<cfreturn rsSQL>
	</cffunction>
	
	<!--- LLaves que fueron generadas en version y no estan definidas en PowerDesigner --->
	<cffunction name="fnGetKEYsLst" output="no" access="private" returntype="query">
		<cfargument name="conexion" required="yes">
		<cfargument name="tabla"	default="">
	
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select 	k.tab,		k.keyO,	k.OP, 
					k.tip,		k.cols,	k.ref, 		k.colsR, 
					k.sec,		k.clu,	k.idxTip,
					t.suf13,	t.suf25,
					k.OP,		k.ant
			  from #keyPD# k
				inner join #tabPD# t
					 on t.tab = k.tab
					and t.newFKs = 0
			 where k.OP = 10
			   and k.del = 0
			 order by k.tab, k.keyO, k.sec
		</cfquery>
	
		<cfreturn rsSQL>
	</cffunction>
	
	<!--- Llaves nuevas a agregar o a regenerar (tablas existentes) OP: 2=Add, 3=Chg --->
	<cffunction name="fnGetKeysAddChg"  access="private" output="no" returntype="query">
		<cfargument name="conexion" required="yes">
		<cfargument name="tabla" 	required="yes">
		<cfargument name="IdxFK" 	default="no" type="boolean">
	
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select 	k.tab,		k.keyO,	k.OP, 
					k.tip,		k.cols,	k.ref, 		k.colsR, 
					k.sec,		k.clu,	k.idxTip,
					t.suf13,	t.suf25, k.ant
			  from #keyPD# k
				inner join #tabPD# t
					on t.tab = k.tab
			 where k.del = 0
			<cfif Arguments.tabla EQ "*FKs*">
			   and k.OP IN (1,2,3,8)
			   and k.tip = 'F'
			   and k.gen = 1
			<cfelseif Arguments.tabla NEQ "">
			   and ((k.OP IN (1,2,3) AND k.tip <> 'F') OR k.idxTip = '+')
			   and k.tab = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.tabla#">
			<cfelseif Arguments.IdxFK>
			   and k.idxTip = '+'
			<cfelse>
			   and k.OP IN (1,2,3,8)
			</cfif>
			 order by k.tab, k.keyO, k.sec
		</cfquery>
	
		<cfreturn rsSQL>
	</cffunction>
	
	<!--- Llaves a borrar o a regenerar (tablas existentes) OP: 3=Chg, 4=Del, 5=Del con Upload Denegado --->
	<cffunction name="fnGetKeysDelChg"  access="private" output="yes" returntype="query">
		<cfargument name="conexion" required="yes">
		<cfargument name="tabla" 	required="yes">
		<cfargument name="denegado"	default="">		<!--- Y=UPLOAD DENEGADO, N=UPLOAD NO DENEGADO --->
	
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select 	tab,  keyO, OP,
					tip,  cols, ref, colsR,
					keyN, idx,
					coalesce(
						(
							select ant 
							  from #keyPD# 
							 where tab	= #keyDB#.tab 
							   and cols	= #keyDB#.cols 
							   and tip	= #keyDB#.tip 
							   and ref	= #keyDB#.ref 
							   and colsR= #keyDB#.colsR
						), 0) as ant
			  from #keyDB#
			<cfif Arguments.tabla EQ "*FKs*">
			 where OP IN (3,4,5,6,7,8)
			   and tip in ('F','D')
			   and keyN <> '*FI*'
			<cfelseif Arguments.tabla NEQ "">
				<!--- El keyN=*FI* se incluyó para poder borrarlo o regenerarlo en este punto --->
				<!--- OP = 7 se excluye a nivel de tabla para mantener el indice FI --->
			 where OP IN (3,4,5,6)
			   and tab = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.tabla#">
			   and (tip <> 'F' OR idx IS NOT NULL)
			<cfelse>
				<cfif Arguments.Denegado EQ "Y">
				 where OP = 5
				<cfelseif Arguments.Denegado EQ "N">
				 where OP IN (3,4,6,7,8)
				<cfelse>
				 where OP IN (3,4,5,6,7,8)
				</cfif>
			   and keyN <> '*FI*'
			</cfif>
			   and (tip = 'D' or coalesce((select newFKs from #tabPD# where tab=#keyDB#.tab),0) = 0)
			 order by 1,2
		</cfquery>
		<cfreturn rsSQL>
	</cffunction>
	
	<!--- Objetos a renombrar --->
	<cffunction name="fnGetRenames"  access="private" output="no" returntype="query">
		<cfargument name="conexion" required="yes">
		<cfargument name="tabla" 	required="yes">
	
		<cfset LvarChkT 	= LvarObjDB.sbGetPDPrefijoName(Arguments.conexion,"'_CK'","")>
		<cfset LvarChkC 	= LvarObjDB.sbGetPDPrefijoName(Arguments.conexion,"'_CK'","pc.sec")>
		<cfset LvarKeyPK 	= LvarObjDB.sbGetPDPrefijoName(Arguments.conexion,"'_PK'","")>
		<cfset LvarKeyAK 	= LvarObjDB.sbGetPDPrefijoName(Arguments.conexion,"'_AK'","pk.sec")>
		<cfset LvarKeyFK 	= LvarObjDB.sbGetPDPrefijoName(Arguments.conexion,"'_FK'","pk.sec")>
		<cfset LvarKeyIUF 	= LvarObjDB.sbGetPDPrefijoName(Arguments.conexion,"case pk.tip when 'F' then '_FI' when 'U' then '_UI' else '_ID' end", "pk.sec")>
	
		<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
			select t.tab, 0 as keyO, 0 as sec, 'CHK_TAB' as tipo, chk.chk as oldName, 
					#preserveSingleQuotes(LvarChkT)# as newName, chk.rul as cols, 'C' as tip, '*' as ref, '*' as colsR
			  from #tabPD# t
				inner join #chkDB# chk
					 on chk.tab = t.tab
					and chk.OP = 0
			 where t.OP = 0
			<cfif Arguments.tabla NEQ "">
			   and t.tab = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.tabla#">
			</cfif>
			   and chk.chk IS NOT NULL
			   and coalesce(chk.chk,' ') <> #preserveSingleQuotes(LvarChkT)#
			UNION
			select t.tab, 0 as keyO, pc.sec, 'CHK_COL' as tipo, c.chk as oldName,  
					#preserveSingleQuotes(LvarChkC)# as newName, pc.rul as cols, 'C' as tip, '*' as ref, '*' as colsR
			  from #tabPD# t
				inner join #colPD# pc
					 on pc.tab = t.tab
					and pc.OP = 0
				inner join #colDB# c
					 on c.tab = pc.tab
					and c.col = pc.col
					and c.OP = 0
			 where t.OP = 0
			<cfif Arguments.tabla NEQ "">
			   and t.tab = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.tabla#">
			</cfif>
			   and c.chk IS NOT NULL
			   and c.chk <> #preserveSingleQuotes(LvarChkC)#
			UNION
			select t.tab, pk.keyO, pk.sec,'KEY_PK' as tipo, k.keyN as oldName,  
					#preserveSingleQuotes(LvarKeyPK)# as newName, pk.cols, pk.tip, pk.ref, pk.colsR
			  from #tabPD# t
				inner join #keyPD# pk
					 on pk.tab = t.tab
					and pk.OP = 0
				inner join #keyDB# k
					 on k.tab	= pk.tab
					and k.cols	= pk.cols
					and k.tip	= pk.tip
					and k.ref	= pk.ref
					and k.colsR	= pk.colsR
					and k.OP = 0
			 where t.OP = 0
			<cfif Arguments.tabla NEQ "">
			   and t.tab = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.tabla#">
			</cfif>
			   and k.keyN <> #preserveSingleQuotes(LvarKeyPK)#
			   and pk.tip = 'P'
			UNION
			select t.tab, pk.keyO, pk.sec,'KEY_AK' as tipo, k.keyN as oldName,
					#preserveSingleQuotes(LvarKeyAK)# as newName, pk.cols, pk.tip, pk.ref, pk.colsR
			  from #tabPD# t
				inner join #keyPD# pk
					 on pk.tab = t.tab
					and pk.OP = 0
				inner join #keyDB# k
					 on k.tab	= pk.tab
					and k.cols	= pk.cols
					and k.tip	= pk.tip
					and k.ref	= pk.ref
					and k.colsR	= pk.colsR
					and k.OP = 0
			 where t.OP = 0
			<cfif Arguments.tabla NEQ "">
			   and t.tab = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.tabla#">
			</cfif>
			   and k.keyN <> #preserveSingleQuotes(LvarKeyAK)#
			   and pk.tip = 'A'
			UNION
			select t.tab, pk.keyO, pk.sec,'KEY_FK' as tipo, k.keyN as oldName,
					#preserveSingleQuotes(LvarKeyFK)# as newName, pk.cols, pk.tip, pk.ref, pk.colsR
			  from #tabPD# t
				inner join #keyPD# pk
					 on pk.tab = t.tab
					and pk.OP = 0
				inner join #keyDB# k
					 on k.tab	= pk.tab
					and k.cols	= pk.cols
					and k.tip	= pk.tip
					and k.ref	= pk.ref
					and k.colsR	= pk.colsR
					and k.OP = 0
			 where t.OP = 0
			<cfif Arguments.tabla NEQ "">
			   and t.tab = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.tabla#">
			</cfif>
			   and k.keyN <> #preserveSingleQuotes(LvarKeyFK)#
			   and pk.tip = 'F'
			UNION
			select t.tab, pk.keyO, pk.sec,'KEY_INDEX' as tipo, k.keyN as oldName,
					#preserveSingleQuotes(LvarKeyIUF)# as newName, pk.cols, pk.tip, pk.ref, pk.colsR
			  from #tabPD# t
				inner join #keyPD# pk
					 on pk.tab = t.tab
					and pk.OP = 0
				inner join #keyDB# k
					 on k.tab	= pk.tab
					and k.cols	= pk.cols
					and k.tip	= pk.tip
					and k.ref	= pk.ref
					and k.colsR	= pk.colsR
					and k.OP  in (0,2)				<!--- OP = 2 es caso especial *FI* --->
			 where t.OP = 0
			<cfif Arguments.tabla NEQ "">
			   and t.tab = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.tabla#">
			</cfif>
			   and k.keyN <> #preserveSingleQuotes(LvarKeyIUF)#
			   and pk.tip in ('U','I')
			UNION
			select t.tab, pk.keyO, pk.sec,'KEY_INDEX_FI' as tipo, pk.idx as oldName,
					#preserveSingleQuotes(LvarKeyIUF)# as newName, pk.cols, pk.tip, pk.ref, pk.colsR
			  from #tabPD# t
				inner join #keyPD# pk
					 on pk.tab = t.tab
					and pk.OP IN (0,2,7,8)
					and pk.idxTip <> '+' 
			 where t.OP = 0
			<cfif Arguments.tabla NEQ "">
			   and t.tab = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.tabla#">
			</cfif>
			   and pk.idx  	IS NOT NULL
			   and pk.idx	<> #preserveSingleQuotes(LvarKeyIUF)#
			   and pk.idxTip = 'F'
	
			 order by 1,2,3,5
		</cfquery>
	
		<cfreturn rsSQL>
	</cffunction>
	
	<!--- Objetos (PK,AK,FK,UI,FI,ID) a renombrar porque su nombre está en otra tabla --->
	<cffunction name="sbRenameObjs"  access="private" output="no" returntype="void">
		<cfargument name="conexion" required="yes">
	
		<cftry>
			<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
				select coalesce(max(IDren),0) as IDren from DBMrenames
			</cfquery>
			<cfset LvarIDren = rsSQL.IDren>
		<cfcatch type="database">
			<cf_dbcreate name="DBMrenames" returnvariable="DBMrenames" datasource="#Arguments.Conexion#">
				<cf_dbcreatecol name="IDren"		    	type="numeric"		identity>
				<cf_dbcreatecol name="sch"		    		type="varchar(30)"	mandatory="yes">
				<cf_dbcreatecol name="tab"		    		type="varchar(30)"	mandatory="yes">
				<cf_dbcreatecol name="old"		    		type="varchar(30)"	mandatory="yes">
				<cf_dbcreatecol name="owner"	    		type="varchar(30)"	mandatory="yes">
				<cf_dbcreatecol name="tip"		   			type="varchar(2)"	mandatory="yes">
				<cf_dbcreatecol name="fecha"	    		type="datetime"		mandatory="yes">
				<cf_dbcreatecol name="sts"		   			type="numeric(1)"	mandatory="yes">
			
				<cf_dbcreatekey cols="IDren">
			</cf_dbcreate>
			<cfset LvarIDren = 0>
		</cfcatch>
		</cftry>

		<cf_dbtemp name="DBMrenI" returnvariable="LvarINDX" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="tab"		    		type="varchar(30)"	mandatory="yes">
			<cf_dbtempcol name="tip"		   			type="varchar(1)"	mandatory="yes">
			<cf_dbtempcol name="obj_name"	    		type="varchar(30)"	mandatory="yes">
		</cf_dbtemp>
		<cf_dbtemp name="DBMrenC" returnvariable="LvarCNST" datasource="#Arguments.Conexion#">
			<cf_dbtempcol name="tab"		    		type="varchar(30)"	mandatory="yes">
			<cf_dbtempcol name="tip"		   			type="varchar(1)"	mandatory="yes">
			<cf_dbtempcol name="obj_name"	    		type="varchar(30)"	mandatory="yes">
		</cf_dbtemp>

		<cfset LvarChkT 	= LvarObjDB.sbGetPDPrefijoName(Arguments.conexion,"'_CK'","")>
		<cfset LvarChkC 	= LvarObjDB.sbGetPDPrefijoName(Arguments.conexion,"'_CK'","pc.sec")>
		<cfset LvarKeyPK 	= LvarObjDB.sbGetPDPrefijoName(Arguments.conexion,"'_PK'","")>
		<cfset LvarKeyAK 	= LvarObjDB.sbGetPDPrefijoName(Arguments.conexion,"'_AK'","pk.sec")>
		<cfset LvarKeyFK 	= LvarObjDB.sbGetPDPrefijoName(Arguments.conexion,"'_FK'","pk.sec")>
		<cfset LvarKeyIUF 	= LvarObjDB.sbGetPDPrefijoName(Arguments.conexion,"case pk.tip when 'F' then '_FI' when 'U' then '_UI' else '_ID' end", "pk.sec")>
		
		<cfquery datasource="#Arguments.Conexion#">
			insert into #LvarINDX# (tab, tip, obj_name)
			select 	distinct t.tab, 'I' as tip, #preserveSingleQuotes(LvarKeyIUF)# as obj_name
			  from #tabPD# t
				inner join #keyPD# pk
					 on pk.tab = t.tab
					and pk.del = 0
			 where t.del = 0
			   and pk.tip in ('U','I','F')
		</cfquery>

		<cfquery datasource="#Arguments.Conexion#">
			insert into #LvarCNST# (tab, tip, obj_name)
			select 	distinct t.tab, 'C' as tip, #preserveSingleQuotes(LvarChkT)# as obj_name
			  from #tabPD# t
			 where t.del = 0
			   and t.rul is not null
			UNION
			select 	distinct t.tab, 'C' as tip, #preserveSingleQuotes(LvarChkC)# as obj_name
			  from #tabPD# t
				inner join #colPD# pc
					 on pc.tab = t.tab
					and pc.del = 0
			 where t.del = 0
			   and pc.rul is not null
			UNION
			select 	distinct t.tab, 'C' as tip,
					case tip
						when 'P' then #preserveSingleQuotes(LvarKeyPK)#
						when 'A' then #preserveSingleQuotes(LvarKeyAK)#
						when 'F' then #preserveSingleQuotes(LvarKeyFK)#
					end as obj_name
			  from #tabPD# t
				inner join #keyPD# pk
					 on pk.tab = t.tab
					and pk.del = 0
			 where t.del = 0
			   and pk.tip in ('P','A','F')
		</cfquery>

		<cfset LvarObjDB.sbRenameObjs (Arguments.Conexion, LvarCNST, LvarINDX, LvarIDren)>

		<cfquery datasource="#Arguments.Conexion#">
			delete from DBMrenames
			 where (
			 		select count(1)
					  from #tabPD#
					 where tab = DBMrenames.owner
					) > 0
		</cfquery>
	</cffunction>

	<cffunction name="sbGetPDPrefijoName" access="package" output="false" returntype="string">
		<cfargument name="conexion"	required="yes">
		<cfargument name="tipo"		required="yes">
		<cfargument name="sec"		required="yes">
		<cfargument name="suf"		required="yes">
		<cfargument name="PrefN"	required="yes">
	
		<cf_dbfunction name="OP_CONCAT" returnvariable="_CAT_" datasource="#Arguments.conexion#">
		<cf_dbfunction name="spart" args="t.tab,1,#Arguments.PrefN#" returnvariable="LvarSUBSTR" datasource="#Arguments.conexion#">
		<cf_dbfunction name="to_char" args="#Arguments.Suf#" returnvariable="LvarCHAR_1" datasource="#Arguments.conexion#">
		<cf_dbfunction name="to_char" args="#Arguments.Sec#" returnvariable="LvarCHAR_2" datasource="#Arguments.conexion#">
	
		<cfif sec EQ "">
			<cfreturn "case when #Arguments.Suf#>0 then #LvarSUBSTR# #_CAT_# right('00' #_CAT_# rtrim(#LvarCHAR_1#),2) else t.tab end #_CAT_# #Arguments.tipo#">
		<cfelse>
			<cfreturn "case when #Arguments.Suf#>0 then #LvarSUBSTR# #_CAT_# right('00' #_CAT_# rtrim(#LvarCHAR_1#),2) else t.tab end #_CAT_# #Arguments.tipo# #_CAT_# right('00' #_CAT_# rtrim(#LvarCHAR_2#),2)">
		</cfif>
	</cffunction>
	
	<cffunction name="fnPrintTABs" output="no" returntype="string">
		<cfargument name="rsSQL">
		<cfargument name="titulo">
	
		<cfset var LvarHTML = "">
		
		<cfoutput>
		<cfsavecontent variable="LvarHTML">
			<BR><strong>#Arguments.Titulo#</strong><BR>
			<table>
			<tr><td><strong>TABLA</strong></td></tr>
			<cfloop query="rsSQL">
				<tr><td>#rsSQL.tab#</td></tr>
			</cfloop>
			</table>
		</cfsavecontent>
		</cfoutput>
	
		<cfreturn LvarHTML>
	</cffunction>	
	
	<cffunction name="fnPrintCHKs" output="no" returntype="string">
		<cfargument name="rsSQL">
		<cfargument name="titulo">
	
		<cfset var LvarHTML = "">
		
		<cfoutput>
		<cfsavecontent variable="LvarHTML">
			<BR><strong>#Arguments.Titulo#</strong><BR>
			<table>
			<tr><td><strong>TABLA</strong></td><td><strong>CHECK</strong></td><td><strong>REGLA</strong></td></tr>
			<cfloop query="rsSQL">
				<tr><td>#rsSQL.tab#</td><td>#rsSQL.chk#</td><td>#rsSQL.rul#</td></tr>
			</cfloop>
			</table>
		</cfsavecontent>
		</cfoutput>
	
		<cfreturn LvarHTML>
	</cffunction>	
	
	<cffunction name="fnPrintRenames" output="no" returntype="string">
		<cfargument name="rsSQL">
		<cfargument name="titulo">
	
		<cfset var LvarHTML = "">
		
		<cfoutput>
		<cfsavecontent variable="LvarHTML">
			<BR><strong>#Arguments.Titulo#</strong><BR>
			<table>
			<tr><td><strong>TABLA</strong></td><td><strong>TIPO</strong></td><td><strong>NOMBRE ACTUAL</strong></td><td><strong>NUEVO NOMBRE</strong></td><td><strong>COLS</strong></td></tr>
			<cfloop query="rsSQL">
				<tr><td>#rsSQL.tab#&nbsp;&nbsp;</td><td>#rsSQL.tipo#&nbsp;&nbsp;</td><td>#rsSQL.oldName#&nbsp;&nbsp;</td><td>#rsSQL.newName#&nbsp;&nbsp;</td><td>#rsSQL.cols#</td></tr>
			</cfloop>
			</table>
		</cfsavecontent>
		</cfoutput>
		<cfreturn LvarHTML>
	</cffunction>	
	
	<cffunction name="fnPrintCOLs" output="no" returntype="string">
		<cfargument name="rsSQL">
		<cfargument name="titulo">
	
		<cfset var LvarHTML = "">
		
		<cfoutput>
		<cfsavecontent variable="LvarHTML">
			<BR><strong>#Arguments.Titulo#</strong><BR>
			<table>
			<tr><td><strong>TABLA</strong></td><td><strong>COLUMNA</strong></td><td><strong>TIPO</strong></td><td><strong>LON</strong></td><td><strong>DEC</strong></td><td><strong>obl</strong></td><td><strong>ide</strong></td><td><strong>dfl</strong></td><td><strong>rul</strong></td></tr>
			<cfloop query="rsSQL">
				<tr><td>#rsSQL.tab#&nbsp;&nbsp;</td><td>#rsSQL.col#&nbsp;&nbsp;</td><td>#fnTIP(rsSQL.tip)#&nbsp;&nbsp;</td><td>#rsSQL.lon#</td><td>#rsSQL.dec#</td><td>#rsSQL.obl#</td><td>#rsSQL.ide#</td><td>#rsSQL.dfl#</td><td>#rsSQL.rul#</td></tr>
			</cfloop>
			</table>
		</cfsavecontent>
		</cfoutput>
	
		<cfreturn LvarHTML>
	</cffunction>	
	
	<cffunction name="fnPrintKEYs" output="no" returntype="string">
		<cfargument name="rsSQL">
		<cfargument name="titulo">
		<cfargument name="FI" type="boolean" default="no">
	
		<cfset var LvarHTML = "">
		
		<cfoutput>
		<cfsavecontent variable="LvarHTML">
			<BR><strong>#Arguments.titulo#</strong><BR>
			<table>
			<tr><td><strong>TABLA</strong></td><td><strong>TIPO</strong></td><td><strong><cfif isdefined("rsSQL.keyN")>CODIGO<cfelse>SEC.</cfif></strong></td><td><strong>COLUMNAS</strong></td><td><strong>TABLA REFERENCIADA</strong></td><td><strong>COLUMNAS REFERENCIADAS</strong></td><td><strong>RAZON</strong></td></tr>
			<cfloop query="rsSQL">
				<cfloop from="1" to="2" index="i">
					<tr><td>#rsSQL.tab#</td><td align="center">
						<cfif rsSQL.tip EQ "P">
							PK <!---Primary Key--->
						<cfelseif rsSQL.tip EQ "A">
							AK <!---Unique Key--->
						<cfelseif rsSQL.tip EQ "U">
							UI <!---Unique Index--->
						<cfelseif rsSQL.tip EQ "F" and i EQ 2 OR Arguments.FI>
							FI <!---Foreing Key--->
						<cfelseif rsSQL.tip EQ "F" and i EQ 1>
							FK <!---Foreing Key--->
						<cfelse>
							ID <!---Index--->
						</cfif>
					</td>
					<cfif isdefined("rsSQL.keyN")>
						<td>
							<cfif rsSQL.tip EQ "F" and i EQ 2>
								#rsSQL.idx#
							<cfelse>
								#rsSQL.keyN#
							</cfif>
						</td>
					<cfelse>
						<td align="center">
							#numberFormat(rsSQL.sec,"00")#
						</td>
					</cfif>
					<td>#rsSQL.cols#</td><td>#rsSQL.ref#</td><td>#rsSQL.colsR#</td>
					<td>
						<cfif rsSQL.OP EQ 1>
							TABLA NUEVA EN DBM
						<cfelseif rsSQL.OP EQ 2>
							NUEVO EN DBM <cfif rsSQL.ant EQ 1>(DBM:RECOLS)</cfif>
						<cfelseif rsSQL.OP EQ 3>
							CAMPOS MODIFICADOS
						<cfelseif rsSQL.OP EQ 4>
							BORRADA EN DBM <cfif rsSQL.ant EQ 1>(DBM:RECOLS)<cfelse>(DBM:DROP)</cfif>
						<cfelseif rsSQL.OP EQ 5>
							NO DEFINIDA EN DBM
						<cfelseif rsSQL.OP EQ 6>
							LLAVE DUPLICADA
						<cfelseif rsSQL.OP EQ 7>
							NO GENERAR CONSTRAINT
						<cfelseif rsSQL.OP EQ 8>
							<font color="##FF0000"><strong>REF A NUEVO IDENTITY</strong></font>
						<cfelseif rsSQL.OP EQ 10>
							DEFINICION DBM PERDIDA
						<cfelseif isdefined("rsSQL.ext")>
							<font color="##FF0000"><strong>REFERENCIA&nbsp;EXTERNA</strong></font>
						</cfif>
					</td>
					</tr>
					<cfif NOT (isdefined("rsSQL.keyN") AND rsSQL.tip EQ "F" AND rsSQL.idx NEQ "")>
						<cfbreak>
					</cfif>
				</cfloop>
			</cfloop>
			</table>
		</cfsavecontent>
		</cfoutput>
		<cfreturn LvarHTML>
	</cffunction>
	
	<cffunction name="fnPrintCOLs2" output="no" returntype="string">
		<cfargument name="rsSQL">
		<cfargument name="TIPO">
		<cfargument name="titulo">
	
		<cfset var LvarHTML = "">
		<cfif Arguments.TIPO EQ "UPLOAD">
			<cfset DBM 	= "POWERDESIGNER">
			<cfset DB	= "DESARROLLO">
		<cfelse>
			<cfset DBM 	= "MODELO DBM">
			<cfset DB	= "BASE DATOS">
		</cfif>
		<cfoutput>
		<cfsavecontent variable="LvarHTML">
			<BR><strong>#Arguments.titulo#</strong><BR>
			<table>
			<tr><td><strong>TABLA</strong></td><td><strong>COLUMNA</strong></td><td><strong>&nbsp;</strong></td><td><strong>TIPO</strong></td><td><strong>LON</strong></td><td><strong>DEC</strong></td><td><strong>obl</strong></td><td><strong>ide</strong></td><td><strong>dfl</strong></td><td><strong>rul</strong></td></tr>
			<cfloop query="rsSQL">
				<tr>
					<td>#rsSQL.tab#</td><td>#rsSQL.col#</td>
					<cfif rsSQL.colAnt NEQ "">
						<td colspan="7" align="right">Nombre Actual:&nbsp;</td><td><strong>#rsSQL.colAnt#</strong></td>
					</cfif>
				</tr>
				<tr><td colspan="2" align="right">#DBM#</td><td>:</td>
					<td>#fnPrintCOLs2ATT(fnTIP(rsSQL.tipP), fnTIP(rsSQL.tipD))#</td>
					<td>#fnPrintCOLs2ATT(rsSQL.lonP, rsSQL.lonD)#</td>
					<td>#fnPrintCOLs2ATT(rsSQL.decP, rsSQL.decD)#</td>
					<td>#fnPrintCOLs2ATT(rsSQL.oblP, rsSQL.oblD)#</td>
					<cfif rsSQL.ideP EQ "1" AND rsSQL.ideT EQ "D">
						<td><strong>ALWAYS</strong></td>
					<cfelse>
						<td>#fnPrintCOLs2ATT(rsSQL.ideP, rsSQL.ideD)#</td>
					</cfif>
					<td>#fnPrintCOLs2ATT(rsSQL.dflP, rsSQL.dflD)#</td>
					<td>#fnPrintCOLs2ATT(rsSQL.rulP, rsSQL.rulD)#</td>
				</tr>	
				<tr><td colspan="2" align="right">#DB#</td>   <td>:</td>
					<td>#fnTIP(rsSQL.tipD)#</td>
					<td>#rsSQL.lonD#</td>
					<td>#rsSQL.decD#</td>
					<td>#rsSQL.oblD#</td>
					<cfif rsSQL.ideP EQ "1" AND rsSQL.ideT EQ "D">
						<td><strong>DEFAULT</strong></td>
					<cfelse>
						<td>#rsSQL.ideD#</td>
					</cfif>
					<cfif trim(#rsSQL.dflP#) EQ "">
						<td><font color="##FF0000">#rsSQL.dflD#</font></td>
					<cfelse>
						<td>#rsSQL.dflD#</td>
					</cfif>
					<cfif trim(#rsSQL.rulP#) EQ "">
						<td><font color="##FF0000">#rsSQL.rulD#</font></td>
					<cfelse>
						<td>#rsSQL.rulD#</td>
					</cfif>
				</tr>
			</cfloop>
			</table>
		</cfsavecontent>
		</cfoutput>
		<cfreturn LvarHTML>
	</cffunction>
	
	<cffunction name="fnTip" output="no" returntype="string">
		<cfargument name="tip">
		<!--- TiposPD = C,V,	B,VB,	CL,BL,	I,N,F,M,L,	D,TS --->
	
		<cfset Arguments.TIP = trim(Arguments.TIP)>
		<cfif Arguments.TIP EQ "C">
			<cfreturn "CHAR">
		<cfelseif Arguments.TIP EQ "V">
			<cfreturn "VARCHAR">
		<cfelseif Arguments.TIP EQ "B">
			<cfreturn "BINARY">
		<cfelseif Arguments.TIP EQ "VB">
			<cfreturn "VARBIN">
		<cfelseif Arguments.TIP EQ "CL">
			<cfreturn "CHAR LOB">
		<cfelseif Arguments.TIP EQ "BL">
			<cfreturn "BIN LOB">
	
		<cfelseif Arguments.TIP EQ "I">
			<cfreturn "INTEGER">
		<cfelseif Arguments.TIP EQ "N">
			<cfreturn "NUMERIC">
		<cfelseif Arguments.TIP EQ "F">
			<cfreturn "FLOAT">
		<cfelseif Arguments.TIP EQ "M">
			<cfreturn "MONEY">
		<cfelseif Arguments.TIP EQ "L">
			<cfreturn "LOGIC">
	
		<cfelseif Arguments.TIP EQ "D">
			<cfreturn "DATE TIME">
		<cfelseif Arguments.TIP EQ "TS">
			<cfreturn "TIMESTAMP">
		<cfelse>
			<cfreturn Arguments.TIP>
		</cfif>
	</cffunction>
	
	<cffunction name="fnPrintCOLs2ATT" output="no" returntype="string">
		<cfargument name="ATT_PD">
		<cfargument name="ATT_DB">
		
		<cfif "|#Arguments.ATT_PD#|" EQ "|#Arguments.ATT_DB#|">
			<cfreturn Arguments.ATT_PD>
		<cfelseif Arguments.ATT_PD NEQ "">
			<cfreturn "<strong>#Arguments.ATT_PD#</strong>">
		<cfelse>
			<cfreturn "<strong>**NULL**</strong>">
		</cfif>
	</cffunction>
	
	<cffunction name="UPLOAD_toVersion" access="public" output="no">
		<cfargument name="IDupl" required="yes">
	
		<cftry>
			<cfquery name="rsSQL" datasource="asp">
				select u.IDmod, u.des, u.uidSVN, u.IDver, u.fec, m.IDsch, s.sch, u.sts, u.stsP
				  from DBMuploads u
					inner join DBMmodelos m 
						inner join DBMsch s
							on s.IDsch = m.IDsch
						on m.IDmod = u.IDmod
				 where u.IDupl = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDupl#">
			</cfquery>
	
			<cfif NOT (rsSQL.sts EQ 3)>
				<cfreturn -1>
			</cfif>
			<cfset LvarIDmod =rsSQL.IDmod>
			<cfset LvarIDsch =rsSQL.IDsch>
			<cfset LvarUplFec =rsSQL.fec>
			<cfif rsSQL.IDver EQ "">
				<!--- Se registra como fecha de la versión, la fecha del Upload --->
				<cfquery name="rsInsert" datasource="asp">
					insert into DBMversiones (IDmod, des, sts, uidSVN, fec)
					values (
						  #LvarIDmod#
						, <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#rsSQL.des#" len="50">
						, 0
						, '#rsSQL.uidSVN#'
						, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarUplFec#">
					)
					<cf_dbidentity1 name="rsInsert" datasource="asp" returnvariable="LvarIDver">
				</cfquery>
				<cf_dbidentity2 name="rsInsert" datasource="asp" returnvariable="LvarIDver">
			<cfelse>
				<cfset LvarIDver = rsSQL.IDver>
				<cfquery datasource="asp">
					delete from DBMtabV
					 where IDver = #LvarIDver#
				</cfquery>
			</cfif>
				
			<cfquery name="rsInsert" datasource="asp">
				update DBMuploads
				   set 	stsP	= 29,		<!--- Generando Version --->
						tabsP 	= 1,
						msg		= null
					 , IDver = #LvarIDver#
				 where IDupl = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDupl#">
			</cfquery>
	
			<!--- TABLAS A CAMBIAR O INCLUIR: excluye tablas cargadas en uploads posteriores --->
			<cfquery name="rsTABs" datasource="asp">
				select 	u.IDtab as IDtabU, u.tab, u.des, u.rul, u.gen, u.del, u.suf13, u.suf25,
						t.IDtab, t.tab as tabOF, t.des as desOF, t.rul as rulOF, t.del as delOF, t.IDmodORI, m.modelo as modORI, t.IDver as IDverAnt,
						t.secCol, t.secIdx, t.secFK
						, u.tabAnt , t.tabAnt as tabAntOF
				  from DBMtabU u
				  left join DBMtab t
						left join DBMmodelos m on m.IDmod = t.IDmodORI
					 on t.IDsch = #LvarIDsch# 
					and (t.tab = u.tab OR t.tab = u.tabAnt)
				 where u.IDupl = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDupl#">
				   and u.gen = 1
				   and u.genVer = 1
				   and (
						select count(1)
						  from DBMtabV tv
							inner join DBMversiones v
								on v.IDver = tv.IDver
						 where tv.IDtab = u.IDtab
						   and v.fec >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarUplFec#">
						) = 0
			</cfquery>
			
			<cfset LvarTabsP = 0>
			<cfloop query="rsTABs">
				<cfif rsTABs.currentRow - LvarTabsP GT 10>
					<cfset LvarTabsP = fnUpdateTabsP("UPLOAD", Arguments.IDupl, rsTABs.currentRow)>
				</cfif>
				<cfset LvarIDtabU	= rsTABs.IDtabU>
				<cfset LvarIDtab 	= rsTABs.IDtab>
				<cfset LvarTab		= trim(rsTABs.tab)>
				<cfset LvarDBMcambiado = false>
		
				<cfif rsTABS.tabAnt EQ rsTABS.tab>
					<cfthrow message="Error al cambiar de nombre la tabla '#rsTABS.tab#'">
				<cfelseif rsTABS.IDtab NEQ "" AND rsTABS.tabAnt NEQ "">
					<cfif rsTABS.tab EQ rsTABS.tabOF AND rsTABS.tabAnt NEQ rsTABS.tabAntOF>
						<cfthrow message="La tabla '#rsTABS.tabAntOF#' ya cambio su nombre a '#rsTABS.tabOF#'. No puede cambiar de nuevo a '#rsTABS.tabAnt#'">
					</cfif>
				<cfelseif rsTABS.tabAntOF NEQ "" AND rsTABS.tabAnt EQ "">
					<cfset rsTABS.tabAnt = rsTABS.tabAntOF>
				</cfif>
				
				<cfif rsTABS.IDtab EQ "">
					<cfset LvarPROCESAR = true>	<!--- TABLA NUEVA en schema --->
		
					<!--- Simplemente agrega en tablas oficiales --->
					<cfset LvarSecCol = 0>
					<cfset LvarSecIdx = 0>
					<cfset LvarSecFK  = 0>
		
					<cfquery name="rsInsert" datasource="asp">
						insert into DBMtab 
							(
								IDver, IDsch, tab, des, rul, del, 
								secCol, secIdx, secFK, 
								suf13, suf25,
								IDmodORI
							)
						values (
								#LvarIDver#,
								#LvarIDsch#,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTABS.tab#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#fnSinSaltoLinea(rsTABS.des)#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTABS.rul#"	null="#trim(rsTABS.rul) EQ ''#">,
								#rsTABS.del#,
								
								0, 0, 0,
								#rsTABS.suf13#, #rsTABS.suf25#,
								<!--- Si la tabla no es para generar, el IDmod (modelo dueño) queda en blanco --->
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarIDmod#" null="#rsTABS.gen EQ '0'#">
							)
						<cf_dbidentity1 name="rsInsert" datasource="asp" returnvariable="LvarIDtab">
					</cfquery>
					<cf_dbidentity2 name="rsInsert" datasource="asp" returnvariable="LvarIDtab">
		
					<cfquery datasource="asp">
						insert into DBMtabV
							(
								IDver, IDtab, op
							)
						values (
								#LvarIDver#,
								#LvarIDtab#,
								1
							)
					</cfquery>
					
					<cfquery name="rsCOLs" datasource="asp">
						select 	u.col, u.sec, u.des, u.tip, u.lon, u.dec, u.ide, u.obl, u.dfl, u.ini, u.minVal, u.maxVal, u.lov, u.del,
								null as IDcol, u.colAnt, '' as colAntOF
						  from DBMcolU u
						 where u.IDtab	= #LvarIDtabU#
						   and u.genVer = 1
						 order by u.sec
					</cfquery>
					<cfset LvarKeyO = fnKeyOsql("u.tip")>
					<cfquery name="rsKEYs" datasource="asp">
						select  #preserveSingleQuotes(LvarKeyO)#,
								u.tip, u.cols, u.ref, u.colsR, u.clu, u.idxTip, u.gen, u.del, u.colsAnt,
								null as IDkey
						  from DBMkeyU u
						 where u.IDtab	= #LvarIDtabU#
						   and u.genVer = 1
						 order by 1
					</cfquery>
				<cfelseif rsTABs.gen EQ "0">
					<cfset LvarPROCESAR = false>	<!--- La tabla no pertenece al modelo, no debe generarse --->
		
					<cfquery datasource="asp">
						insert into DBMtabV
							(
								IDver, IDtab, op
							)
						values (
								#LvarIDver#,
								#LvarIDtab#,
								0
							)
					</cfquery>
		
					<cfif rsTABS.IDmodORI NEQ LvarIDmod>
					<!--- Si la tabla ya existe: pero sigue siendo de otro módulo (módulo original es otro y no hay que generarla): se ignora la tabla --->
					<cfelse>
					<!--- Si la tabla ya existe: pero deja de ser del módulo: se actualiza el modelo origen (se guarda primero los valores anteriore en bitacora), se ignora los demás cambios --->
						<cfset LvarDBMcambiado = true>
						<cfquery datasource="asp">
							insert into DBMtabVant (
								IDver, IDtab, 
								tab, des, chk, del, IDmodORI
							)
							values (
								#rsTABS.IDverAnt#,
								#LvarIDtab#,
		
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTABS.tabOF#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#fnSinSaltoLinea(rsTABS.desOF)#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTABS.rulOF#"	null="#trim(rsTABS.rulOF) EQ ''#">,
								#rsTABS.delOF#,
		
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTABS.IDmodORI#" null="#trim(rsTABS.IDmodORI) EQ ''#">
							)
						</cfquery>				
						<cfquery datasource="asp">
							update DBMtab 
							   set IDver	= #LvarIDver#
								 , IDmodORI = null
		
								 , tab		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTABS.tab#">
								 , des		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#fnSinSaltoLinea(rsTABS.des)#">
								 , chk		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTABS.chk#">
								 , del		= #rsTABS.del#
							  <cfif rsTABs.tabAntOF NEQ rsTABs.tabAnt>
								 , tabAnt 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTABs.tabAnt#" null="#rsTABs.tabAnt EQ ""#">
							  </cfif>
							 where IDtab	= #LvarIDtab#
						</cfquery>
					</cfif>
				<cfelse>
					<cfset LvarPROCESAR = true>	<!--- La tabla debe generarse --->
		
					<cfif rsTABS.IDmodORI NEQ "" AND rsTABS.IDmodORI NEQ LvarIDmod>
						<cfthrow message="La tabla #rsTABS.tab# pertenece a otro modelo: #rsTABS.modORI#">
					</cfif>
					
					<cfquery datasource="asp">
						insert into DBMtabV
							(
								IDver, IDtab, op
							)
						values (
								#LvarIDver#,
								#LvarIDtab#,
								0
							)
					</cfquery>
					
					<cfset LvarSecCol = rsTABs.secCol>
					<cfset LvarSecIdx = rsTABs.secIdx>
					<cfset LvarSecFK  = rsTABs.secFK>
					<!--- Si hubo algun cambio: modifica tablas oficiales (se guarda primero los valores anteriores en bitacora) --->
					<cfif rsTABS.IDmodORI 	NEQ LvarIDmod
					   OR rsTABS.tabOF 		NEQ rsTABS.tab
					   OR rsTABS.desOF 		NEQ rsTABS.des
					   OR rsTABS.rulOF 		NEQ rsTABS.rul
					   OR rsTABS.delOF 		NEQ rsTABS.del
					>
						<cfset LvarDBMcambiado = true>
						<cfquery datasource="asp">
							insert into DBMtabVant (
								IDver, IDtab, 
								tab, des, rul, del, IDmodORI
							)
							values (
								#rsTABS.IDverAnt#,
								#LvarIDtab#,
		
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTABS.tabOF#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTABS.desOF#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTABS.rulOF#"		null="#trim(rsTABS.rulOF) EQ ''#">,
								#rsTABS.delOF#,
		
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTABS.IDmodORI#"	null="#trim(rsTABS.IDmodORI) EQ ''#">
							)
						</cfquery>				
		
						<cfquery datasource="asp">
							update DBMtab 
							   set IDver	= #LvarIDver#
								 , IDmodORI = #LvarIDmod#
							   
								 , tab		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTABS.tab#">
								 , des		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#fnSinSaltoLinea(rsTABS.des)#">
								 , rul		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTABS.rul#"		null="#rsTABS.rul EQ ''#">
								 , del		= #rsTABS.del#
							  <cfif rsTABs.tabAntOF NEQ rsTABs.tabAnt>
								 , tabAnt 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTABs.tabAnt#" null="#rsTABs.tabAnt EQ ""#">
							  </cfif>
							 where IDtab	= #LvarIDtab#
						</cfquery>
					</cfif>
					<cfquery name="rsCOLs" datasource="asp">
						select  u.col, u.colAnt, u.des, u.tip, u.lon, u.dec, u.ide, u.dfl, u.ini, u.minVal, u.maxVal, u.lov, u.del,
								
								case when u.ide = 1 OR u.tip = 'TS' then 1 else u.obl end as obl, 
								
								c.IDcol, c.sec as secOF, 
								c.col as colOF, c.colAnt as colAntOF, c.des as desOF, c.tip as tipOF, 
								c.lon as lonOF, c.dec as decOF, c.ide as ideOF, c.obl as oblOF, c.dfl as dflOF, 
								c.ini as iniOF, c.minVal as minValOF, c.maxVal as maxValOF, c.lov as lovOF, c.del as delOF, 
								c.IDver as IDverAnt
						  from DBMcolU u
							  left join DBMcol c
								on c.IDtab	= #LvarIDtab# and c.col = u.col
						 where u.IDtab	= #LvarIDtabU#		<!--- OJO: c.IDtab y u.IDtab son identity independientes --->
						   and u.genVer = 1
						 order by u.sec
					</cfquery>

					<!--- Borra las llaves unicas repetidas --->
					<cfquery name="rsKEYs" datasource="asp">
						select  k.IDtab, k.cols, max(k.IDkey) as IDkey
						  from DBMkeyU u
							  inner join DBMkey k
								 on k.IDtab	= #LvarIDtab# and k.cols = u.cols 
								and k.tip in ('P','A','U') 
								and u.tip in ('P','A','U')
						 where u.IDtab	= #LvarIDtabU#		<!--- OJO: k.IDtab y u.IDtab son identity independientes --->
						   and u.genVer = 1
						 group by k.IDtab, k.cols
						 having count(1)>1
					</cfquery>
					<cfloop query="rsKEYs">
						<cfquery datasource="asp">
							update DBMkeyVant
							   set IDkey = #rsKEYs.IDkey#
							 where IDkey in	
							 	(
									select IDkey 
									  from DBMkey
									 where IDtab 	= #rsKEYs.IDtab#
									   and cols		= '#rsKEYs.cols#'
									   and tip 		in ('P','A','U') 
									   and IDkey	<> #rsKEYs.IDkey#
								)
						</cfquery>
					
						<cfquery datasource="asp">
							delete from DBMkey
							 where IDtab	= #rsKEYs.IDtab#
							   and cols		= '#rsKEYs.cols#'
							   and tip 		in ('P','A','U') 
							   and IDkey	<> #rsKEYs.IDkey#
						</cfquery>
					</cfloop>

					<cfset LvarKeyO = fnKeyOsql("u.tip")>
					<cfquery name="rsKEYs" datasource="asp">
						select  #preserveSingleQuotes(LvarKeyO)#,
								u.tip, u.cols, u.ref, u.colsR, u.clu, u.idxTip, u.gen, u.del,
	
								k.IDkey, k.sec as secOF,
								k.tip as tipOF, k.cols as colsOF, k.ref as refOF, k.colsR as colsROF, k.clu as cluOF, k.idxTip as idxTipOF, k.gen as genOF, k.del as delOF,
								k.IDver as IDverAnt,
								u.colsAnt
						  from DBMkeyU u
							  left join DBMkey k
								 on k.IDtab	= #LvarIDtab# and k.cols = u.cols 
								and (k.tip = u.tip OR k.tip in ('P','A','U') and u.tip in ('P','A','U'))
								and k.ref = u.ref and k.colsR = u.colsR
						 where u.IDtab	= #LvarIDtabU#		<!--- OJO: k.IDtab y u.IDtab son identity independientes --->
						   and u.genVer = 1
						 order by 1
					</cfquery>
				</cfif>
	
				<cfif LvarPROCESAR>
					<cfquery datasource="asp">
						delete from DBMcolLov
						 where (
							select count(1)
							  from DBMcol c
							 where c.IDtab = #LvarIDtab#
							   and c.IDcol = DBMcolLov.IDcol
							) > 0
					</cfquery>
				
					<!--- PROCESA COLUMNAS --->
					<cfset LvarTab = rsTABS.tab>
					<cfloop query="rsCOLS">
						<cfif rsCOLS.colAnt EQ rsCOLS.col>
							<cfthrow message="Error al cambiar de nombre la columna '#LvarTab#.#rsCOLS.col#'">
						<cfelseif rsCOLS.IDcol NEQ "" AND rsCOLS.colAnt NEQ "">
							<cfif rsCOLS.col EQ rsCOLS.colOF AND trim(rsCOLS.colAntOF) NEQ "" AND rsCOLS.colAnt NEQ rsCOLS.colAntOF>
								<cfthrow message="En la tabla '#LvarTab#' la columna '#rsCOLS.colAntOF#' ya cambio su nombre a '#rsCOLS.colOF#'. No puede cambiar de nuevo a '#rsCOLS.colAnt#'">
							</cfif>
						<cfelseif rsCOLS.colAntOF NEQ "" AND rsCOLS.colAnt EQ "">
							<cfset rsCOLS.colAnt = rsCOLS.colAntOF>
						</cfif>
						<cfset LvarIDcol = rsCOLs.IDcol>
						<!--- Columna Nueva --->
						<cfif rsCOLs.IDcol EQ "">
							<!--- Actualiza la secuencia correspondiente --->
							<cfif lcase(rsCOLs.col) EQ "bmusucodigo">
								<cfset LvarSec = "1001">
							<cfelseif rsCOLs.col EQ "ts_rversion">
								<cfset LvarSec = "1002">
							<cfelse>
								<cfset LvarSecCol ++>
								<cfset LvarSec = LvarSecCol>
							</cfif>
							<cfquery name="rsInsert" datasource="asp">
								insert into DBMcol (
									IDtab, col, 
									sec, 
									des, tip, lon, dec, ide, obl, dfl, ini, minVal, maxVal, lov, del,
									IDver, colAnt
								)
								values (
									#LvarIDtab#,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCOLs.col#">,
		
									#LvarSec#,
									
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#fnSinSaltoLinea(rsCOLs.des)#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCOLs.tip#">,
									#rsCOLs.lon#,
									#rsCOLs.dec#,
									#rsCOLs.ide#,
									#rsCOLs.obl#,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCOLs.dfl#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCOLs.ini#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCOLs.minVal#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCOLs.maxVal#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCOLs.lov#">,
									#rsCOLs.del#,
		
									#LvarIDver#,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCOLs.colAnt#" null="#rsCOLs.colAnt EQ ''#">
								)
								<cf_dbidentity1 name="rsInsert" returnVariable="LvarIDcol" datasource="asp">
							</cfquery>	
							<cf_dbidentity2 name="rsInsert" returnVariable="LvarIDcol" datasource="asp">
	
							<cfquery datasource="asp">
								update DBMtab
								   set secCol	= #LvarSecCol#
								 where IDtab	= #LvarIDtab#
							</cfquery>
						<!--- Si hubo algun cambio: modifica tablas oficiales (se guarda primero los valores anteriores en bitacora) --->
						<cfelseif rsCOLs.colOF NEQ rsCOLs.col
						   OR rsCOLs.desOF NEQ rsCOLs.des
						   OR rsCOLs.tipOF NEQ rsCOLs.tip
						   OR rsCOLs.lonOF NEQ rsCOLs.lon
						   OR rsCOLs.decOF NEQ rsCOLs.dec
						   OR rsCOLs.ideOF NEQ rsCOLs.ide
						   OR rsCOLs.oblOF NEQ rsCOLs.obl
						   OR rsCOLs.dflOF NEQ rsCOLs.dfl
						   OR rsCOLs.iniOF NEQ rsCOLs.ini
						   OR rsCOLs.minValOF NEQ rsCOLs.minVal
						   OR rsCOLs.maxValOF NEQ rsCOLs.maxVal
						   OR rsCOLs.lovOF NEQ rsCOLs.lov
						   OR rsCOLs.delOF NEQ rsCOLs.del
						>
							<cfset LvarDBMcambiado = true>
							<cfquery name="rsSQL" datasource="asp">
								select count(1) as cantidad
								  from DBMcolVant
								 where IDver = #rsCOLs.IDverAnt#
								   and IDcol = #rsCOLs.idCol#
							</cfquery>
							<cfif rsSQL.cantidad EQ 0>
								<cfquery datasource="asp">
									insert into DBMcolVant (
										IDver, IDcol, 
										col, 
										sec, 
										des, tip, lon, dec, ide, obl, dfl, ini, minVal, maxVal, lov, del
									)
									values (
										#rsCOLs.IDverAnt#,
										#rsCOLs.idCol#,
			
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCOLs.colOF#">,
										#rsCOLs.secOF#,
			
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#fnSinSaltoLinea(rsCOLs.desOF)#">,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCOLs.tipOF#">,
										#rsCOLs.lonOF#,
										#rsCOLs.decOF#,
										#rsCOLs.ideOF#,
										#rsCOLs.oblOF#,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCOLs.dflOF#">,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCOLs.iniOF#">,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCOLs.minValOF#">,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCOLs.maxValOF#">,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCOLs.lovOF#">,
										#rsCOLs.delOF#
									)
								</cfquery>
							</cfif>
			
							<cfquery datasource="asp">
								update DBMcol
								   set IDver	= #LvarIDver#
								   
									 , col 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCOLs.col#">
		
									 , des 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#fnSinSaltoLinea(rsCOLs.des)#">
									 , tip 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCOLs.tip#">
									 , lon 		= #rsCOLs.lon#
									 , dec 		= #rsCOLs.dec#
									 , ide 		= #rsCOLs.ide#
									 , obl 		= #rsCOLs.obl#
									 , dfl 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCOLs.dfl#">
									 , ini 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCOLs.ini#">
									 , minVal 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCOLs.minVal#">
									 , maxVal 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCOLs.maxVal#">
									 , lov 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCOLs.lov#">
									 , del 		= #rsCOLs.del#
								  <cfif rsCOLS.colAntOF NEQ rsCOLS.colAnt>
									 , colAnt 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCOLs.colAnt#" null="#rsCOLs.colAnt EQ ""#">
								  </cfif>
								 where IDcol	= #rsCOLs.idCol#
							</cfquery>
						</cfif>
						<cfif rsCOLs.IDcol EQ "" OR rsCOLs.lovOF NEQ rsCOLs.lov>
							<cfset sbLOV(LvarIDcol, rsCOLs.lov)>
						</cfif>
					</cfloop>
		
					<!--- PROCESA KEYs --->
					<cfloop query="rsKEYs">
						<cfif rsKEYs.IDkey EQ "">
							<!--- KEY Nueva --->
							<cfset LvarSec = 0>
							<cftransaction>
								<!--- Actualiza la secuencia correspondiente --->
								<cfif rsKEYs.tip EQ "A" OR rsKEYs.tip EQ "U" OR rsKEYs.tip EQ "I">
									<cfset LvarSecIdx ++>
									<cfset LvarSec = LvarSecIdx>
									<cfquery datasource="asp">
										update DBMtab
										   set secIdx	= #LvarSec#
										 where IDtab	= #LvarIDtab#
									</cfquery>
								<cfelseif rsKEYs.tip EQ "F">
									<cfset LvarSecFK  ++>
									<cfset LvarSec = LvarSecFK>
									<cfquery datasource="asp">
										update DBMtab
										   set secFK	= #LvarSec#
										 where IDtab	= #LvarIDtab#
									</cfquery>
								</cfif>
		
								<cfquery datasource="asp">
									insert into DBMkey (
										IDtab, tip, cols, ref, colsR,
										sec, 
										clu, idxTip, gen, del,
										IDver
									)
									values (
										#LvarIDtab#,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsKEYs.tip#">,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsKEYs.cols#">,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsKEYs.ref#">,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsKEYs.colsR#">,
			
										#LvarSec#,
										
										#rsKEYs.clu#,
										'#rsKEYs.idxTip#',
										#rsKEYs.gen#,
										#rsKEYs.del#,
			
										#LvarIDver#
									)
								</cfquery>


								<!--- Si hubo cambio de PK o AK: colsAnt --->
								<cfif trim(rsKEYs.colsAnt) NEQ "">
									<!--- Obtiene la PK o AK anterior --->
									<cfquery name="rsSQL" datasource="asp">
										select IDkey
										  from DBMkey
										 where IDtab = #LvarIDtab#
									 	   and cols	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsKEYs.colsAnt#">
										   and tip	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsKEYs.tip#">
										   and del	 = 0
									</cfquery>
									<cfif rsSQL.IDkey NEQ "">
										<cfset LvarIDkeys = rsSQL.IDkey>
										<!--- Obtiene las FKs relacionadas con la PK o AK anterior --->
										<cfquery name="rsSQL" datasource="asp">
											select IDkey
											  from DBMkey
											 where ref	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTab#">
											   and colsR = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsKEYs.colsAnt#">
											   and tip	 = 'F'
											   and del	 = 0
											   and (
													select count(1)
													  from DBMtab
													 where IDsch = #LvarIDsch#
													   and IDtab = DBMkey.IDtab
													) > 0
										</cfquery>
										<cfif rsSQL.IDkey NEQ "">
											<cfset LvarIDkeys &= "," & valueList(rsSQL.IDkey)>
										</cfif>
										<!--- Marca com Eliminar las PK,AK o FKs anteriores --->
										<cfquery datasource="asp">
											insert into DBMkeyVant (
												IDver, IDkey, 
												tip, cols, ref, colsR, 
												sec,
												clu, idxTip, gen, del
											)
											select 
												IDver, IDkey, 
												tip, cols, ref, colsR, 
												sec,
												clu, idxTip, gen, del
											  from DBMkey
											 where IDkey in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarIDkeys#" list="yes">)
										</cfquery>				
										<cfquery datasource="asp">
											update DBMkey
											   set IDver	= #LvarIDver#
												 , del 		= 1
											 where IDkey in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarIDkeys#" list="yes">)
										</cfquery>
									</cfif>
								</cfif>
							</cftransaction>
						<!--- Si hubo algun cambio: modifica tablas oficiales (se guarda primero los valores anteriores en bitacora) --->
						<cfelseif 
							  rsKEYs.tipOF 	 	NEQ rsKEYs.tip
						   OR rsKEYs.colsOF	 	NEQ rsKEYs.cols
						   OR rsKEYs.refOF	 	NEQ rsKEYs.ref
						   OR rsKEYs.colsROF 	NEQ rsKEYs.colsR
						   OR rsKEYs.cluOF	 	NEQ rsKEYs.clu
						   OR rsKEYs.idxTipOF	NEQ rsKEYs.idxTip
						   OR rsKEYs.genOF	 	NEQ rsKEYs.gen
						   OR rsKEYs.delOF	 	NEQ rsKEYs.del
						>
							<cfset LvarDBMcambiado = true>
							<cfquery datasource="asp">
								insert into DBMkeyVant (
									IDver, IDkey, 
									tip, cols, ref, colsR, 
									sec,
									clu, idxTip, gen, del
								)
								values (
									#rsKEYs.IDverAnt#,
									#rsKEYs.IDkey#,
		
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsKEYs.tipOF#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsKEYs.colsOF#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsKEYs.refOF#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsKEYs.colsROF#">,
		
									#rsKEYs.secOF#,
		
									#rsKEYs.clu#,
									'#rsKEYs.idxTip#',
									#rsKEYs.gen#,
									#rsKEYs.del#
								)
							</cfquery>				
			
							<cfquery datasource="asp">
								update DBMkey
								   set IDver	= #LvarIDver#
								   
									 , tip		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsKEYs.tip#">
									 , cols		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsKEYs.cols#">
									 , ref		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsKEYs.ref#">
									 , colsR	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsKEYs.colsR#">
		
									 , clu		= #rsKEYs.clu#
									 , idxTip	= '#rsKEYs.idxTip#'
									 , gen		= #rsKEYs.gen#
									 , del		= #rsKEYs.del#
								 where IDkey	= #rsKEYs.IDkey#
							</cfquery>
						</cfif>
					</cfloop>
				</cfif>
				<cfif LvarDBMcambiado>
					<cfquery datasource="asp">
						update DBMtabV
						   set op = 2
						 where IDver = #LvarIDver#
						   and IDtab = #LvarIDtab#
					</cfquery>
				</cfif>
			</cfloop>
		
		
			<cfquery datasource="asp">
				delete from DBMkeyU
				 where 
					(
						select count(1) from DBMtabU t
						 where t.IDtab = DBMkeyU.IDtab
						   and t.IDupl = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDupl#">
					)	> 0
			</cfquery>
			<cfquery datasource="asp">
				delete from DBMcolU
				 where 
					(
						select count(1) from DBMtabU t
						 where t.IDtab = DBMcolU.IDtab
						   and t.IDupl = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDupl#">
					)	> 0
			</cfquery>
			<cfquery datasource="asp">
				delete from DBMtabU
				 where IDupl = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDupl#">
			</cfquery>
			<cfquery name="rsInsert" datasource="asp">
				update DBMuploads
				   set 	 sts	= 4		<!--- Version Generada --->
						,stsP	= 0
						,tabsP	= tabs
						,msg 	= null
				 where IDupl = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDupl#">
			</cfquery>
		<cfcatch type="any">
			<cfset sbUPLOAD_error (cfcatch, Arguments.IDupl, "UPLOAD_toVersion")>
			<cfreturn -1>
		</cfcatch>
		</cftry>
		
		<cfreturn LvarIDver>
	</cffunction>
	
    <cffunction name="fnSinSaltoLinea" returntype="string" output="no">
        <cfargument name="hilera">
        <cfreturn replace(replace(replace(Arguments.hilera,vbCrLf," ","ALL"),chr(13)," ","ALL"),chr(10)," ","ALL")>
    </cffunction>

	<cffunction name="PDs_fromUpload" output="no" returntype="void">
		<cfargument name="conexion" required="yes">
		<cfargument name="IDupl" required="yes">
	
			<cfset creaTablas(Arguments.Conexion)>
	
			<cfquery datasource="asp">
				update DBMuploads
				   set 	stsP	= 3, 		<!--- Preparando Upload --->
						tabsP	= 1,
						msg		= null,
						html	= null
				 where IDupl = #Arguments.IDupl#
			</cfquery>
		
			<cfquery datasource="#Arguments.Conexion#">
				insert into #tabPD# (tab, des, rul, gen, genVer, del, suf13, suf25, tabAnt)
				select 
						tab, des, rul, gen, genVer, del, suf13, suf25, tabAnt
				  from <cf_dbdatabase table="DBMtabU" datasource="asp"> t
				 where IDupl = #Arguments.IDupl#
			</cfquery>
			<cfset LvarTabsP = fnUpdateTabsP("UPLOAD", Arguments.IDupl, 15)>
		
			<cfquery datasource="#Arguments.Conexion#">
				insert into #colPD# (tab, col, sec, des, tip, lon, dec, ide, obl, dfl, ini, minVal, maxVal, lov, genVer, del, colAnt)
				select t.tab, c.col, c.sec, c.des, rtrim(c.tip), c.lon, c.dec, c.ide, c.obl, c.dfl, c.ini, c.minVal, c.maxVal, c.lov, c.genVer, c.del, c.colAnt
				  from <cf_dbdatabase table="DBMtabU" datasource="asp"> t
					inner join <cf_dbdatabase table="DBMcolU" datasource="asp"> c
						on c.IDtab = t.IDtab
				 where IDupl = #Arguments.IDupl#
			</cfquery>
			<cfset LvarTabsP = fnUpdateTabsP("UPLOAD", Arguments.IDupl, 30)>
		
			<cfset LvarKeyO = fnKeyOsql("k.tip")>
			<cfquery datasource="#Arguments.Conexion#">
				insert into #keyPD# (tab, cols, tip, ref, colsR, sec, clu, idxTip, gen, genVer, del, ant, keyO)
				select t.tab, k.cols, k.tip, k.ref, k.colsR, k.sec, k.clu, k.idxTip, k.gen, k.genVer, k.del
						, case when colsAnt is null then 0 else 1 end
						, #preserveSingleQuotes(LvarKeyO)#
				  from <cf_dbdatabase table="DBMtabU" datasource="asp"> t
					inner join <cf_dbdatabase table="DBMkeyU" datasource="asp"> k
						on k.IDtab = t.IDtab
				 where IDupl = #Arguments.IDupl#
			</cfquery>

			<cfquery name="rsSQL" datasource="asp">
				select 
					  m.IDsch
				  from DBMuploads u 
					inner join DBMmodelos m on m.IDmod=u.IDmod 
					inner join DBMsch s on s.IDsch=m.IDsch
				 where u.IDupl = #Arguments.IDupl#
			</cfquery>
			
			<cfset LvarIDsch = rsSQL.IDsch>
	
			<!--- colsAnt: PK, AK y sus FKs --->
			<cfquery datasource="#Arguments.Conexion#">
				insert into #keyPD# (tab, cols, tip, ref, colsR, sec, clu, idxTip, gen, genVer, del, ant, keyO)
				select tt.tab, kk.cols, kk.tip, kk.ref, kk.colsR, kk.sec, kk.clu, kk.idxTip, k.gen, 1, 1, 1
						, #preserveSingleQuotes(LvarKeyO)#
				  from <cf_dbdatabase table="DBMtabU" datasource="asp"> t
					inner join <cf_dbdatabase table="DBMkeyU" datasource="asp"> k
						on k.IDtab = t.IDtab
					inner join <cf_dbdatabase table="DBMtab" datasource="asp"> tt
						inner join <cf_dbdatabase table="DBMkey" datasource="asp"> kk
							on kk.IDtab = tt.IDtab
					    on tt.IDsch			= #LvarIDsch#
					   and tt.tab			= t.tab
					   and kk.cols			= k.colsAnt
					   and kk.tip			= k.tip
					   and kk.del			= 0
				 where IDupl = #Arguments.IDupl#
				   and k.colsAnt is not null
			</cfquery>
			<cfquery datasource="#Arguments.Conexion#">
				insert into #keyPD# (tab, cols, tip, ref, colsR, sec, clu, idxTip, gen, genVer, del, ant, keyO)
				select tt.tab, kk.cols, kk.tip, kk.ref, kk.colsR, kk.sec, kk.clu, kk.idxTip, kk.gen, 1, 1, 1
						, #preserveSingleQuotes(LvarKeyO)#
				  from <cf_dbdatabase table="DBMtabU" datasource="asp"> t
					inner join <cf_dbdatabase table="DBMkeyU" datasource="asp"> k
						on k.IDtab = t.IDtab
					inner join <cf_dbdatabase table="DBMtab" datasource="asp"> tt
						inner join <cf_dbdatabase table="DBMkey" datasource="asp"> kk
							on kk.IDtab = tt.IDtab
					    on tt.IDsch			= #LvarIDsch#
					   and kk.ref			= t.tab
					   and kk.colsR			= k.colsAnt
					   and kk.del			= 0
				 where IDupl = #Arguments.IDupl#
				   and k.colsAnt is not null
			</cfquery>

			<cfquery datasource="#Arguments.Conexion#">
				insert into #tabPD# (tab, des, rul, gen, genVer, del, suf13, suf25, tabAnt, newFKs)
				select tt.tab, tt.des, tt.rul, 1, 1, 1 as del, tt.suf13, tt.suf25, tt.tabAnt, 0 as newFKs
				  from <cf_dbdatabase table="DBMtabU" datasource="asp"> t
					inner join <cf_dbdatabase table="DBMkeyU" datasource="asp"> k
						on k.IDtab = t.IDtab
					inner join <cf_dbdatabase table="DBMtab" datasource="asp"> tt
						inner join <cf_dbdatabase table="DBMkey" datasource="asp"> kk
							on kk.IDtab = tt.IDtab
					    on tt.IDsch			= #LvarIDsch#
					   and kk.ref			= t.tab
					   and kk.colsR			= k.colsAnt
					   and kk.del			= 0
				 where IDupl = #Arguments.IDupl#
				   and k.colsAnt is not null
				   and (
				 		select count(1)
						  from #tabPD#
						 where tab = tt.tab
						) = 0
				   <!--- Solo la primera vez --->
				   and (
				   		select count(1)
						  from <cf_dbdatabase table="DBMtab" datasource="asp"> tt
							inner join <cf_dbdatabase table="DBMkey" datasource="asp"> kk
								on kk.IDtab = tt.IDtab
						 where tt.IDsch			= #LvarIDsch#
						   and tt.tab			= t.tab
						   and kk.cols			= k.cols
						   and kk.del			= 0
						) = 0
			</cfquery>

			<cfset LvarTabsP = fnUpdateTabsP("UPLOAD", Arguments.IDupl, 50)>
	
			<cfset PDs_fromAjustes(Arguments.Conexion, LvarIDsch, "UPLOAD",Arguments.IDupl)>
	</cffunction>
	
	<cffunction name="PDs_fromVersions" output="no" returntype="void">
		<cfargument name="conexion" required="yes">
		<cfargument name="tipo"		required="yes">
		<cfargument name="tipoID"	required="yes"  type="numeric">
		<cfargument name="IDver"	default="0"		type="numeric">
		<cfargument name="tablas"	default=""		type="string">
	
		<cfif Arguments.tipo NEQ "BASECERO">
			<cfset creaTablas(Arguments.conexion, Arguments.tipo)>
		</cfif>
		
		<cfset OP = 0>
		<cfif Arguments.tipo EQ "BASECERO">
			<cfset OP = 1>
			<cfquery name="rsSQL" datasource="asp">
				select IDsch
				  from DBMmodelos
				 where IDmod = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.tipoID#">
			</cfquery>
			<cfset LvarIDsch = rsSQL.IDsch>
			<cfquery datasource="#Arguments.conexion#">
				insert into #tabPD# 
						(OP, tab, des, rul, gen, genVer, del, suf13, suf25, tabAnt)
				select   1,  tab, des, rul, 1,   1,      del, suf13, suf25, tabAnt
				  from <cf_dbdatabase table="DBMtab" datasource="asp"> t
				 where (
						select count(1)
						  from <cf_dbdatabase table="DBMtabV" datasource="asp"> tv
					<cfif Arguments.IDver EQ 0>
						 inner join <cf_dbdatabase table="DBMversiones" datasource="asp"> v
							on v.IDver	= tv.IDver
						 where tv.IDtab	= t.IDtab
						   and v.IDmod 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.tipoID#">
					<cfelse>
						 where tv.IDver = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDver#">
						   and tv.IDtab	= t.IDtab
					</cfif>
						) > 0
				   and IDmodORI IS NOT NULL
			</cfquery>
		<cfelseif Arguments.tipo EQ "UPLOAD">
			<cfquery datasource="asp">
				update DBMuploads
				   set 	stsP	= 3, 		<!--- Preparando Upload --->
						tabsP	= 1,
						msg		= null,
						html	= null
				 where IDupl = #Arguments.tipoID#
			</cfquery>
			
			<cfquery name="rsSQL" datasource="asp">
				select 
					  m.IDsch
				  from DBMuploads u 
					inner join DBMmodelos m on m.IDmod=u.IDmod 
					inner join DBMsch s on s.IDsch=m.IDsch
				 where u.IDupl = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.tipoID#">
			</cfquery>
			<cfset LvarIDsch = rsSQL.IDsch>
			<cfquery datasource="#Arguments.conexion#">
				insert into #tabPD# 
						(tab, des,   rul,   gen, genVer, del,   suf13,   suf25, tabAnt)
				select t.tab, t.des, t.rul, 1,   1,      t.del, t.suf13, t.suf25, t.tabAnt
				  from <cf_dbdatabase table="DBMtabV" datasource="asp"> v
					inner join <cf_dbdatabase table="DBMtab" datasource="asp"> t
					 on t.IDtab = v.IDtab
					and t.IDsch = #LvarIDsch# 
					and t.IDmodORI IS NOT NULL
				  where v.IDver = (select IDver from DBMuploads where IDupl = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDupl#">)
			</cfquery>
		<cfelseif Arguments.tipo EQ "UPGRADE">
			<cfquery datasource="asp">
				update DBMgenP
				   set 	stsP	= 3, 		<!--- Cargando Version --->
						tabsP	= 1,
						msg		= null
				 where IDgen = #Arguments.tipoID#
			</cfquery>
			
			<cfquery name="rsSQL" datasource="asp">
				select v.IDver, m.IDsch
				  from DBMgen g
					inner join DBMversiones v	on v.IDver between g.IDverIni and g.IDverFin and v.IDmod = g.IDmod
					inner join DBMmodelos m 	on m.IDmod=g.IDmod
					inner join DBMsch s 		on s.IDsch=m.IDsch
				 where g.IDgen = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.tipoID#">
			</cfquery>
			<cfset LvarIDsch = rsSQL.IDsch>
			<cfquery datasource="#Arguments.conexion#">
				insert into #tabPD# 
						(tab, des,   rul,   gen,   genVer, del, suf13,   suf25, tabAnt)
				select distinct 	t.tab, t.des, t.rul, 1,     1,    t.del, t.suf13, t.suf25, t.tabAnt
				  from <cf_dbdatabase table="DBMtabV" datasource="asp"> v
					inner join <cf_dbdatabase table="DBMtab" datasource="asp"> t
					 on t.IDtab = v.IDtab
					and t.IDsch = #LvarIDsch# 
					and t.IDmodORI IS NOT NULL
				  where v.IDver IN (<cfqueryparam cfsqltype="cf_sql_numeric" value="#valueList(rsSQL.IDver)#" list="yes">)
			</cfquery>
			<cfquery name="rsSQL" datasource="#Arguments.conexion#">
				select coalesce(count(1),0) as cantidad from #tabPD#
			</cfquery>
			<cfquery datasource="asp">
				update DBMgenP
				   set tabs = #rsSQL.cantidad#
				 where IDgen = #Arguments.tipoID#
			</cfquery>
		<cfelseif Arguments.tipo EQ "UPDATE">
			<cfset LvarIDsch = Arguments.tipoID>
			<cfquery name="rsSQL" datasource="asp">
				select count(1) as cantidad
				  from DBMtab t
				  where t.IDsch = #LvarIDsch# 
					and t.IDmodORI IS NOT NULL
				    and t.tab IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#tablas#" list="yes">)
			</cfquery>
			<cfif rsSQL.cantidad EQ 0>
				<cfthrow message="No se encontró ninguna tabla en IDsch=#LvarIDsch#">
			</cfif>
			<cfquery datasource="#Arguments.conexion#">
				insert into #tabPD# 
						(tab, des,   rul,   gen,   genVer, del, suf13,   suf25, tabAnt)
				select distinct 	t.tab, t.des, t.rul, 1,     1,    t.del, t.suf13, t.suf25, t.tabAnt
				  from <cf_dbdatabase table="DBMtab" datasource="asp"> t
				  where t.IDsch = #LvarIDsch# 
					and t.IDmodORI IS NOT NULL
				    and t.tab IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#tablas#" list="yes">)
			</cfquery>
		</cfif>
		
		<cfset fnUpdateTabsP (Arguments.tipo, Arguments.tipoID, 15)>
	
		<cfquery datasource="#Arguments.conexion#">
			insert into #colPD# (OP,tab, col, sec, des, tip, lon, dec, ide, obl, dfl, ini, minVal, maxVal, lov, genVer, del, colAnt)
			select #OP#,t.tab, c.col, c.sec, c.des, rtrim(c.tip), c.lon, c.dec, c.ide, c.obl, c.dfl, c.ini, c.minVal, c.maxVal, c.lov, 1, c.del, c.colAnt
			  from #tabPD# p
				inner join <cf_dbdatabase table="DBMtab" datasource="asp"> t
					 on t.IDsch	= #LvarIDsch#
					and t.tab 	= p.tab
					and t.IDmodORI	IS NOT NULL
					and t.del	= 0
				inner join <cf_dbdatabase table="DBMcol" datasource="asp"> c
					 on c.IDtab = t.IDtab
		</cfquery>
	
		<cfset fnUpdateTabsP (Arguments.tipo, Arguments.tipoID, 30)>
	
		<cfset LvarKeyO = fnKeyOsql("k.tip")>
		<cfquery datasource="#Arguments.conexion#">
			insert into #keyPD# (OP,tab, cols, tip, ref, colsR, sec, clu, idxTip, gen, genVer, del, keyO)
			select #OP#, t.tab, k.cols, k.tip, k.ref, k.colsR, k.sec, k.clu, k.idxTip, k.gen, 1, k.del
					, #preserveSingleQuotes(LvarKeyO)#
			  from #tabPD# p
				inner join <cf_dbdatabase table="DBMtab" datasource="asp"> t
					 on t.IDsch	= #LvarIDsch#
					and t.tab 	= p.tab
					and t.IDmodORI	IS NOT NULL
					and t.del	= 0
				inner join <cf_dbdatabase table="DBMkey" datasource="asp"> k
					on k.IDtab = t.IDtab
		</cfquery>
	
		<cfset fnUpdateTabsP (Arguments.tipo, Arguments.tipoID, 50)>
	
		<cfset PDs_fromAjustes(Arguments.conexion, LvarIDsch, Arguments.tipo, Arguments.tipoID)>
	</cffunction>
	
	<cffunction name="fnUpdateTabsP" output="no" returntype="numeric">
		<cfargument name="tipo" 	required="yes">
		<cfargument name="tipoID"	required="yes"  type="numeric">
		<cfargument name="tabsP"	required="yes"  type="numeric">
		<cfargument name="porcen"	default="false" type="boolean">
		<cfargument name="Process"	default="">
	
		<cfset LvarToScript_log = (Arguments.tipo EQ "XML" OR Arguments.tipo EQ "UPDATE")>
		<cfif Arguments.tabsP EQ "-1">
			<cfif LvarToScript_log AND GvarUpdateTabsP EQ "">
				<cffile action="write" file="#replace(GvarScript,".sql","_log.txt")#" output="">
			</cfif>
			<cfset GvarUpdateTabsT1 = getTickCount()>
			<cfset GvarUpdateTabsP = ": #Arguments.Process#">
			<cfif LvarToScript_log>
				<cffile action="write" file="#replace(GvarScript,".sql",".txt")#" output="INICIANDO #GvarUpdateTabsP#">
			</cfif>
			<cfreturn 0>
		<cfelseif Arguments.Porcen>
			<cf_dbfunction name="to_number" args="tabs * #Arguments.tabsP#" datasource="asp" returnVariable="LvarInt">
		<cfelse>
			<cfset LvarInt = Arguments.tabsP>
		</cfif>
		<cfif Arguments.tipo EQ "UPLOAD">
			<cfquery datasource="asp">
				update DBMuploads
				   set tabsP	= #LvarInt#
				 where IDupl	= #Arguments.tipoID#
			</cfquery>
		<cfelseif Arguments.tipo EQ "UPGRADE">
			<cfquery datasource="asp">
				update DBMgenP
				   set tabsP	= #LvarInt#
				 where IDgen	= #Arguments.tipoID#
			</cfquery>
		<cfelseif LvarToScript_log>
			<cfif Arguments.Porcen>
				<cfset LvarVal = "#numberFormat(Arguments.tabsP*100,",9.00")#%">
			<cfelse>
				<cfset LvarVal = "#numberFormat(Arguments.tabsP,",9.00")#">
			</cfif>
			<cffile action="write" 	file="#replace(GvarScript,".sql",".txt")#" 		output="Avance #LvarVal##GvarUpdateTabsP#, segs=#numberFormat((getTickCount()-GvarUpdateTabsT2)/1000,",9.0000")# #numberFormat((getTickCount()-GvarUpdateTabsT1)/1000,",9.0000")# #numberFormat((getTickCount()-GvarUpdateTabsT0)/1000,",9.0000")#">
			<cffile action="append"	file="#replace(GvarScript,".sql","_log.txt")#" 	output="Avance #LvarVal##GvarUpdateTabsP#, segs=#numberFormat((getTickCount()-GvarUpdateTabsT2)/1000,",9.0000")# #numberFormat((getTickCount()-GvarUpdateTabsT1)/1000,",9.0000")# #numberFormat((getTickCount()-GvarUpdateTabsT0)/1000,",9.0000")#">
			<cfset GvarUpdateTabsT2 = getTickCount()>
		</cfif>
		
		<cfreturn Arguments.tabsP>
	</cffunction>
	
	<cffunction name="XML_toDB" access="public" output="no">
		<cfargument name="conexion" required="yes">
		<cfargument name="IDsch" 	required="yes">
		<cfargument name="path" 	required="yes">
		<cfargument name="xml" 		required="yes">
		<cfargument name="gen" 		required="yes" type="numeric">
	
		<cfset LvarConexion = Arguments.conexion>
	
		<cfset GvarScript = expandPath("/asp/parches/DBmodel/scripts/") & replace(Arguments.xml,".xml",".sql")>
		<cfif Arguments.gen EQ 2>
			<cfset LvarOK = toDatabase(LvarConexion, "XML", 0)>
			<CF_dbTemp_deletes>
			<cfabort>
		</cfif>
	
		<cfset LvarTit =
					"SCRIPT DE BASE DE DATOS #ucase(Application.dsinfo[LvarConexion].type)# PARA:#vbCrLf#" &
					"GENERAR UNICAMENTE EN:#vbCrLf#" &
					"	SERVER:  http://#cgi.http_host##vbCrLf#" &
					"	DSN:     #LvarConexion##vbCrLf#" &
					"	FECHA:   #dateFormat(now(),"DD/MM/YYYY")# #timeFormat(now(),"HH:mm:ss")#"
		>
	
		<cfset LvarObjDB = createObject("component", "DBModel_#Application.dsinfo[LvarConexion].type#").init(this,LvarConexion)>
		<cfset PDs_fromXML (LvarConexion, Arguments.IDsch, Arguments.path & "/" & Arguments.xml)>
	
		<cfquery name="rsSQL" datasource="#LvarConexion#">
			select distinct tab, tabAnt from #tabPD#
			 where gen = 1
		</cfquery>
	
		<cfset DBs_fromDatabase(LvarConexion, rsSQL, "XML","0",Arguments.IDsch)>
	
		<cfset PDsDBs_Comparation(LvarConexion, "XML", "0")>
	
		<cfset LvarRES = sbPrint_Comparation(LvarConexion,"XML")>
	
		<cfset GvarHTML = replace(GvarScript,".sql",".htm")>
		<cffile file="#GvarHTML#" output="#LvarRes.HTML#" action="write">
		<cfset LvarDenegar	= LvarRes.Denegar>
		<cfset LvarCambios	= LvarRes.Cambios>
		<cfset LvarHTML		= LvarRes.HTML>
	
		<cfset toScriptDB(LvarConexion, "XML", "0", LvarTit)>
	
		<cfif Arguments.gen EQ 1>
			<cfset LvarOK = toDatabase(LvarConexion, "XML", 0)>
		</cfif>
		<CF_dbTemp_deletes>
	</cffunction>
	
	<cffunction name="PDs_fromXML" output="no" access="public">
		<cfargument name="conexion"	required="yes">
		<cfargument name="IDsch"	required="yes">
		<cfargument name="archivo"	required="yes">
	
		<cfset fnUpdateTabsP("XML", 0, -1, false, "PDs_fromXML")>
		<cftry>
			<cfset creaTablas(Arguments.conexion)>
	
			<cffile action="read" file="#Arguments.Archivo#" variable="LvarXML">
			<cfset LvarDOC 		= XmlParse(LvarXML)>
			<cfset LvarDocTabs 	= LvarDoc.version>
	
			<cfset LvarTabsP = 0>
			<cfset LvarTabsN = arrayLen(LvarDocTabs.tab)>
			<cfloop index="t" from="1" to="#LvarTabsN#">
				<cfif t - LvarTabsP GT 10>
					<cfset fnUpdateTabsP("XML", 0, t/arrayLen(LvarDocTabs.tab)*100)>
					<cfset LvarTabsP = t>
				</cfif>
				<cfset LvarTAB = LvarDocTabs.tab[t]>
				<cfset LvarTabla = rtrim(LvarTAB.XmlAttributes.cod)>
				<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
					select count(1) as cantidad
					  from #tabPD#
					 where tab	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTabla#">
				</cfquery>	
				<cfif rsSQL.cantidad EQ 0>
					<cfparam name="LvarTAB.XmlAttributes.gen"		default="1">
					<cfparam name="LvarTAB.XmlAttributes.rul"		default="">
					<cfparam name="LvarTAB.XmlAttributes.genVer"	default="1">
					<cfparam name="LvarTAB.XmlAttributes.del"		default="0">
					<cfparam name="LvarTAB.XmlAttributes.suf13"		default="0">
					<cfparam name="LvarTAB.XmlAttributes.suf25"		default="0">
					<cfparam name="LvarTAB.XmlAttributes.ren"		default="">
					
					<cfquery name="rsInsert" datasource="#Arguments.Conexion#">
						insert into #tabPD# (tab, des, rul, gen, genVer, del, suf13, suf25, tabAnt)
						values (
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTabla#">
							,<cfqueryparam cfsqltype="cf_sql_varchar" value="#fnSinSaltoLinea(LvarTAB.XmlAttributes.des)#">
							,<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTAB.XmlAttributes.rul#"	null="#trim(LvarTAB.XmlAttributes.rul) EQ ''#">
							,<cfqueryparam cfsqltype="cf_sql_bit" 	  value="#LvarTAB.XmlAttributes.gen#">
							,<cfqueryparam cfsqltype="cf_sql_bit" 	  value="#LvarTAB.XmlAttributes.genVer#">
							,<cfqueryparam cfsqltype="cf_sql_bit" 	  value="#LvarTAB.XmlAttributes.del#">
							,<cfqueryparam cfsqltype="cf_sql_integer" value="#LvarTAB.XmlAttributes.suf13#">
							,<cfqueryparam cfsqltype="cf_sql_integer" value="#LvarTAB.XmlAttributes.suf25#">
							,<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTAB.XmlAttributes.ren#"	null="#trim(LvarTAB.XmlAttributes.ren) EQ ''#">
						)
					</cfquery>	
					
					<cfif LvarTAB.XmlAttributes.gen EQ "1" AND LvarTAB.XmlAttributes.del EQ "0"> 
						<cfloop index="c" from="1" to="#arrayLen(LvarTAB.col)#">
							<cfset LvarCOL = LvarTAB.col[c]>
							<cfparam name="LvarCOL.XmlAttributes.lon"		default="0">
							<cfparam name="LvarCOL.XmlAttributes.dec"		default="0">
							<cfparam name="LvarCOL.XmlAttributes.ide"		default="0">
							<cfparam name="LvarCOL.XmlAttributes.obl"		default="0">
							<cfparam name="LvarCOL.XmlAttributes.dfl"		default="">
							<cfparam name="LvarCOL.XmlAttributes.ini"		default="">
							<cfparam name="LvarCOL.XmlAttributes.min"		default="">
							<cfparam name="LvarCOL.XmlAttributes.max"		default="">
							<cfparam name="LvarCOL.XmlAttributes.lov"		default="">
							<cfparam name="LvarCOL.XmlAttributes.sec"		default="#c#">
							<cfparam name="LvarCOL.XmlAttributes.genVer"	default="1">
							<cfparam name="LvarCOL.XmlAttributes.del"		default="0">
							<cfparam name="LvarCOL.XmlAttributes.ren"		default="">
							<cfset LvarTip = LvarCOL.XmlAttributes.tip>
							<cfquery datasource="#Arguments.Conexion#">
								insert into #colPD# (tab, col, sec, des, tip, lon, dec, ide, obl, dfl, ini, minVal, maxVal, lov, genVer, del, colAnt)
								values (
									 '#LvarTabla#'
									,<cfqueryparam value="#LvarCOL.XmlAttributes.cod#"			cfsqltype="cf_sql_varchar">
									,#LvarCOL.XmlAttributes.sec#
									,<cfqueryparam value="#fnSinSaltoLinea(LvarCOL.XmlAttributes.des)#"			cfsqltype="cf_sql_varchar">
									,<cfqueryparam value="#trim(LvarCOL.XmlAttributes.tip)#"	cfsqltype="cf_sql_char">
									,<cfqueryparam value="#LvarCOL.XmlAttributes.lon#"			cfsqltype="cf_sql_integer">
									,<cfqueryparam value="#LvarCOL.XmlAttributes.dec#"			cfsqltype="cf_sql_integer">
									,<cfqueryparam value="#LvarCOL.XmlAttributes.ide#"			cfsqltype="cf_sql_bit">
									,<cfqueryparam value="#LvarCOL.XmlAttributes.obl#"			cfsqltype="cf_sql_bit">
									,<cfqueryparam value="#LvarCOL.XmlAttributes.dfl#"			cfsqltype="cf_sql_varchar"	null="#trim(LvarCOL.XmlAttributes.dfl) EQ ''#">
									,<cfqueryparam value="#LvarCOL.XmlAttributes.ini#"			cfsqltype="cf_sql_varchar"	null="#trim(LvarCOL.XmlAttributes.ini) EQ ''#">
									,<cfqueryparam value="#LvarCOL.XmlAttributes.min#"			cfsqltype="cf_sql_varchar"	null="#trim(LvarCOL.XmlAttributes.min) EQ ''#">
									,<cfqueryparam value="#LvarCOL.XmlAttributes.max#"			cfsqltype="cf_sql_varchar"	null="#trim(LvarCOL.XmlAttributes.max) EQ ''#">
									,<cfqueryparam value="#LvarCOL.XmlAttributes.lov#"			cfsqltype="cf_sql_clob">
									,<cfqueryparam value="#LvarCOL.XmlAttributes.genVer#"		cfsqltype="cf_sql_bit">
									,<cfqueryparam value="#LvarCOL.XmlAttributes.del#"			cfsqltype="cf_sql_bit">
									,<cfqueryparam value="#LvarCOL.XmlAttributes.ren#"			cfsqltype="cf_sql_varchar"	null="#trim(LvarCOL.XmlAttributes.ren) EQ ''#">
								)
							</cfquery>
						</cfloop>
						<cfif isdefined("LvarTAB.key")>
							<cfloop index="k" from="1" to="#arrayLen(LvarTAB.key)#">
								<cfset LvarKey = LvarTAB.key[k]>
								<cfparam name="LvarKey.XmlAttributes.ref"		default="*">
								<cfparam name="LvarKey.XmlAttributes.colsR"		default="*">
		
								<cfparam name="LvarKey.XmlAttributes.clu"		default="0">
								<cfparam name="LvarKey.XmlAttributes.idxTip"	default="#LvarKey.XmlAttributes.tip#">
								<cfparam name="LvarKey.XmlAttributes.gen"		default="#LvarTAB.XmlAttributes.gen#">
								<cfparam name="LvarKey.XmlAttributes.genVer"	default="1">
								<cfparam name="LvarKey.XmlAttributes.del"		default="0">
		
								<cfquery datasource="#Arguments.Conexion#">
									insert into #keyPD# (tab, cols, tip, ref, colsR, sec, clu, idxTip, gen, genVer, del, keyO)
									values (
										 '#LvarTabla#'
										,<cfqueryparam value="#LvarKey.XmlAttributes.cols#"		cfsqltype="cf_sql_varchar">
										,<cfqueryparam value="#LvarKey.XmlAttributes.tip#"		cfsqltype="cf_sql_varchar">
										,<cfqueryparam value="#LvarKey.XmlAttributes.ref#"		cfsqltype="cf_sql_varchar">
										,<cfqueryparam value="#LvarKey.XmlAttributes.colsR#"	cfsqltype="cf_sql_varchar">
										,<cfqueryparam value="#LvarKey.XmlAttributes.sec#"		cfsqltype="cf_sql_integer">
										,<cfqueryparam value="#LvarKey.XmlAttributes.clu#"		cfsqltype="cf_sql_bit">
										,<cfqueryparam value="#LvarKey.XmlAttributes.idxTip#"	cfsqltype="cf_sql_varchar">
										,<cfqueryparam value="#LvarKey.XmlAttributes.gen#"		cfsqltype="cf_sql_bit">
										,<cfqueryparam value="#LvarKey.XmlAttributes.genVer#"	cfsqltype="cf_sql_bit">
										,<cfqueryparam value="#LvarKey.XmlAttributes.del#"		cfsqltype="cf_sql_bit">
										,<cfqueryparam value="#fnKeyO(LvarKey.XmlAttributes.tip)#" 
																								cfsqltype="cf_sql_integer">
	
									)
								</cfquery>
							</cfloop>
						</cfif>
					</cfif>
				</cfif>
			</cfloop>
	
			<cfset fnUpdateTabsP("XML", 0, 100, false)>
	
			<cfset PDs_fromAjustes(Arguments.Conexion,Arguments.IDsch,"XML",0)>
			<cfset fnUpdateTabsP("XML", 0, 100, false, "PDs_fromAjustes")>
			
		<cfcatch type="any">
			<cfrethrow>
		</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="PDs_fromAjustes" access="package" output="no">
		<cfargument name="conexion"	required="yes">
		<cfargument name="IDsch"	required="yes">
		<cfargument name="tipo"		required="yes">
		<cfargument name="tipoID"	required="yes"  type="numeric">
	


		<cfif Arguments.IDsch NEQ 0 AND Arguments.tipo EQ "UPLOAD">
			<!--- REFERENCIAS PD: Obtiene las tablas REFERENCIADAS que no han sido incluidas en la actualización, cuyos campos PK/AK fueron cambiados --->
			<cfset add_RelationsChg(Arguments.conexion,Arguments.IDsch,Arguments.tipo,Arguments.tipoID,"R",colPD)>
			<!--- DEPENDENCIAS PD: Obtiene las tablas DEPENDIENTES que no han sido incluidas en la actualización, cuyos campos PK/AK fueron cambiados --->
			<cfset add_RelationsChg(Arguments.conexion,Arguments.IDsch,Arguments.tipo,Arguments.tipoID,"D",colPD)>
		</cfif>

		<!--- KEYsDel:		LLAVES CON CAMPOS RENOMBRADOS EN POWER DESIGNER --->
		<!--- keyDB OP = 4:	BORRAR EN BASE DE DATOS (alter drop) --->
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			update #keyPD#
			   set OP = 4, idxTip = '*', del=1
			 where del = 0
			   and (
					select count(1)
					  from <cf_dbdatabase table="DBMtab" datasource="asp"> t
					  inner join <cf_dbdatabase table="DBMcol" datasource="asp"> d
						 on d.IDtab = t.IDtab
					 where t.IDsch	= #Arguments.IDsch#
					   and t.tab	= #keyPD#.tab
					   and <cf_dbfunction name="LIKE" args="',' #CONCAT# rtrim(#keyPD#.cols) #CONCAT# ',' LIKE '%,' #CONCAT# rtrim(d.colAnt) #CONCAT# ',%'" delimiters="°" datasource="#Arguments.conexion#">
					) > 0
		</cfquery>
	
		<cfset LvarObjDB.ajustaPDs(Arguments.Conexion,Arguments.tipo,Arguments.tipoID)>
	</cffunction>
	
	<cffunction name="DBs_fromDatabase" access="package" output="no">
		<cfargument name="conexion" 	required="yes">
		<cfargument name="rsOBJECTS"	required="yes"	type="query">
		<cfargument name="TIPO"			required="yes">
		<cfargument name="tipoID"		required="yes"  type="numeric">
		<cfargument name="IDsch"		required="no">
	
		<cfset LvarTabsP = fnUpdateTabsP(Arguments.tipo, Arguments.tipoID, "-1", false, "DBs_fromDatabase")>

		<!--- Renombra Objetos (PK,AK,FK,UI,FI,ID) que su nombre está utilizado en otra tabla --->
		<cfset sbRenameObjs (Arguments.conexion)>

		<cfset LvarObjDB.fromDatabase(Arguments.Conexion, Arguments.rsOBJECTS, Arguments.TIPO, Arguments.TipoID)>
	
		<cfif find(Arguments.tipo,"UPGRADE,XML")>
			<!--- REFERENCIAS PD: Obtiene las tablas REFERENCIADAS que no han sido incluidas en la actualización, cuyos campos PK/AK fueron cambiados --->
			<cfset add_RelationsChg(Arguments.conexion,Arguments.IDsch,Arguments.tipo,Arguments.tipoID,"R",colDB)>
			<!--- DEPENDENCIAS PD: Obtiene las tablas DEPENDIENTES que no han sido incluidas en la actualización, cuyos campos PK/AK fueron cambiados --->
			<cfset add_RelationsChg(Arguments.conexion,Arguments.IDsch,Arguments.tipo,Arguments.tipoID,"D",colDB)>
		</cfif>

		<!--- Mayusculas para Oracle y DB2 --->
		<cfif find(Application.dsinfo[arguments.conexion].type, "db2,oracle")>
			<cfset LvarUPPER = "upper">
		<cfelse>
			<cfset LvarUPPER = "">
		</cfif>
			
		<!--- DEPENDENCIAS DB: Agrega todas las KEYs EN LA BASE DE DATOS de las tablas DEPENDIENTES que no han sido incluidas en la actualización --->
		<cfquery datasource="#Arguments.conexion#">
			update #keyDB# 
			   set OP = -1
			     , tip = 'F'
			 where tip = 'D'
			   and (
					select count(1)
					  from #keyDB# k
					 where k.tab = #keyDB#.tab
					   and k.tip = 'F'
					) = 0
			   and (
					select count(1)
					  from <cf_dbdatabase table="DBMtab" datasource="asp"> t
					 where t.IDsch = #Arguments.IDsch# 
					   and #LvarUPPER#(t.tab) = #keyDB#.tab
					   and t.IDmodORI is not null
					   and t.del	= 0
					) > 0
		</cfquery>
		<cfquery datasource="#Arguments.conexion#">
			delete from #keyDB# 
			 where tip = 'D'
			   and (
					select count(1)
					  from #keyDB# k
					 where k.tab	= #keyDB#.tab
					   and k.cols	= #keyDB#.cols
					   and k.ref	= #keyDB#.ref
					   and k.colsR	= #keyDB#.colsR
					   and k.tip	= 'F'
					) > 0
		</cfquery>
		<cfquery datasource="#Arguments.conexion#">
			delete from #keyDB# 
			 where tip = 'D'
			   and (
					select count(1)
					  from #keyDB# k
					 where k.tab = #keyDB#.tab
					   and k.tip = 'F'
					) > 0
			   and (
					select count(1)
					  from <cf_dbdatabase table="DBMtab" datasource="asp"> t
					 where t.IDsch = #Arguments.IDsch# 
					   and #LvarUPPER#(t.tab) = #keyDB#.tab
					   and t.IDmodORI is not null
					   and t.del	= 0
					) > 0
		</cfquery>

		<!--- Referencias que se borraron de tablas externas al DBM --->
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			select tab as aatab, #keyDB#.* 
			  from #keyDB# 
			 where tip = 'F'
			   and (
					select count(1)
					  from <cf_dbdatabase table="DBMtab" datasource="asp"> t
					 where t.IDsch	= #Arguments.IDsch# 
					   and #LvarUPPER#(t.tab)	= #keyDB#.tab
					   and t.IDmodORI is not null
					   and t.del	= 0
					) = 0
				order by 1
		</cfquery>

		<cfset fnUpdateTabsP(Arguments.tipo, Arguments.tipoID, 100, true, "DBs_fromDatabase")>
	</cffunction>
	
	<cffunction name="add_RelationsChg" access="package" output="no">
		<cfargument name="conexion"	required="yes">
		<cfargument name="IDsch"	required="yes">
		<cfargument name="tipo"		required="yes">
		<cfargument name="tipoID"	required="yes"  type="numeric">
		<cfargument name="tipoR"	required="yes"  type="string">
		<cfargument name="colPD_DB"	required="yes"  type="string">

		<!--- Tipo CHAR = VARCHAR --->
		<cfif Application.dsinfo[arguments.conexion].charTypeDBM EQ "V">
			<cfset LvarTipT = "case when c.tip = 'C' then 'V' else c.tip end">
			<cfset LvarTipR = "case when rc.tip = 'C' then 'V' else rc.tip end">
		<cfelse>
			<cfset LvarTipT = "c.tip">
			<cfset LvarTipR = "rc.tip">
		</cfif>

		<!--- Mayusculas para Oracle y DB2 --->
		<cfif find(Application.dsinfo[arguments.conexion].type, "db2,oracle")>
			<cfset LvarUPPER = "upper">
		<cfelse>
			<cfset LvarUPPER = "">
		</cfif>
			
		<cfquery  datasource="#Arguments.conexion#">
			delete from #colsRPD#
		</cfquery>
		<cfquery  datasource="#Arguments.conexion#">
			delete from #colRPD#
		</cfquery>
		<cf_dbfunction name="fn_len" returnvariable="LEN">
		<cfquery datasource="#Arguments.conexion#">
			insert into #colsRPD# (tab,cols,ref,colsR,niv,iniT,sigT,iniR,sigR,IDtab)
			<cfif Arguments.tipoR EQ "R">
				<!--- Obtiene las llaves de Referencias no incluidas en el parche --->
				select 	k.tab, rtrim(k.cols)  #CONCAT# ',', 
						k.ref, rtrim(k.colsR) #CONCAT# ',',
						#LEN#(rtrim(cols)) - #LEN#(<cf_dbfunction name="sreplace" args="rtrim(cols);',';rtrim('')" delimiters=";">) + 1,
						0, 0, 0, 0, -1
				  from #keyPD# k
				 where tip = 'F'
				   and (
						select count(1)
						  from #tabPD#
						 where tab = k.ref
						) = 0
			 <cfelse>
				<!--- Obtiene las llaves de Dependencias no incluidas en el parche --->
				select 	#LvarUPPER#(t.tab), #LvarUPPER#(rtrim(k.cols))  #CONCAT# ',',
						#LvarUPPER#(k.ref), #LvarUPPER#(rtrim(k.colsR)) #CONCAT# ',', 
						#LEN#(cols) - #LEN#(<cf_dbfunction name="sreplace" args="rtrim(cols);',';rtrim('')" delimiters=";">) + 1,
						0, 0, 0, 0, k.IDtab
				  from <cf_dbdatabase table="DBMkey" datasource="asp"> k
					inner join #tabPD# tt
						 on tt.tab = #LvarUPPER#(k.ref)
					inner join <cf_dbdatabase table="DBMtab" datasource="asp"> t
						 on t.IDsch = #Arguments.IDsch# 
						and t.IDtab = k.IDtab
						and t.IDmodORI is not null
						and t.del	= 0
				 where k.tip = 'F'
				   and (
						select count(1)
						  from #tabPD#
						 where tab = #LvarUPPER#(t.tab)
						) = 0
			</cfif>
		</cfquery>
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			select max(niv) as colN 
			  from #colsRPD#
		</cfquery>
		<cfif rsSQL.colN eq "">
			<cfreturn>
		</cfif>
		<cfset LvarColN = rsSQL.colN>
		<cfloop index="i" from="1" to="#LvarColN#">
			<cfquery datasource="#Arguments.conexion#">
				update #colsRPD#
				   set iniT = sigT  + 1
					 , sigT = <cf_dbfunction name="sFind" args="cols ;',';sigT+1" delimiters=";">
					 , iniR = sigR + 1
					 , sigR = <cf_dbfunction name="sFind" args="colsR;',';sigR+1" delimiters=";">
				 where niv >= #i#
			</cfquery>

			<cf_dbfunction name="sPart" args="cols ;iniT;sigT-iniT" delimiters=";" returnvariable="LvarColT">
			<cf_dbfunction name="sPart" args="colsR;iniR;sigR-iniR" delimiters=";" returnvariable="LvarColR">
<!---
			<cfset LvarCOLT = "case when iniT > 0 AND sigT-iniT > 0 then #LvarColT# end">
			<cfset LvarCOLR = "case when iniR > 0 AND sigR-iniR > 0 then #LvarColR# end">
--->
			<cfif Arguments.tipoR EQ "R">
				<!--- Las Tablas Referenciadas se incluyen solo si cambio su PK/AK (las FK referencias ya están incluidas) --->
				<!--- Se mantienen las características de la tabla que referencia = tab+col en PDcol  --->
				<cfquery datasource="#Arguments.conexion#">
					insert into #colRPD# (
						tab,  col, 
						ref,  colR,
						tip,  lon, 	dec, 
						tipN, lonN, decN
					)
					select 	distinct
							c.tab, c.col, 
							k.ref, #LvarUPPER#(rc.col), 
							rtrim(rc.tip), rc.lon, rc.dec,
							rtrim(coalesce(cc.tip,c.tip)), coalesce(cc.lon,c.lon), coalesce(cc.dec,c.dec)
					  from #colsRPD# k
						inner join #Arguments.colPD_DB# c
							left join #colPD# cc
								 on cc.tab = c.tab
								and cc.col = c.col
							 on c.tab = k.tab
							and c.col = #preserveSingleQuotes(LvarColT)#
						inner join <cf_dbdatabase table="DBMtab" datasource="asp"> r
							 on r.IDsch = #Arguments.IDsch# 
							and #LvarUPPER#(r.tab) = k.ref
							and r.IDmodORI is not null
							and r.del	= 0
						inner join <cf_dbdatabase table="DBMcol" datasource="asp"> rc
							 on rc.IDtab 	= r.IDtab
							and #LvarUPPER#(rc.col) = #preserveSingleQuotes(LvarColR)#
					 where (
							select count(1)
							  from #tabPD#
							 where tab = k.ref
							) = 0
					   and niv >= #i#
					<cfif Arguments.Tipo EQ "UPLOAD">
					   and (rc.tip <> coalesce(cc.tip,c.tip) OR rc.lon <> coalesce(cc.lon,c.lon) OR rc.dec <> coalesce(cc.dec,c.dec))
					</cfif>
					   and (
							select count(1)
							  from #colRPD#
							 where tab  = c.tab
							   and col  = c.col
							   and ref  = k.ref
							   and colR = #LvarUPPER#(rc.col)
							) = 0
				</cfquery>
			<cfelse>
				<!--- Las Tablas Dependientes se incluyen:
						en UPLOAD si cambiaron las FKs (PK/AK de la tabla del UPLOAD o referencias cambiadas)
						en UPGRADE si cambiaron las FKs (PK/AK de la tabla del UPLOAD o referencias cambiadas):
							PDs y DBs
						en UPGRADE si no cambiaron las FKs (PK/AK de la tabla del UPLOAD o referencias cambiadas):
							se incluye PDtab y PDkey_F para que se generen si han borrado (no se incluyen las BDs ni colPD)
				--->
				<!--- Se mantienen las características de la tabla referenciada = ref+colR en PDcol  --->
				<cfquery datasource="#Arguments.conexion#">
					insert into #colRPD# (
						tab,  col, 
						ref,  colR,
						tip,  lon, 	dec, 
						tipN, lonN, decN
					)
					select 	distinct 
							#LvarUPPER#(t.tab), #LvarUPPER#(c.col), 
							rc.tab, rc.col,
							c.tip, c.lon, c.dec,
							coalesce(rcc.tip,rc.tip), coalesce(rcc.lon,rc.lon), coalesce(rcc.dec,rc.dec)
					  from #colsRPD# k
						inner join <cf_dbdatabase table="DBMtab" datasource="asp"> t
							 on t.IDsch = #Arguments.IDsch# 
							and t.IDtab = k.IDtab
							and t.IDmodORI is not null
						inner join <cf_dbdatabase table="DBMcol" datasource="asp"> c
							 on c.IDtab = t.IDtab
							and #LvarUPPER#(c.col) = #preserveSingleQuotes(LvarColT)#
						inner join #Arguments.colPD_DB# rc
							left join #colPD# rcc
								 on rcc.tab = rc.tab
								and rcc.col = rc.col
							 on rc.tab = k.ref
							and rc.col = #preserveSingleQuotes(LvarColR)#
					 where (
							select count(1)
							  from #tabPD#
							 where tab = #LvarUPPER#(t.tab)
							) = 0
					   and niv >= #i#
					<cfif Arguments.Tipo EQ "UPLOAD">
					   and (c.tip <> coalesce(rcc.tip,rc.tip) OR c.lon <> coalesce(rcc.lon,rc.lon) OR c.dec <> coalesce(rcc.dec,rc.dec))
					</cfif>
					   and (
							select count(1)
							  from #colRPD#
							 where tab  = #LvarUPPER#(t.tab)
							   and col  = #LvarUPPER#(c.col)
							   and ref  = rc.tab
							   and colR = rc.col
							) = 0
				</cfquery>
			</cfif>
		</cfloop>

		<cfif Arguments.Tipo NEQ "UPLOAD">
			<!--- Debe ajustar los tipos de datos DBM de colRPD --->
			<cfset LvarObjDB.ajustaPDs(Arguments.Conexion,Arguments.tipo,Arguments.tipoID,-1, colRPD)>
			<cfparam name="session.DBM_DEPENDENCIAS" default="false">
			<cfif Arguments.tipoR EQ "R" OR NOT session.DBM_DEPENDENCIAS>
				<!--- Elimina campos de relacion sin cambios --->
				<cfquery  datasource="#Arguments.conexion#">
					delete from #colRPD#
					 where tip = tipN AND lon = lonN AND dec = decN
				</cfquery>
			</cfif>
		</cfif>
		<cfquery  datasource="#Arguments.conexion#">
			insert into #tabPD# 
							(OP, tab,   des,   rul,   gen,   genVer, del, suf13, suf25, tabAnt)
			select distinct  -1, #LvarUPPER#(t.tab), t.des, t.rul, 1,     1,    t.del, t.suf13, t.suf25, #LvarUPPER#(t.tabAnt)
			  from <cf_dbdatabase table="DBMtab" datasource="asp"> t
			 where t.IDsch = #Arguments.IDsch# 
			   and #LvarUPPER#(t.tab) in (select <cfif Arguments.tipoR EQ "R">ref<cfelse>tab</cfif> from #colRPD#)
			   and t.IDmodORI is not null
			   and (
			  		select count(1)
					  from #tabPD#
					 where tab = #LvarUPPER#(t.tab)
					) = 0
		</cfquery>
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			select coalesce(count(1),0) as cantidad from #tabPD#
		</cfquery>
		<cfquery datasource="asp">
			update DBMgenP
			   set tabs = #rsSQL.cantidad#
			 where IDgen = #Arguments.tipoID#
		</cfquery>
		<cfquery datasource="#Arguments.conexion#">
			insert into #colPD# (OP, tab, col, sec, des, tip, lon, dec, ide, obl, dfl, ini, minVal, maxVal, lov, genVer, del, colAnt)
			select distinct -1, #LvarUPPER#(t.tab), #LvarUPPER#(c.col), c.sec, c.des, 
							rtrim(coalesce(cr.tipN,c.tip)), coalesce(cr.lonN,c.lon), coalesce(cr.decN,c.dec), 
							c.ide, c.obl, c.dfl, c.ini, c.minVal, c.maxVal, c.lov, 1 as genVer, c.del, #LvarUPPER#(c.colAnt)
			  from <cf_dbdatabase table="DBMtab" datasource="asp"> t
				inner join <cf_dbdatabase table="DBMcol" datasource="asp"> c
					 on c.IDtab 	= t.IDtab
				left join #colRPD# cr
				<cfif Arguments.tipoR EQ "R">
					<!--- Cuando es Referencia, las caracteristicas se toman de tab+col --->
					 on cr.tab = #LvarUPPER#(t.tab)
					and cr.col = #LvarUPPER#(c.col)
				<cfelse>
					<!--- Cuando es Dependencia, las caracteristicas se toman de ref+colR --->
					 on cr.ref  = #LvarUPPER#(t.tab)
					and cr.colR = #LvarUPPER#(c.col)
				</cfif>
			 where t.IDsch = #Arguments.IDsch# 
			   and #LvarUPPER#(t.tab) in (select <cfif Arguments.tipoR EQ "R">ref<cfelse>tab</cfif> from #colRPD#)
			   and t.IDmodORI is not null
			   and (
			  		select count(1)
					  from #colPD#
					 where tab = #LvarUPPER#(t.tab)
					) = 0
		</cfquery>
		<cfquery datasource="#Arguments.conexion#">
			insert into #keyPD# 
							(OP, tab,   cols,   tip,   ref,   colsR,   sec,   clu,   idxTip,   gen, genVer,   del, keyO)
			select distinct  -1, #LvarUPPER#(t.tab), #LvarUPPER#(k.cols), k.tip, #LvarUPPER#(k.ref), #LvarUPPER#(k.colsR), k.sec, k.clu, k.idxTip, k.gen, 1, k.del
					, #preserveSingleQuotes(LvarKeyO)#
			  from <cf_dbdatabase table="DBMtab" datasource="asp"> t
				inner join <cf_dbdatabase table="DBMkey" datasource="asp"> k
					on k.IDtab = t.IDtab
			 where t.IDsch = #Arguments.IDsch# 
			   and #LvarUPPER#(t.tab) in (select <cfif Arguments.tipoR EQ "R">ref<cfelse>tab</cfif> from #colRPD#)
			   and t.IDmodORI is not null
			   and (
			  		select count(1)
					  from #keyPD#
					 where tab = #LvarUPPER#(t.tab)
					) = 0
		</cfquery>
		<cfif Arguments.tipo NEQ "UPLOAD">
			<cfquery name="rsNewOBJECTS" datasource="#LvarConexion#">
				select distinct tab, tabAnt 
				  from #tabPD#
				 where OP = -1
			</cfquery>
			<cfif rsSQL.recordCount GT 0>
				<!--- Debe ajustar las nuevas tablas de relacion --->
				<cfset LvarObjDB.ajustaPDs(Arguments.Conexion,Arguments.tipo,Arguments.tipoID,-1)>
				<!--- Obtiene las nuevas tablas de la base de datos --->
				<cfset LvarObjDB.fromDatabase(Arguments.Conexion, rsNewOBJECTS, Arguments.TIPO, Arguments.TipoID)>
				<cfquery datasource="#LvarConexion#">
					update #tabPD#
					   set OP = 0
					 where OP = -1
				</cfquery>
				<cfquery datasource="#LvarConexion#">
					update #colPD#
					   set OP = 0
					 where OP = -1
				</cfquery>
				<cfquery datasource="#LvarConexion#">
					update #keyPD#
					   set OP = 0
					 where OP = -1
				</cfquery>
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="UPLOAD_toDesarrollo" access="public" output="no" returntype="void">
		<cfargument name="IDupl" required="yes">
	
		<cftry>
			<cfquery name="rsSQL" datasource="asp">
				select 
					  m.IDsch
					, u.IDupl
					, case when m.IDsch = 1 then 'minisif' else s.sch end as sch
					, u.sts
					, u.stsP
					, u.msg
					, u.IDver
					, s.sch as schemaN
					, m.modelo
					, u.des
				  from DBMuploads u 
					inner join DBMmodelos m on m.IDmod=u.IDmod 
					inner join DBMsch s on s.IDsch=m.IDsch
				 where u.IDupl = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDupl#">
			</cfquery>
			<cfset LvarSts = rsSQL.sts>
			<cfif NOT (LvarSts EQ 2 AND rsSQL.stsP EQ 0)>
				<cfreturn>
			</cfif>
			<cfset LvarConexion = rsSQL.sch>
			<cfset LvarIDsch	= rsSQL.IDsch>
			<cfset LvarIDver	= rsSQL.IDver>
		
			<cfset LvarObjDB = createObject("component", "DBModel_#Application.dsinfo[LvarConexion].type#").init(this,LvarConexion)>
	
			<cfset GvarScript = expandPath("/asp/parches/DBmodel/scripts/") & "U" & numberFormat(Arguments.IDupl,"0000000000") & ".sql">
	
			<cfset LvarOK = toDatabase(LvarConexion, "UPLOAD", Arguments.IDupl)>
		<cfcatch type="any">
			<cfset sbUPLOAD_error (cfcatch, Arguments.IDupl, "UPLOAD_toDesarrollo")>
			<cfreturn>
		</cfcatch>
		</cftry>
	</cffunction>
	
	
	<cffunction name="PDsDBs_Comparation" access="private" output="yes" returntype="void">
		<cfargument name="conexion" required="yes">
		<cfargument name="tipo" 	required="yes">
		<cfargument name="tipoID"	required="yes"  type="numeric">
	
		<cfset LvarTabsP = fnUpdateTabsP(Arguments.tipo, Arguments.tipoID, "-1", false, "PDsDBs_Comparation")>
		<cfset LvarTabsP = 1>
		<cfset LvarTabsI = 4>
		<cfif Arguments.tipo EQ "UPLOAD">
			<cfquery name="rsSQL" datasource="asp">
				select m.IDsch
				  from DBMuploads u
					inner join DBMmodelos m 
						on m.IDmod = u.IDmod
				 where u.IDupl = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.tipoID#">
			</cfquery>
			<cfset LvarIDsch = rsSQL.IDsch>
			<cfquery datasource="asp">
				update DBMuploads
				   set 	stsP 	= 5, 		<!--- Comparando Desarrollo --->
						tabsP 	= #LvarTabsP#,
						msg		= null,
						html	= null
				 where IDupl = #Arguments.tipoID#
			</cfquery>
		<cfelseif Arguments.tipo EQ "UPGRADE">
			<cfquery name="rsSQL" datasource="asp">
				select m.IDsch
				  from DBMgen g
					inner join DBMmodelos m 
						on m.IDmod = g.IDmod
				 where g.IDgen = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.tipoID#">
			</cfquery>
			<cfset LvarIDsch = rsSQL.IDsch>
			<cfquery datasource="asp">
				update DBMgenP
				   set 	stsP 	= 5, 		<!--- Comparando Base de Datos --->
						tabsP 	= #LvarTabsP#,
						msg		= null
				 where IDgen = #Arguments.tipoID#
			</cfquery>
		</cfif>
	
		<!---
			OP 
			
			del	colPD	Tabs gen = 0
			del	keyPD	Tabs gen = 0
			
			CAMBIOS A BASE DE DATOS:
			TABLAS
			OP = 1	tabPD	Tabs Nuevas
			OP = 1	colPD	Tabs Nuevas
			OP = 1	keyPD	Tabs Nuevas
			OP = 2											chkDB	Chks Nuevas
			OP = 4											chkDB	Chks a Borrar (Denegar UPLOAD)
			OP = 4 											tabDB	Tabs Borrar del = 1
			
			COLUMNAS
			OP = 2	colPD	Cols Nuevas del=0
			OP = 3	colPD	Cols Cambiadas del=0
			OP = 4 											colDB	Cols Borrar del = 1
			OP = 5											colDB	Cols en Desarrollo
			OP = 10	colPD	Cols perdidas
			
			LLAVES
			idx												keyDB	Asignación de ID a FK
			OP = 2	keyPD	Keys Nuevas
			OP = 3 	keyPD	Keys con campos cambiados Add	keyDB	Keys con campos cambiados Borrar
			
			OP = 4 											keyDB	Keys Borrar del = 1 Borrar XKs y FIs
			
			OP = 5											keyBD	Keys Sobrantes en Desarrollo
			OP = 6											keyDB	Keys Duplicadas Borrar XK
			OP = 7	keyPD	FKs NoGenerar FK Agregar new FI	keyDB	FKs NoGenerar Borrar FK
			OP = 10	keyPD	Keys perdidas
	
			El procedimiento de regeneración de COL es:
				add		COL__NEW
				update	COL__NEW = COL		** AQUI PUEDE DAR ERROR DE CONVERSION
				drop	COL					** AQUI PUEDE DAR ERROR DE QUE SE ESTA UTILIZANDO EN UN CONSTRAINT
				rename	COL__NEW to COL
		--->
	
		<cfquery datasource="#Arguments.conexion#">
			delete from #tabPD#
			 where gen = 0
		</cfquery>
	
		<!------------------------------------------------------------->
		<!--- MODIFICACIONES EN TABLAS --->
		<!------------------------------------------------------------->
		
		<!--- CrtTbl:		CREAR TABLAS NUEVAS: TAB+COLS --->
		<!--- tabPD OP = 1:	AGREGAR EN BASE DE DATOS (create table) --->
		<cfquery datasource="#Arguments.conexion#">
			update #tabPD#
			   set OP = 1
			 where OP = 0
			   and gen = 1
			   and del = 0
			   and (
					select count(1)
					  from #tabDB#
					 where tab = #tabPD#.tab
					) = 0
		</cfquery>
		<cfset LvarTabsP = fnUpdateTabsP(Arguments.tipo, Arguments.tipoID, LvarTabsP+LvarTabsI)>
		
		<!--- CrtTbl:		CREAR TABLAS NUEVAS: TAB+COLS --->
		<!--- colPD OP = 1:	INCLUIR EN CREATE TABLE --->
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			update #colPD#
			   set OP = 1
			 where (
					select count(1)
					  from #tabPD#
					 where tab = #colPD#.tab
					   and OP = 1
					) > 0
		</cfquery>
		<cfset LvarTabsP = fnUpdateTabsP(Arguments.tipo, Arguments.tipoID, LvarTabsP+LvarTabsI)>
		
		<!--- CrtTbl:		CREAR TABLAS NUEVAS: KEYS --->
		<!--- keyPD OP = 1:	AÑADIR EN BASE DE DATOS (alter add, create index) --->
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			update #keyPD#
			   set OP = 1
			 where (
					select count(1)
					  from #tabPD#
					 where tab = #keyPD#.tab
					   and OP = 1
					) > 0
		</cfquery>
		<cfset LvarTabsP = fnUpdateTabsP(Arguments.tipo, Arguments.tipoID, LvarTabsP+LvarTabsI)>
		
		<!--- TABsDel:		TABLAS DEFINIDAS COMO BORRAR EN POWER DESIGNER --->
		<!--- tabDB OP = 4:	BORRAR EN BASE DE DATOS (alter drop) --->
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			update #tabPD#
			   set OP = 4
			 where del = 1
		</cfquery>
		<cfset LvarTabsP = fnUpdateTabsP(Arguments.tipo, Arguments.tipoID, LvarTabsP+LvarTabsI)>
	
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			update #tabDB#
			   set OP = 4
			 where (
					select count(1)
					  from #tabPD#
					 where tab = #tabDB#.tab
					   and OP = 4
					) > 0
		</cfquery>
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			update #keyDB#
			   set OP = 4
			 where (
					select count(1)
					  from #tabPD#
					 where tab = #keyDB#.tab
					   and OP = 4
					) > 0
		</cfquery>
		<cfset LvarTabsP = fnUpdateTabsP(Arguments.tipo, Arguments.tipoID, LvarTabsP+LvarTabsI)>
	
	
		<!--- CHKsAdd:		CHECKS A NIVEL DE TABLA NUEVAS EN POWER DESIGNER --->
		<!--- chkDB OP = 2:	AGREGAR EN BASE DE DATOS (alter add) --->
		<cfquery datasource="#Arguments.conexion#">
			insert into #chkDB# (OP, tab, chk, rul)
			select 2, p.tab, '<strong>REGLA NUEVA</strong>' as chk, p.rul
			  from #tabPD# p
			 where OP = 0
			   and p.rul IS NOT NULL
			   and (
					select count(1)
					  from #chkDB# d
					 where d.tab = p.tab
					   and d.rul = p.rul
					) = 0
		</cfquery>
		<cfset LvarTabsP = fnUpdateTabsP(Arguments.tipo, Arguments.tipoID, LvarTabsP+LvarTabsI)>
	
		
		<!--- CHKsDel:		CHECKS A NIVEL DE TABLA NO EXISTENTES EN POWER DESIGNER --->
		<!--- chkDB OP = 4:	Denegar Upload y BORRAR EN BASE DE DATOS (alter drop) --->
		<cfquery datasource="#Arguments.conexion#">
			update #chkDB#
			   set OP = 4
			 where (
					select count(1)
					  from #tabPD#
					 where tab = #chkDB#.tab
					   and rul = #chkDB#.rul
					) = 0
		</cfquery>
		<cfset LvarTabsP = fnUpdateTabsP(Arguments.tipo, Arguments.tipoID, LvarTabsP+LvarTabsI)>
	
	
		<!------------------------------------------------------------->
		<!--- MODIFICACIONES A COLUMNAS --->
		<!------------------------------------------------------------->
	
		<!--- RenCol:		RENOMBRAR COLUMNAS --->
		<!--- Se borra la columna Nueva si todavía existe la Anterior --->
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			delete from #colPD#
			 where (
					select count(1)
					  from #colPD# x
					 where x.tab	= #colPD#.tab
					   and x.colAnt	= #colPD#.col
					   and x.colAnt is not null
					) > 0
		</cfquery>
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			delete from #colDB#
			 where (
					select count(1)
					  from #colPD# pd
					 where pd.tab = #colDB#.tab
					   and pd.col = #colDB#.col
					   and (
							select count(1)
							  from #colDB# db
							 where db.tab = pd.tab
							   and db.col = pd.colAnt
							) > 0
					   and colAnt is not null
					) > 0
		</cfquery>
		<!--- Se renombra la columna Anterior por la Nueva --->
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			update #colDB#
			   set OP = 3
			   	 , colAnt = col
				 , col = 
				 		(
						select col
						  from #colPD#
						 where tab	  = #colDB#.tab
						   and colAnt = #colDB#.col
						   and colAnt is not null
						)
			 where (
					select count(1)
					  from #colPD#
					 where tab	  = #colDB#.tab
					   and colAnt = #colDB#.col
					   and colAnt is not null
					) > 0
		</cfquery>
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			update #colPD#
			   set OP = 3
			 where OP = 0
			   and (
					select count(1)
					  from #colDB#
					 where tab = #colPD#.tab
					   and col = #colPD#.col
					   and colAnt is not null
					) > 0
		</cfquery>

		<!---COLUMNAS NUEVAS --->
		<!--- COLsAdd:		COLUMNAS NUEVAS EN BASE DE DATOS --->
		<!--- colPD OP = 2:	AGREGAR EN BASE DE DATOS (alter add) --->
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			update #colPD#
			   set OP = 2
			 where OP = 0
			   and (
					select count(1)
					  from #tabPD#
					 where tab = #colPD#.tab
					   and OP = 0
					) > 0
			   and (
					select count(1)
					  from #colDB# d
					 where tab = #colPD#.tab
					   and col = #colPD#.col
					) = 0
		</cfquery>
		<cfset LvarTabsP = fnUpdateTabsP(Arguments.tipo, Arguments.tipoID, LvarTabsP+LvarTabsI)>
	
	
		<!--- COLsChg:		COLUMNAS MODIFICADAS --->
		<!--- colDB OP = 3:	REGENERAR EN BASE DE DATOS (alter add/drop/modify, updates, etc) --->
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			update #colDB#
			   set OP = 3
			 where OP = 0
			   and (
					select count(1)
					  from #colPD#
					 where tab = #colDB#.tab
					   and col = #colDB#.col
					   and 
							(
								tip <> #colDB#.tip OR
								lon <> #colDB#.lon OR 
								dec <> #colDB#.dec OR
								ide <> #colDB#.ide OR
								obl <> #colDB#.obl OR
								coalesce(dfl,' ') <> coalesce(#colDB#.dfl,' ') OR
								coalesce(rul,' ') <> coalesce(#colDB#.rul,' ')
							)
					) > 0
		</cfquery>

		<cfset LvarTabsP = fnUpdateTabsP(Arguments.tipo, Arguments.tipoID, LvarTabsP+LvarTabsI)>
	
		<!--- COLsDel:		COLUMNAS DEFINIDAS COMO BORRAR EN POWER DESIGNER --->
		<!--- colDB OP = 4:	BORRAR EN BASE DE DATOS (alter drop) --->
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			update #colPD#
			   set OP = 4
			 where del = 1
		</cfquery>
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			update #colDB#
			   set OP = 4
			 where (
					select count(1)
					  from #colPD#
					 where tab = #colDB#.tab
					   and col = #colDB#.col
					   and OP = 4
					) > 0
		</cfquery>
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			update #colDB#
			   set OP = 4
			 where OP = 0
			   and (
			<cfif LvarObjDB.fnCaseSensitive()>
						(tip = 'TS'  and col <> 'ts_rversion') OR
						(tip <> 'TS' and col =  'ts_rversion')
			<cfelse>
						(tip = 'TS'  and col <> 'TS_RVERSION') OR
						(tip <> 'TS' and tip <> 'D2' and col =  'TS_RVERSION')
			</cfif>
					)
		</cfquery>
		<cfset LvarTabsP = fnUpdateTabsP(Arguments.tipo, Arguments.tipoID, LvarTabsP+LvarTabsI)>
	
		<cfif Arguments.tipo EQ "UPLOAD">
			<!--- COLsLst:		COLUMNAS PERDIDAS EN POWER DESIGNER GENERADAS EN VERSION --->
			<!--- colPD OP = 10:	DENEGAR UPLOAD: SE TIENEN QUE VOLVER A AGREGAR EN POWER DESIGNER, se ignoran en generación --->
			<cfquery datasource="#Arguments.conexion#">
				insert into #colPD# (OP, tab, col, sec, des, tip, lon, dec, ide, obl, dfl, ini, minVal, maxVal, lov, genVer, del, colAnt)
				select 10 as OP, t.tab, c.col, c.sec, c.des, rtrim(c.tip), c.lon, c.dec, c.ide, c.obl, c.dfl, c.ini, c.minVal, c.maxVal, c.lov, 1, c.del, c.colAnt
				  from <cf_dbdatabase table="DBMtab" datasource="asp"> t
					inner join <cf_dbdatabase table="DBMcol" datasource="asp"> c
						on c.IDtab = t.IDtab
					inner join #tabPD# pd
						on pd.tab = t.tab
				 where t.IDsch = #LvarIDsch#
				   and pd.newFKs=0
				   and (
						select count(1)
						  from #colPD#		  
						 where tab = t.tab
						   and (col = c.col OR coalesce(colAnt,'*') = c.col)
						) = 0
					and c.del = 0
					and pd.OP <> -1
			</cfquery>
			<cfset LvarTabsP = fnUpdateTabsP(Arguments.tipo, Arguments.tipoID, LvarTabsP+LvarTabsI)>
		
		
			<!--- COLsIgn:		COLUMNAS EN BASE DE DATOS NO EXISTENTES EN POWER DESIGNER (Se ignoran las tablas DEPENDIENTES (sin columnas) --->
			<!--- colDB OP = 10:	DENEGAR UPLOAD, IGNORAR EN BASE DE DATOS --->
			<cfquery name="rsSQL" datasource="#Arguments.conexion#">
				update #colDB#
				   set OP = 10
				 where OP = 0
				   and (
						select count(1)
						  from #colPD#
						 where tab = #colDB#.tab
						   and col = #colDB#.col
						   and OP <> 10
						) = 0
				   and (
						select count(1)
						  from #colPD#
						 where tab = #colDB#.tab
						) > 0
			</cfquery>
			<cfset LvarTabsP = fnUpdateTabsP(Arguments.tipo, Arguments.tipoID, LvarTabsP+LvarTabsI)>
		</cfif>	
		
		<!------------------------------------------------------------->
		<!--- MODIFICACIONES A LLAVES --->
		<!------------------------------------------------------------->
	
		<!--- KEYsDel:		LLAVES CON CAMPOS RENOMBRADOS EN POWER DESIGNER --->
		<!--- keyDB OP = 4:	BORRAR EN BASE DE DATOS (alter drop) --->
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			update #keyPD#
			   set del=1
			 where del = 0
			   and (
					select count(1)
					  from #colPD# d
					 where d.tab	= #keyPD#.tab
					   and <cf_dbfunction name="LIKE" args="',' #CONCAT# rtrim(#keyPD#.cols) #CONCAT# ',' LIKE '%,' #CONCAT# rtrim(d.colAnt) #CONCAT# ',%'" delimiters="°" datasource="#Arguments.conexion#">
					) > 0
		</cfquery>
	
<!---
		<cfset LvarObjDB.ajustaPDs(Arguments.Conexion,Arguments.tipo,Arguments.tipoID)>
--->
		<!--- KEYsDel:		LLAVES DEFINIDAS COMO BORRAR EN POWER DESIGNER --->
		<!--- keyDB OP = 4:	BORRAR EN BASE DE DATOS (alter drop) --->
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			update #keyPD#
			   set OP = 4
			 where del = 1
		</cfquery>
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			UPDATE #keyDB#
			   set OP = 4
			 where (
					select count(1) 
					  from #keyPD# pd
					 where pd.tab		= #keyDB#.tab
					   and pd.cols		= #keyDB#.cols
					   and (pd.tip		= #keyDB#.tip OR (pd.tip='A' and #keyDB#.tip = 'P'))
					   and pd.ref		= #keyDB#.ref
					   and pd.colsR		= #keyDB#.colsR
					   <!--- Caso especial: cambia PK pero nueva AK igual a la PK anterior sin indicar del=1 --->
					   and (OP = 4 OR (pd.tip='A' and #keyDB#.tip = 'P'))
					) > 0
		</cfquery>
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			UPDATE #keyDB#
			   set OP = 4
			 where (
					select count(1) 
					  from #keyPD# pd
					 where pd.tab		= #keyDB#.ref
					   and pd.cols		= #keyDB#.colsR
					   and pd.tip 		in ('P','A')
					   and OP = 4
					) > 0
		</cfquery>
		<cfset LvarTabsP = fnUpdateTabsP(Arguments.tipo, Arguments.tipoID, LvarTabsP+LvarTabsI)>
	
		<!--- KEYsDel:		KEYS DUPLICADAS EN BASE DE DATOS --->
		<!--- keyDB OP = 6:	BORRAR EN BASE DE DATOS --->
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			UPDATE #keyDB#
			   set OP = 6
			 where OP in (0,1)
			   and (
						select count(1)
						  from #keyDB# uni
						 where uni.tab		= #keyDB#.tab
						   and uni.cols		= #keyDB#.cols
						   and uni.tip		= #keyDB#.tip
						   and uni.ref		= #keyDB#.ref
						   and uni.colsR	= #keyDB#.colsR
						   and uni.keyN		< #keyDB#.keyN
						   and uni.OP in (0,1)
					) > 0
		</cfquery>
	
		<!--- ASIGNACION DE INDICEs A FKs --->
	
		<!--- keyPD.idxTip = '+' sirve para crear el indice propio cuando se crea el FK --->
		<!--- 	Solo FKs (tip='F') --->
		<!--- 	Indice propio (keyPD.idxTip='F') --->
		<!--- 	que no existe el indice propio (keyDB.idx='') u otro indice (tip<>F) o si se va a regenerar (OP = 3) --->
		<cfquery datasource="#Arguments.conexion#">
			UPDATE #keyPD#
			   set idxTip = '+' 			<!--- crear porque no existe el indice o se va a regenerar --->
			 where idxTip = 'F'
			   and OP = 0
			   and (
						select count(1)
						  from #keyDB#
						 where tab		= #keyPD#.tab
						   and cols		= #keyPD#.cols
						   and tip		= 'I'
						   and OP = 0
					) = 0
		</cfquery>
		<cfset LvarTabsP = fnUpdateTabsP(Arguments.tipo, Arguments.tipoID, LvarTabsP+LvarTabsI)>
	
		<!--- keyDB.idx sirve para borrar el indice cuando se borra la FK --->
		<!--- 	Para FKs (tip='F') con Indice propio (keyPD.idxTip='F') --->
		<!--- 	Se convierten sólo ID Indices normales (tip='I') --->
	
		<!--- 	Conversión de ID a FK: --->
		<!--- 		Registra en FK.idx el ID.keyN y elimina el ID --->
		<!---	OJO: el idx puede venir ya lleno para PK o AK (Oracle) --->
		<cfquery datasource="#Arguments.conexion#">
			UPDATE #keyPD#
			   set idx = (					<!--- almacena el indice que se va a asignar --->
							select min(keyN)
							  from #keyDB#
							 where tab		= #keyPD#.tab
							   and cols		= #keyPD#.cols
							   and tip		= 'I'
							   and OP = 0
						) 
			 where idxTip = 'F'
		</cfquery>
		<cfquery datasource="#Arguments.conexion#">
			UPDATE #keyDB#
			   set idx = (					<!--- almacena el indice que se debe borrar --->
							select idx
							  from #keyPD#
							 where tab		= #keyDB#.tab
							   and cols		= #keyDB#.cols
							   and tip		= 'F'
							   and ref		= #keyDB#.ref
							   and colsR	= #keyDB#.colsR
							   and OP = 4
						) 
			 where tip = 'F'
			   and idx is null
		</cfquery>
		<!--- Caso especial: cuando no existe el FK pero sí existe el FI asociado, para efectos de renombrar o regeneración --->
		<cfquery datasource="#Arguments.conexion#">
			insert into #keyDB# (OP, tab, cols, tip, ref, colsR, keyN, 			 idx, clu, keyO)
			select 				  2, tab, cols, tip, ref, colsR, '*FI*' as keyN, idx, clu, 4
			  from #keyPD#
			 where tip 		= 'F'
			   and idxTip 	= 'F'
			   and idx 		IS NOT NULL
			   and OP<>4
			   and (
					select count(1)
					  from #keyDB#
					 where tab		= #keyPD#.tab
					   and cols		= #keyPD#.cols
					   and tip		= #keyPD#.tip
					   and ref		= #keyPD#.ref
					   and colsR	= #keyPD#.colsR
					   and OP = 0
					) = 0
		</cfquery>
		<cfset LvarTabsP = fnUpdateTabsP(Arguments.tipo, Arguments.tipoID, LvarTabsP+LvarTabsI)>
	
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			delete from #keyDB#			
			 where tip = 'I' 		
			   and OP = 0		
			   and (		
						select count(1) 		
						  from #keyPD# fk
						 where fk.tab	= #keyDB#.tab
						   and fk.cols	= #keyDB#.cols
						   and fk.tip	= 'F'
						   and fk.idx	IS NOT NULL
						   and fk.idx	= #keyDB#.keyN
					) > 0		
		</cfquery>
		<cfset LvarTabsP = fnUpdateTabsP(Arguments.tipo, Arguments.tipoID, LvarTabsP+LvarTabsI)>
	
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			UPDATE #keyDB#
			   set idx = (
							select idx
							  from #keyPD#
							 where tab		= #keyDB#.tab
							   and cols		= #keyDB#.cols
							   and tip		= #keyDB#.tip
							   and ref		= #keyDB#.ref
							   and colsR	= #keyDB#.colsR
							   and idxTip	= 'F'
						)
			   where tip = 'F'
				 and OP = 0
		</cfquery>
		<cfset LvarTabsP = fnUpdateTabsP(Arguments.tipo, Arguments.tipoID, LvarTabsP+LvarTabsI)>
	 
		<!--- KEYsAdd:		LLAVES NUEVAS EN BASE DE DATOS --->
		<!--- keyPD OP = 2:	AGREGAR EN BASE DE DATOS (alter add, create index) --->
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			update #keyPD#
			   set OP = 2
			 where OP = 0
			   and (
					select count(1)
					  from #tabPD#
					 where tab = #keyPD#.tab
					   and OP = 0
					) > 0
			   and (
					select count(1)
					  from #keyDB#
					 where tab		= #keyPD#.tab
					   and cols		= #keyPD#.cols
					   and tip		= #keyPD#.tip
					   and ref		= #keyPD#.ref
					   and colsR	= #keyPD#.colsR
					   and OP = 0
					) = 0
		</cfquery>
		<cfset LvarTabsP = fnUpdateTabsP(Arguments.tipo, Arguments.tipoID, LvarTabsP+LvarTabsI)>
	
		<!--- KEYsChg:		LLAVES (PK,AK,UK,IK,FK) EN BASE DE DATOS CON COLUMNAS MODIFICADAS --->
		<!--- keyDB OP = 3:	REGENERAR EN BASE DE DATOS (borrar y crear) --->
		<cfquery datasource="#Arguments.conexion#">
			UPDATE #keyDB#
			   set OP = 3
			 where OP in (0,2)		<!--- OP = 2 es un caso especial *FI*, ver arriba --->
			   and (
					select count(1)
					  from #colDB# d
					 where d.tab = #keyDB#.tab
					   and d.OP = 3
					   and <cf_dbfunction name="LIKE" args="',' #CONCAT# rtrim(#keyDB#.cols) #CONCAT# ',' LIKE '%,' #CONCAT# rtrim(d.col) #CONCAT# ',%'" delimiters="°" datasource="#Arguments.conexion#">
					) > 0
		</cfquery>
		<cfset LvarTabsP = fnUpdateTabsP(Arguments.tipo, Arguments.tipoID, LvarTabsP+LvarTabsI)>
	
		<!--- KEYsDel:		Llaves (PK,AK,UI,ID,FK) EN BASE DE DATOS NO EXISTENTES EN POWER DESIGNER --->
		<!--- keyDB OP = 5:	Denegar Upload y BORRAR EN BASE DE DATOS --->
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			UPDATE #keyDB#
			   set OP = 5 
			 where OP not in (4,-1)
			   and (
					select count(1) 
					  from #tabPD# pd
					 where pd.tab		= #keyDB#.tab
					   and pd.OP <> -1
					) > 0
			   and (
					select count(1) 
					  from #keyPD# pd
					 where pd.tab		= #keyDB#.tab
					   and pd.cols		= #keyDB#.cols
					   and (pd.tip		= #keyDB#.tip OR pd.tip='A' and #keyDB#.tip = 'P')
					   and pd.ref		= #keyDB#.ref
					   and pd.colsR		= #keyDB#.colsR
					) = 0
		</cfquery>
		<cfset LvarTabsP = fnUpdateTabsP(Arguments.tipo, Arguments.tipoID, LvarTabsP+LvarTabsI)>

		<!--- KEYsChg:		FKs que utilizan KEYS (PK,AK) EN BASE DE DATOS CON CAMPOS CAMBIADOS (OP = 3) o QUE SON KEYs CAMBIADAS EN POWER DESIGNER (OP = 5) --->
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			UPDATE #keyDB#
			   set OP = 3
			 where OP in (0,2,-1)
			   and tip in ('F','D')
			   and (
					select count(1)
					  from #keyDB# pk
					 where pk.tab	= #keyDB#.ref
					   and <cf_dbfunction name="LIKE" args="',' #CONCAT# rtrim(#keyDB#.colsR) #CONCAT# ',' LIKE '%,' #CONCAT# rtrim(pk.cols) #CONCAT# ',%'" delimiters="°" datasource="#Arguments.conexion#">
					   and pk.tip  	in ('P','A','U')
					   and pk.OP 	in (3,5)
					) > 0
		</cfquery>
		<cfset LvarTabsP = fnUpdateTabsP(Arguments.tipo, Arguments.tipoID, LvarTabsP+LvarTabsI)>

		<!--- KEYsChg:		Registra en PDs el cambio de todas las KEYS. Se incluyen las nuevas para actualizar el idxTip de FKs nuevas con idx existente que hay que regenerar --->
		<cfquery datasource="#Arguments.conexion#">
			UPDATE #keyPD#
			   set OP = case when OP = 2 then 2 else 3 end
				 , idxTip = case when idxTip = 'F' then '+' else idxTip end
			 where OP in (0,2)
			   and (
					select count(1)
					  from #keyDB#
					 where tab		= #keyPD#.tab
					   and cols		= #keyPD#.cols
					   and tip		= #keyPD#.tip
					   and ref		= #keyPD#.ref
					   and colsR	= #keyPD#.colsR
					   and OP = 3
					) > 0
		</cfquery>
	
		<!--- KEYsDel:		CONVERSION DE INDICES IDs no definidos a FKs DUPLICADAS EN BASE DE DATOS --->
		<!--- keyDB OP = 6:	BORRAR EN BASE DE DATOS --->
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			UPDATE #keyDB#
			   set OP = 6
			 where tip = 'I'
			   and OP = 5
			   and (
						select count(1)
						  from #keyDB# uni
						 where uni.tab		= #keyDB#.tab
						   and uni.cols		= #keyDB#.cols
						   and uni.tip		= 'F'
						   and uni.OP in (0,1)
					) > 0
		</cfquery>
		<cfset LvarTabsP = fnUpdateTabsP(Arguments.tipo, Arguments.tipoID, LvarTabsP+LvarTabsI)>
	
	
		<!--- KEYsDel/KEYsADD:	FKs DEFINIDAS COMO NO GENERAR EN POWER DESIGNER --->
		<!--- 					Incluye FKs contenidas en otras FKs (Empresas) --->
		<!--- keyDB OP = 7:		BORRAR CONSTRAINT PERO MANTENER INDICE EN BASE DE DATOS (alter drop) --->
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			update #keyPD#
			   set OP = 7
			 where gen = 0  		<!--- keysadd: no agrega FKs 7 pero agregar FIs 7 --->
		</cfquery>
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			UPDATE #keyDB#
			   set OP = 7
			 where OP in (0,2)		<!--- keysdel: borra los FKs/FIs 7 y 3 --->
			   and (
					select count(1) 
					  from #keyPD# pd
					 where pd.tab		= #keyDB#.tab
					   and pd.cols		= #keyDB#.cols
					   and pd.tip		= #keyDB#.tip
					   and pd.ref		= #keyDB#.ref
					   and pd.colsR		= #keyDB#.colsR
					   and OP = 7
					) > 0
		</cfquery>
		<cfset LvarTabsP = fnUpdateTabsP(Arguments.tipo, Arguments.tipoID, LvarTabsP+LvarTabsI)>
	
		<!--- KEYsDel/KEYsADD:	FKs QUE HAGAN REFERENCIA INDIRECTA A UN CAMPO CONVERTIDO A IDENTITY --->
		<!--- keyDB OP = 8:		BORRAR Y CREAR CONSTRAINT (no es necesario obrar indice) --->
		<!--- CONVERSION A IDE: Marca como KEYsCHGtoIDE OP = 8 todas las FKs en #keyDB# que haga referencia a campos que se convirtieron a Identity --->
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			select pd.tab, pd.col
			  from #colPD# pd
				inner join #colDB# db
					 on db.tab = pd.tab
					and db.col = pd.col
			 where db.OP = 3
			   and db.ide = 0
			   and pd.ide = 1
		</cfquery>
	
		<cfloop query="rsSQL">
			<cfset fnRecurs_KEYsCHGtoIDE("KEYsCHG", rsSQL.tab, rsSQL.col, rsSQL.col, rsSQL.tab, rsSQL.col, Arguments.conexion, "")>
		</cfloop>
		
		<cfif Arguments.tipo EQ "UPLOAD">
			<!--- KEYsLst:		LLAVES PERDIDAS EN POWER DESIGNER GENERADAS EN VERSION --->
			<!--- keyPD OP = 10:	DENEGAR UPLOAD: SE TIENEN QUE VOLVER A AGREGAR EN POWER DESIGNER, se ignoran en generación --->
			<cfquery name="rsSQL" datasource="#Arguments.conexion#">
				insert into #keyPD# (OP, tab, cols, tip, ref, colsR, sec, clu, idxTip, gen, genVer, del, keyO)
				select 10, t.tab, k.cols, k.tip, k.ref, k.colsR, k.sec, k.clu, k.idxTip, k.gen, 1, k.del, 0
				  from <cf_dbdatabase table="DBMtab" datasource="asp"> t
					inner join <cf_dbdatabase table="DBMkey" datasource="asp"> k
						on k.IDtab = t.IDtab
					inner join #tabPD# pd
						on pd.tab = t.tab
				 where t.IDsch = #LvarIDsch#
				   and OP<>4
				   and (
						select count(1) 
						  from #keyPD# pd
						 where pd.tab		= t.tab
						   and pd.cols		= k.cols
						   and (pd.tip		= k.tip OR pd.tip='A' and k.tip = 'P')
						   and pd.ref		= k.ref
						   and pd.colsR		= k.colsR
						) = 0
					and (
						select count(1)
						  from #colPD# d
						 where d.tab = t.tab
						   and <cf_dbfunction name="LIKE" args="',' #CONCAT# rtrim(k.cols) #CONCAT# ',' LIKE '%,' #CONCAT# rtrim(d.colAnt) #CONCAT# ',%'" delimiters="°" datasource="#Arguments.conexion#">
						) = 0
					and k.del = 0
					and pd.OP <> -1
			</cfquery>
			<cfset LvarTabsP = fnUpdateTabsP(Arguments.tipo, Arguments.tipoID, LvarTabsP+LvarTabsI)>
		</cfif>
			
		<cfset LvarTabsP = fnUpdateTabsP(Arguments.tipo, Arguments.tipoID, 100)>
	</cffunction>
	
	<cffunction name="script_BASECERO" access="public" output="no" returntype="void">
		<cfargument name="archivo" 	required="yes">
		<cfargument name="IDmod" 	required="yes">
		<cfargument name="IDver"	default="0"		type="numeric">
	
		<cfquery name="rsSQL" datasource="asp">
			select	s.IDsch, s.sch, case when s.IDsch=1 then 'minisif' else s.sch end as dsn, 
					m.IDmod, m.modelo
			  from DBMmodelos m
				inner join DBMsch s
					on s.IDsch = m.IDsch	
			 where m.IDmod = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDmod#">
		</cfquery>
		<cfset LvarTit =
					"SCRIPT BASE CERO PARA:#vbCrLf#" &
					"	SCHEMA:  #rsSQL.sch##vbCrLf#" &
					"	MODELO:  #rsSQL.modelo##vbCrLf#" &
					"	FECHA:   #dateFormat(now(),"DD/MM/YYYY")# #timeFormat(now(),"HH:mm:ss")##vbCrLf#" &
					"	TIPO BD: "
		>
		<cfset LvarTitN = len(LvarTit)>
		
		<cftry>
			<cfset LvarConexion = rsSQL.dsn>
			<cfset LvarObjDB = createObject("component", "DBModel_sybase").init(this, LvarConexion)>
			<cfset LvarObjDB2 = LvarObjDB>
			<cfset creaTablas(LvarConexion, "BASECERO")>
	
	
			<cfset LvarFiles = "">
			<cfset LvarDir = expandPath("/asp/parches/DBmodel/scripts/")>
			<cfloop list="sybase,sqlserver,oracle,db2" index="db">
				<cfset session.dbm.db = db>
				<cfset LvarTit 		= mid(LvarTit, 1, LvarTitN) & db>
				<cfset LvarFile		= db & "_" & Arguments.Archivo>
				<cfset GvarScript	= LvarDir & LvarFile>
				<cfset LvarFiles	= listAppend(LvarFiles, LvarFile)>
				<cfset LvarObjDB = LvarObjDB2>
				<cfset creaTablas (LvarConexion)>
				<cfset LvarObjDB	= createObject("component", "DBModel_#db#").init(this, LvarConexion)>
				<cfset LvarObjDB.asignaTablas (LvarConexion)>
				<cfset PDs_fromVersions (LvarConexion, "BASECERO", Arguments.IDmod, Arguments.IDver)>
				<cfset tabDB	= session.dbm.tabDB>
				<cfset colDB	= session.dbm.colDB>
				<cfset keyDB	= session.dbm.keyDB>
				<cfset chkDB	= session.dbm.chkDB>
				<cfset toScriptDB(LvarConexion, "BASECERO", 0, LvarTit)>
			</cfloop>
			<cfset LvarFile = LvarDir & replace(Arguments.Archivo,".sql",".zip")>
			<cfzip 	action	= "zip" 
					file	= "#LvarFile#"
					source	= "#LvarDir#" 
					filter	= "#LvarFiles#"
			>
			<cfloop list="#LvarFiles#" index="LvarFile">
				<cffile action="delete" file="#LvarDir & LvarFile#">
			</cfloop>
		<cfcatch type="any">
			<cfrethrow>
		</cfcatch>
		</cftry>
		<CF_dbTemp_deletes>
	</cffunction>
	
	<!---------------------------------------------------------------------------------
		RUTINAS PARA CARGAR EL XML
	----------------------------------------------------------------------------------->
	<cffunction name="XML_toUpload" output="no" access="public">
		<cfargument name="archivo"	required="yes">
		<cfargument name="IDupl" 	required="yes" type="numeric">
	
		<cftry>
			<cfquery datasource="asp">
				update DBMuploads
				   set 	stsP = 1			<!--- Cargando Upload... --->
					  ,	msg		= null
				 where IDupl = #Arguments.IDupl#
			</cfquery>
		
			<cffile action="read" file="#Arguments.Archivo#" variable="LvarXML">
			
			<cfquery name="rsSQL" datasource="asp">
				select m.IDsch
				  from DBMuploads u
					inner join DBMmodelos m
						on m.IDmod = u.IDmod
				 where IDupl = #Arguments.IDupl#
			</cfquery>
			<cfset LvarIDsch = rsSQL.IDsch>
		
			<cfset LvarDOC 		= XmlParse(LvarXML)>
			<cfset LvarDocTabs 	= LvarDoc.upload>
			
			<cfset LvarTabsP = 0>
			<cfloop index="t" from="1" to="#arrayLen(LvarDocTabs.tab)#">
				<cfif t - LvarTabsP GT 10>
					<cfset LvarTabsP = fnUpdateTabsP("UPLOAD", Arguments.IDupl, t)>
				</cfif>
				<cfset LvarTAB = LvarDocTabs.tab[t]>
				<cfquery name="rsSQL" datasource="asp">
					select count(1) as cantidad
					  from DBMtabU
					 where IDupl = #Arguments.IDupl#
					   and tab	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(LvarTAB.XmlAttributes.cod)#">
				</cfquery>	
				<cfif rsSQL.cantidad EQ 0>
					<cfparam name="LvarTAB.XmlAttributes.gen"		default="1">
					<cfparam name="LvarTAB.XmlAttributes.genVer"	default="1">
					<cfparam name="LvarTAB.XmlAttributes.del"		default="0">
					<cfparam name="LvarTAB.XmlAttributes.rul"		default="">
					<cfparam name="LvarTAB.XmlAttributes.ren"		default="">
					
					<cfset LvarTabCode 		= trim(LvarTAB.XmlAttributes.cod)>
					<cfset LvarTabRename 	= trim(LvarTAB.XmlAttributes.ren)>
					<cfquery name="rsTab" datasource="asp">
						select IDtab, tab, secCol, secIdx, secFK, suf13, suf25
						  from DBMtab
						 where IDsch = #LvarIDsch#
						   and tab	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTabCode#">
					</cfquery>
					<cfset LvarSecs	= false>
					<cfif rsTab.IDtab NEQ "">
						<cfset LvarIDtab	= rsTab.IDtab>
						<cfset LvarSecs		= true>
						<cfset LvarSecCol	= rsTab.secCol>
						<cfset LvarSecIdx	= rsTab.secIdx>
						<cfset LvarSecFK	= rsTab.secFK>
						<cfset LvarSuf13 	= rsTab.suf13>
						<cfset LvarSuf25 	= rsTab.suf25>
						<cfquery name="rsCols" datasource="asp">
							select col, sec
							  from DBMcol
							 where IDtab = #rsTab.IDtab#
						</cfquery>
						<cfquery name="rsKeys" datasource="asp">
							select cols, tip, ref, colsR, sec
							  from DBMkey
							 where IDtab = #rsTab.IDtab#
						</cfquery>
					<cfelse>
						<cfif LvarTabRename EQ "">
							<cfset LvarSecCol	= 0>
							<cfset LvarSecIdx	= 0>
							<cfset LvarSecFK	= 0>
						<cfelse>
							<cfquery name="rsTab" datasource="asp">
								select IDtab, tab, secCol, secIdx, secFK
								  from DBMtab
								 where IDsch = #LvarIDsch#
								   and tab	 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTabRename#">
							</cfquery>
							<cfif rsTab.IDtab EQ "">
								<cfset LvarSecCol	= 0>
								<cfset LvarSecIdx	= 0>
								<cfset LvarSecFK	= 0>
							<cfelse>
								<!--- Mantiene las secuencias de la tabla anterior --->
								<cfset LvarSecs		= true>
								<cfset LvarSecCol	= rsTab.secCol>
								<cfset LvarSecIdx	= rsTab.secIdx>
								<cfset LvarSecFK	= rsTab.secFK>
								<cfquery name="rsCols" datasource="asp">
									select col, sec
									  from DBMcol
									 where IDtab = #rsTab.IDtab#
								</cfquery>
								<cfquery name="rsKeys" datasource="asp">
									select cols, tip, ref, colsR, sec
									  from DBMkey
									 where IDtab = #rsTab.IDtab#
								</cfquery>
							</cfif>
						</cfif>
						<!--- CONTROL DE SUFIJOS DE TABLAS PARA TRIGGERS, CONSTRAINT E INDICES --->
						<!--- 
							En DB2 los triggers, constraint e indices tiene un maximo de 18 caracteres:		
								left(tab,11) + format(suf13,'00') + '_CK'
								left(tab,11) + format(suf13,'00') + '_CK01'
								left(tab,11) + format(suf13,'00') + '_PK'
								left(tab,11) + format(suf13,'00') + '_AK01'
								left(tab,11) + format(suf13,'00') + '_FK01'
								left(tab,11) + format(suf13,'00') + '_IU01'
								left(tab,11) + format(suf13,'00') + '_IF01'
								left(tab,11) + format(suf13,'00') + '_ID01'
							En ORACLE y SYBASE los triggers, constraint e indices tiene un maximo de 30 caracteres:		
								left(tab,23) + format(suf25,'00') + '_CK'
								left(tab,23) + format(suf25,'00') + '_CK01'
								left(tab,23) + format(suf25,'00') + '_PK'
								left(tab,23) + format(suf25,'00') + '_AK01'
								left(tab,23) + format(suf25,'00') + '_FK01'
								left(tab,23) + format(suf25,'00') + '_IU01'
								left(tab,23) + format(suf25,'00') + '_IF01'
								left(tab,23) + format(suf25,'00') + '_ID01'
								Solo Oracle:
								'TIB_'	+ left(tab,23) + format(suf25,'00')
								'TUTS_'	+ left(tab,23) + format(suf25,'00')
								'S_'	+ left(tab,23) + format(suf25,'00')
						--->
						<cfset LvarSuf13 	= 0>
						<cfset LvarSuf25 	= 0>
						<cfset LvarTabUpper 	= ucase(LvarTABcode)>
						<cfif len(LvarTabUpper) GT 13 OR (len(LvarTabUpper) EQ 13 AND isnumeric(mid(LvarTabUpper,12,2)))>
							<cfquery name="rsSQL" datasource="asp">
								select tab, suf13, suf25
								  from DBMtabSuf
								 where IDsch = #LvarIDsch# 
								   and tab 	 = '#LvarTabUpper#'
							</cfquery>
							<cfif rsSQL.tab NEQ "">
								<cfset LvarSuf13 = rsSQL.suf13>
								<cfset LvarSuf25 = rsSQL.suf25>
							<cfelse>
								<cfquery name="rsSQL" datasource="asp">
									select coalesce(max(suf13),0)+1 as suf13
									  from DBMtabSuf
									 where IDsch = #LvarIDsch# 
									   and tab like '#mid(LvarTabUpper,1,11)#%'
								</cfquery>
								<cfset LvarSuf13 = rsSQL.suf13>
								<cfif len(LvarTabUpper) GT 25 OR (len(LvarTabUpper) EQ 25 AND isnumeric(mid(LvarTabUpper,24,2)))>
									<cfquery name="rsSQL" datasource="asp">
										select coalesce(max(suf25),0)+1 as suf25
										  from DBMtabSuf
										 where IDsch = #LvarIDsch# 
										   and tab 	 like '#mid(LvarTabUpper,1,23)#%'
									</cfquery>
									<cfset LvarSuf25 = rsSQL.suf25>
								</cfif>
								<cfquery datasource="asp">
									insert into DBMtabSuf
										(IDsch, tab, suf13, suf25)
									values (#LvarIDsch#, '#LvarTabUpper#', #LvarSuf13#, #LvarSuf25#)
								</cfquery>
							</cfif>
						</cfif>
					</cfif>
					
					<!--- Verfica que no se vuelva a utilizar el tabAnt como tabla nueva --->
					<cfquery name="rsSQL" datasource="asp">
						select tab
						  from DBMtab
						 where IDsch  = #LvarIDsch#
						   and tabAnt = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTabCode#">
						UNION
						select tab
						  from DBMtabU
						 where IDupl	= #Arguments.IDupl#
						   and tabAnt	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTabCode#">
					</cfquery>
					<cfif rsSQL.recordCount GT 0>
						<cfquery datasource="asp">
							update DBMuploads
							   set msg = <cfqueryparam cfsqltype="cf_sql_clob" value="Nombre de tabla '#LvarTabCode#' ya no se puede utilizar porque está definido como nombre anterior de la tabla '#rsSQL.tab#'">
								 , stsP	= 0
								 , tabsP = 0
							 where IDupl = #Arguments.IDupl#
						</cfquery>
						<cfreturn>
					</cfif>
					
					<cfquery name="rsInsert" datasource="asp">
						insert into DBMtabU (IDupl, tab, des, rul, gen, genVer, del, suf13, suf25, tabAnt)
						values (
							#Arguments.IDupl#
							,<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTAB.XmlAttributes.cod#">
							,<cfqueryparam cfsqltype="cf_sql_varchar" value="#fnSinSaltoLinea(LvarTAB.XmlAttributes.des)#">
							,<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTAB.XmlAttributes.rul#"		null="#trim(LvarTAB.XmlAttributes.rul) EQ ''#">
							,<cfqueryparam cfsqltype="cf_sql_bit" 	  value="#LvarTAB.XmlAttributes.gen#">
							,<cfqueryparam cfsqltype="cf_sql_bit" 	  value="#LvarTAB.XmlAttributes.genVer#">
							,<cfqueryparam cfsqltype="cf_sql_bit" 	  value="#LvarTAB.XmlAttributes.del#">
							,<cfqueryparam cfsqltype="cf_sql_integer" value="#LvarSuf13#">
							,<cfqueryparam cfsqltype="cf_sql_integer" value="#LvarSuf25#">
							,<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTAB.XmlAttributes.ren#"	null="#trim(LvarTAB.XmlAttributes.ren) EQ ''#">
						)
						<cf_dbidentity1 name="rsInsert" returnVariable="LvarIDtab" datasource="asp">
					</cfquery>	
					<cf_dbidentity2 name="rsInsert" returnVariable="LvarIDtab" datasource="asp">
					
					<cfset LvarTabKeyV = LvarIDtab>
					
					<cfif LvarTAB.XmlAttributes.gen EQ "1"> 
						<cfloop index="c" from="1" to="#arrayLen(LvarTAB.col)#">
							<cfset LvarCOL = LvarTAB.col[c]>
							<cfparam name="LvarCOL.XmlAttributes.lon"		default="0">
							<cfparam name="LvarCOL.XmlAttributes.dec"		default="0">
							<cfparam name="LvarCOL.XmlAttributes.ide"		default="0">
							<cfparam name="LvarCOL.XmlAttributes.obl"		default="0">
							<cfparam name="LvarCOL.XmlAttributes.dfl"		default="">
							<cfparam name="LvarCOL.XmlAttributes.ini"		default="">
							<cfparam name="LvarCOL.XmlAttributes.min"		default="">
							<cfparam name="LvarCOL.XmlAttributes.max"		default="">
							<cfparam name="LvarCOL.XmlAttributes.lov"		default="">
							<cfparam name="LvarCOL.XmlAttributes.genVer"	default="1">
							<cfparam name="LvarCOL.XmlAttributes.del"		default="0">
							<cfparam name="LvarCOL.XmlAttributes.ren"		default="">
	
							<cfset LvarColCode 		= trim(LvarCOL.XmlAttributes.cod)>
							<cfset LvarColRename 	= trim(LvarCOL.XmlAttributes.ren)>
	
							<cfif LvarSecs> 
								<cfquery name="rsSQL" dbtype="query">
									select sec
									  from rsCols
									 where col = <cfqueryparam value="#LvarColCode#" cfsqltype="cf_sql_varchar">
								</cfquery>
								<cfif rsSQL.sec EQ "" AND LvarColRename NEQ "">
									<cfquery name="rsSQL" dbtype="query">
										select sec
										  from rsCols
										 where col = <cfqueryparam value="#LvarColRename#" cfsqltype="cf_sql_varchar">
									</cfquery>
								</cfif>
								<cfset LvarSec = rsSQL.sec>
							<cfelse>
								<cfset LvarSec = "">
							</cfif>
	
							<cfif LvarSec EQ "">
								<cfset LvarSecCol ++>
								<cfset LvarSec = LvarSecCol>
							</cfif>
	
							<cfset LvarTip = LvarCOL.XmlAttributes.tip>
							<cfif LvarTip EQ "M">
								<cfset LvarCOL.XmlAttributes.lon = "18">
								<cfset LvarCOL.XmlAttributes.dec = "4">
							<cfelseif LvarTip EQ "L">
								<cfset LvarCOL.XmlAttributes.lon = "1">
								<cfset LvarCOL.XmlAttributes.dec = "0">
							<cfelseif LvarTip EQ "CL" OR LvarTip EQ "BL">
								<cfset LvarCOL.XmlAttributes.lon = "-2">
								<cfset LvarCOL.XmlAttributes.dec = "0">
							</cfif>
							<cfif lcase(LvarCOL.XmlAttributes.cod) EQ "bmusucodigo">
								<cfset LvarCOL.XmlAttributes.sec = "1001">
							<cfelseif LvarCOL.XmlAttributes.cod EQ "ts_rversion">
								<cfset LvarCOL.XmlAttributes.sec = "1002">
							</cfif>

							<!--- Verfica que no se vuelva a utilizar el colAnt como columna nueva --->
							<cfquery name="rsSQL" datasource="asp">
								select t.tab, c.col
								  from DBMtab t
								  	inner join DBMcol c
										on c.IDtab = t.IDtab
								 where t.tab	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTabCode#">
								   and c.colAnt = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarColCode#">
								UNION
								select t.tab, c.col
								  from DBMtabU t
								  	inner join DBMcolU c
										on c.IDtab = t.IDtab
								 where t.IDupl	= #Arguments.IDupl#
								   and t.tab	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTabCode#">
								   and c.colAnt = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarColCode#">
							</cfquery>
							<cfif rsSQL.recordCount GT 0>
								<cfquery datasource="asp">
									update DBMuploads
									   set msg = <cfqueryparam cfsqltype="cf_sql_clob" value="Nombre de columna '#LvarTabCode#.#LvarColCode#' ya no se puede utilizar porque está definido como nombre anterior de la columna '#LvarTabCode#.#rsSQL.col#'">
										 , stsP	= 0
										 , tabsP = 0
									 where IDupl = #Arguments.IDupl#
								</cfquery>
								<cfreturn>
							</cfif>

							<cfquery datasource="asp">
								insert into DBMcolU (IDtab, col, sec, des, tip, lon, dec, ide, obl, dfl, ini, minVal, maxVal, lov, genVer, del, colAnt)
								values (
									 #LvarIDtab#
									,<cfqueryparam value="#LvarColCode#"						cfsqltype="cf_sql_varchar">
									,#LvarSec#
									,<cfqueryparam value="#fnSinSaltoLinea(LvarCOL.XmlAttributes.des)#"			cfsqltype="cf_sql_varchar">
									,<cfqueryparam value="#LvarCOL.XmlAttributes.tip#"			cfsqltype="cf_sql_char">
									,<cfqueryparam value="#LvarCOL.XmlAttributes.lon#"			cfsqltype="cf_sql_integer">
									,<cfqueryparam value="#LvarCOL.XmlAttributes.dec#"			cfsqltype="cf_sql_integer">
									,<cfqueryparam value="#LvarCOL.XmlAttributes.ide#"			cfsqltype="cf_sql_bit">
								<cfif LvarCOL.XmlAttributes.ide EQ "1" OR LvarCOL.XmlAttributes.tip EQ "TS">
									,1
								<cfelse>
									,<cfqueryparam value="#LvarCOL.XmlAttributes.obl#"			cfsqltype="cf_sql_bit">
								</cfif>
									,<cfqueryparam value="#LvarCOL.XmlAttributes.dfl#"			cfsqltype="cf_sql_varchar"	null="#trim(LvarCOL.XmlAttributes.dfl) EQ ''#">
									,<cfqueryparam value="#LvarCOL.XmlAttributes.ini#"			cfsqltype="cf_sql_varchar"	null="#trim(LvarCOL.XmlAttributes.ini) EQ ''#">
									,<cfqueryparam value="#LvarCOL.XmlAttributes.min#"			cfsqltype="cf_sql_varchar"	null="#trim(LvarCOL.XmlAttributes.min) EQ ''#">
									,<cfqueryparam value="#LvarCOL.XmlAttributes.max#"			cfsqltype="cf_sql_varchar"	null="#trim(LvarCOL.XmlAttributes.max) EQ ''#">
									,<cfqueryparam value="#LvarCOL.XmlAttributes.lov#"			cfsqltype="cf_sql_varchar"	null="#trim(LvarCOL.XmlAttributes.lov) EQ ''#">
									,<cfqueryparam value="#LvarCOL.XmlAttributes.genVer#"		cfsqltype="cf_sql_bit">
									,<cfqueryparam value="#LvarCOL.XmlAttributes.del#"			cfsqltype="cf_sql_bit">
									,<cfqueryparam value="#LvarCOL.XmlAttributes.ren#"			cfsqltype="cf_sql_varchar"	null="#trim(LvarCOL.XmlAttributes.ren) EQ ''#">
								)
							</cfquery>
						</cfloop>
						<cfif isdefined("LvarTAB.key")>
							<cfloop index="k" from="1" to="#arrayLen(LvarTAB.key)#">
								<cfset LvarKey = LvarTAB.key[k]>
								<cfparam name="LvarKey.XmlAttributes.ref"		default="*">
								<cfparam name="LvarKey.XmlAttributes.colsR"		default="*">
		
								<cfparam name="LvarKey.XmlAttributes.sec"		default="#k#">
								<cfparam name="LvarKey.XmlAttributes.clu"		default="0">
								<cfparam name="LvarKey.XmlAttributes.idxTip"	default="#LvarKey.XmlAttributes.tip#">
								<cfparam name="LvarKey.XmlAttributes.gen"		default="#LvarTAB.XmlAttributes.gen#">
								<cfparam name="LvarKey.XmlAttributes.genVer"	default="1">
								<cfparam name="LvarKey.XmlAttributes.del"		default="0">
								<cfparam name="LvarKey.XmlAttributes.colsAnt"	default="">

								<cfif LvarSecs> 
									<cfquery name="rsSQL" dbtype="query">
										select sec
										  from rsKeys
										 where cols  = <cfqueryparam value="#LvarKey.XmlAttributes.cols#"		cfsqltype="cf_sql_varchar">
										   and tip	 = <cfqueryparam value="#LvarKey.XmlAttributes.tip#"		cfsqltype="cf_sql_varchar">
										   and ref	 = <cfqueryparam value="#LvarKey.XmlAttributes.ref#"		cfsqltype="cf_sql_varchar">
										   and colsR = <cfqueryparam value="#LvarKey.XmlAttributes.colsR#"		cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfset LvarSec = rsSQL.sec>
								<cfelse>
									<cfset LvarSec = "">
								</cfif>
		
								<!--- colsAnt: cambio de PK o AK --->
								<cfif LvarKey.XmlAttributes.colsAnt EQ "" OR NOT listFind("P,A",trim(LvarKey.XmlAttributes.tip))>
									<cfset LvarColsAnt = "">
								<cfelse>
									<cfquery name="rsSQL" dbtype="query">
										select cols
										  from rsKeys
										 where upper(cols)	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(LvarKey.XmlAttributes.colsAnt)#">
										   and tip	 		in ('P','A')
									</cfquery>
									<cfif rsSQL.recordCount EQ 0>
										<cfthrow message="Se está intentando modificar un #LvarKey.XmlAttributes.tip#K, pero no se ha definido en DBM el #LvarKey.XmlAttributes.tip#K anterior: tab=#LvarTabCode# cols=#LvarKey.XmlAttributes.colsAnt#">
									</cfif>
									<cfset LvarColsAnt = rsSQL.cols>
								</cfif>
								
								<cfif LvarSec EQ "">
									<cfif trim(LvarKey.XmlAttributes.tip) EQ "P">
										<cfset LvarSec = 0>
									<cfelseif listFind("A,U,I",trim(LvarKey.XmlAttributes.tip))>
										<cfset LvarSecIdx ++>
										<cfset LvarSec = LvarSecIdx>
									<cfelse>
										<cfset LvarSecFK  ++>
										<cfset LvarSec = LvarSecFK>
									</cfif>
								</cfif>
		
								<cfquery datasource="asp">
									insert into DBMkeyU (IDtab, cols, tip, ref, colsR, sec, clu, idxTip, gen, genVer, del, colsAnt)
									values (
										 #LvarIDtab#
										,<cfqueryparam value="#LvarKey.XmlAttributes.cols#"		cfsqltype="cf_sql_varchar">
										,<cfqueryparam value="#LvarKey.XmlAttributes.tip#"		cfsqltype="cf_sql_varchar">
										,<cfqueryparam value="#LvarKey.XmlAttributes.ref#"		cfsqltype="cf_sql_varchar">
										,<cfqueryparam value="#LvarKey.XmlAttributes.colsR#"	cfsqltype="cf_sql_varchar">
										,#LvarSec#
										,<cfqueryparam value="#LvarKey.XmlAttributes.clu#"		cfsqltype="cf_sql_bit">
										,<cfqueryparam value="#LvarKey.XmlAttributes.idxTip#"	cfsqltype="cf_sql_varchar">
										,<cfqueryparam value="#LvarKey.XmlAttributes.gen#"		cfsqltype="cf_sql_bit">
										,<cfqueryparam value="#LvarKey.XmlAttributes.genVer#"	cfsqltype="cf_sql_bit">
										,<cfqueryparam value="#LvarKey.XmlAttributes.del#"		cfsqltype="cf_sql_bit">
										,<cfqueryparam value="#LvarColsAnt#"					cfsqltype="cf_sql_varchar" null="#LvarColsAnt EQ ""#">
									)
								</cfquery>
							</cfloop>
						</cfif>
					</cfif>
				</cfif>
			</cfloop>
		
			<cfquery datasource="asp">
				update DBMuploads
				   set 	stsP	= 2, 		<!--- Verificando Datos Cargados... --->
						tabsP	= 1
				 where IDupl = #Arguments.IDupl#
			</cfquery>
			
			<cf_dbfunction name="OP_CONCAT" returnvariable="CAT" datasource="asp">
			<cfquery name="rsSQL" datasource="asp">
				select distinct '<BR>' #CAT# u.tab #CAT# ' -> ' #CAT# m.modelo as tabs
				  from DBMtabU u
					inner join DBMuploads uu
					   on uu.IDupl = u.IDupl
					inner join DBMmodelos mm
					   on mm.IDmod = uu.IDmod
					inner join 	DBMtab t 
						inner join DBMmodelos m 
						   on m.IDmod = t.IDmodORI
					   on t.IDsch = mm.IDsch
					  and t.tab = u.tab
				 where u.IDupl = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDupl#">
				   and t.IDmodORI <> uu.IDmod
				   and u.gen = 1
			</cfquery>
			<cfif rsSQL.recordCount GT 0>
				<cfset LvarError = "">
				<cfquery datasource="asp">
					update DBMuploads
					   set msg = <cfqueryparam cfsqltype="cf_sql_clob" value="Tablas pertenecientes a otro modelo (indique DBM:NO_GENERATE): #valueList(rsSQL.tabs)#">
						 , stsP	= 0
						 , tabsP = 0
					 where IDupl = #Arguments.IDupl#
				</cfquery>
				<cfreturn>
			</cfif>
		
			<cfset fnUpdateTabsP("UPLOAD", Arguments.IDupl, 33)>
		
			<cfquery name="rsSQL" datasource="asp">
				select distinct tab as tab
				  from DBMtabU t1
				 where IDupl = #Arguments.IDupl#
				   and (
						select count(1) 
						  from DBMtabU t2
						 where upper(t2.tab) = upper(t1.tab)
						   and t2.tab <> t1.tab
						)>0
				   and (
						select count(1) 
						  from DBMtab t2
						 where t2.IDsch = #LvarIDsch#
						   and upper(t2.tab) = upper(t1.tab)
						   and t2.tab <> t1.tab
						)>0
			</cfquery>
			<cfif rsSQL.recordCount GT 0>
				<cfquery datasource="asp">
					update DBMuploads
					   set msg = <cfqueryparam cfsqltype="cf_sql_clob" value="Tablas repetidas: #valueList(rsSQL.tab)#">
						 , stsP	= 0
						 , tabsP = 0
					 where IDupl = #Arguments.IDupl#
				</cfquery>
				<cfreturn>
			</cfif>
		
			<cfset fnUpdateTabsP("UPLOAD", Arguments.IDupl, 66)>
		
			<cfquery name="rsSQL" datasource="asp">
				select distinct '<BR>' #CAT# t1.tab #CAT# ' - ' #CAT# c1.col as Campos
				  from DBMcolU c1
					inner join DBMtabU t1 
					   on t1.IDtab=c1.IDtab
				 where IDupl = #Arguments.IDupl#
				   and (
						select count(1) 
						  from DBMcolU c2
						 where c2.IDtab = c1.IDtab
						   and upper(c2.col) = upper(c1.col)
						   and c2.col <> c1.col
						)>0
				   and (
						select count(1) 
						  from DBMcol c2
							inner join DBMtab t2
							   on t2.IDtab = c2.IDtab
						 where t2.IDsch = #LvarIDsch#
						   and t2.tab	= t1.tab
	
						   and upper(c2.col) = upper(c1.col)
						   and c2.col <> c1.col
						)>0
			</cfquery>
			<cfif rsSQL.recordCount GT 0>
				<cfquery datasource="asp">
					update DBMuploads
					   set msg = <cfqueryparam cfsqltype="cf_sql_clob" value="Campos repetidos: #valueList(rsSQL.campos)#">
						 , stsP	= 0
						 , tabsP = 0
					 where IDupl = #Arguments.IDupl#
				</cfquery>
				<cfreturn>
			</cfif>
		
			<cfquery name="rsSQL" datasource="asp">
				select '<BR>' #CAT# t1.tab #CAT# ' - ' #CAT# c1.col as Campos
				  from DBMcolU c1
					inner join DBMtabU t1 
					   on t1.IDtab=c1.IDtab
				 where IDupl 	= #Arguments.IDupl#
				   and c1.ide	= 1
				 group by t1.tab, c1.col
				having count(1) > 1
			</cfquery>
			<cfif rsSQL.recordCount GT 0>
				<cfquery datasource="asp">
					update DBMuploads
					   set msg = <cfqueryparam cfsqltype="cf_sql_clob" value="Campos Identity repetidos: #valueList(rsSQL.campos)#">
						 , stsP	= 0
						 , tabsP = 0
					 where IDupl = #Arguments.IDupl#
				</cfquery>
				<cfreturn>
			</cfif>
			<!--- Se eliminan todas las referencias a Empresas que no son necesaria porque están contenidas en otras referencias --->
			<!--- Se mantiene los indices  --->
			<cfquery datasource="asp">
				UPDATE DBMkeyU
				   set gen = 0
				 where (
						select count(1) 
						  from DBMkeyU pd
							inner join DBMtabU t
								on t.IDtab = pd.IDtab
						 where t.IDupl 		= #Arguments.IDupl#
						   and pd.IDtab		= DBMkeyU.IDtab
						   and pd.cols		= DBMkeyU.cols
						   and pd.tip		= DBMkeyU.tip
						   and pd.ref		= DBMkeyU.ref
						   and pd.colsR		= DBMkeyU.colsR
						   and pd.del		= 0
						   and pd.tip		= 'F'
						   and pd.ref		= 'Empresas'
						   and (
								select count(1) 
								  from DBMkeyU
								 where IDtab		=  pd.IDtab
								   and cols			<> pd.cols
								   and tip			=  pd.tip
								   and ','+cols+','	like '%,' + pd.cols + ',%'
								   and del			=  0
								   and gen			=  1
								)>0
						) > 0
			</cfquery>
	
			<cfquery datasource="asp">
				update DBMuploads
				   set 	sts		= 1,		<!--- Upload Cargado --->
						stsP	= 0, 		
						tabs	= (select count(1) from DBMtabU where IDupl = #Arguments.IDupl#),
						tabsP	= (select count(1) from DBMtabU where IDupl = #Arguments.IDupl#),
						msg		= null,
						html	= null
				 where IDupl = #Arguments.IDupl#
			</cfquery>
			<cfset UPLOAD_verificar(Arguments.IDupl)>
		<cfcatch type="any">
			<cfset sbUPLOAD_error (cfcatch, Arguments.IDupl, "XML_toUpload")>
			<cfreturn>
		</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="sbUPLOAD_error" output="no" returntype="void">
		<cfargument name="cfcatch"	 	type="any"	required="yes">
		<cfargument name="IDupl"		type="numeric"	required="yes">
		<cfargument name="proceso"		type="string"	default="PROCESO">
	
		<cfset LvarError = fnFuenteLinea(Arguments.cfcatch)>
		<cfset LvarFile = expandPath("/asp/parches/DBmodel/scripts/") & "U" & numberFormat(Arguments.IDupl,"0000000000") & "_err.txt">
		<cffile file="#LvarFile#" action="write" output="ERROR EN #Arguments.proceso#: #Arguments.cfcatch.Message#: #Arguments.cfcatch.Detail# #LvarError#">
		<cf_jdbcquery_open update="yes" datasource="asp">
			<cfoutput>
			update DBMuploads
			   set msg = #fnSQLstring("#cfcatch.Message#: #cfcatch.Detail# #LvarError#",500)#
				 , stsP = 0
				 , tabsP = 0
			 where IDupl = #Arguments.IDupl#
			</cfoutput>
		</cf_jdbcquery_open>
	</cffunction>
	
	<cffunction name="XML_toVersion" access="public" output="no" returntype="void">
		<cfargument name="archivo"	required="yes">
	
		<cfset LvarUPLOAD_File = expandPath("/asp_dbm/upload.txt")>
	
		<cftry>
			<cffile action="read" file="#Arguments.Archivo#" variable="LvarXML">
			<cfset LvarDOC 		= XmlParse(LvarXML)>
			<cfset LvarDocTabs 	= LvarDoc.version>
			
			<cfset LvarIDsch	= LvarDocTabs.XmlAttributes.IDsch>
			<cfset LvarIDmod	= LvarDocTabs.XmlAttributes.IDmod>
			<cfset LvarParche	= LvarDocTabs.XmlAttributes.parche>
			<cfset LvarVerFec	= parseDateTime(replace(LvarDocTabs.XmlAttributes.fec,"T"," "))>

			<!--- Genera Control de Parches ---> 
			<cftry>
				<cfquery name="rsSQL" datasource="asp">
					select count(1) as cantidad
					  from DBMcontrolParches
					 where parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarParche#">
				</cfquery>
			<cfcatch type="database">
				<cf_dbcreate name="DBMcontrolParches" returnvariable="DBMgens" datasource="asp">
					<cf_dbcreatecol name="IDparche"		    	type="numeric"		identity>
					<cf_dbcreatecol name="parche"		    	type="varchar(50)"	mandatory="yes">
					<cf_dbcreatecol name="fechaParche"		   	type="datetime"		mandatory="yes">
					<cf_dbcreatecol name="fechaAlta"	    	type="datetime"		mandatory="yes">
				
					<cf_dbcreatekey cols="IDparche">
				</cf_dbcreate>
				<cfquery datasource="asp">
					insert into DBMcontrolParches (parche, fechaParche, fechaAlta)
					select parche, min(fec), <cf_dbfunction name="now">
					  from DBMversiones
					 where upper(parche) LIKE 'PARCHE%'
					 group by parche
				</cfquery>
				<cfquery name="rsSQL" datasource="asp">
					select count(1) as cantidad
					  from DBMcontrolParches
					 where parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarParche#">
				</cfquery>
			</cfcatch>
			</cftry>
			<cfif rsSQL.cantidad EQ 0 and ucase(left(LvarParche,6)) EQ "PARCHE">
				<cfquery name="rsInsert" datasource="asp">
					insert into DBMcontrolParches (parche, fechaParche, fechaAlta)
					values (
						  <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#LvarParche#" len="50">
						, <cfqueryparam cfsqltype="cf_sql_timestamp"	value="#LvarVerFec#">
						, <cfqueryparam cfsqltype="cf_sql_timestamp"	value="#now()#">
					) 
				</cfquery>
			</cfif>
			
			<cfif LvarIDsch	NEQ 0 AND LvarIDmod NEQ 0>
				<!--- Crea el schema --->
				<cfquery name="rsSQL" datasource="asp">
					select IDsch 
					  from DBMsch
					 where IDsch = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarIDsch#">
				</cfquery>
				<cfif rsSQL.IDsch EQ "">
					<cfquery name="rsSQL" datasource="asp">
						insert into DBMsch(IDsch,sch) 
						values(
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarIDsch#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarDocTabs.XmlAttributes.sch#">
						)
					</cfquery>
				</cfif>		
			
				<!--- Crea el modelo --->
				<cfquery name="rsSQL" datasource="asp">
					select IDmod
					  from DBMmodelos
					 where IDmod = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarIDmod#">
				</cfquery>
				<cfif rsSQL.IDmod EQ "">
					<cfquery name="rsSQL" datasource="asp">
						insert into DBMmodelos (IDmod, modelo, IDsch, uidSVN) 
						values(
							  <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarIDmod#">
							, <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarDocTabs.XmlAttributes.modelo#">
							, <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarIDsch#">
							, 'SOIN'
						)
					</cfquery>
				</cfif>		
			
				<!--- Crea la version --->
				<cfquery name="rsInsert" datasource="asp">
					insert into DBMversiones (IDmod, des, sts, uidSVN, fec, parche)
					values (
						  #LvarIDmod#
						, <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#LvarDocTabs.XmlAttributes.des#" len="50">
						, 0
						, 'SOIN'
						, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarVerFec#">
						, <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#LvarParche#" len="50">
					)
					<cf_dbidentity1 name="rsInsert" datasource="asp" returnvariable="LvarIDver">
				</cfquery>
				<cf_dbidentity2 name="rsInsert" datasource="asp" returnvariable="LvarIDver">
				
				<cfset LvarDELETE = true>
				<cfset LvarTabsP = 0>
				<cfloop index="t" from="1" to="#arrayLen(LvarDocTabs.tab)#">
					<!--- Procesamiento de Avance y Abort --->
					<cfif t - LvarTabsP GT 10>
						<cfset LvarTabsP = t>
			
						<cfif NOT fileExists(#Arguments.Archivo#)>
							<cfreturn>
						<cfelse>
							<cflock name="DBM_LOAD" throwontimeout="yes" type="exclusive" timeout="10">
								<cffile action="read" file="#LvarUPLOAD_File#" variable="LvarTxt">
						
								<cfif findNoCase("ABORT",LvarTxT)>
									<cfthrow message="Proceso Cancelado por el usuario">
								<cfelseif findNoCase("IGNORE",LvarTxT)>
									<cfreturn>
								</cfif>
			
								<cfset LvarDatos = "#ListGetAt(LvarTxt,1)#,#now()#,#ListGetAt(LvarTxt,3)#,#round(t/arrayLen(LvarDocTabs.tab)*100)#">
								<cffile action="write" file="#LvarUPLOAD_File#" output="#LvarDatos#">
							</cflock>
						</cfif>		
					</cfif>
					
					<cfset LvarTAB = LvarDocTabs.tab[t]>
					<cfparam name="LvarTAB.XmlAttributes.ren"		default="">
					<cfquery name="rsSQL" datasource="asp">
						select t.IDtab, v.fec
						  from DBMtab t
							inner join DBMversiones v
							 on v.IDver = t.IDver
						 where t.IDsch = #LvarIDsch# 
					   <cfif trim(LvarTAB.XmlAttributes.ren) EQ "">
						   and t.tab = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(LvarTAB.XmlAttributes.cod)#">
					   <cfelse>
						   and 	(
									t.tab = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(LvarTAB.XmlAttributes.cod)#"> OR
									t.tab = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(LvarTAB.XmlAttributes.ren)#">
								)
						</cfif>					   
					</cfquery>
			
					<!--- Solo se van a cargar tablas cuando la fecha de control de la versión sea posterior a la fecha de la última modificación de la tabla --->
					<cfif LvarVerFec GT rsSQL.fec>
						<cfset LvarDELETE = false>
						<!--- <tab cod="" des="" suf13="" suf25="" IDmod="" [rul=""]> --->
						<cfparam name="LvarTAB.XmlAttributes.gen"		default="1">
						<cfparam name="LvarTAB.XmlAttributes.rul"		default="">
						<cfparam name="LvarTAB.XmlAttributes.genVer"	default="1">
						<cfparam name="LvarTAB.XmlAttributes.del"		default="0">
						<cfparam name="LvarTAB.XmlAttributes.suf13"		default="0">
						<cfparam name="LvarTAB.XmlAttributes.suf25"		default="0">
			
						<cfif rsSQL.IDtab EQ "">
							<cfset LvarTabNueva = true>			
							<cfquery name="rsInsert" datasource="asp">
								insert into DBMtab (IDsch, tab, des, suf13, suf25, IDmodORI, rul, del, IDver, tabAnt)
								values (
									 #LvarIDsch#
									,<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTAB.XmlAttributes.cod#">
									,<cf_jdbcquery_param cfsqltype="cf_sql_varchar" len="30" value="#fnSinSaltoLinea(LvarTAB.XmlAttributes.des)#">
									,<cfqueryparam cfsqltype="cf_sql_integer" value="#LvarTAB.XmlAttributes.suf13#">
									,<cfqueryparam cfsqltype="cf_sql_integer" value="#LvarTAB.XmlAttributes.suf25#">
									,<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTAB.XmlAttributes.IDmod#">
									,<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTAB.XmlAttributes.rul#"	null="#trim(LvarTAB.XmlAttributes.rul) EQ ''#">
									,<cfqueryparam cfsqltype="cf_sql_bit" 	  value="#LvarTAB.XmlAttributes.del#">
									,#LvarIDver#
									,<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(LvarTAB.XmlAttributes.ren)#" null="#trim(LvarTAB.XmlAttributes.ren) EQ ""#">
								)
								<cf_dbidentity1 name="rsInsert" returnVariable="LvarIDtab" datasource="asp">
							</cfquery>	
							<cf_dbidentity2 name="rsInsert" returnVariable="LvarIDtab" datasource="asp">
						<cfelse>
							<cfset LvarTabNueva = false>
							<cfset LvarIDtab = rsSQL.IDtab>
							<cfquery datasource="asp">
								update DBMtab 
								   set tab		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTAB.XmlAttributes.cod#">
									 , des		= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" len="30" value="#fnSinSaltoLinea(LvarTAB.XmlAttributes.des)#">
									 , IDmodORI = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTAB.XmlAttributes.IDmod#">
									 , rul		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTAB.XmlAttributes.rul#" 	null="#trim(LvarTAB.XmlAttributes.rul) EQ ''#">
									 , del		= #LvarTAB.XmlAttributes.del#
									 , IDver	= #LvarIDver#
									 , suf13	=<cfqueryparam cfsqltype="cf_sql_integer" value="#LvarTAB.XmlAttributes.suf13#">
									 , suf25	=<cfqueryparam cfsqltype="cf_sql_integer" value="#LvarTAB.XmlAttributes.suf25#">
									 <cfif trim(LvarTAB.XmlAttributes.ren) NEQ "">
									 , tabAnt	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(LvarTAB.XmlAttributes.ren)#">
									 </cfif>
								 where IDtab	= #LvarIDtab#
							</cfquery>
						</cfif>
						<cfquery datasource="asp">
							insert into DBMtabV
								(
									IDver, IDtab, op
								)
							values (
									#LvarIDver#,
									#LvarIDtab#,
									1
								)
						</cfquery>
									
						<cfif LvarTAB.XmlAttributes.gen EQ "1"> 
							<cfquery datasource="asp">
								delete from DBMcolLov
								 where (
									select count(1)
									  from DBMcol c
									 where c.IDtab = #LvarIDtab#
									   and c.IDcol = DBMcolLov.IDcol
									) > 0
							</cfquery>
							<cfloop index="c" from="1" to="#arrayLen(LvarTAB.col)#">
								<cfset LvarCOL = LvarTAB.col[c]>
								<!--- <col cod="" des="" sec="" tip="" [lon=""] [dec=""] [ide=""] [obl=""] [dfl=""] [ini=""] [min=""] [max=""] [lov=""] /> --->
								<cfparam name="LvarCOL.XmlAttributes.lon"		default="0">
								<cfparam name="LvarCOL.XmlAttributes.dec"		default="0">
								<cfparam name="LvarCOL.XmlAttributes.ide"		default="0">
								<cfparam name="LvarCOL.XmlAttributes.obl"		default="0">
								<cfparam name="LvarCOL.XmlAttributes.dfl"		default="">
								<cfparam name="LvarCOL.XmlAttributes.ini"		default="">
								<cfparam name="LvarCOL.XmlAttributes.min"		default="">
								<cfparam name="LvarCOL.XmlAttributes.max"		default="">
								<cfparam name="LvarCOL.XmlAttributes.lov"		default="">
								<cfparam name="LvarCOL.XmlAttributes.del"		default="0">
								<cfparam name="LvarCOL.XmlAttributes.ren"		default="">
								<cfset LvarTip = LvarCOL.XmlAttributes.tip>
								<cfif LvarTip EQ "M">
									<cfset LvarCOL.XmlAttributes.lon = "18">
									<cfset LvarCOL.XmlAttributes.dec = "4">
								<cfelseif LvarTip EQ "L">
									<cfset LvarCOL.XmlAttributes.lon = "1">
									<cfset LvarCOL.XmlAttributes.dec = "0">
								<cfelseif LvarTip EQ "CL" OR LvarTip EQ "BL">
									<cfset LvarCOL.XmlAttributes.lon = "-2">
									<cfset LvarCOL.XmlAttributes.dec = "0">
								</cfif>
								<cfif lcase(LvarCOL.XmlAttributes.cod) EQ "bmusucodigo">
									<cfset LvarCOL.XmlAttributes.sec = "1001">
								<cfelseif LvarCOL.XmlAttributes.cod EQ "ts_rversion">
									<cfset LvarCOL.XmlAttributes.sec = "1002">
								</cfif>
								<cfif LvarTabNueva>
									<cfset LvarIDcol = "">
								<cfelse>
									<cfquery name="rsCOLs" datasource="asp">
										select 	IDcol
										  from DBMcol 
										 where IDtab	= #LvarIDtab#
	
									   <cfif trim(LvarTAB.XmlAttributes.ren) EQ "">
										   and col	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarCOL.XmlAttributes.cod#">
									   <cfelse>
										   and 	(
													col	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarCOL.XmlAttributes.cod#"> OR
													col	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarCOL.XmlAttributes.ren#">
												)
										</cfif>					   
					
									</cfquery>
									<cfset LvarIDcol = rsCOLs.IDcol>
								</cfif>
								<cfif LvarIDcol EQ "">
									<cfquery name="rsInsert" datasource="asp">
										insert into DBMcol (
											IDtab, col, 
											sec, 
											des, tip, lon, dec, ide, obl, dfl, ini, minVal, maxVal, lov, del,
											IDver, colAnt
										)
										values (
											 #LvarIDTab#
											,<cfqueryparam value="#LvarCOL.XmlAttributes.cod#"			cfsqltype="cf_sql_varchar">
			
											,#LvarCOL.XmlAttributes.sec#
		
											,<cf_jdbcquery_param cfsqltype="cf_sql_varchar" len="50" value="#fnSinSaltoLinea(LvarCOL.XmlAttributes.des)#">
											,<cfqueryparam value="#LvarCOL.XmlAttributes.tip#"			cfsqltype="cf_sql_char">
											,<cfqueryparam value="#LvarCOL.XmlAttributes.lon#"			cfsqltype="cf_sql_integer">
											,<cfqueryparam value="#LvarCOL.XmlAttributes.dec#"			cfsqltype="cf_sql_integer">
											,<cfqueryparam value="#LvarCOL.XmlAttributes.ide#"			cfsqltype="cf_sql_bit">
										<cfif LvarCOL.XmlAttributes.ide EQ "1" OR LvarCOL.XmlAttributes.tip EQ "TS">
											,1 
										<cfelse>
											,<cfqueryparam value="#LvarCOL.XmlAttributes.obl#"			cfsqltype="cf_sql_bit">
										</cfif>
											,<cfqueryparam value="#LvarCOL.XmlAttributes.dfl#"			cfsqltype="cf_sql_varchar"		null="#trim(LvarCOL.XmlAttributes.dfl) EQ ''#">
											,<cfqueryparam value="#LvarCOL.XmlAttributes.ini#"			cfsqltype="cf_sql_varchar"		null="#trim(LvarCOL.XmlAttributes.ini) EQ ''#">
											,<cfqueryparam value="#LvarCOL.XmlAttributes.min#"			cfsqltype="cf_sql_varchar"		null="#trim(LvarCOL.XmlAttributes.min) EQ ''#">
											,<cfqueryparam value="#LvarCOL.XmlAttributes.max#"			cfsqltype="cf_sql_varchar"		null="#trim(LvarCOL.XmlAttributes.max) EQ ''#">
											,<cfqueryparam value="#LvarCOL.XmlAttributes.lov#"			cfsqltype="cf_sql_varchar"		null="#trim(LvarCOL.XmlAttributes.lov) EQ ''#">
											,<cfqueryparam value="#LvarCOL.XmlAttributes.del#"			cfsqltype="cf_sql_bit">
											,#LvarIDver#
											,<cfqueryparam value="#LvarCOL.XmlAttributes.ren#"			cfsqltype="cf_sql_varchar"		null="#trim(LvarCOL.XmlAttributes.ren) EQ ''#">
										)
										<cf_dbidentity1 name="rsInsert" returnVariable="LvarIDcol" datasource="asp">
									</cfquery>	
									<cf_dbidentity2 name="rsInsert" returnVariable="LvarIDcol" datasource="asp">
								<cfelse>
									<cfquery datasource="asp">
										update DBMcol
										   set    sec 		= #LvarCOL.XmlAttributes.sec#
												, des 		= <cf_jdbcquery_param cfsqltype="cf_sql_varchar" len="50" value="#fnSinSaltoLinea(LvarCOL.XmlAttributes.des)#">
												, tip 		= <cfqueryparam value="#LvarCOL.XmlAttributes.tip#"			cfsqltype="cf_sql_char">
												, lon 		= <cfqueryparam value="#LvarCOL.XmlAttributes.lon#"			cfsqltype="cf_sql_integer">
												, dec 		= <cfqueryparam value="#LvarCOL.XmlAttributes.dec#"			cfsqltype="cf_sql_integer">
												, ide 		= <cfqueryparam value="#LvarCOL.XmlAttributes.ide#"			cfsqltype="cf_sql_bit">
												, obl 		= <cfqueryparam value="#LvarCOL.XmlAttributes.obl#"			cfsqltype="cf_sql_bit">
												, dfl 		= <cfqueryparam value="#LvarCOL.XmlAttributes.dfl#"			cfsqltype="cf_sql_varchar"		null="#trim(LvarCOL.XmlAttributes.dfl) EQ ''#">
												, ini 		= <cfqueryparam value="#LvarCOL.XmlAttributes.ini#"			cfsqltype="cf_sql_varchar"		null="#trim(LvarCOL.XmlAttributes.ini) EQ ''#">
												, minVal 	= <cfqueryparam value="#LvarCOL.XmlAttributes.min#"			cfsqltype="cf_sql_varchar"		null="#trim(LvarCOL.XmlAttributes.min) EQ ''#">
												, maxVal 	= <cfqueryparam value="#LvarCOL.XmlAttributes.max#"			cfsqltype="cf_sql_varchar"		null="#trim(LvarCOL.XmlAttributes.max) EQ ''#">
												, lov 		= <cfqueryparam value="#LvarCOL.XmlAttributes.lov#"			cfsqltype="cf_sql_varchar"		null="#trim(LvarCOL.XmlAttributes.lov) EQ ''#">
												, del 		= <cfqueryparam value="#LvarCOL.XmlAttributes.del#"			cfsqltype="cf_sql_bit">
												, IDver		= #LvarIDver#
												<cfif trim(LvarTAB.XmlAttributes.ren) NEQ "">
												, colAnt	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(LvarCOL.XmlAttributes.ren)#">
												</cfif>
										 where IDcol = #LvarIDcol#
									</cfquery>
								</cfif>
								<cfset sbLOV(LvarIDcol, LvarCOL.XmlAttributes.lov)>
							</cfloop>
							<cfif isdefined("LvarTAB.key")>
								<cfloop index="k" from="1" to="#arrayLen(LvarTAB.key)#">
									<cfset LvarKey = LvarTAB.key[k]>
									<!--- <key tip="" sec="" cols="" [clu="1"] > --->
									<!--- <key tip="" sec="" cols="" ref="" colsR=""> --->
									<cfparam name="LvarKey.XmlAttributes.ref"		default="*">
									<cfparam name="LvarKey.XmlAttributes.colsR"		default="*">
									<cfparam name="LvarKey.XmlAttributes.clu"		default="0">
									<cfparam name="LvarKey.XmlAttributes.idxTip"	default="#LvarKey.XmlAttributes.tip#">
									<cfparam name="LvarKey.XmlAttributes.gen"		default="1">
									<cfparam name="LvarKey.XmlAttributes.del"		default="0">
									
									<cfif LvarTabNueva>
										<cfset LvarIDkey = "">
									<cfelse>
										<cfquery name="rsSQL" datasource="asp">
											select IDkey
											  from DBMkey
											 where IDtab	= <cfqueryparam value="#LvarIDTab#" 					cfsqltype="cf_sql_numeric">
											   and cols		= <cfqueryparam value="#LvarKey.XmlAttributes.cols#"	cfsqltype="cf_sql_varchar">
											   and tip		= <cfqueryparam value="#LvarKey.XmlAttributes.tip#"		cfsqltype="cf_sql_varchar">
											   and ref		= <cfqueryparam value="#LvarKey.XmlAttributes.ref#"		cfsqltype="cf_sql_varchar">
											   and colsR	= <cfqueryparam value="#LvarKey.XmlAttributes.colsR#"	cfsqltype="cf_sql_varchar">
										</cfquery>
										<cfset LvarIDkey = rsSQL.IDkey>
									</cfif>
									<cfif LvarIDkey EQ "">
										<cfquery datasource="asp">
											insert into DBMkey (
												IDtab, cols, tip, ref, colsR,
												sec, 
												clu, idxTip, gen, del,
												IDver
											)
											values (
												 #LvarIDtab#
												,<cfqueryparam value="#LvarKey.XmlAttributes.cols#"		cfsqltype="cf_sql_varchar">
												,<cfqueryparam value="#LvarKey.XmlAttributes.tip#"		cfsqltype="cf_sql_varchar">
												,<cfqueryparam value="#LvarKey.XmlAttributes.ref#"		cfsqltype="cf_sql_varchar">
												,<cfqueryparam value="#LvarKey.XmlAttributes.colsR#"	cfsqltype="cf_sql_varchar">
			
												,<cfqueryparam value="#LvarKey.XmlAttributes.sec#"		cfsqltype="cf_sql_integer">
			
												,<cfqueryparam value="#LvarKey.XmlAttributes.clu#"		cfsqltype="cf_sql_bit">
												,<cfqueryparam value="#LvarKey.XmlAttributes.idxTip#"	cfsqltype="cf_sql_varchar">
												,<cfqueryparam value="#LvarKey.XmlAttributes.gen#"		cfsqltype="cf_sql_bit">
												,<cfqueryparam value="#LvarKey.XmlAttributes.del#"		cfsqltype="cf_sql_bit">
												,#LvarIDver#
											)
										</cfquery>
									<cfelse>
										<cfquery datasource="asp">
											update DBMkey
											   set sec		= <cfqueryparam value="#LvarKey.XmlAttributes.sec#"		cfsqltype="cf_sql_integer">
			
												 , clu		= <cfqueryparam value="#LvarKey.XmlAttributes.clu#"		cfsqltype="cf_sql_bit">
												 , idxTip	= <cfqueryparam value="#LvarKey.XmlAttributes.idxTip#"	cfsqltype="cf_sql_varchar">
												 , gen		= <cfqueryparam value="#LvarKey.XmlAttributes.gen#"		cfsqltype="cf_sql_bit">
												 , del		= <cfqueryparam value="#LvarKey.XmlAttributes.del#"		cfsqltype="cf_sql_bit">
			
												 , IDver	= #LvarIDver#
											  where IDkey 	= #LvarIDkey#
										</cfquery>
									</cfif>
								</cfloop>
							</cfif>
						</cfif>
					</cfif>
				</cfloop>
		
				<!--- Elimina secuencias obsoletas --->
				<cfquery name="rsSQL" datasource="asp">
					delete from DBMcol
					 where 	(
							select count(1)
							  from (select IDtab,tip,sec,min(IDcol) as IDcol, count(1) as cantidad from DBMcol where del=0 group by IDtab,tip,sec having count(1)>1) r
							 where r.IDtab=DBMcol.IDtab and r.tip=DBMcol.tip and r.sec=DBMcol.sec and r.IDcol = DBMcol.IDcol
							) >0
				</cfquery>
				<cfquery name="rsSQL" datasource="asp">
					delete from DBMkey
					 where 	(
							select count(1)
							  from (select IDtab,tip,sec,min(IDkey) as IDkey, count(1) as cantidad  from DBMkey where del=0 and tip<>'P' group by IDtab,tip,sec having count(1)>1) r
							 where r.IDtab=DBMkey.IDtab and r.tip=DBMkey.tip and r.sec=DBMkey.sec and r.IDkey = DBMkey.IDkey
							) >0
				</cfquery>
				<cfquery name="rsSQL" datasource="asp">
					update DBMkey
					   set del = 1
					 where 	(
							select count(1)
							  from (select IDtab,tip,sec,min(IDkey) as IDkey, count(1) as cantidad  from DBMkey where del=0 and tip='P' group by IDtab,tip,sec having count(1)>1) r
							 where r.IDtab=DBMkey.IDtab and r.tip=DBMkey.tip and r.sec=DBMkey.sec and r.IDkey = DBMkey.IDkey
							) >0
				</cfquery>

				<cfif LvarDELETE>
					<cfquery datasource="asp">
						delete from DBMversiones
						where IDver = #LvarIDver#
					</cfquery>
				</cfif>
			</cfif>
				
			<cflock name="DBM_LOAD" throwontimeout="yes" type="exclusive" timeout="50">
				<cffile action="delete" file="#Arguments.Archivo#">
				<cffile action="delete" file="#LvarUPLOAD_File#">
			</cflock>
		<cfcatch type="any">
			<cfset LvarError = fnFuenteLinea(cfcatch)>
			<cflock name="DBM_LOAD" throwontimeout="yes" type="exclusive" timeout="50">
				<cffile action="write" file="#LvarUPLOAD_File#.err" output="#cfcatch.Message# #cfcatch.Detail# #LvarError#">
			</cflock>
		</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="fnXmlString" access="private" output="false" returntype="string">
		<cfargument name="hilera"	type="string" required="yes">
		<cfargument name="longitud"	type="numeric" required="no">
		
		<cfif isdefined("Arguments.longitud")>
			<cfreturn xmlFormat(trim(mid(Arguments.hilera,1,Arguments.longitud)))>
		<cfelse>
			<cfreturn xmlFormat(trim(Arguments.hilera))>
		</cfif>
	</cffunction>
			
	<cffunction name="fnXmlDate" access="private" output="false" returntype="string">
		<cfargument name="fecha"	type="string" required="yes">
		
		<cfif trim(fecha) EQ "">
			<cfreturn "">
		</cfif>
		<cfset fecha = "#dateFormat(Arguments.fecha,"YYYY-MM-DD")#T#timeFormat(Arguments.fecha,"HH:MM:SS")#.0">
		<cfreturn fecha>
	</cffunction>
			
	<cffunction name="fnXmlDateParse" access="private" output="false" returntype="string">
		<cfargument name="fecha"	type="string" required="yes">
		
		<cfset LvarSDF = CreateObject("java", "java.text.SimpleDateFormat").init("yyyy-MM-dd'T'HH:mm:ss.SSSSSSS")>
		<cftry>
			<cfset fecha = LvarSDF.parse(fecha)>
		<cfcatch type="any"></cfcatch>
		</cftry>
		<cfreturn fecha>
	</cffunction>
			
	<cffunction name="fnXmlMoney" access="private" output="false" returntype="string">
		<cfargument name="monto"	type="numeric" required="yes">
		
		<cfreturn numberFormat(Arguments.monto,"9.99")>
	</cffunction>
			
	<cfscript>
		function fnXMLnextRow()
		{
			LvarElems = arrayNew(1);
			LvarElemLevel = 0;
			LvarElemType = 0;
			while(LvarXMLr.hasNext())
			{
				LvarElemTypeName = fnEventTypeName(LvarXMLr.getEventType());
				if (LvarElemTypeName EQ "START_ELEMENT")
				{
				fnDump(LvarXMLr.getAttributeCount());
					LvarElemLevel = LvarElemLevel + 1;
					if (LvarElemLevel GT 3)
						fnThrow ("Se encontraron mas de 3 niveles");
	
					LvarElems[LvarElemLevel] = structNew();
					LvarElems[LvarElemLevel].elementName	= ucase(LvarXMLr.getLocalName());
					LvarElems[LvarElemLevel].elementValue	= "";
					LvarElemType = 1;
				}
				else if (LvarElemTypeName EQ "END_ELEMENT")
				{
					if (LvarElems[LvarElemLevel].elementName NEQ ucase(LvarXMLr.getLocalName()))
						fnThrow ("Se esperaba fin de elemento #LvarElems[LvarElemLevel].elementName# pero se encontró #LvarXMLr.getLocalName()#");
	
					LvarElemLevel = LvarElemLevel - 1;
					LvarElemType = 0;
					if (LvarElemLevel EQ 2)
					{
						LvarElems[LvarElemLevel][LvarElems[LvarElemLevel+1].elementName] = LvarElems[LvarElemLevel+1].elementValue;
					}
					else if (LvarElemLevel EQ 1)
					{
						LvarXMLr.next();
						return LvarElems;
					}
					else
					{
						LvarElement = structNew();
						LvarElement.elementName = "";
						LvarXMLr.next();
						return LvarElement;
					}
				}
				else if (LvarElemType EQ 1 AND LvarElemTypeName EQ "CHARACTERS" AND NOT LvarXMLr.isWhiteSpace())
					LvarElems[LvarElemLevel].elementValue = LvarElems[LvarElemLevel].elementValue & LvarXMLr.getText();
	
				LvarXMLr.next();
			}
	
			LvarElement = structNew();
			LvarElement.elementName = "eof";
			return LvarElement;
		}
		
		function fnEventTypeName (eventType)
		{
			switch (eventType)
			{
				case  1: return "START_ELEMENT"; break;
				case  2: return "END_ELEMENT"; break;
				case  3: return "PROCESSING_INSTRUCTION"; break;
				case  4: return "CHARACTERS"; break;
				case  5: return "COMMENT"; break;
				case  6: return "SPACE"; break;
				case  7: return "START_DOCUMENT"; break;
				case  8: return "END_DOCUMENT"; break;
				case  9: return "ENTITY_REFERENCE"; break;
				case 10: return "ATTRIBUTE"; break;
				case 11: return "DTD"; break;
				case 12: return "CDATA"; break;
				case 13: return "NAMESPACE"; break;
				case 14: return "NOTATION_DECLARATION"; break;
				case 15: return "ENTITY_DECLARATION"; break;
				default: return "NULL";
			}
		}
	</cfscript>
	
	<cffunction name="fnDump" access="private" output="false" returntype="void">
		<cfargument name="hilera"	type="any" required="yes">
		<cfargument name="abortar"	type="boolean" required="no" default="no">
	
		<cfdump var="#hilera#">
		<cfif abortar><cfabort></cfif>
	</cffunction>
	
	<cffunction name="fnThrow" access="package" output="false" returntype="void">
		<cfargument name="hilera"	type="string" required="yes">
		<cfthrow message="#hilera#">
	</cffunction>
	
	<!---------------------------------------------------------------------------------
		RUTINAS COMUNES PARA GENERAR LA BASE DE DATOS
	----------------------------------------------------------------------------------->
	<cffunction name="toScriptDB" access="package" output="no">
		<cfargument name="conexion" required="yes">
		<cfargument name="TIPO"			required="yes">
		<cfargument name="tipoID"		required="yes"  type="numeric">
		<cfargument name="Titulo"		default="">
	
		<cfset LvarTabsP = fnUpdateTabsP(Arguments.tipo, Arguments.tipoID, "-1", false, "toScriptDB")>
		<cfif Arguments.TIPO EQ "UPLOAD">
			<cfquery datasource="asp">
				update DBMuploads
				   set stsP 	= 21 		<!--- Generando Script --->
					 , tabsP	= 1
				 where IDupl = #Arguments.TipoID#
			</cfquery>
		<cfelseif Arguments.tipo EQ "UPGRADE">
			<cfquery datasource="asp">
				update DBMgenP
				   set stsP 	= 21 		<!--- Generando Script --->
					 , tabsP	= 1
				 where IDgen = #Arguments.tipoID#
			</cfquery>
		</cfif>
	
	<!---
		1)	Genera Objetos especiales dependiendo de la base de datos
		2)	Elimina las llaves FKs
		3)	Por cada Tabla a Generar:
			A) Tabla Nueva:
				a) Create table
				b) Crea llaves PK,AK,UI,FI,ID
			B) Tabla a Borrar:
				a) Drop table
			C) Tabla Existente:
				a) sbCHKsDel:			Borra reglas a nivel de tabla
				b) sbKEYsDel:			Borra llaves PK,AK,UI,FK,ID
				c) sbCOLsDel:			Borra columnas a borrar
				d) sbCOLsChg:			Modifica columnas cambiadas
				e) sbCOLsAdd:			Agrega columnas nuevas
				f) sbCHKsAdd:			Agrega regla a nivel de tabla
				g) sbRenames:	Renombra reglas de columna, PK, AK, UI, FK, FI, ID con otra nomenclatura
				d) sbCreaLlaves:		Crea llaves PK,AK,UI,FI,ID
		4)	Crea las llaves FKs
	--->
		<cfset sbIniScript(Titulo)>
		<cfset sbAddScript("/* INI_SCRIPT */#vbCrLf##vbCrLf#")>
		<cfif Arguments.tipo EQ "BASECERO">
			<cfset sbAddScriptTit ("/* ========================= */#vbCrLf#", true)>
			<cfset sbAddScriptTit ("/* GENERA OBJETOS ESPECIALES */#vbCrLf#")>
			<cfset sbAddScriptTit ("/* ========================= */#vbCrLf#")>
			<cfset LvarSQL = LvarObjDB.CrearObjetosEspeciales(Arguments.Conexion,true)>
			<cfset sbAddScript (LvarSQL)>
		</cfif>

		<cfquery name="rsTABsPD" datasource="#Arguments.conexion#">
			select upper(t.tab), t.tab, t.des, t.suf13, t.suf25, t.rul, t.OP, 
				   case when db.tab is not null then 1 else 0 end as DB,
				   db.tabAnt
			  from #tabPD# t
			  	left join #tabDB# db on db.tab = t.tab
			 where t.gen = 1
			order by 1
		</cfquery>
	
		<cfif Application.dsinfo[Arguments.Conexion].type EQ "db2" AND isdefined("session.DB2_REORG") AND session.DB2_REORG>
			<cfset sbAddScriptTit ("/* ================================== */#vbCrLf#", true)>
			<cfset sbAddScriptTit ("/* REROGANIZA TODAS LAS TABLAS EN DB2 */#vbCrLf#")>
			<cfset sbAddScriptTit ("/* ================================== */#vbCrLf#")>
			<cfset LvarTabsP = 0>
			<cfloop query="rsTABsPD">
				<cfif rsTABsPD.currentRow - LvarTabsP GT 10>
						<cfset LvarTabsP = fnUpdateTabsP(Arguments.tipo, Arguments.tipoID, rsTABsPD.currentRow)>
				</cfif>
				<cfif rsTABsPD.OP NEQ "1" AND rsTABsPD.OP NEQ "4">
					<cfset sbAddScript (LvarObjDB.fnREORG(rsTABsPD.tab))>
				</cfif>
			</cfloop>
		</cfif>
	
		<cfset sbEliminaFKs(Arguments.conexion)>
		
		<cfset LvarTabsP = 0>
		<cfloop query="rsTABsPD">
			<cfif rsTABsPD.currentRow - LvarTabsP GT 10>
				<cfset LvarTabsP = fnUpdateTabsP(Arguments.tipo, Arguments.tipoID, rsTABsPD.currentRow)>
			</cfif>
	
			<cfset LvarObjDB.sbSetTabPrefijo(rsTABsPD.tab,rsTABsPD.suf13,rsTABsPD.suf25)>
			<cfif rsTABsPD.OP EQ "1">
				<cfset sbAddScriptTit ("/* ======================================================================================== */#vbCrLf#", true)>
				<cfset sbAddScriptTit ("/* ADD_TABLE #rsTABsPD.tab#: #rsTABsPD.des# */#vbCrLf#")>
				<cfset sbAddScriptTit ("/* ======================================================================================== */#vbCrLf#")>
				<cfset sbTAB_ADD	  (Arguments.conexion, rsTABsPD.tab, rsTABsPD.rul)>
			<cfelseif rsTABsPD.OP EQ "4">
				<cfif rsTABsPD.DB NEQ "0">
					<cfset sbAddScriptTit ("/* ======================================================================================== */#vbCrLf#", true)>
					<cfset sbAddScriptTit ("/* DEL_TABLE #rsTABsPD.tab#: #rsTABsPD.des# */#vbCrLf#")>
					<cfset sbAddScriptTit ("/* ======================================================================================== */#vbCrLf#")>
					<cfset sbTAB_DEL	  (Arguments.conexion, rsTABsPD.tab, rsTABsPD.tabAnt, rsTABsPD.rul)>
				</cfif>
			<cfelse>
				<cfset sbAddScriptTit ("/* ======================================================================================== */#vbCrLf#", true)>
				<cfset sbAddScriptTit ("/* CHG_TABLE #rsTABsPD.tab#: #rsTABsPD.des# */#vbCrLf#")>
				<cfset sbAddScriptTit ("/* ======================================================================================== */#vbCrLf#")>
				<cfset sbTAB_CHG	  (Arguments.conexion, rsTABsPD.tab, rsTABsPD.tabAnt, rsTABsPD.rul)>
			</cfif>
		</cfloop>
		<cfset sbCreaFKs(Arguments.conexion)>
		<cfset sbAddScriptTit ("/* END_SCRIPT */#vbCrLf#", true)>
		<cfset sbAddScript("")>
	</cffunction>
	
	
	<cffunction name="sbTAB_ADD" access="private" output="no">
		<cfargument name="conexion" required="yes">
		<cfargument name="tab" required="yes">
		<cfargument name="rul" required="yes">
	
		<cfset sbAddScript 	(LvarObjDB.fnGenIniTable(Arguments.conexion, Arguments.tab), true)>
		<cfset sbAddScript 	(LvarObjDB.fnGenAddTable(Arguments.conexion, Arguments.tab) )>
		<cfset sbCHKsAdd	(Arguments.conexion, 	Arguments.tab, Arguments.rul)>
		<cfset sbCreaLlaves	(Arguments.conexion, 	Arguments.tab)>
		<cfset sbAddScript 	(LvarObjDB.fnGenEndTable(Arguments.conexion, Arguments.tab), true)>
	</cffunction>
	
	<cffunction name="sbTAB_DEL" access="private" output="no">
		<cfargument name="conexion" required="yes">
		<cfargument name="tab" 		required="yes">
		<cfargument name="tabAnt" 	required="yes">
	
		<cfset sbTABsRen	(Arguments.conexion, 	Arguments.tabAnt, 	Arguments.tab)>
		<cfset sbCHKsDel	(Arguments.conexion, 	Arguments.tab)>
		<cfset LvarSQL = LvarObjDB.fnGenDelTable(Arguments.tab)>
		<cfset sbAddScript (LvarSQL)>
	</cffunction>
	
	<cffunction name="sbTAB_CHG" access="private" output="no">
		<cfargument name="conexion"	required="yes">
		<cfargument name="tab" 		required="yes">
		<cfargument name="tabAnt" 	required="yes">
		<cfargument name="rul" 		required="yes">
	
		<cfset sbAddScript 	(LvarObjDB.fnGenIniTable(Arguments.conexion, Arguments.tab, true), true)>
		<cfset sbTABsRen	(Arguments.conexion, 	Arguments.tabAnt, 	Arguments.tab)>
		<cfset sbCHKsDel	(Arguments.conexion, 	Arguments.tab)>
		<cfset sbKEYsDel	(Arguments.conexion, 	Arguments.tab)>
		<cfset sbCOLsDel	(Arguments.conexion, 	Arguments.tab)>
		<cfset LvarSecIni =	sbRenames	(Arguments.conexion, 	Arguments.tab, "OLD", 0)>
		<cfset sbCOLsChg	(Arguments.conexion, 	Arguments.tab)>
		<cfset sbCOLsAdd	(Arguments.conexion, 	Arguments.tab)>
		<cfset sbRenames				(Arguments.conexion, 	Arguments.tab, "NEW", LvarSecIni)>
		<cfset sbCHKsAdd	(Arguments.conexion, 	Arguments.tab, "*")>
		<cfset sbCreaLlaves	(Arguments.conexion, 	Arguments.tab)>
		<cfset sbAddScript 	(LvarObjDB.fnGenEndTable(Arguments.conexion, Arguments.tab), true)>
	</cffunction>
	
	<!---
		KEYS (PK,AK,UK,IK,FK) NO EXISTENTES EN POWER DESIGNER + FKs que utilizan las anteriores + FKs con campos modificados
	--->
	<cffunction name="sbEliminaFKs" access="private" output="no">
		<cfargument name="conexion" required="yes">
	
		<cfset sbAddScriptTit ("/* ================================================================= */#vbCrLf#",true)>
		<cfset sbAddScriptTit ("/*    ELIMINA FKs QUE YA NO SE UTILIZAN O CON CAMPOS MODIFICADOS     */#vbCrLf#")>
		<cfset sbAddScriptTit ("/* ================================================================= */#vbCrLf#")>
		<cfset sbKEYsDel(Arguments.conexion,"*FKs*")>
	</cffunction>
	
	<cffunction name="sbKEYsDel" access="private" output="yes">
		<cfargument name="conexion" required="yes">
		<cfargument name="tabla" required="yes">
	
		<cfset rsSQL = fnGetKeysDelChg(Arguments.conexion, Arguments.tabla)>
	
		<cfif rsSQL.recordCount EQ 0>
			<cfreturn>
		</cfif>
		<cfif Arguments.tabla EQ "*FKs*">
			<cfoutput query="rsSQL" group="tab">
				<cfset sbAddScript ("")>
				<cfset sbAddScriptTit ("/* CHG_TABLE #rsSQL.tab# */#vbCrLf#",true)>
				<cfoutput>
					<cfif rsSQL.tip EQ 'D'>
						<cfset LvarOP = "DEL_FK OP = (EXTERNO)">
					<cfelseif rsSQL.OP EQ 3>
						<cfset LvarOP = "CHG_FK OP = #fnOPdes(rsSQL.OP)#">
					<cfelse>
						<cfset LvarOP = "DEL_FK OP = #fnOPdes(rsSQL.OP)#">
					</cfif>
					<cfset sbAddScriptTit ('/* #LvarOP#: TIP="#rsSQL.tip#", COLS="#rsSQL.COLs#", REF="#rsSQL.ref#" */#vbCrLf#')>
					<cfset LvarSQL = LvarObjDB.fnGenDelKey (rsSQL.tab,rsSQL.tip,rsSQL.keyN,rsSQL.idx,rsSQL.COLs,rsSQL.ref,rsSQL.colsR, rsSQL.idx, true)>
					<cfset sbAddScript (LvarSQL)>
				</cfoutput>
			</cfoutput>
		<cfelse>
			<cfloop query="rsSQL">
				<cfset sbAddScript ("")>
				<cfif rsSQL.OP EQ 3>
					<cfset LvarOP = "CHG_KEY OP = #fnOPdes(rsSQL.OP)#">
				<cfelse>
					<cfset LvarOP = "DEL_KEY OP = #fnOPdes(rsSQL.OP)#">
				</cfif>
				<cfif rsSQL.tip EQ "F">
					<cfset sbAddScriptTit ('/* #LvarOP#: TIP="#rsSQL.tip#", COLS="#rsSQL.COLs#", REF="#rsSQL.ref#" */#vbCrLf#', true)>
				<cfelse>
					<cfset sbAddScriptTit ('/* #LvarOP#: TIP="#rsSQL.tip#", COLS="#rsSQL.COLs#" */#vbCrLf#', true)>
				</cfif>
				<cfset LvarSQL = LvarObjDB.fnGenDelKey (rsSQL.tab,rsSQL.tip,rsSQL.keyN,rsSQL.idx,rsSQL.cols,rsSQL.ref,rsSQL.colsR, rsSQL.idx, false)>
				<cfset sbAddScript (LvarSQL)>
			</cfloop>
		</cfif>
	</cffunction>
	
	<!---
		BORRA LA REGLA A NIVEL DE TABLA
	--->
	<cffunction name="sbCHKsDel" access="private" output="no">
		<cfargument name="conexion" required="yes">
		<cfargument name="tabla" required="yes">
	
		<cfset rsSQL = fnGetChksDel(LvarConexion,Arguments.tabla)>
		
		<cfloop query="rsSQL">
			<cfset sbAddScript ("")>
			<cfset sbAddScriptTit ("/* DEL_CHECK OP = #fnOPdes(rsSQL.OP)#: chk=#rul# */#vbCrLf#",true)>
			<cfset LvarSQL = LvarObjDB.fnGenDelCheck(rsSQL.tab, rsSQL.chk)>
			<cfset sbAddScript (LvarSQL)>
		</cfloop>
	</cffunction>
	
	<!---
		RENOMBRAR TABLA
	--->
	<cffunction name="sbTABsRen" access="private" output="no">
		<cfargument name="conexion" required="yes">
		<cfargument name="tabAnt" required="yes">
		<cfargument name="tabNew" required="yes">
	
		<cfif rtrim(Arguments.tabAnt) NEQ "">
			<cfset sbAddScript ("")>
			<cfset sbAddScriptTit ("/* CHG_TABLE OP = RENAME: #Arguments.tabAnt# TO #Arguments.tabNew# */#vbCrLf#",true)>
			<cfset LvarSQL = LvarObjDB.fnGenRenTab(Arguments.tabAnt, Arguments.tabNew)>
			<cfset sbAddScript (LvarSQL)>
		</cfif>
	</cffunction>

	<!---
		CAMPOS CON NOMBRES DIFERENTES
	--->
	<cffunction name="sbRenames" access="private" output="no" returntype="numeric">
		<cfargument name="conexion" 	required="yes">
		<cfargument name="tabla"		required="yes">
		<cfargument name="tipo"		required="yes">
		<cfargument name="SecIniOLD"	required="yes">
	
		<cfset rsSQL = fnGetRenames(Arguments.Conexion, Arguments.tabla)>
		<cfset LvarOldNames = valueList(rsSQL.oldName)>
		<cfset LvarNewNames = valueList(rsSQL.newName)>
		<cfif Arguments.Tipo EQ "OLD">
			<cfset LvarSecIni = right("#getTickCount()#",5)>
			<cfloop query="rsSQL">
				<cfif listFind(LvarOldNames,rsSQL.newName) or listFind(LvarNewNames,rsSQL.oldName)>
					<cfset sbAddScript ("")>
					<cfset sbAddScriptTit ("/* CHG_#rsSQL.tipo# (OP = RENAME_OLD): cols=#rsSQL.cols# */#vbCrLf#",true)>
		
						<cfset LvarSQL = LvarObjDB.fnGenRename("OLD", rsSQL.tab, rsSQL.tipo, rsSQL.oldName, "REN#LvarSecIni+rsSQL.currentRow#"
														 , rsSQL.tip, rsSQL.sec, rsSQL.cols, rsSQL.ref, rsSQL.colsR)>
					<cfset sbAddScript (LvarSQL)>
				</cfif>
			</cfloop>
			<cfloop query="rsSQL">
				<cfif NOT (listFind(LvarOldNames,rsSQL.newName) or listFind(LvarNewNames,rsSQL.oldName))>
					<cfset sbAddScript ("")>
					<cfset sbAddScriptTit ("/* CHG_#rsSQL.tipo# (OP = RENAME): cols=#rsSQL.cols# */#vbCrLf#",true)>
					<cfset LvarSQL = LvarObjDB.fnGenRename("REN", rsSQL.tab, rsSQL.tipo, rsSQL.oldName, rsSQL.newName
														 , rsSQL.tip, rsSQL.sec, rsSQL.cols, rsSQL.ref, rsSQL.colsR)>
					<cfset sbAddScript (LvarSQL)>
				</cfif>
			</cfloop>
		<cfelse>
			<cfset LvarSecIni = Arguments.SecIniOLD>
			<cfloop query="rsSQL">
				<cfif listFind(LvarOldNames,rsSQL.newName) or listFind(LvarNewNames,rsSQL.oldName)>
					<cfset sbAddScript ("")>
					<cfset sbAddScriptTit ("/* CHG_#rsSQL.tipo# (OP = RENAME_NEW): cols=#rsSQL.cols# */#vbCrLf#",true)>
					<cfset LvarSQL = LvarObjDB.fnGenRename("NEW", rsSQL.tab, rsSQL.tipo, "REN#LvarSecIni+rsSQL.currentRow#", rsSQL.newName
														 , rsSQL.tip, rsSQL.sec, rsSQL.cols, rsSQL.ref, rsSQL.colsR)>
					<cfset sbAddScript (LvarSQL)>
				</cfif>
			</cfloop>
		</cfif>
		
		<cfreturn LvarSecIni>
	</cffunction>
	
	<cffunction name="sbCHKsAdd" access="private" output="no">
		<cfargument name="conexion" required="yes">
		<cfargument name="tabla" 	required="yes">
		<cfargument name="rul" 		required="yes">
	
		<cfif Arguments.rul EQ "*">
			<cfset rsSQL = fnGetChksAdd(LvarConexion, Arguments.tabla)>
			
			<cfloop query="rsSQL">
				<cfset sbAddScript ("")>
				<cfset sbAddScriptTit ("/* ADD_CHECK: chk=#rsSQL.rul# */#vbCrLf#",true)>
				<cfset LvarSQL = LvarObjDB.fnGenAddCheck(rsSQL.tab, rsSQL.rul)>
				<cfset sbAddScript (LvarSQL)>
			</cfloop>
		<cfelseif Arguments.rul NEQ "">
			<cfset LvarSQL = LvarObjDB.fnGenAddCheck(Arguments.tabla, Arguments.rul)>
			<cfset sbAddScript (LvarSQL)>
		</cfif>
	</cffunction>
	
	<cffunction name="sbCOLsDel" access="private" output="no">
		<cfargument name="conexion" required="yes">
		<cfargument name="tabla" required="yes">
	
		<!--- Las COLsDel OP = 4 se van a borrar --->
		<cfset rsSQL = fnGetCOLsDel(LvarConexion,Arguments.tabla)>
		
		<cfloop query="rsSQL">
			<cfset sbAddScript ("")>
			<cfset sbAddScriptTit ("/* DEL_COLUMN OP = #fnOPdes(rsSQL.OP)#: #col# - #des# */#vbCrLf#",true)>
			<cfset LvarSQL = LvarObjDB.fnGenDelColumn(rsSQL.tab, rsSQL.col, rsSQL.chk, rsSQL.dflN)>
			<cfset sbAddScript (LvarSQL)>
		</cfloop>
	</cffunction>
	
	<cffunction name="sbCOLsAdd" access="private" output="no">
		<cfargument name="conexion" required="yes">
		<cfargument name="tabla" required="yes">
	
		<cfset rsSQL = fnGetColsAdd(LvarConexion,Arguments.tabla)>
		<cfloop query="rsSQL">
			<cfset sbAddScript ("")>
			<cfset sbAddScriptTit ("/* ADD_COLUMN OP = #fnOPdes(rsSQL.OP)#: #col# - #des# */#vbCrLf#",true)>
			<cfset LvarSQL = LvarObjDB.fnGenAddColumn(rsSQL.tab, rsSQL.col, rsSQL.tip, rsSQL.lon, rsSQL.dec, rsSQL.ide, rsSQL.obl, rsSQL.dfl, rsSQL.rul, rsSQL.lov, rsSQL.sec)>
			<cfset sbAddScript (LvarSQL)>
		</cfloop>
	</cffunction>
	
	<!---
		CAMPOS MODIFICADOS EN BASE DE DATOS
	--->
	<cffunction name="sbCOLsChg" access="private" output="no">
		<cfargument name="conexion" required="yes">
		<cfargument name="tabla" required="yes">
	
		<cfset rsSQL = fnGetColsChg(LvarConexion,Arguments.tabla)>
	
		<cfloop query="rsSQL">
			<cfset sbAddScript ("")>
			<cfset sbAddScriptTit ("/* CHG_COLUMN OP = #fnOPdes(rsSQL.OP)#: #rsSQL.col# - #rsSQL.des# */#vbCrLf#",true)>
			<cfset LvarSQL = LvarObjDB.fnGenChgColumn(	
											Arguments.conexion, 
											rsSQL.tab, rsSQL.col,   rsSQL.colAnt,
											rsSQL.tipD, rsSQL.lonD, rsSQL.decD, rsSQL.ideD, rsSQL.oblD, rsSQL.dflD, rsSQL.dflND, rsSQL.rulD, rsSQL.chkD,
											rsSQL.tipP, rsSQL.lonP, rsSQL.decP, rsSQL.ideP, rsSQL.oblP, rsSQL.dflP, rsSQL.rulP, rsSQL.lovP, rsSQL.secP
											, rsSQL.ideT
										)
			>
			<cfset sbAddScript (LvarSQL)>
		</cfloop>
	</cffunction>
	
	<cffunction name="sbCreaLlaves" access="private" output="no">
		<cfargument name="conexion" required="yes">
		<cfargument name="tabla" required="yes">
	
		<cfset rsSQL = fnGetKeysAddChg(Arguments.conexion,Arguments.tabla)>
	
		<cfif rsSQL.recordCount EQ 0>
			<cfreturn>
		</cfif>
		<cfset LvarIdxCols = "">
		<cfif Arguments.tabla EQ "*FKs*">
			<cfoutput query="rsSQL" group="tab">
				<cfset LvarObjDB.sbSetTabPrefijo(rsSQL.tab,rsSQL.suf13,rsSQL.suf25)>
				<cfset sbAddScript ("")>
				<cfset sbAddScriptTit ("/* CHG_TABLE #rsSQL.tab# */#vbCrLf#",true)>
				<cfoutput>
					<cfif rsSQL.OP EQ 3>
						<cfset LvarOP = "CHG_FK OP = #fnOPdes(rsSQL.OP)#">
					<cfelse>
						<cfset LvarOP = "ADD_FK OP = #fnOPdes(rsSQL.OP)#">
					</cfif>
					<cfset sbAddScriptTit ('/* #LvarOP#: TIP="#rsSQL.tip#", SEC="#rsSQL.sec#", COLS="#rsSQL.COLs#", REF="#rsSQL.ref#" */#vbCrLf#')>
					<cfset LvarSQL = LvarObjDB.fnGenAddKey(rsSQL.tab, rsSQL.tip, fnDESC(rsSQL.cols), rsSQL.ref, rsSQL.colsR, rsSQL.sec, rsSQL.clu, rsSQL.idxTip, true)>
					<cfset sbAddScript (LvarSQL)>
				</cfoutput>
			</cfoutput>
		<cfelse>
			<cfloop query="rsSQL">
				<cfset LvarIdxReps = find("*#rsSQL.COLs#*",LvarIdxCols)>
				<cfset LvarIdxCols &= "*#rsSQL.COLs#*">
				<cfif NOT LvarIdxReps>
					<cfset sbAddScript ("")>
	
					<cfif rsSQL.OP EQ 3>
						<cfset LvarOP = "CHG_KEY OP = #fnOPdes(rsSQL.OP)#">
					<cfelse>
						<cfset LvarOP = "ADD_KEY OP = #fnOPdes(rsSQL.OP)#">
					</cfif>
					<cfif rsSQL.tip EQ "F">
						<cfset sbAddScriptTit ('/* #LvarOP#: TIP="#rsSQL.tip#", SEC="#rsSQL.sec#", COLS="#rsSQL.COLs#", REF="#rsSQL.ref#" */#vbCrLf#', true)>
					<cfelse>
						<cfset sbAddScriptTit ('/* #LvarOP#: TIP="#rsSQL.tip#", SEC="#rsSQL.sec#", COLS="#rsSQL.COLs#" */#vbCrLf#', true)>
					</cfif>
					<cfset LvarSQL = LvarObjDB.fnGenAddKey(rsSQL.tab, rsSQL.tip, fnDESC(rsSQL.cols), rsSQL.ref, rsSQL.colsR, rsSQL.sec, rsSQL.clu, rsSQL.idxTip, false)>
					<cfset sbAddScript (LvarSQL)>
				</cfif>
			</cfloop>
		</cfif>
	</cffunction>
	
	<cffunction name="fnOPdes" output="no" returntype="string">
		<cfargument name="OP"	required="yes">
		<cfif Arguments.OP EQ "0">
			<cfreturn "(OK)">
		<cfelseif Arguments.OP EQ "1">
			<cfreturn "(TAB NUEVA)">
		<cfelseif Arguments.OP EQ "2">
			<cfreturn "(NUEVO)">
		<cfelseif Arguments.OP EQ "3">
			<cfreturn "(CAMBIO)">
		<cfelseif Arguments.OP EQ "4">
			<cfreturn "(OBSOLETO)">
		<cfelseif Arguments.OP EQ "5">
			<cfreturn "(NO DEFINIDO)">
		<cfelseif Arguments.OP EQ "6">
			<cfreturn "(DUPLICADO)">
		<cfelseif Arguments.OP EQ "7">
			<cfreturn "(NO GENERAR)">
		<cfelseif Arguments.OP EQ "7">
			<cfreturn "(REF NEW IDENTITY)">
		<cfelseif Arguments.OP EQ "10">
			<cfreturn "(PERDIDO)">
		</cfif>
		
		<cfreturn "(OP = #Arguments.OP#)">
	</cffunction>
	
	<cffunction name="fnDESC" output="no" access="package" returntype="string">
		<cfargument name="cols"	required="yes">
		<cfreturn REPLACE(Arguments.cols,"-"," DESC","ALL")>
	</cffunction>
	
	<cffunction name="fnGetName" access="package" output="no" returntype="string">
		<cfargument name="prefijo"	required="yes">
		<cfargument name="sufijo"	required="yes">
		<cfargument name="sec"		required="yes" type="numeric">
	
		<cfreturn Arguments.prefijo & "_" & Arguments.sufijo & numberFormat(Arguments.sec,"00")>
	</cffunction>
	
	<!---
		FKs NO EXISTENTES EN BASE DE DATOS + FKs con campos modificados
	--->
	<cffunction name="sbCreaFKs" access="private" output="no">
		<cfargument name="conexion" required="yes">
	
		<cfset sbAddScriptTit ("/* ================================================================= */#vbCrLf#", true)>
		<cfset sbAddScriptTit ("/*            CREA FKs NUEVOS O CON CAMPOS MODIFICADOS               */#vbCrLf#")>
		<cfset sbAddScriptTit ("/* ================================================================= */#vbCrLf#")>
		<cfset sbCreaLlaves(Arguments.conexion,"*FKs*")>
	</cffunction>
	
	<cffunction name="fnTipoPDtoCF" access="package" output="no" returntype="string">
		<cfargument name="tip">
	
		<cfif listFind("C,V,CL",Arguments.tip)>
			<cfset LvarTipo = "S">
		<cfelseif listFind("B,VB,BL",Arguments.tip)>
			<cfset LvarTipo = "B">
		<cfelseif listFind("I,N,F,M,L",Arguments.tip)>
			<cfset LvarTipo = "N">
		<cfelseif mid(Arguments.tip,1,1) EQ "D">
			<cfset LvarTipo = "D">
		<cfelseif Arguments.tip EQ "TS">
			<cfset LvarTipo = "TS">
		<cfelse>
			<cfset LvarTipo = "">
		</cfif>
		<cfreturn LvarTipo>
	</cffunction>
	
	<cffunction name="fnLOVtoVALS" access="package" output="false" returntype="string">
		<cfargument name="lov"	type="string" required="yes">
		
		<cfset LvarLOV = trim(Arguments.lov)>
		<cfif LvarLOV EQ "">
			<cfreturn "">
		</cfif>
		<cfset LvarLOV = replace(LvarLOV,"\n",chr(13),"ALL")>
		<cfset LvarLOV = replace(LvarLOV,"\t",chr(9),"ALL")>
		<cfset LvarListas = listToArray (LvarLOV, chr(13))>
		<cfset LvarValores = arrayNew(1)>
		<cfloop list="#LvarLOV#" delimiters="#chr(13)#" index="LvarPar">
			<cfif trim(LvarPar) NEQ "">
				<cfset arrayAppend(LvarValores,listGetAT(LvarPar,1,chr(9)))>
			</cfif>
		</cfloop>
		<cfreturn arrayToList(LvarValores)>
	</cffunction>
	
	<cffunction name="sbLOV" access="private" output="false" returntype="void">
		<cfargument name="IDcol"	type="numeric"	required="yes">
		<cfargument name="lov"		type="string"	required="yes">
		
		<cfset var LvarLOV = trim(Arguments.lov)>
		<cfif LvarLOV EQ "">
			<cfreturn>
		</cfif>
		
		<cfset LvarLOV = replace(LvarLOV,"\n",chr(13),"ALL")>
		<cfset LvarLOV = replace(LvarLOV,"\t",chr(9),"ALL")>
		<cfloop list="#LvarLOV#" delimiters="#chr(13)#" index="LvarPar">
			<cfif trim(LvarPar) NEQ "">
				<cfquery datasource="asp">
					insert into DBMcolLov
						(IDcol, cod, des)
					values (
						#Arguments.IDcol#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#listGetAT(LvarPar,1,chr(9))#">,
						<cfif listLen(LvarPar,chr(9)) LT 2>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="<DESC>">
						<cfelse>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#fnSinSaltoLinea(listGetAT(LvarPar,2,chr(9)))#">
						</cfif>
					)
				</cfquery>
			</cfif>
		</cfloop>
		<cfreturn>
	</cffunction>
	
	<cffunction name="sbIniScript" output="no" returntype="void">
		<cfargument name="Titulo"		default="">
	
		<cfif Arguments.Titulo EQ "">
			<cffile action="write" file="#GvarScript#" 		output="" addnewline="no">
		<cfelse>
			<cffile action="write" file="#GvarScript#" 		output="/*#vbCrLf##Arguments.Titulo##vbCrLf#*/#vbCrLf##vbCrLf#" addnewline="no">
		</cfif>
	</cffunction>
	
	<cffunction name="sbAddScriptTit" output="no" returntype="void">
		<cfargument name="TXT" required="yes">
		<cfargument name="INI" default="no">
	
		<cfif Arguments.INI>
			<cfset GvarScriptTit = Arguments.TXT>
		<cfelse>
			<cfset GvarScriptTit = GvarScriptTit & Arguments.TXT>
		</cfif>
	</cffunction>
	
	<cffunction name="sbAddScript" output="no" returntype="void">
		<cfargument name="SQL" 		required="yes">
		<cfargument name="NotNULL"	default="no">
	
		<cfif Arguments.NotNULL AND Arguments.SQL EQ "">
			<cfreturn>
		</cfif>
		
		<cfif GvarScriptTit NEQ "">
			<cffile action="append" file="#GvarScript#" output="#GvarScriptTit#" addnewline="no">
			<cfset GvarScriptTit = "">
		</cfif>
		<cffile action="append" file="#GvarScript#" output="#Arguments.SQL#" addnewline="no">
	</cffunction>
	
	<cffunction name="sbAddScriptExe" output="no" returntype="void">
		<cfargument name="txt" required="yes">
	
		<cffile action="append" file="#GvarScriptExe#" output="#Arguments.txt#" addnewline="yes">
	</cffunction>
	
	<cffunction name="sbAddScriptErr" output="no" returntype="void">
		<cfargument name="txt" required="yes">
	
		<cffile action="append" file="#GvarScriptErr#" output="#Arguments.txt#" addnewline="yes">
	</cffunction>
	
	/* ADD_TABLE
	/* CHG_TABLE
	/* DEL_TABLE
	/* END_SCRIPT */
	
	/* DEL_FK:
	/* ADD_COLUMN
	/* CHG_COLUMN
	/* DEL_COLUMN
	/* ADD_FK:
	<cffunction name="toDatabase" access="private" output="no">
		<cfargument name="conexion" required="yes">
		<cfargument name="TIPO"		required="yes">
		<cfargument name="tipoID"	required="yes"  type="numeric">
	
		<cfset LvarTabsP = fnUpdateTabsP(Arguments.tipo, Arguments.tipoID, "-1", false, "toDatabase")>
		<cfset LvarBRini = false>
		<cftry>
			<cfif Arguments.TIPO EQ "UPLOAD">
				<cfquery datasource="asp">
					update DBMuploads
					   set 	stsP 	= 22 		<!--- Ejecutando Script --->
						 ,  msg		= null
					 where IDupl = #Arguments.TipoID#
				</cfquery>
			<cfelseif Arguments.tipo EQ "UPGRADE">
				<cfquery datasource="asp">
					update DBMgenP
					   set 	stsP 	= 22 		<!--- Ejecutando Script --->
						 ,  msg		= null
					 where IDgen = #Arguments.tipoID#
				</cfquery>
			</cfif>
		
			<cfset LvarLin = "">
			<cfset LvarTabla 	= "*">
			<cfset LvarErrE 	= false>
			<cfset LvarSQLC 	= true>
			<cfset LvarSQLE		= "">
			<cfset LvarSQL1		= "">
			<cfset LvarDSN		= Arguments.Conexion>
			<cfset LvarHuboError = False>
		
			<cfset GvarScriptExe = replace(GvarScript,".sql","_exe.txt")>
			<cffile action="write" file="#GvarScriptExe#" 	output="/****************************************************#vbCrLf# RESULTADO DE LA EJECUCION DE SCRIPT DE BASE DE DATOS#vbCrLf# ****************************************************/#vbCrLf##vbCrLf#" addnewline="no">
	
			<cfset GvarScriptErr = replace(GvarScript,".sql","_err.txt")>
			<cffile action="write" file="#GvarScriptErr#" 	output="/**************************************************#vbCrLf# ERRORES EN LA EJECUCION DE SCRIPT DE BASE DE DATOS#vbCrLf# **************************************************/#vbCrLf##vbCrLf#" addnewline="no">
	
			<cfset LvarFIL = createObject("java","java.io.File").init(GvarScript)>
			<cfset LvarFR = createObject("java","java.io.FileReader").init(LvarFIL)>
			<cfset LvarBR = createObject("java","java.io.BufferedReader").init(LvarFR)>
			<cfset LvarBRini = true>
	
			<cfset LvarFLen = LvarFIL.length()>
			<cfset LvarLLen = 0>
			<cfset LvarLcnt = 0>
			<cfset LvarTabsP = 0>
	
			<cfset LvarLin = LvarBR.readLine()>
			<cfloop condition="isdefined('LvarLin')">
				<cfset LvarLcnt ++>
				<cfset LvarLLen += len(LvarLin)+2>
				<cfset LvarLin = replace(LvarLin,"GENERAR UNICAMENTE","GENERADO")>
				<cfset sbAddScriptExe(LvarLin)>
				<cfset sbAddScriptErr(LvarLin)>
				<cfif LvarLin EQ "/* INI_SCRIPT */">
					<cfbreak>
				</cfif>
	
				<cfset LvarLin = LvarBR.readLine()>
			</cfloop>
			
			<cfset LvarLin = LvarBR.readLine()>
			<cfloop condition="isdefined('LvarLin')">
				<cfset LvarLcnt ++>
				<cfset LvarLLen += len(LvarLin)+2>
				<cfset sbAddScriptExe(LvarLin)>
				<cfif LvarLcnt - LvarTabsP GT 10>
					<cfset LvarTabsP = LvarLcnt>
					<cfset fnUpdateTabsP(Arguments.Tipo, Arguments.TipoID, LvarLLen/LvarFLen, true)>
				</cfif>
				
				<cfscript>
					if (mid(LvarLin, 1, 2) EQ "/*")
					{
						if (find("/* ADD_TABLE", LvarLin) +
							find("/* CHG_TABLE", LvarLin) + 
							find("/* DEL_TABLE", LvarLin) +
							find("/* END_SCRIPT", LvarLin)
							)
						{
							if (LvarTabla NEQ "*") 
							{
								fnEjecutarSQL(LvarErrE, LvarSQL1);
							}
	
							LvarSQLC = true;
							LvarTabla = LvarLin;
							LvarErrE = false;
							LvarSQLE = "";
							LvarSQL1 = "";
						}
						else if (	find("/* ADD_", LvarLin) +
									find("/* CHG_", LvarLin) + 
									find("/* DEL_", LvarLin) 
								)
						{
							fnEjecutarSQL(LvarErrE, LvarSQL1);
		
							LvarSQLC = true;
							LvarErrE = false;
							LvarSQLE = LvarLin;
							LvarSQL1 = "";
						}
						else if (mid(LvarLin,1,13) EQ "/* IF X GT 0:")
						{
							LvarSQL1 = mid(LvarLin,findNoCase("SELECT ",LvarLin),len(LvarLin));
							LvarSQL1 = mid(LvarSQL1,1,find("*/",LvarSQL1)-1);
							LvarSQLC = (fnQuerySQL_X(LvarErrE, LvarSQL1) GT 0);
							if (NOT LvarSQLC)
							{
								sbAddScriptExe("LA SIGUIENTE INSTRUCCION NO SE VA A EJECUTAR PORQUE NO SE CUMPLIO LA CONDICION 'X GT 0':");
							}
	
							LvarSQL1 = "";
						}
						else if (mid(LvarLin,1,13) EQ "/* IF X EQ 0:")
						{
							LvarSQL1 = mid(LvarLin,findNoCase("SELECT ",LvarLin),len(LvarLin));
							LvarSQL1 = mid(LvarSQL1,1,find("*/",LvarSQL1)-1);
							LvarSQLC = (fnQuerySQL_X(LvarErrE, LvarSQL1) EQ 0);
							if (NOT LvarSQLC)
							{
								sbAddScriptExe("LA SIGUIENTE INSTRUCCION NO SE VA A EJECUTAR PORQUE NO SE CUMPLIO LA CONDICION 'X EQ 0':");
							}
	
							LvarSQL1 = "";
						}
						else if (mid(LvarLin,1,13) EQ "/* IF X GT 1:")
						{
							LvarSQL1 = mid(LvarLin,findNoCase("SELECT ",LvarLin),len(LvarLin));
							LvarSQL1 = mid(LvarSQL1,1,find("*/",LvarSQL1)-1);
							LvarSQLC = (fnQuerySQL_X(LvarErrE, LvarSQL1) GT 1);
							if (NOT LvarSQLC)
							{
								sbAddScriptExe("LA SIGUIENTE INSTRUCCION NO SE VA A EJECUTAR PORQUE NO SE CUMPLIO LA CONDICION 'X GT 1':");
							}
	
							LvarSQL1 = "";
						}
						else if (mid(LvarLin,1,13) EQ "/* IF X EQ 1:")
						{
							LvarSQL1 = mid(LvarLin,findNoCase("SELECT ",LvarLin),len(LvarLin));
							LvarSQL1 = mid(LvarSQL1,1,find("*/",LvarSQL1)-1);
							LvarSQLC = (fnQuerySQL_X(LvarErrE, LvarSQL1) EQ 1);
							if (NOT LvarSQLC)
							{
								sbAddScriptExe("LA SIGUIENTE INSTRUCCION NO SE VA A EJECUTAR PORQUE NO SE CUMPLIO LA CONDICION 'X EQ 1':");
							}
	
							LvarSQL1 = "";
						}
					}
					else if (LvarLin EQ "go" OR LvarLin EQ "/" OR LvarLin EQ ";")
					{
						LvarErrE = NOT fnEjecutarSQL(LvarErrE, LvarSQL1);
						LvarSQLC = true;
						LvarSQLE &= vbCrLf & "OK";
						LvarSQL1 = "";
					}
					else if (LvarSQLC)
					{
						LvarSQLE &= vbCrLf & LvarLin;
						LvarSQL1 &= vbCrLf & LvarLin;
					}
					
					if (LvarErrE)
					{
						LvarHuboError = true;
					}
					LvarLin = LvarBR.readLine();
				</cfscript>
			</cfloop>
	
			<cfset fnUpdateTabsP(Arguments.Tipo, Arguments.TipoID, 1, true)>
	
			<cfset LvarBR.close()>
	
			<cfif LvarHuboError>
				<cfset LvarMSG = "SE ENCONTRARON ERRORES DE BASE DE DATOS EN LA EJECUCION DEL SCRIPT">
			<cfelse>
				<cfset LvarMSG = "OK">
			</cfif>
			<cfif Arguments.TIPO EQ "UPLOAD">
				<cfquery datasource="asp">
					update DBMuploads
					   set msg		= <cfqueryparam cfsqltype="cf_sql_clob" value="#left(LvarMSG,500)#">
						<cfif NOT LvarHuboError>
						 , sts		= 3			<!--- Base de Datos Actualizada --->
						 , stsP		= 0
						<cfelse>
						 , stsP		= 23		<!--- Errores de Base de Datos --->
						</cfif>
						 , tabsP	= tabs
					 where IDupl = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TipoID#">
				</cfquery>
			<cfelseif Arguments.tipo EQ "UPGRADE">
				<cfif NOT LvarHuboError>
					<cfset sbUPGRADE_ACTUALIZADO(Arguments.Conexion, Arguments.TipoID)>
				<cfelse>
					<cfquery datasource="asp">
						update DBMgenP
						   set msg 		= <cfqueryparam cfsqltype="cf_sql_clob" value="#left(LvarMSG,500)#">
							 , stsP		= 23		<!--- Errores de Base de Datos --->
							 , tabsP	= tabs
						 where IDgen = #Arguments.TipoID#
					</cfquery>
				</cfif>
			</cfif>
	
			<cfif LvarHuboError>
				<cfset sbAddScriptErr ("/* END_SCRIPT */#vbCrLf#")>
			<cfelse>
				<cffile action="delete" file="#GvarScriptErr#">
			</cfif>
	
			<cfif Arguments.tipo NEQ "XML">
				<cffile action="delete" file="#GvarScript#">
			</cfif>
		<cfcatch type="any">
			<cfif LvarBRini>
				<cfset LvarBR.close()>
			</cfif>
	
			<cfset LvarError = fnFuenteLinea(cfcatch)>

			<cfset sbAddScriptExe("SE ENCONTRO UN ERROR EN EL GENERADOR DE SCRIPTS:")>
			<cfset sbAddScriptExe("#cfcatch.Message#: #cfcatch.Detail# #LvarError#")>
			<cfset sbAddScriptErr("SE ENCONTRO UN ERROR EN EL GENERADOR DE SCRIPTS:")>
			<cfset sbAddScriptErr("#cfcatch.Message#: #cfcatch.Detail# #LvarError#")>
			
			<cfrethrow>
		</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="sbUPGRADE_ACTUALIZADO" returntype="void">
		<cfargument name="conexion"	type="string"	required="yes">
		<cfargument name="IDgen"	type="numeric"	required="yes">

		<cftransaction>
			<cfquery datasource="asp">
				delete from DBMgenP
				 where IDgen = #Arguments.IDgen#
			</cfquery>
			<cfquery datasource="asp">
				update DBMgen
				   set sts  = 3		<!--- BASE DE DATOS ACTUALIZADA --->
					 , fgeneracion = <cf_dbfunction name="now" datasource="asp">
				 where IDgen = #Arguments.IDgen#
			</cfquery>
			<cfquery name="rsSQL" datasource="asp">
				select g.IDverFin, g.IDmod, v.IDver
						,	(
								select max(IDver)
								  from DBMversiones
								 where IDmod = g.IDmod
							) as maxIDver
						,	(
								select min(IDver)
								  from DBMversiones
								 where IDmod = g.IDmod
							) as minIDver
				  from DBMgen g
					left join DBMversiones v
						on v.IDver = g.IDverFin
				 where IDgen = #Arguments.IDgen#
			</cfquery>
			<cfset LvarIDmod = rsSQL.IDmod>
			<cfset LvarMaxIDver = rsSQL.maxIDver>
			<cfset LvarMinIDver = rsSQL.minIDver>
			<cfif rsSQL.IDver EQ "">
				<cfquery datasource="asp">
					update DBMgen
					   set IDverFin =
							case when IDverFin > #LvarMaxIDver#
								then #LvarMaxIDver#
								else #LvarMinIDver#
					 where IDgen = #Arguments.IDgen#
				</cfquery>
			</cfif>
			<cftry>
				<cfquery datasource="asp">
					insert into <cf_dbdatabase table="DBMgens" datasource="#arguments.conexion#">	
						(IDgen, IDmod, IDverFin, fgeneracion)
					select IDgen, IDmod, IDverFin, fgeneracion
					  from DBMgen
					 where IDgen = #Arguments.IDgen#
				</cfquery>
			<cfcatch type="any"></cfcatch></cftry>
			<cfquery datasource="asp">
				delete from <cf_dbdatabase table="DBMgens" datasource="#arguments.conexion#">	
				 where IDmod = #LvarIDmod#
				   and IDverFin > #LvarMaxIDver#
			</cfquery>
			<cfquery datasource="asp">
				update <cf_dbdatabase table="DBMgens" datasource="#arguments.conexion#">
				   set IDverFin = -IDverFin
				 where IDmod = #LvarIDmod#
				   and IDverFin < 0
			</cfquery>
			<cfquery datasource="asp">
				update DBMdsn
				   set IDverUlt = (
									select IDverFin
									  from DBMgen
									 where IDgen = #Arguments.IDgen#
								)
				 where IDdsn = (
									select IDdsn
									  from DBMgen
									 where IDgen = #Arguments.IDgen#
								)
			</cfquery>
		</cftransaction>
	</cffunction>

	<cffunction name="fnQuerySQL" returntype="query" access="package">
		<cfargument name="sql"			type="string">
	
		<cfquery name="rsQuerySQL" datasource="#LvarDSN#">
			#preserveSingleQuotes(Arguments.SQL)#
		</cfquery>
		<cfreturn rsQuerySQL>
	</cffunction>
	
	<cffunction name="fnQuerySQL_X" returntype="numeric">
		<cfargument name="ExisteError"	type="boolean">
		<cfargument name="sql"			type="string">
	
		<cfif trim(Arguments.sql) EQ "">
			<cfreturn 0>
		<cfelseif Arguments.ExisteError>
			<cfset sbAddScriptExe("NO SE EJECUTÓ LA INSTRUCCIÓN PORQUE HAY UN ERROR PREVIO")>
			<cfset sbAddScriptExe("")>
	
			<cfset sbAddScriptErr(Arguments.sql)>
			<cfset sbAddScriptErr("NO SE EJECUTÓ LA INSTRUCCIÓN PORQUE HAY UN ERROR PREVIO")>
			<cfset sbAddScriptErr("")>
			<cfreturn false>
		</cfif>
		<cftry>
			<cfquery name="rsQuerySQL_X" datasource="#LvarDSN#">
				#preserveSingleQuotes(Arguments.SQL)#
			</cfquery>
			<cfreturn rsQuerySQL_X.X>
		<cfcatch type="database">
			<cfset sbAddScriptExe("ERROR DE BASE DE DATOS: #cfcatch.Message# #cfcatch.Detail#")>
			<cfset sbAddScriptExe("")>
	
			<cfset sbAddScriptErr(LvarTabla)>
			<cfset LvarTabla = "">
			<cfset sbAddScriptErr(LvarSQLE)>
			<cfset sbAddScriptErr("ERROR DE BASE DE DATOS: #cfcatch.Message# #cfcatch.Detail#")>
			<cfset sbAddScriptErr("")>
			<cfreturn false>
		</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="fnEjecutarSQL">
		<cfargument name="ExisteError"	type="boolean">
		<cfargument name="sql"			type="string">
		
		<cfif trim(Arguments.sql) EQ "">
			<cfreturn NOT ExisteError>
		<cfelseif Arguments.ExisteError>
			<cfset sbAddScriptExe("NO SE EJECUTÓ LA INSTRUCCIÓN PORQUE HAY UN ERROR PREVIO")>
			<cfset sbAddScriptExe("")>
	
			<cfset sbAddScriptErr(Arguments.sql)>
			<cfset sbAddScriptErr("NO SE EJECUTÓ LA INSTRUCCIÓN PORQUE HAY UN ERROR PREVIO")>
			<cfset sbAddScriptErr("")>
			<cfreturn false>
		</cfif>
		<cftry>
			<cfset LvarEXE = trim(replace(Arguments.SQL,chr(13)," ","ALL"))>
			<cfif Application.dsinfo[LvarDSN].type EQ "db2" AND left(LvarEXE,22) EQ "CALL SYSPROC.ADMIN_CMD">
				<cfquery datasource="sifjdbc">
					#preserveSingleQuotes(LvarEXE)#
				</cfquery>
			<cfelse>
				<cfquery datasource="#LvarDSN#">
					#preserveSingleQuotes(LvarEXE)#
				</cfquery>
			</cfif>
			<cfset sbAddScriptExe("EJECUCION EN BASE DE DATOS OK")>
			<cfset sbAddScriptExe("")>
			<cfreturn true>
		<cfcatch type="database">
			<cfset sbAddScriptExe("ERROR DE BASE DE DATOS: #cfcatch.Message# #cfcatch.Detail#")>
			<cfset sbAddScriptExe("")>
	
			<cfset sbAddScriptErr(LvarTabla)>
			<cfset LvarTabla = "">
			<cfset sbAddScriptErr(LvarSQLE)>
			<cfset sbAddScriptErr("ERROR DE BASE DE DATOS: #cfcatch.Message# #cfcatch.Detail#")>
			<cfset sbAddScriptErr("")>
			<cfreturn false>
		</cfcatch>
		</cftry>
	</cffunction>
	<!---------------------------------------------------------------------------------
		RUTINAS PARA GENERAR EL XML
	----------------------------------------------------------------------------------->
	<cffunction name="toXML" output="no" access="public">
		<cfargument name="rsOBJECTS"	required="yes" type="query">
		<cfargument name="archivo"		required="yes" type="string">
	
		<cfargument name="fec"			required="yes" type="date">
		<cfargument name="version"		required="yes" type="string">
		<cfargument name="parche"		required="yes" type="string">
		<cfargument name="IDmod"		required="yes" type="numeric">
		<cfargument name="modelo"		required="yes" type="string">
		<cfargument name="IDsch"		required="yes" type="numeric">
		<cfargument name="sch"			required="yes" type="string">
	
		<cfset LvarXML = '<?xml version="1.0" encoding="utf-8"?>'>
		<cfset LvarXML &= '<version des="#xmlFormat(Arguments.version)#" fec="#dateFormat(Arguments.fec,"YYYY-MM-DD")#T#timeFormat(Arguments.fec,"hh:mm:ss")#" parche="#xmlFormat(Arguments.parche)#" IDmod="#Arguments.IDmod#" modelo="#Arguments.modelo#" IDsch="#Arguments.IDsch#" sch="#Arguments.sch#">'>
		<cffile action="write" file="#archivo#" output="#LvarXML#" addnewline="no" charset="utf-8">
	
		<cfloop query="rsOBJECTS">
			<cfset LvarXML = '<tab cod="#rsOBJECTS.tab#" des="#xmlFormat(rsOBJECTS.des)#" suf13="#rsOBJECTS.suf13#" suf25="#rsOBJECTS.suf25#"'>
			<cfif trim(rsOBJECTS.IDmodORI) NEQ "">
				<cfset LvarXML &= ' IDmod="#xmlFormat(rsOBJECTS.IDmodORI)#"'>
			<cfelse>
				<cfset LvarXML &= ' gen="0"'>
			</cfif>
			
			<cfif trim(rsOBJECTS.rul) NEQ "">
				<cfset LvarXML &= ' rul="#xmlFormat(rsOBJECTS.rul)#"'>
			</cfif>
			<cfif trim(rsOBJECTS.del) EQ "1">
				<cfset LvarXML &= ' del="1"'>
			</cfif>
			<cfif trim(rsOBJECTS.tabAnt) NEQ "">
				<cfset LvarXML &= ' ren="#xmlFormat(rsOBJECTS.tabAnt)#"'>
			</cfif>
			<cfset LvarXML &= '>'>
			<cfquery name="rsSQL" datasource="asp">
				select *
				  from DBMcol
				 where IDtab = #rsOBJECTS.IDtab#
				 order by sec
			</cfquery>
			<cfloop query="rsSQL">
				<cfset LvarTIP = trim(rsSQL.tip)>
				<cfset LvarXML &= '<col cod="#rsSQL.col#" des="#xmlFormat(rsSQL.des)#" sec="#rsSQL.sec#" tip="#LvarTIP#"'>
				<cfif NOT listFind("CL,BL,D,L,TS",LvarTIP)>
					<cfset LvarXML &= ' lon="#rsSQL.lon#"'>
					<cfif rsSQL.DEC NEQ "0">
						<cfset LvarXML &= ' dec="#rsSQL.dec#"'>
					</cfif>
				<cfelseif rsSQL.lon NEQ 0>
					<cfset LvarXML &= ' lon="#rsSQL.lon#"'>
				</cfif>
				<cfif rsSQL.ide NEQ "0">
					<cfset LvarXML &= ' ide="#rsSQL.ide#"'>
				</cfif>
				<cfif rsSQL.obl EQ "1" OR rsSQL.ide EQ "1" OR LvarTIP EQ "TS">
					<cfset LvarXML &= ' obl="1"'>
				</cfif>
				<cfif trim(rsSQL.dfl) NEQ "">
					<cfset LvarXML &= ' dfl="#xmlFormat(rsSQL.dfl)#"'>
				</cfif>
				<cfif trim(rsSQL.ini) NEQ "">
					<cfset LvarXML &= ' ini="#xmlFormat(rsSQL.ini)#"'>
				</cfif>
				<cfif trim(rsSQL.minVal) NEQ "">
					<cfset LvarXML &= ' min="#xmlFormat(rsSQL.minVal)#"'>
				</cfif>
				<cfif trim(rsSQL.maxVal) NEQ "">
					<cfset LvarXML &= ' max="#xmlFormat(rsSQL.maxVal)#"'>
				</cfif>
				<cfif trim(rsSQL.lov) NEQ "">
					<cfset LvarXML &= ' lov="#xmlFormat(rsSQL.lov)#"'>
				</cfif>
				<cfif rsSQL.del EQ "1">
					<cfset LvarXML &= ' del="1"'>
				</cfif>
				<cfif trim(rsSQL.colAnt) NEQ "">
					<cfset LvarXML &= ' ren="#xmlFormat(rsSQL.colAnt)#"'>
				</cfif>
				<cfset LvarXML &= ' />'>
			</cfloop>
			<cfquery name="rsSQL" datasource="asp">
				select case tip
							when 'P' then 1
							when 'A' then 2
							when 'U' then 3
							when 'I' then 4
							else 5
						end,
						k.tip, k.sec, k.cols, k.ref, k.colsR, k.clu, k.idxTip, k.gen, k.del
				  from DBMkey k
				 where IDtab = #rsOBJECTS.IDtab#
				 order by 1, sec
			</cfquery>
			<cfloop query="rsSQL">
				<cfset LvarClu="">
				<cfset LvarGen="">
				<cfset LvarDel="">
				<cfset LvarIdxTip="">
				<cfif rsSQL.clu EQ "1">
					<cfset LvarClu=' clu="1"'>
				</cfif>
				<cfif rsSQL.idxTip NEQ "F">
					<cfset LvarIdxTip=' idxTip="#rsSQL.idxTip#"'>
				</cfif>
				<cfif rsSQL.gen NEQ "1">
					<cfset LvarGen=' gen="0"'>
				</cfif>
				<cfif rsSQL.del EQ "1">
					<cfset LvarDel=' del="1"'>
				</cfif>
				<cfif rsSQL.tip NEQ "F">
					<cfset LvarXML &= '<key tip="#rsSQL.tip#" sec="#rsSQL.sec#" cols="#rsSQL.cols#"#LvarClu##LvarGen##LvarDel# />'>
				<cfelse>
					<cfset LvarXML &= '<key tip="#rsSQL.tip#" sec="#rsSQL.sec#" cols="#rsSQL.cols#" ref="#rsSQL.ref#" colsR="#rsSQL.colsR#"#LvarIdxTip##LvarGen##LvarDel# />'>
				</cfif>
			</cfloop>
			<cfset LvarXML &= '</tab>'>
			<cffile action="append" file="#archivo#" output="#LvarXML#" addnewline="no" charset="utf-8">
			<cfset LvarXML = "">
		</cfloop>
		<cfset LvarXML &= '</version>'>
		<cffile action="append" file="#archivo#" output="#LvarXML#" addnewline="no" charset="utf-8">
	</cffunction>
	
	<cffunction name="fnKeyO" output="no" access="package" returntype="numeric">
		<cfargument name="tip" type="string" required="yes">
	
		<cfif Arguments.tip EQ "P">
			<cfreturn 1>
		<cfelseif Arguments.tip EQ "A">
			<cfreturn 2>
		<cfelseif Arguments.tip EQ "U">
			<cfreturn 3>
		<cfelseif Arguments.tip EQ "F">
			<cfreturn 4>
		<cfelse>
			<cfreturn 5>
		</cfif>
	</cffunction>
	
	<cffunction name="fnKeyOsql" output="no" access="package" returntype="string">
		<cfargument name="col" type="string" required="yes">
	
		<cfreturn "case #Arguments.col# when 'P' then 1 when 'A' then 2 when 'U' then 3 when 'F' then 4 else 5 end">
	</cffunction>
	
	<cffunction name="fnSQLstring" access="private" returntype="string">
		<cfargument name="valor" type="string"	required="yes">
		<cfargument name="lon" type="numeric"	default="0">
		
		<cfset LvarSQL = replace(rtrim(Arguments.valor),"'","''","ALL")>
		<cfif Arguments.lon GT 0>
			<cfset LvarSQL = left(LvarSQL,Arguments.lon)>
		</cfif>
		<cfreturn "'#LvarSQL#'">
	</cffunction>
	
	<!--- OJO: FUNCION Recursiva --->
	<!---
		Recorre la estructura de referencias a todos los niveles hijos que utilice un mismo "campo original"
		La razón es que el "campo original" se convirtió a identity, por lo que va a cambiar su valor (a un consecutivo nuevo)
		y todas las referencias directas e indirectas a dicho campo deben cambiar su valor al nuevo valor.
		Para poder hacer UPDATE primero hay que BORRAR los constraints.
		- KEYsCHG : Marca la referencia como OP = 3 para borrar el constraint
		- UPDATE  : Actualiza el valor anterior por el nuevo valor del "campo original"
	--->
	<cffunction name="fnRecurs_KEYsCHGtoIDE" access="package" returntype="string">
		<cfargument name="TIPO" type="string">
		<cfargument name="tab" type="string">
		<cfargument name="colOLD" type="string">
		<cfargument name="colNEW" type="string">
		<cfargument name="tabR" type="string">
		<cfargument name="colR" type="string">
		<cfargument name="conexion" type="string">
		<cfargument name="EXEC" type="string">
		<cfargument name="inicial" default="yes">
			
		<cfset var rsSQL = 0>
		<cfset var LvarSQL_UpdateRefID = "">
		<cfset var LvarColFK	= "">
		<cfif Arguments.inicial>
			<cfif Arguments.TIPO EQ "UPDATE">
				<cfquery name="rsSQL" datasource="#Arguments.conexion#">
					select count(1) as cantidad
					  from #Arguments.tab#
				</cfquery>
				<cfif rsSQL.cantidad EQ 0>
					<cfreturn "">
				</cfif>
			</cfif>
	
			<cfset GvarRefsIDs = "">
		</cfif>
	
		<cfif Arguments.TIPO NEQ "UPDATE" AND Arguments.TIPO NEQ "KEYsCHG">
			<cfthrow message="fnRecurs_KEYsCHGtoIDE: Argumento TIPO debe ser KEYsCHG o UPDATE">
		</cfif>
		
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			select tab, cols, tip, ref, colsR, OP, keyN
			  from #keyDB#
			 where ref = '#Arguments.tabR#' 
			   and ',' #CONCAT# colsR #CONCAT# ',' LIKE '%,#Arguments.colR#,%'
		</cfquery>
	
		<cfloop query="rsSQL">
			<cfif listLen(rsSQL.colsR) EQ 1>
				<cfset LvarColFK 	= rsSQL.Cols>
			<cfelse>
				<cfset LvarColFK	= listGetAt(rsSQL.Cols, listContains(rsSQL.ColsR, Arguments.colR))>
			</cfif>
	
			<cfif NOT listFind(GvarRefsIDs,"#rsSQL.tab#|#LvarColFK#")>
				<cfset GvarRefsIDs = listAppend(GvarRefsIDs,"#rsSQL.tab#|#LvarColFK#")>
				<cfif Arguments.TIPO NEQ "UPDATE">
					<cfif rsSQL.OP EQ "0">
						<cfquery datasource="#Arguments.conexion#">
							update #keyDB#
							   set OP = 8
							 where tab		= '#rsSQL.tab#' 
							   and cols		= '#rsSQL.cols#'
							   and tip		= '#rsSQL.tip#'
							   and ref		= '#rsSQL.ref#'
							   and colsR	= '#rsSQL.colsR#'
							   and OP = 0
						</cfquery>
						<cfquery datasource="#Arguments.conexion#">
							update #keyPD#
							   set OP = 8
							 where tab		= '#rsSQL.tab#' 
							   and cols		= '#rsSQL.cols#'
							   and tip		= '#rsSQL.tip#'
							   and ref		= '#rsSQL.ref#'
							   and colsR	= '#rsSQL.colsR#'
							   and OP = 0
						</cfquery>
					</cfif>
				<cfelse>
					<cfset LvarSQL_UpdateRefID &= "UPDATE #rsSQL.tab# SET #LvarColFK# = coalesce ((select #Arguments.colNEW# from #Arguments.tab# t WHERE t.#Arguments.colOLD# = #rsSQL.tab#.#LvarColFK#), #LvarColFK#)#Arguments.EXEC#">
				</cfif>
	
				<cfset LvarSQL_UpdateRefID &= fnRecurs_KEYsCHGtoIDE(Arguments.TIPO, Arguments.tab, Arguments.colOLD, Arguments.colNEW, rsSQL.tab, LvarColFK, Arguments.conexion, Arguments.EXEC, false)>
			</cfif>
		</cfloop>
	
		<cfreturn LvarSQL_UpdateRefID>
	</cffunction>

	<cffunction name="fnFuenteLinea" returntype="string">
		<cfargument name="objCatch" type="any">
		<cfset var LvarError = "">
		<cftry>
			<cfif isdefined("Arguments.objCatch.TagContext")>
				<cfset LvarError = Arguments.objCatch.TagContext[1].Template>
				<cfif find(expandPath("/"),LvarError)>
					<cfset LvarError = mid(LvarError,find(expandPath("/"),LvarError),len(LvarError))>
					<cfset LvarError = Replace(LvarError,expandPath("/"),"CFMX/")>
					<cfset LvarError = REReplace(LvarError,"[/\\]","/ ","ALL")>
				</cfif>
				<cfset LvarError = LvarError & ": " & Arguments.objCatch.TagContext[1].Line>
			</cfif>
		<cfcatch type="any"></cfcatch>
		</cftry>
		<cfreturn LvarError>	
	</cffunction>
</cfcomponent>
