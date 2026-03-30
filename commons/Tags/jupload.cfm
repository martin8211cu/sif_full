
<cfif isDefined("url.downloadFile")>
  <cfquery datasource="#session.dsn#" name="rs">
    select #url.nombre# as Nombre, #url.campo# as myFile
    from #url.tabla#
    where #url.pk# = #url.pkllave#
  </cfquery>

  <cfheader name="content-disposition" value='attachment; filename="#rs.Nombre#"'>
  <cfcontent variable="#rs.myFile#">
  <cfabort>
</cfif>

<!--- borrar archivos --->
<cfif isDefined("url.deleteFile")>
  <cfquery datasource="#session.dsn#" name="rs">
    delete
    from #url.tabla#
    where #url.pk# = #url.pkllave#
  </cfquery>
  <cfabort>
</cfif>

<!--- refresca el pintado de archivos --->
<cfif isDefined("form.updateFilePool")>
  <cfset form.addDataColumns = DeserializeJSON(form.addDataColumns)>
  <cfquery datasource="#session.dsn#" name="rs">
    select #form.nombre# as nombre, #form.pk# as id
    <cfif arraylen(form.addDataColumns)>
      <cfloop from="1" to="#arraylen(form.addDataColumns)#" index="i">
        , <cfoutput>#form.addDataColumns[i].name#</cfoutput>
      </cfloop>
    </cfif>
    from #form.tabla#
    where #form.fk# = #form.fkvalor#
    <cfif len(trim(form.filter))>
      and <cfoutput>#evaluate("form.filter")#</cfoutput>
    </cfif>
    <cfif form.selfTable >
      and Jtabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tablaRef#">
      and Jindex = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.index#">
    </cfif>
  </cfquery>

  <div id="filePool">
    <cfloop query="rs">
          <div class="ajax-file-upload-statusbar">
              <div class="ajax-file-upload-filename">
                <div class="row">
                  <div class="col-sm-8" style="word-wrap:break-word;"><cfoutput>#nombre#</cfoutput></div>
                  <div class="col-sm-1">
                      <i style="margin-right:2%;cursor: pointer;" class="fa fa-download fa-lg" onclick="Descargar<cfoutput>#form.index#</cfoutput>('<cfoutput>#id#</cfoutput>');"></i>
                  </div>
                  <div class="col-sm-1">
                      <cfif not form.readonly>
                        <cfif len(trim(form.hideDeleted)) eq 0 or (len(trim(form.hideDeleted)) and not evaluate("#form.hideDeleted#"))>
                          <i style="margin-right:2%;cursor: pointer;" onclick="Borrar<cfoutput>#form.index#</cfoutput>(this,'<cfoutput>#id#</cfoutput>');" class="fa fa-trash-o fa-lg"></i>
                        </cfif>
                      </cfif>
                  </div>
                  <div class="col-sm-1">
                      <cfif isDefined("form.ShowDetail") and form.ShowDetail>
                        <i style="margin-right:2%;cursor:pointer;" class="fa fa-eye fa-lg" onclick="fnShowDetail<cfoutput>#form.index#</cfoutput>('<cfoutput>#id#</cfoutput>');"></i>
                      </cfif>
                    </div>
                </div>
              </div>
          </div>
    </cfloop>
  </div>
  <cfabort>
</cfif>

<!--- codigo para guardar el archivio subido --->
<cfif isDefined("url.JQexe")>

  <cfset form.tabla = url.tabla>
  <cfset form.campo = url.campo>
  <cfset form.nombre = url.nombre>
  <cfset form.fk = url.fk>
  <cfset form.fkvalor = url.fkvalor>
  <cfset form.addDataColumns = DeserializeJSON(form.addDataColumns)>
  <cfset LvarObject = getClientFileName("myfileJupload")>
  <cfset form.nombreFile = LvarObject.getFileName() >
  <cfset fileTemp = form.MYFILEJUPLOAD>


  <cfif isdefined("form.myfileJupload") and form.myfileJupload NEQ "">
      <cfquery datasource="#session.dsn#" name="rsValida">
        select 1
        from #form.tabla#
        where #form.fk# = #form.fkvalor#
          <cfif (!isDefined("form.onerecord") or form.onerecord NEQ 1)>
          and ltrim(rtrim(#form.nombre#)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.nombreFile)#">
          </cfif>
          <cfif isDefined("url.tablaRef") and len(trim(url.tablaRef)) and isDefined("form.onerecord") and form.onerecord EQ 1>
          and Jindex = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.index#">
          </cfif>
      </cfquery>
      <cfif rsValida.recordcount eq 0>
        <cfif isdefined("fileTemp")>
           <cfinclude template="/rh/Utiles/imagen.cfm">
           <cfif isdefined("ts")>

				<cfset arrFile = ListToArray(form.NOMBREFILE,'.')>
				<cfset extFile = UCase(Trim(arrFile[2]))>

              	<cfquery name="ABC_empleadosImagen" datasource="#Session.DSN#">
	                insert into #form.tabla#
	                (
	                	#form.fk#,#form.nombre#,#form.campo# <cfif isDefined("url.tablaRef") and len(trim(url.tablaRef))>,Jtabla, Jindex</cfif>
		                <cfif arraylen(form.addDataColumns)>
							<cfloop from="1" to="#arraylen(form.addDataColumns)#" index="i">
							  , <cfoutput>#form.addDataColumns[i].name#</cfoutput>
							</cfloop>
		                </cfif>,tipo,DEid,UsuCreador
					)
                	values
					(
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fkvalor#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#mid(form.nombreFile,1,100)#">,
						<cfqueryparam cfsqltype="cf_sql_blob" value="#tmp#">
						<cfif isDefined("url.tablaRef") and len(trim(url.tablaRef))>
						,<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.tablaRef#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.index#">
						</cfif>
						<cfif arraylen(form.addDataColumns)>
							<cfloop from="1" to="#arraylen(form.addDataColumns)#" index="i">
							  ,<cfif len(trim(form.addDataColumns[i].value))>
							    <cfqueryparam cfsqltype="cf_sql_#form.addDataColumns[i].type#" value="#form.addDataColumns[i].value#">
							  <cfelse>
							    null
							  </cfif>
							</cfloop>
						</cfif>
						,'#extFile#'
						,-1
						,<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                	)
				</cfquery>
			</cfif>
		</cfif>
	<cfelse>
        <cfif isdefined("fileTemp")>
           <cfinclude template="/rh/Utiles/imagen.cfm">
           <cfif isdefined("ts")>
              <cfquery datasource="#Session.DSN#" name="ABC_empleadosImagen">
                update #form.tabla#
                set #form.campo# = <cfqueryparam cfsqltype="cf_sql_blob" value="#tmp#">
                <cfif isDefined("form.onerecord") and form.onerecord EQ 1 and isDefined("url.tablaRef") and len(trim(url.tablaRef))>
                ,#form.nombre# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombreFile#">
                </cfif>
                where #form.fk# = #form.fkvalor#
                  <cfif isDefined("form.onerecord") and form.onerecord EQ 1 and isDefined("url.tablaRef") and len(trim(url.tablaRef))>
                    and Jtabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.tablaRef#">
                    and Jindex = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.index#">
                  <cfelse>
                    and rtrim(#form.nombre#) = '#trim(form.nombreFile)#'
                  </cfif>
              </cfquery>
            </cfif>
        </cfif>
      </cfif>
  </cfif>

  <cfabort>
</cfif>


<cfif ThisTag.ExecutionMode is 'start'>
  <cfparam name="Attributes.index"         type="string" default="">
  <cfparam name="Attributes.tabla"         type="string" default="">
  <cfparam name="Attributes.campo"         type="string" default="">
  <cfparam name="Attributes.nombre"        type="string" default=""><!--- guarda nombre del archivo en el caso que se requiera--->
  <cfparam name="Attributes.pk"            type="string" default="">
  <cfparam name="Attributes.fk"            type="string" default="">
  <cfparam name="Attributes.fkvalor"       type="string">
  <cfparam name="Attributes.addDataColumns"type="array"   default="#arrayNew(1)#">
  <cfparam name="Attributes.hideDeleted"   type="string"  default="">
  <cfparam name="Attributes.ShowDetail"    type="boolean" default="false">
  <cfparam name="Attributes.OnSuccessDelete"type="boolean" default="false">
  <cfparam name="Attributes.filter"        type="string"  default="">
  <cfparam name="Attributes.onSuccess"     type="string"  default="">
  <cfparam name="Attributes.onError"       type="string"  default="">
  <cfparam name="Attributes.readonly"      type="boolean" default="false">
  <cfparam name="Attributes.selfTable"     type="boolean" default="false">
  <cfparam name="Attributes.multiple"      type="boolean" default="true">
  <cfparam name="Attributes.allowedTypes"  type="string"  default=""> <!--- List of comma separated file extensions --->
  <cfparam name="Attributes.conexion"   type="string"  default="#session.dsn#"> <!--- List of comma separated file extensions --->

  <cfif attributes.selfTable >
    <cfset local.tablaRef = attributes.tabla>
    <cfset Attributes.tabla = 'jUploadFiles'>
    <cfset attributes.nombre = 'Jname'>
    <cfset attributes.pk = 'Jid'>
    <cfset attributes.fk = 'JFk'>
    <cfset attributes.campo = 'Jfile'>
  <cfelse>
    <cfif len(trim(Attributes.tabla)) LTE 0 >
      <cfthrow message="Campo: tabla es requerido pero no fue enviado">
    </cfif>
    <cfif len(trim(Attributes.campo)) LTE 0 >
      <cfthrow message="Campo: campo es requerido pero no fue enviado">
    </cfif>
    <cfif len(trim(Attributes.nombre)) LTE 0 >
      <cfthrow message="Campo: nombre es requerido pero no fue enviado">
    </cfif>
    <cfif len(trim(Attributes.pk)) LTE 0 >
      <cfthrow message="Campo: pk es requerido pero no fue enviado">
    </cfif>
    <cfif len(trim(Attributes.fk)) LTE 0 >
      <cfthrow message="Campo: fk es requerido pero no fue enviado">
    </cfif>
  </cfif>

  <cfif not isDefined("request.FileLoadJQueryInUse")>
    <link href="/cfmx/jquery/estilos/uploadfile.css" rel="stylesheet">
    <script>window.jQuery || document.write('<script src="/cfmx/jquery/librerias/jquery-2.0.2.min.js"><\/script>')</script>
    <script src="/cfmx/jquery/librerias/jquery.uploadfile.min.js"></script>

    <iframe id="FRAMECJNEGRA" name="FRAMECJNEGRA" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" src="" ></iframe>
  </cfif>

  <cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_subir" xmlFile="/rh/generales.xml" default="Subir" returnvariable="LB_Subir">

  <div class="row">
    <div class="col-sm-12">
      <cfif not attributes.readonly>
        <div id="JUmulitplefileuploader<cfoutput>#attributes.index#</cfoutput>"><i style="float:right;margin-right:2%;cursor: pointer;" class="fa fa-upload fa-lg">&nbsp;<cfoutput>#LB_Subir#</cfoutput></i></div>
        <div id="JUploadStatus<cfoutput>#attributes.index#</cfoutput>"></div>
      </cfif>

      <cfquery datasource="#Attributes.conexion#" name="rs" >
        select #Attributes.nombre# as nombre, #Attributes.pk# as id
        <cfif arraylen(Attributes.addDataColumns)>
          <cfloop from="1" to="#arraylen(Attributes.addDataColumns)#" index="i">
            , <cfoutput>#Attributes.addDataColumns[i].name#</cfoutput>
          </cfloop>
        </cfif>
        from #Attributes.tabla#
        where #Attributes.fk# = #Attributes.fkvalor#
        <cfif len(trim(Attributes.filter))>
          and <cfoutput>#evaluate("Attributes.filter")#</cfoutput>
        </cfif>
        <cfif attributes.selfTable >
          and Jtabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="#local.tablaRef#">
          and Jindex = <cfqueryparam cfsqltype="cf_sql_numeric" value="#attributes.index#">
        </cfif>
      </cfquery>

      <div id="filePool<cfoutput>#attributes.index#</cfoutput>">
        <cfif not rs.recordcount>
          <cfinvoke component="sif.Componentes.Translate" xmlFile="/rh/generales.xml" method="Translate" key="LB_NoExistenArchivosQueMostrar" Default="No existen archivos que mostrar" returnvariable="LB_NoExistenArchivosQueMostrar"/>
          <cfoutput>#LB_NoExistenArchivosQueMostrar#</cfoutput>
        </cfif>

        <cfloop query="rs">
            <div class="ajax-file-upload-statusbar">
                <div class="ajax-file-upload-filename">
                  <div class="row">
                    <div class="col-sm-7" style="word-wrap:break-word;"><cfoutput>#nombre#</cfoutput></div>
                    <div class="col-sm-1">
                        <i style="margin-right:2%;cursor:pointer;" class="fa fa-download fa-lg" onclick="Descargar<cfoutput>#attributes.index#</cfoutput>('<cfoutput>#id#</cfoutput>');"></i>
                    </div>
                    <div class="col-sm-1">
                        <cfif not attributes.readonly>
                          <cfif len(trim(attributes.hideDeleted)) eq 0 or (len(trim(attributes.hideDeleted)) and not evaluate("rs.#attributes.hideDeleted#"))>
                            <i style="margin-right:2%;cursor: pointer;" onclick="Borrar<cfoutput>#attributes.index#</cfoutput>(this,'<cfoutput>#id#</cfoutput>');" class="fa fa-trash-o fa-lg"></i>
                          </cfif>
                        </cfif>
                    </div>
                    <div class="col-sm-1">
                      <cfif isDefined("attributes.ShowDetail") and attributes.ShowDetail>
                        <i style="margin-right:2%;cursor:pointer;" class="fa fa-eye fa-lg" onclick="fnShowDetail<cfoutput>#attributes.index#</cfoutput>('<cfoutput>#id#</cfoutput>');"></i>
                      </cfif>
                    </div>
                  </div>
                </div>
            </div>
        </cfloop>
      </div>
    </div><!---- fin del col-12-lg--->
  </div>

  <script type="text/javascript">
    function Descargar<cfoutput>#attributes.index#</cfoutput>(llave){
      var frame = document.getElementById("FRAMECJNEGRA");
      <cfoutput>
        frame.src = "/cfmx/commons/Tags/jupload.cfm?downloadFile=1&pkllave="+llave+"&pk=#attributes.pk#&tabla=#attributes.tabla#&nombre=#attributes.nombre#&campo=#attributes.campo#";
        RefrescarFilePool#attributes.index#();
      </cfoutput>
    }

    <cfif not attributes.readonly>
      <cfinvoke component="sif.Componentes.Translate" xmlFile="/rh/generales.xml" method="Translate" key="LB_EstaSeguroQueDeseaEliminarElArchivo" Default="Está seguro que desea eliminar este archivo" returnvariable="LB_EstaSeguroQueDeseaEliminarElArchivo"/>

      function Borrar<cfoutput>#attributes.index#</cfoutput>(e,llave){
        if(confirm("<cfoutput>#LB_EstaSeguroQueDeseaEliminarElArchivo#</cfoutput>?") ){
          <cfoutput>
            $.ajax({
                  url: "/cfmx/commons/Tags/jupload.cfm?deleteFile=1&pkllave="+llave+"&pk=#attributes.pk#&tabla=#attributes.tabla#",
                  success:function(data) {
                    <cfif isDefined("attributes.OnSuccessDelete") and attributes.OnSuccessDelete>
                      fnOnSuccessDelete#attributes.index#();
                    </cfif>
                    RefrescarFilePool#attributes.index#();
                  }
            });
          </cfoutput>
        }
      }
    </cfif>

     function RefrescarFilePool<cfoutput>#attributes.index#</cfoutput>(){
      <cfoutput>
        $.ajax({
              url: "/cfmx/commons/Tags/jupload.cfm",
              type: "post",
              dataType: "html",
              data: { updateFilePool:1, index:'#attributes.index#', readonly:#attributes.readonly#, pk:'#attributes.pk#', nombre:'#attributes.nombre#', tabla:'#attributes.tabla#', fk:'#attributes.fk#', fkvalor:#attributes.fkvalor#, addDataColumns:'#SerializeJSON(attributes.addDataColumns)#', hideDeleted:'#attributes.hideDeleted#', ShowDetail:#attributes.ShowDetail#, filter:"#attributes.filter#", selfTable:#attributes.selfTable#<cfif attributes.selfTable>,tablaRef: '#local.tablaRef#'</cfif>},
              success:function(data) {
                $('##filePool#attributes.index#').html(data);
              }
        });
      </cfoutput>
    }

    <cfif not attributes.readonly>
      $(document).ready(function(){
        <cfoutput>
          var settings = {
            url: "/cfmx/commons/Tags/jupload.cfm?JQexe=1&tabla=#attributes.tabla#&campo=#attributes.campo#&fk=#attributes.fk#&fkvalor=#attributes.fkvalor#&nombre=#attributes.nombre#<cfif attributes.selfTable>&tablaRef=#local.tablaRef#&index=#attributes.index#</cfif>" ,
            method: "POST",
            <cfif isDefined("attributes.allowedTypes") and len(trim(attributes.allowedTypes))>
            allowedTypes:"#attributes.allowedTypes#",
            </cfif>
            fileName: "myfileJupload",
            multiple: <cfif attributes.multiple>true<cfelse>false</cfif>,
            showDelete: false,
            dynamicFormData: function(){
              var data = { addDataColumns:'#SerializeJSON(attributes.addDataColumns)#', hideDeleted:'#Attributes.hideDeleted#',ShowDetail:'#Attributes.ShowDetail#', filter:"#Attributes.filter#"<cfif !attributes.multiple>,onerecord:1</cfif> }
              return data;
            },
            showDone: true,
            showStatusAfterSuccess: false,
            onSuccess:function(files,data,xhr){
              <cfif not len(trim(attributes.onSuccess))>
               RefrescarFilePool#attributes.index#();
              <cfelse>
                #attributes.onSuccess#
              </cfif>
            },
            onError: function(data,status,errMsg){
              <cfif not len(trim(attributes.onError))>
                $("##JUploadStatus").html("<font color='red'>Upload is Failed</font>");
              <cfelse>
                #attributes.onError#
              </cfif>
            }
          }
          $("##JUmulitplefileuploader#attributes.index#").uploadFile(settings);
        </cfoutput>
      });
    </cfif>
  </script>
</cfif>

<!--- funcion que devuevle el nombre del archivo que se encuentra en el temporal --->
<cfif not isDefined("request.FileLoadJQueryInUse")>
  <cffunction name="getClientFileName" returntype="any" output="false" hint="">
    <cfargument name="fieldName" required="true" type="string" hint="Name of the Form field" />
    <cfset var tmpPartsArray = Form.getPartsArray() />

    <cfif IsDefined("tmpPartsArray")>
      <cfloop array="#tmpPartsArray#" index="local.tmpPart">
        <cfif local.tmpPart.isFile() AND local.tmpPart.getName() EQ arguments.fieldName>
          <cfreturn local.tmpPart />
        </cfif>
      </cfloop>
    </cfif>

    <cfreturn "" />
  </cffunction>

  <cfset request.FileLoadJQueryInUse = true>
</cfif>
