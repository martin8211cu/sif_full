<cfsetting requesttimeout="600">

<cffunction name="status">
	<cfargument name="msg">
	
	<cfoutput>
		#TimeFormat(Now(),'HH:mm:ss')# - #Arguments.msg#
		#RepeatString(' ', 512)#
		<br /></cfoutput>
	<cfflush>
</cffunction>

<!---
	Cargar datos requeridos para generar el parche
--->
<cfquery datasource="asp" name="APParcheSQL">
	select p.nombre, p.dbms, p.esquema, p.checksum, p.contenido, p.descripcion, e.datasource
	from APParcheSQL p
		join APEsquema e
			on e.esquema = p.esquema
	where parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.guid#">
	order by secuencia
</cfquery>

<cf_dbfunction name="OP_Concat" returnvariable="CAT" datasource="asp">
<cfquery name="rsDBM" datasource="asp">
	select 	s.IDsch, m.IDmod, 
			v.des as version,
			min(s.sch) as sch, min(m.modelo) as Modelo,
			max(IDver) as IDver, max(v.fec) as fec
	  from DBMversiones v
		inner join DBMmodelos m	on m.IDmod=v.IDmod
		inner join DBMsch s		on s.IDsch=m.IDsch
	where v.parche = '#session.parche.guid#'
	group by s.IDsch, m.IDmod, v.des
</cfquery>
<cfquery datasource="asp" name="APFuente">
	select nombre,revision,autor,fecha,msg,checksum
	from APFuente a
	where parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.guid#">
	order by nombre
</cfquery>
<cfquery name="OpcionesParche" datasource="asp">
	select 	a.tipo,a.SScodigo, a.SMcodigo, a.SMNcodigo, a.detalle, b.SMNtitulo,
			case when b.SMNtipo = 'P' 
				then coalesce(pp.SPdescripcion	, '** Proceso no definido **')
				else coalesce(b.SMNtitulo		, '** Opción de menú no definido **')
			end as Opcion,
			c.SSdescripcion as Sistema,
			d.SMdescripcion as Modulo
			,<cf_dbfunction name="concat" args="ltrim(rtrim(a.SScodigo)),ltrim(rtrim(a.SMcodigo))" datasource="asp">  as agrupador
	from APOpciones a
		inner join SMenues b
			on a.SMNcodigo = b.SMNcodigo
			and a.SMcodigo = b.SMcodigo
			and a.SScodigo = b.SScodigo
		left join SProcesos pp
			on pp.SScodigo = b.SScodigo
			and pp.SMcodigo = b.SMcodigo
			and pp.SPcodigo = b.SPcodigo
		inner join SSistemas c
			on a.SScodigo = c.SScodigo
		inner join SModulos d
			on a.SMcodigo = d.SMcodigo	
	where parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.guid#">
		--and tipo = '1'
	order by  SScodigo, SMcodigo, SMNcodigo
</cfquery>
<cfquery name="OpcionesOtrosParche" datasource="asp">
	select a.SScodigo, a.SMcodigo, a.SMNcodigo, a.detalle, b.SMNtitulo,
		case when b.SMNtipo = 'P' 
			then coalesce(pp.SPdescripcion	, '** Proceso no definido **')
			else coalesce(b.SMNtitulo		, '** Opción de menú no definido **')
		end as Opcion,
		(select  c.SSdescripcion from SSistemas c
		where a.SScodigo = c.SScodigo) as Sistema,
		(select d.SMdescripcion from SModulos d
		where a.SMcodigo = d.SMcodigo
		and a.SScodigo = d.SScodigo) as Modulo
	from APOpciones a		
		left outer join SMenues b
			on a.SMNcodigo = b.SMNcodigo
			and a.SMcodigo = b.SMcodigo
			and a.SScodigo = b.SScodigo
		left join SProcesos pp
			on pp.SScodigo = b.SScodigo
			and pp.SMcodigo = b.SMcodigo
			and pp.SPcodigo = b.SPcodigo
	where parche = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.parche.guid#">
		and tipo = '3'
	order by  SScodigo, SMcodigo, SMNcodigo
</cfquery>

<!---
	preparar el parche con los archivos seleccionados
--->


<!--- crear directorio --->
<cfinvoke component="asp.parches.comp.parche" method="mkdirparche"
	nombre="#session.parche.info.nombre#"
	returnvariable="fullpath"></cfinvoke>
<cfset fullpath = trim(fullpath)>
<cfif right(fullpath,1) NEQ "/" AND right(fullpath,1) NEQ "\">
	<cfset fullpath = "#fullpath#/">
</cfif>
<cfif Not DirectoryExists(fullpath & 'DB2')><cfdirectory action="create" directory="#fullpath#DB2"></cfif>
<cfif Not DirectoryExists(fullpath & 'Oracle')><cfdirectory action="create" directory="#fullpath#Oracle"></cfif>
<cfif Not DirectoryExists(fullpath & 'Sybase')><cfdirectory action="create" directory="#fullpath#Sybase"></cfif>
<cfif Not DirectoryExists(fullpath & 'SqlServer')><cfdirectory action="create" directory="#fullpath#SqlServer"></cfif>
<cfif Not DirectoryExists(fullpath & 'fuentes')><cfdirectory action="create" directory="#fullpath#fuentes"></cfif>
<cfif Not DirectoryExists(fullpath & 'importador')><cfdirectory action="create" directory="#fullpath#importador"></cfif>
<!--- fullpath debe ser de la forma c:/temp/parches/Parche019_032_SIF_RH
	excluyendo el '/' del final --->

<cfinvoke component="asp.parches.comp.svnclient" method="get_info" wc="#session.parche.reposURL#" returnvariable="svninfo" />

<!--- Generar documentación --->
<cftry>
	<cfset archivo = "#fullpath#/#session.parche.info.nombre#.doc">
	<cfsavecontent variable="doc_file"><cfinclude template="doc-word.cfm"></cfsavecontent>
	<cffile action="write" nameconflict="overwrite" file="#archivo#" output="#doc_file#" charset="utf-8">
	
	<!---
		Esta funcionalidad se sustituye con DBMcontrolParches
		
		<cfset archivo = "#fullpath#/Sybase/#session.parche.info.nombre#.sql">
		<cfsavecontent variable="doc_file"><cfinclude template="doc-sql-sybase.cfm"></cfsavecontent>
		<cffile action="write" nameconflict="overwrite" file="#archivo#" output="#doc_file#" charset="utf-8">
		
		<cfset archivo = "#fullpath#/Oracle/#session.parche.info.nombre#.sql">
		<cfsavecontent variable="doc_file"><cfinclude template="doc-sql-oracle.cfm"></cfsavecontent>
		<cffile action="write" nameconflict="overwrite" file="#archivo#" output="#doc_file#" charset="utf-8">
	
		<cfset archivo = "#fullpath#/DB2/#session.parche.info.nombre#.sql">
		<cfsavecontent variable="doc_file"><cfinclude template="doc-sql-db2.cfm"></cfsavecontent>
		<cffile action="write" nameconflict="overwrite" file="#archivo#" output="#doc_file#" charset="utf-8">
		
		<cfset archivo = "#fullpath#/SqlServer/#session.parche.info.nombre#.sql">
		<cfsavecontent variable="doc_file"><cfinclude template="doc-sql-sqlserver.cfm"></cfsavecontent>
		<cffile action="write" nameconflict="overwrite" file="#archivo#" output="#doc_file#" charset="utf-8">
	--->
<cfcatch type="any">
	<cfset str = StructNew()>
	<cfset str.msg = cfcatch.Message & ' ' & cfcatch.Detail>
	<cfset str.archivo = archivo>
	<cfset ArrayAppend(session.parche.errores, str)>
</cfcatch>
</cftry>

<cfoutput><html><body></cfoutput>
<cfset status('Exportando.  Espere mientras el proceso concluye...')>

<!--- Generando XMLs DBM --->
<!--- Exportar versiones de actualización de Database Model  (dbm) --->

<cfif DirectoryExists(fullpath & '/fuentes/asp_dbm')>
	<cfdirectory action="list" directory="#fullpath#/fuentes/asp_dbm" filter="*.xml" name="rsDir">
	<cfloop query="rsDir">
		<cffile action="delete" file="#fullpath#/fuentes/asp_dbm/#rsDir.name#">
	</cfloop>
<cfelse>
	<cfdirectory action="create" directory="#fullpath#/fuentes/asp_dbm">
</cfif>

<cfif rsDBM.recordCount EQ 0>
	<cfset LvarXML = '<?xml version="1.0" encoding="utf-8"?>'>
	<cfset LvarXML &= '<version des="Actualización de Fuentes" fec="#dateFormat(now(),"YYYY-MM-DD")#T#timeFormat(now(),"hh:mm:ss")#" parche="#HTMLEditFormat(session.parche.info.nombre)#" IDmod="0" IDsch="0" />'>
	<cfset LvarArchivo = "#fullpath#/fuentes/asp_dbm/V_#HTMLEditFormat(session.parche.info.nombre)#.xml">
	<cffile action="write" file="#LvarArchivo#" output="#LvarXML#" addnewline="no" charset="utf-8">
	<cfset status("asp_dbm/V_#HTMLEditFormat(session.parche.info.nombre)#.xml")>
<cfelse>
	<cfloop query="rsDBM">
		<cfquery name="rsTabs" datasource="asp">
			select distinct t.*
			  from DBMversiones v
				inner join DBMtabV tv	on tv.IDver=v.IDver
				inner join DBMtab  t	on t.IDtab=tv.IDtab
			where v.parche = '#session.parche.guid#'
			  and v.IDmod	= #rsDBM.IDmod#
			  and v.des		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDBM.version#"> 
		</cfquery>
	
		<cfinvoke 	component="asp.parches.DBmodel.Componentes.DBModel" 
					method		= "toXML"
					rsOBJECTS	= "#rsTabs#"
					archivo		= "#fullpath#/fuentes/asp_dbm/V_#numberFormat(rsDBM.IDver,"0000000000")#.xml"
					fec			= "#rsDBM.fec#"
					version		= "DBM #rsDBM.IDver#: #rsDBM.Version#"
					parche		= "#HTMLEditFormat(session.parche.info.nombre)#"
					IDmod		= "#rsDBM.IDmod#"
					modelo		= "#rsDBM.modelo#"
					IDsch		= "#rsDBM.IDsch#"
					sch			= "#rsDBM.sch#"
		>
		<cfset status("asp_dbm/V_#numberFormat(rsDBM.IDver,"0000000000")#.xml")>
	</cfloop>
</cfif>

<cfquery datasource="asp">
	delete from DBMuploads
	 where (
	 		select count(1)
			  from DBMversiones v
			 where v.IDver = DBMuploads.IDver
			   and v.parche = '#session.parche.guid#'
			) > 0
</cfquery>

<!--- Exportar archivos desde el servidor de fuentes (svn) --->
<cfif FileExists("#fullpath#/#session.parche.info.nombre#.md5")>
	<cffile action="delete" file="#fullpath#/#session.parche.info.nombre#.md5">
</cfif>
<cfif FileExists("#fullpath#/#session.parche.info.nombre#.sha1")>
<cffile action="delete" file="#fullpath#/#session.parche.info.nombre#.sha1">
</cfif>
<cfloop query="APFuente">
	<cftry>
	<cfset status(APFuente.nombre)>
	<cfinvoke component="asp.parches.comp.svnclient"
		method="export"
		reposURL="#session.parche.reposURL#"
		branch="#session.parche.svnBranch#"
		file="#APFuente.nombre#"
		destPath="#fullpath#/fuentes" />

	<cfinvoke component="asp.parches.comp.parche"
		method="add_hash"
		file="#APFuente.nombre#"
		destPath="#fullpath#/fuentes" 
		checksum_name="fuentes/#APFuente.nombre#"
		checksum_md5="#fullpath#/#session.parche.info.nombre#.md5"
		checksum_sha1="#fullpath#/#session.parche.info.nombre#.sha1"
		returnvariable="md5sum"/>
		
	<cfcatch type="any">
	<cfset str = StructNew()>
	<cfset str.msg = cfcatch.Message & ' ' & cfcatch.Detail>
	<cfset str.archivo = APFuente.nombre>
	<cfset ArrayAppend(session.parche.errores, str)>
	</cfcatch></cftry>
</cfloop>

<!--- Generar las exportaciones de las definiciones del importador --->
<cfinvoke component="asp.parches.comp.parche" method="get_entries" collection="importar" returnvariable="col"></cfinvoke>
<cfif StructCount(col)>
	<cfquery datasource="sifcontrol" name="data">
		select EIid
		from EImportador
		where EIcodigo in ( <cfqueryparam cfsqltype="cf_sql_varchar" value="# StructKeyList(col) #" list="yes"> )
	</cfquery>
	<cfset form.eiid = ValueList(data.EIid) >
	<cfset form.included = 1>
	<cfset start_time = GetTickCount()>
	<cfset status('Exportando definición de importador')>
	<cfsavecontent variable="exportar_contents"><cfinclude template="/sif/importar/ExportarWDDX.cfm"></cfsavecontent>
	<cfset status('Terminado definición de importador ('
		& NumberFormat(GetTickCount() - start_time) & 'ms, size=' & NumberFormat(Len(exportar_contents)) &  ' bytes)')>
	<cffile action="write" nameconflict="overwrite" file="#fullpath#/importador/importador.xml" output="#exportar_contents#" charset="utf-8">
</cfif>

<!--- Generar archivos SQL --->
<cfloop query="APParcheSQL">
	<cfinvoke component="asp.parches.comp.misc" method="dbms2dbmsdir" dbms="#dbms#" returnvariable="dbmsdir"/>
	<cffile action="write" nameconflict="overwrite" file="#fullpath#/#dbmsdir#/#nombre#" output="#contenido#">
</cfloop>

<!--- Generar XML final --->
<cfset status('Generando XML')>

<cfoutput>
<cfinvoke component="asp.parches.comp.parche" method="get_xml" returnvariable="parche_xml"/>
<cffile action="write" file="#fullpath#/#session.parche.info.nombre#.xml" output="#parche_xml#">

<!--- Armar el archivo JAR --->

<cfinvoke component="asp.parches.comp.jar" method="jar"
	fullpath="#fullpath#"
	zipfile="#fullpath#/#session.parche.info.nombre#.jar" />

<cfset session.parche.generado = true>

<script type="text/javascript">
location.href="generado.cfm";
</script>
<cfset session.parche.destPath = fullpath>

</body></html>
</cfoutput>


<cfinvoke component="asp.parches.comp.parche" method="guardar"/>
