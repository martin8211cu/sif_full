
<!--- leer configuracion --->
<cfset objParam = CreateObject("component", "commons.Widgets.Componentes.Parametros")>

<cfset lvarRSSurl=objParam.ObtenerValor("#request.WidCodigo#","001")>
<cfset lvarHeight=objParam.ObtenerValor("#request.WidCodigo#","002")>

<cfif lvarHeight EQ "">
    <cfset lvarHeight = 250>
</cfif>

<!--- <cfset rssUrl = "http://www.elfinancierocr.com/rss/pymes/"> --->

<cffeed action="read" source="#lvarRSSurl#" query="entries" properties="info">

<div class="panel panel-default">
	<div class="panel-heading">
        <h3 class="widget-title lighter smaller">
        	<i class="ace-icon fa fa-rss orange"></i>&nbsp;<cfoutput>#info.title#</cfoutput>
        </h3>
    </div>
    <div id="LeftNavigationCollapseEG" class="panel-collapse collapse in" style="height: <cfoutput>#lvarHeight#</cfoutput>px; overflow-y: scroll;">
        <div class="panel-body">
            <ul class="list-group">
				<cfoutput query="entries">
					<a href="#rsslink#" target="_blank"><li class="list-group-item">#title#</li></a>
				</cfoutput>
            </ul>
        </div>
    </div>
</div>


<!--- <cfdump var="#info#">
<cfdump var="#entries#"> --->

