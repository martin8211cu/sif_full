<cf_templateheader title="Verificación de Integridad de Base de Datos">
<cf_web_portlet_start titulo="Verificación de Integridad de Base de Datos">
<cf_templatecss>
<form>
<BR />
<cfparam name="session.IntegrityDSN" default="">
<cfparam name="session.IntegrityOBJ" default="">

<cfparam name="url.dsn" default="">
<cfparam name="url.obj" default="">
<cfif url.dsn EQ "" OR url.obj EQ "">
	<cfset url.dsn = session.IntegrityDSN>
	<cfset url.obj = session.IntegrityOBJ>
</cfif>

<cfquery name="rsSQL" datasource="asp">
	select distinct d.dsn
	  from DBMmodelos m
		inner join DBMsch s
		 on s.IDsch = m.IDsch
		inner join DBMdsn d
		 on d.IDmod = m.IDmod
</cfquery>

Nombre del Objeto (úncamente PK,AK,UI,FK,CK):
<select id="txtDSN">
<cfoutput query="rsSQL">
	<option value="#rsSQL.dsn#"<cfif rsSQL.dsn EQ url.dsn> selected</cfif>>#rsSQL.dsn#</option>
</cfoutput>
</select>
<input 	type="text" name="txtObjeto" id="txtObjeto" value="<cfoutput>#url.obj#</cfoutput>" size="40"
		onkeydown="if(event.which == 13 || window.event && window.event.keyCode == 13) {sbVerificar(); return false;}" 
/>

<input type="button" value="Verificar" onclick="sbVerificar();" />
</form>

<script language="javascript">
	function sbVerificar()
	{
		var LvarObj = document.getElementById("txtObjeto").value.toUpperCase();
		var LvarDSN = document.getElementById("txtDSN").value;
		var LvarLen = LvarObj.length;
		var Lvar3 = LvarObj.substring(LvarLen, LvarLen - 3);
		var Lvar5 = LvarObj.substring(LvarLen, LvarLen - 5);
		if (Lvar3 == "_PK" || Lvar3 == "_CK" || LvarObj.search(/_(AK|UI|FK|CK)\d\d$/) > -1)
		{
			<cfif isdefined("url.UPLOAD")>
			location.href="DBMintegrity.cfm?UPLOAD=<cfoutput>#url.UPLOAD#</cfoutput>&dsn=" + LvarDSN + "&obj="+LvarObj;
			<cfelse>
			location.href="DBMintegrity.cfm?dsn=" + LvarDSN + "&obj="+LvarObj;
			</cfif>
		}
		else
		{
			setTimeout("alert('Sólo se pueden verificar _PK, _AKnn, _UInn, _FKnn, _CK, _CKnn');",1);
			return false;
		}
	}
	
	function right(str, n)
	{
		if (n <= 0)
		   return "";
		else if (n > String(str).length)
		   return str;
		else {
		   var iLen = String(str).length;
		   return String(str).substring(iLen, iLen - n);
		}
	}
</script>

<cfif url.dsn EQ "" or url.obj EQ "">
	<cfabort>
</cfif>

<cfset session.IntegrityDSN = url.dsn>
<cfset session.IntegrityOBJ = url.obj>

<cfset LvarObjTip = listLast(url.obj,"_")>
<cfset LvarSec = right(LvarObjTip,2)>
<cfset LvarTip = left(LvarObjTip,2)>

<cfset LvarTab = listFirst(url.obj,"_")>
<cfset LvarSuf = right(LvarTab,2)>

<cfoutput>
<cfif LvarTip EQ LvarSec>
	<cfset LvarSec = "00">
</cfif>
<cfquery name="rsSQL" datasource="asp">
	select m.IDsch
	  from DBMdsn d
		inner join DBMmodelos m
		 on m.IDmod = d.IDmod
	where d.dsn = '#url.dsn#'
</cfquery>
<cfset LvarIDsch = rsSQL.IDsch>
<cfset LvarDB  = Application.dsinfo[url.dsn].type>
<cfif listFind("sybase,sqlserver",LvarDB)>
	<cfset LvarPre = "">
	<cfset LvarSuf = 100>
<cfelseif LvarDB EQ "oracle">
	<cfset LvarPre = "">
	<cfset LvarSuf = 25>
<cfelseif LvarDB EQ "db2">
	<cfset LvarPre = "">
	<cfset LvarSuf = 13>
<cfelse>
	<cfthrow message="No se ha implementado base de datos #LvarDB#">
</cfif>
<cfset LvarMSG = "OK">
<cfset LvarRegla = "">
<cfset LvarCol = "">

<cfset DBMtab = "DBMtab">
<cfset DBMcol = "DBMcol">
<cfset DBMkey = "DBMkey">
<cfif isdefined("url.UPLOAD")>
	<cfset LvarTabSuf = 0>
	<cfquery name="rsSQL" datasource="asp">
		select IDtab, tab, des, rul
		  from DBMtabU
		 where IDupl = #url.UPLOAD# 
		   and upper(tab) = '#ucase(LvarTab)#'
	</cfquery>
	<cfif rsSQL.tab EQ "">
		<cfset LvarMSG = "La tabla no está definida en el UPLOAD">
	<cfelse>
		<cfset LvarTab   = rsSQL.tab>
		<cfset LvarTabD  = rsSQL.des>
		<cfset LvarIDtab = rsSQL.IDtab>
		<cfset LvarRul   = rsSQL.rul>
	</cfif>
	<cfset DBMtab = "DBMtabU">
	<cfset DBMcol = "DBMcolU">
	<cfset DBMkey = "DBMkeyU">
<cfelseif len(LvarTab) GT LvarSuf>
	<cfset LvarMSG = "La tabla no está definida en DBM">
<cfelseif len(LvarTab) LTE LvarSuf-1 OR len(LvarTab) EQ LvarSuf AND NOT isnumeric(right(LvarTab,2))>
	<cfset LvarTabSuf = 0>
	<cfquery name="rsSQL" datasource="asp">
		select IDtab, tab, des, rul
		  from DBMtab
		 where IDsch = #LvarIDsch# 
		   and upper(tab) = '#ucase(LvarTab)#'
	</cfquery>
	<cfif rsSQL.tab EQ "">
		<cfset LvarMSG = "La tabla no está definida en DBM">
	<cfelse>
		<cfset LvarTab   = rsSQL.tab>
		<cfset LvarTabD  = rsSQL.des>
		<cfset LvarIDtab = rsSQL.IDtab>
		<cfset LvarRul   = rsSQL.rul>
	</cfif>
<cfelse>
	<cfset LvarTabSuf = right(LvarTab,2)>
	<cfquery name="rsSQL" datasource="asp">
		select IDtab, tab, des, rul
		  from DBMtab
		 where IDsch = #LvarIDsch# 
		   and upper(tab) like '#left(ucase(LvarTab),LvarSuf-2)#%'
		   and suf#LvarSuf# = #LvarTabSuf#
	</cfquery>
	<cfif rsSQL.tab EQ "">
		<cfset LvarMSG = "La tabla no está definida en DBM">
	<cfelse>
		<cfset LvarTab   = rsSQL.tab>
		<cfset LvarTabD  = rsSQL.des>
		<cfset LvarIDtab = rsSQL.IDtab>
		<cfset LvarRul   = rsSQL.rul>
	</cfif>
</cfif>

<cfif LvarMSG EQ "OK">
	<cfset LvarObj = LvarTab & "_" & LvarObjTip>
	<cfset session.IntegrityOBJ = LvarObj>
	<cfset url.obj = LvarObj>

	<cfif listFind("PK,AK,UI",LvarTip)>
		<cfquery name="rsSQL" datasource="asp">
			select cols
			  from #DBMkey#
			 where IDtab = #LvarIDtab# 
			   and sec   = #LvarSec#
			   and tip   = '#left(LvarTip,1)#'
		</cfquery>
		<cfif rsSQL.cols EQ "">
			<cfset LvarMSG = "El objeto no está definido en DBM">
		<cfelse>
			<cfset LvarCols = rsSQL.cols>
			<cfset LvarRegla = "Valores Únicos por: #rsSQL.cols#">
			<cfset LvarRegla = "Campos: #LvarTab# (#rsSQL.cols#) no permiten valores duplicados">
			<cfif NOT fnExistsUnique(LvarTab, LvarObj, ucase(LvarObj))>
				<cfif fnExistsError()>
					<cfset LvarMSG = "Objeto no existe en base de datos por error de datos (valores duplicados en campos únicos)">
				<cfelse>
					<cfset LvarMSG = "Los datos estan correctos pero el Objeto no existe en base de datos (revisar mensaje de error)">
				</cfif>
			</cfif>
		</cfif>
	<cfelseif LvarTip EQ "FK">
		<cfquery name="rsSQL" datasource="asp">
			select cols, ref, colsR
			  from #DBMkey#
			 where IDtab = #LvarIDtab# 
			   and sec   = #LvarSec#
			   and tip   = '#left(LvarTip,1)#'
		</cfquery>
		<cfif rsSQL.cols EQ "">
			<cfset LvarMSG = "El objeto no está definido en DBM">
		<cfelse>
			<cfset LvarCols = rsSQL.cols>
			<cfset LvarRef = rsSQL.ref>
			<cfset LvarColsR = rsSQL.colsR>
			<cfset LvarRegla = "Campos: #LvarTab# (#LvarCols#) únicamente permiten valores existentes en: #LvarRef# (#LvarColsR#)">

			<cfif NOT fnExistsReference()>
				<cfif isdefined("url.UPLOAD")>
					<cfquery name="rsREF" datasource="asp">
						select IDtab, suf13, suf25
						  from DBMtabU
						 where IDupl = #url.UPLOAD# 
						   and tab	 = '#LvarRef#'
					</cfquery>
				<cfelse>
					<cfquery name="rsREF" datasource="asp">
						select IDtab, suf13, suf25
						  from DBMtab
						 where IDsch = #LvarIDsch# 
						   and tab	 = '#LvarRef#'
					</cfquery>
				</cfif>
				<cfquery name="rsSQL" datasource="asp">
					select tip, sec
					  from #DBMkey#
					 where IDtab = #rsREF.IDtab#
					   and cols  = '#LvarColsR#'
					   --and tip   in ('P','A')
				</cfquery>

				<cfif rsSQL.sec EQ 0>
					<cfset LvarRefSec = "">
				<cfelse>
					<cfset LvarRefSec = numberFormat(rsSQL.sec,"00")>
				</cfif>
				<cfif (LvarSuf EQ 13 and rsREF.suf13 GT 0) OR (LvarSuf EQ 25 and rsREF.suf25 GT 0)>
					<cfif LvarSuf EQ 13>
						<cfset LvarRefObj = "#left(LvarRef,11)##numberFormat(rsREF.suf13,"00")#_#rsSQL.tip#K#LvarRefSec#">
					<cfelse>
						<cfset LvarRefObj = "#left(LvarRef,23)##numberFormat(rsREF.suf25,"00")#_#rsSQL.tip#K#LvarRefSec#">
					</cfif>
				<cfelse>
					<cfset LvarRefObj = "#LvarRef#_#rsSQL.tip#K#LvarRefSec#">
				</cfif>
				<cfif NOT fnExistsUnique(LvarRef, LvarRefObj, ucase(LvarRefObj))>
					<cfset LvarMSG = "No existe la llave referenciada #LvarRefObj# en base de datos, por tanto no se pudo crear la llave foránea">
				<cfelse>
					<cfif fnExistsError()>
						<cfset LvarMSG = "Objeto no existe en base de datos por error de datos (valores no existentes en #LvarRef# (#LvarColsR#))">
					<cfelse>
						<cfset LvarMSG = "Los datos estan correctos pero el Objeto no existe en base de datos (revisar mensaje de error)">
					</cfif>
				</cfif>
			</cfif>
		</cfif>
	<cfelseif LvarTip EQ "CK" and LvarSec EQ "00">
		<cfif LvarRul EQ "">
			<cfset LvarMSG = "La tabla no tiene regla definida en DBM">
		<cfelse>
			<cfset LvarRegla = LvarRul>
			<cfif NOT fnExistsCheck()>
				<cfif fnExistsError()>
					<cfset LvarMSG = "Objeto no existe en base de datos por error de datos (valores no permitidos)">
				<cfelse>
					<cfset LvarMSG = "Los datos estan correctos pero el Objeto no existe en base de datos (revisar mensaje de error)">
				</cfif>
			</cfif>
		</cfif>
	<cfelseif LvarTip EQ "CK">
		<cfquery name="rsSQL" datasource="asp">
			select col, des, tip, obl, minVal, maxVal, lov
			  from #DBMcol#
			 where IDtab = #LvarIDtab# 
			   and sec   = #LvarSec#
		</cfquery>
		<cfif rsSQL.col EQ "">
			<cfset LvarMSG = "El objeto no está definido en DBM">
		<cfelseif rsSQL.minVal & rsSQL.maxVal & rsSQL.lov EQ "">
			<cfset LvarCol = rsSQL.col>
			<cfset LvarColD = rsSQL.des>
			<cfset LvarMSG = "El campo no tiene reglas definidas en DBM">
		<cfelse>
			<cfset LvarCol = rsSQL.col>
			<cfset LvarColD = rsSQL.des>
			<cfset LvarMin = rsSQL.minVal>
			<cfset LvarMax = rsSQL.minVal>
			<cfset LvarLov = rsSQL.lov>
			<cfset LvarDBM = createObject("component","asp.parches.DBmodel.Componentes.DBModel")>
			<cfset LvarDBMDB = LvarDBM.init_ObjBD(url.dsn)>
			<cfset LvarRegla = LvarDBMDB.toRule(rsSQL.col,rsSQL.tip,rsSQL.obl,rsSQL.minVal,rsSQL.maxVal,rsSQL.lov)>
			<cfif NOT fnExistsCheck()>
				<cfif fnExistsError()>
					<cfset LvarMSG = "Objeto no existe en base de datos por error de datos (valores no permitidos)">
				<cfelse>
					<cfset LvarMSG = "Los datos estan correctos pero el Objeto no existe en base de datos (revisar mensaje de error)">
				</cfif>
			</cfif>
			<cfset LvarRegla = "<table><tr><td><strong>REGLA</strong></td><td>#LvarRegla#</td></tr>">
			<cfif LvarMin NEQ "">
				<cfset LvarRegla = LvarRegla & "<tr><td><strong>VALOR MÍNIMO</strong></td><td>#LvarMin#</td></tr>">
			</cfif>
			<cfif LvarMax NEQ "">
				<cfset LvarRegla = LvarRegla & "<tr><td><strong>VALOR MÁXIMO</strong></td><td>#LvarMax#</td></tr>">
			</cfif>
			<cfif LvarLov NEQ "">
				<cfset LvarLov = replace(LvarLov,"\t","</td><td>","ALL")>
				<cfset LvarLov = replace(LvarLov,"\n","</td></tr><tr><td>","ALL")>
				<cfset LvarLov = replace(LvarLov,"<DESC>","Descripcion no documentada","ALL")>
				<cfset LvarRegla = LvarRegla & "<tr><td><strong>VALORES<BR>PERMITIDOS&nbsp;&nbsp;</strong></td><td><strong>DESCRIPCION</strong></td></tr>">
				<cfset LvarRegla = LvarRegla & "<tr><td>#LvarLov#</td></tr>">
			</cfif>
			<cfset LvarRegla = LvarRegla & "</table>">
		</cfif>
	</cfif>
</cfif>
<table>
	<tr>
		<td valign="top"><strong>DSN</strong></td>
		<td valign="top">#url.dsn#</td>
	</tr>
	<tr>
		<td nowrap="nowrap"><strong>Objeto de Integridad</strong>&nbsp;&nbsp;</td>
		<td valign="top">#url.obj#</td>
	</tr>
	<cfif LvarSec NEQ "">
	<tr>
		<td valign="top"><strong>Secuencia</strong></td>
		<td valign="top">#LvarSec#</td>
	</tr>
	</cfif>
	<tr>
		<td valign="top"><strong>Tabla</strong></td>
		<td valign="top">#LvarTab#</td>
	</tr>
	<tr>
		<td valign="top"><strong>Tipo de Integridad</strong></td>
		<td valign="top">#LvarTip#</td>
	</tr>
	<cfif LvarCol NEQ "">
	<tr>
		<td valign="top"><strong>Columna</strong></td>
		<td valign="top">#LvarCol#: #LvarColD#</td>
	</tr>
	</cfif>
	<cfif LvarRegla NEQ "">
	<tr>
		<td valign="top"><strong>Regla de Integridad</strong></td>
		<td valign="top">#LvarRegla#</td>
	</tr>
	</cfif>
	<tr>
		<td valign="top"><strong>Status</strong></td>
		<td valign="top">#LvarMSG#</td>
	</tr>
</table>

<cfif isdefined("rsERR")>
	<BR><BR>
	<div align="center">
	<strong>#replace(LvarMSG,"Objeto no existe en base de datos por e","E")#:</strong>
	<BR><BR>
	</div>
	<cfset LvarNiv = listToArray(LvarSTR,"|")>
	<table align="center" style="border:solid 1px ##999999; border-collapse:collapse" >
		<tr style="border:solid 1px ##BBBBBB;">
			<td align="center" style="border:solid 1px ##BBBBBB; background-color:##DDDDDD" rowspan="2">##</td>
			<cfloop index="i" from="1" to="#arrayLen(LvarNiv)#">
				<cfif listFirst(LvarNiv[i],":") EQ listLast(LvarNiv[i],":")>
					<td style="border:solid 1px ##BBBBBB; background-color:##DDDDDD;" align="center" rowspan="2" colspan="#listLen(listLast(LvarNiv[i],":"))#">#ucase(listFirst(LvarNiv[i],":"))#&nbsp;</td>
				<cfelse>
					<td style="border:solid 1px ##BBBBBB; background-color:##DDDDDD;" align="center" colspan="#listLen(listLast(LvarNiv[i],":"))#">#listFirst(LvarNiv[i],":")#&nbsp;</td>
				</cfif>
			</cfloop>
		</tr>
		<tr style="border:solid 1px ##BBBBBB;">
			<cfloop index="i" from="1" to="#arrayLen(LvarNiv)#">
				<cfloop index="j" from="1" to="#listLen(listLast(LvarNiv[i],":"))#">
					<cfif listFirst(LvarNiv[i],":") NEQ listLast(LvarNiv[i],":")>
						<td style="border:solid 1px ##BBBBBB; background-color:##DDDDDD;">#listGetAt(listLast(LvarNiv[i],":"),j)#&nbsp;</td>
					</cfif>
				</cfloop>
			</cfloop>
		</tr>
		<cfloop query="rsERR">
			<tr>
				<td align="center" style="border:solid 1px ##BBBBBB; background-color:##DDDDDD">#rsERR.currentRow#</td>
				<cfloop index="i" from="1" to="#arrayLen(LvarNiv)#">
					<cfloop index="j" from="1" to="#listLen(listLast(LvarNiv[i],":"))#">
						<cfset LvarCampo = listGetAt(listLast(LvarNiv[i],":"),j)>
						<cfset LvarValor = rsERR[LvarCampo]>
						<cfif isArray(LvarValor)>
							<cfset LvarValor = "*">
						</cfif>
						<td style="border:solid 1px ##BBBBBB;">#LvarValor#&nbsp;</td>
					</cfloop>
				</cfloop>
			</tr>
		</cfloop>
		<cfif LvarSQLmalos NEQ "">
			<tr>
				<td align="left" style="border:solid 1px ##BBBBBB; background-color:##DDDDDD">#LvarSQLmalos#</td>
			</tr>
		</cfif>
	</table>
</cfif>
</cfoutput>

<cffunction name="fnExistsCheck" output="no" returntype="boolean"> 
	<cfif LvarDB EQ "sybase">
		<cfquery name="rsSQL" datasource="#url.dsn#">
			SELECT count(1) as cantidad
			  FROM sysobjects
			 WHERE	name	= '#LvarObj#'
			   AND 	type	= 'R'
		</cfquery>
	<cfelseif LvarDB EQ "sqlserver">
		<cfquery name="rsSQL" datasource="#url.dsn#">
			SELECT count(1) as cantidad
			  FROM sysobjects
			 WHERE	name	= '#LvarObj#'
			   AND 	type	= 'C'
		</cfquery>
	<cfelseif LvarDB EQ "oracle">
		<cfquery name="rsSQL" datasource="#url.dsn#">
			SELECT	count(1) as cantidad
			  FROM	USER_CONSTRAINTS
			 WHERE	OWNER			= '#ucase(trim(Application.dsinfo[url.dsn].Schema))#'
			   AND 	TABLE_NAME		= '#ucase(LvarTab)#'
			   AND	CONSTRAINT_TYPE	= 'C'
			   AND  CONSTRAINT_NAME	= '#ucase(LvarObj)#'
		</cfquery>
	<cfelseif LvarDB EQ "db2">
		<cfquery name="rsSQL" datasource="#url.dsn#">
			SELECT count(1) as cantidad
			  FROM SYSCAT.CHECKS
			 WHERE	TABSCHEMA	= '#ucase(left(trim(Application.dsinfo[url.dsn].Schema),8))#'
			   AND 	TABNAME		= '#ucase(LvarTab)#'
			   AND  CONSTNAME	= '#ucase(LvarObj)#'
		</cfquery>
	</cfif>
	<cfreturn rsSQL.cantidad GT 0>
</cffunction>

<cffunction name="fnExistsUnique" output="no" returntype="boolean">
	<cfargument name="tab">
	<cfargument name="obj">
	<cfargument name="obj2">
	<cfif listFind("sybase,sqlserver",LvarDB)>
		<cfquery name="rsIDX" datasource="#url.dsn#">
			EXEC sp_helpindex '#Arguments.Tab#'
		</cfquery>
		<cfif not isdefined("rsIDX")>
			<cfquery name="rsSQL" datasource="#url.dsn#">
				SELECT	0 as cantidad
			</cfquery>
		<cfelse>
			<cfquery name="rsSQL" dbtype="query">
				SELECT	index_description
				  FROM	rsIDX
				 WHERE	index_name = '#Arguments.Obj#'
			</cfquery>
			<cfquery name="rsSQL" datasource="#url.dsn#">
				<cfif find('unique',rsSQL.index_description)>
				SELECT	1 as cantidad
				<cfelse>
				SELECT	0 as cantidad
				</cfif>
			</cfquery>
		</cfif>
	<cfelseif LvarDB EQ "oracle">
		<cfquery name="rsSQL" datasource="#url.dsn#">
			SELECT	count(1) as cantidad
			  FROM  ALL_CONSTRAINTS
			 WHERE	OWNER			= '#ucase(trim(Application.dsinfo[url.dsn].Schema))#'
			   AND 	TABLE_NAME		= '#ucase(Arguments.Tab)#'
			   AND  CONSTRAINT_NAME	= '#Arguments.obj2#'
			   AND	CONSTRAINT_TYPE in ('P','U')
		</cfquery>
	<cfelseif LvarDB EQ "db2">
		<cfquery name="rsSQL" datasource="#url.dsn#">
			SELECT	count(1) as cantidad
			  FROM  SYSCAT.TABCONST
			 WHERE	TABSCHEMA	= '#ucase(left(trim(Application.dsinfo[url.dsn].Schema),8))#'
			   AND 	TABNAME		= '#ucase(Arguments.tab)#'
			   AND  CONSTNAME	= '#Arguments.obj2#'
			   AND  TYPE 		in ('P','U')
		</cfquery>
	</cfif>
	<cfreturn rsSQL.cantidad GT 0>
</cffunction>

<cffunction name="fnExistsReference" output="no" returntype="boolean"> 
	<cfif LvarDB EQ "sybase">
		<cfquery name="rsSQL" datasource="#url.dsn#">
			select 	count(1) as cantidad
			  from sysreferences r 
			 where tableid = object_id('#LvarTab#')
			   and object_name(constrid) = '#LvarObj#'
				--and object_name(reftabid) = '#LvarRef#'
		</cfquery>
	<cfelseif LvarDB EQ "sqlserver">
		<cfquery name="rsSQL" datasource="#url.dsn#">
			select 	count(1) as cantidad
			  from sysreferences r 
			 where fkeyid  = object_id('#LvarTab#')
			   and object_name(constid) = '#LvarObj#'
			   --and object_name(rkeyid) = '#LvarRef#'
		</cfquery>
	<cfelseif LvarDB EQ "oracle">
		<cfquery name="rsSQL" datasource="#url.dsn#">
			SELECT	count(1) as cantidad
			  FROM ALL_CONSTRAINTS T
				INNER JOIN ALL_CONSTRAINTS P
					 ON P.OWNER 			= T.R_OWNER
					AND P.CONSTRAINT_NAME	= T.R_CONSTRAINT_NAME
			 WHERE	T.OWNER				= '#ucase(trim(Application.dsinfo[url.dsn].Schema))#'
			   AND 	T.TABLE_NAME		= '#ucase(LvarTab)#'
			   AND  T.CONSTRAINT_NAME	= '#ucase(LvarObj)#'
			   AND  T.CONSTRAINT_TYPE 	= 'R'
			   --AND  P.TABLE_NAME		= '#LvarRef#'
		</cfquery>
	<cfelseif LvarDB EQ "db2">
		<cfquery name="rsSQL" datasource="#url.dsn#">
			SELECT	count(1) as cantidad
			  FROM SYSCAT.REFERENCES
			 WHERE	TABSCHEMA	= '#ucase(left(trim(Application.dsinfo[url.dsn].Schema),8))#'
			   AND 	TABNAME		= '#ucase(LvarTab)#'
			   AND  CONSTNAME	= '#ucase(LvarObj)#'
			   --AND  REFTABNAME	= '#LvarRef#'
		</cfquery>
	</cfif>
	<cfreturn rsSQL.cantidad GT 0>
</cffunction>

<cffunction name="fnExistsError" output="no" returntype="boolean">
	<cfset LvarSQLmalos = "">
	<cfif listFind("PK,AK,UI",LvarTip)>
		<cfset LvarSTR = "CAMPOS UNICOS:#LvarCols#|duplicados:duplicados">
		<cfquery name="rsERR" datasource="#url.dsn#">
			SELECT	#LvarCols#, count(1) as duplicados
			  FROM #LvarTab#
			 GROUP BY #LvarCols#
			HAVING count(1) > 1
		</cfquery>
		<cfset LvarSQLmalos = "SELECT #LvarCols# FROM #LvarTab# GROUP BY #LvarCols# HAVING count(1) > 1">
	<cfelseif LvarTip EQ "FK">
		<cfquery name="rsSQL" datasource="asp">
			select cols
			  from #DBMkey#
			 where IDtab = #LvarIDtab# 
			   and sec   = 0
			   and tip   = 'P'
		</cfquery>
		<cfset LvarSTR = "LLAVE PRIMARIA:#rsSQL.cols#|VALORES INEXISTENTES:#LvarCols#">
		<cfquery name="rsERR" datasource="#url.dsn#">
			SELECT	#rsSQL.cols#,#LvarCols#
			  FROM	#LvarTab# t
			 WHERE	(
			 	select count(1)
				  from #LvarRef# r
					<cfloop index="i" from="1" to="#listLen(LvarCols)#">
						<cfif i EQ 1>
							WHERE
						<cfelse>
							  AND
						</cfif>
								t.#listGetAt(LvarCols,i)# = r.#listGetAt(LvarColsR,i)#
					</cfloop>
				 ) = 0
			<cfloop index="i" from="1" to="#listLen(LvarCols)#">
				<cfif i EQ 1>
				 AND (
				<cfelse>
					  OR
				</cfif>
						t.#listGetAt(LvarCols,i)# IS NOT NULL
			</cfloop>
				)
		</cfquery>
		<cfset LvarSQLmalos = "SELECT #LvarCols# FROM #LvarTab# t WHERE (select count(1) from #LvarRef# r">
		<cfloop index="i" from="1" to="#listLen(LvarCols)#">
			<cfif i EQ 1>
				<cfset LvarSQLmalos &= " WHERE t.#listGetAt(LvarCols,i)# = r.#listGetAt(LvarColsR,i)#">
			<cfelse>
				<cfset LvarSQLmalos &= " AND t.#listGetAt(LvarCols,i)# = r.#listGetAt(LvarColsR,i)#">
			</cfif>
		</cfloop>						
		<cfset LvarSQLmalos &= ") = 0">
		<cfloop index="i" from="1" to="#listLen(LvarCols)#">
			<cfif i EQ 1>
				<cfset LvarSQLmalos &= " AND (t.#listGetAt(LvarCols,i)# IS NOT NULL">
			<cfelse>
				<cfset LvarSQLmalos &= " OR t.#listGetAt(LvarCols,i)# IS NOT NULL">
			</cfif>
		</cfloop>
		<cfset LvarSQLmalos &= ")">
	<cfelseif LvarTip EQ "CK">
		<cfquery name="rsSQL" datasource="asp">
			select cols
			  from #DBMkey#
			 where IDtab = #LvarIDtab# 
			   and sec   = 0
			   and tip   = 'P'
		</cfquery>
		<cfif LvarSec EQ "00">
			<cfset LvarCampos = "#rsSQL.cols#">
			<cfset LvarSTR = "LLAVE PRIMARIA:#rsSQL.cols#|VALORES NO PERMITIDOS:">
			<cfquery name="rsSQL" datasource="asp">
				select col
				  from #DBMcol#
				 where IDtab = #LvarIDtab# 
			</cfquery>
			<cfset LvarReglaLst = ArrayToList(listToArray(REREPLACE(LvarRegla,"[^a-zA-Z0-9_']"," ","ALL"), " "))>
			<cfset LvarColumLst = "">
			<cfloop query="rsSQL">
				<cfif listFind(LvarReglaLst,rsSQL.col) AND not listFind(LvarColumLst,rsSQL.col)>
					<cfset LvarColumLst &= ",#rsSQL.col#">
				</cfif>
			</cfloop>
			<cfset LvarCampos &= "#LvarColumLst#">
			<cfset LvarSTR &= "#mid(LvarColumLst,2,1000)#">
		<cfelse>
			<cfset LvarCampos = "#rsSQL.cols#,#LvarCol#">
			<cfset LvarSTR = "LLAVE PRIMARIA:#rsSQL.cols#|VALORES NO PERMITIDOS:#LvarCol#">
		</cfif>
		<cfquery name="rsERR" datasource="#url.dsn#">
			SELECT	#LvarCampos#
			  FROM	#LvarTab#
			 WHERE	NOT (#preserveSingleQuotes(LvarRegla)#)
		</cfquery>
		<cfset LvarSQLmalos &= "SELECT #LvarCampos# FROM #LvarTab# WHERE NOT (#preserveSingleQuotes(LvarRegla)#)">
	</cfif>
	<cfif rsERR.recordCount EQ 0>
		<cfset LvarSQLmalos = "">
	</cfif>
	<cfreturn rsERR.recordCount GT 0>
</cffunction>
<BR>
<cf_web_portlet_end>
<cf_templatefooter>
