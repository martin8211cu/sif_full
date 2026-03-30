<!--- 
*** Excluye el contenido entre los del contenido Generado
*** Hecho por: Marcel de Mézerville L.
--->
<CFIF ThisTag.HasEndTag>
    <CFSWITCH EXPRESSION="#ThisTag.ExecutionMode#">
    
        <CFCASE VALUE="START">
        </CFCASE>
        <CFCASE VALUE="END">
            <CFSET ThisTag.GeneratedContent = "">
        </CFCASE>
    </CFSWITCH>
<CFELSE>
    <PRE>
    Error: Este tag requiere de un TAG de cierre!!!!
    Uso:
    <FONT COLOR="MAROON">&lt;CF_sifexclude&gt;</FONT>
     HTML que desea suprimir
    <FONT COLOR="MAROON">&lt;/CF_sifexclude</FONT>
    <BR>
    Problemas? Contacte al autor:&nbsp;<A HREF="mailto:marcelm@soin.co.cr?Subject=cf_sifexclude">marcelm@soin.co.cr</A>
    </PRE> 
</CFIF>

