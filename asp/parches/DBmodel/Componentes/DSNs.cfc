<cfcomponent output="no">
	<!---
		select distinct Ccache from asp..Caches c
			inner join asp..Empresa e on e.Cid=c.Cid and Eactiva=1
			inner join asp..CuentaEmpresarial ce on ce.CEcodigo = e.CEcodigo and CEactiva=1 and coalesce(CEaliaslogin,'')<>''
		Y LUEGO SE VERIFICA: Si isdefined('application.dsinfo.#rsSQL.Ccache#') AND application.dsinfo[rsSQL.Ccache].SCHEMA NEQ "" la base de datos esta OK
			Si NOT isdefined('application.dsinfo.#rsSQL.Ccache#') 
				El datasource no está definido en el Administrador del Coldfusion
			Si application.dsinfo[rsSQL.Ccache].SCHEMA EQ ""
				#application.dsinfo[rsSQL.Ccache].SCHEMAERROR#
	--->
	<cffunction name="init" access="public" output="no">
		<cfquery name="rsSQL" datasource="asp">
			select count(1) as cantidad from DBMdsn
		</cfquery>
		<cfif rsSQL.cantidad GT 0>
			<cfreturn>
		</cfif>
		
		<cfquery name="rsSQL" datasource="asp">
			select count(1) as cantidad from DBMsch
		</cfquery>
		<cfif rsSQL.cantidad EQ 0>
			<cfquery datasource="asp">
				insert into DBMsch (IDsch,sch) values (1,'SISTEMAS')
			</cfquery>
			<cfquery datasource="asp">
				insert into DBMsch (IDsch,sch) values (2,'asp')
			</cfquery>
			<cfquery datasource="asp">
				insert into DBMsch (IDsch,sch) values (3,'aspMonitor')
			</cfquery>
			<cfquery datasource="asp">
				insert into DBMsch (IDsch,sch) values (4,'sifControl')
			</cfquery>
			<cfquery datasource="asp">
				insert into DBMsch (IDsch,sch) values (5,'sifInterfaces')
			</cfquery>
			<cfquery datasource="asp">
				insert into DBMsch (IDsch,sch) values (6,'sifPublica')
			</cfquery>
			<cfquery datasource="asp">
				insert into DBMsch (IDsch,sch) values (7,'aspSecure')
			</cfquery>
			<cfquery datasource="asp">
				insert into DBMmodelos (IDmod,modelo,IDsch,uidSVN) values (1,'SIF Sistemas.pdm',1,'pso')
			</cfquery>
			<cfquery datasource="asp">
				insert into DBMmodelos (IDmod,modelo,IDsch,uidSVN) values (5,'ASP Framework.pdm',2,'pso')
			</cfquery>
			<cfquery datasource="asp">
				insert into DBMmodelos (IDmod,modelo,IDsch,uidSVN) values (6,'ASP Monitor.pdm',3,'pso')
			</cfquery>
			<cfquery datasource="asp">
				insert into DBMmodelos (IDmod,modelo,IDsch,uidSVN) values (7,'SIF Control.pdm',4,'pso')
			</cfquery>
		</cfif>

		<cfquery name="rsSQL" datasource="asp">
			select distinct lower(c.Ccache) as dsn
			  from Empresa e 
				inner join Caches c on c.Cid=e.Cid
			 where e.Eactiva=1
			   and rtrim(lower(c.Ccache)) not in ('asp','aspmonitor','aspsecure','sifpublica','sifinterfaces','sifcontrol')
		</cfquery>
		<cfloop query="rsSQL">
			<cfif isdefined("application.dsinfo.#dsn#")>
				<cfquery datasource="asp">
					insert into DBMdsn (IDmod, dsn, activo)
					values (1,<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSQL.dsn#">,1)
				</cfquery>
			</cfif>
		</cfloop>
		<cfquery datasource="asp">
			insert into DBMdsn (IDmod, dsn, activo)
			select IDmod, lower(sch), 0
			  from DBMmodelos m
				inner join DBMsch s
				 on s.IDsch = m.IDsch
			 where m.IDsch <> 1
			   and (
					select count(1)
					  from DBMdsn
					 where IDmod = m.IDmod
					) = 0
		</cfquery>
		<cfquery datasource="asp">
			update DBMdsn 
			   set activo = 1
			where dsn in ('asp','aspmonitor','aspsecure','sifpublica','sifinterfaces','sifcontrol')
		</cfquery>
		<cfloop list="aspsecure,sifpublica,sifinterfaces" index="LvarDSN">
			<cfif isdefined("application.dsinfo.#LvarDSN#")>
				<cfquery datasource="asp">
					update DBMdsn 
					   set activo = 1
					where dsn = '#LvarDSN#'
				</cfquery>
			</cfif>
		</cfloop>
	</cffunction>
</cfcomponent>
