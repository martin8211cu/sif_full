<cfif url.num eq 1>
	<cfif not isdefined('form.ANHCid1')>
        <cf_errorCode	code = "51648" msg = "Error en Invocación: No se envio codigo de Homologación de cuenta (ANHCid)">
    </cfif>
    <cfquery name="rslista1" datasource="#session.dsn#">
        select c.ANHid, c.ANHCid as ANHCid1, f.ANHFid as ANHFid1, f.Cmayor as Cmayor1, f.AnexoCelFmt as AnexoCelFmt1, f.AnexoSigno as AnexoSigno1, 
                case when f.AnexoSigno = 1 then '+' else '-' end as signo1,
                'S' as Mov1
            from ANhomologacionFmts f
                inner join ANhomologacionCta c
                 on c.ANHCid = f.ANHCid
            where f.ANHCid = #form.ANHCid1#
    </cfquery>	
    <cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
        <cfinvokeargument name="query" 			  value="#rslista1#"/>
        <cfinvokeargument name="desplegar"  	  value="AnexoCelFmt1"/>
        <cfinvokeargument name="etiquetas"  	  value="Formato"/>
        <cfinvokeargument name="formatos"   	  value="S"/>
        <cfinvokeargument name="align" 			  value="left,center,center"/>
        <cfinvokeargument name="ajustar"   		  value="N"/>
        <cfinvokeargument name="showEmptyListMsg" value="true"/>
        <cfinvokeargument name="keys"             value="ANHid,ANHCid1,ANHFid1"/>
        <cfinvokeargument name="showEmptyListMsg" value="true"/>
        <cfinvokeargument name="irA"              value="modificaHomologacion.cfm?ANHid=#ANHid#"/>
        <cfinvokeargument name="pageindex"        value="2"/>
        <cfinvokeargument name="formname"        value="lista1"/>
    </cfinvoke> 
<cfelse>
	<cfif not isdefined('form.ANHCid2')>
        <cf_errorCode	code = "51648" msg = "Error en Invocación: No se envio codigo de Homologación de cuenta (ANHCid)">
    </cfif>
    <cfquery name="rslista2" datasource="#session.dsn#">
        select c.ANHid, c.ANHCid as ANHCid2, f.ANHFid as ANHFid2, f.Cmayor as Cmayor2, f.AnexoCelFmt as AnexoCelFmt2, f.AnexoSigno as AnexoSigno2, 
                case when f.AnexoSigno = 1 then '+' else '-' end as signo2,
                'S' as Mov2
            from ANhomologacionFmts f
                inner join ANhomologacionCta c
                 on c.ANHCid = f.ANHCid
            where f.ANHCid = #form.ANHCid2#
    </cfquery>	
    <cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
        <cfinvokeargument name="query" 			  value="#rslista2#"/>
        <cfinvokeargument name="desplegar"  	  value="AnexoCelFmt2"/>
        <cfinvokeargument name="etiquetas"  	  value="Formato"/>
        <cfinvokeargument name="formatos"   	  value="S"/>
        <cfinvokeargument name="align" 			  value="left"/>
        <cfinvokeargument name="ajustar"   		  value="N"/>
        <cfinvokeargument name="showEmptyListMsg" value="true"/>
        <cfinvokeargument name="keys"             value="ANHid,ANHCid2,ANHFid2"/>
        <cfinvokeargument name="showEmptyListMsg" value="true"/>
        <cfinvokeargument name="irA"              value="modificaHomologacion.cfm?ANHid=#ANHid#"/>
        <cfinvokeargument name="pageindex"        value="2"/>
        <cfinvokeargument name="formname"        value="lista2"/>
    </cfinvoke> 

</cfif>
