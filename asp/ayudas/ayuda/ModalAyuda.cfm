

<cfset lvarAyudaDetalleId="0">
<cfif isdefined('url.AyudaDetalleId') and len(url.AyudaDetalleId) GT 0 >
  <cfset form.lvarAyudaDetalleId="#url.AyudaDetalleId#">
</cfif>

<cfset lvarAyudaCabId="0">
<cfif isdefined('url.AyudaCabId') and len(url.AyudaCabId) GT 0 >
    <cfset form.lvarAyudaCabId="#url.AyudaCabId#">
</cfif>

   <script type="text/javascript" src="/cfmx/rh/js/ckeditor/ckeditor.js"></script>

    <cfquery name="rsForm" datasource="asp">
    select AyudaCabId, AyudaDetalleId, AyudaDetalleTitulo, AyudaDetallePos, AyudaDetalleText from AyudaDetalle where 1=1

        <cfif isdefined("form.lvarAyudaCabId") and #Len(Trim("form.lvarAyudaCabId"))# gt 0 >
            and AyudaCabId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.lvarAyudaCabId#">
        </cfif>

        <cfif isdefined("form.lvarAyudaDetalleId") and #Len(Trim("form.lvarAyudaDetalleId"))# gt 0 >
            and AyudaDetalleId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.lvarAyudaDetalleId#">
        </cfif>
    </cfquery>

	<cfquery name="rsInfoCab" datasource="asp">
		SELECT *
		FROM AyudaCabecera
		WHERE AyudaCabId = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.lvarAyudaCabId#">
	</cfquery>

	<cfquery name="rsLanguagesCode" datasource="sifcontrol">
		SELECT DISTINCT (LTRIM(RTRIM(Icodigo))) AS Icodigo
		FROM Idiomas
	</cfquery>

	<!--- Creacion de tabla temporal --->
	<cf_dbtemp name="TabLanguajesTemp" returnvariable="TabLanguajesTemp" datasource="#session.dsn#">
		<cf_dbtempcol name="IdLanguage" type="numeric" identity="true" mandatory="true">
		<cf_dbtempcol name="Codigo" type="varchar(20)">
		<cf_dbtempcol name="Description" type="varchar(250)">
	</cf_dbtemp>
	<cfset LvarTablaTemp = TabLanguajesTemp>

	<cfif rsLanguagesCode.recordCount GT 0>
		<cfoutput query="rsLanguagesCode">
			<cfquery name="rsLanguagesDescrip" datasource="#session.dsn#">
				SELECT MIN(Descripcion) as Descripcion FROM Idiomas WHERE Icodigo = <cf_jdbcquery_param value='#Icodigo#' cfsqltype="cf_sql_varchar">
			</cfquery>
		<cfquery name="rsInsertTempCode" datasource="#session.dsn#">
			INSERT INTO #LvarTablaTemp# (Codigo, Description)
			values (<cf_jdbcquery_param value='#Icodigo#' cfsqltype="cf_sql_varchar">,
			<cf_jdbcquery_param value='#rsLanguagesDescrip.Descripcion#' cfsqltype="cf_sql_varchar">)
		</cfquery>
		</cfoutput>
	</cfif>

	<cfquery name="rsLanguages" datasource="#session.dsn#">
		SELECT *
		FROM #LvarTablaTemp#
		WHERE Codigo =  <cf_jdbcquery_param value='#rsInfoCab.AyudaIdioma#' cfsqltype="cf_sql_varchar">
		ORDER BY Description
	</cfquery>


    <!--- <cfquery name="rsCodigos" datasource="#session.DSN#">
        select upper(FMT001DesCCod) as FMT001DesCCod
        from FMT001DesCorreo
        where (Ecodigo is null or Ecodigo = #session.Ecodigo#)
    </cfquery> --->

    <script language="JavaScript1.2" type="text/javascript">
        var boton = "";
        function setBtn(obj){
        boton = obj.name;
        }
    </script>

    <form name="form"  method="post" action="SQLAyuda.cfm" enctype="multipart/form-data">

        <div class="row">&nbsp;</div>
        <div class="row">&nbsp;</div>

        <input name="AyudaCabId" type="hidden" value="<cfoutput>#form.lvarAyudaCabId#</cfoutput>">

        <table width="100%" border="0" class="areaFiltro"
			<tr>
				<td width="2%"></td>
				<td colspan="2"><b>Idioma cabecera:</b></td>
				<cfoutput><td colspan="4">#rsLanguages.Description#&nbsp;</td></cfoutput>
			</tr>
            <tr>
                <td width="2%"></td>

                <cfif isdefined("form.lvarAyudaDetalleId") and #Len(Trim("form.lvarAyudaDetalleId"))# gt 0 >
                    <td width="1%">
                        <b>Orden:</b>
                    </td>
                    <td width="18%">
                            <input size="10" maxlength="10" name="AyudaDetallePos" value="<cfoutput>#rsForm.AyudaDetallePos#</cfoutput>" alt="C&oacute;digo">
                    </td>
                <cfelse>
                    <td width="1%">
                        <b>Orden:</b>
                    </td>
                    <td width="18%">
                            <input size="10" maxlength="10" name="AyudaDetallePos" value="">
                    </td>
                </cfif>
                <td width="3%">
                    <b>T&iacute;tulo:</b>
                </td>
                <td>
                    <cfif isdefined("form.lvarAyudaDetalleId") and #Len(Trim("form.lvarAyudaDetalleId"))# gt 0 >
                        <input name="AyudaDetalleTitulo" value="<cfoutput>#rsForm.AyudaDetalleTitulo#</cfoutput>" size="35" maxlenght="50" alt="Titulo">
                    <cfelse>
                        <input name="AyudaDetalleTitulo" value="" size="35" maxlenght="50" alt="Titulo">
                    </cfif>


                </td>
                <td width="30%"></td>
                <td>
                    <cfif isdefined("form.lvarAyudaDetalleId") and #Len(Trim("form.lvarAyudaDetalleId"))# gt 0 >
                        <input type="submit" name="btnModificar" class="btnGuardar" value="Guadar" onclick="javascript:h( this );" >
                    <cfelse>
                        <input type="submit" name="btnGuardar" class="btnGuardar" value="Guadar" onclick="javascript:h( this );" >
                    </cfif>
                </td>
            </tr>
        </table>


        <cfif isdefined("form.lvarAyudaDetalleId") and #Len(Trim("form.lvarAyudaDetalleId"))# gt 0 >
            <input type="hidden" name="AyudaDetalleText" value='<cfoutput>#rsForm.AyudaDetalleText#</cfoutput>' >
        <cfelse>
            <input type="hidden" name="AyudaDetalleText" value='' >

        </cfif>

        <cfif isdefined("form.lvarAyudaDetalleId") and #Len(Trim("form.lvarAyudaDetalleId"))# gt 0 >
            <input type="hidden" name="AyudaDetalleId" value='<cfoutput>#rsForm.AyudaDetalleId#</cfoutput>' >
        <cfelse>
            <input type="hidden" name="AyudaDetalleId" value='' >

        </cfif>

        <div class="row">&nbsp;</div>
        <div class="row">
        <div class="col col-md-12">
            <textarea name="editor1" id="editor1" rows="40" cols="40">
            </textarea>
        </div>
        </div>

    </div>


    </form>

    <script type="text/javascript">

 //document.all.elementID.scrollIntoView(true);

    CKEDITOR.replace( 'editor1', {


        on: {
            instanceReady: function( evt ) {
            var oEditor = CKEDITOR.instances.editor1;
            var texto = $('input[name=AyudaDetalleText]').val();
            oEditor.insertHtml(texto);
            }
        }
    });

    CKEDITOR.config.height = 280;

    </script>