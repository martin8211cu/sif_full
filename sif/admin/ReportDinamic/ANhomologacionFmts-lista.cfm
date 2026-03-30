<cfif not isdefined('form.ANHCid')>
	<cf_errorCode	code = "51648" msg = "Error en Invocación: No se envio codigo de Homologación de cuenta (ANHCid)">
</cfif>
<cfquery name="rslista" datasource="#session.dsn#">
	select c.ANHid, c.ANHCid, f.ANHFid , f.Cmayor, f.AnexoCelFmt, f.AnexoSigno, 
			case when f.AnexoSigno = 1 then '+' else '-' end as signo,
			'S' as Mov
		from ANhomologacionFmts f
			inner join ANhomologacionCta c
			 on c.ANHCid = f.ANHCid
		where f.ANHCid = #form.ANHCid#
</cfquery>	
<cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
	<cfinvokeargument name="query" 			  value="#rslista#"/>
	<cfinvokeargument name="desplegar"  	  value="AnexoCelFmt,Mov,signo"/>
	<cfinvokeargument name="etiquetas"  	  value="Formato,Movs,Signo"/>
	<cfinvokeargument name="formatos"   	  value="S,S,S"/>
	<cfinvokeargument name="align" 			  value="left,center,center"/>
	<cfinvokeargument name="ajustar"   		  value="N"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
	<cfinvokeargument name="keys"             value="ANHid,ANHCid,ANHFid"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
	<cfinvokeargument name="irA"              value="modificaHomologacion.cfm?ANHid=#ANHid#"/>
	<cfinvokeargument name="pageindex"        value="2"/>
	<cfinvokeargument name="formname"        value="lista2"/>
</cfinvoke> 

