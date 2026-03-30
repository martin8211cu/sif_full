<cfparam name="Scodigo" type="numeric" default="#session.Scodigo#">

<cfset CONFIG__MINISITIO_ROOT = "/minisitio/" >
<cfset CONFIG__MINISITIO_FILE = "C:/Apache2/htdocs/minisitio/" >
<cfset rutaGeneracion = CONFIG__MINISITIO_FILE & Scodigo & "/">
<cfset httpPrefix = CONFIG__MINISITIO_ROOT & Scodigo & "/">

<cfset name = "Test_" & Round(Rand() * 1000000) & ".html">

<cffile action="write" nameconflict="overwrite" file="#CONFIG__MINISITIO_FILE##name#" output="#name#">
<cfhttp url="#CONFIG__MINISITIO_ROOT##name#" method="get"></cfhttp>
<cfif Trim(cfhttp.FileContent) NEQ Trim(name)>
	<br>
	La Ruta Destino para la generaci&oacute;n de p&aacute;ginas web no es correcta. <br>
	Contacte con el administrador del portal para resolver el problema.<br>
	<br>
	<cffile action="delete" file="#CONFIG__MINISITIO_FILE##name#">
	<cfabort>
<cfelse>
	<cffile action="delete" file="#CONFIG__MINISITIO_FILE##name#">
</cfif>

<cffunction name="GuardarPagina">
	<cfargument name="MSPGcodigo" type="numeric" required="true">
	<cfargument name="MSPcodigo" type="string" required="true">
	<cfargument name="MSCcontenido" type="numeric" required="true">
	<cfargument name="MSPGtitulo" type="string" required="true">
	<cfargument name="MSPGtexto" type="string" required="true">
	
	<cfif MSPGcodigo EQ 0>
		<cfquery name="ident" datasource="sdc">
			insert MSPaginaGenerada (
			Scodigo, MSPcodigo, MSCcontenido,
			MSPGfecha, MSPGtitulo, MSPGtexto)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Scodigo#">,
				<cfif Len(MSPcodigo) GT 0>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#MSPcodigo#">
				<cfelse>null</cfif>,
				<cfif MSCcontenido GT 0>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#MSCcontenido#">
				<cfelse>null</cfif>,
				getdate(),
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#MSPGtitulo#">,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#MSPGtexto#">)
			select @@identity as MSPGcodigo
		</cfquery>
		<cfreturn ident.MSPGcodigo>
	<cfelse>
		<cfquery datasource="sdc">
			update MSPaginaGenerada
			 set MSPcodigo = <cfif Len(MSPcodigo) GT 0>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#MSPcodigo#">
				<cfelse>null</cfif>
			 ,   MSCcontenido = <cfif MSCcontenido GT 0>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#MSCcontenido#">
				<cfelse>null</cfif>
			 ,   MSPGfecha = getdate()
			 ,   MSPGtitulo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#MSPGtitulo#">
			 ,   MSPGtexto = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#MSPGtexto#">
			 where MSPGcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#MSPGcodigo#">
			   and Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Scodigo#">		
		</cfquery>
		<cfreturn MSPGcodigo>
	</cfif>

</cffunction>

<cffunction name="GuardarArchivo">
<cfargument name="baseName" type="string">
<cfargument name="MSPGtexto" type="string">
	<cfif NOT DirectoryExists(rutaGeneracion) >
		<cfdirectory action="create" directory="#rutaGeneracion#">
	</cfif>

	<cftry>
		<cffile action="write"  file="#rutaGeneracion##baseName#" output="#MSPGtexto#">
	<cfcatch type="any">
		No se puede crear archivo: <cfoutput>#rutaGeneracion##baseName#</cfoutput>
		<cfabort>
	</cfcatch>
	</cftry>
</cffunction>


<cffunction name="GenMenu">
<cfargument name="MSPGcodigo" type="numeric">
	
	<cfsavecontent variable="doc">
	<!---cfinclude template="GeneracionMenu-XMenu.cfm" --->
	<cfinclude template="GeneracionMenu-LMenu.cfm">
	</cfsavecontent>
	
	<cfset MSPGcodigo = GuardarPagina(MSPGcodigo, "", 0, "Menu Principal", doc) >
	<cfset GuardarArchivo("m" & Scodigo & ".html", doc) >
	<cfquery datasource="sdc">
		 update Sitio 
		 set MSPGmenu = <cfqueryparam cfsqltype="cf_sql_numeric" value="#MSPGcodigo#">
		 where Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Scodigo#">
	</cfquery>
	<cfreturn MSPGcodigo>
</cffunction>

<cffunction name="Gen1Pagina">
<cfargument name="MSPcodigo" type="string">
	<cfsavecontent variable="doc">
	<cfinclude template="GeneracionPagina.cfm">
	</cfsavecontent>
	<cfset MSPGcodigo = GuardarPagina(0, MSPcodigo, 0, "Pagina...", doc) >
	<cfset GuardarArchivo("p" & MSPGcodigo & ".html", doc) >
	<!---
	Modificacion: Yu Hui
	Descripción: Las tablas de MSContenidoGenerado no se va a utilizar
	<cfif Len(MSPcodigo) GT 0>
		<cfquery datasource="sdc">
			insert MSContenidoGenerado (Scodigo, MSPGcodigo, MSCcontenido)
            select Scodigo, <cfqueryparam cfsqltype="cf_sql_numeric" value="#MSPGcodigo#">, MSCcontenido
            from MSPaginaArea
            where Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Scodigo#">
              and MSPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#MSPcodigo#">
              and MSCcontenido is not null
		</cfquery>
	</cfif>
	--->
	<cfreturn MSPGcodigo>
</cffunction>

    
<cffunction name="GenPaginas">
	<cfquery datasource="sdc" name="home_page">
		select MSPcodigo
        from Sitio
        where Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Scodigo#">
	</cfquery>
	<cfquery datasource="sdc" name="rs1">
		select MSPcodigo
        from MSPagina
        where Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Scodigo#">
	</cfquery>
	<cfloop query="rs1">
		<cfset estaMSPG = Gen1Pagina(rs1.MSPcodigo)>
		<cfif rs1.MSPcodigo EQ home_page.MSPcodigo>
			<cfquery datasource="sdc">
				update Sitio
                set MSPGcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#estaMSPG#">
                where Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Scodigo#">
			</cfquery>
		</cfif>
	</cfloop>
</cffunction>

<cffunction name="GenBarra">
	<cfsavecontent variable="doc">
	<cfinclude template="GeneracionBarra.cfm">
	</cfsavecontent>
	<cfset MSPGcodigo = GuardarPagina(0, "", 0, "Pagina...", doc) >
	<cfset GuardarArchivo("b" & Scodigo & ".html", doc) >
</cffunction>

<cffunction name="GenFrameset">
	<cfsavecontent variable="doc">
	<cfinclude template="GeneracionFrameset.cfm">
	</cfsavecontent>
	<cfset MSPGcodigo = GuardarPagina(0, "", 0, "Pagina...", doc) >
	<cfset GuardarArchivo("f" & Scodigo & ".html", doc) >
</cffunction>

<cffunction name="Gen1Contenido">
<cfargument name="MSCcontenido" type="numeric">
	<cfsavecontent variable="doc">
	<cfinclude template="GeneracionContenido.cfm">
	</cfsavecontent>
	<cfset MSPGcodigo = GuardarPagina(0, "", MSCcontenido, "Pagina...", doc) >
	<cfset GuardarArchivo("c" & MSCcontenido & ".html", doc) >
</cffunction>

<cffunction name="GenContenido">
	<cfquery datasource="sdc" name="rs">
		select a.MSCcontenido
		 from MSContenido a
		where a.Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Scodigo#" >
		<!--- filtro para generar solamente las páginas que se hayan modificado 
		  and a.MSCfmod > all
		  ( select b.MSPGfecha 
		     from MSPaginaGenerada b
		     where b.Scodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Scodigo#" >
		       and b.Scodigo = a.Scodigo
		       and b.MSCcontenido = a.MSCcontenido )--->
	</cfquery>
	<cfloop query="rs">
		<cfset Gen1Contenido(rs.MSCcontenido)>
	</cfloop>
</cffunction>

<cffunction name="GenImports">
	<cfif NOT DirectoryExists(rutaGeneracion & "shared") >
		<cfdirectory action="create" directory="#rutaGeneracion#shared">
	</cfif>
	<cffile action="copy" source="#ExpandPath('shared')#/minisitio.css"
		destination="#rutaGeneracion#/shared/minisitio.css">
	<cffile action="copy" source="#ExpandPath('shared')#/background.gif"
		destination="#rutaGeneracion#/shared/background.gif">
</cffunction>

<cffunction name="GenValidarSitio">
    <!---
     * Valida que:
     * 1 - Todas las opciones de menú tengan submenús o páginas asociadas
     * 2 - Que exista una página de inicio
     * 3 - Que todas las páginas tengan la cantidad de contenidos requeridos
     *     por la plantilla
    --->
	
	<!--- Que todas las opciones de de último nivel tengan link o pagina asociada --->
	<cfquery datasource="sdc" name="nolink">
		select MSMmenu, MSMtexto
		from MSMenu
		where Scodigo = #Scodigo#
		 and MSMhijos = 0
		 and (MSMlink is null or MSMlink = '')
		 and MSPcodigo is null
	</cfquery>
	<cfif nolink.RecordCount GT 0>
		Las siguientes opciones de menú no tienen liga: 
		<cfoutput query="nolink">
			<cfif nolink.CurrentRow GT 1> | </cfif>
			<a href='../catalogos/Menues.cfm?MSMmenu=#MSMmenu#'>#MSMtexto#</a>
		</cfoutput>
		<cfreturn false>
    </cfif>
	
	<cfquery datasource="sdc" name="mainpg">
		select MSPcodigo
		from Sitio
		where Scodigo = #Scodigo#
	</cfquery>
	<cfif mainpg.RecordCount EQ 0>
		No se ha definido la página de inicio.
		<cfreturn false>
    </cfif>
	
	<cfquery datasource="sdc" name="badarea">
		select a.MSPcodigo, a.MSPtitulo
		from MSPagina a, MSPlantilla b
		where a.Scodigo = #Scodigo#
		  and b.MSPplantilla = a.MSPplantilla
		  and b.MSPareas != (select count(1)
			from MSPaginaArea c
			where c.Scodigo = #Scodigo#
			  and c.MSPcodigo = a.MSPcodigo
			  and c.MSCcontenido is not null)
	</cfquery>
	<cfif badarea.RecordCount GT 0>
		Las siguientes páginas no tienen la cantidad apropiada de contenidos:
		<cfoutput query="badarea">
			<cfif badarea.CurrentRow GT 1> | </cfif>
			<a href='../catalogos/Constructor.cfm?MSPcodigo=#MSPcodigo#'>#MSPtitulo#</a>
		</cfoutput>
		El sitio se generará de todos modos, por favor revise.
		<cfreturn false>
    </cfif>
	<cfreturn true>
</cffunction>

<cffunction name="DeleteDirectory">
	<cfif DirectoryExists(rutaGeneracion)>
		<cfdirectory action="list" directory="#rutaGeneracion#" name="listing">
		<cfoutput query="listing">
			<cfif Not DirectoryExists(rutaGeneracion & Name)>
				<cffile action="delete" file="#rutaGeneracion##name#">
			</cfif>
		</cfoutput>
	</cfif>
</cffunction>

<!---
     * ejecutar la opción de generación apropiada
--->
<cfif GenValidarSitio()>
	<cfscript>
		DeleteDirectory();
		gensitio__MSPGcodigo = GenMenu(0);
		GenPaginas();
		GenContenido();
		GenMenu(gensitio__MSPGcodigo);
		GenBarra();
		GenFrameset();
		GenImports();
	</cfscript>	

<div class="subTitulo">Sitio generado exitosamente</div>
<p>&nbsp;</p>
<cfoutput><div style="font-size:medium" align="center">
	Visite la <a href="#httpPrefix#f#Scodigo#.html" target="_blank">
	P&aacute;gina inicial</a> del sitio generado
</div>
</cfoutput>

<cfelse>
<div class="subTitulo">
	Sitio no es v&aacute;lido, por favor corrija
</div>
</cfif>    
<p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p>