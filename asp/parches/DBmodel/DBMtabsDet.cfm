<cf_templateheader title="Descripción de tablas"> 
	<cfset titulo = 'Modelo de Base de Datos'>			
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">	
		<cfquery name="rsTab" datasource="asp">
			select s.sch, IDtab, tab, des, rul, suf25, suf13, 
				del, case when IDmodORI is null then 0 else 1 end as gen 
			  from DBMtab t
			  	inner join DBMsch s
					on s.IDsch=t.IDsch
			 where IDtab=#form.IDtab#
		</cfquery>
		<cfif rsTab.suf25 GT 0>
			<cfset LvarPrefijo30 = mid(rsTab.tab,1,23) & numberFormat(rsTab.suf25,"00")>
		<cfelse>
			<cfset LvarPrefijo30 = rsTab.tab>
		</cfif>
		<cfif rsTab.suf13 GT 0>
			<cfset LvarPrefijoDB2 = mid(rsTab.tab,1,11) & numberFormat(rsTab.suf13,"00")>
		<cfelse>
			<cfset LvarPrefijoDB2 = rsTab.tab>
		</cfif>
		<cf_dbfunction name="sreplace" args="lov,'\n','<BR>'" returnvariable="LvarSRPL">
		<cf_dbfunction name="sreplace" args="#LvarSRPL#;'\t';'='" returnvariable="LvarSRPL" delimiters=";">
		<cfquery name="rsCols" datasource="asp">
			select 	sec, col as colN, des, tip, lon, dec, ide, obl, dfl, minVal, maxVal, del,
					case 
						when del = 1 then '&lt;DBM:DROP&gt;' 
						else #preserveSingleQuotes(LvarSRPL)#
					end lov,
					case tip
						when 'C'	then 'Caracter Longitud Fija'
						when 'V'	then 'Caracter Longitud Variable'
						when 'CL'	then 'Caracter hasta 2GB'

						when 'B'	then 'Binario Longitud Fija'
						when 'VB'	then 'Binario Longitud Variable'
						when 'BL'	then 'Binario hasta 2GB'
						
						when 'N'	then 'Numérico de Funto Fijo'
						when 'F'	then 'Numérico de Funto Flotante'
						when 'I'	then 'Numérico sin decimales'

						when 'L'	then 'Lógico 0 o 1'
						
						when 'D'	then 'Fecha y Hora'
						when 'TS'	then 'Control de concurrencia'
						else tip
					end as tipo,
					<cf_dbfunction name="length" args="col"> as colLen
			  from DBMcol 
			 where IDtab=#form.IDtab#
			 order by sec
		</cfquery>
		<cf_dbfunction name="op_concat" returnvariable="CAT">
		<cfquery name="rsKeys" datasource="asp">
			select sec, cols,
					case tip
						when 'P' then 'PK'
						when 'A' then 'AK'
						when 'U' then 'IU'
						when 'F' then 'FK'
						when 'I' then 'ID'
					end as tip,
					case tip
						when 'P' then 1
						when 'A' then 2
						when 'U' then 3
						when 'F' then 4
						when 'I' then 5
					end as keyO,
					'#LvarPrefijo30#'
					#CAT#
					case tip
						when 'P' then '_PK'
						when 'A' then '_AK'
						when 'U' then '_UI'
						when 'F' then '_FI'
						when 'I' then '_ID'
					end
					#CAT#
					case tip
						when 'P' then ''
						else right('00' #CAT# <cf_dbfunction name="to_char" args="sec">,2)
					end as KeyN_30,
		
					'#LvarPrefijoDB2#'
					#CAT#
					case tip
						when 'P' then '_PK'
						when 'A' then '_AK'
						when 'U' then '_UI'
						when 'F' then '_FI'
						when 'I' then '_ID'
					end
					#CAT#
					case tip
						when 'P' then ''
						else right('00' #CAT# <cf_dbfunction name="to_char" args="sec">,2)
					end as KeyN_DB2
					
			  from DBMkey k
			 where IDtab=#form.IDtab# 
			   AND (k.tip <> 'F' OR k.idxTip = 'F')
			 order by keyO, sec
		</cfquery>
		
		<cfquery name="rsFKs" datasource="asp">
			select 'FK' as tip, sec, cols, ref, colsR,
					'#LvarPrefijo30#'
					#CAT#
					'_FK'
					#CAT#
					case tip
						when 'P' then ''
						else right('00' #CAT# <cf_dbfunction name="to_char" args="sec">,2)
					end as KeyN_30,
		
					'#LvarPrefijoDB2#'
					#CAT#
					'_FK'
					#CAT#
					case tip
						when 'P' then ''
						else right('00' #CAT# <cf_dbfunction name="to_char" args="sec">,2)
					end as KeyN_DB2
					
			  from DBMkey k
			 where IDtab=#form.IDtab# 
			   AND k.tip = 'F'
			 order by sec
		</cfquery>
		
		<cfquery name="rsDEPs" datasource="asp">
			select t.tab, k.sec, k.cols, k.colsR, 'DEP' as tip, k.del,
					'#LvarPrefijo30#'
					#CAT#
					'_FK'
					#CAT#
					case tip
						when 'P' then ''
						else right('00' #CAT# <cf_dbfunction name="to_char" args="sec">,2)
					end as KeyN_30,
		
					'#LvarPrefijoDB2#'
					#CAT#
					'_FK'
					#CAT#
					case tip
						when 'P' then ''
						else right('00' #CAT# <cf_dbfunction name="to_char" args="sec">,2)
					end as KeyN_DB2
			  from DBMkey k
				inner join DBMtab t
					 on t.IDtab = k.IDtab
					and t.IDsch=#esq#
			 where ref='#rsTab.tab#' 
			 order by t.tab, k.sec	
		</cfquery>
		
		<cfoutput>
		<table>
			<tr>
				<td>Schema:</td>
				<td>#rsTab.sch#</td>
			</tr>
			<tr>
				<td>IDtab:</td>
				<td>#rsTab.IDtab#</td>
			</tr>
			<tr>
				<td>Tabla:</td>
				<td>#rsTab.tab#</td>
				<td>:&nbsp;</td>
				<td>#rsTab.des#</td>
			</tr>
			<tr>
				<td>Regla a Nivel de Tabla:&nbsp;&nbsp;</td>
				<td><cfif trim(rsTab.rul) EQ "">N/A<cfelse>#rsTab.rul#</cfif></td>
			</tr>
			<tr>
				<td>Status:&nbsp;&nbsp;</td>
				<td>
					<cfif trim(rsTab.del) EQ "1">
						#htmleditformat("<DBM:DROP>")#
					<cfelseif trim(rsTab.gen) EQ "0">
						#htmleditformat("<DBM:NO_GENERATE>")#
					<cfelse>
						#htmleditformat("<DBM:OK>")#
					</cfif>	
				</td>
			</tr>
		</table>
		<BR>
		</cfoutput>
		<strong>COLUMNAS</strong>
		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
				query="#rsCols#"
				desplegar="sec, colN, des, tip, tipo, lon, dec, ide, obl, dfl, minVal, maxVal, lov"
				etiquetas="Secuencia,Columna,Descripcion, ,Tipo,Long,Decs,Ide,Obl,Default,Min,Max,Valores Permitidos"
				formatos="S,S,S,S,S,S,S,S,S,S,S,S,S,S"
				align="left,left,left,center,left,left,left,left,left,left,left,left,left,left,left"
				showlinks="no"
				keys=""
				showEmptyListMsg="yes"
				maxRows="25"
				linearoja="del EQ 1"
				incluyeform="no"
				formName="form1"
				PageIndex="2"
		/>
		<BR>
		<strong>INDICES</strong>
		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
				query="#rsKEYs#"
				desplegar="tip, cols, keyN_30, keyN_DB2"
				etiquetas="Tipo,Columnas,Nombre Normal, Nombre DB2"
				formatos="S,S,S,S,S,S,S,S,S,S,S,S"
				align="left,left,left,left,left,left,left,left,left,left,left,left,left"
				showlinks="no"
				keys=""
				showEmptyListMsg="yes"
				maxRows="25"
				incluyeform="no"
				formName="form1"
				PageIndex="3"
		/>
		<BR>
		<strong>REFERENCIAS</strong>
		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
				query="#rsFKs#"
				desplegar="tip, cols, ref, colsR, keyN_30, keyN_DB2"
				etiquetas="Tipo,Columnas,Tabla Ref,Cols Ref,Nombre Normal, Nombre DB2"
				formatos="S,S,S,S,S,S,S,S,S,S,S,S"
				align="left,left,left,left,left,left,left,left,left,left,left,left,left"
				showlinks="no"
				keys=""
				showEmptyListMsg="yes"
				maxRows="25"
				incluyeform="no"
				formName="form1"
				PageIndex="4"
		/>
		<BR>
		<strong>DEPENDENCIAS</strong>
		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
				query="#rsDEPs#"
				desplegar="tab, tip, cols, colsR,del"
				etiquetas="Tabla,Tipo,Columnas, Columnas en #rsTab.tab#,Borrar"
				formatos="S,S,S,S,S,S,S,S,S,S,S,S"
				align="left,left,left,left,left,left,left,left,left,left,left,left,left"
				showlinks="no"
				keys=""
				showEmptyListMsg="yes"
				maxRows="25"
				incluyeform="no"
				formName="form1"
				PageIndex="5"
		/>

		<BR>
		<strong>SQLs:</strong><BR>
		<cfset LvarCRLF = chr(13) & chr(10) & "    ">
		<cfset LvarSEL 	= "    ">
		<cfset LvarINS1 = "    INSERT INTO #rsTab.tab# (" & LvarCRLF>
		<cfset LvarINS2 = "">
		<cfset LvarUPD  = "    UPDATE #rsTab.tab#" & LvarCRLF>
		<cfset LvarCOLs = "">

		<cfquery name="rsSQL" dbtype="query">
			select max(colLen) as colLen from rsCols
		</cfquery>

		<cfquery name="rsPK" dbtype="query">
			select cols from rsKeys where tip = 'PK'
		</cfquery>
		
		<cfset LvarPKs = rsPK.cols>

		<cfset LvarIdentity = false>
		<cfset LvarSEL_INI = true>
		<cfset LvarINS_INI = true>
		<cfset LvarUPD_INI = true>
		<cfset LvarWHR_INI = true>
		<cfloop query="rsCols">
			<cfset LvarSpaces = rsSQL.ColLen-len(rsCols.ColN)>
			<cfif LvarSEL_INI>
				<cfset LvarSEL &=	"SELECT ">
				<cfset LvarSEL_INI = false>
			<cfelse>
				<cfset LvarSEL &= 	"," & LvarCRLF>
				<cfset LvarSEL &= 	"       ">
			</cfif>
			<cfif rsCols.ide EQ 1>
				<cfset LvarIdentity = true>
			<cfelseif rsCols.tip NEQ "TS">
				<cfif LvarINS_INI>
					<cfset LvarINS1 &= 	"       ">
					<cfset LvarINS2 &= 	"VALUES(" & LvarCRLF>
					<cfset LvarINS2 &= 	"       ">
					<cfset LvarINS_INI = false>
				<cfelse>
					<cfset LvarINS1 &= 	"," & LvarCRLF>
					<cfset LvarINS1 &= 	"       ">
					<cfset LvarINS2 &= 	"," & LvarCRLF>
					<cfset LvarINS2 &= 	"       ">
				</cfif>
				<cfset LvarINS1 &= 	rsCols.colN>
				<cfset LvarINS2 &= 	fnQueryParam(rsCols.colN,rsCols.tip,rsCols.lon,rsCols.dec,rsCols.obl)>
			</cfif>
			<cfif rsCols.ide EQ 0 AND rsCols.tip NEQ "TS" AND NOT listFind(LvarPKs,rsCols.colN)>
				<cfif LvarUPD_INI>
					<cfset LvarUPD &= 	"   SET ">
					<cfset LvarUPD_INI = false>
				<cfelse>
					<cfset LvarUPD &= 	"," & LvarCRLF>
					<cfset LvarUPD &= 	"       ">
				</cfif>
				<cfset LvarUPD &= 	"#rsCols.colN#">
				<cfif LvarSpaces GT 0>
					<cfset LvarUPD &= repeatString(" ", LvarSpaces)>
				</cfif>
				<cfset LvarUPD &= 	" = #fnQueryParam(rsCols.colN,rsCols.tip,rsCols.lon,rsCols.dec,rsCols.obl)#">
			</cfif>
			<cfif listFind(LvarPKs,rsCols.colN)>
				<cfif LvarWHR_INI>
					<cfset LvarWHR = 	" WHERE ">
						<cfset LvarWHR_INI = false>
					<cfelse>
						<cfset LvarWHR &= 	LvarCRLF>
					<cfset LvarWHR &= 	"   AND ">
				</cfif>
				<cfset LvarWHR &= 	"#rsCols.colN#">
				<cfif LvarSpaces GT 0>
					<cfset LvarWHR &= repeatString(" ", LvarSpaces)>
				</cfif>
				<cfset LvarWHR &= 	" = #fnQueryParam(rsCols.colN,rsCols.tip,rsCols.lon,rsCols.dec,'S')#">
			</cfif>
			<cfset LvarSEL &=	rsCols.colN>
		</cfloop>

		<cfparam name="LvarWHR" default=" WHERE OJO: la tabla no tiene llave primaria">
		<cfset LvarSEL &= 	LvarCRLF>
		<cfset LvarSEL &= 	"  FROM #rsTab.tab#">
		<cfset LvarSEL &= 	LvarCRLF>
		<cfset LvarSEL &= 	LvarWHR>
		
		<cfset LvarINS = 	LvarINS1>
		<cfset LvarINS &= 	LvarCRLF>
		<cfset LvarINS &= 	")">
		<cfset LvarINS &= 	LvarCRLF>
		<cfset LvarINS &= 	LvarINS2>
		<cfset LvarINS &= 	LvarCRLF>
		<cfset LvarINS &= 	")">

		<cfset LvarUPD &= 	LvarCRLF>
		<cfset LvarUPD &= 	LvarWHR>

		<cfset LvarDEL = 	"    DELETE FROM #rsTab.tab#">
		<cfset LvarDEL &= 	LvarCRLF>
		<cfset LvarDEL &= 	LvarWHR>

<BR>
<cfoutput>
		<textarea cols="150" rows="#fnCount("#LvarSEL#")+1#" style="font-family:'Courier New', Courier, monospace'">
#"<cfquery name=""rsSQL"" datasource=""##session.dsn##"">"#
#LvarSEL#
#"</cfquery>"#
		</textarea>
<BR>
<cfif LvarIdentity>
		<textarea cols="150" rows="#fnCount("#LvarINS#")+3#" style="font-family:'Courier New', Courier, monospace'">
#"<cfquery name=""rsInsert"" datasource=""##session.dsn##"">"#
#LvarINS#
#"    <cf_dbidentity1 name=""rsInsert"" datasource=""##session.dsn##"">"#
#"</cfquery>"#
#"<cf_dbidentity2 name=""rsInsert"" datasource=""##session.dsn##"" returnvariable=""LvarIdentity"">"#
		</textarea>
<cfelse>
		<textarea cols="150" rows="#fnCount("#LvarINS#")+1#" style="font-family:'Courier New', Courier, monospace'">
#"<cfquery datasource=""##session.dsn##"">"#
#LvarINS#
#"</cfquery>"#
		</textarea>
</cfif>
<BR>
		<textarea cols="150" rows="#fnCount("#LvarUPD#")+1#" style="font-family:'Courier New', Courier, monospace'">
#"<cfquery datasource=""##session.dsn##"">"#
#LvarUPD#
#"</cfquery>"#
		</textarea>
<BR>
		<textarea cols="150" rows="#fnCount("#LvarDEL#")+1#" style="font-family:'Courier New', Courier, monospace'">
#"<cfquery datasource=""##session.dsn##"">"#
#LvarDEL#
#"</cfquery>"#
		</textarea>
</cfoutput>
<BR>
	<cf_web_portlet_end>
<cf_templatefooter>

<cffunction name="fnQueryParam" output="no" returntype="string">
	<cfargument name="col">
	<cfargument name="tip">
	<cfargument name="lon" type="numeric">
	<cfargument name="dec" type="numeric">
	<cfargument name="obl" type="string">

	<cfif Arguments.col eq "Ecodigo">
		<cfreturn "##session.Ecodigo##">
	<cfelseif Arguments.col eq "BMUsucodigo">
		<cfreturn "##session.Usucodigo##">
	<cfelseif listFind("B,VB,BL",arguments.tip)>
		<cfif LvarSpaces GT 0>
			<cfreturn '<cfqueryparam       cfsqltype="cf_sql_blob"              value="##form.#Arguments.col###"#repeatString(" ", LvarSpaces)# null="##trim(form.#Arguments.col#) EQ ""##">'>
		<cfelse>
			<cfreturn '<cfqueryparam       cfsqltype="cf_sql_blob"              value="##form.#Arguments.col###" null="##trim(form.#Arguments.col#) EQ ""##">'>
		</cfif>
	</cfif>
	<cfset arguments.tip = trim(arguments.tip)>
	<cfset LvarParam = "<cf_jdbcQuery_param cfsqltype=">
	<!--- TiposPD = C,V,	B,VB,	CL,BL,	I,N,F,M,L,	D,TS --->
	<cfif listFind("C,V",arguments.tip)>
		<cfset LvarParam &= '"cf_sql_varchar" len="#arguments.lon#" '>
		<cfif  len("#arguments.lon#") LT 3>
			<cfset LvarParam &= repeatString(" ",3-len("#arguments.lon#"))>
		</cfif>
	<cfelseif arguments.tip EQ "CL">
		<cfset LvarParam &= '"cf_sql_clob"              '>
	<cfelseif arguments.tip EQ "I">
		<cfset LvarParam &= '"cf_sql_integer"           '>
	<cfelseif arguments.tip EQ "N">
		<cfset LvarParam &= '"cf_sql_numeric" scale="#arguments.dec#" '>
	<cfelseif arguments.tip EQ "F">
		<cfset LvarParam &= '"cf_sql_float"             '>
	<cfelseif arguments.tip EQ "M">
		<cfset LvarParam &= '"cf_sql_money"             '>
	<cfelseif arguments.tip EQ "L">
		<cfset LvarParam &= '"cf_sql_bit"               '>

	<cfelseif arguments.tip EQ "D">
		<cfset LvarParam &= '"cf_sql_timestamp"         '>
	</cfif>

	<cfset LvarParam &= 'value="##rsSQL_Form.#Arguments.col###"'>
	<cfif Arguments.obl EQ '0'>
		<cfif LvarSpaces GT 0>
			<cfset LvarParam &= repeatString(" ", LvarSpaces)>
		</cfif>
		<cfset LvarParam &= ' voidNull>'>
	<cfelse>
		<cfset LvarParam &= '>'>
	</cfif>
	
	<cfreturn LvarParam>
</cffunction>
<cffunction name="fnCount" output="no" returntype="string">
	<cfargument name="txt">
	
	<cfset LvarLen = len(Arguments.txt)-len(replace(Arguments.txt,chr(13),"","ALL"))+3>
	<cfif LvarLen GT 40>
		<cfreturn 40>
	<cfelse>
		<cfreturn LvarLen>
	</cfif>
</cffunction>
