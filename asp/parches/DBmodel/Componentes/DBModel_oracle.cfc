<cfset vbCrLf	= chr(13) & chr(10)>
<cfset vbTab	= chr(9)>
<cfset EXEC = "#vbCrLf#/#vbCrLf#">
<cfset GvarOBJ = "">
<cfset GvarTabPrefijo = "">
<cfset GvarTabTriggers = structNew()>

<cffunction name="init" access="package" output="no" returntype="struct">
	<cfargument name="obj" required="yes">
	<cfargument name="dsn" required="yes">
	<cfset GvarOBJ = arguments.obj>

	<cfset GvarSchema = Application.dsinfo[arguments.dsn].Schema>
	<cfif GvarSchema EQ "">
		<cfthrow message="Error en DSN '#arguments.dsn#':#Application.dsinfo[arguments.dsn].SchemaError#">
	</cfif>
	<cfreturn this>
</cffunction>

<cffunction name="fnCaseSensitive" access="package" output="no" returntype="boolean">
	<cfreturn false>
</cffunction>
<!---
	***************************************
	CREAR LAS TABLAS DE TRABAJO PARA ORACLE
	***************************************
--->
<cffunction name="creaTablas" access="package" output="no">
	<cfargument name="conexion" required="yes">
	
	<cfset GvarSchema = ucase(Application.dsinfo[arguments.conexion].Schema)>
	<cf_dbfunction name="OP_CONCAT" returnvariable="CONCAT" datasource="#Arguments.conexion#">
	<cf_dbfunction name="FN_LEN" 	returnvariable="LEN" 	datasource="#Arguments.conexion#">

	<cf_dbtemp name="tabDB_V3" returnvariable="tabDB" datasource="#arguments.conexion#">
		<cf_dbtempcol name="tab"		    	type="varchar(30)"	mandatory="yes">
		<cf_dbtempcol name="tib"		    	type="varchar(50)"	mandatory="no">
		<cf_dbtempcol name="seq"		    	type="varchar(50)"	mandatory="no">
		<cf_dbtempcol name="tuts"		    	type="varchar(50)"	mandatory="no">
		<cf_dbtempcol name="OP"		    		type="integer"		mandatory="yes" default="0">
		<cf_dbtempcol name="tabAnt"		    	type="varchar(30)"	mandatory="no">
	
		<cf_dbtempkey cols="tab">
	</cf_dbtemp>
	<cf_dbtemp name="colDB_V3" returnvariable="colDB" datasource="#arguments.conexion#">
		<cf_dbtempcol name="tab"		    	type="varchar(30)"	mandatory="yes">
		<cf_dbtempcol name="col"		    	type="varchar(50)"	mandatory="yes">
		<cf_dbtempcol name="tip"		    	type="varchar(2)"		mandatory="yes">
		<cf_dbtempcol name="lon"		    	type="int"			mandatory="no">
		<cf_dbtempcol name="dec"		    	type="int"			mandatory="no">
		<cf_dbtempcol name="ide"		    	type="bit"			mandatory="yes">
		<cf_dbtempcol name="obl"		    	type="bit"			mandatory="yes">
		<cf_dbtempcol name="dfl"		    	type="varchar(255)"	mandatory="no">
		<cf_dbtempcol name="dflN"		    	type="char(1)"		mandatory="no">
		<cf_dbtempcol name="chk"		    	type="varchar(50)"	mandatory="no">
		<cf_dbtempcol name="rul"		    	type="varchar(900)"	mandatory="no">
		<cf_dbtempcol name="OP"		    		type="integer"		mandatory="yes" default="0">
		<cf_dbtempcol name="colAnt"		    	type="varchar(30)"	mandatory="no">

		<cf_dbtempkey cols="tab,col">
	</cf_dbtemp>

	<cf_dbtemp name="keyDB_V3" returnvariable="keyDB" datasource="#arguments.conexion#">
		<cf_dbtempcol name="tab"		    	type="varchar(30)"	mandatory="yes">
		<cf_dbtempcol name="cols"		    	type="varchar(255)"	mandatory="yes">
		<cf_dbtempcol name="tip"		    	type="char(1)"		mandatory="yes">
		<cf_dbtempcol name="ref"		    	type="varchar(50)"	mandatory="yes">
		<cf_dbtempcol name="colsR"		    	type="varchar(255)"	mandatory="yes">
		<cf_dbtempcol name="keyN"		    	type="varchar(50)"	mandatory="yes">
		<cf_dbtempcol name="idx"		    	type="varchar(50)"	mandatory="no">
		<cf_dbtempcol name="clu"		    	type="bit"			mandatory="yes">
		<cf_dbtempcol name="keyO"		    	type="integer"		mandatory="yes">
		<cf_dbtempcol name="OP"		    		type="integer"		mandatory="yes" default="0">
	
		<cf_dbtempkey 	cols="tab,cols,tip,ref,keyN">
		<cf_dbtempindex cols="tab,cols,tip,ref,colsR">
	</cf_dbtemp>

	<cf_dbtemp name="chkDB_V3" returnvariable="chkDB" datasource="#arguments.conexion#">
		<cf_dbtempcol name="tab"		    	type="varchar(30)"	mandatory="yes">
		<cf_dbtempcol name="chk"		    	type="varchar(50)"	mandatory="yes">
		<cf_dbtempcol name="rul"		    	type="varchar(900)"	mandatory="no">
		<cf_dbtempcol name="OP"		    		type="integer"		mandatory="yes" default="0">
	
		<cf_dbtempkey cols="tab,chk">
	</cf_dbtemp>

	<cfset session.dbm.tabDB	= tabDB>
	<cfset session.dbm.colDB	= colDB>
	<cfset session.dbm.keyDB	= keyDB>
	<cfset session.dbm.chkDB	= chkDB>

	<cfset tabPD 	= session.dbm.tabPD>
	<cfset colPD 	= session.dbm.colPD>
	<cfset keyPD 	= session.dbm.keyPD>
	<cfset colRPD	= session.dbm.colRPD>
</cffunction>

<cffunction name="asignaTablas" access="package" output="no">
	<cfargument name="conexion" required="yes">

	<cfset GvarSchema = Application.dsinfo[arguments.conexion].Schema>
	<cf_dbfunction name="OP_CONCAT" returnvariable="CONCAT" datasource="#Arguments.conexion#">
	<cf_dbfunction name="FN_LEN" 	returnvariable="LEN" 	datasource="#Arguments.conexion#">

	<cfset tabDB = session.dbm.tabDB>
	<cfset colDB = session.dbm.colDB>
	<cfset keyDB = session.dbm.keyDB>

	<cfset tabPD 	= session.dbm.tabPD>
	<cfset colPD 	= session.dbm.colPD>
	<cfset keyPD 	= session.dbm.keyPD>
	<cfset colRPD	= session.dbm.colRPD>
</cffunction>

<!---
	***********************************************
	AJUSTA LA ESTRUCTURA POWER DESIGNER PARA ORACLE
	***********************************************
--->
<cffunction name="sbGetPDPrefijoName" access="package" output="no" returntype="string">
	<cfargument name="conexion"	required="yes">
	<cfargument name="tipo"		required="yes">
	<cfargument name="sec"		required="yes">

	<cfset LvarSuf = "t.suf25">
	<cfset LvarPrefN = "23">

	<cfreturn GvarOBJ.sbGetPDPrefijoName(Arguments.conexion, tipo, sec, LvarSuf, LvarPrefN)>
</cffunction>

<cffunction name="ajustaPDs" access="package" output="no">
	<cfargument name="conexion"		required="yes">
	<cfargument name="tipo"			required="yes">
	<cfargument name="tipoID"		required="yes">
	<cfargument name="OP"			required="yes"	default="0">
	<cfargument name="colPD_colRPD"	required="yes"	default="#colPD#">

	<cfset LvarTabsI = 50>

	<!--- Ajustes tanto para colPD como para colRPD --->
		<!--- Tipo CHAR = VARCHAR --->
		<cfif Application.dsinfo[arguments.conexion].charTypeDBM EQ "V">
			<cfquery name="rsSQL" datasource="#arguments.conexion#">
				update #Arguments.colPD_colRPD# 
				   set tip='V' 
				 where tip = 'C'
				   and OP = #Arguments.OP#
			</cfquery>
		</cfif>
			
		<!--- Tipo BIT = N(1,0) in 0,1--->
		<cfquery name="rsSQL" datasource="#arguments.conexion#">
			update #Arguments.colPD_colRPD# 
			   set tip='N',lon=1,obl=1,lov='0,1' 
			 where tip='L'
			   and OP = #Arguments.OP#
		</cfquery>
	
		<!--- Tipo TINYINT = N(3,0) in 0,255--->
		<cfquery name="rsSQL" datasource="#arguments.conexion#">
			update #Arguments.colPD_colRPD# 
			   set tip='N',lon=3,dec=0,minVal=coalesce(minVal,'0'),maxVal=coalesce(maxVal,'255') 
			 where tip='I' AND lon=3
			   and OP = #Arguments.OP#
		</cfquery>
	
		<!--- Tipo INTEGER = N(n,0) y MONEY = N(n,4) --->
		<cfquery name="rsSQL" datasource="#arguments.conexion#">
			update #Arguments.colPD_colRPD# 
			   set	tip='N', 
					dec=case when tip = 'I' then 0 else 4 end 
			 where tip in ('I', 'M')
			   and OP = #Arguments.OP#
		</cfquery>
		
		<cfif Arguments.colPD_colRPD EQ colRPD>
			<cfreturn>
		</cfif>
	<!--- FIN ajustes para colRPD --->
	
	
	<!--- Defaults: user_name() y getdate() --->
	<cfquery name="rsSQL" datasource="#arguments.conexion#">
		update #colPD#
		   set dfl = 'USER'
		 where dfl like '%user_name%()%'
		   and OP = #Arguments.OP#
	</cfquery>

	<!--- Defaults: datetime --->
	<cfquery name="rsSQL" datasource="#arguments.conexion#">
		update #colPD#
		   set dfl = 'SYSDATE'
		 where ltrim(rtrim(lower(dfl))) in ('getdate()', 'getdate ()')
		   and OP = #Arguments.OP#
	</cfquery>

	<!--- Tipo TIMESTAMP --->
	<cfquery name="rsSQL" datasource="#arguments.conexion#">
		update #colPD# 
		   set dfl='SYSTIMESTAMP', obl=1 
		 where tip = 'TS'
		   and OP = #Arguments.OP#
	</cfquery>
	
	<cfquery name="rsSQL" datasource="#arguments.conexion#">
		update #colPD#
		   set dfl = 
		   		case 
					when dfl like '%getdate%()%' then 'SYSDATE' 
					when #LEN#(dfl)=8 then 'TO_DATE(''' || dfl || ''',''YYYYMMDD'')'
					else dfl
				end
		 where tip = 'D'
		   and OP = #Arguments.OP#
	</cfquery>
	
	<!--- TODOS LOS CODIGOS EN MAYUSCULAS --->
	<cfquery name="rsSQL" datasource="#arguments.conexion#">
		update #tabPD#
		   set tab = upper(tab),
		   	   tabAnt = upper(tabAnt)
		 where OP = #Arguments.OP#
	</cfquery>
	
	<cfquery name="rsSQL" datasource="#arguments.conexion#">
		update #colPD#
		   set tab = upper(tab),
		       col = upper(col),
		   	   colAnt = upper(colAnt)
		 where OP = #Arguments.OP#
	</cfquery>

	<cfquery name="rsSQL" datasource="#arguments.conexion#">
		update #keyPD#
		   set tab   = upper(tab),
		       cols  = upper(cols),
		       ref   = upper(ref),
		       colsR = upper(colsR)
		 where OP = #Arguments.OP#
	</cfquery>
	
	<cfset LvarTabsI += 10>
	<cfif Arguments.tipo EQ "UPLOAD">
		<cfquery datasource="asp">
			update DBMuploads
			   set 	tabsP	= #LvarTabsI#
			 where IDupl = #Arguments.tipoID#
		</cfquery>
	</cfif>

	<!--- GENERA LAS REGLAS DE LOS CHECKs --->
	<cfquery name="rsSQL" datasource="#arguments.conexion#">
		select tab, col, tip, obl, minVal, maxVal, lov
		  from #colPD#
		 where (minVal IS NOT NULL OR maxVal IS NOT NULL OR lov IS NOT NULL)
		   and OP = #Arguments.OP#
	</cfquery>

	<cfset LvarTabsP = 0>
	<cfloop query="rsSQL">
		<cfif rsSQL.currentRow - LvarTabsP GT 10>
			<cfset LvarTabsP = rsSQL.currentRow>
			<cfif Arguments.tipo EQ "UPLOAD">
				<cfquery datasource="asp">
					update DBMuploads
					   set 	tabsP	= #LvarTabsI + int(LvarTabsP/rsSQL.recordCount * (100-LvarTabsI))#
					 where IDupl = #Arguments.tipoID#
				</cfquery>
			</cfif>
		</cfif>

		<cfif trim(rsSQL.minVal & rsSQL.maxVal & lov) NEQ "">
			<cfset LvarRUL = toRULE (rsSQL.col, rsSQL.tip, rsSQL.obl, rsSQL.minVal, rsSQL.maxVal, rsSQL.lov)>
			<cfquery datasource="#arguments.conexion#">
				update #colPD#
				   set rul = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarRUL#"		null="#trim(LvarRUL) EQ ''#">
				 where tab = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSQL.tab#">
				   and col = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSQL.col#">
			</cfquery>
		</cfif>
	</cfloop>
</cffunction>

<cffunction name="toRule" access="public" output="no" returntype="string">
	<cfargument name="col">
	<cfargument name="tip">
	<cfargument name="obl">
	<cfargument name="minVal">
	<cfargument name="maxVal">
	<cfargument name="lov">
	
	<cfset Arguments.tip = trim(Arguments.tip)>
	<cfset Arguments.obl = trim(Arguments.obl)>
	<cfset Arguments.minVal = trim(Arguments.minVal)>
	<cfset Arguments.maxVal = trim(Arguments.maxVal)>
	<cfset Arguments.lov = trim(Arguments.lov)>
	<cfif Arguments.minVal & Arguments.maxVal & Arguments.lov EQ "">
		<cfreturn "">
	</cfif>
	
	<!--- TiposPD = C,V,CL,	B,VB,BL,	I,N,F,M,L,	D,	TS --->
	<!--- TiposCF = S,		B,			N,			D,	TS --->
	<cfset LvarTipo = GvarObj.fnTipoPDtoCF(Arguments.tip)>

	<cfset LvarRule = "">
	<cfif Arguments.minVal NEQ "">
		<cfset LvarRule = LvarRule & " and #Arguments.col# >= #fnValsToLiterals(Arguments.minVal, LvarTipo, false)#">
	</cfif>
	<cfif Arguments.maxVal NEQ "">
		<cfset LvarRule = LvarRule & " and #Arguments.col# <= #fnValsToLiterals(Arguments.maxVal, LvarTipo, false)#">
	</cfif>

	<cfset LvarVALS = GvarObj.fnLOVtoVALS(Arguments.lov)>
	<cfif LvarVALS NEQ "">
		<cfset LvarRule = LvarRule & " and #Arguments.col# in (#fnValsToLiterals(LvarVALS, LvarTipo, true)#)">
	</cfif>

	<cfif LvarRule NEQ "">
		<cfset LvarRule = mid(LvarRule,6,len(LvarRule))>
		<cfif Arguments.obl EQ "0">
			<cfset LvarRule = "#Arguments.col# is null or ( #LvarRule# )">
		</cfif>
	
		<cfset LvarRule = "#LvarRule#">
	</cfif>

	<cfreturn LvarRule>
</cffunction>

<cffunction name="fnValsToLiterals" access="private" output="no" returntype="string">
	<cfargument name="value">
	<cfargument name="tipo">
	<cfargument name="lista" default="false">

	<cfset LvarValue = trim(replace(Arguments.value,"'", "", "ALL"))>
	<cfif LvarValue EQ "">
		<cfreturn "">
	</cfif>
	
	<cfif Arguments.tipo EQ "S">
		<cfset LvarValue = "'#LvarValue#'">
		<cfif Arguments.lista>
			<cfset LvarValue = replace(LvarValue, ",", "','", "ALL")>
		</cfif>
	<cfelseif Arguments.tipo EQ "B">
		<cfif REfind("[^0123456789ABCDEFabcdef,]",LvarValue)>
			<cfreturn "">
		</cfif>
		<cfset LvarValue = "0x#LvarValue#">
		<cfif Arguments.lista>
			<cfset LvarValue = replace(LvarValue, ",", ",0x#LvarValue#", "ALL")>
		</cfif>
	<cfelseif Arguments.tipo EQ "N">
		<cfif REfind("[^+0123456789.\-,]",LvarValue)>
			<cfreturn "">
		</cfif>
		<cfset LvarValue2 = replace(LvarValue,"+","")>
	<cfelseif Arguments.tipo EQ "D">
	</cfif>
	<cfreturn LvarValue>
</cffunction>

<!---
	*******************************************************
	OBTENER LA ESTRUCTURA ACTUAL DE LA BASE DE DATOS ORACLE
	*******************************************************
--->
<cffunction name="fromDatabase" access="package" output="no">
	<cfargument name="conexion" 	required="yes">
	<cfargument name="rsOBJECTS"	type="query" required="yes">
	<cfargument name="TIPO"			required="yes">
	<cfargument name="TipoID"		required="yes">

	<cfif Arguments.TIPO EQ "UPLOAD">
		<cfquery datasource="asp">
			update DBMuploads
			   set stsP  = 4		<!--- Cargando Desarrollo --->
			   	 , tabsP = 1
			 where IDupl = #Arguments.TipoID#
		</cfquery>
	<cfelseif Arguments.TIPO EQ "UPGRADE">
		<cfquery datasource="asp">
			update DBMgenP
			   set stsP  = 4			<!--- Cargando Base de Datos --->
			   	 , tabsP = 1
			 where IDgen = #Arguments.TipoID#
		</cfquery>
	</cfif>

	<cfset LvarTabsP = 0>
	<cfloop query="rsOBJECTS">
		<cfset LvarTablaPD = trim(rsObjects.tab)>
		<cfset LvarTablaDB = trim(rsObjects.tab)>
		<cfif rsOBJECTS.currentRow - LvarTabsP GT 10>
			<cfset LvarTabsP = GvarOBJ.fnUpdateTabsP (Arguments.tipo, Arguments.tipoID, rsOBJECTS.currentRow)>
		</cfif>

		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			SELECT TABLE_NAME
			  FROM	ALL_TABLES
			 WHERE	OWNER     	= '#GvarSchema#'
			   AND 	TABLE_NAME	= '#LvarTablaPD#'
		</cfquery>
		<cfset LvarTablaDB = trim(rsSQL.TABLE_NAME)>

		<!--- OBTIENE TABLA A RENOMBRAR --->
		<cfif LvarTablaDB EQ "" AND rsObjects.tabAnt NEQ "">
			<cfquery name="rsSQL" datasource="#Arguments.conexion#">
				SELECT TABLE_NAME
				  FROM	ALL_TABLES
				 WHERE	OWNER     	= '#GvarSchema#'
				   AND 	TABLE_NAME	= '#rsObjects.tabAnt#'
			</cfquery>
			<cfset LvarTablaDB = trim(rsSQL.TABLE_NAME)>
		</cfif>

		<cfif LvarTablaDB NEQ "">
			<!--- OBTIENE EL LvarIdentityCol del texto del trigger de Identity --->
			<cfset LvarTIB	= "">
			<cfset LvarTUTS	= "">
			<cfset LvarSEQ	= "">
			<cfset LvarIdentityCol = "">
			<cfquery name="rsTriggers" datasource="#Arguments.conexion#">
				SELECT	TRIGGER_NAME, TRIGGER_BODY, o.STATUS as STATUS_V, t.STATUS as STATUS_E
				  FROM	USER_TRIGGERS t
				  	LEFT JOIN USER_OBJECTS o
						ON OBJECT_NAME = TRIGGER_NAME
				 WHERE	TABLE_OWNER     = '#GvarSchema#'
				   AND 	TABLE_NAME		= '#LvarTablaDB#'
				   AND	TRIGGER_NAME    like 'TIB_%'
			</cfquery>
			
			<!--- Borra si hay mas de un trigger --->
			<cfif rsTriggers.recordCount GT 1>
				<cfthrow message="Debe determinar el trigger de inserción correcto y borrar el equivocado, igualmente con la Secuencia correspondiente: tabla: #LvarTablaDB#, #valueList(rsTriggers.TRIGGER_NAME)#">
				<cfset sbDropTriggersRepetidos(Arguments.conexion, 'TIB')>
			</cfif>			

			<!--- SELECT S_CACHES.NEXTVAL INTO SOINPK.LASTIDENTITY FROM DUAL; --->
			<!--- SELECT SOINPK.LASTIDENTITY INTO :NEW.#Arguments.col# FROM DUAL; --->
			<cfset LvarTIB = trim(rsTriggers.TRIGGER_NAME)>
			<cfset LvarPto = findNoCase(".NEXTVAL", rsTriggers.TRIGGER_BODY)>
			<cfif LvarPto>
				<cfset LvarIdentityCol = mid(rsTriggers.TRIGGER_BODY, findNoCase(":NEW.", rsTriggers.TRIGGER_BODY)+5, 100)>
				<cfset LvarIdentityCol = ucase(left(LvarIdentityCol, find(" ", LvarIdentityCol)-1))>
	
				<cfloop condition="LvarPto GT 0">
					<cfset LvarPto -= 1>
					<cfif mid(rsTriggers.TRIGGER_BODY, LvarPto, 1) EQ " ">
						<cfbreak>
					</cfif>
					<cfset LvarSEQ = mid(rsTriggers.TRIGGER_BODY, LvarPto, 1) & LvarSEQ>
				</cfloop>
				<cfquery name="rsSEQs" datasource="#Arguments.conexion#">
					SELECT	SEQUENCE_NAME
					  FROM	ALL_SEQUENCES
					 WHERE	SEQUENCE_OWNER	= '#GvarSchema#'
					   AND 	SEQUENCE_NAME	= '#LvarSEQ#'
				</cfquery>
				<cfset LvarSEQ = rsSEQs.SEQUENCE_NAME>
				<cfif LvarSEQ EQ "">
					<cfset LvarIdentityCol = "">
				</cfif>
			<cfelse>
				<cfif len(LvarTablaDB) GT 23>
					<cfset GvarTabPrefijo = left(GvarTabPrefijo,23) & "__">
				</cfif>
				<cfquery name="rsSEQs" datasource="#Arguments.conexion#">
					SELECT	SEQUENCE_NAME
					  FROM	ALL_SEQUENCES
					 WHERE	SEQUENCE_OWNER	= '#GvarSchema#'
					<cfif len(LvarTablaDB) LTE 23>
				   	   AND	SEQUENCE_NAME	= 'S_#LvarTablaDB#'
					<cfelse>
					   AND 	(
					   			SEQUENCE_NAME	= 'S_#mid(LvarTablaDB,1,30)#' OR 
								(
								  substr(SEQUENCE_NAME,1,25) = 'S_#mid(LvarTablaDB,1,23)#'
									and substr(SEQUENCE_NAME,26,1) >= '0' and substr(SEQUENCE_NAME,26,1) <= '9'
									and substr(SEQUENCE_NAME,27,1) >= '0' and substr(SEQUENCE_NAME,27,1) <= '9'
								)
							)
					</cfif>
				</cfquery>
				<cfset LvarSEQ = rsSEQs.SEQUENCE_NAME>
				<cfset LvarIdentityCol = "">
			</cfif>
			<cfif LvarTIB NEQ "" AND NOT (LvarSEQ NEQ "" AND rsTriggers.STATUS_V EQ "VALID" AND rsTriggers.STATUS_E EQ "ENABLED")>
				<cfset LvarTIB &= ":INVALID">
			</cfif>

			<cfquery name="rsTriggers" datasource="#Arguments.conexion#">
				SELECT	TRIGGER_NAME, TRIGGER_BODY, o.STATUS as STATUS_V, t.STATUS as STATUS_E
				  FROM	ALL_TRIGGERS t
					INNER JOIN USER_OBJECTS o
						ON OBJECT_NAME = TRIGGER_NAME
				 WHERE	TABLE_OWNER     = '#GvarSchema#'
				   AND 	TABLE_NAME		= '#LvarTablaDB#'
				   AND	TRIGGER_NAME    like 'TUTS_%'
			</cfquery>

			<!--- Borra si hay mas de un trigger --->
			<cfif rsTriggers.recordCount GT 1>
				<cfset sbDropTriggersRepetidos(Arguments.conexion, 'TUTS')>
			</cfif>			

			<cfset LvarTUTS = trim(rsTriggers.TRIGGER_NAME)>
			<cfif findNoCase(".TS_RVERSION", rsTriggers.TRIGGER_BODY)>
				<cfset LvarTS = true>
			<cfelse>
				<cfset LvarTS = false>
			</cfif>
			<cfif LvarTUTS NEQ "" AND NOT (LvarTS AND rsTriggers.STATUS_V EQ "VALID" AND rsTriggers.STATUS_E EQ "ENABLED")>
				<cfset LvarTUTS &= ":INVALID">
			</cfif>
			
			<cfquery datasource="#Arguments.conexion#">
				insert into #tabDB# (tab, tabAnt, tib, tuts, seq)
				values (
					  <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTablaPD#">
					 ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTablaDB#"	null="#LvarTablaPD EQ LvarTablaDB#">
					 ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTIB#"		null="#LvarTIB  EQ ''#">
					 ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTUTS#"		null="#LvarTUTS EQ ''#">
					 ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarSEQ#"		null="#LvarSEQ  EQ ''#">
				)
			</cfquery>
			
			<cfquery name="rsSQL" datasource="#Arguments.conexion#">
				SELECT	OWNER 			AS SCH, 
						TABLE_NAME 		as TAB, 
						COLUMN_NAME 	as COL, 
						DATA_TYPE 		as TIP_DB, 
						'?'		 		as TIP, 
						coalesce(DATA_PRECISION,DATA_LENGTH) as LON, 
						DATA_SCALE 		as DECS, 
						CASE WHEN NULLABLE = 'Y' then 0 else 1 end as OBL,
						DATA_DEFAULT 	as DFL, 
						''				as CHK,
						''				as RUL,
						'0'				as IDE
				  FROM	ALL_TAB_COLUMNS
				 WHERE	OWNER		= '#GvarSchema#'
				   AND 	TABLE_NAME	= '#LvarTablaDB#'
				 ORDER BY COLUMN_ID
			</cfquery>
			
			<!--- OBTIENE LOS CHECKS POR COLUMNA --->
			<cfquery name="rsCHKs" datasource="#Arguments.conexion#">
				SELECT	CONSTRAINT_NAME, SEARCH_CONDITION, '*' AS COLUMN_NAME
				  FROM	USER_CONSTRAINTS
				 WHERE	OWNER			= '#GvarSchema#'
				   AND 	TABLE_NAME		= '#LvarTablaDB#'
				   AND	CONSTRAINT_TYPE	= 'C'
				   AND	SUBSTR(CONSTRAINT_NAME,1,4)<>'SYS_'
			</cfquery>
	
			<cfset LvarCOLs = "">
			<cfloop query="rsCHKs">
				<cfset LvarCHK = rsCHKs.CONSTRAINT_NAME>
				<cfset LvarRUL = rsCHKs.SEARCH_CONDITION>
				<cfset LvarCOL = rsCHKs.COLUMN_NAME>
				<cfloop query="rsSQL">
					<cfif REfindNoCase("[^a-zA-Z0-9_']#rsSQL.COL#[^a-zA-Z0-9_']"," #LvarRUL# ")>
						<cfif LvarCOL EQ "*" AND NOT listFind(LvarCOLs,rsSQL.COL)>
							<cfset LvarCOL = rsSQL.COL>
						<cfelse>
							<cfset LvarCOL = "**">
							<cfbreak>
						</cfif>
					</cfif>
				</cfloop>
				<cfif not find("*",LvarCOL)>
					<cfset LvarCOLs = listAppend(LvarCOLs,LvarCOL)>
				</cfif>
				<cfif len(trim(LvarCHK)) NEQ len(LvarCHK)>
					<cfset LvarCHK = '"#LvarCHK#"'>
					<cfset QuerySetCell(rsCHKs, "CONSTRAINT_NAME", LvarCHK, rsCHKs.currentRow)>
				</cfif>
				<cfset QuerySetCell(rsCHKs, "COLUMN_NAME", LvarCOL, rsCHKs.currentRow)>
			</cfloop>
			<cfquery name="rsSQL2" dbtype="query">
				select CONSTRAINT_NAME, SEARCH_CONDITION
				  from rsCHKs
				 where COLUMN_NAME = '**'
			</cfquery>
			<cfloop query="rsSQL2">
				<cfquery datasource="#Arguments.conexion#">
					insert into #chkDB# (tab, chk, rul)
					values (
						 <cfqueryparam value="#LvarTablaPD#"				cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="#rsSQL2.CONSTRAINT_NAME#"		cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="#rsSQL2.SEARCH_CONDITION#"	cfsqltype="cf_sql_varchar"		null="#trim(rsSQL2.SEARCH_CONDITION) EQ ''#">
					)
				</cfquery>
			</cfloop>
	
			<!--- OBTIENE LAS CARACTERISITICAS DE LAS COLUMNAS --->
			<cfloop query="rsSQL">
				<cfset LvarDfl	= trim(rsSQL.DFL)>
				<cfif LvarDfl EQ "NULL">
					<cfset LvarDfl = "">
				</cfif>
				<cfset LvarObl	= trim(rsSQL.OBL)>
				<cfquery name="rsSQL2" dbtype="query">
					select CONSTRAINT_NAME, SEARCH_CONDITION
					  from rsCHKs
					 where COLUMN_NAME = '#rsSQL.COL#'
				</cfquery>
				
				<cfset LvarCHK = rsSQL2.CONSTRAINT_NAME>
				<cfset LvarRUL = trim(rsSQL2.SEARCH_CONDITION)>
				
				<cfif LvarIdentityCol EQ rsSQL.col>
					<cfset LvarIDE = "1">
				<cfelse>
					<cfset LvarIDE = "0">
				</cfif>
				<!--- Tipo dato TIMESTAMP tiene otra información --->
				<cfif find("TIMESTAMP",rsSQL.TIP_DB)>
					<cfset LvarTIP = "TIMESTAMP">
				<cfelse>
					<cfset LvarTIP = trim(rsSQL.TIP_DB)>
				</cfif>
				<cfset LvarLON = rsSQL.LON>
				<cfif rsSQL.DECs EQ "">
					<cfset LvarDECs = 0>
				<cfelse>
					<cfset LvarDECs = rsSQL.DECs>
				</cfif>
				<cfset LvarType = ColumnTypeFromORACLE(rsSQL.COL,LvarTS,LvarTIP,LvarLON,LvarDECs)>
	
				<cfif LvarType.tip NEQ 'D'>
					<cfset LvarDfl	= replace(LvarDfl,"'","","ALL")>
				</cfif>
				
				<cfquery datasource="#Arguments.conexion#">
					insert into #colDB# (tab, col, tip, lon, dec, ide, obl, dfl, chk, rul)
					values (
						 <cfqueryparam value="#LvarTablaPD#"		cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="#rsSQL.col#"			cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="#trim(LvarTYPE.TIP)#"	cfsqltype="cf_sql_char">
						,<cfqueryparam value="#LvarType.LON#"		cfsqltype="cf_sql_integer">
						,<cfqueryparam value="#LvarType.DECs#"		cfsqltype="cf_sql_integer">
						,<cfqueryparam value="#LvarIDE#"			cfsqltype="cf_sql_bit">
						,<cfqueryparam value="#LvarOBL#"			cfsqltype="cf_sql_bit">
						,<cfqueryparam value="#LvarDFL#"			cfsqltype="cf_sql_varchar"	null="#trim(LvarDFL)	EQ ''#">
						,<cfqueryparam value="#LvarCHK#"			cfsqltype="cf_sql_varchar"	null="#trim(LvarCHK)	EQ ''#">
						,<cfqueryparam value="#LvarRUL#"			cfsqltype="cf_sql_varchar"	null="#trim(LvarRUL)	EQ ''#">
					)
				</cfquery>
			</cfloop>
		
			<!--- KEYs PK, AK --->
			<cfquery name="rsPKsAKs" datasource="#Arguments.conexion#">
				SELECT	'???'	AS COLSK,
						CONSTRAINT_NAME		AS KEYN, 
						CASE 
							WHEN CONSTRAINT_TYPE = 'U' then 'A' ELSE 'P'
						END		as TIP
				  FROM ALL_CONSTRAINTS
				 WHERE	OWNER			= '#GvarSchema#'
				   AND 	TABLE_NAME		= '#LvarTablaDB#'
				   AND	CONSTRAINT_TYPE in ('P','U')
			</cfquery>
			<cfloop query="rsPKsAKs">
				<cfquery name="rsSQL2" datasource="#Arguments.conexion#">
					SELECT COLUMN_NAME
					  FROM	ALL_CONS_COLUMNS
					 WHERE	OWNER			= '#GvarSchema#'
					   AND  CONSTRAINT_NAME = '#rsPKsAKs.KEYN#'
					ORDER BY POSITION
				</cfquery>
				<cfset Lvarcols = valueList(rsSQL2.COLUMN_NAME)>
				<cfset QuerySetCell(rsPKsAKs, "COLSK", Lvarcols, rsPKsAKs.currentRow)>
				<cfquery datasource="#Arguments.conexion#">
					insert into #keyDB# (tab, cols, tip, ref, colsR, keyN, idx, clu, keyO)
					values (
						 <cfqueryparam value="#LvarTablaPD#"	cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="#Lvarcols#"		cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="#rsPKsAKs.tip#"	cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="*"				cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="*"				cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="#rsPKsAKs.keyN#"	cfsqltype="cf_sql_varchar">
						,null
						,<cfqueryparam value="0"				cfsqltype="cf_sql_bit">
						,<cfqueryparam value="#GvarObj.fnKeyO(rsPKsAKs.tip)#" cfsqltype="cf_sql_integer">
					)
				</cfquery>
			</cfloop>
			
			<!--- KEYs UI, ID --->
			<cfquery name="rsIDX" datasource="#Arguments.conexion#">
				SELECT	INDEX_NAME		AS IDX, 
						CASE 
							WHEN INSTR(UNIQUENESS,'NONUNIQUE') > 0 then 'I' else 'U'
						END as TIP, 
						'0'				as CLU, 
						'???'			as COLSK 
				  FROM	ALL_INDEXES I
				 WHERE	TABLE_OWNER		= '#GvarSchema#'
				   AND 	TABLE_NAME		= '#LvarTablaDB#'
			</cfquery>
			<cfquery name="rsICOLs" datasource="#Arguments.conexion#">
				SELECT 	INDEX_OWNER, INDEX_NAME, TABLE_OWNER, TABLE_NAME, COLUMN_POSITION, 
						COLUMN_NAME, DESCEND
				  FROM ALL_IND_COLUMNS C
				 WHERE	TABLE_OWNER		= '#GvarSchema#'
				   AND 	TABLE_NAME		= '#LvarTablaDB#'
				 ORDER BY COLUMN_POSITION
			</cfquery>
			<cfloop query="rsIDX">
				<cfset LvarDesc = " " & lcase(replace(rsIDX.TIP, ",", " ", "ALL")) & " ">
				<cfif rsIDX.TIP NEQ "">
					<cfset LvarTip = rsIDX.TIP>
				<cfelse>
					<cfset LvarTip = "U">
				</cfif>
				<cfquery name="rsSQL2" dbtype="query">
					SELECT 	INDEX_OWNER, INDEX_NAME, TABLE_OWNER, TABLE_NAME, COLUMN_POSITION, 
							COLUMN_NAME, DESCEND
					  FROM	rsICOLS
					 WHERE	TABLE_OWNER		= '#GvarSchema#'
					   AND 	TABLE_NAME		= '#LvarTablaDB#'
					   AND 	INDEX_NAME		= '#rsIDX.IDX#'
					 ORDER BY COLUMN_POSITION
				</cfquery>
				<cfset LvarColsI = "">
				<cfloop query="rsSQL2">
					<cfif LvarColsI NEQ "">
						<cfset LvarColsI &= ",">
					</cfif>
					<cfif MID(rsSQL2.COLUMN_NAME,1,4) EQ "SYS_">
						<cfquery name="rsSQL3" datasource="#Arguments.conexion#">
							SELECT COLUMN_EXPRESSION
							  FROM ALL_IND_EXPRESSIONS
							 WHERE INDEX_OWNER 		= '#rsSQL2.INDEX_OWNER#'
							   AND INDEX_NAME		= '#rsSQL2.INDEX_NAME#'
							   AND TABLE_OWNER		= '#rsSQL2.TABLE_OWNER#'
							   AND TABLE_NAME		= '#rsSQL2.TABLE_NAME#'
							   AND COLUMN_POSITION	= '#rsSQL2.COLUMN_POSITION#'
						</cfquery>
						<cfset LvarColsI &= REPLACE(rsSQL3.COLUMN_EXPRESSION,'"',"","all")>
					<cfelse>
						<cfset LvarColsI &= rsSQL2.COLUMN_NAME>
					</cfif>
					<cfif rsSQL2.DESCEND EQ "DESC">
						<cfset LvarColsI &= "-">
					</cfif>
				</cfloop>
		
				<cfset QuerySetCell(rsIDX, "COLSK", LvarColsI, rsIDX.currentRow)>
		
				<!--- Busca una PK o AK igual al indice: --->
				<!--- - No se puede crear un indice igual a una PK o AK --->
				<!--- - Pero si ya existe el índice si se puede crear la PK o AK igual --->
				<!---   Siempre hay que borrar primero PK/AK y preguntar si existe el indice para borrarlo --->
				<cfset LvarColsK = REPLACE(LvarColsI,"-","","ALL")>
				<cfquery name="rsSQL3" dbtype="query">
					SELECT KEYN, TIP
					  FROM rsPKsAKs
					 WHERE COLSK	= '#LvarColsK#'
				</cfquery>
				<cfif rsSQL3.TIP NEQ "">
					<!--- Asigna el Indice a la KEY y no se crea el indice --->
					<cfset LvarTip = rsSQL3.TIP>
					<cfquery datasource="#Arguments.conexion#">
						update #keyDB# 
						   set idx  = <cfqueryparam value="#rsIDX.idx#"		cfsqltype="cf_sql_varchar">
						 where tab  = <cfqueryparam value="#LvarTablaPD#"		cfsqltype="cf_sql_varchar">
						   and cols = <cfqueryparam value="#LvarColsK#"		cfsqltype="cf_sql_varchar">
						   and tip  = <cfqueryparam value="#rsSQL3.TIP#"	cfsqltype="cf_sql_varchar">
						   and keyN = <cfqueryparam value="#rsSQL3.KEYN#"	cfsqltype="cf_sql_varchar">
					</cfquery>
				<cfelse>
					<!--- Se crea el indice como KEY TIPO UI o ID --->
					<cfquery datasource="#Arguments.conexion#">
						insert into #keyDB# (tab, cols, tip, ref, colsR, keyN, idx, clu, keyO)
						values (
							 <cfqueryparam value="#LvarTablaPD#"	cfsqltype="cf_sql_varchar">
							,<cfqueryparam value="#LvarColsI#"		cfsqltype="cf_sql_varchar">
							,<cfqueryparam value="#LvarTIP#"		cfsqltype="cf_sql_varchar">
							,<cfqueryparam value="*"				cfsqltype="cf_sql_varchar">
							,<cfqueryparam value="*"				cfsqltype="cf_sql_varchar">
							,<cfqueryparam value="#rsIDX.idx#"		cfsqltype="cf_sql_varchar">
							,null
							,<cfqueryparam value="#rsIDX.clu#"		cfsqltype="cf_sql_bit">
							,<cfqueryparam value="#GvarObj.fnKeyO(LvarTip)#" cfsqltype="cf_sql_integer">
						)
					</cfquery>
				</cfif>
			</cfloop>
		
			<!--- KEYs FK --->
			<cfquery name="rsSQL" datasource="#Arguments.conexion#">
				SELECT DISTINCT
						'F' as TIP,				<!--- FKs de LvarTablaDB --->
						T.CONSTRAINT_NAME		as KEYN,
						T.TABLE_NAME			as TAB,
						P.TABLE_NAME			as REF,
						T.R_CONSTRAINT_NAME		as REF_KEY
				  FROM ALL_CONSTRAINTS T
					INNER JOIN ALL_CONSTRAINTS P
						 ON P.OWNER 			= T.R_OWNER
						AND P.CONSTRAINT_NAME	= T.R_CONSTRAINT_NAME
				 WHERE	T.OWNER				= '#GvarSchema#'
				   AND 	T.TABLE_NAME		= '#LvarTablaDB#'
				   AND  T.CONSTRAINT_TYPE 	= 'R'
				UNION
				SELECT DISTINCT
						'D' as TIP,				<!--- DEPENDENCIAS: FKs que referencian a LvarTablaDB --->
						T.CONSTRAINT_NAME		as KEYN,
						T.TABLE_NAME			as TAB,
						P.TABLE_NAME			as REF,
						T.R_CONSTRAINT_NAME		as REF_KEY
				  FROM ALL_CONSTRAINTS T
					INNER JOIN ALL_CONSTRAINTS P
						 ON P.OWNER 			= T.R_OWNER
						AND P.CONSTRAINT_NAME	= T.R_CONSTRAINT_NAME
				 WHERE	P.OWNER				= '#GvarSchema#'
				   AND 	P.TABLE_NAME		= '#LvarTablaDB#'
				   AND  T.CONSTRAINT_TYPE 	= 'R'
				ORDER BY 1,3
			</cfquery>

			<cfloop query="rsSQL">
				<cfquery name="rsSQL2" datasource="#Arguments.conexion#">
					SELECT COLUMN_NAME
					  FROM	ALL_CONS_COLUMNS
					 WHERE	OWNER			= '#GvarSchema#'
					   AND  CONSTRAINT_NAME = '#rsSQL.KEYN#'
					ORDER BY POSITION
				</cfquery>
				<cfset LvarCOLSK = valueList(rsSQL2.COLUMN_NAME)>
				<cfquery name="rsSQL2" datasource="#Arguments.conexion#">
					SELECT COLUMN_NAME
					  FROM	ALL_CONS_COLUMNS
					 WHERE	OWNER			= '#GvarSchema#'
					   AND  CONSTRAINT_NAME = '#rsSQL.REF_KEY#'
					ORDER BY POSITION
				</cfquery>
				<cfset LvarCOLSR = valueList(rsSQL2.COLUMN_NAME)>
		
				<cfset LvarTablaFK = rsSQL.TAB>
				<cfif LvarTablaFK EQ LvarTablaDB AND LvarTablaDB NEQ LvarTablaPD>
					<cfset LvarTablaFK = LvarTablaPD>
				</cfif>
				<cfquery datasource="#Arguments.conexion#">
					insert into #keyDB# (tab, cols, tip, ref, colsR, keyN, idx, clu, keyO)
					values (
						 <cfqueryparam value="#LvarTablaFK#"	cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="#LvarCOLSK#"		cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="#rsSQL.tip#"		cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="#rsSQL.ref#"		cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="#LvarCOLSR#"		cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="#rsSQL.keyN#"		cfsqltype="cf_sql_varchar">
						, null, 0, #GvarObj.fnKeyO("F")#
					)
				</cfquery>
			</cfloop>
		</cfif>
	</cfloop>

	<cfif Arguments.TIPO EQ "UPLOAD">
		<cfquery datasource="asp">
			update DBMuploads
			   set stsP  = 0
			     , tabsP = tabs
			 where IDupl = #Arguments.TipoID#
		</cfquery>
	</cfif>
</cffunction>

<cffunction name="sbDropTriggersRepetidos" output="false" returntype="void">
	<cfargument name="conexion" 			required="yes">
	<cfargument name="TIPO" type="string"	required="yes">
	
	<cfquery name="rsSQL" datasource="#Arguments.conexion#">
		SELECT	COUNT(1) as Cantidad
		  FROM	USER_TRIGGERS t
			LEFT JOIN USER_OBJECTS o
				ON OBJECT_NAME = TRIGGER_NAME
		 WHERE	TABLE_OWNER     = '#GvarSchema#'
		   AND 	TABLE_NAME		= '#LvarTablaDB#'
		   AND	TRIGGER_NAME    = '#Arguments.TIPO#_#LvarTablaDB#'
	</cfquery>
	<cfif rsSQL.cantidad NEQ 0>
		<cfset LvarTrigger = "#Arguments.TIPO#_#LvarTablaDB#">
	<cfelse>
		<cfset LvarTrigger = "#rsTriggers.TRIGGER_NAME#">
	</cfif>
	<cfquery name="rsSQL" dbtype="query">
		SELECT	TRIGGER_NAME
		  FROM  rsTriggers
		 WHERE	TRIGGER_NAME    <> '#LvarTrigger#'
	</cfquery>
	<cfloop query="rsSQL">
		<cftry>
			<cfquery datasource="#Arguments.conexion#">
				DROP TRIGGER "#rsSQL.TRIGGER_NAME#"
			</cfquery>
		<cfcatch type="any">
			<cfthrow message="DROP TRIGGER '#rsSQL.TRIGGER_NAME#'">
		</cfcatch>
		</cftry>
	</cfloop>
	<cfquery name="rsTriggers" datasource="#Arguments.conexion#">
		SELECT	TRIGGER_NAME, TRIGGER_BODY, o.STATUS as STATUS_V, t.STATUS as STATUS_E
		  FROM	USER_TRIGGERS t
			LEFT JOIN USER_OBJECTS o
				ON OBJECT_NAME = TRIGGER_NAME
		 WHERE	TABLE_OWNER     = '#GvarSchema#'
		   AND 	TABLE_NAME		= '#LvarTablaDB#'
		   AND	TRIGGER_NAME    like '#Arguments.TIPO#_%'
	</cfquery>
</cffunction>

<!---
'TIPOS DE DATOS:
'   String:
'       char,nchar,varchar,nvarchar,sysname     C=char,V=VarChar         n,1
'   Binarios:
'       binary,varbinary                        B=Binary,VB=VarBinary    n,1
'   LOB:
'       text, image                             CL=CLOB,BL=BLOB         -2
'   Numéricos Entero:
'       biginteger,integer,int,smallint,tinyint I=Integer                20,10,5,3
'   Numéricos Punto Fijo:
'       numeric,decimal,dec                     N=Numeric                n,d
'   Numéricos Punto Flotante:
'       real, float, double precision           F=Float                  7,15,30
'   Numéricos Montos:
'       money,smallmoney                        M=Money                  18,4
'   Logicos:
'       bit                                     L=Logico                 1
'   Fecha:
'       date, datetime, smalldatetime           D=DateTime               0
'   Control de Concurrencia optimístico:
'       timestamp                               TS=Timestamp             0
<!--- Tipos = "C,V,B,VB,CL,BL,I,N,F,M,L,D,TS" --->
--->
<!--- Tipos = "C,V,B,VB,CL,BL,I,N,F,M,L,D,TS" --->
<!--- Tipo = C = Char: Caracter tamaño fijo --->
<!--- Tipo = V = Varchar: Caracter tamaño variable --->
<!--- Tipo = B = Binary: Dato Binario tamaño fijo --->
<!--- Tipo = VB = Varbinary: Dato Binario tamaño variable --->
<!--- Tipo = CL = CLOB: Objeto caracter de 2GB --->
<!--- Tipo = BL = BLOB: Objeto binario de 2GB --->
<!--- Tipo = I = Integer: Número entero --->
<!--- Tipo = N = Numeric: Número con cantidad de decimales fijo --->
<!--- Tipo = F = Float: Número con punto flotante --->
<!--- Tipo = M = Money: Número para almacenar montos con 4 decimales --->
<!--- Tipo = L = Logic: Número que sólo permite 1=true, 0=false --->
<!--- Tipo = D = Datetime: Fecha que almacena Fecha y Hora --->
<!--- Tipo = TS = Timestamp: Dato autogenerado cada vez que se actualiza un registro --->
<!--- Tipo = ** = Tipo de dato no soportado --->
<cffunction name="ColumnTypeFromORACLE" returntype="struct" output="no">
	<cfargument name="COL">
	<cfargument name="TS">
	<cfargument name="TIP_BD">
	<cfargument name="LON">
	<cfargument name="DECs">
	<!--- Tipos = "C,V,B,VB,CL,BL,I,N,F,M,L,D,TS" --->
	<cfset LvarTYPE = Arguments>
	<cfset LvarTYPE.TIP = "">
	<cfif listFind("CHAR,NCHAR",LvarTYPE.TIP_BD)>
		<!--- Tipo = C = Char: Caracter tamaño fijo --->
		<cfif left(LvarTYPE.TIP_BD,1) EQ "N">
			<cfset LvarTYPE.LON		= "#numberFormat(int(LvarTYPE.LON / 2),"0")#">
		</cfif>
		<cfset LvarTYPE.DECs = "0">
		<cfset LvarTYPE.TIP	 = "C">
	<cfelseif listFind("VARCHAR2,NVARCHAR2",LvarTYPE.TIP_BD)>
		<!--- Tipo = V = Varchar: Caracter tamaño variable --->
		<cfif left(LvarTYPE.TIP_BD,1) EQ "N">
			<cfset LvarTYPE.LON		= "#numberFormat(int(LvarTYPE.LON / 2),"0")#">
		</cfif>
		<cfset LvarTYPE.DECs = "0">
		<cfset LvarTYPE.TIP	 = "V">
	<cfelseif LvarTYPE.TIP_BD EQ "RAW">
		<!--- Tipo = B = Binary: Dato Binario tamaño fijo --->
		<!--- Tipo = VB = Varbinary: Dato Binario tamaño variable --->
		<cfset LvarTYPE.DECs = "0">
		<cfset LvarTYPE.TIP	 = "VB">
	<cfelseif listFind("CLOB,NCLOB,LONG VARCHAR,LONG",LvarTYPE.TIP_BD)>
		<!--- Tipo = CL = CLOB: Objeto caracter de 2GB --->
		<cfif find("LONG",LvarTYPE.TIP_BD)>
			<cfset LvarTYPE.LON		= "-1">
		<cfelse>
			<cfset LvarTYPE.LON		= "-2">
		</cfif>
		<cfset LvarTYPE.DECs	= "0">
		<cfset LvarTYPE.LON		= "-2">
		<cfset LvarTYPE.TIP	= "CL">
	<cfelseif listFind("BLOB,LONG RAW",LvarTYPE.TIP_BD)>
		<!--- Tipo = BL = BLOB: Objeto binario de 2GB --->
		<cfif find("LONG",LvarTYPE.TIP_BD)>
			<cfset LvarTYPE.LON		= "-1">
		<cfelse>
			<cfset LvarTYPE.LON		= "-2">
		</cfif>
		<cfset LvarTYPE.DECs	= "0">
		<cfset LvarTYPE.TIP	= "BL">
	<cfelseif LvarTYPE.TIP_BD EQ "NUMBER">
		<!--- Tipo = I = Integer: Número entero --->
		<!--- Tipo = N = Numeric: Número con cantidad de decimales fijo --->
		<cfif LvarTYPE.DECs EQ "">
			<cfset LvarTYPE.DECs= "0">
		</cfif>
		<cfset LvarTYPE.TIP	= "N">
	<cfelseif LvarTYPE.TIP_BD EQ "FLOAT">
		<!--- Tipo = F = Float: Número con punto flotante --->
		<cfset LvarTYPE.LON		= "#numberFormat(int(LvarTYPE.LON*LOG10(2)))#">
		<cfset LvarTYPE.DECs	= "0">
		<cfset LvarTYPE.TIP	= "F">
	<cfelseif LvarTYPE.TIP_BD EQ "DATE">
		<!--- Tipo = D = Datetime: Fecha que almacena Fecha y Hora --->
		<cfset LvarTYPE.DECs	= "0">
		<cfset LvarTYPE.LON		= "0">
		<cfset LvarTYPE.TIP	= "D">
	<cfelseif LvarTYPE.TIP_BD EQ "TIMESTAMP">
		<!--- Tipo = TS = Timestamp: Dato autogenerado cada vez que se actualiza un registro --->
		<cfset LvarTYPE.DECs	= "0">
		<cfset LvarTYPE.LON		= "0">
		<cfif LvarTYPE.COL EQ "TS_RVERSION" AND LvarTYPE.TS>
			<cfset LvarTYPE.TIP	= "TS">
		<cfelse>
			<!--- Tipo = D3 = Timestamp: Fecha que almacena tanto Fecha como Hora como milisegundos pero no es standard --->
			<cfset LvarTYPE.TIP	= "D3">
		</cfif>
	<cfelse>
		<!--- Tipo = ** = Tipo de dato no soportado --->
		<cfset LvarTYPE.TIP = "?">
	</cfif>
	<cfreturn LvarTYPE>
</cffunction>

<!---
	***********************************************
	GENERAR LA NUEVA ESTRUCTURA EN LA BASE DE DATOS
	***********************************************
--->
<cffunction name="CrearObjetosEspeciales" access="package" output="false" returntype="string">
	<cfargument name="conexion" required="yes">
	<cfargument name="forScript" default="no">

	<cfif forScript>
		<cfset OracleLF = vbCrLf>
		<cfset LvarScript = "">
	<cfelse>
		<cfset OracleLF = chr(10)><!--- no se porqué no funciona con el 13+10 Danim --->
	</cfif>

	<!--- TABLA DUAL --->
	<cfif forScript>
		<cfset LvarScript &= "/* IF X GT 0:SELECT count(1) as X FROM ALL_TABLES WHERE OWNER=USER AND TABLE_NAME='DUAL' */#vbCrLf#">
		<cfset LvarScript &= "DROP TABLE DUAL#EXEC#">
	<cfelse>
		<cfquery name="rsSQL" datasource="#arguments.conexion#">
			SELECT count(1) as X FROM ALL_TABLES WHERE OWNER=USER AND TABLE_NAME='DUAL'
		</cfquery>
		<cfif rsSQL.X GT 0>
			<cfquery datasource="#arguments.conexion#">
				DROP TABLE DUAL
			</cfquery>
		</cfif>
	</cfif>

	<!--- FUNCTION regexp_instr: no existe antes de Oracle10g --->
	<cftry>
		<cfquery name="rsSQL" datasource="#arguments.conexion#">
			SELECT count(1) as X FROM ALL_TABLES WHERE OWNER=USER AND TABLE_NAME='DUAL' AND regexp_instr(TABLE_NAME,'[^DUAL]')>0
		</cfquery>
	<cfcatch type="any">
		<cfsavecontent variable="LvarSQL">
		<cfoutput>
		CREATE OR REPLACE FUNCTION regexp_instr(vString varchar2,vChars varchar2) RETURN NUMBER 
		as
		  vLength number(4);
		  vChars2 varchar2(4000);
		  vPos number(4);
		  vIgnore number(2);
		BEGIN
		  vLength:=length(vChars);
		  IF (substr(vChars,1,1) <> '[') THEN
			raise_application_error(-20001,'Antes de V.10G solo se permite [...]');
		  END IF;
		  IF (substr(vChars,vLength,1) <> ']') THEN
			raise_application_error(-20001,'Antes de V.10G solo se permite [...]');
		  END IF;
		  /* PROCESA LOS GUIONES = RANGO DE CARACTERES */
		  vPos:=instr(vChars,'-');
		  vIgnore := 0;
		  IF (vPos > 0) THEN
			vChars2:='';
			IF ((substr(vChars,2,1) <> '^' AND vPos = 2) OR (substr(vChars,2,1) = '^' AND vPos = 3)) THEN
				vChars2:=vChars2 || '-';
				vPos:=instr(vChars,'-',vPos+2);
			END IF;
			For i in 2..vLength-1 loop
				IF (vPos = vLength-1) THEN
					vChars2:=vChars2 || '-';
				ELSIF (i = vPos - 1) THEN
					IF (substr(vChars,vPos-1,1) <= substr(vChars,vPos+1,1)) THEN
						For j in ASCII(substr(vChars,vPos-1,1))..ASCII(substr(vChars,vPos+1,1)) loop
							vChars2:=vChars2 || chr(j);
						end loop;
					END IF;
					vIgnore := 3;
					vPos:=instr(vChars,'-',vPos+3);
				END IF;
				IF (vIgnore > 0) THEN
					vIgnore := vIgnore - 1;
				ELSIF ((i <> 2 AND substr(vChars,i,1) = '^') OR i>2) THEN
					vChars2:=vChars2 || substr(vChars,i,1);
				END IF;
			end loop;
		  ELSIF (substr(vChars,2,1) <> '^') THEN
			vChars2:=substr(vChars,2,vLength-2);
		  ELSE
			vChars2:=substr(vChars,3,vLength-3);
		  END IF;
		  IF (vChars2 IS NULL) THEN
			return 0;
		  END IF;
		  IF (substr(vChars,2,1) <> '^') THEN
			vLength:=length(vChars2);
			For i in 1..vLength loop
			  if (INSTR(vString,substr(vChars2,i,1)) > 0) THEN
				return i;
			  end if;
			end loop;
			return 0;
		  ELSE
			vLength:=length(vString);
			For i in 1..vLength loop
			  if (INSTR(vChars2,substr(vString,i,1)) = 0) THEN
				return i;
			  end if;
			end loop;
			return 0;
		  END IF;
		exception
		  when others then
			raise_application_error('-20000',sqlerrm);
		end;
		</cfoutput>
		</cfsavecontent>
		<cfset LvarSQL = replace(LvarSQL,chr(13),"","ALL")>
		<cfif forScript>
			<cfset LvarScript &= LvarSQL & EXEC>
		<cfelse>
			<cfquery datasource="#arguments.conexion#">
				#preserveSingleQuotes(LvarSQL)#
			</cfquery>
		</cfif>
	</cfcatch>
	</cftry>

	<!--- FUNCTION BtoC_LOB --->
	<cfset LvarSQL = 
				"#OracleLF#CREATE OR REPLACE FUNCTION BtoC_LOB#OracleLF#" &
				"(src_Blob IN BLOB)#OracleLF#" &
				"RETURN CLOB#OracleLF#" &
				"IS#OracleLF#" &
				"	dst_Clob CLOB;#OracleLF#" &
				"	Buffer raw(32767);#OracleLF#" &
				"	Amount BINARY_INTEGER := 32767;#OracleLF#" &
				"	Position INTEGER := 1;#OracleLF#" &
				"BEGIN#OracleLF#" &
				"	dst_Clob := '';#OracleLF#" &
				"	LOOP#OracleLF#" &
				"		DBMS_LOB.READ  (src_Blob, Amount, Position, Buffer);#OracleLF#" &
				"		dst_Clob := dst_Clob || UTL_RAW.CAST_TO_VARCHAR2(Buffer);#OracleLF#" &
				"#OracleLF#" &
				"		Position := Position + Amount;#OracleLF#" &
				"	END LOOP;#OracleLF#" &
				"	RETURN (dst_Clob);#OracleLF#" &
				"EXCEPTION#OracleLF#" &
				"	WHEN NO_DATA_FOUND THEN#OracleLF#" &
				"		RETURN (dst_Clob);#OracleLF#" &
				"END;#OracleLF#"
	>
	<cfif forScript>
		<cfset LvarScript &= LvarSQL & EXEC>
	<cfelse>
		<cfquery datasource="#arguments.conexion#">
			#preserveSingleQuotes(LvarSQL)#
		</cfquery>
	</cfif>

	<!--- FUNCTION CtoB_LOB --->
	<cfset LvarSQL = 
				"#OracleLF#CREATE OR REPLACE FUNCTION CtoB_LOB#OracleLF#" &
				"(src_Clob IN CLOB) #OracleLF#" &
				"RETURN BLOB#OracleLF#" &
				"IS#OracleLF#" &
				"	dst_Blob BLOB;#OracleLF#" &
				"	Buffer VARCHAR2(32767);#OracleLF#" &
				"	Amount BINARY_INTEGER := 32767;#OracleLF#" &
				"	Position INTEGER := 1;#OracleLF#" &
				"BEGIN#OracleLF#" &
				"	DBMS_LOB.createTemporary (dst_Blob, true);#OracleLF#" &
				"	DBMS_LOB.open (dst_Blob, DBMS_LOB.LOB_READWRITE);#OracleLF#" &
				"	LOOP#OracleLF#" &
				"		DBMS_LOB.READ  (src_Clob, Amount, Position, Buffer);#OracleLF#" &
				"		DBMS_LOB.APPEND (dst_Blob, UTL_RAW.CAST_TO_RAW(Buffer));#OracleLF#" &
				"		Position := Position + Amount;#OracleLF#" &
				"	END LOOP;#OracleLF#" &
				"	DBMS_LOB.CLOSE (dst_Blob);#OracleLF#" &
				"	RETURN (dst_Blob);#OracleLF#" &
				"EXCEPTION#OracleLF#" &
				"	WHEN NO_DATA_FOUND THEN#OracleLF#" &
				"		DBMS_LOB.CLOSE (dst_Blob);#OracleLF#" &
				"		RETURN (dst_Blob);#OracleLF#" &
				"END;#OracleLF#"
	>
	<cfif forScript>
		<cfset LvarScript &= LvarSQL & EXEC>
	<cfelse>
		<cfquery datasource="#arguments.conexion#">
			#preserveSingleQuotes(LvarSQL)#
		</cfquery>
	</cfif>

	<!--- PACKAGE SOINPK --->
	<cfquery name="rsSQL" datasource="#arguments.conexion#">
		SELECT count(1) as Cantidad
		FROM   dba_objects
		WHERE  owner = 'ASP'
		  AND  object_name = 'SOINPK'
		  AND  status = 'VALID'
	</cfquery>
	
	<cfif rsSQL.cantidad NEQ 2>
		<cfset LvarSQL = 
					"#OracleLF#CREATE OR REPLACE PACKAGE SOINPK AS#OracleLF#" &
					"LASTIDENTITY NUMBER :=0;#OracleLF#" &
					"IDENTITYOFF INT :=0;#OracleLF#" &
					"function IDENTITY return NUMBER;#OracleLF#" &
					"procedure SET_IDENTITY_INSERT_OFF;#OracleLF#" &
					"procedure SET_IDENTITY_INSERT_ON;#OracleLF#" &
					"end SOINPK;#OracleLF#"
		>
		<cfif forScript>
			<cfset LvarScript &= LvarSQL & EXEC>
		<cfelse>
			<cfquery datasource="#arguments.conexion#">
				#preserveSingleQuotes(LvarSQL)#
			</cfquery>
		</cfif>
	
		<!--- PACKAGE BODY SOINPK --->
		<cfset LvarSQL = 
					"#OracleLF#CREATE OR REPLACE PACKAGE BODY SOINPK as#OracleLF#" &
					"   function IDENTITY return NUMBER as#OracleLF#" &
					"   begin#OracleLF#" &
					"     RETURN LASTIDENTITY;#OracleLF#" &
					"   end;#OracleLF#" &
					"   procedure SET_IDENTITY_INSERT_OFF as#OracleLF#" &
					"   begin#OracleLF#" &
					"     IDENTITYOFF := 0;#OracleLF#" &
					"   end;#OracleLF#" &
					"   procedure SET_IDENTITY_INSERT_ON as#OracleLF#" &
					"   begin#OracleLF#" &
					"     IDENTITYOFF := 1;#OracleLF#" &
					"   end;#OracleLF#" &
					"end SOINPK;#OracleLF#"
		>
		<cfif forScript>
			<cfset LvarScript &= LvarSQL & EXEC>
		<cfelse>
			<cfquery datasource="#arguments.conexion#">
				#preserveSingleQuotes(LvarSQL)#
			</cfquery>
		</cfif>
	</cfif>
	
	<!--- FUNCTION: right() --->
	<cfset LvarSQL = 
				"#OracleLF#CREATE OR REPLACE FUNCTION RIGHT (vString varchar2, vLength number) return varchar2 as#OracleLF#" &
				"BEGIN#OracleLF#" &
				"   if vLength<=length(vString) then#OracleLF#" &
				"      return substr(vString,-vLength);#OracleLF#" &
				"   else#OracleLF#" &
				"      return vString;#OracleLF#" &
				"   end if;#OracleLF#" &
				"EXCEPTION#OracleLF#" &
				"   when others then#OracleLF#" &
				"      raise_application_error('-20000',sqlerrm);#OracleLF#" &
				"END;#OracleLF#"
	>
	<cfif forScript>
		<cfset LvarScript &= LvarSQL & EXEC>
	<cfelse>
		<cfquery datasource="#arguments.conexion#">
			#preserveSingleQuotes(LvarSQL)#
		</cfquery>
	</cfif>

	<!--- FUNCTION: left() --->
	<cfset LvarSQL = 
				"#OracleLF#CREATE OR REPLACE FUNCTION LEFT (vString varchar2, vLength number) return varchar2 as#OracleLF#" &
				"BEGIN#OracleLF#" &
				"   return substr(vString,1,vLength);#OracleLF#" &
				"EXCEPTION#OracleLF#" &
				"   when others then#OracleLF#" &
				"      raise_application_error('-20000',sqlerrm);#OracleLF#" &
				"END;#OracleLF#"
	>
	<cfif forScript>
		<cfset LvarScript &= LvarSQL & EXEC>
	<cfelse>
		<cfquery datasource="#arguments.conexion#">
			#preserveSingleQuotes(LvarSQL)#
		</cfquery>
	</cfif>

	<cfif forScript>
		<cfreturn LvarScript>
	</cfif>
</cffunction>

<cffunction name="sbSetTabPrefijo" access="package" output="false" returntype="void">
<!--- Prefijo para: PK, AK, UI, ID, FK, CK, TIB, TUTS, S_ --->
	<cfargument name="tab"		required="yes">
	<cfargument name="suf13"	required="yes">
	<cfargument name="suf25"	required="yes">
	
	<cfset GvarTabPrefijo = rtrim(Arguments.tab)>
	<cfif Arguments.suf25 NEQ "0">
		<cfset GvarTabPrefijo = mid(tab,1,23) & numberFormat(Arguments.suf25,"00")>
	</cfif>
</cffunction>

<cffunction name="sbGetPDPrefijo" access="package" output="false" returntype="void">
	<cfreturn "case when t.suf25>0 then left(t.tab,23) || right('00' || to_char(t.suf25),2) else t.tab end">
</cffunction>

<cffunction name="fnGenAddTable" access="" output="false" returntype="string">
	<cfargument name="conexion" required="yes">
	<cfargument name="tabla" required="yes">
<!---
	CREATE TABLE tabla ( 
						col TIPO_DE_DATOS(lon,dec)
							DEFAULT dfl
							NOT NULL
							CONSTRAINT CK1_tabla CHECK (col IS NULL OR ( col IN ('val1','val2') ))
						, ...
						)
--->
	<cfquery name="rsSQL" datasource="#arguments.conexion#">
		select
			p.tab as tab,
			p.col as col, p.sec,
			p.des as des,
			p.tip as tip,
			p.lon as lon,
			p.dec as dec,
			p.ide as ide,
			p.obl as obl,
			rtrim(p.dfl) as dfl,
			p.rul as rul,
			p.lov
		  from #colPD# p
		 where tab = '#Arguments.tabla#'
		order by sec
	</cfquery>

	<cfset Lvar_CREATE = vbCrLf & "CREATE TABLE #Arguments.tabla# (">
	<cfset LvarSpaces = repeatString(" ",31)>
	<cfset LvarComma = " ">
	<cfset LvarIdentity		= "">
	<!--- CREA CAMPOS --->
	<cfloop query="rsSQL">
		<cfset LvarCol = fnGenColumn (rsSQL.tab, rsSQL.col, rsSQL.tip, rsSQL.lon, rsSQL.dec, rsSQL.obl, rsSQL.dfl, rsSQL.lov)>
		<cfset Lvar_CREATE = Lvar_CREATE & vbCrLf & vbTab & LvarComma & left(rsSQL.col & LvarSpaces,31) & left(LvarCol.SQLtip & LvarSpaces, 20)>
		<cfset LvarComma = ",">
		<cfif rsSQL.ide EQ "1">
			<cfset LvarIdentity = rsSQL.col>
			<cfset Lvar_CREATE = Lvar_CREATE & " NOT NULL">
		<cfelse>
			<cfset Lvar_CREATE = Lvar_CREATE & LvarCol.SQLdfl & LvarCol.SQLnul>
			<cfif (rsSQL.rul NEQ "")>
				<cfset Lvar_CREATE = Lvar_CREATE & vbCrLf & vbTab & " CONSTRAINT #GvarObj.fnGetName(GvarTabPrefijo,"CK",rsSQL.sec)# CHECK (#rsSQL.rul#)">
			</cfif>
		</cfif>
	</cfloop>

	<cfset Lvar_CREATE = Lvar_CREATE & vbCrLf & vbTab & ")#EXEC#">

	<cfreturn Lvar_CREATE>
</cffunction>

<cffunction name="fnGenAddCheck" output="false" returntype="string">
	<cfargument name="tabla">
	<cfargument name="rule">

	<cfset Lvar_CHECK = "ALTER TABLE #Arguments.Tabla# ADD CONSTRAINT #GvarTabPrefijo#_CK CHECK (#arguments.rule#)#EXEC#">
	<cfreturn Lvar_CHECK>
</cffunction>

<cffunction name="fnGenDelKey" output="false" returntype="string">
	<cfargument name="tab">
	<cfargument name="tip">
	<cfargument name="key">
	<cfargument name="idx">
	<cfargument name="cols">
	<cfargument name="ref">
	<cfargument name="colsR">
	<cfargument name="idxTip">
	<cfargument name="FKs">

	<cfset Lvar_CREATE = "">
	<cfif Arguments.tip EQ "P">
		<cfset Lvar_CREATE = "ALTER TABLE #Arguments.tab# DROP CONSTRAINT #Arguments.key#">
		<cfset Lvar_CREATE = Lvar_CREATE & " /* PRIMARY KEY (#Arguments.cols#) */#EXEC#">
	<cfelseif Arguments.tip EQ "A">
		<cfset Lvar_CREATE = "ALTER TABLE #Arguments.tab# DROP CONSTRAINT #Arguments.key#">
		<cfset Lvar_CREATE = Lvar_CREATE & " /* UNIQUE KEY (#Arguments.cols#) */#EXEC#">
	<cfelseif Arguments.tip EQ "U">
		<cfset Lvar_CREATE = "DROP INDEX #Arguments.key#">
		<cfset Lvar_CREATE = Lvar_CREATE & " /* UNIQUE INDEX (#Arguments.cols#) */#EXEC#">
	<cfelseif Arguments.tip EQ "I">
		<cfset Lvar_CREATE = "DROP INDEX #Arguments.key#">
		<cfset Lvar_CREATE = Lvar_CREATE & " /* INDEX (#Arguments.cols#) */#EXEC#">
	<cfelseif Arguments.tip EQ "F" or Arguments.tip EQ "D">
		<cfif FKs>
			<cfset Lvar_CREATE = "ALTER TABLE #Arguments.tab# DROP CONSTRAINT #Arguments.key#">
			<cfset Lvar_CREATE = Lvar_CREATE & " /* REFERENCES #Arguments.ref# (#Arguments.colsR#) */#EXEC#">
		<cfelseif trim(Arguments.idx) NEQ "">
			<!--- FK: Si existe indice hay que borrarlo --->
			<cfset Lvar_CREATE = "DROP INDEX #Arguments.idx# /* REFERENCES INDEX (#Arguments.colsR#) */#EXEC#">
		</cfif>
	</cfif>

	<cfif listFind("P,A",Arguments.tip)>
		<!--- Si se creo un indice igual antes que el CONSTRAINT hay que borrar el indice porque puede permanecer --->
		<cfif Arguments.idx NEQ "">
			<cfset LvarIDX = Arguments.idx>
		<cfelse>
			<cfset LvarIDX = Arguments.key>
		</cfif>
		<cfset Lvar_CREATE &= "/* IF X GT 0:SELECT count(1) as X FROM ALL_INDEXES WHERE TABLE_OWNER = '#GvarSchema#' AND TABLE_NAME = '#Arguments.tab#' AND INDEX_NAME = '#LvarIDX#' */#vbCrLf#">
		<cfset Lvar_CREATE &= "DROP INDEX #LvarIDX##EXEC#">
	</cfif>

	<cfreturn Lvar_CREATE & vbCrLf>
</cffunction>

<cffunction name="fnGenAddKey" output="no" returntype="string">
	<cfargument name="tab">
	<cfargument name="tip">
	<cfargument name="cols">
	<cfargument name="ref">
	<cfargument name="colsR">
	<cfargument name="sec">
	<cfargument name="clu">
	<cfargument name="idxTip">
	<cfargument name="FKs">

	<cfset Lvar_CREATE = "">
	<cfif Arguments.tip EQ "P">
		<cfset Lvar_CREATE = "ALTER TABLE #Arguments.tab# ADD CONSTRAINT #GvarTabPrefijo#_PK PRIMARY KEY (#Arguments.cols#)#EXEC#">
	<cfelseif Arguments.tip eq "A">
		<cfset Lvar_CREATE = "ALTER TABLE #Arguments.tab# ADD CONSTRAINT #GvarObj.fnGetName(GvarTabPrefijo,"AK",sec)# UNIQUE (#Arguments.cols#)#EXEC#">
	<cfelseif Arguments.tip eq "U">
		<cfset Lvar_CREATE = "CREATE UNIQUE INDEX #GvarObj.fnGetName(GvarTabPrefijo,"UI",sec)# ON #Arguments.tab# (#Arguments.cols#)#EXEC#">
	<cfelseif Arguments.tip eq "I">
		<cfset Lvar_CREATE = "CREATE INDEX #GvarObj.fnGetName(GvarTabPrefijo,"ID",sec)# ON #Arguments.tab# (#Arguments.cols#)#EXEC#">
	<cfelseif Arguments.tip eq "F">
		<cfif FKs>
			<cfset Lvar_CREATE = "ALTER TABLE #Arguments.tab# ADD CONSTRAINT #GvarObj.fnGetName(GvarTabPrefijo,"FK",sec)# FOREIGN KEY (#Arguments.cols#) REFERENCES #ref# (#Arguments.colsR#)#EXEC#">
		<cfelseif idxTip EQ "+">
			<cfset Lvar_CREATE = "CREATE INDEX #GvarObj.fnGetName(GvarTabPrefijo,"FI",sec)# ON #Arguments.tab# (#Arguments.cols#)#EXEC#">
		</cfif>
	</cfif>
	<cfreturn Lvar_CREATE & vbCrLf>
</cffunction>

<!--- Objetos (PK,AK,FK,UI,FI,ID) a renombrar porque su nombre está en otra tabla --->
<cffunction name="sbRenameObjs"  access="package" output="no" returntype="void">
	<cfargument name="conexion" required="yes">
	<cfargument name="CNSTs" required="yes">
	<cfargument name="INDXs" required="yes">
	<cfargument name="IDren" required="yes">

	<!--- Valida los Constraints definidos en DBM --->
		<!--- En los Constraints de base de datos de otra tabla --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into DBMrenames (owner, sch, tab, old, tip, fecha, sts)
			SELECT 	c.tab, '#GvarSchema#', TABLE_NAME, CONSTRAINT_NAME, 
					case 
						when o.CONSTRAINT_TYPE = 'P' then 'PK'
						when o.CONSTRAINT_TYPE = 'U' then 'AK'
						when o.CONSTRAINT_TYPE = 'R' then 'FK'
						when o.CONSTRAINT_TYPE = 'C' then 'CK'
					end, 
					<cf_dbfunction name="today">, 0
			  FROM ALL_CONSTRAINTS o, #preserveSingleQuotes(Arguments.CNSTs)# c
			 WHERE OWNER			= '#GvarSchema#'
			   AND CONSTRAINT_NAME	= c.obj_name
			   AND TABLE_NAME		<> c.tab
			   AND o.CONSTRAINT_TYPE NOT IN ('V','O')
		</cfquery>
		<!--- En los Indices de base de datos de cualquier tabla --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into DBMrenames (owner, sch, tab, old, tip, fecha, sts)
			SELECT 	c.tab, '#GvarSchema#', TABLE_NAME, INDEX_NAME, 
					CASE WHEN INSTR(UNIQUENESS,'NONUNIQUE') > 0 then 'ID' else 'UI' END,
					<cf_dbfunction name="today">, 0
			  FROM ALL_INDEXES o, #preserveSingleQuotes(Arguments.CNSTs)# c
			 WHERE TABLE_OWNER	= '#GvarSchema#'
			   AND INDEX_NAME 	= c.obj_name
		</cfquery>
	<!--- Valida los Indices definidos en DBM --->
		<!--- En los Constraints de base de datos de CUALQUIER tabla --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into DBMrenames (owner, sch, tab, old, tip, fecha, sts)
			SELECT 	c.tab, '#GvarSchema#', TABLE_NAME, CONSTRAINT_NAME, 
					case 
						when o.CONSTRAINT_TYPE = 'P' then 'PK'
						when o.CONSTRAINT_TYPE = 'U' then 'AK'
						when o.CONSTRAINT_TYPE = 'R' then 'FK'
						when o.CONSTRAINT_TYPE = 'C' then 'CK'
					end, 
					<cf_dbfunction name="today">, 0
			  FROM ALL_CONSTRAINTS o, #preserveSingleQuotes(Arguments.INDXs)# c
			 WHERE OWNER			= '#GvarSchema#'
			   AND CONSTRAINT_NAME	= c.obj_name
			   AND o.CONSTRAINT_TYPE NOT IN ('V','O')
		</cfquery>
		<!--- En los Indices de base de datos de OTRAS tabla --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into DBMrenames (owner, sch, tab, old, tip, fecha, sts)
			SELECT 	c.tab, '#GvarSchema#', TABLE_NAME, INDEX_NAME, 
					CASE WHEN INSTR(UNIQUENESS,'NONUNIQUE') > 0 then 'ID' else 'UI' END,
					<cf_dbfunction name="today">, 0
			  FROM ALL_INDEXES o, #preserveSingleQuotes(Arguments.INDXs)# c
			 WHERE TABLE_OWNER	= '#GvarSchema#'
			   AND INDEX_NAME 	= c.obj_name
			   AND TABLE_NAME	<> c.tab
		</cfquery>
	<!--- Renombra los objetos encontrados --->
	<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
		select IDren, sch, tab, old, tip, fecha, sts
		  from DBMrenames
		 where IDren > #Arguments.IDren#
		   and sts = 0
	</cfquery>
	<cfloop query="rsSQL">
		<cfif right(rsSQL.tip,1) EQ "K">
			<cfquery datasource="#Arguments.Conexion#">
				ALTER TABLE #rsSQL.tab# RENAME CONSTRAINT "#trim(rsSQL.old)#" TO DBMREN_#rsSQL.tip##rsSQL.IDren#
			</cfquery>
		<cfelse>
			<cfquery datasource="#Arguments.Conexion#">
				ALTER INDEX "#trim(rsSQL.old)#" RENAME TO DBMREN_#rsSQL.tip##rsSQL.IDren#
			</cfquery>
		</cfif>
		<cfquery datasource="#Arguments.Conexion#">
			update DBMrenames
			   set sts = 1
			 WHERE IDren = #rsSQL.IDren#
		</cfquery>
	</cfloop>
</cffunction>

<cffunction name="fnGenRename" access="package" output="false" returntype="string">
	<cfargument name="OLDNEW" required="yes">
	<cfargument name="tab" required="yes">
	<cfargument name="tipo" required="yes">
	<cfargument name="oldName" required="yes">
	<cfargument name="newName" required="yes">

	<cfset LvarSQL_RENAME = "">
	<cfif Arguments.oldName NEQ Arguments.newName>
		<cfif find("INDEX",Arguments.tipo)>
			<cfset LvarSQL_RENAME = "ALTER INDEX ""#trim(Arguments.oldName)#"" RENAME TO #Arguments.newName##EXEC#">
		<cfelse>
			<cfset LvarSQL_RENAME = "ALTER TABLE #Arguments.tab# RENAME CONSTRAINT ""#trim(Arguments.oldName)#"" TO #Arguments.newName##EXEC#">
		</cfif>
	</cfif>
	<cfreturn LvarSQL_RENAME>
</cffunction>

<cffunction name="fnGenDelTable" output="false" returntype="string">
	<cfargument name="tabla">

	<cfset Lvar_CHECK = "DROP TABLE #Arguments.Tabla##EXEC#">
	<cfreturn Lvar_CHECK>
</cffunction>

<cffunction name="fnGenDelColumn" output="false" returntype="string">
	<cfargument name="tabla">
	<cfargument name="col">
	<cfargument name="chkN">

	<cfset Lvar_DROP = "">
	<cfif Arguments.chkN NEQ "">
		<cfset Lvar_DROP &= "ALTER TABLE #Arguments.Tabla# DROP CONSTRAINT ""#Arguments.chkN#""#EXEC#">
	</cfif>
	<cfset Lvar_DROP &= "ALTER TABLE #Arguments.Tabla# DROP COLUMN #Arguments.Col##EXEC#">
	<cfreturn Lvar_DROP>
</cffunction>

<cffunction name="fnGenRenTab" output="false" returntype="string">
	<cfargument name="tabOld">
	<cfargument name="tabNew">

	<cfset Lvar_RENAME = "ALTER TABLE ""#Arguments.tabOld#"" RENAME TO #Arguments.tabNew##EXEC#">

	<cfreturn Lvar_RENAME>
</cffunction>

<cffunction name="fnGenDelCheck" output="false" returntype="string">
	<cfargument name="tabla">
	<cfargument name="check">
	<cfargument name="rule">

	<cfset Lvar_CHECK = "ALTER TABLE #Arguments.Tabla# DROP CONSTRAINT #Arguments.Check##EXEC#">
	<cfreturn Lvar_CHECK>
</cffunction>

<cffunction name="fnGenIniTable" access="package" output="false" returntype="string">
	<cfargument name="conexion" required="yes">
	<cfargument name="tab"		required="yes">

	<cfquery name="rsSQL" datasource="#Arguments.conexion#">
		select tib,seq,tuts
		  from #tabDB#
		 where tab = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.tab#">
	</cfquery>
	<cfset GvarTabTriggers.tib  = rsSQL.tib>
	<cfset GvarTabTriggers.seq  = rsSQL.seq>
	<cfset GvarTabTriggers.tuts = rsSQL.tuts>

	<cfquery name="rsSQL" datasource="#Arguments.conexion#">
		select col, tip, lon, dec, obl
		  from #colPD#
		 where tab = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.tab#">
		   and ide = 1
		   and OP not in (4,7)
	</cfquery>
	<cfset GvarTabTriggers.colIde  = rsSQL.col>
	<cfset LvarIdeTip = rsSQL.tip>
	<cfset LvarIdeLon = rsSQL.lon>
	<cfset LvarIdeDec = rsSQL.dec>
	<cfset LvarIdeObl = rsSQL.obl>
	
	<cfquery name="rsSQL" datasource="#Arguments.conexion#">
		select col
		  from #colPD#
		 where tab = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.tab#">
		   and tip = 'TS'
		   and OP not in (4,7)
	</cfquery>
	<cfset GvarTabTriggers.colTS  = rsSQL.col>

	<cfset Lvar_INI = "">
	<cfset Lvar_NoTib = (GvarTabTriggers.tib EQ "")>
	<!--- BORRA TRIGGER PARA CONTROL DE IDENTITY --->
	<cfif FIND(":INVALID", GvarTabTriggers.tib) OR (GvarTabTriggers.tib NEQ "" AND (GvarTabTriggers.tib NEQ "TIB_#GvarTabPrefijo#" OR GvarTabTriggers.colIde EQ "") )>
		<cfset Lvar_INI	&= "/* ELIMINA TRIGGER #GvarTabTriggers.tib# */#vbCrLf#">
		<cfset GvarTabTriggers.tib = REPLACE(GvarTabTriggers.tib,":INVALID","")>
		<cfset Lvar_INI &= 'DROP TRIGGER "#GvarTabTriggers.tib#"#EXEC#'>
		<cfset GvarTabTriggers.tib = "">
	</cfif>
	<!--- BORRA TRIGGER PARA CONTROL CONCURRENCIA --->
	<cfif FIND(":INVALID", GvarTabTriggers.tuts) OR (GvarTabTriggers.tuts NEQ "" AND (GvarTabTriggers.tuts NEQ "TUTS_#GvarTabPrefijo#" OR GvarTabTriggers.colTS EQ "") )>
		<cfset Lvar_INI	&= "/* ELIMINA TRIGGER #GvarTabTriggers.tuts# */#vbCrLf#">
		<cfset GvarTabTriggers.tuts = REPLACE(GvarTabTriggers.tuts,":INVALID","")>
		<cfset Lvar_INI &= 'DROP TRIGGER "#GvarTabTriggers.tuts#"#EXEC#'>
		<cfset GvarTabTriggers.tuts = "">
	</cfif>

	<!--- CREA SECUENCIA PARA CONTROL DE IDENTITY --->
	<cfset GvarTabTriggers.newSeq = false>
	<cfif GvarTabTriggers.colIde NEQ "">
		<cfif GvarTabTriggers.seq EQ "" or Lvar_NoTib>
			<cfset LvarUltimo = "">
			<cfset GvarTabTriggers.newSeq = true>
			<!--- 
				Si el campo no cambia de tip,lon,obl, y si no tiene duplicados:
					se genera la SEQUENCE con el ultimo + 1
					no se debe regenerar el identity
			--->
			<cfquery name="rsSQL" datasource="#Arguments.conexion#">
				select col
				  from #colDB#
				 where tab = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.tab#">
				   and col = <cfqueryparam cfsqltype="cf_sql_varchar" value="#GvarTabTriggers.colIde#">
				   and tip = '#LvarIdeTip#'
				   and lon =  #LvarIdeLon#
				   and dec =  #LvarIdeDec#
			</cfquery>
			<cfif rsSQL.col NEQ "">
				<!--- Si no cambia las características --->
				<cfquery name="rsSQL" datasource="#Arguments.conexion#">
					select #GvarTabTriggers.colIde#, count(1)
					  from #Arguments.tab#
					 where #GvarTabTriggers.colIde# IS NOT NULL
					 group by #GvarTabTriggers.colIde#
					having count(1) > 1
				</cfquery>
				<cfif rsSQL.recordCount EQ 0>
					<!--- Si no hay duplicados --->
					<cfquery name="rsSQL" datasource="#Arguments.conexion#">
						select max(#GvarTabTriggers.colIde#) as ultimo
						  from #Arguments.tab#
						 where #GvarTabTriggers.colIde# IS NOT NULL
					</cfquery>
					<cfset LvarUltimo = rsSQL.ultimo>
					<cfset GvarTabTriggers.newSeq = false>
				</cfif>
			</cfif>
			<cfset Lvar_INI	&= "/* CREA SEQUENCE PARA CONTROL DE CONCURRENCIA */#vbCrLf#">
			<cfset Lvar_INI	&= "/* IF X GT 0:SELECT count(1) as X FROM ALL_SEQUENCES WHERE SEQUENCE_OWNER = '#GvarSchema#' AND SEQUENCE_NAME = 'S_#GvarTabPrefijo#' */#vbCrLf#">
			<cfset Lvar_INI	&= "DROP SEQUENCE S_#GvarTabPrefijo##EXEC#">
			<cfif LvarUltimo EQ "">
				<cfset Lvar_INI	&= "CREATE SEQUENCE S_#GvarTabPrefijo##EXEC#">
			<cfelse>
				<cfset Lvar_INI	&= "CREATE SEQUENCE S_#GvarTabPrefijo# START WITH #LvarUltimo+1##EXEC#">
			</cfif>

			<!--- Actualiza con la sequencia los valores NULOS --->
			<cfif NOT GvarTabTriggers.newSeq>
				<cfquery name="rsSQL" datasource="#Arguments.conexion#">
					select count(1) as nulos
					  from #Arguments.tab#
					 where #GvarTabTriggers.colIde# IS NULL
				</cfquery>
				<cfif rsSQL.nulos GT 0>
					<cfset Lvar_INI	&= "UPDATE #Arguments.tab# set #GvarTabTriggers.colIde# = S_#GvarTabPrefijo#.NEXTVAL where #GvarTabTriggers.colIde# IS NULL#EXEC#">
				</cfif>
			</cfif>
			<cfset GvarTabTriggers.seq = "S_#GvarTabPrefijo#">
		<cfelseif GvarTabTriggers.seq NEQ "S_#GvarTabPrefijo#">
			<cfset Lvar_INI	&= "/* RENOMBRA SEQUENCE PARA CONTROL DE CONCURRENCIA */#vbCrLf#">
			<cfset Lvar_INI	&= "RENAME ""#trim(GvarTabTriggers.seq)#"" TO S_#GvarTabPrefijo##EXEC#">
			<cfset GvarTabTriggers.seq = "S_#GvarTabPrefijo#">
		</cfif>
	</cfif>
	
	<cfreturn Lvar_INI>
</cffunction>

<cffunction name="fnGenEndTable" access="package" output="false" returntype="string">
	<cfargument name="conexion" required="yes">
	<cfargument name="tab"		required="yes">

	<cfset Lvar_FIN = "">
	<!--- CREA TRIGGER PARA CONTROL DE IDENTITY --->
	<cfif GvarTabTriggers.tib EQ "" AND GvarTabTriggers.colIde NEQ "">
		<cfset Lvar_FIN	&= "/* ADD_TRIGGER: CREA TRIGGER PARA CONTROL DE IDENTITY */#vbCrLf#">
		<cfset Lvar_FIN &= fnGenTIB(Arguments.tab, GvarTabTriggers.colIde)>
	</cfif>

	<!--- CREA TRIGGER PARA CONTROL DE CONCURRENCIA OPTIMISTICO: ts_rversion timestamp --->
	<cfif GvarTabTriggers.tuts EQ "" AND GvarTabTriggers.colTS NEQ "">
		<cfset Lvar_FIN	&= "/* ADD_TRIGGER: CREA TRIGGER PARA CONTROL DE CONCURRENCIA */#vbCrLf#">
		<cfset Lvar_FIN &= fnGenTUTS(Arguments.tab)>
	</cfif>
	
	<cfreturn Lvar_FIN>
</cffunction>

<cffunction name="fnGenTIB" output="false" returntype="string">
	<cfargument name="tab" required="yes">
	<cfargument name="col" required="yes">

	<cfset GvarTabTriggers.tib  = "TIB_#GvarTabPrefijo#">
	<cfreturn 	"CREATE OR REPLACE TRIGGER #GvarTabTriggers.tib# BEFORE INSERT#vbCrLf#" &
				"ON #Arguments.tab# FOR EACH ROW#vbCrLf#" &
				"DECLARE#vbCrLf#" &
				"	INTEGRITY_ERROR  EXCEPTION;#vbCrLf#" &
				"	ERRNO            INTEGER;#vbCrLf#" &
				"	ERRMSG           CHAR(200);#vbCrLf#" &
				"	DUMMY            INTEGER;#vbCrLf#" &
				"	FOUND            BOOLEAN;#vbCrLf#" &
				"#vbCrLf#" &
				"BEGIN#vbCrLf#" &
				"	--  COLUMN '#Arguments.col#' USES SEQUENCE S_#GvarTabPrefijo##vbCrLf#" &
				"	IF (SOINPK.IDENTITYOFF = 0) THEN#vbCrLf#" &
				"	  SELECT S_#GvarTabPrefijo#.NEXTVAL INTO SOINPK.LASTIDENTITY FROM DUAL;#vbCrLf#" &
				"	  SELECT SOINPK.LASTIDENTITY INTO :NEW.#Arguments.col# FROM DUAL;#vbCrLf#" &
				"	END IF;#vbCrLf#" &
				"#vbCrLf#" &
				"--  ERRORS HANDLING#vbCrLf#" &
				"EXCEPTION#vbCrLf#" &
				"	WHEN INTEGRITY_ERROR THEN#vbCrLf#" &
				"	   RAISE_APPLICATION_ERROR(ERRNO, ERRMSG);#vbCrLf#" &
				"END;#EXEC##vbCrLf#"
			>
</cffunction>

<cffunction name="fnGenTUTS" output="false" returntype="string">
	<cfargument name="tab" required="yes">

	<cfset GvarTabTriggers.tuts  = "TUTS_#GvarTabPrefijo#">
	<cfreturn 	"CREATE OR REPLACE TRIGGER #GvarTabTriggers.tuts# BEFORE UPDATE#vbCrLf#" &
				"ON #Arguments.tab# FOR EACH ROW#vbCrLf#" &
				"DECLARE#vbCrLf#" &
				"	INTEGRITY_ERROR  EXCEPTION;#vbCrLf#" &
				"	ERRNO            INTEGER;#vbCrLf#" &
				"	ERRMSG           CHAR(200);#vbCrLf#" &
				"	DUMMY            INTEGER;#vbCrLf#" &
				"	FOUND            BOOLEAN;#vbCrLf#" &
				"BEGIN#vbCrLf#" &
				"	SELECT SYSTIMESTAMP INTO :NEW.TS_RVERSION FROM DUAL;#vbCrLf#" &
				"#vbCrLf#" &
				"--  ERRORS HANDLING#vbCrLf#" &
				"EXCEPTION#vbCrLf#" &
				"	WHEN INTEGRITY_ERROR THEN#vbCrLf#" &
				"	   RAISE_APPLICATION_ERROR(ERRNO, ERRMSG);#vbCrLf#" &
				"END;#EXEC##vbCrLf#"
			>
</cffunction>

<cfscript>
	Function fnGenAddColumn(tab1, col, tip, lon, dec, ide, obl, dfl, rul, lov, sec)
	// ALTER TABLE tab ADD 		( col tip(lon,dec) )
	// UPDATE      tab SET col = S_tab.NEXTVAL						-- Cuando es identity
	// UPDATE      tab SET col = VALOR_INICIAL						-- Cuando hay ini o es obl sin dfl (primer valor de lov o dfl de tipo)
	// ALTER TABLE tab MODIFY	( col DEFAULT dfl )					-- Solo con dfl
	// ALTER TABLE tab MODIFY	( col NOT NULL )					-- Solo obl
	//
	// ALTER TABLE tab ADD CONSTRAINT tabla_CK01 CHECK (rul)		-- Cuando hay rul
	{
		GvarTabTriggers.tib = "";
		GvarTabTriggers.tuts = "";
		tab1=trim(tab1);col=trim(col);tip=trim(tip);lon=trim(lon);dec=trim(dec);obl=trim(obl);dfl=trim(dfl);rul=trim(rul);
		LvarCol = fnGenColumn (tab1, col, tip, lon, dec, obl, dfl, lov);

		LvarSQL_ALTER = "";

		// Pone nombre + tipo
		LvarSQL_ALTER &= "ALTER TABLE #tab1# ADD (#col# #LvarCol.SQLtip#)#EXEC#";
		
		if (ide EQ "1")
		{
			LvarSQL_ALTER &= "UPDATE #tab1# SET #col# = S_#GvarTabPrefijo#.NEXTVAL#EXEC#";
		}
		else
		{
			// Si es obligatorio elimina los nulls.  OJO el DEFAULT no actualiza registros existentes, es necesario el UPDATE
			if (LvarCol.dflIni NEQ "")
			{
				LvarSQL_ALTER &= "UPDATE #tab1# SET #col# = #LvarCol.dflIni##EXEC#";
			}
			if (dfl NEQ "")
			{
				LvarSQL_ALTER &= "ALTER TABLE #tab1# MODIFY (" & col & " " & LvarCol.SQLdfl & ")#EXEC#";
			}
		}

		// Pone obligatorio
		if (obl EQ "1")
		{
			LvarSQL_ALTER &= "ALTER TABLE #tab1# MODIFY (" & col & LvarCol.SQLnul & ")#EXEC#";
		}

		// Pone regla
		if (rul NEQ "")
		{
			LvarSQL_ALTER &= "ALTER TABLE #tab1# ADD " & "CONSTRAINT #GvarObj.fnGetName(GvarTabPrefijo,"CK",sec)# CHECK (#rul#)#EXEC#";
		}

		return LvarSQL_ALTER & vbCrLf;
	}

	Function fnGenChgColumn(
							conexion,
							tab, col,   colAnt,
							tip1, lon1, dec1, ide1, obl1, dfl1, dflN1, rul1, chk1, 
							tip2, lon2, dec2, ide2, obl2, dfl2, rul2,  lov2, sec2)
	// ALTER TABLE tab DROP CONSTRAINT nombre_anterior					-- Solo si hay rul anterior
	// RENOMBRAR cuando hay cambio de nombre en columna: colDB.colAnt
	//		ALTER TABLE tab RENAME COLUMN colAnt TO col
	// Cambio simple (cuando pasa de numero a numero, o de cualquiera a string, o solo cambia longitud):
	// 		ALTER TABLE tab MODIFY	( col TIPO_DE_DATOS(lon,dec) )
	// Regenerar (cuando cambia tipo, cambia LOB o cambia identity):
	//		ALTER TABLE tab ADD ( col__NEW TIPO_DE_DATOS(lon,dec) )
	//		UPDATE tabla SET col__NEW = col
	//		ALTER TABLE tab DROP   COLUMN col
	//		ALTER TABLE tab RENAME COLUMN col__NEW TO col
	// UPDATE tabla SET col = DFL_DEFAULT WHERE col IS NULL					-- Solo si cambia obl a 1
	// ALTER TABLE tab MODIFY	( col NULL | NOT NULL )						-- Solo si cambia obl
	// ALTER TABLE tab MODIFY	( col DEFAULT dfl ) 						-- Solo si cambia dfl
	// ALTER TABLE tab MODIFY	( col CONSTRAINT tabla_CK01 CHECK (rul)		-- Solo si hay regla
	{
		GvarTabTriggers.tib = "";
		GvarTabTriggers.tuts = "";
		tab=trim(tab);col=trim(col);
		tip1=trim(tip1);lon1=trim(lon1);dec1=trim(dec1);obl1=trim(obl1);dfl1=trim(dfl1);rul1=trim(rul1);chk1=trim(chk1);
		tip2=trim(tip2);lon2=trim(lon2);dec2=trim(dec2);obl2=trim(obl2);dfl2=trim(dfl2);rul2=trim(rul2);lov2=trim(lov2);

		LvarCol = fnGenColumn (tab, col, tip2, lon2, dec2, obl2, dfl2, lov2);
		dfl2 = LvarCol.dfl2;
		chk2 = GvarObj.fnGetName(GvarTabPrefijo,"CK",sec2);

		LvarSQL_ALTER = "";

		// SIEMPRE SE BORRA LA REGLA PARA EVITAR PROBLEMAS CON EL CAMBIO, LUEGO SE CREA
		if (rul1 NEQ "")
		{
			LvarSQL_ALTER &= "ALTER TABLE #tab# DROP CONSTRAINT #chk1# /* CHECK (#rul1#) */#EXEC#";
		}

		// RENOMBRAR CUANDO HAY CAMBIO DE NOMBRE DE COLUMNA
		if (colAnt NEQ "")
		{
			LvarSQL_ALTER &= "ALTER TABLE #Arguments.tab# RENAME COLUMN #Arguments.colAnt# TO #Arguments.col##EXEC#";
		}
		
		// Cambio a Timestamp
		if (tip1 NEQ "TS" AND tip2 EQ "TS")
		{
			if (col EQ "TS_RVERSION" AND tip1 EQ "D3")
			{
				tip1 = "TS";
			}
			else
			{
				LvarSQL_ALTER &= "ALTER TABLE #tab# DROP COLUMN #col##EXEC#";
				return LvarSQL_ALTER & fnGenAddColumn(tab, col, tip2, lon2, dec2, ide2, obl2, dfl2, rul2, lov2, sec2);
			}
		}
		
		// No hay restriccion especial en LOBs
		LvarLOBs = false;
		
		// Cambio de número a número (excepto a lógico o identity)
		LvarNumToNum = 	(tip1 NEQ tip2) AND 
						(tip1 NEQ "F" AND tip2 NEQ "F") AND
						(GvarOBJ.fnTipoPDtoCF(tip1) EQ "N") AND 
						(GvarOBJ.fnTipoPDtoCF(tip2) EQ "N") AND 
						(tip2 NEQ "L");
		
		// Cambio a char o varchar (No LOB)
		LvarToCHAR =	(obl1 EQ "0") AND 
						(tip1 NEQ tip2) AND 
						(tip2 EQ "C" OR tip2 EQ "V") AND 
						NOT (tip1 EQ "CL" OR tip1 EQ "BL");

		// Cambio Simple: Si cambia de número a número, Si cambia de cualquiera (menos LOB) a String, Si se mantiene el tipo y aumenta la longitud o decimales
		LvarDisminuye	= lon2 LT lon1 OR lon2-dec2 LT lon1-dec1;
		LvarSimple 		= (
							(LvarNumToNum OR LvarToCHAR OR ( tip1 EQ tip2 AND (lon1 NEQ lon2 OR dec1 NEQ dec2) ) )
							AND NOT LvarDisminuye 
						);

		// Regenerar: cambio de Tipo o LOB o poner Identity
 		LvarToIdentity 	= (ide1 EQ "0" AND ide2 EQ "1" and GvarTabTriggers.newSeq);
 		LvarRegenerar 	= (tip1 NEQ tip2 OR LvarToIdentity OR LvarDisminuye);
		
		if (LvarSimple)
		{
			LvarSQL_ALTER &= "ALTER TABLE #tab# MODIFY (#col# #LvarCol.SQLtip#)#EXEC#";
			if (tip2 EQ "V")
			{
				LvarSQL_ALTER &= "UPDATE #tab# SET #col# = RTRIM(LEFT(#col#,#lon2#))#EXEC#";
			}
		}
		else if (LvarRegenerar)
		{
			col__NEW = "#col#__NEW";
			if (len(col__NEW) > 30)
			{
				col__NEW = mid(col,1,23) & numberFormat(sec2,"00") & "__NEW";
			}
			// Convertir a Identity
			if (LvarToIdentity)
			{
				LvarAddUpd	= "ALTER TABLE #tab# ADD   (#col__NEW# #LvarCol.SQLtip#)#EXEC#";
				LvarAddUpd	&= "UPDATE #tab# SET #col__NEW# = S_#GvarTabPrefijo#.NEXTVAL#EXEC#";
				// ACTUALIZA TODAS LAS FKs QUE UTILIZAN EL identity VIEJO POR EL VALOR DEL identity NUEVO (Contribución de Gustavo Fonseca)
				LvarAddUpd	&= GvarObj.fnRecurs_KEYsCHGtoIDE("UPDATE", tab, col, col__NEW, tab, col, conexion, EXEC);
				obl1 = "0";	dfl1 = "";
				obl2 = "1"; dfl2 = "";				
			}
			// Convertir a BIT
			else if (tip2 EQ "L")
			{
				LvarAddUpd	= "ALTER TABLE #tab# ADD   (#col__NEW# #LvarCol.SQLtip#)#EXEC#";
				// ACTUALIZA "0", "" o NULL a 0 SINO 1
				LvarAddUpd	&= "UPDATE #tab# SET #col__NEW# = #fnCast(col, tip1, tip2, lon1, lon2)##EXEC#";
				obl1 = "0";	dfl1 = "";
				obl2 = "1";
			}
			// Convertir diferentes tipos
			else
			{
				LvarAddUpd	= "ALTER TABLE #tab# ADD   (#col__NEW# #LvarCol.SQLtip#)#EXEC#";
				LvarAddUpd	&= "UPDATE #tab# SET #col__NEW# = #fnCast(col, tip1, tip2, lon1, lon2)##EXEC#";
				obl1 = "0";	dfl1 = "";
			}
			
			LvarSQL_ALTER &= "/* IF X GT 0:SELECT count(1) as X FROM ALL_TAB_COLUMNS WHERE	OWNER='#GvarSchema#' AND TABLE_NAME='#tab#' AND COLUMN_NAME='#col__NEW#' */#vbCrLf#";
			LvarSQL_ALTER &= "ALTER TABLE #tab# DROP   COLUMN #col__NEW##EXEC#";
			LvarSQL_ALTER &= LvarAddUpd;
			LvarSQL_ALTER &= "ALTER TABLE #tab# DROP   COLUMN #col##EXEC#";
			LvarSQL_ALTER &= "ALTER TABLE #tab# RENAME COLUMN #col__NEW# TO #col##EXEC#";
		}
		else if (ide1 EQ "0" AND ide2 EQ "1")
		{
			LvarSQL_ALTER &= "/* Campo Identity unicamente requiere SEQUENCE y TRIGGER tib */#vbCrLf#";
		}

		if (compare(dfl1,dfl2) NEQ 0)
		{
			LvarSQL_ALTER &= "ALTER TABLE #tab# MODIFY (" & col & LvarCol.SQLdfl2  & ")#EXEC#";
		}
		
		if (obl1 NEQ obl2)
		{
			if (obl1 EQ "0" and obl2 EQ "1")
			{
				LvarSQL_ALTER &= "UPDATE #tab# SET #col# = #LvarCOL.dflObl# WHERE #col# IS NULL#EXEC#";
			}
			LvarSQL_ALTER &= "ALTER TABLE #tab# MODIFY (" & col & LvarCol.SQLnul2 & ")#EXEC#";
		}

		if (rul2 NEQ "")
		{
			LvarSQL_ALTER &= "ALTER TABLE #tab# ADD " & "CONSTRAINT #chk2# CHECK (#rul2#)#EXEC#";
		}

		return LvarSQL_ALTER & vbCrLf;
	}
	
	Function fnCast(col,tip_ORI,tip_DST,lon_ORI,lon_DST)
	{
	/*
	 ORI/DST	T = ts_rversion		D						S					N							B					
		T		X					to_date(OO)				to_char(OO,*)		to_number(to_char(OO,*))	CtoB(to_char(OO,*))	
		D		SYSTIMESTMAP		X						to_char(OO,*)		to_number(to_char(OO,*))	CtoB(to_char(OO,*))	
		S		SYSTIMESTMAP		to_date(OO,*)			X					to_number(OO)				CtoB(C)				
		N		SYSTIMESTMAP		to_date(OO,*)			to_char(OO)			X							CtoB(to_char(OO))	
		B		SYSTIMESTMAP		to_date(BtoC(OO),*)		to_char(BtoC(OO))	to_number(BtoC(OO))			X
		
		(*) La convencion para convertir fechas entre tipos es YYYYMMDD por lo que se perderán las horas 				
	*/		
		tip2_ORI = GvarObj.fnTipoPDtoCF(tip_ORI);
		tip2_DST = GvarObj.fnTipoPDtoCF(tip_DST);

		if (tip2_ORI EQ tip2_DST and tip2_ORI EQ "S")
		{
			return "LEFT(RTRIM(#col#),#lon_DST#)";
		}
		else if (tip_ORI EQ tip_DST)
		{
			return col;
		}
		else if (tip_DST EQ 'L')
		{
			return "case when coalesce(rtrim(to_char(#col#)), ' ') in ('0',' ') then 0 else 1 end";
		}
		else if (tip2_ORI EQ tip2_DST and tip_ORI NEQ "D3")
		{
			return col;
		}
		else if (tip2_DST EQ "D")
		{
			if (tip2_ORI EQ "S" OR tip2_ORI EQ "N")
			{
				return "TO_DATE(#col#,'YYYYMMDD')";
			}
			else if (tip2_ORI EQ "B")
			{
				return "TO_DATE(BtoC_LOB(#col#),'YYYYMMDD')";
			}
			else if (tip_ORI EQ "D3" AND tip_DST EQ "TS")
			{
				return col;
			}
			else if (tip_ORI EQ "D3")
			{
				return "TO_DATE(TO_CHAR(#col#,'YYYYMMDD HH24:MI:SS'),'YYYYMMDD HH24:MI:SS')";
			}
			else
			{
				return "TO_DATE(#col#)";
			}
		}
		else if (tip2_DST EQ "S")
		{
			if (tip2_ORI EQ "N")
			{
				return "TO_CHAR(#col#)";
			}
			else if (tip2_ORI EQ "B")
			{
				return "BtoC_LOB(#col#)";
			}
			else
			{
				return "TO_CHAR(#col#,'YYYYMMDD')";
			}
		}
		else if (tip2_DST EQ "N")
		{
			if (tip2_ORI EQ "S")
			{
				return "TO_NUMBER(#col#)";
			}
			else if (tip2_ORI EQ "B")
			{
				return "TO_NUMBER(BtoC_LOB(#col#))";
			}
			else
			{
				return "TO_NUMBER(TO_CHAR(#col#,'YYYYMMDD'))";
			}
		}
		else if (tip2_DST EQ "B")
		{
			if (tip2_ORI EQ "S")
			{
				return "CtoB_LOB(#col#)";
			}
			else if (tip2_ORI EQ "N")
			{
				return "CtoB_LOB(TO_CHAR(#col#))";
			}
			else
			{
				return "CtoB_LOB(TO_CHAR(#col#,'YYYYMMDD'))";
			}
		}
	}
		
	Function fnGenColumn(tab1, col, tip, lon, dec, obl, dfl, lov)
	{
		tab1=trim(tab1);col=trim(col);tip=trim(tip);lon=trim(lon);dec=trim(dec);obl=trim(obl);dfl=trim(dfl);lov=trim(lov);
		LvarCol = structNew();
		LvarSQL_COL = "";
		
		// TIPOS DE DATOS:
		//    String:
		//        char,nchar,varchar,nvarchar,sysname     C=char,V=VarChar         n,1
		//    Binarios:
		//        binary,varbinary                        B=Binary,VB=VarBinary    n,1
		//    LOB:
		//        text, image                             CL=CLOB,BL=BLOB         -2
		//    Numéricos Entero:
		//        biginteger,integer,int,smallint,tinyint I=Integer                20,10,5,3
		//    Numéricos Punto Fijo:
		//        NUMBER,decimal,dec                      N=NUMBER                n,d
		//    Numéricos Punto Flotante:
		//        real, float, double precision           F=Float                  7,15,30
		//    Numéricos Montos:
		//        money,smallmoney                        M=Money                  18,4
		//    Logicos:
		//        bit                                     L=Logico                 1
		//    Fecha:
		//        date, datetime, smalldatetime           D=DateTime               0
		//    Control de Concurrencia optimístico:
		//        timestamp                               TS=Timestamp             0

		LvarDefaultDfl = "";
		if (tip EQ "C")
		{
			LvarCol.SQLtip2 = "C";
			LvarSQL_COL = "CHAR(" & lon & ")";
			LvarIsSTR = True;
			LvarDefaultDfl = "' '";
		}
		else if (tip EQ "V")
		{
			LvarCol.SQLtip2 = "C";
			LvarSQL_COL = "VARCHAR2(" & lon & ")";
			LvarIsSTR = True;
			LvarDefaultDfl = "' '";
		}
		else if (tip EQ "B")
		{
			LvarCol.SQLtip2 = "B";
			LvarSQL_COL = "BLOB(" & lon & ")";
			LvarDefaultDfl = "'00'";
		}
		else if (tip EQ "VB")
		{
			LvarCol.SQLtip2 = "B";
			LvarSQL_COL = "BLOB(" & lon & ")";
			LvarDefaultDfl = "'00'";
		}
		else if (tip EQ "CL")
		{
			LvarCol.SQLtip2 = "C";
			LvarSQL_COL = "CLOB";
			LvarIsSTR = True;
			LvarDefaultDfl = "' '";
		}
		else if (tip EQ "BL")
		{
			LvarCol.SQLtip2 = "B";
			LvarSQL_COL = "BLOB";
			LvarDefaultDfl = "'00'";
		}
		else if (tip EQ "I")
		{
			LvarCol.SQLtip2 = "N";
			LvarSQL_COL = "NUMBER(" & lon & ")";
			LvarDefaultDfl = "0";
		}
		else if (tip EQ "N")
		{
			LvarCol.SQLtip2 = "N";
			if (dec EQ 0)
			{
				LvarSQL_COL = "NUMBER(" & lon & ")";
			}
			Else
			{
				LvarSQL_COL = "NUMBER(" & lon & "," & dec & ")";
			}
	
			LvarDefaultDfl = "0";
		}
		else if (tip EQ "F")
		{
			LvarCol.SQLtip2 = "N";
			if (lon LTE 7)
			{
				LvarSQL_COL = "FLOAT(24)";
			}
			if (lon GTE 16)
			{
				LvarSQL_COL = "FLOAT(100)";
			}
			Else
			{
				LvarSQL_COL = "FLOAT(53)";
			}
			LvarDefaultDfl = "0";
		}
		else if (tip EQ "M")
		{
			LvarCol.SQLtip2 = "N";
			LvarSQL_COL = "NUMBER(18,4)";
			LvarDefaultDfl = "0";
		}
		else if (tip EQ "L")
		{
			LvarCol.SQLtip2 = "N";
			LvarSQL_COL = "NUMBER(1)";
			obl = "1";
			LvarDefaultDfl = "0";
		}
		else if (tip EQ "D")
		{
			LvarCol.SQLtip2 = "D";
			LvarSQL_COL = "DATE";
			LvarDefaultDfl = "SYSDATE";
		}
		else if (tip EQ "TS")
		{
			LvarCol.SQLtip2 = "T";
			LvarSQL_COL = "TIMESTAMP";
			LvarDefaultDfl = "SYSTIMESTAMP";
		}
		LvarCol.SQLtip = LvarSQL_COL;

		LvarCol.SQLstr = find("'",LvarDefaultDfl) NEQ 0;
		if (lov NEQ "")
		{
			LvarDefaultDfl = listGetAt(GvarObj.fnLOVtoVALS(lov),1);
			if (LvarCol.SQLstr)
			{
				LvarDefaultDfl = "'#LvarDefaultDfl#'";
			}
		}
		
		
		// Defaults:
		//	.dfl2:		Valor default ajustado para compararlo con dfl1
		//	.dfl:		Valor default (para compararlo con .dflIni) (para compararlo con .dflIni)
		//	.dflIni:	Valor inicial únicamente en ALTER TABLE ADD COLUMN
		//	.dflObl:	Valor para sustituir NULL en campos que se vuelven obligatorios
		//	.SQLdfl:	Clausula "DEFAULT val"	para CREATE TABLE y ALTER TABLE ADD
		//	.SQLdfl2:	Clausula "DEFAULT val | NULL" para ALTER TABLE MODIFY
		LvarSQL_COL = "";
		if (dfl NEQ "")
		{
			dfl = Trim(dfl);
			if (Asc(Right(dfl, 1)) EQ 160)
			{
				dfl = trim(Left(dfl, Len(dfl) - 1));
			}
			
			if (NOT listFind("USER,SYSDATE",dfl))
			{
				if (LvarCol.SQLstr AND mid(dfl,1,1) NEQ "'")
				{
					dfl = "'#dfl#'";
				}
				else if (tip EQ "D" AND IsNumeric(dfl) AND Len(dfl) EQ 8)
				{
					dfl = "TO_DATE('" & Trim(dfl) & "','YYYYMMDD')";
				}
			}
			LvarCol.SQLdfl = " DEFAULT #dfl#";
			LvarCol.SQLdfl2 = LvarCol.SQLdfl;
		}
		else
		{
			LvarCol.SQLdfl = "";
			LvarCol.SQLdfl2 = " DEFAULT NULL";
		}

		// (si es obligatorio y no tiene defaults debe eliminar los nulls con el Default del tipo o el primer valor del lov)
		if (dfl EQ "" AND obl EQ 1)
		{
			LvarCol.dflIni = Trim(LvarDefaultDfl);
		}
		else
		{
			LvarCol.dflIni = dfl;
		}

		// Sustitucion de NULL al cambiar a obligatorio
		if (dfl NEQ "")
		{
			LvarCol.dflObl = dfl;
		}
		else
		{
			LvarCol.dflObl = Trim(LvarDefaultDfl);
		}

		LvarCol.dfl = dfl;
		// Elimina comillas para comparar PD.dfl2 <> DB.dfl1 (excepto tip='D')
		if (tip EQ "D")
		{
			LvarCol.dfl2 = dfl;
		}
		else
		{
			LvarCol.dfl2 = replace(dfl,"'","","ALL");
		}
		
		// .SQLnul:		Clausula NOT NULL	para Create y Alter Add
		// .SQLnul2:	Clausula NOT NULL	para Alter Modify
		if (obl EQ "1")
		{
			LvarCol.SQLnul  = " NOT NULL";
			LvarCol.SQLnul2 = " NOT NULL";
		}
		else
		{
			LvarCol.SQLnul  = "";
			LvarCol.SQLnul2 = " NULL";
		}
		
		return LvarCol;
	}
</cfscript>
