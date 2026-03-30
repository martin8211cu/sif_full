<cfset vbCrLf	= chr(13) & chr(10)>
<cfset vbTab	= chr(9)>
<cfset EXEC = "#vbCrLf#;#vbCrLf#">
<cfset GvarOBJ = "">
<cfset GvarTabPrefijo = "">

<cffunction name="init" access="package" output="no" returntype="struct">
	<cfargument name="obj" required="yes">
	<cfargument name="dsn" required="yes">
	<cfset GvarOBJ = arguments.obj>

	<cfset GvarSchema = ucase(left(trim(Application.dsinfo[arguments.dsn].Schema),8))>
	<cfif GvarSchema EQ "">
		<cfthrow message="Error en DSN '#arguments.dsn#':#Application.dsinfo[arguments.dsn].SchemaError#">
	</cfif>

	<cfreturn this>
</cffunction>

<cffunction name="fnCaseSensitive" access="package" output="no" returntype="boolean">
	<cfreturn false>
</cffunction>
<!---
	****************************************
	CREAR LAS TABLAS DE TRABAJO PARA DB2
	****************************************

ALTER TABLE test RENAME CONSTRAINT test1_pk TO test_pk;
ALTER INDEX test1_pk RENAME TO test_pk;

--->
<cffunction name="creaTablas" access="package" output="no">
	<cfargument name="conexion" required="yes">
	
	<cfset GvarSchema = ucase(left(trim(Application.dsinfo[arguments.conexion].Schema),8))>
	<cf_dbfunction name="OP_CONCAT" returnvariable="CONCAT" datasource="#Arguments.conexion#">
	<cf_dbfunction name="FN_LEN" 	returnvariable="LEN" 	datasource="#Arguments.conexion#">

	<cfset LvarTempV = "3">

	<cf_dbtemp name="tabDB_V#LvarTempV#" returnvariable="tabDB" datasource="#arguments.conexion#">
		<cf_dbtempcol name="tab"		    	type="varchar(30)"	mandatory="yes">
		<cf_dbtempcol name="tuts"		    	type="varchar(50)"	mandatory="no">
		<cf_dbtempcol name="OP"		    		type="integer"		mandatory="yes" default="0">
		<cf_dbtempcol name="tabAnt"		    	type="varchar(30)"	mandatory="no">
	
		<cf_dbtempkey cols="tab">
	</cf_dbtemp>
	<cf_dbtemp name="colDB_V#LvarTempV#" returnvariable="colDB" datasource="#arguments.conexion#">
		<cf_dbtempcol name="tab"		    	type="varchar(30)"	mandatory="yes">
		<cf_dbtempcol name="col"		    	type="varchar(50)"	mandatory="yes">
		<cf_dbtempcol name="tip"		    	type="varchar(2)"		mandatory="yes">
		<cf_dbtempcol name="lon"		    	type="int"			mandatory="no">
		<cf_dbtempcol name="dec"		    	type="int"			mandatory="no">
		<cf_dbtempcol name="ide"		    	type="bit"			mandatory="yes">
		<cf_dbtempcol name="ideT"		    	type="char(1)"		mandatory="yes">
		<cf_dbtempcol name="obl"		    	type="bit"			mandatory="yes">
		<cf_dbtempcol name="dfl"		    	type="varchar(255)"	mandatory="no">
		<cf_dbtempcol name="dflN"		    	type="char(1)"		mandatory="no">
		<cf_dbtempcol name="chk"		    	type="varchar(50)"	mandatory="no">
		<cf_dbtempcol name="rul"		    	type="varchar(900)"	mandatory="no">
		<cf_dbtempcol name="OP"		    		type="integer"		mandatory="yes" default="0">
		<cf_dbtempcol name="colAnt"		    	type="varchar(30)"	mandatory="no">
	
		<cf_dbtempkey cols="tab,col">
	</cf_dbtemp>

	<cf_dbtemp name="keyDB_V#LvarTempV#" returnvariable="keyDB" datasource="#arguments.conexion#">
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

	<cf_dbtemp name="chkDB_V#LvarTempV#" returnvariable="chkDB" datasource="#arguments.conexion#">
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
	********************************************
	AJUSTA LA ESTRUCTURA POWER DESIGNER PARA DB2
	********************************************
--->
<cffunction name="sbGetPDPrefijoName" access="package" output="false" returntype="string">
	<cfargument name="conexion"	required="yes">
	<cfargument name="tipo"		required="yes">
	<cfargument name="sec"		required="yes">

	<cfset LvarSuf = "t.suf13">
	<cfset LvarPrefN = "11">

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
			
		<!--- Tipo CHAR(255) = CHAR(254) --->
		<cfquery name="rsSQL" datasource="#arguments.conexion#">
			update #Arguments.colPD_colRPD# 
			   set lon=254 
			 where tip='C' and lon>254
			   and OP = #Arguments.OP#
		</cfquery>
	
		<!--- Tipo BIT = N(1,0) in 0,1--->
		<cfquery name="rsSQL" datasource="#arguments.conexion#">
			update #Arguments.colPD_colRPD# 
			   set tip='N',lon=1,dec=0,obl=1,lov='0,1' 
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
	
		<!--- Tipo MONEY = N(18,4) --->
		<cfquery name="rsSQL" datasource="#arguments.conexion#">
			update #Arguments.colPD_colRPD# 
			   set tip='N',lon=18,dec=4 
			 where tip='M'
			   and OP = #Arguments.OP#
		</cfquery>
	
		<cfif Arguments.colPD_colRPD EQ colRPD>
			<cfreturn>
		</cfif>
	<!--- FIN ajustes para colRPD --->
	
	
	<!--- Defaults: user_name() --->
	<cfquery name="rsSQL" datasource="#arguments.conexion#">
		update #colPD#
		   set dfl = 'USER'
		 where dfl like '%user_name%()%'
		   and OP = #Arguments.OP#
	</cfquery>

	<!--- Defaults: datetime --->
						
	<cfquery name="rsSQL" datasource="#arguments.conexion#">
		update #colPD#
		   set dfl = 
		   		case 
					when dfl like '%getdate%()%' then 'CURRENT TIMESTAMP' 
					when #LEN#(dfl)=8 then 
						'''' #CONCAT# 
						<cf_dbfunction name="sPart" args="dfl,1,4" datasource="#arguments.conexion#"> #CONCAT# '-' #CONCAT# 
						<cf_dbfunction name="sPart" args="dfl,5,2" datasource="#arguments.conexion#"> #CONCAT# '-' #CONCAT# 
						<cf_dbfunction name="sPart" args="dfl,7,2" datasource="#arguments.conexion#"> #CONCAT# '-00.00.00.000000''' 
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
			   and OP = #Arguments.OP#
		</cfquery>
	</cfif>

	<!--- Convierte AKs con columnas nulas en Indices Unicos UIs --->
	<cfquery name="rsSQL" datasource="#arguments.conexion#">
		update #keyPD#
		   set tip = 'U'
		 where tip='A'
		   and ( 
				select count(1)
				  from #colPD# c
				 where c.tab = #keyPD#.tab
				   and c.obl=0
			<cfif Arguments.tipo NEQ "BASECERO">
				   and fnLIKE(',' || #keyPD#.cols || ',' , '%,' || c.col || ',%')>0
			<cfelse>
				   and ',' || #keyPD#.cols || ',' LIKE '%,' || c.col || ',%'
			</cfif>
			)>0
		   and OP = #Arguments.OP#
	</cfquery>
	<!--- Inhabilita FKs que referencian a UI --->
	<cfquery name="rsSQL" datasource="#arguments.conexion#">
		update #keyPD#
		   set gen = 0
		 where tip='F'
		   and ( 
				select count(1)
				  from #keyPD# c
				 where c.tab 	= #keyPD#.ref
				   and c.cols	= #keyPD#.colsR
				   and c.tip	= 'U'
			)>0
		   and OP = #Arguments.OP#
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
		select c.tab, c.col, c.tip, c.obl, c.minVal, c.maxVal, c.lov
		  from #colPD# c
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

		<cfset LvarRUL = toRULE (rsSQL.col, rsSQL.tip, rsSQL.obl, rsSQL.minVal, rsSQL.maxVal, rsSQL.lov)>
		<cfquery datasource="#arguments.conexion#">
			update #colPD#
			   set rul = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarRUL#"		null="#trim(LvarRUL) EQ ''#">
			 where tab = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSQL.tab#">
			   and col = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSQL.col#">
		</cfquery>
	</cfloop>

	<!--- AJUSTA LAS REGLAS DE TABLAS: Pasa a mayúsculas los nombres de campos --->
	<cfquery name="rsSQL" datasource="#arguments.conexion#">
		select tab, rul
		  from #tabPD#
		 where rul is not null
		   and OP = #Arguments.OP#
	</cfquery>
	<cfloop query="rsSQL">
		<cfquery name="rsSQL2" datasource="#arguments.conexion#">
			select col
			  from #colPD#
			 where tab = '#rsSQL.tab#'
		</cfquery>
		<cfset LvarRule = rsSQL.rul>
		<cfset LvarCols = valueList(rsSQL2.col)>
		<cfloop list="#LvarCols#" index="LvarCol">
			<cfset LvarPto=0>
			<cfloop condition="true">
				<cfset LvarPto = REfindNoCase("[^a-zA-Z_]#LvarCol#[^a-zA-Z0-9_]", LvarRule, LvarPto)>
				<cfif LvarPto EQ 0>
					<cfbreak>
				</cfif>
				<cfset Res = "#LvarPto#,#LvarPto+len(LvarCol)#">
				<cfset LvarRule = mid(LvarRule,1,LvarPto) & ucase(LvarCol) & mid(LvarRule,LvarPto+len(LvarCol)+1,len(LvarRule))>
				<cfset LvarPto++>
			</cfloop>
		</cfloop>
		<cfquery datasource="#arguments.conexion#">
			update #tabPD#
			   set rul = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarRule#"	null="#trim(LvarRule) EQ ''#">
			 where tab = '#rsSQL.tab#'
		</cfquery>
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
	<cfif Arguments.minVal NEQ "" AND Arguments.maxVal NEQ "">
		<cfset LvarRule = LvarRule & " and #Arguments.col# between #fnValsToLiterals(Arguments.minVal, LvarTipo, false)# and #fnValsToLiterals(Arguments.maxVal, LvarTipo, false)#">
	<cfelseif Arguments.minVal NEQ "">
		<cfset LvarRule = LvarRule & " and #Arguments.col# >= #fnValsToLiterals(Arguments.minVal, LvarTipo, false)#">
	<cfelseif Arguments.maxVal NEQ "">
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
			   set stsP  = 4			<!--- Cargando Base de Datos --->
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
	<cfloop query="Arguments.rsOBJECTS">
		<cfset LvarTablaPD = trim(rsObjects.tab)>
		<cfset LvarTablaDB = trim(rsObjects.tab)>
		<cfif rsOBJECTS.currentRow - LvarTabsP GT 10>
			<cfset LvarTabsP = GvarOBJ.fnUpdateTabsP (Arguments.tipo, Arguments.tipoID, rsOBJECTS.currentRow)>
		</cfif>

		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			SELECT 	TABNAME
			  FROM	SYSCAT.TABLES
			 WHERE	TABSCHEMA	= '#GvarSchema#'
			   AND 	TABNAME		= '#LvarTablaPD#'
		</cfquery>
		<cfset LvarTablaDB = trim(rsSQL.TABNAME)>

		<!--- OBTIENE TABLA A RENOMBRAR --->
		<cfif LvarTablaDB EQ "" AND rsObjects.tabAnt NEQ "">
			<cfquery name="rsSQL" datasource="#Arguments.conexion#">
				SELECT 	TABNAME
				  FROM	SYSCAT.TABLES
				 WHERE	TABSCHEMA	= '#GvarSchema#'
				   AND 	TABNAME		= '#rsObjects.tabAnt#'
			</cfquery>
			<cfset LvarTablaDB = trim(rsSQL.TABNAME)>
		</cfif>

		<cfif LvarTablaDB NEQ "">
			<cfquery name="rsIDEs" datasource="#Arguments.conexion#">
				SELECT	TRIGNAME, TEXT
				  FROM	SYSCAT.TRIGGERS
				 WHERE	TABSCHEMA   = '#GvarSchema#'
				   AND 	TABNAME		= '#LvarTablaDB#'
				   AND	TRIGNAME    like 'TUTS_%'
			</cfquery>
			<cfset LvarTUTS = trim(rsIDEs.TRIGNAME)>

			<cfquery name="rsInsert" datasource="#Arguments.conexion#">
				insert into #tabDB# (tab, tabAnt, tuts)
				values (
					  <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTablaPD#">
					 ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTablaDB#"	null="#LvarTablaPD EQ LvarTablaDB#">
					 ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTUTS#"	null="#LvarTUTS EQ ''#">
				)
			</cfquery>	
			
			<cfquery name="rsSQL" datasource="#Arguments.conexion#">
				SELECT	TABSCHEMA		AS SCH, 
						TABNAME 		as TAB, 
						COLNAME 	 	as COL, 
						TYPENAME 		as TIP, 
						LENGTH			as LON, 
						SCALE 			as DECS, 
						case
							when NULLS = 'Y' then '0' else '1'
						end		 		as OBL,
						DEFAULT 		as DFL, 
						case
							when IDENTITY = 'Y' then '1' else '0'
						end		 		as IDE,
						GENERATED,
						case
							when ROWCHANGETIMESTAMP = 'Y' then '1' else '0'
						end		 		as TS
				  FROM	SYSCAT.COLUMNS C
				 WHERE	TABSCHEMA	= '#GvarSchema#'
				   AND 	TABNAME		= '#LvarTablaDB#'
				 ORDER BY COLNO
			</cfquery>

			<!--- OBTIENE LOS CHECKS POR COLUMNA --->
			<cfquery name="rsCHKs" datasource="#Arguments.conexion#">
				SELECT 	CONSTNAME as name, 
						<cf_dbfunction name="to_char" args="TEXT" isNumber="no" datasource="#Arguments.conexion#"> as TEXT, 
						'*' AS COLUMN_NAME
				  FROM SYSCAT.CHECKS
				 WHERE	TABSCHEMA	= '#GvarSchema#'
				   AND 	TABNAME		= '#LvarTablaDB#'
			</cfquery>

			<cfset LvarCOLs = "">
			<cfloop query="rsCHKs">
				<cfset LvarRUL = rsCHKs.text>
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
				<cfset QuerySetCell(rsCHKs, "COLUMN_NAME", LvarCOL, rsCHKs.currentRow)>
			</cfloop>
			<cfquery name="rsSQL2" dbtype="query">
				select name, text
				  from rsCHKs
				 where COLUMN_NAME = '**'
			</cfquery>
			<cfloop query="rsSQL2">
				<cfquery datasource="#Arguments.conexion#">
					insert into #chkDB# (tab, chk, rul)
					values (
						 <cfqueryparam value="#LvarTablaPD#"	cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="#rsSQL2.name#" 	cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="#rsSQL2.text#" 	cfsqltype="cf_sql_varchar"		null="#trim(rsSQL2.text) EQ ''#">
					)
				</cfquery>
			</cfloop>
	
			<!--- OBTIENE LAS CARACTERISITICAS DE LAS COLUMNAS --->
			<cfloop query="rsSQL">
				<cfquery name="rsSQL2" dbtype="query">
					select name, text
					  from rsCHKs
					 where COLUMN_NAME = '#rsSQL.COL#'
				</cfquery>
				<cfset LvarCHK = rsSQL2.name>
				<cfset LvarRUL = trim(rsSQL2.text)>

				<cfset LvarType = ColumnTypeFromDB2(rsSQL.TIP,rsSQL.LON,rsSQL.DECs,rsSQL.TS)>

				<cfset LvarDFL = rsSQL.DFL>
				<cfif LvarType.tip NEQ 'D'>
					<cfset LvarDFL = replace(LvarDFL,"'","","ALL")>
				</cfif>
				
				<cfquery datasource="#arguments.conexion#">
					insert into #colDB# (tab, col, tip, lon, dec, ide, ideT, obl, dfl, chk, rul)
					values (
						 <cfqueryparam value="#LvarTablaPD#"		cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="#rsSQL.col#"			cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="#trim(LvarType.TIP)#"	cfsqltype="cf_sql_char">
						,<cfqueryparam value="#LvarType.LON#"		cfsqltype="cf_sql_integer">
						,<cfqueryparam value="#LvarType.DECs#"		cfsqltype="cf_sql_integer">
						,<cfqueryparam value="#rsSQL.IDE#"			cfsqltype="cf_sql_bit">
						,<cfqueryparam value="#rsSQL.GENERATED#"	cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="#rsSQL.Obl#"			cfsqltype="cf_sql_bit">
						,<cfqueryparam value="#LvarDFL#"			cfsqltype="cf_sql_varchar"	null="#trim(LvarDFL)	EQ ''#">
						,<cfqueryparam value="#LvarCHK#"			cfsqltype="cf_sql_varchar"	null="#trim(LvarCHK)	EQ ''#">
						,<cfqueryparam value="#LvarRUL#"			cfsqltype="cf_sql_varchar"	null="#trim(LvarRUL)	EQ ''#">
					)
				</cfquery>
			</cfloop>	

			<!--- KEYs PK, AK --->
			<cfquery name="rsPKsAKs" datasource="#Arguments.conexion#">
				SELECT	CONSTNAME	AS KEYN, 
						CASE 
							WHEN TYPE = 'U' then 'A' ELSE 'P'
						END			as TIP,
						'???'		AS COLSK
				  FROM SYSCAT.TABCONST
				 WHERE TABSCHEMA	= '#GvarSchema#'
				   AND TABNAME		= '#LvarTablaDB#'
				   AND TYPE 		in ('P','U')
			</cfquery>
			<cfquery name="rsPKsAKsCOLs" datasource="#Arguments.conexion#">
				SELECT 	CONSTNAME	AS KEYN,
						COLNAME,
						COLSEQ
				  FROM SYSCAT.KEYCOLUSE
				 WHERE TABSCHEMA	= '#GvarSchema#'
				   AND TABNAME		= '#LvarTablaDB#'
				 ORDER BY COLSEQ
			</cfquery>

			<cfloop query="rsPKsAKs">
				<cfquery name="rsSQL2" dbtype="query">
					SELECT	COLNAME
					  FROM rsPKsAKsCOLs
					 WHERE KEYN	= '#rsPKsAKs.KEYN#'
					 ORDER BY COLSEQ
				</cfquery>
				<cfset Lvarcols = valueList(rsSQL2.COLNAME)>
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
				SELECT	INDNAME	as KEYN,
						CASE 
							WHEN UNIQUERULE = 'D' THEN
								'I'
							ELSE 
								UNIQUERULE		<!--- U o P --->
						END			as TIP, 
						COLNAMES 		as COLSK
				  FROM	SYSCAT.INDEXES	I
				 WHERE	TABSCHEMA		= '#GvarSchema#'
				   AND 	TABNAME			= '#LvarTablaDB#'
			</cfquery>
			
			<cfloop query="rsIDX">
				<cfset LvarTIP = rsIDX.TIP>
				<cfset LvarCOLS = replace(replace(rsIDX.COLSK,"+",",+","ALL"),"-",",-","ALL")>
				<cfset LvarColsI = "">
				<cfloop index="LvarCol" list="#LvarCOLS#">
					<cfif LvarColsI NEQ "">
						<cfset LvarColsI &= ",">
					</cfif>
					<cfif left(LvarCol,1) EQ "+">
						<cfset LvarColsI &= mid(LvarCol,2,31)>
					<cfelse>
						<cfset LvarColsI &= mid(LvarCol,2,31) & "-">
					</cfif>
				</cfloop>
				<cfset QuerySetCell(rsIDX, "COLSK", LvarColsI, rsIDX.currentRow)>

				<!--- Busca una PK o AK igual al indice: --->
				<!--- - No se puede crear un indice igual a una PK o AK --->
				<!--- - Pero si ya existe el ndice si se puede crear la PK o AK igual --->
				<!---   Siempre hay que borrar primero PK/AK y preguntar si existe el indice para borrarlo --->
				<cfset LvarColsK = REPLACE(LvarColsI,"-","","ALL")>
				<cfset LvarKeyN = rsIDX.keyN>
				<cfquery name="rsSQL3" dbtype="query">
					SELECT KEYN, TIP
					  FROM rsPKsAKs
					 WHERE COLSK	= '#LvarColsK#'
				</cfquery>
				<cfif rsSQL3.TIP NEQ "">
					<!--- Asigna el Indice a la KEY y no se crea el indice --->
					<cfquery datasource="#Arguments.conexion#">
						update #keyDB# 
						   set idx  = <cfqueryparam value="#LvarKeyN#"		cfsqltype="cf_sql_varchar">
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
							,<cfqueryparam value="#rsIDX.keyN#"		cfsqltype="cf_sql_varchar">
							,null
							,<cfqueryparam value="0"				cfsqltype="cf_sql_bit">
							,<cfqueryparam value="#GvarObj.fnKeyO(LvarTip)#" cfsqltype="cf_sql_integer">
						)
					</cfquery>
				</cfif>
			</cfloop>

			<!--- KEYs FK --->
			<cfquery name="rsFKs" datasource="#Arguments.conexion#">
				SELECT DISTINCT
						'F' as TIP,				<!--- FKs de LvarTablaDB --->
						CONSTNAME	as KEYN,
						TABNAME		as TAB,
						REFTABNAME	as REF,
						REFKEYNAME
				  FROM SYSCAT.REFERENCES
				 WHERE	TABSCHEMA	= '#GvarSchema#'
				   AND 	TABNAME		= '#LvarTablaDB#'
				UNION
				SELECT 
						'D' as TIP,				<!--- DEPENDENCIAS: FKs que referencian a LvarTablaDB --->
						CONSTNAME	as KEYN,
						TABNAME		as TAB,
						REFTABNAME	as REF,
						REFKEYNAME
				  FROM SYSCAT.REFERENCES
				 WHERE	TABSCHEMA	= '#GvarSchema#'
				   AND 	REFTABNAME	= '#LvarTablaDB#'
				ORDER BY 1
			</cfquery>

			<cfquery name="rsFKsCOLs" datasource="#Arguments.conexion#">
				SELECT DISTINCT
						c.TABNAME	    as TAB,
						c.CONSTNAME	    as KEYN,
                        c.COLNAME       as COL,
						c.COLSEQ
				  FROM SYSCAT.REFERENCES r
				    INNER JOIN SYSCAT.KEYCOLUSE c
                         ON c.TABSCHEMA	= r.TABSCHEMA
						AND c.TABNAME	= r.TABNAME		
						AND c.CONSTNAME	= r.CONSTNAME 
						 OR c.TABSCHEMA	= r.REFTABSCHEMA
						AND c.TABNAME	= r.REFTABNAME	
						AND c.CONSTNAME = r.REFKEYNAME
				 WHERE	r.TABSCHEMA	= '#GvarSchema#'
				   AND 	r.TABNAME	= '#LvarTablaDB#'
				UNION
				SELECT DISTINCT
						c.TABNAME	    as TAB,
						c.CONSTNAME	    as KEYN,
                        c.COLNAME       as COL,
						c.COLSEQ
				  FROM SYSCAT.REFERENCES r
				    INNER JOIN SYSCAT.KEYCOLUSE c
                         ON c.TABSCHEMA	= r.TABSCHEMA
						AND c.TABNAME	= r.TABNAME		
						AND c.CONSTNAME	= r.CONSTNAME 
						 OR c.TABSCHEMA	= r.REFTABSCHEMA
						AND c.TABNAME	= r.REFTABNAME	
						AND c.CONSTNAME = r.REFKEYNAME
				 WHERE	r.REFTABSCHEMA	= '#GvarSchema#'
				   AND 	r.REFTABNAME	= '#LvarTablaDB#'
			ORDER BY 1,2,4
			</cfquery>

			<cfloop query="rsFKs">
				<cfquery name="rsSQL3" dbtype="query">
					SELECT COL AS COLNAME
					  FROM rsFKsCOLs
					 WHERE TAB	= '#rsFKs.TAB#'
					   AND KEYN	= '#rsFKs.KEYN#'
					 ORDER BY COLSEQ
				</cfquery>
				<cfset LvarCOLsF = valuelist(rsSQL3.COLNAME)>
				<cfquery name="rsSQL3" dbtype="query">
					SELECT COL AS COLNAME
					  FROM rsFKsCOLs
					 WHERE TAB	= '#rsFKs.REF#'
					   AND KEYN	= '#rsFKs.REFKEYNAME#'
					 ORDER BY COLSEQ
				</cfquery>
				<cfset LvarCOLsR = valuelist(rsSQL3.COLNAME)>
				
				<cfset LvarTablaFK = trim(rsFKs.TAB)>
				<cfif LvarTablaFK EQ LvarTablaDB AND LvarTablaDB NEQ LvarTablaPD>
					<cfset LvarTablaFK = LvarTablaPD>
				</cfif>
				<cfquery datasource="#Arguments.conexion#">
					insert into #keyDB# (tab, cols, tip, ref, colsR, keyN, clu, keyO)
					values (
						 <cfqueryparam value="#LvarTablaFK#"	cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="#LvarCOLsF#"		cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="#rsFKs.tip#"		cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="#rsFKs.ref#"		cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="#LvarCOLsR#"		cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="#rsFKs.keyN#"		cfsqltype="cf_sql_varchar">
						, 0, #GvarObj.fnKeyO("F")#
					)
				</cfquery>
			</cfloop>
		</cfif>
		<cfset rsSQL		= javacast("null", 0)>
		<cfset rsSQL2		= javacast("null", 0)>
		<cfset rsSQL3		= javacast("null", 0)>
		<cfset rsIDEs		= javacast("null", 0)>
		<cfset rsInsert		= javacast("null", 0)>
		<cfset rsCHKs		= javacast("null", 0)>
		<cfset rsPKsAKs		= javacast("null", 0)>
		<cfset rsPKsAKsCOLs	= javacast("null", 0)>
		<cfset rsIDX		= javacast("null", 0)>
		<cfset rsFKs		= javacast("null", 0)>
		<cfset rsFKsCOLs	= javacast("null", 0)>
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


<!---
'TIPOS DE DATOS:
'   String:
'       char,nchar,varchar,nvarchar,sysname     C=char,V=VarChar         n,1
'   Binarios:
'       binary,varbinary                        B=Binary,VB=VarBinary    n,1
'   LOB:
'       text, image                             CL=CLOB,BL=BLOB         -2
'   Numricos Entero:
'       biginteger,integer,int,smallint,tinyint I=Integer                20,10,5,3
'   Numricos Punto Fijo:
'       numeric,decimal,dec                     N=Numeric                n,d
'   Numricos Punto Flotante:
'       real, float, double precision           F=Float                  7,15
'   Numricos Montos:
'       money,smallmoney                        M=Money                  18,4
'   Logicos:
'       bit                                     L=Logico                 1
'   Fecha:
'       date, datetime, smalldatetime           D=DateTime               0
'   Control de Concurrencia optimstico:
'       timestamp                               TS=Timestamp             0
<!--- Tipos = "C,V,B,VB,CL,BL,I,N,F,M,L,D,TS" --->
--->
<!--- Tipos = "C,V,B,VB,CL,BL,I,N,F,M,L,D,TS" --->
<!--- Tipo = C = Char: Caracter tamao fijo --->
<!--- Tipo = V = Varchar: Caracter tamao variable --->
<!--- Tipo = B = Binary: Dato Binario tamao fijo --->
<!--- Tipo = VB = Varbinary: Dato Binario tamao variable --->
<!--- Tipo = CL = CLOB: Objeto caracter de 2GB --->
<!--- Tipo = BL = BLOB: Objeto binario de 2GB --->
<!--- Tipo = I = Integer: Nmero entero --->
<!--- Tipo = N = Numeric: Nmero con cantidad de decimales fijo --->
<!--- Tipo = F = Float: Nmero con punto flotante --->
<!--- Tipo = M = Money: Nmero para almacenar montos con 4 decimales --->
<!--- Tipo = L = Logic: Nmero que slo permite 1=true, 0=false --->
<!--- Tipo = D = Datetime: Fecha que almacena Fecha y Hora --->
<!--- Tipo = TS = Timestamp: Dato autogenerado cada vez que se actualiza un registro --->
<!--- Tipo = ** = Tipo de dato no soportado --->
<cffunction name="ColumnTypeFromDB2" returntype="struct">
	<cfargument name="TIP">
	<cfargument name="LON">
	<cfargument name="DECs">
	<cfargument name="TS">
	
	<!--- Tipos = "C,V,B,VB,CL,BL,I,N,F,M,L,D,TS" --->
	<cfset LvarTYPE = Arguments>
	
	<cfif listFind("CHAR,CHARACTER",LvarTYPE.TIP)>
		<!--- Tipo = C = Char: Caracter tamao fijo --->
		<cfset LvarTYPE.TIP	= "C">
		<cfset LvarTYPE.DECs	= "0">
	<cfelseif LvarTYPE.TIP EQ "VARCHAR">
		<!--- Tipo = V = Varchar: Caracter tamao variable --->
		<cfset LvarTYPE.TIP	= "V">
		<cfset LvarTYPE.DECs	= "0">
	<cfelseif LvarTYPE.TIP EQ "BLOB">
		<!--- Tipo = B = Binary: Dato Binario tamao fijo --->
		<!--- Tipo = VB = Varbinary: Dato Binario tamao variable --->
		<cfif LvarTYPE.Lon GTE 2e6>
			<cfset LvarTYPE.TIP	= "BL">
			<cfset LvarTYPE.Lon = -2>
		<cfelseif LvarTYPE.Lon GTE 255> 
			<cfset LvarTYPE.TIP	= "BL">
			<cfset LvarTYPE.Lon = -3>
		<cfelse>
			<cfset LvarTYPE.TIP	= "VB">
		</cfif>
		<cfset LvarTYPE.DECs	= "0">
	<cfelseif listFind("CLOB,LONG VARCHAR",LvarTYPE.TIP)>
		<!--- Tipo = CL = CLOB: Objeto caracter de 2GB --->
		<cfif LvarTYPE.Lon GTE 2e6>
			<cfset LvarTYPE.TIP	= "CL">
			<cfset LvarTYPE.Lon = -2>
		<cfelseif LvarTYPE.Lon GTE 255>
			<cfset LvarTYPE.TIP	= "CL">
			<cfset LvarTYPE.Lon = -3>
		<cfelse>
			<cfset LvarTYPE.TIP	= "V">
		</cfif>
		<cfset LvarTYPE.DECs	= "0">
	<cfelseif listFind("BIGINT,INTEGER,SMALLINT",LvarTYPE.Tip)>
		<!--- Tipo = I = Integer: Nmero entero --->
		<cfif find("BIG", LvarTYPE.tip)>
			<cfset LvarTYPE.TIP = "I">
			<cfset LvarTYPE.Lon = 19>
		<cfelseif find("SMALL", LvarTYPE.tip)>
			<cfset LvarTYPE.TIP = "I">
			<cfset LvarTYPE.Lon = 5>
		<cfelse>
			<cfset LvarTYPE.TIP = "I">
			<cfset LvarTYPE.Lon = 10>
		</cfif>
		<cfset LvarTYPE.Decs = "0">
	<cfelseif listFind("DEC,DECIMAL,NUM,NUMERIC",LvarTYPE.Tip)>
		<!--- Tipo = N = Numeric: Nmero con cantidad de decimales fijo --->
		<cfset LvarTYPE.TIP	= "N">
		<cfif LvarTYPE.DECs EQ "">
			<cfset LvarTYPE.DECs= "0">
		</cfif>
	<cfelseif listFind("FLOAT,DOUBLE,REAL",LvarTYPE.Tip)>
		<!--- Tipo = F = Float: Nmero con punto flotante --->
		<cfset LvarTYPE.TIP = "F">
		<cfif rsSQL.TIP EQ "DOUBLE">
			<cfset LvarTYPE.Lon = 15>
		<cfelse>
			<cfset LvarTYPE.Lon = 7>
		</cfif>
	<cfelseif LvarTYPE.TIP EQ "TIMESTAMP">
		<!--- Tipo = D = Datetime: Fecha que almacena Fecha y Hora --->
		<cfif LvarTYPE.TS EQ "1">
			<cfset LvarTYPE.TIP	= "TS">
		<cfelse>
			<cfset LvarTYPE.TIP	= "D">
		</cfif>
		<cfset LvarTYPE.LON		= "0">
		<cfset LvarTYPE.DECs	= "0">
	<cfelseif LvarTYPE.Tip EQ "DATE">
		<!--- Tipo = D1 = Date: Fecha que almacena Slo Fecha --->
		<cfset LvarTYPE.TIP		= "D1">
		<cfset LvarTYPE.LON		= "0">
		<cfset LvarTYPE.DECs	= "0">
	<cfelseif LvarTYPE.Tip EQ "TIME">
		<!--- Tipo = D2 = Time: Fecha que almacena Slo Hora --->
		<cfset LvarTYPE.TIP		= "D2">
		<cfset LvarTYPE.LON		= "0">
		<cfset LvarTYPE.DECs	= "0">
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

	<cfset LvarScript = "">
	<!--- TABLE dual --->
	<cfif Arguments.forScript>
		<cfset LvarScript = "/* IF X GT 0:SELECT count(1) as X FROM	SYSCAT.TABLES WHERE	TABSCHEMA = '#GvarSchema#' AND TABNAME = 'DUAL' */#vbCrLf#">
		<cfset LvarScript &= "DROP   TABLE DUAL#EXEC#">
		<cfset LvarScript &= "CREATE TABLE DUAL (x  CHAR(1))#EXEC#">
		<cfset LvarScript &= "INSERT INTO  DUAL (x) VALUES ('X')#EXEC#">
	<cfelse>
		<cfset LvarCreate = false>
		<cfset LvarDrop = false>
		<cftry>
			<cfquery name="rsSQL" datasource="#arguments.conexion#">
				select count(1) as cantidad from dual
			</cfquery>
			<cfset LvarDrop = true>
			<cfset LvarCreate = (rsSQL.cantidad NEQ 1)>
		<cfcatch type="any">
			<cfset LvarCreate = true>
		</cfcatch>
		</cftry>
	
		<cfif LvarCreate>
			<cfif LvarDrop>
				<cfquery datasource="#arguments.conexion#">
					DROP TABLE dual
				</cfquery>
			</cfif>
			<cfquery datasource="#arguments.conexion#">
				CREATE TABLE dual (x CHAR(1))
			</cfquery>
			<cfquery datasource="#arguments.conexion#">
				INSERT INTO dual (x) VALUES ('X')
			</cfquery>
		</cfif>
	</cfif>

	<!--- FUNCTION FNLIKE --->
	<cfoutput>
<cfsavecontent variable="LvarSQL">
CREATE FUNCTION FNLIKE
(  
  likeString    VARCHAR(4000), 
  likeMask      VARCHAR(100)
)
RETURNS INTEGER
FENCED
VARIANT
NO SQL
LANGUAGE JAVA
PARAMETER STYLE JAVA
EXTERNAL NAME 'sp.LikeToRegEx!fnLIKE'
</cfsavecontent>
	</cfoutput>

	<cfif forScript>
		<cfset LvarScript &= "/* IF X EQ 0:SELECT COUNT(1) AS X from SYSCAT.FUNCTIONS WHERE FUNCSCHEMA = '#GvarSchema#' AND FUNCNAME='FNLIKE' */#vbCrLf#">
		<cfset LvarScript &= LvarSQL & EXEC>
	<cfelse>
		<cfquery name="rsSQL" datasource="#arguments.conexion#">
			select count(1) as X from SYSCAT.FUNCTIONS WHERE FUNCSCHEMA = '#GvarSchema#' AND FUNCNAME='FNLIKE'
		</cfquery>

		<cftry>
			<cfif rsSQL.X EQ 0>
				<cfquery datasource="#arguments.conexion#">
					#preserveSingleQuotes(LvarSQL)#
				</cfquery>
			</cfif>
			<cfquery name="rsSQL" datasource="#arguments.conexion#">
				select fnlike('A','[AB]') from dual
			</cfquery>
		<cfcatch type="any">
			<cfthrow message="ERROR con la función java FNLIKE: #cfcatch.Message# #cfcatch.Detail#">
		</cfcatch>
		</cftry>
	</cfif>

	<!--- FUNCTION fnTO_CHAR --->
	<cfoutput>
<cfsavecontent variable="LvarSQL">
CREATE FUNCTION fnTO_CHAR(DI DECIMAL(31,10),
                        FMT VARCHAR(50))
RETURNS     VARCHAR(50)
    SPECIFIC fnTO_CHARDECIMAL
    LANGUAGE SQL
    DETERMINISTIC
    NO EXTERNAL ACTION
    CONTAINS SQL
    NULL CALL
    INHERIT SPECIAL REGISTERS
    BEGIN ATOMIC
		DECLARE Retv VARCHAR(50);
		DECLARE DIdg CHAR(31);
		DECLARE DIsub VARCHAR(31);
		DECLARE Posd
			, Posf
			, SigI SMALLINT;
		
		IF FMT = '*'
		THEN
			SET Retv = CASE
				WHEN DI = 0 THEN
					'0'
				WHEN DI > 0 AND DI < 1 THEN
					'0' || TRIM(L '0' FROM TRIM(T '.' FROM TRIM(T '0' FROM RTRIM(CHAR(DI)))))
				WHEN DI > 0 THEN
					TRIM(L '0' FROM TRIM(T '.' FROM TRIM(T '0' FROM RTRIM(CHAR(DI)))))
				WHEN DI < 0 AND DI > -1 THEN
					'-0' || TRIM(L '0' FROM TRIM(T '.' FROM TRIM(T '0' FROM RTRIM(CHAR(-DI)))))
				WHEN DI < 0 THEN
					'-' || TRIM(L '0' FROM TRIM(T '.' FROM TRIM(T '0' FROM RTRIM(CHAR(-DI)))))
                END;
			RETURN Retv;
		END IF;
		
		IF posstr(FMT, '.') > 0
		THEN
			SET DIsub = ltrim(rtrim(translate(substr(FMT, posstr(FMT, '.'), length(FMT)), ' ', '.S')));
		ELSE
			SET DIsub = '';
		END IF;	

		IF length(rtrim(translate(FMT, ' ', ',.90S'))) > 0
			OR length(ltrim(rtrim(translate(FMT, ' ', ',90S')))) > 1
			OR posstr(FMT, 'S') NOT IN (0, 1, length(FMT))
			OR posstr(DIsub, ',') > 0
		THEN
			RETURN '*** Format Error. ***';
		END IF;

		SET DIdg = digits(round(DI,length(DIsub)));

		SET Posd = 22 - length( replace( substr(FMT, 1, posstr(FMT||'.', '.') - 1),',', '') )
			+ sign(posstr(substr(FMT, 1, posstr(FMT||'.', '.') - 1),'S'));
		SET (Posf, SigI, Retv) = (1, 0, '');
		WHILE Posf <= length(FMT) DO
			SET SigI = CASE
				WHEN substr(FMT,Posf,1) IN ('0', '.')
					OR substr(FMT,Posf,1) = '9' AND substr(DIdg,Posd,1) <> '0' THEN
					1
				ELSE 
					SigI
				END;
			SET Retv = CASE
				WHEN SigI = 1 AND substr(FMT,Posf,1) IN ('0', '9') THEN
					Retv || substr(DIdg,Posd,1)
				WHEN SigI = 1 AND substr(FMT,Posf,1) IN (',', '.') THEN
					Retv || substr(FMT,Posf,1)
				WHEN substr(FMT,Posf,1) = 'S' THEN
					Retv || 
					CASE
						WHEN DI > 0 THEN 
							'+'
						WHEN DI < 0 THEN 
							'-'
						ELSE ' '
					END
				WHEN Posf = length(FMT) THEN
					Retv || '0'
				ELSE Retv || ' '
			END;
			SET Posd = CASE
				WHEN substr(FMT,Posf,1) IN ('0', '9') THEN
					Posd + 1
				ELSE 
					Posd
				END;
			SET Posf = Posf + 1;
		END WHILE;

		SET Retv = rtrim(trim(Retv));
		IF POSSTR(FMT, 'S') = 0 AND DI < 0
		THEN
			IF POSSTR(Retv, ',') > 0 
			THEN 
				RETURN '-' || Retv;
			END IF;
			IF DECIMAL(Retv,31,10) <> 0
			THEN 
				RETURN '-' || Retv;
			END IF;
		END IF;
		RETURN Retv;
	END
</cfsavecontent>
<cfsavecontent variable="LvarSQL2">
CREATE FUNCTION fnTO_CHAR(DI FLOAT,
                        FMT VARCHAR(50))
RETURNS     VARCHAR(50)
    SPECIFIC fnTO_CHARFLOAT
    LANGUAGE SQL
    DETERMINISTIC
    NO EXTERNAL ACTION
    CONTAINS SQL
    NULL CALL
    INHERIT SPECIAL REGISTERS
    BEGIN ATOMIC
		RETURN fnTO_CHAR(DECIMAL(DI,31,10),FMT);
	END
</cfsavecontent>
<cfsavecontent variable="LvarSQL3">
CREATE FUNCTION fnTO_CHAR(DI VARCHAR(255),
                        FMT VARCHAR(50))
RETURNS     VARCHAR(255)
    SPECIFIC fnTO_CHARSTRING
    LANGUAGE SQL
    DETERMINISTIC
    NO EXTERNAL ACTION
    CONTAINS SQL
    NULL CALL
    INHERIT SPECIAL REGISTERS
    BEGIN ATOMIC
		IF FMT = '*'
		THEN
			RETURN RTRIM(DI);
		END IF;
		RETURN fnTO_CHAR(DECIMAL(DI,31,10),FMT);
	END
</cfsavecontent>
<cfsavecontent variable="LvarSQL4">
CREATE FUNCTION fnTO_CHAR(DI CLOB,
                        FMT VARCHAR(50))
RETURNS     VARCHAR(32000)
    SPECIFIC fnTO_CHARCLOB
    LANGUAGE SQL
    DETERMINISTIC
    NO EXTERNAL ACTION
    CONTAINS SQL
    NULL CALL
    INHERIT SPECIAL REGISTERS
    BEGIN ATOMIC
		IF FMT = '*'
		THEN
			RETURN RTRIM(DI);
		END IF;
		RETURN fnTO_CHAR(DECIMAL(VARCHAR(DI),31,10),FMT);
	END
</cfsavecontent>
	</cfoutput>

	<cfif forScript>
		<cfset LvarScript &= "/* IF X EQ 0:SELECT COUNT(1) AS X from SYSCAT.FUNCTIONS WHERE FUNCSCHEMA = '#GvarSchema#' AND FUNCNAME='FNTO_CHAR' AND SPECIFICNAME='FNTO_CHARFLOAT' */#vbCrLf#">
		<cfset LvarScript &= "DROP SPECIFIC FUNCTION FNTO_CHARFLOAT" & EXEC>
		<cfset LvarScript &= "/* IF X EQ 0:SELECT COUNT(1) AS X from SYSCAT.FUNCTIONS WHERE FUNCSCHEMA = '#GvarSchema#' AND FUNCNAME='FNTO_CHAR' AND SPECIFICNAME='FNTO_CHARSTRING' */#vbCrLf#">
		<cfset LvarScript &= "DROP SPECIFIC FUNCTION FNTO_CHARSTRING" & EXEC>
		<cfset LvarScript &= "/* IF X EQ 0:SELECT COUNT(1) AS X from SYSCAT.FUNCTIONS WHERE FUNCSCHEMA = '#GvarSchema#' AND FUNCNAME='FNTO_CHAR' AND SPECIFICNAME='FNTO_CHARCLOB' */#vbCrLf#">
		<cfset LvarScript &= "DROP SPECIFIC FUNCTION FNTO_CHARCLOB" & EXEC>
		<cfset LvarScript &= "/* IF X EQ 0:SELECT COUNT(1) AS X from SYSCAT.FUNCTIONS WHERE FUNCSCHEMA = '#GvarSchema#' AND FUNCNAME='FNTO_CHAR' AND SPECIFICNAME='FNTO_CHARDECIMAL' */#vbCrLf#">
		<cfset LvarScript &= "DROP SPECIFIC FUNCTION FNTO_CHARDECIMAL" & EXEC>
		<cfset LvarScript &= LvarSQL & EXEC>
		<cfset LvarScript &= LvarSQL2 & EXEC>
		<cfset LvarScript &= LvarSQL3 & EXEC>
		<cfset LvarScript &= LvarSQL4 & EXEC>
	<cfelse>
		<cfquery name="rsSQL" datasource="#arguments.conexion#">
			select count(1) as X from SYSCAT.FUNCTIONS WHERE FUNCSCHEMA = '#GvarSchema#' AND FUNCNAME='FNTO_CHAR' AND SPECIFICNAME='FNTO_CHARFLOAT'
		</cfquery>
		<cfif rsSQL.X GT 0>
			<cfquery datasource="#arguments.conexion#">
				DROP SPECIFIC FUNCTION FNTO_CHARFLOAT
			</cfquery>
		</cfif>
		<cfquery name="rsSQL" datasource="#arguments.conexion#">
			select count(1) as X from SYSCAT.FUNCTIONS WHERE FUNCSCHEMA = '#GvarSchema#' AND FUNCNAME='FNTO_CHAR' AND SPECIFICNAME='FNTO_CHARSTRING'
		</cfquery>
		<cfif rsSQL.X GT 0>
			<cfquery datasource="#arguments.conexion#">
				DROP SPECIFIC FUNCTION FNTO_CHARSTRING
			</cfquery>
		</cfif>
		<cfquery name="rsSQL" datasource="#arguments.conexion#">
			select count(1) as X from SYSCAT.FUNCTIONS WHERE FUNCSCHEMA = '#GvarSchema#' AND FUNCNAME='FNTO_CHAR' AND SPECIFICNAME='FNTO_CHARCLOB'
		</cfquery>
		<cfif rsSQL.X GT 0>
			<cfquery datasource="#arguments.conexion#">
				DROP SPECIFIC FUNCTION FNTO_CHARCLOB
			</cfquery>
		</cfif>
		<cfquery name="rsSQL" datasource="#arguments.conexion#">
			select count(1) as X from SYSCAT.FUNCTIONS WHERE FUNCSCHEMA = '#GvarSchema#' AND FUNCNAME='FNTO_CHAR' AND SPECIFICNAME='FNTO_CHARDECIMAL'
		</cfquery>
		<cfif rsSQL.X GT 0>
			<cfquery datasource="#arguments.conexion#">
				DROP SPECIFIC FUNCTION FNTO_CHARDECIMAL
			</cfquery>
		</cfif>
		<cfquery datasource="#arguments.conexion#">
			#preserveSingleQuotes(LvarSQL)#
		</cfquery>
		<cfquery datasource="#arguments.conexion#">
			#preserveSingleQuotes(LvarSQL2)#
		</cfquery>
		<cfquery datasource="#arguments.conexion#">
			#preserveSingleQuotes(LvarSQL3)#
		</cfquery>
		<cfquery datasource="#arguments.conexion#">
			#preserveSingleQuotes(LvarSQL4)#
		</cfquery>
	</cfif>

	<!--- RETURN --->
	<cfif forScript>
		<cfreturn LvarScript>
	<cfelse>
		<cfreturn "">
	</cfif>
</cffunction> 

<cffunction name="fnREORG" access="package" output="false" returntype="string">
	<cfargument name="tab" required="yes">
	<cfreturn "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#Arguments.tab#')#EXEC#">
</cffunction>

<cffunction name="fnGenIniTable" access="package" output="false" returntype="string">
	<cfargument name="conexion" required="yes">
	<cfargument name="tab"		required="yes">
	<cfargument name="chg"		default="no">

	<cfquery name="rsSQL" datasource="#Arguments.conexion#">
		select tab, tuts
		  from #tabDB#
		 where tab = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.tab#">
	</cfquery>
	<cfset Lvar_TABINI = "">
	<!--- BORRA TRIGGER ANTERIOR PARA CONTROL CONCURRENCIA --->
	<cfif rsSQL.tuts NEQ "">
		<cfset Lvar_TABINI = "DROP TRIGGER #rsSQL.tuts# /* ELIMINA TRIGGER CONTROL CONCURRENCIA */#EXEC#">
	</cfif>

	<cfif Arguments.chg>
		<cfset GvarObj.sbAddScriptTit (fnREORG(rsSQL.tab))>
	</cfif>
	<cfreturn Lvar_TABINI>
</cffunction>

<cffunction name="fnGenEndTable" access="package" output="false" returntype="string">
	<cfargument name="conexion" required="yes">
	<cfargument name="tab"		required="yes">
	<cfreturn "">
</cffunction>

<cffunction name="sbSetTabPrefijo" access="package" output="false" returntype="void">
<!--- Prefijo para: PK, AK, UI, ID, FK, CK, TIB, S_ --->
	<cfargument name="tab"		required="yes">
	<cfargument name="suf13"	required="yes">
	<cfargument name="suf25"	required="yes">
	
	<cfset GvarTabPrefijo = rtrim(Arguments.tab)>
	<cfif Arguments.suf13 NEQ "0">
		<cfset GvarTabPrefijo = mid(tab,1,11) & numberFormat(Arguments.suf13,"00")>
	</cfif>
</cffunction>

<cffunction name="sbGetPDPrefijo" access="package" output="false" returntype="void">
	<cfreturn "case when t.suf13>0 then left(t.tab,11) || right('00' || convert(varchar,t.suf13),2) else t.tab end">
</cffunction>

<cffunction name="fnGenAddTable" access="package" output="false" returntype="string">
	<cfargument name="conexion" required="yes">
	<cfargument name="tabla" required="yes">
<!---
	CREATE TABLE tabla ( 
						col TIPO_DE_DATOS(lon,dec)
							DEFAULT dfl
							NULL | NOT NULL
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
			rtrim(p.lov) as lov,
			p.rul as rul
		  from #colPD# p
		 where tab = '#Arguments.tabla#'
		order by sec
	</cfquery>

	<cfset Lvar_CREATE = vbCrLf & "CREATE TABLE #Arguments.tabla# (">
	<cfset LvarSpaces = repeatString(" ",31)>
	<cfset LvarComma = " ">
	<cfset Lvarts_rversion	= false>
	<cfset LvarIdentity		= "">
	<!--- CREA CAMPOS --->
	<cfloop query="rsSQL">
		<cfset LvarCol = fnGenColumn (rsSQL.tab, rsSQL.col, rsSQL.tip, rsSQL.lon, rsSQL.dec, rsSQL.obl, rsSQL.dfl, rsSQL.lov)>
		<cfset Lvar_CREATE = Lvar_CREATE & vbCrLf & vbTab & LvarComma & left(rsSQL.col & LvarSpaces,31) & left(LvarCol.SQLtip & LvarSpaces, 20)>
		<cfset LvarComma = ",">
		<cfif (rsSQL.ide EQ "1")>
			<cfset Lvar_CREATE = Lvar_CREATE & " NOT NULL GENERATED ALWAYS AS IDENTITY">
			<cfset LvarIdentity = rsSQL.col>
		<cfelseif rsSQL.col EQ "TS_RVERSION">
			<cfset Lvar_CREATE = Lvar_CREATE & " NOT NULL GENERATED ALWAYS FOR EACH ROW ON UPDATE AS ROW CHANGE TIMESTAMP">
		<cfelse>
			<cfset Lvar_CREATE = Lvar_CREATE & LvarCol.SQLdfl & LvarCol.SQLnul>
			<cfif (rtrim(rsSQL.rul) NEQ "")>
				<cfset Lvar_CREATE = Lvar_CREATE & vbCrLf & vbTab & " CONSTRAINT #GvarObj.fnGetName(GvarTabPrefijo,"CK",rsSQL.sec)# CHECK (#rsSQL.rul#)">
			</cfif>
		</cfif>
	</cfloop>

	<cfset Lvar_CREATE = Lvar_CREATE & vbCrLf & vbTab & ")" & "#EXEC#">

	<cfreturn Lvar_CREATE>
</cffunction>

<cffunction name="fnGenAddCheck" output="false" returntype="string">
	<cfargument name="tabla">
	<cfargument name="rule">

	<cfset Lvar_CHECK = "ALTER TABLE #Arguments.Tabla# ADD CONSTRAINT #GvarTabPrefijo#_CK CHECK (#arguments.rule#)#EXEC#">
	<cfset Lvar_CHECK &= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#Arguments.Tabla#')#EXEC#">
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

	<cfif Arguments.tip EQ "P">
		<cfset Lvar_CREATE = "ALTER TABLE #Arguments.tab# DROP CONSTRAINT ""#Arguments.key#"" /* PRIMARY KEY (#Arguments.cols#) */#EXEC#">
		<cfset Lvar_CREATE &= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#Arguments.tab#')#EXEC#">
	<cfelseif Arguments.tip EQ "A">
		<cfset Lvar_CREATE = "ALTER TABLE #Arguments.tab# DROP CONSTRAINT ""#Arguments.key#"" /* UNIQUE KEY (#Arguments.cols#) */#EXEC#">
		<cfset Lvar_CREATE &= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#Arguments.tab#')#EXEC#">
	<cfelseif Arguments.tip EQ "U">
		<cfset Lvar_CREATE = "DROP INDEX ""#Arguments.key#"" /* UNIQUE INDEX (#Arguments.cols#) */#EXEC#">
	<cfelseif Arguments.tip EQ "I">
		<cfset Lvar_CREATE = "DROP INDEX ""#Arguments.key#"" /* INDEX (#Arguments.cols#) */#EXEC#">
	<cfelseif Arguments.tip EQ "F" or Arguments.tip EQ "D">
		<cfif FKs>
			<cfset Lvar_CREATE = "ALTER TABLE #Arguments.tab# DROP CONSTRAINT ""#Arguments.key#"" /* REFERENCES #Arguments.ref# (#Arguments.colsR#) */#EXEC#">
			<cfset Lvar_CREATE &= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#Arguments.tab#')#EXEC#">
		<cfelseif Arguments.idx NEQ "">
			<!--- FK: Si existe indice hay que borrarlo --->
			<cfset Lvar_CREATE = "DROP INDEX ""#Arguments.idx#"" /* REFERENCES INDEX (#Arguments.colsR#) */#EXEC#">
		</cfif>
	</cfif>

	<cfif listFind("P,A",Arguments.tip)>
		<!--- Si se creo un indice igual antes que el CONSTRAINT hay que borrar el indice porque puede permanecer --->
		<cfif Arguments.idx NEQ "">
			<cfset LvarIDX = Arguments.idx>
		<cfelse>
			<cfset LvarIDX = Arguments.key>
		</cfif>
		<cfset Lvar_CREATE &= "/* IF X GT 0:SELECT count(1) as X FROM SYSCAT.INDEXES WHERE TABSCHEMA = '#GvarSchema#' AND TABNAME = '#Arguments.tab#' AND INDNAME = '#LvarIDX#' */#vbCrLf#">
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
		<cfset Lvar_CREATE &= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#Arguments.tab#')#EXEC#">
	<cfelseif Arguments.tip eq "A">
		<cfset Lvar_CREATE = "ALTER TABLE #Arguments.tab# ADD CONSTRAINT #GvarObj.fnGetName(GvarTabPrefijo,"AK",sec)# UNIQUE (#Arguments.cols#)#EXEC#">
		<cfset Lvar_CREATE &= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#Arguments.tab#')#EXEC#">
	<cfelseif Arguments.tip eq "U">
		<cfset Lvar_CREATE = "CREATE UNIQUE INDEX #GvarObj.fnGetName(GvarTabPrefijo,"UI",sec)# ON #Arguments.tab# (#Arguments.cols#)#EXEC#">
	<cfelseif Arguments.tip eq "I">
		<cfset Lvar_CREATE = "CREATE INDEX #GvarObj.fnGetName(GvarTabPrefijo,"ID",sec)# ON #Arguments.tab# (#Arguments.cols#)#EXEC#">
	<cfelseif Arguments.tip eq "F">
		<cfif FKs>
			<cfset Lvar_CREATE = "ALTER TABLE #Arguments.tab# ADD CONSTRAINT #GvarObj.fnGetName(GvarTabPrefijo,"FK",sec)# FOREIGN KEY (#Arguments.cols#) REFERENCES #ref# (#Arguments.colsR#)#EXEC#">
			<cfset Lvar_CREATE &= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#Arguments.tab#')#EXEC#">
		<cfelseif idxTip EQ "+">
			<cfset Lvar_CREATE = "CREATE INDEX #GvarObj.fnGetName(GvarTabPrefijo,"FI",sec)# ON #Arguments.tab# (#Arguments.cols#)#EXEC#">
		</cfif>
	</cfif>

	<cfreturn Lvar_CREATE & vbCrLf>
</cffunction>

<!--- Objetos (PK,AK,FK,UI,FI,ID) a renombrar porque su nombre está en otra tabla --->
<cffunction name="sbRenameObjs" access="package" output="yes" returntype="void">
	<cfargument name="conexion" required="yes">
	<cfargument name="CNSTs" required="yes">
	<cfargument name="INDXs" required="yes">
	<cfargument name="IDren" required="yes">

	<!--- Valida los Constraints definidos en DBM --->
		<!--- En los Constraints de base de datos de otra tabla --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into DBMrenames (owner, sch, tab, old, tip, fecha, sts)
			SELECT	c.tab, '#GvarSchema#', TABNAME, CONSTNAME, 
					CASE 
						WHEN TYPE = 'P' then 'PK'
						WHEN TYPE = 'U' then 'AK' 
						WHEN TYPE = 'F' then 'FK'
						WHEN TYPE = 'K' then 'CK'
					END,
					<cf_dbfunction name="today">, 0
			  FROM SYSCAT.TABCONST, #preserveSingleQuotes(Arguments.CNSTs)# c
			 WHERE TABSCHEMA	=  '#GvarSchema#'
			   AND CONSTNAME	=  c.obj_name
			   AND TABNAME		<> c.tab
			   AND TYPE			<> 'I'
		</cfquery>
		<!--- En los Indices de base de datos de cualquier tabla --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into DBMrenames (owner, sch, tab, old, tip, fecha, sts)
			SELECT	c.tab, '#GvarSchema#', TABNAME, INDNAME, 
					CASE 
						WHEN UNIQUERULE = 'D' THEN 'ID'
						WHEN UNIQUERULE = 'U' AND SYSTEM_REQUIRED = 1 THEN 'AD'
						ELSE UNIQUERULE	|| 'I'
					END, 
					<cf_dbfunction name="today">, 0
			  FROM SYSCAT.INDEXES, #preserveSingleQuotes(Arguments.CNSTs)# c
			 WHERE TABSCHEMA		=  '#GvarSchema#'
			   AND INDNAME			= c.obj_name
			   AND SYSTEM_REQUIRED	= 0
		</cfquery>
	<!--- Valida los Indices definidos en DBM --->
		<!--- En los Constraints de base de datos de cualquier tabla --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into DBMrenames (owner, sch, tab, old, tip, fecha, sts)
			SELECT	c.tab, '#GvarSchema#', TABNAME, CONSTNAME, 
					CASE 
						WHEN TYPE = 'P' then 'PK'
						WHEN TYPE = 'U' then 'AK' 
						WHEN TYPE = 'F' then 'FK'
						WHEN TYPE = 'K' then 'CK'
					END,
					<cf_dbfunction name="today">, 0
			  FROM SYSCAT.TABCONST, #preserveSingleQuotes(Arguments.INDXs)# c
			 WHERE TABSCHEMA	=  '#GvarSchema#'
			   AND CONSTNAME	= c.obj_name
			   AND TYPE			<> 'I'
		</cfquery>
		<!--- En los Indices de base de datos de OTRA tabla --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into DBMrenames (owner, sch, tab, old, tip, fecha, sts)
			SELECT	c.tab, '#GvarSchema#', TABNAME, INDNAME, 
					CASE 
						WHEN UNIQUERULE = 'D' THEN 'ID'
						WHEN UNIQUERULE = 'U' AND SYSTEM_REQUIRED = 1 THEN 'AD'
						ELSE UNIQUERULE	|| 'I'
					END, 
					<cf_dbfunction name="today">, 0
			  FROM SYSCAT.INDEXES, #preserveSingleQuotes(Arguments.INDXs)# c
			 WHERE TABSCHEMA		=  '#GvarSchema#'
			   AND INDNAME			= c.obj_name
			   AND TABNAME			<> c.tab
			   AND SYSTEM_REQUIRED	= 0
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
				ALTER TABLE #rsSQL.tab# DROP CONSTRAINT #rsSQL.old#
			</cfquery>
			<cfquery datasource="#Arguments.Conexion#">
				update DBMrenames
				   set sts = 2
				 WHERE IDren = #rsSQL.IDren#
			</cfquery>
		<cfelse>
			<cfquery datasource="#Arguments.Conexion#">
				RENAME INDEX "#trim(rsSQL.old)#" TO DBMREN_#rsSQL.tip##rsSQL.IDren#
			</cfquery>
			<cfquery datasource="#Arguments.Conexion#">
				update DBMrenames
				   set sts = 1
				 WHERE IDren = #rsSQL.IDren#
			</cfquery>
		</cfif>
	</cfloop>
</cffunction>

<cffunction name="fnGenRename" access="package" output="false" returntype="string">
	<cfargument name="OLDNEW" required="yes">
	<cfargument name="tab" required="yes">
	<cfargument name="tipo" required="yes">
	<cfargument name="oldName" required="yes">
	<cfargument name="newName" required="yes">

	<cfargument name="tip">
	<cfargument name="sec">
	<cfargument name="cols">
	<cfargument name="ref">
	<cfargument name="colsR">

	<cfset LvarSQL_RENAME = "">
	<cfif compare(Arguments.oldName, Arguments.newName) NEQ 0>
		<cfif find("INDEX",Arguments.tipo)>
			<cfset LvarSQL_RENAME &= "RENAME INDEX ""#trim(Arguments.oldName)#"" TO #Arguments.newName##EXEC#">
		<cfelse>
			<cfif arguments.OLDNEW EQ "OLD" OR arguments.OLDNEW EQ "REN">
				<cfset LvarSQL_RENAME &= "ALTER TABLE #Arguments.tab# DROP CONSTRAINT ""#Arguments.oldName#""#EXEC#">
				<cfset LvarSQL_RENAME &= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#Arguments.tab#')#EXEC#">
			</cfif>
			<cfif arguments.OLDNEW EQ "NEW" OR arguments.OLDNEW EQ "REN">
				<cfif Arguments.tip EQ "C">
					<cfset LvarSQL_RENAME &= "ALTER TABLE #Arguments.tab# ADD CONSTRAINT #Arguments.newName# CHECK (#Arguments.cols#)" & "#EXEC#">
					<cfset LvarSQL_RENAME &= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#Arguments.tab#')#EXEC#">
				<cfelse>
					<cfset LvarSQL_RENAME &= fnGenAddKey(Arguments.tab, Arguments.tip, GvarObj.fnDESC(Arguments.cols), Arguments.ref, Arguments.colsR, Arguments.sec, 0, "", (Arguments.tip EQ "F") )>
				</cfif>
			</cfif>
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
		<cfset Lvar_DROP &= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#Arguments.Tabla#')#EXEC#">
	</cfif>
	<cfset Lvar_DROP &= "ALTER TABLE #Arguments.Tabla# DROP COLUMN #Arguments.Col##EXEC#">
	<cfset Lvar_DROP &= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#Arguments.Tabla#')#EXEC#">
	<cfreturn Lvar_DROP>
</cffunction>

<cffunction name="fnGenRenTab" output="false" returntype="string">
	<cfargument name="tabOld">
	<cfargument name="tabNew">

	<cfset Lvar_RENAME = "RENAME TABLE ""#trim(Arguments.tabOld)#"" TO #Arguments.tabNew##EXEC#">

	<cfreturn Lvar_RENAME>
</cffunction>

<cffunction name="fnGenDelCheck" output="false" returntype="string">
	<cfargument name="tabla">
	<cfargument name="check">
	<cfargument name="rule">

	<cfset Lvar_CHECK = "ALTER TABLE #Arguments.Tabla# DROP CONSTRAINT ""#Arguments.Check#""#EXEC#">
	<cfset Lvar_CHECK &= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#Arguments.Tabla#')#EXEC#">

	<cfreturn Lvar_CHECK>
</cffunction>

<cffunction name="fnSiguienteIDE" output="false" returntype="string">
	<cfargument name="conexion">
	<cfargument name="tab">
	<cfargument name="col">

	<cfset var rsSQL = "">
	<cfquery name="rsSQL" datasource="#arguments.conexion#">
		select max(#col#) as mayor
		  from #tab#
	</cfquery>

	<cfif rsSQL.mayor EQ "">
		<cfreturn "1">
	<cfelse>
		<cfreturn "#rsSQL.mayor+1#">
	</cfif>
</cffunction>

<cfscript>
	Function fnGenAddColumn(tab1, col, tip, lon, dec, ide, obl, dfl, rul, lov, sec)
	// Cuando es identity:
	//  	ALTER TABLE tab ADD          col tip(lon) DEFAULT 0 NOT NULL
	//  	ALTER TABLE tab ALTER COLUMN col DROP DEFAULT
	//  	ALTER TABLE tab ALTER COLUMN col SET GENERATED ALWAYS AS IDENTITY
	//  	UPDATE      tab SET          col = DEFAULT
	// Con Valor Inicial o es obl sin dfl (primer valor de lov o dfl de tipo):
	//  	ALTER TABLE tab ADD   col tip(lon,dec) NULL
	//  	UPDATE      tab SET   col = VALOR_INICIAL
	//  	ALTER TABLE tab ALTER COLUMN col SET DEFAULT dfl		-- Cuando hay dfl
	//  	ALTER TABLE tab ALTER COLUMN col SET NOT NULL			-- Cuando es obl
	// SINO
	//  	ALTER TABLE tab ADD   col tip(lon,dec) {CONSTRAINT TABLA_DF01 DEFAULT dfl} {NULL | NOT NULL}
	//
	// ALTER TABLE tab ADD CONSTRAINT tabla_CK01 CHECK (rul)		-- Cuando hay rul
	{
		tab1=trim(tab1);col=trim(col);tip=trim(tip);lon=trim(lon);dec=trim(dec);obl=trim(obl);dfl=trim(dfl);rul=trim(rul);
		LvarCol = fnGenColumn (tab1, col, tip, lon, dec, obl, dfl, lov);

		LvarSQL_ALTER = "";

		// Pone nombre + tipo
		
		
		if (ide EQ "1")
		{
			LvarSQL_ALTER &= "ALTER TABLE #tab1# ADD #col# #LvarCol.SQLtip# DEFAULT 0 NOT NULL#EXEC#";
			LvarSQL_ALTER &= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#tab1#')#EXEC#";
			LvarSQL_ALTER &= "ALTER TABLE #tab1# ALTER COLUMN #col# DROP DEFAULT#EXEC#";
			LvarSQL_ALTER &= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#tab1#')#EXEC#";
			LvarSQL_ALTER &= "ALTER TABLE #tab1# ALTER COLUMN #col# SET GENERATED ALWAYS AS IDENTITY#EXEC#";
			LvarSQL_ALTER &= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#tab1#')#EXEC#";
			LvarSQL_ALTER &= "UPDATE #tab1# SET #col# = DEFAULT#EXEC#";
		}
		else if (tip EQ "TS")
		{
			LvarSQL_ALTER &= "ALTER TABLE #tab1# ADD #col# TIMESTAMP NOT NULL GENERATED ALWAYS FOR EACH ROW ON UPDATE AS ROW CHANGE TIMESTAMP#EXEC#";
			LvarSQL_ALTER &= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#tab1#')#EXEC#";
		}
		else
		{
			// Si es obligatorio elimina los nulls.
			if (LvarCol.dflIni NEQ "" AND LvarCol.dflIni NEQ LvarCol.dfl)
			{
				LvarSQL_ALTER &= "ALTER TABLE #tab1# ADD #col# #LvarCol.SQLtip##EXEC#";
				LvarSQL_ALTER &= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#tab1#')#EXEC#";
				LvarSQL_ALTER &= "UPDATE      #tab1# SET #col# = #LvarCol.dflIni##EXEC#";
				// Pone default y obligatorio
				if (dfl NEQ "")
				{
					LvarSQL_ALTER &= "ALTER TABLE #tab1# ALTER COLUMN #col##LvarCol.SQLdfl2##EXEC#";
					LvarSQL_ALTER &= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#tab1#')#EXEC#";
				}
				if (obl EQ "1")
				{
					LvarSQL_ALTER &= "ALTER TABLE #tab1# ALTER COLUMN #col##LvarCol.SQLnul2##EXEC#";
					LvarSQL_ALTER &= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#tab1#')#EXEC#";
				}
			}
			else
			{
				// Crea la Columna
				LvarSQL_ALTER &= "ALTER TABLE #tab1# ADD #col# #LvarCol.SQLtip##LvarCol.SQLdfl##LvarCol.SQLnul##EXEC#";
				LvarSQL_ALTER &= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#tab1#')#EXEC#";
			}
			
			// Pone regla
			if (rul NEQ "")
			{
				LvarSQL_ALTER &= "ALTER TABLE #tab1# ADD CONSTRAINT #GvarObj.fnGetName(GvarTabPrefijo,"CK",sec)# CHECK (#rul#)" & "#EXEC#";
				LvarSQL_ALTER &= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#tab1#')#EXEC#";
			}
		}

		return LvarSQL_ALTER & vbCrLf;
	}

	Function fnGenChgColumn(
							conexion,
							tab, col,   colAnt,
							tip1, lon1, dec1, ide1, obl1, dfl1, dflN1, rul1, chk1, 
							tip2, lon2, dec2, ide2, obl2, dfl2, rul2,  lov2, sec2,
							ideT
							)
	// ALTER TABLE tab DROP CONSTRAINT nombre_anterior						-- Solo si hay rul anterior
	// RENOMBRAR cuando hay cambio de nombre en columna: colDB.colAnt
	//		ALTER TABLE tab DROP   COLUMN col
	//		ALTER TABLE tab ADD	   col TIPO_DE_DATOS(lon,dec)
	//		UPDATE tab SET col = colAnt
	//		ALTER TABLE tab DROP   COLUMN colAnt
	// Cambio simple (solo cuando aumenta longitud de un mismo tipo):
	// 		ALTER TABLE tab ALTER COLUMN SET TYPE col TIPO(lon)
	// Regenerar (cuando cambia tipo, cambia LOB o cambia identity):
	//		ALTER TABLE tab ADD	col__NEW TIPO_DE_DATOS(lon,dec)
	//		UPDATE tabla SET col__NEW = col
	//		RENAME COLUMN:
	//		ALTER TABLE tab DROP   COLUMN col
	//		ALTER TABLE tab ADD	col TIPO_DE_DATOS(lon,dec)
	//		UPDATE tabla SET col = col__NEW
	//		ALTER TABLE tab DROP   COLUMN col__NEW
	// UPDATE tabla SET col = DFL_DEFAULT WHERE col IS NULL					-- Solo si cambia a obl
	// ALTER TABLE tab ALTER COLUMN col {NOT NULL | DROP NOT NULL }			-- Solo si cambia obl
	// ALTER TABLE tab ALTER COLUMN col {DEFAULT dfl | DROP DEFAULT} 		-- Solo si cambia dfl
	// ALTER TABLE tab ALTER COLUMN col CONSTRAINT tabla_CK01 CHECK (rul)	-- Solo si hay regla
	{
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
			LvarSQL_ALTER &= "ALTER TABLE #tab# DROP CONSTRAINT ""#chk1#"" /* CHECK (#rul1#) */#EXEC#";
			LvarSQL_ALTER &= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#tab#')#EXEC#";
		}

		// RENOMBRAR CUANDO HAY CAMBIO DE NOMBRE DE COLUMNA
		if (colAnt NEQ "")
		{
			LvarColAnt = fnGenColumn (tab, col, tip1, lon1, dec1, "0", "", "");
			obl1 = "0";	dfl1 = "";
			LvarSQL_ALTER &= "/* IF X GT 1:SELECT count(1) as X FROM SYSCAT.COLUMNS WHERE	TABSCHEMA = '#GvarSchema#' AND TABNAME = '#tab#' AND (COLNAME='#col#' OR COLNAME='#colAnt#') */#vbCrLf#";
			LvarSQL_ALTER &= "ALTER TABLE #tab# DROP  COLUMN ""#col#""#EXEC#";
			LvarSQL_ALTER &= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#tab#')#EXEC#";
			LvarSQL_ALTER &= "ALTER TABLE #tab# ADD   #col# #LvarColAnt.SQLtip##EXEC#";
			LvarSQL_ALTER &= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#tab#')#EXEC#";
			LvarSQL_ALTER &= "UPDATE      #tab# SET   #col# = ""#colAnt#""#EXEC#";
			LvarSQL_ALTER &= "ALTER TABLE #tab# DROP   COLUMN ""#colAnt#""#EXEC#";
			LvarSQL_ALTER &= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#tab#')#EXEC#";
		}
		
		// Cambiar Identity from "BY DEFAULT" to "ALWAYS"
		if (ide1 EQ "1" AND ide2 EQ "1" AND ideT EQ "D" AND lon1 EQ lon2)
		{
			LvarSQL_ALTER &= "ALTER TABLE #tab# ALTER #col# SET GENERATED ALWAYS#EXEC#";
			LvarSQL_ALTER &= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#tab#')#EXEC#";
			return LvarSQL_ALTER;
		}
		
		// Cambio a Timestamp
		if (tip1 NEQ "TS" AND tip2 EQ "TS")
		{
			LvarSQL_ALTER &= "ALTER TABLE #tab# DROP COLUMN ""#col#""#EXEC#";
			LvarSQL_ALTER &= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#tab#')#EXEC#";
			LvarSQL_ALTER &= fnGenAddColumn(tab, col, tip2, lon2, dec2, ide2, obl2, dfl2, rul2, lov2, sec2);
			return LvarSQL_ALTER;
		}
		else if (tip2 EQ "TS")
		{
			return "";
		}
		
		// No hay restriccion especial en LOBs
		LvarLOBs = false;
		
		// Cambio entre numeros (de Integer a Numeric)
		LvarNumToNum = 	(tip1 EQ "I" AND tip2 EQ "N");
		
		// Cambio entre char y varchar
		LvarToCHAR =	(tip1 EQ "C" AND tip2 EQ "V") OR
						(tip1 EQ "V" AND tip2 EQ "C");
		
		// Cambio Simple: Si se mantiene el tipo pero aumenta la longitud o decimales
		LvarDisminuye	= lon1 GT lon2 OR dec1 GT dec2 OR lon1-dec1 GT lon2-dec2;
		LvarSimple 		= NOT LvarDisminuye AND (LvarNumToNum OR LvarToCHAR OR (tip1 EQ tip2 AND (lon1 NEQ lon2 OR dec1 NEQ dec2)));

		// Regenerar: cambio de Tipo o LOB o poner/quitar Identity
 		LvarRegenerar 	= (tip1 NEQ tip2 OR ide1 NEQ ide2 OR LvarDisminuye);
		
		if (LvarSimple and ide2 EQ "1") // Cambio simple a un Identity
		{	
			if (ide1 EQ "1")
			{
				LvarSQL_ALTER &= "ALTER TABLE #tab# ALTER #col# DROP IDENTITY#EXEC#";
				LvarSQL_ALTER &= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#tab#')#EXEC#";
			}
			LvarSQL_ALTER &= "ALTER TABLE #tab# ALTER COLUMN #col# SET DATA TYPE #LvarCol.SQLtip##EXEC#";
			LvarSQL_ALTER &= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#tab#')#EXEC#";
			LvarSQL_ALTER &= "ALTER TABLE #tab# ALTER #col# SET GENERATED ALWAYS AS IDENTITY#EXEC#";
			LvarSQL_ALTER &= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#tab#')#EXEC#";
			LvarSQL_ALTER &= "ALTER TABLE #tab# ALTER #col# RESTART WITH #fnSiguienteIDE(conexion, tab, col)##EXEC#";
			LvarSQL_ALTER &= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#tab#')#EXEC#";
		}
		else if (LvarSimple AND ide1 EQ ide2)
		{
			LvarSQL_ALTER &= "ALTER TABLE #tab# ALTER COLUMN #col# SET DATA TYPE #LvarCol.SQLtip##EXEC#";
			LvarSQL_ALTER &= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#tab#')#EXEC#";
			if (tip2 EQ "V")
			{
				LvarSQL_ALTER &= "UPDATE #tab# SET #col# = RTRIM(#col#)#EXEC#";
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
			if (ide1 EQ "0" AND ide2 EQ "1")
			{
				LvarAddUpd	= "";
				LvarAddUpd	&= "/* IF X GT 0:SELECT count(1) as X FROM SYSCAT.COLUMNS WHERE	TABSCHEMA = '#GvarSchema#' AND TABNAME = '#tab#' AND COLNAME='#col__NEW#' */#vbCrLf#";
				LvarAddUpd	&= "UPDATE      #tab# SET   #col# = #col__NEW# WHERE (SELECT COUNT(1) FROM #tab# WHERE #col# IS NOT NULL) = 0 AND (SELECT COUNT(1) FROM #tab# WHERE #col__NEW# IS NOT NULL) > 0#EXEC#";
				LvarAddUpd	&= "/* IF X GT 0:SELECT count(1) as X FROM SYSCAT.COLUMNS WHERE	TABSCHEMA = '#GvarSchema#' AND TABNAME = '#tab#' AND COLNAME='#col__NEW#' */#vbCrLf#";
				LvarAddUpd	&= "ALTER TABLE #tab# DROP  COLUMN ""#col__NEW#""#EXEC#";
				LvarAddUpd	&= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#tab#')#EXEC#";
				LvarAddUpd	&= "ALTER TABLE #tab# ADD   #col__NEW# #LvarCol.SQLtip##EXEC#";
				LvarAddUpd	&= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#tab#')#EXEC#";
				LvarAddUpd	&= "UPDATE      #tab# SET   #col__NEW# = #fnCast(col, tip1, tip2, lon2)##EXEC#";
				LvarAddUpd	&= "ALTER TABLE #tab# DROP  COLUMN ""#col#""#EXEC#";
				LvarAddUpd	&= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#tab#')#EXEC#";
				LvarAddUpd	&= "ALTER TABLE #tab# ADD   #col# #LvarCol.SQLtip# DEFAULT 0 NOT NULL#EXEC#";
				LvarAddUpd	&= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#tab#')#EXEC#";
				LvarAddUpd	&= "ALTER TABLE #tab# ALTER COLUMN #col# DROP DEFAULT#EXEC#";
				LvarAddUpd	&= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#tab#')#EXEC#";
				LvarAddUpd	&= "ALTER TABLE #tab# ALTER COLUMN #col# SET GENERATED ALWAYS AS IDENTITY#EXEC#";
				LvarAddUpd	&= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#tab#')#EXEC#";
				LvarAddUpd	&= "UPDATE      #tab# SET   #col# = DEFAULT#EXEC#";
				// ACTUALIZA TODAS LAS FKs QUE UTILIZAN EL identity VIEJO POR EL VALOR DEL identity NUEVO (Contribución de Gustavo Fonseca)
				LvarAddUpd	&= GvarObj.fnRecurs_KEYsCHGtoIDE("UPDATE", tab, col__NEW, col, tab, col, conexion, EXEC);
				obl1="1"; obl2="1";
				dfl1=""; dfl2="";

				LvarSQL_ALTER &= LvarAddUpd;
				LvarSQL_ALTER &= "ALTER TABLE #tab# DROP   COLUMN ""#col__NEW#""#EXEC#";
				LvarSQL_ALTER &= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#tab#')#EXEC#";
			}
			// Convertir diferentes tipos
			else
			{
				LvarAddUpd = "";
				LvarAddUpd &= "ALTER TABLE #tab# ADD   #col__NEW# #LvarCol.SQLtip##EXEC#";
				LvarAddUpd &= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#tab#')#EXEC#";
				LvarAddUpd &= "UPDATE      #tab# SET   #col__NEW# = #fnCast(col, tip1, tip2, lon2)##EXEC#";
				obl1 = "0";	dfl1 = "";

				LvarSQL_ALTER &= "/* IF X GT 0:SELECT count(1) as X FROM SYSCAT.COLUMNS WHERE	TABSCHEMA = '#GvarSchema#' AND TABNAME = '#tab#' AND COLNAME='#col__NEW#' */#vbCrLf#";
				LvarSQL_ALTER &= "UPDATE      #tab# SET    #col# = #fnCast(col__NEW, tip2, tip1, lon1)# WHERE (SELECT COUNT(1) FROM #tab# WHERE #col# IS NOT NULL) = 0 AND (SELECT COUNT(1) FROM #tab# WHERE #col__NEW# IS NOT NULL) > 0#EXEC#";
				LvarSQL_ALTER &= "/* IF X GT 0:SELECT count(1) as X FROM SYSCAT.COLUMNS WHERE	TABSCHEMA = '#GvarSchema#' AND TABNAME = '#tab#' AND COLNAME='#col__NEW#' */#vbCrLf#";
				LvarSQL_ALTER &= "ALTER TABLE #tab# DROP   COLUMN ""#col__NEW#""#EXEC#";
				LvarSQL_ALTER &= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#tab#')#EXEC#";
				LvarSQL_ALTER &= LvarAddUpd;
				LvarSQL_ALTER &= "ALTER TABLE #tab# DROP   COLUMN ""#col#""#EXEC#";
				LvarSQL_ALTER &= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#tab#')#EXEC#";
				LvarSQL_ALTER &= "ALTER TABLE #tab# ADD    #col# #LvarCol.SQLtip##EXEC#";
				LvarSQL_ALTER &= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#tab#')#EXEC#";
				LvarSQL_ALTER &= "UPDATE      #tab# SET    #col# = #col__NEW##EXEC#";
				LvarSQL_ALTER &= "ALTER TABLE #tab# DROP   COLUMN ""#col__NEW#""#EXEC#";
				LvarSQL_ALTER &= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#tab#')#EXEC#";
			}
		}

		if (compare(dfl1,dfl2) NEQ 0)
		{
			LvarSQL_ALTER &= "ALTER TABLE #tab# ALTER COLUMN #col##LvarCol.SQLdfl2##EXEC#";
			LvarSQL_ALTER &= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#tab#')#EXEC#";
		}
		
		if (obl1 NEQ obl2)
		{
			if (obl1 EQ "0" and obl2 EQ "1" and tip2 NEQ "L")
			{
				LvarSQL_ALTER &= "UPDATE #tab# SET #col# = #LvarCOL.dflObl# WHERE #col# IS NULL#EXEC#";
			}
			LvarSQL_ALTER &= "ALTER TABLE #tab# ALTER COLUMN #col##LvarCol.SQLnul2##EXEC#";
			LvarSQL_ALTER &= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#tab#')#EXEC#";
		}

		if (rul2 NEQ "")
		{
			LvarSQL_ALTER &= "ALTER TABLE #tab# ADD " & "CONSTRAINT #chk2# CHECK (#rul2#)#EXEC#";
			LvarSQL_ALTER &= "CALL SYSPROC.ADMIN_CMD ('REORG TABLE #GvarSchema#.#tab#')#EXEC#";
		}

		return LvarSQL_ALTER & vbCrLf;
	}
	
	Function fnCast(col,tip_ORI,tip_DST,lon_DST)
	{
	/*
	 ORI/DST	T = ts_rversion		D						S					N							B					
		T		X					to_date(OO)				to_char(OO,*)		to_number(to_char(OO,*))	CtoB(to_char(OO,*))	
		D		SYSTIMESTMAP		X						to_char(OO,*)		to_number(to_char(OO,*))	CtoB(to_char(OO,*))	
		S		SYSTIMESTMAP		to_date(OO,*)			X					to_number(OO)				CtoB(C)				
		N		SYSTIMESTMAP		to_date(OO,*)			to_char(OO)			X							CtoB(to_char(OO))	
		B		SYSTIMESTMAP		to_date(BtoC(OO),*)		to_char(BtoC(OO))	to_number(BtoC(OO))			X
		
		(*) La convencion para convertir fechas entre tipos es YYYYMMDD por lo que se perdern las horas 				
	*/		
		tip2_ORI = GvarObj.fnTipoPDtoCF(tip_ORI);
		tip2_DST = GvarObj.fnTipoPDtoCF(tip_DST);
		
		toChar = "TRIM(VARCHAR(#col#))";

		if (tip_ORI NEQ tip_DST AND tip2_DST EQ 'B')
		{
			return "CAST(#toChar# as BLOB)";
		}
		else if (tip_ORI NEQ tip_DST AND tip_DST EQ 'CL')
		{
			return "CAST(#toChar# as CLOB)";
		}
		else if (tip2_ORI EQ tip2_DST)
		{
			if (tip_ORI EQ 'CL')
				return "TRIM(VARCHAR(SUBSTRING(#col#,1,#lon_DST#,OCTETS)))";
			if (tip2_DST EQ "S")
				return "SUBSTRING(#toChar#,1,#lon_DST#,OCTETS)";
			else if (tip_ORI EQ "D1")
				return "timestamp(#col#, '00:00:00')";
			else if (tip_ORI EQ "D2")
				return "timestamp(current date, #col#)";
			else if (tip_DST EQ "D1")
				return "date(#col#)";
			else if (tip_DST EQ "D2")
				return "time(#col#)";
			else
				return col;
		}
		else if (tip2_DST EQ "T")
		{
			if (col NEQ "ts_rversion")
			{
				fnThrow ("Campo #col# no puede ser TIMESTAMP");
			}
			return "";
		}
		else if (tip2_DST EQ "D")
		{
			return "cast(SUBSTRING(#toChar# || ' 00:00:00',1,19,CODEUNITS16) AS TIMESTAMP)";
		}
		else if (tip2_DST EQ "S")
		{
			return "#toChar#";
		}
		else if (tip2_DST EQ "N")
		{
			return "CAST(#toChar# AS DECIMAL(28,10))";
		}
		else if (tip2_DST EQ "B")
		{
			return "CAST(#toChar# AS BLOB)";
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
		//    Numricos Entero:
		//        biginteger,integer,int,smallint,tinyint I=Integer                20,10,5,3
		//    Numricos Punto Fijo:
		//        NUMBER,decimal,dec                      N=NUMBER                n,d
		//    Numricos Punto Flotante:
		//        real, float, double precision           F=Float                  7,15
		//    Numricos Montos:
		//        money,smallmoney                        M=Money                  18,4
		//    Logicos:
		//        bit                                     L=Logico                 1
		//    Fecha:
		//        date, datetime, smalldatetime           D=DateTime               0
		//    Control de Concurrencia optimstico:
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
			LvarSQL_COL = "VARCHAR(" & lon & ")";
			LvarIsSTR = True;
			LvarDefaultDfl = "' '";
		}
		else if (tip EQ "B")
		{
			LvarCol.SQLtip2 = "B";
			LvarSQL_COL = "BLOB(" & lon & ")";
			LvarDefaultDfl = "BLOB(X'00')";
		}
		else if (tip EQ "VB")
		{
			LvarCol.SQLtip2 = "B";
			LvarSQL_COL = "BLOB(" & lon & ")";
			LvarDefaultDfl = "BLOB(X'00')";
		}
		else if (tip EQ "CL")
		{
			LvarCol.SQLtip2 = "C";
			LvarSQL_COL = "CLOB(2G) NOT LOGGED";
			LvarIsSTR = True;
			LvarDefaultDfl = "' '";
		}
		else if (tip EQ "BL")
		{
			LvarCol.SQLtip2 = "B";
			LvarSQL_COL = "BLOB(2G) NOT LOGGED";
			LvarDefaultDfl = "BLOB(X'00')";
		}
		else if (tip EQ "I")
		{
			LvarCol.SQLtip2 = "N";
            if (lon <= 3)
			{
                LvarSQL_COL = "DECIMAL(3)";
			}
            else if (lon <= 5)
			{
                LvarSQL_COL = "SMALLINT";
			}
            else if (lon <= 10)
			{
                LvarSQL_COL = "INTEGER";
			}
            else
			{
				LvarSQL_COL = "BIGINT";
			}

			LvarDefaultDfl = "0";
		}
		else if (tip EQ "N")
		{
			LvarCol.SQLtip2 = "N";
			if (dec EQ 0)
			{
				LvarSQL_COL = "DECIMAL(" & lon & ")";
			}
			Else
			{
				LvarSQL_COL = "DECIMAL(" & lon & "," & dec & ")";
			}
	
			LvarDefaultDfl = "0";
		}
		else if (tip EQ "F")
		{
			LvarCol.SQLtip2 = "N";
			if (lon LTE 7)
			{
				LvarSQL_COL = "REAL";
			}
			Else
			{
				LvarSQL_COL = "FLOAT";
			}
			LvarDefaultDfl = "0";
		}
		else if (tip EQ "M")
		{
			LvarCol.SQLtip2 = "N";
			LvarSQL_COL = "DECIMAL(18,4)";
			LvarDefaultDfl = "0";
		}
		else if (tip EQ "L")
		{
			LvarCol.SQLtip2 = "N";
			LvarSQL_COL = "DECIMAL(1)";
			obl = "1";
			lov = "0,1";
			LvarDefaultDfl = "0";
		}
		else if (tip EQ "D")
		{
			LvarCol.SQLtip2 = "D";
			LvarSQL_COL = "TIMESTAMP";
			LvarDefaultDfl = "CURRENT TIMESTAMP";
		}
		else if (tip EQ "TS")
		{
			LvarCol.SQLtip2 = "T";
			LvarSQL_COL = "TIMESTAMP";
			LvarDefaultDfl = "CURRENT TIMESTAMP";
		}
		LvarCol.SQLtip = LvarSQL_COL;
		LvarCol.SQLstr = find("'",LvarDefaultDfl) NEQ 0;
		if (lov NEQ "" and lov NEQ "\t")
		{
			LvarDefaultDfl = listGetAt(GvarObj.fnLOVtoVALS(lov),1);
			if (LvarCol.SQLstr)
			{
				LvarDefaultDfl = "'#LvarDefaultDfl#'";
			}
		}
		
		// Defaults:
		//	.dfl2:		Valor default ajustado para compararlo con dfl1
		//	.dfl:		Valor default (para compararlo con .dflIni)
		//	.dflIni:	Valor inicial nicamente en ALTER TABLE ADD COLUMN
		//	.dflObl:	Valor para sustituir NULL en campos que se vuelven obligatorios
		//	.SQLdfl:	Clausula "SET DEFAULT val"	para CREATE TABLE y ALTER TABLE ADD
		//	.SQLdfl2:	Clausula "SET DEFAULT val | NULL" para ALTER TABLE MODIFY
		if (dfl NEQ "")
		{
			dfl = Trim(dfl);
			if (Asc(Right(dfl, 1)) EQ 160)
			{
				dfl = trim(Left(dfl, Len(dfl) - 1));
			}
			
			if (NOT listFind("USER,CURRENT TIMESTAMP",dfl))
			{
				if (LvarCol.SQLstr AND mid(dfl,1,1) NEQ "'")
				{
					dfl = "'#dfl#'";
				}
				else if (tip EQ "D" AND IsNumeric(dfl) AND Len(dfl) EQ 8)
				{
					dfl = "'#mid(dfl,1,4)#-#mid(dfl,5,2)#-#mid(dfl,7,2)# 00:00:00'";
				}
			}
			LvarCol.SQLdfl 	= " DEFAULT #dfl#";
			LvarCol.SQLdfl2 = " SET DEFAULT #dfl#";
		}
		else
		{
			LvarCol.SQLdfl = "";
			LvarCol.SQLdfl2 = " DROP DEFAULT";
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
			LvarCol.SQLnul2 = " SET NOT NULL";
		}
		else
		{
			LvarCol.SQLnul  = "";
			LvarCol.SQLnul2 = " DROP NOT NULL";
		}
		
		return LvarCol;
	}
</cfscript>
