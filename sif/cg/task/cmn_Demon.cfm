<!---  
	Genera Archivos programados en la Contabilidad General 
	Los archivos programados son los de la opcion de Consulta de Saldos por Cuenta Contable ( Archivos )
	Estos se encuentran registrados en la tabla tbl_archivoscf
--->

<cfsetting enablecfoutputonly="yes">
<cfsetting requesttimeout="120">
<cfoutput> inicia demonio #Now()#<br></cfoutput>
<cfflush interval="20">

<cfquery name="rs_Caches" datasource="asp">
	select distinct e.Cid, c.Ccache
	from Empresa e
		inner join Caches c
		on c.Cid = e.Cid
	where exists(
		select 1
		from ModulosCuentaE me
		where me.SScodigo = 'SIF'
		  and me.CEcodigo = e.CEcodigo
		)
</cfquery>
<!--- <cfinclude template="cmn_CreaArchivoSalida.cfm"> --->
<cfloop query="rs_Caches">
	<cfset Conexion = rs_Caches.Ccache>
	<cfset session.dsn = Conexion>
	<cfset session.usuario = 1>
	<cfoutput><p>Probando la conexion: #Conexion#</p></cfoutput>

	<cfset Lvarbandera = false>
	<cfset Lvarbandera = ObtieneAchivosAProcesar(Conexion)>

	<cfif LvarBandera and len(trim(conexion)) GT 0>
		<cfquery datasource="#Conexion#" name="sqldemon" maxrows="5">
			select  
				IDArchivo, Usuario 
			from  tbl_archivoscf
			where FechaSolic <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			  and ( Status = 'P' or (  Status in ('W', 'E') and FechaProce < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd("h", -1, now())#"> ))
			order by Status desc, TpoImpresion asc, IDArchivo
		</cfquery>
		<cfoutput><p>Procesando #sqldemon.recordcount# en la conexion #Conexion#</p></cfoutput>
		<cfloop query="sqldemon">
			<cfset Llave = sqldemon.IDArchivo>
			<cfquery datasource="#conexion#"  name="sqlup" >	
				update  tbl_archivoscf set 
					Status = 'W',
					FechaProce = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, FechaEjec = null, FechaFin = null
					where  IDArchivo = #LLAVE#
			</cfquery>	
		</cfloop>
		<cfloop query="sqldemon"> 
			<cfset Llave = sqldemon.IDArchivo>
			<cfset User = sqldemon.Usuario>
			<cfoutput> Envia a Procesar #Llave# #USER# #conexion# a las #Now()#<br></cfoutput>
			<cfhttp url="http://#CGI.HTTP_HOST#/cfmx/sif/cg/task/cmn_CreaArchivo.cfm?LLAVE=#LLAVE#&USER=#User#&dsn=#conexion#" timeout="20"></cfhttp>
		</cfloop>
	</cfif>
</cfloop>
<cfoutput> finaliza demonio #Now()#<br></cfoutput>

<cffunction name="ObtieneAchivosAProcesar" returntype="boolean">
		<cfargument name="Conexion" type="string" required="yes">
		<cfset LvarExistenArchivos = false>
		<cftry>
			<cfquery datasource="#Arguments.Conexion#" name="sqldemon">
				select count(1) as Cantidad
				from  tbl_archivoscf
				where FechaSolic <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				  and ( Status = 'P' or (  Status in ('W', 'E') and FechaProce < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd("h", -1, now())#"> ))
			</cfquery>
		<cfcatch type="any">
			<cfoutput><p>No encontro la conexion #Arguments.Conexion#</p></cfoutput>
			<cfreturn false>
		</cfcatch>
		</cftry>
		<cfif isdefined("sqldemon") and sqldemon.recordcount GT 0 and sqldemon.Cantidad GT 0>
			<cfreturn true>
		<cfelse>
			<cfoutput><p>No se encontraron reporte por procesar</p></cfoutput>
			<cfreturn false>
		</cfif>
</cffunction>
