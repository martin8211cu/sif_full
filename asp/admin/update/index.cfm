<cf_templateheader title="Version del Sistema">

<cf_web_portlet_start titulo="Version del Sistema">
<cfinclude template="/home/menu/pNavegacion.cfm">
<cfinclude template="/asp/admin/dbmigrate/flash.cfm" >


<cfhtmlhead text='<link href="/cfmx/jquery/estilos/jquery.modallink/jquery.modalLink-1.0.0.css" rel="stylesheet" type="text/css" />'>
<cfhtmlhead text='<script type="text/javascript" language="JavaScript" src="/cfmx/jquery/librerias/jquery.modallink/jquery.modalLink-1.0.0.js">//</script>'>

<cfset notifier = createObject("component", "home.Componentes.Notifier")>
<cfif isdefined("form.Aplicar")>
    <cfsetting requesttimeout=1800>
    <cfset rootPath = GetDirectoryFromPath(ExpandPath('/')) />
    
    <cfif len(trim(form.updateFile))>
        <!--- Se lee el zip --->
        <cftry>
            <cfzip file="#form.updateFile#" action="list" name="entryFiles">

            <cfquery name="versioninfo" dbtype="query">
                select count(name) as existeinfo
                from entryFiles
                where name = 'info.xml'
            </cfquery> 

            <cfif versioninfo.recordcount eq 0>
                <cfthrow message="No se encontro informaci&oacute;n de la actualizaci&oacute;n">						
            </cfif>

            <!--- BACKING UP FILES TO UPDATE --->
            <cfloop query = "entryFiles"> 
                <cfset _file = "#rootPath##entryFiles.name#">
                <cfif FileExists(_file)>
                    <cffile action = "rename" source = "#_file#" destination = "#_file#.bakup" attributes="normal">
                </cfif>
            </cfloop> 
                
            <!--- UNZIP FILE ON ROOT DIRECTORY --->
            <cfzip action="unzip" destination="#rootPath#" file="#form.updateFile#" overwrite="yes" />

            <cfset xml2struct = createObject("component", "commons.Componentes.xmlToStruct")>
            <cffile action="read" file="#rootPath#info.xml" variable="_xmlversion">
            <cfset _version = xml2struct.ConvertXmlToStruct(ToString(_xmlversion), structnew())>

            <!--- VERIFICANDO VERSION --->
            <cfif structKeyExists(_version, "version") and structKeyExists(_version, "changelog")>
                <cfquery name="reversion" datasource="asp">
                    select isnull(max(version),0) version, #_version.version# toupdate from versioninfo
                </cfquery>
                <cfif reversion.version gte _version.version>
                    <cfthrow message="La versi&oacute;n que intenta importar [#_version.version#] ya existe o es inferior a la actual [#reversion.version#]">
                </cfif>
            <cfelse>
                <cfthrow message="No se pudo obtener informaci&oacute;n de la actualizaci&oacute;n">
            </cfif>
            
            <!--- Ejecutando Proceso Adicional --->
            <cfif structKeyExists(_version, "ejecutar") and _version.ejecutar>
                <cftry>
                    <cfset update = createObject("component", "asp.admin.update.execute")>
                    <cfset ejecutado = update.run()>
                    <cfif not ejecutado>
                        <cfthrow message="No se pudo ejecutar el proceso adicional de actualizaci&oacute;n">
                    </cfif>
                <cfcatch type="any">
                    <cfrethrow>
                </cfcatch>
                </cftry>
            </cfif>
            
            <!--- UPLOAD FILE TO ROOT/files/update --->
            <cffile action="upload" fileField = "updateFile" destination="#rootPath#/asp/admin/update/versiones/" nameconflict="makeunique" />

            <!--- REMOVING BACK UP--->
            <cfloop query = "entryFiles"> 
                <cfset _filebak = "#rootPath##entryFiles.name#.bakup">
                <cfif FileExists(_filebak)>
                    <cffile action = "delete" file = "#_filebak#">
                </cfif>
            </cfloop>

            <!--- ACTUALIZANDO VERSION INFO --->
            <cfquery datasource="asp">
                insert into versioninfo (version, changelog, createdat,updatedat)
                values (#_version.version#,'#_version.changelog#', getdate(), getdate())
            </cfquery>
            
            <cfset notifier.insertFlashMeesage(
                message="Sistema actualizado correctamente. Version #_version.version#",
                type="success",
                closeOnClick="true"
            )>				
            <cflocation  url="/cfmx/asp/admin/update/index.cfm">
        <cfcatch type="any">
            <!--- ROLLING BACK UPDATE --->
            <cfif isdefined("entryFiles")>
                <cfloop query = "entryFiles"> 
                    <cfset _file = "#rootPath##entryFiles.name#">
                    <cfset _filebak = "#rootPath##entryFiles.name#.bakup">

                    <cfif FileExists(_file) and FileExists(_filebak)>
                        <cffile action = "delete" file = "#_file#">
                        <cffile action = "rename" source = "#_file#.bakup" destination = "#_file#" attributes="normal">
                    <cfelseif FileExists(_filebak) and not FileExists(_file)>
                        <cffile action = "rename" source = "#_file#.bakup" destination = "#_file#" attributes="normal">
                    </cfif>
                </cfloop> 
            </cfif>
            <cfset notifier.insertFlashMeesage(
                message="Error al importar el archivo : #cfcatch.message#",
                type="error",
                closeOnClick="true"
            )>
            <cflocation  url="/cfmx/asp/admin/update/index.cfm">
        </cfcatch>
        </cftry>


    <cfelse>
        <cfthrow message="No se encontro archivo de actualizacion">
    </cfif>
</cfif>

<!--- <cfinclude template="flash.cfm" > --->
<!--- otener informacion --->
<cfquery name="rsChagelog" datasource="asp">
    select * from versioninfo order by updatedat desc
</cfquery>

<cfquery name="rsCurrentVersion" dbtype="query">
    select max(version) as currentVersion from rsChagelog
</cfquery>

<cfquery name="rsSchemaInfo" datasource="asp">
    select max(isnull(version,0)) as currentVersion from schemainfo
</cfquery>

<cfoutput>
    <div class="col-md-4">
        <div class="hpanel">
            <div class="panel-heading hbuilt">
                <div class="panel-tools">
                    <a class="showhide"><i class="fa fa-database text-info"></i></a>
                        Base de Datos
                </div>
            </div>
            <div class="panel-body">
                <h5>Versi&oacute;n</h5>
                <p>
                    Versi&oacute;n actual: <strong>#rsSchemaInfo.currentVersion#</strong>
                    &nbsp;
                    <a href="/cfmx/asp/admin/dbmigrate/index.cfm">
                        Migraciones pendientes <i class="fa fa-tags"></i>
                    </a>
                </p>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="hpanel">
            <div class="panel-heading hbuilt">
                <div class="panel-tools">
                    <a class="showhide"><i class="fa fa-cube text-info"></i></a>
                    Sistema
                </div>
            </div>
            <div class="panel-body">
                <h5>Versi&oacute;n</h5>
                <p>
                    Versi&oacute;n actual: <strong>7.2.#(rsCurrentVersion.currentVersion neq '') ? rsCurrentVersion.currentVersion : 0#</strong>
                    &nbsp;
                </p>
            </div>
        </div>
    </div>
    <div class="col-lg-4">
        <div class="hpanel">
            <div class="panel-heading hbuilt">Importar Actualizaci&oacute;n</div>
            <div class="panel-body">
                <cfoutput>
                    <div class="form-group">
                            <div class="col-sm-12">	 
                                <form name="frmActualizar" id="frmActualizar" action="" method="post" 
                                    enctype="multipart/form-data" onsubmit="return validaForm()">
                                    <input name="showMessage" type="hidden" value="true">
                                    <table width="100%" border="0" cellpadding="0" cellspacing="2">
                                        <tr><td>&nbsp;</td></tr>
                                        <tr>
                                            <td align="left">
                                                <input type="file" name="updatefile" value="" accept=".zip" size="40"<!---  required="true" --->>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <cf_botones exclude="alta,limpiar" include="Aplicar">
                                            </td>
                                        </tr>
                                    </table>
                                </form>
                            </div>
                        </div>
                </cfoutput>
            </div>
        </div>
    </div>
    <div class="col-md-12">
        <div class="hpanel">
            <div class="panel-heading hbuilt">
                <div class="panel-tools">
                    <a class="showhide"><i class="fa fa-stack-exchange text-info"></i></a> Change Log
                </div>
            </div>
            <div class="panel-body">
                <div class="chat-discussion">
                    <cfloop query="rsChagelog">
                        <div class="chat-message">
                            <div class="message">
                                <span class="message-author"><strong>Versi&oacute;n #version#</strong></span>
                                <span class="message-date">#lsDateFormat(createdat,"dd/mm/yyyy")# #lsTimeFormat(createdat,"hh:mm:ss tt")#</span>
                                <span class="message-content">#changelog#</span>
                            </div>
                        </div>
                    </cfloop>
                </div>
            </div>
        </div>
    </div>
</cfoutput>



<cf_web_portlet_end>
<cf_templatefooter>