
<cfset modo="filtro">

<cfif isdefined('form.btnImprimir') || isdefined('form.btnReimprimir')>
    <cfset modo="print">
    <!--- obtener lotes a imprimir --->
    <cfif isDefined('form.CHKALLITEMS') && form.CHKALLITEMS eq 1>
        <cfquery name="q_lotes" datasource="#session.dsn#">
            #PreserveSingleQuotes(form.q_folios)#
        </cfquery>
        <cfset lotes = ValueList(q_lotes.lote)>
        <cfset lotes = ListToArray(lotes,",",false,false)>
    <cfelse>
        <cfset lotes = ListToArray(form.chk,",",false,false)>
    </cfif>
    <!--- obtener folios a imprimir --->
    <cfquery name="q_folios" datasource ="#session.dsn#">
        select f.CRCcuentasid,f.Numero,c.Numero SNnumero from CRCControlFolio f
            inner join CRCCuentas c on f.CRCCuentasid = c.id
            inner join SNegocios n on c.SNegociosSNid = n.SNid   
        where lote in (<cfqueryparam value="#arrayToList(lotes)#" cfsqltype="cf_sql_varchar" list="yes" /> ) order by n.SNid,f.lote,f.Numero;
    </cfquery>
 
    <!--- variables para generar paginas--->
    <cfset Interation = 0>
    <cfset currentFolder = "paginas">
    <cfset Folios = []>
    <cfset NUM_DIST = []>

    <!--- rutas absolutas para archivos--->
    <cfset sqlPath_R = "#ExpandPath( GetContextRoot() )#">
    <cfif REFind('(cfmx)$',sqlPath_R) gt 0> 
        <cfset sqlPath_R = "#Replace(sqlPath_R,'cfmx','')#"> 
    <cfelse> 
        <cfset sqlPath_R = "#sqlPath_R#\">
    </cfif>
    <cfset sqlPath = "#sqlPath_R#Enviar\foliosPDF\">
    <cfset sqlPath_R = "#sqlPath##currentFolder#\">
    <cfset fileName = "folios_#currentFolder#">

    <!--- Eliminar directorio de paginas--->
	<cfif DirectoryExists("#sqlPath_R#") >
		<cfdirectory action="delete" directory="#sqlPath_R#" recurse="true">
	</cfif>

    <!--- crear paginas de 4 folios--->
    <cfloop query="#q_folios#">
        <cfif ArrayLen(Folios) eq 4>
            <cfset Interation += 1>
            <cfinclude template="../../Plantillas/Plantilla_ValesCreditoFULL.cfm">
            <cfset Folios = []>
            <cfset NUM_DIST = []>
        </cfif>
        <cfset arrayAppend(Folios, q_folios.Numero)>
        <cfset arrayAppend(NUM_DIST, "#q_folios.SNnumero#")>
    </cfloop>

    <!--- ultima pagina si no llena 4 folios --->
    <cfif ArrayLen(Folios) gt 0>
        <cfloop index="i" from="#ArrayLen(Folios)#" to="4">
            <cfset arrayAppend(Folios, '')>
            <cfset arrayAppend(NUM_DIST, '')>
        </cfloop>
        <cfset Interation += 1>
        <cfinclude template="../../Plantillas/Plantilla_ValesCreditoFULL.cfm">
    </cfif>

    <!--- Borrar imagenes de codigo de barras del directorio --->
    <cfloop index="i" from="1" to="4">
        <cfif FileExists("#sqlPath_R#BarcodeFolio#i#.jpg")> 
            <cfset FileDelete("#sqlPath_R#BarcodeFolio#i#.jpg")>
        </cfif>
    </cfloop>

    <!--- Unir todas las paginas en un solo archivo descargable --->
    <cfpdf action="merge" destination="#sqlPath##fileName#.pdf" overwrite="yes"> 
        <cfloop index="i" from="1" to="#Interation#">
            <cfpdfparam source="#sqlPath_R#p#i#.pdf"> 
        </cfloop>
    </cfpdf>

    <!--- Actualizar estado de los folios impresos a activos --->
    <cfset estado='G'>
    <cfif isdefined('form.btnReimprimir')><cfset estado='I'></cfif>
    <cfquery name="q_folios" datasource ="#session.dsn#">
        update CRCControlFolio set Estado = 'I'
        where lote in (#arrayToList(lotes)#) and Estado = '#estado#';
    </cfquery>

</cfif>

<cfif isdefined('form.btnAplicar') && form.btnAplicar eq "Activar">
    <cfset modo="aprobar">
    <cfif isDefined('form.CHKALLITEMS') && form.CHKALLITEMS eq 1>
        <cfquery name="q_lotes" datasource="#session.dsn#">
            #PreserveSingleQuotes(form.q_folios)#
        </cfquery>
        <cfset lotes = ValueList(q_lotes.lote)>
        <cfset lotes = ListToArray(lotes,",",false,false)>
    <cfelse>
        <cfset lotes = ListToArray(form.chk,",",false,false)>
    </cfif>

    <!--- obtener folios a imprimir --->
    <cfquery name="q_folios" datasource ="#session.dsn#">
        update CRCControlFolio set Estado = 'A'
        where lote in (#arrayToList(lotes)#) and Estado = 'I';
    </cfquery>
</cfif>


<cfoutput>
    <form action="ImpresionFolios.cfm" method="post" name="sql"> 
        <cfif !isdefined('form.btnLimpiar')>
            <input type="hidden" name="lote" value="#form.lote#">
            <input type="hidden" name="loteMin" value="#form.loteMin#">
            <input type="hidden" name="loteMax" value="#form.loteMax#">
            <cfif isDefined('form.CHK_print')>
                <input type="hidden" name="CHK_print" value="1">
            </cfif>
            <input type="hidden" name="SNid" value="#form.SNid#">
            <input type="hidden" name="SNnombre" value="#form.SNnombre#">
            <input type="hidden" name="Cuentaid" value="#form.Cuentaid#">
            <input type="hidden" name="SNnumero" value="#form.SNnumero#">
            <input type="hidden" name="q_Folios" value="#form.q_Folios#">
            <input type="hidden" name="modo" value="#modo#">
            <cfif modo eq "print">
                <input type="hidden" name="fileName" value="#fileName#">
                <input type="hidden" name="sqlPath" value="#sqlPath#">
                <input type="hidden" name="lotesImpresos" value="#arrayToList(lotes)#">
            </cfif>
        </cfif>
    </form>
</cfoutput>

<HTML>
    <head> <meta http-equiv="Content-Type" content="text/html; charset=utf-8"> </head>
    <body>
        <script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
    </body>
</HTML>