<!--- Actualizar la informacion sobre caches en la variable Application.dsinfo --->
<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo">
<cfinvokeargument name="refresh" value="yes">
</cfinvoke>

<cfif not isdefined("Form.btnNuevo")>
	<cfif isdefined("Form.Cid") and Len(Trim(Form.Cid)) NEQ 0>
		<cfif isdefined("Form.btnEliminar")>
			<cfquery name="rs" datasource="asp">
				delete CacheRepo where Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#">
			</cfquery>
			<cfquery name="rs" datasource="asp">
				delete from Caches
				where Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#">
			</cfquery>
		<cfelse>
			<cfquery name="rs" datasource="asp">
				update Caches
				set CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CEcodigo#" null="#not isdefined('Form.Cexclusivo')#">,
					Ccache = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ccache#">,
					Cexclusivo = <cfqueryparam cfsqltype="cf_sql_bit" value="#isdefined('Form.Cexclusivo')#">
				where Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#">
			</cfquery>
			<cfquery name="rsRep" datasource="asp">
				select IdCR from CacheRepo where  Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#">
			</cfquery>
			<cfif isdefined("Form.repo") and #Form.repo# neq 0>
				<cfif #rsRep.RecordCount# eq 0>
					<cfquery datasource="asp">
					    insert into CacheRepo (Cid, CidR)
					    Values(
					    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#">,
					    <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.repo#">
					    )
			 	    </cfquery>
			 	<cfelse>
			 	    <cfquery datasource="asp">
				 	    update CacheRepo
				 	    set CidR = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.repo#">
				 	    where IdCR = #rsRep.IdCR#
					</cfquery>
				</cfif>
				<cfif #Form.repo# eq -1>
				    <cfinvoke method="tablaRepo" >
						<cfinvokeargument name="cache" value="#Form.Ccache#">
    			    </cfinvoke>
		            <cfelse>
		            <cfinvoke method="crearVista" >
						<cfinvokeargument name="cid" value="#Form.Cid#">
						<cfinvokeargument name="cache" value="#Form.Ccache#">
    			    </cfinvoke>
				</cfif>
			</cfif>
		</cfif>

	<cfelse>
		<cfquery name="rs" datasource="asp">
			insert into Caches (CEcodigo, Ccache, Cexclusivo)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CEcodigo#" null="#not isdefined('Form.Cexclusivo')#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ccache#">,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#isdefined('Form.Cexclusivo')#">
			)
			SELECT @@IDENTITY AS 'cid'
		</cfquery>
		<cfif #Form.repo# neq 0>
			<cfquery datasource="asp">
				insert into CacheRepo (Cid, CidR)
				Values(
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.cid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.repo#">
				)
			</cfquery>
		</cfif>
		<cfif #Form.repo# eq -1>
			 <cfinvoke method="tablaRepo" >
				<cfinvokeargument name="cache" value="#Form.Ccache#">
    		 </cfinvoke>
	         <cfelse>
	         <cfinvoke method="crearVista" >
			 	<cfinvokeargument name="cid" value="#Form.Cid#">
			 	<cfinvokeargument name="cache" value="#Form.Ccache#">
    		 </cfinvoke>
		</cfif>
	</cfif>
</cfif>
<cffunction name="tablaRepo" returntype="void">
	<cfargument name="cache" type="string" required="true">
	<cflock name="serviceFactory" type="exclusive" timeout="10">
		<cfscript>
			factory = CreateObject("java", "coldfusion.server.ServiceFactory");
			ds_service = factory.datasourceservice;
   		</cfscript>
    </cflock>
	<cfset caches = ds_service.getNames()>
	<cfset data = "ds_service.getDataSources()." & #arguments.cache# & ".DRIVER" >
	<cfif Evaluate(data) eq 'MSSQLServer'>
		<cftry>
			<cfquery datasource="#Form.Ccache#">
				CREATE TABLE [dbo].[CERepositorio](
					[IdRep] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
					[IdContable] [numeric](18, 0) NULL,
					[IdDocumento] [numeric](18, 0) NULL,
					[numDocumento] [varchar](50) NULL,
					[origen] [varchar](20) NULL,
					[linea] [numeric](18, 0) NULL,
					[timbre] [varchar](40) NOT NULL,
					[rfc] [varchar](13) NULL,
					[total] [money] NULL,
					[archivoXML] [image] NULL,
					[archivo] [image] NULL,
					[nombreArchivo] [varchar](50) NULL,
					[extension] [varchar](5) NULL,
					[xmlTimbrado] [varchar](max) NULL,
					TipoComprobante int NULL,
					Serie varchar(40) null,
					Mcodigo numeric null,
					TipoCambio money null,
					[Ecodigo] [int] NULL,
					[ts_rversion] [timestamp] NOT NULL,
					[BMUsucodigo] [numeric](18, 0) NOT NULL,
 				CONSTRAINT [PK_CERepositorio] PRIMARY KEY CLUSTERED
				(
				[IdRep] ASC
				)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
				) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
			</cfquery>
			<cfcatch>
			</cfcatch>
		</cftry>
</cfif>	
</cffunction>

<cffunction name="crearVista" returntype="void">
	<cfargument name="cid" type="numeric" required="true">
	<cfargument name="cache" type="string" required="true">
	<cfquery name="rs" datasource="asp">
		select rep.CDataSource from CacheRepo repo
		inner join CachesRep rep on repo.CidR = rep.CidR
		where repo.Cid = #arguments.cid#
	</cfquery>
	<cflock name="serviceFactory" type="exclusive" timeout="10">
		<cfscript>
			factory = CreateObject("java", "coldfusion.server.ServiceFactory");
			ds_service = factory.datasourceservice;
   		</cfscript>
	</cflock>
	<cfset caches = ds_service.getNames()>
	<cfset data = "ds_service.getDataSources()." & #arguments.cache# & ".DRIVER" >
	<cfset databaseName = "ds_service.getDataSources()." & #rs.CDataSource# & ".urlmap.database" >
	<cfset nameDB = #Evaluate(databaseName)#>
	<cfif Evaluate(data) eq 'MSSQLServer'>
		<cftry>
			<cfquery name="vista" datasource="#Form.Ccache#">
				CREATE view [dbo].[CERepositorio] as
				select *
				from #nameDB#..CERepositorio
			</cfquery>
			<cfcatch type="any">
				<cf_dump var="#cfcatch.Type# #cfcatch.Message# #cfcatch.Detail#" >
			</cfcatch>
		</cftry>
	</cfif>
</cffunction>
<cffunction name="crearDirectorios" returntype="void">
	<cfset req = GetHTTPRequestData().headers>
	<cfset hostname = "">
	<cfif StructKeyExists(req,"X-Forwarded-Host")>
		<cfset hostname = req["X-Forwarded-Host"]>
	</cfif>
	<cfif Len(hostname) EQ 0>
		<cfset hostname = req["Host"]>
	</cfif>
	<cfif ListLen(hostname) GT 1>
		<cfset hostname = Trim(ListGetAt(hostname, 1))>
	</cfif>
	<cfset LvarHostname = hostname>
	<cftry>
		<cfquery name="rsdir" datasource="asp">
			select Ereferencia from Empresa where Cid =
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#">
		</cfquery>
		<cfset local.baseWebPath = ExpandPath( "../../../sif/ce/Empresas/" )>
		<cfloop query="rsdir">
			<cfset dirrectorio = 'http://#LvarHostname#/cfmx/sif/ce/Empresas/'&'Empresa_'&#rsdir.Ereferencia#/>
			<cfset dirrectorio2 = #local.baseWebPath#&'Empresa_'&#rsdir.Ereferencia#/>
	        <cfdirectory directory="#dirrectorio2#" action="create" type="dir">
		</cfloop>
		<cfcatch></cfcatch>
	</cftry>
</cffunction>
<cfparam name="Form.Pagina" default="1">
<cflocation url="caches.cfm?Pagina=#Form.Pagina#">