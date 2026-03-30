<!---<cfparam name="url.prueba" default="hola">

REfindNoCase("@[\W]*Arguments\.[\W]*@","Esto es un mensaje Arguments.hola para siempre")

<cf_error code="1" message="Prueba @url.prueba@ ##Prueba">


create table CodigoError
(
 CERRcod numeric not null primary key,
 CERRmsg varchar(1024) not null,
 CERRdes text null,
 CERRcor text null,
 CERRref numeric null
)
create table CodigoErrorSrc
(
 CERRSid numeric identity not null primary key,
 CERRcod numeric not null,
 CERRSsrc varchar(1024) not null
)

--->
<cffile action="write" file="#expandPath("./listaCF_errorCode.cfm")#" output="">


<cfset LvarDirBat = "#expandPath("./")#dir.bat">
<cfset LvarDirXXX = "#expandPath("./")#dir.XXX">
<cfset LvarDirTxt = "#expandPath("./")#dir.txt">
<cfset LvarCFTHROWs= "#expandPath("./")#cfthrows.txt">
<!---
<cftry>
	<cffile action="delete" file="#LvarDir#">
	<cffile action="delete" file="#LvarDirXXX#">
<cfcatch type="any"></cfcatch></cftry>

<cffile action="write" file="#expandPath("./")#dir.bat" output='dir "#expandPath("/")#sif\*.cfm" /B /s >"#LvarDirXXX#"#chr(13)##chr(10)#dir "#expandPath("/")#sif\*.cfc" /B /s >>"#LvarDirXXX#"#chr(13)##chr(10)#ren "#LvarDirXXX#" "*.txt"'>
<cfexecute name="cmd" arguments='/K"#LvarDirBat#"' />
<cfset LvarF=0>
<cfloop condition="true">
	<cfset LvarF=LvarF+1>
	<cf_wait seconds="1">
	<cfif fileExists(LvarDirTxt) or LvarF GTE 100>
		<cfbreak>
	</cfif>
</cfloop>
--->

<cfscript>
// Initilize Java File IO
FileIOClass=createObject("java","java.io.FileReader");
FileIO=FileIOClass.init(LvarDirTxt);
LineIOClass=createObject("java","java.io.BufferedReader" );
LineIO=LineIOClass.init(FileIO);
</cfscript>

<cfset LvarArchivos = arrayNew(1)>
<cfset LvarF=0>
<cfloop condition="true">
	<cfset LvarF=LvarF+1>
    <!--- Read in next line --->
    <cfset CurrLine=LineIO.readLine()>
    <!--- If CurrLine is not defined, we have reached the end of file --->
    <cfif not IsDefined("CurrLine")>
        <CFBREAK>
    </cfif>

    <cfset LvarArchivos[LvarF] = #CurrLine#>

</cfloop>
<cfset LineIO.close()>
<cfset FileIO.close()>

<cfset LvarInicio = gettickcount()>
<cfquery name="rsSQL" datasource="sifControl">
	select coalesce(max(CERRcod),50000) as cod
	  from CodigoError
</cfquery>

<cfset LvarERR = rsSQL.cod>
<cffile action="write" file="#LvarCFTHROWs#" output="SECUENCIA#chr(9)#ARCHIVO#chr(9)#Message#chr(9)#Detail">
<cfset LvarRootN = len(expandPath("/"))>
<cfset LvarBOM = "#chr(239)##chr(187)##chr(191)#">
<cfset LvarBOM = LvarBOM.getBytes()>
<cfset LvarBUFF = createObject("java","java.lang.System")>
<cfloop from="1" to="#arrayLen(LvarArchivos)#" index="LvarF">
	<cfset LvarGrabar = false>
	<cfset LvarProcesar = listFindNoCase("cfm,cfc",right(LvarArchivos[LvarF],3))>
	<cfset LvarProcesar = LvarProcesar AND (find(expandpath("/sif/rh/"),LvarArchivos[LvarF]) NEQ 1) and fileexists(LvarArchivos[LvarF])>
	<cfif LvarProcesar >
			<cffile action="readbinary" file="#LvarArchivos[LvarF]#" variable="LvarBin">

			<!--- COLOCA EL BOM A LOS ARCHIVOS QUE NO LO TIENEN --->
			<cfif arraylen(LvarBin) GT 4 AND LvarBin[1] NEQ -17>
				<cfset LvarWithBOM = repeatstring(" ",arrayLen(LvarBin)+3).getBytes()>
				<cfset LvarBUFF.ArrayCopy(LvarBOM,0,LvarWithBOM,0,3)>
				<cfset LvarBUFF.ArrayCopy(LvarBin,0,LvarWithBOM,3,arrayLen(LvarBin))>
<!---
				<cffile action="write" file="#LvarArchivos[LvarF]#.XXX" output="#LvarWithBOM#">
--->
			</cfif>
		<cftry>
			<cffile action="read" file="#LvarArchivos[LvarF]#" variable="LvarFuente">
		<cfcatch type="any">
			<cfset LvarProcesar = false>
		</cfcatch></cftry>
	</cfif>
	
	<cfif LvarProcesar>
		<cfset LvarFuente_DST = "">
		<cfset LvarPtoAnt = 1>
		<cfset LvarPtoIni = findNoCase("<cfthrow ",LvarFuente,1)>
		<cfset LvarProcesar = LvarPtoIni NEQ 0>
		<cfloop condition="LvarPtoIni GT 0">
			<cfset LvarSRCname = mid(LvarArchivos[LvarF],LvarRootN,100)>
			<cfset LvarCFerror = fnExtraer(LvarPtoIni)>
			<cfset LvarNew = "">
			<cfif lcase(LvarCFerror.Object) EQ "@cfcatch@" OR lcase(LvarCFerror.Message) EQ "@cfcatch.message@">
				<cfset LvarNew = "<cfrethrow>">
				<!---<cffile action="append" file="#LvarCFTHROWs#" output="N/A#chr(9)##LvarSRCname##chr(9)##LvarNew#">--->
			<cfelseif LvarCFerror.Object NEQ "">
				<cfset LvarNew = LvarCFerror.cfThrow>
				<cffile action="append" file="#LvarCFTHROWs#" output="N/A#chr(9)##LvarSRCname##chr(9)##LvarNew#">
				<cfset LvarNew = "">
			<cfelseif not find(" ",LvarCFerror.Message & LvarCFerror.Detail)>
				<cfset LvarNew = LvarCFerror.cfThrow>
				<cffile action="append" file="#LvarCFTHROWs#" output="PENDIENTE#chr(9)##LvarSRCname##chr(9)##LvarNew#">
				<cfset LvarNew = "">
			<cfelse>
				<cfset LvarNew = '<cf_errorCode'>
				<cfif LvarCFerror.Message EQ "" AND LvarCFerror.Detail NEQ "">
					<cfset LvarCFerror.Message = LvarCFerror.Detail>
					<cfset LvarCFerror.Detail = "">
				</cfif>
				<cfset sbEvaluarCFerror()>
				<cfquery name="rsSQL" datasource="sifControl">
					select coalesce(CERRref,CERRcod) as CERRcod
					  from CodigoError
					 where CERRmsg = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarCFerror.Message#">
				</cfquery>
				<cfif rsSQL.CERRcod NEQ "">
					<cfset LvarCode = rsSQL.CERRcod>

					<cfquery name="rsSQL" datasource="sifControl">
						select count(1) as cantidad 
						  from CodigoErrorSrc
						 where CERRcod	= #LvarCode#
						   and CERRSsrc	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarSRCname#">
					</cfquery>
					<cfif rsSQL.cantidad EQ 0>
						<cfquery datasource="sifControl">
							insert into CodigoErrorSrc
								(CERRcod, CERRSsrc)
							values(
								#LvarCode#,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarSRCname#">
							)
						</cfquery>
					</cfif>
				<cfelse>
					<cfset LvarERR = LvarERR + 1>
					<cfset LvarCode = LvarERR>

					<cfquery datasource="sifControl">
						insert into CodigoError
							(CERRcod, CERRmsg, CERRdes, CERRcor, CERRref)
						values(
							#LvarCode#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarCFerror.Message#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarCFerror.Detail#" null="#LvarCFerror.Detail EQ ""#">,
							null,
							null
						)
					</cfquery>

					<cfquery datasource="sifControl">
						insert into CodigoErrorSrc
							(CERRcod, CERRSsrc)
						values(
							#LvarCode#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarSRCname#">
						)
					</cfquery>
				</cfif>
					
				<cfset LvarNew = LvarNew & chr(9) & 'errorCode="#LvarCode#" errorMSG="#LvarCFerror.Message#"'>
				
				<cfif LvarCFerror.datosN GT 0>
					<!--- Obtiene el margen --->
					<cfloop index="m" from="#LvarPtoIni-1#" to="1" step="-1">
						<cfif mid(LvarFuente,m,1) EQ chr(13) OR mid(LvarFuente,m,1) EQ chr(10)>
							<cfset LvarMargen = chr(13) & chr(10) & mid(LvarFuente,m+1,LvarPtoIni-m-1)>
							<cfbreak>
						<cfelseif m EQ 1>
							<cfset LvarMargen = chr(13) & chr(10) & mid(LvarFuente,m,LvarPtoIni-m)>
							<cfbreak>
						</cfif>
					</cfloop>
					<cfset LvarMargen = REreplace(LvarMargen,"\S"," ","ALL")>
					<!--- Añade los datos adicionales --->
					<cfloop from="1" to="#LvarCFerror.datosN#" index="d">
						<cfset LvarNew = LvarNew & LvarMargen & chr(9) & chr(9) & chr(9) & chr(9) & 'errorDat_#d#="###replace(LvarCFerror.datos[d],"@","##","ALL")###"'>
					</cfloop>
					<cfset LvarNew = LvarNew & LvarMargen>
				</cfif>
								
				<cfset LvarNew = LvarNew & '>'>

				<cfif LvarCode EQ 51308 or findNocase("index2-java1.cfm",LvarArchivos[LvarF])>
					<cfset LvarGrabar = true>
				</cfif>
			</cfif>
<cffile action="append" file="#expandPath("./listaCF_errorCode.cfm")#" output="#LvarNew#">

			<cfif LvarNew NEQ "">
				<cfset LvarFuente_DST = LvarFuente_DST & mid(LvarFuente,LvarPtoAnt,LvarPtoIni-LvarPtoAnt) & LvarNew>
				<cfset LvarPtoAnt = LvarPto+1>
			</cfif>
			
			<cfset LvarPtoIni = findNoCase("<cfthrow ",LvarFuente,LvarPto)>
		</cfloop>

		<cfif LvarProcesar>
			<cfset LvarFuente_DST = LvarFuente_DST & mid(LvarFuente,LvarPtoAnt,len(LvarFuente))>
<!---
				<cffile action="write" file="#LvarArchivos[LvarF].XXX#" output="#LvarFuente_DST#">
--->
			<cfif LvarGrabar>
				<cfset LvarFile = replace(LvarArchivos[LvarF],"\","/","ALL")>
				<cfset LvarFile = listLast(LvarFile,"/")>
				<cffile action="write" file="#expandPath("./#LvarFile#.old")#" output="#LvarFuente#">
				<cffile action="write" file="#expandPath("./#LvarFile#.new")#" output="#LvarFuente_DST#">
			</cfif>
		</cfif>
	</cfif>
</cfloop>
<cfoutput>
duró #(getTickCount()-LvarInicio)/1000# segundos
</cfoutput>
<!---
<cfthrow detail=""  errorcode="" extendedinfo="" message="" object="" type="">
--->
<cffunction name="fnExtraer" output="no" returntype="struct">
	<cfargument name="ini" type="numeric">
	
	<cfset LvarPtoCFthrow = Arguments.ini>
	<cfset LvarPto = Arguments.ini + 9>
	<cfset LvarRES = structNew()>
	<cfset LvarRES.ErrorCode	= "">
	<cfset LvarRES.Message		= "">
	<cfset LvarRES.Detail		= "">
	<cfset LvarRES.ExtendedInfo	= "">
	<cfset LvarRES.Object		= "">
	<cfset LvarRES.Type			= "">
	<cfset LvarAttr = "">
	<cfloop condition="LvarPto LTE len(LvarFuente)">
		<cfset sbBrincarBlancos(LvarAttr NEQ "")>
		<cfif mid(LvarFuente,LvarPto,1) EQ ">" OR mid(LvarFuente,LvarPto,2) EQ "/>">
			<cfbreak>
		<cfelseif LvarAttr EQ "">
			<cfset LvarAttr = fnExtraerAttr ("detail,errorcode,extendedinfo,message,object,type")>
		<cfelseif mid(LvarFuente,LvarPto,1) EQ "'" OR mid(LvarFuente,LvarPto,1) EQ '"'>
			<cfset LvarRES[LvarAttr] = fnExtraerHilera()>
			<cfset LvarPto = LvarPto + 1>
			<cfset LvarAttr = "">
		<cfelse>
			<cfset LvarRES[LvarAttr] = "">
			<cfset LvarAttr = "">
		</cfif>
	</cfloop>
	<cfset LvarRES.cfThrow = mid(LvarFuente,Arguments.Ini,LvarPto-Arguments.Ini+1)>
	<cfreturn LvarRES>
</cffunction>

<cffunction name="fnExtraerAttr" output="no">
	<cfargument name="Attrs" type="string">
	
	<cfset var LvarIni = LvarPto>
	<cfloop list="#Arguments.Attrs#" index="LvarAttr">
		<cfset LvarN = len(LvarAttr)>
		<cfif lcase(mid(LvarFuente,LvarPto,LvarN+1)) EQ LvarAttr & " ">
			<cfset LvarPto = LvarPto + LvarN+1>
			<cfreturn LvarAttr>
		</cfif>
		<cfif lcase(mid(LvarFuente,LvarPto,LvarN+1)) EQ LvarAttr & "=">
			<cfset LvarPto = LvarPto + LvarN+1>
			<cfreturn LvarAttr>
		</cfif>
	</cfloop>
	<cfthrow message="El cfthrow no contiene attr correcto: #mid(LvarFuente,LvarIni,50)#">
</cffunction>

<cffunction name="sbBrincarBlancos" output="no">
	<cfargument name="brincarIgual" type="boolean">
	
	<cfloop condition="LvarPto LTE len(LvarFuente)">
		<cfif mid(LvarFuente,LvarPto,1) EQ ">" OR mid(LvarFuente,LvarPto,2) EQ "/>">
			<cfbreak>
		<cfelseif Arguments.brincarIgual AND mid(LvarFuente,LvarPto,1) EQ "=">
		<cfelseif REfind("\s",mid(LvarFuente,LvarPto,2)) NEQ 1>
			<cfbreak>
		</cfif>
		<cfset LvarPto = LvarPto + 1>
	</cfloop>
</cffunction>

<cffunction name="fnExtraerHilera" output="no" returntype="string">
	<cfset var LvarIni = LvarPto>
	<cfset var LvarChr = mid(LvarFuente,LvarPto,1)>
	<cfset LvarPto = LvarPto + 1>
	<cfloop condition="LvarPto LTE len(LvarFuente)">
		<cfif mid(LvarFuente,LvarPto,1) EQ "##">
			<cfset sbBrincarGatos()>
		<cfelseif mid(LvarFuente,LvarPto,1) EQ LvarChr>
			<cfif mid(LvarFuente,LvarPto,2) EQ LvarChr & LvarChr>
				<cfset LvarPto = LvarPto + 1>
			<cfelse>
				<cfbreak>
			</cfif>
		</cfif>
		<cfset LvarPto = LvarPto + 1>
	</cfloop>
	<cfset LvarLinea = mid(LvarFuente,LvarIni+1,LvarPto-LvarIni-1)>
	<cfset LvarLinea = replaceNoCase(LvarLinea,"&aacute;","á","ALL")>
	<cfset LvarLinea = replaceNoCase(LvarLinea,"&eacute;","é","ALL")>
	<cfset LvarLinea = replaceNoCase(LvarLinea,"&iacute;","í","ALL")>
	<cfset LvarLinea = replaceNoCase(LvarLinea,"&oacute;","ó","ALL")>
	<cfset LvarLinea = replaceNoCase(LvarLinea,"&uacute;","ú","ALL")>
	<cfset LvarLinea = replaceNoCase(LvarLinea,"&nbsp;"," ","ALL")>
	<cfset LvarLinea = replace(LvarLinea,"@","°","ALL")>
	<cfset LvarLinea = replace(LvarLinea,"##","@","ALL")>
	<cfset LvarLinea = replace(LvarLinea,chr(9)," ","ALL")>
	<cfset LvarLinea = replace(LvarLinea,chr(13)&chr(10),"<BR>","ALL")>
	<cfset LvarLinea = replaceNoCase(LvarLinea,"<BR />","<BR>","ALL")>
	<cfset LvarLinea = replaceNoCase(LvarLinea,"<BR><BR>","<BR>","ALL")>
	<cfset LvarLinea = REreplace(LvarLinea,"\s+"," ","ALL")>
	<cfreturn LvarLinea>
</cffunction>

<cffunction name="sbBrincarGatos" output="no">
	<cfset var LvarIni = LvarPto>
	<cfset var LvarChr = "##">
	<cfset LvarPto = LvarPto + 1>
	<cfloop condition="LvarPto LTE len(LvarFuente)">
		<cfif mid(LvarFuente,LvarPto,1) EQ LvarChr>
			<cfbreak>
		</cfif>
		<cfset LvarPto = LvarPto + 1>
	</cfloop>
	<cfreturn>
</cffunction>

<cffunction name="sbEvaluarCFerror" access="private" output="yes" returntype="void">
	<cfset var LvarMSG = "">
	<cfset var LvarPto0 = 0>
	<cfset var LvarPto1 = 0>
	<cfset var LvarPto2 = 0>

	<cfset LvarCFerror.datos = arrayNew(1)>
	<cfset LvarCFerror.datosN = 0>
	<cfloop list="message,detail" index="attr">
		<cfset sbEvaluarString(attr)>
	</cfloop>
</cffunction>

<cffunction name="sbEvaluarString" access="private" output="yes" returntype="void">
	<cfargument name="attr" type="string">

	<cfset LvarString = LvarCFerror[Arguments.attr]>
	<cfif find("@",LvarString)>
		<cfset LvarMSG = "">
		<cfset LvarPto0 = 0>
		<cfset LvarPto1 = 0>
		<cfset LvarPto2 = 0>
		<cfloop condition="true">
			<cfset LvarPto0 = LvarPto2+1>
			<cfset LvarPto1 = find("@",LvarString,LvarPto2+1)>
			<cfset LvarPto2 = find("@",LvarString,LvarPto1+1)>
			<cfset LvarVAR = "">
			<cfif LvarPto1 EQ 0 OR LvarPto2 EQ 0>
				<cfbreak>
			</cfif>
			<cfset LvarMSG = LvarMSG & mid(LvarString,LvarPto0,LvarPto1-LvarPto0)>
			<cfset LvarVAR = mid(LvarString,LvarPto1+1,LvarPto2-LvarPto1-1)>
			<cfset LvarPto3 = find("'",LvarVAR)>
			<cfif ( len(LvarVAR)-len(replace(LvarVAR,"'","","ALL")) ) mod 2 NEQ 0>
		<cfset LvarXXX = 1>
				<cfset LvarPto2 = find("@",LvarString,LvarPto2+1)>
				<cfif LvarPto2 EQ 0>
					<cfbreak>
				</cfif>
				<cfset LvarPto2 = find("@",LvarString,LvarPto2+1)>
				<cfif LvarPto2 EQ 0>
					<cfbreak>
				</cfif>
				<cfset LvarVAR = mid(LvarString,LvarPto1+1,LvarPto2-LvarPto1-1)>
			</cfif>
			<cfif trim(LvarVAR) EQ "">
				<cfset LvarMSG = LvarMSG & "####">
			<cfelse>
				<cfset LvarCFerror.datosN ++>
				<cfset LvarCFerror.datos[LvarCFerror.datosN] = LvarVAR>
				<cfset LvarMSG = LvarMSG & "@errorDat_#LvarCFerror.datosN#@">
			</cfif>
		</cfloop>
		<cfset LvarMSG = LvarMSG & mid(LvarString,LvarPto0,len(LvarString))>
		<cfset LvarMSG = replace(LvarMSG, '""', "'", "ALL")>
		<cfset LvarMSG = replace(LvarMSG, '"', "'", "ALL")>
		<cfset LvarCFerror[Arguments.attr] = LvarMSG>
	</cfif>
</cffunction>
