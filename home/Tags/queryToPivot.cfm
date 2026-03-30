<cfif isDefined("Url.descargarQueryToPivot") and isdefined("form.datos") and len(trim(form.datos))>
   <cfcontent type="application/vnd.ms-excel; charset=windows-1252">
    <cfheader name="Content-Disposition" value="attachment; filename=IndicadosRRHH-#session.usulogin#-#year(now())##month(now())##day(now())#.xls" ><!---charset="utf-8"---> 
    <cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>
    <cfoutput>#form.datos#</cfoutput>
    <cfabort>
</cfif>
<cfparam name="attributes.query" type="query">
<cfparam name="attributes.cols" type="string">
<cfparam name="attributes.etiquetas" type="string">
<cfparam name="attributes.rowIndex" type="string">
<cfparam name="attributes.colIndex" type="string">
<cfparam name="attributes.dataIndex" type="string">
<cfparam name="attributes.filterIndex" type="string" default="">
<cfparam name="attributes.clearColumns" type="string" default="">
<cfparam name="attributes.showGraficos" type="string" default="S">
<cfparam name="attributes.headerAntes"      type="string" default="N">
<cfparam name="attributes.headerDespues"    type="string" default="S">
<cfparam name="attributes.funcion"    type="string" default="sum">

 
<cfif not attributes.query.recordcount>
	No se proporcionaron datos para visualización
<cfelse>
    <link rel='StyleSheet' href='/cfmx/commons/js/pivot/pivot.css' type='text/css'>
    <cfoutput>
    
    <script type='text/javascript'> 
      var featureList = ['pivot']; 
    </script> 
    <cfset editOpciones = ''>
    <!------ activar y desactivar opciones------->
    <cfif attributes.showGraficos eq 'N'>
        <cfset editOpciones =listAppend(editOpciones, "mostrarGraficos:0")>
    </cfif>
    <cfif attributes.headerAntes eq 'S'>
        <cfset editOpciones =listAppend(editOpciones, "headingBefore:1")>
    </cfif>
    <cfif attributes.headerDespues eq 'N'>
        <cfset editOpciones =listAppend(editOpciones, "headingAfter:0")>
    </cfif>
    <cfif ucase(trim(attributes.funcion)) eq 'SUM'>
        <cfset editOpciones =listAppend(editOpciones, "agg:1")>
    <cfelseif ucase(trim(attributes.funcion)) eq 'COUNT'>
        <cfset editOpciones =listAppend(editOpciones, "agg:0")>
    <cfelseif ucase(trim(attributes.funcion)) eq 'AVG'>
        <cfset editOpciones =listAppend(editOpciones, "agg:3")>
    <cfelse>
        <cf_throw message="Las funciones válidas son: SUM,COUNT,AVG">
    </cfif>
    <script type="application/x-javascript" src='/cfmx/commons/js/pivot/translate.cfm'></script> 
    
    <script type='application/x-javascript' src='/cfmx/commons/js/pivot/loader.js'></script>      
    
    <script type='text/javascript'>
    var pTable;

        
    var cabecera = new Array(<cfloop list="#attributes.etiquetas#" index="col"><cfif listGetAt(attributes.etiquetas,1) neq col>,</cfif>'#col#'</cfloop>);
    var datos = new Array();
        <cfset i =0 >
        <cfloop query="attributes.query">
                    datos[#i#] = new Array(<cfloop list="#attributes.cols#" index="col"><cfset ActualCol = evaluate(col)><cfif len(trim(attributes.clearColumns)) and  listfindNocase( attributes.clearColumns,col)><cfset ActualCol = trim(limpiar(ActualCol))></cfif><cfif listGetAt(attributes.cols,1) neq col>,</cfif> '#ActualCol#'</cfloop>);
                <cfset i = i +1 >		
        </cfloop>
    
    function init() {
        /*function(div,chartDiv,filterDiv,headerRow,dataRows,headerRowIndexes,headerColIndexes,filterIndexes,dataColumnIndex,optObj)*/
        <cfset LvarRows=''>
        <cfset LvarCols=''>
        <cfset LvarFilterIndex=''>
     
    
        <cfloop list="#attributes.rowIndex#" index="col">
            <cfset LvarRows = listAppend(LvarRows, listFindNoCase(attributes.cols,col)-1)>
        </cfloop>
    
        <cfloop list="#attributes.colIndex#" index="col"> 
            <cfset LvarCols = listAppend(LvarCols, listFindNoCase(attributes.cols,col)-1)>
        </cfloop>
     
        <cfloop list="#attributes.filterIndex#" index="col"> 
            <cfset LvarFilterIndex = listAppend(LvarFilterIndex, listFindNoCase(attributes.cols,col)-1)>
        </cfloop>

        <cfset dataIndex = listFindNoCase(attributes.cols,attributes.dataIndex)-1>
        
        pTable = new OAT.Pivot('tabla', 'grafico', 'filtros', cabecera, datos, [#LvarRows#], [#LvarCols#], [#LvarFilterIndex#], #dataIndex#,<cfif len(trim(editOpciones))>{#editOpciones#}<cfelse>null</cfif>);
        OAT.Loader.loadFeatures("pivot",function(){try{fnDespuesPivot();}catch(e){}});
        pTable.go();
    }
    </script>
    <cf_translate key="LB_FuncionParaDatos" xmlFile="/rh/generales.xml">Función para Datos</cf_translate>
    <select id="pivot_agg">
        <option value="0" <cfif attributes.funcion eq 'COUNT'>selected</cfif>><cf_translate key="LB_Cantidad" xmlFile="/rh/generales.xml">Cantidad</cf_translate></option>
        <option value="1" <cfif attributes.funcion eq 'SUM'>selected</cfif>><cf_translate key="LB_Suma" xmlFile="/rh/generales.xml">Suma</cf_translate></option>
        <option value="2"><cf_translate key="LB_Producto" xmlFile="/rh/generales.xml">Producto</cf_translate></option>
        <option value="3" <cfif attributes.funcion eq 'AVG'>selected</cfif>><cf_translate key="LB_Promedio" xmlFile="/rh/generales.xml">Promedio</cf_translate></option>
        <option value="4" ><cf_translate key="LB_Maximo" xmlFile="/rh/generales.xml">Máximo</cf_translate></option>
        <option value="5"><cf_translate key="LB_Minimo" xmlFile="/rh/generales.xml">Mínimo</cf_translate></option>
        <option value="6"><cf_translate key="LB_Distinto" xmlFile="/rh/generales.xml">Distinto</cf_translate></option>
        <option value="7"><cf_translate key="LB_Varianza" xmlFile="/rh/generales.xml">Varianza</cf_translate></option>
        <option value="8"><cf_translate key="LB_DesviacionEstandar" xmlFile="/rh/generales.xml">Desviación Estándar</cf_translate></option>
        <option value="9"><cf_translate key="LB_Mediana" xmlFile="/rh/generales.xml">Mediana</cf_translate></option>
        <option value="10"><cf_translate key="LB_Moda" xmlFile="/rh/generales.xml">Moda</cf_translate></option>
    </select>
    <cf_translate key="LB_SubtotalesFuncionParaSubtotales" xmlFile="/rh/generales.xml">Función para Subtotales</cf_translate>
    <select id="pivot_agg_totals">
        <option value="0"><cf_translate key="LB_Cantidad" xmlFile="/rh/generales.xml">Cantidad</cf_translate></option>
        <option value="1"><cf_translate key="LB_Suma" xmlFile="/rh/generales.xml">Suma</cf_translate></option>
        <option value="2"><cf_translate key="LB_Producto" xmlFile="/rh/generales.xml">Producto</cf_translate></option>
        <option value="3"><cf_translate key="LB_Promedio" xmlFile="/rh/generales.xml">Promedio</cf_translate></option>
        <option value="4"><cf_translate key="LB_Maximo" xmlFile="/rh/generales.xml">Máximo</cf_translate></option>
        <option value="5"><cf_translate key="LB_Minimo" xmlFile="/rh/generales.xml">Mínimo</cf_translate></option>
        <option value="6"><cf_translate key="LB_Distinto" xmlFile="/rh/generales.xml">Distinto</cf_translate></option>
        <option value="7"><cf_translate key="LB_Varianza" xmlFile="/rh/generales.xml">Varianza</cf_translate></option>
        <option value="8"><cf_translate key="LB_DesviacionEstandar" xmlFile="/rh/generales.xml">Desviación Estándar</cf_translate></option>
        <option value="9"><cf_translate key="LB_Mediana" xmlFile="/rh/generales.xml">Mediana</cf_translate></option>
        <option value="10"><cf_translate key="LB_Moda" xmlFile="/rh/generales.xml">Moda</cf_translate></option>
    </select>
    <a onClick="fnImgDownloadPivot();">  <img src="/cfmx/sif/imagenes/Cfinclude.gif"     border="0" style="cursor:pointer" class="noprint" title="Download"></a>
    
    <div id='filtros'></div>
    <div id='tabla'></div>
    <div id='grafico'></div>
 
    
    </cfoutput>
</cfif>
<cffunction name="limpiar" returntype="string">
	<cfargument name="valor" type="string" required="yes">
	<cfreturn ReReplaceNoCase(arguments.valor, '<(.|\n)*?>', '', 'ALL')>
</cffunction>
<form method="post" id="formdescargar" name="formdescargar" action="/cfmx/commons/Tags/queryToPivot.cfm?descargarQueryToPivot=1"> 
    <input type="hidden" name="datos" id="datos">
</form>
<script type="text/javascript">
    function fnImgDownloadPivot(){
        document.formdescargar.datos.value=$("#tabla").html();
        document.formdescargar.submit();
    }
</script> 