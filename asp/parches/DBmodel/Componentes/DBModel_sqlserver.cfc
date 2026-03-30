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
	<cfset SQL_INIT  = "true">
	<cfset SQL_OR  = "or">
	<cfset SQL_AND = "and">
	<cfset SQL_GTE = " >= ">
	<cfset SQL_LTE = " <= ">
	<cfset SQL_EQ  = " = ">
	<cfset SQL_ISNULL = "is null">
	<cfset SQL_P_1 = "">
	<cfset SQL_P_2 = "">
	<cfset SQL_P_OR = false>
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
	<cfset sbObtieneDialecto(Arguments.conexion)>

	<cf_dbfunction name="OP_CONCAT" returnvariable="CONCAT" datasource="#Arguments.conexion#">
	<cf_dbfunction name="FN_LEN" 	returnvariable="LEN" 	datasource="#Arguments.conexion#">

	<cf_dbtemp name="tabDB" returnvariable="tabDB" datasource="#arguments.conexion#">
		<cf_dbtempcol name="tab"		    	type="varchar(30)"	mandatory="yes">
		<cf_dbtempcol name="OP"		    		type="integer"		mandatory="yes" default="0">
		<cf_dbtempcol name="tabAnt"		    	type="varchar(30)"	mandatory="no">
	
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
		<cf_dbtempcol name="dflN"		    	type="varchar(255)"	mandatory="no">
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
	AJUSTA LA ESTRUCTURA POWER DESIGNER PARA SQLSERVER
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
	
	
	<!--- Defaults: user_name() y getdate() --->
	<cfquery name="rsSQL" datasource="#arguments.conexion#">
		update #colPD#
		   set dfl = 'user_name()'
		 where dfl like '%user_name%()%'
		   and OP = #Arguments.OP#
	</cfquery>
	
	<!--- Defaults: datetime --->
	<cfquery name="rsSQL" datasource="#arguments.conexion#">
		update #colPD#
		   set dfl = 
		   		case 
					when dfl like '%getdate%()%' then 'getdate()' 
			<cfif (SQL_OR EQ "OR")>
					when #LEN#(dfl)=8 AND dfl NOT LIKE '%[^0-9]%' then 'CONVERT([datetime],(' #CONCAT# dfl #CONCAT# '),(112))' 
			<cfelse>
					when #LEN#(dfl)=8 AND dfl NOT LIKE '%[^0-9]%' then 'convert(datetime,' #CONCAT# dfl #CONCAT# ',112)' 
            </cfif>
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

<cffunction name="sbObtieneDialecto" access="private" output="no" returntype="void">
	<cfargument name="conexion" 	default="">

	<!--- OJO: En SQLserver 2008 genera OR en mayúsculas y todos los numericos con () --->
	<cfparam name="SQL_INIT" default="true">
    <cfif SQL_INIT>
		<cfset SQL_INIT = false>
		<cfset SQL_OR  = "or">
		<cfset SQL_AND = "and">
		<cfset SQL_GTE = " >= ">
		<cfset SQL_LTE = " <= ">
		<cfset SQL_EQ  = " = ">
		<cfset SQL_ISNULL = "is null">
		<cfset SQL_P_1 = "">
		<cfset SQL_P_2 = "">
		<cfset SQL_P_OR = false>

		<cfquery datasource="#Arguments.conexion#">
           CREATE TABLE MS_SQL_OBTIENE_DIALECTO
		   (campo int CHECK (campo=0 or campo=1 or campo=3))
        </cfquery>
		
		<cfquery name="rsSQL" datasource="#Arguments.conexion#">
		   SELECT m.text
			 FROM sysconstraints c, sysobjects o, syscomments m
			WHERE c.id = OBJECT_ID('MS_SQL_OBTIENE_DIALECTO')
			  AND c.constid = o.id
			  AND o.id = m.id
			  AND (o.type = 'C')
		</cfquery>
		
		<cfif find("(0)",rsSQL.text)>
			<cfset SQL_P_1 = "(">
			<cfset SQL_P_2 = ")">
		<cfelse>
			<cfset SQL_P_1 = "">
			<cfset SQL_P_2 = "">
		</cfif>
		<cfset SQL_P_OR = (findNoCase(" OR (",rsSQL.text) NEQ 0)>
		<cfif find(" OR ",rsSQL.text)>
			<cfset SQL_OR  = "OR">
			<cfset SQL_AND = "AND">
			<cfset SQL_ISNULL = "IS NULL">
		<cfelse>
			<cfset SQL_OR  = "or">
			<cfset SQL_AND = "and">
			<cfset SQL_ISNULL = "is null">
		</cfif>
		<cfif find(" = ",rsSQL.text)>
			<cfset SQL_GTE = " >= ">
			<cfset SQL_LTE = " <= ">
			<cfset SQL_EQ  = " = ">
		<cfelse>
			<cfset SQL_GTE = ">=">
			<cfset SQL_LTE = "<=">
			<cfset SQL_EQ  = "=">
		</cfif>
        <cfquery datasource="#Arguments.conexion#">
           DROP TABLE MS_SQL_OBTIENE_DIALECTO
        </cfquery>
	</cfif>
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
	<cfset LvarLOVs = "">
	
	<cfif Arguments.minVal NEQ "" AND Arguments.maxVal NEQ "">
		<cfset LvarRule = "[#Arguments.col#]#SQL_GTE##fnValsToLiterals(Arguments.minVal, LvarTipo, false)# #SQL_AND# [#Arguments.col#]#SQL_LTE##fnValsToLiterals(Arguments.maxVal, LvarTipo, false)#">
	<cfelseif Arguments.minVal NEQ "">
		<cfset LvarRule = "[#Arguments.col#]#SQL_GTE##fnValsToLiterals(Arguments.minVal, LvarTipo, false)#">
	<cfelseif Arguments.maxVal NEQ "">
		<cfset LvarRule = "[#Arguments.col#]#SQL_LTE##fnValsToLiterals(Arguments.maxVal, LvarTipo, false)#">
	</cfif>

	<cfset LvarVALs = GvarObj.fnLOVtoVALS(Arguments.lov)>
	<cfif LvarVALs NEQ "">
		<cfset LvarVALs = fnValsToLiterals(LvarVALS, LvarTipo, true)>

		<cfset P = 0>
		<cfset LvarVALsX = listToArray(LvarVALs)>
		<cfset N = ArrayLen(LvarVALsX)>
		<cfloop index="I" from="#N#" to="1" step="-1">
			<cfset val = LvarVALsX[I]>
			<cfif I GT 1 AND I LT N>
				<cfif SQL_P_OR>
					<cfset P ++>
					<cfset LvarLOVs &= " #SQL_OR# (">
				<cfelse>
					<cfset LvarLOVs &= " #SQL_OR# ">
				</cfif>
			<cfelseif I EQ 1 AND N NEQ 1>
				<cfset LvarLOVs &= " #SQL_OR# ">
			</cfif>				
			<cfset LvarLOVs &= "[#Arguments.col#]#SQL_EQ##val#">
		</cfloop>
		<cfset LvarLOVs &= repeatString(")",P)>
		<cfif LvarRule NEQ "">
			<cfset LvarRule &= " #SQL_AND# (#LvarLOVs#)">
		<cfelseif Arguments.obl EQ "0" AND N GT 1>
			<cfset LvarRule = "(#LvarLOVs#)">
		<cfelse>
			<cfset LvarRule = "#LvarLOVs#">
		</cfif>
	</cfif>

	<cfif LvarRule NEQ "">
		<cfif Arguments.obl EQ "0">
			<cfset LvarRule = "[#Arguments.col#] #SQL_ISNULL# #SQL_OR# #LvarRule#">
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
		<cfset LvarValue = "">
		<cfloop list="#LvarValue2#" index="val">
			<cfif left(val,1) EQ "-">
            	<cfset LvarSigno = "-">
                <cfset val = mid(val,2,len(val))>
			<cfelse>
            	<cfset LvarSigno = "">
            </cfif>

			<!--- Le quita los ceros a la izquierda --->
            <cfloop index="I" from="1" to="#len(val)-1#">
                <cfif mid(val,1,1) EQ "0" and mid(val,2,1) NEQ ".">
                    <cfset val = mid(val,2,len(val))>
                <cfelse>
                    <cfbreak>
                </cfif>
            </cfloop>
            <cfif LvarSigno EQ "-">
				<cfset val = "(-#val#)">
            <cfelse>
                <cfset val = "#SQL_P_1##val##SQL_P_2#">
			</cfif>
			<cfset LvarValue = listAppend(LvarValue,val)>
		</cfloop>
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
						DATA_TYPE		as TIP_TS
				  FROM	rsSQL
			</cfquery>
	
			<!--- OBTIENE LOS CHECKS POR COLUMNA --->
			<cfquery name="rsCHKs" datasource="#Arguments.conexion#">
			   SELECT o.name, m.text, '*' AS COLUMN_NAME
				 FROM sysconstraints c, sysobjects o, syscomments m
				WHERE c.id = #LvarTAB_id#
				  AND c.constid = o.id
				  AND o.id = m.id
				  AND (o.type = 'C')
			</cfquery>
			<cfset LvarCOLs = "">
			<cfloop query="rsCHKs">
				<cfset LvarRUL = trim(rsCHKs.text)>
				<cfset LvarCOL = rsCHKs.COLUMN_NAME>
				<cfloop query="rsSQL">
					<cfif find("[#rsSQL.COL#]"," #LvarRUL# ")>
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
				<cfset LvarRul = rsSQL2.text>
				<cfset LvarRul = replace(LvarRul,"[","","ALL")>
				<cfset LvarRul = replace(LvarRul,"]","","ALL")>
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
				select rtrim(c.name) as name, text, o.name as defN
				  from syscolumns c
				  	inner join syscomments cm
						on cm.id = c.cdefault
				  	inner join sysobjects o
						on o.id = c.cdefault
				 where c.id		= #LvarTAB_id#
			</cfquery>

			<!--- OBTIENE CAMPO IDENTITY --->
			<cfquery name="rsIDE" datasource="#Arguments.conexion#">
				select name 
                  from syscolumns 
                 where id=#LvarTAB_id# 
                   and status & 0x80 = 128
			</cfquery>
            <cfset LvarIdentity = rsIDE.name>

			<!--- OBTIENE LAS CARACTERISITICAS DE LAS COLUMNAS --->
			<cfloop query="rsSQL">
				<cfquery name="rsSQL2" dbtype="query">
					select text, defN
					  from rsDEFs
					 where name = '#rsSQL.COL#'
				</cfquery>
				<cfset LvarDFL = "">
				<cfset LvarDFL_N = "">
				<cfif rsSQL2.text NEQ "">
					<cfset LvarDFL = replace(rsSQL2.text,"'","","ALL")>
					<cfif mid(LvarDFL,1,1) EQ "(">
						<cfset LvarDFL = mid(LvarDFL,2,len(LvarDFL)-2)>
					</cfif>
					<cfif mid(LvarDFL,1,1) EQ "(">
						<cfset LvarDFL = mid(LvarDFL,2,len(LvarDFL)-2)>
					</cfif>

					<cfif mid(LvarDFL,1,2) EQ "(-">
						<cfset LvarDFL = mid(LvarDFL,2,len(LvarDFL)-2)>
					</cfif>

					<cfset LvarDFL_N = rsSQL2.defN>
				</cfif>
		
				<cfset LvarCHK = "">
				<cfset LvarRUL = "">	
				<cfquery name="rsSQL2" dbtype="query">
					select name, text
					  from rsCHKs
					 where COLUMN_NAME = '#rsSQL.COL#'
				</cfquery>
				<cfset LvarCHK = rsSQL2.name>
				<cfset LvarRUL = trim(rsSQL2.text)>

				<cfset LvarTIP_BD = rtrim(rsSQL.TIP_BD)>
				<cfset LvarIDE = "0">
				<cfif find("identity",LvarTIP_BD)>
					<cfset LvarTIP_BD = rereplace(replace(LvarTIP_BD, "identity",""), "[()]","","ALL")>
					<cfset LvarIDE = "1">
                <cfelseif LvarIdentity EQ rsSQL.col>
					<cfset LvarIDE = "1">
				</cfif>
	
				<cfset LvarType = ColumnTypeFromSQLSERVER(trim(LvarTIP_BD),rsSQL.LON,rsSQL.DECs)>
				<cfif LvarTYPE.TIP EQ "?">
                    <cfquery name="rsType" datasource="#Arguments.conexion#">
                        select t.name
                          from systypes t2
                            inner join systypes t on t.xusertype = t2.xtype
                        where t2.name=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(LvarTIP_BD)#">
                    </cfquery>
					<cfset LvarType = ColumnTypeFromSQLSERVER(trim(rsType.name),rsSQL.LON,rsSQL.DECs)>
                </cfif>

				<cfif LvarType.tip EQ 'TS' OR LvarIDE EQ "1">
					<cfset LvarOBL = 1>
				<cfelse>
					<cfset LvarOBL = rsSQL.Obl>
				</cfif>
				
				<cfquery datasource="#arguments.conexion#">
					insert into #colDB# (tab, col, tip, lon, dec, ide, obl, dfl, chk, rul, dflN)
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

						,<cfqueryparam value="#LvarDFL_N#"			cfsqltype="cf_sql_varchar"	null="#trim(LvarDFL_N)	EQ ''#">
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
			   SELECT o.name, case when xtype = 'PK' then 'P' else 'A' end as type
				 FROM sysconstraints c, sysobjects o
				WHERE c.id = #LvarTAB_id#
				  AND c.constid = o.id
                  AND o.xtype in ('PK','UQ')
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

				<cfset LvarCols = replace(replace(trim(rsIDX.COLS) & ",","(-)","-","ALL")," ","","ALL")>
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
						object_name(constid)	as COD,
						object_name(fkeyid)		as TAB,
						object_name(rkeyid)		as REF,
						fkeyid					as TABid,
						rkeyid					as REFid,
						keycnt,
						fkey1,fkey2,fkey3,fkey4,fkey5,fkey6,fkey7,fkey8,fkey9,fkey10,fkey11,fkey12,fkey13,fkey14,fkey15,fkey16,
						rkey1,rkey2,rkey3,rkey4,rkey5,rkey6,rkey7,rkey8,rkey9,rkey10,rkey11,rkey12,rkey13,rkey14,rkey15,rkey16
			  from sysreferences r 
			 where fkeyid = #LvarTAB_id# 
			UNION
				select 	DISTINCT
						'D' as TIP,				<!--- DEPENDENCIAS: FKs que referencian a LvarTablaDB --->
						object_name(constid)	as COD,
						object_name(fkeyid)		as TAB,
						object_name(rkeyid)		as REF,
						fkeyid					as TABid,
						rkeyid					as REFid,
						keycnt,
						fkey1,fkey2,fkey3,fkey4,fkey5,fkey6,fkey7,fkey8,fkey9,fkey10,fkey11,fkey12,fkey13,fkey14,fkey15,fkey16,
						rkey1,rkey2,rkey3,rkey4,rkey5,rkey6,rkey7,rkey8,rkey9,rkey10,rkey11,rkey12,rkey13,rkey14,rkey15,rkey16
			  from sysreferences r 
			 where rkeyid = #LvarTAB_id# 
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

					<cfset LvarCOL_F_I = "rsSQL.fkey#i#">
					<cfquery name="rsSQL2" datasource="#Arguments.conexion#">
						select name from syscolumns where id=#rsSQL.TABid# and colid = #evaluate(LvarCOL_F_I)#
					</cfquery>
					<cfset LvarCols &= rsSQL2.name>

					<cfset LvarCOL_R_I = "rsSQL.rkey#i#">
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
						,<cfqueryparam value="#rsSQL.tip#"		cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="#rsSQL.ref#"		cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="#LvarColsR#"		cfsqltype="cf_sql_varchar">
						,<cfqueryparam value="#rsSQL.cod#"		cfsqltype="cf_sql_varchar">
						, null, 0, #GvarObj.fnKeyO("F")#
					)
				</cfquery>
			</cfloop>
		</cfif>
	</cfloop>

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
<cffunction name="ColumnTypeFromSQLSERVER" returntype="struct">
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
		<cfset LvarScript &= "CREATE TABLE dual (x varchar(1))#EXEC#">
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
			CREATE TABLE dual (x VARCHAR(1))
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
		<!--- En los Constraints de base de datos de otra tabla --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into DBMrenames (owner, sch, tab, old, tip, fecha, sts)
			SELECT	c.tab, '#GvarSchema#', object_name(o.id), object_name(o.constid), 
					case 
						when o.status & 1 = 1 then 'PK'
						when o.status & 2 = 2 then 'AK'
						when o.status & 3 = 3 then 'FK'
						when o.status & 4 = 4 then 'CK'
						when o.status & 5 = 5 then 'DK'
						when o.status & 16 = 16 then 'CK'
						when o.status & 32 = 32 then 'CK'
					end, 
					<cf_dbfunction name="today">, 0
			  FROM sysconstraints o, #preserveSingleQuotes(Arguments.CNSTs)# c
			 WHERE object_name(o.constid)	= c.obj_name
			   AND object_name(o.id)		<> c.tab
		</cfquery>
		<!--- En los Indices de base de datos de cualquier tabla --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into DBMrenames (owner, sch, tab, old, tip, fecha, sts)
			SELECT	c.tab, '#GvarSchema#', object_name(o.id), o.name, 
					case when status & 2 = 2  then 'UI'	else 'ID' end,
					<cf_dbfunction name="today">, 0
			  FROM sysindexes o, #preserveSingleQuotes(Arguments.CNSTs)# c
			 WHERE o.name = c.obj_name
			   AND status & 2048 & 4096 = 0
			   AND NOT (status & 2 = 2 
			   			AND
							(
							select count(1) 
							  from sysconstraints
							 where id = o.id
							   and object_name(constid) = o.name
							   and (status & 1 = 1 OR status & 2 = 2)
							) > 0
						) 
		</cfquery>
	<!--- Valida los Indices definidos en DBM --->
		<!--- En los Constraints de base de datos de CUALQUIER tabla --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into DBMrenames (owner, sch, tab, old, tip, fecha, sts)
			SELECT	c.tab, '#GvarSchema#', object_name(o.id), object_name(o.constid), 
					case 
						when o.status & 1 = 1 then 'PK'
						when o.status & 2 = 2 then 'AK'
						when o.status & 3 = 3 then 'FK'
						when o.status & 4 = 4 then 'CK'
						when o.status & 5 = 5 then 'DK'
						when o.status & 16 = 16 then 'CK'
						when o.status & 32 = 32 then 'CK'
					end, 
					<cf_dbfunction name="today">, 0
			  FROM sysconstraints o, #preserveSingleQuotes(Arguments.INDXs)# c
			 WHERE object_name(o.constid)	= c.obj_name
		</cfquery>
		<!--- En los Indices de base de datos de OTRAS tabla --->
		<cfquery datasource="#Arguments.Conexion#">
			insert into DBMrenames (owner, sch, tab, old, tip, fecha, sts)
			SELECT	c.tab, '#GvarSchema#', object_name(o.id), o.name, 
					case when status & 2 = 2  then 'UI'	else 'ID' end,
					<cf_dbfunction name="today">, 0
			  FROM sysindexes o, #preserveSingleQuotes(Arguments.INDXs)# c
			 WHERE o.name = c.obj_name
			   AND status & 2048 & 4096 = 0
			   AND object_name(o.id)	<> c.tab
		</cfquery>
	<!--- Renombra los objetos encontrados --->
	<cfquery name="rsSQL" datasource="#Arguments.Conexion#">
		select sch, tab, old, tip, fecha, sts, min(IDren) as IDren
		  from DBMrenames r
		 where IDren > #Arguments.IDren#
		   and sts = 0
		group by sch, tab, old, tip, fecha, sts
	</cfquery>
	<cfloop query="rsSQL">
<cftry>	
		<cfif right(rsSQL.tip,1) EQ "K">
			<cfquery datasource="#Arguments.Conexion#">
				EXEC sp_rename '#rsSQL.old#', 'DBMREN_#rsSQL.tip##rsSQL.IDren#', 'OBJECT'
			</cfquery>
		<cfelse>
			<cfquery datasource="#Arguments.Conexion#">
				EXEC sp_rename '#rsSQL.tab#.#rsSQL.old#', 'DBMREN_#rsSQL.tip##rsSQL.IDren#', 'INDEX'
			</cfquery>
		</cfif>
<cfcatch type="any">
	<cfif right(rsSQL.tip,1) EQ "K">
		<cfthrow message="EXEC sp_rename '#rsSQL.old#', 'DBMREN_#rsSQL.tip##rsSQL.IDren#', 'OBJECT' --#rsSQL.tip# #cfcatch.Message#  #cfcatch.Detail#">
	<cfelse>
		<cfthrow message="EXEC sp_rename '#rsSQL.tab#.#rsSQL.old#', 'DBMREN_#rsSQL.tip##rsSQL.IDren#', 'INDEX' --#rsSQL.tip# #cfcatch.Message#  #cfcatch.Detail#">
	</cfif>
</cfcatch>
</cftry>
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
		<cfif find("PK",Arguments.tipo)+find("AK",Arguments.tipo)+find("INDEX",Arguments.tipo)>
			<cfset LvarSQL_RENAME = "EXEC sp_rename '#Arguments.tab#.#Arguments.oldName#', '#Arguments.newName#', 'INDEX'#EXEC#">
		<cfelse>
			<cfset LvarSQL_RENAME = "EXEC sp_rename '#Arguments.oldName#', '#Arguments.newName#', 'OBJECT'#EXEC#">
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
		<cfset LvarCol = fnGenColumn (rsSQL.tab, rsSQL.col, rsSQL.tip, rsSQL.lon, rsSQL.dec, 0, rsSQL.obl, rsSQL.dfl, rsSQL.lov)>
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
	<cfargument name="dflN">

	<cfset Lvar_DROP = "">
	<cfif Arguments.chkN NEQ "">
		<cfset Lvar_DROP &= "ALTER TABLE #Arguments.Tabla# DROP CONSTRAINT ""#Arguments.chkN#""#EXEC#">
	</cfif>
	<cfif Arguments.dflN NEQ "">
		<cfset Lvar_DROP &= "ALTER TABLE #Arguments.Tabla# DROP CONSTRAINT ""#Arguments.dflN#""#EXEC#">
	</cfif>
	<cfset Lvar_DROP &= "ALTER TABLE #Arguments.Tabla# DROP COLUMN #Arguments.Col##EXEC#">
	<cfreturn Lvar_DROP>
</cffunction>

<cffunction name="fnGenRenTab" output="false" returntype="string">
	<cfargument name="tabOld">
	<cfargument name="tabNew">

	<cfset Lvar_RENAME = "EXEC sp_rename '#Arguments.tabOld#', '#Arguments.tabNew#', 'OBJECT'#EXEC#">

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
	//  	ALTER TABLE tab ADD   col tip(lon) identity
	// Con Valor Inicial o es obl sin dfl (primer valor de lov o dfl de tipo):
	//  	ALTER TABLE tab ADD   col tip(lon,dec) NULL
	//  	UPDATE      tab SET   col = VALOR_INICIAL
	//  	ALTER TABLE tab ADD   CONSTRAINT tab_DF01 dfl FOR col		-- Cuando hay dfl
	//  	ALTER TABLE tab ALTER COLUMN NOT NULL						-- Cuando el obl
	// SINO
	//  	ALTER TABLE tab ADD   col tip(lon,dec) {CONSTRAINT TABLA_DF01 DEFAULT dfl} {NULL | NOT NULL}
	//
	// ALTER TABLE tab ADD CONSTRAINT tabla_CK01 CHECK (rul)			-- Cuando hay rul
	{
		tab1=trim(tab1);col=trim(col);tip=trim(tip);lon=trim(lon);dec=trim(dec);obl=trim(obl);dfl=trim(dfl);rul=trim(rul);
		LvarCol = fnGenColumn (tab1, col, tip, lon, dec, 0, obl, dfl, lov);

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
			if (LvarCol.dflIni NEQ "" AND LvarCol.dflIni NEQ LvarCol.dfl)
			{
				LvarSQL_ALTER &= "ALTER TABLE #tab1# ADD #col# #LvarCol.SQLtip# NULL#EXEC#";
				LvarSQL_ALTER &= "UPDATE #tab1# SET #col# = #LvarCol.dflIni##EXEC#";
				// Pone default y obligatorio
				if (dfl NEQ "")
				{
					LvarSQL_ALTER &= "ALTER TABLE #tab1# ADD CONSTRAINT #GvarObj.fnGetName(GvarTabPrefijo,"DF",sec)##LvarCol.SQLdfl# FOR #col##EXEC#";
				}
				if (obl EQ "1")
				{
					LvarSQL_ALTER &= "ALTER TABLE #tab1# ALTER COLUMN #col# #LvarCol.SQLtip##LvarCol.SQLnul##EXEC#";
				}
			}
			else
			{
				// Crea la Columna
				LvarSQL_ALTER &= "ALTER TABLE #tab1# ADD #col# #LvarCol.SQLtip##LvarCol.SQLdfl##LvarCol.SQLnul##EXEC#";
			}
			
			// Pone regla
			if (rul NEQ "")
			{
				LvarSQL_ALTER &= "ALTER TABLE #tab1# ADD CONSTRAINT #GvarObj.fnGetName(GvarTabPrefijo,"CK",sec)# CHECK #rul#" & "#EXEC#";
			}
		}

		return LvarSQL_ALTER & vbCrLf;
	}

	Function fnGenChgColumn(
							conexion,
							tab, col,   colAnt,
							tip1, lon1, dec1, ide1, obl1, dfl1, dflN1, rul1, chk1, 
							tip2, lon2, dec2, ide2, obl2, dfl2, rul2,  lov2, sec2)
	// ALTER TABLE tab DROP CONSTRAINT nombre_anterior						-- Cuando hay regla anterior, para evitar conflictos
	// RENOMBRAR cuando hay cambio de nombre en columna: colDB.colAnt
	//		EXEC sp_rename 'tabla.colAnt', 'col', 'COLUMN'
	// Cambio simple (cuando pasa de numero a numero, o de cualquiera a string, o solo cambia longitud):
	// 		ALTER TABLE tab DROP CONSTRAINT DEFAULT dflN_ant					-- Cuando hay default anterior, para evitar conflictos
	// 		ALTER TABLE tab ALTER COLUMN col TIPO_DE_DATOS(lon,dec) NULL_ANTERIOR
	// Regenerar (cuando cambia tipo, cambia LOB o cambia identity):
	// 		ALTER TABLE tab DROP CONSTRAINT DEFAULT dflN_ant					-- Cuando hay default anterior, para evitar conflictos
	//		ALTER TABLE tab ADD col__NEW TIPO_DE_DATOS(lon,dec) NULL
	//		UPDATE tabla SET col__NEW = col
	//		ALTER TABLE tab DROP col
	//		EXEC sp_rename 'tabla.col__NEW', 'col', 'COLUMN'
	// ALTER TABLE tab ALTER COLUMN col TIPO_DE_DATOS(lon,dec) [NOT] NULL  	-- Solo si cambia obl
	// UPDATE tabla SET col = DFL_DEFAULT WHERE col IS NULL						-- Solo si es obl sin default
	// ALTER TABLE tab ADD CONSTRAINT DEFAULT tabla_DF01 FOR col				-- Solo si cambia default
	// ALTER TABLE tab ADD CONSTRAINT tabla_CK01 CHECK (rul)					-- Solo si hay regla
	{
		tab=trim(tab);col=trim(col);
		tip1=trim(tip1);lon1=trim(lon1);dec1=trim(dec1);obl1=trim(obl1);dfl1=trim(dfl1);rul1=trim(rul1);chk1=trim(chk1); dflN1=trim(dflN1);
		tip2=trim(tip2);lon2=trim(lon2);dec2=trim(dec2);obl2=trim(obl2);dfl2=trim(dfl2);rul2=trim(rul2);lov2=trim(lov2);

		LvarCol = fnGenColumn (tab, col, tip2, lon2, dec2, obl1, obl2, dfl2, lov2);
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
			LvarSQL_ALTER &= "EXEC sp_rename '#tab#.#colAnt#', '#col#', 'COLUMN'#EXEC#";
		}
		
		// Cambio a Timestamp
		if (tip1 NEQ "TS" AND tip2 EQ "TS")
		{
			// BORRA EL DEFAULT
			if (dflN1 NEQ "")
			{
				LvarSQL_ALTER &= "ALTER TABLE #tab# DROP CONSTRAINT #dflN1##EXEC#";
				dfl1 = "";
				dflN1 = "";
			}
			LvarSQL_ALTER &= "ALTER TABLE #tab# DROP COLUMN #col##EXEC#";
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
			// SE BORRA EL DEFAULT PARA EVITAR PROBLEMAS CON EL CAMBIO, LUEGO SE CREA
			if (dflN1 NEQ "")
			{
				LvarSQL_ALTER &= "ALTER TABLE #tab# DROP CONSTRAINT #dflN1##EXEC#";
				dfl1 = "";
				dflN1 = "";
			}

			LvarSQL_ALTER &= "ALTER TABLE #tab# ALTER COLUMN #col# #LvarCol.SQLtip##LvarCol.SQLnulAnt##EXEC#";
			if (tip2 EQ "V")
			{
				LvarSQL_ALTER &= "UPDATE #tab# SET #col# = RTRIM(#col#)#EXEC#";
			}
		}
		else if (LvarRegenerar)
		{
			// SE BORRA EL DEFAULT PARA EVITAR PROBLEMAS CON EL CAMBIO, LUEGO SE CREA
			if (dflN1 NEQ "")
			{
				LvarSQL_ALTER &= "ALTER TABLE #tab# DROP CONSTRAINT #dflN1##EXEC#";
				dfl1 = "";
				dflN1 = "";
			}

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
			//else if (tip2 EQ "L")
			//{
			//	dflN1 = GvarObj.fnGetName(GvarTabPrefijo,"DF",sec2);
			//	LvarAddUpd	= "ALTER TABLE #tab# ADD #col__NEW# #LvarCol.SQLtip# CONSTRAINT #dflN1# DEFAULT 0 NOT NULL#EXEC#";
			//	// ACTUALIZA "0", "" o NULL a 0 SINO 1
			//	LvarAddUpd	&= "UPDATE #tab# SET #col__NEW# = #fnCast(col, tip1, tip2)##EXEC#";
			//	obl1 = "1";	obl2 = "1";
			//	dfl1 = "0";	
			//}
			// Convertir diferentes tipos
			else
			{
				LvarAddUpd	= "ALTER TABLE #tab# ADD #col__NEW# #LvarCol.SQLtip# NULL#EXEC#";
				LvarAddUpd	&= "UPDATE #tab# SET #col__NEW# = #fnCast(col, tip1, tip2)##EXEC#";
				obl1 = "0";
				dfl1 = "";
			}
			
			LvarSQL_ALTER &= "/* IF X GT 0:select count(1) as X from syscolumns where id=object_id('#tab#') and name='#col__NEW#' */#vbCrLf#";
			LvarSQL_ALTER &= "ALTER TABLE #tab# DROP COLUMN #col__NEW##EXEC#";
			LvarSQL_ALTER &= LvarAddUpd;
			LvarSQL_ALTER &= "ALTER TABLE #tab# DROP COLUMN #col##EXEC#";
			LvarSQL_ALTER &= "EXEC sp_rename '#tab#.#col__NEW#', '#col#', 'COLUMN'#EXEC#";
		}

		// Cambia Obligatorio
		if (obl1 NEQ obl2)
		{
			if (obl1 EQ "0" and obl2 EQ "1")
			{
				LvarSQL_ALTER &= "UPDATE #tab# SET #col# = #LvarCOL.dflObl# WHERE convert(varchar,#col#) IS NULL#EXEC#";
			}

			LvarSQL_ALTER &= "ALTER TABLE #tab# ALTER COLUMN #col# #LvarCol.SQLtip##LvarCol.SQLnul##EXEC#";
		}

		// Cambia Default
		if (compare(dfl1,dfl2) NEQ 0)
		{
			if (dflN1 NEQ "")
			{
				LvarSQL_ALTER &= "ALTER TABLE #tab# DROP CONSTRAINT #dflN1# /* #dfl1# */#EXEC#";
			}
			if (dfl2 NEQ "")
			{
				LvarSQL_ALTER &= "ALTER TABLE #tab# ADD CONSTRAINT #GvarObj.fnGetName(GvarTabPrefijo,"DF",sec2)##LvarCol.SQLdfl2# FOR #col##EXEC#";
			}
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
			if (tip2_ORI EQ "S" AND tip_ORI NEQ "CL")
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
		
	Function fnGenColumn(tab1, col, tip, lon, dec, oblAnt, obl, dfl, lov)
	{
		tab1=trim(tab1);col=trim(col);tip=trim(tip);lon=trim(lon);dec=trim(dec);oblAnt=trim(oblAnt);obl=trim(obl);dfl=trim(dfl);lov=trim(lov);
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
				LvarDefaultDfl = "'#trim(LvarDefaultDfl)#'";
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

			if (NOT listFind("user_name(),getdate()",dfl))
			{
				if (LvarCol.SQLstr AND mid(dfl,1,1) NEQ "'")
				{
					dfl = "'#dfl#'";
				}
				else if (tip EQ "D" AND IsNumeric(dfl) AND Len(dfl) EQ 8)
				{
					if (SQL_OR EQ "OR")
					{
						dfl = "CONVERT([datetime],(" & dfl & "),(112))";
					}
					else
					{
						dfl = "convert(datetime," & dfl & ",112)";
					}
				}
				// A los numericos los convierte: les quita ceros a la izquierda y pone parentesis a negativos
				Else if (LvarCol.SQLtip2 EQ "N")
				{
					dfl = fnValsToLiterals(dfl,LvarCol.SQLtip2,false);
					if (left(dfl, 1) EQ "(" AND right(dfl, 1) EQ ")")
					{
						dfl = trim(mid(dfl, 2, Len(dfl) - 2));
					}
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
		// Elimina comillas para comparar PD.dfl2 <> DB.dfl1 (Los convert(datetime) lo guarda sin comillas en SQLserver)
		LvarCol.dfl2 = replace(dfl,"'","","ALL");

		if (oblAnt EQ "1")
		{
			LvarCol.SQLnulAnt = " NOT NULL";
		}
		else
		{
			LvarCol.SQLnulAnt = " NULL";
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
