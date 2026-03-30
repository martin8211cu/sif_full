<cfset vbCrLf	= chr(13) & chr(10)>
<cfset vbTab	= chr(9)>
<cfset EXEC = "#vbCrLf#go#vbCrLf#">
<cfset GvarOBJ = "">
<cfset GvarSchema = "">
<cfset GvarTabPrefijo = "">

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
	<cfreturn true>
</cffunction>
<!---
	****************************************
	CREAR LAS TABLAS DE TRABAJO PARA SYABASE
	****************************************

ALTER TABLE test RENAME CONSTRAINT test1_pk TO test_pk;
ALTER INDEX test1_pk RENAME TO test_pk;

--->
<cffunction name="creaTablas" access="package" output="no">
	<cfargument name="conexion" required="yes">
	
	<cfset GvarSchema = Application.dsinfo[arguments.conexion].Schema>
	<cf_dbfunction name="OP_CONCAT" returnvariable="CONCAT" datasource="#Arguments.conexion#">
	<cf_dbfunction name="FN_LEN" 	returnvariable="LEN" 	datasource="#Arguments.conexion#">

	<cf_dbtemp name="tabDB" returnvariable="tabDB" datasource="#arguments.conexion#">
		<cf_dbtempcol name="tab"		    	type="varchar(30)"	mandatory="yes">
		<cf_dbtempcol name="OP"		    		type="integer"		mandatory="yes" default="0">
		<cf_dbtempcol name="tabAnt"		    	type="varchar(30)"	mandatory="no">
	
		<cf_dbtempcol name="tuts"		    	type="varchar(1)"	mandatory="no">
		<cf_dbtempcol name="tib"		    	type="varchar(1)"	mandatory="no">
		<cf_dbtempcol name="seq"		    	type="tinyint"		mandatory="yes" default="0">

		<cf_dbtempkey cols="tab">
	</cf_dbtemp>

	<cf_dbtemp name="colDB" returnvariable="colDB" datasource="#arguments.conexion#">
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

	<cf_dbtemp name="keyDB" returnvariable="keyDB" datasource="#arguments.conexion#">
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
		<cf_dbtempindex cols="ref">
	</cf_dbtemp>

	<cf_dbtemp name="chkDB" returnvariable="chkDB" datasource="#arguments.conexion#">
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
	AJUSTA LA ESTRUCTURA POWER DESIGNER PARA SYBASE
	***********************************************
--->
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
			
		<cfif Arguments.colPD_colRPD EQ colRPD>
			<cfreturn>
		</cfif>
	<!--- FIN ajustes para colRPD --->
	
	
	<!--- Defaults: user_name() --->
	<cfquery name="rsSQL" datasource="#arguments.conexion#">
		update #colPD#
		   set dfl = 'suser_name()'
		 where dfl like '%user_name%()%'
		   and OP = #Arguments.OP#
	</cfquery>
	
	<!--- Defaults: datetime --->
	<cfquery name="rsSQL" datasource="#arguments.conexion#">
		update #colPD#
		   set dfl = 
		   		case 
					when dfl like '%getdate%()%' then 'getdate()' 
					when #LEN#(dfl)=8 then 'convert(datetime,''' #CONCAT# dfl #CONCAT# ''',112)' 
					else dfl
				end
		 where tip = 'D'
		   and OP = #Arguments.OP#
	</cfquery>
	
	<!--- GENERA LAS REGLAS DE LOS CHECKs --->
	<cfquery name="rsSQL" datasource="#arguments.conexion#">
		select c.tab, c.col, c.tip, c.obl, c.minVal, c.maxVal, c.lov
		  from #colPD# c
		 where (minVal IS NOT NULL OR maxVal IS NOT NULL OR lov IS NOT NULL)
		   and OP = #Arguments.OP#
	</cfquery>

	<cfset LvarTabsP = 0>
	<cfloop query="rsSQL">
		<cfif rsSQL.currentRow - LvarTabsP  GT 10>
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
			<cfset LvarRule = "#Arguments.col# is null or (#LvarRule#)">
		</cfif>
	
		<cfset LvarRule = "(#LvarRule#)">
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

	<cfset LvarTIP_TS = "*">
	
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
	<cfset LvarSysTypes = structNew()>
	<cfloop query="Arguments.rsOBJECTS">
		<cfset LvarTablaPD = trim(rsObjects.tab)>
		<cfset LvarTablaDB = trim(rsObjects.tab)>
		<cfif rsOBJECTS.currentRow - LvarTabsP GT 10>
			<cfset LvarTabsP = GvarOBJ.fnUpdateTabsP (Arguments.tipo, Arguments.tipoID, rsOBJECTS.currentRow)>
		</cfif>

		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
		   SELECT object_id('#LvarTablaPD#') as id
		</cfquery>
		<cfset LvarTAB_id = rsSQL.id>

		<!--- OBTIENE TABLA A RENOMBRAR --->
		<cfif LvarTAB_id EQ "" AND rsObjects.tabAnt NEQ "">
			<cfquery name="rsSQL" datasource="#Arguments.conexion#">
			   SELECT object_id('#rsObjects.tabAnt#') as id
			</cfquery>
			<cfset LvarTAB_id	= rsSQL.id>
			<cfif LvarTAB_id NEQ "">
				<cfset LvarTablaDB	= trim(rsObjects.tabAnt)>
			<cfelse>
				<cfset LvarTablaDB	= "">
			</cfif>
		</cfif>

		<cfif LvarTAB_id NEQ "">
			<cfquery name="rsInsert" datasource="#Arguments.conexion#">
				insert into #tabDB# (tab, tabAnt)
				values (
					  <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTablaPD#">
					 ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarTablaDB#"	null="#LvarTablaPD EQ LvarTablaDB#">
				)
			</cfquery>	
			
			<!--- OBTIENE LAS COLUMNAS --->
			<cfquery name="rsSQL" datasource="#Arguments.conexion#">
				EXEC sp_columns '#LvarTablaDB#'
			</cfquery>
			<cfquery name="rsSQL" dbtype="query">
				SELECT	TABLE_QUALIFIER AS SCH, 
						TABLE_NAME		as TAB, 
						COLUMN_NAME 	as COL, 
						TYPE_NAME 		as TIP_BD, 
						[PRECISION]		as LON, 
						SCALE 			as DECS, 
						-(NULLABLE-1)	as OBL,
						DATA_TYPE		as SYS_TYPE
				  FROM	rsSQL
			</cfquery>
	
			<!--- OBTIENE LOS CHECKS POR COLUMNA --->
			<cfquery name="rsCHKs" datasource="#Arguments.conexion#">
			   SELECT o.name, m.text, '*' AS COLUMN_NAME
				 FROM sysconstraints c, sysobjects o, syscomments m
				WHERE c.tableid = #LvarTAB_id#
				  AND c.constrid = o.id
				  AND o.id = m.id
				  AND (o.sysstat & 15 = 7)
			</cfquery>

			<cfset LvarCOLs = "">
			<cfloop query="rsCHKs">
				<cfset LvarRUL = trim(rsCHKs.text)>
				<cfset LvarCOL = rsCHKs.COLUMN_NAME>
				<cfloop query="rsSQL">
					<cfif REfindNoCase("[^a-zA-Z0-9_']#rsSQL.COL#[^a-zA-Z0-9_']"," #LvarRUL# ") AND find(" CHECK ", LvarRUL)>
						<cfif LvarCOL EQ "*" AND NOT listFind(LvarCOLs,rsSQL.COL)>
							<cfset LvarCOL = rsSQL.COL>
<!---
							<cfset LvarRUL = replace(LvarRUL,"( ","(","ALL")>
							<cfset LvarRUL = replace(LvarRUL,"in(","in (","ALL")>
							<cfset LvarRUL = replace(LvarRUL," )",")","ALL")>
							<cfif not find("'",LvarRUL)>
								<cfset LvarRUL = replace(LvarRUL,", ",",","ALL")>
								<cfset LvarRUL = replace(LvarRUL,"  "," ","ALL")>
							<cfelse>
								<cfset LvarRUL = replace(LvarRUL,"', '","','","ALL")>
							</cfif>
--->
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
				<cfset QuerySetCell(rsCHKs, "text", LvarRUL, rsCHKs.currentRow)>
			</cfloop>
			<cfquery name="rsSQL2" dbtype="query">
				select name, text
				  from rsCHKs
				 where COLUMN_NAME = '**'
			</cfquery>
			<cfloop query="rsSQL2">
				<cfset LvarRul = rsSQL2.text>
				<cfset LvarPto = find(" CHECK ", LvarRul)>
				<cfif LvarPto GT 0>
					<cfset LvarRul = trim(mid(LvarRul,LvarPto+6,len(LvarRul)))>
				</cfif>
				<cfquery datasource="#Arguments.conexion#">
					insert into #chkDB# (tab, chk, rul)
					values (
						 <cfqueryparam value="#LvarTablaPD#"	cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="#rsSQL2.name#"	cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="#LvarRul#"		cfsqltype="cf_sql_varchar"		null="#trim(LvarRul) EQ ''#">
					)
				</cfquery>
			</cfloop>
	
			<!--- OBTIENE LOS DEFAULTS POR COLUMNA --->
			<cfquery name="rsDEFs" datasource="#Arguments.conexion#">
				select c.name, text
				  from syscolumns c, syscomments cm
				 where c.id		= #LvarTAB_id#
				   and cm.id	= cdefault
			</cfquery>
		
			<!--- OBTIENE LAS CARACTERISITICAS DE LAS COLUMNAS --->
			<cfloop query="rsSQL">
				<cfquery name="rsSQL2" dbtype="query">
					select text
					  from rsDEFs
					 where name = '#rsSQL.COL#'
				</cfquery>
				<cfset LvarDFL = "">
				<cfif find('DEFAULT ',rsSQL2.text)>
					<cfset LvarDFL = trim(mid(rsSQL2.text,9,len(rsSQL2.text)))>
				</cfif>
		
				<cfset LvarCHK = "">
				<cfset LvarRUL = "">
				<cfquery name="rsSQL2" dbtype="query">
					select name, text
					  from rsCHKs
					 where COLUMN_NAME = '#rsSQL.COL#'
				</cfquery>
				<cfset LvarPto = find(" CHECK ", rsSQL2.text)>
				<cfif LvarPto GT 0>
					<cfset LvarCHK = rsSQL2.name>
					<cfset LvarRUL = trim(mid(rsSQL2.text,LvarPto+6,len(rsSQL2.text)))>
				</cfif>

				<cfset LvarTIP_BD = rtrim(rsSQL.TIP_BD)>
				<cfset LvarIDE = "0">
				<cfif find("identity",LvarTIP_BD)>
					<cfset LvarTIP_BD = rereplace(replace(LvarTIP_BD, "identity",""), "[()]","","ALL")>
					<cfset LvarIDE = "1">
				</cfif>
	
				<!--- Los tipos timestamp y identity estan confundidos --->
				<cfif LvarTIP_BD EQ "varbinary" OR LvarIDE EQ "1">
					<cfset LvarType = "T" & replace(rsSQL.SYS_TYPE,"-","X")>
					<cfif isdefined ("LvarSysTypes.#LvarType#")>
						<cfset LvarTIP_BD = LvarSysTypes[LvarType]>
					<cfelse>
						<cfquery name="rsSQL2" datasource="#Arguments.conexion#">
							select t.name
							  from syscolumns c
								inner join systypes t
									on t.usertype = c.usertype
							 where c.id		= #LvarTAB_id#
							   and c.name	= '#rsSQL.COL#'
						</cfquery>
						<cfset LvarTIP_BD = rsSQL2.name>
						<cfset LvarSysTypes[LvarType] = LvarTIP_BD>
					</cfif>
				</cfif>

				<cfset LvarType = ColumnTypeFromSYBASE(trim(LvarTIP_BD),rsSQL.LON,rsSQL.DECs)>
				
				<cfif LvarType.tip NEQ 'D'>
					<cfset LvarDFL = replace(LvarDFL,"'","","ALL")>
				</cfif>

				<cfif LvarType.tip EQ 'TS' OR LvarIDE EQ "1">
					<cfset LvarOBL = 1>
				<cfelse>
					<cfset LvarOBL = rsSQL.Obl>
				</cfif>
				
				<cfquery datasource="#arguments.conexion#">
					insert into #colDB# (tab, col, tip, lon, dec, ide, obl, dfl, chk, rul)
					values (
						 <cfqueryparam value="#LvarTablaPD#"		cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="#rsSQL.col#"			cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="#trim(LvarType.TIP)#"	cfsqltype="cf_sql_char">
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
				
			<!--- KEYs PK, AK, UI, ID --->
			<!--- Se usa sp_helpindex para no armar las columnas (en sysindexes estan en binario) --->
			<cfquery name="rsIDX" datasource="#Arguments.conexion#">
				EXEC sp_helpindex '#LvarTablaDB#'
			</cfquery>
			<cfparam name="rsIDX" default="#queryNew('index_name,index_keys,index_description')#">
			<cfquery name="rsIDX" dbtype="query">
				SELECT	index_name		AS IDX, 
						'???'			as TIP, 
						'???'			as CLU, 
						'???'			as KEYN, 
						index_keys	 	as COLS,
						index_description
				  FROM	rsIDX
			</cfquery>
			<cfquery name="rsPKsAKs" datasource="#Arguments.conexion#">
				SELECT name,case when (status & 2048 = 2048) then 'P' else 'A' end as type
				  FROM sysindexes 
				 WHERE id = #LvarTAB_id#  
				   AND indid > 0
				   AND status2 & 2 = 2 
			</cfquery>
			<cfloop query="rsIDX">
				<cfset LvarDesc = " " & lcase(replace(rsIDX.index_description, ",", " ", "ALL")) & " ">
				<cfif find(" clustered ", LvarDesc)>
					<cfset LvarCLU = "1">
				<cfelse>
					<cfset LvarCLU = "0">
				</cfif>
				<cfset LvarKey = "">
				<cfset LvarKey = trim(rsIDX.IDX)>
				<cfif find(" unique ", LvarDesc)>
					<cfquery name="rsSQL2" dbtype="query">
						SELECT type
						  FROM rsPKsAKs
						 WHERE name = '#LvarKey#'
					</cfquery>
					<cfif rsSQL2.type NEQ "">
						<cfset LvarTip = rsSQL2.type>
					<cfelse>
						<cfset LvarTip = "U">
					</cfif>
				<cfelse>
					<cfset LvarTip = "I">
				</cfif>

				<cfset LvarCols = replace(replace(trim(rsIDX.COLS) & ","," DESC,","-,","ALL")," ","","ALL")>
				<cfset LvarCols = mid(LvarCols,1,len(LvarCols)-1)>

				<cfquery datasource="#Arguments.conexion#">
					insert into #keyDB# (tab, cols, tip, ref, colsR, keyN, idx, clu, keyO)
					values (
						 <cfqueryparam value="#LvarTablaPD#"	cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="#LvarCols#"		cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="#LvarTIP#"		cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="*"				cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="*"				cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="#LvarKEY#"		cfsqltype="cf_sql_varchar">
						,null
						,<cfqueryparam value="#LvarCLU#"		cfsqltype="cf_sql_bit">
						,<cfqueryparam value="#GvarObj.fnKeyO(LvarTip)#" cfsqltype="cf_sql_integer">
					)
				</cfquery>
			</cfloop>
			
			<!--- KEYs FK --->
			<cfquery name="rsSQL" datasource="#Arguments.conexion#">
				select 	DISTINCT
						'F' as TIP,				<!--- FKs de LvarTablaDB --->
						object_name(constrid)	as COD,
						object_name(tableid)	as TAB,
						object_name(reftabid)	as REF,
						tableid					as TABid,
						reftabid				as REFid,
						keycnt,
						fokey1,fokey2,fokey3,fokey4,fokey5,fokey6,fokey7,fokey8,fokey9,fokey10,fokey11,fokey12,fokey13,fokey14,fokey15,fokey16,
						refkey1,refkey2,refkey3,refkey4,refkey5,refkey6,refkey7,refkey8,refkey9,refkey10,refkey11,refkey12,refkey13,refkey14,refkey15,refkey16
			  from sysreferences r 
			 where tableid = #LvarTAB_id# 
			UNION
				select 	DISTINCT
						'D' as TIP,				<!--- DEPENDENCIAS: FKs que referencian a LvarTablaDB --->
						object_name(constrid)	as COD,
						object_name(tableid)	as TAB,
						object_name(reftabid)	as REF,
						tableid					as TABid,
						reftabid				as REFid,
						keycnt,
						fokey1,fokey2,fokey3,fokey4,fokey5,fokey6,fokey7,fokey8,fokey9,fokey10,fokey11,fokey12,fokey13,fokey14,fokey15,fokey16,
						refkey1,refkey2,refkey3,refkey4,refkey5,refkey6,refkey7,refkey8,refkey9,refkey10,refkey11,refkey12,refkey13,refkey14,refkey15,refkey16
			  from sysreferences r 
			 where reftabid = #LvarTAB_id# 
			 order by TIP,TAB
			</cfquery>
			<cfloop query="rsSQL">
				<cfset LvarCols = "">
				<cfset LvarColsR = "">
				<cfloop index="i" from="1" to="#rsSQL.keycnt#">
					<cfif LvarCols NEQ "">
						<cfset LvarCols  &= ",">
						<cfset LvarColsR &= ",">
					</cfif>

					<cfset LvarCOL_F_I = "rsSQL.fokey#i#">
					<cfquery name="rsSQL2" datasource="#Arguments.conexion#">
						select name from syscolumns where id=#rsSQL.TABid# and colid = #evaluate(LvarCOL_F_I)#
					</cfquery>
					<cfset LvarCols &= rsSQL2.name>

					<cfset LvarCOL_R_I = "rsSQL.refkey#i#">
					<cfquery name="rsSQL2" datasource="#Arguments.conexion#">
						select name from syscolumns where id=#rsSQL.REFid# and colid = #evaluate(LvarCOL_R_I)#
					</cfquery>
					<cfset LvarColsR &= rsSQL2.name>
				</cfloop>

				<cfset LvarTablaFK = rsSQL.TAB>
				<cfif LvarTablaFK EQ LvarTablaDB AND LvarTablaDB NEQ LvarTablaPD>
					<cfset LvarTablaFK = LvarTablaPD>
				</cfif>
				<cfquery datasource="#Arguments.conexion#">
					insert into #keyDB# (tab, cols, tip, ref, colsR, keyN, idx, clu, keyO)
					values (
						 <cfqueryparam value="#LvarTablaFK#"	cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="#LvarCols#"		cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="#rsSQL.TIP#"		cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="#rsSQL.ref#"		cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="#LvarColsR#"		cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="#rsSQL.cod#"		cfsqltype="cf_sql_varchar">
						, null, 0, #GvarObj.fnKeyO("F")#
					)
				</cfquery>
			</cfloop>
		</cfif>
	</cfloop>

	<!--- Ajusta los LOBs de tablas existentes, cuando son nuevos o cuando son viejos que pasan a obligatorio: deben aceptar nulls --->
	<cfquery name="rsSQL" datasource="#arguments.conexion#">
		update #colPD#
		   set obl = 0
		 where  tip in ('CL','BL')
			and obl = 1
			and (
		 		select count(1)
				  from #tabDB#
				 where tab = #colPD#.tab
				) > 0
			and (
		 		select count(1)
				  from #colDB#
				 where tab = #colPD#.tab
				   and col = #colPD#.col
				   and tip = #colPD#.tip
				   and obl = 1
				) = 0
	</cfquery>
	
	<cfif Arguments.TIPO EQ "UPLOAD">
		<cfquery datasource="asp">
			update DBMuploads
			   set tabsP = tabs
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
<cffunction name="ColumnTypeFromSYBASE" returntype="struct">
	<cfargument name="TIP_BD">
	<cfargument name="LON">
	<cfargument name="DECs">
	
	<!--- Tipos = "C,V,B,VB,CL,BL,I,N,F,M,L,D,TS" --->
	<cfset LvarTYPE = Arguments>
	<cfset LvarTYPE.TIP = "">
	<cfset LvarTYPE.TIP_L = " ">
	
	<cfif listFind("char,nchar",LvarTYPE.TIP_BD)>
		<!--- Tipo = C = Char: Caracter tamaño fijo --->
		<cfif LvarTYPE.Lon EQ 0>
			<cfset LvarTYPE.Lon = 1>
		</cfif>
		<cfset LvarTYPE.DECs = "0">
		<cfset LvarTYPE.TIP  = "C">
	<cfelseif listFind("varchar,nvarchar,sysname",LvarTYPE.TIP_BD)>
		<!--- Tipo = V = Varchar: Caracter tamaño variable --->
		<cfif LvarTYPE.Lon EQ 0>
			<cfset LvarTYPE.Lon = 1>
		</cfif>
		<cfset LvarTYPE.DECs = "0">
		<cfset LvarTYPE.TIP  = "V">
	<cfelseif LvarTYPE.TIP_BD EQ "binary">
		<!--- Tipo = B = Binary: Dato Binario tamaño fijo --->
		<cfif LvarTYPE.Lon EQ 0>
			<cfset LvarTYPE.Lon = 1>
		</cfif>
		<cfset LvarTYPE.DECs = "0">
		<cfset LvarTYPE.TIP  = "B">
	<cfelseif LvarTYPE.TIP_BD EQ "varbinary">
		<!--- Tipo = VB = Varbinary: Dato Binario tamaño variable --->
		<cfif LvarTYPE.Lon EQ 0>
			<cfset LvarTYPE.Lon = 1>
		</cfif>
		<cfset LvarTYPE.DECs = "0">
		<cfset LvarTYPE.TIP  = "VB">
	<cfelseif LvarTYPE.TIP_BD EQ "text">
		<!--- Tipo = CL = CLOB: Objeto caracter de 2GB --->
		<cfset LvarTYPE.Lon = -2>
		<cfset LvarTYPE.Decs = "0">
		<cfset LvarTYPE.TIP  = "CL">
	<cfelseif LvarTYPE.TIP_BD EQ "image">
		<!--- Tipo = BL = BLOB: Objeto binario de 2GB --->
		<cfset LvarTYPE.Lon = -2>
		<cfset LvarTYPE.Decs = "0">
		<cfset LvarTYPE.TIP  = "BL">
	<cfelseif listFind("bigint,biginteger,integer,int,smallint,tinyint",LvarTYPE.TIP_BD)>
		<!--- Tipo = I = Integer: Número entero --->
		<cfif find("big", LvarTYPE.TIP_BD)>
			<cfset LvarTYPE.Lon = 19>
		<cfelseif find("small", LvarTYPE.TIP_BD)>
			<cfset LvarTYPE.Lon = 5>
		<cfelseif find("tiny", LvarTYPE.TIP_BD)>
			<cfset LvarTYPE.Lon = 3>
		<cfelse>
			<cfset LvarTYPE.Lon = 10>
		</cfif>
		<cfset LvarTYPE.Decs = "0">
		<cfset LvarTYPE.TIP  = "I">
	<cfelseif listFind("numeric,decimal,dec",LvarTYPE.TIP_BD)>
		<!--- Tipo = N = Numeric: Número con cantidad de decimales fijo --->
		<cfif LvarTYPE.Lon EQ 0>
			<cfset LvarTYPE.Lon = 18>
		</cfif>
		<cfset LvarTYPE.TIP = "N">
	<cfelseif listFind("real,float,double,double precision",LvarTYPE.TIP_BD)>
		<!--- Tipo = F = Float: Número con punto flotante --->
		<cfif LvarTYPE.TIP_BD EQ "real">
			<cfset LvarTYPE.Lon = 7>
		<cfelseif find("double",LvarTYPE.TIP_BD) OR LvarTYPE.Lon GTE 16>
			<cfset LvarTYPE.Lon = 30>
		<cfelseif LvarTYPE.Lon EQ 0 OR LvarTYPE.Lon GTE 8>
			<cfset LvarTYPE.Lon = 15>
		<cfelse>
			<cfset LvarTYPE.Lon = 7>
		</cfif>
		<cfset LvarTYPE.DECs = "0">
		<cfset LvarTYPE.TIP  = "F">
	<cfelseif listFind("money,smallmoney",LvarTYPE.TIP_BD)>
		<!--- Tipo = M = Money: Número para almacenar montos con 4 decimales --->
		<cfset LvarTYPE.Lon  = "18">
		<cfset LvarTYPE.Decs = "4">
		<cfset LvarTYPE.TIP  = "M">
		<cfif LvarTYPE.TIP_BD EQ "smallmoney">
			<cfset LvarTYPE.TIP_L = "*">
		</cfif>
	<cfelseif LvarTYPE.TIP_BD EQ "bit">
		<!--- Tipo = L = Logic: Número que sólo permite 1=true, 0=false --->
		<cfset LvarTYPE.TIP  = "L">
		<cfset LvarTYPE.Lon  = "1">
		<cfset LvarTYPE.Decs = "0">
	<cfelseif listFind("date,datetime,smalldatetime",LvarTYPE.TIP_BD)>
		<!--- Tipo = D = Datetime: Fecha que almacena Fecha y Hora --->
		<cfset LvarTYPE.TIP  = "D">
		<cfset LvarTYPE.LON  = "0">
		<cfset LvarTYPE.DECs = "0">
		<cfif LvarTYPE.TIP_BD NEQ "datetime">
			<cfset LvarTYPE.TIP_L = "*">
		</cfif>
	<cfelseif LvarTYPE.TIP_BD EQ "timestamp">
		<!--- Tipo = TS = Timestamp: Dato autogenerado cada vez que se actualiza un registro --->
		<cfset LvarTYPE.LON  = "0">
		<cfset LvarTYPE.DECs = "0">
		<cfset LvarTYPE.TIP  = "TS">
	<cfelse>
		<!--- Tipo = ** = Tipo de dato no soportado --->
		<cfset LvarTYPE.TIP = "?">
	</cfif>
	<cfreturn LvarType>
</cffunction>

<!---
	***********************************************
	GENERAR LA NUEVA ESTRUCTURA EN LA BASE DE DATOS
	***********************************************
--->
<cffunction name="CrearObjetosEspeciales" access="package" output="false" returntype="string">
	<cfargument name="conexion" required="yes">
	<cfargument name="forScript" default="no">

	<!--- TABLE dual --->
	<cfif Arguments.forScript>
		<cfset LvarScript = "/* IF X GT 0:SELECT count(1) as X FROM sysobjects where name='dual' and type='U' */#vbCrLf#">
		<cfset LvarScript &= "DROP   TABLE dual#EXEC#">
		<cfset LvarScript &= "CREATE TABLE dual (x  varchar(1))#EXEC#">
		<cfset LvarScript &= "INSERT INTO  dual (x) VALUES ('X')#EXEC#">
		<cfreturn LvarScript>
	</cfif>
	
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
			CREATE TABLE dual (x varchar(1))
		</cfquery>
		<cfquery datasource="#arguments.conexion#">
			INSERT INTO dual (x) VALUES ('X')
		</cfquery>
	</cfif>
</cffunction>

<cffunction name="fnGenIniTable" access="package" output="false" returntype="string">
	<cfargument name="conexion" required="yes">
	<cfargument name="tab"		required="yes">

	<cfreturn "">
</cffunction>

<cffunction name="fnGenEndTable" access="package" output="false" returntype="string">
	<cfargument name="conexion" required="yes">
	<cfargument name="tab"		required="yes">
	
	<cfreturn "">
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

<cffunction name="sbGetPDPrefijoName" access="package" output="false" returntype="string">
	<cfargument name="conexion"	required="yes">
	<cfargument name="tipo"		required="yes">
	<cfargument name="sec"		required="yes">

	<cfset LvarSuf = "t.suf25">
	<cfset LvarPrefN = "23">

	<cfreturn GvarOBJ.sbGetPDPrefijoName(Arguments.conexion, tipo, sec, LvarSuf, LvarPrefN)>
</cffunction>

<!--- Objetos (PK,AK,FK,UI,FI,ID) a renombrar porque su nombre está en otra tabla --->
<cffunction name="sbRenameObjs"  access="package" output="no" returntype="void">
	<cfargument name="conexion" required="yes">
	<cfargument name="CNSTs" required="yes">
	<cfargument name="INDXs" required="yes">
	<cfargument name="IDren" required="yes">

	<!--- Valida los Constraints definidos en DBM --->
		<!--- En los CKs y FKs de base de datos de otra tabla --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into DBMrenames (owner, sch, tab, old, tip, fecha, sts)
			SELECT	c.tab, '#GvarSchema#', object_name(o.tableid), object_name(o.constrid), 
					case 
						when status = 64  then 'FK' 
						when status = 128 then 'CK' 
					end,
					<cf_dbfunction name="today">, 0
			  FROM sysconstraints o, #preserveSingleQuotes(Arguments.CNSTs)# c
			 WHERE object_name(o.constrid)	= c.obj_name
			   AND object_name(o.tableid)	<> c.tab
			   AND status in (64,128)
		</cfquery>
	<!--- Los PKs y AKs e indices no importan que estén repetidos  --->
	<!--- Renombra los objetos encontrados --->
	<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
		select IDren, sch, tab, old, tip, fecha, sts
		  from DBMrenames
		 where IDren > #Arguments.IDren#
		   and sts = 0
	</cfquery>

	<cfloop query="rsSQL">
		<cfif right(rsSQL.tip,1) EQ "K" AND rsSQL.tip NEQ "PK" AND rsSQL.tip NEQ "AK">
			<cfquery datasource="#Arguments.Conexion#">
				EXEC sp_rename '#rsSQL.old#', 'DBMREN_#rsSQL.tip##rsSQL.IDren#'
			</cfquery>
		<cfelse>
			<cfquery datasource="#Arguments.Conexion#">
				EXEC sp_rename '#rsSQL.old#', 'DBMREN_#rsSQL.tip##rsSQL.IDren#', 'index'
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
	<cfif compare(Arguments.oldName, Arguments.newName) NEQ 0>
		<cfif find("PK",Arguments.tipo)+find("AK",Arguments.tipo)+find("INDEX",Arguments.tipo)>
			<cfset LvarSQL_RENAME = "EXEC sp_rename '#Arguments.tab#.#Arguments.oldName#', '#Arguments.newName#', 'index'#EXEC#">
		<cfelse>
			<cfset LvarSQL_RENAME = "EXEC sp_rename '#Arguments.oldName#', '#Arguments.newName#'#EXEC#">
		</cfif>
	</cfif>
	<cfreturn LvarSQL_RENAME>
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
			p.lov as lov,
			p.rul as rul
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
		<cfif (rsSQL.ide EQ "1")>
			<cfset LvarIdentity = rsSQL.col>
			<cfset Lvar_CREATE = Lvar_CREATE & " identity">
		<cfelseif (rsSQL.col EQ "ts_rversion")>
		<cfelse>
			<cfset Lvar_CREATE = Lvar_CREATE & LvarCol.SQLdfl & LvarCol.SQLnul>
			<cfif (rtrim(rsSQL.rul) NEQ "")>
				<cfset Lvar_CREATE = Lvar_CREATE & vbCrLf & vbTab & " CONSTRAINT #GvarObj.fnGetName(GvarTabPrefijo,"CK",rsSQL.sec)# CHECK #rsSQL.rul#">
			</cfif>
		</cfif>
	</cfloop>

	<cfset Lvar_CREATE = Lvar_CREATE & vbCrLf & vbTab & ")" & "#EXEC#">

	<cfreturn Lvar_CREATE>
</cffunction>

<cffunction name="fnGenAddCheck" output="false" returntype="string">
	<cfargument name="tabla">
	<cfargument name="rule">

	<cfset Lvar_CHECK = "ALTER TABLE #Arguments.Tabla# ADD CONSTRAINT #GvarTabPrefijo#_CK CHECK #arguments.rule##EXEC#">
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
		<cfset Lvar_CREATE = "DROP INDEX #Arguments.tab#.#Arguments.key#">
		<cfset Lvar_CREATE = Lvar_CREATE & " /* UNIQUE INDEX (#Arguments.cols#) */#EXEC#">
	<cfelseif Arguments.tip EQ "I">
		<cfset Lvar_CREATE = "DROP INDEX #Arguments.tab#.#Arguments.key#">
		<cfset Lvar_CREATE = Lvar_CREATE & " /* INDEX (#Arguments.cols#) */#EXEC#">
	<cfelseif Arguments.tip EQ "F" or Arguments.tip EQ "D">
		<cfif FKs>
			<cfset Lvar_CREATE = "ALTER TABLE #Arguments.tab# DROP CONSTRAINT #Arguments.key#">
			<cfset Lvar_CREATE = Lvar_CREATE & " /* REFERENCES #Arguments.ref# (#Arguments.colsR#) */#EXEC#">
		<cfelseif trim(Arguments.idx) NEQ "">
			<!--- FK: Si existe indice hay que borrarlo --->
			<cfset Lvar_CREATE = "DROP INDEX #Arguments.tab#.#Arguments.idx# /* REFERENCES INDEX (#Arguments.colsR#) */#EXEC#">
		</cfif>
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
	<cfif Arguments.clu EQ "1">
		<cfset LvarCLU = "CLUSTERED">
	<cfelse>
		<cfset LvarCLU = "NONCLUSTERED">
	</cfif>
	<cfif Arguments.tip EQ "P">
		<cfset Lvar_CREATE = "ALTER TABLE #Arguments.tab# ADD CONSTRAINT #GvarTabPrefijo#_PK PRIMARY KEY #LvarCLU# (#Arguments.cols#)#EXEC#">
	<cfelseif Arguments.tip eq "A">
		<cfset Lvar_CREATE = "ALTER TABLE #Arguments.tab# ADD CONSTRAINT #GvarObj.fnGetName(GvarTabPrefijo,"AK",sec)# UNIQUE #LvarCLU# (#Arguments.cols#)#EXEC#">
	<cfelseif Arguments.tip eq "U">
		<cfset Lvar_CREATE = "CREATE UNIQUE #LvarCLU# INDEX #GvarObj.fnGetName(GvarTabPrefijo,"UI",sec)# ON #Arguments.tab# (#Arguments.cols#)#EXEC#">
	<cfelseif Arguments.tip eq "I">
		<cfset Lvar_CREATE = "CREATE #LvarCLU# INDEX #GvarObj.fnGetName(GvarTabPrefijo,"ID",sec)# ON #Arguments.tab# (#Arguments.cols#)#EXEC#">
	<cfelseif Arguments.tip eq "F">
		<cfif FKs>
			<cfset Lvar_CREATE = "ALTER TABLE #Arguments.tab# ADD CONSTRAINT #GvarObj.fnGetName(GvarTabPrefijo,"FK",sec)# FOREIGN KEY (#Arguments.cols#) REFERENCES #ref# (#Arguments.colsR#)#EXEC#">
		<cfelseif idxTip EQ "+">
			<cfset Lvar_CREATE = "CREATE INDEX #GvarObj.fnGetName(GvarTabPrefijo,"FI",sec)# ON #Arguments.tab# (#Arguments.cols#)#EXEC#">
		</cfif>
	</cfif>
	<cfreturn Lvar_CREATE & vbCrLf>
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
	<cfset Lvar_DROP &= "ALTER TABLE #Arguments.Tabla# DROP #Arguments.Col##EXEC#">
	<cfreturn Lvar_DROP>
</cffunction>

<cffunction name="fnGenRenTab" output="false" returntype="string">
	<cfargument name="tabOld">
	<cfargument name="tabNew">

	<cfset Lvar_RENAME = "EXEC sp_rename '#Arguments.tabOld#', '#Arguments.tabNew#'#EXEC#">

	<cfreturn Lvar_RENAME>
</cffunction>

<cffunction name="fnGenDelCheck" output="false" returntype="string">
	<cfargument name="tabla">
	<cfargument name="check">
	<cfargument name="rule">

	<cfset Lvar_CHECK = "ALTER TABLE #Arguments.Tabla# DROP CONSTRAINT #Arguments.Check##EXEC#">
	<cfreturn Lvar_CHECK>
</cffunction>

<cfscript>
	Function fnGenAddColumn(tab1, col, tip, lon, dec, ide, obl, dfl, rul, lov, sec)
	// Cuando es identity:
	//  	ALTER TABLE tab ADD     col tip(lon,dec) identity
	// Con Valor Inicial o es obl sin dfl (primer valor de lov o dfl de tipo):
	//  	ALTER TABLE tab ADD     col tip(lon,dec) NULL
	//  	UPDATE      tab SET     col = VALOR_INICIAL
	//  	ALTER TABLE tab REPLACE col	dfl								-- Cuando hay dfl
	//  	ALTER TABLE tab MODIFY  col tip(lon,dec) NOT NULL			-- Cuando el obl
	// Cuando Default es expresión y es obl (hay que incluirlo NULL):
	//  	ALTER TABLE tab ADD     col tip(lon,dec) dfl NULL
	//  	ALTER TABLE tab MODIFY  col tip(lon,dec) NOT NULL
	// SINO
	//  	ALTER TABLE tab ADD  col tip(lon,dec) {dfl} {NULL | NOT NULL}
	//
	// ALTER TABLE tab ADD CONSTRAINT tabla_CK01 CHECK (rul)			-- Cuando hay rul
	{
		tab1=trim(tab1);col=trim(col);tip=trim(tip);lon=trim(lon);dec=trim(dec);obl=trim(obl);dfl=trim(dfl);rul=trim(rul);
		LvarCol = fnGenColumn (tab1, col, tip, lon, dec, obl, dfl, lov);

		LvarSQL_ALTER = "";

		// Solo permite agregar un LOB NULL
		if (tip EQ "CL" OR tip EQ "BL")
		{
			obl = 0;
			LvarCol.SQLnul = " NULL";
		}
		
		if (ide EQ "1")
		{
			LvarSQL_ALTER &= "ALTER TABLE #tab1# ADD #col# #LvarCol.SQLtip# identity#EXEC#";
		}
		else if (tip EQ "TS")
		{
			LvarSQL_ALTER &= "ALTER TABLE #tab1# ADD #col# timestamp#EXEC#";
		}
		else
		{
			// Si es obligatorio elimina los nulls.  
			// Caso especial: si es bit y default es una función se debe crear un numeric(1) NULL
			if (LvarCol.dflIni NEQ "" AND LvarCol.dflIni NEQ LvarCol.dfl AND NOT ( tip EQ 'L' AND find("(",LvarCol.SQLdfl) ) )
			{
				if (tip EQ "L")
				{
					LvarTipo = "numeric(1)";	// Lo incluye numeric para poder agregarlo como NULL
				}
				else
				{
					LvarTipo = LvarCol.SQLtip;
				}
				LvarSQL_ALTER &= "ALTER TABLE #tab1# ADD #col# #LvarTipo# NULL#EXEC#";
				LvarSQL_ALTER &= "UPDATE #tab1# SET #col# = #LvarCol.dflIni##EXEC#";
				// Pone default
				if (dfl NEQ "")
				{
					LvarSQL_ALTER &= "ALTER TABLE #tab1# REPLACE #col##LvarCol.SQLdfl##EXEC#";
				}
				// Pone obligatorio
				if (obl EQ "1")
				{
					LvarSQL_ALTER &= "ALTER TABLE #tab1# MODIFY #col# #LvarCol.SQLtip# NOT NULL#EXEC#";
				}
			}
			// Caso especial: No permite agregar un campo NOT NULL cuando default es expresion getdate() o suser_name() o convert(
			else if (obl EQ "1" and find("(",LvarCol.SQLdfl))
			{
				LvarSQL_ALTER &= "ALTER TABLE #tab1# ADD #col# #LvarCol.SQLtip##LvarCol.SQLdfl# NULL#EXEC#";
				LvarSQL_ALTER &= "ALTER TABLE #tab1# MODIFY #col# #LvarCol.SQLtip# NOT NULL#EXEC#";
			}
			// Crea la Columna con default y nul
			else
			{
				LvarSQL_ALTER &= "ALTER TABLE #tab1# ADD #col# #LvarCol.SQLtip##LvarCol.SQLdfl##LvarCol.SQLnul##EXEC#";
			}

			// Pone regla
			if (rul NEQ "")
			{
				LvarSQL_ALTER &= "ALTER TABLE #tab1# ADD " & "CONSTRAINT #GvarObj.fnGetName(GvarTabPrefijo,"CK",sec)# CHECK #rul#" & "#EXEC#";
			}
		}

		return LvarSQL_ALTER & vbCrLf;
	}

	Function fnGenChgColumn(
							conexion,
							tab, col,   colAnt,
							tip1, lon1, dec1, ide1, obl1, dfl1, dflN1, rul1, chk1, 
							tip2, lon2, dec2, ide2, obl2, dfl2, rul2,  lov2, sec2)
	// ALTER TABLE tab DROP CONSTRAINT nombre_anterior						-- Cuando hay constraint anterior, para evitar conflictos
	// RENOMBRAR cuando hay cambio de nombre en columna: colDB.colAnt
	//		EXEC sp_rename 'tabla.colAnt', 'col', 'column'
	// Cambio simple (cuando pasa de numero a numero, o de cualquiera a string, o solo cambia longitud):
	// 		ALTER TABLE tab MODIFY 	col TIPO_DE_DATOS(lon,dec)
	// Regenerar (cuando cambia tipo, cambia LOB o cambia identity):
	//		ALTER TABLE tab ADD col__NEW TIPO_DE_DATOS(lon,dec) NULL
	//		UPDATE tabla SET col__NEW = col
	//		ALTER TABLE tab DROP col
	//		EXEC sp_rename 'tabla.col__NEW', 'col', 'column'
	// ALTER TABLE tab REPLACE 	col DEFAULT dfl | NULL 						-- Solo si cambia dfl
	// UPDATE tabla SET col = DFL_DEFAULT WHERE col IS NULL						-- Solo si es obl sin default
	// ALTER TABLE tab MODIFY	 	col [NOT] NULL 								-- Solo si cambia obl
	// ALTER TABLE tab ADD CONSTRAINT tabla_CK01 CHECK (rul)					-- Solo si hay regla
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
			LvarSQL_ALTER &= "ALTER TABLE #tab# DROP CONSTRAINT #chk1# /* CHECK #rul1# */#EXEC#";
		}

		// RENOMBRAR CUANDO HAY CAMBIO DE NOMBRE DE COLUMNA
		if (colAnt NEQ "")
		{
			LvarSQL_ALTER &= "EXEC sp_rename '#tab#.#colAnt#', '#col#', 'column'#EXEC#";
		}
		
		// Cambio a Timestamp
		if (tip1 NEQ "TS" AND tip2 EQ "TS")
		{
			LvarSQL_ALTER &= "ALTER TABLE #tab# DROP #col##EXEC#";
			return LvarSQL_ALTER & fnGenAddColumn(tab, col, tip2, lon2, dec2, ide2, obl2, dfl2, rul2, lov2, sec2);
		}
		else if (tip2 EQ "TS")
		{
			return "";
		}
		
		// Cambio de text o image solo cuando pasa de obligatorio a opcional: UN LOB NO PUEDE NI PASARSE NI AGREGARSE NOT NULL
		LvarLOBs = false;
		if (tip2 EQ "CL" OR tip2 EQ "BL")
		{
			LvarLOBs = (tip1 EQ tip2 AND obl1 EQ 1 AND obl2 EQ 0);
			obl1 = 0;
			obl2 = 0;
		}

		// Cambio de número a número (excepto a lógico o identity)
		LvarNumToNum = 	(tip1 NEQ tip2) AND 
						(GvarOBJ.fnTipoPDtoCF(tip1) EQ "N") AND 
						(GvarOBJ.fnTipoPDtoCF(tip2) EQ "N") AND 
						(tip2 NEQ "L");
		
		// Cambio a char o varchar (No LOB)
		LvarToCHAR =	(tip1 NEQ tip2) AND 
						(tip2 EQ "C" OR tip2 EQ "V") AND 
						NOT (tip1 EQ "CL" OR tip1 EQ "BL");
		
		// Cambio Simple: Si cambia de número a número, Si cambia de cualquiera (menos LOB) a String, Si se mantiene el tipo pero cambia la longitud o decimales
		LvarSimple 		= (LvarNumToNum OR LvarToCHAR OR (tip1 EQ tip2 AND (lon1 NEQ lon2 OR dec1 NEQ dec2)));

		// Regenerar: cambio de Tipo o LOB o quitar Identity
		LvarRegenerar 	= (tip1 NEQ tip2 OR LvarLOBs OR ide1 NEQ ide2);
		
		if (LvarSimple)
		{
			LvarSQL_ALTER &= "ALTER TABLE #tab# MODIFY #col# #LvarCol.SQLtip##EXEC#";
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
				LvarAddUpd	= "ALTER TABLE #tab# ADD  #col__NEW# #LvarCol.SQLtip# identity#EXEC#";
				// ACTUALIZA TODAS LAS FKs QUE UTILIZAN EL identity VIEJO POR EL VALOR DEL identity NUEVO (Contribución de Gustavo Fonseca)
				LvarAddUpd	&= GvarObj.fnRecurs_KEYsCHGtoIDE("UPDATE", tab, col, col__NEW, tab, col, conexion, EXEC);
				obl1="1"; obl2="1";
				dfl1=""; dfl2="";
			}
			// Convertir a BIT
			else if (tip2 EQ "L")
			{
				LvarAddUpd	= "ALTER TABLE #tab# ADD #col__NEW# #LvarCol.SQLtip# DEFAULT 0 NOT NULL#EXEC#";
				// ACTUALIZA "0", "" o NULL a 0 SINO 1
				LvarAddUpd	&= "UPDATE #tab# SET #col__NEW# = #fnCast(col, tip1, tip2)##EXEC#";
				obl1 = "1";	obl2 = "1";
				dfl1 = "0";	
			}
			// Convertir diferentes tipos
			else
			{
				LvarAddUpd	= "ALTER TABLE #tab# ADD #col__NEW# #LvarCol.SQLtip# NULL#EXEC#";
				LvarAddUpd	&= "UPDATE #tab# SET #col__NEW# = #fnCast(col, tip1, tip2)##EXEC#";
				obl1 = "0";
				dfl1 = "";
			}
			LvarSQL_ALTER &= "/* IF X GT 0:select count(1) as X from syscolumns where id=object_id('#tab#') and name='#col__NEW#' */#vbCrLf#";
			LvarSQL_ALTER &= "ALTER TABLE #tab# DROP #col__NEW##EXEC#";
			LvarSQL_ALTER &= LvarAddUpd;
			LvarSQL_ALTER &= "ALTER TABLE #tab# DROP #col##EXEC#";
			LvarSQL_ALTER &= "EXEC sp_rename '#tab#.#col__NEW#', '#col#', 'column'#EXEC#";
		}

		// Cambia Obligatorio
		if (obl1 NEQ obl2)
		{
			if (obl1 EQ "0" and obl2 EQ "1")
			{
				LvarSQL_ALTER &= "UPDATE #tab# SET #col# = #LvarCOL.dflObl# WHERE convert(varchar,#col#) IS NULL#EXEC#";
			}

			LvarSQL_ALTER &= "ALTER TABLE #tab# MODIFY #col##LvarCol.SQLnul##EXEC#";
		}

		// Cambia Default
		if (compare(dfl1,dfl2) NEQ 0)
		{
			LvarSQL_ALTER &= "ALTER TABLE #tab# REPLACE #col##LvarCol.SQLdfl2##EXEC#";
		}
	
		// SIEMPRE SE CREA LA REGLA PORQUE SE BORRO AL INICIO
		if (rul2 NEQ "")
		{
			LvarSQL_ALTER &= "ALTER TABLE #tab# ADD CONSTRAINT #chk2# CHECK #rul2##EXEC#";
		}

		return LvarSQL_ALTER & vbCrLf ;
	}
	
	Function fnCast(col,tip_ORI,tip_DST)
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

		if (tip_ORI EQ tip_DST)
		{
			return col;
		}
		else if (tip_DST EQ 'L')
		{
			return "case when coalesce(rtrim(convert(varchar,#col#)), ' ') in ('0',' ') then 0 else 1 end";
		}
		else if (tip_ORI NEQ tip_DST AND tip_DST EQ 'BL')
		{
			return "convert(image,#col#)";
		}
		else if (tip_ORI NEQ tip_DST AND tip_DST EQ 'CL')
		{
			return "convert(text,#col#)";
		}
		else if (tip_ORI EQ 'BL' AND (tip_DST EQ 'VB' OR tip_DST EQ 'B'))
		{
			return "convert(varbinary,#col#)";
		}
		else if (tip2_ORI EQ tip2_DST)
		{
			return col;
		}
		else if (tip2_DST EQ "D")
		{
			if (tip2_ORI EQ "S")
			{
				return "convert(datetime,#col#,112)";
			}
			else
			{
				return "convert(datetime,convert(varchar,#col#,112),112)";
			}
		}
		else if (tip2_DST EQ "S")
		{
			return "convert(varchar,#col#,112)";
		}
		else if (tip2_DST EQ "N")
		{
			if (tip2_ORI EQ "S")
			{
				return "convert(numeric(28,10),#col#)";
			}
			else
			{
				return "convert(numeric(28,10),convert(varchar,#col#,112))";
			}
		}
		else if (tip2_DST EQ "B")
		{
			if (tip2_ORI EQ "S")
			{
				return "convert(varbinary,#col#)";
			}
			else
			{
				return "convert(varbinary,convert(varchar,#col#,112))";
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
			LvarSQL_COL = "char(" & lon & ")";
			LvarIsSTR = True;
			LvarDefaultDfl = "' '";
		}
		else if (tip EQ "V")
		{
			LvarCol.SQLtip2 = "C";
			LvarSQL_COL = "varchar(" & lon & ")";
			LvarIsSTR = True;
			LvarDefaultDfl = "' '";
		}
		else if (tip EQ "B")
		{
			LvarCol.SQLtip2 = "B";
			LvarSQL_COL = "binary(" & lon & ")";
			LvarDefaultDfl = "'00'";
		}
		else if (tip EQ "VB")
		{
			LvarCol.SQLtip2 = "B";
			LvarSQL_COL = "varbinary(" & lon & ")";
			LvarDefaultDfl = "'00'";
		}
		else if (tip EQ "CL")
		{
			LvarCol.SQLtip2 = "C";
			LvarSQL_COL = "text";
			LvarIsSTR = True;
			LvarDefaultDfl = "' '";
		}
		else if (tip EQ "BL")
		{
			LvarCol.SQLtip2 = "B";
			LvarSQL_COL = "image";
			LvarDefaultDfl = "'00'";
		}
		else if (tip EQ "I")
		{
			LvarCol.SQLtip2 = "N";
            if (lon <= 3)
			{
                LvarSQL_COL = "tinyint";
			}
            else if (lon <= 5)
			{
                LvarSQL_COL = "smallint";
			}
            else if (lon <= 10)
			{
                LvarSQL_COL = "integer";
			}
            else
			{
				LvarSQL_COL = "bigint";
			}

			LvarDefaultDfl = "0";
		}
		else if (tip EQ "N")
		{
			LvarCol.SQLtip2 = "N";
			if (dec EQ 0)
			{
				LvarSQL_COL = "numeric(" & lon & ")";
			}
			Else
			{
				LvarSQL_COL = "numeric(" & lon & "," & dec & ")";
			}
	
			LvarDefaultDfl = "0";
		}
		else if (tip EQ "F")
		{
			LvarCol.SQLtip2 = "N";
			if (lon LTE 7)
			{
				LvarSQL_COL = "real";
			}
			else if (lon GTE 16)
			{
				LvarSQL_COL = "double precision";
			}
			Else
			{
				LvarSQL_COL = "float";
			}
			LvarDefaultDfl = "0";
		}
		else if (tip EQ "M")
		{
			LvarCol.SQLtip2 = "N";
			LvarSQL_COL = "money";
			LvarDefaultDfl = "0";
		}
		else if (tip EQ "L")
		{
			LvarCol.SQLtip2 = "N";
			LvarSQL_COL = "bit";
			obl = "1";
			LvarDefaultDfl = "0";
		}
		else if (tip EQ "D")
		{
			LvarCol.SQLtip2 = "D";
			LvarSQL_COL = "datetime";
			LvarDefaultDfl = "getdate()";
		}
		else if (tip EQ "TS")
		{
			LvarCol.SQLtip2 = "T";
			LvarSQL_COL = "timestamp";
			LvarDefaultDfl = "";
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
		//	.dfl:		Valor default (para compararlo con .dflIni)
		//	.dflIni:	Valor inicial únicamente en ALTER TABLE ADD COLUMN
		//	.dflObl:	Valor para sustituir NULL en campos que se vuelven obligatorios
		//	.SQLdfl:	Clausula "DEFAULT val"	para CREATE TABLE y ALTER TABLE ADD
		//	.SQLdfl2:	Clausula "DEFAULT val | NULL" para ALTER TABLE MODIFY
		if (dfl NEQ "")
		{
			dfl = Trim(dfl);
			if (Asc(Right(dfl, 1)) EQ 160)
			{
				dfl = trim(Left(dfl, Len(dfl) - 1));
			}
			
			if (NOT listFind("suser_name(),getdate()",dfl))
			{
				if (LvarCol.SQLstr AND mid(dfl,1,1) NEQ "'")
				{
					dfl = "'#dfl#'";
				}
				else if (tip EQ "D" AND IsNumeric(dfl) AND Len(dfl) EQ 8)
				{
					dfl = "convert(datetime,'" & dfl & "',112)";
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
		
		// .SQLnul:		Clausula NULL | NOT NULL
		if (obl EQ "1")
		{
			LvarCol.SQLnul = " NOT NULL";
		}
		else
		{
			LvarCol.SQLnul = " NULL";
		}
		
		return LvarCol;
	}
</cfscript>
