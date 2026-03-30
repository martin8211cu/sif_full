<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Title" Default="Descargar XML" returnvariable="LB_Title"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Nombre" Default="Nombre" returnvariable="LB_Nombre"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Fecha" Default="Fecha" returnvariable="LB_Fecha"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Descargar" Default="Descargar" returnvariable="LB_Descargar"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Reimprimir" Default="Reimprimir" returnvariable="LB_Reimprimir"/>

<!--- TODO EN ESTE ARCHIVO, POR MAS ANIMALADA QUE PAREZCA, TIENE UNA RAZON DE SER (NO LO BORRES)--->
<cfoutput>
    <!--- Validacion y creacion de carpetar para almacenar Facturas --->
    <cf_foldersFacturacion name = "ruta">
    <cfif IsDefined("url.btnReimprimir")>
    	<cfset varXMLNombre = url.filename>    
    	<cffile action="read" variable="xml32" file="#ruta#/#url.filename#" charset="utf-8">
    	<cfset varXMLTimbrado = xml32>
    
    	<cfset arrNombreXML = ListToArray(url.filename,".",false,true)>
    	<cfset ImgPath = "#ruta#/imgQR/#Left(arrNombreXML[1],Len(arrNombreXML[1])-1)#.jpg">
    	<cffile action = "readBinary" file = "#ImgPath#" variable = "contenidoQR">
    
    	<cfinvoke component="rh.Componentes.GeneraCFDIs.XMLtoPDF" method="generaPDF">
    		<cfinvokeargument name="XMLTimbrado" value="#varXMLTimbrado#">
    		<cfinvokeargument name="NombreXML" value="#url.filename#">
    		<cfinvokeargument name="OrigenProceso" value="RECIBOPAGO">
    		<cfinvokeargument name="ImagenQR" value="#contenidoQR#">
    	</cfinvoke>
    	<cfset url.filename = Replace(url.filename,'T.xml','.pdf')>
    </cfif>
<cf_templateheader title="#LB_Title#">
    <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Title#'>
        <form name="form1" action="DescargarXML.cfm">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td colspan="2">
                        <cfinclude template="/home/menu/pNavegacion.cfm">
                    </td>
                </tr>
                <!--- Campos para filtrar--->
                <tr>
                    <td>&nbsp;</td>
                    <td>#LB_Nombre#:</td>
                    <td>
                        <input type="text" name="FN" <cfif isDefined('url.FN')>value="#url.FN#"</cfif>>
                    </td>
                    <td>#LB_Fecha#:</td>
                    <td>
                        <input type="date" name="FF" <cfif isDefined('url.FF')>value="#url.FF#"</cfif>>
                    </td>
                    <td>
                        <input type="button" name="filtro" value="Filtrar" onclick="Filtrar();">
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <!--- Se declaran los filtros para la lista --->
                    <cfset nameFilter = ''>
                    <cfset datefilter = ''>
                    <cfif isDefined('url.FN') OR isDefined('url.FF')>
                        <cfset nameFilter = "#url.FN#">
                        <cfset datefilter = "#url.FF#">
                    </cfif>
                    <td>&nbsp;</td>
                    <td width="60%" align="center" colspan="5">
                        <!--- Se consula el directorio con los archivos pdf y xml--->
                        <cfdirectory
                            action="list"
                            directory="#ruta#/"
                            recurse="false"
                            name="XMLFiles"
                            filter="*#nameFilter#*.pdf|*#nameFilter#*.xml"
                            sort="datelastmodified desc"
                        >
                        <!--- Se agrega una columna con boton de descarga--->
                        <cfset downloadArray = []>
                        <!--- Se filtran los archivos que no entren en la fecha escogida, y se topa a 1500--->
                        <cfquery name="XMLFiles" dbtype="query" maxRows="1500">
                            select XMLFiles.Name,XMLFiles.Directory,
                            CAST(CAST( XMLFiles.datelastmodified as date) as varchar) as DateLastModified
                            from XMLFiles
                            <cfif datefilter neq ''>
                                where CAST(CAST( XMLFiles.datelastmodified as date) as varchar) = '#datefilter#'
                            </cfif>
                        </cfquery>
                        <cfloop query="#XMLFiles#">
                            <cfset htmlobj = '<input type="button" name="descarga" file_value="#XMLFiles.NAME#" value="Descargar" onclick="Descargar(this);">'>
                            <cfset ArrayAppend(downloadArray,htmlobj)>
                        </cfloop>
                        <cfset QueryAddColumn(XMLFiles, 'Download' , 'VarChar', downloadArray)>

                         <cfset reimprimirArray = []>
                         <cfloop query="#XMLFiles#">
							<cfset htmlobj2 = "&nbsp;">
							<cfif Left(Name,2) eq 'RE'>
								<cfif right(Name,3) neq 'pdf'>
									<cfset htmlobj2 = '<input type="submit" name="btnReimprimir" id="btnReimprimir" file_value="#XMLFiles.NAME#" value="#LB_Reimprimir#" onclick="javascript: return Reimprimir(this);">'>
								</cfif>
							</cfif>
							<cfset ArrayAppend(reimprimirArray,htmlobj2)>
                        </cfloop>
						<cfset QueryAddColumn(XMLFiles, 'Reimprimir' , 'VarChar', reimprimirArray)>

                        <!--- Se filtran los archivos que no entren en la fecha escogida--->
                        <cfif datefilter neq ''>
                            <cfquery name="fileList" dbtype="query">
                                select XMLFiles.Name
                                    ,XMLFiles.Directory
                                    ,CAST(CAST( XMLFiles.datelastmodified as date) as varchar) as DateLastModified
                                    ,XMLFiles.Download,XMLFiles.Reimprimir 
                                from XMLFiles 
                                where CAST(CAST( XMLFiles.datelastmodified as date) as varchar) = '#datefilter#'
                            </cfquery>
                            <cfset XMLFiles = fileList>
                        </cfif>

                        <!--- Filtran los archivos que no pertenezcan a la empresa--->
                        <cfquery name="fileTitles" datasource="#session.DSN#">
                            select
                                case 
								when serie like 'RE%' or serie like 'CO%' then
                                    RTRIM(CONCAT(Serie,Folio,'_',DocPago))
                                else
                                    CONCAT(ecodigo,'_',Serie,Folio) end as fileTitle
                                from FA_CFDI_Emitido 
                                where ecodigo = #session.ecodigo# and stsTimbre=1
                                order by fechaTimbrado desc;
                        </cfquery>
                        <cftry>
                            <cfset fileTitles = ValueArray(fileTitles, 'fileTitle')>
                            <cfcatch>
                                <cfset fileTitles = MyValueArray(fileTitles, 'fileTitle')>
                            </cfcatch>
                        </cftry>

                        <cfset fileArray = []>
                        <cfset filesAdded = []>
                        <cfloop query="#XMLFiles#">
                            <cfloop array="#fileTitles#" index="i">
                                <cfif Find(i,XMLFiles.Name,0) gt 0>
                                    <cfif ArrayFind(filesAdded,XMLFiles.Name) eq 0>
										<cfset dadd = DateFormat(XMLFiles.DateLastModified,"dd/MM/yyyy HH:mm") & ':00'>
										<cfset dadd1 = LSDateFormat(dadd,"YYYY-MM-dd HH:mm:ss")>
                                        <cfset ArrayAppend(filesAdded,XMLFiles.Name)>
                                        <cfset ArrayAppend(fileArray,[XMLFiles.Name,XMLFiles.Directory,XMLFiles.DateLastModified,XMLFiles.Download,XMLFiles.Reimprimir,dadd1])>
                                    </cfif>
                                </cfif>
                            </cfloop>
                        </cfloop>
                        <cfset fileList =  QueryNew("Name,Directory,DateLastModified,Download,Reimprimir,dadd","varchar,varchar,varchar,varchar,varchar,varchar",fileArray)>
                        <cfset XMLFilesL = fileList>

						<cfquery name="fileListL" dbtype="query">
							select
								XMLFilesL.Name,
								XMLFilesL.Directory,
								XMLFilesL.datelastmodified,
								XMLFilesL.Download,
								XMLFilesL.Reimprimir,
								XMLFilesL.dadd
							from XMLFilesL
							order by dadd desc
						</cfquery>
						<cfset XMLFiles = fileListL>

                        <!--- Se renderiza la lista con los archivos de la empresa--->
                        <input type="hidden" value="" name="filename">
                        <cfinvoke component="commons.Componentes.pListas" method="pListaQuery"
                            query="#XMLFiles#"
                            columnas="Name,Directory,DateLastModified,Download,Reimprimir"
                            desplegar="Name,DateLastModified,Download,Reimprimir"
                            etiquetas="#LB_Nombre#,#LB_Fecha#,#LB_Descargar#,#LB_Reimprimir#"
                            formatos="S,S,S,S"
                            align="left,left,left,left"
                            checkboxes="N"
                            showLink="NO"
                            ira="DescargarXML.cfm"
                            keys="Name">
                        </cfinvoke>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">&nbsp;</td>
                </tr>
            </table>
        </form>
    <cf_web_portlet_end>
<cf_templatefooter>

<script>
    function Descargar(btn){
        document.getElementsByName('filename')[0].value = btn.attributes.file_value.value;
        document.form1.submit();
    }
    function Filtrar(){
        document.getElementsByName('filename')[0].value = '';
        document.form1.submit();
    }

    function Reimprimir(btn)
    {
    	document.getElementsByName('filename')[0].value = btn.attributes.file_value.value;
        document.form1.action= 'DescargarXML.cfm?btnReimprimir=1'();
        return true;
    }
</script>

<!--- Funcion para descargar el archivo seleccionado--->
<cfif isdefined('url.filename')>
    <cfif url.filename neq ''>
        <cfset fileName = url.filename>
        <cfheader name="Content-Disposition" value="attachment; filename=#fileName#">
        <cfcontent type="text/plain" file="#ruta#/#fileName#" deletefile="no" reset="yes">
    </cfif>
</cfif>

<cffunction name="MyValueArray" access="private" returntype="array">
    <cfargument name="v_query" type="query"  required="yes">
    <cfargument name="v_col" type="string"  required="yes">
    <cfset arrayCol = []>
    <cfloop query="#arguments.v_query#">
        <cfset titlePart = "#arguments.v_query[v_col]#">
        <cfset arrayAppend(arrayCol, titlePart)>
    </cfloop>
    <cfreturn arrayCol>
</cffunction>

</cfoutput>