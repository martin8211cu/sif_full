<cfcomponent>
    <cffunction  name="checkDir"> <!--- FUNCION PARA CREAR DIRECTORIOS SI NO EXISTEN --->
        <cfargument  name="path" required="true">
        <cfif !DirectoryExists("#arguments.path#") >
            <cfset DirectoryCreate("#arguments.path#")>
        </cfif>
    </cffunction>

    <cffunction  name="getPath"> <!--- FUNCION PARA OBTENER LA RUTA ABSOLUTA DEL SERVIDOR --->
        <cfset vsPath_R = "#ExpandPath( GetContextRoot() )#">
        <cfif REFind('(cfmx)$',vsPath_R) gt 0>
            <cfset vsPath_R = "#Replace(vsPath_R,'cfmx','')#">
        <cfelse>
            <cfset vsPath_R = "#vsPath_R#\">
        </cfif>
        <cfreturn vsPath_R>
    </cffunction>

    <cffunction  name="imprimir"> <!--- FUNCION PARA CREAR EL PDF (MERGE DE CADA PAGINA)--->
        <cfargument  name="placas"              type="query"   required="yes">
        <cfargument  name="saveAs"              type="string"   required="no"   default="">
        <cfargument  name="dsn"                 type="string"   required="no"   default="#session.dsn#">
        <cfargument  name="ecodigo"             type="string"   required="no"   default="#session.ecodigo#">

        <!--- REVISION DE RUTAS PARA ARCHIVOS --->
        <cfset vsPath_R = getPath()>
        <cfset codCorte ="#DateFormat(now(),'yyyymmdd')#_#RandString(8)#">
        <cfset CheckDir("#vsPath_R#sif\af\placas")>
        <cfset CheckDir("#vsPath_R#sif\af\placas\#codCorte#")>
        <cfset CheckDir("#vsPath_R#sif\af\placas\#codCorte#\paginasRE")>
        <cfset finalPath = "#vsPath_R#sif\af\placas\#codCorte#">
        <cfset fileName = "#codCorte#_#RandString(8)#">

        <cftry>

            <!--- CREAR PAGINAS PARA RECIBOS DE PAGO --->
            <cfset RP_Paginas = RP_Data(
                      path      ="#finalPath#\paginasRE"
                    , placas  ="#arguments.placas#"
                    , dsn       ="#arguments.dsn#"
                    , ecodigo   =arguments.ecodigo)>

            <cfif ArrayLen(RP_Paginas) gt 0>
                <!--- COMBINAR TODAS LAS PAGINAS EN UN SOLO PDF --->
                <cfpdf action="merge" destination="#finalPath#\#fileName#.pdf" overwrite="yes">
                    <cfloop index="i" from="1" to="#ArrayLen(RP_Paginas)#">
                        <cfpdfparam source="#finalPath#\paginasRE\p#i#.pdf">
                    </cfloop>
                </cfpdf>
            </cfif>

        <cfcatch type="any">
            <cfrethrow>
        </cfcatch>
        </cftry>
        <cfreturn "#finalPath#\#fileName#.pdf">
    </cffunction>

    <cffunction  name="RP_Data"> <!--- FUNCION PARA CREAR LAS PAGINAS DE CADA RECIBO DE PAGO POR CUENTA --->
        <cfargument  name="path"                type="string"   required="yes">
        <cfargument  name="placas"              type="query"   required="yes">
        <cfargument  name="dsn"                 type="string"   required="no"   default="#session.dsn#">
        <cfargument  name="ecodigo"             type="string"   required="no"   default="#session.ecodigo#">

        <!---  VARIABLES DE PAGINACION --->
        <cfset e_paginas = []>
        <cfset e_pagina = []>
        <cfset _placa = structNew()>



        <cfif placas.recordCount gt 0>
            <cfobject type="java" class="generacsd.TestQRCode" name="QRCode">
            <!--- PAGINACION DE RESULTADOS DEL QUERY --->
            <cfset _contador = 0>

            <cfloop query="#placas#">
                <cfset _contador += 1>
                <cfset _placa.fecha           = "#DateFormat(placas.Fecha,'dd-mm-yyyy')#">
                <cfset _placa.placa           = "#placas.placa#">
                <cfset _placa.serie           = "#placas.serie#">
                <cfset _placa.descripcion   = "#placas.descripcion#">

                <cfset fileName = '#placas.placa#.jpg' />
                <cfset fullPath = '#arguments.path#\#filename#' />
                <cfset _image = QRCode.generateQR(fullPath,"#placas.placa#$#placas.descripcion#",500,500)>

                <cfset _placa.imgQR   = "/cfmx/sif/af/placas/#CodCorte#/paginasRE/#fileName#">

                <cfset arrayAppend(e_pagina, _placa)>
                <cfif arrayLen(e_pagina) eq 21>
                    <cfset arrayAppend(e_paginas, e_pagina)>
                    <cfset e_pagina = []>
                <cfelseif _contador eq placas.recordCount>
                    <cfset arrayAppend(e_paginas, e_pagina)>
                </cfif>
                <cfset _placa = structNew()>
            </cfloop>

            <cfloop index="i" from="#arrayLen(e_pagina)#" to="21">
                <cfset _placa.fecha           = "">
                <cfset _placa.placa           = "">
                <cfset _placa.descripcion   = "">
                <cfset _placa.imgQR   = "">
                <cfset arrayAppend(e_pagina, _placa)>
                <cfif arrayLen(e_pagina) gt 21 and arrayLen(e_pagina) % 21 eq 1>
                    <cfset arrayAppend(e_paginas, e_pagina)>
                    <cfset e_pagina = []>
                </cfif>
                <cfset _placa = structNew()>
            </cfloop>

            <!---
            <!--- ELIMINACION DE DIRECTORIO/ARCHIVOS VIEJOS DEL CORTE PROCESADO --->
            <cfif DirectoryExists("#arguments.path#") >
                <cfdirectory action="delete" directory="#arguments.path#" recurse="true">
            </cfif>
            <cfset DirectoryCreate("#arguments.path#")>
            --->

            <!--- CREACION DE PAGINAS DE RECIBOS DE PAGO --->
            <cfset font = "font-family: Arial, Helvetica, sans-serif;">
            <cfset size = "font-size: 9px;">
            <cfset letter = "#font# #size#">
            <cfset border = "border: 0px solid;">
            <cfset noBorder = "cellpadding='0' cellspacing='0'">
            <cfset lineHeight = "line-height: 16px;">
            <cfset _count = 1>

            <cfset ArrayDeleteAt(e_paginas,arrayLen(e_paginas))>
            <cfloop array="#e_paginas#" index="i">

                <cfset a_placas = i>
                <cfoutput>
                    <cfdocument
                        format = "PDF"
                        marginBottom = "0"
                        marginLeft = "0"
                        marginRight = "0"
                        marginTop = "0"
                        pageType = "letter"
                        pageHeight = "11"
                        unit= "cm"
                        filename = "#arguments.path#\p#_count#.pdf"
                        overwrite = "yes"
                    >
                <cfset _count += 1>
                    <html>
                        <head>
                            <style>
                                .table-placa {
                                    border-collapse: collapse;
                                    border: 1px solid black;
                                }
                                td {
                                    padding: 2px;
                                    font-size: 7px;
                                }

                                .externo {
                                  border: 1px solid blue;
                                }
                                .interno {
                                  border: 1px dashed goldenrod;
                                  margin: auto;
                                }

                            </style>
                        </head>
                        <body style="#letter#">
                            <table width="100%" height:"100%"; border="0">
                                <cfset _c = 0>
                                <cfloop array="#a_placas#" index="p">
                                    <cfif p.descripcion NEQ ''>
                                    <cfif _c eq 0 >
                                        
                                        <tr>
                                    </cfif>
                                        <td style="height: 14.28%">
                                           <!---  <div style="height:7px; width:100%;"></div> --->
                                            <div style="height:2.8cm; width:100%;">
                                                <div style="width: 6.35cm; height: 2.50cm;">
                                                <table class="table-placa" style="height:100%; width:100%;" border="0">
                                                    <tr>
                                                        <td> 
                                                            <img src="#p.imgQR#" border="0" width="95px" height="95px"/>
                                                        </td>
                                                        <td valign="top" align="center">
                                                            <div style="height:2.5cm; width:100%;">
                                                            <table border="0">
                                                                <tr>
                                                                    <td align="center" valign="top">
                                                                        <img src="/cfmx/home/public/logo_empresa.cfm?EcodigoSDC=#Session.EcodigoSDC#"
                                                                        class="iconoEmpresa" alt="logo" width="80px" height="auto" border="0">
                                                                        <img src="/cfmx/sif/af/conciliacionAF/INEELogo.png" width="60px" height="50px">
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td align="center">
                                                                        <p><strong>#p.placa#</strong></p>
                                                                        <p><strong>#Left(p.descripcion,100)#</strong></p>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                                </div>
                                            </div>
                                        </td>
                                        
                                        <cfset _c += 1>
                                    <cfif _c eq 3>
                                        </tr>
                                        <cfset _c = 0>
                                    </cfif>
                                    </cfif>
                                </cfloop>
                            </table>
                        </body>
                    </html>

                    </cfdocument>
                </cfoutput>
            </cfloop>
        </cfif>
        
        <cfreturn e_paginas>

    </cffunction>


    <cffunction name="RandString" output="no" returntype="string">
        <cfargument name="length" type="numeric" required="yes">
        <!--- Local vars --->
        <cfset var result="">
        <cfset var i=0>
        <!--- Create string --->
         <cfloop index="i" from="1" to="#ARGUMENTS.length#">
             <!--- Random character in range A-Z --->
             <cfset result=result&Chr(RandRange(65, 90))>
         </cfloop>

         <!--- Return it --->
         <cfreturn result>
    </cffunction>
</cfcomponent>