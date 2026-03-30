

<cfset lvarAyudaCabId="0">
<cfif isdefined('url.AyudaCabIdVar') and len(url.AyudaCabIdVar) GT 0 >
    <cfset form.lvarAyudaCabId="#url.AyudaCabIdVar#">
</cfif>

<cfquery datasource="asp" name="lista_query">                 
        select ac.AyudaCabId as codigo, ac.SScodigo as sistema, ac.SMcodigo as modulo, ac.SPcodigo as proceso, ac.AyudaCabTitulo as cabecera 
        ,'<i class=''fa fa-plus fa-lg'' style=''cursor:pointer;'' onclick=''agreagrWid(' + cast(ac.AyudaCabId as varchar) + ');''>'
        as acciones from AyudaCabecera ac  where AyudaCabId != 	<cf_jdbcquery_param value="#form.lvarAyudaCabId#" cfsqltype="cf_sql_integer">
</cfquery>

<form name="form1"  method="post" action="SQLAyuda.cfm" enctype="multipart/form-data">   
    <div class="row">
        <div class="col-md-12">&nbsp;</div>
        <div class="col-md-12">&nbsp;</div>
        <div class="col-md-12">
            <b>Cabeceras:</b>	
            <select name="listaqueryRel" class="listaqueryRel" onchange="SetInputHidden()">
                <option value="-1">--Ninguno--</option>
                <cfoutput query="lista_query">
                    <option value="#lista_query.codigo#">
                        #lista_query.cabecera#
                    </option>
                </cfoutput>
            </select>	
        </div>
        <input  type="hidden" name="RelInput" class="RelInput">
        <input  type="hidden" name="RelInputText" class="RelInputText">    
        <input name="AyudaCabId" type="hidden" value="<cfoutput>#form.lvarAyudaCabId#</cfoutput>">
        <div class="col-md-12">&nbsp;</div>
        <div class="col-md-12">
        <input type="submit" name="btnGuardarRel" class="btnGuardar" value="Guadar" onclick="javascript:h( this );" >			                        		                        		    
        </div>    
    </div>

    <script language="javascript1.2" type="text/javascript">

        function SetInputHidden(){
        var ValorRelInput = $('.listaqueryRel').val();
        var ValorRelInputText = $('.listaqueryRel option:selected').text();
        $('.RelInput').val(ValorRelInput);
        $('.RelInputText').val(ValorRelInputText);       
        }

    </script>

</form>




